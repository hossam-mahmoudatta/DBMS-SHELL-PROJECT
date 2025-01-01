# Created: 2025-01-01 15:00:00
# Created by Hossam

listDatabase() {
    dir="../DATABASES/"  # Replace with your directory path

    # Get the list of files in the directory
    databasesLists=$(ls "$dir")

    # Check if the directory contains files
    if [ -z "$databasesLists" ];
    then
        zenity --info --text="You don't have any databases!"
    else
        # Use Zenity to display the contents in a list
        zenity --list --title="Your Databases" --text="Here are your databases" --column="Items" $databasesLists
    fi
}

# Call the function
listDatabase