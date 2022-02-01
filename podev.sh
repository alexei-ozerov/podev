#!/bin/bash

MOUNT_DIR=.
DOCKERFILE=Dockerfile.arch
TAG=dev/arch

Help()
{
   # Display Help
   echo "Podman Development Environment Manager."
   echo
   echo "Syntax: scriptTemplate [-b|r|g|a|c]"
   echo "options:"
   echo "b     Podman Build Dev Image."
   echo "r     Podman Run Dev Image."
   echo "a     Podman Attach Dev Image."
   echo "c     Podman Clean Container & System Cache."
   echo "h     Print this Help."
   echo
}

Attach()
{
  echo -e "Attaching to dev container"
  podman exec -it $(podman container ls -a | grep ${TAG} | awk '{print $1}') /bin/bash
}

Build()
{
  echo -e "Building image & tagging as ${TAG}"
  podman build --tag ${TAG} -f ${DOCKERFILE}
}

Run()
{
  echo -e "Attempting to stop any previously run containers of ${TAG}"
  podman rm --force $(podman container ls -a | grep ${TAG} | awk '{print $1}')
  podman run -it -d --userns=keep-id -v ${MOUNT_DIR}:/usr/src/dev/vmnt:Z ${TAG} /bin/bash
}

Clean()
{
  podman rm --force $(podman container ls -a | grep ${TAG} | awk '{print $1}')
  podman system prune --force
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
