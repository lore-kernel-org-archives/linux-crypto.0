Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0B313211E;
	Thu, 30 May 2024 12:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.23.248
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717071925; cv=none; b=Qith9XRSOdryvPgmkSbIqfHhpRHhpgWQejzHPUzTiXkT4NmyCvTKSOmkGio37i/MSK1oIMik51ZHb8W1Btrahlc2DcKf9xaw2QgcP5k2CLOimv8dCPh2w/WRc2+Dq84y8QPOCroQ7kK2FENBrx61CmoW7oD90RpiSmexOxv05Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717071925; c=relaxed/simple;
	bh=c9OZF6gwLe1ONPPFCAYO4TW8gF1/XJQrbjh5NzlI0lA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dUm/GWuXd1CxYtCavIeKrvL21y/Dazv4qXcaY5pi0Qrp6KXoV8o2j46mJ+2Oo/j9g51FPKnelWlhrq6yub6Q/y8e3kBafsrqJMHSYtrBZ/91uh0DYnV7h8w/K9IO1MulpKxrzZVG5GNyT/i4GLwUeNjIFrDyScvIqu1jhbO6jsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=FUyWd3oa; arc=none smtp.client-ip=198.47.23.248
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="FUyWd3oa"
Received: from lelv0265.itg.ti.com ([10.180.67.224])
	by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 44UCOq6U097845;
	Thu, 30 May 2024 07:24:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1717071892;
	bh=2lNFQzYM7+sgc6vlQIM/TN4kEerFm7atv8+bl0DccJM=;
	h=From:To:CC:Subject:Date:In-Reply-To:References;
	b=FUyWd3oa/nhh3Z75BqNNvBQEMQe63DYheI9RDjzHBLx2lpxfzG18Fr9jBBJx78I1j
	 iUUtxOITVmkeQqiO0EPbi+FUCTd3VWj0iyuDhERHuW8Qy4/h/IZUZ7p9/9o7cp1m0N
	 GHu1r2BgrgRWO+2PV0DHU6g3RHIfC+lyybnrjxYE=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
	by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 44UCOq87031377
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 30 May 2024 07:24:52 -0500
Received: from DFLE107.ent.ti.com (10.64.6.28) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Thu, 30
 May 2024 07:24:52 -0500
Received: from lelvsmtp6.itg.ti.com (10.180.75.249) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Thu, 30 May 2024 07:24:52 -0500
Received: from localhost (kamlesh.dhcp.ti.com [172.24.227.123])
	by lelvsmtp6.itg.ti.com (8.15.2/8.15.2) with ESMTP id 44UCOp5x070692;
	Thu, 30 May 2024 07:24:51 -0500
From: <kamlesh@ti.com>
To: <herbert@gondor.apana.org.au>, <kristo@kernel.org>, <will@kernel.org>
CC: <akpm@linux-foundation.org>, <davem@davemloft.net>,
        <mcoquelin.stm32@gmail.com>, <alexandre.torgue@foss.st.com>,
        <robh@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <conor+dt@kernel.org>, <vigneshr@ti.com>, <catalin.marinas@arm.com>,
        <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        Kamlesh
 Gurudasani <kamlesh@ti.com>
Subject: [PATCH v3 4/6] crypto: ti - add driver for MCRC64 engine
Date: Thu, 30 May 2024 17:54:26 +0530
Message-ID: <20240524-mcrc64-upstream-v3-4-24b94d8e8578@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240524-mcrc64-upstream-v3-0-24b94d8e8578@ti.com>
References: <20240524-mcrc64-upstream-v3-0-24b94d8e8578@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180

From: Kamlesh Gurudasani <kamlesh@ti.com>

Add support for MCRC64 engine to calculate 64-bit CRC in Full-CPU mode.

In Full-CPU mode, the CPU does the data patterns transfer and signature
verification all by itself, only CRC calculation is being done by MCRC64
engine.

