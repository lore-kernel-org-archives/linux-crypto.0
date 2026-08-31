Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB0F396B96;
	Mon, 31 Aug 2026 20:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788208216; cv=none; b=MmlH42v34oUkL5EAYBFxo++QQoZNV7TSYH2/Xdg9kOnKZDqj8fm5BhpPYbDM2hOGB6mKii6RnsOSWGoJMbxqotZE3xn8jBxEm2fa14Iwx4o7IqH72uzcIQNREhtyVomtLeL+wPqSQqmPdPWnYez2ysv8ayJfWGTKPWv9H2uBG0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788208216; c=relaxed/simple;
	bh=6WZgFUTe62WvbxNz6qB5ZVqWRs2W1wT5mqLU8DRYqQg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ovUXc8iUIKPckyKnLaEHVh/YXHQ2HNRla6ojYjs2h9KsfRESXFy3LRvzsBM/p56kaNjWXzoOymcb+jU+Pv+aQ7xtKHdg3yUehKwFz/xMWDCVM2auR4eD2uQhp6Qf7szp24MVmYR2FhPoKueTWk07EbHvOAK18xJchR5soXnQza4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=brGVKU7p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="brGVKU7p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97DE41F000E9;
	Mon, 31 Aug 2026 20:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788208214;
	bh=rpv0GrrPu5dnZ00dUowYTnt/x0gMh9fh47S2zY1JAcE=;
	h=From:To:Cc:Subject:Date;
	b=brGVKU7pHdrMcdNmo3o2Nf/L1xEHKSNZknjs86oldjRIGIXkCPtw8JnQhHCQhCC2o
	 Sc5wY50tH3ulPxwJx9h69w0YWWbSSfO8muQ2UJQcq+9PipSTv8kV2lm3in9mHbLQzR
	 k5vtedXVZvqcjFS1mu8+sH9HATcqoDpqvEHJO7iGudWwVQUkPs+AJ64mZ6xaDq9dfR
	 14plY4X94hC/GiqkIjlPkfOhCTqpRp1CMbg/iYbha0KeuhHMd+SR8yl/bKp8QBKhZq
	 N4lgThl0bKtLSGJWRYeW0xu3K7y3Sa3hKgMcZmT2GecCMpcynHw/kr/9rpAZrsevLi
	 q0gG6gOa6ypoA==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	Corentin Labbe <clabbe.montjoie@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.15] crypto: sun8i-ss - Remove crypto_rng interface
Date: Mon, 31 Aug 2026 13:29:58 -0700
Message-ID: <20260831202958.192351-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit a78446ee6fae86ac8733f120e3ffce2e5d9384f5 upstream.

Since the crypto_rng interface for hardware PRNGs is unused and is
redundant with hwrng and the actual Linux RNG, it's being phased out.
Most drivers for it were already removed.  Go ahead and remove the
sun8i-ss support which is one of the only remaining ones.

As usual for crypto_rng, this driver was also buggy: its ->generate()
function had a use-after-free vulnerability due to using
wait_for_completion_interruptible_timeout() without handling shutting
down the DMA operation if a signal is sent.  Also, it had a buffer
overread bug in the line 'memcpy(ctx->seed, d + dlen, ctx->slen);'.
There's no point in fixing these bugs separately only to remove the code
anyway, so this commit is marked with Fixes and Cc stable.

Fixes: ac2614d721de ("crypto: sun8i-ss - Add support for the PRNG")
Cc: stable@vger.kernel.org
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/allwinner/Kconfig              |   8 -
 drivers/crypto/allwinner/sun8i-ss/Makefile    |   1 -
 .../crypto/allwinner/sun8i-ss/sun8i-ss-core.c |  39 ----
 .../crypto/allwinner/sun8i-ss/sun8i-ss-prng.c | 172 ------------------
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h  |  23 ---
 5 files changed, 243 deletions(-)
 delete mode 100644 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-prng.c

