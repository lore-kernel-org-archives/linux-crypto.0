From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH v3 13/17] crypto: talitos - adapt interrupts and reset
 functions to SEC1
Date: Fri, 10 Apr 2015 11:19:40 +0200
Message-ID: <20150417142407.2DAF61A242C@localhost.localdomain>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	David S Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:41737 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934421AbbDQOYJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Apr 2015 10:24:09 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adapts the interrupts handling and reset function for
SEC1. On SEC1, registers are almost similar to SEC2+, but bits
are sometimes located at different places. So we need to define
TALITOS1 and TALITOS2 versions of some fields, and manage according
to whether it is SEC1 or SEC2.

On SEC1, only one interrupt vector is dedicated to the SEC, so only
interrupt_4ch is needed.

On SEC1, interrupts are enabled by clearing related bits in IMR,
while on SEC2, interrupts are enabled by seting the bits in IMR.

SEC1 also performs parity verification in the DES Unit. We have
to disable this feature because the test vectors provided in
the kernel have parity errors.

In reset functions, only SEC2 supports continuation after error.
For SEC1, we have to reset in all cases.

For errors handling, SEC2+ names have been kept, but displayed
text have been amended to reflect exact meaning on SEC1.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/crypto/talitos.c | 227 +++++++++++++++++++++++++++++++++++------------
 drivers/crypto/talitos.h |  39 +++++---
 2 files changed, 199 insertions(+), 67 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 6d77699..1265405 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -124,12 +124,23 @@ static int reset_channel(struct device *dev, int ch)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	unsigned int timeout = TALITOS_TIMEOUT;
+	bool is_sec1 = has_ftr_sec1(priv);
 
