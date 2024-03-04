#!/bin/bash

function update_and_upgrade {
    echo "Updating and upgrading your packages. This might take a bit, so why not grab a coffee? ☕"
    sudo apt update -y
    sudo apt upgrade -y
    echo "All set! Your packages are now as fresh as a daisy. 🌼"
}

function disable_swap {
    echo "Disabling swap... Don't worry, it's like turning off a light we don't need. 💡"
    sudo swapoff -a
    sudo sed -i '/ swap / s/^\(.*\)$/#\\1/g' /etc/fstab
    echo "Swap is now disabled. We're all about efficiency here!"
}

function load_kernel_modules {
    echo "Loading some essential kernel modules... Think of it as giving your system a new skill! 🥋"
    sudo tee /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF
    sudo modprobe overlay
    sudo modprobe br_netfilter
    echo "Kernel modules loaded. Your system is now even more talented!"
}

function set_sysctl_params {
    echo "Tweaking sysctl parameters for networking... It's like tuning a guitar for the perfect sound. 🎸"
    sudo tee /etc/sysctl.d/kubernetes.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
    sudo sysctl --system
    echo "Sysctl parameters set. Your network is now ready to rock 'n' roll!"
}

function remove_conflicting_packages {
    echo "Looking for any packages that might stir up trouble... and politely asking them to leave. 🚪🏃"
    for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove -y $pkg; done
    echo "All clear! No troublemakers found."
}

function setup_docker_and_containerd {
    echo "Setting up Docker and containerd... because even containers need a cozy home. 🏡"
    sudo apt-get update
    sudo apt-get install -y ca-certificates curl gnupg2 software-properties-common apt-transport-https
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    echo "Adding Docker's official GPG key... Like getting a VIP pass! 🎫"
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \\
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt install -y containerd.io
    containerd config default | sudo tee /etc/containerd/config.toml >/dev/null
    sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml
    sudo systemctl restart containerd
    sudo systemctl enable containerd
    echo "Docker and containerd are now snugly set up in their new home. 🏠✨"
}

function install_kubernetes_components {
    echo "Now, let's welcome Kubernetes to the party! 🎉 Installing kubelet, kubeadm, kubectl..."
    sudo apt-get update
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
    sudo apt-get update
    sudo apt-get install -y kubelet kubeadm kubectl
    sudo apt-mark hold kubelet kubeadm kubectl
    echo "Kubernetes components are now installed. The gang's all here! 🤗"
}

# Let's call all the functions in order
update_and_upgrade
disable_swap
load_kernel_modules
set_sysctl_params
remove_conflicting_packages
setup_docker_and_containerd
install_kubernetes_components

echo "Congratulations! 🎊 Your Kubernetes cluster is ready to conquer the digital world. What will you deploy first? 🚀🌌"

