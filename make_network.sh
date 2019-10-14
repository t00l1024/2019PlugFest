#!/bin/bash

# Source bashrc-of
source bashrc-of

# Cleanup scenario
echo "Cleaning up any previous testing..."
cleanup
sudo ovs-vsctl show

#################################################################################
#
#              Create Datapaths
#
#################################################################################

# Create DP t1-sw1 0x1
echo "Creating OVS DP t1-sw1..."
sudo ovs-vsctl add-br t1-sw1 \
	-- set bridge t1-sw1 other-config:datapath-id=0x1 \
	-- set bridge t1-sw1 other-config:disable-in-band=true \
	-- set bridge t1-sw1 fail_mode=secure \
	-- set-controller t1-sw1 tcp:127.0.0.1:6653 tcp:127.0.0.1:6654

# Create DP t1-sw2 0x2
echo "Creating OVS DP t1-sw2..."
sudo ovs-vsctl add-br t1-sw2 \
	-- set bridge t1-sw2 other-config:datapath-id=0x2 \
	-- set bridge t1-sw2 other-config:disable-in-band=true \
	-- set bridge t1-sw2 fail_mode=secure \
	-- set-controller t1-sw2 tcp:127.0.0.1:6653 tcp:127.0.0.1:6654

# Create DP t2-sw1 0x3
echo "Creating OVS DP t1-sw2..."
sudo ovs-vsctl add-br t2-sw1 \
	-- set bridge t2-sw1 other-config:datapath-id=0x3 \
	-- set bridge t2-sw1 other-config:disable-in-band=true \
	-- set bridge t2-sw1 fail_mode=secure \
	-- set-controller t2-sw1 tcp:127.0.0.1:6653 tcp:127.0.0.1:6654

# Create DP t2-sw2 0x4
echo "Creating OVS DP t2-sw2..."
sudo ovs-vsctl add-br t2-sw2 \
	-- set bridge t2-sw2 other-config:datapath-id=0x4 \
	-- set bridge t2-sw2 other-config:disable-in-band=true \
	-- set bridge t2-sw2 fail_mode=secure \
	-- set-controller t2-sw2 tcp:127.0.0.1:6653 tcp:127.0.0.1:6654

# Create DP ext-net -- Not controlled by FAUCET
echo "Creating OVS bridge ext-net1..."
sudo ovs-vsctl add-br ext-net1

echo "Creating OVS bridge ext-net2..."
sudo ovs-vsctl add-br ext-net2 


#################################################################################
#
#              Create Trunks between Datapaths
#
#################################################################################

# Create patch between t1-sw1 port 1, to t2-sw1 port 1
echo "Creating t1-sw1 to t2-sw1 patch..."
ovs_patch t1-sw1 1 t2-sw1 1

# Create patch between t1-sw1 port 2, to t2-sw2 port 2
echo "Creating t1-sw1 to t2-sw2 patch..."
ovs_patch t1-sw1 2 t2-sw2 2

# Create patch between t1-sw2 port 2, to t2-sw1 port 2
echo "Creating t1-sw2 to t2-sw1 patch..."
ovs_patch t1-sw2 2 t2-sw1 2

# Create patch between t1-sw2 port 1, to t2-sw2 port 1
echo "Creating t1-sw2 to t2-sw2 patch..."
ovs_patch t1-sw2 1 t2-sw2 1


echo "Creating ext-net1 bond1 and patch..."
# Set ports as bond ports on External Network
sudo ovs-vsctl add-bond ext-net1 bond1 ext-net-1 ext-net-2 lacp=active \
        -- set interface ext-net-1 type=patch \
        -- set interface ext-net-1 options:peer=t1-sw1-4 \
        -- set interface ext-net-2 type=patch \
        -- set interface ext-net-2 options:peer=t1-sw1-5

echo "Creating ext-net2 bond2 and patch..."
sudo ovs-vsctl add-bond ext-net2 bond2 ext-net-3 ext-net-4 lacp=active \
        -- set interface ext-net-3 type=patch \
        -- set interface ext-net-3 options:peer=t1-sw2-4 \
        -- set interface ext-net-4 type=patch \
        -- set interface ext-net-4 options:peer=t1-sw2-5

# Create the other 1/2 of the patch ports. FAUCET will handle LACP
echo "Creating t1-sw1 port 4 to ext-net-1 patch..."
sudo ovs-vsctl add-port t1-sw1 t1-sw1-4 \
        -- set interface t1-sw1-4 type=patch \
        -- set interface t1-sw1-4 options:peer=ext-net-1 \
        -- set interface t1-sw1-4 ofport_request=4

echo "Creating t1-sw1 port 5 to ext-net-1 patch..."
sudo ovs-vsctl add-port t1-sw1 t1-sw1-5 \
        -- set interface t1-sw1-5 type=patch \
        -- set interface t1-sw1-5 options:peer=ext-net-2 \
        -- set interface t1-sw1-5 ofport_request=5

echo "Creating t1-sw2 port 4 to ext-net-2 patch..."
sudo ovs-vsctl add-port t1-sw2 t1-sw2-4 \
        -- set interface t1-sw2-4 type=patch \
        -- set interface t1-sw2-4 options:peer=ext-net-3 \
        -- set interface t1-sw2-4 ofport_request=4

echo "Creating t1-sw2 port 5 to ext-net-1 patch..."
sudo ovs-vsctl add-port t1-sw2 t1-sw2-5 \
        -- set interface t1-sw2-5 type=patch \
        -- set interface t1-sw2-5 options:peer=ext-net-4 \
        -- set interface t1-sw2-5 ofport_request=5



# git pull origin master

#systemctl restart faucet
#/usr/local/bin/faucet --ryu-config-file=/etc/faucet/ryu.conf --ryu-ofp-tcp-listen-port=6653

