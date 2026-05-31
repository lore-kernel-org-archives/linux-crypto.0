Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA15B2FF65F;
	Sun, 31 May 2026 18:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780250551; cv=none; b=rWiD5Nv/T1D9xXKv3IYYq+EGCWc5h6kqD3dVyossmBRyJgg4iAmXhfYy3mU8Gw0zzK0LqGE8bMmDoiAf4iRkNbWNXD5cStvYNDRtJmjskx/rUiiVtbjLwuvlwQ0ZKeBFXBSDtm0dCQ0xD4wog2mXBekC5Ff808KRQBGL5KfEYt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780250551; c=relaxed/simple;
	bh=LGDjurLHVCTZNj5V7RYeNDTQ7jxHF+5FdGFel3Y7EO4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=UfqlzxKnOsx1dnWrwcKupGAb/8iXKp7gUFzYthVJVdrjntS/Hag6wRcLWgTHbKmGwRhkhupM7cRRZL9yGOVLvB1L7RHVcBpwlV5DOJI/ONk0hDJ8kVzr51pE514lufQGo6vb7em18AO8pDtCzaooF5UMDjmy6eiLfCEgEavEnPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e0tyehKm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e0tyehKm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 478BE1F00893;
	Sun, 31 May 2026 18:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780250549;
	bh=py3KDNOf9FXC1vbSVOWH9fMcheDEX0Fm5RuaBp+oAwI=;
	h=From:To:Cc:Subject:Date;
	b=e0tyehKmHeTBqGR+tRURjIkKf6AZ0PsgjIM3c0xiUXnKOqCV734DbDw7i8iWF+EbG
	 +OzKt+PwDbRIAERKILn7VA1IQeaQdnyqRRf5Et73v1+zGahX6JZvdEvtvnZvd+TOG3
	 o6tnK0JsLBzz1L0WOf24fBoJr5m0z3nAeAdR3/wXTUtQic9omfkty1px6K2cepXALZ
	 uFhY7V3gx5GjiQbvoTUnmol4ypgE1Uo+sBh0M00820fJVFuqmvujpPUm30xDAr+nYb
	 ForOt6ia8joq7xg46WeIxraqtoWFomd5moqu/y/Klo2IHMRnZlYNZP0E2R9wueqSIO
	 HRx8ztJuqVdzw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-samsung-soc@vger.kernel.org,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] crypto: exynos-rng - Remove exynos-rng driver
Date: Sun, 31 May 2026 10:59:31 -0700
Message-ID: <20260531175932.32171-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This driver has no purpose.  It doesn't feed into the Linux RNG, nor
does it implement the hwrng interface.  It is accessible only via the
"rng" algorithm type of AF_ALG, which isn't used in practice.  Everyone
uses either the Linux RNG, or rarely /dev/hwrng.

Moreover, this is a PRNG whose only source of entropy is the 160-bit
seed the user passes in.  So this can be used only by a user who already
has a source of cryptographically secure random numbers, such as
/dev/random.  Which they can, and do, just use in the first place.

Just remove this driver.  There's no need to keep useless code around.

Note that the other crypto_rng drivers in drivers/crypto/ are similarly
unused and are being removed too.  This commit just handles exynos-rng.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 MAINTAINERS                         |   8 -
 arch/arm/configs/exynos_defconfig   |   1 -
 arch/arm/configs/multi_v7_defconfig |   1 -
 drivers/crypto/Kconfig              |  18 --
 drivers/crypto/Makefile             |   1 -
 drivers/crypto/exynos-rng.c         | 399 ----------------------------
 6 files changed, 428 deletions(-)
 delete mode 100644 drivers/crypto/exynos-rng.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 882214b0e7db..a7f2762baac1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -23701,18 +23701,10 @@ L:	linux-samsung-soc@vger.kernel.org
 S:	Supported
 F:	Documentation/devicetree/bindings/mailbox/google,gs101-mbox.yaml
 F:	drivers/mailbox/exynos-mailbox.c
 F:	include/linux/mailbox/exynos-message.h
 
