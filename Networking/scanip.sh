#!/bin/bash

MY_IP=`curl -s http://ipecho.net/plain`
unamestr=`uname`

if [[ $unamestr == *"Linux"* ]]; then
   xdg-open "https://www.shodan.io/host/$MY_IP"
else
   open "https://www.shodan.io/host/$MY_IP"
fi

