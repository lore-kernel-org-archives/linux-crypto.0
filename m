Return-Path: <SRS0=2Pww=CN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D25EC43461
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Sep 2020 11:37:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6149D208C7
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Sep 2020 11:37:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="NTXjirCK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729942AbgIDLhO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Sep 2020 07:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729992AbgIDLg6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Sep 2020 07:36:58 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9E8CC061238
        for <linux-crypto@vger.kernel.org>; Fri,  4 Sep 2020 04:10:28 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id a17so6315835wrn.6
        for <linux-crypto@vger.kernel.org>; Fri, 04 Sep 2020 04:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gwQOYNsFhJKOJgkVKQ7t1D2QC2KNM79plMEf+Obg/L4=;
        b=NTXjirCKJmklB5fh1xxX8RgUqvoIkvhaVkrnuZ0YSHHKI8UfNcEew4JmDP0bUrT2+D
         PdZeoS5wP+us4m5t0zmED/b/m1O0hHKjPpE7FwRQlZQatwfP7MNemSiKG910FiT6j3IQ
         7ueD59mOYgW4iZ6JgtzPofyeK8hioI91r14dwdEZaM1S6wcJ2Mkt7TqNUK7rtsb0Wa+A
         6YdFCyKiSE7AJyEWGKLjoJLjcNKBnY/+inYbMJAIMZjttcHrXiSH1QjhbR9B96h3LqOS
         PAgSx6tkZvY5BCBeUqm+u5p4gTSscMEDLht2ByGqizr0DzBmi1Muf/1Uvdy8K3AMLiUI
         e0lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gwQOYNsFhJKOJgkVKQ7t1D2QC2KNM79plMEf+Obg/L4=;
        b=CUjtpS41p9MD+pgYdWqvHCbw886FyGCilZxvDjDAispdkzLcL42FpEEcSTBZYzR9dw
         xsaxKJGVe9QHA/NOWp/2QQIwJgQtBfmUVh8fZXe2i1D4jFmwbdQ7T3sDtgEkrUjoTjXl
         blem/r4+KuCcNBWII4zZgsgc6vku94a6idDV7+z3qRJQNRGY3GnfHpPOJIFQd8dPMKTX
         6t5UXh6mArGJ5UgiaoNTlmLgJHcymz3IdPtpwK/fyMRCN8sDDlV11Gp4Dm6sYA2L4+70
         QhwvWe4wecNxRBcRvXpEYAw8eeOTnWqubJFuIf+zZ9nGlWc/WGP9P2482S0XTW20FLv4
         UyRA==
X-Gm-Message-State: AOAM531Wlbye0KpmT0+IMOGbguVeE/YG/q3vLybCtySgc2kl5uV8fd//
        1adWrXLwVIkumUSN//OujGv/2g==
X-Google-Smtp-Source: ABdhPJx9re8ibfpl8RHF+SmsKq54Z2aokCP4ZIBVk3BrH9xJvPa2lU0Kb/Vw9Pidx46q1U1uf6ek4Q==
X-Received: by 2002:adf:ff83:: with SMTP id j3mr7340718wrr.135.1599217827548;
        Fri, 04 Sep 2020 04:10:27 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id m3sm10622743wmb.26.2020.09.04.04.10.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Sep 2020 04:10:26 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v6 15/18] crypto: sun8i-ce: Add support for the TRNG
Date:   Fri,  4 Sep 2020 11:10:00 +0000
Message-Id: <1599217803-29755-16-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1599217803-29755-1-git-send-email-clabbe@baylibre.com>
References: <1599217803-29755-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch had support for the TRNG present in the CE.
Note that according to the algorithm ID, 2 version of the TRNG exists,
the first present in H3/H5/R40/A64 and the second present in H6.
This patch adds support for both, but only the second is working
reliabily according to rngtest.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/Kconfig              |   8 ++
 drivers/crypto/allwinner/sun8i-ce/Makefile    |   1 +
 .../crypto/allwinner/sun8i-ce/sun8i-ce-core.c |  18 +++
 .../crypto/allwinner/sun8i-ce/sun8i-ce-trng.c | 127 ++++++++++++++++++
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h  |  18 +++
 5 files changed, 172 insertions(+)
 create mode 100644 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c

