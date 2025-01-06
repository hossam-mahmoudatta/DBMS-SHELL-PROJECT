# Insert into Table API 
# Hossam Mahmoud

#########################################################
#########################################################

# echo $(pwd)
source ../CONNECT_MENU-API/pickTable.sh

# This API should allow us to insert into a table of our choice
insertTable() {
    $selectedTable=pickTable
    echo You passed the call to pickTable # Verify that the function got called
    
    # Verify that the selected table is correct
    echo $selectedTable

    # Read the schema (first row) from the table
    schema=$(head -n 1 "$tablePath")
    echo $schema
    columns=(${(s:,:)schema})  # Split schema by comma

    # Prepare to collect values for each column
    values=()

    # Loop through each column in the schema
    for column in "${columns[@]}";
    do
    value=$(zenity --entry --title="Insert Data" --text="Enter value for '$column':")

    # Check if value is empty
    if [[ -z "$value" ]]; then
        zenity --error --text="Value for '$column' cannot be empty."
        return
    fi

    values+=("$value")
    done

    # Join values with commas
    newRow=$(IFS=,; echo "${values[*]}")

    # Append the new row to the table
    echo "$newRow" >> "$tablePath"
    zenity --info --text="Data inserted successfully into '$tablePath'."
}

# Call the function 
insertTable $1