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
        
        // --- Column 1: Navigation ---
        titleLabel = Label(frame: Rect(x: 40, y: 30, width: 280, height: 40))
        titleLabel.text = "NAVIGATION"
        self.view.addSubview(titleLabel)
        
        myProfileBtn = Button(frame: Rect(x: 40, y: 90, width: 280, height: 45))
        myProfileBtn.setTitle("MY PROFILE", forState: Control.State.normal)
        myProfileBtn.backgroundColor = AppTheme.primaryButton
        myProfileBtn.addTarget(self, action: AdminDashboardViewController.showProfile, for: Control.Event.primaryActionTriggered)
        self.view.addSubview(myProfileBtn)
        
        refreshBtn = Button(frame: Rect(x: 40, y: 145, width: 280, height: 45))
        refreshBtn.setTitle("REFRESH USERS", forState: Control.State.normal)
        refreshBtn.backgroundColor = AppTheme.primaryButton
        refreshBtn.addTarget(self, action: AdminDashboardViewController.refreshTapped, for: Control.Event.primaryActionTriggered)
        self.view.addSubview(refreshBtn)
        
        refreshCoursesBtn = Button(frame: Rect(x: 40, y: 200, width: 280, height: 45))
        refreshCoursesBtn.setTitle("REFRESH COURSES", forState: Control.State.normal)
        refreshCoursesBtn.backgroundColor = AppTheme.primaryButton
        refreshCoursesBtn.addTarget(self, action: AdminDashboardViewController.refreshCoursesTapped, for: Control.Event.primaryActionTriggered)
        self.view.addSubview(refreshCoursesBtn)
        
        let usersCard = View(frame: Rect(x: 40, y: 270, width: 300, height: 320))
        usersCard.backgroundColor = AppTheme.cardBackground
        self.view.addSubview(usersCard)
        
        usersListLabel = Label(frame: Rect(x: 10, y: 10, width: 280, height: 300))
        usersListLabel.text = "No users found."
        usersCard.addSubview(usersListLabel)
        
        logoutButton = Button(frame: Rect(x: 40, y: 620, width: 140, height: 45))
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
        print("Add user clicked")
    }

    func refreshTapped() {
        print("Refresh users clicked")
    }

    func refreshCoursesTapped() {
        print("Refresh courses clicked")
    }

    func showProfile() {
        let profileVC = ProfileViewController(user: currentUser)
        NavigationHelper.transition(to: profileVC)
    }

    func logout() {
        NavigationHelper.transition(to: LoginViewController())
    }
}