
################################## !/usr/bin/zsh
#!/bin/bash

connectMenu() {
    dbPath=$1
    dbName=$(basename "$dbPath")  # Extract just the database name
    
    choice=$(zenity --list \
        --width=350 --height=350 \
        --extra-button="Exit" \
        --title="$dbName" \
        --text="What would you want to do with $dbName" \
        --column="Database Options:" \
        "Create Table" "List Tables" "Drop Table" \
        "Select from Table" "Insert into Table" "Update into Table" \
        "Delete from Table" "Exit")
    
    case $choice in
        "Create a Database")
            ./createDatabase.sh
            connectMenu
            ;;
        "List Databases")
            ./listDatabase.sh
            connectMenu
            ;;
        "Connect to a Database")
            ./connectDatabase.sh
            connectMenu
            ;;
        "Drop a Database")
            ./dropDatabase.sh
            connectMenu
            ;;
        "Exit")
            zenity --info --text="Quitting the Database Manager.." --title="Exit"
            exit 0
            ;;
        *)
            zenity --error --text="Invalid option. Please Try again." --title="Error"
            connectMenu
            ;;
    esac
}


# Start the application
connectMenu