MCRC64 engine calculates 64-bit cyclic redundancy checks (CRC)
according to the ISO 3309 standard.

The ISO 3309 64-bit CRC model parameters are as follows:
    Generator Polynomial: x^64 + x^4 + x^3 + x + 1
    Polynomial Value: 0x000000000000001B
    Initial value: 0x0000000000000000
    Reflected Input: False
    Reflected Output: False
    Xor Final: 0x0000000000000000

Signed-off-by: Kamlesh Gurudasani <kamlesh@ti.com>
---
 MAINTAINERS                |   2 +
 drivers/crypto/Kconfig     |   1 +
 drivers/crypto/Makefile    |   1 +
 drivers/crypto/ti/Kconfig  |  11 +++
 drivers/crypto/ti/Makefile |   2 +
 drivers/crypto/ti/mcrc64.c | 442 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 459 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0c6bd9c22b91..d072b5a0154f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22193,8 +22193,10 @@ F:	drivers/iio/adc/ti-lmp92064.c
 
 TI MEMORY CYCLIC REDUNDANCY CHECK (MCRC64) DRIVER
 M:	Kamlesh Gurudasani <kamlesh@ti.com>
+L:	linux-crypto@vger.kernel.org
 S:	Maintained
 F:	Documentation/devicetree/bindings/crypto/ti,mcrc64.yaml
+F:	drivers/crypto/ti/mcrc64.c
 
 TI PCM3060 ASoC CODEC DRIVER
 M:	Kirill Marinushkin <kmarinushkin@birdec.com>
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index bb27690f8f7c..7e8ad3dc18da 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -806,5 +806,6 @@ config CRYPTO_DEV_SA2UL
 
 source "drivers/crypto/aspeed/Kconfig"
 source "drivers/crypto/starfive/Kconfig"
+source "drivers/crypto/ti/Kconfig"
 
 endif # CRYPTO_HW
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index ad4ccef67d12..07488b610bed 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -42,6 +42,7 @@ obj-$(CONFIG_CRYPTO_DEV_SL3516) += gemini/
 obj-y += stm32/
 obj-$(CONFIG_CRYPTO_DEV_TALITOS) += talitos.o
 obj-$(CONFIG_CRYPTO_DEV_TEGRA) += tegra/
+obj-$(CONFIG_CRYPTO_DEV_TI_MCRC64) += ti/
 obj-$(CONFIG_CRYPTO_DEV_VIRTIO) += virtio/
 #obj-$(CONFIG_CRYPTO_DEV_VMX) += vmx/
 obj-$(CONFIG_CRYPTO_DEV_BCM_SPU) += bcm/
