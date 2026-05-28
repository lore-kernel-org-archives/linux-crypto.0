Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0C43AEF54
	for <linux-crypto@vger.kernel.org>; Thu, 28 May 2026 09:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779959393; cv=none; b=hesZ3wltPhnMHJaOHeR+GrqaFnxnT5nYAsOy7CNqryT0khB8/SJFIPmL6D/QK/1U/xIBvaJSbR7KP8GfKhdvBxaw2WBGautEMOjz7mhitQemPQUM3AIrxuW0E0tz8cAqS+VvcAGVxhNL9tApBA3WhAEQxdPvTTDbOtSq3cuYqic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779959393; c=relaxed/simple;
	bh=VBAD9NuH03xWJrTBmRuvHN3BavrW/bFp/FqE7e0d3FY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Dz2CXfF5MjdivH9ylPXlDesC0Usij/yvho55DuST2LTeRyyODoKGolSZqTJzlOWD3AZe9E2zcJ7TKf6q6DqHKmzb720+YsOqPnQpm73Wd+ByGBv+51HFQOSJg68KIp5MWqGKpOghQEG6o91c9jHT3W47vPKk5lK+Eg7mK02yhwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=vFfA/i4h; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="vFfA/i4h"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 7DB9E1A36FC;
	Thu, 28 May 2026 09:09:48 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 4C59260495;
	Thu, 28 May 2026 09:09:48 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 8D9EA10888054;
	Thu, 28 May 2026 11:09:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1779959387; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=sHutvC1GP3emoHslG85fSmnHI5NVAmOhI7EifFu37Fc=;
	b=vFfA/i4hbm/0N5LaOxIXZZwscuHvoR+VVnRenzgv3vP1m3b11OxUKBZGTUf7rGGkZqqKPY
	o+pBT5aUZbvOqjIW0RtzoXwJ/Rh3CLO+qOOM/5l/73QEURb7g/WczQqt23VHDbHmmgGKA2
	eXjHIZ13a6h9ECMC020XJUw0w/qz5EP91laF/PqzZO9c8i+PmlOatXYkMSKc2+VLU9CM9N
	L/iwnXRwF6s0iunTeUxtxsZbMCdnJt2qxt3HN4lmKXuU4eLzG0xVn4R+shIsv4TutKshPB
	zTi8WPR6kFR7jGHQaXNH9Y8GXWBKFEL0krJ/ekIiBTS1uDj3fEi9isRBZixrMg==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Thu, 28 May 2026 11:08:35 +0200
Subject: [PATCH 22/29] crypto: talitos - Move SEC1 ops into talitos-sec1.c
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260528-7-1-rc1_talitos_cleanup-v1-22-cb1ad6cdea49@bootlin.com>
References: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
In-Reply-To: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779959350; l=23999;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=VBAD9NuH03xWJrTBmRuvHN3BavrW/bFp/FqE7e0d3FY=;
 b=doE2xtTdKqt0zH3pXGUNBQBYyLl9s0NajlcDOZkTuo7vLL5uqd/ZvHNfQHKtwtPuf7BFtJ1qW
 wKbCKhJrn+2COibunvS0Za74FzOyFHOQw/nnPP0o+4Ac0dHmflZ+/Tp
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Relocate all SEC1-specific functions and the sec1_ops /
talitos_register_sec1() definitions from talitos.c into a new
talitos-sec1.c compilation unit.

Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos/Makefile       |   2 +
 drivers/crypto/talitos/talitos-sec1.c | 305 ++++++++++++++++++++++++++++++++++
 drivers/crypto/talitos/talitos.c      | 289 +-------------------------------
 drivers/crypto/talitos/talitos.h      |   8 +
 4 files changed, 316 insertions(+), 288 deletions(-)

diff --git a/drivers/crypto/talitos/Makefile b/drivers/crypto/talitos/Makefile
index 9e80bb094507..5f3bc89ad7ea 100644
--- a/drivers/crypto/talitos/Makefile
+++ b/drivers/crypto/talitos/Makefile
@@ -1,3 +1,5 @@
 obj-$(CONFIG_CRYPTO_DEV_TALITOS) += talitos.o
 
 talitos-y := talitos.o talitos-rng.o talitos-hash.o talitos-skcipher.o talitos-aead.o
