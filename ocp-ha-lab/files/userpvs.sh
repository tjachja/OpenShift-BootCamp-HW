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

cat /root/pvs/* | oc create -f -

ansible nodes -m shell -a "docker pull registry.access.redhat.com/openshift3/ose-recycler:latest"
ansible nodes -m shell -a "docker tag registry.access.redhat.com/openshift3/ose-recycler:latest registry.access.redhat.com/openshift3/ose-recycler:v3.9.30"