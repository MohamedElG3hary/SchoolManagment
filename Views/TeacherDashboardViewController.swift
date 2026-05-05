import SwiftWin32
import CoreGraphics
import Foundation

class TeacherDashboardViewController: BaseViewController {
    
    // Mock user for the prototype
    var currentUser: User!
    var currentTeacherId: Int = 1
    
    // Column 1
    var availableCoursesLabel: Label!
    var availableCoursesList: Label!
    var courseIdToJoinField: TextField!
    var joinCourseBtn: Button!
    
    // Column 2
    var myCoursesLabel: Label!
    var myCoursesList: Label!
    var refreshMyCoursesBtn: Button!
    
    // Column 3
    var registeredStudentsLabel: Label!
    var targetCourseIdField: TextField!
    var viewStudentsBtn: Button!
    var studentsListArea: Label!
    
    // Bottom
    var myProfileBtn: Button!
    var logoutBtn: Button!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppTheme.lightBackground
        self.title = "Teacher Dashboard"
        
        // --- Column 1: Available Courses ---
        availableCoursesLabel = Label(frame: Rect(x: 50, y: 30, width: 280, height: 40))
        availableCoursesLabel.text = "AVAILABLE COURSES"
        self.view.addSubview(availableCoursesLabel)
        
        let availableCard = View(frame: Rect(x: 50, y: 80, width: 280, height: 250))
        availableCard.backgroundColor = AppTheme.mainBackground
        self.view.addSubview(availableCard)
        
        availableCoursesList = Label(frame: Rect(x: 10, y: 10, width: 260, height: 230))
        availableCoursesList.text = DatabaseManager.shared.getAllCoursesFormatted()
        availableCard.addSubview(availableCoursesList)
        
        courseIdToJoinField = TextField(frame: Rect(x: 50, y: 350, width: 280, height: 35))
        courseIdToJoinField.placeholder = "Enter Course ID to Teach"
        courseIdToJoinField.backgroundColor = AppTheme.inputBackground
        self.view.addSubview(courseIdToJoinField)
        
        joinCourseBtn = Button(frame: Rect(x: 50, y: 400, width: 280, height: 40))
        joinCourseBtn.setTitle("Join Course", forState: .normal)
        joinCourseBtn.backgroundColor = AppTheme.primaryButton
        joinCourseBtn.addTarget(self, action: TeacherDashboardViewController.joinCourseTapped, for: .primaryActionTriggered)
        self.view.addSubview(joinCourseBtn)
        
        // --- Column 2: My Teaching Schedule ---
        myCoursesLabel = Label(frame: Rect(x: 380, y: 30, width: 280, height: 40))
        myCoursesLabel.text = "MY TEACHING SCHEDULE"
        self.view.addSubview(myCoursesLabel)
        
        let myCoursesCard = View(frame: Rect(x: 380, y: 80, width: 280, height: 250))
        myCoursesCard.backgroundColor = AppTheme.mainBackground
        self.view.addSubview(myCoursesCard)
        
        myCoursesList = Label(frame: Rect(x: 10, y: 10, width: 260, height: 230))
        myCoursesList.text = DatabaseManager.shared.getTeacherCourses(teacherId: currentTeacherId)
        myCoursesCard.addSubview(myCoursesList)
        
        refreshMyCoursesBtn = Button(frame: Rect(x: 380, y: 350, width: 280, height: 40))
        refreshMyCoursesBtn.setTitle("Refresh My List", forState: .normal)
        refreshMyCoursesBtn.backgroundColor = AppTheme.primaryButton
        refreshMyCoursesBtn.addTarget(self, action: TeacherDashboardViewController.refreshMyCoursesTapped, for: .primaryActionTriggered)
        self.view.addSubview(refreshMyCoursesBtn)
        
        // --- Column 3: Students ---
        registeredStudentsLabel = Label(frame: Rect(x: 710, y: 30, width: 280, height: 40))
        registeredStudentsLabel.text = "REGISTERED STUDENTS"
        self.view.addSubview(registeredStudentsLabel)
        
        targetCourseIdField = TextField(frame: Rect(x: 710, y: 80, width: 280, height: 35))
        targetCourseIdField.placeholder = "Enter Course ID to view Students"
        targetCourseIdField.backgroundColor = AppTheme.inputBackground
        self.view.addSubview(targetCourseIdField)
        
        viewStudentsBtn = Button(frame: Rect(x: 710, y: 130, width: 280, height: 40))
        viewStudentsBtn.setTitle("Show Students", forState: .normal)
        viewStudentsBtn.backgroundColor = AppTheme.primaryButton
        viewStudentsBtn.addTarget(self, action: TeacherDashboardViewController.viewStudentsTapped, for: .primaryActionTriggered)
        self.view.addSubview(viewStudentsBtn)
        
        let studentsCard = View(frame: Rect(x: 710, y: 190, width: 280, height: 300))
        studentsCard.backgroundColor = AppTheme.mainBackground
        self.view.addSubview(studentsCard)
        
        studentsListArea = Label(frame: Rect(x: 10, y: 10, width: 260, height: 280))
        studentsListArea.text = "Students will appear here."
        studentsCard.addSubview(studentsListArea)
        
        // --- Bottom Section ---
        myProfileBtn = Button(frame: Rect(x: 50, y: 565, width: 280, height: 40))
        myProfileBtn.setTitle("My Profile", forState: .normal)
        myProfileBtn.backgroundColor = AppTheme.primaryButton
        myProfileBtn.addTarget(self, action: TeacherDashboardViewController.showProfile, for: .primaryActionTriggered)
        self.view.addSubview(myProfileBtn)

        logoutBtn = Button(frame: Rect(x: 50, y: 620, width: 150, height: 40))
        logoutBtn.setTitle("Logout", forState: .normal)
        logoutBtn.backgroundColor = AppTheme.secondaryButton
        logoutBtn.addTarget(self, action: TeacherDashboardViewController.logout, for: .primaryActionTriggered)
        self.view.addSubview(logoutBtn)
    }
    
    func joinCourseTapped() {
        if let idText = courseIdToJoinField.text, let courseId = Int(idText) {
            DatabaseManager.shared.joinCourse(teacherId: currentTeacherId, courseId: courseId)
            refreshMyCoursesTapped()
        }
    }
    
    func refreshMyCoursesTapped() {
        myCoursesList.text = DatabaseManager.shared.getTeacherCourses(teacherId: currentTeacherId)
    }
    
    func viewStudentsTapped() {
        print("[TeacherDashboard] Show Students tapped")
        if let idText = targetCourseIdField.text, let courseId = Int(idText) {
            print("[TeacherDashboard] Loading students for courseId=\(courseId)")
            studentsListArea.text = "Loading students..."
            let studentsText = DatabaseManager.shared.getStudentsInCourse(courseId: courseId)
            studentsListArea.text = studentsText
        }
        else {
            studentsListArea.text = "Please enter a valid course ID."
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
