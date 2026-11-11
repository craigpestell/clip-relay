import UIKit
import UserNotifications
import UserNotificationsUI

/// Variant D: the expanded (long-press) notification shows the text and a Copy button.
/// Runs in the extension's process, not the app's, so the result shows on screen and in Console (search "ClipSpike").
final class NotificationViewController: UIViewController, UNNotificationContentExtension {
    private let textLabel = UILabel()
    private let statusLabel = UILabel()
    private let copyButton = UIButton(type: .system)
    private var text = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        textLabel.numberOfLines = 0
        statusLabel.numberOfLines = 0
        statusLabel.font = .preferredFont(forTextStyle: .footnote)
        statusLabel.textColor = .secondaryLabel
        copyButton.setTitle("Copy (D: extension)", for: .normal)
        copyButton.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        copyButton.addTarget(self, action: #selector(copyTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [textLabel, copyButton, statusLabel])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            stack.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -16),
        ])
        preferredContentSize = CGSize(width: view.bounds.width, height: 160)
    }

    func didReceive(_ notification: UNNotification) {
        text = notification.request.content.userInfo["text"] as? String ?? notification.request.content.body
        textLabel.text = text
    }

    @objc private func copyTapped() {
        let pb = UIPasteboard.general
        let before = pb.changeCount
        pb.string = text
        let after = pb.changeCount
        let ok = after != before
        statusLabel.text = ok ? "WRITE OK (changeCount \(before)→\(after)). Now paste in Notes to confirm."
                              : "WRITE FAILED (changeCount stayed \(before))"
        NSLog("ClipSpike D extension: changeCount %ld->%ld => %@", before, after, ok ? "WRITE OK" : "WRITE FAILED")
    }
}
