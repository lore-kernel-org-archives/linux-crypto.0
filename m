From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH] crypto: talitos - properly lock access to global talitos registers
Date: Fri, 30 Mar 2012 17:49:53 +0300
Message-ID: <1333118993-17522-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Kim Phillips <kim.phillips@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:40154
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751153Ab2C3Oum (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 30 Mar 2012 10:50:42 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Access to global talitos registers must be protected for the case when
affinities are configured such that primary and secondary talitos irqs
run on different cpus.

Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/talitos.c |   20 +++++++++++++++++---
 1 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index dc641c7..921039e 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -124,6 +124,9 @@ struct talitos_private {
 	void __iomem *reg;
 	int irq[2];
 
+	/* SEC global registers lock  */
+	spinlock_t reg_lock ____cacheline_aligned;
+
 	/* SEC version geometry (from device tree node) */
 	unsigned int num_channels;
 	unsigned int chfifo_len;
@@ -412,6 +415,7 @@ static void talitos_done_##name(unsigned long data)			\
 {									\
 	struct device *dev = (struct device *)data;			\
 	struct talitos_private *priv = dev_get_drvdata(dev);		\
+	unsigned long flags;						\
 									\
 	if (ch_done_mask & 1)						\
 		flush_channel(dev, 0, 0, 0);				\
@@ -427,8 +431,10 @@ static void talitos_done_##name(unsigned long data)			\
 out:									\
 	/* At this point, all completed channels have been processed */	\
 	/* Unmask done interrupts for channels completed later on. */	\
+	spin_lock_irqsave(&priv->reg_lock, flags);			\
 	setbits32(priv->reg + TALITOS_IMR, ch_done_mask);		\
 	setbits32(priv->reg + TALITOS_IMR_LO, TALITOS_IMR_LO_INIT);	\
+	spin_unlock_irqrestore(&priv->reg_lock, flags);			\
 }
 DEF_TALITOS_DONE(4ch, TALITOS_ISR_4CHDONE)
 DEF_TALITOS_DONE(ch0_2, TALITOS_ISR_CH_0_2_DONE)
@@ -619,22 +625,28 @@ static irqreturn_t talitos_interrupt_##name(int irq, void *data)	       \
 	struct device *dev = data;					       \
 	struct talitos_private *priv = dev_get_drvdata(dev);		       \
 	u32 isr, isr_lo;						       \
+	unsigned long flags;						       \
 									       \
+	spin_lock_irqsave(&priv->reg_lock, flags);			       \
 	isr = in_be32(priv->reg + TALITOS_ISR);				       \
 	isr_lo = in_be32(priv->reg + TALITOS_ISR_LO);			       \
 	/* Acknowledge interrupt */					       \
 	out_be32(priv->reg + TALITOS_ICR, isr & (ch_done_mask | ch_err_mask)); \
 	out_be32(priv->reg + TALITOS_ICR_LO, isr_lo);			       \
 									       \
-	if (unlikely((isr & ~TALITOS_ISR_4CHDONE) & ch_err_mask || isr_lo))    \
-		talitos_error(dev, isr, isr_lo);			       \
-	else								       \
+	if (unlikely(isr & ch_err_mask || isr_lo)) {			       \
+		spin_unlock_irqrestore(&priv->reg_lock, flags);		       \
+		talitos_error(dev, isr & ch_err_mask, isr_lo);		       \
+	}								       \
+	else {								       \
 		if (likely(isr & ch_done_mask)) {			       \
 			/* mask further done interrupts. */		       \
 			clrbits32(priv->reg + TALITOS_IMR, ch_done_mask);      \
 			/* done_task will unmask done interrupts at exit */    \
 			tasklet_schedule(&priv->done_task[tlet]);	       \
 		}							       \
+		spin_unlock_irqrestore(&priv->reg_lock, flags);		       \
+	}								       \
 									       \
 	return (isr & (ch_done_mask | ch_err_mask) || isr_lo) ? IRQ_HANDLED :  \
 								IRQ_NONE;      \
@@ -2719,6 +2731,8 @@ static int talitos_probe(struct platform_device *ofdev)
 
 	priv->ofdev = ofdev;
 
+	spin_lock_init(&priv->reg_lock);
+
 	err = talitos_probe_irq(ofdev);
 	if (err)
 		goto err_out;
-- 
1.7.3.4
