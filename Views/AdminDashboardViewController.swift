import SwiftWin32
import CoreGraphics
import Foundation

class AdminDashboardViewController: BaseViewController {
    var currentUser: User!
    var titleLabel: Label!
    var myProfileBtn: Button!
    var logoutButton: Button!
    var refreshBtn: Button!
    var statusLabel: Label!
    var nameTextField: TextField!
    var roleTextField: TextField!
    var emailTextField: TextField!
    var passwordTextField: TextField!
    var addUserBtn: Button!
    var coursesTitle: Label!
    var courseNameField: TextField!
    var saveCourseBtn: Button!
    var targetStudentIdField: TextField!
    var targetCourseIdField: TextField!
    var gradeValueField: TextField!
    var submitGradeBtn: Button!
    var refreshCoursesBtn: Button!
    var coursesListView: Label!
    var usersListLabel: Label!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppTheme.mainBackground
        
        myProfileBtn = Button(frame: Rect(x: 60, y: 30, width: 220, height: 44))
        myProfileBtn.setTitle("MY PROFILE", forState: Control.State.normal)
        myProfileBtn.backgroundColor = AppTheme.primaryButton
        myProfileBtn.addTarget(self, action: AdminDashboardViewController.showProfile, for: Control.Event.primaryActionTriggered)
        self.view.addSubview(myProfileBtn)

        refreshBtn = Button(frame: Rect(x: 60, y: 90, width: 220, height: 44))
        refreshBtn.setTitle("REFRESH USERS", forState: Control.State.normal)
        refreshBtn.backgroundColor = AppTheme.primaryButton
        refreshBtn.addTarget(self, action: AdminDashboardViewController.refreshTapped, for: Control.Event.primaryActionTriggered)
        self.view.addSubview(refreshBtn)

        refreshCoursesBtn = Button(frame: Rect(x: 60, y: 150, width: 220, height: 44))
        refreshCoursesBtn.setTitle("REFRESH COURSES", forState: Control.State.normal)
        refreshCoursesBtn.backgroundColor = AppTheme.primaryButton
        refreshCoursesBtn.addTarget(self, action: AdminDashboardViewController.refreshCoursesTapped, for: Control.Event.primaryActionTriggered)
        self.view.addSubview(refreshCoursesBtn)

        let usersCard = View(frame: Rect(x: 40, y: 220, width: 260, height: 260))
        usersCard.backgroundColor = Color.white 
        self.view.addSubview(usersCard)

        usersListLabel = Label(frame: Rect(x: 10, y: 10, width: 240, height: 240))
        usersListLabel.text = "No users found."
        usersCard.addSubview(usersListLabel)

        logoutButton = Button(frame: Rect(x: 60, y: 500, width: 220, height: 44))
        logoutButton.setTitle("LOGOUT", forState: Control.State.normal)
        logoutButton.backgroundColor = AppTheme.secondaryButton
        logoutButton.addTarget(self, action: AdminDashboardViewController.logout, for: Control.Event.primaryActionTriggered)
        self.view.addSubview(logoutButton)
        
        // --- Column 2: User Management ---
        let userHeader = Label(frame: Rect(x: 380, y: 30, width: 300, height: 40))
        userHeader.text = "REGISTER NEW USER"
        self.view.addSubview(userHeader)
        
        nameTextField = createStyledTextField(frame: Rect(x: 380, y: 80, width: 300, height: 40), placeholder: "Full Name")
        self.view.addSubview(nameTextField)
        
        roleTextField = createStyledTextField(frame: Rect(x: 380, y: 135, width: 300, height: 40), placeholder: "Role (student/teacher/admin)")
        self.view.addSubview(roleTextField)
        
        emailTextField = createStyledTextField(frame: Rect(x: 380, y: 190, width: 300, height: 40), placeholder: "Email Address")
        self.view.addSubview(emailTextField)
        
        passwordTextField = createStyledTextField(frame: Rect(x: 380, y: 245, width: 300, height: 40), placeholder: "Password")
        self.view.addSubview(passwordTextField)
        
        addUserBtn = Button(frame: Rect(x: 380, y: 305, width: 300, height: 45))
        addUserBtn.setTitle("ADD USER", forState: Control.State.normal)
        addUserBtn.backgroundColor = AppTheme.primaryButton
        addUserBtn.addTarget(self, action: AdminDashboardViewController.addUserTapped, for: Control.Event.primaryActionTriggered)
        self.view.addSubview(addUserBtn)
        
        // --- Column 3: Course & Grading ---
        coursesTitle = Label(frame: Rect(x: 720, y: 30, width: 300, height: 40))
        coursesTitle.text = "COURSE & GRADING"
        self.view.addSubview(coursesTitle)
        
