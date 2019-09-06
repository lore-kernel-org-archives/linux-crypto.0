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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0DBEC43331
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 15:34:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3DAA20838
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 15:34:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iUnXUXuP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404107AbfIFPep (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Sep 2019 11:34:45 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:32859 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404387AbfIFPeo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Sep 2019 11:34:44 -0400
Received: by mail-ed1-f66.google.com with SMTP id o9so6722803edq.0
        for <linux-crypto@vger.kernel.org>; Fri, 06 Sep 2019 08:34:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6uMmV5ErfzayV8PcAf3sreZod7mbrSgyuBteR9K0XjM=;
        b=iUnXUXuPQ5mP54G3HVvx2zp22zX+CvOqlrh2Ct+vE+0Cb4FsXLIhw2tXb+zW6oGhGW
         UNb8DBXKEeg5nCgCjTDQTmrlMeXW4NvEsAlt5JoaYSLPMOFJjG7KadOOcKfMm5FYAI0R
         rYF67HpbRPS0Xd18H09XrC8AgnUpLC1ztCX4qr6RbevLRUs3I7rn2VeDu0iPpbNa6q7G
         QKLkI0N6/SFbMiZT+mVLfQskYOe0kITockysvGv7jFMm3HDKhEPQHMUkFmzJUlzAOHcT
         WqDhz9VawySVdXgvbN0Jfnf+tJurOZFpoRBMlsbYfFHCBGjcb7nWQlpjls2WbHw4L+DG
         4uPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6uMmV5ErfzayV8PcAf3sreZod7mbrSgyuBteR9K0XjM=;
        b=on/hignGaQBrNvPl4+otRCJ2YcgeZczd5gWp+GilEsfoWtzsxjdQ4SRKqM2OTwJqek
         V9ylV8slYNJy38dIYYOFYtdHbtzfgqB95M98F1wh9cREQcC7PC+dhFFWvsA6nN6zegzU
         VdKbOZuPTFgZilnU1f5GeBcsl4gVF8LrZESVdC+9uidEspJXxNML1SYZQ4N1+of9ZCFv
         H8yR2WrSdgz4QCC+z5hLU/RxAOD//46sjGguhvNiItNGIK2pp4UKma4Ix5SrEo7kCSUy
         qiv5zt9zkRt/RXRp1j/2CfMXo1FQDYoxn5JneOh8jMgNa16Kdq457Yp8T1uRUd11IHpQ
         0+ew==
X-Gm-Message-State: APjAAAVk29cEScc0O7NoEJMlHI+6kibvFq9+DzO1m9wKbmwOd34Vf56q
        Ep8e9BrRLf3/7KCM+Xr9ngtjOQOD
X-Google-Smtp-Source: APXvYqzrxTTHEmeYWXELzinfReP9UtPwQ3xxzZbC2tRADVl5ssCBGkq8ICM6/DnbP7v1jV43FG3djg==
X-Received: by 2002:a50:9e26:: with SMTP id z35mr10219379ede.265.1567784082228;
        Fri, 06 Sep 2019 08:34:42 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id c22sm995218eds.30.2019.09.06.08.34.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 08:34:41 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 4/6] crypto: inside-secure - Base CD fetchcount on actual CD FIFO size