+
+talitos-$(CONFIG_CRYPTO_DEV_TALITOS1) += talitos-sec1.o
diff --git a/drivers/crypto/talitos/talitos-sec1.c b/drivers/crypto/talitos/talitos-sec1.c
new file mode 100644
index 000000000000..695d531aa7f4
--- /dev/null
+++ b/drivers/crypto/talitos/talitos-sec1.c
@@ -0,0 +1,305 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+/*
+ * Freescale SEC (talitos) SEC1 specific driver code
+ *
+ * Copyright (c) 2006-2011 Freescale Semiconductor, Inc.
+ */
+
+#include <linux/io.h>
+#include <linux/of_irq.h>
+
+#include "talitos.h"
+
+#define DEF_TALITOS1_DONE(name, ch_done_mask)				\
+static void talitos1_done_##name(unsigned long data)			\
+{									\
+	struct device *dev = (struct device *)data;			\
+	struct talitos_private *priv = dev_get_drvdata(dev);		\
+	unsigned long flags;						\
+									\
+	if (ch_done_mask & 0x10000000)					\
+		talitos_flush_channel(dev, 0, 0, 0);			\
+	if (ch_done_mask & 0x40000000)					\
+		talitos_flush_channel(dev, 1, 0, 0);			\
+	if (ch_done_mask & 0x00010000)					\
+		talitos_flush_channel(dev, 2, 0, 0);			\
+	if (ch_done_mask & 0x00040000)					\
+		talitos_flush_channel(dev, 3, 0, 0);			\
+									\
+	/* At this point, all completed channels have been processed */	\
+	/* Unmask done interrupts for channels completed later on. */	\
+	spin_lock_irqsave(&priv->reg_lock, flags);			\
+	clrbits32(priv->reg + TALITOS_IMR, ch_done_mask);		\
+	clrbits32(priv->reg + TALITOS_IMR_LO, TALITOS1_IMR_LO_INIT);	\
+	spin_unlock_irqrestore(&priv->reg_lock, flags);			\
+}
+
+DEF_TALITOS1_DONE(4ch, TALITOS1_ISR_4CHDONE)
+DEF_TALITOS1_DONE(ch0, TALITOS1_ISR_CH_0_DONE)
+
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
+static int sec1_reset_device(struct device *dev)
+{
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	unsigned int timeout = TALITOS_TIMEOUT;
+
+	setbits32(priv->reg + TALITOS_MCR, TALITOS1_MCR_SWR);
+
+	while ((in_be32(priv->reg + TALITOS_MCR) & TALITOS1_MCR_SWR) &&
+	       --timeout)
+		cpu_relax();
+
+	if (timeout == 0) {
+		dev_err(dev, "failed to reset sec1 device\n");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int sec1_reset_channel(struct device *dev, int ch)
+{
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	unsigned int timeout = TALITOS_TIMEOUT;
+
+	setbits32(priv->chan[ch].reg + TALITOS_CCCR_LO, TALITOS1_CCCR_LO_RESET);
+
+	while ((in_be32(priv->chan[ch].reg + TALITOS_CCCR_LO) &
+		TALITOS1_CCCR_LO_RESET) &&
+	       --timeout)
+		cpu_relax();
+
+	if (timeout == 0) {
+		dev_err(dev, "failed to reset sec1 channel %d\n", ch);
+		return -EIO;
+	}
+
+	setbits32(priv->chan[ch].reg + TALITOS_CCCR_LO,
+		  TALITOS_CCCR_LO_NE | TALITOS_CCCR_LO_CDIE |
+			  TALITOS_CCCR_LO_CDWE);
+
+	return 0;
+}
+
+static void sec1_configure_device(struct device *dev)
+{
+	struct talitos_private *priv = dev_get_drvdata(dev);
+
+	clrbits32(priv->reg + TALITOS_IMR, TALITOS1_IMR_INIT);
+	clrbits32(priv->reg + TALITOS_IMR_LO, TALITOS1_IMR_LO_INIT);
+	/* disable parity error check in DEU (erroneous? test vect.) */
+	setbits32(priv->reg_deu + TALITOS_EUICR, TALITOS1_DEUICR_KPE);
+}
+
+static void sec1_dma_map_request(struct device *dev,
+				 struct talitos_request *request,
+				 struct talitos_desc *desc)
+{
+	struct talitos_edesc *edesc =
+		container_of(desc, struct talitos_edesc, desc);
+	dma_addr_t dma_desc, prev_dma_desc;
+	struct talitos_edesc *prev_edesc = NULL;
+
+	while (edesc) {
+		edesc->desc.hdr1 = edesc->desc.hdr;
+
+		dma_desc = dma_map_single(dev, &edesc->desc.hdr1,
+					  TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
+
+		if (!prev_edesc) {
+			request->dma_desc = dma_desc;
+			goto next;
+		}
+
+		/* Chain in any previous descriptors. */
+
+		prev_edesc->desc.next_desc = cpu_to_be32(dma_desc);
+
+		dma_sync_single_for_device(dev, prev_dma_desc,
+					   TALITOS_DESC_SIZE, DMA_TO_DEVICE);
+
+next:
+		prev_edesc = edesc;
+		prev_dma_desc = dma_desc;
+		edesc = edesc->next_desc;
+	}
+}
+
+static void sec1_dma_unmap_request(struct device *dev,
+				   struct talitos_request *request)
+{
+	struct talitos_edesc *edesc;
+
+	dma_unmap_single(dev, request->dma_desc, TALITOS_DESC_SIZE,
+			 DMA_BIDIRECTIONAL);
+	edesc = container_of(request->desc, struct talitos_edesc, desc);
+	while (edesc->next_desc) {
+		dma_unmap_single(dev, be32_to_cpu(edesc->desc.next_desc),
+				 TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
+		edesc = edesc->next_desc;
+	}
+}
+
+static __be32 sec1_get_request_hdr(struct device *dev,
+				   struct talitos_request *request)
+{
+	struct talitos_edesc *edesc;
+	dma_addr_t dma_desc;
+
+	edesc = container_of(request->desc, struct talitos_edesc, desc);
+	dma_desc = request->dma_desc;
+	while (edesc->next_desc) {
+		dma_desc = be32_to_cpu(edesc->desc.next_desc);
+		edesc = edesc->next_desc;
+	}
+
+	dma_sync_single_for_cpu(dev, dma_desc, TALITOS_DESC_SIZE,
+				DMA_BIDIRECTIONAL);
+
+	return edesc->desc.hdr1;
+}
+
+static __be32 sec1_search_desc_hdr_in_request(struct talitos_request *request,
+					      dma_addr_t cur_desc)
+{
+	struct talitos_edesc *edesc;
+
+
+	if (request->dma_desc == cur_desc)
+		return request->desc->hdr;
+
+	edesc = container_of(request->desc, struct talitos_edesc, desc);
+	while (edesc->next_desc) {
+		if (edesc->desc.next_desc == cpu_to_be32(cur_desc))
+			return edesc->next_desc->desc.hdr1;
+		edesc = edesc->next_desc;
+	}
+
+	return 0;
+}
+
+static int sec1_talitos_handle_error(struct device *dev, u32 isr, u32 isr_lo)
+{
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	int ch, error;
+	u32 v_lo;
+
+	for (ch = 0; ch < priv->num_channels; ch++) {
+		if (!TALITOS1_CH_HAS_ERROR(isr, ch))
+			continue;
+
+		v_lo = in_be32(priv->chan[ch].reg + TALITOS_CCPSR_LO);
+
+		error = -EINVAL;
+
+		if (v_lo & TALITOS1_CCPSR_LO_TEA)
+			dev_err(dev, "transfer error acknowledge\n");
+		if (v_lo & TALITOS1_CCPSR_LO_PTRNC)
+			dev_err(dev, "pointer not complete error\n");
+		if (v_lo & TALITOS1_CCPSR_LO_PE)
+			dev_err(dev, "parity error\n");
+		if (v_lo & TALITOS1_CCPSR_LO_IDH)
+			dev_err(dev, "illegal descriptor header error\n");
+		if (v_lo & TALITOS1_CCPSR_LO_SA)
+			dev_err(dev, "static assignment error\n");
+		if (v_lo & TALITOS1_CCPSR_LO_EU)
+			talitos_report_eu_error(
+				dev, ch, talitos_current_desc_hdr(dev, ch));
+
+		talitos_flush_channel(dev, ch, error, 1);
+		priv->ops->reset_channel(dev, ch);
+	}
+
+	if (isr_lo & TALITOS1_ISR_TEA_ERR)
+		dev_err(dev, "TEA error: ISR 0x%08x_%08x\n", isr, isr_lo);
+
+	return (isr & ~TALITOS1_ISR_4CHERR) || isr_lo;
+}
+
+static int sec1_talitos_probe_irq(struct platform_device *ofdev)
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
+	err = request_irq(priv->irq[0], talitos1_interrupt_4ch, 0,
+			  dev_driver_string(dev), dev);
+	if (err) {
+		dev_err(dev, "failed to request primary irq\n");
+		irq_dispose_mapping(priv->irq[0]);
+		priv->irq[0] = 0;
+	}
+
+	return err;
+}
+
+static void sec1_init_task(struct device *dev)
+{
+	struct talitos_private *priv = dev_get_drvdata(dev);
+
+	if (priv->num_channels == 1)
+		tasklet_init(&priv->done_task[0], talitos1_done_ch0,
+			     (unsigned long)dev);
+	else
+		tasklet_init(&priv->done_task[0], talitos1_done_4ch,
+			     (unsigned long)dev);
+}
+
+static const struct talitos_ops sec1_ops = {
+	.probe_irq = sec1_talitos_probe_irq,
+	.init_task = sec1_init_task,
+	.reset_device = sec1_reset_device,
+	.reset_channel = sec1_reset_channel,
+	.configure_device = sec1_configure_device,
+	.dma_map_request = sec1_dma_map_request,
+	.dma_unmap_request = sec1_dma_unmap_request,
+	.get_request_hdr = sec1_get_request_hdr,
+	.search_desc_hdr_in_request = sec1_search_desc_hdr_in_request,
+	.handle_error = sec1_talitos_handle_error,
+};
+
+void talitos_register_sec1(struct talitos_private *priv)
+{
+	priv->ops = &sec1_ops;
+}
diff --git a/drivers/crypto/talitos/talitos.c b/drivers/crypto/talitos/talitos.c
index 827d075ecfaa..a4fd14c8bef5 100644
--- a/drivers/crypto/talitos/talitos.c
+++ b/drivers/crypto/talitos/talitos.c
@@ -133,30 +133,6 @@ void unmap_single_talitos_ptr(struct device *dev,
 			 from_talitos_ptr_len(ptr, is_sec1), dir);
 }
 
-static int sec1_reset_channel(struct device *dev, int ch)
-{
-	struct talitos_private *priv = dev_get_drvdata(dev);
-	unsigned int timeout = TALITOS_TIMEOUT;
-
-	setbits32(priv->chan[ch].reg + TALITOS_CCCR_LO, TALITOS1_CCCR_LO_RESET);
-
-	while ((in_be32(priv->chan[ch].reg + TALITOS_CCCR_LO) &
-		TALITOS1_CCCR_LO_RESET) &&
-	       --timeout)
-		cpu_relax();
-
-	if (timeout == 0) {
-		dev_err(dev, "failed to reset sec1 channel %d\n", ch);
-		return -EIO;
-	}
-
-	setbits32(priv->chan[ch].reg + TALITOS_CCCR_LO,
-		  TALITOS_CCCR_LO_NE | TALITOS_CCCR_LO_CDIE |
-			  TALITOS_CCCR_LO_CDWE);
-
-	return 0;
-}
-
 static int sec2_reset_channel(struct device *dev, int ch)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
@@ -186,25 +162,6 @@ static int sec2_reset_channel(struct device *dev, int ch)
 	return 0;
 }
 
-static int sec1_reset_device(struct device *dev)
-{
-	struct talitos_private *priv = dev_get_drvdata(dev);
-	unsigned int timeout = TALITOS_TIMEOUT;
-
-	setbits32(priv->reg + TALITOS_MCR, TALITOS1_MCR_SWR);
-
-	while ((in_be32(priv->reg + TALITOS_MCR) & TALITOS1_MCR_SWR) &&
-	       --timeout)
-		cpu_relax();
-
-	if (timeout == 0) {
-		dev_err(dev, "failed to reset sec1 device\n");
-		return -EIO;
-	}
-
-	return 0;
-}
-
 static int sec2_reset_device(struct device *dev)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
@@ -228,16 +185,6 @@ static int sec2_reset_device(struct device *dev)
 	return 0;
 }
 
