#!/bin/bash

taginstance () { # $1 node name, $2 node label, $3 node value
cat > patch.json <<EOF
[
 {
 "op": "add", "path": "/metadata/labels/$2", "value": "$3"
 }
]
EOF
curl --request PATCH --data "$(cat patch.json)" -H "Content-Type:application/json-patch+json" http://k8s.mbst.tv:8080/api/v1/nodes/$1 >> /dev/null
}

LOCAL_HOSTNAME=`curl -L http://169.254.169.254/latest/meta-data/local-hostname`

if [[ `aws ec2 describe-instances --region eu-west-1 --instance-ids=$(curl -L http://169.254.169.254/latest/meta-data/instance-id) | jq '.Reservations[].Instances[].Tags[] | select ( .Key | contains("elastic-ip-id") )'` == *eipalloc* ]]; then
  ELASTIC_IP_ID=`aws ec2 describe-instances --region eu-west-1 --instance-ids=$(curl -L http://169.254.169.254/latest/meta-data/instance-id) | jq '.Reservations[].Instances[].Tags[] | select ( .Key | contains("elastic-ip-id") ).Value' | sed 's/\"//g'`
  aws ec2 associate-address --region eu-west-1 --allocation-id=$ELASTIC_IP_ID --instance-id=$(curl -L http://169.254.169.254/latest/meta-data/instance-id)
  taginstance $LOCAL_HOSTNAME elastic-ip-instance true
else
  taginstance $LOCAL_HOSTNAME elastic-ip-instance false
fi

if [[ `aws ec2 describe-instances --region eu-west-1 --instance-ids=$(curl -L http://169.254.169.254/latest/meta-data/instance-id) | jq '.Reservations[].Instances[].InstanceLifecycle'` == *spot* ]]; then
  taginstance $LOCAL_HOSTNAME spot-instance true
else
  taginstance $LOCAL_HOSTNAME spot-instance false
fi
