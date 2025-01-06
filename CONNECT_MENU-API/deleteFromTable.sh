# Create Table Function 
# Abdelrahman Khaled 










deleteFromTable() {

  local dbPath=$1       # Path to the table (file)
  local column_name=$2   # Column name to check for deletion
  local value=$3         # Value to match in the column for deletion

  # Sanity check: Ensure all required arguments are provided
  if [[ -z "$dbPath" || -z "$column_name" || -z "$value" ]]; then
    echo "Error: Missing required arguments. Usage: deleteFromTable <dbPath> <column_name> <value>"
    return 1
  fi

  # Check if the table (file) exists
  if [[ ! -f "$dbPath" ]]; then
    echo "Error: Table '$dbPath' not found."
    return 1
  fi

  # Ensure the file is readable
  if [[ ! -r "$dbPath" ]]; then
    echo "Error: Cannot read the table '$dbPath'. Check file permissions."
    return 1
  fi

  # Ensure the file is writable
  if [[ ! -w "$dbPath" ]]; then
    echo "Error: Cannot write to the table '$dbPath'. Check file permissions."
    return 1
  fi

  # Extract the header row (first line)
  local header=$(head -n 1 "$dbPath")

  # Sanity check: Ensure the header exists
  if [[ -z "$header" ]]; then
    echo "Error: Table '$dbPath' is empty or malformed."
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
    echo "Error: Column '$column_name' does not exist in the table."
    return 1
  fi

  # Perform the deletion (excluding the header row)
  # Using a corrected reference to the column
  awk -F',' -v col="$column_number" -v val="$value" 'NR == 1 || $col != val' "$dbPath" > temp && mv temp "$dbPath"

  echo "Rows with column '$column_name' matching '$value' have been deleted from '$dbPath'."
}

deleteFromTable $1 $2 $3











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