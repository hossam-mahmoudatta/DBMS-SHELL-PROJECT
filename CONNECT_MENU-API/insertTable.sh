# Insert into Table API 
# Created: Hossam Mahmoud

#########################################################
#########################################################echo "Insert into Table API started" >> insertTable.log

# This API should allow us to insert into a table of our choice
insertTable() {
    dbPath=$1
    dir="$dbPath/TABLES/"

    logFile="../LOGS/insertTable.log"

    echo "Directory path: $dir" >> "$logFile"

    # Get the list of files in the directory but without the IDCounter files
    tablesList=$(ls $dir | grep -v '\_IDCounter')

    # Stores in a log file
    echo "Tables list: $tablesList" >> "$logFile"

    # Check if the directory contains files
    if [ -z "$tablesList" ];
    then
        zenity --info --text="You don't have any Tables!"
        echo "No tables found" >> "$logFile"
    else
        # Display the databases in a clickable list
        selectedTable=$(zenity --list \
            --title="Your Tables" \
            --text="Select a Table:" \
            --column="Tables" $tablesList)

        echo "Selected table: $selectedTable" >> "$logFile"

        # Check if a table was selected
        if [ -n "$selectedTable" ];
        then
            # Navigate to the next menu based on the selected database
            zenity --info --text="You selected the Table: $selectedTable"
        else
            zenity --error --text="No database selected."
            echo "No table selected" >> "$logFile"
            return
        fi
    fi

    tablePath="$dbPath/TABLES/$selectedTable"

    tableIDCounterPath="$dbPath/TABLES/${selectedTable}_IDCounter"

    # Verify that the selected table is correct
    echo you are in insertTable $tablePath
    echo "Table path: $tablePath" >> "$logFile"

    # Read the schema (first row) from the table
    metaData=$(head -n 1 "$tablePath")
    echo $metaData # Working till here
    echo "Metadata: $metaData" >> "$logFile"

    # Initialize an empty string to hold the row data
    row=""

    # Read the current ID from the counter file
    if [ -f "$tableIDCounterPath" ];
    then 
        currentID=$(cat "$tableIDCounterPath") 
    else
        currentID=0
    fi 

    echo "Current ID: $currentID" >> "$logFile"

    # Increment the ID
    newID=$((currentID + 1))

    echo "New ID: $newID" >> "$logFile"

    # Update the ID counter file 
    echo "$newID" > "$tableIDCounterPath"

    # Check for duplicate ID in the table
    if grep -q "^$newID," "$tablePath";
    then
        echo "Error: Duplicate ID detected"
        newID=$((newID + 1))
        # Update the ID counter file 
        echo "$newID" > "$tableIDCounterPath"
        echo "Duplicate ID detected, new ID: $newID" >> "$logFile"
    fi

    row=$newID

    columns=()  # Initialize the columns array
    IFS=','     # Internal field seperator understood by bash

    # Split the schema into columns
    for col in $metaData;
    do
        columns+=("$col")  # Add each column
    done

    echo "Columns: ${columns[@]}" >> "$logFile"

    # Iterate through each column and ask for the corresponding data value
    # Why columns[@]:1, because i will skip the first column which is the id
    # Which will be generated 
    for col in "${columns[@]:1}";
    do
        # Extract column name and type (assuming the schema is in 'name:type' format)
        IFS=':' read -r colName colType <<< "$col"

        echo "Column: $colName, Type: $colType" >> "$logFile"

        # Prompt the user for the value of the column
        value=$(zenity --entry \
            --title="Enter Value for $colName" \
            --text="Column: $colName, Data Type: $colType")

        echo "Value: $value" >> "$logFile"

        # If the user clicks "No", break the loop
        if [ $? -eq 1 ];
        then
            zenity --error --text="No value was entered."
            echo "No value entered" >> "$logFile"
            echo "$currentID" > "$tableIDCounterPath"
            return
        fi

        # Validate the input based on column type
        case $colType in
            int)
                # Ensure the value is an integer
                if ! [[ $value =~ ^[0-9]+$ ]];
                then
                    zenity --error --text="Invalid value for $colName. Expected an integer."
                    echo "Invalid value for $colName" >> "$logFile"
                    continue  # Skip the current iteration and ask again
                fi
                ;;
            float)
                # Ensure the value is a float
                if ! [[ $value =~ ^[0-9]+(\.[0-9]+)?$ ]];
                then
                    zenity --error --text="Invalid value for $colName. Expected a float."
                    echo "Invalid value for $colName" >> "$logFile"
                    continue
                fi
                ;;
            bool)
                # Ensure the value is either 'true' or 'false'
                if [[ $value != "true" && $value != "false" ]];
                then
                    zenity --error --text="Invalid value for $colName. Expected 'true' or 'false'."
                    echo "Invalid value for $colName" >> "$logFile"
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
    echo "Data inserted successfully into the table." >> "$logFile"
    zenity --info --text="Data inserted successfully into the table."

    # Confirm the insertion
    zenity --info --text="Data inserted successfully with ID: $newID"
    echo "Data inserted successfully with ID: $newID" >> "$logFile"
}


