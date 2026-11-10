import SwiftUI
import UIKit
import UserNotifications

/// Variants under test. Each one tries to put the notification's text on the clipboard.
///  A  notification action without .foreground (handled in the background)
///  B  notification action with .foreground (app opens)
///  C  plain tap on the notification (app opens)
///  D  Copy button inside the notification content extension (long-press)
///  E  Control Center control running an App Intent (iOS 18), see Controls/
enum Spike {
    static let category = "CLIP"
    static let extCategory = "CLIP_EXT"
    static let copyBackground = "COPY_BG"
    static let copyForeground = "COPY_FG"

    static func registerCategories() {
        let bg = UNNotificationAction(identifier: copyBackground, title: "Copy (A: background)", options: [])
        let fg = UNNotificationAction(identifier: copyForeground, title: "Copy (B: opens app)", options: [.foreground])
        let plain = UNNotificationCategory(identifier: category, actions: [bg, fg], intentIdentifiers: [], options: [])
        let ext = UNNotificationCategory(identifier: extCategory, actions: [], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([plain, ext])
    }

    static func schedule(category: String, delay: TimeInterval = 5) {
        let text = "clip-relay test \(Date().formatted(date: .omitted, time: .standard))"
        let content = UNMutableNotificationContent()
        content.title = "Text from your computer"
        content.body = text
        content.userInfo = ["text": text]
        content.categoryIdentifier = category
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
        Log.add("scheduled \(category) in \(Int(delay))s: \(text)")
    }

    /// Writes to the general pasteboard and reports whether the write took.
    /// changeCount and hasStrings can be read without triggering the paste prompt.
    @discardableResult
    static func copy(_ text: String, variant: String) -> Bool {
        let pb = UIPasteboard.general
        let before = pb.changeCount
        pb.string = text
        let after = pb.changeCount
        let ok = after != before
        let state: String
        switch UIApplication.shared.applicationState {
        case .active: state = "active"
        case .inactive: state = "inactive"
        case .background: state = "background"
        @unknown default: state = "unknown"
        }
        Log.add("\(variant): appState=\(state) changeCount \(before)->\(after) hasStrings=\(pb.hasStrings) => \(ok ? "WRITE OK" : "WRITE FAILED")")
        return ok
    }
}

enum Log {
    static let key = "spikeLog"
    static func add(_ line: String) {
        let stamp = Date().formatted(date: .omitted, time: .standard)
        var lines = UserDefaults.standard.stringArray(forKey: key) ?? []
        lines.insert("[\(stamp)] \(line)", at: 0)
        UserDefaults.standard.set(Array(lines.prefix(200)), forKey: key)
        NSLog("ClipSpike %@", line)
    }
    static var lines: [String] { UserDefaults.standard.stringArray(forKey: key) ?? [] }
    static func clear() { UserDefaults.standard.removeObject(forKey: key) }
}

final class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        Spike.registerCategories()
        Log.add("launched")
        return true
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .list, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let text = response.notification.request.content.userInfo["text"] as? String
            ?? response.notification.request.content.body
        let variant: String
        switch response.actionIdentifier {
        case Spike.copyBackground: variant = "A background action"
        case Spike.copyForeground: variant = "B foreground action"
        case UNNotificationDefaultActionIdentifier: variant = "C tap"
        default: variant = "other(\(response.actionIdentifier))"
        }
        DispatchQueue.main.async {
            Spike.copy(text, variant: variant)
            NotificationCenter.default.post(name: .spikeLogChanged, object: nil)
            completionHandler()
        }
    }
}

extension Notification.Name {
    static let spikeLogChanged = Notification.Name("spikeLogChanged")
}

@main
struct ClipSpikeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup { ContentView() }
    }
}

struct ContentView: View {
    @State private var lines = Log.lines
    @State private var permission = "unknown"

    var body: some View {
        NavigationStack {
            List {
                Section("1. Permission") {
                    Button("Allow notifications") {
                        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
                            DispatchQueue.main.async { permission = granted ? "granted" : "denied" }
                        }
                    }
                    Text("Status: \(permission)").foregroundStyle(.secondary)
                }
                Section("2. Send a test notification (5 s), then leave the app") {
                    Button("Notification with A/B buttons (also test C: plain tap)") { Spike.schedule(category: Spike.category) }
                    Button("Notification with content extension (D: long-press)") { Spike.schedule(category: Spike.extCategory) }
                }
                Section("3. Results") {
                    Button("Refresh") { lines = Log.lines }
                    Button("Clear log", role: .destructive) { Log.clear(); lines = [] }
                    ForEach(lines, id: \.self) { Text($0).font(.caption.monospaced()) }
                }
            }
            .navigationTitle("ClipSpike")
            .onReceive(NotificationCenter.default.publisher(for: .spikeLogChanged)) { _ in lines = Log.lines }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in lines = Log.lines }
        }
    }
}
