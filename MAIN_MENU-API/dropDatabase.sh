
#!/bin/bash
# Created: Abdelrahman Khaled

# Drop Database Function 
dropDatabase(){

    logFile="../LOGS/dropDatabase.log"
    
    dir=../DATABASES
    
    databasesList=$(ls $dir)

    # Check if the directory contains files
    if [ -z "$databasesList" ];
    then
        zenity --info --text="You don't have any Databases!"
        echo "No databases found in directory: $dir" >> "$logFile"
    else
        # Use Zenity to display the contents in a list
        selectedDB=$(zenity --list \
            --title="Your Databases" \
            --text="Here are your Databases" \
            --column="Items" $databasesList)
        echo "Databases listed successfully in directory: $dir" >> "$logFile"

        # Check if a database was selected
        if [ -n "$selectedDB" ];
        then
            # Navigate to the next menu based on the selected database
            zenity --info --text="You selected the Database: $selectedDB"
        else
            zenity --error --text="No database selected."
            echo "No database selected" >> "$logFile"
            return
        fi
    fi

    # Check if the database exists or not 
    if [ -d "../DATABASES/$selectedDB" ];
    then
        # Use Zenity for confirmation before deletion
        zenity --question \
            --title="Confirm Deletion" \
            --text="Are you in ur mind to decide deleting the '$selectedDB' database?" \
            --ok-label="Yes" \
            --cancel-label="No"

        if [ $? -ne 0 ];
        then 
            zenity --info \
                --text="Database $selectedDB Not Deleted."
            echo "$(date) - Database $dbName not deleted." >> "$logFile"
            return
        fi

        # Delete the database (directory)
        rm -r ../DATABASES/"$selectedDB"
        zenity --info \
            --text="Database $selectedDB Deleted Successfully!"
        echo "$(date) - Database $selectedDB deleted successfully." >> "$logFile"
        
    else  
        zenity --error \
            --text="Database $selectedDB Not Found."
        echo "$(date) - Error: Database $selectedDB not found." >> "$logFile"
    fi
}

# call to the function
dropDatabase







# # Drop Database Function 
# # Abdelrahman Khaled

# Drop_Database(){

#         echo "Drop Database"

#         # Read the database name from the user
#         read -p "Enter Databse Name:" db_name

#         # Check if the database exits or not 
        
#         if [ -d "$db_name" ]; then

#         # confirm the user to delete the database

#                 read -p "Are you in ur mind to delete $db_name Database? [y/n]:" confirm

#                 if [ "$confirm" != "y" ]; then 
#                         echo "Database $db_name Not Deleted Bro!!"
#                         return
#                 fi

#                 rm -r "$db_name"
#                 echo "Database $db_name Deleted Successfully Bro!!"
                
#         else  
#                 echo "Database $db_name Not Found Bro!!"
#         fi       

# }