diff --git a/drivers/crypto/ti/Kconfig b/drivers/crypto/ti/Kconfig
new file mode 100644
index 000000000000..b5747c2ab8f8
--- /dev/null
+++ b/drivers/crypto/ti/Kconfig
@@ -0,0 +1,11 @@
+# SPDX-License-Identifier: GPL-2.0-only
+config CRYPTO_DEV_TI_MCRC64
+	tristate "Texas Instruments MCRC64 engine support"
+	depends on ARCH_K3 || COMPILE_TEST
+	select CRYPTO_HASH
+	select CRYPTO_CRC64_ISO3309
+	help
+	  This enables support for the MCRC64 engine
+	  which can be found on all AM62* and J722S devices.
+	  MCRC64 engine calculates 64-bit cyclic redundancy checks (CRC)
+	  according to the ISO 3309 standard.
diff --git a/drivers/crypto/ti/Makefile b/drivers/crypto/ti/Makefile
new file mode 100644
index 000000000000..94ffc2576137
--- /dev/null
+++ b/drivers/crypto/ti/Makefile
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_CRYPTO_DEV_TI_MCRC64) += mcrc64.o
diff --git a/drivers/crypto/ti/mcrc64.c b/drivers/crypto/ti/mcrc64.c
new file mode 100644
index 000000000000..2be18ce81a27
--- /dev/null
+++ b/drivers/crypto/ti/mcrc64.c
@@ -0,0 +1,442 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) Texas Instruments 2023 - http://www.ti.com
+ * Author: Kamlesh Gurudasani <kamlesh@ti.com>
+ */
+
+#include <linux/crc64.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mod_devicetable.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+
+#include <crypto/internal/hash.h>
+
+#include <asm/unaligned.h>
+
+#define DRIVER_NAME		"mcrc64"
+#define CHKSUM_DIGEST_SIZE	8
+#define CHKSUM_BLOCK_SIZE	1
+
+/* Registers */
+#define CRC_CTRL0 0x0000 /* CRC Global Control Register 0 */
+#define CH_PSA_SWRE(ch) BIT(((ch) - 1) << 3) /* PSA Software Reset  */
+
+#define CRC_CTRL1 0x0008 /* CRC Global Control Register 1 */
+#define PWDN BIT(0) /* Power Down  */
+
+#define CRC_CTRL2 0x0010 /* CRC Global Control Register 2 */
+#define CH_MODE(ch, m) ((m) << (((ch) - 1) << 3))
+
+#define PSA_SIGREGL(ch) ((0x6 + (4 * ((ch) - 1))) << 4) /* Signature register */
+
+#define MCRC64_ALG_MASK 0x8000000000000000
+#define MCRC64_CRC64_POLY 0x000000000000001b
+
+#define MCRC64_AUTOSUSPEND_DELAY 50
+
+enum mcrc64_mode {
+	MCRC64_MODE_DATA_CAPTURE = 0,
+	MCRC64_MODE_AUTO,
+	MCRC64_MODE_SEMI_CPU,
+	MCRC64_MODE_FULL_CPU,
+	MCRC64_MODE_INVALID,
+};
+
+enum mcrc64_channel {
+	MCRC64_CHANNEL_1 = 1,
+	MCRC64_CHANNEL_2,
+	MCRC64_CHANNEL_3,
+	MCRC64_CHANNEL_4,
+	MCRC64_CHANNEL_INVALID,
+};
+
+struct mcrc64_data {
+	struct list_head list;
+	struct device *dev;
+	void __iomem *regs;
+};
+
+struct mcrc64_list {
+	struct list_head dev_list;
+	spinlock_t lock; /* protect dev_list */
+};
+
+static struct mcrc64_list mcrc64_dev_list = {
+	.dev_list = LIST_HEAD_INIT(mcrc64_dev_list.dev_list),
+	.lock = __SPIN_LOCK_UNLOCKED(mcrc64_dev_list.lock),
+};
+
+struct mcrc64_tfm_ctx {
+	struct mcrc64_data *dev_data;
+	u64 key;
+};
+
+struct mcrc64_desc_ctx {
+	u64 signature;
+};
+
+static struct mcrc64_data *mcrc64_get_dev(struct mcrc64_tfm_ctx *tctx)
+{
+	struct mcrc64_data *dev_data;
+
+	if (tctx->dev_data)
+		return tctx->dev_data;
+
+	spin_lock_bh(&mcrc64_dev_list.lock);
+	dev_data = list_first_entry(&mcrc64_dev_list.dev_list, struct mcrc64_data, list);
+	if (dev_data)
+		list_move_tail(&dev_data->list, &mcrc64_dev_list.dev_list);
+	spin_unlock_bh(&mcrc64_dev_list.lock);
+
+	return dev_data;
+}
+
+static int mcrc64_set_mode(void __iomem *regs, u32 channel, u32 mode)
+{
+	u32 mode_set_val;
+	u32 crc_ctrl2_reg = 0;
+
+	if (mode < 0 || mode >= MCRC64_MODE_INVALID)
+		return -EINVAL;
+
+	if (channel <= 0 || channel >= MCRC64_CHANNEL_INVALID)
+		return -EINVAL;
+
+	mode_set_val = crc_ctrl2_reg | CH_MODE(channel, mode);
+
+	/* Write CRC_CTRL2, set mode */
+	writel_relaxed(mode_set_val, regs + CRC_CTRL2);
+
+	return 0;
+}
+
+static int mcrc64_reset_signature(void __iomem *regs, u32 channel)
+{
+	u32 crc_ctrl0_reg, reset_val, reset_undo_val;
+
+	if (channel <= 0 || channel >= MCRC64_CHANNEL_INVALID)
+		return -EINVAL;
+
+	/* reset PSA */
+	crc_ctrl0_reg = readl_relaxed(regs + CRC_CTRL0);
+
+	reset_val = crc_ctrl0_reg | CH_PSA_SWRE(channel);
+	reset_undo_val = crc_ctrl0_reg & ~CH_PSA_SWRE(channel);
+
+	/* Write CRC_CTRL0 register, reset PSA register */
+	writel_relaxed(reset_val, regs + CRC_CTRL0);
+	writel_relaxed(reset_undo_val, regs + CRC_CTRL0);
+
+	return 0;
+}
+
+/* This helper implements crc64 calculation using CPU */
+static u64 mcrc64_calculate_sw_crc(u64 crc, u8 byte)
+{
+	u64 bit = 0;
+	u8 j;
+
+	for (j = 0; j < 8; j++) {
+		bit = crc & MCRC64_ALG_MASK;
+		crc <<= 1;
+		if (byte & (0x80 >> j))
+			bit ^= MCRC64_ALG_MASK;
+		if (bit)
+			crc ^= MCRC64_CRC64_POLY;
+	}
+
+	return crc;
+}
+
+static int mcrc64_calculate_crc(void __iomem *regs, u32 channel,
+				const u8 *d8, size_t length, u64 *crc64)
+{
+	void __iomem *psa_reg;
+	u64 signature = 0;
+
+	if (channel <= 0 || channel >= MCRC64_CHANNEL_INVALID)
+		return -EINVAL;
+
+	psa_reg = regs + PSA_SIGREGL(channel);
+
+	for (; length >= sizeof(u64); d8 += sizeof(u64), length -= sizeof(u64))
+		writeq_relaxed(cpu_to_be64p((u64 *)d8), psa_reg);
+
+	signature = readq_relaxed(psa_reg);
+
+	if (length) {
+		while (length--)
+			signature = mcrc64_calculate_sw_crc(signature, *d8++);
+
+		/* set capture mode */
+		int ret = mcrc64_set_mode(regs, MCRC64_CHANNEL_1,
+					MCRC64_MODE_DATA_CAPTURE);
+		if (ret)
+			return ret;
+
+		ret = mcrc64_reset_signature(regs, MCRC64_CHANNEL_1);
+		if (ret)
+			return ret;
+
+		writeq_relaxed(signature, psa_reg);
+
+		ret = mcrc64_set_mode(regs, MCRC64_CHANNEL_1,
+				      MCRC64_MODE_FULL_CPU);
+		if (ret)
+			return ret;
+	}
+
+	*crc64 = signature;
+
+	return 0;
+}
+
+static int mcrc64_cra_init(struct crypto_tfm *tfm)
+{
+	struct mcrc64_tfm_ctx *tctx = crypto_tfm_ctx(tfm);
+	struct mcrc64_data *dev_data;
+
+	dev_data = mcrc64_get_dev(tctx);
+	if (!dev_data)
+		return -ENODEV;
+
+	pm_runtime_get_sync(dev_data->dev);
+
+	tctx->key = 0;
+
+	return 0;
+}
+
+static void mcrc64_cra_exit(struct crypto_tfm *tfm)
+{
+	struct mcrc64_tfm_ctx *tctx = crypto_tfm_ctx(tfm);
+	struct mcrc64_data *dev_data;
+
+	dev_data = mcrc64_get_dev(tctx);
+
+	pm_runtime_mark_last_busy(dev_data->dev);
+	pm_runtime_put_autosuspend(dev_data->dev);
+}
+
+static int mcrc64_setkey(struct crypto_shash *tfm, const u8 *key,
+			 unsigned int keylen)
+{
+	struct mcrc64_tfm_ctx *tctx = crypto_shash_ctx(tfm);
+
+	if (keylen != sizeof(u64))
+		return -EINVAL;
+
+	tctx->key = get_unaligned_le64(key);
+
+	return 0;
+}
+
+static int mcrc64_init(struct shash_desc *desc)
+{
+	struct mcrc64_desc_ctx *ctx = shash_desc_ctx(desc);
+	struct mcrc64_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
+	struct mcrc64_data *dev_data;
+	void __iomem *psa_reg;
+
+	dev_data = mcrc64_get_dev(tctx);
+	if (!dev_data)
+		return -ENODEV;
+
+	pm_runtime_get_sync(dev_data->dev);
+
+	/* set capture mode */
+	int ret = mcrc64_set_mode(dev_data->regs, MCRC64_CHANNEL_1,
+				  MCRC64_MODE_DATA_CAPTURE);
+	if (ret)
+		return ret;
+
+	/* reset PSA */
+	psa_reg = dev_data->regs + PSA_SIGREGL(MCRC64_CHANNEL_1);
+	ret =  mcrc64_reset_signature(dev_data->regs, MCRC64_CHANNEL_1);
+	if (ret)
+		return ret;
+
+	/* write key  */
+	writeq_relaxed(tctx->key, psa_reg);
+
+	/* set full cpu mode */
+	ret = mcrc64_set_mode(dev_data->regs, MCRC64_CHANNEL_1,
+			      MCRC64_MODE_FULL_CPU);
+	if (ret)
+		return ret;
+
+	ctx->signature = readq_relaxed(psa_reg);
+
+	return 0;
+}
+
+static int mcrc64_update(struct shash_desc *desc, const u8 *d8,
+			 unsigned int length)
+{
+	struct mcrc64_desc_ctx *ctx = shash_desc_ctx(desc);
+	struct mcrc64_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
+	struct mcrc64_data *dev_data;
+
+	dev_data = mcrc64_get_dev(tctx);
+	if (!dev_data)
+		return -ENODEV;
+
+	return mcrc64_calculate_crc(dev_data->regs, MCRC64_CHANNEL_1,
+				    d8, length, &ctx->signature);
+}
+
+static int mcrc64_final(struct shash_desc *desc, u8 *out)
+{
+	struct mcrc64_desc_ctx *ctx = shash_desc_ctx(desc);
+
+	/* Send computed CRC */
+	put_unaligned_le64(ctx->signature, out);
+	return 0;
+}
+
+static int mcrc64_finup(struct shash_desc *desc, const u8 *data,
+			unsigned int length, u8 *out)
+{
+	return mcrc64_update(desc, data, length) ?:
+		mcrc64_final(desc, out);
+}
+
+static int mcrc64_digest(struct shash_desc *desc, const u8 *data,
+			 unsigned int length, u8 *out)
+{
+	return mcrc64_init(desc) ?: mcrc64_finup(desc, data, length, out);
+}
+
+static unsigned int refcnt;
+static DEFINE_MUTEX(refcnt_lock);
+static struct shash_alg algs[] = {
+	/* CRC-64 */
+	{
+		.setkey		= mcrc64_setkey,
+		.init		= mcrc64_init,
+		.update		= mcrc64_update,
+		.final		= mcrc64_final,
+		.finup		= mcrc64_finup,
+		.digest		= mcrc64_digest,
+		.descsize	= sizeof(struct mcrc64_desc_ctx),
+		.digestsize	= CHKSUM_DIGEST_SIZE,
+		.base		= {
+			.cra_name		= CRC64_ISO3309_STRING,
+			.cra_driver_name	= "mcrc64",
+			.cra_priority		= 300,
+			.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
+			.cra_blocksize		= CHKSUM_BLOCK_SIZE,
+			.cra_ctxsize		= sizeof(struct mcrc64_tfm_ctx),
+			.cra_module		= THIS_MODULE,
+			.cra_init		= mcrc64_cra_init,
+			.cra_exit		= mcrc64_cra_exit,
+		}
+	}
+};
+
+static int mcrc64_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct mcrc64_data *dev_data;
+	int ret;
+
+	dev_data = devm_kzalloc(dev, sizeof(*dev_data), GFP_KERNEL);
+	if (!dev_data)
+		return -ENOMEM;
+
+	dev_data->dev = dev;
+	dev_data->regs = devm_platform_ioremap_resource(pdev, 0);
+
+	platform_set_drvdata(pdev, dev_data);
+
+	spin_lock(&mcrc64_dev_list.lock);
+	list_add(&dev_data->list, &mcrc64_dev_list.dev_list);
+	spin_unlock(&mcrc64_dev_list.lock);
+
+	mutex_lock(&refcnt_lock);
+	if (!refcnt) {
+		ret = crypto_register_shashes(algs, ARRAY_SIZE(algs));
+		if (ret) {
+			mutex_unlock(&refcnt_lock);
+			dev_err(dev, "Failed to register\n");
+			return ret;
+		}
+	}
+	refcnt++;
+	mutex_unlock(&refcnt_lock);
+
+	pm_runtime_set_autosuspend_delay(dev, MCRC64_AUTOSUSPEND_DELAY);
+	pm_runtime_use_autosuspend(dev);
+
+	pm_runtime_get_noresume(dev);
+	pm_runtime_set_active(dev);
+	pm_runtime_enable(dev);
+
+	pm_runtime_put_sync(dev);
+
+	return 0;
+}
+
+static int mcrc64_remove(struct platform_device *pdev)
+{
+	struct mcrc64_data *dev_data = platform_get_drvdata(pdev);
+	int ret;
+
+	ret = pm_runtime_resume_and_get(dev_data->dev);
+	if (ret < 0)
+		return ret;
+
+	spin_lock(&mcrc64_dev_list.lock);
+	list_del(&dev_data->list);
+	spin_unlock(&mcrc64_dev_list.lock);
+
+	mutex_lock(&refcnt_lock);
+	if (!--refcnt)
+		crypto_unregister_shashes(algs, ARRAY_SIZE(algs));
+	mutex_unlock(&refcnt_lock);
+
+	pm_runtime_disable(dev_data->dev);
+	pm_runtime_put_noidle(dev_data->dev);
+
+	return 0;
+}
+
+static int __maybe_unused mcrc64_suspend(struct device *dev)
+{
+	return	pm_runtime_force_suspend(dev);
+}
+
+static int __maybe_unused mcrc64_resume(struct device *dev)
+{
+	return pm_runtime_force_resume(dev);
+}
+
+static const struct dev_pm_ops mcrc64_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(mcrc64_suspend,
+				mcrc64_resume)
+};
+
+static const struct of_device_id of_match[] = {
+	{ .compatible = "ti,am62-mcrc64", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, of_match);
+
+static struct platform_driver mcrc64_driver = {
+	.probe	= mcrc64_probe,
+	.remove = mcrc64_remove,
+	.driver = {
+		.name		= DRIVER_NAME,
+		.pm		= &mcrc64_pm_ops,
+		.of_match_table = of_match,
+	},
+};
+
+module_platform_driver(mcrc64_driver);
+
+MODULE_AUTHOR("Kamlesh Gurudasani <kamlesh@ti.com>");
+MODULE_DESCRIPTION("Texas Instruments MCRC64 driver");
+MODULE_LICENSE("GPL");

-- 
2.34.1
