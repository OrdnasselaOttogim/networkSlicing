#!/bin/sh

#management slice 20% bandwidth
echo '-------------- Development Slice --------------'
echo 'h3 h4 h5 h6 h7 h8'


#creating a virtual queue for s2
sudo ovs-vsctl set port s2-eth4 qos=@newqos -- \
--id=@newqos create QoS type=linux-htb \
other-config:max-rate=1000000000 \
queues:3=@devq -- \
--id=@devq create queue other-config:min-rate=10000 other-config:max-rate=200000000

sudo ovs-vsctl set port s2-eth5 qos=@newqos -- \
--id=@newqos create QoS type=linux-htb \
other-config:max-rate=1000000000 \
queues:3=@devq -- \
--id=@devq create queue other-config:min-rate=10000 other-config:max-rate=200000000

#creating a virtual queue for s3
sudo ovs-vsctl set port s3-eth3 qos=@newqos -- \
--id=@newqos create QoS type=linux-htb \
other-config:max-rate=1000000000 \
queues:3=@devq -- \
--id=@devq create queue other-config:min-rate=10000 other-config:max-rate=200000000

sudo ovs-vsctl set port s3-eth4 qos=@newqos -- \
--id=@newqos create QoS type=linux-htb \
other-config:max-rate=1000000000 \
queues:3=@devq -- \
--id=@devq create queue other-config:min-rate=10000 other-config:max-rate=200000000

#creating a virtual queue for s4
sudo ovs-vsctl set port s4-eth3 qos=@newqos -- \
--id=@newqos create QoS type=linux-htb \
other-config:max-rate=1000000000 \
queues:3=@devq -- \
--id=@devq create queue other-config:min-rate=10000 other-config:max-rate=200000000

sudo ovs-vsctl set port s4-eth4 qos=@newqos -- \
--id=@newqos create QoS type=linux-htb \
other-config:max-rate=1000000000 \
queues:3=@devq -- \
--id=@devq create queue other-config:min-rate=10000 other-config:max-rate=200000000


#s2 h3, h4

sudo ovs-ofctl add-flow s2 ip,priority=65500,nw_src=10.0.0.3,nw_dst=10.0.0.4,idle_timeout=0,actions=set_queue:3,normal
sudo ovs-ofctl add-flow s2 ip,priority=65500,nw_src=10.0.0.3,nw_dst=10.0.0.5,idle_timeout=0,actions=set_queue:3,normal
sudo ovs-ofctl add-flow s2 ip,priority=65500,nw_src=10.0.0.3,nw_dst=10.0.0.6,idle_timeout=0,actions=set_queue:3,normal
sudo ovs-ofctl add-flow s2 ip,priority=65500,nw_src=10.0.0.3,nw_dst=10.0.0.7,idle_timeout=0,actions=set_queue:3,normal
sudo ovs-ofctl add-flow s2 ip,priority=65500,nw_src=10.0.0.3,nw_dst=10.0.0.8,idle_timeout=0,actions=set_queue:3,normal

sudo ovs-ofctl add-flow s2 ip,priority=65500,nw_src=10.0.0.4,nw_dst=10.0.0.3,idle_timeout=0,actions=set_queue:3,normal
sudo ovs-ofctl add-flow s2 ip,priority=65500,nw_src=10.0.0.4,nw_dst=10.0.0.5,idle_timeout=0,actions=set_queue:3,normal
sudo ovs-ofctl add-flow s2 ip,priority=65500,nw_src=10.0.0.4,nw_dst=10.0.0.6,idle_timeout=0,actions=set_queue:3,normal
sudo ovs-ofctl add-flow s2 ip,priority=65500,nw_src=10.0.0.4,nw_dst=10.0.0.7,idle_timeout=0,actions=set_queue:3,normal
sudo ovs-ofctl add-flow s2 ip,priority=65500,nw_src=10.0.0.4,nw_dst=10.0.0.8,idle_timeout=0,actions=set_queue:3,normal


#s3 h5, h6

