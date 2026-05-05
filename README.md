# 🏫 School Management System (Desktop App)

A simple **School Management System** built as a desktop application for Windows, designed to manage students, teachers, courses, and enrollments in a structured and user-friendly way.

The system provides different roles (Admin, Teacher, Student), each with dedicated features and dashboards.

---

## 🚀 Features

### 👨‍💼 Admin
- Add / manage students
- Add / manage teachers
- Create courses
- View all users in the system
- View user profile ("About Me")

### 👨‍🏫 Teacher
- View assigned courses
- Join courses to teach
- View students enrolled in their courses
- View profile ("About Me")

### 👨‍🎓 Student
- View available courses
- Enroll in courses using Course ID
- View enrolled courses
- View grades
- View profile ("About Me")

---

## 🧱 System Architecture

The project follows a simple layered structure:

- **UI Layer** → Built using SwiftWin32 (Windows desktop UI)
- **Logic Layer** → Handles user actions and application flow
- **Data Layer** → SQLite database using C-based bindings

---

## ⚙️ Technologies Used

- **Swift (Core Language)**
- **SwiftWin32** → For building native Windows GUI
- **SQLite (via C integration)** → Lightweight embedded database
- **C / C++ Integration** → Used for low-level database access and system interaction

> The project demonstrates interoperability between Swift and C-based libraries to build a cross-technology desktop system.

---

## 🗄️ Database

The system uses a local SQLite database with the following tables:

- `Admins`
- `Students`
- `Teachers`
- `Courses`
- `Enrollments`
- `Grades`
- `TeacherCourses`

Relationships:
- Students enroll in courses via `Enrollments`
- Teachers are assigned to courses via `TeacherCourses`
- Grades are linked to students and courses

---

## 🎯 Key Concepts

- Role-based access control (RBAC)
- MVC-like separation of concerns
- Relational database design
- Cross-language integration (Swift + C)
- Event-driven UI system

---

## 🖥️ UI Overview

Each user role has a dedicated dashboard:

- Clean structured layout
- Course listing with ID-based enrollment
- Profile section ("About Me")
- Simple navigation between views

The UI is designed to be minimal, readable, and functional rather than overly complex.

---

## 🔐 Authentication

Users are authenticated based on:
- Email / Name
- Password
- Role (Admin / Teacher / Student)

---



---

## 👨‍💻 Author

Developed as a learning project to demonstrate:
- Mohamed ElGohary

---

## 📄 License

This project is for educational purposes only.
