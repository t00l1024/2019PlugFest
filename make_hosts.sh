#!/bin/bash

# Source bashrc-of
source bashrc-of

# Create Test Namespaces and Connect them 
create_ns host1 192.168.10.2/24
as_ns host1 ip route add default via 192.168.10.1
sudo ovs-vsctl add-port t2-sw1 veth-host1 \
		        -- set interface veth-host1 ofport_request=3

create_ns host2 192.168.20.2/24
as_ns host2 ip route add default via 192.168.20.1
sudo ovs-vsctl add-port t2-sw2 veth-host2 \
		        -- set interface veth-host2 ofport_request=3

# Create Poseidon namespace (for testing)
# This is really a mirrored input interface, but create the namespace and set an IP anyways.
create_ns poseidon 192.168.20.3/24
as_ns poseidon ip route add default via 192.168.20.1
sudo ovs-vsctl add-port t1-sw2 veth-poseidon \
		        -- set interface veth-poseidon ofport_request=3
