#!/bin/sh 
DEMO="RHDM Quick Loan Bank Demo"
AUTHORS="Red Hat"
PROJECT="git@github.com:jbossdemocentral/rhdm7-qlb-loan-demo.git"
PRODUCT="Red Hat Decision Manager"
JBOSS_HOME=./target/jboss-eap-7.3
SERVER_DIR=$JBOSS_HOME/standalone/deployments/
SERVER_CONF=$JBOSS_HOME/standalone/configuration/
SERVER_BIN=$JBOSS_HOME/bin
SRC_DIR=./installs
SUPPORT_DIR=./support
PRJ_DIR=./projects
VERSION_EAP=7.3.0
VERSION=7.11.0
EAP=jboss-eap-$VERSION_EAP.zip
RHDM=rhdm-$VERSION-decision-central-eap7-deployable.zip
KIESERVER=rhdm-$VERSION-kie-server-ee8.zip

# demo project.
PROJECT_GIT_REPO=https://github.com/jbossdemocentral/rhdm7-qlb-loan-demo-repo
PROJECT_GIT_REPO_NAME=rhdm7-qlb-loan-demo-repo.git
NIOGIT_PROJECT_GIT_REPO="MySpace/$PROJECT_GIT_REPO_NAME"
PROJECT_GIT_BRANCH=master
PROJECT_GIT_DIR=$SUPPORT_DIR/demo_project_git 

# wipe screen.
clear 

echo
echo "###############################################################"
echo "##                                                           ##"   
echo "##  Setting up the ${DEMO}                 ##"
echo "##                                                           ##"   
echo "##                                                           ##"   
echo "##         ####  ##### ####     #   #  ###  #####            ##"
echo "##         #   # #     #   #    #   # #   #   #              ##"
echo "##         ####  ###   #   #    ##### #####   #              ##"
echo "##         #  #  #     #   #    #   # #   #   #              ##"
echo "##         #   # ##### ####     #   # #   #   #              ##"
echo "##                                                           ##"   
echo "##     ####  #####  #### #####  #### #####  ###  #   #       ##"   
echo "##     #   # #     #       #   #       #   #   # ##  #       ##"   
echo "##     #   # ###   #       #    ###    #   #   # # # #       ##"   
echo "##     #   # #     #       #       #   #   #   # #  ##       ##"   
echo "##     ####  #####  #### ##### ####  #####  ###  #   #       ##"   
echo "##                                                           ##"   
echo "##       #   #  ###  #   #  ###  ##### ##### ####            ##"
echo "##       ## ## #   # ##  # #   # #     #     #   #           ##"
echo "##       # # # ##### # # # ##### #  ## ###   ####            ##"
echo "##       #   # #   # #  ## #   # #   # #     #  #            ##"
echo "##       #   # #   # #   # #   # ##### ##### #   #           ##"
echo "##                                                           ##"   
echo "##                                                           ##"   
echo "##  brought to you by, ${AUTHORS}                               ##"   
echo "##                                                           ##"   
echo "##  ${PROJECT}  ##"
echo "##                                                           ##"   
echo "###############################################################"
echo

# make some checks first before proceeding.	

command -v npm -q >/dev/null 2>&1 || { echo >&2 "npm is required but not installed yet... please install and try again..."; exit 1; }

echo "Npm tooling present..."
echo

if [ -r $SUPPORT_DIR ] || [ -L $SUPPORT_DIR ]; then
        echo "Support dir is present..."
        echo
else
        echo "$SUPPORT_DIR wasn't found. Please make sure to run this script inside the demo directory."
        echo
        exit
fi

if [ -r $SRC_DIR/$EAP ] || [ -L $SRC_DIR/$EAP ]; then
	echo "Product EAP sources are present..."
	echo
else
	echo "Need to download $EAP package from https://developers.redhat.com/products/eap/download"
	echo "and place it in the $SRC_DIR directory to proceed..."
	echo
	exit
fi

if [ -r $SRC_DIR/$RHDM ] || [ -L $SRC_DIR/$RHDM ]; then
	echo "Product RHDM sources are present..."
	echo
else
	echo "Need to download $RHDM from https://developers.redhat.com/products/red-hat-decision-manager/download"
	echo "and place it in the $SRC_DIR directory to proceed..."
	echo
	exit
fi

if [ -r $SRC_DIR/$KIESERVER ] || [ -L $SRC_DIR/$KIESERVER ]; then
	echo "Product RHDM Kie Server sources are present..."
	echo
