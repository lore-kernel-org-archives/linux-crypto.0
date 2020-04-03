Return-Path: <SRS0=Ncaf=5T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6289C2BA12
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Apr 2020 19:50:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A25BD2077D
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Apr 2020 19:50:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="FkWYcosm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728144AbgDCTuz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Apr 2020 15:50:55 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:56174 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727829AbgDCTux (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Apr 2020 15:50:53 -0400
Received: by mail-wm1-f66.google.com with SMTP id r16so8349613wmg.5
        for <linux-crypto@vger.kernel.org>; Fri, 03 Apr 2020 12:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/28ip8yNlzBl3kqNdA+eZ6BCeI3BlfsCwZtohbtX9gk=;
        b=FkWYcosmokLgH6u6Ih3T3De0sL14NAoxZYBwAo3JXLHtuUCT7e7jQmnE8MoVE4gqze
         5vO7h3hcIJi9JqFwJh2RxKqjioSOddNo6/Qiy/QDlx/n7VxPchhRHlJJgcbsaEqq8sdF
         iMNuGYJ+u5vZZgQPTe2CqKM2um3WjzOH7hVq9ra0eRYmLPxUkqHjY6So18jcrsm8i7b9
         6FJJbtHDjBzMCpIfC4FrQkLAAxNfMKUOqVUkRDY+2EHvnsiGRm/x164+D1gKCKqZEUB3
         FuX/dMOyA+lMGPuoHc/lG6om4zAEcDhavoSsO/I2e42v6l9/6/ry0pd4ZPFZerKQ0g/u
         AuOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/28ip8yNlzBl3kqNdA+eZ6BCeI3BlfsCwZtohbtX9gk=;
        b=jPdfKOWAcFyigHi5Mv8bmIE8D0qzBCpcvanq2raBCouOQimHDThT8JV9tndQTl5/Jy
         3NVHP+wjfeie69j73ireKp+4jgkf+4f/mRPGC+tzRgmvyykPDZ/bwQMapQGisUNDY5qu
         kXiVGCx3B7B+EaXpxrbTR24i/EF8nWESjwgjXnhZ+J1+qIZTw+leB+nTPBjR51sZixag
         JvDevtGoFCuNofcseStSo1kqIbqAX9iJlvnP2LcriiNHo54TbwM0Z1Cq/YBvfNYDR7SB
         S+GIMk2ZwURxuhSe+hYkX9JR/toB0LgbE6NJRUyed42JLu4mpSf3vdvlVWeho5e7vhUd
         yPJg==
X-Gm-Message-State: AGi0PuaXMGL+JnHIbArrGQfOFbDiD/dPosxIz/d/yTUsnMWqCdStp5Ge
        ejr1xWk2JO+AvEQWd1N7wFVFsA==
X-Google-Smtp-Source: APiQypJDLz2vWum5QsgbODnfI3uBYlGG3Z6i3JxK+vAGRPd1olGF7GpVDNdajeN4jdW8S09q9kJu/w==
X-Received: by 2002:a7b:c452:: with SMTP id l18mr10757445wmi.140.1585943450232;
        Fri, 03 Apr 2020 12:50:50 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id c17sm8102448wrp.28.2020.04.03.12.50.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 03 Apr 2020 12:50:49 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 3/7] crypto: sun8i-ss: Add support for the PRNG
Date:   Fri,  3 Apr 2020 19:50:34 +0000
Message-Id: <1585943438-862-4-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1585943438-862-1-git-send-email-clabbe@baylibre.com>
References: <1585943438-862-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch had support for the PRNG present in the SS.
The output was tested with rngtest without any failure.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/Kconfig              |   8 +
 drivers/crypto/allwinner/sun8i-ss/Makefile    |   1 +
 .../crypto/allwinner/sun8i-ss/sun8i-ss-core.c |  39 ++++
 .../crypto/allwinner/sun8i-ss/sun8i-ss-prng.c | 169 ++++++++++++++++++
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h  |  25 +++
 5 files changed, 242 insertions(+)
 create mode 100644 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-prng.c

diff --git a/drivers/crypto/allwinner/Kconfig b/drivers/crypto/allwinner/Kconfig
index d315427ea1ba..a0bdb26d0fe4 100644
--- a/drivers/crypto/allwinner/Kconfig
+++ b/drivers/crypto/allwinner/Kconfig
@@ -95,3 +95,11 @@ config CRYPTO_DEV_SUN8I_SS_DEBUG
 	  Say y to enable sun8i-ss debug stats.
 	  This will create /sys/kernel/debug/sun8i-ss/stats for displaying
 	  the number of requests per flow and per algorithm.
