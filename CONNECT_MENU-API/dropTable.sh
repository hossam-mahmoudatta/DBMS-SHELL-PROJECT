# Create Table Function 
# Created: Abdelrahman Khaled 
# Modified: Hossam Mahmoud

dropTable() {

    

    dbPath=$1
    dir="$dbPath/TABLES/"

    # Verify the directory exists
    if [ ! -d "$dir" ];
    then
        zenity --error \
            --text="Error: Directory '$dir' does not exist."
        return
    fi

    # Get the list of files in the directory but without the IDCounter files
    tablesList=$(ls $dir | grep -v '\_IDCounter')
    if [ -z "$tablesList" ]; then
        zenity --info \
            --text="No tables found in the directory."
        return
    fi

    # Select a table
    selectedTable=$(zenity --list \
        --title="Select a Table" \
        --text="Available Tables:" \
        --column="Tables" $tablesList)
    if [ -z "$selectedTable" ];
    then
        zenity --warning \
            --text="No table selected."
        return
    fi

    tablePath="$dir/$selectedTable"

    if [ ! -f "$tablePath" ];
    then
        zenity --error \
            --text="Error: Table file '$tablePath' not found."
        return
    fi


    # Check if the table exists
    if [ -f "$tablePath" ];
    then
        # Confirm if you really want to delete the table
        zenity --question \
            --title="Confirm Deletion" \
            --text="Are you sure you want to delete the $tableName table?" \
            --ok-label="Yes" --cancel-label="No"
        
        # If the user clicks "No", cancel the deletion
        if [ $? -ne 0 ];
        then
            zenity --info \
                --title="Drop Table" \
                --text="Table $tableName not deleted."
            return
        fi

        # Delete the table
        rm "$tablePath"
        zenity --info \
            --title="Drop Table" \
            --text="Table $tableName deleted successfully."
    else
        zenity --error \
            --title="Drop Table" \
            --text="Table $tableName not found."
    fi
}

# Call the function 
dropTable $1









# dropTable(){

#     echo "Drop Table"
    
#     read -p "Enter Table Name:" tableName

#     # Check if the table exits or not
#     if [ -f "$tableNamr" ];
#     then
#       # confirm the user to delete the table
#       read -p "Are you in ur mind to delete $tableName Table? [y/n]:" confirm

#       if [ "$confirm" != "y" ]; then 
#         echo "Table $tableName Not Deleted Bro!!"
#         return
#       fi

#       rm -r "$tableName"
#       echo "Table $tableName Deleted Successfully Bro!!"

#     else  
#       echo "Table $tableName Not Found Bro!!"
#     fi 


# }







  