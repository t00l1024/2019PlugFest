#!/bin/bash

# Source bashrc-of
source bashrc-of

function ping_test () {
	as_ns $1 ping -q -c2 $2 > /dev/null
	if [ $? -eq 0 ]
	then
		echo "SUCCESS: from $1 $2"
	else
		echo "FAIL: from $1 to $2"
	fi
}

# Ping local "router IPs"
ping_test host1 192.168.10.1
ping_test host2 192.168.20.1

# Simple ping tests across datapaths
ping_test host1 192.168.20.2

ping_test host2 192.168.10.2

