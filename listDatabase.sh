
################################## !/usr/bin/zsh
#!/bin/bash

# HZA DBMS was created by:
# Abdelrahman Khaled
# Zeyad Tarek
# Hossam Mahmoud

mainMenu() {
    choice=$(zenity --list --title="ITI HZA DBMS" --text="Choose your preferred action:" --width=300 --height=300\
        --column="DBMS Options:" \
        "Create a Database" "List Databases" "Connect to a Database" "Drop a Database" "Exit" --extra-button="Exit")
    
    case $choice in
        "Create a Database")
            ./createDatabase.sh
            mainMenu
            ;;
        "List Databases")
            ./listDatabase.sh
            mainMenu
            ;;
        "Connect to a Database")
            ./connectDatabase.sh
            mainMenu
            ;;
        "Drop a Database")
            ./dropDatabase.sh
            mainMenu
            ;;
        "Exit")
            zenity --info --text="Thank you for using HZA DBMS!" --title="Exit"
            exit 0
            ;;
        *)
            zenity --error --text="Invalid option. Please Try again." --title="Error"
            mainMenu
            ;;
    esac
}


# Start the application
mainMenu
