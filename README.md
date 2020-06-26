These (experimental) Dockerfiles are suitable for locally deploying and running the titan2d tool, either on the command line ('simple') or using the GUI. 

From simple to complex, here's what the subdirectories contain:
- titan-from-binary: simplest case, build from the binary
- titan-deps: enumerates and provides dependencies for titan2d
- titan-simple: command line interface only
- titan-gui: includes packages needed to run the GUI (i.e. Java)

Currently this application uses python2 and Java 1.7 or so. One goal is to move to python3 and update or obviate Java.
