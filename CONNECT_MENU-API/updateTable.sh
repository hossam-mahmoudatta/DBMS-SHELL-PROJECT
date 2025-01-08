# Update into Table API 
# Created: Hossam Mahmoud

#########################################################
#########################################################

# This API should allow us to update any field inside the table
updateTable() {
    dbPath=$1
    dir="$dbPath/TABLES/"

    # Verify the directory exists
    if [ ! -d "$dir" ]; then
        zenity --error --text="Error: Directory '$dir' does not exist."
        return
    fi

    # Get the list of files in the directory but without the IDCounter files
    tablesList=$(ls $dir | grep -v '\_IDCounter')
    if [ -z "$tablesList" ]; then
        zenity --info --text="No tables found in the directory."
        return
    fi

    # Select a table
    selectedTable=$(zenity --list \
        --title="Select a Table" \
        --text="Available Tables:" \
        --column="Tables" $tablesList)
    if [ -z "$selectedTable" ]; then
        zenity --warning --text="No table selected."
        return
    fi

    tablePath="$dir/$selectedTable"
    if [ ! -f "$tablePath" ]; then
        zenity --error --text="Error: Table file '$tablePath' not found."
        return
    fi

    # Read the schema
    metaData=$(head -n 1 "$tablePath" 2>/dev/null)
    if [ -z "$metaData" ]; then
        zenity --error --text="Error: Table schema not found."
        return
    fi

    # Split schema into columns
    IFS=',' read -ra columns <<< "$metaData"

    # Extract column names without types
    columnNames=()
    for col in "${columns[@]}";
    do
        columnName="${col%%:*}"  # Extract everything before the ':'
        columnNames+=("$columnName")
    done

    # Select a row to update
    while true;
    do
        rowID=$(zenity --entry \
            --title="Enter Row ID" \
            --text="Enter the ID of the row to update:")
        if [ $? -ne 0 ];
        then
            zenity --info --text="Update canceled."
            return
        fi

        rowToUpdate=$(grep "^$rowID," "$tablePath" 2>/dev/null)
        if [ -z "$rowToUpdate" ]; then
            zenity --error --text="Row with ID '$rowID' not found. Try again."
        else
            break
        fi
    done

    zenity --info --text="Row to update:\n$rowToUpdate"

    while true;
    do
        # Select a column to update (including all columns)
        selectedColumn=$(zenity --list \
            --title="Select Column" \
            --text="Select a column to update:" \
            --column="Columns" "${columnNames[@]}")
        if [ -z "$selectedColumn" ];
        then
            zenity --error --text="No column selected."
            return
        fi
        # Prevent updating the ID column
        if [ "$selectedColumn" == "${columnNames[0]}" ];
        then
            zenity --error --text="You aren't authorized to update the ID column."
            continue
        fi
        break
    done

    # Find column index
    columnIndex=-1
    for i in "${!columnNames[@]}"; do
        if [[ "${columnNames[$i]}" == "$selectedColumn" ]]; then
            columnIndex=$i
            break
        fi
    done

    if [ "$columnIndex" -eq -1 ]; then
        zenity --error --text="Error: Column not found in schema."
        return
    fi

    # Prompt for new value
    newValue=$(zenity --entry \
        --title="Enter New Value" \
        --text="Enter the new value for column '$selectedColumn':")
    if [ -z "$newValue" ];
    then
        zenity --warning --text="No value entered."
        return
    fi

    # Update the row
    tempFile=$(mktemp)
    awk -F',' -v rowID="$rowID" -v \
        colIndex="$((columnIndex + 1))" \
        -v newValue="$newValue" \
        'BEGIN { OFS = "," }
         $1 == rowID { $colIndex = newValue }
         { print }' "$tablePath" > "$tempFile"

    if mv "$tempFile" "$tablePath";
    then
        zenity --info --text="Row updated successfully!"
    else
        zenity --error --text="Error updating the table."
    fi
}


# Call the function
updateTable "$1"















# updateTable() {

# dbPath=$1
#     dir="$dbPath/TABLES/"
#     # Get the list of files in the directory
#     tablesList=$(ls $dir)

