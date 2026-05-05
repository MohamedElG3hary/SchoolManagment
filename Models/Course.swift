import Foundation

class Course {
    var courseId: String
    var title: String
    weak var teacher: Teacher?
    
    init(courseId: String, title: String) {
        self.courseId = courseId
        self.title = title
    }
}