# Call the function 
insertTable $1









# This is the code without logs
# # This API should allow us to insert into a table of our choice
# insertTable() {
#     dbPath=$1
#     dir="$dbPath/TABLES/"

#     # Get the list of files in the directory but without the IDCounter files
#     tablesList=$(ls $dir | grep -v '\_IDCounter')


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
#             zenity --error --text="No database selected."
#             return
#         fi
#     fi

#     tablePath="$dbPath/TABLES/$selectedTable"

#     tableIDCounterPath="$dbPath/TABLES/${selectedTable}_IDCounter"

#     # Verify that the selected table is correct
#     echo you are in insertTable $tablePath

#     # Read the schema (first row) from the table
#     metaData=$(head -n 1 "$tablePath")
#     echo $metaData # Working till here
    
#     # Initialize an empty string to hold the row data
#     row=""
    
#     # Read the current ID from the counter file
#     if [ -f "$tableIDCounterPath" ];
#     then 
#         currentID=$(cat "$tableIDCounterPath") 
#     else
#         currentID=0
#     fi 
    
#     # Increment the ID
#     newID=$((currentID + 1))
    
#     # Update the ID counter file 
#     echo "$newID" > "$tableIDCounterPath"
    
#     # Check for duplicate ID in the table
#     if grep -q "^$newID," "$tablePath";
#     then
#         echo "Error: Duplicate ID detected"
#         newID=$((newID + 1))
#         # Update the ID counter file 
#         echo "$newID" > "$tableIDCounterPath"
#     fi
    
#     row=$newID

#     columns=()  # Initialize the columns array
#     IFS=','     # Internal field seperator understood by bash

#     # Split the schema into columns
#     for col in $metaData;
#     do
#         columns+=("$col")  # Add each column
#     done


#     # Iterate through each column and ask for the corresponding data value
#     # Why columns[@]:1, because i will skip the first column which is the id
#     # Which will be generated 
#     for col in "${columns[@]:1}";
#     do
#         # Extract column name and type (assuming the schema is in 'name:type' format)
#         IFS=':' read -r colName colType <<< "$col"

#         # Prompt the user for the value of the column
#         value=$(zenity --entry \
#             --title="Enter Value for $colName" \
#             --text="Column: $colName, Data Type: $colType")

#         # If the user clicks "No", break the loop
#         if [ $? -eq 1 ];
#         then
#             zenity --error --text="No value was entered."
#             echo "$currentID" > "$tableIDCounterPath"
#             return
#         fi

#         # Validate the input based on column type
#         case $colType in
#             int)
#                 # Ensure the value is an integer
#                 if ! [[ $value =~ ^[0-9]+$ ]];
#                 then
#                     zenity --error --text="Invalid value for $colName. Expected an integer."
#                     continue  # Skip the current iteration and ask again
#                 fi
#                 ;;
#             float)
#                 # Ensure the value is a float
#                 if ! [[ $value =~ ^[0-9]+(\.[0-9]+)?$ ]];
#                 then
#                     zenity --error --text="Invalid value for $colName. Expected a float."
#                     continue
#                 fi
#                 ;;
#             bool)
#                 # Ensure the value is either 'true' or 'false'
#                 if [[ $value != "true" && $value != "false" ]];
#                 then
#                     zenity --error --text="Invalid value for $colName. Expected 'true' or 'false'."
#                     continue
#                 fi
#                 ;;
#         esac

#         # Add the value to the row data, separated by commas
#         if [ -z "$row" ];
#         then
#             row="$value"  # First value, no comma
#         else
#             row="$row,$value"  # Subsequent values, separated by commas
#         fi
#     done

#     echo "$row" >> "$tablePath"  # Append the row data to the table file
#     zenity --info --text="Data inserted successfully into the table."

#     # Confirm the insertion
#     zenity --info --text="Data inserted successfully with ID: $newID"
# }