SelectTable() {
    dbPath=$1
    dir="$dbPath/TABLES"

    # Check if the tables directory exists
    if [ ! -d "$dir" ]; then
        zenity --error --text="The tables directory does not exist!"
        return
    fi

    # Get the list of tables in the directory
    TableLists=$(ls "$dir")
    if [ -z "$TableLists" ]; then
        zenity --info --text="You don't have any tables!"
        return
    fi

    # Display the tables in a clickable list
    selectedTable=$(zenity --list --title="Your Tables" --text="Select a Table:" --column="Tables" $TableLists)

    # Check if a table was selected
    if [ -n "$selectedTable" ]; then
        zenity --info --text="You selected the table: $selectedTable"

        # Extract columns from the selected table
        columns=$(head -n 1 "$dir/$selectedTable" | tr ',' '\n')

        # Prepare columns for zenity checklist format
        checklistOptions=$(echo "$columns" | awk '{print "FALSE", NR, $1}')

        # Display a checklist to select columns
        selectedColumns=$(zenity --list --checklist --title="Select Columns" --text="Select one or more columns:" \
            --column="Select" --column="Index" --column="Column Name" $checklistOptions)

        if [ -n "$selectedColumns" ]; then
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
                else
                    # Filter rows based on conditions
                    filteredData=$(awk -F, -v OFS=',' -v cols="$selectedColumns" 'BEGIN { split(cols, colArray, "|") } NR > 1 { 
                        if ('"$filterConditions"') { row=""; for (i in colArray) row = row $colArray[i] (i == length(colArray) ? "" : OFS); print row } 
                    }' "$dir/$selectedTable")
                fi

                # Display filtered data
                if [ -n "$filteredData" ]; then
                    zenity --info --text="Filtered Data:\n$header\n$filteredData"
                else
                    zenity --warning --text="No matching rows found."
                fi
            else
                # Select a specific number of rows
                # Remove the part asking for the number of rows
                zenity --info --text="Displaying all rows in the file: $selectedTable"

                # Use `cat` to display the entire file content
                allRows=$(cat "$dir/$selectedTable")
                zenity --info --text="File content:\n$allRows"

            fi
        else
            zenity --warning --text="No columns selected."
        fi
    else
        zenity --warning --text="No table selected."
    fi
}

# Call the function
SelectTable "$1"
