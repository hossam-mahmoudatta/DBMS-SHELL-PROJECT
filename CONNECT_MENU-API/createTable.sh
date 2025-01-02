# Create Table Function 
# Abdelrahman Khaled 



createTable() {
  # Ensure tables are stored in a dedicated folder
  dbPath=$1
  mkdir -p ../DATABASES/$dbPath/TABLES


  # Prompt for the table name using Zenity
  tableName=$(zenity --entry --title="Table Name" --text="Enter table name:")
  
  # Validate table name (no spaces or special characters)
  if [[ ! "$tableName" =~ ^[a-zA-Z0-9_]+$ ]];
  then
    zenity --error --text="Invalid table name. Only alphanumeric characters and underscores are allowed."
    return
  fi

  # Check if the table already exists
  tablePath="../DATABASES/TABLES/$tableName"
  if [ -f "$tablePath" ];
  then
    zenity --error --text="Table '$tableName' already exists."
    return
  fi

  # Prompt for the schema (columns and data types) using Zenity
  schema=$(zenity --entry --title="Table Schema" --text="Enter column names and types (e.g., id:int,name:string,age:int):")

  # Validate schema format (basic validation for now)
  if [[ ! "$schema" =~ ^([a-zA-Z_][a-zA-Z0-9_]*:[a-zA-Z]+)(,[a-zA-Z_][a-zA-Z0-9_]*:[a-zA-Z]+)*$ ]];
  then
    zenity --error --text="Invalid schema format. Use format like 'id:int,name:string,age:int'."
    return
  fi

  # Create the table and write the schema as the first line
  echo "$schema" > "$tablePath"
  zenity --info --text="Table '$tableName' created successfully."
}


# call the Function
createTable








# createTable() {
#   # Ensure tables are stored in a dedicated folder
#   mkdir -p tables

#   # Prompt for the table name
#   read -p "Enter table name: " tableName
  
#   # Validate table name (no spaces or special characters)
#   if [[ ! "$tableName" =~ ^[a-zA-Z0-9_]+$ ]]; then
#     echo "Invalid table name. Only alphanumeric characters and underscores are allowed."
#     return
#   fi

#   # Check if the table already exists
#   table_path="tables/$table_name"
#   if [ -f "$table_path" ]; then
#     echo "Table '$table_name' already exists."
#     return
#   fi

#   # Prompt for the schema (columns and data types)
#   read -p "Enter column names and types (e.g., id:int,name:string,age:int): " schema

#   # Validate schema format (basic validation for now)
#   if [[ ! "$schema" =~ ^([a-zA-Z_][a-zA-Z0-9_]*:[a-zA-Z]+)(,[a-zA-Z_][a-zA-Z0-9_]*:[a-zA-Z]+)*$ ]]; then
#     echo "Invalid schema format. Use format like 'id:int,name:string,age:int'."
#     return
#   fi

#   # Create the table and write the schema as the first line
#   echo "$schema" > "$table_path"
#   echo "Table '$table_name' created successfully."
# }