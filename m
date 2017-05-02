From: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Subject: IPsec PFP support on linux
Date: Tue, 2 May 2017 08:32:38 -0400
Message-ID: <20170502123238.GE5843@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sowmini.varadhan@oracle.com
To: netdev@vger.kernel.org, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, swan@lists.libreswan.org,
        steffen.klassert@secunet.com, borisp@mellanox.com,
        ilant@mellanox.com
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

I have a question about linux support for IPsec PFP (as defined in
rfc 4301). I am assuming this exists, and is accessible from uspace,
in which case I need some hints on how to set it up.

Assuming I have a server listening at port 5001 that I want to
secure via ipsec. Suppose I want to make sure that each TCP/UDP 5-tuple
sending packets to port 5001 gets its own SA.

RFC4301 has this:

       - SPD-S: For traffic that is to be protected using IPsec, the
         entry consists of the values of the selectors that apply to the
         traffic to be protected via AH or ESP, controls on how to
         create SAs based on these selectors, ...

and further down
      If IPsec processing is specified for
      an entry, a "populate from packet" (PFP) flag may be asserted for
      one or more of the selectors in the SPD entry (Local IP address;
      Remote IP address; Next Layer Protocol; and, depending on Next
      Layer Protocol, Local port and Remote port, or ICMP type/code, or
      Mobility Header type).  If asserted for a given selector X, the
      flag indicates that the SA to be created should take its value for
      X from the value in the packet.  Otherwise, the SA should take its
      value(s) for X from the value(s) in the SPD entry.

A google search produces a discarded patch
  http://marc.info/?l=linux-netdev&m=119746758904140
but its not clear to me how to set this up (if PFP works fine,
as suggested by Herbert's response above)

I tried experimenting with IP_XFRM_POLICY from a simple udp client but
(a) that seems to require a SPI and reqid to set up the SPD 
(b) I see the SADB_ACQUIRE upcall being triggered after the local port
    is bound (and SADB entry is set up for the lport).  But ike phase2
    does not converge for the lport specific sadb added
    by the bind (even in quick mode)

My understanding is that pluto shoud be generating spi's to make sure
they are sufficiently unique/random etc. so (a) makes me think I'm
either not setting this up or not using this correctly.

Any hints/sample code/RTFMs would be helpful (documentation for
IP_XFRM_POLICY seems scant, afaict). I'd be happy to share my 
udp client program, if it can provide more context to my question.

--Sowmini
