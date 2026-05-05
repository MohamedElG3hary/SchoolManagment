import SwiftWin32
import CoreGraphics
import Foundation

class StudentCoursesViewController: ViewController {
    var currentUser: User?
    var currentStudentId: Int = 1
    var titleLabel: Label!
    var resultsArea: Label!
    var backBtn: Button!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppTheme.lightBackground
        self.title = "My Enrolled Courses"
        
        print("[ENROLLMENT_VIEW] === viewDidLoad called ===")
        print("[ENROLLMENT_VIEW] currentStudentId: \(currentStudentId)")
        print("[ENROLLMENT_VIEW] currentUser: \(currentUser?.name ?? "nil")")
        
        titleLabel = Label(frame: Rect(x: 50, y: 30, width: 400, height: 40))
        titleLabel.text = "MY ENROLLED COURSES"
        self.view.addSubview(titleLabel)
        
        let card = View(frame: Rect(x: 50, y: 80, width: 1000, height: 450))
        card.backgroundColor = AppTheme.mainBackground
        self.view.addSubview(card)
        
        resultsArea = Label(frame: Rect(x: 20, y: 20, width: 960, height: 410))
        print("[ENROLLMENT_VIEW] About to fetch enrolled courses for student \(currentStudentId)")
        let enrolledCoursesText = DatabaseManager.shared.getStudentSchedule(studentId: currentStudentId)
        print("[ENROLLMENT_VIEW] Fetched enrolled courses: \(enrolledCoursesText)")
        resultsArea.text = enrolledCoursesText
        card.addSubview(resultsArea)
        
        backBtn = Button(frame: Rect(x: 50, y: 550, width: 280, height: 40))
        backBtn.setTitle("Back to Dashboard", forState: .normal)
        backBtn.backgroundColor = AppTheme.primaryButton
        backBtn.addTarget(self, action: StudentCoursesViewController.backTapped, for: .primaryActionTriggered)
        self.view.addSubview(backBtn)
    }
    
    func backTapped() {
        let dashboard = StudentDashboardViewController()
        dashboard.currentUser = currentUser
        dashboard.currentStudentId = currentStudentId 
        NavigationHelper.transition(to: dashboard)
    }
}
