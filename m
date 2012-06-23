From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 18/20] crypto: caam - only query h/w in job ring dequeue path
Date: Fri, 22 Jun 2012 19:48:55 -0500
Message-ID: <1340412537-2325-13-git-send-email-kim.phillips@freescale.com>
References: <1340412174-1784-1-git-send-email-kim.phillips@freescale.com>
 <1340412537-2325-1-git-send-email-kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [213.199.154.208] ([213.199.154.208]:25767 "EHLO
	am1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933252Ab2FWAwD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Jun 2012 20:52:03 -0400
In-Reply-To: <1340412537-2325-1-git-send-email-kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Code was needlessly checking the s/w job ring when there
would be nothing to process if the h/w's output completion
ring were empty anyway.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/caam/jr.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index 11d93f2..7ae5e51 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -59,15 +59,15 @@ static void caam_jr_dequeue(unsigned long devarg)
 	u32 *userdesc, userstatus;
 	void *userarg;
 
-	spin_lock_bh(&jrp->outlock);
+	while (rd_reg32(&jrp->rregs->outring_used)) {
 
-	head = ACCESS_ONCE(jrp->head);
-	sw_idx = tail = jrp->tail;
+		head = ACCESS_ONCE(jrp->head);
 
-	while (CIRC_CNT(head, tail, JOBR_DEPTH) >= 1 &&
-	       rd_reg32(&jrp->rregs->outring_used)) {
+		spin_lock_bh(&jrp->outlock);
 
+		sw_idx = tail = jrp->tail;
 		hw_idx = jrp->out_ring_read_index;
+
 		for (i = 0; CIRC_CNT(head, tail + i, JOBR_DEPTH) >= 1; i++) {
 			sw_idx = (tail + i) & (JOBR_DEPTH - 1);
 
@@ -121,15 +121,8 @@ static void caam_jr_dequeue(unsigned long devarg)
 
 		/* Finally, execute user's callback */
 		usercall(dev, userdesc, userstatus, userarg);
-
-		spin_lock_bh(&jrp->outlock);
-
-		head = ACCESS_ONCE(jrp->head);
-		sw_idx = tail = jrp->tail;
 	}
 
-	spin_unlock_bh(&jrp->outlock);
-
 	/* reenable / unmask IRQs */
 	clrbits32(&jrp->rregs->rconfig_lo, JRCFG_IMSK);
 }
-- 
1.7.11.1
