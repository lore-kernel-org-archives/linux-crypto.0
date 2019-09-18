Return-Path: <SRS0=f1VZ=XN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FB86C4CEC4
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Sep 2019 11:44:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FFD621907
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Sep 2019 11:44:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l3QQBuiM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727807AbfIRLoU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 18 Sep 2019 07:44:20 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:46894 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727608AbfIRLoT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 Sep 2019 07:44:19 -0400
Received: by mail-ed1-f68.google.com with SMTP id t3so4115355edw.13
        for <linux-crypto@vger.kernel.org>; Wed, 18 Sep 2019 04:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=iZkZOaAGLL3DOBQGBHi9RUqlxs60HiKY1fa+AGeVEzU=;
        b=l3QQBuiMahL2+3LUrsMuEBw9TMsOZvoAMgcXuFoAVt/G7WKFGf3uEj977uMo8G3KV8
         9EW7reSnejij5RPta7Blich/D8Ie36VbwtAg3yf3O3K/Bm0WCg2QmWy+z7PlTgfGyozy
         992mMEyx/t/h1BtLD+lwt9OVrZApG5Mf2FPxMpFcib4jkfK6Dgj4Q0g0dtaD93ebmj6W
         KyCpvttXO/UPY6pkrRm9yfBji/a7ZpaoWRexfuftSva1XjH/gBC690j+NTWoyRRJ+ZPO
         HL0AunYgxdyP37dU/K5rCLRKRb+U4x2YsF24nZ6HBNKDjOTgmOf74Hj887hKqyUJehXU
         Z5fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=iZkZOaAGLL3DOBQGBHi9RUqlxs60HiKY1fa+AGeVEzU=;
        b=FmET9ZWa6E8RtYPqkJ3CBbtyYeqfvGmIZHgULkgcwv1/KZt1mA/8rDSWn9bwzVLGgV
         44l1Gcv4tGP3SOu/Q0gZAlZtAhQ0WwtAcJWy0jTOPDF05JBc1CqwTSZ3vr+UDZf+YN7Z
         DSgJSDPNgPzk2VptVZhP4w0PHiZFLasIvOh6SN9lPpeF1eJ17y5iFDLG3+BNlmYpy/Gt
         i1xLTfQqSy3ZwhIk5ScdfWtYmZrtmg/sMZT91Zr6/nYGy97WGxznuE+WXzKmHLM26fat
         yEgFxM8ydqnoVWzKNoEV91ryQ8SGGREu5/EV/GCA/gQf/PydcXdu4xq4u++tBJuZbGnU
         z7xQ==
X-Gm-Message-State: APjAAAWDeLcdTt2n68u3M28nzwYGl876sYALZteCJbgiG9DQ20KspVpO
        6tiDxuBFim5Xzkutkar6+xFHam8L
X-Google-Smtp-Source: APXvYqzDZQYG8/1ZpqzsPsTW5SlgDOXykjm/KjgCZZx1R9WboPfLXo9s65Ww4IqqlZJm71jEkV0tpQ==
X-Received: by 2002:a17:907:10c5:: with SMTP id rv5mr9012483ejb.262.1568807056858;
        Wed, 18 Sep 2019 04:44:16 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id s21sm1003738edi.85.2019.09.18.04.44.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Sep 2019 04:44:16 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH] crypto: inside-secure - Add support for the EIP196
Date:   Wed, 18 Sep 2019 12:41:26 +0200
Message-Id: <1568803286-8111-1-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds support for the EIP196, which is an EIP197 derivative
that has no classification hardware and a simplified record cache.

The patch has been tested with the eip196b-ie and eip197c-iewxkbc
configurations on the Xilinx VCU118 development board as well as on the
Macchiatobin board (Marvell A8K - EIP197b-ieswx), including the crypto
extra tests.

