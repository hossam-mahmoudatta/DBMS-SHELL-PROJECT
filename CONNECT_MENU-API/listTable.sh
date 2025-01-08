# Created: 2025-01-01 15:00:00
# Created by Hossam

listTable() {
    dbPath=$1
    dir="$dbPath/TABLES/"
    # Get the list of files in the directory
    tablesList=$(ls $dir)

    logFile="../LOGS/listTable.log"

    # Log the directory path
    echo "Listing tables in directory: $dir" >> "$logFile"

    # Check if the directory contains files
    if [ -z "$tablesList" ];
    then
        zenity --info --text="You don't have any Tables!"
        echo "No tables found in directory: $dir" >> "$logFile"
    else
        # Use Zenity to display the contents in a list
        zenity --list --title="Your Tables" --text="Here are your Tables" --column="Items" $tablesList
        echo "Tables listed successfully in directory: $dir" >> "$logFile"
    fi
}

# Call the function
listTable $1
    
    
    # echo "Im in the list menu now: $dir"
    # echo "Where am i: $(pwd)"