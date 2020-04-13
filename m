Return-Path: <SRS0=MzAP=55=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC53DC2BA19
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Apr 2020 10:06:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C333720732
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Apr 2020 10:06:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="eEplc62x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbgDMKFv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 13 Apr 2020 06:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728339AbgDMKE4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Apr 2020 06:04:56 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1666C008619
        for <linux-crypto@vger.kernel.org>; Mon, 13 Apr 2020 02:58:26 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id x25so8855766wmc.0
        for <linux-crypto@vger.kernel.org>; Mon, 13 Apr 2020 02:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FCjnjhJX7qygTimvzKaS8dDINkwunt76OLwRGwafATY=;
        b=eEplc62xX+eE5+YnmikSqPfhk37jcoFNnW3wMX3VEnCtDwNiMoqHkCuXSF0wj5IhOc
         LUlH0MHhKpa7MpWwCmkOtJNWF0/cp1E4tKKg3DeaaXHrLk3xqN9k14N7rZ2eaWhlfi5Y
         tEqUvbuYibWpqz0hj0s+Gk2vuZ5fCoDClDdr0iSAVPPc+mM/9Pw0HbBEBq+TiBQBnFVV
         2PqT3YVqBnedx5oY8hvw/TfjQoDmvA55G+l5inEjEYB14NNk00CyJKNjkgTdoGahxotR
         ioHM0oOx/wBTft7IQz34V0078fODNZUwQ5ttB6gjsHHXuiHAhJ8z3C5ciiP55T9Nxwef
         eiSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FCjnjhJX7qygTimvzKaS8dDINkwunt76OLwRGwafATY=;
        b=pe/U8MKMbPmIj9lOfk747hHVyRcLafYCXTxDL0s3woPhEwSp55Sokllb2Alh4pQF17
         WX5koHoNFBixMty7cL7ApDdn/oddv2uzK2FQVgiMETsor3Xm4HGt3W9dtUtkAbbGacdk
         gYklSX8qeTQqlZrrBQDlwGTsBslyXuptac888bxF3YzauRRfJ40yGvBOgcHJa67GWVQn
         Eo/V77y3Q4BriJXibjV8FdegRD8NN3FwHZ9YxP7LmSvutMy+trzK9KxQURFfmQGd1GF9
         u2gAQC+Ma1M3Gnh/scurx5cIMhzgpo9G44BSLlGa5t2vk4xcg5B2tuJRFsNkquFZTppI
         Bvew==
X-Gm-Message-State: AGi0PubcjIIDd7Y2w2PGzBVhq8MF2CfkgKJsfpQwVq5IH5wjc8Fj+rRa
        tRPad50ncQWMPHjh4NlyN+lT3g==
X-Google-Smtp-Source: APiQypLQ8GMndSdV9BtJhzmyC3uUxOMLygmHF4zVaAVjrKBo28KLWVCdgau6QFEmp3ZxD9sr/S/qTA==
X-Received: by 2002:a1c:7715:: with SMTP id t21mr17045128wmi.182.1586771905313;
        Mon, 13 Apr 2020 02:58:25 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id v21sm13594491wmj.8.2020.04.13.02.58.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 Apr 2020 02:58:24 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 9/9] crypto: sun8i-ce: Add support for the TRNG
Date:   Mon, 13 Apr 2020 09:58:09 +0000
Message-Id: <1586771889-3299-10-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1586771889-3299-1-git-send-email-clabbe@baylibre.com>
References: <1586771889-3299-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch had support for the TRNG present in the CE.
Note that according to the algorithm ID, 2 version of the TRNG exists,
the first present in H3/H5/R40/A64 and the second present in H6.
This patch adds support for both, but only the second is working
reliabily accoridng to rngtest.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/Kconfig              |   8 ++
 drivers/crypto/allwinner/sun8i-ce/Makefile    |   1 +
 .../crypto/allwinner/sun8i-ce/sun8i-ce-core.c |  18 +++
 .../crypto/allwinner/sun8i-ce/sun8i-ce-trng.c | 123 ++++++++++++++++++
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h  |  18 +++
 5 files changed, 168 insertions(+)
 create mode 100644 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c

diff --git a/drivers/crypto/allwinner/Kconfig b/drivers/crypto/allwinner/Kconfig
index 223a5823867c..6aec31f7d2be 100644
--- a/drivers/crypto/allwinner/Kconfig
+++ b/drivers/crypto/allwinner/Kconfig
@@ -87,6 +87,14 @@ config CRYPTO_DEV_SUN8I_CE_PRNG
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
index 54dfd7b9463e..138196c2b0fa 100644
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
@@ -579,6 +585,10 @@ static int sun8i_ce_dbgfs_read(struct seq_file *seq, void *v)
 			break;
 		}
 	}
+#ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_TRNG
+	seq_printf(seq, "HWRNG %lu %lu\n",
+		   ce->hwrng_stat_req, ce->hwrng_stat_bytes);
+#endif
 	return 0;
 }
 
@@ -928,6 +938,10 @@ static int sun8i_ce_probe(struct platform_device *pdev)
 	if (err < 0)
 		goto error_alg;
 
+#ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_TRNG
+	sun8i_ce_hwrng_register(ce);
+#endif
+
 	v = readl(ce->base + CE_CTR);
 	v >>= CE_DIE_ID_SHIFT;
 	v &= CE_DIE_ID_MASK;
@@ -957,6 +971,10 @@ static int sun8i_ce_remove(struct platform_device *pdev)
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
index 000000000000..5e4effe29ed3
--- /dev/null
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c
@@ -0,0 +1,123 @@
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
+#include <linux/pm_runtime.h>
+#include <linux/hw_random.h>
+/*
+ * Note that according to the algorithm ID, 2 versions of the TRNG exists,
+ * The first present in H3/H5/R40/A64 and the second present in H6.
+ * This file adds support for both, but only the second is working
+ * reliabily according to rngtest.
+ **/
+
+int sun8i_ce_trng_read(struct hwrng *rng, void *data, size_t max, bool wait)
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
+	if (err < 0)
+		goto err_pm;
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
+	ce->chanlist[flow].timeout = 2000;
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
+
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
index 2ef0c3814367..746e56c254d4 100644
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
 	char prng;
+	char trng;
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
@@ -349,3 +364,6 @@ int sun8i_ce_prng_generate(struct crypto_rng *tfm, const u8 *src,
 int sun8i_ce_prng_seed(struct crypto_rng *tfm, const u8 *seed, unsigned int slen);
 void sun8i_ce_prng_exit(struct crypto_tfm *tfm);
 int sun8i_ce_prng_init(struct crypto_tfm *tfm);
+
+int sun8i_ce_hwrng_register(struct sun8i_ce_dev *ce);
+void sun8i_ce_hwrng_unregister(struct sun8i_ce_dev *ce);
-- 
2.24.1

