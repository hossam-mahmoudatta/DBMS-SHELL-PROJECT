#!/bin/bash

# Drop Database Function 

Drop_Database(){

        echo "Drop Database"
        read -p "Enter Databse Name:" db_name
        
        if [ -d "$db_name" ]; then
                rm -r "$db_name"
                echo "Database $db_name Deleted Successfully Bro!!"
                
        else  
                echo "Database $db_name Not Found Bro!!"
        fi       

}