diff --git a/drivers/crypto/allwinner/Kconfig b/drivers/crypto/allwinner/Kconfig
index 17bf9ead6ef2..d86ae005fbe2 100644
--- a/drivers/crypto/allwinner/Kconfig
+++ b/drivers/crypto/allwinner/Kconfig
@@ -105,14 +105,6 @@ config CRYPTO_DEV_SUN8I_SS_DEBUG
 	  This will create /sys/kernel/debug/sun8i-ss/stats for displaying
 	  the number of requests per flow and per algorithm.
 
-config CRYPTO_DEV_SUN8I_SS_PRNG
-	bool "Support for Allwinner Security System PRNG"
-	depends on CRYPTO_DEV_SUN8I_SS
-	select CRYPTO_RNG
-	help
-	  Select this option if you want to provide kernel-side support for
-	  the Pseudo-Random Number Generator found in the Security System.
-
 config CRYPTO_DEV_SUN8I_SS_HASH
 	bool "Enable support for hash on sun8i-ss"
 	depends on CRYPTO_DEV_SUN8I_SS
diff --git a/drivers/crypto/allwinner/sun8i-ss/Makefile b/drivers/crypto/allwinner/sun8i-ss/Makefile
index aabfd893c817..2d6458a42e58 100644
--- a/drivers/crypto/allwinner/sun8i-ss/Makefile
+++ b/drivers/crypto/allwinner/sun8i-ss/Makefile
@@ -1,4 +1,3 @@
 obj-$(CONFIG_CRYPTO_DEV_SUN8I_SS) += sun8i-ss.o
 sun8i-ss-y += sun8i-ss-core.o sun8i-ss-cipher.o
-sun8i-ss-$(CONFIG_CRYPTO_DEV_SUN8I_SS_PRNG) += sun8i-ss-prng.o
 sun8i-ss-$(CONFIG_CRYPTO_DEV_SUN8I_SS_HASH) += sun8i-ss-hash.o
diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
index 47b5828e35c3..904cbaceee1b 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
@@ -22,7 +22,6 @@
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/reset.h>
-#include <crypto/internal/rng.h>
 #include <crypto/internal/skcipher.h>
 
 #include "sun8i-ss.h"
@@ -269,25 +268,6 @@ static struct sun8i_ss_alg_template ss_algs[] = {
 		.decrypt	= sun8i_ss_skdecrypt,
 	}
 },
-#ifdef CONFIG_CRYPTO_DEV_SUN8I_SS_PRNG
-{
-	.type = CRYPTO_ALG_TYPE_RNG,
-	.alg.rng = {
-		.base = {
-			.cra_name		= "stdrng",
-			.cra_driver_name	= "sun8i-ss-prng",
-			.cra_priority		= 300,
-			.cra_ctxsize = sizeof(struct sun8i_ss_rng_tfm_ctx),
-			.cra_module		= THIS_MODULE,
-			.cra_init		= sun8i_ss_prng_init,
-			.cra_exit		= sun8i_ss_prng_exit,
-		},
-		.generate               = sun8i_ss_prng_generate,
-		.seed                   = sun8i_ss_prng_seed,
-		.seedsize               = PRNG_SEED_SIZE,
-	}
-},
-#endif
 #ifdef CONFIG_CRYPTO_DEV_SUN8I_SS_HASH
 {	.type = CRYPTO_ALG_TYPE_AHASH,
 	.ss_algo_id = SS_ID_HASH_MD5,
@@ -431,12 +411,6 @@ static int sun8i_ss_debugfs_show(struct seq_file *seq, void *v)
 				   ss_algs[i].alg.skcipher.base.cra_name,
 				   ss_algs[i].stat_req, ss_algs[i].stat_fb);
 			break;
