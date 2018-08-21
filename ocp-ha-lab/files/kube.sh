#!/usr/bin/env bash
ansible masters[0] -b -m fetch -a "src=/root/.kube/config dest=/root/.kube/config flat=yes"
# Create directories on the support1.$GUID.internal NFS server to be used as PVs in the OpenShift cluster. 
# These directories should be under /srv/nfs because this directory is backed by a separate volume group.
export GUID=`hostname|awk -F. '{print $2}'`
echo "export GUID=$GUID" >> ~/.bashrc
echo $GUID