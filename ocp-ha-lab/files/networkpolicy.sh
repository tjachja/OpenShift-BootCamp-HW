#default deny all traffic
oc create -f templates/network-policy/default-deny.yaml

#allow traffic between pods in the same namespace
oc create -f templates/network-policy/allow-same-namespace.yaml

#allow traffic from default (for routers, etc)
oc create -f templates/network-policy/allow-default-namespace.yaml