-	setbits32(priv->chan[ch].reg + TALITOS_CCCR, TALITOS_CCCR_RESET);
+	if (is_sec1) {
+		setbits32(priv->chan[ch].reg + TALITOS_CCCR_LO,
+			  TALITOS1_CCCR_LO_RESET);
 
-	while ((in_be32(priv->chan[ch].reg + TALITOS_CCCR) & TALITOS_CCCR_RESET)
-	       && --timeout)
-		cpu_relax();
+		while ((in_be32(priv->chan[ch].reg + TALITOS_CCCR_LO) &
+			TALITOS1_CCCR_LO_RESET) && --timeout)
+			cpu_relax();
+	} else {
+		setbits32(priv->chan[ch].reg + TALITOS_CCCR,
+			  TALITOS2_CCCR_RESET);
+
+		while ((in_be32(priv->chan[ch].reg + TALITOS_CCCR) &
+			TALITOS2_CCCR_RESET) && --timeout)
+			cpu_relax();
+	}
 
 	if (timeout == 0) {
 		dev_err(dev, "failed to reset channel %d\n", ch);
@@ -152,11 +163,12 @@ static int reset_device(struct device *dev)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	unsigned int timeout = TALITOS_TIMEOUT;
-	u32 mcr = TALITOS_MCR_SWR;
+	bool is_sec1 = has_ftr_sec1(priv);
+	u32 mcr = is_sec1 ? TALITOS1_MCR_SWR : TALITOS2_MCR_SWR;
 
 	setbits32(priv->reg + TALITOS_MCR, mcr);
 
-	while ((in_be32(priv->reg + TALITOS_MCR) & TALITOS_MCR_SWR)
+	while ((in_be32(priv->reg + TALITOS_MCR) & mcr)
 	       && --timeout)
 		cpu_relax();
 
@@ -180,6 +192,7 @@ static int init_device(struct device *dev)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	int ch, err;
+	bool is_sec1 = has_ftr_sec1(priv);
 
 	/*
 	 * Master reset
@@ -203,8 +216,15 @@ static int init_device(struct device *dev)
 	}
 
 	/* enable channel done and error interrupts */
-	setbits32(priv->reg + TALITOS_IMR, TALITOS_IMR_INIT);
-	setbits32(priv->reg + TALITOS_IMR_LO, TALITOS_IMR_LO_INIT);
+	if (is_sec1) {
+		clrbits32(priv->reg + TALITOS_IMR, TALITOS1_IMR_INIT);
+		clrbits32(priv->reg + TALITOS_IMR_LO, TALITOS1_IMR_LO_INIT);
+		/* disable parity error check in DEU (erroneous? test vect.) */
+		setbits32(priv->reg_deu + TALITOS_EUICR, TALITOS1_DEUICR_KPE);
+	} else {
+		setbits32(priv->reg + TALITOS_IMR, TALITOS2_IMR_INIT);
+		setbits32(priv->reg + TALITOS_IMR_LO, TALITOS2_IMR_LO_INIT);
+	}
 
 	/* disable integrity check error interrupts (use writeback instead) */
 	if (priv->features & TALITOS_FTR_HW_AUTH_CHECK)
@@ -349,8 +369,37 @@ static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
 /*
  * process completed requests for channels that have done status
  */
-#define DEF_TALITOS_DONE(name, ch_done_mask)				\
-static void talitos_done_##name(unsigned long data)			\
+#define DEF_TALITOS1_DONE(name, ch_done_mask)				\
+static void talitos1_done_##name(unsigned long data)			\
+{									\
+	struct device *dev = (struct device *)data;			\
+	struct talitos_private *priv = dev_get_drvdata(dev);		\
+	unsigned long flags;						\
+									\
+	if (ch_done_mask & 0x10000000)					\
+		flush_channel(dev, 0, 0, 0);			\
+	if (priv->num_channels == 1)					\
+		goto out;						\
+	if (ch_done_mask & 0x40000000)					\
+		flush_channel(dev, 1, 0, 0);			\
+	if (ch_done_mask & 0x00010000)					\
+		flush_channel(dev, 2, 0, 0);			\
+	if (ch_done_mask & 0x00040000)					\
+		flush_channel(dev, 3, 0, 0);			\
+									\
+out:									\
+	/* At this point, all completed channels have been processed */	\
+	/* Unmask done interrupts for channels completed later on. */	\
+	spin_lock_irqsave(&priv->reg_lock, flags);			\
+	clrbits32(priv->reg + TALITOS_IMR, ch_done_mask);		\
+	clrbits32(priv->reg + TALITOS_IMR_LO, TALITOS1_IMR_LO_INIT);	\
+	spin_unlock_irqrestore(&priv->reg_lock, flags);			\
+}
+
+DEF_TALITOS1_DONE(4ch, TALITOS1_ISR_4CHDONE)
+
+#define DEF_TALITOS2_DONE(name, ch_done_mask)				\
+static void talitos2_done_##name(unsigned long data)			\
 {									\
 	struct device *dev = (struct device *)data;			\
 	struct talitos_private *priv = dev_get_drvdata(dev);		\
@@ -372,12 +421,13 @@ out:									\
 	/* Unmask done interrupts for channels completed later on. */	\
 	spin_lock_irqsave(&priv->reg_lock, flags);			\
 	setbits32(priv->reg + TALITOS_IMR, ch_done_mask);		\
-	setbits32(priv->reg + TALITOS_IMR_LO, TALITOS_IMR_LO_INIT);	\
+	setbits32(priv->reg + TALITOS_IMR_LO, TALITOS2_IMR_LO_INIT);	\
 	spin_unlock_irqrestore(&priv->reg_lock, flags);			\
 }
-DEF_TALITOS_DONE(4ch, TALITOS_ISR_4CHDONE)
-DEF_TALITOS_DONE(ch0_2, TALITOS_ISR_CH_0_2_DONE)
-DEF_TALITOS_DONE(ch1_3, TALITOS_ISR_CH_1_3_DONE)
+
+DEF_TALITOS2_DONE(4ch, TALITOS2_ISR_4CHDONE)
+DEF_TALITOS2_DONE(ch0_2, TALITOS2_ISR_CH_0_2_DONE)
+DEF_TALITOS2_DONE(ch1_3, TALITOS2_ISR_CH_1_3_DONE)
 
 /*
  * locate current (offending) descriptor
@@ -492,13 +542,21 @@ static void talitos_error(struct device *dev, u32 isr, u32 isr_lo)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	unsigned int timeout = TALITOS_TIMEOUT;
-	int ch, error, reset_dev = 0, reset_ch = 0;
+	int ch, error, reset_dev = 0;
 	u32 v, v_lo;
+	bool is_sec1 = has_ftr_sec1(priv);
+	int reset_ch = is_sec1 ? 1 : 0; /* only SEC2 supports continuation */
 
 	for (ch = 0; ch < priv->num_channels; ch++) {
 		/* skip channels without errors */
-		if (!(isr & (1 << (ch * 2 + 1))))
-			continue;
+		if (is_sec1) {
+			/* bits 29, 31, 17, 19 */
+			if (!(isr & (1 << (29 + (ch & 1) * 2 - (ch & 2) * 6))))
+				continue;
+		} else {
+			if (!(isr & (1 << (ch * 2 + 1))))
+				continue;
+		}
 
 		error = -EINVAL;
 
@@ -518,23 +576,28 @@ static void talitos_error(struct device *dev, u32 isr, u32 isr_lo)
 		if (v_lo & TALITOS_CCPSR_LO_MDTE)
 			dev_err(dev, "master data transfer error\n");
 		if (v_lo & TALITOS_CCPSR_LO_SGDLZ)
-			dev_err(dev, "s/g data length zero error\n");
+			dev_err(dev, is_sec1 ? "pointeur not complete error\n"
+					     : "s/g data length zero error\n");
 		if (v_lo & TALITOS_CCPSR_LO_FPZ)
-			dev_err(dev, "fetch pointer zero error\n");
+			dev_err(dev, is_sec1 ? "parity error\n"
+					     : "fetch pointer zero error\n");
 		if (v_lo & TALITOS_CCPSR_LO_IDH)
 			dev_err(dev, "illegal descriptor header error\n");
 		if (v_lo & TALITOS_CCPSR_LO_IEU)
-			dev_err(dev, "invalid execution unit error\n");
+			dev_err(dev, is_sec1 ? "static assignment error\n"
+					     : "invalid exec unit error\n");
 		if (v_lo & TALITOS_CCPSR_LO_EU)
 			report_eu_error(dev, ch, current_desc_hdr(dev, ch));
-		if (v_lo & TALITOS_CCPSR_LO_GB)
-			dev_err(dev, "gather boundary error\n");
-		if (v_lo & TALITOS_CCPSR_LO_GRL)
-			dev_err(dev, "gather return/length error\n");
-		if (v_lo & TALITOS_CCPSR_LO_SB)
-			dev_err(dev, "scatter boundary error\n");
-		if (v_lo & TALITOS_CCPSR_LO_SRL)
-			dev_err(dev, "scatter return/length error\n");
+		if (!is_sec1) {
+			if (v_lo & TALITOS_CCPSR_LO_GB)
+				dev_err(dev, "gather boundary error\n");
+			if (v_lo & TALITOS_CCPSR_LO_GRL)
+				dev_err(dev, "gather return/length error\n");
+			if (v_lo & TALITOS_CCPSR_LO_SB)
+				dev_err(dev, "scatter boundary error\n");
+			if (v_lo & TALITOS_CCPSR_LO_SRL)
+				dev_err(dev, "scatter return/length error\n");
+		}
 
 		flush_channel(dev, ch, error, reset_ch);
 
@@ -542,10 +605,10 @@ static void talitos_error(struct device *dev, u32 isr, u32 isr_lo)
 			reset_channel(dev, ch);
 		} else {
 			setbits32(priv->chan[ch].reg + TALITOS_CCCR,
-				  TALITOS_CCCR_CONT);
+				  TALITOS2_CCCR_CONT);
 			setbits32(priv->chan[ch].reg + TALITOS_CCCR_LO, 0);
 			while ((in_be32(priv->chan[ch].reg + TALITOS_CCCR) &
-			       TALITOS_CCCR_CONT) && --timeout)
+			       TALITOS2_CCCR_CONT) && --timeout)
 				cpu_relax();
 			if (timeout == 0) {
 				dev_err(dev, "failed to restart channel %d\n",
@@ -554,9 +617,14 @@ static void talitos_error(struct device *dev, u32 isr, u32 isr_lo)
 			}
 		}
 	}
