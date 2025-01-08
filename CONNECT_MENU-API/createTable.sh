# Create Table Function 
# Created: Abdelrahman Khaled 
# Modified: Hossam Mahmoud

createTable() {
    # Ensure tables are stored in a dedicated folder
    dbPath=$1
    mkdir -p ../DATABASES/$dbPath/TABLES
    
    logFile="../LOGS/createTable.log"
    echo "$(date) - Created tables folder in $dbPath" >> "$logFile"

    # This loop checks if the table name is valid, and if it already exists or not.
    while true;
    do
    # Prompt for the table name using Zenity
    tableName=$(zenity --entry \
        --title="Table Name" \
        --text="Enter table name:")
    # If the user clicks Cancel, go back to the menu
    if [ $? -eq 1 ];
    then
        zenity --info --text="Table Creation Canceled!"
        echo "$(date) - Table creation canceled" >> "$logFile"
        return
    fi

    # If the user cancels the input, exit the loop
    if [ -z "$tableName" ];
    then
        zenity --warning \
            --text="Table name cannot be empty. Please try again."
        echo "$(date) - Empty table name" >> "$logFile"
        continue
    fi

    # Validate table name (no spaces or special characters)
    if [[ ! "$tableName" =~ ^[a-zA-Z0-9_]+$ ]];
    then
        zenity --error \
            --text="Invalid table name. Only alphanumeric characters and underscores are allowed."
        echo "$(date) - Invalid table name" >> "$logFile"
        continue
    fi

    # Check if the table already exists
    tablePath="$dbPath/TABLES/$tableName"

    if [ -f "$tablePath" ];
    then
        zenity --error \
            --text="Table '$tableName' already exists. Please choose a different name."
        echo "$(date) - Table already exists" >> "$logFile"
        continue
    fi
    echo "$(date) - Valid table name: $tableName" >> "$logFile"
    break
    done


    # Keep prompting for columns until the user decides to stop
    while true;
    do
    # Ask for the column name
    columnName=$(zenity --entry \
        --title="Column Name" \
        --text="Enter the name of the column:")

    # If the user clicks Cancel, go back to the menu
    if [ $? -eq 1 ];
    then
        zenity --info \
            --text="Table Fields Creation Canceled!"
        echo "$(date) - Table fields creation canceled" >> "$logFile"
        return
    fi

    # If no column name is entered, stop the process
    if [ -z "$columnName" ];
    then
        zenity --error \
            --text="Column name cannot be empty. Please try again."
        echo "$(date) - Empty column name" >> "$logFile"
        continue
    fi

    # Ask for the data type
    columnType=$(zenity --list \
        --title="Select Data Type" \
        --text="Choose a data type for '$columnName':" \
        --column="Data Types" \
        "int" "varchar" "float" "bool")

    # If the user clicks Cancel, go back to the menu
    if [ $? -eq 1 ];
    then
        zenity --info \
            --text="Data Types Selection Canceled!"
        echo "$(date) - Data types selection canceled" >> "$logFile"
        return
    fi

    # If no data type is selected, show an error
    if [ -z "$columnType" ];
    then
        zenity --error \
            --text="You must select a data type. Please try again."
        echo "$(date) - No data type selected" >> "$logFile"
        continue
    fi

    # Add the column to the schema
    if [ -z "$schema" ];
    then
        # If its the first column
        schema="$columnName:$columnType"
    else
        # If its not the first column
        schema="$schema,$columnName:$columnType"
    fi
    echo "$(date) - Added column: $columnName:$columnType" >> "$logFile"

    # Ask if the user wants to add another column
    addAnother=$(zenity --question \
        --title="Add Another Column?" \
        --text="Do you want to add another column?" \
        --ok-label="Yes" --cancel-label="No")

    # If the user clicks "No", break the loop
    if [ $? -eq 1 ];
    then
        echo "$(date) - No more columns" >> "$logFile"
        break
    fi
    done

    tableIDCounterPath="$dbPath/TABLES/${tableName}_IDCounter"

    # Save the schema to the table file
    echo "$schema" > "$tablePath"
    echo 0 > "$tableIDCounterPath"
    echo "$(date) - Table metadata created successfully: $schema" >> "$logFile"

    zenity --info \
        --text="Table Metadata created successfully: $schema"
}

# call the Function
createTable $1
