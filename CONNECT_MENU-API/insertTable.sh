# Insert into Table API 
# Hossam Mahmoud

#########################################################
#########################################################

# echo $(pwd)
# source ../CONNECT_MENU-API/pickTable.sh

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
        selectedTable=$(zenity --list \
            --title="Your Tables" \
            --text="Select a Table:" \
            --column="Tables" $tablesList)

        # Check if a table was selected
        if [ -n "$selectedTable" ];
        then
            # Navigate to the next menu based on the selected database
            zenity --info --text="You selected the Table: $selectedTable"
        else
            zenity --warning --text="No database selected."
        fi
    fi

    tablePath="$dbPath/TABLES/$selectedTable"
    
    # Verify that the selected table is correct
    echo you are in insertTable $tablePath

    # Read the schema (first row) from the table
    metaData=$(head -n 1 "$tablePath")
    echo $schema # Working till here

    # Extract column names (using comma as the separator)
    # Converts comma-separated metadata to newline-separated column names
    columns=$(echo "$metaData" | tr ',' '\n')
    
    # Read the current number of rows in the table (excluding metadata)
    currentRowCount=$(wc -l < "$tablePath")
    
    # Generate the new ID by incrementing the last ID
    if [ "$currentRowCount" -gt 1 ];
    then
        lastID=$(tail -n 1 "$tablePath" | cut -d',' -f1)  # Get the last ID in the table
        newID=$((lastID + 1))  # Increment the ID
    else
        newID=1  # If the table is empty, start from ID 1
    fi

    columns=()  # Initialize the columns array
    IFS=','     # Internal field seperator understood by bash

    # Split the schema into columns
    for col in $schema;
    do
        columns+=("$col")  # Add each part into the columns array
    done
    
    # Prompt for the rest of the data (excluding id)
    name=$(zenity --entry --title="Enter Data" --text="Enter the name:")
    age=$(zenity --entry --title="Enter Data" --text="Enter the age:")
    
    # Ensure that the inputs are valid
    if [[ -z "$name" || -z "$age" ]];
    then
        zenity --error --text="Invalid input. Name and age are required."
        return
    fi
    
    # Append the new row with the auto-generated ID
    echo "$newID,$name,$age" >> "$tablePath"
    
    # Confirm the insertion
    zenity --info --text="Data inserted successfully with ID: $newID"
}

# Call the function 
insertTable $1