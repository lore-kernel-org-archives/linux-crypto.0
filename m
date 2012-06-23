From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 20/20] crypto: caam - one tasklet per job ring
Date: Fri, 22 Jun 2012 19:48:57 -0500
Message-ID: <1340412537-2325-15-git-send-email-kim.phillips@freescale.com>
References: <1340412174-1784-1-git-send-email-kim.phillips@freescale.com>
 <1340412537-2325-1-git-send-email-kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [213.199.154.204] ([213.199.154.204]:8755 "EHLO
	am1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933261Ab2FWAwI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Jun 2012 20:52:08 -0400
In-Reply-To: <1340412537-2325-1-git-send-email-kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

there is no noticeable benefit for multiple cores to process one
job ring's output ring: in fact, we can benefit from cache effects
of having the back-half stay on the core that receives a particular
ring's interrupts, and further relax general contention and the
locking involved with reading outring_used, since tasklets run
atomically.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/caam/intern.h |  2 +-
 drivers/crypto/caam/jr.c     | 13 +++++--------
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
index ed2b739..5cd4c1b 100644
--- a/drivers/crypto/caam/intern.h
+++ b/drivers/crypto/caam/intern.h
@@ -43,7 +43,7 @@ struct caam_drv_private_jr {
 	struct device *parentdev;	/* points back to controller dev */
 	int ridx;
 	struct caam_job_ring __iomem *rregs;	/* JobR's register space */
-	struct tasklet_struct irqtask[NR_CPUS];
+	struct tasklet_struct irqtask;
 	int irq;			/* One per queue */
 	int assign;			/* busy/free */
 
diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index 0adaad1..7074a1a 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -43,7 +43,7 @@ static irqreturn_t caam_jr_interrupt(int irq, void *st_dev)
 	wr_reg32(&jrp->rregs->jrintstatus, irqstate);
 
 	preempt_disable();
-	tasklet_schedule(&jrp->irqtask[smp_processor_id()]);
+	tasklet_schedule(&jrp->irqtask);
 	preempt_enable();
 
 	return IRQ_HANDLED;
@@ -322,11 +322,9 @@ static int caam_jr_init(struct device *dev)
 
 	jrp = dev_get_drvdata(dev);
 
-	/* Connect job ring interrupt handler. */
-	for_each_possible_cpu(i)
-		tasklet_init(&jrp->irqtask[i], caam_jr_dequeue,
-			     (unsigned long)dev);
+	tasklet_init(&jrp->irqtask, caam_jr_dequeue, (unsigned long)dev);
 
+	/* Connect job ring interrupt handler. */
 	error = request_irq(jrp->irq, caam_jr_interrupt, IRQF_SHARED,
 			    "caam-jobr", dev);
 	if (error) {
@@ -416,12 +414,11 @@ int caam_jr_shutdown(struct device *dev)
 {
 	struct caam_drv_private_jr *jrp = dev_get_drvdata(dev);
 	dma_addr_t inpbusaddr, outbusaddr;
-	int ret, i;
+	int ret;
 
 	ret = caam_reset_hw_jr(dev);
 
-	for_each_possible_cpu(i)
-		tasklet_kill(&jrp->irqtask[i]);
+	tasklet_kill(&jrp->irqtask);
 
 	/* Release interrupt */
 	free_irq(jrp->irq, dev);
-- 
1.7.11.1
