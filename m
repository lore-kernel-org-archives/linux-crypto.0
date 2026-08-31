Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889CA37AA7A;
	Mon, 31 Aug 2026 20:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788207959; cv=none; b=WFDOgHdRZ3zx8iBtyo8PzMWyNc0jGRdsluTMW1wjgRVO2wkyLZReNNDeY7Li+X6NkjRAscvYPobp5NpP1eykKRe7eyz/diq4VbWTHEBMsu1E4ympsxgih5oNQ8kieGyoG8BbyWymQ+3io4UJiekx6orvfdotf8Io2YV1Oyc2aKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788207959; c=relaxed/simple;
	bh=IW2GlMt1lMA+Dvmr1Qi/JBEFqyilacgMuXPJ48GMFRw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FO47OB2luBdQRJkGW0rjq5XjU71/RIYbxgpSnFZ3ZnYnBZ8YYq0SpiAv4A7YiZIID6SbPkqVDNTqkv4Zz34fjpSabULwJUBMOEzYWrW/6EL6z/2ChOeOL1SBkfG9EoWqk7E3qOlIJhk1SFAdtED1+bJ22IGQagX5auonzYlRZPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ju9ytv+t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ju9ytv+t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA4FC1F000E9;
	Mon, 31 Aug 2026 20:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788207957;
	bh=sw8Odf+/j4LzH/ujHDdCaENjOfhaimkhk6w4zfe4cAs=;
	h=From:To:Cc:Subject:Date;
	b=Ju9ytv+twdixJj3ht7hVd7QNKsktKHXhiZdAe2g8CPIpsd+2OuBMwXI+ac6ZyOmEv
	 +kKEznxVlOZq+HUCjYfhTUPLRn304fLw42yCcTx+PUYS404o9AG6EUSMWlYSCT4sqt
	 Xum2//8C14tdG6Gb9V13XwFGwzhe1Vlr8BlzzLG+d+1HFJv8I143iBf0TbHBoJ9clq
	 miLevYw+XahCSF7iv0rnH5+p02TxeTo6QNbRu/L/HB0b2JHJmb2ZDj7HQnnNmUOdFF
	 M0JwU/83JF/cfz16REnmJOAhnfwWI6nEf+TTtnrPumjhoBpws6iO9m312SISa+w+EB
	 0CImK3pO1fehQ==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	Corentin Labbe <clabbe.montjoie@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.1] crypto: sun8i-ce - Remove crypto_rng interface
Date: Mon, 31 Aug 2026 13:25:28 -0700
Message-ID: <20260831202528.178706-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 011556f71d094da61379ae3672692cae2795304e upstream.

Since the crypto_rng interface for hardware PRNGs is unused and is
redundant with hwrng and the actual Linux RNG, it's being phased out.
Most drivers for it were already removed.  Go ahead and remove the
sun8i-ce support which is one of the only remaining ones.

Note that the sun8i-ce support for hwrng remains in place.  That is the
interface that actually matters.

As usual for crypto_rng, this driver was also buggy: its ->generate()
function had a use-after-free vulnerability due to using
wait_for_completion_interruptible_timeout() without handling shutting
down the DMA operation if a signal is sent.  There's no point in fixing
this separately only to remove the code anyway, so this commit is marked
with Fixes and Cc stable.

Fixes: 5eb7e9468884 ("crypto: sun8i-ce - Add support for the PRNG")
Cc: stable@vger.kernel.org
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/allwinner/Kconfig              |   8 -
 drivers/crypto/allwinner/sun8i-ce/Makefile    |   1 -
 .../crypto/allwinner/sun8i-ce/sun8i-ce-core.c |  55 ------
 .../crypto/allwinner/sun8i-ce/sun8i-ce-prng.c | 160 ------------------
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h  |  29 ----
 5 files changed, 253 deletions(-)
 delete mode 100644 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c

diff --git a/drivers/crypto/allwinner/Kconfig b/drivers/crypto/allwinner/Kconfig
index 06ea0e9fe6f2..17bf9ead6ef2 100644
--- a/drivers/crypto/allwinner/Kconfig
+++ b/drivers/crypto/allwinner/Kconfig
@@ -70,14 +70,6 @@ config CRYPTO_DEV_SUN8I_CE_HASH
 	help
 	  Say y to enable support for hash algorithms.
 
