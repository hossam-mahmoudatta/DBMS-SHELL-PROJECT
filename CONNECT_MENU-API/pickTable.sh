# Pick from a Table API 
# Hossam Mahmoud

#########################################################
#########################################################

# This API should allow us to view our tables and
# pick from it to allow further processing
pickTable() {
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
            return $selectedTable
        else
            zenity --warning --text="No database selected."
        fi
    fi
}

# Call the function 
pickTable $1

