import Foundation
import CSQLite

class DatabaseManager {
    static let shared = DatabaseManager()
    
    private var db: OpaquePointer?
    private let dbPath = "SchoolDB.sqlite"
    
    private init() {}
    
    func setupDatabase() {
        if sqlite3_open(dbPath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(dbPath)")
            createTables()
            seedDefaultAdmin()
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db)!)
            print("Unable to open database. Error: \(errorMessage)")
        }
    }
    
    func createTables() {
        let tables = [
            ("Admins", "CREATE TABLE IF NOT EXISTS Admins (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT, password TEXT);"),
            ("Students", "CREATE TABLE IF NOT EXISTS Students (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT, password TEXT);"),
            ("Teachers", "CREATE TABLE IF NOT EXISTS Teachers (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT, password TEXT);"),
            ("Courses", "CREATE TABLE IF NOT EXISTS Courses (id INTEGER PRIMARY KEY AUTOINCREMENT, courseName TEXT);"),
            ("Grades", "CREATE TABLE IF NOT EXISTS Grades (studentId INTEGER, courseId INTEGER, grade REAL, PRIMARY KEY (studentId, courseId), FOREIGN KEY(studentId) REFERENCES Students(id), FOREIGN KEY(courseId) REFERENCES Courses(id));"),
            ("TeacherCourses", "CREATE TABLE IF NOT EXISTS TeacherCourses (teacherId INTEGER, courseId INTEGER, PRIMARY KEY(teacherId, courseId), FOREIGN KEY(teacherId) REFERENCES Teachers(id), FOREIGN KEY(courseId) REFERENCES Courses(id));"),
            ("Enrollments", "CREATE TABLE IF NOT EXISTS Enrollments (studentId INTEGER, courseId INTEGER, PRIMARY KEY(studentId, courseId), FOREIGN KEY(studentId) REFERENCES Students(id), FOREIGN KEY(courseId) REFERENCES Courses(id));")
        ]
        
        for (tableName, query) in tables {
            var errorMessage: UnsafeMutablePointer<Int8>? = nil
            query.withCString { queryCString in
                if sqlite3_exec(db, queryCString, nil, nil, &errorMessage) == SQLITE_OK {
                    print("Successfully created \(tableName) table.")
                } else {
                    if let errorMsg = errorMessage {
                        let errorString = String(cString: errorMsg)
                        print("Failed to create \(tableName) table. Error: \(errorString)")
                        sqlite3_free(errorMessage)
                    } else {
                        let dbError = String(cString: sqlite3_errmsg(db)!)
                        print("Failed to create \(tableName) table. DB Error: \(dbError)")
                    }
                }
            }
        }
    }

    func seedDefaultAdmin() {
        let checkQuery = "SELECT COUNT(*) FROM Admins;"
        var statement: OpaquePointer? = nil
        var adminCount = 0

        if sqlite3_prepare_v2(db, checkQuery, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_ROW {
                adminCount = Int(sqlite3_column_int(statement, 0))
            }
            sqlite3_finalize(statement)
        } else {
            let errorMsg = String(cString: sqlite3_errmsg(db)!)
            print("Failed to query Admins table. Error: \(errorMsg)")
            return
        }

        if adminCount == 0 {
            let adminQuery = "INSERT INTO Admins (name, email, password) VALUES ('Admin', 'admin@school.edu', 'admin123');"
            var errorMessage: UnsafeMutablePointer<Int8>? = nil

            adminQuery.withCString { queryCString in
                if sqlite3_exec(db, queryCString, nil, nil, &errorMessage) == SQLITE_OK {
                    print("Inserted default admin account into Admins table.")
                } else if let errorMsg = errorMessage {
                    let errorString = String(cString: errorMsg)
                    print("Failed to seed default admin. Error: \(errorString)")
                    sqlite3_free(errorMessage)
                } else {
                    let dbError = String(cString: sqlite3_errmsg(db)!)
                    print("Failed to seed default admin. DB Error: \(dbError)")
                }
            }
        }
    }
    func insertStudent(name: String, email: String, password: String) {
        let query = "INSERT INTO Students (name, email, password) VALUES ('\(name)', '\(email)', '\(password)');"
        var errorMessage: UnsafeMutablePointer<Int8>? = nil
        
        query.withCString { queryCString in
            if sqlite3_exec(db, queryCString, nil, nil, &errorMessage) == SQLITE_OK {
                print("Successfully added student: \(name)")
            } else {
                if let errorMsg = errorMessage {
                    let errorString = String(cString: errorMsg)
                    print("Failed to add student. Error: \(errorString)")
                    sqlite3_free(errorMessage)
                }
            }
        }
    }
    
    func insertTeacher(name: String, email: String, password: String) {
        let query = "INSERT INTO Teachers (name, email, password) VALUES ('\(name)', '\(email)', '\(password)');"
        var errorMessage: UnsafeMutablePointer<Int8>? = nil
        
        query.withCString { queryCString in
            if sqlite3_exec(db, queryCString, nil, nil, &errorMessage) == SQLITE_OK {
                print("Successfully added teacher: \(name)")
            } else {
                if let errorMsg = errorMessage {
                    let errorString = String(cString: errorMsg)
                    print("Failed to add teacher. Error: \(errorString)")
                    sqlite3_free(errorMessage)
                }
            }
        }
    }
    
    func addUser(_ user: User) {
        if let student = user as? Student {
            insertStudent(name: student.name, email: student.email, password: student.password)
        } else if let teacher = user as? Teacher {
            insertTeacher(name: teacher.name, email: teacher.email, password: teacher.password)
        }
    }
    
    func addCourse(name: String) {
        let query = "INSERT INTO Courses (courseName) VALUES ('\(name)');"
        var errorMessage: UnsafeMutablePointer<Int8>? = nil
        
        query.withCString { queryCString in
            if sqlite3_exec(db, queryCString, nil, nil, &errorMessage) == SQLITE_OK {
                print("Successfully added course: \(name)")
            } else {
                if let errorMsg = errorMessage {
                    let errorString = String(cString: errorMsg)
                    print("Failed to add course. Error: \(errorString)")
                    sqlite3_free(errorMessage)
                }
            }
        }
    }
    
    func assignGrade(studentId: Int, courseId: Int, grade: Double) {
        let query = """
        INSERT OR REPLACE INTO Grades (studentId, courseId, grade)
        VALUES (\(studentId), \(courseId), \(grade));
        """
        var errorMessage: UnsafeMutablePointer<Int8>? = nil
        
        query.withCString { queryCString in
            if sqlite3_exec(db, queryCString, nil, nil, &errorMessage) == SQLITE_OK {
                print("Successfully assigned grade.")
            } else {
                if let errorMsg = errorMessage {
                    let errorString = String(cString: errorMsg)
                    print("Failed to assign grade. Error: \(errorString)")
                    sqlite3_free(errorMessage)
                }
            }
        }
    }
    
    func fetchGradesForStudent(studentId: Int) -> String {
        var result = "Grades for Student ID \(studentId):\n"
        let query = """
        SELECT c.courseName, g.grade
        FROM Grades g
        JOIN Courses c ON g.courseId = c.id
        WHERE g.studentId = \(studentId);
        """
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            var found = false
            while sqlite3_step(statement) == SQLITE_ROW {
                found = true
                let courseNamePointer = sqlite3_column_text(statement, 0)
                let courseName = courseNamePointer != nil ? String(cString: courseNamePointer!) : ""
                let grade = sqlite3_column_double(statement, 1)
                result += "- \(courseName): \(grade)\n"
            }
            if !found {
                result += "No grades found."
            }
        } else {
            result = "Error fetching grades."
        }
        sqlite3_finalize(statement)
        return result
    }
    
    func joinCourse(teacherId: Int, courseId: Int) {
        let query = "INSERT OR IGNORE INTO TeacherCourses (teacherId, courseId) VALUES (\(teacherId), \(courseId));"
        var errorMessage: UnsafeMutablePointer<Int8>? = nil
        
        query.withCString { queryCString in
            if sqlite3_exec(db, queryCString, nil, nil, &errorMessage) == SQLITE_OK {
                print("Successfully joined course.")
            } else {
                if let errorMsg = errorMessage {
                    let errorString = String(cString: errorMsg)
                    print("Failed to join course. Error: \(errorString)")
                    sqlite3_free(errorMessage)
                }
            }
        }
    }
    
    func getTeacherCourses(teacherId: Int) -> String {
        var result = ""
        let query = """
        SELECT c.id, c.courseName
        FROM Courses c
        JOIN TeacherCourses tc ON c.id = tc.courseId
        WHERE tc.teacherId = \(teacherId);
        """
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            var found = false
            while sqlite3_step(statement) == SQLITE_ROW {
                found = true
                let id = Int(sqlite3_column_int(statement, 0))
                let namePointer = sqlite3_column_text(statement, 1)
                let name = namePointer != nil ? String(cString: namePointer!) : ""
                result += "[ID: \(id)] \(name)\n"
            }
            if !found {
                result = "No courses joined."
            }
        } else {
            result = "Error fetching courses."
        }
        sqlite3_finalize(statement)
        return result
    }
    
    func getStudentsInCourse(courseId: Int) -> String {
        var result = ""
        let query = """
        SELECT s.id, s.name, g.grade
        FROM Students s
        JOIN Grades g ON s.id = g.studentId
        WHERE g.courseId = \(courseId);
        """
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            var found = false
            while sqlite3_step(statement) == SQLITE_ROW {
                found = true
                let id = Int(sqlite3_column_int(statement, 0))
                let namePointer = sqlite3_column_text(statement, 1)
                let name = namePointer != nil ? String(cString: namePointer!) : ""
                let grade = sqlite3_column_double(statement, 2)
                result += "[ID: \(id)] \(name) - Grade: \(grade)\n"
            }
            if !found {
                result = "No students found."
            }
        } else {
            result = "Error fetching students."
        }
        sqlite3_finalize(statement)
        return result
    }
    
    func enrollStudentInCourse(studentId: Int, courseId: Int) -> Bool {
        let query = "INSERT OR IGNORE INTO Enrollments (studentId, courseId) VALUES (\(studentId), \(courseId));"
        var errorMessage: UnsafeMutablePointer<Int8>? = nil
        var didSucceed = false
        
        query.withCString { queryCString in
            let result = sqlite3_exec(db, queryCString, nil, nil, &errorMessage)
            if result == SQLITE_OK {
                let changes = sqlite3_changes(db)
                if changes > 0 {
                    didSucceed = true
                    print("Student registered successfully: studentId=\(studentId), courseId=\(courseId), changes=\(changes)")
                } else {
                    print("Registration completed without inserting a row: studentId=\(studentId), courseId=\(courseId)")
                }
            } else {
                if let errorMsg = errorMessage {
                    let errorString = String(cString: errorMsg)
                    print("Failed to enroll student \(studentId) in course \(courseId). Error: \(errorString)")
                    sqlite3_free(errorMessage)
                } else {
                    print("Failed to enroll student \(studentId) in course \(courseId). Unknown database error.")
                }
            }
        }

        return didSucceed
    }

    func enrollInCourse(studentId: Int, courseId: Int) {
        _ = enrollStudentInCourse(studentId: studentId, courseId: courseId)
    }
    
    func getStudentSchedule(studentId: Int) -> String {
        var result = ""
        let query = """
        SELECT c.id, c.courseName, t.name 
        FROM Enrollments e 
        JOIN Courses c ON e.courseId = c.id 
        LEFT JOIN TeacherCourses tc ON c.id = tc.courseId 
        LEFT JOIN Teachers t ON tc.teacherId = t.id 
        WHERE e.studentId = \(studentId);
        """
        var statement: OpaquePointer? = nil
        
        print("[DB_QUERY] getStudentSchedule called with studentId=\(studentId)")
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            var found = false
            var courseCount = 0
            while sqlite3_step(statement) == SQLITE_ROW {
                found = true
                courseCount += 1
                let courseId = Int(sqlite3_column_int(statement, 0))
                let courseNamePointer = sqlite3_column_text(statement, 1)
                let courseName = courseNamePointer != nil ? String(cString: courseNamePointer!) : ""
                let teacherNamePointer = sqlite3_column_text(statement, 2)
                let teacherName = teacherNamePointer != nil ? String(cString: teacherNamePointer!) : "TBA"
                result += "ID: \(courseId) | Course: [\(courseName)] - Teacher: [\(teacherName)]\n"
                print("[DB_QUERY] Found enrollment: courseId=\(courseId), courseName=\(courseName), teacher=\(teacherName)")
            }
            if !found {
                result = "No enrolled courses found."
                print("[DB_QUERY] No enrollments found for studentId=\(studentId)")
            } else {
                print("[DB_QUERY] Total enrollments found: \(courseCount)")
            }
        } else {
            result = "Error fetching schedule."
            print("[DB_QUERY] Failed to prepare SQL statement for studentId=\(studentId)")
        }
        sqlite3_finalize(statement)
        print("[DB_QUERY] getStudentSchedule returning: \(result)")
        return result
    }
    
    func fetchAllCourses() -> [(id: Int, name: String)] {
        var courses: [(id: Int, name: String)] = []
        let query = "SELECT id, courseName FROM Courses;"
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                let namePointer = sqlite3_column_text(statement, 1)
                let name = namePointer != nil ? String(cString: namePointer!) : "Unknown"
                courses.append((id: id, name: name))
            }
        } else {
            print("Error preparing query for fetchAllCourses")
        }
        sqlite3_finalize(statement)
        return courses
    }

    func getAllAvailableCourses() -> [(id: Int, name: String)] {
        fetchAllCourses()
    }
    
    func fetchUsers() -> [User] {
        var users: [User] = []
        
        // Fetch Students
        let studentQuery = "SELECT id, name, email, password FROM Students;"
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, studentQuery, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                let namePointer = sqlite3_column_text(statement, 1)
                let name = namePointer != nil ? String(cString: namePointer!) : ""
                let emailPointer = sqlite3_column_text(statement, 2)
                let email = emailPointer != nil ? String(cString: emailPointer!) : ""
                let passwordPointer = sqlite3_column_text(statement, 3)
                let password = passwordPointer != nil ? String(cString: passwordPointer!) : ""
                
                let student = Student(id: id, name: name, email: email, password: password)
                users.append(student)
            }
        }
        sqlite3_finalize(statement)
        
        // Fetch Teachers
        let teacherQuery = "SELECT id, name, email, password FROM Teachers;"
        var teacherStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, teacherQuery, -1, &teacherStatement, nil) == SQLITE_OK {
            while sqlite3_step(teacherStatement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(teacherStatement, 0))
                let namePointer = sqlite3_column_text(teacherStatement, 1)
                let name = namePointer != nil ? String(cString: namePointer!) : ""
                let emailPointer = sqlite3_column_text(teacherStatement, 2)
                let email = emailPointer != nil ? String(cString: emailPointer!) : ""
                let passwordPointer = sqlite3_column_text(teacherStatement, 3)
                let password = passwordPointer != nil ? String(cString: passwordPointer!) : ""
                
                let teacher = Teacher(id: id, name: name, email: email, password: password)
                users.append(teacher)
            }
        }
        sqlite3_finalize(teacherStatement)
        
        return users
    }
    
    func authenticateUser(name: String, password: String) -> User? {
        var user: User? = nil
        
        // Check Admins table first
        let adminQuery = "SELECT id, name, email, password FROM Admins WHERE name = '\(name)' AND password = '\(password)';"
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, adminQuery, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                let namePointer = sqlite3_column_text(statement, 1)
                let adminName = namePointer != nil ? String(cString: namePointer!) : ""
                let emailPointer = sqlite3_column_text(statement, 2)
                let emailFromDB = emailPointer != nil ? String(cString: emailPointer!) : ""
                let passwordPointer = sqlite3_column_text(statement, 3)
                let passwordFromDB = passwordPointer != nil ? String(cString: passwordPointer!) : ""
                
                user = Admin(id: id, name: adminName, email: emailFromDB, password: passwordFromDB)
            }
        }
        sqlite3_finalize(statement)
        
        // Check Teachers table
        if user == nil {
            let teacherQuery = "SELECT id, name, email, password FROM Teachers WHERE name = '\(name)' AND password = '\(password)';"
            var teacherStatement: OpaquePointer? = nil
            
            if sqlite3_prepare_v2(db, teacherQuery, -1, &teacherStatement, nil) == SQLITE_OK {
                if sqlite3_step(teacherStatement) == SQLITE_ROW {
                    let id = Int(sqlite3_column_int(teacherStatement, 0))
                    let namePointer = sqlite3_column_text(teacherStatement, 1)
                    let teacherName = namePointer != nil ? String(cString: namePointer!) : ""
                    let emailPointer = sqlite3_column_text(teacherStatement, 2)
                    let emailFromDB = emailPointer != nil ? String(cString: emailPointer!) : ""
                    let passwordPointer = sqlite3_column_text(teacherStatement, 3)
                    let passwordFromDB = passwordPointer != nil ? String(cString: passwordPointer!) : ""
                    
                    user = Teacher(id: id, name: teacherName, email: emailFromDB, password: passwordFromDB)
                }
            }
            sqlite3_finalize(teacherStatement)
        }
        
        // Check Students table
        if user == nil {
            let studentQuery = "SELECT id, name, email, password FROM Students WHERE name = '\(name)' AND password = '\(password)';"
            var studentStatement: OpaquePointer? = nil
            
            if sqlite3_prepare_v2(db, studentQuery, -1, &studentStatement, nil) == SQLITE_OK {
                if sqlite3_step(studentStatement) == SQLITE_ROW {
                    let id = Int(sqlite3_column_int(studentStatement, 0))
                    let namePointer = sqlite3_column_text(studentStatement, 1)
                    let studentName = namePointer != nil ? String(cString: namePointer!) : ""
                    let emailPointer = sqlite3_column_text(studentStatement, 2)
                    let emailFromDB = emailPointer != nil ? String(cString: emailPointer!) : ""
                    let passwordPointer = sqlite3_column_text(studentStatement, 3)
                    let passwordFromDB = passwordPointer != nil ? String(cString: passwordPointer!) : ""
                    
                    user = Student(id: id, name: studentName, email: emailFromDB, password: passwordFromDB)
                }
            }
            sqlite3_finalize(studentStatement)
        }
        
        return user
    }

    func authenticateUser(email: String, password: String) -> User? {
        return authenticateUser(name: email, password: password)
    }

    func resetEntireDatabase() {
        let resetQueries = [
            "DROP TABLE IF EXISTS Users;",
            "DELETE FROM Enrollments;",
            "DELETE FROM TeacherCourses;",
            "DELETE FROM Grades;",
            "DELETE FROM Courses;",
            "DELETE FROM Students;",
            "DELETE FROM Teachers;",
            "DELETE FROM Admins;",
            "DELETE FROM sqlite_sequence;"
        ]
        
        var errorMessage: UnsafeMutablePointer<Int8>? = nil
        
        for query in resetQueries {
            query.withCString { queryCString in
                if sqlite3_exec(db, queryCString, nil, nil, &errorMessage) != SQLITE_OK {
                    if let errorMsg = errorMessage {
                        let errorString = String(cString: errorMsg)
                        print("Error during reset: \(errorString)")
                        sqlite3_free(errorMessage)
                    }
                }
            }
        }
        
        print("Database reset complete.")
        seedDefaultAdmin()
    }

    func getAllCoursesFormatted() -> String {
        var result = ""
        let query = "SELECT id, courseName FROM Courses;"
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            var found = false
            while sqlite3_step(statement) == SQLITE_ROW {
                found = true
                let id = Int(sqlite3_column_int(statement, 0))
                let namePointer = sqlite3_column_text(statement, 1)
                let name = namePointer != nil ? String(cString: namePointer!) : ""
                result += "[ID: \(id)] \(name)\n"
            }
            if !found {
                result = "No courses found."
            }
        } else {
            result = "Error fetching courses."
        }
        sqlite3_finalize(statement)
        return result
    }
    
    func getAllUsersFormatted() -> String {
        var result = ""
        let query = """
        SELECT id, name, 'student' as role, email FROM Students 
        UNION ALL 
        SELECT id, name, 'teacher' as role, email FROM Teachers;
        """
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            var found = false
            while sqlite3_step(statement) == SQLITE_ROW {
                found = true
                let id = Int(sqlite3_column_int(statement, 0))
                let namePointer = sqlite3_column_text(statement, 1)
                let name = namePointer != nil ? String(cString: namePointer!) : ""
                let rolePointer = sqlite3_column_text(statement, 2)
                let role = rolePointer != nil ? String(cString: rolePointer!) : ""
                let emailPointer = sqlite3_column_text(statement, 3)
                let email = emailPointer != nil ? String(cString: emailPointer!) : ""
                result += "[ID: \(id)] \(name) - \(role.capitalized) - \(email)\n"
            }
            if !found {
                result = "No users found."
            }
        } else {
            result = "Error fetching users."
        }
        sqlite3_finalize(statement)
        return result
    }

    deinit {
        if db != nil {
            sqlite3_close(db)
        }
    }
}