-SAMSUNG EXYNOS PSEUDO RANDOM NUMBER GENERATOR (RNG) DRIVER
-M:	Krzysztof Kozlowski <krzk@kernel.org>
-L:	linux-crypto@vger.kernel.org
-L:	linux-samsung-soc@vger.kernel.org
-S:	Maintained
-F:	Documentation/devicetree/bindings/rng/samsung,exynos4-rng.yaml
-F:	drivers/crypto/exynos-rng.c
-
 SAMSUNG EXYNOS TRUE RANDOM NUMBER GENERATOR (TRNG) DRIVER
 M:	Łukasz Stelmach <l.stelmach@samsung.com>
 L:	linux-samsung-soc@vger.kernel.org
 S:	Maintained
 F:	Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.yaml
diff --git a/arch/arm/configs/exynos_defconfig b/arch/arm/configs/exynos_defconfig
index 84070e9698e8..8b072a5c0a5e 100644
--- a/arch/arm/configs/exynos_defconfig
+++ b/arch/arm/configs/exynos_defconfig
@@ -362,11 +362,10 @@ CONFIG_CRYPTO_LZ4=m
 CONFIG_CRYPTO_USER_API_HASH=m
 CONFIG_CRYPTO_USER_API_SKCIPHER=m
 CONFIG_CRYPTO_USER_API_RNG=m
 CONFIG_CRYPTO_USER_API_AEAD=m
 CONFIG_CRYPTO_AES_ARM_BS=m
-CONFIG_CRYPTO_DEV_EXYNOS_RNG=y
 CONFIG_CRYPTO_DEV_S5P=y
 CONFIG_DMA_CMA=y
 CONFIG_CMA_SIZE_MBYTES=96
 CONFIG_FONTS=y
 CONFIG_FONT_7x14=y
diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index bcc9aabc1202..3672dd12df60 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -1327,11 +1327,10 @@ CONFIG_CRYPTO_GHASH_ARM_CE=m
 CONFIG_CRYPTO_AES=m
 CONFIG_CRYPTO_AES_ARM_BS=m
 CONFIG_CRYPTO_AES_ARM_CE=m
 CONFIG_CRYPTO_DEV_SUN4I_SS=m
 CONFIG_CRYPTO_DEV_FSL_CAAM=m
-CONFIG_CRYPTO_DEV_EXYNOS_RNG=m
 CONFIG_CRYPTO_DEV_S5P=m
 CONFIG_CRYPTO_DEV_ATMEL_AES=m
 CONFIG_CRYPTO_DEV_ATMEL_TDES=m
 CONFIG_CRYPTO_DEV_ATMEL_SHA=m
 CONFIG_CRYPTO_DEV_MARVELL_CESA=m
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 3449b3c9c6ad..39c7b195bb33 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -373,25 +373,10 @@ config CRYPTO_DEV_SAHARA
 	select CRYPTO_ENGINE
 	help
 	  This option enables support for the SAHARA HW crypto accelerator
 	  found in some Freescale i.MX chips.
 
-config CRYPTO_DEV_EXYNOS_RNG
-	tristate "Exynos HW pseudo random number generator support"
-	depends on ARCH_EXYNOS || COMPILE_TEST
-	depends on HAS_IOMEM
-	select CRYPTO_RNG
-	help
-	  This driver provides kernel-side support through the
-	  cryptographic API for the pseudo random number generator hardware
-	  found on Exynos SoCs.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called exynos-rng.
-
-	  If unsure, say Y.
-
 config CRYPTO_DEV_S5P
 	tristate "Support for Samsung S5PV210/Exynos crypto accelerator"
 	depends on ARCH_S5PV210 || ARCH_EXYNOS || COMPILE_TEST
 	depends on HAS_IOMEM
 	select CRYPTO_AES
@@ -402,20 +387,17 @@ config CRYPTO_DEV_S5P
 	  algorithms execution.
 
 config CRYPTO_DEV_EXYNOS_HASH
 	bool "Support for Samsung Exynos HASH accelerator"
 	depends on CRYPTO_DEV_S5P
