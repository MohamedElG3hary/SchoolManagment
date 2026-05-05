import SwiftWin32
import CoreGraphics
import Foundation

class StudentDashboardViewController: BaseViewController {
    
    var currentUser: User!
    var currentStudentId: Int = 1
    
    // Available courses from database
    var availableCourses: [(id: Int, name: String)] = []
    
    // Column 1: Profile
    var aboutMeLabel: Label!
    var nameLabel: Label!
    var roleLabel: Label!
    var emailLabel: Label!
    
    // Column 2: Registration
    var enrollCoursesLabel: Label!
    var courseListLabel: Label!
    var courseIdTextField: TextField!
    var registerBtn: Button!
    
    // Column 3: Actions
    var quickActionsLabel: Label!
    var viewMyScheduleBtn: Button!
    var viewResultsBtn: Button!
    
    // Bottom
    var myProfileBtn: Button!
    var logoutBtn: Button!
    var statusLabel: Label!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let student = currentUser as? Student {
        currentStudentId = student.id
        print("[INIT] Using real student ID: \(currentStudentId)")
        } else {
            print("[INIT] ERROR: currentUser is not a Student")
        }
        
        self.title = "Student Dashboard"
        
        nameLabel = Label(frame: Rect(x: 50, y: 80, width: 250, height: 30))
        roleLabel = Label(frame: Rect(x: 50, y: 110, width: 250, height: 30))
        emailLabel = Label(frame: Rect(x: 50, y: 140, width: 250, height: 30))

            if let user = self.currentUser {
                nameLabel.text = "Name: \(user.name)"
                roleLabel.text = "Role: \(user.role)"
                emailLabel.text = "Email: \(user.email)"
            } else {
                nameLabel.text = "Name: Unknown"
                roleLabel.text = "Role: Unknown"
                emailLabel.text = "Email: Unknown"
            }

            self.view.addSubview(nameLabel)
            self.view.addSubview(roleLabel)
            self.view.addSubview(emailLabel)
        
        // --- Column 2: Registration (x: 400) ---
        enrollCoursesLabel = Label(frame: Rect(x: 400, y: 30, width: 280, height: 40))
        enrollCoursesLabel.text = "ENROLL IN COURSES"
        self.view.addSubview(enrollCoursesLabel)
        
        courseListLabel = Label(frame: Rect(x: 400, y: 75, width: 280, height: 240))
        courseListLabel.text = "Loading courses..."
        self.view.addSubview(courseListLabel)

        loadAvailableCourses()

        courseIdTextField = TextField(frame: Rect(x: 400, y: 325, width: 280, height: 35))
        courseIdTextField.placeholder = "Enter Course ID"
        courseIdTextField.backgroundColor = AppTheme.inputBackground
        self.view.addSubview(courseIdTextField)

        registerBtn = Button(frame: Rect(x: 400, y: 375, width: 280, height: 40))
        registerBtn.setTitle("Register", forState: .normal)
        registerBtn.backgroundColor = AppTheme.primaryButton
        registerBtn.addTarget(self, action: StudentDashboardViewController.registerButtonClicked, for: .primaryActionTriggered)
        self.view.addSubview(registerBtn)
        
        // --- Column 3: Actions (x: 750) ---
        quickActionsLabel = Label(frame: Rect(x: 750, y: 30, width: 280, height: 40))
        quickActionsLabel.text = "QUICK ACTIONS"
        self.view.addSubview(quickActionsLabel)
        
        viewMyScheduleBtn = Button(frame: Rect(x: 750, y: 80, width: 280, height: 40))
        viewMyScheduleBtn.setTitle("View My Enrolled Courses", forState: .normal)
        viewMyScheduleBtn.backgroundColor = AppTheme.primaryButton
        viewMyScheduleBtn.addTarget(self, action: StudentDashboardViewController.viewScheduleTapped, for: .primaryActionTriggered)
        self.view.addSubview(viewMyScheduleBtn)
        
