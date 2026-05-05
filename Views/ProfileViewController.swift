import SwiftWin32
import CoreGraphics
import Foundation

class ProfileViewController: ViewController {
    var user: User?
    var headerLabel: Label!
    var nameLabel: Label!
    var idLabel: Label!
    var roleLabel: Label!
    var emailLabel: Label!
    var backButton: Button!
    
    init(user: User) {
        self.user = user
        super.init()
    }
    
    override func viewDidLoad() {
        guard let user = self.user else { return }
        super.viewDidLoad()
        self.view.backgroundColor = AppTheme.mainBackground
        self.title = "User Profile"
        
        headerLabel = Label(frame: Rect(x: 350, y: 50, width: 400, height: 40))
        headerLabel.text = "USER PROFILE"
        headerLabel.textAlignment = .center
        self.view.addSubview(headerLabel)
        
        nameLabel = Label(frame: Rect(x: 350, y: 120, width: 400, height: 30))
        nameLabel.text = "Name: \(user.name)"
        nameLabel.textAlignment = .center
        self.view.addSubview(nameLabel)
        
        idLabel = Label(frame: Rect(x: 350, y: 160, width: 400, height: 30))
        idLabel.text = "ID: \(user.id)"
        idLabel.textAlignment = .center
        self.view.addSubview(idLabel)
        
        roleLabel = Label(frame: Rect(x: 350, y: 200, width: 400, height: 30))
        roleLabel.text = "Role: \(user.role.rawValue.capitalized)"
        roleLabel.textAlignment = .center
        self.view.addSubview(roleLabel)
        
        emailLabel = Label(frame: Rect(x: 350, y: 240, width: 400, height: 30))
        emailLabel.text = "Email: \(user.email)"
        emailLabel.textAlignment = .center
        self.view.addSubview(emailLabel)
        
        backButton = Button(frame: Rect(x: 450, y: 350, width: 200, height: 40))
        backButton.setTitle("Back to Dashboard", forState: .normal)
        backButton.backgroundColor = AppTheme.primaryButton
        backButton.addTarget(self, action: ProfileViewController.backButtonTapped, for: .primaryActionTriggered)
        self.view.addSubview(backButton)
    }
    
    func backButtonTapped() {
        guard let user = self.user else { return }
        let dashboard: ViewController
        switch user.role {
        case .admin:
            let adminDashboard = AdminDashboardViewController()
            adminDashboard.currentUser = user
            dashboard = adminDashboard
        case .teacher:
            let teacherDashboard = TeacherDashboardViewController()
            teacherDashboard.currentUser = user
            teacherDashboard.currentTeacherId = user.id
            dashboard = teacherDashboard
        case .student:
            let studentDashboard = StudentDashboardViewController()
            studentDashboard.currentUser = user
            studentDashboard.currentStudentId = user.id
            dashboard = studentDashboard
        }
        
        DispatchQueue.main.async {
            if let window = Application.shared.windows.first {
                window.subviews.forEach { $0.removeFromSuperview() }
                window.rootViewController = dashboard
                window.makeKeyAndVisible()
            }
        }
    }
}