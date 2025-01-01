#!/bin/bash


# Main Menu Function

main_menu(){

        echo "Main Menu"
        echo "1. Create Database"
        echo "2. List Database"
        echo "3. Connect Database"
        echo "4. Drop Database"
        echo "5. Exit"

        read -p "Select Your Option:" Your_Choice


        case $Your_Choice in
                1) Create_Database ;;
                2) List_Database ;;
                3) Connect_Database ;;
                4) Drop_Database ;;
                5) Exit 0 ;;
                *) echo "Invalid Option Try one more again Bro!!" ; main_menu ;;
        esac


}

