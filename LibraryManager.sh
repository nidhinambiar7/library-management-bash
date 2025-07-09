#!/bin/bash

# Database files
BOOKS_DB="books.txt"
STUDENTS_DB="students.txt"
BORROWED_DB="borrowed.txt"
ADMIN_DB="admin.txt"

# Create database files if they don't exist
touch "$BOOKS_DB" "$STUDENTS_DB" "$BORROWED_DB" "$ADMIN_DB"

# Initialize admin credentials if not exists
if [ ! -s "$ADMIN_DB" ]; then
    echo "admin:password" > "$ADMIN_DB"
fi

student_login() {
    local credentials
    credentials=$(zenity --forms --title="Student Login" \
        --text="Enter your details" \
        --add-entry="Name" \
        --add-entry="Phone Number" \
        --add-password="Password")
    
    if [ $? -ne 0 ]; then
        return 1
    fi
    
    IFS='|' read -r name phone password <<< "$credentials"
    
    if grep -q "^$name:$phone:$password$" "$STUDENTS_DB"; then
        student_menu "$name"
    else
        zenity --error --text="Invalid credentials or student not registered!"
        return 1
    fi
}

student_register() {
    local credentials
    credentials=$(zenity --forms --title="Student Registration" \
        --text="Enter your details" \
        --add-entry="Name" \
        --add-entry="Phone Number" \
        --add-password="Password")
    
    if [ $? -ne 0 ]; then
        return 1
    fi
    
    IFS='|' read -r name phone password <<< "$credentials"
    
    if grep -q "^$name:" "$STUDENTS_DB"; then
        zenity --error --text="Student already exists!"
        return 1
    fi
    
    echo "$name:$phone:$password" >> "$STUDENTS_DB"
    zenity --info --text="Registration successful!"
}

admin_register() {
    local credentials
    credentials=$(zenity --forms --title="Admin Registration" \
        --text="Enter admin details" \
        --add-entry="Name" \
        --add-password="Password" \
        --add-password="Confirm Password")
    
    if [ $? -ne 0 ]; then
        return 1
    fi
    
    IFS='|' read -r name password confirm_password <<< "$credentials"
    
    # Validate password match
    if [ "$password" != "$confirm_password" ]; then
        zenity --error --text="Passwords do not match!"
        return 1
    fi
    
    # Check if admin already exists
    if grep -q "^$name:" "$ADMIN_DB"; then
        zenity --error --text="Admin user already exists!"
        return 1
    fi
    
    echo "$name:$password" >> "$ADMIN_DB"
    zenity --info --text="Admin registration successful!"
}

student_menu() {
    local name=$1
    while true; do
        local choice
        choice=$(zenity --list --title="Student Menu" \
            --text="Welcome $name" \
            --column="Options" \
            "Borrow Book" \
            "Return Book" \
            "Display Borrowed Books" \
            "Logout")
        
        case $choice in
            "Borrow Book")
                borrow_book "$name"
                ;;
            "Return Book")
                return_book "$name"
                ;;
            "Display Borrowed Books")
                display_borrowed_books "$name"
                ;;
            "Logout"|"")
                return 0
                ;;
        esac
    done
}

borrow_book() {
    local name=$1
    local available_books
    available_books=$(comm -23 <(sort "$BOOKS_DB") <(grep "^$name:" "$BORROWED_DB" | cut -d':' -f2 | sort))
    
    if [ -z "$available_books" ]; then
        zenity --error --text="No books available!"
        return 1
    fi
    
    local book
    book=$(echo "$available_books" | zenity --list --title="Available Books" \
        --text="Select a book to borrow" \
        --column="Books" \
        --height=400)
    
    if [ -n "$book" ]; then
        echo "$name:$book:$(date +%Y-%m-%d)" >> "$BORROWED_DB"
        zenity --info --text="Book borrowed successfully!"
    fi
}

