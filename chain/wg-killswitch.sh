#!/bin/bash
# WireGuard permanent kill-switch

WG_IF="wg0"

# 1️⃣ Flush existing rules
sudo iptables -F
sudo iptables -t nat -F
sudo iptables -X
sudo iptables -t nat -X

# 2️⃣ Default drop for outgoing traffic
sudo iptables -P OUTPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P INPUT DROP

# 3️⃣ Allow traffic over WireGuard interface
sudo iptables -A OUTPUT -o $WG_IF -j ACCEPT
sudo iptables -A INPUT -i $WG_IF -j ACCEPT

# 4️⃣ Allow localhost
sudo iptables -A OUTPUT -o lo -j ACCEPT
sudo iptables -A INPUT -i lo -j ACCEPT

# 5️⃣ Allow VPN server IP (WireGuard endpoint)
VPN_IP="vpn.example.com"
sudo iptables -A OUTPUT -d $VPN_IP -p udp --dport 51820 -j ACCEPT

# 6️⃣ Optional: allow DNS queries over tunnel only
sudo iptables -A OUTPUT -p udp --dport 53 -o $WG_IF -j ACCEPT

echo "[+] WireGuard Killswitch rules applied."
