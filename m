Return-Path: <SRS0=W4lJ=6I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8412BC55191
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Apr 2020 14:03:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 563972075A
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Apr 2020 14:03:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="xWWoK2o+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728520AbgDXOC5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 Apr 2020 10:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727038AbgDXOC4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Apr 2020 10:02:56 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50665C09B045
        for <linux-crypto@vger.kernel.org>; Fri, 24 Apr 2020 07:02:55 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id h2so10572639wmb.4
        for <linux-crypto@vger.kernel.org>; Fri, 24 Apr 2020 07:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Ngf3qsfO2V989B3HBOESqGUe0AMmqHsI3ObXw8kn6Z0=;
        b=xWWoK2o+M8uO7Sv4kkziqRiFPcWnSgGSoJhJDnyYDnywlMFF0M+lSVGAlmVZrKTTFA
         Tl+WKDkZfmkDulwtlfVzwGOM8qkSXkCB6fhKX1CrN6f+bwTaAEqVneJFo+Gv3bQDrjvS
         omkBzBS0jGpTCM9gjm7J9Ts10hxsDUz6RWyA60ezA6+LN3gRvdVDxdZDZ+PZXjBSs0NJ
         kreTPRIUHkREMu3NUZxcA45pJ5X500zTHbl3cjcXU4OZGn2WJsc6e3bcxzeRUb/pVdyo
         FV4TpSsUMxvGa1ohd7d7oySEJB5FdHveJQ3FfFyuZtCPky1IrKlMlhcIDQJgGUeclNof
         YrVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Ngf3qsfO2V989B3HBOESqGUe0AMmqHsI3ObXw8kn6Z0=;
        b=jIOoiB6Ixkj4wTfeJSgUQ0T2en+ov2zFmkcXro7byFMSeWvbfcpWcNjymXQAkzWKqk
         7OY0pQ1ZqKiyiXlPOxvW7Y5dQB9fRU1OApZoQHmJD52sMPD8PyO0omxo2HOjwu0VHDF4
         9xrJWuGJr9qJAOQr2kzYvlgF/ornBIXz9Il9WW2r4Jf3aNWQ7Q0dwHg8QzOcZy4th7Oy
         gyJzPB52PYWDE3V55jJgeN1M5NnjH4kwje8PZEzbsgmMMHeMcA/CAuE8i4FCXwuOCfw5
         glEnh/WQ9f2TLYCee1EvWNq1eY0XF8xHofZl//XqbVYKMlS6L2OvSB4MyPX1AcUWr0+G
         T+qw==
X-Gm-Message-State: AGi0PuaUEgUKhzOkByE9K+p2xLaFODI9LMoD7P/YasvolLTYZAxpUtXY
        ebvEPmvRr589Km2/KOSgYU6DkA==
X-Google-Smtp-Source: APiQypLpqjqlvOsrZibcJicX/6++CPBIOOsDbHzX4g7GxAnNu0j9Bxjjh40xqYZg8zh7YvVseAG9Xw==
X-Received: by 2002:a05:600c:2196:: with SMTP id e22mr10048935wme.105.1587736973863;
        Fri, 24 Apr 2020 07:02:53 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id v131sm3061051wmb.19.2020.04.24.07.02.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Apr 2020 07:02:52 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v2 13/14] crypto: sun8i-ce: Add support for the PRNG
Date:   Fri, 24 Apr 2020 14:02:13 +0000
Message-Id: <1587736934-22801-14-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1587736934-22801-1-git-send-email-clabbe@baylibre.com>
References: <1587736934-22801-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch had support for the PRNG present in the CE.
The output was tested with rngtest without any failure.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/Kconfig              |   8 +
 drivers/crypto/allwinner/sun8i-ce/Makefile    |   1 +
 .../crypto/allwinner/sun8i-ce/sun8i-ce-core.c |  58 +++++-
 .../crypto/allwinner/sun8i-ce/sun8i-ce-prng.c | 189 ++++++++++++++++++
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h  |  31 +++
 5 files changed, 286 insertions(+), 1 deletion(-)
 create mode 100644 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c

