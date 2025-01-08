# Created: Zeyad Tarek

selectTable() {
    dbPath=$1
    dir="$dbPath/TABLES"

    logFile="../LOGS/selectFromTable.log"

    # Check if the tables directory exists
    if [ ! -d "$dir" ];
    then
        zenity --error --text="The tables directory does not exist!"
        echo "$(date) - Error: The tables directory does not exist!" >> "$logFile"
        return
    fi

    # Get the list of files in the directory but without the IDCounter files
    tablesList=$(ls $dir | grep -v '\_IDCounter')
    if [ -z "$tablesList" ];
    then
        zenity --info --text="You don't have any tables!"
        echo "$(date) - Info: No tables found." >> "$logFile"
        return
    fi

    # Display the tables in a clickable list
    selectedTable=$(zenity --list \
        --title="Your Tables" \
        --text="Select a Table:" \--column="Tables" $tablesList)

    # Check if a table was selected
    if [ -n "$selectedTable" ];
    then
        zenity --info --text="You selected the table: $selectedTable"
        echo "$(date) - Info: Selected table: $selectedTable" >> "$logFile"

        # Extract columns from the selected table
        columns=$(head -n 1 "$dir/$selectedTable" | tr ',' '\n')

        # Prepare columns for zenity checklist format
        checklistOptions=$(echo "$columns" | awk '{print "FALSE", NR, $1}')

        # Display a checklist to select columns
        selectedColumns=$(zenity --list --checklist --title="Select Columns" --text="Select one or more columns:" \
            --column="Select" --column="Index" --column="Column Name" $checklistOptions)

        if [ -n "$selectedColumns" ]; then
            echo "$(date) - Info: Selected columns: $selectedColumns" >> "$logFile"

            # Ask the user to specify a filter for rows or the number of rows
            filterType=$(zenity --list --radiolist --title="Filter Rows" --text="How would you like to filter the rows?" \
                --column="Select" --column="Filter Type" TRUE "Filter by Column Values" FALSE "View all rows")

            if [ "$filterType" == "Filter by Column Values" ]; then
                # Initialize filter conditions
                filterConditions=""
                IFS='|' read -r -a columnArray <<< "$selectedColumns"

                for columnIndex in "${columnArray[@]}"; do
                    columnName=$(echo "$columns" | sed -n "${columnIndex}p")
                    filterValue=$(zenity --entry --title="Filter Rows" --text="Enter value for column '$columnName':")
                    if [ -n "$filterValue" ]; then
                        filterConditions+="\$$columnIndex == \"$filterValue\" && "
                        echo "$(date) - Info: Filter condition added: $columnName == $filterValue" >> "$logFile"
                    fi
                done

                # Trim trailing '&&'
                filterConditions=${filterConditions%&& }

                # Extract and filter rows
                header=$(head -n 1 "$dir/$selectedTable")

                if [ -z "$filterConditions" ]; then
                    # Extract all rows if no filter conditions are provided
                    filteredData=$(awk -F, -v OFS=',' -v cols="$selectedColumns" 'BEGIN { split(cols, colArray, "|") } NR > 1 { 
                        row=""; for (i in colArray) row = row $colArray[i] (i == length(colArray) ? "" : OFS); print row 
                    }' "$dir/$selectedTable")
                    echo "$(date) - Info: All rows extracted." >> "$logFile"
                else
                    # Filter rows based on conditions
                    filteredData=$(awk -F, -v OFS=',' -v cols="$selectedColumns" 'BEGIN { split(cols, colArray, "|") } NR > 1 { 
                        if ('"$filterConditions"') { row=""; for (i in colArray) row = row $colArray[i] (i == length(colArray) ? "" : OFS); print row } 
                    }' "$dir/$selectedTable")
                    echo "$(date) - Info: Rows filtered based on conditions: $filterConditions" >> "$logFile"
                fi

                # Display filtered data
                if [ -n "$filteredData" ]; then
                    zenity --info --text="Filtered Data:\n$header\n$filteredData"
                    echo "$(date) - Info: Filtered data displayed." >> "$logFile"
                else
                    zenity --warning --text="No matching rows found."
                    echo "$(date) - Warning: No matching rows found." >> "$logFile"
                fi
            else
                # Select a specific number of rows
                # Remove the part asking for the number of rows
                zenity --info --text="Displaying all rows in the file: $selectedTable"
                echo "$(date) - Info: All rows displayed." >> "$logFile"

                # Use `cat` to display the entire file content
                allRows=$(cat "$dir/$selectedTable")
                zenity --info --text="File content:\n$allRows"
                echo "$(date) - Info: File content displayed." >> "$logFile"

            fi
        else
            zenity --warning --text="No columns selected."
            echo "$(date) - Warning: No columns selected." >> "$logFile"
        fi
    else
        zenity --warning --text="No table selected."
        echo "$(date) - Warning: No table selected." >> "$logFile"
    fi
}

# Call the function
selectTable "$1"
