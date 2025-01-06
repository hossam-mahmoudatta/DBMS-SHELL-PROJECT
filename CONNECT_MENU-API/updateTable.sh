# Update into Table API 
# Created: Hossam Mahmoud

#########################################################
#########################################################

# This API should allow us to update any field inside the table
updateTable() {
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

        # Prepare the columns for zenity --checklist format
        checklistOptions=$(echo "$columns" | awk '{print "FALSE", NR, $1}')

        # Display a checklist to select columns
        selectedColumns=$(zenity --list \
            --checklist \
            --title="Select Columns" \
            --text="Select one or more columns:" \
            --column="Select" --column="Index" --column="Column Name" $checklistOptions)

        if [ -n "$selectedColumns" ]; then
            # Ask the user to specify a filter for the rows or the number of rows
            filterType=$(zenity --list \
                --radiolist \
                --title="Filter Rows" \
                --text="How would you like to filter the rows?" \
                --column="Select" --column="Filter Type" \
                TRUE "Filter by Column Values" \
                FALSE "Select Number of Rows")

            if [ "$filterType" == "Filter by Column Values" ]; then
                # Initialize filter conditions
                filterConditions=""

                # Split selectedColumns into individual columns
                IFS='|' read -r -a columnArray <<< "$selectedColumns"

                for columnIndex in "${columnArray[@]}"; do
                    columnName=$(echo "$columns" | sed -n "${columnIndex}p")
                    filterValue=$(zenity --entry --title="Filter Rows" --text="Enter value for column '$columnName':")

                    # If the user enters a value, add it to the filter conditions
                    if [ -n "$filterValue" ]; then
                        filterConditions+="\$$columnIndex == \"$filterValue\" && "
                    fi
                done

                # Trim trailing '&&'
                filterConditions=${filterConditions%&& }

                # Extract header and filter rows
                header=$(head -n 1 "$dir/$selectedTable")

                # Get column indices for the selected columns
                selectedColumnIndices=()
                IFS='|' read -r -a columnArray <<< "$selectedColumns"
                for columnIndex in "${columnArray[@]}"; do
                    selectedColumnIndices+=($(echo "$columns" | sed -n "${columnIndex}p"))
                done

                # If filterConditions is empty, it means user left values blank
                if [ -z "$filterConditions" ]; then
                    # Extract all rows, as the filter conditions are empty
                    filteredData=$(awk -F, -v OFS=',' -v cols="$selectedColumns" 'BEGIN { split(cols, colArray, "|") }
                    NR == 1 { next }
                    {
                        row = ""
                        for (i in colArray) {
                            row = row $colArray[i] (i == length(colArray) ? "" : OFS)
                        }
                        print row
                    }' "$dir/$selectedTable")
                else
                    # Filter rows based on the condition
                    filteredData=$(awk -F, -v OFS=',' -v cols="$selectedColumns" 'BEGIN { split(cols, colArray, "|") }
                    NR == 1 { next }
                    {
                        if ('"$filterConditions"') {
                            row = ""
                            for (i in colArray) {
                                row = row $colArray[i] (i == length(colArray) ? "" : OFS)
                            }
                            print row
                        }
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
                numRows=$(zenity --entry \
                    --title="Number of Rows" \
                    --text="Enter the number of rows to display:")

                if [[ "$numRows" =~ ^[0-9]+$ ]]; then
                    selectedRows=$(head -n "$((numRows + 1))" "$dir/$selectedTable")
                    zenity --info --text="Selected rows:\n$selectedRows"
                else
                    zenity --error --text="Invalid number of rows entered."
                fi
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
