#!/bin/sh -e

#Print some Debug
set -x

###################################################
# We'll need binaries from different paths,       #
#  so we should be sure, all bin dir in the PATH  #
###################################################
PATH="${PATH}:/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin"

#######################################################
# Git commit hash from                                #
# https://github.com/Kozea/Radicale                   #
# which we want to use for our Radicale server        #
# 04.02.2018 dca25b9e909e5c99312844f6df4fa0ff986bae86 #
#######################################################
GIT_COMMIT="dca25b9e909e5c99312844f6df4fa0ff986bae86"

#########################
# Create data directory #
#########################
mkdir -p "/data"

#################################
# Create temp working directory #
#################################
WORK_DIR="/tmp/build"
mkdir -p $WORK_DIR
cd $WORK_DIR

################################
# Install some needed packages #
################################
apk update

######################################################
# Runtime and build dependencies for Radicale server #
######################################################
apk add git python3 python3-dev build-base libffi-dev ca-certificates openssl && python3 -m pip install --upgrade pip && python3 -m pip install passlib bcrypt

#################################################
# Seperate build-deps                           #
# I'm creatind variable with them to being able #
#  to delete them back after building           #
#################################################
BUILD_DEP="python3-dev musl-dev build-base libffi-dev python-dev make gcc g++ git"
apk add $BUILD_DEP

################################################
# Clone mozilla-syncserv and get needed commit #
################################################
git clone https://github.com/Kozea/Radicale .
git reset --hard "$GIT_COMMIT"

#############################
# Build and install radical #
#############################
python3 -m pip install .

#########################################
# Delete all unneded files and packages #
#########################################
cd /
apk del --purge $BUILD_DEP
rm /var/cache/apk/*
rm -rf /root/.cache
rm -rf $WORK_DIR

echo "Done!"