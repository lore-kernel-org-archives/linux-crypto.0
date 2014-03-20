From: Yashpal Dutta <yashpal.dutta@freescale.com>
Subject: [PATCH] crypto: caam - power management support for caam job-ring
Date: Thu, 20 Mar 2014 08:03:17 +0545
Message-ID: <1395281897-45211-1-git-send-email-yashpal.dutta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Yashpal Dutta <yashpal.dutta@freescale.com>
To: <linux-crypto@vger.kernel.org>, <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:45440
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750758AbaCSSX2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Mar 2014 14:23:28 -0400
Received: from mail217-ch1 (localhost [127.0.0.1])	by
 mail217-ch1-R.bigfish.com (Postfix) with ESMTP id 6C4071E0108	for
 <linux-crypto@vger.kernel.org>; Wed, 19 Mar 2014 18:23:27 +0000 (UTC)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Job ring is suspended gracefully and resume afresh.
Pending Jobs not yet processed by CAAM are marked with error for
producer

Signed-off-by: Yashpal Dutta <yashpal.dutta@freescale.com>
---
 drivers/crypto/caam/intern.h |   2 +
 drivers/crypto/caam/jr.c     | 253 ++++++++++++++++++++++++++++++++-----------
 2 files changed, 189 insertions(+), 66 deletions(-)

diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
index 6d85fcc..0d41d05 100644
--- a/drivers/crypto/caam/intern.h
+++ b/drivers/crypto/caam/intern.h
@@ -54,6 +54,8 @@ struct caam_drv_private_jr {
 	int inp_ring_write_index;	/* Input index "tail" */
 	int head;			/* entinfo (s/w ring) head index */
 	dma_addr_t *inpring;	/* Base of input ring, alloc DMA-safe */
+	dma_addr_t inpbusaddr;	/* Input ring physical address */
+	dma_addr_t outbusaddr;	/* Output ring physical address */
 	spinlock_t outlock ____cacheline_aligned; /* Output ring index lock */
 	int out_ring_read_index;	/* Output index "tail" */
 	int tail;			/* entinfo (s/w ring) tail index */
diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index 1d80bd3..33d1cf7 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -68,7 +68,6 @@ static int caam_reset_hw_jr(struct device *dev)
 int caam_jr_shutdown(struct device *dev)
 {
 	struct caam_drv_private_jr *jrp = dev_get_drvdata(dev);
-	dma_addr_t inpbusaddr, outbusaddr;
 	int ret;
 
 	ret = caam_reset_hw_jr(dev);
@@ -78,13 +77,10 @@ int caam_jr_shutdown(struct device *dev)
 	/* Release interrupt */
 	free_irq(jrp->irq, dev);
 
-	/* Free rings */
-	inpbusaddr = rd_reg64(&jrp->rregs->inpring_base);
-	outbusaddr = rd_reg64(&jrp->rregs->outring_base);
 	dma_free_coherent(dev, sizeof(dma_addr_t) * JOBR_DEPTH,
-			  jrp->inpring, inpbusaddr);
+			  jrp->inpring, jrp->inpbusaddr);
 	dma_free_coherent(dev, sizeof(struct jr_outentry) * JOBR_DEPTH,
-			  jrp->outring, outbusaddr);
+			  jrp->outring, jrp->outbusaddr);
 	kfree(jrp->entinfo);
 
 	return ret;
@@ -159,78 +155,82 @@ static irqreturn_t caam_jr_interrupt(int irq, void *st_dev)
 	return IRQ_HANDLED;
 }
 
