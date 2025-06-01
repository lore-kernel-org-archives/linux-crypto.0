Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8406EACE;
	Sun,  1 Jun 2025 19:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748806570; cv=none; b=cNC3x/zpbx9W7ib2HMMG7/wgnB21myeEE/4LrCMxA5rYBEvpHUxlHVzHCEOCcraB1A9zjsdSNSh1gJL96nkOUEBvrK7MTmnl7CCaO/aZLzMVQby9pCbmpwabHqUc5/G03ipHkBhf+CQRNgNLFr3dGwOS5moHsxElTU6Po5o/qO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748806570; c=relaxed/simple;
	bh=MDN4vCHcaS5qEapoDPYHjR52t6QOBz252cVmdE136Q0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=R9V/k/8Wbg8KkWU/j42v4qMw/LNmXThb72vwvniPKnycQYMC7f5pZkU4Mk1flXanEov8FnNpbqe3FWrOeU5eRaVxc89bXSsdCDP5OmoApsGw0MKUKnWE5nFLMhfO6F5MYp9y26N9j0JQQgjvWgtI1HqoKb/9qFFnu09u/Xqj5rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AANVZ8LV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AANVZ8LV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1D10C4CEE7;
	Sun,  1 Jun 2025 19:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748806570;
	bh=MDN4vCHcaS5qEapoDPYHjR52t6QOBz252cVmdE136Q0=;
	h=From:To:Cc:Subject:Date:From;
	b=AANVZ8LVd2mW+KLD0V1VwxbZq8PYlfWidE3DSQxO8oQz7bzAvW32hu/ztX55L8EMy
	 Mqv4ObQTpjXt0ARqP7/dkIWfVvS+niJTVPPmuV+0irhgvPgrwviKR0ap3aTKcqmFYA
	 xJ5gQSDwJ5jRKuHyXdzRCq8GbWDpjS5tOK0zn+xcXDV8lcRYGFNh0Ky8MDtoVAQAPO
	 Xk5Xfwtt2m9jZcb5Bc7pHskd917C0cjJzsLuyoCseGpG8NJ1Dom2F+f1v5sBRfvADB
	 i4mYg/UDgBp9UL1RXN8NPWb6JMTOaLEFYonHSF2BRq7BSV1fDuAAJoT2xTYpMk3s81
	 s0wvQYpQp9GLQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Fabien Dessenne <fabien.dessenne@foss.st.com>,
	Lionel Debieve <lionel.debieve@foss.st.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	linux-stm32@st-md-mailman.stormreply.com
Subject: [PATCH v2] crypto: stm32 - remove crc32 and crc32c support
Date: Sun,  1 Jun 2025 12:34:41 -0700
Message-ID: <20250601193441.6913-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Remove the crc32 and crc32c support from the stm32 driver.  Since it's
not wired up to the CRC library, almost no CRC user in the kernel can
actually be taking advantage of it, so it's effectively dead code.

Support for this hardware could be migrated to the CRC library, but
there doesn't seem to be much point.  This CRC engine is present only on
a couple older SoCs that lacked CRC instructions.

Even on those SoCs, it's probably not worthwhile.  This driver has to
deal with things like locking and runtime power management that do not
exist in software CRC code and are a source of bugs (as is clear from
the commit log) and add significant overhead to the processing of short
messages, which are common.  The patch that originally added this driver
seemed to justify it based purely on a microbenchmark on Cortex-M7 on
long messages, not a real use case.  These days, if this driver were to
be used at all it would likely be on Cortex-A7 instead.  This CRC engine
is also not supported by QEMU, making the driver not easily testable.

Acked-by: Ard Biesheuvel <ardb@kernel.org>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: Fabien Dessenne <fabien.dessenne@foss.st.com>
Cc: Lionel Debieve <lionel.debieve@foss.st.com>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: linux-stm32@st-md-mailman.stormreply.com
Signed-off-by: Eric Biggers <ebiggers@google.com>
---

