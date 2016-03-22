From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH] vti6: Add pmtu handling to vti6_xmit.
Date: Tue, 22 Mar 2016 11:53:18 +0100
Message-ID: <20160322105318.GS3347@gauss.secunet.com>
References: <20150529182709.2147.78230.stgit@ahduyck-vm-fedora22>
 <56BA975D.2040706@alliedtelesis.co.nz>
 <20160217070805.GA316@gauss.secunet.com>
 <56C520F0.4050309@alliedtelesis.co.nz>
 <20160218121915.GH316@gauss.secunet.com>
 <56CE22A3.7030702@alliedtelesis.co.nz>
 <20160304070525.GA3347@gauss.secunet.com>
 <56E73285.5000702@alliedtelesis.co.nz>
 <20160315122801.GB3347@gauss.secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"alexander.h.duyck@redhat.com" <alexander.h.duyck@redhat.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>
To: Mark McKinstry <Mark.McKinstry@alliedtelesis.co.nz>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([62.96.220.36]:45280 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759170AbcCVKx2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 Mar 2016 06:53:28 -0400
Content-Disposition: inline
In-Reply-To: <20160315122801.GB3347@gauss.secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 15, 2016 at 01:28:01PM +0100, Steffen Klassert wrote:
> On Mon, Mar 14, 2016 at 09:52:05PM +0000, Mark McKinstry wrote:
> > Your patch adds a dst_release() call to my suggested fix, but this is 
> > problematic because the kfree_skb() call at tx_error already takes care 
> > of releasing dst - via kfree_skb() > __kfree_skb() > skb_release_all() > 
> > skb_release_head_state() > skb_dst_drop()
> >  > refdst_drop() > dst_release(). In our scenario your patch results in 
> > a negative refcount kernel warning being generated in dst_release() for 
> > every packet that is too big to go over the vti.
> 
> Hm. I've just noticed that my pmtu test does not trigger this
> codepath, so I did not see the warning.
> 
> Seems like we do the pmtu handling too late, it should happen before
> we do skb_dst_set(). Also skb_scrub_packet() resets skb->ignore_df,
> so checking ignore_df after skb_scrub_packet() does not make much sense.
> 
> I'll send an updated version after some more testing.
> 

I've added a testcase that triggers this codepath to my testing
environment. The patch below works for me, could you please test
if it fixes your problems?

Subject: [PATCH] vti: Add pmtu handling to vti_xmit.

We currently rely on the PMTU discovery of xfrm.
However if a packet is locally sent, the PMTU mechanism
of xfrm tries to do local socket notification what
might not work for applications like ping that don't
check for this. So add pmtu handling to vti_xmit to
report MTU changes immediately.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv4/ip_vti.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
index 5cf10b7..a917903 100644
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -156,6 +156,7 @@ static netdev_tx_t vti_xmit(struct sk_buff *skb, struct net_device *dev,
 	struct dst_entry *dst = skb_dst(skb);
 	struct net_device *tdev;	/* Device to other host */
 	int err;
+	int mtu;
 
 	if (!dst) {
 		dev->stats.tx_carrier_errors++;
@@ -192,6 +193,23 @@ static netdev_tx_t vti_xmit(struct sk_buff *skb, struct net_device *dev,
 			tunnel->err_count = 0;
 	}
 
+	mtu = dst_mtu(dst);
+	if (skb->len > mtu) {
+		skb_dst(skb)->ops->update_pmtu(skb_dst(skb), NULL, skb, mtu);
+		if (skb->protocol == htons(ETH_P_IP)) {
+			icmp_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
+				  htonl(mtu));
+		} else {
+			if (mtu < IPV6_MIN_MTU)
+				mtu = IPV6_MIN_MTU;
+
+			icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
+		}
+
+		dst_release(dst);
+		goto tx_error;
+	}
+
 	skb_scrub_packet(skb, !net_eq(tunnel->net, dev_net(dev)));
 	skb_dst_set(skb, dst);
 	skb->dev = skb_dst(skb)->dev;
-- 
1.9.1
