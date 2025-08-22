#!/bin/bash
# Simple script to chain VPN + Tor

echo "[*] Starting Tor service..."
tor > /dev/null 2>&1 &

sleep 5

echo "[*] Starting VPN tunnel..."
if [ "$1" == "wg" ]; then
    wg-quick up ./wireguard.conf
elif [ "$1" == "ovpn" ]; then
    sudo openvpn --config ./openvpn.conf &
else
    echo "Usage: ./chain.sh [wg|ovpn]"
    exit 1
fi

echo "[+] Chain established. Verifying external IP..."
curl --socks5 127.0.0.1:9050 ifconfig.me
