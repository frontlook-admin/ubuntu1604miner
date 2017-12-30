#!/bin/bash

# Install dependencies
apt install -y dstat git screen clinfo
echo vm.nr_hugepages=128 > /etc/sysctl.conf

# Create mining dir
mkdir mining
cd mining/

# Download and install NVIDIA driver
sudo add-apt-repository ppa:graphics-drivers/ppa
apt update
apt install -y nvidia-387 nvidia-cuda-dev nvidia-cuda-toolkit

# Download and install AMD driver
wget --referer=http://support.amd.com https://www2.ati.com/drivers/linux/beta/ubuntu/amdgpu-pro-17.40-483984.tar.xz
tar -Jxvf amdgpu-pro-17.40-483984.tar.xz
cd amdgpu-pro-17.40-483984
sudo ./amdgpu-pro-install -y
sudo usermod -a -G video $LOGNAME
sudo apt install -y rocm-amdgpu-pro
echo 'export LLVM_BIN=/opt/amdgpu-pro/bin' | sudo tee /etc/profile.d/amdgpu-pro.sh

## Find the line that reads GRUB_CMDLINE_LINUX_DEFAULT=”quiet splash”. Modify it to: GRUB_CMDLINE_LINUX_DEFAULT="quiet splash amdgpu.vm_fragment_size=9" use text mode!!
update-grub

# Download and install XMR-stak all in one miner
git clone https://github.com/fireice-uk/xmr-stak.git
cd xmr-stak/
sed -i 's/2.0/0.0/g' xmrstak/donate-level.hpp
apt install libmicrohttpd-dev libssl-dev cmake build-essential libhwloc-dev ocl-icd-opencl-dev
cmake . 
make install

# Reboot when its all done
reboot


