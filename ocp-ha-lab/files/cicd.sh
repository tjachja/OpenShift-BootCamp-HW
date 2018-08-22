#!/usr/bin/env bash

# Login to the webconsole as Andrew to view jenkins pipeline
oc adm policy add-cluster-role-to-user cluster-admin andrew

oc login -u system:admin -n default

# Create Lifecycle Stages:
oc new-project tasks-build --display-name "Tasks App - Build"
oc new-project tasks-dev --display-name "Tasks App - Dev"
oc new-project tasks-stage --display-name "Tasks App - Stage"
oc new-project tasks-prod --display-name "Tasks App - Prod"

# Stand up jenkins master in dev
oc process openshift//jenkins-persistent | oc apply -f- -n tasks-dev
oc delete networkpolicy deny-by-default -n tasks-dev

oc create -f  /root/OpenShift-BootCamp-HW/ocp-ha-lab/files/templates/allow-8080-frontend.yaml -n tasks-dev

# Instantiate Pipeline
oc process -f /root/OpenShift-BootCamp-HW/ocp-ha-lab/container-pipelines/tasks/applier/templates/deployment.yml --param-file=/root/OpenShift-BootCamp-HW/ocp-ha-lab/container-pipelines/tasks/applier/params/deployment-dev | oc apply -f-
oc process -f /root/OpenShift-BootCamp-HW/ocp-ha-lab/container-pipelines/tasks/applier/templates/deployment.yml --param-file=/root/OpenShift-BootCamp-HW/ocp-ha-lab/container-pipelines/tasks/applier/params/deployment-stage | oc apply -f-
oc process -f /root/OpenShift-BootCamp-HW/ocp-ha-lab/container-pipelines/tasks/applier/templates/deployment.yml --param-file=/root/OpenShift-BootCamp-HW/ocp-ha-lab/container-pipelines/tasks/applier/params/deployment-prod | oc apply -f-

# Deploy the pipeline template in dev only
oc process -f /root/OpenShift-BootCamp-HW/ocp-ha-lab/container-pipelines/tasks/applier/templates/build.yml --param-file /root/OpenShift-BootCamp-HW/ocp-ha-lab/container-pipelines/tasks/applier/params/build-dev | oc apply -f-

