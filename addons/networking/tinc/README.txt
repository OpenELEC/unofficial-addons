    tinc for OpenELEC
    Version 1.0 2015-02-04
    Anton Voyl (awiouy@gmail.com)

1   Setting up a tinc Network on a First System

1.1 Introduction

    This section describes how to set up a tinc virtual private network on a
    first system.

1.2 Details

    The name of the tinc network will be "Peanuts". Within tinc network
    "Peanuts", the first system is a node, whose name will be "Linus".

    tinc newtwork "Peanuts" will operate in switch mode. Node "Linus" will
    listen on port 6550.

    The IP address of node "Linus" will be 172.16.1.1. The netmask of tinc
    network "Peanuts" will be 255.255.255.0.

    If node "Linus" is behind a firewall, the firewall is configured to forward
    packets on port 6550 to the first system.

    The first system is known on the internet as "linus.ddns.net".

1.3 Procedure

    Install the tinc-addon on the first system.

    Connect to the first system with SSH and enter the following commands:
    tinc -n Peanuts init Linus
    tinc -n Peanuts set mode switch
    tinc -n Peanuts set port 6500
    tinc -n Peanuts set address linus.ddns.net
    echo ifconfig \$INTERFACE 172.16.1.1 netmask 255.255.255.0 \
      > /storage/.cache/tinc/Peanuts/tinc-up
    tinc -n Peanuts start

1.4 Verification

    Below are some commands that may be used to verify the tinc network:

    To verify the state of tinc network:
    tinc -n Peanuts dump nodes
    Linus id 7d01e0054837 at MYSELF port 6550...

    To verify the IP configuration:
    ip route show dev Peanuts
    172.16.1.0/24 dev Peanuts  src 172.16.1.1


2   Inviting a node to Join an Existing tinc Network

2.1 Introduction

    This section describes how to invite a node to join an existing tinc
    network.

2.2 Details

    Node "Lucy" will be invited from node "Linus" to join tinc network
    "Peanuts".

    The IP address of node "Lucy" will be 172.16.1.2.

2.3 Procedure

    Connect to the first system with SSH and enter the following command:
    tinc -n Peanuts invite Lucy

    Send the output of this command (linus.ddns.net:6550/...), the ip address
    of the node (172.16.1.2), and the netmask of tinc network "Peanuts"
    (255.255.255.0) to the owner of the second system.


3   Joining an Existing tinc Network from a Second System

3.1 Introduction

    This section describes how to join an existing tinc network from a second
    system.

3.2 Details

    You have received an invitation to join a tinc network
    (linus.ddns.net:6550/...), an ip address of a node (172.16.1.2), and a
    netmask of a tinc network (255.255.255.0).

    The name of the tinc network on the second system is irrelevant, as long as
    it is not already used. We will use Peanuts for simplicity.

3.3 Procedure

    Install the tinc-addon on the second system.

    Connect to second system with SSH and enter the following commands:
    tinc -n Peanuts join linus.ddns.net:6550/...
    echo ifconfig \$INTERFACE 172.16.1.2 netmask 255.255.255.0 \
    > /storage/.cache/tinc/Peanuts/tinc-up
    chmod a+x /storage/.cache/tinc/Peanuts/tinc-up
    tinc -n Peanuts start

3.4 Verification

    See section 1.4 above.


4   Miscellaneous

4.1 Automatic Start of tinc Networks

    The tinc add-on attempts to start existing tinc networks when XBMC is
    started.

4.2 Removing tinc Networks from a System

    To remove a tinc network from a system, connect to the system with SSH and
    enter the following command:
    rm -rf /storage/.cache/tinc/network

    To remove all tinc networks from a system, connect to the system with SSH
    and enter the following command:
    rm -rf /storage/.cache/tinc/*

4.3 Further Documentation

    tinc is documented at http://tinc-vpn.org/docs/

4.4 Help Needed

    Any help would be appreciated to create a proper user interface to the
    tinc-addon.
