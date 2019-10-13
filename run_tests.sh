#!/bin/bash

# Source bashrc-of
source bashrc-of

# Ping tests from DP ar2930f-1 (host3 192.168.10.4/24)
#as_ns host3 ping -q -c3 192.168.10.2 > /dev/null


function ping_test () {
	as_ns $1 ping -q -c2 $2 > /dev/null
	if [ $? -eq 0 ]
	then
		echo "SUCCESS: from $1 $2"
	else
		echo "FAIL: from $1 to $2"
	fi
}

ping_test wan 192.168.11.2
ping_test dns 192.168.11.3
ping_test dns 192.168.11.4
ping_test dns 192.168.51.2
ping_test host2 192.168.11.4
ping_test host2 192.168.51.2
ping_test host3 192.168.51.2
