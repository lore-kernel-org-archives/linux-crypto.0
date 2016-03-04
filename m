From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH] vti6: Add pmtu handling to vti6_xmit.
Date: Fri, 4 Mar 2016 08:05:25 +0100
Message-ID: <20160304070525.GA3347@gauss.secunet.com>
References: <20150529182709.2147.78230.stgit@ahduyck-vm-fedora22>
 <56BA975D.2040706@alliedtelesis.co.nz>
 <20160217070805.GA316@gauss.secunet.com>
 <56C520F0.4050309@alliedtelesis.co.nz>
 <20160218121915.GH316@gauss.secunet.com>
 <56CE22A3.7030702@alliedtelesis.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"alexander.h.duyck@redhat.com" <alexander.h.duyck@redhat.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>
To: Mark McKinstry <Mark.McKinstry@alliedtelesis.co.nz>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([62.96.220.36]:51809 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbcCDHFa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 4 Mar 2016 02:05:30 -0500
Content-Disposition: inline
In-Reply-To: <56CE22A3.7030702@alliedtelesis.co.nz>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Feb 24, 2016 at 09:37:39PM +0000, Mark McKinstry wrote:
> On 19/02/16 01:19, Steffen Klassert wrote:
> > On Thu, Feb 18, 2016 at 01:40:00AM +0000, Mark McKinstry wrote:
> >> This patch fixes our issue, thanks. In our scenario the tunnel path MTU
> >> now gets updated so that subsequent large packets sent over the tunnel
> >> get fragmented correctly.
> > I've applied this patch to the ipsec tree now.
> > Thanks for testing!
> I spoke too soon. Upon further testing with this patch we have found it 
> causes
> a skt buffer leak. This is problematic for us and can cause memory 
> exhaustion in
> one of our test scenarios that has an IPv4 IPsec tunnel over a PPP link. 

The patch below is what I plan to apply on top of the original patch.

Subject: [PATCH] vti: Fix recource leeks on pmtu discovery

A recent patch introduced pmtu handling directly in the
vti transmit routine. Unfortunately we now return without
releasing the dst_entry and freeing the sk_buff. This patch
fixes the issue.

Fixes: 325b71fe0f57 ("vti: Add pmtu handling to vti_xmit.")
Reported-by: Mark McKinstry <Mark.McKinstry@alliedtelesis.co.nz>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv4/ip_vti.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
index 6862305..2ea2b6e 100644
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -206,7 +206,8 @@ static netdev_tx_t vti_xmit(struct sk_buff *skb, struct net_device *dev,
 		else
 			icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
 
-		return -EMSGSIZE;
+		dst_release(dst);
+		goto tx_error;
 	}
 
 	err = dst_output(tunnel->net, skb->sk, skb);
-- 
1.9.1
