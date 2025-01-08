
################################## !/usr/bin/zsh
#!/bin/bash

connectMenu() {
    echo "Connecting to database: $dbPath" >> ../LOGS/connectMenu.log
    dbName=$(basename "$dbPath")  # Extract just the database name
    echo "Database name: $dbName" >> ../LOGS/connectMenu.log

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
        echo "User canceled." >> ../LOGS/connectMenu.log
        zenity --info --text="User canceled."
        return
    fi

    case $choice in
        "Create Table")
            echo "Creating table..." >> ../LOGS/connectMenu.log
            ../CONNECT_MENU-API/createTable.sh  "$dbPath"
            echo "Table created successfully." >> ../LOGS/connectMenu.log
            connectMenu "$dbPath"
            ;;
        "Select from Table")
            echo "Selecting from table..." >> ../LOGS/connectMenu.log
            ../CONNECT_MENU-API/selectFromTable.sh  "$dbPath"
            echo "Selection successful." >> ../LOGS/connectMenu.log
            connectMenu "$dbPath"
            ;;
        "List Tables")
            echo "Listing tables..." >> ../LOGS/connectMenu.log
            ../CONNECT_MENU-API/listTable.sh "$dbPath"
            echo "Tables listed successfully." >> ../LOGS/connectMenu.log
            connectMenu "$dbPath"
            ;;
        "Insert into Table")
            echo "Inserting into table..." >> ../LOGS/connectMenu.log
            ../CONNECT_MENU-API/insertTable.sh "$dbPath"
            echo "Insertion successful." >> ../LOGS/connectMenu.log
            connectMenu "$dbPath"
            ;;
        "Update into Table")
            echo "Updating table..." >> ../LOGS/connectMenu.log
            ../CONNECT_MENU-API/updateTable.sh "$dbPath"
            echo "Update successful." >> ../LOGS/connectMenu.log
            connectMenu "$dbPath"
            ;;
        "Delete from Table")
            echo "Deleting from table..." >> ../LOGS/connectMenu.log
            ../CONNECT_MENU-API/deleteFromTable.sh "$dbPath"
            echo "Deletion successful." >> ../LOGS/connectMenu.log
            connectMenu "$dbPath"
            ;;
        "Drop Table")
            echo "Dropping table..." >> ../LOGS/connectMenu.log
            ../CONNECT_MENU-API/dropTable.sh "$dbPath"
            echo "Table dropped successfully." >> ../LOGS/connectMenu.log
            connectMenu "$dbPath"
            ;;
        "Exit")
            echo "Exiting application..." >> ../LOGS/connectMenu.log
            zenity --info \
                --title="Exit" \
                --text="Quitting the Database Manager.."
            exit 0
            ;;
        *)
            echo "Invalid option. Please try again." >> ../LOGS/connectMenu.log
            zenity --error \
                --title="Error" \
                --text="Invalid option. Please Try again." 
            connectMenu
            ;;
    esac
}

# Start the application
connectMenu "$1"
