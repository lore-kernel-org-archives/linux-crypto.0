Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C6F3B0AC6
	for <linux-crypto@vger.kernel.org>; Thu, 28 May 2026 09:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779959395; cv=none; b=qHM6IdCHYYyhImLEpLvHzs9tP22WoWveTdY8kzmnNJBjC6ZXr29JrI5hkBtNtm1UI1yrZil0+OuWBW0kXCZIEehZ/WAQtMjd+2p7etQJ4yCIwDJ4wGVhx+dgl7ov3ZojKzh1i6aF7Di5vlV86XcPAix/8rJHXV+aBVaYt0kTS6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779959395; c=relaxed/simple;
	bh=G2Rh7ItojjDOD/vsIVPY/V4JRlOlXe8zoHg/E/XqAiw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=KM0QrHc/kDrrpKa9/9VId4p+WsPqEOkxhY6pw9rBL2vYzTDNeodvknMTaMGnMjstYW5nmEFDzuD40u2Pc+N/YGkWoN1EgRV1x2ldhhCLaV9+VQctQQH2Dm4SnXZkIoccpmcgmCFGdvlyu+xvd3Xrvn8KCCTT08RK/MK0R9W3fAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=tBG55HCX; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="tBG55HCX"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id A37264E42D78;
	Thu, 28 May 2026 09:09:50 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 7847160495;
	Thu, 28 May 2026 09:09:50 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 0F5B410888508;
	Thu, 28 May 2026 11:09:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1779959389; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=7Cl6V4bJQiHOW1rUQE5wCi24+z761xmT1stBeV67bbI=;
	b=tBG55HCX7SDOO/B4e/WHs3yi8w7JDKS8iID/lulBKD+ZxhBx5F/5Xx4OBLK59aQayCkl7w
	6vFeVg8HRrKF3faZnCfSYc3Ee+AX/+CohAbGk7XSKWhB6Quxbibawq0/SIHfyojKfoCFwe
	lfEglTVR6JkuJQRuYudCRW3yaQo8tVFpYjDd69vLi6h4YLqd4Qh49/U9aCl9eJEC7wf6BK
	B5Piv6lzkOP1FGJX/EIsIbB5mIh0wjetc3SoQbQw+iGcMGUifEIqhU+hcJQRXzT+kcu0cy
	9P44BMl3nEz5Xhmu3z9at5DF/6+PPBuylixP0huU/6JyCPwziQQ1FNpX39/89g==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Thu, 28 May 2026 11:08:36 +0200
Subject: [PATCH 23/29] crypto: talitos - Move SEC2 ops into talitos-sec2.c
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260528-7-1-rc1_talitos_cleanup-v1-23-cb1ad6cdea49@bootlin.com>
References: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
In-Reply-To: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779959350; l=24452;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=G2Rh7ItojjDOD/vsIVPY/V4JRlOlXe8zoHg/E/XqAiw=;
 b=pdAmiEyokmkc+jmlDwVObhe/dBfO0E7c02WdCYF4f2vHUJsaupLNXKaRo5eNyzUeG4viYbHXW
 3YSf/FycGlDA9WBYwRXU9XKNTk36CRAiUKBQgFsoYLye+OTngyVvsHn
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Relocate all SEC2-specific functions and the sec2_ops /
talitos_register_sec2() definitions from talitos.c into a new
talitos-sec2.c compilation unit.


Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos/Makefile       |   1 +
 drivers/crypto/talitos/talitos-sec2.c | 330 ++++++++++++++++++++++++++++++++++
 drivers/crypto/talitos/talitos.c      | 319 +-------------------------------
 drivers/crypto/talitos/talitos.h      |   8 +
 4 files changed, 340 insertions(+), 318 deletions(-)

diff --git a/drivers/crypto/talitos/Makefile b/drivers/crypto/talitos/Makefile
index 5f3bc89ad7ea..3d9fa2570f2c 100644
--- a/drivers/crypto/talitos/Makefile
+++ b/drivers/crypto/talitos/Makefile
@@ -3,3 +3,4 @@ obj-$(CONFIG_CRYPTO_DEV_TALITOS) += talitos.o
 talitos-y := talitos.o talitos-rng.o talitos-hash.o talitos-skcipher.o talitos-aead.o
 
 talitos-$(CONFIG_CRYPTO_DEV_TALITOS1) += talitos-sec1.o
