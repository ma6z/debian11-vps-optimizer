#!/bin/bash
set -euo pipefail

# ===================================================
# Debian 11 KVM VPS Full Optimizer
# Optimized for Wings, Blueprints, and containers
# Credits: Zenx
# ===================================================

echo "===================================="
echo "  Debian 11 KVM VPS Full Optimizer"
echo "          Powered by Zenx"
echo "===================================="

# -----------------------------
# 1️⃣ Update & upgrade
# -----------------------------
echo "[INFO] Updating system..."
apt update && apt upgrade -y

# -----------------------------
# 2️⃣ Install essentials
# -----------------------------
echo "[INFO] Installing core packages..."
apt install -y htop iftop iotop sysstat unzip wget curl vim sudo net-tools git gnupg2 lsb-release apt-transport-https software-properties-common build-essential qemu-utils

# -----------------------------
# 3️⃣ Enable KVM acceleration
# -----------------------------
echo "[INFO] Checking KVM support..."
if [[ $(egrep -c '(vmx|svm)' /proc/cpuinfo) -eq 0 ]]; then
    echo "[WARN] No hardware virtualization detected!"
else
    echo "[SUCCESS] Hardware virtualization detected."
fi

# -----------------------------
# 4️⃣ CPU & memory optimization
# -----------------------------
echo "[INFO] Setting CPU governor to performance..."
for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    [[ -f $cpu ]] && echo performance > "$cpu"
done

echo "[INFO] Tweaking memory settings..."
sysctl -w vm.swappiness=10
sysctl -w vm.vfs_cache_pressure=50
echo 1 > /proc/sys/vm/overcommit_memory
echo 1024 > /proc/sys/vm/nr_hugepages

# -----------------------------
# 5️⃣ Disk I/O optimization
# -----------------------------
echo "[INFO] Optimizing disk scheduler..."
for disk in /sys/block/sd*; do
    [[ -f $disk/queue/scheduler ]] && echo noop > "$disk/queue/scheduler"
done

# -----------------------------
# 6️⃣ Network optimization
# -----------------------------
echo "[INFO] Tuning network parameters..."
sysctl -w net.core.somaxconn=1024
sysctl -w net.ipv4.tcp_fin_timeout=15
sysctl -w net.ipv4.tcp_tw_reuse=1
sysctl -w net.ipv4.ip_local_port_range="1024 65535"
sysctl -w net.ipv4.tcp_max_syn_backlog=2048

# -----------------------------
# 7️⃣ SSH hardening
# -----------------------------
echo "[INFO] Hardening SSH..."
sed -i 's/^PermitRootLogin yes/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
systemctl restart sshd

# -----------------------------
# 8️⃣ Firewall & security
# -----------------------------
echo "[INFO] Installing and enabling UFW..."
apt install -y ufw
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw --force enable

# -----------------------------
# 9️⃣ System monitoring
# -----------------------------
echo "[INFO] Installing monitoring tools..."
apt install -y sysstat iftop htop iotop glances

# -----------------------------
# 🔟 Optional performance tweaks
# -----------------------------
echo "[INFO] Enabling CPU & network performance tweaks..."
echo 0 > /proc/sys/kernel/nmi_watchdog
echo 0 > /proc/sys/kernel/panic_on_oops
echo 0 > /proc/sys/kernel/softlockup_panic

# -----------------------------
# 11️⃣ Cleaning up
# -----------------------------
echo "[INFO] Cleaning up..."
apt autoremove -y && apt clean

echo "===================================="
echo "[SUCCESS] VPS fully optimized for high-performance workloads!"
echo "[INFO] Credits: Zenx"
echo "Recommended next steps:"
echo " - Install Docker/Podman for containerized apps"
echo " - Deploy Wings, Blueprints, or any custom panels"
echo " - Set up backup and monitoring scripts"
echo "===================================="