-static void sec1_configure_device(struct device *dev)
-{
-	struct talitos_private *priv = dev_get_drvdata(dev);
-
-	clrbits32(priv->reg + TALITOS_IMR, TALITOS1_IMR_INIT);
-	clrbits32(priv->reg + TALITOS_IMR_LO, TALITOS1_IMR_LO_INIT);
-	/* disable parity error check in DEU (erroneous? test vect.) */
-	setbits32(priv->reg_deu + TALITOS_EUICR, TALITOS1_DEUICR_KPE);
-}
-
 static void sec2_configure_device(struct device *dev)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
@@ -286,40 +233,6 @@ static int init_device(struct device *dev)
 	return 0;
 }
 
-static void sec1_dma_map_request(struct device *dev,
-				 struct talitos_request *request,
-				 struct talitos_desc *desc)
-{
-	struct talitos_edesc *edesc =
-		container_of(desc, struct talitos_edesc, desc);
-	dma_addr_t dma_desc, prev_dma_desc;
-	struct talitos_edesc *prev_edesc = NULL;
-
-	while (edesc) {
-		edesc->desc.hdr1 = edesc->desc.hdr;
-
-		dma_desc = dma_map_single(dev, &edesc->desc.hdr1,
-					  TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
-
-		if (!prev_edesc) {
-			request->dma_desc = dma_desc;
-			goto next;
-		}
-
-		/* Chain in any previous descriptors. */
-
-		prev_edesc->desc.next_desc = cpu_to_be32(dma_desc);
-
-		dma_sync_single_for_device(dev, prev_dma_desc,
-					   TALITOS_DESC_SIZE, DMA_TO_DEVICE);
-
-next:
-		prev_edesc = edesc;
-		prev_dma_desc = dma_desc;
-		edesc = edesc->next_desc;
-	}
-}
-
 static void sec2_dma_map_request(struct device *dev,
 				 struct talitos_request *request,
 				 struct talitos_desc *desc)
@@ -386,25 +299,6 @@ int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
 	return -EINPROGRESS;
 }
 
