From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 1/4] crypto: caam - handle interrupt lines shared across
 rings
Date: Mon, 11 Apr 2011 19:15:16 -0500
Message-ID: <20110411191516.bae0454e.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Steve Cornelius <sec@pobox.com>
To: <linux-crypto@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:47245
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756467Ab1DLAPY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 Apr 2011 20:15:24 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

- add IRQF_SHARED to request_irq flags to support parts such as
the p1023 that has one IRQ line per couple of rings.

- resetting a job ring triggers an interrupt, so move request_irq
prior to jr_reset to avoid 'got IRQ but nobody cared' messages.

- disable IRQs in h/w to avoid contention between reset and
interrupt status

- delete invalid comment - if there were incomplete jobs,
module would be in use, preventing an unload.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
this, and the remaining patches in this series, tested on p1023, p3041,
p4080, and 32- and 64-bit p5020.

 drivers/crypto/caam/jr.c |   46 ++++++++++++++++++++--------------------------
 1 files changed, 20 insertions(+), 26 deletions(-)

diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index 68cb9af..340fa32 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -292,10 +292,10 @@ static int caam_reset_hw_jr(struct device *dev)
 	unsigned int timeout = 100000;
 
 	/*
-	 * FIXME: disabling IRQs here inhibits proper job completion
-	 * and error propagation
+	 * mask interrupts since we are going to poll
+	 * for reset completion status
 	 */
-	disable_irq(jrp->irq);
+	setbits32(&jrp->rregs->rconfig_lo, JRCFG_IMSK);
 
 	/* initiate flush (required prior to reset) */
 	wr_reg32(&jrp->rregs->jrcommand, JRCR_RESET);
@@ -320,7 +320,8 @@ static int caam_reset_hw_jr(struct device *dev)
 		return -EIO;
 	}
 
-	enable_irq(jrp->irq);
+	/* unmask interrupts */
+	clrbits32(&jrp->rregs->rconfig_lo, JRCFG_IMSK);
 
 	return 0;
 }
@@ -336,6 +337,21 @@ static int caam_jr_init(struct device *dev)
 
 	jrp = dev_get_drvdata(dev);
 
+	/* Connect job ring interrupt handler. */
+	for_each_possible_cpu(i)
+		tasklet_init(&jrp->irqtask[i], caam_jr_dequeue,
+			     (unsigned long)dev);
+
+	error = request_irq(jrp->irq, caam_jr_interrupt, IRQF_SHARED,
+			    "caam-jobr", dev);
+	if (error) {
+		dev_err(dev, "can't connect JobR %d interrupt (%d)\n",
+			jrp->ridx, jrp->irq);
+		irq_dispose_mapping(jrp->irq);
+		jrp->irq = 0;
+		return -EINVAL;
+	}
+
 	error = caam_reset_hw_jr(dev);
 	if (error)
 		return error;
@@ -404,28 +420,6 @@ static int caam_jr_init(struct device *dev)
 		  (JOBR_INTC_COUNT_THLD << JRCFG_ICDCT_SHIFT) |
 		  (JOBR_INTC_TIME_THLD << JRCFG_ICTT_SHIFT));
 
-	/* Connect job ring interrupt handler. */
-	for_each_possible_cpu(i)
-		tasklet_init(&jrp->irqtask[i], caam_jr_dequeue,
-			     (unsigned long)dev);
-
-	error = request_irq(jrp->irq, caam_jr_interrupt, 0,
-			    "caam-jobr", dev);
-	if (error) {
-		dev_err(dev, "can't connect JobR %d interrupt (%d)\n",
-			jrp->ridx, jrp->irq);
-		irq_dispose_mapping(jrp->irq);
-		jrp->irq = 0;
-		dma_unmap_single(dev, inpbusaddr, sizeof(u32 *) * JOBR_DEPTH,
-				 DMA_BIDIRECTIONAL);
-		dma_unmap_single(dev, outbusaddr, sizeof(u32 *) * JOBR_DEPTH,
-				 DMA_BIDIRECTIONAL);
-		kfree(jrp->inpring);
-		kfree(jrp->outring);
-		kfree(jrp->entinfo);
-		return -EINVAL;
-	}
-
 	jrp->assign = JOBR_UNASSIGNED;
 	return 0;
 }
-- 
1.7.4.3.dirty
