#!/bin/bash

function print_green_tag {
  printf "\e[1;32m[$1]\e[0m$2\n"
}

function print_blue_tag {
  printf "\e[38;5;81m[$1]\e[0m$2\n"
}

echo ""
print_blue_tag "WORKER SETUP"
echo ""

print_green_tag "TASK" ": Join cluster"
bash /vagrant/tmp/join-cluster.sh
echo ""

echo ""
print_blue_tag "FINISHED WORKER SETUP"
echo ""