-static __be32 sec1_get_request_hdr(struct device *dev,
-				   struct talitos_request *request)
-{
-	struct talitos_edesc *edesc;
-	dma_addr_t dma_desc;
-
-	edesc = container_of(request->desc, struct talitos_edesc, desc);
-	dma_desc = request->dma_desc;
-	while (edesc->next_desc) {
-		dma_desc = be32_to_cpu(edesc->desc.next_desc);
-		edesc = edesc->next_desc;
-	}
-
-	dma_sync_single_for_cpu(dev, dma_desc, TALITOS_DESC_SIZE,
-				DMA_BIDIRECTIONAL);
-
-	return edesc->desc.hdr1;
-}
-
 static __be32 sec2_get_request_hdr(struct device *dev,
 				   struct talitos_request *request)
 {
@@ -414,21 +308,6 @@ static __be32 sec2_get_request_hdr(struct device *dev,
 	return request->desc->hdr;
 }
 
-static void sec1_dma_unmap_request(struct device *dev,
-				   struct talitos_request *request)
-{
-	struct talitos_edesc *edesc;
-
-	dma_unmap_single(dev, request->dma_desc, TALITOS_DESC_SIZE,
-			 DMA_BIDIRECTIONAL);
-	edesc = container_of(request->desc, struct talitos_edesc, desc);
-	while (edesc->next_desc) {
-		dma_unmap_single(dev, be32_to_cpu(edesc->desc.next_desc),
-				 TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
-		edesc = edesc->next_desc;
-	}
-}
-
 static void sec2_dma_unmap_request(struct device *dev,
 				   struct talitos_request *request)
 {
@@ -499,32 +378,6 @@ void talitos_flush_channel(struct device *dev, int ch, int error, int reset_ch)
 /*
  * process completed requests for channels that have done status
  */
-#define DEF_TALITOS1_DONE(name, ch_done_mask)				\
-static void talitos1_done_##name(unsigned long data)			\
-{									\
-	struct device *dev = (struct device *)data;			\
-	struct talitos_private *priv = dev_get_drvdata(dev);		\
-	unsigned long flags;						\
-									\
-	if (ch_done_mask & 0x10000000)					\
-		talitos_flush_channel(dev, 0, 0, 0);			\
-	if (ch_done_mask & 0x40000000)					\
-		talitos_flush_channel(dev, 1, 0, 0);			\
-	if (ch_done_mask & 0x00010000)					\
-		talitos_flush_channel(dev, 2, 0, 0);			\
-	if (ch_done_mask & 0x00040000)					\
-		talitos_flush_channel(dev, 3, 0, 0);			\
-									\
-	/* At this point, all completed channels have been processed */	\
-	/* Unmask done interrupts for channels completed later on. */	\
-	spin_lock_irqsave(&priv->reg_lock, flags);			\
-	clrbits32(priv->reg + TALITOS_IMR, ch_done_mask);		\
-	clrbits32(priv->reg + TALITOS_IMR_LO, TALITOS1_IMR_LO_INIT);	\
-	spin_unlock_irqrestore(&priv->reg_lock, flags);			\
-}
-
-DEF_TALITOS1_DONE(4ch, TALITOS1_ISR_4CHDONE)
-DEF_TALITOS1_DONE(ch0, TALITOS1_ISR_CH_0_DONE)
 
 #define DEF_TALITOS2_DONE(name, ch_done_mask)				\
 static void talitos2_done_##name(unsigned long data)			\
@@ -555,25 +408,6 @@ DEF_TALITOS2_DONE(ch0, TALITOS2_ISR_CH_0_DONE)
 DEF_TALITOS2_DONE(ch0_2, TALITOS2_ISR_CH_0_2_DONE)
 DEF_TALITOS2_DONE(ch1_3, TALITOS2_ISR_CH_1_3_DONE)
 
-static __be32 sec1_search_desc_hdr_in_request(struct talitos_request *request,
-					      dma_addr_t cur_desc)
-{
-	struct talitos_edesc *edesc;
-
-
-	if (request->dma_desc == cur_desc)
-		return request->desc->hdr;
-
-	edesc = container_of(request->desc, struct talitos_edesc, desc);
-	while (edesc->next_desc) {
-		if (edesc->desc.next_desc == cpu_to_be32(cur_desc))
-			return edesc->next_desc->desc.hdr1;
-		edesc = edesc->next_desc;
-	}
-
-	return 0;
-}
-
 static __be32 sec2_search_desc_hdr_in_request(struct talitos_request *request,
 					      dma_addr_t cur_desc)
 {
@@ -694,44 +528,6 @@ void talitos_report_eu_error(struct device *dev, int ch, __be32 desc_hdr)
 			in_be32(priv->chan[ch].reg + TALITOS_DESCBUF_LO + 8*i));
 }
 
-static int sec1_talitos_handle_error(struct device *dev, u32 isr, u32 isr_lo)
-{
-	struct talitos_private *priv = dev_get_drvdata(dev);
-	int ch, error;
-	u32 v_lo;
-
-	for (ch = 0; ch < priv->num_channels; ch++) {
-		if (!TALITOS1_CH_HAS_ERROR(isr, ch))
-			continue;
-
-		v_lo = in_be32(priv->chan[ch].reg + TALITOS_CCPSR_LO);
-
-		error = -EINVAL;
-
-		if (v_lo & TALITOS1_CCPSR_LO_TEA)
-			dev_err(dev, "transfer error acknowledge\n");
-		if (v_lo & TALITOS1_CCPSR_LO_PTRNC)
-			dev_err(dev, "pointer not complete error\n");
-		if (v_lo & TALITOS1_CCPSR_LO_PE)
-			dev_err(dev, "parity error\n");
-		if (v_lo & TALITOS1_CCPSR_LO_IDH)
-			dev_err(dev, "illegal descriptor header error\n");
-		if (v_lo & TALITOS1_CCPSR_LO_SA)
-			dev_err(dev, "static assignment error\n");
-		if (v_lo & TALITOS1_CCPSR_LO_EU)
-			talitos_report_eu_error(
-				dev, ch, talitos_current_desc_hdr(dev, ch));
-
-		talitos_flush_channel(dev, ch, error, 1);
-		priv->ops->reset_channel(dev, ch);
-	}
-
-	if (isr_lo & TALITOS1_ISR_TEA_ERR)
-		dev_err(dev, "TEA error: ISR 0x%08x_%08x\n", isr, isr_lo);
-
-	return (isr & ~TALITOS1_ISR_4CHERR) || isr_lo;
-}
-
 static int sec2_talitos_handle_error(struct device *dev, u32 isr, u32 isr_lo)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
@@ -827,41 +623,6 @@ void talitos_error(struct device *dev, u32 isr, u32 isr_lo)
 	}
 }
 
