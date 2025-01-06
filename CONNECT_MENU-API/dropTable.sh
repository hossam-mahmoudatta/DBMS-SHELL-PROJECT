# Create Table Function 
# Abdelrahman Khaled 





dropTable() {
    # Display a Zenity input box to ask for the table name
    tableName=$(zenity --entry --title="Drop Table" --text="Enter Table Name:")

    # If the user cancels the input box, exit the function
    if [ -z "$tableName" ]; then
        zenity --info --title="Drop Table" --text="No table name entered!"
        return
    fi

    # Check if the table exists
    if [ -f "$tableName" ]; then

        # Confirm if you real wanna delete the table
        confirm=$(zenity --question --title="Confirm Deletion" \
            --text="Are you in ur mind to delete $tableName Table?" \
            --ok-label="Yes" --cancel-label="No")
        
        # If the user clicks "No", cancel the deletion
        if [ $? -ne 0 ]; then
            zenity --info --title="Drop Table" --text="Table $tableName Not Deleted Bro!!"
            return
        fi

        # Delete the table
        rm -r "$tableName"
        zenity --info --title="Drop Table" --text="Table $tableName Deleted Successfully Bro!!"
    else
        # If the table doesn't exist, show a message
        zenity --error --title="Drop Table" --text="Table $tableName Not Found Bro!!"
    fi
}












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







  