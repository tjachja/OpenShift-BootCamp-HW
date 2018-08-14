ansible masters[0] -b -m fetch -a "src=/root/.kube/config dest=/root/.kube/config flat=yes"
# Create directories on the support1.$GUID.internal NFS server to be used as PVs in the OpenShift cluster. 
# These directories should be under /srv/nfs because this directory is backed by a separate volume group.
export GUID=`hostname|awk -F. '{print $2}'`
echo "export GUID=$GUID" >> ~/.bashrc
echo $GUID

ssh support1.$GUID.internal
sudo -i
mkdir -p /srv/nfs/user-vols/pv{1..200}

for pvnum in {1..50} ; do
echo /srv/nfs/user-vols/pv${pvnum} *(rw,root_squash) >> /etc/exports.d/openshift-uservols.exports
chown -R nfsnobody.nfsnobody  /srv/nfs
chmod -R 777 /srv/nfs
done

systemctl restart nfs-server
exit
exit

# On your bastion create 25 definition files for PVs pv1 to pv25 with a size of 5 GB and ReadWriteOnce access mode.
export GUID=`hostname|awk -F. '{print $2}'`

export volsize="5Gi"
mkdir /root/pvs
for volume in pv{1..25} ; do
cat << EOF > /root/pvs/${volume}
{
  "apiVersion": "v1",
  "kind": "PersistentVolume",
  "metadata": {
    "name": "${volume}"
  },
  "spec": {
    "capacity": {
        "storage": "${volsize}"
    },
    "accessModes": [ "ReadWriteOnce" ],
    "nfs": {
        "path": "/srv/nfs/user-vols/${volume}",
        "server": "support1.${GUID}.internal"
    },
    "persistentVolumeReclaimPolicy": "Recycle"
  }
}
EOF
echo "Created def file for ${volume}";
done;

# On your bastion create 25 definition files for PVs pv26 to pv50 with a size of 10 GB and ReadWriteMany access mode.
export GUID=`hostname|awk -F. '{print $2}'`

export volsize="10Gi"
for volume in pv{26..50} ; do
cat << EOF > /root/pvs/${volume}
{
  "apiVersion": "v1",
  "kind": "PersistentVolume",
  "metadata": {
    "name": "${volume}"
  },
  "spec": {
    "capacity": {
        "storage": "${volsize}"
    },
    "accessModes": [ "ReadWriteMany" ],
    "nfs": {
        "path": "/srv/nfs/user-vols/${volume}",
        "server": "support1.${GUID}.internal"
    },
    "persistentVolumeReclaimPolicy": "Retain"
  }
}
EOF
echo "Created def file for ${volume}";
done;

# Use oc create to create all of the PVs you defined.
cat /root/pvs/* | oc create -f -