diff --git a/drivers/crypto/allwinner/Kconfig b/drivers/crypto/allwinner/Kconfig
index 93cc67adb1ed..223a5823867c 100644
--- a/drivers/crypto/allwinner/Kconfig
+++ b/drivers/crypto/allwinner/Kconfig
@@ -79,6 +79,14 @@ config CRYPTO_DEV_SUN8I_CE_HASH
 	help
 	  Say y to enable support for hash algorithms.
 
+config CRYPTO_DEV_SUN8I_CE_PRNG
+	bool "Support for Allwinner Crypto Engine PRNG"
+	depends on CRYPTO_DEV_SUN8I_CE
+	select CRYPTO_RNG
+	help
+	  Select this option if you want to provide kernel-side support for
+	  the Pseudo-Random Number Generator found in the Crypto Engine.
+
 config CRYPTO_DEV_SUN8I_SS
 	tristate "Support for Allwinner Security System cryptographic offloader"
 	select CRYPTO_SKCIPHER
diff --git a/drivers/crypto/allwinner/sun8i-ce/Makefile b/drivers/crypto/allwinner/sun8i-ce/Makefile
index d1b1f0e86c79..c0ea81da2c7d 100644
--- a/drivers/crypto/allwinner/sun8i-ce/Makefile
+++ b/drivers/crypto/allwinner/sun8i-ce/Makefile
@@ -1,3 +1,4 @@
 obj-$(CONFIG_CRYPTO_DEV_SUN8I_CE) += sun8i-ce.o
 sun8i-ce-y += sun8i-ce-core.o sun8i-ce-cipher.o
 sun8i-ce-$(CONFIG_CRYPTO_DEV_SUN8I_CE_HASH) += sun8i-ce-hash.o
+sun8i-ce-$(CONFIG_CRYPTO_DEV_SUN8I_CE_PRNG) += sun8i-ce-prng.o
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
index 8c94ffe1efd0..23b9fc67d7ea 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
@@ -22,6 +22,7 @@
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/reset.h>
+#include <crypto/internal/rng.h>
 #include <crypto/internal/skcipher.h>
 
 #include "sun8i-ce.h"
@@ -45,6 +46,7 @@ static const struct ce_variant ce_h3_variant = {
 		{ "mod", 50000000, 0 },
 		},
 	.esr = ESR_H3,
+	.prng = CE_ALG_PRNG,
 };
 
 static const struct ce_variant ce_h5_variant = {
@@ -60,6 +62,7 @@ static const struct ce_variant ce_h5_variant = {
 		{ "mod", 300000000, 0 },
 		},
 	.esr = ESR_H5,
+	.prng = CE_ALG_PRNG,
 };
 
 static const struct ce_variant ce_h6_variant = {
@@ -72,12 +75,14 @@ static const struct ce_variant ce_h6_variant = {
 	},
 	.cipher_t_dlen_in_bytes = true,
 	.hash_t_dlen_in_bits = true,
+	.prng_t_dlen_in_bytes = true,
 	.ce_clks = {
 		{ "bus", 0, 200000000 },
 		{ "mod", 300000000, 0 },
 		{ "ram", 0, 400000000 },
 		},
 	.esr = ESR_H6,
+	.prng = CE_ALG_PRNG_V2,
 };
 
 static const struct ce_variant ce_a64_variant = {
@@ -93,6 +98,7 @@ static const struct ce_variant ce_a64_variant = {
 		{ "mod", 300000000, 0 },
 		},
 	.esr = ESR_A64,
+	.prng = CE_ALG_PRNG,
 };
 
 static const struct ce_variant ce_r40_variant = {
@@ -108,15 +114,17 @@ static const struct ce_variant ce_r40_variant = {
 		{ "mod", 300000000, 0 },
 		},
 	.esr = ESR_R40,
+	.prng = CE_ALG_PRNG,
 };
 
 /*
  * sun8i_ce_get_engine_number() get the next channel slot
  * This is a simple round-robin way of getting the next channel
+ * The flow 3 is reserve for xRNG operations
  */
 int sun8i_ce_get_engine_number(struct sun8i_ce_dev *ce)
 {
-	return atomic_inc_return(&ce->flow) % MAXFLOW;
+	return atomic_inc_return(&ce->flow) % (MAXFLOW - 1);
 }
 
 int sun8i_ce_run_task(struct sun8i_ce_dev *ce, int flow, const char *name)
