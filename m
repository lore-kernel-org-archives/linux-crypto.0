Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE3E35AC07;
	Fri, 29 May 2026 23:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780097681; cv=none; b=cnYCFO9YEP4g2eeBxfGV2HTnVFjgPUhyCnHjquS2QryHRefFgtxLS9PuvwfRL8h5pWrkxTWsr2dXh9S5EVyv6+EdmSEDhUc/NaMSvmn8ST+uSPdckOS3voGZ4b05aGekxfDiDhEXuF9xXrFKlfOgrlEmYB1YpuxjAOB4zczR2vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780097681; c=relaxed/simple;
	bh=b8Kck+xuHwWrflj4CXJK6WlvQP8VgGSpelKBTEAkHWo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=StffH/249UAfzS+uD0N+TeuetgR2SiEBnC2yoiG17phGsmR8QvQREHJziuRDYRr3pPr7u6GovWftzUd3/FDbBgncmMsaNDUMMxMWu4xTOsRqSKcN4KqEsQq7ROrY0PhX55/4Dn4CXN7gK9S9T5NfV4LyksJ5aBWa45NVRA8yoCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qm46BBSS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qm46BBSS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C5D11F00893;
	Fri, 29 May 2026 23:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780097679;
	bh=v5fZjVvIPi8DCkgOLIKe29rCtOkSMS7f2MSh2pmPCnw=;
	h=From:To:Cc:Subject:Date;
	b=Qm46BBSSjglxlGIPd4ehemTzUm94BNxqqvVNMJAu7weG6clBqZ3qzSWZEsLyaDJ51
	 a+3mq0iAR1TAkVIh5tSEGBA4QEg7RgANZcznYFyK3V+RV0p7LHSMTb0O7VRP89c9Yu
	 zghpEBtLkxBEag4Z12drDKGiDNA5Fa/u3pLsMDg2vM6e2sQPWDLREUEzyUJRwkCcKt
	 4vIZp+uU3KsBQX2v8gwh+pHofS017vbAoXfawSJw3Txo+dLtt6tZ2tVNo/O6GkVmEN
	 1rQeA6Egl6Dl2ejOe+pkXr3mcgr4vw+aUJgxJsB3ZqmPevh2lbLsaLkkGmFKpxt31z
	 P1enIaZKdcYRg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	Qunqin Zhao <zhaoqunqin@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Yinggang Gu <guyinggang@loongson.cn>,
	Lee Jones <lee@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH] crypto: loongson - Remove broken and unused loongson-rng
Date: Fri, 29 May 2026 16:32:08 -0700
Message-ID: <20260529233208.8703-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The loongson-rng rng_alg has several vulnerabilities, including not
providing forward security, and a use-after-free bug due to the use of
wait_for_completion_interruptible().

Meanwhile, the rng_alg framework doesn't really have any purpose in the
first place other than to access the software algorithms crypto/drbg.c
and crypto/jitterentropy.c.  Hardware-specific rng_algs have no
in-kernel user, and unlike hwrng there's no feed into the actual Linux
RNG.  As such, there's really no point to this code.  There are of
course other rng_alg drivers that are similarly unused, but they're
similarly in the process of being phased out, e.g.
https://lore.kernel.org/r/20260529193648.18172-1-ebiggers@kernel.org and
https://lore.kernel.org/r/20260529220430.34135-1-ebiggers@kernel.org

Given that, there's no point in fixing forward these vulnerabilities,
and it makes much more sense to simply roll back the addition of this
driver.  If this platform provides TRNG (not PRNG) functionality, it
could make sense to add a hwrng driver, but it would be quite different.

