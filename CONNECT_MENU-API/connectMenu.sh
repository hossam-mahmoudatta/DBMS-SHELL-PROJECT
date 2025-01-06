
################################## !/usr/bin/zsh
#!/bin/bash

connectMenu() {
    dbPath=$1
    #echo "Im in connect menu now: $dbPath"
    dbName=$(basename "$dbPath")  # Extract just the database name

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
    
    case $choice in
        "Create Table")
            # pwd - had to change the path.
            ../CONNECT_MENU-API/createTable.sh  "$dbPath"
            connectMenu "$dbPath"
            ;;
        "Select from Table")
            # pwd - had to change the path.
            ../CONNECT_MENU-API/selectFromTable.sh  "$dbPath"
            connectMenu "$dbPath"
            ;;
        "List Tables")
            ../CONNECT_MENU-API/listTable.sh "$dbPath"
            connectMenu "$dbPath"
            ;;
        "Select from Table")
            ../CONNECT_MENU-API/connectDatabase.sh
            connectMenu
            ;;
        "Insert into Table")
            ../CONNECT_MENU-API/insertTable.sh "$dbPath"
            connectMenu "$dbPath"
            ;;
        "Update into Table")
            ../CONNECT_MENU-API/updateTable.sh "$dbPath"
            connectMenu "$dbPath"
            ;;
        "Delete from Table")
            ../CONNECT_MENU-API/deleteFromTable.sh "$dbPath"
            connectMenu "$dbPath"
            ;;
        "Drop Table")
            ../CONNECT_MENU-API/dropTable.sh "$dbPath"
            connectMenu "$dbPath"
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
connectMenu "$1"
