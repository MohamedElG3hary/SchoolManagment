import Foundation

class Teacher: User {
    var assignedCourses: [Course] = []
    
    init(id: Int, name: String, email: String, password: String) {
        super.init(id: id, name: name, role: .teacher, email: email, password: password)
    }
    
    func assign(course: Course) {
        assignedCourses.append(course)
        course.teacher = self
    }
    
    func assignGrade(student: Student, course: Course, grade: Double) {
        student.grades[course.courseId] = grade
    }
}