-config CRYPTO_DEV_SUN8I_CE_PRNG
-	bool "Support for Allwinner Crypto Engine PRNG"
-	depends on CRYPTO_DEV_SUN8I_CE
-	select CRYPTO_RNG
-	help
-	  Select this option if you want to provide kernel-side support for
-	  the Pseudo-Random Number Generator found in the Crypto Engine.
-
 config CRYPTO_DEV_SUN8I_CE_TRNG
 	bool "Support for Allwinner Crypto Engine TRNG"
 	depends on CRYPTO_DEV_SUN8I_CE
diff --git a/drivers/crypto/allwinner/sun8i-ce/Makefile b/drivers/crypto/allwinner/sun8i-ce/Makefile
index 0842eb2d9408..ea708b427e2e 100644
--- a/drivers/crypto/allwinner/sun8i-ce/Makefile
+++ b/drivers/crypto/allwinner/sun8i-ce/Makefile
@@ -1,5 +1,4 @@
 obj-$(CONFIG_CRYPTO_DEV_SUN8I_CE) += sun8i-ce.o
 sun8i-ce-y += sun8i-ce-core.o sun8i-ce-cipher.o
 sun8i-ce-$(CONFIG_CRYPTO_DEV_SUN8I_CE_HASH) += sun8i-ce-hash.o
-sun8i-ce-$(CONFIG_CRYPTO_DEV_SUN8I_CE_PRNG) += sun8i-ce-prng.o
 sun8i-ce-$(CONFIG_CRYPTO_DEV_SUN8I_CE_TRNG) += sun8i-ce-trng.o
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
index 9f6594699835..76422fbe3ebb 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
@@ -22,7 +22,6 @@
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/reset.h>
-#include <crypto/internal/rng.h>
 #include <crypto/internal/skcipher.h>
 
 #include "sun8i-ce.h"
@@ -46,7 +45,6 @@ static const struct ce_variant ce_h3_variant = {
 		{ "mod", 50000000, 0 },
 		},
 	.esr = ESR_H3,
-	.prng = CE_ALG_PRNG,
 	.trng = CE_ID_NOTSUPP,
 };
 
@@ -63,7 +61,6 @@ static const struct ce_variant ce_h5_variant = {
 		{ "mod", 300000000, 0 },
 		},
 	.esr = ESR_H5,
-	.prng = CE_ALG_PRNG,
 	.trng = CE_ID_NOTSUPP,
 };
 
@@ -77,7 +74,6 @@ static const struct ce_variant ce_h6_variant = {
 	},
 	.cipher_t_dlen_in_bytes = true,
 	.hash_t_dlen_in_bits = true,
-	.prng_t_dlen_in_bytes = true,
 	.trng_t_dlen_in_bytes = true,
 	.ce_clks = {
 		{ "bus", 0, 200000000 },
@@ -85,7 +81,6 @@ static const struct ce_variant ce_h6_variant = {
 		{ "ram", 0, 400000000 },
 		},
 	.esr = ESR_H6,
-	.prng = CE_ALG_PRNG_V2,
 	.trng = CE_ALG_TRNG_V2,
 };
 
@@ -102,7 +97,6 @@ static const struct ce_variant ce_a64_variant = {
 		{ "mod", 300000000, 0 },
 		},
 	.esr = ESR_A64,
-	.prng = CE_ALG_PRNG,
 	.trng = CE_ID_NOTSUPP,
 };
 
@@ -120,7 +114,6 @@ static const struct ce_variant ce_d1_variant = {
 		{ "ram", 0, 400000000 },
 		},
 	.esr = ESR_D1,
-	.prng = CE_ALG_PRNG,
 	.trng = CE_ALG_TRNG,
 };
 
@@ -137,7 +130,6 @@ static const struct ce_variant ce_r40_variant = {
 		{ "mod", 300000000, 0 },
 		},
 	.esr = ESR_R40,
-	.prng = CE_ALG_PRNG,
 	.trng = CE_ID_NOTSUPP,
 };
 
@@ -560,25 +552,6 @@ static struct sun8i_ce_alg_template ce_algs[] = {
 	}
 },
 #endif
