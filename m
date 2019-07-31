Return-Path: <SRS0=mqYf=V4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C05CDC32751
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 16:28:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EB0A206B8
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 16:28:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oz1kCWfV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbfGaQ2J (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 31 Jul 2019 12:28:09 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:37048 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727485AbfGaQ2I (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Jul 2019 12:28:08 -0400
Received: by mail-ed1-f68.google.com with SMTP id w13so66288537eds.4
        for <linux-crypto@vger.kernel.org>; Wed, 31 Jul 2019 09:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=URNIiMG5C3pXi37zNqMRpwOCONUF9jRh+65X8cu30FQ=;
        b=oz1kCWfV0IRJYJHAOviPwvnht7AuNgvbTF4J22GA1OuMYpk5HaUEz+dNLHmfYoGUwO
         xYZoHnPeHW9vs7SMD4fbtOkWxA1df4TxyzsOql3l3FZ3eKq60dEM9Pnn0ZdbcVzaKds3
         51FHZO+/lb0wE08f2SK5dw/J3zOjb6LdSNBnqHCPG3YUP0Zp8hPmcpe4LCZf57Wzl7yq
         DA4ai5/VrumuxLrqOXcg4J6SS9myNRjOYYLaWZuxKBQi0lx/L6u2rpvzkhk7X9pEH50+
         xJkCqpEagq4zbrzwsv1w8CnhK/D4s3yYBhcP1v5+H9Ugb7DqSY/NOUw/mdS5y2cP5mgK
         9bPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=URNIiMG5C3pXi37zNqMRpwOCONUF9jRh+65X8cu30FQ=;
        b=IP5PIYqmqoTP9QO0+rHH9K9GBdItb6SlieAaEJD85V6+r4VYeE5KnokL26/MAqYpAs
         Y8HOu+nnxQ1UFqwl02w92cM5/1eWXY08KQ3CbyNYbZCsdIguYJQNTfnACcSNO8IGA5C7
         yYpGlSrcOn6tt5NEa807vno9kSUt6KYafB81OEWDD7jADS5KkNVf4ruFQAGnrmT/7ZaL
         SehSM8p2RNPs9GJ6rR0QsxvaZzcY0d1NKzWlHzvDFIqpV/4KOmZAcXz9synCIkH+QOzt
         ErKxQFEurB/42codt/+ftC09Qu0ffoANpbqnRAaztfxKpqEW02hcxbSNj1dkiVOhPtMT
         3aVQ==
X-Gm-Message-State: APjAAAWPbN1yi5j9oIxq4WaWhuXejNE8YWEYO3G4PT6UnAZMfm5FFsc+
        MhlEs2P0sLSt2FM/vMXKiEfWtoih
X-Google-Smtp-Source: APXvYqxaXzjrdRbdnAkjOCfHOG0Hv4atVZm3isCNyu/8LUd3UZTyazzSZsFBNgIx7fy3N5TezDJa4w==
X-Received: by 2002:a17:906:19c6:: with SMTP id h6mr7408075ejd.262.1564590486599;
        Wed, 31 Jul 2019 09:28:06 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id w35sm17418264edd.32.2019.07.31.09.28.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 09:28:06 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@insidesecure.com>,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 4/4] crypto: inside-secure - add support for using the EIP197 without vendor firmware
Date:   Wed, 31 Jul 2019 17:25:30 +0200
Message-Id: <1564586730-9629-5-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564586730-9629-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1564586730-9629-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Pascal van Leeuwen <pvanleeuwen@insidesecure.com>

Until now, the inside-secure driver required a set of firmware images
supplied by the silicon vendor, typically under NDA, to be present in
/lib/firmware/inside-secure in order to be able to function.
This patch removes the dependence on this official vendor firmware by
falling back to generic "mini" FW - developed specifically for this
driver - that can be provided under GPL 2.0 through linux-firmwares.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c | 194 ++++++++++++++++++++++++--------
 drivers/crypto/inside-secure/safexcel.h |  12 ++
 2 files changed, 161 insertions(+), 45 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 01e03ca..e25beef 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -108,44 +108,143 @@ static void eip197_trc_cache_init(struct safexcel_crypto_priv *priv)
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
+	/* Exclude final 2 NOPs from size */
+	return i - EIP197_FW_TERMINAL_NOPS;
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
 
-	/* Release engine from reset */
-	val = readl(EIP197_PE(priv) + ctrl);
-	val &= ~EIP197_PE_ICE_x_CTRL_SW_RESET;
-	writel(val, EIP197_PE(priv) + ctrl);
+	for (pe = 0; pe < priv->config.pes; pe++) {
+		base = EIP197_PE_ICE_SCRATCH_RAM(pe);
+		pollcnt = EIP197_FW_START_POLLCNT;
+		while (pollcnt &&
+		       (readl_relaxed(EIP197_PE(priv) + base +
+			      pollofs) != 1)) {
+			pollcnt--;
+		}
+		if (!pollcnt) {
+			dev_err(priv->dev, "FW(%d) for PE %d failed to start\n",
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
+			val = EIP197_PE_ICE_UENG_START_OFFSET((ifppsz - 1) &
+					EIP197_PE_ICE_UENG_INIT_ALIGN_MASK) |
+				EIP197_PE_ICE_UENG_DEBUG_RESET;
+		writel(val, EIP197_PE(priv) + EIP197_PE_ICE_FPP_CTRL(pe));
+
+		/* Start IPUE microengines */
+		if (minifw)
+			val = 0;
+		else
+			val = EIP197_PE_ICE_UENG_START_OFFSET((ipuesz - 1) &
+					EIP197_PE_ICE_UENG_INIT_ALIGN_MASK) |
+				EIP197_PE_ICE_UENG_DEBUG_RESET;
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
 
 	if (priv->version == EIP197D_MRVL)
 		dir = "eip197d";
@@ -155,51 +254,56 @@ static int eip197_load_firmwares(struct safexcel_crypto_priv *priv)
 	else
 		return -ENODEV;
 
+retry_fw:
 	for (i = 0; i < FW_NB; i++) {
-		snprintf(fw_path, 31, "inside-secure/%s/%s", dir, fw_name[i]);
-		ret = request_firmware(&fw[i], fw_path, priv->dev);
+		snprintf(fw_path, 37, "inside-secure/%s/%s", dir, fw_name[i]);
+		ret = firmware_request_nowarn(&fw[i], fw_path, priv->dev);
 		if (ret) {
-			if (priv->version != EIP197B_MRVL)
+			if (minifw || priv->version != EIP197B_MRVL)
 				goto release_fw;
 
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
 
-		memset_io(EIP197_PE(priv) + EIP197_PE_ICE_SCRATCH_RAM(pe), 0,
-			  EIP197_NUM_OF_SCRATCH_BLOCKS * sizeof(u32));
+	ifppsz = eip197_write_firmware(priv, fw[FW_IFPP]);
 
-		eip197_write_firmware(priv, fw[FW_IFPP], pe,
-				      EIP197_PE_ICE_FPP_CTRL(pe),
-				      EIP197_PE_ICE_RAM_CTRL_FPP_PROG_EN);
+	/* Enable access to IPUE program memories */
+	for (pe = 0; pe < priv->config.pes; pe++)
+		writel(EIP197_PE_ICE_RAM_CTRL_PUE_PROG_EN,
+		       EIP197_PE(priv) + EIP197_PE_ICE_RAM_CTRL(pe));
 
-		eip197_write_firmware(priv, fw[FW_IPUE], pe,
-				      EIP197_PE_ICE_PUE_CTRL(pe),
-				      EIP197_PE_ICE_RAM_CTRL_PUE_PROG_EN);
+	ipuesz = eip197_write_firmware(priv, fw[FW_IPUE]);
+
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
+		dev_dbg(priv->dev, "Firmware set not (fully) present or init failed, falling back to BCLA mode\n");
+		dir = "eip197_minifw";
+		minifw = 1;
+		goto retry_fw;
+	}
+
+	dev_dbg(priv->dev, "Firmware load failed.\n");
+
 	return ret;
 }
 
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index a9a239b..ffb1c66 100644
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
@@ -228,6 +230,11 @@
 #define EIP197_DxE_THR_CTRL_EN			BIT(30)
 #define EIP197_DxE_THR_CTRL_RESET_PE		BIT(31)
 
+/* EIP197_PE_ICE_PUE/FPP_CTRL */
+#define EIP197_PE_ICE_UENG_START_OFFSET(n)	((n) << 16)
+#define EIP197_PE_ICE_UENG_INIT_ALIGN_MASK	0x7ff0
+#define EIP197_PE_ICE_UENG_DEBUG_RESET		BIT(3)
+
 /* EIP197_HIA_AIC_G_ENABLED_STAT */
 #define EIP197_G_IRQ_DFE(n)			BIT((n) << 1)
 #define EIP197_G_IRQ_DSE(n)			BIT(((n) << 1) + 1)
@@ -530,6 +537,11 @@ struct safexcel_command_desc {
  * Internal structures & functions
  */
 
+#define EIP197_FW_TERMINAL_NOPS		2
+#define EIP197_FW_START_POLLCNT		16
+#define EIP197_FW_PUE_READY		0x14
+#define EIP197_FW_FPP_READY		0x18
+
 enum eip197_fw {
 	FW_IFPP = 0,
 	FW_IPUE,
-- 
1.8.3.1

