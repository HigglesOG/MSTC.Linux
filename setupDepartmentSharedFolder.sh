#!/bin/bash
#Code By: Logan Derezinski
#Date 04/15/2025

#check for command line argument
ROOT_FOLDER="$1"

if [[ $(whoami) == "root" ]]; then
 echo "access"

 else
  echo "script is not running as root."
  exit 1

fi


if [ -z "$ROOT_FOLDER" ]; then
  echo
  echo "creates a department shared folder structure at the specified location"
  echo
  echo " Usage: $0 <root folder> "
  echo

  exit 1
fi

DEPARTMENTS=("Sales"
"HumanResources"
"TechnicalOperations"
"Helpdesk"
"Research")

# Check that ROOT_FOLDER ecists, if not, create it...
if [ ! -d "$ROOT_FOLDER" ]; then 
  echo "Creating root folder at $ROOT_FOLDER..."
  mkdir -p "$ROOT_FOLDER" 
fi

for DEPARTMENT in ${DEPARTMENTS[*]}; do
  # This will repeat for each department
  echo "Provisioning $DEPARTMENT..."

# Check if Department Group Exists

if [ ! $(getent group "$DEPARTMENT") ]; then
  echo "Creating group $DEPARTMENT..."
  groupadd "$DEPARTMENT"
fi

 DEPARTMENT_FOLDER="$ROOT_FOLDER/$DEPARTMENT"
 if [ ! -d "$DEPARTMENT_FOLDER" ]; then
 echo "Creating Shared Folder at $DEPARTMENT_FOLDER..."
 mkdir -p "$DEPARTMENT_FOLDER"
fi

 echo " - Apply $CURRENT_USER:$DEPARTMENT ownership on $DEPARTMENT_FOLDER..."
 chown  "$CURRENT_USER:$DEPARTMENT" "$DEPARTMENT_FOLDER"

 echo " - Applying permissions on $DEPARTMENT_FOLDER... $CURRENT_USER=rwx, $DEPARTMENT=rwx,o="
 chmod u+rwx,g+rwx,o-rwx "$DEPARTMENT_FOLDER"

 echo " - Granting permission (rx) to Helpdesk on $DEPARTMENT_FOLDER..."
 setfacl --modify=g:Helpdesk:rx "$DEPARTMENT_FOLDER" 

done 