-#ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_PRNG
-{
-	.type = CRYPTO_ALG_TYPE_RNG,
-	.alg.rng = {
-		.base = {
-			.cra_name		= "stdrng",
-			.cra_driver_name	= "sun8i-ce-prng",
-			.cra_priority		= 300,
-			.cra_ctxsize		= sizeof(struct sun8i_ce_rng_tfm_ctx),
-			.cra_module		= THIS_MODULE,
-			.cra_init		= sun8i_ce_prng_init,
-			.cra_exit		= sun8i_ce_prng_exit,
-		},
-		.generate               = sun8i_ce_prng_generate,
-		.seed                   = sun8i_ce_prng_seed,
-		.seedsize               = PRNG_SEED_SIZE,
-	}
-},
-#endif
 };
 
 #ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
@@ -634,12 +607,6 @@ static int sun8i_ce_debugfs_show(struct seq_file *seq, void *v)
 			seq_printf(seq, "\tFallback due to SG numbers: %lu\n",
 				   ce_algs[i].stat_fb_maxsg);
 			break;
-		case CRYPTO_ALG_TYPE_RNG:
-			seq_printf(seq, "%s %s reqs=%lu bytes=%lu\n",
-				   ce_algs[i].alg.rng.base.cra_driver_name,
-				   ce_algs[i].alg.rng.base.cra_name,
-				   ce_algs[i].stat_req, ce_algs[i].stat_bytes);
-			break;
 		}
 	}
 #ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_TRNG
@@ -880,23 +847,6 @@ static int sun8i_ce_register_algs(struct sun8i_ce_dev *ce)
 				return err;
 			}
 			break;
-		case CRYPTO_ALG_TYPE_RNG:
-			if (ce->variant->prng == CE_ID_NOTSUPP) {
-				dev_info(ce->dev,
-					 "DEBUG: Algo of %s not supported\n",
-					 ce_algs[i].alg.rng.base.cra_name);
-				ce_algs[i].ce = NULL;
-				break;
-			}
-			dev_info(ce->dev, "Register %s\n",
-				 ce_algs[i].alg.rng.base.cra_name);
-			err = crypto_register_rng(&ce_algs[i].alg.rng);
-			if (err) {
-				dev_err(ce->dev, "Fail to register %s\n",
-					ce_algs[i].alg.rng.base.cra_name);
-				ce_algs[i].ce = NULL;
-			}
-			break;
 		default:
 			ce_algs[i].ce = NULL;
 			dev_err(ce->dev, "ERROR: tried to register an unknown algo\n");
@@ -923,11 +873,6 @@ static void sun8i_ce_unregister_algs(struct sun8i_ce_dev *ce)
 				 ce_algs[i].alg.hash.halg.base.cra_name);
 			crypto_unregister_ahash(&ce_algs[i].alg.hash);
 			break;
