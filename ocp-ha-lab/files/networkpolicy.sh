#default deny all traffic
oc create -f ./templates/network-policy/default-deny.yaml

#allow traffic between pods in the same namespace
oc create -f ./templates/network-policy/allow-3306.yaml

#allow traffic from default (for routers, etc)
oc create -f ./templates/network-policy/allow-8080-frontend.yaml
