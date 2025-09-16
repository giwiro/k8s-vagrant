#!/bin/bash

POD_NETWORK_CIDR="$1"
MASTER_PRIVATE_IP="$2"
TLS_CHECK_DISABLE="$3"

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
print_blue_tag "MASTER_PRIVATE_IP" ": $MASTER_PRIVATE_IP"
print_blue_tag "TLS_CHECK_DISABLE" ": $TLS_CHECK_DISABLE"
echo ""

echo "Configured options:"
print_blue_tag "WGET_OPTIONS" ": $WGET_OPTIONS"
echo ""

print_green_tag "TASK" ": Initialize Kubernetes Cluster"
kubeadm init \
  --apiserver-advertise-address="$MASTER_PRIVATE_IP" \
  --pod-network-cidr="$POD_NETWORK_CIDR" \
  --apiserver-cert-extra-sans="$MASTER_PRIVATE_IP" \
  --upload-certs
echo ""

print_green_tag "TASK" ": Copy kube admin config to user and root .kube directory"
mkdir -p /home/vagrant/.kube
cp /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube

mkdir -p /root/.kube
cp /etc/kubernetes/admin.conf /root/.kube/config
chown -R root:root /root/.kube

systemctl restart kubelet.service
echo ""

print_green_tag "TASK" ": Install flannel"
KUBE_FLANNEL_FILE=kube-flannel.yml
wget $WGET_OPTIONS -O $KUBE_FLANNEL_FILE https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
# Change CIDR
sed -i -e "s#\"Network\": \".*\"#\"Network\": \"$POD_NETWORK_CIDR\"#g" $KUBE_FLANNEL_FILE
# Find right interface
INTERFACE_NAME=eth0
INTERFACE_NAME=$(ip addr | awk -vtarget_addr="$MASTER_PRIVATE_IP" '
  /^[0-9]+:/ {
    iface=substr($2, 0, length($2)-1)
  }
  $1 == "inet" {
    split($2, addr, "/")
    if (addr[1] == target_addr) {
      print iface
    }
  }
')
echo "INTERFACE_NAME=$INTERFACE_NAME"
sed -i -e "/containers:/,/args:/!b;/args:/a\        - --iface=$INTERFACE_NAME" $KUBE_FLANNEL_FILE
sudo -u vagrant kubectl apply -f $KUBE_FLANNEL_FILE
echo ""

print_green_tag "TASK" ": Generate /vagrant/tmp/join-cluster.sh"
mkdir -p /vagrant/tmp
kubeadm token create --print-join-command > /vagrant/tmp/join-cluster.sh 2>/dev/null
echo ""

echo ""
print_blue_tag "FINISHED MASTER SETUP"
echo ""
