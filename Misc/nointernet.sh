#!/bin/bash

RED='\033[0;31m'
NO_COLOR='\033[0m'

display_usage () {
    script_name=`basename "$0"`

    echo "Launch a program with internet access blocked.                                                           "
    echo "                                                                                                         "
    echo "Usage: $script_name <program name> [program args]                                                        "
    echo "                                                                                                         "
    echo "Pre-requisites:                                                                                          "
    echo "  1) Group 'no-internet' exists (i.e., sudo groupadd no-internet)                                        "
    echo "  2) Current user is part of 'no-internet' group (i.e., sudo usermod -a -G no-internet \$USER)           "
    echo "  3) Firewall blocks Internet access for 'no-internet' group:                                            "
    echo "                                                                                                         "
    echo "          sudo iptables -I OUTPUT 1 -m owner --gid-owner no-internet -j DROP                             "
    echo "                                                                                                         "
    echo "     Optionally, program can be allowed to access local network but no Internet                          "
    echo "                                                                                                         "
    echo "          sudo iptables -A OUTPUT -m owner --gid-owner no-internet -d 192.168.1.0/24 -j ACCEPT           "
    echo "          sudo iptables -A OUTPUT -m owner --gid-owner no-internet -d 127.0.0.0/8 -j ACCEPT              "
    echo "          sudo iptables -A OUTPUT -m owner --gid-owner no-internet -j DROP                               "
    echo "                                                                                                         "
    echo "     Make iptables rules permanent so that they don't disapper on system restart:                        "
    echo "                                                                                                         "
    echo "          i. Save rules to a file: sudo sh -c 'iptables-save > /etc/iptables.rules'                      "
    echo "         ii. Create a script '/etc/network/if-pre-up.d/firewall' with following contents                 "
    echo "                  #!/bin/bash                                                                            "
    echo "                  $(which iptables-restore) < /etc/iptables.rules                                        "
    echo "        iii. Make it runnable: sudo chmod +x /etc/network/if-pre-up.d/firewall                           "
    echo "         iv. Reboot system                                                                               "
    echo "          v. List the iptables rules to check if it has been applied: iptables -L                        "
    echo "                                                                                                         "
    echo "Reference:                                                                                               "
    echo "  https://serverfault.com/questions/550276/how-to-block-internet-access-to-certain-programs-on-linux     "
    echo "  https://websistent.com/how-to-save-iptables-rules-in-debian/                                           "
}

if [ "$#" -gt 0 ]; then
    echo "Checking firewall rule"
    sudo iptables -L | grep no-internet

    if [ "$?" -eq 0 ]; then
        sg no-internet "${1} ${@:2}"
    else
        echo -e "${RED}Firewall rule not set, can't launch program. Run this script without arguments to see how to set firewall rules.${NO_COLOR}"
    fi
else
    display_usage
fi

