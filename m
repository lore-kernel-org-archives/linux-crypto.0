From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH v2 08/17] crypto: talitos - Deport SEC2 error handling
Date: Fri,  6 Mar 2015 17:40:05 +0100 (CET)
Message-ID: <20150306164005.CADF81A241C@localhost.localdomain>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:54021 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755103AbbCFQkI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 Mar 2015 11:40:08 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

SEC2 and SEC1 error handling will be different because so many bits are
different. So we move error handling into talitos2.c

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
 drivers/crypto/talitos.c  | 103 +++++-----------------------------------------
 drivers/crypto/talitos.h  |   8 ++++
 drivers/crypto/talitos2.c |  82 ++++++++++++++++++++++++++++++++++++
 3 files changed, 101 insertions(+), 92 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 114c5e5..81a6e47 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -68,7 +68,7 @@ static unsigned int do_reset_channel(struct talitos_private *priv, int ch)
 	return timeout;
 }
 
-static int reset_channel(struct device *dev, int ch)
+int talitos_reset_channel(struct device *dev, int ch)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	unsigned int timeout = do_reset_channel(priv, ch);
@@ -124,7 +124,7 @@ static void do_init_device(struct talitos_private *priv)
 	setbits32(priv->reg + TALITOS_IMR_LO, TALITOS_IMR_LO_INIT);
 }
 
-static int init_device(struct device *dev)
+int talitos_init_device(struct device *dev)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	int ch, err;
@@ -145,7 +145,7 @@ static int init_device(struct device *dev)
 
 	/* reset channels */
 	for (ch = 0; ch < priv->num_channels; ch++) {
-		err = reset_channel(dev, ch);
+		err = talitos_reset_channel(dev, ch);
 		if (err)
 			return err;
 	}
@@ -223,7 +223,7 @@ EXPORT_SYMBOL(talitos_submit);
 /*
  * process what was done, notify callback of error if not
  */
-static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
+void talitos_flush_channel(struct device *dev, int ch, int error, int reset_ch)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	struct talitos_request *request, saved_req;
@@ -289,15 +289,15 @@ static void talitos_done_##name(unsigned long data)			\
 	unsigned long flags;						\
 									\
 	if (ch_done_mask & 1)						\
-		flush_channel(dev, 0, 0, 0);				\
+		talitos_flush_channel(dev, 0, 0, 0);			\
 	if (priv->num_channels == 1)					\
 		goto out;						\
 	if (ch_done_mask & (1 << 2))					\
-		flush_channel(dev, 1, 0, 0);				\
+		talitos_flush_channel(dev, 1, 0, 0);			\
 	if (ch_done_mask & (1 << 4))					\
-		flush_channel(dev, 2, 0, 0);				\
+		talitos_flush_channel(dev, 2, 0, 0);			\
 	if (ch_done_mask & (1 << 6))					\
-		flush_channel(dev, 3, 0, 0);				\
+		talitos_flush_channel(dev, 3, 0, 0);			\
 									\
 out:									\
 	/* At this point, all completed channels have been processed */	\
@@ -345,10 +345,11 @@ static u32 current_desc_hdr(struct device *dev, int ch)
 /*
  * user diagnostics; report root cause of error based on execution unit status
  */
-static void report_eu_error(struct device *dev, int ch, u32 desc_hdr)
+void talitos_report_eu_error(struct device *dev, int ch)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	int i;
+	u32 desc_hdr = current_desc_hdr(dev, ch);
 
 	if (!desc_hdr)
 		desc_hdr = in_be32(priv->chan[ch].reg + TALITOS_DESCBUF);
@@ -417,88 +418,6 @@ static void report_eu_error(struct device *dev, int ch, u32 desc_hdr)
 			in_be32(priv->chan[ch].reg + TALITOS_DESCBUF_LO + 8*i));
 }
 
