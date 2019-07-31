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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5510C32751
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 16:28:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87A3C206B8
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 16:28:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rXPmx5HS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727485AbfGaQ2L (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 31 Jul 2019 12:28:11 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:44951 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727276AbfGaQ2J (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Jul 2019 12:28:09 -0400
Received: by mail-ed1-f68.google.com with SMTP id k8so66205230edr.11
        for <linux-crypto@vger.kernel.org>; Wed, 31 Jul 2019 09:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8QFJTc1X1I81naecmEeFOggEyKc+eqgKxq166uj3RXY=;
        b=rXPmx5HSicVSB3cOjtEZvgS8YixRrlLppZwpwU2g7r2pAI+scEnrKsZpAM1cWZ+wTJ
         FxHAgLoaU8uX3+kJv/cTe1R7OAE/fWG91xTV9GF5RFCbfLYvZ+L7QcyGIhLyNoUFYwdt
         pBDp807j/9DbFu/a13dnSxUwtxgYqzrK68Jc8dA6yOfyS59QaJN7d4I2ZR8rfhe0RVHb
         GpU+5XGMHp9XWbqxhA4X7ZQz41DH5WgIJOVwXT8sMd3o9K+/19oL8bOYpQG0puSanjgm
         BZAOCEjaCsEIWfq8iCpph6FPM6UJiVbU1OcfTmYSjQv0wUcqG3dDFkC3DKt85zhaLjJd
         u4nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8QFJTc1X1I81naecmEeFOggEyKc+eqgKxq166uj3RXY=;
        b=LkTjwP0tibdSHO/+t0xCbHIcfIRYkltmACAFp5EEGnAyq+CqRi3+KQ0CpPhKqzTDMf
         MmWYW+pI+aA+LOFe3ktC+nDnaLf/TViyp/7r1oa0WsnESEJOI2VJPocijpUm3HXK2faX
         SwY1xiYoz5ciAZIUZ/M2ptI9wdNTSCpr/8yQ63b3VLIRKvcMADXWWw/ikJqF8qkDLsgi
         dMJ0Z2a+rY1OpfOVaeTFntpLHdRkmFygXWIeMLJInn7IiNubqEpoxOcSfLfyxBH/RIfn
         Cg8Zi6yU4dY9952div0BmAlWgQlVa89r3+ykk67vvAMeXp8Jr13AcuhdLc7NQzdeg/6S
         5feg==
X-Gm-Message-State: APjAAAVC2oRcWo1EoeHegtkFOwFN6M+VAldjQIZR+R/D9sa1IQDhsB6p
        Aum80Hw1O4For2Iggq9RPbQr9dQ1
X-Google-Smtp-Source: APXvYqwAig6Gx/p0GcHa6XOb3u29k/kQZ3opNnoFXL9UWpW8J5Jjnn8SAKBYHmXrXB1x+VRuSgibrw==
X-Received: by 2002:aa7:c393:: with SMTP id k19mr107745757edq.76.1564590485928;
        Wed, 31 Jul 2019 09:28:05 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id w35sm17418264edd.32.2019.07.31.09.28.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 09:28:05 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@insidesecure.com>,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 3/4] crypto: inside-secure - add support for PCI based FPGA development board
Date:   Wed, 31 Jul 2019 17:25:29 +0200
Message-Id: <1564586730-9629-4-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564586730-9629-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1564586730-9629-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Pascal van Leeuwen <pvanleeuwen@insidesecure.com>

This patch adds support for a PCIE development board with FPGA from Xilinx,
to facilitate pre-silicon driver development by both Inside Secure and its
IP customers. Since Inside Secure neither produces nor has access to actual
silicon, this is required functionality to allow us to contribute.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c      | 560 +++++++++++++++++++--------
 drivers/crypto/inside-secure/safexcel.h      |  30 +-
 drivers/crypto/inside-secure/safexcel_ring.c |   3 +-
 3 files changed, 420 insertions(+), 173 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index a066152..01e03ca 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/of_platform.h>
 #include <linux/of_irq.h>
+#include <linux/pci.h>
 #include <linux/platform_device.h>
 #include <linux/workqueue.h>
 
@@ -32,16 +33,17 @@ static void eip197_trc_cache_init(struct safexcel_crypto_priv *priv)
 	u32 val, htable_offset;
 	int i, cs_rc_max, cs_ht_wc, cs_trc_rec_wc, cs_trc_lg_rec_wc;
 
-	if (priv->version == EIP197B) {
-		cs_rc_max = EIP197B_CS_RC_MAX;
-		cs_ht_wc = EIP197B_CS_HT_WC;
-		cs_trc_rec_wc = EIP197B_CS_TRC_REC_WC;
-		cs_trc_lg_rec_wc = EIP197B_CS_TRC_LG_REC_WC;
-	} else {
+	if (priv->version == EIP197D_MRVL) {
 		cs_rc_max = EIP197D_CS_RC_MAX;
 		cs_ht_wc = EIP197D_CS_HT_WC;
 		cs_trc_rec_wc = EIP197D_CS_TRC_REC_WC;
 		cs_trc_lg_rec_wc = EIP197D_CS_TRC_LG_REC_WC;
+	} else {
+		/* Default to minimum "safe" settings */
+		cs_rc_max = EIP197B_CS_RC_MAX;
+		cs_ht_wc = EIP197B_CS_HT_WC;
+		cs_trc_rec_wc = EIP197B_CS_TRC_REC_WC;
+		cs_trc_lg_rec_wc = EIP197B_CS_TRC_LG_REC_WC;
 	}
 
 	/* Enable the record cache memory access */
@@ -145,23 +147,19 @@ static int eip197_load_firmwares(struct safexcel_crypto_priv *priv)
 	int i, j, ret = 0, pe;
 	u32 val;
 
-	switch (priv->version) {
-	case EIP197B:
-		dir = "eip197b";
-		break;
-	case EIP197D:
+	if (priv->version == EIP197D_MRVL)
 		dir = "eip197d";
-		break;
-	default:
-		/* No firmware is required */
-		return 0;
-	}
+	else if (priv->version == EIP197D_MRVL ||
+		 priv->version == EIP197_DEVBRD)
+		dir = "eip197b";
+	else
+		return -ENODEV;
 
 	for (i = 0; i < FW_NB; i++) {
 		snprintf(fw_path, 31, "inside-secure/%s/%s", dir, fw_name[i]);
 		ret = request_firmware(&fw[i], fw_path, priv->dev);
 		if (ret) {
-			if (priv->version != EIP197B)
+			if (priv->version != EIP197B_MRVL)
 				goto release_fw;
 
 			/* Fallback to the old firmware location for the
@@ -294,6 +292,9 @@ static int safexcel_hw_init(struct safexcel_crypto_priv *priv)
 	u32 version, val;
 	int i, ret, pe;
 
+	dev_dbg(priv->dev, "HW init: using %d pipe(s) and %d ring(s)\n",
+		priv->config.pes, priv->config.rings);
+
 	/* Determine endianess and configure byte swap */
 	version = readl(EIP197_HIA_AIC(priv) + EIP197_HIA_VERSION);
 	val = readl(EIP197_HIA_AIC(priv) + EIP197_HIA_MST_CTRL);
@@ -303,8 +304,11 @@ static int safexcel_hw_init(struct safexcel_crypto_priv *priv)
 	else if (((version >> 16) & 0xffff) == EIP197_HIA_VERSION_LE)
 		val |= (EIP197_MST_CTRL_NO_BYTE_SWAP >> 24);
 
-	/* For EIP197 set maximum number of TX commands to 2^5 = 32 */
-	if (priv->version == EIP197B || priv->version == EIP197D)
+	/*
+	 * For EIP197's only set maximum number of TX commands to 2^5 = 32
+	 * Skip for the EIP97 as it does not have this field.
+	 */
+	if (priv->version != EIP97IES_MRVL)
 		val |= EIP197_MST_CTRL_TX_MAX_CMD(5);
 
 	writel(val, EIP197_HIA_AIC(priv) + EIP197_HIA_MST_CTRL);
@@ -330,11 +334,10 @@ static int safexcel_hw_init(struct safexcel_crypto_priv *priv)
 		writel(EIP197_DxE_THR_CTRL_RESET_PE,
 		       EIP197_HIA_DFE_THR(priv) + EIP197_HIA_DFE_THR_CTRL(pe));
 
-		if (priv->version == EIP197B || priv->version == EIP197D) {
-			/* Reset HIA input interface arbiter */
+		if (priv->version != EIP97IES_MRVL)
+			/* Reset HIA input interface arbiter (EIP197 only) */
 			writel(EIP197_HIA_RA_PE_CTRL_RESET,
 			       EIP197_HIA_AIC(priv) + EIP197_HIA_RA_PE_CTRL(pe));
-		}
 
 		/* DMA transfer size to use */
 		val = EIP197_HIA_DFE_CFG_DIS_DEBUG;
@@ -357,12 +360,11 @@ static int safexcel_hw_init(struct safexcel_crypto_priv *priv)
 		       EIP197_PE_IN_xBUF_THRES_MAX(7),
 		       EIP197_PE(priv) + EIP197_PE_IN_TBUF_THRES(pe));
 
-		if (priv->version == EIP197B || priv->version == EIP197D) {
+		if (priv->version != EIP97IES_MRVL)
 			/* enable HIA input interface arbiter and rings */
 			writel(EIP197_HIA_RA_PE_CTRL_EN |
 			       GENMASK(priv->config.rings - 1, 0),
 			       EIP197_HIA_AIC(priv) + EIP197_HIA_RA_PE_CTRL(pe));
-		}
 
 		/* Data Store Engine configuration */
 
@@ -381,10 +383,11 @@ static int safexcel_hw_init(struct safexcel_crypto_priv *priv)
 		       EIP197_HIA_DxE_CFG_MAX_DATA_SIZE(8);
 		val |= EIP197_HIA_DxE_CFG_DATA_CACHE_CTRL(WR_CACHE_3BITS);
 		val |= EIP197_HIA_DSE_CFG_ALWAYS_BUFFERABLE;
-		/* FIXME: instability issues can occur for EIP97 but disabling it impact
-		 * performances.
+		/*
+		 * FIXME: instability issues can occur for EIP97 but disabling
+		 * it impacts performance.
 		 */
-		if (priv->version == EIP197B || priv->version == EIP197D)
+		if (priv->version != EIP97IES_MRVL)
 			val |= EIP197_HIA_DSE_CFG_EN_SINGLE_WR;
 		writel(val, EIP197_HIA_DSE(priv) + EIP197_HIA_DSE_CFG(pe));
 
@@ -479,7 +482,7 @@ static int safexcel_hw_init(struct safexcel_crypto_priv *priv)
 	/* Clear any HIA interrupt */
 	writel(GENMASK(30, 20), EIP197_HIA_AIC_G(priv) + EIP197_HIA_AIC_G_ACK);
 
-	if (priv->version == EIP197B || priv->version == EIP197D) {
+	if (priv->version != EIP97IES_MRVL) {
 		eip197_trc_cache_init(priv);
 
 		ret = eip197_load_firmwares(priv);
@@ -514,7 +517,8 @@ void safexcel_dequeue(struct safexcel_crypto_priv *priv, int ring)
 	struct safexcel_context *ctx;
 	int ret, nreq = 0, cdesc = 0, rdesc = 0, commands, results;
 
-	/* If a request wasn't properly dequeued because of a lack of resources,
+	/*
+	 * If a request wasn't properly dequeued because of a lack of resources,
 	 * proceeded it first,
 	 */
 	req = priv->ring[ring].req;
@@ -543,7 +547,8 @@ void safexcel_dequeue(struct safexcel_crypto_priv *priv, int ring)
 		if (backlog)
 			backlog->complete(backlog, -EINPROGRESS);
 
-		/* In case the send() helper did not issue any command to push
+		/*
+		 * In case the send() helper did not issue any command to push
 		 * to the engine because the input data was cached, continue to
 		 * dequeue other requests as this is valid and not an error.
 		 */
@@ -556,7 +561,8 @@ void safexcel_dequeue(struct safexcel_crypto_priv *priv, int ring)
 	}
 
 request_failed:
-	/* Not enough resources to handle all the requests. Bail out and save
+	/*
+	 * Not enough resources to handle all the requests. Bail out and save
 	 * the request and the backlog for the next dequeue call (per-ring).
 	 */
 	priv->ring[ring].req = req;
@@ -711,7 +717,8 @@ static inline void safexcel_handle_result_descriptor(struct safexcel_crypto_priv
 		ndesc = ctx->handle_result(priv, ring, req,
 					   &should_complete, &ret);
 		if (ndesc < 0) {
-			dev_err(priv->dev, "failed to handle result (%d)", ndesc);
+			dev_err(priv->dev, "failed to handle result (%d)\n",
+				ndesc);
 			goto acknowledge;
 		}
 
@@ -731,7 +738,8 @@ static inline void safexcel_handle_result_descriptor(struct safexcel_crypto_priv
 		       EIP197_xDR_PROC_xD_COUNT(tot_descs * priv->config.rd_offset),
 		       EIP197_HIA_RDR(priv, ring) + EIP197_HIA_xDR_PROC_COUNT);
 
-	/* If the number of requests overflowed the counter, try to proceed more
+	/*
+	 * If the number of requests overflowed the counter, try to proceed more
 	 * requests.
 	 */
 	if (nreq == EIP197_xDR_PROC_xD_PKT_MASK)
@@ -783,7 +791,7 @@ static irqreturn_t safexcel_irq_ring(int irq, void *data)
 			 * reinitialized. This should not happen under
 			 * normal circumstances.
 			 */
-			dev_err(priv->dev, "RDR: fatal error.");
+			dev_err(priv->dev, "RDR: fatal error.\n");
 		} else if (likely(stat & EIP197_xDR_THRESH)) {
 			rc = IRQ_WAKE_THREAD;
 		}
@@ -813,23 +821,45 @@ static irqreturn_t safexcel_irq_ring_thread(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static int safexcel_request_ring_irq(struct platform_device *pdev, const char *name,
+static int safexcel_request_ring_irq(void *pdev, int irqid,
+				     int is_pci_dev,
 				     irq_handler_t handler,
 				     irq_handler_t threaded_handler,
 				     struct safexcel_ring_irq_data *ring_irq_priv)
 {
-	int ret, irq = platform_get_irq_byname(pdev, name);
+	int ret, irq;
+	struct device *dev;
+
+	if (IS_ENABLED(CONFIG_PCI) && is_pci_dev) {
+		struct pci_dev *pci_pdev = pdev;
+
+		dev = &pci_pdev->dev;
+		irq = pci_irq_vector(pci_pdev, irqid);
+		if (irq < 0) {
+			dev_err(dev, "unable to get device MSI IRQ %d (err %d)\n",
+				irqid, irq);
+			return irq;
+		}
+	} else if (IS_ENABLED(CONFIG_OF)) {
+		struct platform_device *plf_pdev = pdev;
+		char irq_name[6] = {0}; /* "ringX\0" */
 
-	if (irq < 0) {
-		dev_err(&pdev->dev, "unable to get IRQ '%s'\n", name);
-		return irq;
+		snprintf(irq_name, 6, "ring%d", irqid);
+		dev = &plf_pdev->dev;
+		irq = platform_get_irq_byname(plf_pdev, irq_name);
+
+		if (irq < 0) {
+			dev_err(dev, "unable to get IRQ '%s' (err %d)\n",
+				irq_name, irq);
+			return irq;
+		}
 	}
 
-	ret = devm_request_threaded_irq(&pdev->dev, irq, handler,
+	ret = devm_request_threaded_irq(dev, irq, handler,
 					threaded_handler, IRQF_ONESHOT,
-					dev_name(&pdev->dev), ring_irq_priv);
+					dev_name(dev), ring_irq_priv);
 	if (ret) {
-		dev_err(&pdev->dev, "unable to request IRQ %d\n", irq);
+		dev_err(dev, "unable to request IRQ %d\n", irq);
 		return ret;
 	}
 
@@ -916,22 +946,20 @@ static void safexcel_configure(struct safexcel_crypto_priv *priv)
 	val = readl(EIP197_HIA_AIC_G(priv) + EIP197_HIA_OPTIONS);
 
 	/* Read number of PEs from the engine */
-	switch (priv->version) {
-	case EIP197B:
-	case EIP197D:
-		mask = EIP197_N_PES_MASK;
-		break;
-	default:
+	if (priv->version == EIP97IES_MRVL)
+		/* Narrow field width for EIP97 type engine */
 		mask = EIP97_N_PES_MASK;
-	}
+	else
+		/* Wider field width for all EIP197 type engines */
+		mask = EIP197_N_PES_MASK;
+
 	priv->config.pes = (val >> EIP197_N_PES_OFFSET) & mask;
 
+	priv->config.rings = min_t(u32, val & GENMASK(3, 0), max_rings);
+
 	val = (val & GENMASK(27, 25)) >> 25;
 	mask = BIT(val) - 1;
 
-	val = readl(EIP197_HIA_AIC_G(priv) + EIP197_HIA_OPTIONS);
-	priv->config.rings = min_t(u32, val & GENMASK(3, 0), max_rings);
-
 	priv->config.cd_size = (sizeof(struct safexcel_command_desc) / sizeof(u32));
 	priv->config.cd_offset = (priv->config.cd_size + mask) & ~mask;
 
@@ -943,21 +971,7 @@ static void safexcel_init_register_offsets(struct safexcel_crypto_priv *priv)
 {
 	struct safexcel_register_offsets *offsets = &priv->offsets;
 
-	switch (priv->version) {
-	case EIP197B:
-	case EIP197D:
-		offsets->hia_aic	= EIP197_HIA_AIC_BASE;
-		offsets->hia_aic_g	= EIP197_HIA_AIC_G_BASE;
-		offsets->hia_aic_r	= EIP197_HIA_AIC_R_BASE;
-		offsets->hia_aic_xdr	= EIP197_HIA_AIC_xDR_BASE;
-		offsets->hia_dfe	= EIP197_HIA_DFE_BASE;
-		offsets->hia_dfe_thr	= EIP197_HIA_DFE_THR_BASE;
-		offsets->hia_dse	= EIP197_HIA_DSE_BASE;
-		offsets->hia_dse_thr	= EIP197_HIA_DSE_THR_BASE;
-		offsets->hia_gen_cfg	= EIP197_HIA_GEN_CFG_BASE;
-		offsets->pe		= EIP197_PE_BASE;
-		break;
-	case EIP97IES:
+	if (priv->version == EIP97IES_MRVL) {
 		offsets->hia_aic	= EIP97_HIA_AIC_BASE;
 		offsets->hia_aic_g	= EIP97_HIA_AIC_G_BASE;
 		offsets->hia_aic_r	= EIP97_HIA_AIC_R_BASE;
@@ -968,135 +982,119 @@ static void safexcel_init_register_offsets(struct safexcel_crypto_priv *priv)
 		offsets->hia_dse_thr	= EIP97_HIA_DSE_THR_BASE;
 		offsets->hia_gen_cfg	= EIP97_HIA_GEN_CFG_BASE;
 		offsets->pe		= EIP97_PE_BASE;
-		break;
+	} else {
+		offsets->hia_aic	= EIP197_HIA_AIC_BASE;
+		offsets->hia_aic_g	= EIP197_HIA_AIC_G_BASE;
+		offsets->hia_aic_r	= EIP197_HIA_AIC_R_BASE;
+		offsets->hia_aic_xdr	= EIP197_HIA_AIC_xDR_BASE;
+		offsets->hia_dfe	= EIP197_HIA_DFE_BASE;
+		offsets->hia_dfe_thr	= EIP197_HIA_DFE_THR_BASE;
+		offsets->hia_dse	= EIP197_HIA_DSE_BASE;
+		offsets->hia_dse_thr	= EIP197_HIA_DSE_THR_BASE;
+		offsets->hia_gen_cfg	= EIP197_HIA_GEN_CFG_BASE;
+		offsets->pe		= EIP197_PE_BASE;
 	}
 }
 
-static int safexcel_probe(struct platform_device *pdev)
+/*
+ * Generic part of probe routine, shared by platform and PCI driver
+ *
+ * Assumes IO resources have been mapped, private data mem has been allocated,
+ * clocks have been enabled, device pointer has been assigned etc.
+ *
+ */
+static int safexcel_probe_generic(void *pdev,
+				  struct safexcel_crypto_priv *priv,
+				  int is_pci_dev)
 {
-	struct device *dev = &pdev->dev;
-	struct resource *res;
-	struct safexcel_crypto_priv *priv;
+	struct device *dev = priv->dev;
 	int i, ret;
 
-	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
-	if (!priv)
+	priv->context_pool = dmam_pool_create("safexcel-context", dev,
+					      sizeof(struct safexcel_context_record),
+					      1, 0);
+	if (!priv->context_pool)
 		return -ENOMEM;
 
-	priv->dev = dev;
-	priv->version = (enum safexcel_eip_version)of_device_get_match_data(dev);
-
-	if (priv->version == EIP197B || priv->version == EIP197D)
-		priv->flags |= EIP197_TRC_CACHE;
-
 	safexcel_init_register_offsets(priv);
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	priv->base = devm_ioremap_resource(dev, res);
-	if (IS_ERR(priv->base)) {
-		dev_err(dev, "failed to get resource\n");
-		return PTR_ERR(priv->base);
-	}
+	if (priv->version != EIP97IES_MRVL)
+		priv->flags |= EIP197_TRC_CACHE;
 
-	priv->clk = devm_clk_get(&pdev->dev, NULL);
-	ret = PTR_ERR_OR_ZERO(priv->clk);
-	/* The clock isn't mandatory */
-	if  (ret != -ENOENT) {
-		if (ret)
-			return ret;
+	safexcel_configure(priv);
 
-		ret = clk_prepare_enable(priv->clk);
-		if (ret) {
-			dev_err(dev, "unable to enable clk (%d)\n", ret);
+	if (IS_ENABLED(CONFIG_PCI) && priv->version == EIP197_DEVBRD) {
+		/*
+		 * Request MSI vectors for global + 1 per ring -
+		 * or just 1 for older dev images
+		 */
+		struct pci_dev *pci_pdev = pdev;
+
+		ret = pci_alloc_irq_vectors(pci_pdev,
+					    priv->config.rings + 1,
+					    priv->config.rings + 1,
+					    PCI_IRQ_MSI | PCI_IRQ_MSIX);
+		if (ret < 0) {
+			dev_err(dev, "Failed to allocate PCI MSI interrupts\n");
 			return ret;
 		}
 	}
 
-	priv->reg_clk = devm_clk_get(&pdev->dev, "reg");
-	ret = PTR_ERR_OR_ZERO(priv->reg_clk);
-	/* The clock isn't mandatory */
-	if  (ret != -ENOENT) {
-		if (ret)
-			goto err_core_clk;
-
-		ret = clk_prepare_enable(priv->reg_clk);
-		if (ret) {
-			dev_err(dev, "unable to enable reg clk (%d)\n", ret);
-			goto err_core_clk;
-		}
-	}
-
-	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
-	if (ret)
-		goto err_reg_clk;
-
-	priv->context_pool = dmam_pool_create("safexcel-context", dev,
-					      sizeof(struct safexcel_context_record),
-					      1, 0);
-	if (!priv->context_pool) {
-		ret = -ENOMEM;
-		goto err_reg_clk;
-	}
-
-	safexcel_configure(priv);
-
+	/* Register the ring IRQ handlers and configure the rings */
 	priv->ring = devm_kcalloc(dev, priv->config.rings,
 				  sizeof(*priv->ring),
 				  GFP_KERNEL);
-	if (!priv->ring) {
-		ret = -ENOMEM;
-		goto err_reg_clk;
-	}
+	if (!priv->ring)
+		return -ENOMEM;
 
 	for (i = 0; i < priv->config.rings; i++) {
-		char irq_name[6] = {0}; /* "ringX\0" */
-		char wq_name[9] = {0}; /* "wq_ringX\0" */
+		char wq_name[9] = {0};
 		int irq;
 		struct safexcel_ring_irq_data *ring_irq;
 
 		ret = safexcel_init_ring_descriptors(priv,
 						     &priv->ring[i].cdr,
 						     &priv->ring[i].rdr);
-		if (ret)
-			goto err_reg_clk;
+		if (ret) {
+			dev_err(dev, "Failed to initialize rings\n");
+			return ret;
+		}
 
 		priv->ring[i].rdr_req = devm_kcalloc(dev,
 			EIP197_DEFAULT_RING_SIZE,
 			sizeof(priv->ring[i].rdr_req),
 			GFP_KERNEL);
-		if (!priv->ring[i].rdr_req) {
-			ret = -ENOMEM;
-			goto err_reg_clk;
-		}
+		if (!priv->ring[i].rdr_req)
+			return -ENOMEM;
 
 		ring_irq = devm_kzalloc(dev, sizeof(*ring_irq), GFP_KERNEL);
-		if (!ring_irq) {
-			ret = -ENOMEM;
-			goto err_reg_clk;
-		}
+		if (!ring_irq)
+			return -ENOMEM;
 
 		ring_irq->priv = priv;
 		ring_irq->ring = i;
 
-		snprintf(irq_name, 6, "ring%d", i);
-		irq = safexcel_request_ring_irq(pdev, irq_name, safexcel_irq_ring,
+		irq = safexcel_request_ring_irq(pdev,
+						EIP197_IRQ_NUMBER(i, is_pci_dev),
+						is_pci_dev,
+						safexcel_irq_ring,
 						safexcel_irq_ring_thread,
 						ring_irq);
 		if (irq < 0) {
-			ret = irq;
-			goto err_reg_clk;
+			dev_err(dev, "Failed to get IRQ ID for ring %d\n", i);
+			return irq;
 		}
 
 		priv->ring[i].work_data.priv = priv;
 		priv->ring[i].work_data.ring = i;
-		INIT_WORK(&priv->ring[i].work_data.work, safexcel_dequeue_work);
+		INIT_WORK(&priv->ring[i].work_data.work,
+			  safexcel_dequeue_work);
 
 		snprintf(wq_name, 9, "wq_ring%d", i);
-		priv->ring[i].workqueue = create_singlethread_workqueue(wq_name);
-		if (!priv->ring[i].workqueue) {
-			ret = -ENOMEM;
-			goto err_reg_clk;
-		}
+		priv->ring[i].workqueue =
+			create_singlethread_workqueue(wq_name);
+		if (!priv->ring[i].workqueue)
+			return -ENOMEM;
 
 		priv->ring[i].requests = 0;
 		priv->ring[i].busy = false;
@@ -1108,28 +1106,21 @@ static int safexcel_probe(struct platform_device *pdev)
 		spin_lock_init(&priv->ring[i].queue_lock);
 	}
 
-	platform_set_drvdata(pdev, priv);
 	atomic_set(&priv->ring_used, 0);
 
 	ret = safexcel_hw_init(priv);
 	if (ret) {
-		dev_err(dev, "EIP h/w init failed (%d)\n", ret);
-		goto err_reg_clk;
+		dev_err(dev, "HW init failed (%d)\n", ret);
+		return ret;
 	}
 
 	ret = safexcel_register_algorithms(priv);
 	if (ret) {
 		dev_err(dev, "Failed to register algorithms (%d)\n", ret);
-		goto err_reg_clk;
+		return ret;
 	}
 
 	return 0;
-
-err_reg_clk:
-	clk_disable_unprepare(priv->reg_clk);
-err_core_clk:
-	clk_disable_unprepare(priv->clk);
-	return ret;
 }
 
 static void safexcel_hw_reset_rings(struct safexcel_crypto_priv *priv)
@@ -1151,6 +1142,80 @@ static void safexcel_hw_reset_rings(struct safexcel_crypto_priv *priv)
 	}
 }
 
+#if IS_ENABLED(CONFIG_OF)
+/*
+ * for Device Tree platform driver
+ */
+
+static int safexcel_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct resource *res;
+	struct safexcel_crypto_priv *priv;
+	int ret;
+
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->dev = dev;
+	priv->version = (enum safexcel_eip_version)of_device_get_match_data(dev);
+
+	platform_set_drvdata(pdev, priv);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	priv->base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(priv->base)) {
+		dev_err(dev, "failed to get resource\n");
+		return PTR_ERR(priv->base);
+	}
+
+	priv->clk = devm_clk_get(&pdev->dev, NULL);
+	ret = PTR_ERR_OR_ZERO(priv->clk);
+	/* The clock isn't mandatory */
+	if  (ret != -ENOENT) {
+		if (ret)
+			return ret;
+
+		ret = clk_prepare_enable(priv->clk);
+		if (ret) {
+			dev_err(dev, "unable to enable clk (%d)\n", ret);
+			return ret;
+		}
+	}
+
+	priv->reg_clk = devm_clk_get(&pdev->dev, "reg");
+	ret = PTR_ERR_OR_ZERO(priv->reg_clk);
+	/* The clock isn't mandatory */
+	if  (ret != -ENOENT) {
+		if (ret)
+			goto err_core_clk;
+
+		ret = clk_prepare_enable(priv->reg_clk);
+		if (ret) {
+			dev_err(dev, "unable to enable reg clk (%d)\n", ret);
+			goto err_core_clk;
+		}
+	}
+
+	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
+	if (ret)
+		goto err_reg_clk;
+
+	/* Generic EIP97/EIP197 device probing */
+	ret = safexcel_probe_generic(pdev, priv, 0);
+	if (ret)
+		goto err_reg_clk;
+
+	return 0;
+
+err_reg_clk:
+	clk_disable_unprepare(priv->reg_clk);
+err_core_clk:
+	clk_disable_unprepare(priv->clk);
+	return ret;
+}
+
 static int safexcel_remove(struct platform_device *pdev)
 {
 	struct safexcel_crypto_priv *priv = platform_get_drvdata(pdev);
@@ -1170,30 +1235,28 @@ static int safexcel_remove(struct platform_device *pdev)
 static const struct of_device_id safexcel_of_match_table[] = {
 	{
 		.compatible = "inside-secure,safexcel-eip97ies",
-		.data = (void *)EIP97IES,
+		.data = (void *)EIP97IES_MRVL,
 	},
 	{
 		.compatible = "inside-secure,safexcel-eip197b",
-		.data = (void *)EIP197B,
+		.data = (void *)EIP197B_MRVL,
 	},
 	{
 		.compatible = "inside-secure,safexcel-eip197d",
-		.data = (void *)EIP197D,
+		.data = (void *)EIP197D_MRVL,
 	},
+	/* For backward compatibility and intended for generic use */
 	{
-		/* Deprecated. Kept for backward compatibility. */
 		.compatible = "inside-secure,safexcel-eip97",
-		.data = (void *)EIP97IES,
+		.data = (void *)EIP97IES_MRVL,
 	},
 	{
-		/* Deprecated. Kept for backward compatibility. */
 		.compatible = "inside-secure,safexcel-eip197",
-		.data = (void *)EIP197B,
+		.data = (void *)EIP197B_MRVL,
 	},
 	{},
 };
 
-
 static struct platform_driver  crypto_safexcel = {
 	.probe		= safexcel_probe,
 	.remove		= safexcel_remove,
@@ -1202,10 +1265,169 @@ static int safexcel_remove(struct platform_device *pdev)
 		.of_match_table = safexcel_of_match_table,
 	},
 };
-module_platform_driver(crypto_safexcel);
+#endif
+
+#if IS_ENABLED(CONFIG_PCI)
+/*
+ * PCIE devices - i.e. Inside Secure development boards
+ */
+
+static int crypto_is_pci_probe(struct pci_dev *pdev,
+			       const struct pci_device_id *ent)
+{
+	struct device *dev = &pdev->dev;
+	struct safexcel_crypto_priv *priv;
+	void __iomem *pciebase;
+	int rc;
+	u32 val;
+
+	dev_dbg(dev, "Probing PCIE device: vendor %04x, device %04x, subv %04x, subdev %04x, ctxt %lx\n",
+		ent->vendor, ent->device, ent->subvendor,
+		ent->subdevice, ent->driver_data);
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->dev = dev;
+	priv->version = (enum safexcel_eip_version)ent->driver_data;
+
+	pci_set_drvdata(pdev, priv);
+
+	/* enable the device */
+	rc = pcim_enable_device(pdev);
+	if (rc) {
+		dev_err(dev, "Failed to enable PCI device\n");
+		return rc;
+	}
+
+	/* take ownership of PCI BAR0 */
+	rc = pcim_iomap_regions(pdev, 1, "crypto_safexcel");
+	if (rc) {
+		dev_err(dev, "Failed to map IO region for BAR0\n");
+		return rc;
+	}
+	priv->base = pcim_iomap_table(pdev)[0];
+
+	if (priv->version == EIP197_DEVBRD) {
+		dev_dbg(dev, "Device identified as FPGA based development board - applying HW reset\n");
+
+		rc = pcim_iomap_regions(pdev, 4, "crypto_safexcel");
+		if (rc) {
+			dev_err(dev, "Failed to map IO region for BAR4\n");
+			return rc;
+		}
+
+		pciebase = pcim_iomap_table(pdev)[2];
+		val = readl(pciebase + EIP197_XLX_IRQ_BLOCK_ID_ADDR);
+		if ((val >> 16) == EIP197_XLX_IRQ_BLOCK_ID_VALUE) {
+			dev_dbg(dev, "Detected Xilinx PCIE IRQ block version %d, multiple MSI support enabled\n",
+				(val & 0xff));
+
+			/* Setup MSI identity map mapping */
+			writel(EIP197_XLX_USER_VECT_LUT0_IDENT,
+			       pciebase + EIP197_XLX_USER_VECT_LUT0_ADDR);
+			writel(EIP197_XLX_USER_VECT_LUT1_IDENT,
+			       pciebase + EIP197_XLX_USER_VECT_LUT1_ADDR);
+			writel(EIP197_XLX_USER_VECT_LUT2_IDENT,
+			       pciebase + EIP197_XLX_USER_VECT_LUT2_ADDR);
+			writel(EIP197_XLX_USER_VECT_LUT3_IDENT,
+			       pciebase + EIP197_XLX_USER_VECT_LUT3_ADDR);
+
+			/* Enable all device interrupts */
+			writel(GENMASK(31, 0),
+			       pciebase + EIP197_XLX_USER_INT_ENB_MSK);
+		} else {
+			dev_err(dev, "Unrecognised IRQ block identifier %x\n",
+				val);
+			return -ENODEV;
+		}
+
+		/* HW reset FPGA dev board */
+		/* assert reset */
+		writel(1, priv->base + EIP197_XLX_GPIO_BASE);
+		wmb(); /* maintain strict ordering for accesses here */
+		/* deassert reset */
+		writel(0, priv->base + EIP197_XLX_GPIO_BASE);
+		wmb(); /* maintain strict ordering for accesses here */
+	}
+
+	/* enable bus mastering */
+	pci_set_master(pdev);
+
+	/* Generic EIP97/EIP197 device probing */
+	rc = safexcel_probe_generic(pdev, priv, 1);
+	return rc;
+}
+
+void crypto_is_pci_remove(struct pci_dev *pdev)
+{
+	struct safexcel_crypto_priv *priv = pci_get_drvdata(pdev);
+	int i;
+
+	safexcel_unregister_algorithms(priv);
+
+	for (i = 0; i < priv->config.rings; i++)
+		destroy_workqueue(priv->ring[i].workqueue);
+
+	safexcel_hw_reset_rings(priv);
+}
+
+static const struct pci_device_id crypto_is_pci_ids[] = {
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_XILINX, 0x9038,
+			       0x16ae, 0xc522),
+		/* assume EIP197B for now */
+		.driver_data = EIP197_DEVBRD,
+	},
+	{},
+};
+
+MODULE_DEVICE_TABLE(pci, crypto_is_pci_ids);
+
+static struct pci_driver crypto_is_pci_driver = {
+	.name          = "crypto-safexcel",
+	.id_table      = crypto_is_pci_ids,
+	.probe         = crypto_is_pci_probe,
+	.remove        = crypto_is_pci_remove,
+};
+#endif
+
+static int __init crypto_is_init(void)
+{
+	int rc;
+
+#if IS_ENABLED(CONFIG_OF)
+		/* Register platform driver */
+		platform_driver_register(&crypto_safexcel);
+#endif
+
+#if IS_ENABLED(CONFIG_PCI)
+		/* Register PCI driver */
+		rc = pci_register_driver(&crypto_is_pci_driver);
+#endif
+
+	return 0;
+}
+
+static void __exit crypto_is_exit(void)
+{
+#if IS_ENABLED(CONFIG_OF)
+		/* Unregister platform driver */
+		platform_driver_unregister(&crypto_safexcel);
+#endif
+
+#if IS_ENABLED(CONFIG_PCI)
+		/* Unregister PCI driver if successfully registered before */
+		pci_unregister_driver(&crypto_is_pci_driver);
+#endif
+}
+
+module_init(crypto_is_init);
+module_exit(crypto_is_exit);
 
 MODULE_AUTHOR("Antoine Tenart <antoine.tenart@free-electrons.com>");
 MODULE_AUTHOR("Ofer Heifetz <oferh@marvell.com>");
 MODULE_AUTHOR("Igal Liberman <igall@marvell.com>");
-MODULE_DESCRIPTION("Support for SafeXcel cryptographic engine EIP197");
+MODULE_DESCRIPTION("Support for SafeXcel cryptographic engines: EIP97 & EIP197");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index e53c232..a9a239b 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -38,6 +38,27 @@
 	char __##name##_desc[size] CRYPTO_MINALIGN_ATTR; \
 	struct type##_request *name = (void *)__##name##_desc
 
+/* Xilinx dev board base offsets */
+#define EIP197_XLX_GPIO_BASE		0x200000
+#define EIP197_XLX_IRQ_BLOCK_ID_ADDR	0x2000
+#define EIP197_XLX_IRQ_BLOCK_ID_VALUE	0x1fc2
+#define EIP197_XLX_USER_INT_ENB_MSK	0x2004
+#define EIP197_XLX_USER_INT_ENB_SET	0x2008
+#define EIP197_XLX_USER_INT_ENB_CLEAR	0x200c
+#define EIP197_XLX_USER_INT_BLOCK	0x2040
+#define EIP197_XLX_USER_INT_PEND	0x2048
+#define EIP197_XLX_USER_VECT_LUT0_ADDR	0x2080
+#define EIP197_XLX_USER_VECT_LUT0_IDENT	0x03020100
+#define EIP197_XLX_USER_VECT_LUT1_ADDR	0x2084
+#define EIP197_XLX_USER_VECT_LUT1_IDENT	0x07060504
+#define EIP197_XLX_USER_VECT_LUT2_ADDR	0x2088
+#define EIP197_XLX_USER_VECT_LUT2_IDENT	0x0b0a0908
+#define EIP197_XLX_USER_VECT_LUT3_ADDR	0x208c
+#define EIP197_XLX_USER_VECT_LUT3_IDENT	0x0f0e0d0c
+
+/* Helper defines for probe function */
+#define EIP197_IRQ_NUMBER(i, is_pci)	(i + is_pci)
+
 /* Register base offsets */
 #define EIP197_HIA_AIC(priv)		((priv)->base + (priv)->offsets.hia_aic)
 #define EIP197_HIA_AIC_G(priv)		((priv)->base + (priv)->offsets.hia_aic_g)
@@ -581,10 +602,13 @@ struct safexcel_ring {
 	struct crypto_async_request *backlog;
 };
 
+/* EIP integration context flags */
 enum safexcel_eip_version {
-	EIP97IES = BIT(0),
-	EIP197B  = BIT(1),
-	EIP197D  = BIT(2),
+	/* Platform (EIP integration context) specifier */
+	EIP97IES_MRVL,
+	EIP197B_MRVL,
+	EIP197D_MRVL,
+	EIP197_DEVBRD
 };
 
 struct safexcel_register_offsets {
diff --git a/drivers/crypto/inside-secure/safexcel_ring.c b/drivers/crypto/inside-secure/safexcel_ring.c
index 142bc3f..2402a62 100644
--- a/drivers/crypto/inside-secure/safexcel_ring.c
+++ b/drivers/crypto/inside-secure/safexcel_ring.c
@@ -145,7 +145,8 @@ struct safexcel_command_desc *safexcel_add_cdesc(struct safexcel_crypto_priv *pr
 			(lower_32_bits(context) & GENMASK(31, 2)) >> 2;
 		cdesc->control_data.context_hi = upper_32_bits(context);
 
-		if (priv->version == EIP197B || priv->version == EIP197D)
+		if (priv->version == EIP197B_MRVL ||
+		    priv->version == EIP197D_MRVL)
 			cdesc->control_data.options |= EIP197_OPTION_RC_AUTO;
 
 		/* TODO: large xform HMAC with SHA-384/512 uses refresh = 3 */
-- 
1.8.3.1

