
################################## !/usr/bin/zsh
#!/bin/bash

connectMenu() {
    logFile="../LOGS/connectMenu.log"
    dbPath=$1
    echo "Connecting to database: $dbPath" >> "$logFile"
    dbName=$(basename "$dbPath")  # Extract just the database name
    echo "Database name: $dbName" >> "$logFile"

    choice=$(zenity --list \
        --width=350 --height=350 \
        --title="$dbName" \
        --text="What would you want to do with $dbName" \
        --column="Database Options:" \
        "Create Table" \
        "List Tables" \
        "Drop Table" \
        "Select from Table" \
        "Insert into Table" \
        "Update into Table" \
        "Delete from Table" \
        "Exit" --extra-button="Exit" )

    if [ $? -ne 0 ];
    then
        echo "User canceled." >> "$logFile"
        zenity --info --text="User canceled."
        return
    fi

    case $choice in
        "Create Table")
            echo "Creating table..." >> "$logFile"
            ../CONNECT_MENU-API/createTable.sh  "$dbPath"
            echo "Table created successfully." >> "$logFile"
            connectMenu "$dbPath"
            ;;
        "Select from Table")
            echo "Selecting from table..." >> "$logFile"
            ../CONNECT_MENU-API/selectFromTable.sh  "$dbPath"
            echo "Selection successful." >> "$logFile"
            connectMenu "$dbPath"
            ;;
        "List Tables")
            echo "Listing tables..." >> "$logFile"
            ../CONNECT_MENU-API/listTable.sh "$dbPath"
            echo "Tables listed successfully." >> "$logFile"
            connectMenu "$dbPath"
            ;;
        "Insert into Table")
            echo "Inserting into table..." >> "$logFile"
            ../CONNECT_MENU-API/insertTable.sh "$dbPath"
            echo "Insertion successful." >> "$logFile"
            connectMenu "$dbPath"
            ;;
        "Update into Table")
            echo "Updating table..." >> "$logFile"
            ../CONNECT_MENU-API/updateTable.sh "$dbPath"
            echo "Update successful." >> "$logFile"
            connectMenu "$dbPath"
            ;;
        "Delete from Table")
            echo "Deleting from table..." >> "$logFile"
            ../CONNECT_MENU-API/deleteFromTable.sh "$dbPath"
            echo "Deletion successful." >> "$logFile"
            connectMenu "$dbPath"
            ;;
        "Drop Table")
            echo "Dropping table..." >> "$logFile"
            ../CONNECT_MENU-API/dropTable.sh "$dbPath"
            echo "Table dropped successfully." >> "$logFile"
            connectMenu "$dbPath"
            ;;
        "Exit")
            echo "Exiting application..." >> "$logFile"
            zenity --info \
                --title="Exit" \
                --text="Quitting the Database Manager.."
            exit 0
            ;;
        *)
            echo "Invalid option. Please try again." >> "$logFile"
            zenity --error \
                --title="Error" \
                --text="Invalid option. Please Try again." 
            connectMenu
            ;;
    esac
}

# Start the application
connectMenu "$1"