sudo ovs-ofctl add-flow s3 ip,priority=65500,nw_src=10.0.0.5,nw_dst=10.0.0.3,idle_timeout=0,actions=set_queue:3,normal
sudo ovs-ofctl add-flow s3 ip,priority=65500,nw_src=10.0.0.5,nw_dst=10.0.0.4,idle_timeout=0,actions=set_queue:3,normal
sudo ovs-ofctl add-flow s3 ip,priority=65500,nw_src=10.0.0.5,nw_dst=10.0.0.6,idle_timeout=0,actions=set_queue:3,normal
sudo ovs-ofctl add-flow s3 ip,priority=65500,nw_src=10.0.0.5,nw_dst=10.0.0.7,idle_timeout=0,actions=set_queue:3,normal
sudo ovs-ofctl add-flow s3 ip,priority=65500,nw_src=10.0.0.5,nw_dst=10.0.0.8,idle_timeout=0,actions=set_queue:3,normal

sudo ovs-ofctl add-flow s3 ip,priority=65500,nw_src=10.0.0.6,nw_dst=10.0.0.3,idle_timeout=0,actions=set_queue:3,normal
sudo ovs-ofctl add-flow s3 ip,priority=65500,nw_src=10.0.0.6,nw_dst=10.0.0.4,idle_timeout=0,actions=set_queue:3,normal
sudo ovs-ofctl add-flow s3 ip,priority=65500,nw_src=10.0.0.6,nw_dst=10.0.0.5,idle_timeout=0,actions=set_queue:3,normal
sudo ovs-ofctl add-flow s3 ip,priority=65500,nw_src=10.0.0.6,nw_dst=10.0.0.7,idle_timeout=0,actions=set_queue:3,normal
sudo ovs-ofctl add-flow s3 ip,priority=65500,nw_src=10.0.0.6,nw_dst=10.0.0.8,idle_timeout=0,actions=set_queue:3,normal

#s3 h5, h6

sudo ovs-ofctl add-flow s4 ip,priority=65500,nw_src=10.0.0.7,nw_dst=10.0.0.3,idle_timeout=0,actions=set_queue:3,normal
sudo ovs-ofctl add-flow s4 ip,priority=65500,nw_src=10.0.0.7,nw_dst=10.0.0.4,idle_timeout=0,actions=set_queue:3,normal
sudo ovs-ofctl add-flow s4 ip,priority=65500,nw_src=10.0.0.7,nw_dst=10.0.0.5,idle_timeout=0,actions=set_queue:3,normal
sudo ovs-ofctl add-flow s4 ip,priority=65500,nw_src=10.0.0.7,nw_dst=10.0.0.6,idle_timeout=0,actions=set_queue:3,normal
sudo ovs-ofctl add-flow s4 ip,priority=65500,nw_src=10.0.0.7,nw_dst=10.0.0.8,idle_timeout=0,actions=set_queue:3,normal

sudo ovs-ofctl add-flow s4 ip,priority=65500,nw_src=10.0.0.8,nw_dst=10.0.0.3,idle_timeout=0,actions=set_queue:3,normal
sudo ovs-ofctl add-flow s4 ip,priority=65500,nw_src=10.0.0.8,nw_dst=10.0.0.4,idle_timeout=0,actions=set_queue:3,normal
sudo ovs-ofctl add-flow s4 ip,priority=65500,nw_src=10.0.0.8,nw_dst=10.0.0.5,idle_timeout=0,actions=set_queue:3,normal
sudo ovs-ofctl add-flow s4 ip,priority=65500,nw_src=10.0.0.8,nw_dst=10.0.0.6,idle_timeout=0,actions=set_queue:3,normal
sudo ovs-ofctl add-flow s4 ip,priority=65500,nw_src=10.0.0.8,nw_dst=10.0.0.7,idle_timeout=0,actions=set_queue:3,normal

echo '-------Dropping other connections-------'


