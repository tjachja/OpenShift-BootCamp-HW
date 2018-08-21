#!/usr/bin/env bash
oc login -u andrew -p r3dh4t1!

oc new-project tasks-build --display-name "Tasks App - Build"
oc new-project tasks-dev --display-name "Tasks App - Dev"
oc new-project tasks-stage --display-name "Tasks App - Stage"
oc new-project tasks-prod --display-name "Tasks App - Prod"

ansible-playbook -i container-pipelines/tasks/applier/inventory/ openshift-applier/playbooks/openshift-cluster-seed.yml