# Use jbossdemocentral/developer as the base
FROM quay.io/jbossdemocentral/developer

# Maintainer details
MAINTAINER Red Hat

#Arguments
ARG DM_VERSION
ARG DM_DECISION_CENTRAL
ARG DM_KIE_SERVER
ARG EAP
ARG PROJECT_GIT_REPO
#ARG NIOGIT_PROJECT_GIT_REPO
ARG JBOSS_EAP
#ARG EAP_PATCH

# Environment Variables
ENV HOME /opt/jboss
ENV JBOSS_HOME $HOME/$JBOSS_EAP

# ADD Installation Files
COPY installs/$DM_DECISION_CENTRAL installs/$DM_KIE_SERVER installs/$EAP /opt/jboss/

# Update Permissions on Installers
USER root
RUN chown jboss:jboss /opt/jboss/$EAP /opt/jboss/$DM_DECISION_CENTRAL /opt/jboss/$DM_KIE_SERVER
USER jboss

# Prepare and run installer and cleanup installation components
RUN unzip -qo /opt/jboss/$EAP -d $HOME && \
    unzip -qo /opt/jboss/$DM_DECISION_CENTRAL -d $HOME && \
		unzip -qo /opt/jboss/$DM_KIE_SERVER -d $JBOSS_HOME/standalone/deployments && touch $JBOSS_HOME/standalone/deployments/kie-server.war.dodeploy && \
    rm -rf /opt/jboss/$DM_DECISION_CENTRAL /opt/jboss/$DM_KIE_SERVER /opt/jboss/$EAP $JBOSS_HOME/standalone/configuration/standalone_xml_history/

# Copy demo and support files
COPY support/rhdm7-demo-niogit $JBOSS_HOME/bin/.niogit
# Clone the rhdm7-qlb-loan-demo-repo repository
USER root
RUN rm -rf $JBOSS_HOME/bin/.niogit/MySpace/rhdm7-qlb-loan-demo-repo.git && git clone --bare $PROJECT_GIT_REPO $JBOSS_HOME/bin/.niogit/MySpace/rhdm7-qlb-loan-demo-repo.git
USER 1000

# Create users
RUN $JBOSS_HOME/bin/add-user.sh -a -r ApplicationRealm -u dmAdmin -p redhatdm1! -ro analyst,admin,manager,user,kie-server,kiemgmt,rest-all --silent  && \
  $JBOSS_HOME/bin/add-user.sh -a -r ApplicationRealm -u kieserver -p kieserver1! -ro kie-server --silent

# Add support files
COPY support/standalone-full.xml $JBOSS_HOME/standalone/configuration/
COPY support/userinfo.properties $JBOSS_HOME/standalone/deployments/decision-central.war/WEB-INF/classes/

# Switch back to root user to perform cleanup
USER root

# Fix permissions on support files
RUN chown -R jboss:jboss $JBOSS_HOME/bin/.niogit $JBOSS_HOME/standalone/configuration/standalone-full.xml $JBOSS_HOME/standalone/deployments/decision-central.war/WEB-INF/classes/userinfo.properties

# Run as JBoss
USER jboss

# Expose Ports
EXPOSE 9990 9999 8080

# Run Red Hat Decision Manager
ENTRYPOINT ["/opt/jboss/jboss-eap-7.2/bin/standalone.sh"]
CMD ["-c","standalone-full.xml","-b", "0.0.0.0","-bmanagement","0.0.0.0"]
