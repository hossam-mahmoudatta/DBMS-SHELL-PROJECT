
################################## !/usr/bin/zsh
#!/bin/bash

# HZA DBMS was created by:
# Abdelrahman Khaled
# Zeyad Tarek
# Hossam Mahmoud

mainMenu() {
    logFile="../LOGS/mainMenu.log"

    echo "$(date) - Main Menu Started" >> $logFile

    choice=$(zenity --list \
        --title="ITI HZA DBMS Main Menu" \
        --text="Choose your preferred action:" \
        --width=350 --height=350\
        --column="DBMS Options:" \
        "Create a Database" \
        "List Databases" \
        "Connect to a Database" \
        "Drop a Database" \
        "Exit" --extra-button="Exit")

    case $choice in
        "Create a Database")
            echo "$(date) - Create Database Option Selected" >> $logFile
            ./createDatabase.sh
            echo "$(date) - Create Database Option Executed" >> $logFile
            mainMenu
            ;;
        "List Databases")
            echo "$(date) - List Databases Option Selected" >> $logFile
            ./listDatabase.sh
            echo "$(date) - List Databases Option Executed" >> $logFile
            mainMenu
            ;;
        "Connect to a Database")
            echo "$(date) - Connect to Database Option Selected" >> $logFile
            ./connectDatabase.sh
            echo "$(date) - Connect to Database Option Executed" >> $logFile
            mainMenu
            ;;
        "Drop a Database")
            echo "$(date) - Drop Database Option Selected" >> $logFile
            ./dropDatabase.sh
            echo "$(date) - Drop Database Option Executed" >> $logFile
            mainMenu
            ;;
        "Exit")
            echo "$(date) - Exit Option Selected" >> $logFile
            zenity --info --text="Thank you for using HZA DBMS!" --title="Exit"
            echo "$(date) - Application Exited" >> $logFile
            exit 0
            ;;
        *)
            echo "$(date) - Invalid Option Selected" >> $logFile
            zenity --error --text="Invalid option. Please Try again." --title="Error"
            mainMenu
            ;;
    esac
}

# Start the application
mainMenu