-	depends on !CRYPTO_DEV_EXYNOS_RNG && CRYPTO_DEV_EXYNOS_RNG!=m
 	select CRYPTO_SHA1
 	select CRYPTO_MD5
 	select CRYPTO_SHA256
 	help
 	  Select this to offload Exynos from HASH MD5/SHA1/SHA256.
 	  This will select software SHA1, MD5 and SHA256 as they are
 	  needed for small and zero-size messages.
-	  HASH algorithms will be disabled if EXYNOS_RNG
-	  is enabled due to hw conflict.
 
 config CRYPTO_DEV_NX
 	bool "Support for IBM PowerPC Nest (NX) cryptographic acceleration"
 	depends on PPC64
 	help
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 283bbc650b5b..e141ab0dd741 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -9,11 +9,10 @@ obj-$(CONFIG_CRYPTO_DEV_ATMEL_I2C) += atmel-i2c.o
 obj-$(CONFIG_CRYPTO_DEV_ATMEL_ECC) += atmel-ecc.o
 obj-$(CONFIG_CRYPTO_DEV_ATMEL_SHA204A) += atmel-sha204a.o
 obj-$(CONFIG_CRYPTO_DEV_CCP) += ccp/
 obj-$(CONFIG_CRYPTO_DEV_CCREE) += ccree/
 obj-$(CONFIG_CRYPTO_DEV_CHELSIO) += chelsio/
-obj-$(CONFIG_CRYPTO_DEV_EXYNOS_RNG) += exynos-rng.o
 obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM_COMMON) += caam/
 obj-$(CONFIG_CRYPTO_DEV_GEODE) += geode-aes.o
 obj-$(CONFIG_CRYPTO_DEV_HIFN_795X) += hifn_795x.o
 obj-$(CONFIG_CRYPTO_DEV_IMGTEC_HASH) += img-hash.o
 obj-$(CONFIG_CRYPTO_DEV_MARVELL) += marvell/