+talitos-$(CONFIG_CRYPTO_DEV_TALITOS2) += talitos-sec2.o
diff --git a/drivers/crypto/talitos/talitos-sec2.c b/drivers/crypto/talitos/talitos-sec2.c
new file mode 100644
index 000000000000..962e7cd43631
--- /dev/null
+++ b/drivers/crypto/talitos/talitos-sec2.c
@@ -0,0 +1,330 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+/*
+ * Freescale SEC (talitos) SEC2 specific driver code
+ *
+ * Copyright (c) 2006-2011 Freescale Semiconductor, Inc.
+ */
+
+#include <linux/io.h>
+#include <linux/of_irq.h>
+
+#include "talitos.h"
+
+#define DEF_TALITOS2_INTERRUPT(name, ch_done_mask, ch_err_mask, tlet)	       \
+static irqreturn_t talitos2_interrupt_##name(int irq, void *data)	       \
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
+
+DEF_TALITOS2_INTERRUPT(4ch, TALITOS2_ISR_4CHDONE, TALITOS2_ISR_4CHERR, 0)
+DEF_TALITOS2_INTERRUPT(ch0_2, TALITOS2_ISR_CH_0_2_DONE, TALITOS2_ISR_CH_0_2_ERR,
+		       0)
+DEF_TALITOS2_INTERRUPT(ch1_3, TALITOS2_ISR_CH_1_3_DONE, TALITOS2_ISR_CH_1_3_ERR,
+		       1)
+
+#define DEF_TALITOS2_DONE(name, ch_done_mask)				\
+static void talitos2_done_##name(unsigned long data)			\
+{									\
+	struct device *dev = (struct device *)data;			\
+	struct talitos_private *priv = dev_get_drvdata(dev);		\
+	unsigned long flags;						\
+									\
+	if (ch_done_mask & 1)						\
+		talitos_flush_channel(dev, 0, 0, 0);			\
+	if (ch_done_mask & (1 << 2))					\
+		talitos_flush_channel(dev, 1, 0, 0);			\
+	if (ch_done_mask & (1 << 4))					\
+		talitos_flush_channel(dev, 2, 0, 0);			\
+	if (ch_done_mask & (1 << 6))					\
+		talitos_flush_channel(dev, 3, 0, 0);			\
+									\
+	/* At this point, all completed channels have been processed */	\
+	/* Unmask done interrupts for channels completed later on. */	\
+	spin_lock_irqsave(&priv->reg_lock, flags);			\
+	setbits32(priv->reg + TALITOS_IMR, ch_done_mask);		\
+	setbits32(priv->reg + TALITOS_IMR_LO, TALITOS2_IMR_LO_INIT);	\
+	spin_unlock_irqrestore(&priv->reg_lock, flags);			\
+}
+
+DEF_TALITOS2_DONE(4ch, TALITOS2_ISR_4CHDONE)
+DEF_TALITOS2_DONE(ch0, TALITOS2_ISR_CH_0_DONE)
+DEF_TALITOS2_DONE(ch0_2, TALITOS2_ISR_CH_0_2_DONE)
+DEF_TALITOS2_DONE(ch1_3, TALITOS2_ISR_CH_1_3_DONE)
+
+static int sec2_reset_channel(struct device *dev, int ch)
+{
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	unsigned int timeout = TALITOS_TIMEOUT;
+
+	setbits32(priv->chan[ch].reg + TALITOS_CCCR, TALITOS2_CCCR_RESET);
+
+	while ((in_be32(priv->chan[ch].reg + TALITOS_CCCR) &
+		TALITOS2_CCCR_RESET) &&
+	       --timeout)
+		cpu_relax();
+
+	if (timeout == 0) {
+		dev_err(dev, "failed to reset sec2 channel %d\n", ch);
+		return -EIO;
+	}
+
+	setbits32(priv->chan[ch].reg + TALITOS_CCCR_LO,
+		  TALITOS_CCCR_LO_EAE | TALITOS_CCCR_LO_CDWE |
+			  TALITOS_CCCR_LO_CDIE);
+
+	/* ICCR writeback, if available */
+	if (priv->features & TALITOS_FTR_HW_AUTH_CHECK)
+		setbits32(priv->chan[ch].reg + TALITOS_CCCR_LO,
+			  TALITOS_CCCR_LO_IWSE);
+
+	return 0;
+}
+
+static int sec2_reset_device(struct device *dev)
+{
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	unsigned int timeout = TALITOS_TIMEOUT;
+
+	setbits32(priv->reg + TALITOS_MCR, TALITOS2_MCR_SWR);
+
+	while ((in_be32(priv->reg + TALITOS_MCR) & TALITOS2_MCR_SWR) &&
+	       --timeout)
+		cpu_relax();
+
+	if (priv->irq[1])
+		setbits32(priv->reg + TALITOS_MCR,
+			  TALITOS_MCR_RCA1 | TALITOS_MCR_RCA3);
+
+	if (timeout == 0) {
+		dev_err(dev, "failed to reset sec2 device\n");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static void sec2_configure_device(struct device *dev)
+{
+	struct talitos_private *priv = dev_get_drvdata(dev);
+
+	setbits32(priv->reg + TALITOS_IMR, TALITOS2_IMR_INIT);
+	setbits32(priv->reg + TALITOS_IMR_LO, TALITOS2_IMR_LO_INIT);
+
+	/* disable integrity check error interrupts (use writeback instead) */
+	if (priv->features & TALITOS_FTR_HW_AUTH_CHECK)
+		setbits32(priv->reg_mdeu + TALITOS_EUICR_LO,
+			  TALITOS_MDEUICR_LO_ICE);
+}
+
+static void sec2_dma_map_request(struct device *dev,
+				 struct talitos_request *request,
+				 struct talitos_desc *desc)
+{
+	request->dma_desc =
+		dma_map_single(dev, desc, TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
+}
+
+static int sec2_talitos_handle_error(struct device *dev, u32 isr, u32 isr_lo)
+{
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	unsigned int timeout = TALITOS_TIMEOUT;
+	int ch, error, reset_dev = 0;
+	u32 v_lo;
+	int reset_ch = 0;
+
+	for (ch = 0; ch < priv->num_channels; ch++) {
+		if (!TALITOS2_CH_HAS_ERROR(isr, ch))
+			continue;
+
+		error = -EINVAL;
+
+		v_lo = in_be32(priv->chan[ch].reg + TALITOS_CCPSR_LO);
+
+		if (v_lo & TALITOS2_CCPSR_LO_DOF) {
+			dev_err(dev, "double fetch fifo overflow error\n");
+			error = -EAGAIN;
+			reset_ch = 1;
+		}
+		if (v_lo & TALITOS2_CCPSR_LO_SOF) {
+			/* h/w dropped descriptor */
+			dev_err(dev, "single fetch fifo overflow error\n");
+			error = -EAGAIN;
+		}
+		if (v_lo & TALITOS2_CCPSR_LO_MDTE)
+			dev_err(dev, "master data transfer error\n");
+		if (v_lo & TALITOS2_CCPSR_LO_SGDLZ)
+			dev_err(dev, "s/g data length zero error\n");
+		if (v_lo & TALITOS2_CCPSR_LO_FPZ)
+			dev_err(dev, "fetch pointer zero error\n");
+		if (v_lo & TALITOS2_CCPSR_LO_IDH)
+			dev_err(dev, "illegal descriptor header error\n");
+		if (v_lo & TALITOS2_CCPSR_LO_IEU)
+			dev_err(dev, "invalid exec unit error\n");
+		if (v_lo & TALITOS2_CCPSR_LO_EU)
+			talitos_report_eu_error(
+				dev, ch, talitos_current_desc_hdr(dev, ch));
+		if (v_lo & TALITOS2_CCPSR_LO_GB)
+			dev_err(dev, "gather boundary error\n");
+		if (v_lo & TALITOS2_CCPSR_LO_GRL)
+			dev_err(dev, "gather return/length error\n");
+		if (v_lo & TALITOS2_CCPSR_LO_SB)
+			dev_err(dev, "scatter boundary error\n");
+		if (v_lo & TALITOS2_CCPSR_LO_SRL)
+			dev_err(dev, "scatter return/length error\n");
+
+		talitos_flush_channel(dev, ch, error, reset_ch);
+
+		if (reset_ch) {
+			priv->ops->reset_channel(dev, ch);
+		} else {
+			setbits32(priv->chan[ch].reg + TALITOS_CCCR,
+				  TALITOS2_CCCR_CONT);
+			setbits32(priv->chan[ch].reg + TALITOS_CCCR_LO, 0);
+			while ((in_be32(priv->chan[ch].reg + TALITOS_CCCR) &
+				TALITOS2_CCCR_CONT) && --timeout)
+				cpu_relax();
+			if (timeout == 0) {
+				dev_err(dev, "failed to restart channel %d\n",
+					ch);
+				reset_dev = 1;
+			}
+		}
+	}
+
+	return reset_dev || (isr & ~TALITOS2_ISR_4CHERR) || isr_lo;
+}
+
+static int sec2_talitos_probe_irq(struct platform_device *ofdev)
+{
+	struct device *dev = &ofdev->dev;
+	struct device_node *np = ofdev->dev.of_node;
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	int err;
+
+	priv->irq[0] = irq_of_parse_and_map(np, 0);
+	if (!priv->irq[0]) {
+		dev_err(dev, "failed to map irq\n");
+		return -EINVAL;
+	}
+	priv->irq[1] = irq_of_parse_and_map(np, 1);
+
+	/* get the primary irq line */
+	if (!priv->irq[1]) {
+		err = request_irq(priv->irq[0], talitos2_interrupt_4ch, 0,
+				  dev_driver_string(dev), dev);
+		goto primary_out;
+	}
+
+	err = request_irq(priv->irq[0], talitos2_interrupt_ch0_2, 0,
+			  dev_driver_string(dev), dev);
+	if (err)
+		goto primary_out;
+
+	/* get the secondary irq line */
+	err = request_irq(priv->irq[1], talitos2_interrupt_ch1_3, 0,
+			  dev_driver_string(dev), dev);
+	if (err) {
+		dev_err(dev, "failed to request secondary irq\n");
+		irq_dispose_mapping(priv->irq[1]);
+		priv->irq[1] = 0;
+	}
+
+	return err;
+
+primary_out:
+	if (err) {
+		dev_err(dev, "failed to request primary irq\n");
+		irq_dispose_mapping(priv->irq[0]);
+		priv->irq[0] = 0;
+	}
+
+	return err;
+}
+
+static void sec2_init_task(struct device *dev)
+{
+	struct talitos_private *priv = dev_get_drvdata(dev);
+
+	if (priv->irq[1]) {
+		tasklet_init(&priv->done_task[0], talitos2_done_ch0_2,
+			     (unsigned long)dev);
+		tasklet_init(&priv->done_task[1], talitos2_done_ch1_3,
+			     (unsigned long)dev);
+	} else if (priv->num_channels == 1) {
+		tasklet_init(&priv->done_task[0], talitos2_done_ch0,
+			     (unsigned long)dev);
+	} else {
+		tasklet_init(&priv->done_task[0], talitos2_done_4ch,
+			     (unsigned long)dev);
+	}
+}
+
+static void sec2_dma_unmap_request(struct device *dev,
+				   struct talitos_request *request)
+{
+	dma_unmap_single(dev, request->dma_desc, TALITOS_DESC_SIZE,
+			 DMA_BIDIRECTIONAL);
+}
+
+static __be32 sec2_get_request_hdr(struct device *dev,
+				   struct talitos_request *request)
+{
+	dma_sync_single_for_cpu(dev, request->dma_desc, TALITOS_DESC_SIZE,
+				DMA_BIDIRECTIONAL);
+
+	return request->desc->hdr;
+}
+
+static __be32 sec2_search_desc_hdr_in_request(struct talitos_request *request,
+					      dma_addr_t cur_desc)
+{
+	if (request->dma_desc == cur_desc)
+		return request->desc->hdr;
+	return 0;
+}
+
+static const struct talitos_ops sec2_ops = {
+	.probe_irq = sec2_talitos_probe_irq,
+	.init_task = sec2_init_task,
+	.reset_device = sec2_reset_device,
+	.reset_channel = sec2_reset_channel,
+	.configure_device = sec2_configure_device,
+	.dma_map_request = sec2_dma_map_request,
+	.dma_unmap_request = sec2_dma_unmap_request,
+	.get_request_hdr = sec2_get_request_hdr,
+	.search_desc_hdr_in_request = sec2_search_desc_hdr_in_request,
+	.handle_error = sec2_talitos_handle_error,
+};
+
+void talitos_register_sec2(struct talitos_private *priv)
+{
+	priv->ops = &sec2_ops;
+}
diff --git a/drivers/crypto/talitos/talitos.c b/drivers/crypto/talitos/talitos.c
index a4fd14c8bef5..152618998819 100644
--- a/drivers/crypto/talitos/talitos.c
+++ b/drivers/crypto/talitos/talitos.c
@@ -133,71 +133,6 @@ void unmap_single_talitos_ptr(struct device *dev,
 			 from_talitos_ptr_len(ptr, is_sec1), dir);
 }
 
-static int sec2_reset_channel(struct device *dev, int ch)
-{
-	struct talitos_private *priv = dev_get_drvdata(dev);
-	unsigned int timeout = TALITOS_TIMEOUT;
-
-	setbits32(priv->chan[ch].reg + TALITOS_CCCR, TALITOS2_CCCR_RESET);
-
-	while ((in_be32(priv->chan[ch].reg + TALITOS_CCCR) &
-		TALITOS2_CCCR_RESET) &&
-	       --timeout)
-		cpu_relax();
-
-	if (timeout == 0) {
-		dev_err(dev, "failed to reset sec2 channel %d\n", ch);
-		return -EIO;
-	}
-
-	setbits32(priv->chan[ch].reg + TALITOS_CCCR_LO,
-		  TALITOS_CCCR_LO_EAE | TALITOS_CCCR_LO_CDWE |
-			  TALITOS_CCCR_LO_CDIE);
-
-	/* ICCR writeback, if available */
-	if (priv->features & TALITOS_FTR_HW_AUTH_CHECK)
-		setbits32(priv->chan[ch].reg + TALITOS_CCCR_LO,
-			  TALITOS_CCCR_LO_IWSE);
-
-	return 0;
-}
-
-static int sec2_reset_device(struct device *dev)
-{
-	struct talitos_private *priv = dev_get_drvdata(dev);
-	unsigned int timeout = TALITOS_TIMEOUT;
-
-	setbits32(priv->reg + TALITOS_MCR, TALITOS2_MCR_SWR);
-
-	while ((in_be32(priv->reg + TALITOS_MCR) & TALITOS2_MCR_SWR) &&
-	       --timeout)
-		cpu_relax();
-
-	if (priv->irq[1])
-		setbits32(priv->reg + TALITOS_MCR,
-			  TALITOS_MCR_RCA1 | TALITOS_MCR_RCA3);
-
-	if (timeout == 0) {
-		dev_err(dev, "failed to reset sec2 device\n");
-		return -EIO;
-	}
-
-	return 0;
-}
-
-static void sec2_configure_device(struct device *dev)
-{
-	struct talitos_private *priv = dev_get_drvdata(dev);
-
-	setbits32(priv->reg + TALITOS_IMR, TALITOS2_IMR_INIT);
-	setbits32(priv->reg + TALITOS_IMR_LO, TALITOS2_IMR_LO_INIT);
-
-	/* disable integrity check error interrupts (use writeback instead) */
-	if (priv->features & TALITOS_FTR_HW_AUTH_CHECK)
-		setbits32(priv->reg_mdeu + TALITOS_EUICR_LO,
-			  TALITOS_MDEUICR_LO_ICE);
-}
-
 /*
  * Reset and initialize the device
  */
@@ -233,14 +168,6 @@ static int init_device(struct device *dev)
 	return 0;
 }
 
-static void sec2_dma_map_request(struct device *dev,
-				 struct talitos_request *request,
-				 struct talitos_desc *desc)
-{
-	request->dma_desc =
-		dma_map_single(dev, desc, TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
-}
-
 /**
  * talitos_submit - submits a descriptor to the device for processing
  * @dev:	the SEC device to be used
@@ -299,22 +226,6 @@ int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
 	return -EINPROGRESS;
 }
 
-static __be32 sec2_get_request_hdr(struct device *dev,
-				   struct talitos_request *request)
-{
-	dma_sync_single_for_cpu(dev, request->dma_desc, TALITOS_DESC_SIZE,
-				DMA_BIDIRECTIONAL);
-
-	return request->desc->hdr;
-}
-
-static void sec2_dma_unmap_request(struct device *dev,
-				   struct talitos_request *request)
-{
-	dma_unmap_single(dev, request->dma_desc, TALITOS_DESC_SIZE,
-			 DMA_BIDIRECTIONAL);
-}
-
 /*
  * process what was done, notify callback of error if not
  */
@@ -375,47 +286,6 @@ void talitos_flush_channel(struct device *dev, int ch, int error, int reset_ch)
 	spin_unlock_irqrestore(&priv->chan[ch].tail_lock, flags);
 }
 
-/*
- * process completed requests for channels that have done status
- */
-
-#define DEF_TALITOS2_DONE(name, ch_done_mask)				\
-static void talitos2_done_##name(unsigned long data)			\
-{									\
-	struct device *dev = (struct device *)data;			\
-	struct talitos_private *priv = dev_get_drvdata(dev);		\
-	unsigned long flags;						\
-									\
-	if (ch_done_mask & 1)						\
-		talitos_flush_channel(dev, 0, 0, 0);			\
-	if (ch_done_mask & (1 << 2))					\
-		talitos_flush_channel(dev, 1, 0, 0);			\
-	if (ch_done_mask & (1 << 4))					\
-		talitos_flush_channel(dev, 2, 0, 0);			\
-	if (ch_done_mask & (1 << 6))					\
-		talitos_flush_channel(dev, 3, 0, 0);			\
-									\
-	/* At this point, all completed channels have been processed */	\
-	/* Unmask done interrupts for channels completed later on. */	\
-	spin_lock_irqsave(&priv->reg_lock, flags);			\
-	setbits32(priv->reg + TALITOS_IMR, ch_done_mask);		\
-	setbits32(priv->reg + TALITOS_IMR_LO, TALITOS2_IMR_LO_INIT);	\
-	spin_unlock_irqrestore(&priv->reg_lock, flags);			\
-}
-
-DEF_TALITOS2_DONE(4ch, TALITOS2_ISR_4CHDONE)
-DEF_TALITOS2_DONE(ch0, TALITOS2_ISR_CH_0_DONE)
-DEF_TALITOS2_DONE(ch0_2, TALITOS2_ISR_CH_0_2_DONE)
-DEF_TALITOS2_DONE(ch1_3, TALITOS2_ISR_CH_1_3_DONE)
-
-static __be32 sec2_search_desc_hdr_in_request(struct talitos_request *request,
-					      dma_addr_t cur_desc)
-{
-	if (request->dma_desc == cur_desc)
-		return request->desc->hdr;
-	return 0;
-}
-
 /*
  * locate current (offending) descriptor
  */
@@ -528,76 +398,6 @@ void talitos_report_eu_error(struct device *dev, int ch, __be32 desc_hdr)
 			in_be32(priv->chan[ch].reg + TALITOS_DESCBUF_LO + 8*i));
 }
 
