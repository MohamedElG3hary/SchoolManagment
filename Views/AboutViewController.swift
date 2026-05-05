import SwiftWin32
import CoreGraphics
import Foundation
class AboutViewController: ViewController {
    var titleLabel: Label!
    var infoLabel: Label!
    var goBackButton: Button!
    var logoutButton: Button!
    
    var previousDashboard: ViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Color(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.title = "User Profile"
        
        titleLabel = Label(frame: Rect(x: 50, y: 30, width: 300, height: 40))
        titleLabel.text = "About Me"
        self.view.addSubview(titleLabel)
        
        infoLabel = Label(frame: Rect(x: 50, y: 90, width: 400, height: 120))
        infoLabel.text = "Name: John Doe\nRole: Sample Role\nEmail: user@school.edu"
        self.view.addSubview(infoLabel)
        
        goBackButton = Button(frame: Rect(x: 50, y: 230, width: 150, height: 40))
        goBackButton.setTitle("Go Back", forState: .normal)
        goBackButton.addTarget(self, action: AboutViewController.goBack, for: .primaryActionTriggered)
        self.view.addSubview(goBackButton)
        
        logoutButton = Button(frame: Rect(x: 50, y: 290, width: 150, height: 40))
        logoutButton.setTitle("Logout", forState: .normal)
        logoutButton.addTarget(self, action: AboutViewController.logout, for: .primaryActionTriggered)
        self.view.addSubview(logoutButton)
    }
    
     func goBack() {
        if let previous = previousDashboard {
            DispatchQueue.main.async {
                if let window = Application.shared.windows.first {
                    window.subviews.forEach { $0.removeFromSuperview() }
                    window.rootViewController = previous
                    window.makeKeyAndVisible()
                }
            }
        }
    }
    
    func logout() {
        DispatchQueue.main.async {
            if let window = Application.shared.windows.first {
                window.subviews.forEach { $0.removeFromSuperview() }
                window.rootViewController = LoginViewController()
                window.makeKeyAndVisible()
            }
        }
    }
}