Link: https://lore.kernel.org/linux-crypto/20260525145939.GC2018@quark/
Fixes: 766b2d724c8d ("crypto: loongson - add Loongson RNG driver support")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 MAINTAINERS                                 |   1 -
 arch/loongarch/configs/loongson32_defconfig |   1 -
 arch/loongarch/configs/loongson64_defconfig |   1 -
 drivers/crypto/Kconfig                      |   1 -
 drivers/crypto/Makefile                     |   1 -
 drivers/crypto/loongson/Kconfig             |   6 -
 drivers/crypto/loongson/Makefile            |   1 -
 drivers/crypto/loongson/loongson-rng.c      | 209 --------------------
 8 files changed, 221 deletions(-)
 delete mode 100644 drivers/crypto/loongson/Kconfig
 delete mode 100644 drivers/crypto/loongson/Makefile
 delete mode 100644 drivers/crypto/loongson/loongson-rng.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 882214b0e7db..6c805560c77c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15068,11 +15068,10 @@ F:	drivers/pwm/pwm-loongson.c
 LOONGSON SECURITY ENGINE DRIVERS
 M:	Qunqin Zhao <zhaoqunqin@loongson.cn>
 L:	linux-crypto@vger.kernel.org
 S:	Maintained
 F:	drivers/char/tpm/tpm_loongson.c
-F:	drivers/crypto/loongson/
 F:	drivers/mfd/loongson-se.c
 F:	include/linux/mfd/loongson-se.h
 
 LOONGSON-2 SOC SERIES CLOCK DRIVER
 M:	Yinbo Zhu <zhuyinbo@loongson.cn>
diff --git a/arch/loongarch/configs/loongson32_defconfig b/arch/loongarch/configs/loongson32_defconfig
index d5ef396dffe3..82897236863f 100644
--- a/arch/loongarch/configs/loongson32_defconfig
+++ b/arch/loongarch/configs/loongson32_defconfig
@@ -1089,11 +1089,10 @@ CONFIG_CRYPTO_LZ4HC=m
 CONFIG_CRYPTO_USER_API_HASH=m
 CONFIG_CRYPTO_USER_API_SKCIPHER=m
 CONFIG_CRYPTO_USER_API_RNG=m
 CONFIG_CRYPTO_USER_API_AEAD=m
 CONFIG_CRYPTO_DEV_VIRTIO=m
-CONFIG_CRYPTO_DEV_LOONGSON_RNG=m
 CONFIG_DMA_CMA=y
 CONFIG_CMA_SIZE_MBYTES=0
 CONFIG_PRINTK_TIME=y
 CONFIG_STRIP_ASM_SYMS=y
 CONFIG_MAGIC_SYSRQ=y
diff --git a/arch/loongarch/configs/loongson64_defconfig b/arch/loongarch/configs/loongson64_defconfig
index cba4cdff5acd..a94e88bd7ec5 100644
--- a/arch/loongarch/configs/loongson64_defconfig
+++ b/arch/loongarch/configs/loongson64_defconfig
@@ -1122,11 +1122,10 @@ CONFIG_CRYPTO_LZ4HC=m
 CONFIG_CRYPTO_USER_API_HASH=m
 CONFIG_CRYPTO_USER_API_SKCIPHER=m
 CONFIG_CRYPTO_USER_API_RNG=m
 CONFIG_CRYPTO_USER_API_AEAD=m
 CONFIG_CRYPTO_DEV_VIRTIO=m
-CONFIG_CRYPTO_DEV_LOONGSON_RNG=m
 CONFIG_DMA_CMA=y
 CONFIG_DMA_NUMA_CMA=y
 CONFIG_CMA_SIZE_MBYTES=0
 CONFIG_PRINTK_TIME=y
 CONFIG_STRIP_ASM_SYMS=y
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 3449b3c9c6ad..075ec9432789 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -844,11 +844,10 @@ config CRYPTO_DEV_CCREE
 	  Choose this if you wish to use hardware acceleration of
 	  cryptographic operations on the system REE.
 	  If unsure say Y.
 
 source "drivers/crypto/hisilicon/Kconfig"
-source "drivers/crypto/loongson/Kconfig"
 
 source "drivers/crypto/amlogic/Kconfig"
 
 config CRYPTO_DEV_SA2UL
 	tristate "Support for TI security accelerator"
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 283bbc650b5b..ad773158ae56 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -41,11 +41,10 @@ obj-$(CONFIG_CRYPTO_DEV_VIRTIO) += virtio/
 obj-$(CONFIG_CRYPTO_DEV_BCM_SPU) += bcm/
 obj-y += inside-secure/
 obj-$(CONFIG_CRYPTO_DEV_ARTPEC6) += axis/
 obj-y += xilinx/
 obj-y += hisilicon/
