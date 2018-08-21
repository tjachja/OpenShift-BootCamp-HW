#!/usr/bin/env bash
oc login -u andrew -p r3dh4t1!
## 1. Create Lifecycle Stages
oc create -f ../container-pipelines/tasks/applier/projects/projects.yml

## 2. Stand up Jenkins master in dev
oc new-app jboss-eap70-openshift:1.6~https://github.com/wkulhanek/openshift-tasks
oc process openshift//jenkins-persistent | oc apply -f- -n tasks-build

## 3. Instantiate Pipeline
oc process -f ../container-pipelines/tasks/applier/templates/deployment.yml --param-file=../container-pipelines/tasks/applier/params/deployment-dev | oc apply -f-
oc process -f ../container-pipelines/tasks/applier/templates/deployment.yml --param-file=../container-pipelines/tasks/applier/params/deployment-stage | oc apply -f-
oc process -f ../container-pipelines/tasks/applier/templates/deployment.yml --param-file=../container-pipelines/tasks/applier/params/deployment-prod | oc apply -f-
oc process -f ../container-pipelines/tasks/applier/templates/build.yml --param-file ../container-pipelines/tasks/applier/params/build-dev | oc apply -f-