diff --git a/drivers/crypto/allwinner/Kconfig b/drivers/crypto/allwinner/Kconfig
index bf4d2a6328dc..0e72543ad1f1 100644
--- a/drivers/crypto/allwinner/Kconfig
+++ b/drivers/crypto/allwinner/Kconfig
@@ -96,6 +96,14 @@ config CRYPTO_DEV_SUN8I_CE_PRNG
 	  Select this option if you want to provide kernel-side support for
 	  the Pseudo-Random Number Generator found in the Crypto Engine.
 
+config CRYPTO_DEV_SUN8I_CE_TRNG
+	bool "Support for Allwinner Crypto Engine TRNG"
+	depends on CRYPTO_DEV_SUN8I_CE
+	select HW_RANDOM
+	help
+	  Select this option if you want to provide kernel-side support for
+	  the True Random Number Generator found in the Crypto Engine.
+
 config CRYPTO_DEV_SUN8I_SS
 	tristate "Support for Allwinner Security System cryptographic offloader"
 	select CRYPTO_SKCIPHER
diff --git a/drivers/crypto/allwinner/sun8i-ce/Makefile b/drivers/crypto/allwinner/sun8i-ce/Makefile
index c0ea81da2c7d..0842eb2d9408 100644
--- a/drivers/crypto/allwinner/sun8i-ce/Makefile
+++ b/drivers/crypto/allwinner/sun8i-ce/Makefile
@@ -2,3 +2,4 @@ obj-$(CONFIG_CRYPTO_DEV_SUN8I_CE) += sun8i-ce.o
 sun8i-ce-y += sun8i-ce-core.o sun8i-ce-cipher.o
 sun8i-ce-$(CONFIG_CRYPTO_DEV_SUN8I_CE_HASH) += sun8i-ce-hash.o
 sun8i-ce-$(CONFIG_CRYPTO_DEV_SUN8I_CE_PRNG) += sun8i-ce-prng.o
+sun8i-ce-$(CONFIG_CRYPTO_DEV_SUN8I_CE_TRNG) += sun8i-ce-trng.o
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
index 9b7f8fdc4992..116425e3d2b9 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
@@ -47,6 +47,7 @@ static const struct ce_variant ce_h3_variant = {
 		},
 	.esr = ESR_H3,
 	.prng = CE_ALG_PRNG,