-	if (reset_dev || isr & ~TALITOS_ISR_4CHERR || isr_lo) {
-		dev_err(dev, "done overflow, internal time out, or rngu error: "
-		        "ISR 0x%08x_%08x\n", isr, isr_lo);
+	if (reset_dev || (is_sec1 && isr & ~TALITOS1_ISR_4CHERR) ||
+	    (!is_sec1 && isr & ~TALITOS2_ISR_4CHERR) || isr_lo) {
+		if (is_sec1 && (isr_lo & TALITOS1_ISR_TEA_ERR))
+			dev_err(dev, "TEA error: ISR 0x%08x_%08x\n",
+				isr, isr_lo);
+		else
+			dev_err(dev, "done overflow, internal time out, or "
+				"rngu error: ISR 0x%08x_%08x\n", isr, isr_lo);
 
 		/* purge request queues */
 		for (ch = 0; ch < priv->num_channels; ch++)
@@ -567,8 +635,43 @@ static void talitos_error(struct device *dev, u32 isr, u32 isr_lo)
 	}
 }
 
-#define DEF_TALITOS_INTERRUPT(name, ch_done_mask, ch_err_mask, tlet)	       \
-static irqreturn_t talitos_interrupt_##name(int irq, void *data)	       \
+#define DEF_TALITOS1_INTERRUPT(name, ch_done_mask, ch_err_mask, tlet)	       \
+static irqreturn_t talitos1_interrupt_##name(int irq, void *data)	       \
+{									       \
+	struct device *dev = data;					       \
+	struct talitos_private *priv = dev_get_drvdata(dev);		       \
+	u32 isr, isr_lo;						       \
+	unsigned long flags;						       \
+									       \
+	spin_lock_irqsave(&priv->reg_lock, flags);			       \
+	isr = in_be32(priv->reg + TALITOS_ISR);				       \
+	isr_lo = in_be32(priv->reg + TALITOS_ISR_LO);			       \
+	/* Acknowledge interrupt */					       \
+	out_be32(priv->reg + TALITOS_ICR, isr & (ch_done_mask | ch_err_mask)); \
+	out_be32(priv->reg + TALITOS_ICR_LO, isr_lo);			       \
+									       \
+	if (unlikely(isr & ch_err_mask || isr_lo & TALITOS1_IMR_LO_INIT)) {    \
+		spin_unlock_irqrestore(&priv->reg_lock, flags);		       \
+		talitos_error(dev, isr & ch_err_mask, isr_lo);		       \
+	}								       \
+	else {								       \
+		if (likely(isr & ch_done_mask)) {			       \
+			/* mask further done interrupts. */		       \
+			setbits32(priv->reg + TALITOS_IMR, ch_done_mask);      \
+			/* done_task will unmask done interrupts at exit */    \
+			tasklet_schedule(&priv->done_task[tlet]);	       \
+		}							       \
+		spin_unlock_irqrestore(&priv->reg_lock, flags);		       \
+	}								       \
+									       \
+	return (isr & (ch_done_mask | ch_err_mask) || isr_lo) ? IRQ_HANDLED :  \
+								IRQ_NONE;      \
+}
+
+DEF_TALITOS1_INTERRUPT(4ch, TALITOS1_ISR_4CHDONE, TALITOS1_ISR_4CHERR, 0)
+
+#define DEF_TALITOS2_INTERRUPT(name, ch_done_mask, ch_err_mask, tlet)	       \
+static irqreturn_t talitos2_interrupt_##name(int irq, void *data)	       \
 {									       \
 	struct device *dev = data;					       \
 	struct talitos_private *priv = dev_get_drvdata(dev);		       \
@@ -599,9 +702,12 @@ static irqreturn_t talitos_interrupt_##name(int irq, void *data)	       \
 	return (isr & (ch_done_mask | ch_err_mask) || isr_lo) ? IRQ_HANDLED :  \
 								IRQ_NONE;      \
 }