Note that this patchset applies on top of the earlier submitted
"Add support for eip197f_iewc" series.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c      | 69 ++++++++++++++++++++++------
 drivers/crypto/inside-secure/safexcel.h      | 30 +++++++++++-
 drivers/crypto/inside-secure/safexcel_ring.c |  1 +
 3 files changed, 86 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index c40eb1b..9fb4947 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -484,6 +484,14 @@ static int safexcel_hw_setup_cdesc_rings(struct safexcel_crypto_priv *priv)
 		cd_fetch_cnt = ((1 << priv->hwconfig.hwcfsize) /
 				cd_size_rnd) - 1;
 	}
+	/*
+	 * Since we're using command desc's way larger than formally specified,
+	 * we need to check whether we can fit even 1 for low-end EIP196's!
+	 */
+	if (!cd_fetch_cnt) {
+		dev_err(priv->dev, "Unable to fit even 1 command desc!\n");
+		return -ENODEV;
+	}
 
 	for (i = 0; i < priv->config.rings; i++) {
 		/* ring base address */
@@ -608,8 +616,8 @@ static int safexcel_hw_init(struct safexcel_crypto_priv *priv)
 		writel(EIP197_DxE_THR_CTRL_RESET_PE,
 		       EIP197_HIA_DFE_THR(priv) + EIP197_HIA_DFE_THR_CTRL(pe));
 
-		if (priv->flags & SAFEXCEL_HW_EIP197)
-			/* Reset HIA input interface arbiter (EIP197 only) */
+		if (priv->flags & EIP197_PE_ARB)
+			/* Reset HIA input interface arbiter (if present) */
 			writel(EIP197_HIA_RA_PE_CTRL_RESET,
 			       EIP197_HIA_AIC(priv) + EIP197_HIA_RA_PE_CTRL(pe));
 
@@ -756,22 +764,28 @@ static int safexcel_hw_init(struct safexcel_crypto_priv *priv)
 	/* Clear any HIA interrupt */
 	writel(GENMASK(30, 20), EIP197_HIA_AIC_G(priv) + EIP197_HIA_AIC_G_ACK);
 
-	if (priv->flags & SAFEXCEL_HW_EIP197) {
+	if (priv->flags & EIP197_SIMPLE_TRC) {
+		writel(EIP197_STRC_CONFIG_INIT |
+		       EIP197_STRC_CONFIG_LARGE_REC(EIP197_CS_TRC_REC_WC) |
+		       EIP197_STRC_CONFIG_SMALL_REC(EIP197_CS_TRC_REC_WC),
+		       priv->base + EIP197_STRC_CONFIG);
+		writel(EIP197_PE_EIP96_TOKEN_CTRL2_CTX_DONE,
+		       EIP197_PE(priv) + EIP197_PE_EIP96_TOKEN_CTRL2(0));
+	} else if (priv->flags & SAFEXCEL_HW_EIP197) {
 		ret = eip197_trc_cache_init(priv);
 		if (ret)
 			return ret;
+	}
 
-		priv->flags |= EIP197_TRC_CACHE;
-
+	if (priv->flags & EIP197_ICE) {
 		ret = eip197_load_firmwares(priv);
 		if (ret)
 			return ret;
 	}
 
-	safexcel_hw_setup_cdesc_rings(priv);
-	safexcel_hw_setup_rdesc_rings(priv);
-
-	return 0;
+	return safexcel_hw_setup_cdesc_rings(priv) ?:
+	       safexcel_hw_setup_rdesc_rings(priv) ?:
+	       0;
 }
 
 /* Called with ring's lock taken */
@@ -1371,7 +1385,7 @@ static int safexcel_probe_generic(void *pdev,
 				  int is_pci_dev)
 {
 	struct device *dev = priv->dev;
-	u32 peid, version, mask, val, hiaopt;
+	u32 peid, version, mask, val, hiaopt, hwopt, peopt;
 	int i, ret, hwctg;
 
 	priv->context_pool = dmam_pool_create("safexcel-context", dev,
@@ -1433,13 +1447,16 @@ static int safexcel_probe_generic(void *pdev,
 	 */
 	version = readl(EIP197_GLOBAL(priv) + EIP197_VERSION);
 	if (((priv->flags & SAFEXCEL_HW_EIP197) &&
-	     (EIP197_REG_LO16(version) != EIP197_VERSION_LE)) ||
+	     (EIP197_REG_LO16(version) != EIP197_VERSION_LE) &&
+	     (EIP197_REG_LO16(version) != EIP196_VERSION_LE)) ||
 	    ((!(priv->flags & SAFEXCEL_HW_EIP197) &&
 	     (EIP197_REG_LO16(version) != EIP97_VERSION_LE)))) {
 		/*
 		 * We did not find the device that matched our initial probing
 		 * (or our initial probing failed) Report appropriate error.
 		 */
+		dev_err(priv->dev, "Probing for EIP97/EIP19x failed - no such device (read %08x)\n",
+			version);
 		return -ENODEV;
 	}
 
@@ -1447,6 +1464,14 @@ static int safexcel_probe_generic(void *pdev,
 	hwctg = version >> 28;
 	peid = version & 255;
 
+	/* Detect EIP206 processing pipe */
+	version = readl(EIP197_PE(priv) + + EIP197_PE_VERSION(0));
+	if (EIP197_REG_LO16(version) != EIP206_VERSION_LE) {
+		dev_err(priv->dev, "EIP%d: EIP206 not detected\n", peid);
+		return -ENODEV;
+	}
+	priv->hwconfig.ppver = EIP197_VERSION_MASK(version);
+
 	/* Detect EIP96 packet engine and version */
 	version = readl(EIP197_PE(priv) + EIP197_PE_EIP96_VERSION(0));
 	if (EIP197_REG_LO16(version) != EIP96_VERSION_LE) {
@@ -1455,10 +1480,13 @@ static int safexcel_probe_generic(void *pdev,
 	}
 	priv->hwconfig.pever = EIP197_VERSION_MASK(version);
 
+	hwopt = readl(EIP197_GLOBAL(priv) + EIP197_OPTIONS);
 	hiaopt = readl(EIP197_HIA_AIC(priv) + EIP197_HIA_OPTIONS);
 
 	if (priv->flags & SAFEXCEL_HW_EIP197) {
 		/* EIP197 */
+		peopt = readl(EIP197_PE(priv) + EIP197_PE_OPTIONS(0));
+
 		priv->hwconfig.hwdataw  = (hiaopt >> EIP197_HWDATAW_OFFSET) &
 					  EIP197_HWDATAW_MASK;
 		priv->hwconfig.hwcfsize = ((hiaopt >> EIP197_CFSIZE_OFFSET) &
@@ -1471,6 +1499,15 @@ static int safexcel_probe_generic(void *pdev,
 					  EIP197_N_PES_MASK;
 		priv->hwconfig.hwnumrings = (hiaopt >> EIP197_N_RINGS_OFFSET) &
 					    EIP197_N_RINGS_MASK;
+		if (hiaopt & EIP197_HIA_OPT_HAS_PE_ARB)
+			priv->flags |= EIP197_PE_ARB;
+		if (EIP206_OPT_ICE_TYPE(peopt) == 1)
+			priv->flags |= EIP197_ICE;
+		/* If not a full TRC, then assume simple TRC */
+		if (!(hwopt & EIP197_OPT_HAS_TRC))
+			priv->flags |= EIP197_SIMPLE_TRC;
+		/* EIP197 always has SOME form of TRC */
+		priv->flags |= EIP197_TRC_CACHE;
 	} else {
 		/* EIP97 */
 		priv->hwconfig.hwdataw  = (hiaopt >> EIP197_HWDATAW_OFFSET) &
@@ -1492,18 +1529,24 @@ static int safexcel_probe_generic(void *pdev,
 			break;
 	}
 	priv->hwconfig.hwnumraic = i;
+	/* Low-end EIP196 may not have any ring AIC's ... */
+	if (!priv->hwconfig.hwnumraic) {
+		dev_err(priv->dev, "No ring interrupt controller present!\n");
+		return -ENODEV;
+	}
 
 	/* Get supported algorithms from EIP96 transform engine */
 	priv->hwconfig.algo_flags = readl(EIP197_PE(priv) +
 				    EIP197_PE_EIP96_OPTIONS(0));
 
 	/* Print single info line describing what we just detected */
-	dev_info(priv->dev, "EIP%d:%x(%d,%d,%d,%d)-HIA:%x(%d,%d,%d),PE:%x,alg:%08x\n",
+	dev_info(priv->dev, "EIP%d:%x(%d,%d,%d,%d)-HIA:%x(%d,%d,%d),PE:%x/%x,alg:%08x\n",
 		 peid, priv->hwconfig.hwver, hwctg, priv->hwconfig.hwnumpes,
 		 priv->hwconfig.hwnumrings, priv->hwconfig.hwnumraic,
 		 priv->hwconfig.hiaver, priv->hwconfig.hwdataw,
 		 priv->hwconfig.hwcfsize, priv->hwconfig.hwrfsize,
-		 priv->hwconfig.pever, priv->hwconfig.algo_flags);
+		 priv->hwconfig.ppver, priv->hwconfig.pever,
+		 priv->hwconfig.algo_flags);
 
 	safexcel_configure(priv);
 
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index 25dfd8a..c2524e1 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -17,9 +17,11 @@
 #define EIP197_HIA_VERSION_BE			0xca35
 #define EIP197_HIA_VERSION_LE			0x35ca
 #define EIP97_VERSION_LE			0x9e61
+#define EIP196_VERSION_LE			0x3bc4
 #define EIP197_VERSION_LE			0x3ac5
 #define EIP96_VERSION_LE			0x9f60
 #define EIP201_VERSION_LE			0x36c9
+#define EIP206_VERSION_LE			0x31ce
 #define EIP197_REG_LO16(reg)			(reg & 0xffff)
 #define EIP197_REG_HI16(reg)			((reg >> 16) & 0xffff)
 #define EIP197_VERSION_MASK(reg)		((reg >> 16) & 0xfff)
@@ -27,6 +29,15 @@
 						((reg >> 4) & 0xf0) | \
 						((reg >> 12) & 0xf))
 
+/* EIP197 HIA OPTIONS ENCODING */
+#define EIP197_HIA_OPT_HAS_PE_ARB		BIT(29)
+
+/* EIP206 OPTIONS ENCODING */
+#define EIP206_OPT_ICE_TYPE(n)			((n>>8)&3)
+
+/* EIP197 OPTIONS ENCODING */
+#define EIP197_OPT_HAS_TRC			BIT(31)
+
 /* Static configuration */
 #define EIP197_DEFAULT_RING_SIZE		400
 #define EIP197_MAX_TOKENS			19
@@ -160,12 +171,16 @@
 #define EIP197_PE_EIP96_FUNCTION_EN(n)		(0x1004 + (0x2000 * (n)))
 #define EIP197_PE_EIP96_CONTEXT_CTRL(n)		(0x1008 + (0x2000 * (n)))
 #define EIP197_PE_EIP96_CONTEXT_STAT(n)		(0x100c + (0x2000 * (n)))
+#define EIP197_PE_EIP96_TOKEN_CTRL2(n)		(0x102c + (0x2000 * (n)))
 #define EIP197_PE_EIP96_FUNCTION2_EN(n)		(0x1030 + (0x2000 * (n)))
 #define EIP197_PE_EIP96_OPTIONS(n)		(0x13f8 + (0x2000 * (n)))
 #define EIP197_PE_EIP96_VERSION(n)		(0x13fc + (0x2000 * (n)))
 #define EIP197_PE_OUT_DBUF_THRES(n)		(0x1c00 + (0x2000 * (n)))
 #define EIP197_PE_OUT_TBUF_THRES(n)		(0x1d00 + (0x2000 * (n)))
+#define EIP197_PE_OPTIONS(n)			(0x1ff8 + (0x2000 * (n)))
+#define EIP197_PE_VERSION(n)			(0x1ffc + (0x2000 * (n)))
 #define EIP197_MST_CTRL				0xfff4
+#define EIP197_OPTIONS				0xfff8
 #define EIP197_VERSION				0xfffc
 
 /* EIP197-specific registers, no indirection */
@@ -181,6 +196,7 @@
 #define EIP197_TRC_ECCADMINSTAT			0xf0838
 #define EIP197_TRC_ECCDATASTAT			0xf083c
 #define EIP197_TRC_ECCDATA			0xf0840
+#define EIP197_STRC_CONFIG			0xf43f0
 #define EIP197_FLUE_CACHEBASE_LO(n)		(0xf6000 + (32 * (n)))
 #define EIP197_FLUE_CACHEBASE_HI(n)		(0xf6004 + (32 * (n)))
 #define EIP197_FLUE_CONFIG(n)			(0xf6010 + (32 * (n)))
@@ -331,6 +347,14 @@
 #define EIP197_ADDRESS_MODE			BIT(8)
 #define EIP197_CONTROL_MODE			BIT(9)
 
+/* EIP197_PE_EIP96_TOKEN_CTRL2 */
+#define EIP197_PE_EIP96_TOKEN_CTRL2_CTX_DONE	BIT(3)
+
+/* EIP197_STRC_CONFIG */
+#define EIP197_STRC_CONFIG_INIT			BIT(31)
+#define EIP197_STRC_CONFIG_LARGE_REC(s)		(s<<8)
+#define EIP197_STRC_CONFIG_SMALL_REC(s)		(s<<0)
+
 /* EIP197_FLUE_CONFIG */
 #define EIP197_FLUE_CONFIG_MAGIC		0xc7000004
 
@@ -472,7 +496,7 @@ struct result_data_desc {
 	u16 application_id;
 	u16 rsvd1;
 
-	u32 rsvd2;
+	u32 rsvd2[5];
 } __packed;
 
 
@@ -731,12 +755,16 @@ struct safexcel_register_offsets {
 enum safexcel_flags {
 	EIP197_TRC_CACHE	= BIT(0),
 	SAFEXCEL_HW_EIP197	= BIT(1),
+	EIP197_PE_ARB		= BIT(2),
+	EIP197_ICE		= BIT(3),
+	EIP197_SIMPLE_TRC	= BIT(4),
 };
 
 struct safexcel_hwconfig {
 	enum safexcel_eip_algorithms algo_flags;
 	int hwver;
 	int hiaver;
+	int ppver;
 	int pever;
 	int hwdataw;
 	int hwcfsize;
diff --git a/drivers/crypto/inside-secure/safexcel_ring.c b/drivers/crypto/inside-secure/safexcel_ring.c
index 5323e91..9237ba7 100644
--- a/drivers/crypto/inside-secure/safexcel_ring.c
+++ b/drivers/crypto/inside-secure/safexcel_ring.c
@@ -180,6 +180,7 @@ struct safexcel_result_desc *safexcel_add_rdesc(struct safexcel_crypto_priv *pri
 
 	rdesc->first_seg = first;
 	rdesc->last_seg = last;
+	rdesc->result_size = EIP197_RD64_RESULT_SIZE;
 	rdesc->particle_size = len;
 	rdesc->data_lo = lower_32_bits(data);
 	rdesc->data_hi = upper_32_bits(data);
-- 
1.8.3.1