+	.trng = CE_ID_NOTSUPP,
 };
 
 static const struct ce_variant ce_h5_variant = {
@@ -63,6 +64,7 @@ static const struct ce_variant ce_h5_variant = {
 		},
 	.esr = ESR_H5,
 	.prng = CE_ALG_PRNG,
+	.trng = CE_ID_NOTSUPP,
 };
 
 static const struct ce_variant ce_h6_variant = {
@@ -76,6 +78,7 @@ static const struct ce_variant ce_h6_variant = {
 	.cipher_t_dlen_in_bytes = true,
 	.hash_t_dlen_in_bits = true,
 	.prng_t_dlen_in_bytes = true,
+	.trng_t_dlen_in_bytes = true,
 	.ce_clks = {
 		{ "bus", 0, 200000000 },
 		{ "mod", 300000000, 0 },
@@ -83,6 +86,7 @@ static const struct ce_variant ce_h6_variant = {
 		},
 	.esr = ESR_H6,
 	.prng = CE_ALG_PRNG_V2,
+	.trng = CE_ALG_TRNG_V2,
 };
 
 static const struct ce_variant ce_a64_variant = {
@@ -99,6 +103,7 @@ static const struct ce_variant ce_a64_variant = {
 		},
 	.esr = ESR_A64,
 	.prng = CE_ALG_PRNG,
+	.trng = CE_ID_NOTSUPP,
 };
 
 static const struct ce_variant ce_r40_variant = {
@@ -115,6 +120,7 @@ static const struct ce_variant ce_r40_variant = {
 		},
 	.esr = ESR_R40,
 	.prng = CE_ALG_PRNG,
+	.trng = CE_ID_NOTSUPP,
 };
 
 /*
@@ -589,6 +595,10 @@ static int sun8i_ce_dbgfs_read(struct seq_file *seq, void *v)
 			break;
 		}
 	}
+#ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_TRNG
+	seq_printf(seq, "HWRNG %lu %lu\n",
+		   ce->hwrng_stat_req, ce->hwrng_stat_bytes);
+#endif
 	return 0;
 }
 
@@ -939,6 +949,10 @@ static int sun8i_ce_probe(struct platform_device *pdev)
 	if (err < 0)
 		goto error_alg;
 
+#ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_TRNG
+	sun8i_ce_hwrng_register(ce);
+#endif
+
 	v = readl(ce->base + CE_CTR);
 	v >>= CE_DIE_ID_SHIFT;
 	v &= CE_DIE_ID_MASK;
@@ -968,6 +982,10 @@ static int sun8i_ce_remove(struct platform_device *pdev)
 {
 	struct sun8i_ce_dev *ce = platform_get_drvdata(pdev);
 
+#ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_TRNG
+	sun8i_ce_hwrng_unregister(ce);
+#endif
+
 	sun8i_ce_unregister_algs(ce);
 
 #ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c
new file mode 100644
index 000000000000..af99730d8fd1
--- /dev/null
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c
@@ -0,0 +1,127 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * sun8i-ce-trng.c - hardware cryptographic offloader for
+ * Allwinner H3/A64/H5/H2+/H6/R40 SoC
+ *
+ * Copyright (C) 2015-2020 Corentin Labbe <clabbe@baylibre.com>
+ *
+ * This file handle the TRNG
+ *
+ * You could find a link for the datasheet in Documentation/arm/sunxi/README
+ */
+#include "sun8i-ce.h"
+#include <linux/dma-mapping.h>
+#include <linux/pm_runtime.h>
+#include <linux/hw_random.h>
+/*
+ * Note that according to the algorithm ID, 2 versions of the TRNG exists,
+ * The first present in H3/H5/R40/A64 and the second present in H6.
+ * This file adds support for both, but only the second is working
+ * reliabily according to rngtest.
+ **/
+
+static int sun8i_ce_trng_read(struct hwrng *rng, void *data, size_t max, bool wait)
+{
+	struct sun8i_ce_dev *ce;
+	dma_addr_t dma_dst;
+	int err = 0;
+	int flow = 3;
+	unsigned int todo;
+	struct sun8i_ce_flow *chan;
+	struct ce_task *cet;
+	u32 common;
+	void *d;
+
+	ce = container_of(rng, struct sun8i_ce_dev, trng);
+
+	/* round the data length to a multiple of 32*/
+	todo = max + 32;
+	todo -= todo % 32;
+
+	d = kzalloc(todo, GFP_KERNEL | GFP_DMA);
+	if (!d)
+		return -ENOMEM;
+
+#ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
+	ce->hwrng_stat_req++;
+	ce->hwrng_stat_bytes += todo;
+#endif
+
+	dma_dst = dma_map_single(ce->dev, d, todo, DMA_FROM_DEVICE);
+	if (dma_mapping_error(ce->dev, dma_dst)) {
+		dev_err(ce->dev, "Cannot DMA MAP DST\n");
+		err = -EFAULT;
+		goto err_dst;
+	}
+
+	err = pm_runtime_get_sync(ce->dev);
+	if (err < 0) {
+		pm_runtime_put_noidle(ce->dev);
+		goto err_pm;
+	}
+
+	mutex_lock(&ce->rnglock);
+	chan = &ce->chanlist[flow];
+
+	cet = &chan->tl[0];
+	memset(cet, 0, sizeof(struct ce_task));
+
+	cet->t_id = cpu_to_le32(flow);
+	common = ce->variant->trng | CE_COMM_INT;
+	cet->t_common_ctl = cpu_to_le32(common);
+
+	/* recent CE (H6) need length in bytes, in word otherwise */
+	if (ce->variant->trng_t_dlen_in_bytes)
+		cet->t_dlen = cpu_to_le32(todo);
+	else
+		cet->t_dlen = cpu_to_le32(todo / 4);
+
+	cet->t_sym_ctl = 0;
+	cet->t_asym_ctl = 0;
+
+	cet->t_dst[0].addr = cpu_to_le32(dma_dst);
+	cet->t_dst[0].len = cpu_to_le32(todo / 4);
+	ce->chanlist[flow].timeout = todo;
+
+	err = sun8i_ce_run_task(ce, 3, "TRNG");
+	mutex_unlock(&ce->rnglock);
+
+	pm_runtime_put(ce->dev);
+
+err_pm:
+	dma_unmap_single(ce->dev, dma_dst, todo, DMA_FROM_DEVICE);
+
+	if (!err) {
+		memcpy(data, d, max);
+		err = max;
+	}
+	memzero_explicit(d, todo);
+err_dst:
+	kfree(d);
+	return err;
+}
+
+int sun8i_ce_hwrng_register(struct sun8i_ce_dev *ce)
+{
+	int ret;
+
+	if (ce->variant->trng == CE_ID_NOTSUPP) {
+		dev_info(ce->dev, "TRNG not supported\n");
+		return 0;
+	}
+	ce->trng.name = "sun8i Crypto Engine TRNG";
+	ce->trng.read = sun8i_ce_trng_read;
+	ce->trng.quality = 1000;
+
+	ret = hwrng_register(&ce->trng);
+	if (ret)
+		dev_err(ce->dev, "Fail to register the TRNG\n");
+	return ret;
+}
+
+void sun8i_ce_hwrng_unregister(struct sun8i_ce_dev *ce)
+{
+	if (ce->variant->trng == CE_ID_NOTSUPP)
+		return;
+	hwrng_unregister(&ce->trng);
+}
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
index 48d518539c29..5ab71e696860 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
@@ -12,6 +12,7 @@
 #include <linux/atomic.h>
 #include <linux/debugfs.h>
 #include <linux/crypto.h>
+#include <linux/hw_random.h>
 #include <crypto/internal/hash.h>
 #include <crypto/md5.h>
 #include <crypto/rng.h>
@@ -55,7 +56,9 @@
 #define CE_ALG_SHA256           19
 #define CE_ALG_SHA384           20
 #define CE_ALG_SHA512           21
+#define CE_ALG_TRNG		48
 #define CE_ALG_PRNG		49
+#define CE_ALG_TRNG_V2		0x1c
 #define CE_ALG_PRNG_V2		0x1d
 
 /* Used in ce_variant */
@@ -129,9 +132,12 @@ struct ce_clock {
  *				bits or words
  * @prng_t_dlen_in_bytes:	Does the request size for PRNG is in
  *				bytes or words
+ * @trng_t_dlen_in_bytes:	Does the request size for TRNG is in
+ *				bytes or words
  * @ce_clks:	list of clocks needed by this variant
  * @esr:	The type of error register
  * @prng:	The CE_ALG_XXX value for the PRNG
+ * @trng:	The CE_ALG_XXX value for the TRNG
  */
 struct ce_variant {
 	char alg_cipher[CE_ID_CIPHER_MAX];
@@ -140,9 +146,11 @@ struct ce_variant {
 	bool cipher_t_dlen_in_bytes;
 	bool hash_t_dlen_in_bits;
 	bool prng_t_dlen_in_bytes;
+	bool trng_t_dlen_in_bytes;
 	struct ce_clock ce_clks[CE_MAX_CLOCKS];
 	int esr;
 	unsigned char prng;
+	unsigned char trng;
 };
 
 struct sginfo {
@@ -218,6 +226,13 @@ struct sun8i_ce_dev {
 	struct dentry *dbgfs_dir;
 	struct dentry *dbgfs_stats;
 #endif
+#ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_TRNG
+	struct hwrng trng;
+#ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
+	unsigned long hwrng_stat_req;
+	unsigned long hwrng_stat_bytes;
+#endif
+#endif
 };
 
 /*
@@ -351,3 +366,6 @@ int sun8i_ce_prng_generate(struct crypto_rng *tfm, const u8 *src,
 int sun8i_ce_prng_seed(struct crypto_rng *tfm, const u8 *seed, unsigned int slen);
 void sun8i_ce_prng_exit(struct crypto_tfm *tfm);
 int sun8i_ce_prng_init(struct crypto_tfm *tfm);
+
+int sun8i_ce_hwrng_register(struct sun8i_ce_dev *ce);
+void sun8i_ce_hwrng_unregister(struct sun8i_ce_dev *ce);
-- 
2.26.2