-obj-y += loongson/
 obj-$(CONFIG_CRYPTO_DEV_AMLOGIC_GXL) += amlogic/
 obj-y += intel/
 obj-y += starfive/
 obj-y += cavium/
 obj-y += ti/
diff --git a/drivers/crypto/loongson/Kconfig b/drivers/crypto/loongson/Kconfig
deleted file mode 100644
index f4e1544ffbb4..000000000000
--- a/drivers/crypto/loongson/Kconfig
+++ /dev/null
@@ -1,6 +0,0 @@
-config CRYPTO_DEV_LOONGSON_RNG
-	tristate "Support for Loongson RNG Driver"
-	depends on MFD_LOONGSON_SE
-	select CRYPTO_RNG
-	help
-	  Support for Loongson RNG Driver.
diff --git a/drivers/crypto/loongson/Makefile b/drivers/crypto/loongson/Makefile
deleted file mode 100644
index 1ce5ec32b553..000000000000
--- a/drivers/crypto/loongson/Makefile
+++ /dev/null
@@ -1 +0,0 @@
-obj-$(CONFIG_CRYPTO_DEV_LOONGSON_RNG)  += loongson-rng.o
diff --git a/drivers/crypto/loongson/loongson-rng.c b/drivers/crypto/loongson/loongson-rng.c
deleted file mode 100644
index 3a4940260f9e..000000000000
--- a/drivers/crypto/loongson/loongson-rng.c
+++ /dev/null
@@ -1,209 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/* Copyright (c) 2019 HiSilicon Limited. */
-/* Copyright (c) 2025 Loongson Technology Corporation Limited. */
-
-#include <linux/crypto.h>
-#include <linux/err.h>
-#include <linux/hw_random.h>
-#include <linux/io.h>
-#include <linux/iopoll.h>
-#include <linux/kernel.h>
-#include <linux/list.h>
-#include <linux/mfd/loongson-se.h>
-#include <linux/module.h>
-#include <linux/mutex.h>
-#include <linux/platform_device.h>
-#include <linux/random.h>
-#include <crypto/internal/rng.h>
-
-#define SE_SEED_SIZE 32
-
-struct loongson_rng_list {
-	struct mutex lock;
-	struct list_head list;
-	int registered;
-};
-
-struct loongson_rng {
-	u32 used;
-	struct loongson_se_engine *engine;
-	struct list_head list;
-	struct mutex lock;
-};
-
-struct loongson_rng_ctx {
-	struct loongson_rng *rng;
-};
-
-struct loongson_rng_cmd {
-	u32 cmd_id;
-	union {
-		u32 len;
-		u32 ret;
-	} u;
-	u32 seed_off;
-	u32 out_off;
-	u32 pad[4];
-};
-
-static struct loongson_rng_list rng_devices = {
-	.lock = __MUTEX_INITIALIZER(rng_devices.lock),
-	.list = LIST_HEAD_INIT(rng_devices.list),
-};
-
-static int loongson_rng_generate(struct crypto_rng *tfm, const u8 *src,
-			  unsigned int slen, u8 *dstn, unsigned int dlen)
-{
-	struct loongson_rng_ctx *ctx = crypto_rng_ctx(tfm);
-	struct loongson_rng *rng = ctx->rng;
-	struct loongson_rng_cmd *cmd = rng->engine->command;
-	int err, len;
-
-	mutex_lock(&rng->lock);
-	cmd->seed_off = 0;
-	do {
-		len = min(dlen, rng->engine->buffer_size);
-		cmd = rng->engine->command;
-		cmd->u.len = len;
-		err = loongson_se_send_engine_cmd(rng->engine);
-		if (err)
-			break;
-
-		cmd = rng->engine->command_ret;
-		if (cmd->u.ret) {
-			err = -EIO;
-			break;
-		}
-
-		memcpy(dstn, rng->engine->data_buffer, len);
-		dlen -= len;
-		dstn += len;
-	} while (dlen > 0);
-	mutex_unlock(&rng->lock);
-
-	return err;
-}
-
-static int loongson_rng_init(struct crypto_tfm *tfm)
-{
-	struct loongson_rng_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct loongson_rng *rng;
-	u32 min_used = U32_MAX;
-
-	mutex_lock(&rng_devices.lock);
-	list_for_each_entry(rng, &rng_devices.list, list) {
-		if (rng->used < min_used) {
-			ctx->rng = rng;
-			min_used = rng->used;
-		}
-	}
-	ctx->rng->used++;
-	mutex_unlock(&rng_devices.lock);
-
-	return 0;
-}
-
-static void loongson_rng_exit(struct crypto_tfm *tfm)
-{
-	struct loongson_rng_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	mutex_lock(&rng_devices.lock);
-	ctx->rng->used--;
-	mutex_unlock(&rng_devices.lock);
-}
-
-static int loongson_rng_seed(struct crypto_rng *tfm, const u8 *seed,
-			     unsigned int slen)
-{
-	struct loongson_rng_ctx *ctx = crypto_rng_ctx(tfm);
-	struct loongson_rng *rng = ctx->rng;
-	struct loongson_rng_cmd *cmd;
-	int err;
-
-	if (slen < SE_SEED_SIZE)
-		return -EINVAL;
-
-	slen = min(slen, rng->engine->buffer_size);
-
-	mutex_lock(&rng->lock);
-	cmd = rng->engine->command;
-	cmd->u.len = slen;
-	cmd->seed_off = rng->engine->buffer_off;
-	memcpy(rng->engine->data_buffer, seed, slen);
-	err = loongson_se_send_engine_cmd(rng->engine);
-	if (err)
-		goto out;
-
-	cmd = rng->engine->command_ret;
-	if (cmd->u.ret)
-		err = -EIO;
-out:
-	mutex_unlock(&rng->lock);
-
-	return err;
-}
-
-static struct rng_alg loongson_rng_alg = {
-	.generate = loongson_rng_generate,
-	.seed =	loongson_rng_seed,
-	.seedsize = SE_SEED_SIZE,
-	.base = {
-		.cra_name = "stdrng",
-		.cra_driver_name = "loongson_stdrng",
-		.cra_priority = 300,
-		.cra_ctxsize = sizeof(struct loongson_rng_ctx),
-		.cra_module = THIS_MODULE,
-		.cra_init = loongson_rng_init,
-		.cra_exit = loongson_rng_exit,
-	},
-};
-
-static int loongson_rng_probe(struct platform_device *pdev)
-{
-	struct loongson_rng_cmd *cmd;
-	struct loongson_rng *rng;
-	int ret = 0;
-
-	rng = devm_kzalloc(&pdev->dev, sizeof(*rng), GFP_KERNEL);
-	if (!rng)
-		return -ENOMEM;
-
-	rng->engine = loongson_se_init_engine(pdev->dev.parent, SE_ENGINE_RNG);
-	if (!rng->engine)
-		return -ENODEV;
-	cmd = rng->engine->command;
-	cmd->cmd_id = SE_CMD_RNG;
-	cmd->out_off = rng->engine->buffer_off;
-	mutex_init(&rng->lock);
-
-	mutex_lock(&rng_devices.lock);
-
-	if (!rng_devices.registered) {
-		ret = crypto_register_rng(&loongson_rng_alg);
-		if (ret) {
-			dev_err(&pdev->dev, "failed to register crypto(%d)\n", ret);
-			goto out;
-		}
-		rng_devices.registered = 1;
-	}
-
-	list_add_tail(&rng->list, &rng_devices.list);
-out:
-	mutex_unlock(&rng_devices.lock);
-
-	return ret;
-}
-
-static struct platform_driver loongson_rng_driver = {
-	.probe		= loongson_rng_probe,
-	.driver		= {
-		.name	= "loongson-rng",
-	},
-};
-module_platform_driver(loongson_rng_driver);
-
-MODULE_ALIAS("platform:loongson-rng");
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Yinggang Gu <guyinggang@loongson.cn>");
-MODULE_AUTHOR("Qunqin Zhao <zhaoqunqin@loongson.cn>");
-MODULE_DESCRIPTION("Loongson Random Number Generator driver");

base-commit: 5624ea54f3ba5c83d2e5503411a31a8be0278c1e
-- 
2.54.0

