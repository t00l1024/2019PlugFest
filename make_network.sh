#!/bin/bash

# Source bashrc-of
source bashrc-of

# Cleanup scenario
cleanup

#################################################################################
#
#              Create Datapaths
#
#################################################################################

# Create DP t1-sw1 0x01
sudo ovs-vsctl add-br t1-sw1 \
	-- set bridge t1-sw1 other-config:datapath-id=0x01 \
	-- set bridge t1-sw1 other-config:disable-in-band=true \
	-- set bridge t1-sw1 fail_mode=secure \
	-- set-controller t1-sw1 tcp:127.0.0.1:6653 tcp:127.0.0.1:6654

# Create DP t1-sw2 0x02
sudo ovs-vsctl add-br t1-sw2 \
	-- set bridge t1-sw2 other-config:datapath-id=0x02 \
	-- set bridge t1-sw2 other-config:disable-in-band=true \
	-- set bridge t1-sw2 fail_mode=secure \
	-- set-controller t1-sw2 tcp:127.0.0.1:6653 tcp:127.0.0.1:6654

# Create DP t2-sw1 0x03
sudo ovs-vsctl add-br t2-sw1 \
	-- set bridge t2-sw1 other-config:datapath-id=0x03 \
	-- set bridge t2-sw1 other-config:disable-in-band=true \
	-- set bridge t2-sw1 fail_mode=secure \
	-- set-controller t2-sw1 tcp:127.0.0.1:6653 tcp:127.0.0.1:6654

# Create DP t2-sw2 0x04
sudo ovs-vsctl add-br t2-sw2 \
	-- set bridge t2-sw2 other-config:datapath-id=0x04 \
	-- set bridge t2-sw2 other-config:disable-in-band=true \
	-- set bridge t2-sw2 fail_mode=secure \
	-- set-controller t2-sw2 tcp:127.0.0.1:6653 tcp:127.0.0.1:6654

# Create DP ext-net -- Not controlled by FAUCET
sudo ovs-vsctl add-br ext-net 


#################################################################################
#
#              Create Trunks between Datapaths
#
#################################################################################

# Create patch between t1-sw1 port 1, to t2-sw1 port 1
ovs_patch t1-sw1 1 t2-sw1 1

# Create patch between t1-sw1 port 2, to t2-sw2 port 2
ovs_patch t1-sw1 2 t2-sw2 2

# Create patch between t1-sw2 port 2, to t2-sw1 port 2
ovs_patch t1-sw2 2 t2-sw1 2

# Create patch between t1-sw2 port 1, to t2-sw2 port 1
ovs_patch t1-sw2 1 t2-sw2 1

# Create MLAGs to External Network
ovs_patch t1-sw1 4 ext-net 1
ovs_patch t1-sw1 5 ext-net 2
ovs_patch t1-sw2 4 ext-net 3
ovs_patch t1-sw2 5 ext-net 4

# This fails!!!!

# Set ports as bond ports on External Network
sudo ovs-vsctl add-bond ext-net bond0 ext-net-1 ext-net-2 \
	-- set port bond0 lacp=active \
	-- set port bond0 bond_mode=balance-tcp

sudo ovs-vsctl add-bond ext-net bond1 ext-net-3 ext-net-4 \
	-- set port bond1 lacp=active \
	-- set port bond1 bond_mode=balance-tcp


# git pull origin master

#systemctl restart faucet
#/usr/local/bin/faucet --ryu-config-file=/etc/faucet/ryu.conf --ryu-ofp-tcp-listen-port=6653

