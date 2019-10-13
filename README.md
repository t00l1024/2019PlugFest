This project consists of a set of shell scripts that deploys a virtual network for testing the 2019 FAUCET Con PlugFest.

**Official information:**

    FAUCET PlugFest page: https://groups.google.com/a/waikato.ac.nz/forum/#!forum/faucet-plugfest.group

    FAUCET PluFest topology, tests, and release: https://groups.google.com/a/waikato.ac.nz/forum/#!topic/faucet-plugfest.group/553RrsyZ8gQ

**Approach:**
* Inside a Linux VM, one script (make_network.sh) will create a series a Open vSwitch bridges (datapaths) and logically connect them via OVS patch interfaces. This represents the physical connectivtiy between switches.
* The faucet.yaml file(s) will then be confgured for the datapaths and features, as needed. When FAUCET is executed, a working SDN network should be functional.
* The second script (make_hosts.sh) will create a series of Linux network namespaces to the previously created datapaths. This simulated physical hosts connected to the network and application & NFV features can be tested.
* The last, optional script (run_tests.sh) is for automating a series of end-to-end tests. This script likely requires modification to your definition of success & failure on the created network

**Requirements:**
* Knowledge/experience with Open vSwitch, FAUCET, shell scripting.
* Ubuntu or Debian Linux virtual machine (can be run on bare metal). Tested on Debian 9/10.
* Open vSwitch 2.10 or later
* A working version FAUCET 1.9.14 or later. Current release is recommended

    
**Usage:**
1. Using a modified version Josh's basic topology from the Google Groups page, run the ./make_network.sh script. The result should match the network topology.
2. The faucet.yaml file should provide the basis for the PlugFest. Run FAUCET with this file. Verify features in the log files.
3. Run make_network.sh to add hosts
4. Run tests as needed