        viewResultsBtn = Button(frame: Rect(x: 750, y: 135, width: 280, height: 40))
        viewResultsBtn.setTitle("View My Grades", forState: .normal)
        viewResultsBtn.backgroundColor = AppTheme.primaryButton
        viewResultsBtn.addTarget(self, action: StudentDashboardViewController.viewGradesTapped, for: .primaryActionTriggered)
        self.view.addSubview(viewResultsBtn)
        
        // --- Footer Section ---
        myProfileBtn = Button(frame: Rect(x: 50, y: 565, width: 280, height: 40))
        myProfileBtn.setTitle("My Profile", forState: .normal)
        myProfileBtn.backgroundColor = AppTheme.primaryButton
        myProfileBtn.addTarget(self, action: StudentDashboardViewController.showProfile, for: .primaryActionTriggered)
        self.view.addSubview(myProfileBtn)

        logoutBtn = Button(frame: Rect(x: 50, y: 620, width: 150, height: 40))
        logoutBtn.setTitle("Logout", forState: .normal)
        logoutBtn.backgroundColor = AppTheme.secondaryButton
        logoutBtn.addTarget(self, action: StudentDashboardViewController.logout, for: .primaryActionTriggered)
        self.view.addSubview(logoutBtn)
        
        statusLabel = Label(frame: Rect(x: 250, y: 620, width: 800, height: 40))
        statusLabel.text = " Ready."
        statusLabel.backgroundColor = AppTheme.mainBackground
        self.view.addSubview(statusLabel)
    }

    func loadAvailableCourses() {
        availableCourses = DatabaseManager.shared.fetchAllCourses()
        courseListLabel.text = formattedCourseList()
    }
    
    func registerButtonClicked(_ sender: Button) {
        print("Register button clicked")
        statusLabel.text = " Register button clicked"

        do {
            try handleRegistration()
        } catch {
            statusLabel.text = " Registration failed: \(error.localizedDescription)"
            print("Registration handler threw an error: \(error)")
        }
    }

    private func handleRegistration() throws {
    loadAvailableCourses()

    let courseIdText = courseIdTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    print("[REGISTER] Entered Course ID: \(courseIdText)")
    print("[REGISTER] Current student ID: \(currentStudentId)")

    // Validation
    guard !courseIdText.isEmpty else {
        statusLabel.text = " Please enter a Course ID"
        return
    }

    guard let courseId = Int(courseIdText) else {
        statusLabel.text = " Invalid Course ID"
        return
    }

    guard let selectedCourse = availableCourses.first(where: { $0.id == courseId }) else {
        statusLabel.text = " Course not found"
        return
    }

    print("[REGISTER] Course found: \(selectedCourse.name)")

    let didEnroll = DatabaseManager.shared.enrollStudentInCourse(
        studentId: currentStudentId,
        courseId: selectedCourse.id
    )

    print("[REGISTER] enroll result: \(didEnroll)")

    if didEnroll {
        statusLabel.text = " Successfully registered for \(selectedCourse.name)"

        let updated = DatabaseManager.shared.getStudentSchedule(studentId: currentStudentId)
        print("[REGISTER] Updated Schedule:\n\(updated)")
    } else {
        statusLabel.text = " Already registered or failed"
    }
}

    func formattedCourseList() -> String {
        if availableCourses.isEmpty {
            return "No courses available."
        }

        var result = "Available Courses:\n"
        for course in availableCourses {
            result += "ID: \(course.id)  Name: \(course.name)\n"
        }
        return result
    }
    
    func viewScheduleTapped() {
        guard let currentUser = currentUser else {
            statusLabel.text = " Unable to open enrolled courses."
            return
        }

        let scheduleVC = StudentCoursesViewController()
        scheduleVC.currentUser = currentUser
        scheduleVC.currentStudentId = currentStudentId
        NavigationHelper.transition(to: scheduleVC)
    }
    
    func viewGradesTapped() {
        statusLabel.text = "\n" + DatabaseManager.shared.fetchGradesForStudent(studentId: currentStudentId)
    }

    func showProfile() {
        guard let currentUser = currentUser else {
            statusLabel.text = " Unable to open profile."
            return
        }

        let profileVC = ProfileViewController(user: currentUser)
        NavigationHelper.transition(to: profileVC)
    }
    
    func logout() {
        NavigationHelper.transition(to: LoginViewController())
    }
}