@@ -130,6 +138,7 @@ int sun8i_ce_run_task(struct sun8i_ce_dev *ce, int flow, const char *name)
 #endif
 
 	mutex_lock(&ce->mlock);
+	mutex_init(&ce->rnglock);
 
 	v = readl(ce->base + CE_ICR);
 	v |= 1 << flow;
@@ -516,6 +525,25 @@ static struct sun8i_ce_alg_template ce_algs[] = {
 	}
 },
 #endif
+#ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_PRNG
+{
+	.type = CRYPTO_ALG_TYPE_RNG,
+	.alg.rng = {
+		.base = {
+			.cra_name		= "stdrng",
+			.cra_driver_name	= "sun8i-ce-prng",
+			.cra_priority		= 300,
+			.cra_ctxsize		= sizeof(struct sun8i_ce_rng_tfm_ctx),
+			.cra_module		= THIS_MODULE,
+			.cra_init		= sun8i_ce_prng_init,
+			.cra_exit		= sun8i_ce_prng_exit,
+		},
+		.generate               = sun8i_ce_prng_generate,
+		.seed                   = sun8i_ce_prng_seed,
+		.seedsize               = PRNG_SEED_SIZE,
+	}
+},
+#endif
 };
 
 #ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
@@ -543,6 +571,12 @@ static int sun8i_ce_dbgfs_read(struct seq_file *seq, void *v)
 				   ce_algs[i].alg.hash.halg.base.cra_name,
 				   ce_algs[i].stat_req, ce_algs[i].stat_fb);
 			break;
+		case CRYPTO_ALG_TYPE_RNG:
+			seq_printf(seq, "%s %s %lu %lu\n",
+				   ce_algs[i].alg.rng.base.cra_driver_name,
+				   ce_algs[i].alg.rng.base.cra_name,
+				   ce_algs[i].stat_req, ce_algs[i].stat_bytes);
+			break;
 		}
 	}
 	return 0;
@@ -777,6 +811,23 @@ static int sun8i_ce_register_algs(struct sun8i_ce_dev *ce)
 				return err;
 			}
 			break;
+		case CRYPTO_ALG_TYPE_RNG:
+			if (ce->variant->prng == CE_ID_NOTSUPP) {
+				dev_info(ce->dev,
+					 "DEBUG: Algo of %s not supported\n",
+					 ce_algs[i].alg.rng.base.cra_name);
+				ce_algs[i].ce = NULL;
+				break;
+			}
+			dev_info(ce->dev, "Register %s\n",
+				 ce_algs[i].alg.rng.base.cra_name);
+			err = crypto_register_rng(&ce_algs[i].alg.rng);
+			if (err) {
+				dev_err(ce->dev, "Fail to register %s\n",
+					ce_algs[i].alg.rng.base.cra_name);
+				ce_algs[i].ce = NULL;
+			}
+			break;
 		default:
 			ce_algs[i].ce = NULL;
 			dev_err(ce->dev, "ERROR: tried to register an unknown algo\n");
@@ -803,6 +854,11 @@ static void sun8i_ce_unregister_algs(struct sun8i_ce_dev *ce)
 				 ce_algs[i].alg.hash.halg.base.cra_name);
 			crypto_unregister_ahash(&ce_algs[i].alg.hash);
 			break;
