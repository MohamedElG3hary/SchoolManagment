import SwiftWin32
import Foundation

enum NavigationHelper {
    static func transition(to viewController: ViewController) {
        DispatchQueue.main.async {
            if let appDelegate = Application.shared.delegate as? AppDelegate, let window = appDelegate.window {
                window.subviews.forEach { $0.removeFromSuperview() }
                window.rootViewController = viewController
                window.makeKeyAndVisible()
                return
            }

            if let window = Application.shared.windows.first {
                window.subviews.forEach { $0.removeFromSuperview() }
                window.rootViewController = viewController
                window.makeKeyAndVisible()
            }
        }
    }
}