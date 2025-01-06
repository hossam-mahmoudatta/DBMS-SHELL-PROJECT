# Create Table Function 
# Abdelrahman Khaled 













deleteFromTable() {

  local dbPath=$1       # Path to the table (file)
  local column_name=$2   # Column name to check for deletion
  local value=$3         # Value to match in the column for deletion
  local tableName=$(basename "$dbPath" .meta) # Extract table name from the file path

  # Sanity check: Ensure all required arguments are provided
  if [[ -z "$dbPath" || -z "$column_name" || -z "$value" ]]; then
    zenity --error --text="Error: Missing required arguments."
    return 1
  fi

  # Check if the table (file) exists
  if [[ ! -f "$dbPath/TABLES/$tableName.meta" ]]; then
    zenity --error --text="Error: Table '$dbPath' not found."
    return 1
  fi

  # Ensure the file is readable
  if [[ ! -r "$dbPath/TABLES/$tableName.meta" ]]; then
    zenity --error --text="Error: Cannot read the table '$dbPath/TABLES/$tableName.meta'. Check file permissions."
    return 1
  fi

  # Ensure the file is writable
  if [[ ! -w "$dbPath/TABLES/$tableName.meta" ]]; then
    zenity --error --text="Error: Cannot write to the table '$dbPath/TABLES/$tableName.meta'. Check file permissions."
    return 1
  fi

  # Extract the header row (first line)
  local header=$(head -n 1 "$dbPath/TABLES/$tableName.meta")

  # Sanity check: Ensure the header exists
  if [[ -z "$header" ]]; then
    zenity --error --text="Error: Table '$dbPath/TABLES/$tableName.meta' is empty or malformed."
    return 1
  fi

  # Find the column number based on the column name
  local column_number=$(echo "$header" | awk -F',' -v col="$column_name" '{
      for (i = 1; i <= NF; i++) {
          if ($i == col) {
              print i;
              exit;
          }
      }
      exit 1; # Exit with an error code if the column is not found
  }')

  # Check if the column was found
  if [[ -z $column_number ]]; then
    zenity --error --text="Error: Column '$column_name' does not exist in the table."
    return 1
  fi

  # Perform the deletion (excluding the header row)
  awk -F',' -v col="$column_number" -v val="$value" 'NR == 1 || $col != val' "$dbPath/TABLES/$tableName.meta" > temp && mv temp "$dbPath/TABLES/$tableName.meta"

  # Show success message with zenity
  zenity --info --text="Rows with column '$column_name' matching '$value' have been deleted from '$dbPath/TABLES/$tableName.meta'."
}

# Get the file path, column name, and value from the user via Zenity
dbPath=$(zenity --file-selection --title="Select the Database File")
if [[ -z "$dbPath/TABLES/$tableName.meta" ]]; then
  zenity --error --text="No file selected. Exiting."
  exit 1
fi

column_name=$(zenity --entry --title="Enter Column Name" --text="Please enter the column name to check for deletion:")
if [[ -z "$column_name" ]]; then
  zenity --error --text="No column name entered. Exiting."
  exit 1
fi

value=$(zenity --entry --title="Enter Value to Delete" --text="Please enter the value to delete:")
if [[ -z "$value" ]]; then
  zenity --error --text="No value entered. Exiting."
  exit 1
fi

# Run the function with the user input
deleteFromTable "$dbPath/TABLES/$tableName.meta" "$column_name" "$value"































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