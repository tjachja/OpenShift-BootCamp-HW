#!/usr/bin/env bash
oc login -u system:admin -n default
cd /root/OpenShift-BootCamp-HW/ocp-ha-lab/container-pipelines/tasks

# Create Lifecycle Stages:
oc new-project tasks-build --display-name "Tasks App - Build"
oc new-project tasks-dev --display-name "Tasks App - Dev"
oc new-project tasks-stage --display-name "Tasks App - Stage"
oc new-project tasks-prod --display-name "Tasks App - Prod"

# Stand up jenkins master in build 
oc process openshift//jenkins-persistent | oc apply -f- -n tasks-build

# Instantiate Pipeline
oc process -f applier/templates/deployment.yml --param-file=applier/params/deployment-dev | oc apply -f-
oc process -f applier/templates/deployment.yml --param-file=applier/params/deployment-stage | oc apply -f-
oc process -f applier/templates/deployment.yml --param-file=applier/params/deployment-prod | oc apply -f-

# Deploy the pipeline template in dev only
oc process -f applier/templates/build.yml --param-file applier/params/build-dev | oc apply -f-

# Login to the webconsole as andrew to view jenkins pipeline
oc adm policy add-cluster-role-to-user cluster-admin andrew
