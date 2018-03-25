# Quick Loan Bank - UI

Quick Loan Bank UI is an example demo invoking a decision service based on [Red Hat Decision Manager 7](https://www.redhat.com/en/technologies/jboss-middleware/businessrules).

![qlb rhdm 7 demo](img/qlb_rhdm.png?raw=true)

The Quick Loan Bank UI is based on [AngularJS](https://angularjs.org) and [PatternFly](http://patternfly.org)

![qlb ui](img/qlb_ui.png?raw=true)

## Prerequisites

1. Enable Cross-Origin Resource Sharing (CORS) on the server where the Loan Application Decision Service is deployed
For EAP 7.1, add or replace existing undertow in your configuration file:

        <subsystem xmlns="urn:jboss:domain:undertow:4.0">
            <buffer-cache name="default"/>
            <server name="default-server">
                <http-listener name="default" socket-binding="http" redirect-socket="https" enable-http2="true"/>
                <https-listener name="https" socket-binding="https" security-realm="ApplicationRealm" enable-http2="true"/>
                <host name="default-host" alias="localhost">
                    <location name="/" handler="welcome-content"/>
                    <filter-ref name="server-header"/>
                    <filter-ref name="x-powered-by-header"/>

                    <filter-ref name="Access-Control-Allow-Origin"/>
                    <filter-ref name="Access-Control-Allow-Methods"/>
                    <filter-ref name="Access-Control-Allow-Headers"/>                                        
                    <filter-ref name="Access-Control-Allow-Credentials"/>   

                    <http-invoker security-realm="ApplicationRealm"/>
                </host>
            </server>
            <servlet-container name="default">
                <jsp-config/>
                <websockets/>
            </servlet-container>
            <handlers>
                <file name="welcome-content" path="${jboss.home.dir}/welcome-content"/>
            </handlers>
            <filters>
                <response-header name="server-header" header-name="Server" header-value="JBoss-EAP/7"/>
                <response-header name="x-powered-by-header" header-name="X-Powered-By" header-value="Undertow/1"/>

                <response-header name="Access-Control-Allow-Origin" header-name="Access-Control-Allow-Origin" header-value="http://localhost:3000"/>
                <response-header name="Access-Control-Allow-Methods" header-name="Access-Control-Allow-Methods" header-value="GET, POST, OPTIONS"/>
                <response-header name="Access-Control-Allow-Headers" header-name="Access-Control-Allow-Headers" header-value="Authorization , Content-Type"/>
                <response-header name="Access-Control-Allow-Credentials" header-name="Access-Control-Allow-Credentials" header-value="true"/>  

            </filters>
        </subsystem>

2. Verify that the Loan Application Decision Service is up and running here:



http://localhost:8080/kie-server/services/rest/server/containers/loan-application_1.0

If not, follow the instructions here:

https://github.com/snoussi/qlb-loan-application-repo




## Deploying the web UI

1. Clone this repo

```bash
$ git clone https://github.com/snoussi/qlb-loan-application-ui.git
```

2. Once you have it, `cd` into your project folder and install the dependencies:

```bash
$ cd qlb-loan-application-ui
$ npm install
```

3. We will use the browsersync tool to serve and refresh our web content 
Start browsersync by running:

```bash
$ npm start
```

This will start a server at http://localhost:3000/

## Supporting videos
### Rules Update and Hot Deployment
[![Rules Update and Hot Deployment](https://i.imgur.com/XKsmHMV.png)](https://vimeo.com/259899040 "Rules Update and Hot Deployment")
