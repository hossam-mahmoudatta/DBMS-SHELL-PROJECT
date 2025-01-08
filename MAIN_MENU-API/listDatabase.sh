# Created: 2025-01-01 15:00:00
# Created by Hossam

listDatabase() {

    logFile="../LOGS/listDatabase.log"
    dir="../DATABASES/"

    # Get the list of files in the directory
    databasesLists=$(ls "$dir")

    # Check if the directory contains files
    if [ -z "$databasesLists" ];
    then
        echo "$(date) - No databases found." >> "$logFile"
        zenity --info --text="You don't have any databases!"
    else
        echo "$(date) - Databases found: $databasesLists" >> "$logFile"
        # Use Zenity to display the contents in a list
        zenity --list \
        --title="Your Databases" \
        --text="Here are your databases" \
        --column="Items" $databasesLists
    fi
}

# Call the function
listDatabase