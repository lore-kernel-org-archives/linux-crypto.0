From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH v2 10/17] crypto: talitos - Move interrupt related macros in talitos2.h
Date: Fri,  6 Mar 2015 17:40:45 +0100 (CET)
Message-ID: <20150306164045.E399B1A241C@localhost.localdomain>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:54033 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755103AbbCFQkr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 Mar 2015 11:40:47 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Move interrupt related macros in talitos2.h as they are specific to SEC2

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
 drivers/crypto/talitos.c  | 58 ---------------------------------------------
 drivers/crypto/talitos2.h | 60 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+), 58 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index ffa103b..b1ba98b 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -262,32 +262,6 @@ void talitos_flush_channel(struct device *dev, int ch, int error, int reset_ch)
 /*
  * process completed requests for channels that have done status
  */
-#define DEF_TALITOS_DONE(name, ch_done_mask)				\
-static void talitos_done_##name(unsigned long data)			\
-{									\
-	struct device *dev = (struct device *)data;			\
-	struct talitos_private *priv = dev_get_drvdata(dev);		\
-	unsigned long flags;						\
-									\
-	if (ch_done_mask & 1)						\
-		talitos_flush_channel(dev, 0, 0, 0);			\
-	if (priv->num_channels == 1)					\
-		goto out;						\
-	if (ch_done_mask & (1 << 2))					\
-		talitos_flush_channel(dev, 1, 0, 0);			\
-	if (ch_done_mask & (1 << 4))					\
-		talitos_flush_channel(dev, 2, 0, 0);			\
-	if (ch_done_mask & (1 << 6))					\
-		talitos_flush_channel(dev, 3, 0, 0);			\
-									\
-out:									\
-	/* At this point, all completed channels have been processed */	\
-	/* Unmask done interrupts for channels completed later on. */	\
-	spin_lock_irqsave(&priv->reg_lock, flags);			\
-	setbits32(priv->reg + TALITOS_IMR, ch_done_mask);		\
-	setbits32(priv->reg + TALITOS_IMR_LO, TALITOS_IMR_LO_INIT);	\
-	spin_unlock_irqrestore(&priv->reg_lock, flags);			\
-}
 DEF_TALITOS_DONE(4ch, TALITOS_ISR_4CHDONE)
 DEF_TALITOS_DONE(ch0_2, TALITOS_ISR_CH_0_2_DONE)
 DEF_TALITOS_DONE(ch1_3, TALITOS_ISR_CH_1_3_DONE)
@@ -399,38 +373,6 @@ void talitos_report_eu_error(struct device *dev, int ch)
 			in_be32(priv->chan[ch].reg + TALITOS_DESCBUF_LO + 8*i));
 }
 
-#define DEF_TALITOS_INTERRUPT(name, ch_done_mask, ch_err_mask, tlet)	       \
-static irqreturn_t talitos_interrupt_##name(int irq, void *data)	       \
-{									       \
-	struct device *dev = data;					       \
-	struct talitos_private *priv = dev_get_drvdata(dev);		       \
-	u32 isr, isr_lo;						       \
-	unsigned long flags;						       \
-									       \
-	spin_lock_irqsave(&priv->reg_lock, flags);			       \
-	isr = in_be32(priv->reg + TALITOS_ISR);				       \
-	isr_lo = in_be32(priv->reg + TALITOS_ISR_LO);			       \
-	/* Acknowledge interrupt */					       \
-	out_be32(priv->reg + TALITOS_ICR, isr & (ch_done_mask | ch_err_mask)); \
-	out_be32(priv->reg + TALITOS_ICR_LO, isr_lo);			       \
-									       \
-	if (unlikely(isr & ch_err_mask || isr_lo)) {			       \
-		spin_unlock_irqrestore(&priv->reg_lock, flags);		       \
-		talitos_error(dev, isr & ch_err_mask, isr_lo);		       \
-	}								       \
-	else {								       \
-		if (likely(isr & ch_done_mask)) {			       \
-			/* mask further done interrupts. */		       \
-			clrbits32(priv->reg + TALITOS_IMR, ch_done_mask);      \
-			/* done_task will unmask done interrupts at exit */    \
-			tasklet_schedule(&priv->done_task[tlet]);	       \
-		}							       \
-		spin_unlock_irqrestore(&priv->reg_lock, flags);		       \
-	}								       \
-									       \
-	return (isr & (ch_done_mask | ch_err_mask) || isr_lo) ? IRQ_HANDLED :  \
-								IRQ_NONE;      \
-}
 DEF_TALITOS_INTERRUPT(4ch, TALITOS_ISR_4CHDONE, TALITOS_ISR_4CHERR, 0)
 DEF_TALITOS_INTERRUPT(ch0_2, TALITOS_ISR_CH_0_2_DONE, TALITOS_ISR_CH_0_2_ERR, 0)
 DEF_TALITOS_INTERRUPT(ch1_3, TALITOS_ISR_CH_1_3_DONE, TALITOS_ISR_CH_1_3_ERR, 1)