-/*
- * recover from error interrupts
- */
-static void talitos_error(struct device *dev, u32 isr, u32 isr_lo)
-{
-	struct talitos_private *priv = dev_get_drvdata(dev);
-	unsigned int timeout = TALITOS_TIMEOUT;
-	int ch, error, reset_dev = 0, reset_ch = 0;
-	u32 v, v_lo;
-
-	for (ch = 0; ch < priv->num_channels; ch++) {
-		/* skip channels without errors */
-		if (!(isr & (1 << (ch * 2 + 1))))
-			continue;
-
-		error = -EINVAL;
-
-		v = in_be32(priv->chan[ch].reg + TALITOS_CCPSR);
-		v_lo = in_be32(priv->chan[ch].reg + TALITOS_CCPSR_LO);
-
-		if (v_lo & TALITOS_CCPSR_LO_DOF) {
-			dev_err(dev, "double fetch fifo overflow error\n");
-			error = -EAGAIN;
-			reset_ch = 1;
-		}
-		if (v_lo & TALITOS_CCPSR_LO_SOF) {
-			/* h/w dropped descriptor */
-			dev_err(dev, "single fetch fifo overflow error\n");
-			error = -EAGAIN;
-		}
-		if (v_lo & TALITOS_CCPSR_LO_MDTE)
-			dev_err(dev, "master data transfer error\n");
-		if (v_lo & TALITOS_CCPSR_LO_SGDLZ)
-			dev_err(dev, "s/g data length zero error\n");
-		if (v_lo & TALITOS_CCPSR_LO_FPZ)
-			dev_err(dev, "fetch pointer zero error\n");
-		if (v_lo & TALITOS_CCPSR_LO_IDH)
-			dev_err(dev, "illegal descriptor header error\n");
-		if (v_lo & TALITOS_CCPSR_LO_IEU)
-			dev_err(dev, "invalid execution unit error\n");
-		if (v_lo & TALITOS_CCPSR_LO_EU)
-			report_eu_error(dev, ch, current_desc_hdr(dev, ch));
-		if (v_lo & TALITOS_CCPSR_LO_GB)
-			dev_err(dev, "gather boundary error\n");
-		if (v_lo & TALITOS_CCPSR_LO_GRL)
-			dev_err(dev, "gather return/length error\n");
-		if (v_lo & TALITOS_CCPSR_LO_SB)
-			dev_err(dev, "scatter boundary error\n");
-		if (v_lo & TALITOS_CCPSR_LO_SRL)
-			dev_err(dev, "scatter return/length error\n");
-
-		flush_channel(dev, ch, error, reset_ch);
-
-		if (reset_ch) {
-			reset_channel(dev, ch);
-		} else {
-			setbits32(priv->chan[ch].reg + TALITOS_CCCR,
-				  TALITOS_CCCR_CONT);
-			setbits32(priv->chan[ch].reg + TALITOS_CCCR_LO, 0);
-			while ((in_be32(priv->chan[ch].reg + TALITOS_CCCR) &
-			       TALITOS_CCCR_CONT) && --timeout)
-				cpu_relax();
-			if (timeout == 0) {
-				dev_err(dev, "failed to restart channel %d\n",
-					ch);
-				reset_dev = 1;
-			}
-		}
-	}
-	if (reset_dev || isr & ~TALITOS_ISR_4CHERR || isr_lo) {
-		dev_err(dev, "done overflow, internal time out, or rngu error: "
-		        "ISR 0x%08x_%08x\n", isr, isr_lo);
-
-		/* purge request queues */
-		for (ch = 0; ch < priv->num_channels; ch++)
-			flush_channel(dev, ch, -EIO, 1);
-
-		/* reset and reinitialize the device */
-		init_device(dev);
-	}
-}
-
 #define DEF_TALITOS_INTERRUPT(name, ch_done_mask, ch_err_mask, tlet)	       \
 static irqreturn_t talitos_interrupt_##name(int irq, void *data)	       \
 {									       \
@@ -2099,7 +2018,7 @@ static int talitos_probe(struct platform_device *ofdev)
 	dma_set_mask(dev, DMA_BIT_MASK(36));
 
 	/* reset and initialize the h/w */
-	err = init_device(dev);
+	err = talitos_init_device(dev);
 	if (err) {
 		dev_err(dev, "failed to initialize device\n");
 		goto err_out;
diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index 09c97ad..f5e8013 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -143,6 +143,14 @@ extern struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 						 int icv_stashing,
 						 u32 cryptoflags,
 						 bool encrypt);
+
+extern int talitos_reset_channel(struct device *dev, int ch);
+extern int talitos_init_device(struct device *dev);
+extern void talitos_flush_channel(struct device *dev, int ch, int error,
+				  int reset_ch);
+extern void talitos_report_eu_error(struct device *dev, int ch);
+extern void talitos_error(struct device *dev, u32 isr, u32 isr_lo);
+
 extern int talitos_cra_init(struct crypto_tfm *tfm);
 
 /* .features flag */
diff --git a/drivers/crypto/talitos2.c b/drivers/crypto/talitos2.c
index 024cbbd..80f6bc0 100644
--- a/drivers/crypto/talitos2.c
+++ b/drivers/crypto/talitos2.c
@@ -183,6 +183,88 @@ void map_sg_out_talitos_ptr(struct device *dev, struct scatterlist *dst,
 	}
 }
 
