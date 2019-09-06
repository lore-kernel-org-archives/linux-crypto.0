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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1717DC00307
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 15:34:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E351B20838
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 15:34:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lArlZ7BH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404387AbfIFPep (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Sep 2019 11:34:45 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:42785 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404459AbfIFPep (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Sep 2019 11:34:45 -0400
Received: by mail-ed1-f68.google.com with SMTP id y91so6654227ede.9
        for <linux-crypto@vger.kernel.org>; Fri, 06 Sep 2019 08:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mo136QagH5i3b7/V+ae5K7cs0AQXi+Ek+lBv3k/aE9E=;
        b=lArlZ7BHMsd+bW+HM9w5C3YNw8/4yB5Em0ZskRUrHV07c+RMzNvRt3Y4PZA4p6i8Jj
         n1dn6JatcEquh7ffJK5BbRhxW3Yuee7wS49ltKZ053t+Gb34k+s+hjCD49nC+znTz3nx
         tJoj0BPNAHNArYFCrIgoPd3wX/jeD4n2dDPds0OMrHlPX01R5dBKnqaV2gWnkQykUeS8
         zstyfvFFogDOIMwP9p0xeyXaLBz1Xx6Lk7A3OT6n2tRgXcUqzDJiXQCjOUGXyrEdHglE
         S5QB7klVZwu+8wUjnHpspJ+1LwARztUO+cCXJ8Ri/bwQ4omSonUObux1HnwDxhucT9YB
         lreQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mo136QagH5i3b7/V+ae5K7cs0AQXi+Ek+lBv3k/aE9E=;
        b=jkxfd5HS0+UNAdc+G5tR25HQaJWJ8K5pScmMJuFX6eTVP8xOCGctyEwkorecrsoVKU
         wQ43rzMOYSiKeNnpfJ9fe3zGvtx93d5U903B23UUDqajREwrB/0n6zRDiUN9apIiniEO
         1XPBSY5mapM4LCTZivOMPl8u2khtn5YR3YDYvgC0KakD4sSJo8Sawc/g1DVAkbXjQxqy
         84C2WxLADD8T1OiJhVpbG+C1OySd5zOjlILLYtU3cV4y7c8INxYFvUTWHRCyADf3GAYI
         bOlzxuszTwdnOZf0aH6fFOA9+ugWrgMsxDLSjgTMKgOioX9PNVs1xWgiPnWT79uqJj/D
         HiDw==
X-Gm-Message-State: APjAAAWlGB3l5PplOicMB7LQC43i8XeJ5Gw56Oo2KsWSBF+EFmIsUWQZ
        wpP8HZKN5sZ5hB+InPuak88IjPGX
X-Google-Smtp-Source: APXvYqxRNCgw6jU8i+fzYjp2mLV05YtUprst0BnFLYPqRuaRihmBBbzhuGZ12xqgEtmatQLwIIG/mw==
X-Received: by 2002:a50:95a3:: with SMTP id w32mr10321989eda.211.1567784083114;
        Fri, 06 Sep 2019 08:34:43 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id c22sm995218eds.30.2019.09.06.08.34.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 08:34:42 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 5/6] crypto: inside-secure - Base RD fetchcount on actual RD FIFO size
Date:   Fri,  6 Sep 2019 16:31:52 +0200
Message-Id: <1567780313-1579-6-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567780313-1579-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1567780313-1579-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch derives the result descriptor fetch count from the actual
FIFO size advertised by the hardware. Fetching result descriptors
one at a time is a performance bottleneck for small blocks, especially
on hardware with multiple pipes. Even moreso if the HW has few rings.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c | 37 +++++++++++++++++++++++----------
 drivers/crypto/inside-secure/safexcel.h | 15 ++++++++++++-
 2 files changed, 40 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 9384491..a607786 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -357,13 +357,22 @@ static int safexcel_hw_setup_cdesc_rings(struct safexcel_crypto_priv *priv)
 static int safexcel_hw_setup_rdesc_rings(struct safexcel_crypto_priv *priv)
 {
 	u32 hdw, rd_size_rnd, val;
-	int i;
-
-	hdw = readl(EIP197_HIA_AIC_G(priv) + EIP197_HIA_OPTIONS);
-	hdw &= GENMASK(27, 25);
-	hdw >>= 25;
+	int i, rd_fetch_cnt;
 
-	rd_size_rnd = (priv->config.rd_size + (BIT(hdw) - 1)) >> hdw;
+	/* determine number of RD's we can fetch into the FIFO as one block */
+	rd_size_rnd = (EIP197_RD64_FETCH_SIZE +
+		      BIT(priv->hwconfig.hwdataw) - 1) >>
+		      priv->hwconfig.hwdataw;
+	if (priv->flags & SAFEXCEL_HW_EIP197) {
+		/* EIP197: try to fetch enough in 1 go to keep all pipes busy */
+		rd_fetch_cnt = (1 << priv->hwconfig.hwrfsize) / rd_size_rnd;
+		rd_fetch_cnt = min_t(uint, rd_fetch_cnt,
+				     (priv->config.pes * EIP197_FETCH_DEPTH));
+	} else {
+		/* for the EIP97, just fetch all that fits minus 1 */
+		rd_fetch_cnt = ((1 << priv->hwconfig.hwrfsize) /
+			       rd_size_rnd) - 1;
+	}
 
 	for (i = 0; i < priv->config.rings; i++) {
 		/* ring base address */
@@ -376,8 +385,8 @@ static int safexcel_hw_setup_rdesc_rings(struct safexcel_crypto_priv *priv)
 		       priv->config.rd_size,
 		       EIP197_HIA_RDR(priv, i) + EIP197_HIA_xDR_DESC_SIZE);
 
-		writel(((EIP197_FETCH_COUNT * (rd_size_rnd << hdw)) << 16) |
-		       (EIP197_FETCH_COUNT * priv->config.rd_offset),
+		writel(((rd_fetch_cnt * (rd_size_rnd << hdw)) << 16) |
+		       (rd_fetch_cnt * priv->config.rd_offset),
 		       EIP197_HIA_RDR(priv, i) + EIP197_HIA_xDR_CFG);
 
 		/* Configure DMA tx control */
@@ -1248,12 +1257,17 @@ static int safexcel_probe_generic(void *pdev,
 		priv->hwconfig.hwcfsize = ((hiaopt >> EIP197_CFSIZE_OFFSET) &
 					   EIP197_CFSIZE_MASK) +
 					  EIP197_CFSIZE_ADJUST;
+		priv->hwconfig.hwrfsize = ((hiaopt >> EIP197_RFSIZE_OFFSET) &
+					   EIP197_RFSIZE_MASK) +
+					  EIP197_RFSIZE_ADJUST;
 	} else {
 		/* EIP97 */
 		priv->hwconfig.hwdataw  = (hiaopt >> EIP197_HWDATAW_OFFSET) &
 					  EIP97_HWDATAW_MASK;
 		priv->hwconfig.hwcfsize = (hiaopt >> EIP97_CFSIZE_OFFSET) &
 					  EIP97_CFSIZE_MASK;
+		priv->hwconfig.hwrfsize = (hiaopt >> EIP97_RFSIZE_OFFSET) &
+					  EIP97_RFSIZE_MASK;
 	}
 
 	/* Get supported algorithms from EIP96 transform engine */
@@ -1261,10 +1275,11 @@ static int safexcel_probe_generic(void *pdev,
 				    EIP197_PE_EIP96_OPTIONS(0));
 
 	/* Print single info line describing what we just detected */
-	dev_info(priv->dev, "EIP%d:%x(%d)-HIA:%x(%d,%d),PE:%x,alg:%08x\n", peid,
-		 priv->hwconfig.hwver, hwctg, priv->hwconfig.hiaver,
+	dev_info(priv->dev, "EIP%d:%x(%d)-HIA:%x(%d,%d,%d),PE:%x,alg:%08x\n",
+		 peid, priv->hwconfig.hwver, hwctg, priv->hwconfig.hiaver,
 		 priv->hwconfig.hwdataw, priv->hwconfig.hwcfsize,
-		 priv->hwconfig.pever, priv->hwconfig.algo_flags);
+		 priv->hwconfig.hwrfsize, priv->hwconfig.pever,
+		 priv->hwconfig.algo_flags);
 
 	safexcel_configure(priv);
 
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index e01aa70..19049f1 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -30,7 +30,6 @@
 #define EIP197_DEFAULT_RING_SIZE		400
 #define EIP197_MAX_TOKENS			18
 #define EIP197_MAX_RINGS			4
-#define EIP197_FETCH_COUNT			1
 #define EIP197_FETCH_DEPTH			2
 #define EIP197_MAX_BATCH_SZ			64
 
@@ -234,6 +233,11 @@
 #define EIP97_CFSIZE_OFFSET			8
 #define EIP197_CFSIZE_MASK			GENMASK(3, 0)
 #define EIP97_CFSIZE_MASK			GENMASK(4, 0)
+#define EIP197_RFSIZE_OFFSET			12
+#define EIP197_RFSIZE_ADJUST			4
+#define EIP97_RFSIZE_OFFSET			12
+#define EIP197_RFSIZE_MASK			GENMASK(3, 0)
+#define EIP97_RFSIZE_MASK			GENMASK(4, 0)
 
 /* EIP197_HIA_AIC_R_ENABLE_CTRL */
 #define EIP197_CDR_IRQ(n)			BIT((n) * 2)
@@ -463,6 +467,14 @@ struct safexcel_result_desc {
 	struct result_data_desc result_data;
 } __packed;
 
+/*
+ * The EIP(1)97 only needs to fetch the descriptor part of
+ * the result descriptor, not the result token part!
+ */
+#define EIP197_RD64_FETCH_SIZE		((sizeof(struct safexcel_result_desc) -\
+					  sizeof(struct result_data_desc)) /\
+					 sizeof(u32))
+
 struct safexcel_token {
 	u32 packet_length:17;
 	u8 stat:2;
@@ -692,6 +704,7 @@ struct safexcel_hwconfig {
 	int pever;
 	int hwdataw;
 	int hwcfsize;
+	int hwrfsize;
 };
 
 struct safexcel_crypto_priv {
-- 
1.8.3.1

