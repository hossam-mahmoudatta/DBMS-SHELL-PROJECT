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
        # Display the databases in a clickable list
        selectedTable=$(zenity --list --title="Your Tables" --text="Select a Table:" --column="Tables" $tablesList)

        # Check if a table was selected
        if [ -n "$selectedTable" ];
        then
            # Navigate to the next menu based on the selected database
            zenity --info --text="You selected the Table: $selectedTable"
        else
            zenity --warning --text="No database selected."
        fi
           
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
  