v2: reworked commit message and added Acked-by

 arch/arm/configs/multi_v7_defconfig |   1 -
 drivers/crypto/stm32/Kconfig        |   9 -
 drivers/crypto/stm32/Makefile       |   1 -
 drivers/crypto/stm32/stm32-crc32.c  | 480 ----------------------------
 4 files changed, 491 deletions(-)
 delete mode 100644 drivers/crypto/stm32/stm32-crc32.c

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index aca01ad6aafc5..8e1c13188f3eb 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -1296,11 +1296,10 @@ CONFIG_CRYPTO_DEV_ATMEL_TDES=m
 CONFIG_CRYPTO_DEV_ATMEL_SHA=m
 CONFIG_CRYPTO_DEV_MARVELL_CESA=m
 CONFIG_CRYPTO_DEV_QCE=m
 CONFIG_CRYPTO_DEV_QCOM_RNG=m
 CONFIG_CRYPTO_DEV_ROCKCHIP=m
-CONFIG_CRYPTO_DEV_STM32_CRC=m
 CONFIG_CRYPTO_DEV_STM32_HASH=m
 CONFIG_CRYPTO_DEV_STM32_CRYP=m
 CONFIG_CMA_SIZE_MBYTES=64
 CONFIG_PRINTK_TIME=y
 CONFIG_DEBUG_KERNEL=y
diff --git a/drivers/crypto/stm32/Kconfig b/drivers/crypto/stm32/Kconfig
index 49dfd161e9b9e..d6dc848c82eee 100644
--- a/drivers/crypto/stm32/Kconfig
+++ b/drivers/crypto/stm32/Kconfig
@@ -1,15 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
-config CRYPTO_DEV_STM32_CRC
-	tristate "Support for STM32 crc accelerators"
-	depends on ARCH_STM32
-	select CRYPTO_HASH
-	select CRC32
-	help
-	  This enables support for the CRC32 hw accelerator which can be found
-	  on STMicroelectronics STM32 SOC.
-
 config CRYPTO_DEV_STM32_HASH
 	tristate "Support for STM32 hash accelerators"
 	depends on ARCH_STM32 || ARCH_U8500
 	depends on HAS_DMA
 	select CRYPTO_HASH
diff --git a/drivers/crypto/stm32/Makefile b/drivers/crypto/stm32/Makefile
index 518e0e0b11a9e..c63004026afb8 100644
--- a/drivers/crypto/stm32/Makefile
+++ b/drivers/crypto/stm32/Makefile
@@ -1,4 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0-only
-obj-$(CONFIG_CRYPTO_DEV_STM32_CRC) += stm32-crc32.o
 obj-$(CONFIG_CRYPTO_DEV_STM32_HASH) += stm32-hash.o
 obj-$(CONFIG_CRYPTO_DEV_STM32_CRYP) += stm32-cryp.o
