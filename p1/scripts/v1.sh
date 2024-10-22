#!/bin/bash

# Install K3s in controller mode
curl -sfL https://get.k3s.io | sh -s - --node-ip=192.168.56.110 --flannel-iface=eth1

# Wait for K3s to be ready
while ! sudo k3s kubectl get node &>/dev/null; do
    sleep 1
done

# Get the node token
NODE_TOKEN=$(sudo cat /var/lib/rancher/k3s/server/node-token)

# Make the node token available to the worker node
echo $NODE_TOKEN > /vagrant/node-token

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Set up kubectl for the vagrant user
mkdir -p /home/vagrant/.kube
sudo cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config
sudo chown vagrant:vagrant /home/vagrant/.kube/config
echo "export KUBECONFIG=/home/vagrant/.kube/config" >> /home/vagrant/.bashrc

echo "K3s controller and kubectl have been installed and configured."
