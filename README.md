# kube-aws-labels

> Available on Docker Hub: https://hub.docker.com/r/grrywlsn/kube-aws-labels/
>
GitHub repo: https://github.com/grrywlsn/kube-aws-labels

This is a Docker container to run on a Kubernetes node's OS (eg. a CoreOS level, not as a pod), which will add a label saying whether or not the EC2 instance is a spot instance.

It can also optionally attach an elastic IP, and will add a node label if it does so. You can choose which elastic IP to add by setting an instance tag named `elastic-ip-id` with th `eipalloc id` as its value.

## still to do

- pass in Kubernetes API as variable
- aws region as variable
- override if AWS local-hostname is not node name
