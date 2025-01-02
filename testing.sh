#!/usr/bin/zsh
# GTK_THEME="Arc-Dark" zenity --info --text="Custom theme applied!" --width=300 --height=150
#!/bin/bash

mainMenu() {
    choice=$(zenity --list --title="ITI HZA DBMS" --text="Choose your preferred action:" --width=300 --height=300\
        --column="DBMS Options:" \
        "Create a Database" "List Databases" "Connect to a Database" "Drop a Database" "Exit" --extra-button="About")
    
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

create_file() {
    filename=$(zenity --entry --title="Create File" --text="Enter file name:")
    if [[ -n "$filename" ]]; then
        touch "$filename" && \
        zenity --info --text="File '$filename' created successfully." --title="Success"
    else
        zenity --error --text="No file name provided." --title="Error"
    fi
    mainMenu
}

list_files() {
    filelist=$(ls)
    zenity --text-info --title="Files in Directory" --width=500 --height=300 <<< "$filelist"
    mainMenu
}

delete_file() {
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



#comment