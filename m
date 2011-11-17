From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 3/5] crypto: talitos - prepare driver for channel remap
 support
Date: Wed, 16 Nov 2011 18:19:33 -0600
Message-ID: <20111116181933.2a987af9b27d4f8476a42607@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:52865
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754701Ab1KQAUd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Nov 2011 19:20:33 -0500
Received: from mail41-va3 (localhost [127.0.0.1])	by mail41-va3-R.bigfish.com
 (Postfix) with ESMTP id 544D44402B0	for <linux-crypto@vger.kernel.org>; Thu,
 17 Nov 2011 00:19:45 +0000 (UTC)
Received: from VA3EHSMHS028.bigfish.com (unknown [10.7.14.250])	by
 mail41-va3.bigfish.com (Postfix) with ESMTP id D46EB5C0047	for
 <linux-crypto@vger.kernel.org>; Thu, 17 Nov 2011 00:19:44 +0000 (UTC)
Received: from x9 (x9.am.freescale.net [10.82.120.9])	by
 az33smr02.freescale.net (8.13.1/8.13.0) with SMTP id pAH0KT0B027495	for
 <linux-crypto@vger.kernel.org>; Wed, 16 Nov 2011 18:20:29 -0600 (CST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add a reg member to the channel struct and use it to
access channels.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/talitos.c |   37 ++++++++++++++++++++++---------------
 drivers/crypto/talitos.h |   31 ++++++++++++++++---------------
 2 files changed, 38 insertions(+), 30 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index c372a18..7f82e91 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -99,6 +99,8 @@ struct talitos_request {
 
 /* per-channel fifo management */
 struct talitos_channel {
+	void __iomem *reg;
+
 	/* request fifo */
 	struct talitos_request *fifo;
 
@@ -197,9 +199,9 @@ static int reset_channel(struct device *dev, int ch)
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	unsigned int timeout = TALITOS_TIMEOUT;
 
-	setbits32(priv->reg + TALITOS_CCCR(ch), TALITOS_CCCR_RESET);
+	setbits32(priv->chan[ch].reg + TALITOS_CCCR, TALITOS_CCCR_RESET);
 
-	while ((in_be32(priv->reg + TALITOS_CCCR(ch)) & TALITOS_CCCR_RESET)
+	while ((in_be32(priv->chan[ch].reg + TALITOS_CCCR) & TALITOS_CCCR_RESET)
 	       && --timeout)
 		cpu_relax();
 
@@ -209,12 +211,12 @@ static int reset_channel(struct device *dev, int ch)
 	}
 
 	/* set 36-bit addressing, done writeback enable and done IRQ enable */
-	setbits32(priv->reg + TALITOS_CCCR_LO(ch), TALITOS_CCCR_LO_EAE |
+	setbits32(priv->chan[ch].reg + TALITOS_CCCR_LO, TALITOS_CCCR_LO_EAE |
 		  TALITOS_CCCR_LO_CDWE | TALITOS_CCCR_LO_CDIE);
 
 	/* and ICCR writeback, if available */
 	if (priv->features & TALITOS_FTR_HW_AUTH_CHECK)
-		setbits32(priv->reg + TALITOS_CCCR_LO(ch),
+		setbits32(priv->chan[ch].reg + TALITOS_CCCR_LO,
 		          TALITOS_CCCR_LO_IWSE);
 
 	return 0;
@@ -328,8 +330,9 @@ static int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
 
 	/* GO! */
 	wmb();
-	out_be32(priv->reg + TALITOS_FF(ch), upper_32_bits(request->dma_desc));
-	out_be32(priv->reg + TALITOS_FF_LO(ch),
+	out_be32(priv->chan[ch].reg + TALITOS_FF,
+		 upper_32_bits(request->dma_desc));
+	out_be32(priv->chan[ch].reg + TALITOS_FF_LO,
 		 lower_32_bits(request->dma_desc));
 
 	spin_unlock_irqrestore(&priv->chan[ch].head_lock, flags);
@@ -423,7 +426,7 @@ static u32 current_desc_hdr(struct device *dev, int ch)
 	int tail = priv->chan[ch].tail;
 	dma_addr_t cur_desc;
 
-	cur_desc = in_be32(priv->reg + TALITOS_CDPR_LO(ch));
+	cur_desc = in_be32(priv->chan[ch].reg + TALITOS_CDPR_LO);
 
 	while (priv->chan[ch].fifo[tail].dma_desc != cur_desc) {
 		tail = (tail + 1) & (priv->fifo_len - 1);
@@ -445,7 +448,7 @@ static void report_eu_error(struct device *dev, int ch, u32 desc_hdr)
 	int i;
 
 	if (!desc_hdr)
-		desc_hdr = in_be32(priv->reg + TALITOS_DESCBUF(ch));
+		desc_hdr = in_be32(priv->chan[ch].reg + TALITOS_DESCBUF);
 
 	switch (desc_hdr & DESC_HDR_SEL0_MASK) {
 	case DESC_HDR_SEL0_AFEU:
@@ -507,8 +510,8 @@ static void report_eu_error(struct device *dev, int ch, u32 desc_hdr)
 
 	for (i = 0; i < 8; i++)
 		dev_err(dev, "DESCBUF 0x%08x_%08x\n",
-			in_be32(priv->reg + TALITOS_DESCBUF(ch) + 8*i),
-			in_be32(priv->reg + TALITOS_DESCBUF_LO(ch) + 8*i));
+			in_be32(priv->chan[ch].reg + TALITOS_DESCBUF + 8*i),
+			in_be32(priv->chan[ch].reg + TALITOS_DESCBUF_LO + 8*i));
 }
 
 /*
@@ -529,8 +532,8 @@ static void talitos_error(unsigned long data, u32 isr, u32 isr_lo)
 
 		error = -EINVAL;
 
-		v = in_be32(priv->reg + TALITOS_CCPSR(ch));
-		v_lo = in_be32(priv->reg + TALITOS_CCPSR_LO(ch));
+		v = in_be32(priv->chan[ch].reg + TALITOS_CCPSR);
+		v_lo = in_be32(priv->chan[ch].reg + TALITOS_CCPSR_LO);
 
 		if (v_lo & TALITOS_CCPSR_LO_DOF) {
 			dev_err(dev, "double fetch fifo overflow error\n");
@@ -568,10 +571,10 @@ static void talitos_error(unsigned long data, u32 isr, u32 isr_lo)
 		if (reset_ch) {
 			reset_channel(dev, ch);
 		} else {
-			setbits32(priv->reg + TALITOS_CCCR(ch),
+			setbits32(priv->chan[ch].reg + TALITOS_CCCR,
 				  TALITOS_CCCR_CONT);
-			setbits32(priv->reg + TALITOS_CCCR_LO(ch), 0);
-			while ((in_be32(priv->reg + TALITOS_CCCR(ch)) &
+			setbits32(priv->chan[ch].reg + TALITOS_CCCR_LO, 0);
+			while ((in_be32(priv->chan[ch].reg + TALITOS_CCCR) &
 			       TALITOS_CCCR_CONT) && --timeout)
 				cpu_relax();
 			if (timeout == 0) {
@@ -2710,6 +2713,10 @@ static int talitos_probe(struct platform_device *ofdev)
 		goto err_out;
 	}
 
+	for (i = 0; i < priv->num_channels; i++)
+		priv->chan[i].reg = priv->reg + TALITOS_CH_BASE_OFFSET +
+				    TALITOS_CH_STRIDE * (i + 1);
+
 	for (i = 0; i < priv->num_channels; i++) {
 		spin_lock_init(&priv->chan[i].head_lock);
 		spin_lock_init(&priv->chan[i].tail_lock);
diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index 0b746ac..3ed319d 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -1,7 +1,7 @@
 /*
  * Freescale SEC (talitos) device register and descriptor header defines
  *
- * Copyright (c) 2006-2010 Freescale Semiconductor, Inc.
+ * Copyright (c) 2006-2011 Freescale Semiconductor, Inc.
  *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
@@ -49,13 +49,14 @@
 #define TALITOS_ICR_LO			0x101C
 
 /* channel register address stride */
+#define TALITOS_CH_BASE_OFFSET		0x1000	/* default channel map base */
 #define TALITOS_CH_STRIDE		0x100
 
 /* channel configuration register  */
-#define TALITOS_CCCR(ch)		(ch * TALITOS_CH_STRIDE + 0x1108)
+#define TALITOS_CCCR			0x8
 #define   TALITOS_CCCR_CONT		0x2    /* channel continue */
 #define   TALITOS_CCCR_RESET		0x1    /* channel reset */
-#define TALITOS_CCCR_LO(ch)		(ch * TALITOS_CH_STRIDE + 0x110c)
+#define TALITOS_CCCR_LO			0xc
 #define   TALITOS_CCCR_LO_IWSE		0x80   /* chan. ICCR writeback enab. */
 #define   TALITOS_CCCR_LO_EAE		0x20   /* extended address enable */
 #define   TALITOS_CCCR_LO_CDWE		0x10   /* chan. done writeback enab. */
@@ -63,8 +64,8 @@
 #define   TALITOS_CCCR_LO_CDIE		0x2    /* channel done IRQ enable */
 
 /* CCPSR: channel pointer status register */
-#define TALITOS_CCPSR(ch)		(ch * TALITOS_CH_STRIDE + 0x1110)
-#define TALITOS_CCPSR_LO(ch)		(ch * TALITOS_CH_STRIDE + 0x1114)
+#define TALITOS_CCPSR			0x10
+#define TALITOS_CCPSR_LO		0x14
 #define   TALITOS_CCPSR_LO_DOF		0x8000 /* double FF write oflow error */
 #define   TALITOS_CCPSR_LO_SOF		0x4000 /* single FF write oflow error */
 #define   TALITOS_CCPSR_LO_MDTE		0x2000 /* master data transfer error */
@@ -79,24 +80,24 @@
 #define   TALITOS_CCPSR_LO_SRL		0x0010 /* scatter return/length error */
 
 /* channel fetch fifo register */
-#define TALITOS_FF(ch)			(ch * TALITOS_CH_STRIDE + 0x1148)
-#define TALITOS_FF_LO(ch)		(ch * TALITOS_CH_STRIDE + 0x114c)
+#define TALITOS_FF			0x48
+#define TALITOS_FF_LO			0x4c
 
 /* current descriptor pointer register */
-#define TALITOS_CDPR(ch)		(ch * TALITOS_CH_STRIDE + 0x1140)
-#define TALITOS_CDPR_LO(ch)		(ch * TALITOS_CH_STRIDE + 0x1144)
+#define TALITOS_CDPR			0x40
+#define TALITOS_CDPR_LO			0x44
 
 /* descriptor buffer register */
-#define TALITOS_DESCBUF(ch)		(ch * TALITOS_CH_STRIDE + 0x1180)
-#define TALITOS_DESCBUF_LO(ch)		(ch * TALITOS_CH_STRIDE + 0x1184)
+#define TALITOS_DESCBUF			0x80
+#define TALITOS_DESCBUF_LO		0x84
 
 /* gather link table */
-#define TALITOS_GATHER(ch)		(ch * TALITOS_CH_STRIDE + 0x11c0)
-#define TALITOS_GATHER_LO(ch)		(ch * TALITOS_CH_STRIDE + 0x11c4)
+#define TALITOS_GATHER			0xc0
+#define TALITOS_GATHER_LO		0xc4
 
 /* scatter link table */
-#define TALITOS_SCATTER(ch)		(ch * TALITOS_CH_STRIDE + 0x11e0)
-#define TALITOS_SCATTER_LO(ch)		(ch * TALITOS_CH_STRIDE + 0x11e4)
+#define TALITOS_SCATTER			0xe0
+#define TALITOS_SCATTER_LO		0xe4
 
 /* execution unit interrupt status registers */
 #define TALITOS_DEUISR			0x2030 /* DES unit */
-- 
1.7.7
