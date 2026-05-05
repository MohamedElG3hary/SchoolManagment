import SwiftWin32
import CoreGraphics
import Foundation
// AppTheme is accessible from the same module (no need for explicit import if in same target)

class BaseViewController: ViewController {
    private static var modalClosures: [Int: () -> Void] = [:]
    private static var nextModalId: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        // Apply global background color
        self.view.backgroundColor = AppTheme.mainBackground
    }

    func handleModalButton(_ sender: Button) {
        let rawTag = sender.tag
        guard rawTag != 0 else { return }
        let modalId = abs(rawTag)

        // If positive tag => confirm; negative => cancel
        if rawTag > 0 {
            if let closure = BaseViewController.modalClosures[modalId] {
                closure()
            }
        }

        // Remove overlay by modal id
        if let overlay = self.view.subviews.first(where: { $0.tag == modalId }) {
            overlay.removeFromSuperview()
        }
        BaseViewController.modalClosures[modalId] = nil
    }

    // Simple modal confirmation overlay compatible with SwiftWin32
    func showDoubleCheckAlert(title: String, message: String, onConfirm: @escaping () -> Void) {
        let id = BaseViewController.nextModalId
        BaseViewController.nextModalId += 1
        BaseViewController.modalClosures[id] = onConfirm

        // Overlay
        let overlay = View(frame: self.view.bounds)
        overlay.backgroundColor = AppTheme.overlayBackground
        overlay.tag = id

        // Panel
        let panelWidth: Int = 500
        let panelHeight: Int = 180
        let panelX = (Int(self.view.frame.width) - panelWidth) / 2
        let panelY = (Int(self.view.frame.height) - panelHeight) / 2
        let panel = View(frame: Rect(x: panelX, y: panelY, width: panelWidth, height: panelHeight))
        panel.backgroundColor = AppTheme.mainBackground
        overlay.addSubview(panel)

        let titleLabel = Label(frame: Rect(x: 10, y: 10, width: panelWidth - 20, height: 30))
        titleLabel.text = title
        titleLabel.textAlignment = .center
        panel.addSubview(titleLabel)

        let msgLabel = Label(frame: Rect(x: 10, y: 50, width: panelWidth - 20, height: 60))
        msgLabel.text = message
        msgLabel.textAlignment = .center
        panel.addSubview(msgLabel)

        let cancelBtn = Button(frame: Rect(x: 40, y: panelHeight - 60, width: 180, height: 40))
        cancelBtn.setTitle("Cancel", forState: .normal)
        cancelBtn.backgroundColor = AppTheme.secondaryButton
        cancelBtn.tag = -id // negative tag for cancel
        cancelBtn.addTarget(self, action: BaseViewController.handleModalButton, for: .primaryActionTriggered)
        panel.addSubview(cancelBtn)

        let confirmBtn = Button(frame: Rect(x: panelWidth - 220, y: panelHeight - 60, width: 180, height: 40))
        confirmBtn.setTitle("Yes, I'm sure", forState: .normal)
        confirmBtn.backgroundColor = AppTheme.primaryButton
        confirmBtn.tag = id // positive tag for confirm
        confirmBtn.addTarget(self, action: BaseViewController.handleModalButton, for: .primaryActionTriggered)
        panel.addSubview(confirmBtn)

        self.view.addSubview(overlay)
    }
}
