# Created: 2025-01-01 15:00:00
# Created by Hossam

connectDatabase() {
    dir="../DATABASES"
    logFile="../LOGS/connectDatabase.log"

    # Get the list of files in the directory
    databasesLists=$(ls "$dir")

    # Check if the directory contains files
    if [ -z "$databasesLists" ];
    then
        zenity --info --text="You don't have any databases!"
        echo "$(date) - No databases found." >> "$logFile"
    else
        # Display the databases in a clickable list
        selectedDB=$(zenity --list \
            --title="Your Databases" \
            --text="Select a Database:" \
            --column="Databases" $databasesLists)

        # Check if a database was selected
        if [ -n "$selectedDB" ];
        then
            # Navigate to the next menu based on the selected database
            zenity --info --text="You selected the database: $selectedDB"
            echo "$(date) - Database '$selectedDB' selected." >> "$logFile"
            
            # Call a function or script for the next menu
            ../CONNECT_MENU-API/connectMenu.sh "$dir/$selectedDB"
        else
            zenity --warning --text="No database selected."
            echo "$(date) - No database selected." >> "$logFile"
        fi
    fi
}

# Call the function
connectDatabase