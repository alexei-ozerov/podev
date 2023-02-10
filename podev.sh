#!/bin/bash

MOUNT_DIR=.
DOCKERFILE=Dockerfile.arch
TAG=dev/arch
CONFIG_FILE=.podev.conf

Setup()
{
  if test -f "$CONFIG_FILE"; then
    ENGINE=$(cat "$CONFIG_FILE")
  else

    echo "Please pick if you would like to use (1) Podman or (2) Docker."
    echo "Please enter the number 1 or 2 to make your choice."
    echo
    
    read USER_OPTION

    if [[ ! "$USER_OPTION" =~ [1-2] ]]; then
      echo "Please enter a valid option (1 or 2)."
      exit 1
    elif [[ "$USER_OPTION" == "1" ]]; then
      echo "podman" >> "$CONFIG_FILE"
    else
      echo "docker" >> "$CONFIG_FILE"
    fi 

    ENGINE=$(cat "$CONFIG_FILE")
  fi 
}

Get_User_Input()
{
  echo "Please pick if you would like to use (1) Podman or (2) Docker."
  echo "Please enter the number 1 or 2 to make your choice."
  echo
  
  read USER_OPTION
}

Help()
{
   # Display Help
   echo "Development Environment Manager."
   echo
   echo "Syntax: scriptTemplate [-b|r|g|a|c]"
   echo "options:"
   echo "b     Build Dev Image."
   echo "r     Run Dev Image."
   echo "a     Attach Dev Image."
   echo "c     Clean Container & System Cache."
   echo "h     Print this Help."
   echo 
}

Attach()
{
  Setup
  echo -e "Attaching to dev container"
  "$ENGINE" exec -it $("$ENGINE" container ls -a | grep ${TAG} | awk '{print $1}') /bin/bash
}

Build()
{
  Setup
  echo -e "Building image & tagging as ${TAG}"
  "$ENGINE" build --tag ${TAG} -f ${DOCKERFILE}
}

Run()
{
  Setup
  echo -e "Attempting to stop any previously run containers of ${TAG}"
  "$ENGINE" rm --force $("$ENGINE" container ls -a | grep ${TAG} | awk '{print $1}')
  "$ENGINE" run -it -d --userns=keep-id -v ${MOUNT_DIR}:/usr/src/dev/vmnt:Z ${TAG} /bin/bash
}

Clean()
{
  Setup
  "$ENGINE" rm --force $("$ENGINE" container ls -a | grep ${TAG} | awk '{print $1}')
  "$ENGINE" system prune --force
}

while getopts ":hbrac" option; do
   case $option in
      h) # display Help
         Help
         exit;;
      b) # build image
         Build
         exit;;
      r) # run image (detached)
         Run
         exit;;
      a) # attach to running image (forking bash process)
         Attach
         exit;;
      c) # remove dev container and clean cache
         Clean
         exit;;
     \?) # Invalid option
         echo "Error: Invalid option"
         exit;;
   esac
done