else
	echo "Need to download $KIESERVER from https://developers.redhat.com/products/red-hat-decision-manager/download"
	echo "and place it in the $SRC_DIR directory to proceed..."
	echo
	exit
fi

# Remove the old JBoss instance, if it exists.
if [ -x $JBOSS_HOME ]; then
	echo "  - removing existing installation directory..."
	echo
	rm -rf ./target
fi

# Installation.
echo "JBoss EAP installation running now..."
echo
mkdir -p ./target
unzip -qo $SRC_DIR/$EAP -d ./target

if [ $? -ne 0 ]; then
	echo "Error occurred during JBoss EAP installation!"
	echo
	exit
fi

echo "Red Hat Decision Manager installation running now..."
echo
unzip -qo $SRC_DIR/$RHDM -d ./target 

if [ $? -ne 0 ]; then
	echo "Error occurred during $PRODUCT installation!"
	echo
	exit
fi

echo "Red Hat Decision Manager KIE Server installation running now..."
echo
unzip -qo $SRC_DIR/$KIESERVER -d $JBOSS_HOME/standalone/deployments 

if [ $? -ne 0 ]; then
	echo "Error occurred during $PRODUCT installation!"
	echo
	exit
fi

# Set deployment Kie Server.
touch $JBOSS_HOME/standalone/deployments/kie-server.war.dodeploy

echo "  - enabling demo accounts role setup..."
echo
echo "  - User 'dmAdmin' password 'redhatdm1!' setup..."
echo
$JBOSS_HOME/bin/add-user.sh -a -r ApplicationRealm -u dmAdmin -p redhatdm1! -ro analyst,admin,manager,user,kie-server,kiemgmt,rest-all --silent 

if [ $? -ne 0 ]; then
	echo "Error occurred during user add dmAdmin!"
	echo
	exit
fi

echo "  - management user 'kieserver' password 'kieserver1!' setup..."
echo
$JBOSS_HOME/bin/add-user.sh -a -r ApplicationRealm -u kieserver -p kieserver1! -ro kie-server,rest-all --silent

if [ $? -ne 0 ]; then
	echo "Error occurred during user add kieserver!"
	echo
	exit
fi

echo "  - setting up standalone-full.xml configuration adjustments..."
echo
cp $SERVER_CONF/standalone-full.xml $SERVER_CONF/standalone.xml