+
+config CRYPTO_DEV_SUN8I_SS_PRNG
+	bool "Support for Allwinner Security System PRNG"
+	depends on CRYPTO_DEV_SUN8I_SS
+	select CRYPTO_RNG
+	help
+	  Select this option if you want to provide kernel-side support for
+	  the Pseudo-Random Number Generator found in the Security System.
diff --git a/drivers/crypto/allwinner/sun8i-ss/Makefile b/drivers/crypto/allwinner/sun8i-ss/Makefile
index add7b0543fd5..49f2f912c816 100644
--- a/drivers/crypto/allwinner/sun8i-ss/Makefile
+++ b/drivers/crypto/allwinner/sun8i-ss/Makefile
@@ -1,2 +1,3 @@
 obj-$(CONFIG_CRYPTO_DEV_SUN8I_SS) += sun8i-ss.o
 sun8i-ss-y += sun8i-ss-core.o sun8i-ss-cipher.o
+sun8i-ss-$(CONFIG_CRYPTO_DEV_SUN8I_SS_PRNG) += sun8i-ss-prng.o
diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
index a5cea855e7d8..347a274ce3a4 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
@@ -22,6 +22,7 @@
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/reset.h>
+#include <crypto/internal/rng.h>
 #include <crypto/internal/skcipher.h>
 
 #include "sun8i-ss.h"
@@ -260,6 +261,25 @@ static struct sun8i_ss_alg_template ss_algs[] = {
 		.decrypt	= sun8i_ss_skdecrypt,
 	}
 },
+#ifdef CONFIG_CRYPTO_DEV_SUN8I_SS_PRNG
+{
+	.type = CRYPTO_ALG_TYPE_RNG,
+	.alg.rng = {
+		.base = {
+			.cra_name		= "stdrng",
+			.cra_driver_name	= "sun8i-ss-prng",
+			.cra_priority		= 300,
+			.cra_ctxsize = sizeof(struct sun8i_ss_rng_tfm_ctx),
+			.cra_module		= THIS_MODULE,
+			.cra_init		= sun8i_ss_prng_init,
+			.cra_exit		= sun8i_ss_prng_exit,
+		},
+		.generate               = sun8i_ss_prng_generate,
+		.seed                   = sun8i_ss_prng_seed,
+		.seedsize               = PRNG_SEED_SIZE,
+	}
+},
+#endif
 };
 
 #ifdef CONFIG_CRYPTO_DEV_SUN8I_SS_DEBUG
@@ -281,6 +301,12 @@ static int sun8i_ss_dbgfs_read(struct seq_file *seq, void *v)
 				   ss_algs[i].alg.skcipher.base.cra_name,
 				   ss_algs[i].stat_req, ss_algs[i].stat_fb);
 			break;
+		case CRYPTO_ALG_TYPE_RNG:
+			seq_printf(seq, "%s %s %lu %lu\n",
+				   ss_algs[i].alg.rng.base.cra_driver_name,
+				   ss_algs[i].alg.rng.base.cra_name,
+				   ss_algs[i].stat_req, ss_algs[i].stat_bytes);
+			break;
 		}
 	}
 	return 0;
@@ -444,6 +470,14 @@ static int sun8i_ss_register_algs(struct sun8i_ss_dev *ss)
 				return err;
 			}
 			break;
+		case CRYPTO_ALG_TYPE_RNG:
+			err = crypto_register_rng(&ss_algs[i].alg.rng);
+			if (err) {
+				dev_err(ss->dev, "Fail to register %s\n",
+					ss_algs[i].alg.rng.base.cra_name);
+				ss_algs[i].ss = NULL;
+			}
+			break;
 		default:
 			ss_algs[i].ss = NULL;
 			dev_err(ss->dev, "ERROR: tried to register an unknown algo\n");
@@ -465,6 +499,11 @@ static void sun8i_ss_unregister_algs(struct sun8i_ss_dev *ss)
 				 ss_algs[i].alg.skcipher.base.cra_name);
 			crypto_unregister_skcipher(&ss_algs[i].alg.skcipher);
 			break;
+		case CRYPTO_ALG_TYPE_RNG:
+			dev_info(ss->dev, "Unregister %d %s\n", i,
+				 ss_algs[i].alg.rng.base.cra_name);
+			crypto_unregister_rng(&ss_algs[i].alg.rng);
+			break;
 		}
 	}
 }
diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-prng.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-prng.c
new file mode 100644
index 000000000000..f953d62c6348
--- /dev/null
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-prng.c
@@ -0,0 +1,169 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * sun8i-ss-prng.c - hardware cryptographic offloader for
+ * Allwinner A80/A83T SoC
+ *
+ * Copyright (C) 2015-2020 Corentin Labbe <clabbe@baylibre.com>
+ *
+ * This file handle the PRNG found in the SS
+ *
+ * You could find a link for the datasheet in Documentation/arm/sunxi.rst
+ */
+#include "sun8i-ss.h"
+#include <linux/pm_runtime.h>
+#include <crypto/internal/rng.h>
+
+int sun8i_ss_prng_seed(struct crypto_rng *tfm, const u8 *seed,
+		       unsigned int slen)
+{
+	struct sun8i_ss_rng_tfm_ctx *ctx = crypto_rng_ctx(tfm);
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
+int sun8i_ss_prng_init(struct crypto_tfm *tfm)
+{
+	struct crypto_rng *rngtfm = __crypto_rng_cast(tfm);
+	struct sun8i_ss_rng_tfm_ctx *ctx = crypto_rng_ctx(rngtfm);
+
+	memset(ctx, 0, sizeof(struct sun8i_ss_rng_tfm_ctx));
+	return 0;
+}
+
+void sun8i_ss_prng_exit(struct crypto_tfm *tfm)
+{
+	struct crypto_rng *rngtfm = __crypto_rng_cast(tfm);
+	struct sun8i_ss_rng_tfm_ctx *ctx = crypto_rng_ctx(rngtfm);
+
+	kfree(ctx->seed);
+	ctx->seed = NULL;
+	ctx->slen = 0;
+}
+
+int sun8i_ss_prng_generate(struct crypto_rng *tfm, const u8 *src,
+			   unsigned int slen, u8 *dst, unsigned int dlen)
+{
+	struct sun8i_ss_rng_tfm_ctx *ctx = crypto_rng_ctx(tfm);
+	struct rng_alg *alg = crypto_rng_alg(tfm);
+	struct sun8i_ss_alg_template *algt;
+	struct sun8i_ss_dev *ss;
+	dma_addr_t dma_iv, dma_dst;
+	unsigned int todo;
+	int err = 0;
+	int flow;
+	void *d;
+	u32 v;
+
+	algt = container_of(alg, struct sun8i_ss_alg_template, alg.rng);
+	ss = algt->ss;
+
+	if (ctx->slen == 0) {
+		dev_err(ss->dev, "The PRNG is not seeded\n");
+		return -EINVAL;
+	}
+
+	/* The SS does not give an updated seed, so we need to get a new one.
+	 * So we will ask for an extra PRNG_SEED_SIZE data.
+	 * We want dlen + seedsize rounded up to a multiple of PRNG_DATA_SIZE
+	 */
+	todo = dlen + PRNG_SEED_SIZE + PRNG_DATA_SIZE;
+	todo -= todo % PRNG_DATA_SIZE;
+
+	d = kzalloc(todo, GFP_KERNEL | GFP_DMA);
+	if (!d)
+		return -ENOMEM;
+
+	flow = sun8i_ss_get_engine_number(ss);
+
+#ifdef CONFIG_CRYPTO_DEV_SUN8I_SS_DEBUG
+	algt->stat_req++;
+	algt->stat_bytes += todo;
+#endif
+
+	v = SS_ALG_PRNG | SS_PRNG_CONTINUE | SS_START;
+	if (flow)
+		v |= SS_FLOW1;
+	else
+		v |= SS_FLOW0;
+
+	dma_iv = dma_map_single(ss->dev, ctx->seed, ctx->slen, DMA_TO_DEVICE);
+	if (dma_mapping_error(ss->dev, dma_iv)) {
+		dev_err(ss->dev, "Cannot DMA MAP IV\n");
+		return -EFAULT;
+	}
+
+	dma_dst = dma_map_single(ss->dev, d, todo, DMA_FROM_DEVICE);
+	if (dma_mapping_error(ss->dev, dma_dst)) {
+		dev_err(ss->dev, "Cannot DMA MAP DST\n");
+		err = -EFAULT;
+		goto err_iv;
+	}
+
+	err = pm_runtime_get_sync(ss->dev);
+	if (err < 0)
+		goto err_pm;
+	err = 0;
+
+	mutex_lock(&ss->mlock);
+	writel(dma_iv, ss->base + SS_IV_ADR_REG);
+	/* the PRNG act badly (failing rngtest) without SS_KEY_ADR_REG set */
+	writel(dma_iv, ss->base + SS_KEY_ADR_REG);
+	writel(dma_dst, ss->base + SS_DST_ADR_REG);
+	writel(todo / 4, ss->base + SS_LEN_ADR_REG);
+
+	reinit_completion(&ss->flows[flow].complete);
+	ss->flows[flow].status = 0;
+	/* Be sure all data is written before enabling the task */
+	wmb();
+
+	writel(v, ss->base + SS_CTL_REG);
+
+	wait_for_completion_interruptible_timeout(&ss->flows[flow].complete,
+						  msecs_to_jiffies(todo));
+	if (ss->flows[flow].status == 0) {
+		dev_err(ss->dev, "DMA timeout for PRNG (size=%u)\n", todo);
+		err = -EFAULT;
+	}
+	/* Since cipher and hash use the linux/cryptoengine and that we have
+	 * a cryptoengine per flow, we are sure that they will issue only one
+	 * request per flow.
+	 * Since the cryptoengine wait for completion before submitting a new
+	 * one, the mlock could be left just after the final writel.
+	 * But cryptoengine cannot handle crypto_rng, so we need to be sure
+	 * nothing will use our flow.
+	 * The easiest way is to grab mlock until the hardware end our requests.
+	 * We could have used a per flow lock, but this would increase
+	 * complexity.
+	 * The drawback is that no request could be handled for the other flow.
+	 */
+	mutex_unlock(&ss->mlock);
+
+	pm_runtime_put(ss->dev);
+
+err_pm:
+	dma_unmap_single(ss->dev, dma_dst, todo, DMA_FROM_DEVICE);
+err_iv:
+	dma_unmap_single(ss->dev, dma_iv, ctx->slen, DMA_TO_DEVICE);
+
+	if (!err) {
+		memcpy(dst, d, dlen);
+		/* Update seed */
+		memcpy(ctx->seed, d + dlen, ctx->slen);
+	}
+	kzfree(d);
+
+	return err;
+}
diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
index f7a64033fc03..0223e10495ac 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
@@ -8,6 +8,7 @@
 #include <crypto/aes.h>
 #include <crypto/des.h>
 #include <crypto/engine.h>
+#include <crypto/rng.h>
 #include <crypto/skcipher.h>
 #include <linux/atomic.h>
 #include <linux/debugfs.h>
@@ -21,6 +22,7 @@
 #define SS_ALG_AES		0
 #define SS_ALG_DES		(1 << 2)
 #define SS_ALG_3DES		(2 << 2)
+#define SS_ALG_PRNG		(4 << 2)
 
 #define SS_CTL_REG		0x00
 #define SS_INT_CTL_REG		0x04
@@ -52,6 +54,8 @@
 #define SS_FLOW0	BIT(30)
 #define SS_FLOW1	BIT(31)
 
+#define SS_PRNG_CONTINUE	BIT(18)
+
 #define MAX_SG 8
 
 #define MAXFLOW 2
@@ -61,6 +65,9 @@
 #define SS_DIE_ID_SHIFT	20
 #define SS_DIE_ID_MASK	0x07
 
+#define PRNG_DATA_SIZE (160 / 8)
+#define PRNG_SEED_SIZE DIV_ROUND_UP(175, 8)
+
 /*
  * struct ss_clock - Describe clocks used by sun8i-ss
  * @name:       Name of clock needed by this variant
@@ -179,6 +186,16 @@ struct sun8i_cipher_tfm_ctx {
 	struct crypto_sync_skcipher *fallback_tfm;
 };
 
+/*
+ * struct sun8i_ss_prng_ctx - context for PRNG TFM
+ * @seed:	The seed to use
+ * @slen:	The size of the seed
+ */
+struct sun8i_ss_rng_tfm_ctx {
+	void *seed;
+	unsigned int slen;
+};
+
 /*
  * struct sun8i_ss_alg_template - crypto_alg template
  * @type:		the CRYPTO_ALG_TYPE for this template
@@ -189,6 +206,7 @@ struct sun8i_cipher_tfm_ctx {
  * @alg:		one of sub struct must be used
  * @stat_req:		number of request done on this template
  * @stat_fb:		number of request which has fallbacked
+ * @stat_bytes:		total data size done by this template
  */
 struct sun8i_ss_alg_template {
 	u32 type;
@@ -197,10 +215,12 @@ struct sun8i_ss_alg_template {
 	struct sun8i_ss_dev *ss;
 	union {
 		struct skcipher_alg skcipher;
+		struct rng_alg rng;
 	} alg;
 #ifdef CONFIG_CRYPTO_DEV_SUN8I_SS_DEBUG
 	unsigned long stat_req;
 	unsigned long stat_fb;
+	unsigned long stat_bytes;
 #endif
 };
 
@@ -218,3 +238,8 @@ int sun8i_ss_skencrypt(struct skcipher_request *areq);
 int sun8i_ss_get_engine_number(struct sun8i_ss_dev *ss);
 
 int sun8i_ss_run_task(struct sun8i_ss_dev *ss, struct sun8i_cipher_req_ctx *rctx, const char *name);
+int sun8i_ss_prng_generate(struct crypto_rng *tfm, const u8 *src,
+			   unsigned int slen, u8 *dst, unsigned int dlen);
+int sun8i_ss_prng_seed(struct crypto_rng *tfm, const u8 *seed, unsigned int slen);
+int sun8i_ss_prng_init(struct crypto_tfm *tfm);
+void sun8i_ss_prng_exit(struct crypto_tfm *tfm);
-- 
2.24.1