diff --git a/drivers/crypto/stm32/stm32-crc32.c b/drivers/crypto/stm32/stm32-crc32.c
deleted file mode 100644
index fd29785a3ecf3..0000000000000
--- a/drivers/crypto/stm32/stm32-crc32.c
+++ /dev/null
@@ -1,480 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Copyright (C) STMicroelectronics SA 2017
- * Author: Fabien Dessenne <fabien.dessenne@st.com>
- */
-
-#include <linux/bitrev.h>
-#include <linux/clk.h>
-#include <linux/crc32.h>
-#include <linux/crc32poly.h>
-#include <linux/io.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/mod_devicetable.h>
-#include <linux/platform_device.h>
-#include <linux/pm_runtime.h>
-
-#include <crypto/internal/hash.h>
-
-#include <linux/unaligned.h>
-
-#define DRIVER_NAME             "stm32-crc32"
-#define CHKSUM_DIGEST_SIZE      4
-#define CHKSUM_BLOCK_SIZE       1
-
-/* Registers */
-#define CRC_DR                  0x00000000
-#define CRC_CR                  0x00000008
-#define CRC_INIT                0x00000010
-#define CRC_POL                 0x00000014
-
-/* Registers values */
-#define CRC_CR_RESET            BIT(0)
-#define CRC_CR_REV_IN_WORD      (BIT(6) | BIT(5))
-#define CRC_CR_REV_IN_BYTE      BIT(5)
-#define CRC_CR_REV_OUT          BIT(7)
-#define CRC32C_INIT_DEFAULT     0xFFFFFFFF
-
-#define CRC_AUTOSUSPEND_DELAY	50
-
-static unsigned int burst_size;
-module_param(burst_size, uint, 0644);
-MODULE_PARM_DESC(burst_size, "Select burst byte size (0 unlimited)");
-
-struct stm32_crc {
-	struct list_head list;
-	struct device    *dev;
-	void __iomem     *regs;
-	struct clk       *clk;
-	spinlock_t       lock;
-};
-
-struct stm32_crc_list {
-	struct list_head dev_list;
-	spinlock_t       lock; /* protect dev_list */
-};
-
-static struct stm32_crc_list crc_list = {
-	.dev_list = LIST_HEAD_INIT(crc_list.dev_list),
-	.lock     = __SPIN_LOCK_UNLOCKED(crc_list.lock),
-};
-
-struct stm32_crc_ctx {
-	u32 key;
-	u32 poly;
-};
-
-struct stm32_crc_desc_ctx {
-	u32    partial; /* crc32c: partial in first 4 bytes of that struct */
-};
-
-static int stm32_crc32_cra_init(struct crypto_tfm *tfm)
-{
-	struct stm32_crc_ctx *mctx = crypto_tfm_ctx(tfm);
-
-	mctx->key = 0;
-	mctx->poly = CRC32_POLY_LE;
-	return 0;
-}
-
-static int stm32_crc32c_cra_init(struct crypto_tfm *tfm)
-{
-	struct stm32_crc_ctx *mctx = crypto_tfm_ctx(tfm);
-
-	mctx->key = CRC32C_INIT_DEFAULT;
-	mctx->poly = CRC32C_POLY_LE;
-	return 0;
-}
-
-static int stm32_crc_setkey(struct crypto_shash *tfm, const u8 *key,
-			    unsigned int keylen)
-{
-	struct stm32_crc_ctx *mctx = crypto_shash_ctx(tfm);
-
-	if (keylen != sizeof(u32))
-		return -EINVAL;
-
-	mctx->key = get_unaligned_le32(key);
-	return 0;
-}
-
-static struct stm32_crc *stm32_crc_get_next_crc(void)
-{
-	struct stm32_crc *crc;
-
-	spin_lock_bh(&crc_list.lock);
-	crc = list_first_entry_or_null(&crc_list.dev_list, struct stm32_crc, list);
-	if (crc)
-		list_move_tail(&crc->list, &crc_list.dev_list);
-	spin_unlock_bh(&crc_list.lock);
-
-	return crc;
-}
-
-static int stm32_crc_init(struct shash_desc *desc)
-{
-	struct stm32_crc_desc_ctx *ctx = shash_desc_ctx(desc);
-	struct stm32_crc_ctx *mctx = crypto_shash_ctx(desc->tfm);
-	struct stm32_crc *crc;
-	unsigned long flags;
-
-	crc = stm32_crc_get_next_crc();
-	if (!crc)
-		return -ENODEV;
-
-	pm_runtime_get_sync(crc->dev);
-
-	spin_lock_irqsave(&crc->lock, flags);
-
-	/* Reset, set key, poly and configure in bit reverse mode */
-	writel_relaxed(bitrev32(mctx->key), crc->regs + CRC_INIT);
-	writel_relaxed(bitrev32(mctx->poly), crc->regs + CRC_POL);
-	writel_relaxed(CRC_CR_RESET | CRC_CR_REV_IN_WORD | CRC_CR_REV_OUT,
-		       crc->regs + CRC_CR);
-
-	/* Store partial result */
-	ctx->partial = readl_relaxed(crc->regs + CRC_DR);
-
-	spin_unlock_irqrestore(&crc->lock, flags);
-
-	pm_runtime_mark_last_busy(crc->dev);
-	pm_runtime_put_autosuspend(crc->dev);
-
-	return 0;
-}
-
-static int burst_update(struct shash_desc *desc, const u8 *d8,
-			size_t length)
-{
-	struct stm32_crc_desc_ctx *ctx = shash_desc_ctx(desc);
-	struct stm32_crc_ctx *mctx = crypto_shash_ctx(desc->tfm);
-	struct stm32_crc *crc;
-
-	crc = stm32_crc_get_next_crc();
-	if (!crc)
-		return -ENODEV;
-
-	pm_runtime_get_sync(crc->dev);
-
-	if (!spin_trylock(&crc->lock)) {
-		/* Hardware is busy, calculate crc32 by software */
-		if (mctx->poly == CRC32_POLY_LE)
-			ctx->partial = crc32_le(ctx->partial, d8, length);
-		else
-			ctx->partial = crc32c(ctx->partial, d8, length);
-
-		goto pm_out;
-	}
-
-	/*
-	 * Restore previously calculated CRC for this context as init value
-	 * Restore polynomial configuration
-	 * Configure in register for word input data,
-	 * Configure out register in reversed bit mode data.
-	 */
-	writel_relaxed(bitrev32(ctx->partial), crc->regs + CRC_INIT);
-	writel_relaxed(bitrev32(mctx->poly), crc->regs + CRC_POL);
-	writel_relaxed(CRC_CR_RESET | CRC_CR_REV_IN_WORD | CRC_CR_REV_OUT,
-		       crc->regs + CRC_CR);
-
-	if (d8 != PTR_ALIGN(d8, sizeof(u32))) {
-		/* Configure for byte data */
-		writel_relaxed(CRC_CR_REV_IN_BYTE | CRC_CR_REV_OUT,
-			       crc->regs + CRC_CR);
-		while (d8 != PTR_ALIGN(d8, sizeof(u32)) && length) {
-			writeb_relaxed(*d8++, crc->regs + CRC_DR);
-			length--;
-		}
-		/* Configure for word data */
-		writel_relaxed(CRC_CR_REV_IN_WORD | CRC_CR_REV_OUT,
-			       crc->regs + CRC_CR);
-	}
-
-	for (; length >= sizeof(u32); d8 += sizeof(u32), length -= sizeof(u32))
-		writel_relaxed(*((u32 *)d8), crc->regs + CRC_DR);
-
-	if (length) {
-		/* Configure for byte data */
-		writel_relaxed(CRC_CR_REV_IN_BYTE | CRC_CR_REV_OUT,
-			       crc->regs + CRC_CR);
-		while (length--)
-			writeb_relaxed(*d8++, crc->regs + CRC_DR);
-	}
-
-	/* Store partial result */
-	ctx->partial = readl_relaxed(crc->regs + CRC_DR);
-
-	spin_unlock(&crc->lock);
-
-pm_out:
-	pm_runtime_mark_last_busy(crc->dev);
-	pm_runtime_put_autosuspend(crc->dev);
-
-	return 0;
-}
-
-static int stm32_crc_update(struct shash_desc *desc, const u8 *d8,
-			    unsigned int length)
-{
-	const unsigned int burst_sz = burst_size;
-	unsigned int rem_sz;
-	const u8 *cur;
-	size_t size;
-	int ret;
-
-	if (!burst_sz)
-		return burst_update(desc, d8, length);
-
-	/* Digest first bytes not 32bit aligned at first pass in the loop */
-	size = min_t(size_t, length, burst_sz + (size_t)d8 -
-				     ALIGN_DOWN((size_t)d8, sizeof(u32)));
-	for (rem_sz = length, cur = d8; rem_sz;
-	     rem_sz -= size, cur += size, size = min(rem_sz, burst_sz)) {
-		ret = burst_update(desc, cur, size);
-		if (ret)
-			return ret;
-	}
-
-	return 0;
-}
-
-static int stm32_crc_final(struct shash_desc *desc, u8 *out)
-{
-	struct stm32_crc_desc_ctx *ctx = shash_desc_ctx(desc);
-	struct stm32_crc_ctx *mctx = crypto_shash_ctx(desc->tfm);
-
-	/* Send computed CRC */
-	put_unaligned_le32(mctx->poly == CRC32C_POLY_LE ?
-			   ~ctx->partial : ctx->partial, out);
-
-	return 0;
-}
-
-static int stm32_crc_finup(struct shash_desc *desc, const u8 *data,
-			   unsigned int length, u8 *out)
-{
-	return stm32_crc_update(desc, data, length) ?:
-	       stm32_crc_final(desc, out);
-}
-
-static int stm32_crc_digest(struct shash_desc *desc, const u8 *data,
-			    unsigned int length, u8 *out)
-{
-	return stm32_crc_init(desc) ?: stm32_crc_finup(desc, data, length, out);
-}
-
-static unsigned int refcnt;
-static DEFINE_MUTEX(refcnt_lock);
-static struct shash_alg algs[] = {
-	/* CRC-32 */
-	{
-		.setkey         = stm32_crc_setkey,
-		.init           = stm32_crc_init,
-		.update         = stm32_crc_update,
-		.final          = stm32_crc_final,
-		.finup          = stm32_crc_finup,
-		.digest         = stm32_crc_digest,
-		.descsize       = sizeof(struct stm32_crc_desc_ctx),
-		.digestsize     = CHKSUM_DIGEST_SIZE,
-		.base           = {
-			.cra_name               = "crc32",
-			.cra_driver_name        = "stm32-crc32-crc32",
-			.cra_priority           = 200,
-			.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
-			.cra_blocksize          = CHKSUM_BLOCK_SIZE,
-			.cra_ctxsize            = sizeof(struct stm32_crc_ctx),
-			.cra_module             = THIS_MODULE,
-			.cra_init               = stm32_crc32_cra_init,
-		}
-	},
-	/* CRC-32Castagnoli */
-	{
-		.setkey         = stm32_crc_setkey,
-		.init           = stm32_crc_init,
-		.update         = stm32_crc_update,
-		.final          = stm32_crc_final,
-		.finup          = stm32_crc_finup,
-		.digest         = stm32_crc_digest,
-		.descsize       = sizeof(struct stm32_crc_desc_ctx),
-		.digestsize     = CHKSUM_DIGEST_SIZE,
-		.base           = {
-			.cra_name               = "crc32c",
-			.cra_driver_name        = "stm32-crc32-crc32c",
-			.cra_priority           = 200,
-			.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
-			.cra_blocksize          = CHKSUM_BLOCK_SIZE,
-			.cra_ctxsize            = sizeof(struct stm32_crc_ctx),
-			.cra_module             = THIS_MODULE,
-			.cra_init               = stm32_crc32c_cra_init,
-		}
-	}
-};
-
-static int stm32_crc_probe(struct platform_device *pdev)
-{
-	struct device *dev = &pdev->dev;
-	struct stm32_crc *crc;
-	int ret;
-
-	crc = devm_kzalloc(dev, sizeof(*crc), GFP_KERNEL);
-	if (!crc)
-		return -ENOMEM;
-
-	crc->dev = dev;
-
-	crc->regs = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(crc->regs)) {
-		dev_err(dev, "Cannot map CRC IO\n");
-		return PTR_ERR(crc->regs);
-	}
-
-	crc->clk = devm_clk_get(dev, NULL);
-	if (IS_ERR(crc->clk)) {
-		dev_err(dev, "Could not get clock\n");
-		return PTR_ERR(crc->clk);
-	}
-
-	ret = clk_prepare_enable(crc->clk);
-	if (ret) {
-		dev_err(crc->dev, "Failed to enable clock\n");
-		return ret;
-	}
-
-	pm_runtime_set_autosuspend_delay(dev, CRC_AUTOSUSPEND_DELAY);
-	pm_runtime_use_autosuspend(dev);
-
-	pm_runtime_get_noresume(dev);
-	pm_runtime_set_active(dev);
-	pm_runtime_irq_safe(dev);
-	pm_runtime_enable(dev);
-
-	spin_lock_init(&crc->lock);
-
-	platform_set_drvdata(pdev, crc);
-
-	spin_lock(&crc_list.lock);
-	list_add(&crc->list, &crc_list.dev_list);
-	spin_unlock(&crc_list.lock);
-
-	mutex_lock(&refcnt_lock);
-	if (!refcnt) {
-		ret = crypto_register_shashes(algs, ARRAY_SIZE(algs));
-		if (ret) {
-			mutex_unlock(&refcnt_lock);
-			dev_err(dev, "Failed to register\n");
-			clk_disable_unprepare(crc->clk);
-			return ret;
-		}
-	}
-	refcnt++;
-	mutex_unlock(&refcnt_lock);
-
-	dev_info(dev, "Initialized\n");
-
-	pm_runtime_put_sync(dev);
-
-	return 0;
-}
-
-static void stm32_crc_remove(struct platform_device *pdev)
-{
-	struct stm32_crc *crc = platform_get_drvdata(pdev);
-	int ret = pm_runtime_get_sync(crc->dev);
-
-	spin_lock(&crc_list.lock);
-	list_del(&crc->list);
-	spin_unlock(&crc_list.lock);
-
-	mutex_lock(&refcnt_lock);
-	if (!--refcnt)
-		crypto_unregister_shashes(algs, ARRAY_SIZE(algs));
-	mutex_unlock(&refcnt_lock);
-
-	pm_runtime_disable(crc->dev);
-	pm_runtime_put_noidle(crc->dev);
-
-	if (ret >= 0)
-		clk_disable(crc->clk);
-	clk_unprepare(crc->clk);
-}
-
-static int __maybe_unused stm32_crc_suspend(struct device *dev)
-{
-	struct stm32_crc *crc = dev_get_drvdata(dev);
-	int ret;
-
-	ret = pm_runtime_force_suspend(dev);
-	if (ret)
-		return ret;
-
-	clk_unprepare(crc->clk);
-
-	return 0;
-}
-
-static int __maybe_unused stm32_crc_resume(struct device *dev)
-{
-	struct stm32_crc *crc = dev_get_drvdata(dev);
-	int ret;
-
-	ret = clk_prepare(crc->clk);
-	if (ret) {
-		dev_err(crc->dev, "Failed to prepare clock\n");
-		return ret;
-	}
-
-	return pm_runtime_force_resume(dev);
-}
-
-static int __maybe_unused stm32_crc_runtime_suspend(struct device *dev)
-{
-	struct stm32_crc *crc = dev_get_drvdata(dev);
-
-	clk_disable(crc->clk);
-
-	return 0;
-}
-
-static int __maybe_unused stm32_crc_runtime_resume(struct device *dev)
-{
-	struct stm32_crc *crc = dev_get_drvdata(dev);
-	int ret;
-
-	ret = clk_enable(crc->clk);
-	if (ret) {
-		dev_err(crc->dev, "Failed to enable clock\n");
-		return ret;
-	}
-
-	return 0;
-}
-
-static const struct dev_pm_ops stm32_crc_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(stm32_crc_suspend,
-				stm32_crc_resume)
-	SET_RUNTIME_PM_OPS(stm32_crc_runtime_suspend,
-			   stm32_crc_runtime_resume, NULL)
-};
-
-static const struct of_device_id stm32_dt_ids[] = {
-	{ .compatible = "st,stm32f7-crc", },
-	{},
-};
-MODULE_DEVICE_TABLE(of, stm32_dt_ids);
-
-static struct platform_driver stm32_crc_driver = {
-	.probe  = stm32_crc_probe,
-	.remove = stm32_crc_remove,
-	.driver = {
-		.name           = DRIVER_NAME,
-		.pm		= &stm32_crc_pm_ops,
-		.of_match_table = stm32_dt_ids,
-	},
-};
-
-module_platform_driver(stm32_crc_driver);
-
-MODULE_AUTHOR("Fabien Dessenne <fabien.dessenne@st.com>");
-MODULE_DESCRIPTION("STMicrolectronics STM32 CRC32 hardware driver");
-MODULE_LICENSE("GPL");

base-commit: bb1556ec94647060c6b52bf434b9fd824724a6f4
-- 
2.49.0