-/* Deferred service handler, run as interrupt-fired tasklet */
-static void caam_jr_dequeue(unsigned long devarg)
+/* Consume the processed output ring Job */
+static inline void caam_jr_consume(struct device *dev)
 {
 	int hw_idx, sw_idx, i, head, tail;
-	struct device *dev = (struct device *)devarg;
 	struct caam_drv_private_jr *jrp = dev_get_drvdata(dev);
 	void (*usercall)(struct device *dev, u32 *desc, u32 status, void *arg);
 	u32 *userdesc, userstatus;
 	void *userarg;
 
-	while (rd_reg32(&jrp->rregs->outring_used)) {
+	head = ACCESS_ONCE(jrp->head);
+	spin_lock(&jrp->outlock);
 
-		head = ACCESS_ONCE(jrp->head);
+	sw_idx = tail = jrp->tail;
+	hw_idx = jrp->out_ring_read_index;
 
-		spin_lock(&jrp->outlock);
+	for (i = 0; CIRC_CNT(head, tail + i, JOBR_DEPTH) >= 1; i++) {
+		sw_idx = (tail + i) & (JOBR_DEPTH - 1);
 
-		sw_idx = tail = jrp->tail;
-		hw_idx = jrp->out_ring_read_index;
+		smp_read_barrier_depends();
+		if (jrp->outring[hw_idx].desc ==
+		    jrp->entinfo[sw_idx].desc_addr_dma)
+			break; /* found */
+	}
+	/* we should never fail to find a matching descriptor */
+	BUG_ON(CIRC_CNT(head, tail + i, JOBR_DEPTH) <= 0);
 
-		for (i = 0; CIRC_CNT(head, tail + i, JOBR_DEPTH) >= 1; i++) {
-			sw_idx = (tail + i) & (JOBR_DEPTH - 1);
+	/* Unmap just-run descriptor so we can post-process */
+	dma_unmap_single(dev, jrp->outring[hw_idx].desc,
+			 jrp->entinfo[sw_idx].desc_size,
+			 DMA_TO_DEVICE);
 
-			smp_read_barrier_depends();
+	/* mark completed, avoid matching on a recycled desc addr */
+	jrp->entinfo[sw_idx].desc_addr_dma = 0;
 
-			if (jrp->outring[hw_idx].desc ==
-			    jrp->entinfo[sw_idx].desc_addr_dma)
-				break; /* found */
-		}
-		/* we should never fail to find a matching descriptor */
-		BUG_ON(CIRC_CNT(head, tail + i, JOBR_DEPTH) <= 0);
-
-		/* Unmap just-run descriptor so we can post-process */
-		dma_unmap_single(dev, jrp->outring[hw_idx].desc,
-				 jrp->entinfo[sw_idx].desc_size,
-				 DMA_TO_DEVICE);
-
-		/* mark completed, avoid matching on a recycled desc addr */
-		jrp->entinfo[sw_idx].desc_addr_dma = 0;
-
-		/* Stash callback params for use outside of lock */
-		usercall = jrp->entinfo[sw_idx].callbk;
-		userarg = jrp->entinfo[sw_idx].cbkarg;
-		userdesc = jrp->entinfo[sw_idx].desc_addr_virt;
-		userstatus = jrp->outring[hw_idx].jrstatus;
-
-		/* set done */
-		wr_reg32(&jrp->rregs->outring_rmvd, 1);
-
-		jrp->out_ring_read_index = (jrp->out_ring_read_index + 1) &
-					   (JOBR_DEPTH - 1);
-
-		/*
-		 * if this job completed out-of-order, do not increment
-		 * the tail.  Otherwise, increment tail by 1 plus the
-		 * number of subsequent jobs already completed out-of-order
-		 */
-		if (sw_idx == tail) {
-			do {
-				tail = (tail + 1) & (JOBR_DEPTH - 1);
-				smp_read_barrier_depends();
-			} while (CIRC_CNT(head, tail, JOBR_DEPTH) >= 1 &&
-				 jrp->entinfo[tail].desc_addr_dma == 0);
-
-			jrp->tail = tail;
-		}
+	/* Stash callback params for use outside of lock */
+	usercall = jrp->entinfo[sw_idx].callbk;
+	userarg = jrp->entinfo[sw_idx].cbkarg;
+	userdesc = jrp->entinfo[sw_idx].desc_addr_virt;
+	userstatus = jrp->outring[hw_idx].jrstatus;
 
-		spin_unlock(&jrp->outlock);
+	/* set done */
+	wr_reg32(&jrp->rregs->outring_rmvd, 1);
 
-		/* Finally, execute user's callback */
-		usercall(dev, userdesc, userstatus, userarg);
+	jrp->out_ring_read_index = (jrp->out_ring_read_index + 1) &
+				   (JOBR_DEPTH - 1);
+
+	/*
+	 * if this job completed out-of-order, do not increment
+	 * the tail.  Otherwise, increment tail by 1 plus the
+	 * number of subsequent jobs already completed out-of-order
+	 */
+	if (sw_idx == tail) {
+		do {
+			tail = (tail + 1) & (JOBR_DEPTH - 1);
+			smp_read_barrier_depends();
+		} while (CIRC_CNT(head, tail, JOBR_DEPTH) >= 1 &&
+			 jrp->entinfo[tail].desc_addr_dma == 0);
+
+		jrp->tail = tail;
 	}
 
+	spin_unlock(&jrp->outlock);
+
+	/* Finally, execute user's callback */
+	usercall(dev, userdesc, userstatus, userarg);
+}
+
+/* Deferred service handler, run as interrupt-fired tasklet */
+static void caam_jr_dequeue(unsigned long devarg)
+{
+	struct device *dev = (struct device *)devarg;
+	struct caam_drv_private_jr *jrp = dev_get_drvdata(dev);
+
+	while (rd_reg32(&jrp->rregs->outring_used))
+		caam_jr_consume(dev);
+
 	/* reenable / unmask IRQs */
 	clrbits32(&jrp->rregs->rconfig_lo, JRCFG_IMSK);
 }
@@ -368,13 +368,131 @@ int caam_jr_enqueue(struct device *dev, u32 *desc,
 }
 EXPORT_SYMBOL(caam_jr_enqueue);
 
+#ifdef CONFIG_PM
+/* Return Failure for Job pending in input ring */
+static void caam_fail_inpjobs(struct device *dev)
+{
+	struct caam_drv_private_jr *jrp = dev_get_drvdata(dev);
+	void (*usercall)(struct device *dev, u32 *desc, u32 status, void *arg);
+	u32 *userdesc;
+	void *userarg;
+	int sw_idx;
+
+	/* Check for jobs left after reaching output ring and return error */
+	for (sw_idx = 0; sw_idx < JOBR_DEPTH; sw_idx++) {
+		if (jrp->entinfo[sw_idx].desc_addr_dma != 0) {
+			usercall = jrp->entinfo[sw_idx].callbk;
+			userarg = jrp->entinfo[sw_idx].cbkarg;
+			userdesc = jrp->entinfo[sw_idx].desc_addr_virt;
+			usercall(dev, userdesc, -EIO, userarg);
+			jrp->entinfo[sw_idx].desc_addr_dma = 0;
+		}
+	}
+}
+
+/* Suspend handler for Job Ring */
+static int jr_suspend(struct device *dev)
+{
+	struct caam_drv_private_jr *jrp = dev_get_drvdata(dev);
+	unsigned int timeout = 100000;
+	int ret = 0;
+
+	/*
+	 * mask interrupts since we are going to poll
+	 * for reset completion status
+	 */
+	setbits32(&jrp->rregs->rconfig_lo, JRCFG_IMSK);
+
+	/*
+	 * Cleanup all the pending completed Jobs to make room for
+	 * in Job's coming to Outring during flush
+	 */
+	while (rd_reg32(&jrp->rregs->outring_used))
+		caam_jr_consume(dev);
+
+	/* initiate flush (required prior to reset) */
+	wr_reg32(&jrp->rregs->jrcommand, JRCR_RESET);
+	while (((rd_reg32(&jrp->rregs->jrintstatus) & JRINT_ERR_HALT_MASK) ==
+		JRINT_ERR_HALT_INPROGRESS) && --timeout)
+		cpu_relax();
+
+	if ((rd_reg32(&jrp->rregs->jrintstatus) & JRINT_ERR_HALT_MASK) !=
+	    JRINT_ERR_HALT_COMPLETE || timeout == 0) {
+		dev_err(dev, "failed to flush job ring %d\n", jrp->ridx);
+		ret = -EIO;
+		goto err;
+	}
+
+	/*
+	 * Disallow any further addition in Job Ring by making input_ring
+	 * size ZERO. If output complete ring processing try to enqueue
+	 * more Job's back to JR, it will return -EBUSY
+	 */
+	wr_reg32(&jrp->rregs->inpring_size, 0);
+
+	while (rd_reg32(&jrp->rregs->outring_used))
+		caam_jr_consume(dev);
+
+	caam_fail_inpjobs(dev);
+
+	/* initiate reset */
+	timeout = 100000;
+	wr_reg32(&jrp->rregs->jrcommand, JRCR_RESET);
+	while ((rd_reg32(&jrp->rregs->jrcommand) & JRCR_RESET) && --timeout)
+		cpu_relax();
+
+	if (timeout == 0) {
+		dev_err(dev, "failed to reset job ring %d\n", jrp->ridx);
+		ret = -EIO;
+		goto err;
+	}
+
+err:
+	/* unmask interrupts */
+	clrbits32(&jrp->rregs->rconfig_lo, JRCFG_IMSK);
+	return ret;
+}
+
+/* Resume handler for Job Ring */
+static int jr_resume(struct device *dev)
+{
+	struct caam_drv_private_jr *jrp;
+
+	jrp = dev_get_drvdata(dev);
+
+	memset(jrp->entinfo, 0, sizeof(struct caam_jrentry_info) * JOBR_DEPTH);
+
+	/* Setup rings */
+	jrp->inp_ring_write_index = 0;
+	jrp->out_ring_read_index = 0;
+	jrp->head = 0;
+	jrp->tail = 0;
+
+	/* Setup ring base registers */
+	wr_reg64(&jrp->rregs->inpring_base, jrp->inpbusaddr);
+	wr_reg64(&jrp->rregs->outring_base, jrp->outbusaddr);
+	/* Setup ring size */
+	wr_reg32(&jrp->rregs->inpring_size, JOBR_DEPTH);
+	wr_reg32(&jrp->rregs->outring_size, JOBR_DEPTH);
+
+	setbits32(&jrp->rregs->rconfig_lo, JOBR_INTC |
+		  (JOBR_INTC_COUNT_THLD << JRCFG_ICDCT_SHIFT) |
+		  (JOBR_INTC_TIME_THLD << JRCFG_ICTT_SHIFT));
+	return 0;
+}
+
+const struct dev_pm_ops jr_pm_ops = {
+	.suspend = jr_suspend,
+	.resume = jr_resume,
+};
+#endif /* CONFIG_PM */
+
 /*
  * Init JobR independent of platform property detection
  */
 static int caam_jr_init(struct device *dev)
 {
 	struct caam_drv_private_jr *jrp;
-	dma_addr_t inpbusaddr, outbusaddr;
 	int i, error;
 
 	jrp = dev_get_drvdata(dev);
@@ -397,10 +515,10 @@ static int caam_jr_init(struct device *dev)
 		return error;
 
 	jrp->inpring = dma_alloc_coherent(dev, sizeof(dma_addr_t) * JOBR_DEPTH,
-					  &inpbusaddr, GFP_KERNEL);
+					  &jrp->inpbusaddr, GFP_KERNEL);
 
 	jrp->outring = dma_alloc_coherent(dev, sizeof(struct jr_outentry) *
-					  JOBR_DEPTH, &outbusaddr, GFP_KERNEL);
+					  JOBR_DEPTH, &jrp->outbusaddr, GFP_KERNEL);
 
 	jrp->entinfo = kzalloc(sizeof(struct caam_jrentry_info) * JOBR_DEPTH,
 			       GFP_KERNEL);
@@ -421,8 +539,8 @@ static int caam_jr_init(struct device *dev)
 	jrp->head = 0;
 	jrp->tail = 0;
 
-	wr_reg64(&jrp->rregs->inpring_base, inpbusaddr);
-	wr_reg64(&jrp->rregs->outring_base, outbusaddr);
+	wr_reg64(&jrp->rregs->inpring_base, jrp->inpbusaddr);
+	wr_reg64(&jrp->rregs->outring_base, jrp->outbusaddr);
 	wr_reg32(&jrp->rregs->inpring_size, JOBR_DEPTH);
 	wr_reg32(&jrp->rregs->outring_size, JOBR_DEPTH);
 
@@ -518,6 +636,9 @@ static struct platform_driver caam_jr_driver = {
 		.name = "caam_jr",
 		.owner = THIS_MODULE,
 		.of_match_table = caam_jr_match,
+#ifdef CONFIG_PM
+		.pm = &jr_pm_ops,
+#endif
 	},
 	.probe       = caam_jr_probe,
 	.remove      = caam_jr_remove,
-- 
1.8.1.2
