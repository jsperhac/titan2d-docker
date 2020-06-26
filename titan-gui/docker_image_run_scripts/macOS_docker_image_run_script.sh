#!/bin/bash

# Script for running the titan-gui Docker image on a MacBook Air running the macOS High Sierra Version 10.13.6 operating system.

# References:

# https://cntnr.io/running-guis-with-docker-on-mac-os-x-a14df6a76efc
# https://docs.docker.com/engine/reference/commandline/run/
# https://unix.stackexchange.com/questions/74185/how-can-i-prevent-grep-from-showing-up-in-ps-results

# X11 is no longer included with Mac, but X11 server and client libraries are available from the XQuartz project. 
# socat is a command line based utility that establishes two bidirectional byte streams and transfers data between them, 
# used to enable data transfers between Docker and XQuartz.

# Preparation:

# To install socat and XQuartz:

# brew install socat
# brew cask install xquartz

#  open -a Xquartz and check the  XQuartz / Preferences / Security / Allow connections from network clients check box.

# Run ifconfig en0 to get the ip of the network interface of the host macOS. Example:
# inet 192.168.1.151 netmask 0xffffff00 broadcast 192.168.1.255

# Run:

echo "Creating the titan-gui container..."

# Start the socat process
socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\" &

socat_ps=$(ps | grep -v grep | grep "socat")
echo $socat_ps

# Docker run options:

# --rm: automatically remove the created container when Docker exits
# --name: assign a name to the created container
# --interactive, -i: keep STDIN open even if not attached
# --tty, -t: allocate a pseudo-TTY
# --detach, -d: run container in background and print container ID
# --env: set environment variables
# --mount: attach a filesystem mount to the container

# For the mount, naming target the directory to mimic a vhub user's home directory.

# With this docker run command, a bash window is opened to the /opt/titan_wsp directory for the created container.
# Need to exit out of the bash window when done.
#docker run --rm --name titan-gui-container -it --env DISPLAY=192.168.1.151:0 --mount type=bind,source="/Users/renettej/AAB_Titan2D/renettej",target=/home/vhub/renettej titan-gui /bin/bash

# With this docker run command, the created container is run in the background
docker run --rm --name titan-gui-container -dit --env DISPLAY=192.168.1.151:0 --mount type=bind,source="/Users/renettej/AAB_Titan2D/renettej",target=/home/vhub/renettej titan-gui

echo "Opening the titan-gui container X11 window..."

docker exec titan-gui-container /opt/titan_wsp/titan2d_bld/iccoptompmpi/bin/titan_gui.sh

echo "Deleting the titan-gui container..."

docker stop titan-gui-container

# Kill the socat process.
# awk '{ print $1 }') gets the first word which is the PID returned by ps for the socat command.
socat_ps_pid=$(ps | grep -v grep | grep "socat" | awk '{ print $1 }')
kill -9 $socat_ps_pid
caffeinate -w $socat_ps_pid
