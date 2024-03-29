# Kubernetes Setup Script

This script automates the setup of a Kubernetes cluster on Ubuntu. It's designed to be a quick start for DevOps engineers and software developers looking to jump straight into container orchestration without the manual setup hassle.

## Features

- Disables swap
- Installs necessary packages and kernel modules
- Sets up Docker and containerd
- Installs and initializes Kubernetes (kubelet, kubeadm, kubectl)
- Applies Calico as the network plugin
- Prepares the system for Kubernetes with optimal settings

## Prerequisites

- Ubuntu Linux (18.04/20.04)
- Root access
- Internet connection

## Usage

### Create user and upgrade system
1. Download the Script
    Use `curl` to download the script directly into your environment:

   ```bash
   bash <(curl -s https://raw.githubusercontent.com/ksobitov/dotfiles/main/server/basic_setup.sh)
   ```

   After this command update and upgrade system
   
   ```bash
   apt update && apt upgrade -y
   ```
   
    After this reboot your system
   ```bash
   init 6
   ```

   Next: Connect your server via **ssh** and change user
   
   ```bash
   ssh root@<YOUR_IP_ADDRESS>

   su -l <USERNAME>
   ```

   After this you can install Kubernetes

### Install Kubernetes
1. **Download the Script**

    Use `curl` to download the script directly into your environment:

    ```bash
    bash <(curl -s https://raw.githubusercontent.com/ksobitov/dotfiles/main/server/kubernetes_setup.sh)
    ```

    Follow any on-screen instructions. The script will output a `kubeadm join` command for joining nodes to your cluster.

## Post-Setup
Before initializing your Kubernetes cluster

```bash
sudo kubeadm config images pull
```

Initializing your Kubernetes cluster

```bash
sudo kubeadm init --pod-network-cidr=192.168.1.0/16
```

Setting up kubectl

```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

Enabling kubectl autocomplete
    
```bash
echo "source <(kubectl completion bash)" >> ~/.bashrc
source ~/.bashrc
```
    
Deploying the Calico network plugin

```bash
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.2/manifests/calico.yaml
```
Let's take a peek at your cluster's status

```bash
kubectl get nodes
```


After running the script, your Kubernetes cluster will be up. Use the `kubeadm join` command provided at the end of the script output to add worker nodes to your cluster.

## Support

For issues or questions, please open an issue in the GitHub repository.

## Contributing

Contributions are welcome! Please submit a pull request or open an issue to discuss proposed changes.

---

Happy containerizing!
