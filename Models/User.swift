import Foundation

enum UserRole: String {
    case admin = "admin"
    case teacher = "teacher"
    case student = "student"
}

class User {
    let id: Int
    let name: String
    let role: UserRole
    let email: String
    let password: String
    
    init(id: Int, name: String, role: UserRole, email: String, password: String) {
        self.id = id
        self.name = name
        self.role = role
        self.email = email
        self.password = password
    }
}
