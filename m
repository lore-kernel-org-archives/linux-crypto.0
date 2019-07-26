Return-Path: <SRS0=5D8e=VX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DCF6C7618B
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 13:46:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0FBF22CE8
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 13:46:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p116ZgMo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388714AbfGZNq2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jul 2019 09:46:28 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:41279 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388706AbfGZNq2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jul 2019 09:46:28 -0400
Received: by mail-ed1-f65.google.com with SMTP id p15so53298886eds.8
        for <linux-crypto@vger.kernel.org>; Fri, 26 Jul 2019 06:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7GWRjN+h8VxTSHo6gHqpeTxdDWC4Tob4LN4YAG9hhzo=;
        b=p116ZgMoh9CbxCKa1v7Ji5X6L6Y9jQygSXakCFUNVYHIB3y886bMo5M68tm494Mhel
         PYm+fdRIZkApR0Q50y/H7w3BCpImXyrbsv8GmSHWsqbfjtXZLjDaWUlfcDDFUvKOIbED
         7CIFYLWxg/FpkiepArLN02nZWb/Xglt8ecmAN19XE8qdZ38WZpFVZcmKXQdgLDKEluzm
         +a4Wn+Wwn3zsRBGrhYbJurF2L0KtxXSvXx+VX/vBHPXygctjsioF5SgffN0kFGoR9mzW
         /Xkx0pk0WL0j8A3TDSEpWxpMviCyUx+A7yowUEoDiSF3GYjv+4Mw883MecuzNuCn9w33
         xNIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7GWRjN+h8VxTSHo6gHqpeTxdDWC4Tob4LN4YAG9hhzo=;
        b=S/yv94mTkmxwHGOgqoeKoSnyg2tVfZ1xvLoF+rO9qx5fM0j9nsCdHjjZ1djdB4hzIj
         +614lCZeEwDanxOyu/QyLk7iV9jUmtoT8SaqyRF9fmjV/zzUuqmOI2L7EoN0MVTQ0b35
         I8rjCoMEBxsOImH2m06mNyrLIXx3ClMa+KTu30U9+Qk0fTa8dTSEzegmwuqzvGJ5zWmZ
         PHxcRoLmJwYSOzPXT5cmCI0NWfr4YP7kJ2ECb0/+1qyllS+Bvu/Lr5uxCvT5jprmaDL0
         1thWSlxRPnnb6a28CwLmTkVskd3tUzNhbm8N+uz0cuZdHwwx+jlwZF07Vqf1vO1lm2dB
         UJ/A==
X-Gm-Message-State: APjAAAVf7M9bh7kOzLyMVuTXyIs2uBqZJZXrg/9p8keufQLgf1qaWgvI
        GbOfTUrLWIzGoe5FPj+DDiRmTHcI
X-Google-Smtp-Source: APXvYqxoegy48Xl+zG6VuaTQkkCLqEttbSYespZAiakmI2O9ZbJYio2TphouzvZnmT1q6T2A0TG9Zg==
X-Received: by 2002:aa7:ca41:: with SMTP id j1mr84178827edt.149.1564148785891;
        Fri, 26 Jul 2019 06:46:25 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id 34sm14061423eds.5.2019.07.26.06.46.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 06:46:25 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCHv2 3/3] crypto: inside-secure - add support for using the EIP197 without vendor firmware
Date:   Fri, 26 Jul 2019 14:43:25 +0200
Message-Id: <1564145005-26731-4-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564145005-26731-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1564145005-26731-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Until now, the inside-secure driver required a set of firmware images
supplied by the silicon vendor, typically under NDA, to be present in
/lib/firmware/inside-secure in order to be able to function.
This patch removes the dependence on this official vendor firmware by
falling back to generic "mini" FW - developed specifically for this
driver - that can be provided under GPL 2.0 through linux-firmwares.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c | 194 ++++++++++++++++++++++++--------
 drivers/crypto/inside-secure/safexcel.h |   6 +
 2 files changed, 153 insertions(+), 47 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index fe9b6d0..503fef0 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -108,44 +108,139 @@ static void eip197_trc_cache_init(struct safexcel_crypto_priv *priv)
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
 
