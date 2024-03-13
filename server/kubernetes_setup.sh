#!/bin/bash

function update_and_upgrade {
    echo "🔧 Updating and upgrading your packages. This might take a bit, so why not grab a coffee? ☕"
    sudo apt update -y &>/dev/null
    sudo apt upgrade -y &>/dev/null
    echo "✅ All set! Your packages are now as fresh as a daisy. 🌼"
}

function disable_swap {
    echo "🔒 Disabling swap... It's like turning off a light we don't need. 💡"
    sudo swapoff -a &>/dev/null
    sudo sed -i '/ swap / s/^\(.*\)$/#\\1/g' /etc/fstab &>/dev/null
    echo "✅ Swap is now disabled. We're all about efficiency here!"
}

function load_kernel_modules {
    echo "🔌 Loading some essential kernel modules... It's like teaching your system a new trick! 🐕"
    sudo tee /etc/modules-load.d/containerd.conf >/dev/null <<EOF
overlay
br_netfilter
EOF
    sudo modprobe overlay &>/dev/null
    sudo modprobe br_netfilter &>/dev/null
    echo "✅ Kernel modules loaded. Your system just got smarter!"
}

function set_sysctl_params {
    echo "🎛 Tweaking sysctl parameters for networking... It's like tuning a guitar for that perfect sound. 🎸"
    sudo tee /etc/sysctl.d/kubernetes.conf >/dev/null <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
    sudo sysctl --system &>/dev/null
    echo "✅ Sysctl parameters set. Your network is now ready to rock 'n' roll!"
}

function remove_conflicting_packages {
    echo "🧹 Looking for any packages that might stir up trouble... and politely asking them to leave. 🚪🏃"
    for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove -y $pkg &>/dev/null; done
    echo "✅ All clear! No troublemakers found."
}

function setup_docker {
    echo "🐳 Setting up Docker and containerd... It's like building a cozy nest for your containers. 🏡"
    sudo apt-get update &>/dev/null
    sudo apt-get install ca-certificates curl -y &>/dev/null
    sudo install -m 0755 -d /etc/apt/keyrings &>/dev/null
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc &>/dev/null
    sudo chmod a+r /etc/apt/keyrings/docker.asc &>/dev/null

    echo "📦 Adding Docker's repository..."
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
    sudo apt-get update &>/dev/null

    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y &>/dev/null

    echo "📐 Configuring Docker..."
    sudo mkdir -p /etc/docker &>/dev/null
    cat <<EOF | sudo tee /etc/docker/daemon.json >/dev/null
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

    sudo systemctl enable docker &>/dev/null
    sudo systemctl daemon-reload &>/dev/null
    sudo systemctl restart docker &>/dev/null
    
    echo "✅ Docker is now snugly set up in their new home. 🐳✨"
}

function setup_containerd {
    echo "📦 Setting up containerd... Preparing another cozy spot for your containers. 🛏"
    containerd config default | sudo tee /etc/containerd/config.toml >/dev/null
    sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml &>/dev/null
    sudo systemctl restart containerd &>/dev/null
    sudo systemctl enable containerd &>/dev/null
    echo "✅ containerd is snugly set up. Ready to containerize the world! 🌍✨"
}

function install_kubernetes_components {
    echo "🚀 Now, let's welcome Kubernetes to the party! Installing kubelet, kubeadm, kubectl..."
    sudo apt-get update &>/dev/null
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg &>/dev/null
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list &>/dev/null
    sudo apt-get update &>/dev/null
    sudo apt-get install -y kubelet kubeadm kubectl &>/dev/null
    sudo apt-mark hold kubelet kubeadm kubectl &>/dev/null
    echo "✅ Kubernetes components are installed. The gang's all here! 🐳🤖🌐"
}

# Let's call all the functions in order
update_and_upgrade
disable_swap
load_kernel_modules
set_sysctl_params
remove_conflicting_packages
setup_docker
setup_containerd
install_kubernetes_components

echo "🎉 Congratulations! Your Kubernetes cluster is ready to conquer the digital world. What will you deploy first? 🚀🌌"
