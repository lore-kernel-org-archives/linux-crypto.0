Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26232D9787;
	Sun, 31 May 2026 19:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780255382; cv=none; b=e96t/fcChB7d1Q56D772aqkZv4XFPUfuPhz1P+TcqZtJ+nDz37CNXOX+HuPdlr2nDG3osU+TxM84JDAgvIQ3AyXXtoJuUbKIrvP3CD6vLzJxdtRPXgbgLRBUjOgpwOBBE/ZY6DJAD8gBDzkPWsdO6vaD5ErrIQTIOljRljHB6I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780255382; c=relaxed/simple;
	bh=9OXEHWFXi3dedFvMeMJywRaN68mE/fALy7lIctbYxjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=okZSbqJiDjcS8u52UQAhBPEbNNza8yCJikqSDMIp5w2gnnkNp8ABkRCmnUPqhH/7iAAKSZojlSdJyOikJwzclr60yt3kmPglHb4TC+VuZ0Tc6uvS5mEeiQ+6tx95uHRpZF1CM0aTjC1oaFnlqDJMs4kh1O59N7UTqfX/qGmGq3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lf1+BpJJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lf1+BpJJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 669511F00899;
	Sun, 31 May 2026 19:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780255381;
	bh=PtE9W6YDGCs/tmCEdA/v//PZCwP2DZ4Ut/SmazPBmMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lf1+BpJJetBlzxhsWVzuilb3Nd3BeVKnK7YHF21V+2KTIiS2BiqV/Rjl+9c7mw7Dh
	 cbM+dJuibiV/qBPhNudfbR9pmMK76p9I4xPwC6EaH44YjquJlAs0s56PLzggb6OTp1
	 utOLGRYxluyMk3RKikW1cnhTOaiwb1/0izvp5aVAkjVszSYlqaZ9MXFDNnDaTWbbtL
	 2JdVWOYnObNwsp08NXBoLIskUx4tWepT5/omfym72zLPk+N5V9HnZWDWV2I8J15gvB
	 A9m7hn2bLRpm83sCsQJjMmD25IEtw2xX7LFZdhnkUOnZoq5U9fZjB9u/Kh8D0F5zJ1
	 4SdpqkC0s2qlw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Mounika Botcha <mounika.botcha@amd.com>,
	Harsh Jain <h.jain@amd.com>,
	Olivia Mackall <olivia@selenic.com>,
	Michal Simek <michal.simek@amd.com>,
	linux-arm-kernel@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH 1/4] crypto: xilinx-trng - Remove crypto_rng interface
Date: Sun, 31 May 2026 12:17:35 -0700
Message-ID: <20260531191738.55843-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260531191738.55843-1-ebiggers@kernel.org>
References: <20260531191738.55843-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implementing the crypto_rng interface has no purpose, as it isn't used
in practice.  It's being removed from other drivers too.  Just remove
it.  This leaves hwrng, which is actually used.

Tagging with 'Cc stable' due to the bugs that this removes:

  - xtrng_trng_generate() sometimes returned success even when it didn't
    fill in all the bytes.

  - It was possible for xtrng_trng_generate() and
    xtrng_hwrng_trng_read() to run concurrently and interfere with each
    other, as the locking code in xtrng_hwrng_trng_read() was broken.

Fixes: 8979744aca80 ("crypto: xilinx - Add TRNG driver for Versal")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/crypto/Kconfig              |  1 -
 drivers/crypto/xilinx/xilinx-trng.c | 85 ++---------------------------
 2 files changed, 4 insertions(+), 82 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 07f0fa3341fc..26194c33cb32 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -708,11 +708,10 @@ config CRYPTO_DEV_TEGRA
 
 config CRYPTO_DEV_XILINX_TRNG
 	tristate "Support for Xilinx True Random Generator"
 	depends on ZYNQMP_FIRMWARE || COMPILE_TEST
 	select CRYPTO_DF80090A
-	select CRYPTO_RNG
 	select HW_RANDOM
 	help
 	  Xilinx Versal SoC driver provides kernel-side support for True Random Number
 	  Generator and Pseudo random Number in CTR_DRBG mode as defined in NIST SP800-90A.
 
diff --git a/drivers/crypto/xilinx/xilinx-trng.c b/drivers/crypto/xilinx/xilinx-trng.c
index 43a4832f07e7..a35643baa489 100644
--- a/drivers/crypto/xilinx/xilinx-trng.c
+++ b/drivers/crypto/xilinx/xilinx-trng.c
@@ -4,25 +4,22 @@
  * Copyright (c) 2024 - 2025 Advanced Micro Devices, Inc.
  */
 
 #include <linux/bitfield.h>
 #include <linux/clk.h>
-#include <linux/crypto.h>
 #include <linux/delay.h>
 #include <linux/firmware/xlnx-zynqmp.h>
 #include <linux/hw_random.h>
 #include <linux/io.h>
 #include <linux/iopoll.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/mutex.h>
 #include <linux/mod_devicetable.h>
 #include <linux/platform_device.h>
 #include <crypto/aes.h>
 #include <crypto/df_sp80090a.h>
 #include <crypto/internal/cipher.h>
-#include <crypto/internal/rng.h>
 
 /* TRNG Registers Offsets */
 #define TRNG_STATUS_OFFSET			0x4U
 #define TRNG_CTRL_OFFSET			0x8U
 #define TRNG_EXT_SEED_OFFSET			0x40U
@@ -58,20 +55,13 @@
 struct xilinx_rng {
 	void __iomem *rng_base;
 	struct device *dev;
 	unsigned char *scratchpadbuf;
 	struct aes_enckey *aeskey;
-	struct mutex lock;	/* Protect access to TRNG device */
 	struct hwrng trng;
 };
 