diff --git a/drivers/crypto/talitos2.h b/drivers/crypto/talitos2.h
index f9da9f2..10c7313 100644
--- a/drivers/crypto/talitos2.h
+++ b/drivers/crypto/talitos2.h
@@ -222,3 +222,63 @@ static inline void do_init_device(struct talitos_private *priv)
 	setbits32(priv->reg + TALITOS_IMR, TALITOS_IMR_INIT);
 	setbits32(priv->reg + TALITOS_IMR_LO, TALITOS_IMR_LO_INIT);
 }
+
+#define DEF_TALITOS_DONE(name, ch_done_mask)				\
+static void talitos_done_##name(unsigned long data)			\
+{									\
+	struct device *dev = (struct device *)data;			\
+	struct talitos_private *priv = dev_get_drvdata(dev);		\
+	unsigned long flags;						\
+									\
+	if (ch_done_mask & 1)						\
+		talitos_flush_channel(dev, 0, 0, 0);			\
+	if (priv->num_channels == 1)					\
+		goto out;						\
+	if (ch_done_mask & (1 << 2))					\
+		talitos_flush_channel(dev, 1, 0, 0);			\
+	if (ch_done_mask & (1 << 4))					\
+		talitos_flush_channel(dev, 2, 0, 0);			\
+	if (ch_done_mask & (1 << 6))					\
+		talitos_flush_channel(dev, 3, 0, 0);			\
+									\
+out:									\
+	/* At this point, all completed channels have been processed */	\
+	/* Unmask done interrupts for channels completed later on. */	\
+	spin_lock_irqsave(&priv->reg_lock, flags);			\
+	setbits32(priv->reg + TALITOS_IMR, ch_done_mask);		\
+	setbits32(priv->reg + TALITOS_IMR_LO, TALITOS_IMR_LO_INIT);	\
+	spin_unlock_irqrestore(&priv->reg_lock, flags);			\
+}
+
+#define DEF_TALITOS_INTERRUPT(name, ch_done_mask, ch_err_mask, tlet)	       \
+static irqreturn_t talitos_interrupt_##name(int irq, void *data)	       \
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
+	if (unlikely(isr & ch_err_mask || isr_lo)) {			       \
+		spin_unlock_irqrestore(&priv->reg_lock, flags);		       \
+		talitos_error(dev, isr & ch_err_mask, isr_lo);		       \
+	}								       \
+	else {								       \
+		if (likely(isr & ch_done_mask)) {			       \
+			/* mask further done interrupts. */		       \
+			clrbits32(priv->reg + TALITOS_IMR, ch_done_mask);      \
+			/* done_task will unmask done interrupts at exit */    \
+			tasklet_schedule(&priv->done_task[tlet]);	       \
+		}							       \
+		spin_unlock_irqrestore(&priv->reg_lock, flags);		       \
+	}								       \
+									       \
+	return (isr & (ch_done_mask | ch_err_mask) || isr_lo) ? IRQ_HANDLED :  \
+								IRQ_NONE;      \
+}
-- 
2.1.0
