Return-Path: <SRS0=4a8U=XB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B668C43331
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 15:34:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA27520838
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 15:34:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AbXjt0Qj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394764AbfIFPem (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Sep 2019 11:34:42 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:44523 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394868AbfIFPem (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Sep 2019 11:34:42 -0400
Received: by mail-ed1-f67.google.com with SMTP id p2so5493753edx.11
        for <linux-crypto@vger.kernel.org>; Fri, 06 Sep 2019 08:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nuBODiQS+dIFCr86SVLtzK9jPi6yygw3exLqu21uB0c=;
        b=AbXjt0Qjm5oXzMCzSL/s/kF7dqOu0X8mTQ1bk3kPHzb5JCpEDvN14fuTdryNUYvdrz
         4OnNfE/UMMqWUHVKjTyAlg+LxeB5rVznm3r/mb/ljPS5Ki/wJMH2iJ4A/98QEefg6A2u
         xBgjuS+rtzbA7bJukU2WBA7mwDGNs7Kwcigsv+VqRNMUwAUgkBTfqZu56kZ89s+EIN+2
         aZVsK9YX7OrJa38LGyINFiJAxgTPiGVAZe+ZpIi2LpPhHuYH/66xu8IW8p4/GsWAZvYm
         0XcN88VojtXZIQ+hZWRuw0txWaiTpGHGOGiCQyG4p9zH6Z2clSzvgoJ2L3bhysGGkJ58
         PkcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nuBODiQS+dIFCr86SVLtzK9jPi6yygw3exLqu21uB0c=;
        b=ckKlbmS4FCsO4cQIz9lyp06eKl0h/ZxZjqCL8Pif7e8in+kuDSppYT81DALt7BSMbq
         f+cqPEx8HRufEYk9n4fOQ3MLk/1EiBvn15WDaDiy47C5DBulQtxfJFYkpNvnWCjoBk8M
         oTAlEZQD4l1+Q0O1VJ+n3xP8+91j5Lvh5aPEerRFISyd3l4AdEiykcReHpOugflHMiLD
         goIOleKQvyytVlqT+OO2Ln9saOlm+G2mXuUwF7dfZVXQGLuF5Mm7Q83++1ECUyTv5nl9
         5eCbabJacB5QvZE00tmeVVbGv2dS6tJZ6JwnXAZXJF3WN5Orak1YrCuyloEklrVe+9Bg
         0omg==
X-Gm-Message-State: APjAAAWLrvt0ywrx+fX6HVl5Utlnzztvq/PtNoa894nQSwi7FmkuIC+D
        xmkMzY4+tU+Orzsx7ttC3pk3iGO2
X-Google-Smtp-Source: APXvYqxbfqvq65AjdHr3Xo2A67oWSYDrYcBWJet4WzPEim3EjAdL3RHOcj8zdYsUDvrGeyJiTQMw2g==
X-Received: by 2002:a05:6402:1845:: with SMTP id v5mr5194867edy.130.1567784079588;
        Fri, 06 Sep 2019 08:34:39 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id c22sm995218eds.30.2019.09.06.08.34.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 08:34:39 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 1/6] crypto: inside-secure - Add EIP97/EIP197 and endianness detection
Date:   Fri,  6 Sep 2019 16:31:48 +0200
Message-Id: <1567780313-1579-2-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567780313-1579-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1567780313-1579-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds automatic EIP97/EIP197 detection, so it does not need to
rely on any static value from the device table anymore. In particular,
the static value from the table won't work for PCI devboards that cannot
be further identified save from this direct hardware probing.

The patch also adds automatic host xs endianness detection & correction.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c | 154 ++++++++++++++++++++++----------
 drivers/crypto/inside-secure/safexcel.h |  26 +++++-
 2 files changed, 130 insertions(+), 50 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 2fdb188..7a37c40 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -393,29 +393,21 @@ static int safexcel_hw_setup_rdesc_rings(struct safexcel_crypto_priv *priv)
 
 static int safexcel_hw_init(struct safexcel_crypto_priv *priv)
 {
-	u32 version, val;
+	u32 val;
 	int i, ret, pe;
 
 	dev_dbg(priv->dev, "HW init: using %d pipe(s) and %d ring(s)\n",
 		priv->config.pes, priv->config.rings);
 
-	/* Determine endianess and configure byte swap */
-	version = readl(EIP197_HIA_AIC(priv) + EIP197_HIA_VERSION);
-	val = readl(EIP197_HIA_AIC(priv) + EIP197_HIA_MST_CTRL);
-
-	if ((version & 0xffff) == EIP197_HIA_VERSION_BE)
-		val |= EIP197_MST_CTRL_BYTE_SWAP;
-	else if (((version >> 16) & 0xffff) == EIP197_HIA_VERSION_LE)
-		val |= (EIP197_MST_CTRL_NO_BYTE_SWAP >> 24);
-
 	/*
 	 * For EIP197's only set maximum number of TX commands to 2^5 = 32
 	 * Skip for the EIP97 as it does not have this field.
 	 */
-	if (priv->version != EIP97IES_MRVL)
+	if (priv->flags & SAFEXCEL_HW_EIP197) {
+		val = readl(EIP197_HIA_AIC(priv) + EIP197_HIA_MST_CTRL);
 		val |= EIP197_MST_CTRL_TX_MAX_CMD(5);
-
-	writel(val, EIP197_HIA_AIC(priv) + EIP197_HIA_MST_CTRL);
+		writel(val, EIP197_HIA_AIC(priv) + EIP197_HIA_MST_CTRL);
+	}
 
 	/* Configure wr/rd cache values */
 	writel(EIP197_MST_CTRL_RD_CACHE(RD_CACHE_4BITS) |
@@ -438,7 +430,7 @@ static int safexcel_hw_init(struct safexcel_crypto_priv *priv)
 		writel(EIP197_DxE_THR_CTRL_RESET_PE,
 		       EIP197_HIA_DFE_THR(priv) + EIP197_HIA_DFE_THR_CTRL(pe));
 
-		if (priv->version != EIP97IES_MRVL)
+		if (priv->flags & SAFEXCEL_HW_EIP197)
 			/* Reset HIA input interface arbiter (EIP197 only) */
 			writel(EIP197_HIA_RA_PE_CTRL_RESET,
 			       EIP197_HIA_AIC(priv) + EIP197_HIA_RA_PE_CTRL(pe));
@@ -464,7 +456,7 @@ static int safexcel_hw_init(struct safexcel_crypto_priv *priv)
 		       EIP197_PE_IN_xBUF_THRES_MAX(7),
 		       EIP197_PE(priv) + EIP197_PE_IN_TBUF_THRES(pe));
 
-		if (priv->version != EIP97IES_MRVL)
+		if (priv->flags & SAFEXCEL_HW_EIP197)
 			/* enable HIA input interface arbiter and rings */
 			writel(EIP197_HIA_RA_PE_CTRL_EN |
 			       GENMASK(priv->config.rings - 1, 0),
@@ -490,7 +482,7 @@ static int safexcel_hw_init(struct safexcel_crypto_priv *priv)
 		/* FIXME: instability issues can occur for EIP97 but disabling
 		 * it impacts performance.
 		 */
-		if (priv->version != EIP97IES_MRVL)
+		if (priv->flags & SAFEXCEL_HW_EIP197)
 			val |= EIP197_HIA_DSE_CFG_EN_SINGLE_WR;
 		writel(val, EIP197_HIA_DSE(priv) + EIP197_HIA_DSE_CFG(pe));
 
@@ -577,8 +569,9 @@ static int safexcel_hw_init(struct safexcel_crypto_priv *priv)
 	/* Clear any HIA interrupt */
 	writel(GENMASK(30, 20), EIP197_HIA_AIC_G(priv) + EIP197_HIA_AIC_G_ACK);
 
-	if (priv->version != EIP97IES_MRVL) {
+	if (priv->flags & SAFEXCEL_HW_EIP197) {
 		eip197_trc_cache_init(priv);
+		priv->flags |= EIP197_TRC_CACHE;
 
 		ret = eip197_load_firmwares(priv);
 		if (ret)
@@ -1087,12 +1080,12 @@ static void safexcel_configure(struct safexcel_crypto_priv *priv)
 	val = readl(EIP197_HIA_AIC_G(priv) + EIP197_HIA_OPTIONS);
 
 	/* Read number of PEs from the engine */
-	if (priv->version == EIP97IES_MRVL)
-		/* Narrow field width for EIP97 type engine */
-		mask = EIP97_N_PES_MASK;
-	else
+	if (priv->flags & SAFEXCEL_HW_EIP197)
 		/* Wider field width for all EIP197 type engines */
 		mask = EIP197_N_PES_MASK;
+	else
+		/* Narrow field width for EIP97 type engine */
+		mask = EIP97_N_PES_MASK;
 
 	priv->config.pes = (val >> EIP197_N_PES_OFFSET) & mask;
 
@@ -1112,18 +1105,7 @@ static void safexcel_init_register_offsets(struct safexcel_crypto_priv *priv)
 {
 	struct safexcel_register_offsets *offsets = &priv->offsets;
 
-	if (priv->version == EIP97IES_MRVL) {
-		offsets->hia_aic	= EIP97_HIA_AIC_BASE;
-		offsets->hia_aic_g	= EIP97_HIA_AIC_G_BASE;
-		offsets->hia_aic_r	= EIP97_HIA_AIC_R_BASE;
-		offsets->hia_aic_xdr	= EIP97_HIA_AIC_xDR_BASE;
-		offsets->hia_dfe	= EIP97_HIA_DFE_BASE;
-		offsets->hia_dfe_thr	= EIP97_HIA_DFE_THR_BASE;
-		offsets->hia_dse	= EIP97_HIA_DSE_BASE;
-		offsets->hia_dse_thr	= EIP97_HIA_DSE_THR_BASE;
-		offsets->hia_gen_cfg	= EIP97_HIA_GEN_CFG_BASE;
-		offsets->pe		= EIP97_PE_BASE;
-	} else {
+	if (priv->flags & SAFEXCEL_HW_EIP197) {
 		offsets->hia_aic	= EIP197_HIA_AIC_BASE;
 		offsets->hia_aic_g	= EIP197_HIA_AIC_G_BASE;
 		offsets->hia_aic_r	= EIP197_HIA_AIC_R_BASE;
@@ -1134,6 +1116,19 @@ static void safexcel_init_register_offsets(struct safexcel_crypto_priv *priv)
 		offsets->hia_dse_thr	= EIP197_HIA_DSE_THR_BASE;
 		offsets->hia_gen_cfg	= EIP197_HIA_GEN_CFG_BASE;
 		offsets->pe		= EIP197_PE_BASE;
+		offsets->global		= EIP197_GLOBAL_BASE;
+	} else {
+		offsets->hia_aic	= EIP97_HIA_AIC_BASE;
+		offsets->hia_aic_g	= EIP97_HIA_AIC_G_BASE;
+		offsets->hia_aic_r	= EIP97_HIA_AIC_R_BASE;
+		offsets->hia_aic_xdr	= EIP97_HIA_AIC_xDR_BASE;
+		offsets->hia_dfe	= EIP97_HIA_DFE_BASE;
+		offsets->hia_dfe_thr	= EIP97_HIA_DFE_THR_BASE;
+		offsets->hia_dse	= EIP97_HIA_DSE_BASE;
+		offsets->hia_dse_thr	= EIP97_HIA_DSE_THR_BASE;
+		offsets->hia_gen_cfg	= EIP97_HIA_GEN_CFG_BASE;
+		offsets->pe		= EIP97_PE_BASE;
+		offsets->global		= EIP97_GLOBAL_BASE;
 	}
 }
 
@@ -1149,8 +1144,8 @@ static int safexcel_probe_generic(void *pdev,
 				  int is_pci_dev)
 {
 	struct device *dev = priv->dev;
-	u32 peid;
-	int i, ret;
+	u32 peid, version, mask, val;
+	int i, ret, hwctg;
 
 	priv->context_pool = dmam_pool_create("safexcel-context", dev,
 					      sizeof(struct safexcel_context_record),
@@ -1158,23 +1153,89 @@ static int safexcel_probe_generic(void *pdev,
 	if (!priv->context_pool)
 		return -ENOMEM;
 
+	/*
+	 * First try the EIP97 HIA version regs
+	 * For the EIP197, this is guaranteed to NOT return any of the test
+	 * values
+	 */
+	version = readl(priv->base + EIP97_HIA_AIC_BASE + EIP197_HIA_VERSION);
+
+	mask = 0;  /* do not swap */
+	if (EIP197_REG_LO16(version) == EIP197_HIA_VERSION_LE) {
+		priv->hwconfig.hiaver = EIP197_VERSION_MASK(version);
+	} else if (EIP197_REG_HI16(version) == EIP197_HIA_VERSION_BE) {
+		/* read back byte-swapped, so complement byte swap bits */
+		mask = EIP197_MST_CTRL_BYTE_SWAP_BITS;
+		priv->hwconfig.hiaver = EIP197_VERSION_SWAP(version);
+	} else {
+		/* So it wasn't an EIP97 ... maybe it's an EIP197? */
+		version = readl(priv->base + EIP197_HIA_AIC_BASE +
+				EIP197_HIA_VERSION);
+		if (EIP197_REG_LO16(version) == EIP197_HIA_VERSION_LE) {
+			priv->hwconfig.hiaver = EIP197_VERSION_MASK(version);
+			priv->flags |= SAFEXCEL_HW_EIP197;
+		} else if (EIP197_REG_HI16(version) ==
+			   EIP197_HIA_VERSION_BE) {
+			/* read back byte-swapped, so complement swap bits */
+			mask = EIP197_MST_CTRL_BYTE_SWAP_BITS;
+			priv->hwconfig.hiaver = EIP197_VERSION_SWAP(version);
+			priv->flags |= SAFEXCEL_HW_EIP197;
+		} else {
+			return -ENODEV;
+		}
+	}
+
+	/* Now initialize the reg offsets based on the probing info so far */
 	safexcel_init_register_offsets(priv);
 
+	/*
+	 * If the version was read byte-swapped, we need to flip the device
+	 * swapping Keep in mind here, though, that what we write will also be
+	 * byte-swapped ...
+	 */
+	if (mask) {
+		val = readl(EIP197_HIA_AIC(priv) + EIP197_HIA_MST_CTRL);
+		val = val ^ (mask >> 24); /* toggle byte swap bits */
+		writel(val, EIP197_HIA_AIC(priv) + EIP197_HIA_MST_CTRL);
+	}
+
+	/*
+	 * We're not done probing yet! We may fall through to here if no HIA
+	 * was found at all. So, with the endianness presumably correct now and
+	 * the offsets setup, *really* probe for the EIP97/EIP197.
+	 */
+	version = readl(EIP197_GLOBAL(priv) + EIP197_VERSION);
+	if (((priv->flags & SAFEXCEL_HW_EIP197) &&
+	     (EIP197_REG_LO16(version) != EIP197_VERSION_LE)) ||
+	    ((!(priv->flags & SAFEXCEL_HW_EIP197) &&
+	     (EIP197_REG_LO16(version) != EIP97_VERSION_LE)))) {
+		/*
+		 * We did not find the device that matched our initial probing
+		 * (or our initial probing failed) Report appropriate error.
+		 */
+		return -ENODEV;
+	}
+
+	priv->hwconfig.hwver = EIP197_VERSION_MASK(version);
+	hwctg = version >> 28;
+	peid = version & 255;
+
+	/* Detect EIP96 packet engine and version */
+	version = readl(EIP197_PE(priv) + EIP197_PE_EIP96_VERSION(0));
+	if (EIP197_REG_LO16(version) != EIP96_VERSION_LE) {
+		dev_err(dev, "EIP%d: EIP96 not detected.\n", peid);
+		return -ENODEV;
+	}
+	priv->hwconfig.pever = EIP197_VERSION_MASK(version);
+
 	/* Get supported algorithms from EIP96 transform engine */
 	priv->hwconfig.algo_flags = readl(EIP197_PE(priv) +
 				    EIP197_PE_EIP96_OPTIONS(0));
 
-	if (priv->version == EIP97IES_MRVL) {
-		peid = 97;
-	} else {
-		priv->flags |= EIP197_TRC_CACHE;
-		peid = 197;
-	}
-
-	/* Dump some debug information important during development */
-	dev_dbg(priv->dev, "Inside Secure EIP%d packetengine\n", peid);
-	dev_dbg(priv->dev, "Supported algorithms: %08x\n",
-			   priv->hwconfig.algo_flags);
+	/* Print single info line describing what we just detected */
+	dev_info(priv->dev, "EIP%d:%x(%d)-HIA:%x,PE:%x,alg:%08x\n", peid,
+		 priv->hwconfig.hwver, hwctg, priv->hwconfig.hiaver,
+		 priv->hwconfig.pever, priv->hwconfig.algo_flags);
 
 	safexcel_configure(priv);
 
@@ -1526,7 +1587,6 @@ void safexcel_pci_remove(struct pci_dev *pdev)
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_XILINX, 0x9038,
 			       0x16ae, 0xc522),
-		/* assume EIP197B for now */
 		.driver_data = EIP197_DEVBRD,
 	},
 	{},
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index d76a4fa..e4da706 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -14,8 +14,17 @@
 #include <crypto/sha.h>
 #include <crypto/skcipher.h>
 
-#define EIP197_HIA_VERSION_LE			0xca35
-#define EIP197_HIA_VERSION_BE			0x35ca
+#define EIP197_HIA_VERSION_BE			0xca35
+#define EIP197_HIA_VERSION_LE			0x35ca
+#define EIP97_VERSION_LE			0x9e61
+#define EIP197_VERSION_LE			0x3ac5
+#define EIP96_VERSION_LE			0x9f60
+#define EIP197_REG_LO16(reg)			(reg & 0xffff)
+#define EIP197_REG_HI16(reg)			((reg >> 16) & 0xffff)
+#define EIP197_VERSION_MASK(reg)		((reg >> 16) & 0xfff)
+#define EIP197_VERSION_SWAP(reg)		(((reg & 0xf0) << 4) | \
+						((reg >> 4) & 0xf0) | \
+						((reg >> 12) & 0xf))
 
 /* Static configuration */
 #define EIP197_DEFAULT_RING_SIZE		400
@@ -70,6 +79,7 @@
 #define EIP197_HIA_DSE_THR(priv)	((priv)->base + (priv)->offsets.hia_dse_thr)
 #define EIP197_HIA_GEN_CFG(priv)	((priv)->base + (priv)->offsets.hia_gen_cfg)
 #define EIP197_PE(priv)			((priv)->base + (priv)->offsets.pe)
+#define EIP197_GLOBAL(priv)		((priv)->base + (priv)->offsets.global)
 
 /* EIP197 base offsets */
 #define EIP197_HIA_AIC_BASE		0x90000
@@ -82,6 +92,7 @@
 #define EIP197_HIA_DSE_THR_BASE		0x8d040
 #define EIP197_HIA_GEN_CFG_BASE		0xf0000
 #define EIP197_PE_BASE			0xa0000
+#define EIP197_GLOBAL_BASE		0xf0000
 
 /* EIP97 base offsets */
 #define EIP97_HIA_AIC_BASE		0x0
@@ -94,6 +105,7 @@
 #define EIP97_HIA_DSE_THR_BASE		0xf600
 #define EIP97_HIA_GEN_CFG_BASE		0x10000
 #define EIP97_PE_BASE			0x10000
+#define EIP97_GLOBAL_BASE		0x10000
 
 /* CDR/RDR register offsets */
 #define EIP197_HIA_xDR_OFF(priv, r)		(EIP197_HIA_AIC_xDR(priv) + (r) * 0x1000)
@@ -146,9 +158,11 @@
 #define EIP197_PE_EIP96_CONTEXT_CTRL(n)		(0x1008 + (0x2000 * (n)))
 #define EIP197_PE_EIP96_CONTEXT_STAT(n)		(0x100c + (0x2000 * (n)))
 #define EIP197_PE_EIP96_OPTIONS(n)		(0x13f8 + (0x2000 * (n)))
+#define EIP197_PE_EIP96_VERSION(n)		(0x13fc + (0x2000 * (n)))
 #define EIP197_PE_OUT_DBUF_THRES(n)		(0x1c00 + (0x2000 * (n)))
 #define EIP197_PE_OUT_TBUF_THRES(n)		(0x1d00 + (0x2000 * (n)))
 #define EIP197_MST_CTRL				0xfff4
+#define EIP197_VERSION				0xfffc
 
 /* EIP197-specific registers, no indirection */
 #define EIP197_CLASSIFICATION_RAMS		0xe0000
@@ -252,6 +266,7 @@
 #define EIP197_MST_CTRL_TX_MAX_CMD(n)		(((n) & 0xf) << 20)
 #define EIP197_MST_CTRL_BYTE_SWAP		BIT(24)
 #define EIP197_MST_CTRL_NO_BYTE_SWAP		BIT(25)
+#define EIP197_MST_CTRL_BYTE_SWAP_BITS          GENMASK(25, 24)
 
 /* EIP197_PE_IN_DBUF/TBUF_THRES */
 #define EIP197_PE_IN_xBUF_THRES_MIN(n)		((n) << 8)
@@ -652,14 +667,19 @@ struct safexcel_register_offsets {
 	u32 hia_dse_thr;
 	u32 hia_gen_cfg;
 	u32 pe;
+	u32 global;
 };
 
 enum safexcel_flags {
-	EIP197_TRC_CACHE = BIT(0),
+	EIP197_TRC_CACHE	= BIT(0),
+	SAFEXCEL_HW_EIP197	= BIT(1),
 };
 
 struct safexcel_hwconfig {
 	enum safexcel_eip_algorithms algo_flags;
+	int hwver;
+	int hiaver;
+	int pever;
 };
 
 struct safexcel_crypto_priv {
-- 
1.8.3.1