-static int sec2_talitos_handle_error(struct device *dev, u32 isr, u32 isr_lo)
-{
-	struct talitos_private *priv = dev_get_drvdata(dev);
-	unsigned int timeout = TALITOS_TIMEOUT;
-	int ch, error, reset_dev = 0;
-	u32 v_lo;
-	int reset_ch = 0;
-
-	for (ch = 0; ch < priv->num_channels; ch++) {
-		if (!TALITOS2_CH_HAS_ERROR(isr, ch))
-			continue;
-
-		error = -EINVAL;
-
-		v_lo = in_be32(priv->chan[ch].reg + TALITOS_CCPSR_LO);
-
-		if (v_lo & TALITOS2_CCPSR_LO_DOF) {
-			dev_err(dev, "double fetch fifo overflow error\n");
-			error = -EAGAIN;
-			reset_ch = 1;
-		}
-		if (v_lo & TALITOS2_CCPSR_LO_SOF) {
-			/* h/w dropped descriptor */
-			dev_err(dev, "single fetch fifo overflow error\n");
-			error = -EAGAIN;
-		}
-		if (v_lo & TALITOS2_CCPSR_LO_MDTE)
-			dev_err(dev, "master data transfer error\n");
-		if (v_lo & TALITOS2_CCPSR_LO_SGDLZ)
-			dev_err(dev, "s/g data length zero error\n");
-		if (v_lo & TALITOS2_CCPSR_LO_FPZ)
-			dev_err(dev, "fetch pointer zero error\n");
-		if (v_lo & TALITOS2_CCPSR_LO_IDH)
-			dev_err(dev, "illegal descriptor header error\n");
-		if (v_lo & TALITOS2_CCPSR_LO_IEU)
-			dev_err(dev, "invalid exec unit error\n");
-		if (v_lo & TALITOS2_CCPSR_LO_EU)
-			talitos_report_eu_error(
-				dev, ch, talitos_current_desc_hdr(dev, ch));
-		if (v_lo & TALITOS2_CCPSR_LO_GB)
-			dev_err(dev, "gather boundary error\n");
-		if (v_lo & TALITOS2_CCPSR_LO_GRL)
-			dev_err(dev, "gather return/length error\n");
-		if (v_lo & TALITOS2_CCPSR_LO_SB)
-			dev_err(dev, "scatter boundary error\n");
-		if (v_lo & TALITOS2_CCPSR_LO_SRL)
-			dev_err(dev, "scatter return/length error\n");
-
-		talitos_flush_channel(dev, ch, error, reset_ch);
-
-		if (reset_ch) {
-			priv->ops->reset_channel(dev, ch);
-		} else {
-			setbits32(priv->chan[ch].reg + TALITOS_CCCR,
-				  TALITOS2_CCCR_CONT);
-			setbits32(priv->chan[ch].reg + TALITOS_CCCR_LO, 0);
-			while ((in_be32(priv->chan[ch].reg + TALITOS_CCCR) &
-				TALITOS2_CCCR_CONT) && --timeout)
-				cpu_relax();
-			if (timeout == 0) {
-				dev_err(dev, "failed to restart channel %d\n",
-					ch);
-				reset_dev = 1;
-			}
-		}
-	}
-
-	return reset_dev || (isr & ~TALITOS2_ISR_4CHERR) || isr_lo;
-}
-
 /*
  * recover from error interrupts
  */