-		case CRYPTO_ALG_TYPE_RNG:
-			dev_info(ce->dev, "Unregister %d %s\n", i,
-				 ce_algs[i].alg.rng.base.cra_name);
-			crypto_unregister_rng(&ce_algs[i].alg.rng);
-			break;
 		}
 	}
 }
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c
deleted file mode 100644
index b3cc43ea6c8a..000000000000
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c
+++ /dev/null
@@ -1,160 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * sun8i-ce-prng.c - hardware cryptographic offloader for
- * Allwinner H3/A64/H5/H2+/H6/R40 SoC
- *
- * Copyright (C) 2015-2020 Corentin Labbe <clabbe@baylibre.com>
- *
- * This file handle the PRNG
- *
- * You could find a link for the datasheet in Documentation/arm/sunxi.rst
- */
-#include "sun8i-ce.h"
-#include <linux/dma-mapping.h>
-#include <linux/pm_runtime.h>
-#include <crypto/internal/rng.h>
-
-int sun8i_ce_prng_init(struct crypto_tfm *tfm)
-{
-	struct sun8i_ce_rng_tfm_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	memset(ctx, 0, sizeof(struct sun8i_ce_rng_tfm_ctx));
-	return 0;
-}
-
-void sun8i_ce_prng_exit(struct crypto_tfm *tfm)
-{
-	struct sun8i_ce_rng_tfm_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	kfree_sensitive(ctx->seed);
-	ctx->seed = NULL;
-	ctx->slen = 0;
-}
-
-int sun8i_ce_prng_seed(struct crypto_rng *tfm, const u8 *seed,
-		       unsigned int slen)
-{
-	struct sun8i_ce_rng_tfm_ctx *ctx = crypto_rng_ctx(tfm);
-
-	if (ctx->seed && ctx->slen != slen) {
-		kfree_sensitive(ctx->seed);
-		ctx->slen = 0;
-		ctx->seed = NULL;
-	}
-	if (!ctx->seed)
-		ctx->seed = kmalloc(slen, GFP_KERNEL | GFP_DMA);
-	if (!ctx->seed)
-		return -ENOMEM;
-
-	memcpy(ctx->seed, seed, slen);
-	ctx->slen = slen;
-
-	return 0;
-}
-
-int sun8i_ce_prng_generate(struct crypto_rng *tfm, const u8 *src,
-			   unsigned int slen, u8 *dst, unsigned int dlen)
-{
-	struct sun8i_ce_rng_tfm_ctx *ctx = crypto_rng_ctx(tfm);
-	struct rng_alg *alg = crypto_rng_alg(tfm);
-	struct sun8i_ce_alg_template *algt;
-	struct sun8i_ce_dev *ce;
-	dma_addr_t dma_iv, dma_dst;
-	int err = 0;
-	int flow = 3;
-	unsigned int todo;
-	struct sun8i_ce_flow *chan;
-	struct ce_task *cet;
-	u32 common, sym;
-	void *d;
-
-	algt = container_of(alg, struct sun8i_ce_alg_template, alg.rng);
-	ce = algt->ce;
-
-	if (ctx->slen == 0) {
-		dev_err(ce->dev, "not seeded\n");
-		return -EINVAL;
-	}
-
-	/* we want dlen + seedsize rounded up to a multiple of PRNG_DATA_SIZE */
-	todo = dlen + ctx->slen + PRNG_DATA_SIZE * 2;
-	todo -= todo % PRNG_DATA_SIZE;
-
-	d = kzalloc(todo, GFP_KERNEL | GFP_DMA);
-	if (!d) {
-		err = -ENOMEM;
-		goto err_mem;
-	}
-
-	dev_dbg(ce->dev, "%s PRNG slen=%u dlen=%u todo=%u multi=%u\n", __func__,
-		slen, dlen, todo, todo / PRNG_DATA_SIZE);
-
-#ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
-	algt->stat_req++;
-	algt->stat_bytes += todo;
-#endif
-
-	dma_iv = dma_map_single(ce->dev, ctx->seed, ctx->slen, DMA_TO_DEVICE);
-	if (dma_mapping_error(ce->dev, dma_iv)) {
-		dev_err(ce->dev, "Cannot DMA MAP IV\n");
-		err = -EFAULT;
-		goto err_iv;
-	}
-
-	dma_dst = dma_map_single(ce->dev, d, todo, DMA_FROM_DEVICE);
-	if (dma_mapping_error(ce->dev, dma_dst)) {
-		dev_err(ce->dev, "Cannot DMA MAP DST\n");
-		err = -EFAULT;
-		goto err_dst;
-	}
-
-	err = pm_runtime_resume_and_get(ce->dev);
-	if (err < 0)
-		goto err_pm;
-
-	mutex_lock(&ce->rnglock);
-	chan = &ce->chanlist[flow];
-
-	cet = &chan->tl[0];
-	memset(cet, 0, sizeof(struct ce_task));
-
-	cet->t_id = cpu_to_le32(flow);
-	common = ce->variant->prng | CE_COMM_INT;
-	cet->t_common_ctl = cpu_to_le32(common);
-
-	/* recent CE (H6) need length in bytes, in word otherwise */
-	if (ce->variant->prng_t_dlen_in_bytes)
-		cet->t_dlen = cpu_to_le32(todo);
-	else
-		cet->t_dlen = cpu_to_le32(todo / 4);
-
-	sym = PRNG_LD;
-	cet->t_sym_ctl = cpu_to_le32(sym);
-	cet->t_asym_ctl = 0;
-
-	cet->t_key = cpu_to_le32(dma_iv);
-	cet->t_iv = cpu_to_le32(dma_iv);
-
-	cet->t_dst[0].addr = cpu_to_le32(dma_dst);
-	cet->t_dst[0].len = cpu_to_le32(todo / 4);
-	ce->chanlist[flow].timeout = 2000;
-
-	err = sun8i_ce_run_task(ce, 3, "PRNG");
-	mutex_unlock(&ce->rnglock);
-
-	pm_runtime_put(ce->dev);
-
-err_pm:
-	dma_unmap_single(ce->dev, dma_dst, todo, DMA_FROM_DEVICE);
-err_dst:
-	dma_unmap_single(ce->dev, dma_iv, ctx->slen, DMA_TO_DEVICE);
-
-	if (!err) {
-		memcpy(dst, d, dlen);
-		memcpy(ctx->seed, d + dlen, ctx->slen);
-	}
-err_iv:
-	kfree_sensitive(d);
-err_mem:
-	return err;
-}
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
index a1658722d886..d8c1a372c39e 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
@@ -15,7 +15,6 @@
 #include <linux/hw_random.h>
 #include <crypto/internal/hash.h>
 #include <crypto/md5.h>
