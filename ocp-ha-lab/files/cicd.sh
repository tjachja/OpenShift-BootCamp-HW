oc create -f ./container-pipelines/basic-spring-boot/applier/projects/projects.yml
oc process openshift//jenkins-persistent | oc apply -f- -n basic-spring-boot-build
oc process -f ./container-pipelines/basic-spring-boot/applier/templates/deployment.yml --param-file=./container-pipelines/basic-spring-boot/applier/params/deployment-dev | oc apply -f-
oc process -f ./container-pipelines/basic-spring-boot/applier/templates/deployment.yml --param-file=./container-pipelines/basic-spring-boot/applier/params/deployment-stage | oc apply -f-
oc process -f ./container-pipelines/basic-spring-boot/applier/templates/deployment.yml --param-file=./container-pipelines/basic-spring-boot/applier/params/deployment-prod | oc apply -f-
oc process -f ./container-pipelines/basic-spring-boot/applier/templates/build.yml --param-file=./container-pipelines/basic-spring-boot/applier/params/build-dev | oc apply -f-