@@ -623,45 +423,6 @@ void talitos_error(struct device *dev, u32 isr, u32 isr_lo)
 	}
 }
 
-#define DEF_TALITOS2_INTERRUPT(name, ch_done_mask, ch_err_mask, tlet)	       \
-static irqreturn_t talitos2_interrupt_##name(int irq, void *data)	       \
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
-
-DEF_TALITOS2_INTERRUPT(4ch, TALITOS2_ISR_4CHDONE, TALITOS2_ISR_4CHERR, 0)
-DEF_TALITOS2_INTERRUPT(ch0_2, TALITOS2_ISR_CH_0_2_DONE, TALITOS2_ISR_CH_0_2_ERR,
-		       0)
-DEF_TALITOS2_INTERRUPT(ch1_3, TALITOS2_ISR_CH_1_3_DONE, TALITOS2_ISR_CH_1_3_ERR,
-		       1)
-
 void talitos_sg_unmap(struct device *dev,
 			     struct talitos_edesc *edesc,
 			     struct scatterlist *src,
@@ -1023,84 +784,6 @@ int talitos_register_common(struct device *dev,
 	return 0;
 }
 
-static int sec2_talitos_probe_irq(struct platform_device *ofdev)
-{
-	struct device *dev = &ofdev->dev;
-	struct device_node *np = ofdev->dev.of_node;
-	struct talitos_private *priv = dev_get_drvdata(dev);
-	int err;
-
-	priv->irq[0] = irq_of_parse_and_map(np, 0);
-	if (!priv->irq[0]) {
-		dev_err(dev, "failed to map irq\n");
-		return -EINVAL;
-	}
-	priv->irq[1] = irq_of_parse_and_map(np, 1);
-
-	/* get the primary irq line */
-	if (!priv->irq[1]) {
-		err = request_irq(priv->irq[0], talitos2_interrupt_4ch, 0,
-				  dev_driver_string(dev), dev);
-		goto primary_out;
-	}
-
-	err = request_irq(priv->irq[0], talitos2_interrupt_ch0_2, 0,
-			  dev_driver_string(dev), dev);
-	if (err)
-		goto primary_out;
-
-	/* get the secondary irq line */
-	err = request_irq(priv->irq[1], talitos2_interrupt_ch1_3, 0,
-			  dev_driver_string(dev), dev);
-	if (err) {
-		dev_err(dev, "failed to request secondary irq\n");
-		irq_dispose_mapping(priv->irq[1]);
-		priv->irq[1] = 0;
-	}
-
-	return err;
-
-primary_out:
-	if (err) {
-		dev_err(dev, "failed to request primary irq\n");
-		irq_dispose_mapping(priv->irq[0]);
-		priv->irq[0] = 0;
-	}
-
-	return err;
-}
-
-static void sec2_init_task(struct device *dev)
-{
-	struct talitos_private *priv = dev_get_drvdata(dev);
-
-	if (priv->irq[1]) {
-		tasklet_init(&priv->done_task[0], talitos2_done_ch0_2,
-			     (unsigned long)dev);
-		tasklet_init(&priv->done_task[1], talitos2_done_ch1_3,
-			     (unsigned long)dev);
-	} else if (priv->num_channels == 1) {
-		tasklet_init(&priv->done_task[0], talitos2_done_ch0,
-			     (unsigned long)dev);
-	} else {
-		tasklet_init(&priv->done_task[0], talitos2_done_4ch,
-			     (unsigned long)dev);
-	}
-}
-
-static const struct talitos_ops sec2_ops = {
-	.probe_irq = sec2_talitos_probe_irq,
-	.init_task = sec2_init_task,
-	.reset_device = sec2_reset_device,
-	.reset_channel = sec2_reset_channel,
-	.configure_device = sec2_configure_device,
-	.dma_map_request = sec2_dma_map_request,
-	.dma_unmap_request = sec2_dma_unmap_request,
-	.get_request_hdr = sec2_get_request_hdr,
-	.search_desc_hdr_in_request = sec2_search_desc_hdr_in_request,
-	.handle_error = sec2_talitos_handle_error,
-};
-
 static int talitos_probe(struct platform_device *ofdev)
 {
 	struct device *dev = &ofdev->dev;
@@ -1186,7 +869,7 @@ static int talitos_probe(struct platform_device *ofdev)
 	if (has_ftr_sec1(priv))
 		talitos_register_sec1(priv);
 	else
-		priv->ops = &sec2_ops;
+		talitos_register_sec2(priv);
 
 	err = priv->ops->probe_irq(ofdev);
 	if (err)
diff --git a/drivers/crypto/talitos/talitos.h b/drivers/crypto/talitos/talitos.h
index f5e98050c4cb..ae0bdb2ea78e 100644
--- a/drivers/crypto/talitos/talitos.h
+++ b/drivers/crypto/talitos/talitos.h
@@ -574,6 +574,14 @@ static inline void talitos_register_sec1(struct talitos_private *priv)
 }
 #endif
 
+#ifdef CONFIG_CRYPTO_DEV_TALITOS2
+void talitos_register_sec2(struct talitos_private *priv);
+#else
+static inline void talitos_register_sec2(struct talitos_private *priv)
+{
+}
+#endif
+
 /* Hardware RNG */
 
 int talitos_register_rng(struct device *dev);

-- 
2.54.0