-DEF_TALITOS_INTERRUPT(4ch, TALITOS_ISR_4CHDONE, TALITOS_ISR_4CHERR, 0)
-DEF_TALITOS_INTERRUPT(ch0_2, TALITOS_ISR_CH_0_2_DONE, TALITOS_ISR_CH_0_2_ERR, 0)
-DEF_TALITOS_INTERRUPT(ch1_3, TALITOS_ISR_CH_1_3_DONE, TALITOS_ISR_CH_1_3_ERR, 1)
+
+DEF_TALITOS2_INTERRUPT(4ch, TALITOS2_ISR_4CHDONE, TALITOS2_ISR_4CHERR, 0)
+DEF_TALITOS2_INTERRUPT(ch0_2, TALITOS2_ISR_CH_0_2_DONE, TALITOS2_ISR_CH_0_2_ERR,
+		       0)
+DEF_TALITOS2_INTERRUPT(ch1_3, TALITOS2_ISR_CH_1_3_DONE, TALITOS2_ISR_CH_1_3_ERR,
+		       1)
 
 /*
  * hwrng
@@ -2639,29 +2745,35 @@ static int talitos_probe_irq(struct platform_device *ofdev)
 	struct device_node *np = ofdev->dev.of_node;
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	int err;
+	bool is_sec1 = has_ftr_sec1(priv);
 
 	priv->irq[0] = irq_of_parse_and_map(np, 0);
 	if (!priv->irq[0]) {
 		dev_err(dev, "failed to map irq\n");
 		return -EINVAL;
 	}
+	if (is_sec1) {
+		err = request_irq(priv->irq[0], talitos1_interrupt_4ch, 0,
+				  dev_driver_string(dev), dev);
+		goto primary_out;
+	}
 
 	priv->irq[1] = irq_of_parse_and_map(np, 1);
 
 	/* get the primary irq line */
 	if (!priv->irq[1]) {
-		err = request_irq(priv->irq[0], talitos_interrupt_4ch, 0,
+		err = request_irq(priv->irq[0], talitos2_interrupt_4ch, 0,
 				  dev_driver_string(dev), dev);
 		goto primary_out;
 	}
 
-	err = request_irq(priv->irq[0], talitos_interrupt_ch0_2, 0,
+	err = request_irq(priv->irq[0], talitos2_interrupt_ch0_2, 0,
 			  dev_driver_string(dev), dev);
 	if (err)
 		goto primary_out;
 
 	/* get the secondary irq line */
-	err = request_irq(priv->irq[1], talitos_interrupt_ch1_3, 0,
+	err = request_irq(priv->irq[1], talitos2_interrupt_ch1_3, 0,
 			  dev_driver_string(dev), dev);
 	if (err) {
 		dev_err(dev, "failed to request secondary irq\n");
@@ -2702,20 +2814,6 @@ static int talitos_probe(struct platform_device *ofdev)
 
 	spin_lock_init(&priv->reg_lock);
 
-	err = talitos_probe_irq(ofdev);
-	if (err)
-		goto err_out;
-
-	if (!priv->irq[1]) {
-		tasklet_init(&priv->done_task[0], talitos_done_4ch,
-			     (unsigned long)dev);
-	} else {
-		tasklet_init(&priv->done_task[0], talitos_done_ch0_2,
-			     (unsigned long)dev);
-		tasklet_init(&priv->done_task[1], talitos_done_ch1_3,
-			     (unsigned long)dev);
-	}
-
 	priv->reg = of_iomap(np, 0);
 	if (!priv->reg) {
 		dev_err(dev, "failed to of_iomap\n");
@@ -2783,6 +2881,25 @@ static int talitos_probe(struct platform_device *ofdev)
 		stride = TALITOS2_CH_STRIDE;
 	}
 
+	err = talitos_probe_irq(ofdev);
+	if (err)
+		goto err_out;
+
+	if (of_device_is_compatible(np, "fsl,sec1.0")) {
+		tasklet_init(&priv->done_task[0], talitos1_done_4ch,
+			     (unsigned long)dev);
+	} else {
+		if (!priv->irq[1]) {
+			tasklet_init(&priv->done_task[0], talitos2_done_4ch,
+				     (unsigned long)dev);
+		} else {
+			tasklet_init(&priv->done_task[0], talitos2_done_ch0_2,
+				     (unsigned long)dev);
+			tasklet_init(&priv->done_task[1], talitos2_done_ch1_3,
+				     (unsigned long)dev);
+		}
+	}
+
 	priv->chan = kzalloc(sizeof(struct talitos_channel) *
 			     priv->num_channels, GFP_KERNEL);
 	if (!priv->chan) {
diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index 4faa3b6..9507c4f 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -188,26 +188,38 @@ static inline bool has_ftr_sec1(struct talitos_private *priv)
  * TALITOS_xxx_LO addresses point to the low data bits (32-63) of the register
  */
 
+#define ISR1_FORMAT(x)			(((x) << 28) | ((x) << 16))
+#define ISR2_FORMAT(x)			(((x) << 4) | (x))
+
 /* global register offset addresses */
 #define TALITOS_MCR			0x1030  /* master control register */
 #define   TALITOS_MCR_RCA0		(1 << 15) /* remap channel 0 */
 #define   TALITOS_MCR_RCA1		(1 << 14) /* remap channel 1 */
 #define   TALITOS_MCR_RCA2		(1 << 13) /* remap channel 2 */
 #define   TALITOS_MCR_RCA3		(1 << 12) /* remap channel 3 */
-#define   TALITOS_MCR_SWR		0x1     /* s/w reset */
+#define   TALITOS1_MCR_SWR		0x1000000     /* s/w reset */
+#define   TALITOS2_MCR_SWR		0x1     /* s/w reset */
 #define TALITOS_MCR_LO			0x1034
 #define TALITOS_IMR			0x1008  /* interrupt mask register */
-#define   TALITOS_IMR_INIT		0x100ff /* enable channel IRQs */
-#define   TALITOS_IMR_DONE		0x00055 /* done IRQs */
+/* enable channel IRQs */
+#define   TALITOS1_IMR_INIT		ISR1_FORMAT(0xf)
+#define   TALITOS1_IMR_DONE		ISR1_FORMAT(0x5) /* done IRQs */
+/* enable channel IRQs */
+#define   TALITOS2_IMR_INIT		(ISR2_FORMAT(0xf) | 0x10000)
+#define   TALITOS2_IMR_DONE		ISR1_FORMAT(0x5) /* done IRQs */
 #define TALITOS_IMR_LO			0x100C
-#define   TALITOS_IMR_LO_INIT		0x20000 /* allow RNGU error IRQs */
+#define   TALITOS1_IMR_LO_INIT		0x2000000 /* allow RNGU error IRQs */
+#define   TALITOS2_IMR_LO_INIT		0x20000 /* allow RNGU error IRQs */
 #define TALITOS_ISR			0x1010  /* interrupt status register */
-#define   TALITOS_ISR_4CHERR		0xaa    /* 4 channel errors mask */
-#define   TALITOS_ISR_4CHDONE		0x55    /* 4 channel done mask */
-#define   TALITOS_ISR_CH_0_2_ERR	0x22    /* channels 0, 2 errors mask */
-#define   TALITOS_ISR_CH_0_2_DONE	0x11    /* channels 0, 2 done mask */
-#define   TALITOS_ISR_CH_1_3_ERR	0x88    /* channels 1, 3 errors mask */
-#define   TALITOS_ISR_CH_1_3_DONE	0x44    /* channels 1, 3 done mask */
+#define   TALITOS1_ISR_4CHERR		ISR1_FORMAT(0xa) /* 4 ch errors mask */
+#define   TALITOS1_ISR_4CHDONE		ISR1_FORMAT(0x5) /* 4 ch done mask */
+#define   TALITOS1_ISR_TEA_ERR		0x00000040
+#define   TALITOS2_ISR_4CHERR		ISR2_FORMAT(0xa) /* 4 ch errors mask */
+#define   TALITOS2_ISR_4CHDONE		ISR2_FORMAT(0x5) /* 4 ch done mask */
+#define   TALITOS2_ISR_CH_0_2_ERR	ISR2_FORMAT(0x2) /* ch 0, 2 err mask */
+#define   TALITOS2_ISR_CH_0_2_DONE	ISR2_FORMAT(0x1) /* ch 0, 2 done mask */
+#define   TALITOS2_ISR_CH_1_3_ERR	ISR2_FORMAT(0x8) /* ch 1, 3 err mask */
+#define   TALITOS2_ISR_CH_1_3_DONE	ISR2_FORMAT(0x4) /* ch 1, 3 done mask */
 #define TALITOS_ISR_LO			0x1014
 #define TALITOS_ICR			0x1018  /* interrupt clear register */
 #define TALITOS_ICR_LO			0x101C
@@ -219,14 +231,15 @@ static inline bool has_ftr_sec1(struct talitos_private *priv)
 
 /* channel configuration register  */
 #define TALITOS_CCCR			0x8
-#define   TALITOS_CCCR_CONT		0x2    /* channel continue */
-#define   TALITOS_CCCR_RESET		0x1    /* channel reset */
+#define   TALITOS2_CCCR_CONT		0x2    /* channel continue on SEC2 */
+#define   TALITOS2_CCCR_RESET		0x1    /* channel reset on SEC2 */
 #define TALITOS_CCCR_LO			0xc
 #define   TALITOS_CCCR_LO_IWSE		0x80   /* chan. ICCR writeback enab. */
 #define   TALITOS_CCCR_LO_EAE		0x20   /* extended address enable */
 #define   TALITOS_CCCR_LO_CDWE		0x10   /* chan. done writeback enab. */
 #define   TALITOS_CCCR_LO_NT		0x4    /* notification type */
 #define   TALITOS_CCCR_LO_CDIE		0x2    /* channel done IRQ enable */
+#define   TALITOS1_CCCR_LO_RESET	0x1    /* channel reset on SEC1 */
 
 /* CCPSR: channel pointer status register */
 #define TALITOS_CCPSR			0x10
@@ -298,6 +311,8 @@ static inline bool has_ftr_sec1(struct talitos_private *priv)
 #define TALITOS_EUICR_LO		0x3c
 #define TALITOS_EU_FIFO			0x800 /* output FIFO */
 #define TALITOS_EU_FIFO_LO		0x804 /* output FIFO */
+/* DES unit */
+#define   TALITOS1_DEUICR_KPE		0x00200000 /* Key Parity Error */
 /* message digest unit */
 #define   TALITOS_MDEUICR_LO_ICE	0x4000 /* integrity check IRQ enable */
 /* random number unit */
-- 
2.1.0