diff --git a/drivers/crypto/exynos-rng.c b/drivers/crypto/exynos-rng.c
deleted file mode 100644
index 2aaa98f9b44e..000000000000
--- a/drivers/crypto/exynos-rng.c
+++ /dev/null
@@ -1,399 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * exynos-rng.c - Random Number Generator driver for the Exynos
- *
- * Copyright (c) 2017 Krzysztof Kozlowski <krzk@kernel.org>
- *
- * Loosely based on old driver from drivers/char/hw_random/exynos-rng.c:
- * Copyright (C) 2012 Samsung Electronics
- * Jonghwa Lee <jonghwa3.lee@samsung.com>
- */
-
-#include <linux/clk.h>
-#include <linux/crypto.h>
-#include <linux/err.h>
-#include <linux/io.h>
-#include <linux/module.h>
-#include <linux/mutex.h>
-#include <linux/of.h>
-#include <linux/platform_device.h>
-
-#include <crypto/internal/rng.h>
-
-#define EXYNOS_RNG_CONTROL		0x0
-#define EXYNOS_RNG_STATUS		0x10
-
-#define EXYNOS_RNG_SEED_CONF		0x14
-#define EXYNOS_RNG_GEN_PRNG	        BIT(1)
-
-#define EXYNOS_RNG_SEED_BASE		0x140
-#define EXYNOS_RNG_SEED(n)		(EXYNOS_RNG_SEED_BASE + (n * 0x4))
-#define EXYNOS_RNG_OUT_BASE		0x160
-#define EXYNOS_RNG_OUT(n)		(EXYNOS_RNG_OUT_BASE + (n * 0x4))
-
-/* EXYNOS_RNG_CONTROL bit fields */
-#define EXYNOS_RNG_CONTROL_START	0x18
-/* EXYNOS_RNG_STATUS bit fields */
-#define EXYNOS_RNG_STATUS_SEED_SETTING_DONE	BIT(1)
-#define EXYNOS_RNG_STATUS_RNG_DONE		BIT(5)
-
-/* Five seed and output registers, each 4 bytes */
-#define EXYNOS_RNG_SEED_REGS		5
-#define EXYNOS_RNG_SEED_SIZE		(EXYNOS_RNG_SEED_REGS * 4)
-
-enum exynos_prng_type {
-	EXYNOS_PRNG_UNKNOWN = 0,
-	EXYNOS_PRNG_EXYNOS4,
-	EXYNOS_PRNG_EXYNOS5,
-};
-
-/*
- * Driver re-seeds itself with generated random numbers to hinder
- * backtracking of the original seed.
- *
- * Time for next re-seed in ms.
- */
-#define EXYNOS_RNG_RESEED_TIME		1000
-#define EXYNOS_RNG_RESEED_BYTES		65536
-
-/*
- * In polling mode, do not wait infinitely for the engine to finish the work.
- */
-#define EXYNOS_RNG_WAIT_RETRIES		100
-
-/* Context for crypto */
-struct exynos_rng_ctx {
-	struct exynos_rng_dev		*rng;
-};
-
-/* Device associated memory */
-struct exynos_rng_dev {
-	struct device			*dev;
-	enum exynos_prng_type		type;
-	void __iomem			*mem;
-	struct clk			*clk;
-	struct mutex 			lock;
-	/* Generated numbers stored for seeding during resume */
-	u8				seed_save[EXYNOS_RNG_SEED_SIZE];
-	unsigned int			seed_save_len;
-	/* Time of last seeding in jiffies */
-	unsigned long			last_seeding;
-	/* Bytes generated since last seeding */
-	unsigned long			bytes_seeding;
-};
-
-static struct exynos_rng_dev *exynos_rng_dev;
-
-static u32 exynos_rng_readl(struct exynos_rng_dev *rng, u32 offset)
-{
-	return readl_relaxed(rng->mem + offset);
-}
-
-static void exynos_rng_writel(struct exynos_rng_dev *rng, u32 val, u32 offset)
-{
-	writel_relaxed(val, rng->mem + offset);
-}
-
-static int exynos_rng_set_seed(struct exynos_rng_dev *rng,
-			       const u8 *seed, unsigned int slen)
-{
-	u32 val;
-	int i;
-
-	/* Round seed length because loop iterates over full register size */
-	slen = ALIGN_DOWN(slen, 4);
-
-	if (slen < EXYNOS_RNG_SEED_SIZE)
-		return -EINVAL;
-
-	for (i = 0; i < slen ; i += 4) {
-		unsigned int seed_reg = (i / 4) % EXYNOS_RNG_SEED_REGS;
-
-		val = seed[i] << 24;
-		val |= seed[i + 1] << 16;
-		val |= seed[i + 2] << 8;
-		val |= seed[i + 3] << 0;
-
-		exynos_rng_writel(rng, val, EXYNOS_RNG_SEED(seed_reg));
-	}
-
-	val = exynos_rng_readl(rng, EXYNOS_RNG_STATUS);
-	if (!(val & EXYNOS_RNG_STATUS_SEED_SETTING_DONE)) {
-		dev_warn(rng->dev, "Seed setting not finished\n");
-		return -EIO;
-	}
-
-	rng->last_seeding = jiffies;
-	rng->bytes_seeding = 0;
-
-	return 0;
-}
-
-/*
- * Start the engine and poll for finish.  Then read from output registers
- * filling the 'dst' buffer up to 'dlen' bytes or up to size of generated
- * random data (EXYNOS_RNG_SEED_SIZE).
- *
- * On success: return 0 and store number of read bytes under 'read' address.
- * On error: return -ERRNO.
- */
-static int exynos_rng_get_random(struct exynos_rng_dev *rng,
-				 u8 *dst, unsigned int dlen,
-				 unsigned int *read)
-{
-	int retry = EXYNOS_RNG_WAIT_RETRIES;
-
-	if (rng->type == EXYNOS_PRNG_EXYNOS4) {
-		exynos_rng_writel(rng, EXYNOS_RNG_CONTROL_START,
-				  EXYNOS_RNG_CONTROL);
-	} else if (rng->type == EXYNOS_PRNG_EXYNOS5) {
-		exynos_rng_writel(rng, EXYNOS_RNG_GEN_PRNG,
-				  EXYNOS_RNG_SEED_CONF);
-	}
-
-	while (!(exynos_rng_readl(rng,
-			EXYNOS_RNG_STATUS) & EXYNOS_RNG_STATUS_RNG_DONE) && --retry)
-		cpu_relax();
-
-	if (!retry)
-		return -ETIMEDOUT;
-
-	/* Clear status bit */
-	exynos_rng_writel(rng, EXYNOS_RNG_STATUS_RNG_DONE,
-			  EXYNOS_RNG_STATUS);
-	*read = min_t(size_t, dlen, EXYNOS_RNG_SEED_SIZE);
-	memcpy_fromio(dst, rng->mem + EXYNOS_RNG_OUT_BASE, *read);
-	rng->bytes_seeding += *read;
-
-	return 0;
-}
-
-/* Re-seed itself from time to time */
-static void exynos_rng_reseed(struct exynos_rng_dev *rng)
-{
-	unsigned long next_seeding = rng->last_seeding + \
-				     msecs_to_jiffies(EXYNOS_RNG_RESEED_TIME);
-	unsigned long now = jiffies;
-	unsigned int read = 0;
-	u8 seed[EXYNOS_RNG_SEED_SIZE];
-
-	if (time_before(now, next_seeding) &&
-	    rng->bytes_seeding < EXYNOS_RNG_RESEED_BYTES)
-		return;
-
-	if (exynos_rng_get_random(rng, seed, sizeof(seed), &read))
-		return;
-
-	exynos_rng_set_seed(rng, seed, read);
-
-	/* Let others do some of their job. */
-	mutex_unlock(&rng->lock);
-	mutex_lock(&rng->lock);
-}
-
-static int exynos_rng_generate(struct crypto_rng *tfm,
-			       const u8 *src, unsigned int slen,
-			       u8 *dst, unsigned int dlen)
-{
-	struct exynos_rng_ctx *ctx = crypto_rng_ctx(tfm);
-	struct exynos_rng_dev *rng = ctx->rng;
-	unsigned int read = 0;
-	int ret;
-
-	ret = clk_prepare_enable(rng->clk);
-	if (ret)
-		return ret;
-
-	mutex_lock(&rng->lock);
-	do {
-		ret = exynos_rng_get_random(rng, dst, dlen, &read);
-		if (ret)
-			break;
-
-		dlen -= read;
-		dst += read;
-
-		exynos_rng_reseed(rng);
-	} while (dlen > 0);
-	mutex_unlock(&rng->lock);
-
-	clk_disable_unprepare(rng->clk);
-
-	return ret;
-}
-
-static int exynos_rng_seed(struct crypto_rng *tfm, const u8 *seed,
-			   unsigned int slen)
-{
-	struct exynos_rng_ctx *ctx = crypto_rng_ctx(tfm);
-	struct exynos_rng_dev *rng = ctx->rng;
-	int ret;
-
-	ret = clk_prepare_enable(rng->clk);
-	if (ret)
-		return ret;
-
-	mutex_lock(&rng->lock);
-	ret = exynos_rng_set_seed(ctx->rng, seed, slen);
-	mutex_unlock(&rng->lock);
-
-	clk_disable_unprepare(rng->clk);
-
-	return ret;
-}
-
-static int exynos_rng_kcapi_init(struct crypto_tfm *tfm)
-{
-	struct exynos_rng_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	ctx->rng = exynos_rng_dev;
-
-	return 0;
-}
-
-static struct rng_alg exynos_rng_alg = {
-	.generate		= exynos_rng_generate,
-	.seed			= exynos_rng_seed,
-	.seedsize		= EXYNOS_RNG_SEED_SIZE,
-	.base			= {
-		.cra_name		= "stdrng",
-		.cra_driver_name	= "exynos_rng",
-		.cra_priority		= 300,
-		.cra_ctxsize		= sizeof(struct exynos_rng_ctx),
-		.cra_module		= THIS_MODULE,
-		.cra_init		= exynos_rng_kcapi_init,
-	}
-};
-
-static int exynos_rng_probe(struct platform_device *pdev)
-{
-	struct exynos_rng_dev *rng;
-	int ret;
-
-	if (exynos_rng_dev)
-		return -EEXIST;
-
-	rng = devm_kzalloc(&pdev->dev, sizeof(*rng), GFP_KERNEL);
-	if (!rng)
-		return -ENOMEM;
-
-	rng->type = (uintptr_t)of_device_get_match_data(&pdev->dev);
-
-	mutex_init(&rng->lock);
-
-	rng->dev = &pdev->dev;
-	rng->clk = devm_clk_get(&pdev->dev, "secss");
-	if (IS_ERR(rng->clk)) {
-		dev_err(&pdev->dev, "Couldn't get clock.\n");
-		return PTR_ERR(rng->clk);
-	}
-
-	rng->mem = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(rng->mem))
-		return PTR_ERR(rng->mem);
-
-	platform_set_drvdata(pdev, rng);
-
-	exynos_rng_dev = rng;
-
-	ret = crypto_register_rng(&exynos_rng_alg);
-	if (ret) {
-		dev_err(&pdev->dev,
-			"Couldn't register rng crypto alg: %d\n", ret);
-		exynos_rng_dev = NULL;
-	}
-
-	return ret;
-}
-
-static void exynos_rng_remove(struct platform_device *pdev)
-{
-	crypto_unregister_rng(&exynos_rng_alg);
-
-	exynos_rng_dev = NULL;
-}
-
-static int __maybe_unused exynos_rng_suspend(struct device *dev)
-{
-	struct exynos_rng_dev *rng = dev_get_drvdata(dev);
-	int ret;
-
-	/* If we were never seeded then after resume it will be the same */
-	if (!rng->last_seeding)
-		return 0;
-
-	rng->seed_save_len = 0;
-	ret = clk_prepare_enable(rng->clk);
-	if (ret)
-		return ret;
-
-	mutex_lock(&rng->lock);
-
-	/* Get new random numbers and store them for seeding on resume. */
-	exynos_rng_get_random(rng, rng->seed_save, sizeof(rng->seed_save),
-			      &(rng->seed_save_len));
-
-	mutex_unlock(&rng->lock);
-
-	dev_dbg(rng->dev, "Stored %u bytes for seeding on system resume\n",
-		rng->seed_save_len);
-
-	clk_disable_unprepare(rng->clk);
-
-	return 0;
-}
-
-static int __maybe_unused exynos_rng_resume(struct device *dev)
-{
-	struct exynos_rng_dev *rng = dev_get_drvdata(dev);
-	int ret;
-
-	/* Never seeded so nothing to do */
-	if (!rng->last_seeding)
-		return 0;
-
-	ret = clk_prepare_enable(rng->clk);
-	if (ret)
-		return ret;
-
-	mutex_lock(&rng->lock);
-
-	ret = exynos_rng_set_seed(rng, rng->seed_save, rng->seed_save_len);
-
-	mutex_unlock(&rng->lock);
-
-	clk_disable_unprepare(rng->clk);
-
-	return ret;
-}
-
-static SIMPLE_DEV_PM_OPS(exynos_rng_pm_ops, exynos_rng_suspend,
-			 exynos_rng_resume);
-
-static const struct of_device_id exynos_rng_dt_match[] = {
-	{
-		.compatible = "samsung,exynos4-rng",
-		.data = (const void *)EXYNOS_PRNG_EXYNOS4,
-	}, {
-		.compatible = "samsung,exynos5250-prng",
-		.data = (const void *)EXYNOS_PRNG_EXYNOS5,
-	},
-	{ },
-};
-MODULE_DEVICE_TABLE(of, exynos_rng_dt_match);
-
-static struct platform_driver exynos_rng_driver = {
-	.driver		= {
-		.name	= "exynos-rng",
-		.pm	= &exynos_rng_pm_ops,
-		.of_match_table = exynos_rng_dt_match,
-	},
-	.probe		= exynos_rng_probe,
-	.remove		= exynos_rng_remove,
-};
-
-module_platform_driver(exynos_rng_driver);
-
-MODULE_DESCRIPTION("Exynos H/W Random Number Generator driver");
-MODULE_AUTHOR("Krzysztof Kozlowski <krzk@kernel.org>");
-MODULE_LICENSE("GPL v2");

base-commit: 5624ea54f3ba5c83d2e5503411a31a8be0278c1e
-- 
2.54.0

