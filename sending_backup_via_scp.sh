#!/bin/bash

# README
# This script will helps you create backup which will be send to other server.
# To use correct this script you should know 3 variables.
# 1 -> Select which folders to back up. (backup_directories)
# 2 -> Destination sever name or ip address.
# 3 -> User which have account and correct permissions to this server.

# Mandatory - You can add some additional directories if you want.
backup_directories=("/etc" "/home" "/boot")
# Optional - You can change directory where backups will be released.
destination_directory="/backup"
# Mandatory -Provide ip address or hostname from your config.
destination_server="Please check your ~/.ssh/config and provide server name or ip address."
# Mandatory - user with account and correct permissions.
user="my_user"
backup_date=$(date +%b-%d-%y)

echo "We will do backup for following directories: ${backup_directories[@]}"

for val in "${backup_directories[@]}"; do
  sudo tar -Pczf /tmp/$val-$backup_date.tar.gz $val
  if [ $? -eq 0 ]; then
      echo "$val backup has been done successfully."
    else
      echo "Something went wrong when we try to make backup of $val"
  fi
  scp /tmp$val-$backup_date.tar.gz $user@$destination_server:$destination_directory
  if [ $? -eq 0 ]; then
      echo "$val has been migrated successfully."
  else
      echo "Something went wrong when we try to migrate data - $val to $destination_server"
  fi
done

sudo rm /tmp/*.gzecho "Backup has been done successfully."
