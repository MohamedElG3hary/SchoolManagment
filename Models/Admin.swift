import Foundation

class Admin: User {
    init(id: Int, name: String, email: String, password: String) {
        super.init(id: id, name: name, role: .admin, email: email, password: password)
    }
    
    func registerStudent(name: String, email: String, password: String) {
        DatabaseManager.shared.insertStudent(name: name, email: email, password: password)
    }
    
    func registerTeacher(name: String, email: String, password: String) {
        DatabaseManager.shared.insertTeacher(name: name, email: email, password: password)
    }
    
    func createNewCourse(name: String) {
        DatabaseManager.shared.addCourse(name: name)
    }
    
    func assignGradeToStudent(studentId: Int, courseId: Int, grade: Double) {
        DatabaseManager.shared.assignGrade(studentId: studentId, courseId: courseId, grade: grade)
    }
    
    func addNewUser(_ user: User) {
        DatabaseManager.shared.addUser(user)
    }
    
    func fetchAllUsers() -> [User] {
        DatabaseManager.shared.fetchUsers()
    }
    
    func systemReset() {
        DatabaseManager.shared.resetEntireDatabase()
    }
}
