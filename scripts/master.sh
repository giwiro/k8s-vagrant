#!/bin/bash

POD_NETWORK_CIDR="$1"

function print_green_tag {
  printf "\e[1;32m[$1]\e[0m$2\n"
}

function print_blue_tag {
  printf "\e[38;5;81m[$1]\e[0m$2\n"
}

echo ""
echo "Configured Variables:"
print_blue_tag "POD_NETWORK_CIDR" ": $POD_NETWORK_CIDR"
echo ""

echo "[TASK 1] Initialize Kubernetes Cluster"
kubeadm init --pod-network-cidr=10.244.0.0/16
