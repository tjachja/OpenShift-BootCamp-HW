#!/usr/bin/env bash

# multiple clients created 
oc login -u system:admin -n default

ansible masters -m shell -a 'htpasswd -b /etc/origin/master/htpasswd Amy r3dh4t1!'
ansible masters -m shell -a 'htpasswd -b /etc/origin/master/htpasswd Andrew r3dh4t1!'
ansible masters -m shell -a 'htpasswd -b /etc/origin/master/htpasswd Brian r3dh4t1!'
ansible masters -m shell -a 'htpasswd -b /etc/origin/master/htpasswd Betty r3dh4t1!'

oc adm groups new alpha Amy Andrew
oc adm groups new beta Brian Betty

for OCP_USERNAME in Amy Andrew Brian Betty; do

oc create clusterquota clusterquota-$OCP_USERNAME \
 --project-annotation-selector=openshift.io/requester=$OCP_USERNAME \
 --hard pods=25 \
 --hard requests.memory=6Gi \
 --hard requests.cpu=5 \
 --hard limits.cpu=25  \
 --hard limits.memory=40Gi \
 --hard configmaps=25 \
 --hard persistentvolumeclaims=25  \
 --hard services=25

done

# new project template is modified to include a LimitRange 
oc create -f /root/OpenShift-BootCamp-HW/ocp-ha-lab/files/templates/template.yaml -n default

ansible masters -m shell -a "sed -i 's/projectRequestTemplate.*/projectRequestTemplate\: \"default\/project-request\"/g' /etc/origin/master/master-config.yaml"
ansible masters -m shell -a'systemctl restart atomic-openshift-master-api'
ansible masters -m shell -a'systemctl restart atomic-openshift-master-controllers'
