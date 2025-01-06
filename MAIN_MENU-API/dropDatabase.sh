
#!/bin/bash

# Drop Database Function 
# Abdelrahman Khaled

Drop_Database(){

        echo "Drop Database"

        # Use Zenity to database name
        db_name=$(zenity --entry --title="Database Name" --text="Enter Database Name:")

        # Check if the user canceled or left the input empty
        if [ -z "$db_name" ]; then
                zenity --error --text="Database name cannot be empty. Please provide a valid name."
                return
        fi

        # Check if the database exists or not 
        if [ -d "../DATABASES/$db_name" ]; then

                # Use Zenity for confirmation before deletion
                zenity --question --title="Confirm Deletion" --text="Are you in ur mind to decide deleting the '$db_name' database?" --ok-label="Yes" --cancel-label="No"

                if [ $? -ne 0 ]; then 
                        zenity --info --text="Database $db_name Not Deleted."
                        return
                fi

                # Delete the database (directory)
                rm -r ../DATABASES/"$db_name"
                zenity --info --text="Database $db_name Deleted Successfully!"
                
        else  
                zenity --error --text="Database $db_name Not Found."
        fi       

}

# call to the function
Drop_Database







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

