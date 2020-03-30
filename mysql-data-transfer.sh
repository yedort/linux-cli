#!/bin/bash

if (( $# != 1 && $# != 3 )) || [[ $1 != 'import' && $1 != 'export' ]] || ( (( $# == 3 )) && [[ $2 != '-u' ]] );then
  echo 'Wrong arguments'
  echo 'Usage:'
  echo 'bash mysql-data-transfer.sh import'
  echo 'bash mysql-data-transfer.sh import -u yedort'
  echo 'bash mysql-data-transfer.sh export'
  echo 'bash mysql-data-transfer.sh export -u yedort'
  exit
fi

if (( $# == 3 ));then
  user=$3
else
  user=$USER
fi

if [[ $1 == 'export' ]];then
  mysql_config_editor set --login-path=mysqldatatransfer --host=localhost --user=$user --password
  mkdir databases
  mapfile databases < <(mysql --login-path=mysqldatatransfer -se "SHOW DATABASES")
  unset databases[0]
  for database in ${databases[@]};do
    mysqldump --login-path=mysqldatatransfer $database > databases/$database.sql
  done
else
  mysql_config_editor set --login-path=mysqldatatransfer --host=localhost --user=$USER --password
  if (( $# == 3 ));then
    password=$(<new_password.cnf)
    if [[ -z password ]];then
      echo "Please specify the new user's password in a file named \"new_password.cnf\" in the current directory"
      exit
    fi
    mysql --login-path=mysqldatatransfer -e "CREATE USER ${user};SET PASSWORD FOR ${user} = '${password}'"
  fi
  read -p "Databases' directory: " directory_path
  databases=$directory_path/*
  for database in $databases;do
    mysql --login-path=mysqldatatransfer -e "CREATE DATABASE ${database};GRANT ALL PRIVILEGES ON ${database}.* TO ${user}"
    mysql --login-path=mysqldatatransfer $database < $database.sql
  done
  password=''
fi
