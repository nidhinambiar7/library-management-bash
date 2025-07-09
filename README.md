# library-management-bash
A simple library management system using Bash and Zenity for GUI dialogs. Built for a UNIX Shell Programming course project.

![Bash](https://img.shields.io/badge/bash-4.0+-green.svg)
![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-Linux-lightgrey.svg)

A command-line library management system built with Bash scripting and Zenity GUI components. This system provides separate interfaces for students and administrators to manage book borrowing, returns, and library inventory.

## 🚀 Features

### Student Features
* **User Registration** - Create new student accounts with secure authentication
* **Book Borrowing** - Browse and borrow available books from the library
* **Book Returns** - Return borrowed books with automatic record updates
* **Personal Dashboard** - View all currently borrowed books with dates
* **Secure Login** - Password-protected access with credential validation

### Administrator Features
* **Library Management** - Add and remove books from the library inventory
* **Book Inventory** - View complete list of all books in the system
* **Borrowing Overview** - Monitor all borrowed books across all students
* **Admin Registration** - Create new administrator accounts
* **Secure Access** - Password-protected administrative functions

## 📋 Requirements

* **Operating System:** Linux (Ubuntu, Debian, CentOS, etc.)
* **Shell:** Bash 4.0 or higher
* **GUI Framework:** Zenity (for graphical dialogs)
* **Permissions:** Read/write access to script directory

### Installing Dependencies

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install zenity
```

**CentOS/RHEL:**
```bash
sudo yum install zenity
# or for newer versions
sudo dnf install zenity
```

**Arch Linux:**
```bash
sudo pacman -S zenity
```

## 🛠 Installation

1. **Clone the repository:**
```bash
git clone https://github.com/nidhinambiar7/library-management-bash.git
cd library-management-bash
```

2. **Make the script executable:**
```bash
chmod +x LibraryManager.sh
```

3. **Run the application:**
```bash
./LibraryManager.sh
```

## 🚀 Usage

### First Time Setup

1. **Launch the application:**
```bash
./LibraryManager.sh
```

2. **Default Admin Access:**
   - Username: `admin`
   - Password: `password`
   - ⚠️ **Important:** Change default credentials immediately after first login

### Student Workflow

1. **Registration:**
   - Select "Student Register" from main menu
   - Provide name, phone number, and password
   - Confirm registration success

2. **Login:**
   - Select "Student Login"
   - Enter registered credentials
   - Access student dashboard

3. **Borrowing Books:**
   - Choose "Borrow Book" from student menu
   - Select from available books list
   - Confirm borrowing transaction

4. **Returning Books:**
   - Select "Return Book" from student menu
   - Choose from your borrowed books
   - Confirm return transaction

### Administrator Workflow

1. **Login:**
   - Select "Admin Login" from main menu
   - Enter admin credentials
   - Access administrator dashboard

2. **Managing Books:**
   - **Add Books:** Select "Add Book" and enter book title
   - **Remove Books:** Select "Remove Book" and choose from inventory
   - **View Inventory:** Select "Display Books" to see all available books

3. **Monitoring System:**
   - Select "View All Borrowed Books" to see complete borrowing status
   - Monitor student activity and book circulation

## 📁 Data Storage

The system automatically creates and manages the following files:

```
library_data/
├── books.txt          # Book inventory database
├── students.txt       # Student credentials and info
├── borrowed.txt       # Active borrowing records
└── admin.txt         # Administrator credentials
```

### Data Format

**books.txt:**
```
Book Title 1
Book Title 2
Book Title 3
```

**students.txt:**
```
StudentName:PhoneNumber:Password
JohnDoe:1234567890:securepass
```

**borrowed.txt:**
```
StudentName:BookTitle:BorrowDate
JohnDoe:Python Programming:2024-01-15
```

**admin.txt:**
```
AdminName:Password
admin:password
```

## 🔧 Configuration

### Customizing Database Files

Edit the variables at the top of the script to change file locations:

```bash
BOOKS_DB="books.txt"
STUDENTS_DB="students.txt"
BORROWED_DB="borrowed.txt"
ADMIN_DB="admin.txt"
```

### Security Considerations

* Change default admin credentials immediately
* Ensure script directory has proper permissions (755)
* Regularly backup database files
* Consider implementing password hashing for production use

## 🐛 Troubleshooting

### Common Issues

**"Command not found" error:**
```bash
# Ensure Zenity is installed
which zenity
sudo apt install zenity  # Ubuntu/Debian
```

**Permission denied:**
```bash
# Make script executable
chmod +x LibraryManager.sh
```

**GUI not displaying:**
```bash
# Check X11 forwarding (if using SSH)
ssh -X username@hostname
# or ensure DISPLAY variable is set
echo $DISPLAY
```

**Database corruption:**
```bash
# Backup and recreate database files
cp books.txt books.txt.backup
> books.txt  # Clear file
# Re-add books through admin interface
```

## 📊 System Limitations

* **File-based Storage:** Not suitable for large-scale deployments
* **Single User Access:** No concurrent user support
* **Basic Authentication:** Simple password storage (not hashed)
* **No Data Validation:** Limited input sanitization
* **Platform Dependency:** Linux/Unix systems only

## 🛡️ Security Notes

* Passwords are stored in plain text (development version)
* No encryption for data files
* Suitable for educational/demonstration purposes
* For production use, implement proper authentication and encryption

## 🤝 Contributing

Contributions are welcome! Areas for improvement:

* Password hashing implementation
* Database migration to SQLite
* Input validation enhancement
* Multi-user concurrent access
* Web interface development

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgements

* **Zenity** - For providing simple GUI dialogs in shell scripts
* **Bash Community** - For extensive documentation and examples
* **BMS College of Engineering** - For educational support and guidance

## 📞 Support

For issues, questions, or suggestions:
* Open an issue on [GitHub Issues](https://github.com/nidhinambiar7/library-management-bash/issues)
* Check existing documentation
* Ensure all dependencies are properly installed

---

**Built for educational purposes and library management automation** 📚
