# Created: 2025-01-01 15:00:00
# Created by Hossam

listDatabase() {
    # Prompt the user for a database name using Zenity
    db_name=$(zenity --entry --title="Create Database" --text="Enter your database name:")

    # Check if the user canceled the operation
    if [ $? -ne 0 ]; then
        zenity --error --title="Operation Canceled" --text="No database name entered."
        return
    fi

    # Validate the database name (no spaces, only alphanumeric characters, underscores, or camelCase)
    if [[ ! "$db_name" =~ ^[a-zA-Z0-9_]+$ ]]; then
        zenity --error --title="Invalid Database Name" --text="Invalid database name. Avoid spaces and special characters. Use underscores (_) or camelCase if necessary."
        return
    fi

    # Check if the directory already exists
    if [ -d "$db_name" ]; then
        zenity --warning --title="Database Exists" --text="Database \"$db_name\" already exists!"
    else
        # Create the directory for the database
        mkdir -p DATABASES/"$db_name"
        zenity --info --title="Database Created" --text="Database \"$db_name\" created successfully."
    fi
}

# Call the function
createDatabase