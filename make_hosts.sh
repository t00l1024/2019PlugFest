#!/bin/bash

# Source bashrc-of
source bashrc-of

# Create Test Namespaces and Connect them - atx950
create_ns wan 192.88.99.254/24
as_ns wan ip route add default via 192.88.99.1
sudo ovs-vsctl add-port atx950 veth-wan \
		        -- set interface veth-wan ofport_request=4

create_ns dns 192.168.11.2/24
as_ns dns ip route add default via 192.168.11.1
sudo ovs-vsctl add-port atx950 veth-dns \
		        -- set interface veth-dns ofport_request=5

create_ns host2 192.168.11.3/24
as_ns host2 ip route add default via 192.168.11.1
sudo ovs-vsctl add-port atx950 veth-host2 \
		        -- set interface veth-host2 ofport_request=6

# Create Test Namespaces and Connect them - ar2930f-1
create_ns host3 192.168.11.4/24
as_ns host3 ip route add default via 192.168.11.1
sudo ovs-vsctl add-port ar2930f-1 veth-host3 \
		        -- set interface veth-host3 ofport_request=5

# Create Test Namespaces and Connect them - ar2930f-1
create_ns host4 192.168.51.2/24
as_ns host4 ip route add default via 192.168.51.1
sudo ovs-vsctl add-port ar2930f-1 veth-host4 \
		        -- set interface veth-host4 ofport_request=50
