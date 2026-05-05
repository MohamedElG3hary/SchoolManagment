import SwiftWin32
import CoreGraphics
import Foundation

class LoginViewController: ViewController {
    var titleLabel: Label!
    var nameTextField: TextField!
    var roleTextField: TextField!
    var passwordTextField: TextField!
    var loginButton: Button!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppTheme.mainBackground
        self.title = "Login"

        // Title
        titleLabel = Label(frame: Rect(x: 300, y: 100, width: 400, height: 50))
        titleLabel.text = "School Management System"
        titleLabel.textAlignment = .center
        self.view.addSubview(titleLabel)

        // Name
        nameTextField = TextField(frame: Rect(x: 350, y: 180, width: 300, height: 40))
        nameTextField.placeholder = "Name"
        nameTextField.backgroundColor = AppTheme.inputBackground
        self.view.addSubview(nameTextField)

        // Role
        roleTextField = TextField(frame: Rect(x: 350, y: 240, width: 300, height: 40))
        roleTextField.placeholder = "Role: admin/teacher/student"
        roleTextField.backgroundColor = AppTheme.inputBackground
        self.view.addSubview(roleTextField)

        // Password
        passwordTextField = TextField(frame: Rect(x: 350, y: 300, width: 300, height: 40))
        passwordTextField.placeholder = "Password"
        passwordTextField.backgroundColor = AppTheme.inputBackground
        self.view.addSubview(passwordTextField)

        // Login button
        loginButton = Button(frame: Rect(x: 350, y: 360, width: 300, height: 45))
        loginButton.setTitle("Login", forState: .normal)
        loginButton.backgroundColor = AppTheme.primaryButton
        loginButton.addTarget(self, action: LoginViewController.loginTapped, for: .primaryActionTriggered)
        self.view.addSubview(loginButton)
    }
    
    func loginTapped() {
        let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let role = roleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = passwordTextField.text ?? ""
        
        guard !name.isEmpty, !password.isEmpty else {
            print("Please enter a name and password.")
            return
        }

        guard let authenticatedUser = DatabaseManager.shared.authenticateUser(name: name, password: password) else {
            print("Invalid name or password.")
            return
        }

        guard role.isEmpty || authenticatedUser.role.rawValue == role.lowercased() else {
            print("Selected role does not match the signed-in user.")
            return
        }

        var nextVC: ViewController?
        
        switch authenticatedUser.role {
        case .admin:
            let dashboard = AdminDashboardViewController()
            dashboard.currentUser = authenticatedUser
            nextVC = dashboard
        case .teacher:
            let dashboard = TeacherDashboardViewController()
            dashboard.currentUser = authenticatedUser
            dashboard.currentTeacherId = authenticatedUser.id
            nextVC = dashboard
        case .student:
            let dashboard = StudentDashboardViewController()
            dashboard.currentUser = authenticatedUser
            dashboard.currentStudentId = authenticatedUser.id
            nextVC = dashboard
        default:
            print("Invalid user role.")
            return
        }
        
        if let vc = nextVC {
            NavigationHelper.transition(to: vc)
        }
    }
}
