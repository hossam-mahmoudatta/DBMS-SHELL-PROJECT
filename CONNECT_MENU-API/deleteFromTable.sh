# Create Table Function 
# Abdelrahman Khaled 

<<<<<<< HEAD




=======
>>>>>>> origin/main
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












# deleteFromTable() {

#   local dbPath=$1       # Path to the table (file)
#   local column_name=$2   # Column name to check for deletion
#   local value=$3         # Value to match in the column for deletion

#   # Sanity check: Ensure all required arguments are provided
#   if [[ -z "$dbPath" || -z "$column_name" || -z "$value" ]]; then
#     echo "Error: Missing required arguments. Usage: deleteFromTable <dbPath> <column_name> <value>"
#     return 1
#   fi

#   # Check if the table (file) exists
#   if [[ ! -f "$dbPath" ]]; then
#     echo "Error: Table '$dbPath' not found."
#     return 1
#   fi

#   # Ensure the file is readable
#   if [[ ! -r "$dbPath" ]]; then
#     echo "Error: Cannot read the table '$dbPath'. Check file permissions."
#     return 1
#   fi

#   # Ensure the file is writable
#   if [[ ! -w "$dbPath" ]]; then
#     echo "Error: Cannot write to the table '$dbPath'. Check file permissions."
#     return 1
#   fi

#   # Extract the header row (first line)
#   local header=$(head -n 1 "$dbPath")

#   # Sanity check: Ensure the header exists
#   if [[ -z "$header" ]]; then
#     echo "Error: Table '$dbPath' is empty or malformed."
#     return 1
#   fi

#   # Find the column number based on the column name
#   local column_number=$(echo "$header" | awk -F',' -v col="$column_name" '{
#       for (i = 1; i <= NF; i++) {
#           if ($i == col) {
#               print i;
#               exit;
#           }
#       }
#       exit 1; # Exit with an error code if the column is not found
#   }')

#   # Check if the column was found
#   if [[ -z $column_number ]]; then
#     echo "Error: Column '$column_name' does not exist in the table."
#     return 1
#   fi

#   # Perform the deletion (excluding the header row)
#   awk -F',' -v col="$column_number" -v val="$value" 'NR == 1 || $col != val' "$dbPath" > temp && mv temp "$dbPath"

#   echo "Rows with column '$column_name' matching '$value' have been deleted from '$dbPath'."
# }

# deleteFromTable $1 $2 $3











# deleteFromTable(){

#   local dbPath=$1
#   local column_name=$2
#   local value=$3

#   #check if the table exists

#   if [[ ! -f "$dbPath" ]]; then
#     echo "Table not found"
#     return 1
#   fi


#   local header=$(head -n 1 "$dbPath")

#     # Find the column number based on the column name
#     local column_number=$(echo "$header" | awk -F',' -v col="$column_name" '{
#         for (i = 1; i <= NF; i++) {
#             if ($i == col) {
#                 print i;
#                 exit;
#             }
#         }
#         exit 1; # Exit with an error code if the column is not found
#     }')

#     # Check if the column was found
#     if [[ -z $column_number ]]; then
#         echo "Error: Column '$column_name' does not exist in the table."
#         return 1
#     fi

#     # prefom the deletion
#     awk -F',' -v col="$column_number" -v val="$value" 'NR == 1 || $col != val' "$dbPath" > temp && mv temp "$dbPath"


#     echo "Rows with column '$column_name' matching '$value' have been deleted from '$dbPath'."


# }