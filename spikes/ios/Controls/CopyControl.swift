import AppIntents
import SwiftUI
import UIKit
import WidgetKit

/// Variant E: a Control Center / Lock Screen control (iOS 18) that runs an App Intent.
/// It copies a fixed test string; a real app would fetch the latest text first.
@main
struct ClipSpikeControlsBundle: WidgetBundle {
    var body: some Widget {
        CopyControl()
    }
}

struct CopyControl: ControlWidget {
    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: "CopyTestText") {
            ControlWidgetButton(action: CopyTestTextIntent()) {
                Label("ClipSpike copy", systemImage: "doc.on.clipboard")
            }
        }
        .displayName("ClipSpike copy")
        .description("Copies a test string to the clipboard.")
    }
}

struct CopyTestTextIntent: AppIntent {
    static var title: LocalizedStringResource = "Copy test text"

    func perform() async throws -> some IntentResult {
        let result = await MainActor.run { () -> String in
            let pb = UIPasteboard.general
            let before = pb.changeCount
            pb.string = "clip-relay control test \(Date().formatted(date: .omitted, time: .standard))"
            let after = pb.changeCount
            return after != before ? "WRITE OK \(before)->\(after)" : "WRITE FAILED \(before)"
        }
        NSLog("ClipSpike E control: %@", result)
        return .result()
    }
}
