# Insert into Table API 
# Hossam Mahmoud



dropTable() {
    # Define the database path
    dbPath=$1

    # Display a Zenity input box to ask for the table name
    tableName=$(zenity --entry --title="Drop Table" --text="Enter Table Name:")

    # If the user cancels the input box, exit the function
    if [ -z "$tableName" ]; then
        zenity --info --title="Drop Table" --text="No table name entered!"
        return
    fi



    # Construct the full path to the table
  tablePath="$dbPath/TABLES/$tableName.meta"

    # Debugging output
    echo "Table path: $tablePath"

    # Check if the table exists
    if [ -f "$tablePath" ]; then

        # Confirm if you really want to delete the table
        zenity --question --title="Confirm Deletion" \
            --text="Are you sure you want to delete the $tableName table?" \
            --ok-label="Yes" --cancel-label="No"
        
        # If the user clicks "No", cancel the deletion
        if [ $? -ne 0 ]; then
            zenity --info --title="Drop Table" --text="Table $tableName not deleted."
            return
        fi

        # Delete the table
        rm "$tablePath"
        zenity --info --title="Drop Table" --text="Table $tableName deleted successfully."
    else
        zenity --error --title="Drop Table" --text="Table $tableName not found."
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







  