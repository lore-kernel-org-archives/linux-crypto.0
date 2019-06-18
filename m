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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0D3EC31E51
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jun 2019 06:59:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C73F20665
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jun 2019 06:59:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sa9Ct/Dg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725955AbfFRG7A (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Jun 2019 02:59:00 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:41627 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbfFRG67 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jun 2019 02:58:59 -0400
Received: by mail-ed1-f65.google.com with SMTP id p15so20005052eds.8
        for <linux-crypto@vger.kernel.org>; Mon, 17 Jun 2019 23:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=p+XgInrpo3p68MsiLmNH7UBtHnIjxMe6P7wuqNXc3Ww=;
        b=Sa9Ct/DgJ/okpco1GvzdKV0DcDtC4kXKCdF9AVf7NNY+P+eszpc0lv6qVPCu09aOsm
         49XTk2ouhHy3c3+kHh7OknVpX8EtlJYt6EShl/t0r0u3o2hOM2eMbkWQTpPvMbQJwWqf
         Bpb8314h/vcY7tyslsxoYXokWOzQDu7+88Dt8MB5yvHVh1snGL3x16GoRbXnHgsmCT4t
         voYljcC3TYz3jgk5CJIxbODeL/ZgoEmgeEWLDQSjUi0FaAvkv1Sf1QGCHACfgyzAf+Wg
         saJjZ5ZsqYkN1W8XIwmxLAjb2tGLq25lfQBzwTKtnvzCY5Q4oNNDV9y9+E3E+Auq7hkN
         I1vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=p+XgInrpo3p68MsiLmNH7UBtHnIjxMe6P7wuqNXc3Ww=;
        b=Rh+I5Yn/nlrpKW+nM1e2E+3KKsMlgKHtVdSpLUhtX2s3j2FiV1yFrpbRlWEyVCzYHy
         sbRjsn5wSOamnoUgPKHkKEyEDL+CtG3/rE1clzT7CrWkql58xbFl0DGLqrYOj/kMyqu1
         h5BYdLLBRONI4O7CvNcIeWjLCYrfWcGLTcVPrtj4/HiSZXP/54MbSFQeMfZt8IUlRtuu
         4BoGKW89PRajJRzWksQiYcepQH7eTWUzcsL2/aAhnwDKoU25ldaowx+07LMlBVvfJswi
         3CnXHkfsAckXp8OMCKMZjw+v5jmpyeitFc7UYyB/zx4dd3zxVieLQjNWs32fSOhgFS+S
         ALXQ==
X-Gm-Message-State: APjAAAWKvMQtlNqABSHiyEUBbnYAfOLagsk6XNkOJB2qG2WkRyrqWeEA
        Wp23PSbUz49CVIPOV0lwWtP28G+M
X-Google-Smtp-Source: APXvYqzFCp5hn7QwBEoamuwA+ro9n2npA2Tw8qYmvUyZiXubhNaQJRoWaMs4MBxB2yj5Rnjga8vhWQ==
X-Received: by 2002:a50:a7a5:: with SMTP id i34mr123045852edc.294.1560841136913;
        Mon, 17 Jun 2019 23:58:56 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id q2sm2602291ejk.46.2019.06.17.23.58.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 23:58:56 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@insidesecure.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@insidesecure.com>
Subject: [PATCH 2/3] crypto: inside-secure - add support for PCI based FPGA development board
Date:   Tue, 18 Jun 2019 07:56:23 +0200
Message-Id: <1560837384-29814-3-git-send-email-pvanleeuwen@insidesecure.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1560837384-29814-1-git-send-email-pvanleeuwen@insidesecure.com>
References: <1560837384-29814-1-git-send-email-pvanleeuwen@insidesecure.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds support for a PCIE development board with FPGA from Xilinx,
to facilitate pre-silicon driver development by both Inside Secure and its
IP customers. Since Inside Secure neither produces nor has access to actual
silicon, this is required functionality to allow us to contribute.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@insidesecure.com>
---
 drivers/crypto/inside-secure/safexcel.c | 493 +++++++++++++++++++++++---------
 drivers/crypto/inside-secure/safexcel.h |  17 ++
 2 files changed, 376 insertions(+), 134 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index df43a2c..a6a0f48 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/of_platform.h>
 #include <linux/of_irq.h>
+#include <linux/pci.h>
 #include <linux/platform_device.h>
 #include <linux/workqueue.h>
 
@@ -32,7 +33,7 @@ static void eip197_trc_cache_init(struct safexcel_crypto_priv *priv)
 	u32 val, htable_offset;
 	int i, cs_rc_max, cs_ht_wc, cs_trc_rec_wc, cs_trc_lg_rec_wc;
 
-	if (priv->version == EIP197B) {
+	if (priv->version & EIP197B) {
 		cs_rc_max = EIP197B_CS_RC_MAX;
 		cs_ht_wc = EIP197B_CS_HT_WC;
 		cs_trc_rec_wc = EIP197B_CS_TRC_REC_WC;
@@ -145,23 +146,19 @@ static int eip197_load_firmwares(struct safexcel_crypto_priv *priv)
 	int i, j, ret = 0, pe;
 	u32 val;
 
-	switch (priv->version) {
-	case EIP197B:
+	if (priv->version & EIP197B)
 		dir = "eip197b";
-		break;
-	case EIP197D:
+	else if (priv->version & EIP197D)
 		dir = "eip197d";
-		break;
-	default:
+	else
 		/* No firmware is required */
 		return 0;
-	}
 
 	for (i = 0; i < FW_NB; i++) {
 		snprintf(fw_path, 31, "inside-secure/%s/%s", dir, fw_name[i]);
 		ret = request_firmware(&fw[i], fw_path, priv->dev);
 		if (ret) {
-			if (priv->version != EIP197B)
+			if (!(priv->version & EIP197B))
 				goto release_fw;
 
 			/* Fallback to the old firmware location for the
@@ -294,6 +291,9 @@ static int safexcel_hw_init(struct safexcel_crypto_priv *priv)
 	u32 version, val;
 	int i, ret, pe;
 
+	dev_info(priv->dev, "EIP(1)97 HW init: burst size %d beats, using %d pipe(s) and %d ring(s)",
+			16, priv->config.pes, priv->config.rings);
+
 	/* Determine endianess and configure byte swap */
 	version = readl(EIP197_HIA_AIC(priv) + EIP197_HIA_VERSION);
 	val = readl(EIP197_HIA_AIC(priv) + EIP197_HIA_MST_CTRL);
@@ -304,7 +304,7 @@ static int safexcel_hw_init(struct safexcel_crypto_priv *priv)
 		val |= (EIP197_MST_CTRL_NO_BYTE_SWAP >> 24);
 
 	/* For EIP197 set maximum number of TX commands to 2^5 = 32 */
-	if (priv->version == EIP197B || priv->version == EIP197D)
+	if ((priv->version & EIP197B) || (priv->version & EIP197D))
 		val |= EIP197_MST_CTRL_TX_MAX_CMD(5);
 
 	writel(val, EIP197_HIA_AIC(priv) + EIP197_HIA_MST_CTRL);
@@ -330,11 +330,10 @@ static int safexcel_hw_init(struct safexcel_crypto_priv *priv)
 		writel(EIP197_DxE_THR_CTRL_RESET_PE,
 		       EIP197_HIA_DFE_THR(priv) + EIP197_HIA_DFE_THR_CTRL(pe));
 
-		if (priv->version == EIP197B || priv->version == EIP197D) {
+		if ((priv->version & EIP197B) || (priv->version & EIP197D))
 			/* Reset HIA input interface arbiter */
 			writel(EIP197_HIA_RA_PE_CTRL_RESET,
 			       EIP197_HIA_AIC(priv) + EIP197_HIA_RA_PE_CTRL(pe));
-		}
 
 		/* DMA transfer size to use */
 		val = EIP197_HIA_DFE_CFG_DIS_DEBUG;
@@ -357,12 +356,11 @@ static int safexcel_hw_init(struct safexcel_crypto_priv *priv)
 		       EIP197_PE_IN_xBUF_THRES_MAX(7),
 		       EIP197_PE(priv) + EIP197_PE_IN_TBUF_THRES(pe));
 
-		if (priv->version == EIP197B || priv->version == EIP197D) {
+		if ((priv->version & EIP197B) || (priv->version & EIP197D))
 			/* enable HIA input interface arbiter and rings */
 			writel(EIP197_HIA_RA_PE_CTRL_EN |
 			       GENMASK(priv->config.rings - 1, 0),
 			       EIP197_HIA_AIC(priv) + EIP197_HIA_RA_PE_CTRL(pe));
-		}
 
 		/* Data Store Engine configuration */
 
@@ -384,7 +382,7 @@ static int safexcel_hw_init(struct safexcel_crypto_priv *priv)
 		/* FIXME: instability issues can occur for EIP97 but disabling it impact
 		 * performances.
 		 */
-		if (priv->version == EIP197B || priv->version == EIP197D)
+		if ((priv->version & EIP197B) || (priv->version & EIP197D))
 			val |= EIP197_HIA_DSE_CFG_EN_SINGLE_WR;
 		writel(val, EIP197_HIA_DSE(priv) + EIP197_HIA_DSE_CFG(pe));
 
@@ -479,7 +477,7 @@ static int safexcel_hw_init(struct safexcel_crypto_priv *priv)
 	/* Clear any HIA interrupt */
 	writel(GENMASK(30, 20), EIP197_HIA_AIC_G(priv) + EIP197_HIA_AIC_G_ACK);
 
-	if (priv->version == EIP197B || priv->version == EIP197D) {
+	if ((priv->version & EIP197B) || (priv->version & EIP197D)) {
 		eip197_trc_cache_init(priv);
 
 		ret = eip197_load_firmwares(priv);
@@ -813,23 +811,45 @@ static irqreturn_t safexcel_irq_ring_thread(int irq, void *data)
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
 
-	if (irq < 0) {
-		dev_err(&pdev->dev, "unable to get IRQ '%s'\n", name);
-		return irq;
+	if (IS_ENABLED(CONFIG_PCI) && is_pci_dev) {
+		struct pci_dev *pci_pdev = pdev;
+
+		dev = &pci_pdev->dev;
+		irq = pci_irq_vector(pci_pdev, irqid);
+		if (irq < 0) {
+			dev_err(dev, "unable to get device MSI IRQ %d (err %d)",
+				irqid, irq);
+			return irq;
+		}
+	} else {
+		struct platform_device *plf_pdev = pdev;
+		char irq_name[6] = {0}; /* "ringX\0" */
+
+		snprintf(irq_name, 6, "ring%d", irqid);
+		dev = &plf_pdev->dev;
+		irq = platform_get_irq_byname(plf_pdev, irq_name);
+
+		if (irq < 0) {
+			dev_err(dev, "unable to get IRQ '%s'\n (err %d)",
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
 
@@ -925,22 +945,18 @@ static void safexcel_configure(struct safexcel_crypto_priv *priv)
 	val = readl(EIP197_HIA_AIC_G(priv) + EIP197_HIA_OPTIONS);
 
 	/* Read number of PEs from the engine */
-	switch (priv->version) {
-	case EIP197B:
-	case EIP197D:
-		mask = EIP197_N_PES_MASK;
-		break;
-	default:
+	if (priv->version & EIP97IES)
 		mask = EIP97_N_PES_MASK;
-	}
+	else
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
 
@@ -952,21 +968,7 @@ static void safexcel_init_register_offsets(struct safexcel_crypto_priv *priv)
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
+	if (priv->version & EIP97IES) {
 		offsets->hia_aic	= EIP97_HIA_AIC_BASE;
 		offsets->hia_aic_g	= EIP97_HIA_AIC_G_BASE;
 		offsets->hia_aic_r	= EIP97_HIA_AIC_R_BASE;
@@ -977,139 +979,131 @@ static void safexcel_init_register_offsets(struct safexcel_crypto_priv *priv)
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
+	if ((priv->version & EIP197B) || (priv->version & EIP197D))
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
+	if (IS_ENABLED(CONFIG_PCI) && (priv->version & DEVICE_IS_PCI)) {
+		/*
+		 * Request MSI vectors for global + 1 per ring -
+		 * or just 1 for older dev images
+		 */
+		struct pci_dev *pci_pdev = pdev;
+
+		ret = pci_alloc_irq_vectors(pci_pdev,
+					    priv->config.rings + 1,
+					    priv->config.rings + 1,
+					    PCI_IRQ_MSI|PCI_IRQ_MSIX);
+		if (ret < 0) {
+			dev_err(dev, "Failed to allocate PCI MSI interrupts");
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
 	if (!priv->ring) {
-		ret = -ENOMEM;
-		goto err_reg_clk;
+		dev_err(dev, "Failed to allocate ring memory");
+		return -ENOMEM;
 	}
 
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
+			dev_err(dev, "Failed to initialize rings");
+			return ret;
+		}
 
 		priv->ring[i].rdr_req = devm_kcalloc(dev,
 			EIP197_DEFAULT_RING_SIZE,
 			sizeof(priv->ring[i].rdr_req),
 			GFP_KERNEL);
 		if (!priv->ring[i].rdr_req) {
-			ret = -ENOMEM;
-			goto err_reg_clk;
+			dev_err(dev, "Failed to allocate RDR async request queue for ring %d",
+				i);
+			return -ENOMEM;
 		}
 
 		ring_irq = devm_kzalloc(dev, sizeof(*ring_irq), GFP_KERNEL);
 		if (!ring_irq) {
-			ret = -ENOMEM;
-			goto err_reg_clk;
+			dev_err(dev, "Failed to allocate IRQ data for ring %d",
+				i);
+			return -ENOMEM;
 		}
 
 		ring_irq->priv = priv;
 		ring_irq->ring = i;
 
-		snprintf(irq_name, 6, "ring%d", i);
-		irq = safexcel_request_ring_irq(pdev, irq_name, safexcel_irq_ring,
+		irq = safexcel_request_ring_irq(pdev, i + is_pci_dev,
+						is_pci_dev,
+						safexcel_irq_ring,
 						safexcel_irq_ring_thread,
 						ring_irq);
 		if (irq < 0) {
-			ret = irq;
-			goto err_reg_clk;
+			dev_err(dev, "Failed to get IRQ ID for ring %d", i);
+			return irq;
 		}
 
 		priv->ring[i].work_data.priv = priv;
 		priv->ring[i].work_data.ring = i;
-		INIT_WORK(&priv->ring[i].work_data.work, safexcel_dequeue_work);
+		INIT_WORK(&priv->ring[i].work_data.work,
+			  safexcel_dequeue_work);
 
 		snprintf(wq_name, 9, "wq_ring%d", i);
-		priv->ring[i].workqueue = create_singlethread_workqueue(wq_name);
+		priv->ring[i].workqueue =
+			create_singlethread_workqueue(wq_name);
 		if (!priv->ring[i].workqueue) {
-			ret = -ENOMEM;
-			goto err_reg_clk;
+			dev_err(dev, "Failed to create work queue for ring %d",
+				i);
+			return -ENOMEM;
 		}
-
 		priv->ring[i].requests = 0;
 		priv->ring[i].busy = false;
-
 		crypto_init_queue(&priv->ring[i].queue,
 				  EIP197_DEFAULT_RING_SIZE);
 
@@ -1117,22 +1111,88 @@ static int safexcel_probe(struct platform_device *pdev)
 		spin_lock_init(&priv->ring[i].queue_lock);
 	}
 
-	platform_set_drvdata(pdev, priv);
 	atomic_set(&priv->ring_used, 0);
 
 	ret = safexcel_hw_init(priv);
 	if (ret) {
-		dev_err(dev, "EIP h/w init failed (%d)\n", ret);
-		goto err_reg_clk;
+		dev_err(dev, "EIP(1)97 h/w init failed (%d)", ret);
+		return ret;
 	}
 
 	ret = safexcel_register_algorithms(priv);
 	if (ret) {
-		dev_err(dev, "Failed to register algorithms (%d)\n", ret);
-		goto err_reg_clk;
+		dev_err(dev, "Failed to register algorithms (%d)", ret);
+		return ret;
 	}
 
 	return 0;
+}
+
+/*
+ *
+ * for Device Tree platform driver
+ *
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
 
 err_reg_clk:
 	clk_disable_unprepare(priv->reg_clk);
@@ -1189,13 +1249,12 @@ static int safexcel_remove(struct platform_device *pdev)
 		.compatible = "inside-secure,safexcel-eip197d",
 		.data = (void *)EIP197D,
 	},
+	/* For backward compatibiliry and intended for generic use */
 	{
-		/* Deprecated. Kept for backward compatibility. */
 		.compatible = "inside-secure,safexcel-eip97",
 		.data = (void *)EIP97IES,
 	},
 	{
-		/* Deprecated. Kept for backward compatibility. */
 		.compatible = "inside-secure,safexcel-eip197",
 		.data = (void *)EIP197B,
 	},
@@ -1211,10 +1270,176 @@ static int safexcel_remove(struct platform_device *pdev)
 		.of_match_table = safexcel_of_match_table,
 	},
 };
-module_platform_driver(crypto_safexcel);
+
+/*
+ *
+ * PCIE devices - i.e. Inside Secure development boards
+ *
+ */
+
+static int crypto_is_pci_probe(struct pci_dev *pdev,
+	 const struct pci_device_id *ent)
+{
+	if (IS_ENABLED(CONFIG_PCI)) {
+		struct device *dev = &pdev->dev;
+		struct safexcel_crypto_priv *priv;
+		void __iomem *pciebase;
+		int rc;
+		u32 val;
+
+		dev_info(dev, "Probing PCIE device: vendor %04x, device %04x, subv %04x, subdev %04x, ctxt %lx",
+			 ent->vendor, ent->device, ent->subvendor,
+			 ent->subdevice, ent->driver_data);
+
+		priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+		if (!priv) {
+			dev_err(dev, "Failed to allocate memory");
+			return -ENOMEM;
+		}
+
+		priv->dev = dev;
+		priv->version = (enum safexcel_eip_version)ent->driver_data;
+
+		pci_set_drvdata(pdev, priv);
+
+		/* enable the device */
+		rc = pcim_enable_device(pdev);
+		if (rc) {
+			dev_err(dev, "pci_enable_device() failed");
+			return rc;
+		}
+
+		/* take ownership of PCI BAR0 */
+		rc = pcim_iomap_regions(pdev, 1, "crypto_safexcel");
+		if (rc) {
+			dev_err(dev, "pcim_iomap_regions() failed for BAR0");
+			return rc;
+		}
+		priv->base = pcim_iomap_table(pdev)[0];
+
+		if (priv->version & XILINX_PCIE) {
+			dev_info(dev, "Device identified as FPGA based development board - applying HW reset");
+
+			rc = pcim_iomap_regions(pdev, 4, "crypto_safexcel");
+			if (rc) {
+				dev_err(dev, "pcim_iomap_regions() failed for BAR4");
+				return rc;
+			}
+
+			pciebase = pcim_iomap_table(pdev)[2];
+			val = readl(pciebase + XILINX_IRQ_BLOCK_ID);
+			if ((val >> 16) == 0x1fc2) {
+				dev_info(dev, "Detected Xilinx PCIE IRQ block version %d, multiple MSI support enabled",
+					 (val & 0xff));
+
+				/* Setup MSI identity map mapping */
+				writel(0x03020100,
+				       pciebase + XILINX_USER_VECT_LUT0);
+				writel(0x07060504,
+				       pciebase + XILINX_USER_VECT_LUT1);
+				writel(0x0b0a0908,
+				       pciebase + XILINX_USER_VECT_LUT2);
+				writel(0x0f0e0d0c,
+				       pciebase + XILINX_USER_VECT_LUT3);
+
+				/* Enable all device interrupts */
+				writel(GENMASK(31, 0),
+				       pciebase + XILINX_USER_INT_ENB_MSK);
+			} else {
+				dev_err(dev, "Unrecognised IRQ block identifier %x",
+					val);
+				return -ENODEV;
+			}
+
+			/* HW reset FPGA dev board */
+			// assert reset
+			writel(1, priv->base + XILINX_GPIO_BASE);
+			wmb(); /* maintain strict ordering for accesses here */
+			// deassert reset
+			writel(0, priv->base + XILINX_GPIO_BASE);
+			wmb(); /* maintain strict ordering for accesses here */
+		}
+
+		/* enable bus mastering */
+		pci_set_master(pdev);
+
+		/* Generic EIP97/EIP197 device probing */
+		rc = safexcel_probe_generic(pdev, priv, 1);
+		if (rc)
+			return rc;
+	}
+	return 0;
+}
+
+void crypto_is_pci_remove(struct pci_dev *pdev)
+{
+	if (IS_ENABLED(CONFIG_PCI)) {
+		struct safexcel_crypto_priv *priv = pci_get_drvdata(pdev);
+		int i;
+
+		safexcel_unregister_algorithms(priv);
+
+		for (i = 0; i < priv->config.rings; i++)
+			destroy_workqueue(priv->ring[i].workqueue);
+
+		safexcel_hw_reset_rings(priv);
+	}
+}
+
+static const struct pci_device_id crypto_is_pci_ids[] = {
+	{
+		.vendor = 0x10ee,
+		.device = 0x9038,
+		.subvendor = 0x16ae,
+		.subdevice = 0xc522,
+		.class = 0x00000000,
+		.class_mask = 0x00000000,
+		// assume EIP197B for now
+		.driver_data = XILINX_PCIE | DEVICE_IS_PCI | EIP197B,
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
+
+static int __init crypto_is_init(void)
+{
+	int rc;
+	/* Register platform driver */
+	platform_driver_register(&crypto_safexcel);
+
+	if (IS_ENABLED(CONFIG_PCI)) {
+		/* Register PCI driver */
+		rc = pci_register_driver(&crypto_is_pci_driver);
+	}
+
+	return 0;
+}
+
+static void __exit crypto_is_exit(void)
+{
+	/* Unregister platform driver */
+	platform_driver_unregister(&crypto_safexcel);
+
+	if (IS_ENABLED(CONFIG_PCI)) {
+		/* Unregister PCI driver if successfully registered before */
+		pci_unregister_driver(&crypto_is_pci_driver);
+	}
+}
+
+module_init(crypto_is_init);
+module_exit(crypto_is_exit);
 
 MODULE_AUTHOR("Antoine Tenart <antoine.tenart@free-electrons.com>");
 MODULE_AUTHOR("Ofer Heifetz <oferh@marvell.com>");
 MODULE_AUTHOR("Igal Liberman <igall@marvell.com>");
-MODULE_DESCRIPTION("Support for SafeXcel cryptographic engine EIP197");
+MODULE_AUTHOR("Pascal van Leeuwen <pvanleeuwen@insidesecure.com>");
+MODULE_DESCRIPTION("Support for SafeXcel cryptographic engines: EIP97 & EIP197");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index e0c202f..924270e 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -38,6 +38,19 @@
 	char __##name##_desc[size] CRYPTO_MINALIGN_ATTR; \
 	struct type##_request *name = (void *)__##name##_desc
 
+/* Xilinx dev board base offsets */
+#define XILINX_GPIO_BASE                0x200000
+#define XILINX_IRQ_BLOCK_ID		0x2000
+#define XILINX_USER_INT_ENB_MSK		0x2004
+#define XILINX_USER_INT_ENB_SET		0x2008
+#define XILINX_USER_INT_ENB_CLEAR	0x200c
+#define XILINX_USER_INT_BLOCK		0x2040
+#define XILINX_USER_INT_PEND		0x2048
+#define XILINX_USER_VECT_LUT0		0x2080
+#define XILINX_USER_VECT_LUT1		0x2084
+#define XILINX_USER_VECT_LUT2		0x2088
+#define XILINX_USER_VECT_LUT3		0x208c
+
 /* Register base offsets */
 #define EIP197_HIA_AIC(priv)		((priv)->base + (priv)->offsets.hia_aic)
 #define EIP197_HIA_AIC_G(priv)		((priv)->base + (priv)->offsets.hia_aic_g)
@@ -581,10 +594,14 @@ struct safexcel_ring {
 	struct crypto_async_request *backlog;
 };
 
+/* EIP integration context flags */
 enum safexcel_eip_version {
+	/* for Marvell Armada BW compatibility */
 	EIP97IES = BIT(0),
 	EIP197B  = BIT(1),
 	EIP197D  = BIT(2),
+	XILINX_PCIE   = BIT(3),
+	DEVICE_IS_PCI = BIT(4),
 };
 
 struct safexcel_register_offsets {
-- 
1.8.3.1

