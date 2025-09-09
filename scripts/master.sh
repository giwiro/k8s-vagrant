#!/bin/bash

POD_NETWORK_CIDR="$1"
TLS_CHECK_DISABLE="$2"

WGET_OPTIONS=""

if [ "$TLS_CHECK_DISABLE" = "true" ] ; then
  WGET_OPTIONS="$WGET_OPTIONS --no-check-certificate"
fi

function print_green_tag {
  printf "\e[1;32m[$1]\e[0m$2\n"
}

function print_blue_tag {
  printf "\e[38;5;81m[$1]\e[0m$2\n"
}

echo ""
print_blue_tag "MASTER SETUP"
echo ""

echo ""
echo "Configured variables:"
print_blue_tag "POD_NETWORK_CIDR" ": $POD_NETWORK_CIDR"
print_blue_tag "TLS_CHECK_DISABLE" ": $TLS_CHECK_DISABLE"
echo ""

echo "Configured options:"
print_blue_tag "WGET_OPTIONS" ": $WGET_OPTIONS"
echo ""

print_green_tag "TASK" ": Initialize Kubernetes Cluster"
kubeadm init --pod-network-cidr="$POD_NETWORK_CIDR"
echo ""

print_green_tag "TASK" ": Copy kube admin config to user and root .kube directory"
mkdir -p /home/vagrant/.kube
cp /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube

mkdir -p /root/.kube
cp /etc/kubernetes/admin.conf /root/.kube/config
chown -R root:root /root/.kube

systemctl restart kublet.service
echo ""

print_green_tag "TASK" ": Install flannel"
KUBE_FLANNEL_FILE=kube-flannel.yml
wget $WGET_OPTIONS -O $KUBE_FLANNEL_FILE https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
sed -i -e "s#10.244.0.0/16#$POD_NETWORK_CIDR#g" $KUBE_FLANNEL_FILE
sudo -u vagrant kubectl apply -f $KUBE_FLANNEL_FILE
echo ""

print_green_tag "TASK" ": Generate /vagrant/tmp/join-cluster.sh"
mkdir -p /vagrant/tmp
kubeadm token create --print-join-command > /vagrant/tmp/join-cluster.sh 2>/dev/null
echo ""

echo ""
print_blue_tag "FINISHED MASTER SETUP"
echo ""
