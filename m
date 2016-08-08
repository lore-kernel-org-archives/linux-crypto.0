From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 11/11] crypto: caam: get rid of tasklet
Date: Mon, 08 Aug 2016 18:05:24 +0100
Message-ID: <E1bWnzQ-0002WR-W0@rmk-PC.armlinux.org.uk>
References: <20160808170400.GC1041@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Fabio Estevam <fabio.estevam@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:57514 "EHLO
	pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbcHHRFa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Aug 2016 13:05:30 -0400
In-Reply-To: <20160808170400.GC1041@n2100.armlinux.org.uk>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Threaded interrupts can perform the function of the tasklet, and much
more safely too - without races when trying to take the tasklet and
interrupt down on device removal.

With the old code, there is a window where we call tasklet_kill().  If
the interrupt handler happens to be running on a different CPU, and
subsequently calls tasklet_schedule(), the tasklet will be re-scheduled
for execution.

Switching to a hardirq/threadirq combination implementation avoids this,
and it also means generic code deals with the teardown sequencing of the
threaded and non-threaded parts.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/crypto/caam/intern.h |  1 -
 drivers/crypto/caam/jr.c     | 25 +++++++++----------------
 2 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
index e2bcacc1a921..5d4c05074a5c 100644
--- a/drivers/crypto/caam/intern.h
+++ b/drivers/crypto/caam/intern.h
@@ -41,7 +41,6 @@ struct caam_drv_private_jr {
 	struct device		*dev;
 	int ridx;
 	struct caam_job_ring __iomem *rregs;	/* JobR's register space */
-	struct tasklet_struct irqtask;
 	int irq;			/* One per queue */
 
 	/* Number of scatterlist crypt transforms active on the JobR */
diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index a81f551ac222..320228875e9a 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -73,8 +73,6 @@ static int caam_jr_shutdown(struct device *dev)
 
 	ret = caam_reset_hw_jr(dev);
 
-	tasklet_kill(&jrp->irqtask);
-
 	/* Release interrupt */
 	free_irq(jrp->irq, dev);
 
@@ -130,7 +128,7 @@ static irqreturn_t caam_jr_interrupt(int irq, void *st_dev)
 
 	/*
 	 * Check the output ring for ready responses, kick
-	 * tasklet if jobs done.
+	 * the threaded irq if jobs done.
 	 */
 	irqstate = rd_reg32(&jrp->rregs->jrintstatus);
 	if (!irqstate)
@@ -152,18 +150,13 @@ static irqreturn_t caam_jr_interrupt(int irq, void *st_dev)
 	/* Have valid interrupt at this point, just ACK and trigger */
 	wr_reg32(&jrp->rregs->jrintstatus, irqstate);
 
-	preempt_disable();
-	tasklet_schedule(&jrp->irqtask);
-	preempt_enable();
-
-	return IRQ_HANDLED;
+	return IRQ_WAKE_THREAD;
 }
 
-/* Deferred service handler, run as interrupt-fired tasklet */
-static void caam_jr_dequeue(unsigned long devarg)
+static irqreturn_t caam_jr_threadirq(int irq, void *st_dev)
 {
 	int hw_idx, sw_idx, i, head, tail;
-	struct device *dev = (struct device *)devarg;
+	struct device *dev = st_dev;
 	struct caam_drv_private_jr *jrp = dev_get_drvdata(dev);
 	void (*usercall)(struct device *dev, u32 *desc, u32 status, void *arg);
 	u32 *userdesc, userstatus;
@@ -237,6 +230,8 @@ static void caam_jr_dequeue(unsigned long devarg)
 
 	/* reenable / unmask IRQs */
 	clrsetbits_32(&jrp->rregs->rconfig_lo, JRCFG_IMSK, 0);
+
+	return IRQ_HANDLED;
 }
 
 /**
@@ -394,11 +389,10 @@ static int caam_jr_init(struct device *dev)
 
 	jrp = dev_get_drvdata(dev);
 
-	tasklet_init(&jrp->irqtask, caam_jr_dequeue, (unsigned long)dev);
-
 	/* Connect job ring interrupt handler. */
-	error = request_irq(jrp->irq, caam_jr_interrupt, IRQF_SHARED,
-			    dev_name(dev), dev);
+	error = request_threaded_irq(jrp->irq, caam_jr_interrupt,
+				     caam_jr_threadirq, IRQF_SHARED,
+				     dev_name(dev), dev);
 	if (error) {
 		dev_err(dev, "can't connect JobR %d interrupt (%d)\n",
 			jrp->ridx, jrp->irq);
@@ -460,7 +454,6 @@ static int caam_jr_init(struct device *dev)
 out_free_irq:
 	free_irq(jrp->irq, dev);
 out_kill_deq:
-	tasklet_kill(&jrp->irqtask);
 	return error;
 }
 
-- 
2.1.0