-#define DEF_TALITOS1_INTERRUPT(name, ch_done_mask, ch_err_mask, tlet)	       \
-static irqreturn_t talitos1_interrupt_##name(int irq, void *data)	       \
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
-	if (unlikely(isr & ch_err_mask || isr_lo & TALITOS1_IMR_LO_INIT)) {    \
-		spin_unlock_irqrestore(&priv->reg_lock, flags);		       \
-		talitos_error(dev, isr & ch_err_mask, isr_lo);		       \
-	}								       \
-	else {								       \
-		if (likely(isr & ch_done_mask)) {			       \
-			/* mask further done interrupts. */		       \
-			setbits32(priv->reg + TALITOS_IMR, ch_done_mask);      \
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
-DEF_TALITOS1_INTERRUPT(4ch, TALITOS1_ISR_4CHDONE, TALITOS1_ISR_4CHERR, 0)
-
 #define DEF_TALITOS2_INTERRUPT(name, ch_done_mask, ch_err_mask, tlet)	       \
 static irqreturn_t talitos2_interrupt_##name(int irq, void *data)	       \
 {									       \
@@ -1262,29 +1023,6 @@ int talitos_register_common(struct device *dev,
 	return 0;
 }
 
-static int sec1_talitos_probe_irq(struct platform_device *ofdev)
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
-	err = request_irq(priv->irq[0], talitos1_interrupt_4ch, 0,
-			  dev_driver_string(dev), dev);
-	if (err) {
-		dev_err(dev, "failed to request primary irq\n");
-		irq_dispose_mapping(priv->irq[0]);
-		priv->irq[0] = 0;
-	}
-
-	return err;
-}
-
 static int sec2_talitos_probe_irq(struct platform_device *ofdev)
 {
 	struct device *dev = &ofdev->dev;
@@ -1332,18 +1070,6 @@ static int sec2_talitos_probe_irq(struct platform_device *ofdev)
 	return err;
 }
 
-static void sec1_init_task(struct device *dev)
-{
-	struct talitos_private *priv = dev_get_drvdata(dev);
-
-	if (priv->num_channels == 1)
-		tasklet_init(&priv->done_task[0], talitos1_done_ch0,
-			     (unsigned long)dev);
-	else
-		tasklet_init(&priv->done_task[0], talitos1_done_4ch,
-			     (unsigned long)dev);
-}
-
 static void sec2_init_task(struct device *dev)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
@@ -1362,19 +1088,6 @@ static void sec2_init_task(struct device *dev)
 	}
 }
 
