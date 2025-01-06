# Update into Table API 
# Created: Hossam Mahmoud

#########################################################
#########################################################

# This API should allow us to update any field inside the table
updateTable() {

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
            return
        fi
    fi

    tablePath="$dbPath/TABLES/$selectedTable"
    
    # Verify that the selected table is correct
    echo you are in insertTable $tablePath

    # Read the schema (first row) from the table
    metaData=$(head -n 1 "$tablePath")
    echo $metaData  # Debugging: Output the schema
    
    # Read all the rows (excluding the schema) into an array
    rows=$(tail -n +2 "$tablePath")
    
    # Get the column names from the schema (assuming 'name:type' format)
    columns=()
    IFS=','  # Internal Field Separator (IFS) set to comma to split schema by columns
    for col in $metaData;
    do
        columns+=("$col")  # Add each column to the array
    done

    # This will loop untill correct row id is entered
    while true;
    do
        # Ask for the ID of the row to update
        rowID=$(zenity --entry \
            --title="Enter Row ID" \
            --text="Enter the ID of the row you want to update:")
        if [ $? -eq 1 ];
        then
        zenity --info --text="Update Canceled!"
        return
        fi

        # Find the row by ID (excluding the schema line)
        rowToUpdate=$(grep "^$rowID," "$tablePath")

        # If no row is found, show an error
        if [ -z "$rowToUpdate" ];
        then
            zenity --error --text="Row with ID $rowID not found. Try again"
            continue
        fi
        break
    done


    # Display the row to update
    zenity --info --text="You selected the following row to update:\n$rowToUpdate"

    # Ask the user which column to update
    selectedColumn=$(zenity --list \
        --title="Select Column to Update" \
        --text="Select a column to update:" \
        --column="Columns" "${columns[@]:1}")  # Skip the first column (ID)
    if [ $? -eq 1 ];
    then
        zenity --info --text="User Canceled!"
        return
    fi

    # Ask for the new value for the selected column
    newValue=$(zenity --entry \
        --title="Enter New Value" \
        --text="Enter the new value for column '$selectedColumn':")
    
    if [ $? -eq 1 ];
    then
        zenity --info --text="Column Update Canceled!"
        return
    fi

    # Find the index of the selected column
    columnIndex=-1
    for i in "${!columns[@]}";
    do
        if [ "${columns[$i]%%:*}" == "$selectedColumn" ];
        then
            columnIndex=$i
            break
        fi
    done


    # Extract the current row and update the column value
    IFS=',' read -r -a rowArray <<< "$rowToUpdate"  # Split row into array
    rowArray[$columnIndex]="$newValue"  # Update the value for the selected column (skip ID)

    # Rebuild the updated row as a comma-separated string
    updatedRow=$(IFS=,; echo "${rowArray[*]}")

    # Replace the old row with the updated row in the table
    # Use sed to update the row in the file
    sed -i "s/^$rowID,.*/$updatedRow/" "$tablePath"

    zenity --info --text="Row with ID $rowID updated successfully."
}

# Call the function
updateTable "$1"
