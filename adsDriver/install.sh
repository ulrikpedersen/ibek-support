#!/bin/bash
##########################################################################
##### install script for adsDriver support module       ##################
##########################################################################

# ARGUMENTS:
#  $1 VERSION to install (must match repo tag)
VERSION=${1}
NAME=adsDriver
FOLDER=$(dirname $(readlink -f $0))

# log output and abort on failure
set -xe

ibek support apt-install --only=dev libboost-thread-dev
ibek support apt-install --only=run libboost-thread1.74.0

# get the source and fix up the configure/RELEASE files
# ibek support git-clone ${NAME} ${VERSION} --org https://github.com/Cosylab/
# We need to clone the submodule as well for this module. Ibek doesn't support that yet.
git clone --recurse-submodules -b ${VERSION} --depth 1 https://github.com/Cosylab/${NAME}.git /epics/support/${NAME}

ibek support register ${NAME}

# declare the libs and DBDs that are required in ioc/iocApp/src/Makefile
ibek support add-libs ads
ibek support add-dbds ads.dbd

# compile the support module
ibek support compile ${NAME}

# prepare *.bob, *.pvi, *.ibek.support.yaml for access outside the container.
ibek support generate-links ${FOLDER}

