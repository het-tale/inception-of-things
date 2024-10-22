#!/bin/bash

# Wait for the node token to be available
while [ ! -f /vagrant/node-token ]; do
    sleep 1
done

# Get the node token
NODE_TOKEN=$(cat /vagrant/node-token)

# Install K3s in agent mode
curl -sfL https://get.k3s.io | K3S_URL=https://192.168.56.110:6443 K3S_TOKEN=$NODE_TOKEN sh -s - --node-ip=192.168.56.111 --flannel-iface=eth1

echo "K3s agent has been installed and configured."
