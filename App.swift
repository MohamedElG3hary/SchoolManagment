import SwiftWin32
import CoreGraphics
import Foundation

@main
final class AppDelegate: ApplicationDelegate {
    var window: Window? 
    var previousVCs: [ViewController] = []

    func application(_ application: Application, didFinishLaunchingWithOptions launchOptions: [Application.LaunchOptionsKey: Any]?) -> Bool {
        DatabaseManager.shared.setupDatabase()
        
        self.window = Window(frame: Rect(x: 50, y: 50, width: 1100, height: 700))
        // Ensure the window has a white background before attaching content
        self.window?.backgroundColor = .white

        let loginVC = LoginViewController()
        self.window?.rootViewController = loginVC
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func transition(to vc: ViewController) {
        if let window = self.window {
            let oldVC = window.rootViewController
            
            oldVC?.view.isHidden = true
            
            window.rootViewController = vc
            window.makeKeyAndVisible()
            
            if let old = oldVC {
                self.previousVCs.append(old)
            }
        }
    }
}