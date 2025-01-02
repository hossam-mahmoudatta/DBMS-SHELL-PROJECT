# Created: 2025-01-01 15:00:00
# Created by Hossam

connectDatabase() {
    # Replace with your directory path
    dir="../DATABASES"
    currentDIR=$(dirname "$0")

    # Get the list of files in the directory
    databasesLists=$(ls "$dir")

    # Check if the directory contains files
    if [ -z "$databasesLists" ];
    then
        zenity --info --text="You don't have any databases!"
    else
        # Display the databases in a clickable list
        selectedDB=$(zenity --list --title="Your Databases" --text="Select a Database:" --column="Databases" $databasesLists)

        # Check if a database was selected
        if [ -n "$selectedDB" ];
        then
            # Navigate to the next menu based on the selected database
            zenity --info --text="You selected the database: $selectedDB"
            
            # Call a function or script for the next menu
            # echo "Current Directory: $(pwd)"
            # echo "Current Directory: $selectedDB"
            # echo "Current Directory: $dir/$selectedDB"

            ../CONNECT_MENU-API/connectMenu.sh "$dir/$selectedDB"
        else
            zenity --warning --text="No database selected."
        fi
    fi
}

# Call the function
connectDatabase