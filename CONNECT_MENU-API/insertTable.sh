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
    echo $metaData # Working till here
    
    # Read the current number of rows in the table (excluding metadata)
    currentRowCount=$(wc -l < "$tablePath")
    
    # Initialize an empty string to hold the row data
    row=""

    # Generate the new ID by incrementing the last ID
    if [ "$currentRowCount" -gt 1 ];
    then
        lastID=$(tail -n 1 "$tablePath" | cut -d',' -f1)  # Get the last ID in the table
        newID=$((lastID + 1))  # Increment the ID
    else
        newID=1  # If the table is empty, start from ID 1
    fi
    row=$newID

    columns=()  # Initialize the columns array
    IFS=','     # Internal field seperator understood by bash

    # Split the schema into columns
    for col in $metaData;
    do
        columns+=("$col")  # Add each column
    done


    # Iterate through each column and ask for the corresponding data value
    # Why columns[@]:1, because i will skip the first column which is the id
    # Which will be generated 
    for col in "${columns[@]:1}";
    do
        # Extract column name and type (assuming the schema is in 'name:type' format)
        IFS=':' read -r colName colType <<< "$col"

        # Prompt the user for the value of the column
        value=$(zenity --entry \
            --title="Enter Value for $colName" \
            --text="Column: $colName, Data Type: $colType")

        # Validate the input based on column type
        case $colType in
            int)
                # Ensure the value is an integer
                if ! [[ $value =~ ^[0-9]+$ ]];
                then
                    zenity --error --text="Invalid value for $colName. Expected an integer."
                    continue  # Skip the current iteration and ask again
                fi
                ;;
            float)
                # Ensure the value is a float
                if ! [[ $value =~ ^[0-9]+(\.[0-9]+)?$ ]];
                then
                    zenity --error --text="Invalid value for $colName. Expected a float."
                    continue
                fi
                ;;
            bool)
                # Ensure the value is either 'true' or 'false'
                if [[ $value != "true" && $value != "false" ]];
                then
                    zenity --error --text="Invalid value for $colName. Expected 'true' or 'false'."
                    continue
                fi
                ;;
        esac

        # Add the value to the row data, separated by commas
        if [ -z "$row" ];
        then
            row="$value"  # First value, no comma
        else
            row="$row,$value"  # Subsequent values, separated by commas
        fi
    done

    echo "$row" >> "$tablePath"  # Append the row data to the table file
    zenity --info --text="Data inserted successfully into the table."

    # Confirm the insertion
    zenity --info --text="Data inserted successfully with ID: $newID"
}

# Call the function 
insertTable $1