+/*
+ * recover from error interrupts
+ */
+void talitos_error(struct device *dev, u32 isr, u32 isr_lo)
+{
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	unsigned int timeout = TALITOS_TIMEOUT;
+	int ch, error, reset_dev = 0, reset_ch = 0;
+	u32 v, v_lo;
+
+	for (ch = 0; ch < priv->num_channels; ch++) {
+		/* skip channels without errors */
+		if (!(isr & (1 << (ch * 2 + 1))))
+			continue;
+
+		error = -EINVAL;
+
+		v = in_be32(priv->chan[ch].reg + TALITOS_CCPSR);
+		v_lo = in_be32(priv->chan[ch].reg + TALITOS_CCPSR_LO);
+
+		if (v_lo & TALITOS_CCPSR_LO_DOF) {
+			dev_err(dev, "double fetch fifo overflow error\n");
+			error = -EAGAIN;
+			reset_ch = 1;
+		}
+		if (v_lo & TALITOS_CCPSR_LO_SOF) {
+			/* h/w dropped descriptor */
+			dev_err(dev, "single fetch fifo overflow error\n");
+			error = -EAGAIN;
+		}
+		if (v_lo & TALITOS_CCPSR_LO_MDTE)
+			dev_err(dev, "master data transfer error\n");
+		if (v_lo & TALITOS_CCPSR_LO_SGDLZ)
+			dev_err(dev, "s/g data length zero error\n");
+		if (v_lo & TALITOS_CCPSR_LO_FPZ)
+			dev_err(dev, "fetch pointer zero error\n");
+		if (v_lo & TALITOS_CCPSR_LO_IDH)
+			dev_err(dev, "illegal descriptor header error\n");
+		if (v_lo & TALITOS_CCPSR_LO_IEU)
+			dev_err(dev, "invalid execution unit error\n");
+		if (v_lo & TALITOS_CCPSR_LO_EU)
+			talitos_report_eu_error(dev, ch);
+		if (v_lo & TALITOS_CCPSR_LO_GB)
+			dev_err(dev, "gather boundary error\n");
+		if (v_lo & TALITOS_CCPSR_LO_GRL)
+			dev_err(dev, "gather return/length error\n");
+		if (v_lo & TALITOS_CCPSR_LO_SB)
+			dev_err(dev, "scatter boundary error\n");
+		if (v_lo & TALITOS_CCPSR_LO_SRL)
+			dev_err(dev, "scatter return/length error\n");
+
+		talitos_flush_channel(dev, ch, error, reset_ch);
+
+		if (reset_ch) {
+			talitos_reset_channel(dev, ch);
+		} else {
+			setbits32(priv->chan[ch].reg + TALITOS_CCCR,
+				  TALITOS_CCCR_CONT);
+			setbits32(priv->chan[ch].reg + TALITOS_CCCR_LO, 0);
+			while ((in_be32(priv->chan[ch].reg + TALITOS_CCCR) &
+			       TALITOS_CCCR_CONT) && --timeout)
+				cpu_relax();
+			if (timeout == 0) {
+				dev_err(dev, "failed to restart channel %d\n",
+					ch);
+				reset_dev = 1;
+			}
+		}
+	}
+	if (reset_dev || isr & ~TALITOS_ISR_4CHERR || isr_lo) {
+		dev_err(dev, "done overflow, internal time out, or rngu error: "
+			"ISR 0x%08x_%08x\n", isr, isr_lo);
+
+		/* purge request queues */
+		for (ch = 0; ch < priv->num_channels; ch++)
+			talitos_flush_channel(dev, ch, -EIO, 1);
+
+		/* reset and reinitialize the device */
+		talitos_init_device(dev);
+	}
+}
+
 int aead_setauthsize(struct crypto_aead *authenc,
 			    unsigned int authsize)
 {
-- 
2.1.0
