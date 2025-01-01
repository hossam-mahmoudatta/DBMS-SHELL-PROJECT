#!/usr/bin/zsh

# HZA DBMS was created by:
# Abdelrahman Khaled
# Zeyad Tarek
# Hossam Mahmoud

# Source external function files
source ./createDatabase.sh
source ./listDatabase.sh
source ./connectDatabase.sh
source ./dropDatabase.sh


mainMenu() {
    choice=$(zenity --list --title="ITI HZA DBMS" --text="Choose your preferred action:" --width=300 --height=300\
        --column="DBMS Options:" \
        "Create a Database" "List Databases" "Connect to a Database" "Drop a Database" "Exit" --extra-button="Exit")
    
    case $choice in
        "Create a Database")
            createDatabase
            ;;
        "List Databases")
            listDatabase
            ;;
        "Connect to a Database")
            connectDatabase
            ;;
        "Drop a Database")
            dropDatabase
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

createDatabase() {
    filename=$(zenity --entry --title="Create File" --text="Enter file name:")
    if [[ -n "$filename" ]]; then
        touch "$filename" && \
        zenity --info --text="File '$filename' created successfully." --title="Success"
    else
        zenity --error --text="No file name provided." --title="Error"
    fi
    mainMenu
}

listDatabase() {
    filelist=$(ls)
    zenity --text-info --title="Files in Directory" --width=500 --height=300 <<< "$filelist"
    mainMenu
}

connectDatabase() {
    filelist=$(ls)
    zenity --text-info --title="Files in Directory" --width=500 --height=300 <<< "$filelist"
    mainMenu
}

dropDatabase() {
    filename=$(zenity --entry --title="Delete File" --text="Enter file name to delete:")
    if [[ -e "$filename" ]]; then
        rm "$filename" && \
        zenity --info --text="File '$filename' deleted successfully." --title="Success"
    else
        zenity --error --text="File '$filename' not found." --title="Error"
    fi
    mainMenu
}

# Start the application
mainMenu