-#include <crypto/rng.h>
 #include <crypto/sha1.h>
 #include <crypto/sha2.h>
 
@@ -58,9 +57,7 @@
 #define CE_ALG_SHA384           20
 #define CE_ALG_SHA512           21
 #define CE_ALG_TRNG		48
-#define CE_ALG_PRNG		49
 #define CE_ALG_TRNG_V2		0x1c
-#define CE_ALG_PRNG_V2		0x1d
 
 /* Used in ce_variant */
 #define CE_ID_NOTSUPP		0xFF
@@ -96,10 +93,6 @@
 #define ESR_H6	4
 #define ESR_D1	5
 
-#define PRNG_DATA_SIZE (160 / 8)
-#define PRNG_SEED_SIZE DIV_ROUND_UP(175, 8)
-#define PRNG_LD BIT(17)
-
 #define CE_DIE_ID_SHIFT	16
 #define CE_DIE_ID_MASK	0x07
 
@@ -132,13 +125,10 @@ struct ce_clock {
  *				bytes or words
  * @hash_t_dlen_in_bytes:	Does the request size for hash is in
  *				bits or words
- * @prng_t_dlen_in_bytes:	Does the request size for PRNG is in
- *				bytes or words
  * @trng_t_dlen_in_bytes:	Does the request size for TRNG is in
  *				bytes or words
  * @ce_clks:	list of clocks needed by this variant
  * @esr:	The type of error register
- * @prng:	The CE_ALG_XXX value for the PRNG
  * @trng:	The CE_ALG_XXX value for the TRNG
  */
 struct ce_variant {
@@ -147,11 +137,9 @@ struct ce_variant {
 	u32 op_mode[CE_ID_OP_MAX];
 	bool cipher_t_dlen_in_bytes;
 	bool hash_t_dlen_in_bits;
-	bool prng_t_dlen_in_bytes;
 	bool trng_t_dlen_in_bytes;
 	struct ce_clock ce_clks[CE_MAX_CLOCKS];
 	int esr;
-	unsigned char prng;
 	unsigned char trng;
 };
 
@@ -301,16 +289,6 @@ struct sun8i_ce_hash_reqctx {
 	struct ahash_request fallback_req; // keep at the end
 };
 
-/*
- * struct sun8i_ce_prng_ctx - context for PRNG TFM
- * @seed:	The seed to use
- * @slen:	The size of the seed
- */
-struct sun8i_ce_rng_tfm_ctx {
-	void *seed;
-	unsigned int slen;
-};
-
 /*
  * struct sun8i_ce_alg_template - crypto_alg template
  * @type:		the CRYPTO_ALG_TYPE for this template
@@ -331,7 +309,6 @@ struct sun8i_ce_alg_template {
 	union {
 		struct skcipher_alg skcipher;
 		struct ahash_alg hash;
-		struct rng_alg rng;
 	} alg;
 	unsigned long stat_req;
 	unsigned long stat_fb;
@@ -374,11 +351,5 @@ int sun8i_ce_hash_finup(struct ahash_request *areq);
 int sun8i_ce_hash_digest(struct ahash_request *areq);
 int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq);
 
-int sun8i_ce_prng_generate(struct crypto_rng *tfm, const u8 *src,
-			   unsigned int slen, u8 *dst, unsigned int dlen);
-int sun8i_ce_prng_seed(struct crypto_rng *tfm, const u8 *seed, unsigned int slen);
-void sun8i_ce_prng_exit(struct crypto_tfm *tfm);
-int sun8i_ce_prng_init(struct crypto_tfm *tfm);
-
 int sun8i_ce_hwrng_register(struct sun8i_ce_dev *ce);
 void sun8i_ce_hwrng_unregister(struct sun8i_ce_dev *ce);

base-commit: d64a499eea6b62b5121beceed9e8a1f57b00d863
-- 
2.55.0

