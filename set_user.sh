#!/bin/bash

USERNAME="lion"
PASSWD=

while getopts "u:p:" option; do
    case $option in
        u) USERNAME=$OPTARG;;
        p) PASSWD=$OPTARG ;;
        *)
            echo "Usage: $0 [-u username] [-p password]"
            exit 1
            ;;
    esac
done

if [ -z $PASSWD ]; then
    echo "password is required"
    echo "Usage: $0 [-u username] [-p password]"
    exit 1
fi

# user 추가 
echo "Add user"
useradd -s /bin/bash -d /home/$USERNAME -m $USERNAME

# password 변경
echo "Add user"
useradd "$USERNAME:$PASSWD" | chpasswd

# sudoer에 추가
echo "Add sudoer"
echo "$USERNAME ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME
