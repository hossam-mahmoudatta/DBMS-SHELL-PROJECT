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
        columns+=("$col")  # Add each column
    done

    # Initialize an empty string to hold the row data
    row=""

    # Iterate through each column and ask for the corresponding data value
    for col in "${columns[@]}";
    do
        # Extract column name and type (assuming the schema is in 'name:type' format)
        IFS=':' read -r colName colType <<< "$col"

        # Prompt the user for the value of the column
        value=$(zenity --entry --title="Enter Value for $colName" --text="Column: $colName, Data Type: $colType")

        # Validate the input based on column type
        case $colType in
            int)
                # Ensure the value is an integer
                if ! [[ $value =~ ^[0-9]+$ ]]; then
                    zenity --error --text="Invalid value for $colName. Expected an integer."
                    continue  # Skip the current iteration and ask again
                fi
                ;;
            float)
                # Ensure the value is a float
                if ! [[ $value =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
                    zenity --error --text="Invalid value for $colName. Expected a float."
                    continue
                fi
                ;;
            bool)
                # Ensure the value is either 'true' or 'false'
                if [[ $value != "true" && $value != "false" ]]; then
                    zenity --error --text="Invalid value for $colName. Expected 'true' or 'false'."
                    continue
                fi
                ;;
        esac

        # Add the value to the row data, separated by commas
        if [ -z "$row" ]; then
            row="$value"  # First value, no comma
        else
            row="$row,$value"  # Subsequent values, separated by commas
        fi
    done

    echo "$row" >> "$tableFile"  # Append the row data to the table file
    zenity --info --text="Data inserted successfully into the table."
    
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