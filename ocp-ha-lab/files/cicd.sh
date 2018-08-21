#!/usr/bin/env bash

echo '************\nSetting up CI/CD Pipeline\n************'
oc new-project cicd
#set up Jenkins with a PV
oc new-app jenkins-persistent --param ENABLE_OAUTH=true
echo "Waiting for Jenkins to spin up"
sleep 60
#now set up openshift-tasks
oc new-project tasks
## 1. Create Lifecycle Stages
oc create -f applier/projects/projects.yml

## 2. Stand up Jenkins master in dev
oc new-app jboss-eap70-openshift:1.6~https://github.com/wkulhanek/openshift-tasks
oc process openshift//jenkins-persistent | oc apply -f- -n tasks-build
## 3. Instantiate Pipeline
oc process -f ../container-pipelines/tasks/applier/templates/deployment.yml --param-file=../container-pipelines/tasks/applier/params/deployment-dev | oc apply -f-
oc process -f ../container-pipelines/tasks/applier/templates/deployment.yml --param-file=../container-pipelines/tasks/applier/params/deployment-stage | oc apply -f-
oc process -f ../container-pipelines/tasks/applier/templates/deployment.yml --param-file=../container-pipelines/tasks/applier/params/deployment-prod | oc apply -f-
oc process -f ../container-pipelines/tasks/applier/templates/build.yml --param-file applier/params/build-dev | oc apply -f-