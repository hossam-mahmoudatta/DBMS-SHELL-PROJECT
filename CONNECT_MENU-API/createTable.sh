# Create Table Function 
# Abdelrahman Khaled 


createTable() {
  # Ensure tables are stored in a dedicated folder
  dbPath=$1
  mkdir -p ../DATABASES/$dbPath/TABLES
  
  while True:
  do
    # Prompt for the table name using Zenity
    tableName=$(zenity --entry --title="Table Name" --text="Enter table name:")

    # If the user cancels the input, exit the loop
    if [ -z "$tableName" ];
    then
      zenity --warning --text="Table name cannot be empty. Please try again."
      continue
    fi

    # Validate table name (no spaces or special characters)
    if [[ ! "$tableName" =~ ^[a-zA-Z0-9_]+$ ]];
    then
        zenity --error --text="Invalid table name. Only alphanumeric characters and underscores are allowed."
        continue
    fi

    # Check if the table already exists
    tablePath="$dbPath/TABLES/$tableName.meta"
    if [ -f "$tablePath" ];
    then
        zenity --error --text="Table '$tableName' already exists. Please choose a different name."
        continue
    fi
    break
  done
    

  # Keep prompting for columns until the user decides to stop
  while true;
  do
    # Ask for the column name
    columnName=$(zenity --entry --title="Column Name" --text="Enter the name of the column:")

    # If no column name is entered, stop the process
    if [ -z "$columnName" ];
    then
        zenity --error --text="Column name cannot be empty. Please try again."
        continue
    fi

    # Ask for the data type
    columnType=$(zenity --list --title="Select Data Type" \
      --text="Choose a data type for '$columnName':" \
      --column="Data Types" \
      "int" "string" "float" "bool")

    # If no data type is selected, show an error
    if [ -z "$columnType" ];
    then
        zenity --error --text="You must select a data type. Please try again."
        continue
    fi

    # Add the column to the schema
    if [ -z "$schema" ];
    then
        schema="$columnName:$columnType"
    else
        schema="$schema,$columnName:$columnType"
    fi

    # Ask if the user wants to add another column
    addAnother=$(zenity --question --title="Add Another Column?" --text="Do you want to add another column?" --ok-label="Yes" --cancel-label="No")

    # If the user clicks "No", break the loop
    if [ $? -eq 1 ]; then
        break
    fi
  done

  # Save the schema to the table file
  echo "$schema" > "$tablePath"
  zenity --info --text="Table schema created successfully: $schema"




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
createTable $1