return_book() {
    local name=$1
    local borrowed_books
    borrowed_books=$(grep "^$name:" "$BORROWED_DB" | cut -d':' -f2)
    
    if [ -z "$borrowed_books" ]; then
        zenity --error --text="No books to return!"
        return 1
    fi
    
    local book
    book=$(echo "$borrowed_books" | zenity --list --title="Borrowed Books" \
        --text="Select a book to return" \
        --column="Books" \
        --height=400)
    
    if [ -n "$book" ]; then
        sed -i "/^$name:$book:/d" "$BORROWED_DB"
        zenity --info --text="Book returned successfully!"
    fi
}

display_borrowed_books() {
    local name=$1
    local borrowed_books
    borrowed_books=$(grep "^$name:" "$BORROWED_DB" | \
        awk -F: '{print "Book: " $2 "\nBorrowed Date: " $3 "\n"}')
    
    if [ -z "$borrowed_books" ]; then
        zenity --info --text="No books borrowed."
    else
        echo "$borrowed_books" | zenity --text-info --title="Your Borrowed Books" \
            --width=400 --height=300
    fi
}

admin_login() {
    local credentials
    credentials=$(zenity --forms --title="Admin Login" \
        --text="Enter admin credentials" \
        --add-entry="Name" \
        --add-password="Password")
    
    if [ $? -ne 0 ]; then
        return 1
    fi
    
    IFS='|' read -r name password <<< "$credentials"
    
    if grep -q "^$name:$password$" "$ADMIN_DB"; then
        admin_menu
    else
        zenity --error --text="Invalid admin credentials!"
        return 1
    fi
}

admin_menu() {
    while true; do
        local choice
        choice=$(zenity --list --title="Admin Menu" \
            --text="Select an option" \
            --column="Options" \
            "Display Books" \
            "Add Book" \
            "Remove Book" \
            "View All Borrowed Books" \
            "Logout")
        
        case $choice in
            "Display Books")
                display_books
                ;;
            "Add Book")
                add_book
                ;;
            "Remove Book")
                remove_book
                ;;
            "View All Borrowed Books")
                view_all_borrowed_books
                ;;
            "Logout"|"")
                return 0
                ;;
        esac
    done
}

view_all_borrowed_books() {
    if [ ! -s "$BORROWED_DB" ]; then
        zenity --info --text="No books are currently borrowed."
        return
    fi
    
    local borrowed_info
    borrowed_info=$(awk -F: '{printf "Student: %s\nBook: %s\nBorrowed Date: %s\n\n", $1, $2, $3}' "$BORROWED_DB")
    echo "$borrowed_info" | zenity --text-info --title="All Borrowed Books" \
        --width=500 --height=400
}

display_books() {
    if [ ! -s "$BOOKS_DB" ]; then
        zenity --info --text="No books in the library."
        return
    fi
    
    zenity --text-info --title="Library Books" \
        --filename="$BOOKS_DB" \
        --width=400 --height=300
}

add_book() {
    local book
    book=$(zenity --entry --title="Add Book" \
        --text="Enter book title:")
    
    if [ -n "$book" ]; then
        if grep -q "^$book$" "$BOOKS_DB"; then
            zenity --error --text="Book already exists!"
            return 1
        fi
        echo "$book" >> "$BOOKS_DB"
        zenity --info --text="Book added successfully!"
    fi
}

remove_book() {
    if [ ! -s "$BOOKS_DB" ]; then
        zenity --error --text="No books to remove!"
        return 1
    fi
    
    local book
    book=$(cat "$BOOKS_DB" | zenity --list --title="Remove Book" \
        --text="Select a book to remove" \
        --column="Books" \
        --height=400)
    
    if [ -n "$book" ]; then
        sed -i "/^$book$/d" "$BOOKS_DB"
        # Also remove from borrowed books
        sed -i "/^[^:]*:$book:/d" "$BORROWED_DB"
        zenity --info --text="Book removed successfully!"
    fi
}

# Main menu
while true; do
    choice=$(zenity --list --title="Library Management System" \
        --text="Select user type" \
        --column="Options" \
        "Student Login" \
        "Student Register" \
        "Admin Login" \
        "Admin Register" \
        "Exit")
    
    case $choice in
        "Student Login")
            student_login
            ;;
        "Student Register")
            student_register
            ;;
        "Admin Login")
            admin_login
            ;;
        "Admin Register")
            admin_register
            ;;
        "Exit"|"")
            exit 0
            ;;
    esac
done
