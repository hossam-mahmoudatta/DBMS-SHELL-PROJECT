
################################## !/usr/bin/zsh
#!/bin/bash

connectMenu() {
    dbPath=$1
    choice=$(zenity --list --title="Connect Menu" --text="What would you want to do?" --width=350 --height=350\
        --column="DBMS Options:" \
        "Create a Database" "List Databases" "Connect to a Database" "Drop a Database" "Exit" --extra-button="Exit")
    
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
            zenity --info --text="Thank you for using HZA DBMS!" --title="Exit"
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
