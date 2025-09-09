#!/bin/bash

MASTER_PRIVATE_IP="$1"
NUMBER_NODES="$2"
NODES_PRIVATE_IP_PREFIX="$3"
TLS_CHECK_DISABLE="$4"

# Change to latest version
KUBERNETES_VERSION="v1.33"
CRIO_VERSION="v1.33"

CURL_OPTIONS=""

if [ "$TLS_CHECK_DISABLE" = "true" ] ; then
  CURL_OPTIONS="$CURL_OPTIONS -k"
  echo 'Acquire::https::Verify-Peer "false";' | sudo tee /etc/apt/apt.conf.d/99no-verify-ssl > /dev/null
fi

function print_green_tag {
  printf "\e[1;32m[$1]\e[0m$2\n"
}

function print_blue_tag {
  printf "\e[38;5;81m[$1]\e[0m$2\n"
}

echo ""
print_blue_tag "MACHINE SETUP"
echo ""

echo ""
echo "Configured variables:"
print_blue_tag "MASTER_PRIVATE_IP" ": $MASTER_PRIVATE_IP"
print_blue_tag "NUMBER_NODES" ": $NUMBER_NODES"
print_blue_tag "NODES_PRIVATE_IP_PREFIX" ": $NODES_PRIVATE_IP_PREFIX"
print_blue_tag "TLS_CHECK_DISABLE" ": $TLS_CHECK_DISABLE"
echo ""

echo "Configured options:"
print_blue_tag "CURL_OPTIONS" ": $CURL_OPTIONS"
echo ""

print_green_tag "TASK" " Update hosts"
echo "$MASTER_PRIVATE_IP master master" | tee -a /etc/hosts
for (( i=1; i<=$NUMBER_NODES; i++ )); do
  echo "${NODES_PRIVATE_IP_PREFIX}$((i + 1)) worker$i worker$i" | tee -a /etc/hosts
done
echo ""

print_green_tag "TASK" " Upgrade system and install common packages"
apt-get update
apt-get upgrade
apt-get install -y software-properties-common apt-transport-https ca-certificates curl gpg
echo ""

print_green_tag "TASK" " Add the cri-o repository"
curl $CURL_OPTIONS -fsSL https://download.opensuse.org/repositories/isv:/cri-o:/stable:/$CRIO_VERSION/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/cri-o-apt-keyring.gpg] https://download.opensuse.org/repositories/isv:/cri-o:/stable:/$CRIO_VERSION/deb/ /" | tee /etc/apt/sources.list.d/cri-o.list
apt-get update
echo ""

print_green_tag "TASK" " Install cri-o"
apt-get install -y cri-o
if [ "$TLS_CHECK_DISABLE" = "true" ] ; then
  sudo tee /etc/containers/registries.conf.d/99-insecure-registries.conf > /dev/null <<EOF
[[registry]]
location = "docker.io"
insecure = true

[[registry]]
location = "registry.k8s.io"
insecure = true

[[registry]]
location = "dl.k8s.io"
insecure = true

[[registry]]
location = "ghcr.io"
insecure = true
EOF
fi
echo "Kernel level configurations (turn off swap, use netfilter, ip packet forward)"
swapoff -a
modprobe br_netfilter
sysctl -w net.bridge.bridge-nf-call-iptables=1
sysctl -w net.ipv4.ip_forward=1
echo "Restart and enable crio.service"
systemctl enable crio --now
systemctl restart crio.service
echo ""

print_green_tag "TASK" " Add the Kubernetes repository"
curl $CURL_OPTIONS -fsSL https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/ /" |  tee /etc/apt/sources.list.d/kubernetes.list
apt-get update
echo ""

print_green_tag "TASK" " Upgrade system"
apt-get upgrade
echo ""

print_green_tag "TASK" " Install Kubernetes (kubelet, kubeadm, kubectl)"
apt-get install -y kubelet kubeadm kubectl
systemctl restart kubelet.service
systemctl restart crio.service
echo ""

print_green_tag "TASK" " Add useful alias"
echo 'alias k="kubectl"' >> ~/.bashrc
echo ""

echo ""
print_blue_tag "FINISHED MACHINE SETUP"
echo ""
