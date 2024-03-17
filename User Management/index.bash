

# הגדר את הקובץ לאחסון הנתונים
DATA_FILE="user_data.txt"

# בדוק אם קובץ הנתונים קיים, אם לא צור אותו
touch "$DATA_FILE"

# פונקציה להצגת התפריט
display_menu() {
    echo "1. Add User"
    echo "2. Display List by ID Card"
    echo "3. Display List by First Name"
    echo "4. Display List by Last Name"
    echo "5. Search by ID Card, First Name, or Last Name"
    echo "6. Delete User by ID Card"
    echo "7. Exit"
}

# פונקציה להוספת משתמש
add_user() {
    echo "Enter First Name: "
    read first_name

    # אמת את השם הפרטי (לא אמור להכיל מספרים)
    if [[ "$first_name" =~ [0-9] ]]; then
        echo "Error: First name should not contain numbers."
        return
    fi

    echo "Enter Last Name: "
    read last_name

    # אמת את השם משפחה (לא אמור להכיל מספרים)
    if [[ "$last_name" =~ [0-9] ]]; then
        echo "Error: Last name should not contain numbers."
        return
    fi

    echo "Enter ID Card: "
    read id_card

    
# אימות תעודת זהות (צריך להכיל מספרים בלבד)
    if ! [[ "$id_card" =~ ^[0-9]+$ ]]; then
        echo "Error: ID card should contain only numeric characters."
        return
    fi

   
# בדוק אם יש תעודת זהות כפולה
    while IFS=':' read -r fname lname card || [ -n "$fname" ]; do
        if [ "$card" == "$id_card" ]; then
            echo "Error: Duplicate ID card found. Cannot add user."
            return
        fi
    done < "$DATA_FILE"

    # שמור את נתוני המשתמש
    echo "$first_name:$last_name:$id_card" >> "$DATA_FILE"
    echo "User added successfully."
}


# פונקציה להצגת הרשימה לפי תעודת זהות
display_by_id_card() {
    echo "List sorted by ID card:"
    sort -t: -k3 "$DATA_FILE"
}

# פונקציה להצגת הרשימה לפי שם פרטי
display_by_first_name() {
    echo "List sorted by first name:"
    sort -t: -k1 "$DATA_FILE"
}


# פונקציה להצגת הרשימה לפי שם משפחה
display_by_last_name() {
    echo "List sorted by last name:"
    sort -t: -k2 "$DATA_FILE"
}

# פונקציה לחיפוש לפי תעודת זהות, שם פרטי או שם משפחה
search() {
    echo "Enter ID card, first name, or last name to search: "
    read search_term
    echo "Search results:"
    grep -i "$search_term" "$DATA_FILE"
}

# פונקציה למחיקת משתמש באמצעות תעודת זהות
delete_user() {
    echo "Enter ID card of the user to delete: "
    read id_card

   
# בדוק אם המשתמש עם תעודת הזהות שצוינה קיים
    while IFS=':' read -r fname lname card || [ -n "$fname" ]; do
        if [ "$card" == "$id_card" ]; then
           
          # הסר את השורה המכילה את תעודת הזהות שצוינה
            sed -i "/^$id_card:/d" "$DATA_FILE"
            echo "User with ID card $id_card deleted successfully."
            return
        fi
    done < "$DATA_FILE"

    # אם תעודת הזהות לא נמצאה
    echo "User with ID card $id_card not found."
}


# הסקריפט הראשי מתחיל כאן
while true; do
    display_menu
    read -p "Enter your choice: " choice

    case $choice in
        1) add_user ;;
        2) display_by_id_card ;;
        3) display_by_first_name ;;
        4) display_by_last_name ;;
        5) search ;;
        6) delete_user ;;
        7) echo "Exiting..."; break ;;
        *) echo "Invalid choice. Please try again." ;;
    esac
done
