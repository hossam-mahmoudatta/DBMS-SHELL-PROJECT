#!/bin/bash

# Created: Abdelrahman Khaled

    createDatabase() {
    logFile="../LOGS/createDatabase.log"
    db_name=$(zenity --entry \
        --title="Create Database" \
        --text="Enter your database name:")

    # Check if the user canceled the operation
    if [ $? -ne 0 ];
    then
        zenity --error \
            --title="Operation Canceled" \
            --text="No database name entered."
        echo "$(date) - Operation Canceled: No database name entered." >> "$logFile"
        return
    fi

    # Validate the database name (no spaces, only alphanumeric characters, underscores, or camelCase)
    if [[ ! "$db_name" =~ ^[a-zA-Z0-9_]+$ ]];
    then
        zenity --error \
            --title="Invalid Database Name" \
            --text="Invalid database name. Avoid spaces and special characters. Use underscores (_) or camelCase if necessary."
        echo "$(date) - Invalid Database Name: $db_name" >> "$logFile"
        return
    fi

    # Check if the directory already exists
    if [ -d "../DATABASES/$db_name" ];
    then
        zenity --warning \
            --title="Database Exists" \
            --text="Database \"$db_name\" already exists!"
        echo "$(date) - Database Exists: $db_name" >> "$logFile"
    else
        # Create the directory for the database
        mkdir -p ../DATABASES/"$db_name"
        zenity --info \
            --title="Database Created" \
            --text="Database \"$db_name\" created successfully."
        echo "$(date) - Database Created: $db_name" >> "$logFile"
    fi
}

# Call the function
createDatabase