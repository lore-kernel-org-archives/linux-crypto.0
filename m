From: Yuan Kang <Yuan.Kang@freescale.com>
Subject: [RFC] ah4: use passed-in value of err in ah_output_done
Date: Wed, 17 Aug 2011 14:46:18 -0500
Message-ID: <20110817144618.e55f460d.Yuan.Kang@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:40845
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751200Ab1HQTuT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Aug 2011 15:50:19 -0400
Received: from mail49-ch1 (localhost.localdomain [127.0.0.1])	by
 mail49-ch1-R.bigfish.com (Postfix) with ESMTP id 636E2628445	for
 <linux-crypto@vger.kernel.org>; Wed, 17 Aug 2011 19:50:18 +0000 (UTC)
Received: from CH1EHSMHS025.bigfish.com (snatpool1.int.messaging.microsoft.com
 [10.43.68.246])	by mail49-ch1.bigfish.com (Postfix) with ESMTP id
 3EBB01AA004F	for <linux-crypto@vger.kernel.org>; Wed, 17 Aug 2011 19:50:18
 +0000 (UTC)
Received: from localhost (b36765-ec1.am.freescale.net [10.82.120.211])	by
 az33smr01.freescale.net (8.13.1/8.13.0) with SMTP id p7HJoEl1004608	for
 <linux-crypto@vger.kernel.org>; Wed, 17 Aug 2011 14:50:14 -0500 (CDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

ah_output_done, as the callback function for the
digest function, receives the exit status in err,
and calls xfrm_output_resume, which also takes a
parameter called err.
Assuming that the digest function exited successfully,
the value of err is 0, and prevents xfrm_output_resume
from calling ah_output, which calls the digest function,
again. However, setting the value of err to ah->nexthdr
gives err a positive protocol value, resulting in
infinite calls of the digest function, preventing the
sending of the packet to the network.

It appears that, except for the first call,
xfrm_output_resume should take err directly from the
value that ah_output_done receives, like esp_output_done,
and unlike ah_input_done, which calls xfrm_input_resume,
which explicitly takes a parameter called nexthdr.
When the change was made, ICMP would work with ah transport
mode.

Signed-off-by: Yuan Kang <Yuan.Kang@freescale.com>
---
 net/ipv4/ah4.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ah4.c b/net/ipv4/ah4.c
index c1f4154..33ca186 100644
--- a/net/ipv4/ah4.c
+++ b/net/ipv4/ah4.c
@@ -136,8 +136,6 @@ static void ah_output_done(struct crypto_async_request *base, int err)
 		memcpy(top_iph+1, iph+1, top_iph->ihl*4 - sizeof(struct iphdr));
 	}
 
-	err = ah->nexthdr;
-
 	kfree(AH_SKB_CB(skb)->tmp);
 	xfrm_output_resume(skb, err);
 }
-- 
1.7.4.4
