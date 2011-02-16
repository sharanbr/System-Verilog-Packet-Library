/*
Copyright (c) 2011, Sachin Gandhi
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
    * Neither the name of the author nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

// ----------------------------------------------------------------------
//  L2/Ether Type defines/tasks/macros
// ----------------------------------------------------------------------

// ~~~~~~~~~~ Ether Type defines ~~~~~~~~~~
`define SNAP_HDR_ETYPE      16'h8870
`define DOT1Q_HDR_ETYPE     16'h8100
`define ALT1Q_HDR_ETYPE     16'h8200
`define STAG_HDR_ETYPE      16'h88A8
`define ITAG_HDR_ETYPE      16'h88E7
`define ETH_HDR_ETYPE       16'h6558 // Ethernet-over-GRE Tunnel
`define IPV4_HDR_ETYPE      16'h0800
`define IPV6_HDR_ETYPE      16'h86DD
`define PTL2_HDR_ETYPE      16'h5555
`define MPLS_HDR_ETYPE      16'h8847
`define MMPLS_HDR_ETYPE     16'h8848
`define PTP_HDR_ETYPE       16'h88F7
`define LLC_HDR_MAX_LEN     16'd1500

// ~~~~~~~~~~ Ether Type fields ~~~~~~~~~~
  bit [15:0]  snap_etype    = `SNAP_HDR_ETYPE;
  bit [15:0]  dot1q_etype   = `DOT1Q_HDR_ETYPE;
  bit [15:0]  alt1q_etype   = `ALT1Q_HDR_ETYPE;
  bit [15:0]  stag_etype    = `STAG_HDR_ETYPE;
  bit [15:0]  itag_etype    = `ITAG_HDR_ETYPE;
  bit [15:0]  eth_etype     = `ETH_HDR_ETYPE;
  bit [15:0]  ipv4_etype    = `IPV4_HDR_ETYPE;
  bit [15:0]  ipv6_etype    = `IPV6_HDR_ETYPE;
  bit [15:0]  ptl2_etype    = `PTL2_HDR_ETYPE;
  bit [15:0]  mpls_etype    = `MPLS_HDR_ETYPE;
  bit [15:0]  mmpls_etype   = `MMPLS_HDR_ETYPE;
  bit [15:0]  ptp_etype     = `PTP_HDR_ETYPE;
  bit [15:0]  llc_max_len   = `LLC_HDR_MAX_LEN;

// ~~~~~~~~ define to copy Ether Type fields  ~~~~~~~~~~
`define HDR_L2_INCLUDE_CPY\
    this.snap_etype    = cpy_cls.snap_etype;\
    this.dot1q_etype   = cpy_cls.dot1q_etype;\
    this.alt1q_etype   = cpy_cls.alt1q_etype;\
    this.stag_etype    = cpy_cls.stag_etype;\
    this.itag_etype    = cpy_cls.itag_etype;\
    this.eth_etype     = cpy_cls.eth_etype;\
    this.ipv4_etype    = cpy_cls.ipv4_etype;\
    this.ipv6_etype    = cpy_cls.ipv6_etype;\
    this.ptl2_etype    = cpy_cls.ptl2_etype;\
    this.mpls_etype    = cpy_cls.mpls_etype;\
    this.mmpls_etype   = cpy_cls.mmpls_etype;\
    this.ptp_etype     = cpy_cls.ptp_etype;\
    this.llc_max_len   = cpy_cls.llc_max_len

// ~~~~~~~~~~ Constraints Macro for ethertype ~~~~~~~~~~
`define LEGAL_ETH_TYPE_CONSTRAINTS \
        (nxt_hdr.hid == SNAP_HID)   -> (etype == snap_etype) | (etype == this.total_hdr_len);\
        (nxt_hdr.hid == SNAP_HID) & (etype != snap_etype) -> (this.total_hdr_len inside { [16'd1 : llc_max_len] });\
        (nxt_hdr.hid != SNAP_HID)   -> (etype >  llc_max_len) ;\
        (nxt_hdr.hid == DOT1Q_HID)  -> (etype == dot1q_etype) ;\
        (nxt_hdr.hid == ALT1Q_HID)  -> (etype == alt1q_etype) ;\
        (nxt_hdr.hid == STAG_HID)   -> (etype == stag_etype)  ;\
        (nxt_hdr.hid == ITAG_HID)   -> (etype == itag_etype)  ;\
        (nxt_hdr.hid == ETH_HID)    -> (etype == eth_etype)   ;\
        (nxt_hdr.hid == IPV4_HID)   -> (etype == ipv4_etype)  ;\
        (nxt_hdr.hid == IPV6_HID)   -> (etype == ipv6_etype)  ;\
        (nxt_hdr.hid == PTL2_HID)   -> (etype == ptl2_etype)  ;\
        (nxt_hdr.hid == PTP_HID)    -> (etype == ptp_etype)   ;\
        (nxt_hdr.hid == MPLS_HID)   -> (etype == mpls_etype)  ;\
        (nxt_hdr.hid == MMPLS_HID)  -> (etype == mmpls_etype) ;\
        (nxt_hdr.hid == DATA_HID)   -> (etype != dot1q_etype) &\
                                       (etype != alt1q_etype) &\
                                       (etype != stag_etype)  &\
                                       (etype != itag_etype)  &\
                                       (etype != eth_etype)   &\
                                       (etype != ipv4_etype)  &\
                                       (etype != ipv6_etype)  &\
                                       (etype != ptl2_etype)  &\
                                       (etype != ptp_etype)   &\
                                       (etype != mpls_etype)  &\
                                       (etype != mmpls_etype) &\
                                       (etype != snap_etype)

// ~~~~~~~~~~ Function to get the name of ethertype ~~~~~~~~~~
  function string get_etype_name(bit [15:0] etype); // {
     if ((etype <= llc_max_len) & (etype != snap_etype))
         get_etype_name = "SNAP";
     else
     begin // {
         case (etype) // {
             dot1q_etype   : get_etype_name = "DOT1Q";
             alt1q_etype   : get_etype_name = "ALT1Q";
             stag_etype    : get_etype_name = "STAG";
             itag_etype    : get_etype_name = "ITAG";
             snap_etype    : get_etype_name = "SNAP";
             eth_etype     : get_etype_name = "ETH";
             ipv4_etype    : get_etype_name = "IPV4";
             ipv6_etype    : get_etype_name = "IPV6";
             ptl2_etype    : get_etype_name = "PTL2";
             ptp_etype     : get_etype_name = "PTP";
             mpls_etype    : get_etype_name = "MPLS-UNICAST";
             mmpls_etype   : get_etype_name = "MPLS-MULTICAST";
             default       : get_etype_name = "UNKNOWN";
         endcase // }
     end // }
  endfunction : get_etype_name // }

// ~~~~~~~~~~ Function to get the ethertype ~~~~~~~~~~
  // function to get etype based on hid
  function bit [15:0] get_etype(int hid); // {
     case (hid) // {
        SNAP_HID    : get_etype = snap_etype;
        DOT1Q_HID   : get_etype = dot1q_etype;
        ALT1Q_HID   : get_etype = alt1q_etype;
        STAG_HID    : get_etype = stag_etype;
        ITAG_HID    : get_etype = itag_etype;
        ETH_HID     : get_etype = eth_etype;
        IPV4_HID    : get_etype = ipv4_etype;
        IPV6_HID    : get_etype = ipv6_etype;
        PTL2_HID    : get_etype = ptl2_etype;
        PTP_HID     : get_etype = ptp_etype;
        MPLS_HID    : get_etype = mpls_etype;
        MMPLS_HID   : get_etype = mmpls_etype;
        default     : get_etype = $urandom ();
     endcase // }
  endfunction : get_etype // }

// ~~~~~~~~~~ Function to get the name of ethertype ~~~~~~~~~~
  function int get_hid_from_etype(bit [15:0] etype); // {
     if (etype < llc_max_len)
         get_hid_from_etype = SNAP_HID;
     else
     begin // {
         case (etype) // {
             snap_etype    : get_hid_from_etype = SNAP_HID;
             dot1q_etype   : get_hid_from_etype = DOT1Q_HID;
             alt1q_etype   : get_hid_from_etype = ALT1Q_HID;
             stag_etype    : get_hid_from_etype = STAG_HID;
             itag_etype    : get_hid_from_etype = ITAG_HID;
             eth_etype     : get_hid_from_etype = ETH_HID;
             ipv4_etype    : get_hid_from_etype = IPV4_HID;
             ipv6_etype    : get_hid_from_etype = IPV6_HID;
             ptl2_etype    : get_hid_from_etype = PTL2_HID;
             ptp_etype     : get_hid_from_etype = PTP_HID;
             mpls_etype    : get_hid_from_etype = MPLS_HID;
             mmpls_etype   : get_hid_from_etype = MMPLS_HID;
             default       : get_hid_from_etype = DATA_HID;
         endcase // }
     end // }
  endfunction : get_hid_from_etype // }

// ~~~~~~~~~~ EOF ~~~~~~~~~~