        courseNameField = createStyledTextField(frame: Rect(x: 720, y: 80, width: 300, height: 40), placeholder: "New Course Name")
        self.view.addSubview(courseNameField)
        
        saveCourseBtn = Button(frame: Rect(x: 720, y: 135, width: 300, height: 45))
        saveCourseBtn.setTitle("CREATE COURSE", forState: Control.State.normal)
        saveCourseBtn.backgroundColor = AppTheme.primaryButton
        saveCourseBtn.addTarget(self, action: AdminDashboardViewController.saveCourseTapped, for: Control.Event.primaryActionTriggered)
        self.view.addSubview(saveCourseBtn)
        
        targetStudentIdField = createStyledTextField(frame: Rect(x: 720, y: 220, width: 300, height: 40), placeholder: "Target Student ID")
        self.view.addSubview(targetStudentIdField)
        
        targetCourseIdField = createStyledTextField(frame: Rect(x: 720, y: 275, width: 300, height: 40), placeholder: "Target Course ID")
        self.view.addSubview(targetCourseIdField)
        
        gradeValueField = createStyledTextField(frame: Rect(x: 720, y: 330, width: 300, height: 40), placeholder: "Grade Value")
        self.view.addSubview(gradeValueField)
        
        submitGradeBtn = Button(frame: Rect(x: 720, y: 390, width: 300, height: 45))
        submitGradeBtn.setTitle("ASSIGN GRADE", forState: Control.State.normal)
        submitGradeBtn.backgroundColor = AppTheme.primaryButton
        submitGradeBtn.addTarget(self, action: AdminDashboardViewController.submitGradeTapped, for: Control.Event.primaryActionTriggered)
        self.view.addSubview(submitGradeBtn)
        
        statusLabel = Label(frame: Rect(x: 200, y: 620, width: 820, height: 45))
        statusLabel.text = " Ready."
        statusLabel.backgroundColor = AppTheme.lightBackground
        self.view.addSubview(statusLabel)

        // Courses list card
        let coursesCard = View(frame: Rect(x: 720, y: 460, width: 300, height: 140))
        coursesCard.backgroundColor = AppTheme.cardBackground
        self.view.addSubview(coursesCard)

        coursesListView = Label(frame: Rect(x: 10, y: 10, width: 280, height: 120))
        coursesListView.text = "No courses found."
        coursesCard.addSubview(coursesListView)
    }

    private func createStyledTextField(frame: Rect, placeholder: String) -> TextField {
        let tf = TextField(frame: frame)
        tf.placeholder = placeholder
        tf.backgroundColor = AppTheme.inputBackground
        return tf
    }

    func saveCourseTapped() {
        let courseName = courseNameField.text ?? ""
        (currentUser as? Admin)?.createNewCourse(name: courseName)
    }

    func submitGradeTapped() {
        print("Submit grade clicked")
    }

    func addUserTapped() {
        print("Creating user...")
        let name = nameTextField.text ?? ""
        let role = (roleTextField.text ?? "").lowercased()
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""

        guard email.count > 0, password.count > 0, role.count > 0 else {
            statusLabel.text = "Missing required fields."
            return
        }

        if role == "student" || role == "teacher" || role == "admin" {
            if let created = DatabaseManager.shared.createUserAccount(role: role, name: name, email: email, password: password) {
                statusLabel.text = "User created: \(created.email)"
                print("User linked to \(role) successfully")
                // Refresh users list so UI immediately reflects DB
                refreshTapped()
            } else {
                statusLabel.text = "User already exists or creation failed."
            }
        } else {
            statusLabel.text = "Role must be student/teacher/admin."
        }
    }

    func refreshTapped() {
        print("Refreshing users...")
        let users = DatabaseManager.shared.fetchUsers()
        print("Users fetched: \(users.count) items")

        if users.isEmpty {
            usersListLabel.text = "No users found."
        } else {
            var text = ""
            for u in users {
                let role = (u is Student) ? "Student" : ((u is Teacher) ? "Teacher" : "User")
                text += "[ID: \(u.id)] \(u.name) - \(role) - \(u.email)\n"
            }
            usersListLabel.text = text
        }
    }

    func refreshCoursesTapped() {
        print("Refreshing courses...")
        let courses = DatabaseManager.shared.fetchAllCourses()
        print("Courses fetched: \(courses.count) items")

        if courses.isEmpty {
            coursesListView.text = "No courses found."
        } else {
            var text = ""
            for c in courses {
                text += "[ID: \(c.id)] \(c.name)\n"
            }
            coursesListView.text = text
        }
    }

    func showProfile() {
        let profileVC = ProfileViewController(user: currentUser)
        NavigationHelper.transition(to: profileVC)
    }

    func logout() {
        NavigationHelper.transition(to: LoginViewController())
    }
}