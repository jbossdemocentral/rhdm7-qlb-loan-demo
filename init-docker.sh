#!/bin/sh
DEMO="Quick Loan Bank Demo"
AUTHORS="Red Hat"
PROJECT="git@github.com:jbossdemocentral/rhdm7-qlb-loan-demo.git"
PRODUCT="Red Hat Decision Manager"
TARGET=./target
JBOSS_HOME=$TARGET/jboss-eap-7.1
SERVER_DIR=$JBOSS_HOME/standalone/deployments
SERVER_CONF=$JBOSS_HOME/standalone/configuration/
SERVER_BIN=$JBOSS_HOME/bin
SRC_DIR=./installs
SUPPORT_DIR=./support
DM_DECISION_CENTRAL=rhdm-7.0.0.GA-decision-central-eap7-deployable.zip
DM_KIE_SERVER=rhdm-7.0.0.GA-kie-server-ee7.zip
EAP=jboss-eap-7.1.0.zip
#EAP_PATCH=jboss-eap-6.4.7-patch.zip
VERSION=7.0

# wipe screen.
clear

echo
echo "#################################################################"
echo "##                                                             ##"
echo "##  Setting up the ${DEMO}       ##"
echo "##                                                             ##"
echo "##                                                             ##"
echo "##     ####  #   # ####    #   #   #####    #####              ##"
echo "##     #   # #   # #   #  # # # #     #     #   #              ##"
echo "##     ####  ##### #   #  #  #  #   ###     #   #              ##"
echo "##     # #   #   # #   #  #     #   #       #   #              ##"
echo "##     #  #  #   # ####   #     #  #     #  #####              ##"
echo "##                                                             ##"
echo "##  brought to you by,                                         ##"
echo "##             ${AUTHORS}                                         ##"
echo "##                                                             ##"
echo "##                                                             ##"
echo "##  ${PROJECT}      ##"
echo "##                                                             ##"
echo "#################################################################"
echo

# make some checks first before proceeding.
if [ -r $SRC_DIR/$EAP ] || [ -L $SRC_DIR/$EAP ]; then
	 echo Product sources are present...
	 echo
else
	echo Need to download $EAP package from http://developers.redhat.com
	echo and place it in the $SRC_DIR directory to proceed...
	echo
	exit
fi

#if [ -r $SRC_DIR/$EAP_PATCH ] || [ -L $SRC_DIR/$EAP_PATCH ]; then
#	echo Product patches are present...
#	echo
#else
#	echo Need to download $EAP_PATCH package from the Customer Portal
#	echo and place it in the $SRC_DIR directory to proceed...
#	echo
#	exit
#fi

if [ -r $SRC_DIR/$DM_DECISION_CENTRAL ] || [ -L $SRC_DIR/$DM_DECISION_CENTRAL ]; then
		echo Product sources are present...
		echo
else
		echo Need to download $DM_DECISION_CENTRAL zip from http://developers.redhat.com
		echo and place it in the $SRC_DIR directory to proceed...
		echo
		exit
fi

if [ -r $SRC_DIR/$DM_KIE_SERVER ] || [ -L $SRC_DIR/$DM_KIE_SERVER ]; then
		echo Product sources are present...
		echo
else
		echo Need to download $DM_KIE_SERVER zip from http://developers.redhat.com
		echo and place it in the $SRC_DIR directory to proceed...
		echo
		exit
fi

cp support/docker/Dockerfile .
cp support/docker/Dockerfile-ui .
cp support/docker/docker-compose.yml .
cp support/docker/.dockerignore .

echo Starting Docker builds.
echo

docker build --no-cache -t jbossdemocentral/rhdm7-qlb-loan-demo .
docker build --no-cache -t jbossdemocentral/rhdm7-qlb-loan-demo-ui -f Dockerfile-ui .

if [ $? -ne 0 ]; then
        echo
        echo Error occurred during Docker build!
        echo Consult the Docker build output for more information.
        exit
fi

echo Docker build finished.
echo

rm Dockerfile
rm Dockerfile-ui

echo
echo "=================================================================================="
echo "=                                                                                ="
echo "=  You can now start the $PRODUCT in a Docker container with:    ="
echo "=                                                                                ="
echo "=     docker-compose up                                                          ="
echo "=                                                                                ="
echo "=  Login into Decision Central at:                                               ="
echo "=                                                                                ="
echo "=    http://localhost:8080/decision-central  (u:dmAdmin / p:redhatdm1!)          ="
echo "=                                                                                ="
echo "=  Login into Quick Loan Bank application at:                                    ="
echo "=                                                                                ="
echo "=    http://localhost:3000                                                       ="
echo "=                                                                                ="
echo "=  See README.md for general details to run the various demo cases.              ="
echo "=                                                                                ="
echo "=  $PRODUCT $VERSION $DEMO Setup Complete.             ="
echo "=                                                                                ="
echo "=================================================================================="
