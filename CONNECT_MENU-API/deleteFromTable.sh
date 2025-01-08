# Create Table Function 
# Abdelrahman Khaled 





deleteFromTable() {

      dbPath=$1  # Path to the database directory
      dir="$dbPath/TABLES/"
      
      # Get the list of tables in the directory
      tablesList=$(ls $dir)

      # Check if the directory contains files
      if [ -z "$tablesList" ]; then
          zenity --info --text="You don't have any Tables!"
          return
      fi

      # Display the tables in a clickable list
      deleteFromTable=$(zenity --list \
          --title="Your Tables" \
          --text="Select a Table:" \
          --column="Tables" $tablesList)

      # Check if a table was selected
      if [ -z "$deleteFromTable" ]; then
          zenity --warning --text="No table selected."
          return
      fi

      tablePath="$dbPath/TABLES/$deleteFromTable"

      # Verify that the selected table is correct
      zenity --info --text="You selected the Table: $deleteFromTable"

      # Read the schema (first row) from the table
      metaData=$(head -n 1 "$tablePath")
      
      # Extract the column names
      columns=()
      IFS=','  # Internal Field Separator
      for col in $metaData; do
          columns+=("$col")  # Add each column to the array
      done

      # Let the user select a column for deletion
      selectedColumn=$(zenity --list \
          --title="Select Column" \
          --text="Select a Column to Filter Rows for Deletion:" \
          --column="Columns" "${columns[@]}")

      # Check if a column was selected
      if [ -z "$selectedColumn" ]; then
          zenity --warning --text="No column selected for deletion filter."
          return
      fi

      # Prompt the user to enter the value to filter rows for deletion
      value=$(zenity --entry \
          --title="Enter Value" \
          --text="Enter the value for column '$selectedColumn' to filter rows for deletion:")

      # Validate if a value was entered
      if [ -z "$value" ]; then
          zenity --warning --text="No value entered for deletion filter."
          return
      fi

      # Get the column index based on the selected column name
      columnIndex=$(echo "$metaData" | awk -F',' -v col="$selectedColumn" '{
          for (i = 1; i <= NF; i++) {
              if ($i == col) {
                  print i;
                  exit;
              }
          }
      }')

      # Check if the column index was found
      if [ -z "$columnIndex" ]; then
          zenity --error --text="Selected column '$selectedColumn' does not exist in the table."
          return
      fi

      # Perform the deletion using awk
      awk -F',' -v col="$columnIndex" -v val="$value" 'NR == 1 || $col != val' "$tablePath" > temp && mv temp "$tablePath"

      # Confirm deletion
      zenity --info --text="Rows where column '$selectedColumn' equals '$value' have been deleted from the table '$deleteFromTable'."
}

# Call the function
deleteFromTable $1








# script without zenity

# deleteFromTable() {
#     dbPath=$1  # Path to the database directory
#     dir="$dbPath/TABLES/"
    
#     # Get the list of tables in the directory
#     tablesList=$(ls $dir)

#     # Check if the directory contains files
#     if [ -z "$tablesList" ]; then
#         echo "You don't have any Tables!"
#         return
#     fi

#     # Display the tables and ask the user to select one
#     echo "Available Tables:"
#     select deleteFromTable in $tablesList; do
#         if [ -n "$deleteFromTable" ]; then
#             break
#         else
#             echo "Invalid selection. Please try again."
#         fi
#     done

#     tablePath="$dbPath/TABLES/$deleteFromTable"

#     # Verify that the selected table is correct
#     echo "You selected the Table: $deleteFromTable"

#     # Read the schema (first row) from the table
#     metaData=$(head -n 1 "$tablePath")
    
#     # Extract the column names
#     columns=()
#     IFS=','  # Internal Field Separator
#     for col in $metaData; do
#         columns+=("$col")  # Add each column to the array
#     done

#     # Let the user select a column for deletion
#     echo "Available Columns:"
#     select selectedColumn in "${columns[@]}"; do
#         if [ -n "$selectedColumn" ]; then
#             break
#         else
#             echo "Invalid selection. Please try again."
#         fi
#     done

#     # Prompt the user to enter the value to filter rows for deletion
#     read -p "Enter the value for column '$selectedColumn' to filter rows for deletion: " value

#     # Validate if a value was entered
#     if [ -z "$value" ]; then
#         echo "No value entered for deletion filter."
#         return
#     fi

#     # Get the column index based on the selected column name
#     columnIndex=$(echo "$metaData" | awk -F',' -v col="$selectedColumn" '{
#         for (i = 1; i <= NF; i++) {
#             if ($i == col) {
#                 print i;
#                 exit;
#             }
#         }
#     }')

#     # Check if the column index was found
#     if [ -z "$columnIndex" ]; then
#         echo "Error: Selected column '$selectedColumn' does not exist in the table."
#         return
#     fi

#     # Perform the deletion using awk
#     awk -F',' -v col="$columnIndex" -v val="$value" 'NR == 1 || $col != val' "$tablePath" > temp && mv temp "$tablePath"

#     # Confirm deletion
#     echo "Rows where column '$selectedColumn' equals '$value' have been deleted from the table '$deleteFromTable'."
# }

# # Call the function
# deleteFromTable $1









