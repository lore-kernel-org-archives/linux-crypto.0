From: Fabien Dessenne <fabien.dessenne-qxv4g6HH51o@public.gmane.org>
Subject: [PATCH 2/4] crypto: stm32 - Support for STM32 CRC32 crypto module
Date: Tue, 14 Mar 2017 17:37:24 +0100
Message-ID: <1489509446-32283-3-git-send-email-fabien.dessenne@st.com>
References: <1489509446-32283-1-git-send-email-fabien.dessenne@st.com>
Mime-Version: 1.0
Content-Type: text/plain
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Alexandre Torgue <alexandre.torgue-qxv4g6HH51o@public.gmane.org>,
        Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>,
        <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489509446-32283-1-git-send-email-fabien.dessenne-qxv4g6HH51o@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

This module registers a CRC32 ("Ethernet") and a CRC32C (Castagnoli)
algorithm that make use of the STMicroelectronics STM32 crypto hardware.

Theses algorithms are compatible with the little-endian generic ones.
Both algorithms use ~0 as default seed (key).
With CRC32C the output is xored with ~0.

Using TCRYPT CRC32C speed test, this shows up to 900% speedup compared
to the crc32c-generic algorithm.

Signed-off-by: Fabien Dessenne <fabien.dessenne-qxv4g6HH51o@public.gmane.org>
---
 drivers/crypto/Kconfig             |   2 +
 drivers/crypto/Makefile            |   1 +
 drivers/crypto/stm32/Kconfig       |   8 +
 drivers/crypto/stm32/Makefile      |   2 +
 drivers/crypto/stm32/stm32_crc32.c | 325 +++++++++++++++++++++++++++++++++++++
 5 files changed, 338 insertions(+)
 create mode 100644 drivers/crypto/stm32/Kconfig
 create mode 100644 drivers/crypto/stm32/Makefile
 create mode 100644 drivers/crypto/stm32/stm32_crc32.c

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 473d312..922b323 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -619,4 +619,6 @@ config CRYPTO_DEV_BCM_SPU
 	  Secure Processing Unit (SPU). The SPU driver registers ablkcipher,
 	  ahash, and aead algorithms with the kernel cryptographic API.
 
+source "drivers/crypto/stm32/Kconfig"
+
 endif # CRYPTO_HW
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 7396094..95bf2f9 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -30,6 +30,7 @@ obj-$(CONFIG_CRYPTO_DEV_QCE) += qce/
 obj-$(CONFIG_CRYPTO_DEV_ROCKCHIP) += rockchip/
 obj-$(CONFIG_CRYPTO_DEV_S5P) += s5p-sss.o
 obj-$(CONFIG_CRYPTO_DEV_SAHARA) += sahara.o
+obj-$(CONFIG_CRYPTO_DEV_STM32) += stm32/
 obj-$(CONFIG_CRYPTO_DEV_SUN4I_SS) += sunxi-ss/
 obj-$(CONFIG_CRYPTO_DEV_TALITOS) += talitos.o
 obj-$(CONFIG_CRYPTO_DEV_UX500) += ux500/