-	/* Enable access to the program memory */
-	writel(prog_en, EIP197_PE(priv) + EIP197_PE_ICE_RAM_CTRL(pe));
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
+
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
 
-	/* Release engine from reset */
-	val = readl(EIP197_PE(priv) + ctrl);
-	val &= ~EIP197_PE_ICE_x_CTRL_SW_RESET;
-	writel(val, EIP197_PE(priv) + ctrl);
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
+				  int ipuesz, int ifppsz, int minifw)
+{
+	int pe;
+	u32 val;
+
+	for (pe = 0; pe < priv->config.pes; pe++) {
+		/* Disable access to all program memory */
+		writel(0, EIP197_PE(priv) + EIP197_PE_ICE_RAM_CTRL(pe));
+
+		/* Start IFPP microengines */
+		if (minifw)
+			val = 0;
+		else
+			val = (((ifppsz - 1) & 0x7ff0) << 16) | BIT(3);
+		writel(val, EIP197_PE(priv) + EIP197_PE_ICE_FPP_CTRL(pe));
+
+		/* Start IPUE microengines */
+		if (minifw)
+			val = 0;
+		else
+			val = ((ipuesz - 1) & 0x7ff0) << 16 | BIT(3);
+		writel(val, EIP197_PE(priv) + EIP197_PE_ICE_PUE_CTRL(pe));
+	}
+
+	/* For miniFW startup, there is no initialization, so always succeed */
+	if (minifw)
+		return true;
+
+	/* Wait until all the firmwares have properly started up */
+	if (!poll_fw_ready(priv, 1))
+		return false;
+	if (!poll_fw_ready(priv, 0))
+		return false;
+
+	return true;
 }
 
 static int eip197_load_firmwares(struct safexcel_crypto_priv *priv)
 {
 	const char *fw_name[] = {"ifpp.bin", "ipue.bin"};
 	const struct firmware *fw[FW_NB];
-	char fw_path[31], *dir = NULL;
+	char fw_path[37], *dir = NULL;
 	int i, j, ret = 0, pe;
-	u32 val;
+	int ipuesz, ifppsz, minifw = 0;
 
 	if (priv->version == EIP97IES_MRVL)
 		/* No firmware is required */
@@ -156,52 +251,57 @@ static int eip197_load_firmwares(struct safexcel_crypto_priv *priv)
 		/* Default to minimum EIP197 config */
 		dir = "eip197b";
 
+retry_fw:
 	for (i = 0; i < FW_NB; i++) {
-		snprintf(fw_path, 31, "inside-secure/%s/%s", dir, fw_name[i]);
-		ret = request_firmware(&fw[i], fw_path, priv->dev);
+		snprintf(fw_path, 37, "inside-secure/%s/%s", dir, fw_name[i]);
+		ret = firmware_request_nowarn(&fw[i], fw_path, priv->dev);
 		if (ret) {
-			if (!(priv->version == EIP197B_MRVL))
+			if (minifw || !(priv->version == EIP197B_MRVL))
 				goto release_fw;
 
 			/*
 			 * Fallback to the old firmware location for the
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
+	if (eip197_start_firmware(priv, ipuesz, ifppsz, minifw)) {
+		dev_dbg(priv->dev, "Firmware loaded successfully");
+		return 0;
 	}
 
+	ret = -ENODEV;
+
 release_fw:
 	for (j = 0; j < i; j++)
 		release_firmware(fw[j]);
 
+	if (!minifw) {
+		/* Retry with minifw path */
+		dev_dbg(priv->dev, "Firmware set not (fully) present or init failed, falling back to BCLA mode");
+		dir = "eip197_minifw";
+		minifw = 1;
+		goto retry_fw;
+	}
+
+	dev_dbg(priv->dev, "Firmware load failed.");
+
 	return ret;
 }
 
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index d07bec1..ed47df0 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -136,8 +136,10 @@
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
@@ -530,6 +532,10 @@ struct safexcel_command_desc {
  * Internal structures & functions
  */
 
+#define EIP197_FW_START_POLLCNT		16
+#define EIP197_FW_PUE_READY		0x14
+#define EIP197_FW_FPP_READY		0x18
+
 enum eip197_fw {
 	FW_IFPP = 0,
 	FW_IPUE,
-- 
1.8.3.1