#     # Check if the directory contains files
#     if [ -z "$tablesList" ];
#     then
#         zenity --info --text="You don't have any Tables!"
#     else
#         # Display the databases in a clickable list
#         selectedTable=$(zenity --list \
#             --title="Your Tables" \
#             --text="Select a Table:" \
#             --column="Tables" $tablesList)

#         # Check if a table was selected
#         if [ -n "$selectedTable" ];
#         then
#             # Navigate to the next menu based on the selected database
#             zenity --info --text="You selected the Table: $selectedTable"
#         else
#             zenity --warning --text="No database selected."
#             return
#         fi
#     fi

#     tablePath="$dbPath/TABLES/$selectedTable"
    
#     # Verify that the selected table is correct
#     echo you are in insertTable $tablePath

#     # Read the schema (first row) from the table
#     metaData=$(head -n 1 "$tablePath")
#     echo $metaData  # Debugging: Output the schema
    
#     # Read all the rows (excluding the schema) into an array
#     rows=$(tail -n +2 "$tablePath")
    
#     # Get the column names from the schema (assuming 'name:type' format)
#     columns=()
#     IFS=','  # Internal Field Separator (IFS) set to comma to split schema by columns
#     for col in $metaData;
#     do
#         columns+=("$col")  # Add each column to the array
#     done

#     # This will loop untill correct row id is entered
#     while true;
#     do
#         # Ask for the ID of the row to update
#         rowID=$(zenity --entry \
#             --title="Enter Row ID" \
#             --text="Enter the ID of the row you want to update:")
#         if [ $? -eq 1 ];
#         then
#             zenity --info --text="Update Canceled!"
#             return
#         fi

#         # Find the row by ID (excluding the schema line)
#         rowToUpdate=$(grep "^$rowID," "$tablePath")

#         # If no row is found, show an error
#         if [ -z "$rowToUpdate" ];
#         then
#             zenity --error --text="Row with ID $rowID not found. Try again"
#             continue
#         fi
#         break
#     done


#     # Display the row to update
#     zenity --info --text="You selected the following row to update:\n$rowToUpdate"

#     # Ask the user which column to update (excluding the ID column)
#     columnNames=("${columns[@]:1}")  # Exclude the ID column
#     selectedColumn=$(zenity --list \
#         --title="Select Column to Update" \
#         --text="Select a column to update:" \
#         --column="Columns" "${columnNames[@]}")
#     if [ $? -eq 1 ];
#     then
#         zenity --info --text="User Canceled!"
#         return
#     fi
#     if [ -z "$selectedColumn" ];
#     then
#         zenity --warning --text="No column selected."
#         return
#     fi

#     # Find the index of the selected column
#     columnIndex=-1
#     for i in "${!columns[@]}";
#     do
#         if [ "${columns[$i]%%:*}" == "$selectedColumn" ];
#         then
#             columnIndex=$i
#             break
#         fi
#     done

#     if [ "$columnIndex" -eq -1 ];
#     then
#         zenity --error --text="Error: Column index not found."
#         return
#     fi

#     # Ask for the new value
#     newValue=$(zenity --entry \
#         --title="Enter New Value" \
#         --text="Enter the new value for column '$selectedColumn':")
#     if [ $? -eq 1 ];
#     then
#         zenity --info --text="Column Update Canceled!"
#         return
#     fi

#     # Update the selected row
#     updatedRow=$(awk -F',' -v rowID="$rowID" -v colIndex="$((columnIndex + 1))" -v newValue="$newValue" \
#     'BEGIN { OFS = "," } $1 == rowID { $colIndex = newValue } { print }' "$tablePath")

#     # # Update the selected row
#     # updatedRow=$(awk -F',' -v rowID="$rowID" -v colIndex="$columnIndex" -v newValue="$newValue" \
#     # 'BEGIN { OFS = "," } $1 == rowID { $colIndex = newValue } { print }' "$tablePath")

#     # Write the updated row back to the file
#     echo "$updatedRow" > "$tablePath"
    
#     zenity --info --text="Row with ID $rowID updated successfully."
# }

# # Call the function
# updateTable "$1"

