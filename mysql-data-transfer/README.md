# Bash script

## How it works:

Import: First, you will be asked for the current user's password. If you specify the user argument, it will create that user with the password you speficied in the file named "new_password.cnf" and grant permissions to it. Otherwise, it will grant permissions to the current user.

Export: If you specify the user argument, it will proceed for that user's databases. Otherwise, for the current user's.

## Usage:

bash mysql-data-transfer.sh import

bash mysql-data-transfer.sh import -u yedort

bash mysql-data-transfer.sh export

bash mysql-data-transfer.sh export -u yedort
