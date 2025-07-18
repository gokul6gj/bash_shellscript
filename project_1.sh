#!/bin/bash

# Prompt the user to enter a username
echo "Enter your user Name: "
read user

# Check if the user exists on the system
if id "$user" &>/dev/null
then
    # Get the user's home directory from /etc/passwd
    home_dir=$(getent passwd "$user" | cut -d: -f6)

    # Get the default login shell for the user
    default_shell=$(getent passwd "$user" | cut -d: -f7)

    # Get the user's last 10 login records using 'last'
    last_login_info=$(last -F | grep "^$user" | head -10)

    # Get the user's UID and GID
    uid=$(id -u "$user")
    gid=$(id -g "$user")

    # Get all groups the user belongs to
    groups=$(id "$user" | cut -d' ' -f3-)

    # Get disk usage of user's home directory (handles errors silently)
    disk_usage=$(du -sh "$home_dir" 2>/dev/null | cut -f1)

    # Write all collected details into a report file
    echo "User: $user" > user_report.txt # > This will Redirect data to file if file doesn't exist i will create itself.
    echo "Home Directory: $home_dir" >> user_report.txt
    echo "Default Shell: $default_shell" >> user_report.txt
    echo "UID: $uid" >> user_report.txt
    echo "GID: $gid" >> user_report.txt
    echo "Groups: $groups" >> user_report.txt
    echo "Home Directory Disk Usage: $disk_usage" >> user_report.txt
    echo -e "Last Login:\n$last_login_info" >> user_report.txt

    echo "Report is Generated in user_report.txt"

else
    # If user doesn't exist, show a warning
    echo "User $user not found"
fi

