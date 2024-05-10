from ryu.base import app_manager
from ryu.controller import ofp_event
from ryu.controller.handler import CONFIG_DISPATCHER, MAIN_DISPATCHER
from ryu.controller.handler import set_ev_cls
from ryu.ofproto import ofproto_v1_3
from ryu.lib.packet import packet
from ryu.lib.packet import ethernet
from ryu.lib.packet import ether_types
from ryu.lib.packet import udp
from ryu.lib.packet import tcp
from ryu.lib.packet import icmp
import threading,time,subprocess


class Slicing(app_manager.RyuApp):

	#openflow v1.3
    OFP_VERSIONS = [ofproto_v1_3.OFP_VERSION]

    def __init__(self, *args, **kwargs):
        super(Slicing, self).__init__(*args, **kwargs)

        self.slices = {
            0: "production", 1: "management", 2: "development"
        }

        self.slice_states = [False for _ in range(3)]

        #switch id : {"MAC adress of the host" : eth port of the switch it is connected}
        self.mac_to_port = {
        	1:{"00:00:00:00:00:01": 1, "00:00:00:00:00:02": 2, "00:00:00:00:00:03": 3,
        	   "00:00:00:00:00:04": 3, "00:00:00:00:00:05": 3, "00:00:00:00:00:06": 3, 
        	   "00:00:00:00:00:07": 3, "00:00:00:00:00:08": 3},
        	2:{"00:00:00:00:00:03": 1, "00:00:00:00:00:04": 2, "00:00:00:00:00:01": 3,
        	   "00:00:00:00:00:02": 3, "00:00:00:00:00:05": 4, "00:00:00:00:00:06": 4, 
        	   "00:00:00:00:00:07": 5, "00:00:00:00:00:08": 5},
        	3:{"00:00:00:00:00:05": 1, "00:00:00:00:00:06": 2, "00:00:00:00:00:01": 3,
        	   "00:00:00:00:00:02": 3, "00:00:00:00:00:03": 3, "00:00:00:00:00:04": 3, 
        	   "00:00:00:00:00:07": 4, "00:00:00:00:00:08": 4},
        	4:{"00:00:00:00:00:07": 1, "00:00:00:00:00:08": 2, "00:00:00:00:00:01": 3,
        	   "00:00:00:00:00:02": 3, "00:00:00:00:00:03": 3, "00:00:00:00:00:04": 3, 
        	   "00:00:00:00:00:05": 4, "00:00:00:00:00:06": 4}
        }
        self.cli_thread = threading.Thread(target=self.command_line_interface, args=())
        self.cli_thread.daemon = True
        self.cli_thread.start()




    @set_ev_cls(ofp_event.EventOFPSwitchFeatures, CONFIG_DISPATCHER)
    def switch_features_handler(self, ev):
        datapath = ev.msg.datapath
        ofproto = datapath.ofproto
        parser = datapath.ofproto_parser

        # install the table-miss flow entry.
        match = parser.OFPMatch()
        actions = [
            parser.OFPActionOutput(ofproto.OFPP_CONTROLLER, ofproto.OFPCML_NO_BUFFER)
        ]
        self.add_flow(datapath, 0, match, actions)

    def add_flow(self, datapath, priority, match, actions):
        ofproto = datapath.ofproto
        parser = datapath.ofproto_parser

        # construct flow_mod message and send it.
        inst = [parser.OFPInstructionActions(ofproto.OFPIT_APPLY_ACTIONS, actions)]
        mod = parser.OFPFlowMod(
            datapath=datapath, priority=priority, match=match, instructions=inst
        )
        datapath.send_msg(mod)

    def _send_package(self, msg, datapath, in_port, actions):
        data = None
        ofproto = datapath.ofproto
        if msg.buffer_id == ofproto.OFP_NO_BUFFER:
            data = msg.data

        out = datapath.ofproto_parser.OFPPacketOut(
            datapath=datapath,
            buffer_id=msg.buffer_id,
            in_port=in_port,
            actions=actions,
            data=data,
        )
        datapath.send_msg(out)


    #packet_in_handler is called when Ryu receives an openflow packet_in message
    #first parameter of set_ev_cls indicates the thype of event this function should be called for
    #second parameter of set_ev_cls indicates the state of the switch 
    #MAIN_DISPATCHER means that this function iscalled only after the negotiation between Ryu and switch completes.
    @set_ev_cls(ofp_event.EventOFPPacketIn, MAIN_DISPATCHER)
    def _packet_in_handler(self, ev):

        #get packet information
        msg = ev.msg
        datapath = msg.datapath #switch
        ofproto = datapath.ofproto #represents the openflow protocol negotiated
        in_port = msg.match["in_port"]

        #extract the packet from the message
        pkt = packet.Packet(msg.data)

        eth = pkt.get_protocol(ethernet.ethernet)


        if eth.ethertype == ether_types.ETH_TYPE_LLDP:
            # ignore lldp packet
            return
        
        dst = eth.dst
        src = eth.src
        
        #get the switch id
        dpid = datapath.id
        
        if dpid in self.mac_to_port:
                if dst in self.mac_to_port[dpid]:
                	# if we know the destination we can generate the output port, action and match looking at the table
                    out_port = self.mac_to_port[dpid][dst]
                    #packet_out message
                    actions = [datapath.ofproto_parser.OFPActionOutput(out_port)]
                    match = datapath.ofproto_parser.OFPMatch(eth_dst=dst)

                    # add to flow table
                    self.add_flow(datapath, 1, match, actions)

                    #then execute the same command that was added to the flow table
                    self._send_package(msg, datapath, in_port, actions)



    # Function to activate a slice
    def activate_slice(self, slice_id):
        subprocess.call(f"./{self.slices[slice_id]}_slice.sh")
        self.slice_states[slice_id] = True
        print(f"{self.slices[slice_id]} Slice is activated.")


    # Function to deactivate a slice
    def deactivate_slice(self, slice_id):
        self.slice_states[slice_id] = False
        print(f"{self.slices[slice_id]} Slice is deactivated.")
            

    # Command line interface to activate/deactivate slices
    def command_line_interface(self):
        while True:
            time.sleep(1)
            command = input("Slices: \n 1. Production \n 2. Management \n 3. Development \n  Enter command (activate/deactivate/status): ").strip().lower()
            if command == "activate":
                slice_id = int(input("Enter slice ID to activate: ").strip()) - 1
                if slice_id in self.slices:
                    self.activate_slice(slice_id)
                else:
                    print("Please enter a valid id(1/2/3)")
                    continue
            elif command == "deactivate":
                slice_id = int(input("Enter slice ID to deactivate: ").strip()) - 1
                if slice_id in self.slices:
                    self.deactivate_slice(slice_id)
                else:
                    print("Please enter a valid id(1/2/3)")
            elif command == "status":
                for s in self.slices:
                    if self.slice_states[s] == True:
                        print(f"{self.slices[s]} Slice is activated.")
                    else:
                        print(f"{self.slices[s]} Slice is not activated.")
            else:
                print("Invalid command. Please enter 'activate' or 'deactivate'.")

