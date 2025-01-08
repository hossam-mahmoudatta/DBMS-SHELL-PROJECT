#!/bin/bash
# Created: Abdelrahman Khaled

createDatabase() {

    logFile="../LOGS/createDatabase.log"
    
    dbName=$(zenity --entry \
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
    if [[ ! "$dbName" =~ ^[a-zA-Z0-9_]+$ ]];
    then
        zenity --error \
            --title="Invalid Database Name" \
            --text="Invalid database name. Avoid spaces and special characters. Use underscores (_) or camelCase if necessary."
        echo "$(date) - Invalid Database Name: $dbName" >> "$logFile"
        return
    fi

    # Check if the directory already exists
    if [ -d "../DATABASES/$dbName" ];
    then
        zenity --warning \
            --title="Database Exists" \
            --text="Database \"$dbName\" already exists!"
        echo "$(date) - Database Exists: $dbName" >> "$logFile"
    else
        # Create the directory for the database
        mkdir -p ../DATABASES/"$dbName"
        zenity --info \
            --title="Database Created" \
            --text="Database \"$dbName\" created successfully."
        echo "$(date) - Database Created: $dbName" >> "$logFile"
    fi
}

# Call the function
createDatabase