diff --git a/drivers/crypto/stm32/Kconfig b/drivers/crypto/stm32/Kconfig
new file mode 100644
index 0000000..792335b
--- /dev/null
+++ b/drivers/crypto/stm32/Kconfig
@@ -0,0 +1,8 @@
+config CRYPTO_DEV_STM32
+	tristate "Support for STM32 crypto accelerators"
+	depends on ARCH_STM32
+	select CRYPTO_HASH
+	help
+          This enables support for the CRC32 hw accelerator which can be found
+	  on STMicroelectronis STM32 SOC.
+
diff --git a/drivers/crypto/stm32/Makefile b/drivers/crypto/stm32/Makefile
new file mode 100644
index 0000000..73b4c6e
--- /dev/null
+++ b/drivers/crypto/stm32/Makefile
@@ -0,0 +1,2 @@
+obj-$(CONFIG_CRYPTO_DEV_STM32) += stm32_cryp.o
+stm32_cryp-objs := stm32_crc32.o
diff --git a/drivers/crypto/stm32/stm32_crc32.c b/drivers/crypto/stm32/stm32_crc32.c
new file mode 100644
index 0000000..ba780a6
--- /dev/null
+++ b/drivers/crypto/stm32/stm32_crc32.c
@@ -0,0 +1,325 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2017
+ * Author: Fabien Dessenne <fabien.dessenne-qxv4g6HH51o@public.gmane.org>
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#include <linux/bitrev.h>
+#include <linux/clk.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+
+#include <crypto/internal/hash.h>
+
+#include <asm/unaligned.h>
+
+#define DRIVER_NAME             "stm32-crc32"
+#define CHKSUM_DIGEST_SIZE      4
+#define CHKSUM_BLOCK_SIZE       1
+
+/* Registers */
+#define CRC_DR                  0x00000000
+#define CRC_CR                  0x00000008
+#define CRC_INIT                0x00000010
+#define CRC_POL                 0x00000014
+
+/* Registers values */
+#define CRC_CR_RESET            BIT(0)
+#define CRC_CR_REVERSE          (BIT(7) | BIT(6) | BIT(5))
+#define CRC_INIT_DEFAULT        0xFFFFFFFF
+
+/* Polynomial reversed */
+#define POLY_CRC32              0xEDB88320
+#define POLY_CRC32C             0x82F63B78
+
+struct stm32_crc {
+	struct list_head list;
+	struct device    *dev;
+	void __iomem     *regs;
+	struct clk       *clk;
+	u8               pending_data[sizeof(u32)];
+	size_t           nb_pending_bytes;
+};
+
+struct stm32_crc_list {
+	struct list_head dev_list;
+	spinlock_t       lock; /* protect dev_list */
+};
+
+static struct stm32_crc_list crc_list = {
+	.dev_list = LIST_HEAD_INIT(crc_list.dev_list),
+	.lock     = __SPIN_LOCK_UNLOCKED(crc_list.lock),
+};
+
+struct stm32_crc_ctx {
+	u32 key;
+	u32 poly;
+};
+
+struct stm32_crc_desc_ctx {
+	u32    partial; /* crc32c: partial in first 4 bytes of that struct */
+	struct stm32_crc *crc;
+};
+
+static int stm32_crc32_cra_init(struct crypto_tfm *tfm)
+{
+	struct stm32_crc_ctx *mctx = crypto_tfm_ctx(tfm);
+
+	mctx->key = CRC_INIT_DEFAULT;
+	mctx->poly = POLY_CRC32;
+	return 0;
+}
+
+static int stm32_crc32c_cra_init(struct crypto_tfm *tfm)
+{
+	struct stm32_crc_ctx *mctx = crypto_tfm_ctx(tfm);
+
+	mctx->key = CRC_INIT_DEFAULT;
+	mctx->poly = POLY_CRC32C;
+	return 0;
+}
+
+static int stm32_crc_setkey(struct crypto_shash *tfm, const u8 *key,
+			    unsigned int keylen)
+{
+	struct stm32_crc_ctx *mctx = crypto_shash_ctx(tfm);
+
+	if (keylen != sizeof(u32)) {
+		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+
+	mctx->key = get_unaligned_le32(key);
+	return 0;
+}
+
+static int stm32_crc_init(struct shash_desc *desc)
+{
+	struct stm32_crc_desc_ctx *ctx = shash_desc_ctx(desc);
+	struct stm32_crc_ctx *mctx = crypto_shash_ctx(desc->tfm);
+	struct stm32_crc *crc;
+
+	spin_lock_bh(&crc_list.lock);
+	list_for_each_entry(crc, &crc_list.dev_list, list) {
+		ctx->crc = crc;
+		break;
+	}
+	spin_unlock_bh(&crc_list.lock);
+
+	/* Reset, set key, poly and configure in bit reverse mode */
+	writel(bitrev32(mctx->key), ctx->crc->regs + CRC_INIT);
+	writel(bitrev32(mctx->poly), ctx->crc->regs + CRC_POL);
+	writel(CRC_CR_RESET | CRC_CR_REVERSE, ctx->crc->regs + CRC_CR);
+
+	/* Store partial result */
+	ctx->partial = readl(ctx->crc->regs + CRC_DR);
+	ctx->crc->nb_pending_bytes = 0;
+
+	return 0;
+}
+
+static int stm32_crc_update(struct shash_desc *desc, const u8 *d8,
+			    unsigned int length)
+{
+	struct stm32_crc_desc_ctx *ctx = shash_desc_ctx(desc);
+	struct stm32_crc *crc = ctx->crc;
+	u32 *d32;
+	unsigned int i;
+
+	if (unlikely(crc->nb_pending_bytes)) {
+		while (crc->nb_pending_bytes != sizeof(u32) && length) {
+			/* Fill in pending data */
+			crc->pending_data[crc->nb_pending_bytes++] = *(d8++);
+			length--;
+		}
+
+		if (crc->nb_pending_bytes == sizeof(u32)) {
+			/* Process completed pending data */
+			writel(*(u32 *)crc->pending_data, crc->regs + CRC_DR);
+			crc->nb_pending_bytes = 0;
+		}
+	}
+
+	d32 = (u32 *)d8;
+	for (i = 0; i < length >> 2; i++)
+		/* Process 32 bits data */
+		writel(*(d32++), crc->regs + CRC_DR);
+
+	/* Store partial result */
+	ctx->partial = readl(crc->regs + CRC_DR);
+
+	/* Check for pending data (non 32 bits) */
+	length &= 3;
+	if (likely(!length))
+		return 0;
+
+	if ((crc->nb_pending_bytes + length) >= sizeof(u32)) {
+		/* Shall not happen */
+		dev_err(crc->dev, "Pending data overflow\n");
+		return -EINVAL;
+	}
+
+	d8 = (const u8 *)d32;
+	for (i = 0; i < length; i++)
+		/* Store pending data */
+		crc->pending_data[crc->nb_pending_bytes++] = *(d8++);
+
+	return 0;
+}
+
+static int stm32_crc_final(struct shash_desc *desc, u8 *out)
+{
+	struct stm32_crc_desc_ctx *ctx = shash_desc_ctx(desc);
+	struct stm32_crc_ctx *mctx = crypto_shash_ctx(desc->tfm);
+
+	/* Send computed CRC */
+	put_unaligned_le32(mctx->poly == POLY_CRC32C ?
+			   ~ctx->partial : ctx->partial, out);
+
+	return 0;
+}
+
+static int stm32_crc_finup(struct shash_desc *desc, const u8 *data,
+			   unsigned int length, u8 *out)
+{
+	return stm32_crc_update(desc, data, length) ?:
+	       stm32_crc_final(desc, out);
+}
+
+static int stm32_crc_digest(struct shash_desc *desc, const u8 *data,
+			    unsigned int length, u8 *out)
+{
+	return stm32_crc_init(desc) ?: stm32_crc_finup(desc, data, length, out);
+}
+
+static struct shash_alg algs[] = {
+	/* CRC-32 */
+	{
+		.setkey         = stm32_crc_setkey,
+		.init           = stm32_crc_init,
+		.update         = stm32_crc_update,
+		.final          = stm32_crc_final,
+		.finup          = stm32_crc_finup,
+		.digest         = stm32_crc_digest,
+		.descsize       = sizeof(struct stm32_crc_desc_ctx),
+		.digestsize     = CHKSUM_DIGEST_SIZE,
+		.base           = {
+			.cra_name               = "crc32",
+			.cra_driver_name        = DRIVER_NAME,
+			.cra_priority           = 200,
+			.cra_blocksize          = CHKSUM_BLOCK_SIZE,
+			.cra_alignmask          = 3,
+			.cra_ctxsize            = sizeof(struct stm32_crc_ctx),
+			.cra_module             = THIS_MODULE,
+			.cra_init               = stm32_crc32_cra_init,
+		}
+	},
+	/* CRC-32Castagnoli */
+	{
+		.setkey         = stm32_crc_setkey,
+		.init           = stm32_crc_init,
+		.update         = stm32_crc_update,
+		.final          = stm32_crc_final,
+		.finup          = stm32_crc_finup,
+		.digest         = stm32_crc_digest,
+		.descsize       = sizeof(struct stm32_crc_desc_ctx),
+		.digestsize     = CHKSUM_DIGEST_SIZE,
+		.base           = {
+			.cra_name               = "crc32c",
+			.cra_driver_name        = DRIVER_NAME,
+			.cra_priority           = 200,
+			.cra_blocksize          = CHKSUM_BLOCK_SIZE,
+			.cra_alignmask          = 3,
+			.cra_ctxsize            = sizeof(struct stm32_crc_ctx),
+			.cra_module             = THIS_MODULE,
+			.cra_init               = stm32_crc32c_cra_init,
+		}
+	}
+};
+
+static int stm32_crc_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct stm32_crc *crc;
+	struct resource *res;
+	int ret;
+
+	crc = devm_kzalloc(dev, sizeof(*crc), GFP_KERNEL);
+	if (!crc)
+		return -ENOMEM;
+
+	crc->dev = dev;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	crc->regs = devm_ioremap_resource(dev, res);
+	if (IS_ERR(crc->regs)) {
+		dev_err(dev, "Cannot map CRC IO\n");
+		return PTR_ERR(crc->regs);
+	}
+
+	crc->clk = devm_clk_get(dev, NULL);
+	if (IS_ERR(crc->clk)) {
+		dev_err(dev, "Could not get clock\n");
+		return PTR_ERR(crc->clk);
+	}
+
+	ret = clk_prepare_enable(crc->clk);
+	if (ret) {
+		dev_err(crc->dev, "Failed to enable clock\n");
+		return ret;
+	}
+
+	platform_set_drvdata(pdev, crc);
+
+	spin_lock(&crc_list.lock);
+	list_add(&crc->list, &crc_list.dev_list);
+	spin_unlock(&crc_list.lock);
+
+	ret = crypto_register_shashes(algs, ARRAY_SIZE(algs));
+	if (ret) {
+		dev_err(dev, "Failed to register\n");
+		clk_disable_unprepare(crc->clk);
+		return ret;
+	}
+
+	dev_info(dev, "Initialized\n");
+
+	return 0;
+}
+
+static int stm32_crc_remove(struct platform_device *pdev)
+{
+	struct stm32_crc *crc = platform_get_drvdata(pdev);
+
+	spin_lock(&crc_list.lock);
+	list_del(&crc->list);
+	spin_unlock(&crc_list.lock);
+
+	crypto_unregister_shash(algs);
+
+	if (crc && crc->clk)
+		clk_disable_unprepare(crc->clk);
+
+	return 0;
+}
+
+static const struct of_device_id stm32_dt_ids[] = {
+	{ .compatible = "st,stm32f7-crc", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, sti_dt_ids);
+
+static struct platform_driver stm32_crc_driver = {
+	.probe  = stm32_crc_probe,
+	.remove = stm32_crc_remove,
+	.driver = {
+		.name           = DRIVER_NAME,
+		.of_match_table = stm32_dt_ids,
+	},
+};
+
+module_platform_driver(stm32_crc_driver);
+
+MODULE_AUTHOR("Fabien Dessenne <fabien.dessenne-qxv4g6HH51o@public.gmane.org>");
+MODULE_DESCRIPTION("STMicrolectronics STM32 CRC32 hardware driver");
+MODULE_LICENSE("GPL");
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
