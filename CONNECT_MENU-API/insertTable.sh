# Insert into Table API 
# Hossam Mahmoud

#########################################################
#########################################################

# This API should allow us to insert into a table of our choice
insertTable() {
    dbPath=$1
    dir="$dbPath/TABLES/"
    # Get the list of files in the directory
    tablesList=$(ls $dir)

    # Check if the directory contains files
    if [ -z "$tablesList" ];
    then
        zenity --info --text="You don't have any Tables!"
    else
        # Use Zenity to display the contents in a list
        zenity --list --title="Your Tables" --text="Here are your Tables" --column="Items" $tablesList
    fi
    # Define the database path
    dbPath=$1

    # Display a Zenity input box to ask for the table name
    tableName=$(zenity --entry --title="Drop Table" --text="Enter Table Name:")

    # If the user cancels the input box, exit the function
    if [ -z "$tableName" ]; then
        zenity --info --title="Drop Table" --text="No table name entered!"
        return
    fi



    # Construct the full path to the table
  tablePath="$dbPath/TABLES/$tableName.meta"

    # Debugging output
    echo "Table path: $tablePath"

    # Check if the table exists
    if [ -f "$tablePath" ]; then

        # Confirm if you really want to delete the table
        zenity --question --title="Confirm Deletion" \
            --text="Are you sure you want to delete the $tableName table?" \
            --ok-label="Yes" --cancel-label="No"
        
        # If the user clicks "No", cancel the deletion
        if [ $? -ne 0 ]; then
            zenity --info --title="Drop Table" --text="Table $tableName not deleted."
            return
        fi

        # Delete the table
        rm "$tablePath"
        zenity --info --title="Drop Table" --text="Table $tableName deleted successfully."
    else
        zenity --error --title="Drop Table" --text="Table $tableName not found."
    fi
}

# Call the function 
insertTable $1



connectDatabase() {
    # Replace with your directory path
    dir="../DATABASES"
    # currentDIR=$(dirname "$0")

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







  