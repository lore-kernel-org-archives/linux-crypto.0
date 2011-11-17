From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 4/5] crypto: talitos - support for channel remap and 2nd IRQ
Date: Wed, 16 Nov 2011 18:20:12 -0600
Message-ID: <20111116182012.e2929f6c44cf11f8bd53437b@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <linuxppc-dev@ozlabs.org>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:56381 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614Ab1KQAVP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Nov 2011 19:21:15 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Some later SEC v3.x are equipped with a second IRQ line.
By correctly assigning IRQ affinity, this feature can be
used to increase performance on dual core parts, like the
MPC8572E and P2020E.

The existence of the 2nd IRQ is determined from the device
node's interrupt property.  If present, the driver remaps
two of four channels, which in turn makes those channels
trigger their interrupts on the 2nd line instead of the first.
To handle single- and dual-IRQ combinations efficiently,
talitos gets two new interrupt handlers and back-half workers.

[includes a fix to MCR_LO's address.]

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/talitos.c |  203 +++++++++++++++++++++++++++++++---------------
 drivers/crypto/talitos.h |   14 +++-
 2 files changed, 147 insertions(+), 70 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 7f82e91..92c0ca7 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -122,7 +122,7 @@ struct talitos_private {
 	struct device *dev;
 	struct platform_device *ofdev;
 	void __iomem *reg;
-	int irq;
+	int irq[2];
 
 	/* SEC version geometry (from device tree node) */
 	unsigned int num_channels;
@@ -146,7 +146,7 @@ struct talitos_private {
 	atomic_t last_chan ____cacheline_aligned;
 
 	/* request callback tasklet */
-	struct tasklet_struct done_task;
+	struct tasklet_struct done_task[2];
 
 	/* list of registered algorithms */
 	struct list_head alg_list;
@@ -226,13 +226,19 @@ static int reset_device(struct device *dev)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	unsigned int timeout = TALITOS_TIMEOUT;
+	u32 mcr = TALITOS_MCR_SWR;
 
-	setbits32(priv->reg + TALITOS_MCR, TALITOS_MCR_SWR);
+	setbits32(priv->reg + TALITOS_MCR, mcr);
 
 	while ((in_be32(priv->reg + TALITOS_MCR) & TALITOS_MCR_SWR)
 	       && --timeout)
 		cpu_relax();
 
+	if (priv->irq[1] != NO_IRQ) {
+		mcr = TALITOS_MCR_RCA1 | TALITOS_MCR_RCA3;
+		setbits32(priv->reg + TALITOS_MCR, mcr);
+	}
+
 	if (timeout == 0) {
 		dev_err(dev, "failed to reset device\n");
 		return -EIO;
@@ -401,21 +407,32 @@ static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
 /*
  * process completed requests for channels that have done status
  */
-static void talitos_done(unsigned long data)
-{
-	struct device *dev = (struct device *)data;
-	struct talitos_private *priv = dev_get_drvdata(dev);
-	int ch;
-
-	for (ch = 0; ch < priv->num_channels; ch++)
-		flush_channel(dev, ch, 0, 0);
-
-	/* At this point, all completed channels have been processed.
-	 * Unmask done interrupts for channels completed later on.
-	 */
-	setbits32(priv->reg + TALITOS_IMR, TALITOS_IMR_INIT);
-	setbits32(priv->reg + TALITOS_IMR_LO, TALITOS_IMR_LO_INIT);
+#define DEF_TALITOS_DONE(name, ch_done_mask)				\
+static void talitos_done_##name(unsigned long data)			\
+{									\
+	struct device *dev = (struct device *)data;			\
+	struct talitos_private *priv = dev_get_drvdata(dev);		\
+									\
+	if (ch_done_mask & 1)						\
+		flush_channel(dev, 0, 0, 0);				\
+	if (priv->num_channels == 1)					\
+		goto out;						\
+	if (ch_done_mask & (1 << 2))					\
+		flush_channel(dev, 1, 0, 0);				\
+	if (ch_done_mask & (1 << 4))					\
+		flush_channel(dev, 2, 0, 0);				\
+	if (ch_done_mask & (1 << 6))					\
+		flush_channel(dev, 3, 0, 0);				\
+									\
+out:									\
+	/* At this point, all completed channels have been processed */	\
+	/* Unmask done interrupts for channels completed later on. */	\
+	setbits32(priv->reg + TALITOS_IMR, ch_done_mask);		\
+	setbits32(priv->reg + TALITOS_IMR_LO, TALITOS_IMR_LO_INIT);	\
 }
+DEF_TALITOS_DONE(4ch, TALITOS_ISR_4CHDONE)
+DEF_TALITOS_DONE(ch0_2, TALITOS_ISR_CH_0_2_DONE)
+DEF_TALITOS_DONE(ch1_3, TALITOS_ISR_CH_1_3_DONE)
 
 /*
  * locate current (offending) descriptor
@@ -584,7 +601,7 @@ static void talitos_error(unsigned long data, u32 isr, u32 isr_lo)
 			}
 		}
 	}
-	if (reset_dev || isr & ~TALITOS_ISR_CHERR || isr_lo) {
+	if (reset_dev || isr & ~TALITOS_ISR_4CHERR || isr_lo) {
 		dev_err(dev, "done overflow, internal time out, or rngu error: "
 		        "ISR 0x%08x_%08x\n", isr, isr_lo);
 
@@ -597,30 +614,35 @@ static void talitos_error(unsigned long data, u32 isr, u32 isr_lo)
 	}
 }
 
-static irqreturn_t talitos_interrupt(int irq, void *data)
-{
-	struct device *dev = data;
-	struct talitos_private *priv = dev_get_drvdata(dev);
-	u32 isr, isr_lo;
-
-	isr = in_be32(priv->reg + TALITOS_ISR);
-	isr_lo = in_be32(priv->reg + TALITOS_ISR_LO);
-	/* Acknowledge interrupt */
-	out_be32(priv->reg + TALITOS_ICR, isr);
-	out_be32(priv->reg + TALITOS_ICR_LO, isr_lo);
-
-	if (unlikely((isr & ~TALITOS_ISR_CHDONE) || isr_lo))
-		talitos_error((unsigned long)data, isr, isr_lo);
-	else
-		if (likely(isr & TALITOS_ISR_CHDONE)) {
-			/* mask further done interrupts. */
-			clrbits32(priv->reg + TALITOS_IMR, TALITOS_IMR_DONE);
-			/* done_task will unmask done interrupts at exit */
-			tasklet_schedule(&priv->done_task);
-		}
-
-	return (isr || isr_lo) ? IRQ_HANDLED : IRQ_NONE;
+#define DEF_TALITOS_INTERRUPT(name, ch_done_mask, ch_err_mask, tlet)	       \
+static irqreturn_t talitos_interrupt_##name(int irq, void *data)	       \
+{									       \
+	struct device *dev = data;					       \
+	struct talitos_private *priv = dev_get_drvdata(dev);		       \
+	u32 isr, isr_lo;						       \
+									       \
+	isr = in_be32(priv->reg + TALITOS_ISR);				       \
+	isr_lo = in_be32(priv->reg + TALITOS_ISR_LO);			       \
+	/* Acknowledge interrupt */					       \
+	out_be32(priv->reg + TALITOS_ICR, isr & (ch_done_mask | ch_err_mask)); \
+	out_be32(priv->reg + TALITOS_ICR_LO, isr_lo);			       \
+									       \
+	if (unlikely((isr & ~TALITOS_ISR_4CHDONE) & ch_err_mask || isr_lo))    \
+		talitos_error((unsigned long)data, isr, isr_lo);	       \
+	else								       \
+		if (likely(isr & ch_done_mask)) {			       \
+			/* mask further done interrupts. */		       \
+			clrbits32(priv->reg + TALITOS_IMR, ch_done_mask);      \
+			/* done_task will unmask done interrupts at exit */    \
+			tasklet_schedule(&priv->done_task[tlet]);	       \
+		}							       \
+									       \
+	return (isr & (ch_done_mask | ch_err_mask) || isr_lo) ? IRQ_HANDLED :  \
+								IRQ_NONE;      \
 }
+DEF_TALITOS_INTERRUPT(4ch, TALITOS_ISR_4CHDONE, TALITOS_ISR_4CHERR, 0)
+DEF_TALITOS_INTERRUPT(ch0_2, TALITOS_ISR_CH_0_2_DONE, TALITOS_ISR_CH_0_2_ERR, 0)
+DEF_TALITOS_INTERRUPT(ch1_3, TALITOS_ISR_CH_1_3_DONE, TALITOS_ISR_CH_1_3_ERR, 1)
 
 /*
  * hwrng
@@ -2558,12 +2580,15 @@ static int talitos_remove(struct platform_device *ofdev)
 
 	kfree(priv->chan);
 
-	if (priv->irq != NO_IRQ) {
-		free_irq(priv->irq, dev);
-		irq_dispose_mapping(priv->irq);
-	}
+	for (i = 0; i < 2; i++)
+		if (priv->irq[i] != NO_IRQ) {
+			free_irq(priv->irq[i], dev);
+			irq_dispose_mapping(priv->irq[i]);
+		}
 
-	tasklet_kill(&priv->done_task);
+	tasklet_kill(&priv->done_task[0]);
+	if (priv->irq[1] != NO_IRQ)
+		tasklet_kill(&priv->done_task[1]);
 
 	iounmap(priv->reg);
 
@@ -2628,6 +2653,54 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 	return t_alg;
 }
 
+static int talitos_probe_irq(struct platform_device *ofdev)
+{
+	struct device *dev = &ofdev->dev;
+	struct device_node *np = ofdev->dev.of_node;
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	int err;
+
+	priv->irq[0] = irq_of_parse_and_map(np, 0);
+	if (priv->irq[0] == NO_IRQ) {
+		dev_err(dev, "failed to map irq\n");
+		return -EINVAL;
+	}
+
+	priv->irq[1] = irq_of_parse_and_map(np, 1);
+
+	/* get the primary irq line */
+	if (priv->irq[1] == NO_IRQ) {
+		err = request_irq(priv->irq[0], talitos_interrupt_4ch, 0,
+				  dev_driver_string(dev), dev);
+		goto primary_out;
+	}
+
+	err = request_irq(priv->irq[0], talitos_interrupt_ch0_2, 0,
+			  dev_driver_string(dev), dev);
+	if (err)
+		goto primary_out;
+
+	/* get the secondary irq line */
+	err = request_irq(priv->irq[1], talitos_interrupt_ch1_3, 0,
+			  dev_driver_string(dev), dev);
+	if (err) {
+		dev_err(dev, "failed to request secondary irq\n");
+		irq_dispose_mapping(priv->irq[1]);
+		priv->irq[1] = NO_IRQ;
+	}
+
+	return err;
+
+primary_out:
+	if (err) {
+		dev_err(dev, "failed to request primary irq\n");
+		irq_dispose_mapping(priv->irq[0]);
+		priv->irq[0] = NO_IRQ;
+	}
+
+	return err;
+}
+
 static int talitos_probe(struct platform_device *ofdev)
 {
 	struct device *dev = &ofdev->dev;
@@ -2644,28 +2717,22 @@ static int talitos_probe(struct platform_device *ofdev)
 
 	priv->ofdev = ofdev;
 
-	tasklet_init(&priv->done_task, talitos_done, (unsigned long)dev);
-
-	INIT_LIST_HEAD(&priv->alg_list);
-
-	priv->irq = irq_of_parse_and_map(np, 0);
-
-	if (priv->irq == NO_IRQ) {
-		dev_err(dev, "failed to map irq\n");
-		err = -EINVAL;
+	err = talitos_probe_irq(ofdev);
+	if (err)
 		goto err_out;
-	}
 
-	/* get the irq line */
-	err = request_irq(priv->irq, talitos_interrupt, 0,
-			  dev_driver_string(dev), dev);
-	if (err) {
-		dev_err(dev, "failed to request irq %d\n", priv->irq);
-		irq_dispose_mapping(priv->irq);
-		priv->irq = NO_IRQ;
-		goto err_out;
+	if (priv->irq[1] == NO_IRQ) {
+		tasklet_init(&priv->done_task[0], talitos_done_4ch,
+			     (unsigned long)dev);
+	} else {
+		tasklet_init(&priv->done_task[0], talitos_done_ch0_2,
+			     (unsigned long)dev);
+		tasklet_init(&priv->done_task[1], talitos_done_ch1_3,
+			     (unsigned long)dev);
 	}
 
+	INIT_LIST_HEAD(&priv->alg_list);
+
 	priv->reg = of_iomap(np, 0);
 	if (!priv->reg) {
 		dev_err(dev, "failed to of_iomap\n");
@@ -2713,9 +2780,11 @@ static int talitos_probe(struct platform_device *ofdev)
 		goto err_out;
 	}
 
-	for (i = 0; i < priv->num_channels; i++)
-		priv->chan[i].reg = priv->reg + TALITOS_CH_BASE_OFFSET +
-				    TALITOS_CH_STRIDE * (i + 1);
+	for (i = 0; i < priv->num_channels; i++) {
+		priv->chan[i].reg = priv->reg + TALITOS_CH_STRIDE * (i + 1);
+		if ((priv->irq[1] == NO_IRQ) || !(i & 1))
+			priv->chan[i].reg += TALITOS_CH_BASE_OFFSET;
+	}
 
 	for (i = 0; i < priv->num_channels; i++) {
 		spin_lock_init(&priv->chan[i].head_lock);
diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index 3ed319d..3c17395 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -34,16 +34,24 @@
 
 /* global register offset addresses */
 #define TALITOS_MCR			0x1030  /* master control register */
-#define TALITOS_MCR_LO			0x1038
+#define   TALITOS_MCR_RCA0		(1 << 15) /* remap channel 0 */
+#define   TALITOS_MCR_RCA1		(1 << 14) /* remap channel 1 */
+#define   TALITOS_MCR_RCA2		(1 << 13) /* remap channel 2 */
+#define   TALITOS_MCR_RCA3		(1 << 12) /* remap channel 3 */
 #define   TALITOS_MCR_SWR		0x1     /* s/w reset */
+#define TALITOS_MCR_LO			0x1034
 #define TALITOS_IMR			0x1008  /* interrupt mask register */
 #define   TALITOS_IMR_INIT		0x100ff /* enable channel IRQs */
 #define   TALITOS_IMR_DONE		0x00055 /* done IRQs */
 #define TALITOS_IMR_LO			0x100C
 #define   TALITOS_IMR_LO_INIT		0x20000 /* allow RNGU error IRQs */
 #define TALITOS_ISR			0x1010  /* interrupt status register */
-#define   TALITOS_ISR_CHERR		0xaa    /* channel errors mask */
-#define   TALITOS_ISR_CHDONE		0x55    /* channel done mask */
+#define   TALITOS_ISR_4CHERR		0xaa    /* 4 channel errors mask */
+#define   TALITOS_ISR_4CHDONE		0x55    /* 4 channel done mask */
+#define   TALITOS_ISR_CH_0_2_ERR	0x22    /* channels 0, 2 errors mask */
+#define   TALITOS_ISR_CH_0_2_DONE	0x11    /* channels 0, 2 done mask */
+#define   TALITOS_ISR_CH_1_3_ERR	0x88    /* channels 1, 3 errors mask */
+#define   TALITOS_ISR_CH_1_3_DONE	0x44    /* channels 1, 3 done mask */
 #define TALITOS_ISR_LO			0x1014
 #define TALITOS_ICR			0x1018  /* interrupt clear register */
 #define TALITOS_ICR_LO			0x101C
-- 
1.7.7
