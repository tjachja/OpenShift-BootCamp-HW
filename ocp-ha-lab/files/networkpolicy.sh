#!/usr/bin/env bash

#default deny all traffic
oc create -f /root/OpenShift-BootCamp-HW/ocp-ha-lab/files/templates/default-deny.yaml

#allow traffic between pods in the same namespace
oc create -f /root/OpenShift-BootCamp-HW/ocp-ha-lab/files/templates/allow-3306.yaml

#allow traffic from default (for routers, etc)
oc create -f /root/OpenShift-BootCamp-HW/ocp-ha-lab/files/templates/allow-8080-frontend.yaml