Date:   Fri,  6 Sep 2019 16:31:51 +0200
Message-Id: <1567780313-1579-5-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567780313-1579-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1567780313-1579-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch derives the command descriptor fetch count from the actual
FIFO size advertised by the hardware. Fetching command descriptors
one at a time is a performance bottleneck for small blocks, especially
on hardware with multiple pipes. Even moreso if the HW has few rings.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c | 47 ++++++++++++++++++++++++++-------
 drivers/crypto/inside-secure/safexcel.h | 11 ++++++++
 2 files changed, 48 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index d9b927b..9384491 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -310,13 +310,22 @@ static int eip197_load_firmwares(struct safexcel_crypto_priv *priv)
 static int safexcel_hw_setup_cdesc_rings(struct safexcel_crypto_priv *priv)
 {
 	u32 hdw, cd_size_rnd, val;
-	int i;
+	int i, cd_fetch_cnt;
 
-	hdw = readl(EIP197_HIA_AIC_G(priv) + EIP197_HIA_OPTIONS);
-	hdw &= GENMASK(27, 25);
-	hdw >>= 25;
-
-	cd_size_rnd = (priv->config.cd_size + (BIT(hdw) - 1)) >> hdw;
+	cd_size_rnd  = (priv->config.cd_size +
+			(BIT(priv->hwconfig.hwdataw) - 1)) >>
+		       priv->hwconfig.hwdataw;
+	/* determine number of CD's we can fetch into the CD FIFO as 1 block */
+	if (priv->flags & SAFEXCEL_HW_EIP197) {
+		/* EIP197: try to fetch enough in 1 go to keep all pipes busy */
+		cd_fetch_cnt = (1 << priv->hwconfig.hwcfsize) / cd_size_rnd;
+		cd_fetch_cnt = min_t(uint, cd_fetch_cnt,
+				     (priv->config.pes * EIP197_FETCH_DEPTH));
+	} else {
+		/* for the EIP97, just fetch all that fits minus 1 */
+		cd_fetch_cnt = ((1 << priv->hwconfig.hwcfsize) /
+				cd_size_rnd) - 1;
+	}
 
 	for (i = 0; i < priv->config.rings; i++) {
 		/* ring base address */
@@ -328,8 +337,8 @@ static int safexcel_hw_setup_cdesc_rings(struct safexcel_crypto_priv *priv)
 		writel(EIP197_xDR_DESC_MODE_64BIT | (priv->config.cd_offset << 16) |
 		       priv->config.cd_size,
 		       EIP197_HIA_CDR(priv, i) + EIP197_HIA_xDR_DESC_SIZE);
-		writel(((EIP197_FETCH_COUNT * (cd_size_rnd << hdw)) << 16) |
-		       (EIP197_FETCH_COUNT * priv->config.cd_offset),
+		writel(((cd_fetch_cnt * (cd_size_rnd << hdw)) << 16) |
+		       (cd_fetch_cnt * priv->config.cd_offset),
 		       EIP197_HIA_CDR(priv, i) + EIP197_HIA_xDR_CFG);
 
 		/* Configure DMA tx control */
@@ -1146,7 +1155,7 @@ static int safexcel_probe_generic(void *pdev,
 				  int is_pci_dev)
 {
 	struct device *dev = priv->dev;
-	u32 peid, version, mask, val;
+	u32 peid, version, mask, val, hiaopt;
 	int i, ret, hwctg;
 
 	priv->context_pool = dmam_pool_create("safexcel-context", dev,
@@ -1230,13 +1239,31 @@ static int safexcel_probe_generic(void *pdev,
 	}
 	priv->hwconfig.pever = EIP197_VERSION_MASK(version);
 
+	hiaopt = readl(EIP197_HIA_AIC(priv) + EIP197_HIA_OPTIONS);
+
+	if (priv->flags & SAFEXCEL_HW_EIP197) {
+		/* EIP197 */
+		priv->hwconfig.hwdataw  = (hiaopt >> EIP197_HWDATAW_OFFSET) &
+					  EIP197_HWDATAW_MASK;
+		priv->hwconfig.hwcfsize = ((hiaopt >> EIP197_CFSIZE_OFFSET) &
+					   EIP197_CFSIZE_MASK) +
+					  EIP197_CFSIZE_ADJUST;
+	} else {
+		/* EIP97 */
+		priv->hwconfig.hwdataw  = (hiaopt >> EIP197_HWDATAW_OFFSET) &
+					  EIP97_HWDATAW_MASK;
+		priv->hwconfig.hwcfsize = (hiaopt >> EIP97_CFSIZE_OFFSET) &
+					  EIP97_CFSIZE_MASK;
+	}
+
 	/* Get supported algorithms from EIP96 transform engine */
 	priv->hwconfig.algo_flags = readl(EIP197_PE(priv) +
 				    EIP197_PE_EIP96_OPTIONS(0));
 
 	/* Print single info line describing what we just detected */
-	dev_info(priv->dev, "EIP%d:%x(%d)-HIA:%x,PE:%x,alg:%08x\n", peid,
+	dev_info(priv->dev, "EIP%d:%x(%d)-HIA:%x(%d,%d),PE:%x,alg:%08x\n", peid,
 		 priv->hwconfig.hwver, hwctg, priv->hwconfig.hiaver,
+		 priv->hwconfig.hwdataw, priv->hwconfig.hwcfsize,
 		 priv->hwconfig.pever, priv->hwconfig.algo_flags);
 
 	safexcel_configure(priv);
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index e9bda97..e01aa70 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -31,6 +31,7 @@
 #define EIP197_MAX_TOKENS			18
 #define EIP197_MAX_RINGS			4
 #define EIP197_FETCH_COUNT			1
+#define EIP197_FETCH_DEPTH			2
 #define EIP197_MAX_BATCH_SZ			64
 
 #define EIP197_GFP_FLAGS(base)	((base).flags & CRYPTO_TFM_REQ_MAY_SLEEP ? \
@@ -225,6 +226,14 @@
 #define EIP197_N_PES_OFFSET			4
 #define EIP197_N_PES_MASK			GENMASK(4, 0)
 #define EIP97_N_PES_MASK			GENMASK(2, 0)
+#define EIP197_HWDATAW_OFFSET			25
+#define EIP197_HWDATAW_MASK			GENMASK(3, 0)
+#define EIP97_HWDATAW_MASK			GENMASK(2, 0)
+#define EIP197_CFSIZE_OFFSET			9
+#define EIP197_CFSIZE_ADJUST			4
+#define EIP97_CFSIZE_OFFSET			8
+#define EIP197_CFSIZE_MASK			GENMASK(3, 0)
+#define EIP97_CFSIZE_MASK			GENMASK(4, 0)
 
 /* EIP197_HIA_AIC_R_ENABLE_CTRL */
 #define EIP197_CDR_IRQ(n)			BIT((n) * 2)
@@ -681,6 +690,8 @@ struct safexcel_hwconfig {
 	int hwver;
 	int hiaver;
 	int pever;
+	int hwdataw;
+	int hwcfsize;
 };
 
 struct safexcel_crypto_priv {
-- 
1.8.3.1

