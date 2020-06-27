#!/bin/bash

# Script for running the titan-gui docker image on a MacBook Air running the macOS High Sierra Version 10.13.6 operating system.

# References:

# https://cntnr.io/running-guis-with-docker-on-mac-os-x-a14df6a76efc
# https://docs.docker.com/engine/reference/commandline/run/
# https://unix.stackexchange.com/questions/74185/how-can-i-prevent-grep-from-showing-up-in-ps-results

# X11 is no longer included with Mac, but X11 server and client libraries are available from the XQuartz project. 
# socat is a command line based utility that establishes two bidirectional byte streams and transfers data between them, 
# used to enable data transfers between docker and the titan-gui XQuartz / X11 window.

# Preparation:

# To install socat and XQuartz:

# brew install socat
# brew cask install xquartz

# open -a Xquartz and check the  XQuartz / Preferences / Security / Allow connections from network clients check box.

# Run:

if [ $# -ne 1 ] ; then

   echo "Requires an argument. Enter 1 or 2:"
   echo "1: docker run and open a bash terminal window"
   echo "2: docker run detached and open a titan-gui X11 window"

else

   echo "Creating and running the titan-gui container..."

    # Start the socat process
    socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\" &

    socat_ps=$(ps | grep -v grep | grep "socat")
    echo $socat_ps

    # Get the ip address of the network interface of the host macOS.
    # awk '{ print $2 }') gets the second word which is the ip address.
    ip_address=$(ifconfig en0 | awk '$1 == "inet" {print $2}')
    #echo $ip_address   

    # Docker run options:

    # --rm: automatically remove the created container when docker exits
    # --name: assign a name to the created container
    # --interactive, -i: keep STDIN open even if not attached
    # --tty, -t: allocate a pseudo-TTY
    # --detach, -d: run container in background and print container ID
    # --env: set environment variables
    # --mount: attach a filesystem mount to the container
    # --volume, -v: bind mount a volume

    # For the mount, naming target the directory to mimic a vhub user's home directory.

    if [ $1 == 1 ]; then

        # With this docker run command, a bash window is opened to the /opt/titan_wsp directory for the created container.
        # Need to exit out of the bash window when done.

        docker run --rm --name titan-gui-container -it --env DISPLAY=$ip_address:0 --mount type=bind,source=/Users/renettej/AAB_Titan2D/renettej,target=/home/vhub/renettej titan-gui /bin/bash

    else

        # With this docker run command, the created container is run in the background and a titan-gui X11 window is opened.

        # When the Input Directory button is selected, 
        # the file selection dialog opens to the current directory which is currently /root.
        # For the docker run command below, 
        # need to migrate to the /home/vhub/renettej directory to select a Titan2D input directory.
        # For vhub, the Input Directory button event handler code can be modified to open to the user's home directory.

        docker run --rm --name titan-gui-container -dit --env DISPLAY=$ip_address:0 --mount type=bind,source=/Users/renettej/AAB_Titan2D/renettej,target=/home/vhub/renettej titan-gui
        # docker run --rm --name titan-gui-container -dit --env DISPLAY=$ip_address:0 --volume /Users/renettej/AAB_Titan2D/renettej:/home/vhub/renettej titan-gui

        echo "Opening the titan-gui container X11 window..."

        docker exec titan-gui-container /opt/titan_wsp/titan2d_bld/iccoptompmpi/bin/titan_gui.sh

        echo "Stopping and removing the titan-gui container..."

        docker stop titan-gui-container
    fi

    # Kill the socat process.
    # awk '{ print $1 }') gets the first word which is the PID returned by ps for the socat command.
    socat_ps_pid=$(ps | grep -v grep | grep "socat" | awk '{ print $1 }')
    kill -9 $socat_ps_pid
    # wait for the socat process to exit.
    caffeinate -w $socat_ps_pid
fi
