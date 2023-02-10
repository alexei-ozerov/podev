# Podman Development Environment
## Building
To build the environment, please make sure to have podman or docker installed. While the script is intended to be used with podman, I have updated it to be able to also work with a docker installation.

Before attempting to run the build process, please open up the podev.sh script and update the "MOUNT_DIR" variable to point to what you would like mounted inside your dev container. This will mount your selected folder in the container to /usr/src/dev/vmnt.

Run the following from the podev directory:
```
./podev.sh -b
```

## Running
In order to run the container, perform the following commands:

1. Create a detached instance of the container:
```
./podev.sh -r
```

2. Attach to the container with a forked bash instance:
```
./podev.sh -a
```

## Cleaning
To remove a running container and ANY dangling images (WARNING: this will remove any dangling images, containers, volumes, etc. If you do not want this, please modify the script accordingly), run:
```
./podev.sh -c
```