echo "  - setup system properties"
echo
./target/jboss-eap-7.3/bin/jboss-cli.sh <<EOT
embed-server
/system-property=org.kie.server.location:add(value=http://localhost:8080/kie-server/services/rest/server)
/system-property=org.kie.server.controller:add(value=http://localhost:8080/decision-central/rest/controller)
/system-property=org.kie.server.controller.user:add(value=kieserver)
/system-property=org.kie.server.controller.pwd:add(value=kieserver1!)
/system-property=org.kie.server.user:add(value=kieserver)
/system-property=org.kie.server.pwd:add(value=kieserver1!)
/system-property=org.kie.server.id:add(value=default-kie-server)
/system-property=org.kie.override.deploy.enabled:add(value=true)
/system-property=org.kie.server.repo:add(value=\${jboss.home.dir}/bin})
/system-property=org.uberfire.metadata.index.dir:add(value=\${jboss.home.dir}/bin)   
/system-property=org.guvnor.m2repo.dir:add(value=\${jboss.home.dir}/bin)
/system-property=org.uberfire.nio.git.dir:add(value=\${jboss.home.dir}/bin)
EOT

echo "  - setup cors filters in undertow"
echo
$JBOSS_HOME/bin/jboss-cli.sh <<EOT
embed-server
/subsystem=undertow/server=default-server/host=default-host/filter-ref="Access-Control-Allow-Origin":add()
/subsystem=undertow/server=default-server/host=default-host/filter-ref="Access-Control-Allow-Methods":add()
/subsystem=undertow/server=default-server/host=default-host/filter-ref="Access-Control-Allow-Headers":add()
/subsystem=undertow/server=default-server/host=default-host/filter-ref="Access-Control-Allow-Credentials":add()
/subsystem=undertow/server=default-server/host=default-host/filter-ref="Access-Control-Max-Age":add()
/subsystem=undertow/configuration=filter/response-header="Access-Control-Allow-Origin":add(header-name="Access-Control-Allow-Origin",header-value="*")
/subsystem=undertow/configuration=filter/response-header="Access-Control-Allow-Methods":add(header-name="Access-Control-Allow-Methods",header-value="GET, POST, OPTIONS, PUT")
/subsystem=undertow/configuration=filter/response-header="Access-Control-Allow-Headers":add(header-name="Access-Control-Allow-Headers",header-value="accept, authorization, content-type, x-requested-with")
/subsystem=undertow/configuration=filter/response-header="Access-Control-Allow-Credentials":add(header-name="Access-Control-Allow-Credentials",header-value="true")
/subsystem=undertow/configuration=filter/response-header="Access-Control-Max-Age":add(header-name="Access-Control-Max-Age",header-value="1")
EOT

echo "  - setup email notification users..."
echo
cp $SUPPORT_DIR/userinfo.properties $SERVER_DIR/decision-central.war/WEB-INF/classes/

echo "  - making sure standalone.sh for server is executable..."
echo
chmod u+x $JBOSS_HOME/bin/standalone.sh

echo "  - setting up demo projects, copy default (internal) repositories..."
echo
rm -rf $SERVER_BIN/.niogit && mkdir -p $SERVER_BIN/.niogit && cp -r $SUPPORT_DIR/rhdm7-demo-niogit/* $SERVER_BIN/.niogit

if [ $? -ne 0 ]; then
	echo "Error occurred during copy of default repo!"
	echo
	exit
fi

# Copy the demo project repo.
echo "  - cloning the project's Git repo from ${PROJECT_GIT_REPO}..."
echo
rm -rf ./target/temp && mkdir -p ./target/temp && git clone -b $PROJECT_GIT_BRANCH --single-branch $PROJECT_GIT_REPO ./target/temp/$PROJECT_GIT_REPO_NAME

if [ $? -ne 0 ]; then
	echo "Error cloning project git repo, check connection!"
	echo
	exit
fi

pushd ./target/temp/$PROJECT_GIT_REPO_NAME

echo "  - renaming cloned branch '${PROJECT_GIT_BRANCH}' to 'master'..."
echo
git branch -m $PROJECT_GIT_BRANCH master

if [ $? -ne 0 ]; then
	echo "Error renmaing cloned branch to master!"
	echo
	exit
fi

popd

echo "  - replacing cached project git repo ${PROJECT_GIT_DIR}/${PROJECT_GIT_REPO_NAME}..."
echo
rm -rf $PROJECT_GIT_DIR/$PROJECT_GIT_REPO_NAME && mkdir -p $PROJECT_GIT_DIR && git clone --bare target/temp/$PROJECT_GIT_REPO_NAME $PROJECT_GIT_DIR/$PROJECT_GIT_REPO_NAME && rm -rf ./target/temp

if [ $? -ne 0 ]; then
	echo "Error replacing cached project git repo!"
	echo
	exit
fi

echo "  - copy repo to EAP installation directory..."
echo
rm -rf $SERVER_BIN/.niogit/$NIOGIT_PROJECT_GIT_REPO && cp -R $PROJECT_GIT_DIR/$PROJECT_GIT_REPO_NAME $SERVER_BIN/.niogit/$NIOGIT_PROJECT_GIT_REPO

if [ $? -ne 0 ]; then
	echo "Error copying to installation directory in EAP!"
	echo
	exit
fi

echo "  - installing the UI..."
echo
pushd ./support/application-ui/
npm install

if [ $? -ne 0 ]; then
	echo "Error installing UI!"
	echo
	exit
fi

popd

echo "=============================================================================="
echo "=                                                                            ="
echo "=  $PRODUCT $VERSION setup complete.                           ="
echo "=                                                                            ="
echo "=  You can now start the $PRODUCT with:                      ="
echo "=                                                                            ="
echo "=      $SERVER_BIN/standalone.sh                              ="
echo "=                                                                            ="
echo "=  Login to Red Hat Decision Manager to start developing rules projects:     ="
echo "=                                                                            ="
echo "=  http://localhost:8080/decision-central                                    ="
echo "=                                                                            ="
echo "=  [ u:dmAdmin / p:redhatdm1! ]                                              ="
echo "=                                                                            ="
echo "=  To start the front-end app, navigate to 'support/application-ui' and run: ="
echo "=                                                                            ="
echo "=   npm start                                                                ="
echo "=                                                                            ="
echo "=  See README.md for general details to run the various demo cases.          ="
echo "=                                                                            ="
echo "=============================================================================="
echo