-struct xilinx_rng_ctx {
-	struct xilinx_rng *rng;
-};
-
-static struct xilinx_rng *xilinx_rng_dev;
-
 static void xtrng_readwrite32(void __iomem *addr, u32 mask, u8 value)
 {
 	u32 val;
 
 	val = ioread32(addr);
@@ -243,74 +233,25 @@ static int xtrng_random_bytes_generate(struct xilinx_rng *rng, u8 *rand_buf_ptr,
 	}
 
 	return nbytes;
 }
 
-static int xtrng_trng_generate(struct crypto_rng *tfm, const u8 *src, u32 slen,
-			       u8 *dst, u32 dlen)
-{
-	struct xilinx_rng_ctx *ctx = crypto_rng_ctx(tfm);
-	int ret;
-
-	mutex_lock(&ctx->rng->lock);
-	ret = xtrng_random_bytes_generate(ctx->rng, dst, dlen, true);
-	mutex_unlock(&ctx->rng->lock);
-
-	return ret < 0 ? ret : 0;
-}
-
-static int xtrng_trng_seed(struct crypto_rng *tfm, const u8 *seed, unsigned int slen)
-{
-	return 0;
-}
-
-static int xtrng_trng_init(struct crypto_tfm *rtfm)
-{
-	struct xilinx_rng_ctx *ctx = crypto_tfm_ctx(rtfm);
-
-	ctx->rng = xilinx_rng_dev;
-
-	return 0;
-}
-
-static struct rng_alg xtrng_trng_alg = {
-	.generate = xtrng_trng_generate,
-	.seed = xtrng_trng_seed,
-	.seedsize = 0,
-	.base = {
-		.cra_name = "stdrng",
-		.cra_driver_name = "xilinx-trng",
-		.cra_priority = 300,
-		.cra_ctxsize = sizeof(struct xilinx_rng_ctx),
-		.cra_module = THIS_MODULE,
-		.cra_init = xtrng_trng_init,
-	},
-};
-
 static int xtrng_hwrng_trng_read(struct hwrng *hwrng, void *data, size_t max, bool wait)
 {
 	u8 buf[TRNG_SEC_STRENGTH_BYTES];
 	struct xilinx_rng *rng;
 	int ret = -EINVAL, i = 0;
 
 	rng = container_of(hwrng, struct xilinx_rng, trng);
-	/* Return in case wait not set and lock not available. */
-	if (!mutex_trylock(&rng->lock) && !wait)
-		return 0;
-	else if (!mutex_is_locked(&rng->lock) && wait)
-		mutex_lock(&rng->lock);
-
 	while (i < max) {
 		ret = xtrng_random_bytes_generate(rng, buf, TRNG_SEC_STRENGTH_BYTES, wait);
 		if (ret < 0)
 			break;
 
 		memcpy(data + i, buf, min_t(int, ret, (max - i)));
 		i += min_t(int, ret, (max - i));
 	}
-	mutex_unlock(&rng->lock);
-
 	return ret;
 }
 
 static int xtrng_hwrng_register(struct hwrng *trng)
 {
@@ -352,60 +293,42 @@ static int xtrng_probe(struct platform_device *pdev)
 	if (!rng->aeskey)
 		return -ENOMEM;
 
 	sb_size = crypto_drbg_ctr_df_datalen(TRNG_SEED_LEN_BYTES, AES_BLOCK_SIZE);
 	rng->scratchpadbuf = devm_kzalloc(&pdev->dev, sb_size, GFP_KERNEL);
-	if (!rng->scratchpadbuf) {
-		ret = -ENOMEM;
-		goto end;
-	}
+	if (!rng->scratchpadbuf)
+		return -ENOMEM;
 
 	xtrng_trng_reset(rng->rng_base);
 	ret = xtrng_reseed_internal(rng);
 	if (ret) {
 		dev_err(&pdev->dev, "TRNG Seed fail\n");
-		goto end;
-	}
-
-	xilinx_rng_dev = rng;
-	mutex_init(&rng->lock);
-	ret = crypto_register_rng(&xtrng_trng_alg);
-	if (ret) {
-		dev_err(&pdev->dev, "Crypto Random device registration failed: %d\n", ret);
-		goto end;
+		return ret;
 	}
 
 	ret = xtrng_hwrng_register(&rng->trng);
 	if (ret) {
 		dev_err(&pdev->dev, "HWRNG device registration failed: %d\n", ret);
-		goto crypto_rng_free;
+		return ret;
 	}
 	platform_set_drvdata(pdev, rng);
 
 	return 0;
-
-crypto_rng_free:
-	crypto_unregister_rng(&xtrng_trng_alg);
-
-end:
-	return ret;
 }
 
 static void xtrng_remove(struct platform_device *pdev)
 {
 	struct xilinx_rng *rng;
 	u32 zero[TRNG_NUM_INIT_REGS] = { };
 
 	rng = platform_get_drvdata(pdev);
 	xtrng_hwrng_unregister(&rng->trng);
-	crypto_unregister_rng(&xtrng_trng_alg);
 	xtrng_write_multiple_registers(rng->rng_base + TRNG_EXT_SEED_OFFSET, zero,
 				       TRNG_NUM_INIT_REGS);
 	xtrng_write_multiple_registers(rng->rng_base + TRNG_PER_STRNG_OFFSET, zero,
 				       TRNG_NUM_INIT_REGS);
 	xtrng_hold_reset(rng->rng_base);
-	xilinx_rng_dev = NULL;
 }
 
 static const struct of_device_id xtrng_of_match[] = {
 	{ .compatible = "xlnx,versal-trng", },
 	{},
-- 
2.54.0

