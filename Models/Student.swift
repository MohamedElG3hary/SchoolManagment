import Foundation

class Student: User {
    var registeredCourses: [Course] = []
    var grades: [String: Double] = [:] 
    
    init(id: Int, name: String, email: String, password: String) {
        super.init(id: id, name: name, role: .student, email: email, password: password)
    }
    
    func register(course: Course) {
        registeredCourses.append(course)
    }
}
