#!/usr/bin/zsh

main_menu() {
    choice=$(zenity --list --title="File Manager" --text="Choose an action:" \
        --column="Option" \
        "Create File" "List Files" "Delete File" "Exit")
    
    case $choice in
        "Create File")
            create_file
            ;;
        "List Files")
            list_files
            ;;
        "Delete File")
            delete_file
            ;;
        "Exit")
            zenity --info --text="Goodbye!" --title="Exit"
            exit 0
            ;;
        *)
            zenity --error --text="Invalid choice. Try again." --title="Error"
            main_menu
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
    main_menu
}

list_files() {
    filelist=$(ls)
    zenity --text-info --title="Files in Directory" --width=500 --height=300 <<< "$filelist"
    main_menu
}

delete_file() {
    filename=$(zenity --entry --title="Delete File" --text="Enter file name to delete:")
    if [[ -e "$filename" ]]; then
        rm "$filename" && \
        zenity --info --text="File '$filename' deleted successfully." --title="Success"
    else
        zenity --error --text="File '$filename' not found." --title="Error"
    fi
    main_menu
}

# Start the application
main_menu
