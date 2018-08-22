# OpenShift-BootCamp-HW

## Review the Env_Type variable file

* This file link:./env_vars.yml[./env_vars.yml] contains all the variables you
 need to define to control the deployment of your environment.

## Running the Ansible Playbook

. You can run the playbook with the following arguments to overwrite the default variable values:
[source,bash]
----
# Set the your environment variables (this is optional, but makes life easy)

REGION=ap-southeast-1
KEYNAME=ocpkey
GUID=testnewec21
ENVTYPE="ocp-ha-lab"
CLOUDPROVIDER=ec2v2
HOSTZONEID='Z3IHLWJZOU9SRT'
REPO_PATH='https://admin.example.com/repos/ocp/3.6/'

BASESUFFIX='.example.opentlc.com'
IPAPASS=aaaaaa
REPO_VERSION=3.6
NODE_COUNT=2
DEPLOYER_REPO_PATH=`pwd`
LOG_FILE=$(pwd)/${ENVTYPE}-${GUID}.log

## For a HA environment that is not installed with OpenShift


  ansible-playbook main.yml  -e "guid=${GUID}"
