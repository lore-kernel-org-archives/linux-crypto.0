From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 19/20] crypto: caam - consolidate memory barriers from job ring en/dequeue
Date: Fri, 22 Jun 2012 19:48:56 -0500
Message-ID: <1340412537-2325-14-git-send-email-kim.phillips@freescale.com>
References: <1340412174-1784-1-git-send-email-kim.phillips@freescale.com>
 <1340412537-2325-1-git-send-email-kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:3785
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756821Ab2FWAu5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Jun 2012 20:50:57 -0400
In-Reply-To: <1340412537-2325-1-git-send-email-kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Memory barriers are implied by the i/o register write implementation
(at least on Power).  So we can remove the redundant wmb() in
caam_jr_enqueue, and, in dequeue(), hoist the h/w done notification
write up to before we need to increment the head of the ring, and
save an smp_mb.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/caam/jr.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index 7ae5e51..0adaad1 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -94,7 +94,8 @@ static void caam_jr_dequeue(unsigned long devarg)
 		userdesc = jrp->entinfo[sw_idx].desc_addr_virt;
 		userstatus = jrp->outring[hw_idx].jrstatus;
 
-		smp_mb();
+		/* set done */
+		wr_reg32(&jrp->rregs->outring_rmvd, 1);
 
 		jrp->out_ring_read_index = (jrp->out_ring_read_index + 1) &
 					   (JOBR_DEPTH - 1);
@@ -114,9 +115,6 @@ static void caam_jr_dequeue(unsigned long devarg)
 			jrp->tail = tail;
 		}
 
-		/* set done */
-		wr_reg32(&jrp->rregs->outring_rmvd, 1);
-
 		spin_unlock_bh(&jrp->outlock);
 
 		/* Finally, execute user's callback */
@@ -265,8 +263,6 @@ int caam_jr_enqueue(struct device *dev, u32 *desc,
 				    (JOBR_DEPTH - 1);
 	jrp->head = (head + 1) & (JOBR_DEPTH - 1);
 
-	wmb();
-
 	wr_reg32(&jrp->rregs->inpring_jobadd, 1);
 
 	spin_unlock(&jrp->inplock);
-- 
1.7.11.1