#dropping the connection of the other hosts
sudo ovs-ofctl add-flow s1 ip,priority=65500,nw_src=10.0.0.1,nw_dst=10.0.0.2,idle_timeout=0,actions=drop
sudo ovs-ofctl add-flow s1 ip,priority=65500,nw_src=10.0.0.1,nw_dst=10.0.0.3,idle_timeout=0,actions=drop
sudo ovs-ofctl add-flow s1 ip,priority=65500,nw_src=10.0.0.1,nw_dst=10.0.0.4,idle_timeout=0,actions=drop
sudo ovs-ofctl add-flow s1 ip,priority=65500,nw_src=10.0.0.1,nw_dst=10.0.0.5,idle_timeout=0,actions=drop
sudo ovs-ofctl add-flow s1 ip,priority=65500,nw_src=10.0.0.1,nw_dst=10.0.0.6,idle_timeout=0,actions=drop
sudo ovs-ofctl add-flow s1 ip,priority=65500,nw_src=10.0.0.1,nw_dst=10.0.0.7,idle_timeout=0,actions=drop
sudo ovs-ofctl add-flow s1 ip,priority=65500,nw_src=10.0.0.1,nw_dst=10.0.0.8,idle_timeout=0,actions=drop

sudo ovs-ofctl add-flow s1 ip,priority=65500,nw_src=10.0.0.2,nw_dst=10.0.0.1,idle_timeout=0,actions=drop
sudo ovs-ofctl add-flow s1 ip,priority=65500,nw_src=10.0.0.2,nw_dst=10.0.0.3,idle_timeout=0,actions=drop
sudo ovs-ofctl add-flow s1 ip,priority=65500,nw_src=10.0.0.2,nw_dst=10.0.0.4,idle_timeout=0,actions=drop
sudo ovs-ofctl add-flow s1 ip,priority=65500,nw_src=10.0.0.2,nw_dst=10.0.0.5,idle_timeout=0,actions=drop
sudo ovs-ofctl add-flow s1 ip,priority=65500,nw_src=10.0.0.2,nw_dst=10.0.0.6,idle_timeout=0,actions=drop
sudo ovs-ofctl add-flow s1 ip,priority=65500,nw_src=10.0.0.2,nw_dst=10.0.0.7,idle_timeout=0,actions=drop
sudo ovs-ofctl add-flow s1 ip,priority=65500,nw_src=10.0.0.2,nw_dst=10.0.0.8,idle_timeout=0,actions=drop

sudo ovs-ofctl add-flow s2 ip,priority=65500,nw_src=10.0.0.3,nw_dst=10.0.0.1,idle_timeout=0,actions=drop
sudo ovs-ofctl add-flow s2 ip,priority=65500,nw_src=10.0.0.3,nw_dst=10.0.0.2,idle_timeout=0,actions=drop
sudo ovs-ofctl add-flow s2 ip,priority=65500,nw_src=10.0.0.4,nw_dst=10.0.0.1,idle_timeout=0,actions=drop
sudo ovs-ofctl add-flow s2 ip,priority=65500,nw_src=10.0.0.4,nw_dst=10.0.0.2,idle_timeout=0,actions=drop
sudo ovs-ofctl add-flow s3 ip,priority=65500,nw_src=10.0.0.5,nw_dst=10.0.0.1,idle_timeout=0,actions=drop
sudo ovs-ofctl add-flow s3 ip,priority=65500,nw_src=10.0.0.5,nw_dst=10.0.0.2,idle_timeout=0,actions=drop
sudo ovs-ofctl add-flow s3 ip,priority=65500,nw_src=10.0.0.6,nw_dst=10.0.0.1,idle_timeout=0,actions=drop
sudo ovs-ofctl add-flow s3 ip,priority=65500,nw_src=10.0.0.6,nw_dst=10.0.0.2,idle_timeout=0,actions=drop
sudo ovs-ofctl add-flow s4 ip,priority=65500,nw_src=10.0.0.7,nw_dst=10.0.0.1,idle_timeout=0,actions=drop
sudo ovs-ofctl add-flow s4 ip,priority=65500,nw_src=10.0.0.7,nw_dst=10.0.0.2,idle_timeout=0,actions=drop
sudo ovs-ofctl add-flow s4 ip,priority=65500,nw_src=10.0.0.8,nw_dst=10.0.0.1,idle_timeout=0,actions=drop
sudo ovs-ofctl add-flow s4 ip,priority=65500,nw_src=10.0.0.8,nw_dst=10.0.0.2,idle_timeout=0,actions=drop
