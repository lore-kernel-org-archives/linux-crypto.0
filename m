Return-Path: <SRS0=jBdH=UR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E8BAC31E5D
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jun 2019 06:59:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC61420665
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jun 2019 06:59:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AzQthxDl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbfFRG7A (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Jun 2019 02:59:00 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:42233 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726888AbfFRG7A (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jun 2019 02:59:00 -0400
Received: by mail-ed1-f68.google.com with SMTP id z25so20011396edq.9
        for <linux-crypto@vger.kernel.org>; Mon, 17 Jun 2019 23:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=sLMPHDH/uXW2Y9oa5hmdZntsr+mVybyBOkos3yxznXs=;
        b=AzQthxDlh82iZNIUWO5X8+VQau+7ppvYAhmF1PJZ7KWif5AtI1RUIaadZ4iq8Kd1SJ
         cbrn9Uu7Iwlk9GB1eP57kLM+jAVoA2NSz225hcPOyYPVDdlOumxeIxu42ZlzE7mSPzlt
         ObbrZ3/rIwJTbkMC4sXsiltyYKSyP8HJgH7RX/8j/bwIKbeX5nvkLz7+kK/P+vrFYzM8
         qANBxzfX9tBoXnM0DEDE/mwZSBf32nDJLNJTpweiCOpggR/JDZccncyWGmQbwRxIKZ/6
         FipfBqoZ4Gv7AGUuC86kjmIm5pC2olfgAuqVlG/NI3PRflWGh+fRPz4jQlLv8mye+K0J
         r1KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=sLMPHDH/uXW2Y9oa5hmdZntsr+mVybyBOkos3yxznXs=;
        b=j0iWhBHBvqY1M7CW2cmo4/bBj2zyFuHGKwCPpBpK87b0z/ZGXHxcJw0q7DsXA05ptv
         FvzMklSCr7GAs5hTkP0pRWiPqN5uhZT7Wnr9zBpyNd3HS8yrPRPCr/tADDFrqUetQrCo
         vHyA1WD5JM+hT+RUOmJhpxexmAcoOSagMBDq2AzCq2DUKhjUbKc6mVJBVLkoyNGh2HOr
         ikXCRplGrBYBY2/4RkUCdUdJ3A2l4BmJ1xRon47ugbvcQAONOLADigqvX4288AmHtquN
         FKfeSWjhKy3l3N2dAcCp4BLLi8f6k5328DkvOwxcKrTUi6SazeYXiM3GcFRSJZlbYH32
         ebww==
X-Gm-Message-State: APjAAAXdPwnXD8Wo1gM8dic07I7hndojTMxFGdJ5bhKQBPGfFWBLjX/C
        kZQl4D5EGnh5PdJcRrLcQDfqEWQ+
X-Google-Smtp-Source: APXvYqy3xqp72In/ofsSlmR4lnII3Kg9kfwB9CS1SUSy6lWRrMO0CdxV0FZt9mirJG+B+AD4VOCHWg==
X-Received: by 2002:a17:906:94ce:: with SMTP id d14mr78736117ejy.251.1560841137538;
        Mon, 17 Jun 2019 23:58:57 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id q2sm2602291ejk.46.2019.06.17.23.58.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 23:58:57 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@insidesecure.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@insidesecure.com>
Subject: [PATCH 3/3] crypto: inside-secure - add support for using the EIP197 without firmware images
Date:   Tue, 18 Jun 2019 07:56:24 +0200
Message-Id: <1560837384-29814-4-git-send-email-pvanleeuwen@insidesecure.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1560837384-29814-1-git-send-email-pvanleeuwen@insidesecure.com>
References: <1560837384-29814-1-git-send-email-pvanleeuwen@insidesecure.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Until now, the inside-secure driver required a set of firmware images to be
present in /lib/firmware/inside-secure in order to be able to function.
These firmware images were not available to the general public and diffi-
cult to obtain (only under NDA from Marvell). Also, the driver did and does
not use any specific firmware functionality. This patch removes the depen-
dence on those firmware images.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@insidesecure.com>
---
 drivers/crypto/inside-secure/safexcel.c | 217 +++++++++++++++++++++++++-------
 drivers/crypto/inside-secure/safexcel.h |   6 +
 2 files changed, 180 insertions(+), 43 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index a6a0f48..e1781b2 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -107,44 +107,160 @@ static void eip197_trc_cache_init(struct safexcel_crypto_priv *priv)
 	writel(val, priv->base + EIP197_TRC_PARAMS);
 }
 
-static void eip197_write_firmware(struct safexcel_crypto_priv *priv,
-				  const struct firmware *fw, int pe, u32 ctrl,
-				  u32 prog_en)
+static void eip197_init_firmware(struct safexcel_crypto_priv *priv)
 {
-	const u32 *data = (const u32 *)fw->data;
+	int pe, i;
 	u32 val;
-	int i;
 
-	/* Reset the engine to make its program memory accessible */
-	writel(EIP197_PE_ICE_x_CTRL_SW_RESET |
-	       EIP197_PE_ICE_x_CTRL_CLR_ECC_CORR |
-	       EIP197_PE_ICE_x_CTRL_CLR_ECC_NON_CORR,
-	       EIP197_PE(priv) + ctrl);
+	for (pe = 0; pe < priv->config.pes; pe++) {
+		/* Configure the token FIFO's */
+		writel(3, EIP197_PE(priv) + EIP197_PE_ICE_PUTF_CTRL(pe));
+		writel(0, EIP197_PE(priv) + EIP197_PE_ICE_PPTF_CTRL(pe));
+
+		/* Clear the ICE scratchpad memory */
+		val = readl(EIP197_PE(priv) + EIP197_PE_ICE_SCRATCH_CTRL(pe));
+		val |= EIP197_PE_ICE_SCRATCH_CTRL_CHANGE_TIMER |
+		       EIP197_PE_ICE_SCRATCH_CTRL_TIMER_EN |
+		       EIP197_PE_ICE_SCRATCH_CTRL_SCRATCH_ACCESS |
+		       EIP197_PE_ICE_SCRATCH_CTRL_CHANGE_ACCESS;
+		writel(val, EIP197_PE(priv) + EIP197_PE_ICE_SCRATCH_CTRL(pe));
+
+		/* clear the scratchpad RAM using 32 bit writes only */
+		for (i = 0; i < EIP197_NUM_OF_SCRATCH_BLOCKS; i++)
+			writel(0, EIP197_PE(priv) +
+				  EIP197_PE_ICE_SCRATCH_RAM(pe) + (i<<2));
+
+		/* Reset the IFPP engine to make its program mem accessible */
+		writel(EIP197_PE_ICE_x_CTRL_SW_RESET |
+		       EIP197_PE_ICE_x_CTRL_CLR_ECC_CORR |
+		       EIP197_PE_ICE_x_CTRL_CLR_ECC_NON_CORR,
+		       EIP197_PE(priv) + EIP197_PE_ICE_FPP_CTRL(pe));
+
+		/* Reset the IPUE engine to make its program mem accessible */
+		writel(EIP197_PE_ICE_x_CTRL_SW_RESET |
+		       EIP197_PE_ICE_x_CTRL_CLR_ECC_CORR |
+		       EIP197_PE_ICE_x_CTRL_CLR_ECC_NON_CORR,
+		       EIP197_PE(priv) + EIP197_PE_ICE_PUE_CTRL(pe));
+
+		/* Enable access to all IFPP program memories */
+		writel(EIP197_PE_ICE_RAM_CTRL_FPP_PROG_EN,
+		       EIP197_PE(priv) + EIP197_PE_ICE_RAM_CTRL(pe));
+	}
+
+}
 
-	/* Enable access to the program memory */
-	writel(prog_en, EIP197_PE(priv) + EIP197_PE_ICE_RAM_CTRL(pe));
+static int eip197_write_firmware(struct safexcel_crypto_priv *priv,
+				  const struct firmware *fw)
+{
+	const u32 *data = (const u32 *)fw->data;
+	int i;
 
 	/* Write the firmware */
 	for (i = 0; i < fw->size / sizeof(u32); i++)
 		writel(be32_to_cpu(data[i]),
 		       priv->base + EIP197_CLASSIFICATION_RAMS + i * sizeof(u32));
 
-	/* Disable access to the program memory */
-	writel(0, EIP197_PE(priv) + EIP197_PE_ICE_RAM_CTRL(pe));
+	return i - 2;
+}
+
+/*
+ * If FW is actual production firmware, then poll for its initialization
+ * to complete and check if it is good for the HW, otherwise just return OK.
+ */
+static bool poll_fw_ready(struct safexcel_crypto_priv *priv, int fpp)
+{
+	int pe, pollcnt;
+	u32 base, pollofs;
+
+	if (fpp)
+		pollofs  = EIP197_FW_FPP_READY;
+	else
+		pollofs  = EIP197_FW_PUE_READY;
+
+	for (pe = 0; pe < priv->config.pes; pe++) {
+		base = EIP197_PE_ICE_SCRATCH_RAM(pe);
+		pollcnt = EIP197_FW_START_POLLCNT;
+		while (pollcnt &&
+		       (readl(EIP197_PE(priv) + base +
+			      pollofs) != 1)) {
+			pollcnt--;
+			cpu_relax();
+		}
+		if (!pollcnt) {
+			dev_err(priv->dev, "FW(%d) for PE %d failed to start",
+				fpp, pe);
+			return false;
+		}
+	}
+	return true;
+}
+
+static bool eip197_start_firmware(struct safexcel_crypto_priv *priv,
+				  int ipuesz, int ifppsz)
+{
+	int pe;
+	u32 val;
+
+	for (pe = 0; pe < priv->config.pes; pe++) {
+		/* Disable access to all program memory */
+		writel(0, EIP197_PE(priv) + EIP197_PE_ICE_RAM_CTRL(pe));
+
+		/* Start IFPP microengines */
+		if (ifppsz)
+			val = (((ifppsz - 1) & 0x7ff0) << 16) | BIT(3);
+		else
+			val = 0;
+		writel(val, EIP197_PE(priv) + EIP197_PE_ICE_FPP_CTRL(pe));
+
+		/* Start IPUE microengines */
+		if (ipuesz)
+			val = ((ipuesz - 1) & 0x7ff0) << 16 | BIT(3);
+		else
+			val = 0;
+		writel(val, EIP197_PE(priv) + EIP197_PE_ICE_PUE_CTRL(pe));
+	}
+
+	/* For miniFW startup, there is no initialization, so always succeed */
+	if ((!ipuesz) && (!ifppsz))
+		return true;
+
+	/* Wait until all the firmwares have properly started up */
+	if (!poll_fw_ready(priv, 1))
+		return false;
+	if (!poll_fw_ready(priv, 0))
+		return false;
 
-	/* Release engine from reset */
-	val = readl(EIP197_PE(priv) + ctrl);
-	val &= ~EIP197_PE_ICE_x_CTRL_SW_RESET;
-	writel(val, EIP197_PE(priv) + ctrl);
+	return true;
 }
 
 static int eip197_load_firmwares(struct safexcel_crypto_priv *priv)
 {
+	/*
+	 * The embedded one-size-fits-all MiniFW is just for handling TR
+	 * prefetch & invalidate. It does not support any FW flows, effectively
+	 * turning the EIP197 into a glorified EIP97
+	 */
+	const u32 ipue_minifw[] = {
+		 0x24808200, 0x2D008204, 0x2680E208, 0x2780E20C,
+		 0x2200F7FF, 0x38347000, 0x2300F000, 0x15200A80,
+		 0x01699003, 0x60038011, 0x38B57000, 0x0119F04C,
+		 0x01198548, 0x20E64000, 0x20E75000, 0x1E200000,
+		 0x30E11000, 0x103A93FF, 0x60830014, 0x5B8B0000,
+		 0xC0389000, 0x600B0018, 0x2300F000, 0x60800011,
+		 0x90800000, 0x10000000, 0x10000000};
+	const u32 ifpp_minifw[] = {
+		 0x21008000, 0x260087FC, 0xF01CE4C0, 0x60830006,
+		 0x530E0000, 0x90800000, 0x23008004, 0x24808008,
+		 0x2580800C, 0x0D300000, 0x205577FC, 0x30D42000,
+		 0x20DAA7FC, 0x43107000, 0x42220004, 0x00000000,
+		 0x00000000, 0x00000000, 0x00000000, 0x00000000,
+		 0x00060004, 0x20337004, 0x90800000, 0x10000000,
+		 0x10000000};
 	const char *fw_name[] = {"ifpp.bin", "ipue.bin"};
 	const struct firmware *fw[FW_NB];
 	char fw_path[31], *dir = NULL;
 	int i, j, ret = 0, pe;
-	u32 val;
+	int ipuesz, ifppsz;
 
 	if (priv->version & EIP197B)
 		dir = "eip197b";
@@ -156,7 +272,7 @@ static int eip197_load_firmwares(struct safexcel_crypto_priv *priv)
 
 	for (i = 0; i < FW_NB; i++) {
 		snprintf(fw_path, 31, "inside-secure/%s/%s", dir, fw_name[i]);
-		ret = request_firmware(&fw[i], fw_path, priv->dev);
+		ret = firmware_request_nowarn(&fw[i], fw_path, priv->dev);
 		if (ret) {
 			if (!(priv->version & EIP197B))
 				goto release_fw;
@@ -164,42 +280,57 @@ static int eip197_load_firmwares(struct safexcel_crypto_priv *priv)
 			/* Fallback to the old firmware location for the
 			 * EIP197b.
 			 */
-			ret = request_firmware(&fw[i], fw_name[i], priv->dev);
-			if (ret) {
-				dev_err(priv->dev,
-					"Failed to request firmware %s (%d)\n",
-					fw_name[i], ret);
+			ret = firmware_request_nowarn(&fw[i], fw_name[i],
+						      priv->dev);
+			if (ret)
 				goto release_fw;
-			}
 		}
 	}
 
-	for (pe = 0; pe < priv->config.pes; pe++) {
-		/* Clear the scratchpad memory */
-		val = readl(EIP197_PE(priv) + EIP197_PE_ICE_SCRATCH_CTRL(pe));
-		val |= EIP197_PE_ICE_SCRATCH_CTRL_CHANGE_TIMER |
-		       EIP197_PE_ICE_SCRATCH_CTRL_TIMER_EN |
-		       EIP197_PE_ICE_SCRATCH_CTRL_SCRATCH_ACCESS |
-		       EIP197_PE_ICE_SCRATCH_CTRL_CHANGE_ACCESS;
-		writel(val, EIP197_PE(priv) + EIP197_PE_ICE_SCRATCH_CTRL(pe));
+	eip197_init_firmware(priv);
+
+	ifppsz = eip197_write_firmware(priv, fw[FW_IFPP]);
 
-		memset_io(EIP197_PE(priv) + EIP197_PE_ICE_SCRATCH_RAM(pe), 0,
-			  EIP197_NUM_OF_SCRATCH_BLOCKS * sizeof(u32));
+	/* Enable access to IPUE program memories */
+	for (pe = 0; pe < priv->config.pes; pe++)
+		writel(EIP197_PE_ICE_RAM_CTRL_PUE_PROG_EN,
+		       EIP197_PE(priv) + EIP197_PE_ICE_RAM_CTRL(pe));
 
-		eip197_write_firmware(priv, fw[FW_IFPP], pe,
-				      EIP197_PE_ICE_FPP_CTRL(pe),
-				      EIP197_PE_ICE_RAM_CTRL_FPP_PROG_EN);
+	ipuesz = eip197_write_firmware(priv, fw[FW_IPUE]);
 
-		eip197_write_firmware(priv, fw[FW_IPUE], pe,
-				      EIP197_PE_ICE_PUE_CTRL(pe),
-				      EIP197_PE_ICE_RAM_CTRL_PUE_PROG_EN);
+	if (eip197_start_firmware(priv, ipuesz, ifppsz)) {
+		dev_info(priv->dev, "EIP197 firmware loaded successfully");
+		return 0;
 	}
 
 release_fw:
 	for (j = 0; j < i; j++)
 		release_firmware(fw[j]);
 
-	return ret;
+	/*
+	 * Firmware download failed, fall back to EIP97 BCLA mode
+	 * Note that this is not a formally supported mode for the EIP197,
+	 * so your mileage may vary
+	 */
+	dev_info(priv->dev, "EIP197 firmware set not (fully) present or init failed, falling back to EIP97 BCLA mode");
+
+	eip197_init_firmware(priv);
+
+	for (i = 0; i < sizeof(ifpp_minifw)>>2; i++)
+		writel(ifpp_minifw[i],
+		       priv->base + EIP197_CLASSIFICATION_RAMS + (i<<2));
+
+	/* Enable access to IPUE program memories */
+	for (pe = 0; pe < priv->config.pes; pe++)
+		writel(EIP197_PE_ICE_RAM_CTRL_PUE_PROG_EN,
+		       EIP197_PE(priv) + EIP197_PE_ICE_RAM_CTRL(pe));
+
+	for (i = 0; i < sizeof(ipue_minifw)>>2; i++)
+		writel(ipue_minifw[i],
+		       priv->base + EIP197_CLASSIFICATION_RAMS + (i<<2));
+
+	eip197_start_firmware(priv, 0, 0);
+	return 0;
 }
 
 static int safexcel_hw_setup_cdesc_rings(struct safexcel_crypto_priv *priv)
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index 924270e..380ba72 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -128,8 +128,10 @@
 #define EIP197_PE_IN_TBUF_THRES(n)		(0x0100 + (0x2000 * (n)))
 #define EIP197_PE_ICE_SCRATCH_RAM(n)		(0x0800 + (0x2000 * (n)))
 #define EIP197_PE_ICE_PUE_CTRL(n)		(0x0c80 + (0x2000 * (n)))
+#define EIP197_PE_ICE_PUTF_CTRL(n)		(0x0d00 + (0x2000 * (n)))
 #define EIP197_PE_ICE_SCRATCH_CTRL(n)		(0x0d04 + (0x2000 * (n)))
 #define EIP197_PE_ICE_FPP_CTRL(n)		(0x0d80 + (0x2000 * (n)))
+#define EIP197_PE_ICE_PPTF_CTRL(n)		(0x0e00 + (0x2000 * (n)))
 #define EIP197_PE_ICE_RAM_CTRL(n)		(0x0ff0 + (0x2000 * (n)))
 #define EIP197_PE_EIP96_TOKEN_CTRL(n)		(0x1000 + (0x2000 * (n)))
 #define EIP197_PE_EIP96_FUNCTION_EN(n)		(0x1004 + (0x2000 * (n)))
@@ -522,6 +524,10 @@ struct safexcel_command_desc {
  * Internal structures & functions
  */
 
+#define EIP197_FW_START_POLLCNT		16
+#define EIP197_FW_PUE_READY             0x14
+#define EIP197_FW_FPP_READY             0x18
+
 enum eip197_fw {
 	FW_IFPP = 0,
 	FW_IPUE,
-- 
1.8.3.1