-		case CRYPTO_ALG_TYPE_RNG:
-			seq_printf(seq, "%s %s reqs=%lu tsize=%lu\n",
-				   ss_algs[i].alg.rng.base.cra_driver_name,
-				   ss_algs[i].alg.rng.base.cra_name,
-				   ss_algs[i].stat_req, ss_algs[i].stat_bytes);
-			break;
 		case CRYPTO_ALG_TYPE_AHASH:
 			seq_printf(seq, "%s %s reqs=%lu fallback=%lu\n",
 				   ss_algs[i].alg.hash.halg.base.cra_driver_name,
@@ -626,14 +600,6 @@ static int sun8i_ss_register_algs(struct sun8i_ss_dev *ss)
 				return err;
 			}
 			break;
-		case CRYPTO_ALG_TYPE_RNG:
-			err = crypto_register_rng(&ss_algs[i].alg.rng);
-			if (err) {
-				dev_err(ss->dev, "Fail to register %s\n",
-					ss_algs[i].alg.rng.base.cra_name);
-				ss_algs[i].ss = NULL;
-			}
-			break;
 		case CRYPTO_ALG_TYPE_AHASH:
 			id = ss_algs[i].ss_algo_id;
 			ss_method = ss->variant->alg_hash[id];
@@ -675,11 +641,6 @@ static void sun8i_ss_unregister_algs(struct sun8i_ss_dev *ss)
 				 ss_algs[i].alg.skcipher.base.cra_name);
 			crypto_unregister_skcipher(&ss_algs[i].alg.skcipher);
 			break;
-		case CRYPTO_ALG_TYPE_RNG:
-			dev_info(ss->dev, "Unregister %d %s\n", i,
-				 ss_algs[i].alg.rng.base.cra_name);
-			crypto_unregister_rng(&ss_algs[i].alg.rng);
-			break;
 		case CRYPTO_ALG_TYPE_AHASH:
 			dev_info(ss->dev, "Unregister %d %s\n", i,
 				 ss_algs[i].alg.hash.halg.base.cra_name);
diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-prng.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-prng.c
deleted file mode 100644
index 246a6782674c..000000000000
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-prng.c
+++ /dev/null
@@ -1,172 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * sun8i-ss-prng.c - hardware cryptographic offloader for
- * Allwinner A80/A83T SoC
- *
- * Copyright (C) 2015-2020 Corentin Labbe <clabbe@baylibre.com>
- *
- * This file handle the PRNG found in the SS
- *
- * You could find a link for the datasheet in Documentation/arm/sunxi.rst
- */
-#include "sun8i-ss.h"
-#include <linux/dma-mapping.h>
-#include <linux/pm_runtime.h>
-#include <crypto/internal/rng.h>
-
-int sun8i_ss_prng_seed(struct crypto_rng *tfm, const u8 *seed,
-		       unsigned int slen)
-{
-	struct sun8i_ss_rng_tfm_ctx *ctx = crypto_rng_ctx(tfm);
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
-int sun8i_ss_prng_init(struct crypto_tfm *tfm)
-{
-	struct sun8i_ss_rng_tfm_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	memset(ctx, 0, sizeof(struct sun8i_ss_rng_tfm_ctx));
-	return 0;
-}
-
-void sun8i_ss_prng_exit(struct crypto_tfm *tfm)
-{
-	struct sun8i_ss_rng_tfm_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	kfree_sensitive(ctx->seed);
-	ctx->seed = NULL;
-	ctx->slen = 0;
-}
-
-int sun8i_ss_prng_generate(struct crypto_rng *tfm, const u8 *src,
-			   unsigned int slen, u8 *dst, unsigned int dlen)
-{
-	struct sun8i_ss_rng_tfm_ctx *ctx = crypto_rng_ctx(tfm);
-	struct rng_alg *alg = crypto_rng_alg(tfm);
-	struct sun8i_ss_alg_template *algt;
-	struct sun8i_ss_dev *ss;
-	dma_addr_t dma_iv, dma_dst;
-	unsigned int todo;
-	int err = 0;
-	int flow;
-	void *d;
-	u32 v;
-
-	algt = container_of(alg, struct sun8i_ss_alg_template, alg.rng);
-	ss = algt->ss;
-
-	if (ctx->slen == 0) {
-		dev_err(ss->dev, "The PRNG is not seeded\n");
-		return -EINVAL;
-	}
-
-	/* The SS does not give an updated seed, so we need to get a new one.
-	 * So we will ask for an extra PRNG_SEED_SIZE data.
-	 * We want dlen + seedsize rounded up to a multiple of PRNG_DATA_SIZE
-	 */
-	todo = dlen + PRNG_SEED_SIZE + PRNG_DATA_SIZE;
-	todo -= todo % PRNG_DATA_SIZE;
-
-	d = kzalloc(todo, GFP_KERNEL | GFP_DMA);
-	if (!d)
-		return -ENOMEM;
-
-	flow = sun8i_ss_get_engine_number(ss);
-
-#ifdef CONFIG_CRYPTO_DEV_SUN8I_SS_DEBUG
-	algt->stat_req++;
-	algt->stat_bytes += todo;
-#endif
-
-	v = SS_ALG_PRNG | SS_PRNG_CONTINUE | SS_START;
-	if (flow)
-		v |= SS_FLOW1;
-	else
-		v |= SS_FLOW0;
-
-	dma_iv = dma_map_single(ss->dev, ctx->seed, ctx->slen, DMA_TO_DEVICE);
-	if (dma_mapping_error(ss->dev, dma_iv)) {
-		dev_err(ss->dev, "Cannot DMA MAP IV\n");
-		err = -EFAULT;
-		goto err_free;
-	}
-
-	dma_dst = dma_map_single(ss->dev, d, todo, DMA_FROM_DEVICE);
-	if (dma_mapping_error(ss->dev, dma_dst)) {
-		dev_err(ss->dev, "Cannot DMA MAP DST\n");
-		err = -EFAULT;
-		goto err_iv;
-	}
-
-	err = pm_runtime_get_sync(ss->dev);
-	if (err < 0) {
-		pm_runtime_put_noidle(ss->dev);
-		goto err_pm;
-	}
-	err = 0;
-
-	mutex_lock(&ss->mlock);
-	writel(dma_iv, ss->base + SS_IV_ADR_REG);
-	/* the PRNG act badly (failing rngtest) without SS_KEY_ADR_REG set */
-	writel(dma_iv, ss->base + SS_KEY_ADR_REG);
-	writel(dma_dst, ss->base + SS_DST_ADR_REG);
-	writel(todo / 4, ss->base + SS_LEN_ADR_REG);
-
-	reinit_completion(&ss->flows[flow].complete);
-	ss->flows[flow].status = 0;
-	/* Be sure all data is written before enabling the task */
-	wmb();
-
-	writel(v, ss->base + SS_CTL_REG);
-
-	wait_for_completion_interruptible_timeout(&ss->flows[flow].complete,
-						  msecs_to_jiffies(todo));
-	if (ss->flows[flow].status == 0) {
-		dev_err(ss->dev, "DMA timeout for PRNG (size=%u)\n", todo);
-		err = -EFAULT;
-	}
-	/* Since cipher and hash use the linux/cryptoengine and that we have
-	 * a cryptoengine per flow, we are sure that they will issue only one
-	 * request per flow.
-	 * Since the cryptoengine wait for completion before submitting a new
-	 * one, the mlock could be left just after the final writel.
-	 * But cryptoengine cannot handle crypto_rng, so we need to be sure
-	 * nothing will use our flow.
-	 * The easiest way is to grab mlock until the hardware end our requests.
-	 * We could have used a per flow lock, but this would increase
-	 * complexity.
-	 * The drawback is that no request could be handled for the other flow.
-	 */
-	mutex_unlock(&ss->mlock);
-
-	pm_runtime_put(ss->dev);
-
-err_pm:
-	dma_unmap_single(ss->dev, dma_dst, todo, DMA_FROM_DEVICE);
-err_iv:
-	dma_unmap_single(ss->dev, dma_iv, ctx->slen, DMA_TO_DEVICE);
-
-	if (!err) {
-		memcpy(dst, d, dlen);
-		/* Update seed */
-		memcpy(ctx->seed, d + dlen, ctx->slen);
-	}
-err_free:
-	kfree_sensitive(d);
-
-	return err;
-}
diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
index eb82ee5345ae..2beaeb94a3d6 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
@@ -8,7 +8,6 @@
 #include <crypto/aes.h>
 #include <crypto/des.h>
 #include <crypto/engine.h>
-#include <crypto/rng.h>
 #include <crypto/skcipher.h>
 #include <linux/atomic.h>
 #include <linux/debugfs.h>
@@ -27,7 +26,6 @@
 #define SS_ALG_DES		(1 << 2)
 #define SS_ALG_3DES		(2 << 2)
 #define SS_ALG_MD5		(3 << 2)
-#define SS_ALG_PRNG		(4 << 2)
 #define SS_ALG_SHA1		(6 << 2)
 #define SS_ALG_SHA224		(7 << 2)
 #define SS_ALG_SHA256		(8 << 2)
@@ -68,8 +66,6 @@
 #define SS_FLOW0	BIT(30)
 #define SS_FLOW1	BIT(31)
 
-#define SS_PRNG_CONTINUE	BIT(18)
-
 #define MAX_SG 8
 
 #define MAXFLOW 2
@@ -79,9 +75,6 @@
 #define SS_DIE_ID_SHIFT	20
 #define SS_DIE_ID_MASK	0x07
 
-#define PRNG_DATA_SIZE (160 / 8)
-#define PRNG_SEED_SIZE DIV_ROUND_UP(175, 8)
-
 /*
  * struct ss_clock - Describe clocks used by sun8i-ss
  * @name:       Name of clock needed by this variant
@@ -215,16 +208,6 @@ struct sun8i_cipher_tfm_ctx {
 	struct crypto_skcipher *fallback_tfm;
 };
 
-/*
- * struct sun8i_ss_prng_ctx - context for PRNG TFM
- * @seed:	The seed to use
- * @slen:	The size of the seed
- */
-struct sun8i_ss_rng_tfm_ctx {
-	void *seed;
-	unsigned int slen;
-};
-
 /*
  * struct sun8i_ss_hash_tfm_ctx - context for an ahash TFM
  * @enginectx:		crypto_engine used by this TFM
@@ -274,7 +257,6 @@ struct sun8i_ss_alg_template {
 	struct sun8i_ss_dev *ss;
 	union {
 		struct skcipher_alg skcipher;
-		struct rng_alg rng;
 		struct ahash_alg hash;
 	} alg;
 #ifdef CONFIG_CRYPTO_DEV_SUN8I_SS_DEBUG
@@ -298,11 +280,6 @@ int sun8i_ss_skencrypt(struct skcipher_request *areq);
 int sun8i_ss_get_engine_number(struct sun8i_ss_dev *ss);
 
 int sun8i_ss_run_task(struct sun8i_ss_dev *ss, struct sun8i_cipher_req_ctx *rctx, const char *name);
-int sun8i_ss_prng_generate(struct crypto_rng *tfm, const u8 *src,
-			   unsigned int slen, u8 *dst, unsigned int dlen);
-int sun8i_ss_prng_seed(struct crypto_rng *tfm, const u8 *seed, unsigned int slen);
-int sun8i_ss_prng_init(struct crypto_tfm *tfm);
-void sun8i_ss_prng_exit(struct crypto_tfm *tfm);
 
 int sun8i_ss_hash_crainit(struct crypto_tfm *tfm);
 void sun8i_ss_hash_craexit(struct crypto_tfm *tfm);

base-commit: 28c35638ec51efdaa30089020b2abf7608898cb3
prerequisite-patch-id: 68cfa487d2ddab6e0a4d823bac945afa5c6817df
-- 
2.55.0