-static const struct talitos_ops sec1_ops = {
-	.probe_irq = sec1_talitos_probe_irq,
-	.init_task = sec1_init_task,
-	.reset_device = sec1_reset_device,
-	.reset_channel = sec1_reset_channel,
-	.configure_device = sec1_configure_device,
-	.dma_map_request = sec1_dma_map_request,
-	.dma_unmap_request = sec1_dma_unmap_request,
-	.get_request_hdr = sec1_get_request_hdr,
-	.search_desc_hdr_in_request = sec1_search_desc_hdr_in_request,
-	.handle_error = sec1_talitos_handle_error,
-};
-
 static const struct talitos_ops sec2_ops = {
 	.probe_irq = sec2_talitos_probe_irq,
 	.init_task = sec2_init_task,
@@ -1471,7 +1184,7 @@ static int talitos_probe(struct platform_device *ofdev)
 	}
 
 	if (has_ftr_sec1(priv))
-		priv->ops = &sec1_ops;
+		talitos_register_sec1(priv);
 	else
 		priv->ops = &sec2_ops;
 
diff --git a/drivers/crypto/talitos/talitos.h b/drivers/crypto/talitos/talitos.h
index 98b2cb5115f8..f5e98050c4cb 100644
--- a/drivers/crypto/talitos/talitos.h
+++ b/drivers/crypto/talitos/talitos.h
@@ -566,6 +566,14 @@ __be32 talitos_current_desc_hdr(struct device *dev, int ch);
 void talitos_error(struct device *dev, u32 isr, u32 isr_lo);
 void talitos_report_eu_error(struct device *dev, int ch, __be32 desc_hdr);
 
+#ifdef CONFIG_CRYPTO_DEV_TALITOS1
+void talitos_register_sec1(struct talitos_private *priv);
+#else
+static inline void talitos_register_sec1(struct talitos_private *priv)
+{
+}
+#endif
+
 /* Hardware RNG */
 
 int talitos_register_rng(struct device *dev);

-- 
2.54.0

