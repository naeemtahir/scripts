#!/bin/sh

if [ "$#" -eq 1 ]; then
    echo "==============================================================================="
    echo "Stopping DNS Leak while on OpenVPN, update client side *.ovpn as per:"
    echo "    http://www.ubuntubuzz.com/2015/09/how-to-fix-openvpn-dns-leak-in-linux.html"
    echo ""
    echo "This also requires following settings in Router, go to 'VPN->OpenVPN->VPN Details->Advanced Settings' and set"
    echo "   Respond to DNS: Yes"
    echo "   Advertise DNS to clients: Yes"
    echo "   Encryption cipher: AES-256-CBC"
    echo "   Push LAN to clients: Yes"
    echo "   Direct clients to redirect Internet traffic: Yes"
    echo "==============================================================================="

    sudo openvpn --config $1
else
    script_name=$(basename "$0")
    echo "Usage: $script_name <client.ovpn>"
    exit 1
fi
