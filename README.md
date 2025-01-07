# DBMS-SHELL-PROJECT

=====================================
=====================================

## This is the official Repo for the Database Management System Bash Project

=====================================
=====================================

## Contributors:
### Hossam Mahmoud
### Abdelrahman Khaled
### Zeyad Tarek

=====================================
=====================================

## Brief
This project implements a database system coded in Bash, powered by Zenity GUI.
The DBMS provides basic operations like creating, reading, updating, and deleting databases / tables. It is implemented in a way that is very user friendly achieving very smooth and instant transitions between menu operations.

## Features
- **[Table of Contents](#table-of-contents)**
  - [Create Database](#create-database)
  - [View Databases](#view-databases)
  - [Connect to Database](#connect-to-database)
    - **Operations:**
      - Create Table
      - Insert Data
      - Update Data
      - Delete Data
      - View Table
  - [Drop Database](#drop-database)
  - [Exit](#exit)
  - [Error Handling](#error-handling)

- **Create Database**: Create new databases.
- **View Databases**: Display all available databases.
- **Connect to Database**: Access a specific database for table and data operations.
  - **Operations:**
    - Create Table
    - Insert Data
    - Update Data
    - Delete Data
    - View Table
- **Drop Database**: Delete an existing database.
- **Exit**: Exit the application gracefully.
- **Error Handling**: Provides error messages for invalid options and operations.


## Project Structure
The project is structured in the following manner:

### Entry Point
- **`mainMenu.sh`**: You can run the application by running this file!

### Script APIs
Each operation is encapsulated in its own script file to enhance organization and maintainability:

- `connectToDataBase.sh`
- `createDataBase.sh`
- `createTable.sh`
- `deleteFromTable.sh`
- `dropDataBase.sh`
- `dropTable.sh`
- `insertIntoTable.sh`
- `listDataBases.sh`
- `listTables.sh`
- `manageDataBase.sh`
- `selectFromTable.sh`
- `selectAllData.sh`
- `selectByCondition.sh`
- `selectByPrimaryKey.sh`
- `selectSpecificColumns.sh`
- `sortData.sh`
- `updateRowInTable.sh`
- `validation.sh`

## Requirements
- Bash / Zsh Shells
- Zenity (to enable the GUI interface)
- Linux-based operating system

## Usage
### Running the Script
1. Ensure all required scripts are in the same directory as `databaseEngine.sh`.
2. Run the script with the following command:
   ```bash
   ./databaseEngine.sh start
   ```
3. To display help information, use:
   ```bash
   ./databaseEngine.sh --help
   ```

### Interacting with the Application
- Upon execution, the main menu will be displayed via Zenity.
- Select an option from the menu to perform the corresponding action.
- Follow the prompts for specific operations.

## Directory Setup
The script ensures that a directory named `DBMS` is created in the user's home directory if it does not already exist. This directory is used to store database files and related data.

## Code Highlights
### Menu System
The menu system is implemented using Zenity's `--list` option, providing a clean and interactive interface:
```bash
choice=$(zenity --list --title="Database Engine" --column="Options" "${menu[@]}" --height=250)
```
### Error Handling
Invalid selections are gracefully handled with error messages displayed using Zenity:
```bash
zenity --error --text="Invalid option. Please try again."
```
### Directory Management
Ensures the necessary directory structure exists:
```bash
if ! isAlreadyExists -m; then
  mkdir -p "$HOME/DBMS"
fi
```

## Prerequisites
### Install Zenity
Zenity is required to run the graphical interface. Install it using:
```bash
sudo apt-get install zenity
```
or
```bash
yum install zenity
```

### Install figlet
For stylized terminal output:
```bash
sudo apt-get install figlet
```
or
```bash
yum install figlet
```

## Contributing
Contributions are welcome! Please follow these steps:
1. Fork the repository.
2. Create a new branch.
3. Implement your changes.
4. Submit a pull request.

## License
This project is licensed under the GPL License.

## Acknowledgments
- [Zenity Documentation](https://help.gnome.org/users/zenity/stable/)
- Bash scripting community and resources

## Future Enhancements
- Add support for advanced SQL-like queries.
- Introduce user authentication for database access.
- Enhance the GUI with more features and better usability.

---

Thank you for using the Database Engine! If you encounter any issues or have suggestions, feel free to reach out.










=====================================
=====================================
This is the directory for the Shell Project
=====================================
=====================================

Bash Shell Script Database Management System (DBMS):

The Project aim to develop DBMS, that will enable users to store and retrieve the data from Hard-disk.

The Project Features:
The Application will be CLI Menu based app, that will provide to user this Menu items:
Main Menu:
- Create Database
- List Databases
- Connect To Databases
- Drop Database

Up on user Connect to Specific Database, there will be new Screen with this Menu:
- Create Table 
- List Tables
- Drop Table
- Insert into Table
- Select From Table
- Delete From Table
- Update Row

Hints:
- The Database will store as Directory on Current Script File
- Don't use Absolute Path in your scripts
- The Tables store in files, which can be CSV or JSON or XML File format
- You can divide the Table info to two tables: Meta-data and Raw Data in separate files or the same file
- When Create Table, The Meta Data of Table will be: Table Name, Number of Columns, Name Of Columns
- There is assumption that First Column is Primary Key, which used for Delete Rows.
- The Select of Rows displayed in screen/terminal in Accepted/Good Format
- Keep track of Data Types (Digits or Strings) of Column and Validated user input based on it

The Bonus:
- Make the App to accept SQL Code Instead of Above Menu Based
- Make GUI of Application 'Plus" the current CLI view
