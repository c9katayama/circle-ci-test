#!/bin/sh

# In order to avoid mmap issue in running java in Docker
setfattr -n user.pax.flags -v "mr" /usr/bin/java

cd /opt/docker/
/usr/bin/java -jar ci.jar