+		case CRYPTO_ALG_TYPE_RNG:
+			dev_info(ce->dev, "Unregister %d %s\n", i,
+				 ce_algs[i].alg.rng.base.cra_name);
+			crypto_unregister_rng(&ce_algs[i].alg.rng);
+			break;
 		}
 	}
 }
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c
new file mode 100644
index 000000000000..8f82bfc2c54c
--- /dev/null
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c
@@ -0,0 +1,189 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * sun8i-ce-prng.c - hardware cryptographic offloader for
+ * Allwinner H3/A64/H5/H2+/H6/R40 SoC
+ *
+ * Copyright (C) 2015-2020 Corentin Labbe <clabbe@baylibre.com>
+ *
+ * This file handle the PRNG
+ *
+ * You could find a link for the datasheet in Documentation/arm/sunxi/README
+ */
+#include "sun8i-ce.h"
+#include <linux/pm_runtime.h>
+#include <crypto/internal/rng.h>
+
+int sun8i_ce_prng_init(struct crypto_tfm *tfm)
+{
+	struct sun8i_ce_rng_tfm_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	memset(ctx, 0, sizeof(struct sun8i_ce_rng_tfm_ctx));
+	return 0;
+}
+
+void sun8i_ce_prng_exit(struct crypto_tfm *tfm)
+{
+	struct sun8i_ce_rng_tfm_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	kfree(ctx->seed);
+	ctx->seed = NULL;
+	ctx->slen = 0;
+}
+
+int sun8i_ce_prng_seed(struct crypto_rng *tfm, const u8 *seed,
+		       unsigned int slen)
+{
+	struct sun8i_ce_rng_tfm_ctx *ctx = crypto_rng_ctx(tfm);
+
+	if (ctx->seed && ctx->slen != slen) {
+		ctx->slen = 0;
+		kfree(ctx->seed);
+		ctx->seed = NULL;
+	}
+	if (!ctx->seed)
+		ctx->seed = kmalloc(slen, GFP_KERNEL | GFP_DMA);
+	if (!ctx->seed)
+		return -ENOMEM;
+
+	memcpy(ctx->seed, seed, slen);
+	ctx->slen = slen;
+
+	return 0;
+}
+
+int sun8i_ce_prng_generate(struct crypto_rng *tfm, const u8 *src,
+			   unsigned int slen, u8 *dst, unsigned int dlen)
+{
+	struct sun8i_ce_rng_tfm_ctx *ctx = crypto_rng_ctx(tfm);
+	struct rng_alg *alg = crypto_rng_alg(tfm);
+	struct sun8i_ce_alg_template *algt;
+	struct sun8i_ce_dev *ce;
+	dma_addr_t dma_iv, dma_dst;
+	int err = 0;
+	int flow = 3;
+	unsigned int todo;
+	struct sun8i_ce_flow *chan;
+	struct ce_task *cet;
+	u32 common, sym;
+	dma_addr_t dma_next, dma_key;
+	void *next, *key;
+	void *d;
+
+	algt = container_of(alg, struct sun8i_ce_alg_template, alg.rng);
+	ce = algt->ce;
+
+	if (ctx->slen == 0) {
+		dev_err(ce->dev, "not seeded\n");
+		return -EINVAL;
+	}
+
+	next = kzalloc(256, GFP_KERNEL | GFP_DMA);
+	if (!next)
+		return -ENOMEM;
+
+	key = kzalloc(256, GFP_KERNEL | GFP_DMA);
+	if (!key)
+		return -ENOMEM;
+
+	/* we want dlen + seedsize rounded up to a multiple of PRNG_DATA_SIZE */
+	todo = dlen + ctx->slen + PRNG_DATA_SIZE * 2;
+	todo -= todo % PRNG_DATA_SIZE;
+
+	d = kzalloc(todo + 20, GFP_KERNEL | GFP_DMA);
+	if (!d)
+		return -ENOMEM;
+
+	dev_dbg(ce->dev, "%s PRNG slen=%u dlen=%u todo=%u multi=%u\n", __func__,
+		slen, dlen, todo, todo / PRNG_DATA_SIZE);
+
+	if (ctx->slen == 0) {
+		dev_err(ce->dev, "not seeded\n");
+		return -EINVAL;
+	}
+
+#ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
+	algt->stat_req++;
+	algt->stat_bytes += todo;
+#endif
+
+	dma_iv = dma_map_single(ce->dev, ctx->seed, ctx->slen, DMA_TO_DEVICE);
+	if (dma_mapping_error(ce->dev, dma_iv)) {
+		dev_err(ce->dev, "Cannot DMA MAP IV\n");
+		return -EFAULT;
+	}
+
+	dma_dst = dma_map_single(ce->dev, d, todo, DMA_FROM_DEVICE);
+	if (dma_mapping_error(ce->dev, dma_dst)) {
+		dev_err(ce->dev, "Cannot DMA MAP DST\n");
+		err = -EFAULT;
+		goto err_iv;
+	}
+
+	dma_next = dma_map_single(ce->dev, next, 256, DMA_FROM_DEVICE);
+	if (dma_mapping_error(ce->dev, dma_next)) {
+		dev_err(ce->dev, "Cannot DMA MAP NEXT\n");
+		err = -EFAULT;
+		goto err_iv;
+	}
+
+	dma_key = dma_map_single(ce->dev, key, 256, DMA_FROM_DEVICE);
+	if (dma_mapping_error(ce->dev, dma_key)) {
+		dev_err(ce->dev, "Cannot DMA MAP NEXT\n");
+		err = -EFAULT;
+		goto err_iv;
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
+	common = ce->variant->prng | CE_COMM_INT;
+	cet->t_common_ctl = cpu_to_le32(common);
+
+	/* recent CE (H6) need length in bytes, in word otherwise */
+	if (ce->variant->prng_t_dlen_in_bytes)
+		cet->t_dlen = cpu_to_le32(todo);
+	else
+		cet->t_dlen = cpu_to_le32(todo / 4);
+
+	sym = PRNG_LD;
+	cet->t_sym_ctl = cpu_to_le32(sym);
+	cet->t_asym_ctl = 0;
+
+	cet->t_key = cpu_to_le32(dma_key);
+	cet->t_key = cpu_to_le32(dma_iv);
+	cet->t_iv = cpu_to_le32(dma_iv);
+	cet->t_ctr = cpu_to_le32(dma_next);
+
+	cet->t_dst[0].addr = cpu_to_le32(dma_dst);
+	cet->t_dst[0].len = cpu_to_le32(todo / 4);
+	ce->chanlist[flow].timeout = 2000;
+
+	err = sun8i_ce_run_task(ce, 3, "PRNG");
+	mutex_unlock(&ce->rnglock);
+
+	pm_runtime_put(ce->dev);
+
+	dma_unmap_single(ce->dev, dma_key, 256, DMA_FROM_DEVICE);
+	dma_unmap_single(ce->dev, dma_next, 256, DMA_FROM_DEVICE);
+err_pm:
+	dma_unmap_single(ce->dev, dma_dst, todo, DMA_FROM_DEVICE);
+err_iv:
+	dma_unmap_single(ce->dev, dma_iv, ctx->slen, DMA_TO_DEVICE);
+
+	if (!err) {
+		memcpy(dst, d, dlen);
+		memcpy(ctx->seed, d + dlen, ctx->slen);
+	}
+	kfree(next);
+	kfree(key);
+	kfree(d);
+	return err;
+}
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
index ef2f1e5aa23a..2ef0c3814367 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
@@ -14,6 +14,7 @@
 #include <linux/crypto.h>
 #include <crypto/internal/hash.h>
 #include <crypto/md5.h>
+#include <crypto/rng.h>
 #include <crypto/sha.h>
 
 /* CE Registers */
@@ -54,6 +55,8 @@
 #define CE_ALG_SHA256           19
 #define CE_ALG_SHA384           20
 #define CE_ALG_SHA512           21
+#define CE_ALG_PRNG		49
+#define CE_ALG_PRNG_V2		0x1d
 
 /* Used in ce_variant */
 #define CE_ID_NOTSUPP		0xFF
@@ -88,6 +91,10 @@
 #define ESR_H5	3
 #define ESR_H6	4
 
+#define PRNG_DATA_SIZE (160 / 8)
+#define PRNG_SEED_SIZE DIV_ROUND_UP(175, 8)
+#define PRNG_LD BIT(17)
+
 #define CE_DIE_ID_SHIFT	16
 #define CE_DIE_ID_MASK	0x07
 
@@ -120,8 +127,11 @@ struct ce_clock {
  *				bytes or words
  * @hash_t_dlen_in_bytes:	Does the request size for hash is in
  *				bits or words
+ * @prng_t_dlen_in_bytes:	Does the request size for PRNG is in
+ *				bytes or words
  * @ce_clks:	list of clocks needed by this variant
  * @esr:	The type of error register
+ * @prng:	The CE_ALG_XXX value for the PRNG
  */
 struct ce_variant {
 	char alg_cipher[CE_ID_CIPHER_MAX];
@@ -129,8 +139,10 @@ struct ce_variant {
 	u32 op_mode[CE_ID_OP_MAX];
 	bool cipher_t_dlen_in_bytes;
 	bool hash_t_dlen_in_bits;
+	bool prng_t_dlen_in_bytes;
 	struct ce_clock ce_clks[CE_MAX_CLOCKS];
 	int esr;
+	char prng;
 };
 
 struct sginfo {
@@ -185,6 +197,7 @@ struct sun8i_ce_flow {
  * @reset:	pointer to reset controller
  * @dev:	the platform device
  * @mlock:	Control access to device registers
+ * @rnglock:	Control access to the RNG (dedicated channel 3)
  * @chanlist:	array of all flow
  * @flow:	flow to use in next request
  * @variant:	pointer to variant specific data
@@ -197,6 +210,7 @@ struct sun8i_ce_dev {
 	struct reset_control *reset;
 	struct device *dev;
 	struct mutex mlock;
+	struct mutex rnglock;
 	struct sun8i_ce_flow *chanlist;
 	atomic_t flow;
 	const struct ce_variant *variant;
@@ -264,6 +278,16 @@ struct sun8i_ce_hash_reqctx {
 	int flow;
 };
 
+/*
+ * struct sun8i_ce_prng_ctx - context for PRNG TFM
+ * @seed:	The seed to use
+ * @slen:	The size of the seed
+ */
+struct sun8i_ce_rng_tfm_ctx {
+	void *seed;
+	unsigned int slen;
+};
+
 /*
  * struct sun8i_ce_alg_template - crypto_alg template
  * @type:		the CRYPTO_ALG_TYPE for this template
@@ -284,6 +308,7 @@ struct sun8i_ce_alg_template {
 	union {
 		struct skcipher_alg skcipher;
 		struct ahash_alg hash;
+		struct rng_alg rng;
 	} alg;
 #ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
 	unsigned long stat_req;
@@ -318,3 +343,9 @@ int sun8i_ce_hash_update(struct ahash_request *areq);
 int sun8i_ce_hash_finup(struct ahash_request *areq);
 int sun8i_ce_hash_digest(struct ahash_request *areq);
 int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq);
+
+int sun8i_ce_prng_generate(struct crypto_rng *tfm, const u8 *src,
+			   unsigned int slen, u8 *dst, unsigned int dlen);
+int sun8i_ce_prng_seed(struct crypto_rng *tfm, const u8 *seed, unsigned int slen);
+void sun8i_ce_prng_exit(struct crypto_tfm *tfm);
+int sun8i_ce_prng_init(struct crypto_tfm *tfm);
-- 
2.26.2

