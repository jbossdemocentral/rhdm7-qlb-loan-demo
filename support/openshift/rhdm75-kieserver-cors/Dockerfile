FROM registry.redhat.io/rhdm-7/rhdm75-kieserver-openshift:1.0

ADD ./contrib/standalone-openshift.xml /opt/eap/standalone/configuration/standalone-openshift.xml
USER root
RUN chown jboss:root /opt/eap/standalone/configuration/standalone-openshift.xml && chmod 664 /opt/eap/standalone/configuration/standalone-openshift.xml
USER jboss
