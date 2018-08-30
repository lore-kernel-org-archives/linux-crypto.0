From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 6/6] crypto: vf-crc - Add new driver for Freescale Vybrid CRC
Date: Thu, 30 Aug 2018 19:15:39 +0200
Message-ID: <20180830171539.20008-7-krzk@kernel.org>
References: <20180830171539.20008-1-krzk@kernel.org>
To: Krzysztof Kozlowski <krzk@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Stefan Agner <stefan@agner.ch>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180830171539.20008-1-krzk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add driver for using the Freescale/NXP Vybrid processor CRC block for
CRC16 and CRC32 offloading.  The driver implements shash_alg and was
tested using internal testmgr tests and libkcapi.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 MAINTAINERS               |   7 +
 drivers/crypto/Kconfig    |  10 ++
 drivers/crypto/Makefile   |   1 +
 drivers/crypto/vf-crc.c   | 387 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/crc32poly.h |   7 +
 5 files changed, 412 insertions(+)
 create mode 100644 drivers/crypto/vf-crc.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 0a340f680230..e84fa829a4e4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15388,6 +15388,13 @@ S:	Maintained
 F:	Documentation/fb/uvesafb.txt
 F:	drivers/video/fbdev/uvesafb.*
 
+VF500/VF610 HW CRC DRIVER
+M:	Krzysztof Kozlowski <krzk@kernel.org>
+L:	linux-crypto@vger.kernel.org
+S:	Maintained
+F:	drivers/crypto/vf-crc.c
+F:	Documentation/devicetree/bindings/crypto/fsl-vf610-crc.txt
+
 VF610 NAND DRIVER
 M:	Stefan Agner <stefan@agner.ch>
 L:	linux-mtd@lists.infradead.org
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 20314d7a7b58..0ade940ac79c 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -418,6 +418,16 @@ config CRYPTO_DEV_MXS_DCP
 	  To compile this driver as a module, choose M here: the module
 	  will be called mxs-dcp.
 
+config CRYPTO_DEV_VF_CRC
+	tristate "Support for Freescale/NXP Vybrid CRC HW accelerator"
+	select CRYPTO_HASH
+	help
+	  This option enables support for the CRC16/32 hardware accelerator
+	  on Freescale/NXP Vybrid VF500/VF610 SoCs.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called vf-crc.
+
 config CRYPTO_DEV_EXYNOS_RNG
 	tristate "EXYNOS HW pseudo random number generator support"
 	depends on ARCH_EXYNOS || COMPILE_TEST
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index c23396f32c8a..418c08bdc19c 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -41,6 +41,7 @@ obj-$(CONFIG_ARCH_STM32) += stm32/
 obj-$(CONFIG_CRYPTO_DEV_SUN4I_SS) += sunxi-ss/
 obj-$(CONFIG_CRYPTO_DEV_TALITOS) += talitos.o
 obj-$(CONFIG_CRYPTO_DEV_UX500) += ux500/
+obj-$(CONFIG_CRYPTO_DEV_VF_CRC) += vf-crc.o
 obj-$(CONFIG_CRYPTO_DEV_VIRTIO) += virtio/
 obj-$(CONFIG_CRYPTO_DEV_VMX) += vmx/
 obj-$(CONFIG_CRYPTO_DEV_BCM_SPU) += bcm/
diff --git a/drivers/crypto/vf-crc.c b/drivers/crypto/vf-crc.c
new file mode 100644
index 000000000000..2223b2e0f014
--- /dev/null
+++ b/drivers/crypto/vf-crc.c
@@ -0,0 +1,387 @@
+// SPDX-License-Identifier: GPL-2.0
+//
+// Freescale/NXP VF500/VF610 hardware CRC driver
+//
+// Copyright (c) 2018 Krzysztof Kozlowski <krzk@kernel.org>
+
+#include <linux/bitrev.h>
+#include <linux/clk.h>
+#include <linux/crc32poly.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+
+#include <crypto/internal/hash.h>
+
+#include <asm/unaligned.h>
+
+#define DRIVER_NAME             "vf-crc"
+#define CHKSUM_DIGEST_SIZE	4
+#define CHKSUM_BLOCK_SIZE       1
+
+/* Register offsets */
+#define CRC_DATA		0x00
+#define CRC_POLY		0x04
+#define CRC_CTRL		0x08
+
+/* CTRL bit fields */
+/* Width of CRC (0 - 16 bit, 1 - 32 bit) */
+#define CRC_CTRL_TCRC		BIT(24)
+/* Write CRC Data register as Seed (0 - data, 1 - seed) */
+#define CRC_CTRL_WAS		BIT(25)
+/* Final XOR on checksum */
+#define CRC_CTRL_FXOR		BIT(26)
+
+#define CRC_INIT_DEFAULT        0x0
+
+struct vf_crc {
+	struct clk		*clk;
+	struct device		*dev;
+	void __iomem		*iobase;
+
+	/*
+	 * Request currently processed in HW so consecutive update() and final()
+	 * will not need to reinit the HW.
+	 */
+	struct vf_crc_desc_ctx	*processed_desc;
+
+	/* Lock protecting access to HW registers and processed_desc. */
+	struct mutex		lock;
+};
+
+struct vf_crc_desc_ctx {
+	struct vf_crc		*crc;
+	/*
+	 * Current state of computed CRC (used for re-init on subsequent
+	 * requests).
+	 */
+	u32			state;
+};
+
+struct vf_crc_tfm_ctx {
+	unsigned int		align;
+	u32			ctrl_init;
+	bool			is_16_bit;
+	u32			key;
+	u32			poly;
+};
+
+static struct vf_crc *vf_crc_data;
+
+static int vf_crc_cra_init32(struct crypto_tfm *tfm)
+{
+	struct vf_crc_tfm_ctx *mctx = crypto_tfm_ctx(tfm);
+
+	mctx->align = sizeof(u32);
+	/* 32 bit, no XOR */
+	mctx->ctrl_init = CRC_CTRL_TCRC;
+	mctx->is_16_bit = false;
+	mctx->key = CRC_INIT_DEFAULT;
+	mctx->poly = CRC32_POLY_BE;
+
+	return 0;
+}
+
+static int vf_crc_cra_init16(struct crypto_tfm *tfm)
+{
+	struct vf_crc_tfm_ctx *mctx = crypto_tfm_ctx(tfm);
+
+	mctx->align = sizeof(u16);
+	/* 16 bit, no XOR */
+	mctx->ctrl_init = 0;
+	mctx->is_16_bit = true;
+	mctx->key = CRC_INIT_DEFAULT;
+	mctx->poly = CRC16_POLY_BE;
+
+	return 0;
+}
+
+static int vf_crc_setkey(struct crypto_shash *tfm, const u8 *key,
+			 unsigned int keylen)
+{
+	struct vf_crc_tfm_ctx *mctx = crypto_shash_ctx(tfm);
+
+	if (keylen != mctx->align) {
+		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+
+	if (mctx->is_16_bit)
+		mctx->key = bitrev16(get_unaligned_le16(key));
+	else
+		mctx->key = bitrev32(get_unaligned_le32(key));
+
+	return 0;
+}
+
+static int vf_crc_init(struct shash_desc *desc)
+{
+	struct vf_crc_desc_ctx *desc_ctx = shash_desc_ctx(desc);
+	struct vf_crc_tfm_ctx *mctx = crypto_shash_ctx(desc->tfm);
+
+	desc_ctx->crc = vf_crc_data;
+	desc_ctx->state = mctx->key;
+
+	return 0;
+}
+
+static void vf_crc_initialize_regs(struct vf_crc_tfm_ctx *mctx,
+				   struct vf_crc_desc_ctx *desc_ctx)
+{
+	struct vf_crc *crc = desc_ctx->crc;
+
+	/* Init and write-as-seed (next data write will be the seed) */
+	writel(mctx->ctrl_init, crc->iobase + CRC_CTRL);
+	writel(mctx->poly, crc->iobase + CRC_POLY);
+	writel(mctx->ctrl_init | CRC_CTRL_WAS, crc->iobase + CRC_CTRL);
+
+	/* Initialize engine with either key or state from previous rounds */
+	writel(desc_ctx->state, crc->iobase + CRC_DATA);
+
+	/* Clear write-as-seed */
+	writel(mctx->ctrl_init, crc->iobase + CRC_CTRL);
+}
+
+static void vf_crc_write_bytes(void __iomem *addr, const u8 *data,
+			       unsigned int len)
+{
+	unsigned int i;
+	u8 value;
+
+	for (i = 0; i < len; i++) {
+		value = bitrev8(data[i]);
+		writeb(value, addr);
+	}
+}
+
+static int vf_crc_update_prepare(struct vf_crc_tfm_ctx *mctx,
+				 struct vf_crc_desc_ctx *desc_ctx)
+{
+	struct vf_crc *crc = desc_ctx->crc;
+	int ret;
+
+	ret = clk_prepare_enable(crc->clk);
+	if (ret) {
+		dev_err(crc->dev, "Failed to enable clock\n");
+		return ret;
+	}
+
+	mutex_lock(&crc->lock);
+
+	/*
+	 * Check if we are continuing to process request already configured
+	 * in HW. HW has to be re-initialized only on first update() for given
+	 * request or if new request was processed after last call to update().
+	 */
+	if (crc->processed_desc == desc_ctx)
+		return 0;
+
+	vf_crc_initialize_regs(mctx, desc_ctx);
+
+	return 0;
+}
+
+static void vf_crc_update_unprepare(struct vf_crc_tfm_ctx *mctx,
+				    struct vf_crc_desc_ctx *desc_ctx)
+{
+	struct vf_crc *crc = desc_ctx->crc;
+
+	if (mctx->is_16_bit)
+		desc_ctx->state = readw(crc->iobase + CRC_DATA);
+	else
+		desc_ctx->state = readl(crc->iobase + CRC_DATA);
+
+	mutex_unlock(&crc->lock);
+
+	clk_disable_unprepare(crc->clk);
+}
+
+static int vf_crc_update(struct shash_desc *desc, const u8 *data,
+			 unsigned int len)
+{
+	struct vf_crc_desc_ctx *desc_ctx = shash_desc_ctx(desc);
+	struct vf_crc_tfm_ctx *mctx = crypto_shash_ctx(desc->tfm);
+	unsigned int i, len_align;
+	int ret;
+
+	ret = vf_crc_update_prepare(mctx, desc_ctx);
+	if (ret)
+		return ret;
+
+	len_align = ALIGN_DOWN(len, mctx->align);
+	if (mctx->is_16_bit) {
+		u16 value;
+
+		for (i = 0; i < len_align; i += mctx->align) {
+			value = bitrev16(get_unaligned_le16(data + i));
+			writew(value, desc_ctx->crc->iobase + CRC_DATA);
+		}
+	} else {
+		u32 value;
+
+		for (i = 0; i < len_align; i += mctx->align) {
+			value = bitrev32(get_unaligned_le32(data + i));
+			writel(value, desc_ctx->crc->iobase + CRC_DATA);
+		}
+	}
+
+	if (len != len_align)
+		vf_crc_write_bytes(desc_ctx->crc->iobase + CRC_DATA,
+				   &data[len_align], len - len_align);
+
+	vf_crc_update_unprepare(mctx, desc_ctx);
+
+	return 0;
+}
+
+static int vf_crc_final(struct shash_desc *desc, u8 *out)
+{
+	struct vf_crc_desc_ctx *desc_ctx = shash_desc_ctx(desc);
+	struct vf_crc_tfm_ctx *mctx = crypto_shash_ctx(desc->tfm);
+
+	if (mctx->is_16_bit)
+		put_unaligned_le16(bitrev16(desc_ctx->state), out);
+	else
+		put_unaligned_le32(bitrev32(desc_ctx->state), out);
+
+	mutex_lock(&desc_ctx->crc->lock);
+	/* No more processing of this request */
+	desc_ctx->crc->processed_desc = NULL;
+	mutex_unlock(&desc_ctx->crc->lock);
+
+	return 0;
+}
+
+static int vf_crc_finup(struct shash_desc *desc, const u8 *data,
+			unsigned int len, u8 *out)
+{
+	return vf_crc_update(desc, data, len) ?:
+	       vf_crc_final(desc, out);
+}
+
+static int vf_crc_digest(struct shash_desc *desc, const u8 *data,
+			 unsigned int leng, u8 *out)
+{
+	return vf_crc_init(desc) ?: vf_crc_finup(desc, data, leng, out);
+}
+
+static struct shash_alg algs[] = {
+	{
+		.setkey         = vf_crc_setkey,
+		.init           = vf_crc_init,
+		.update         = vf_crc_update,
+		.final          = vf_crc_final,
+		.finup          = vf_crc_finup,
+		.digest         = vf_crc_digest,
+		.descsize       = sizeof(struct vf_crc_desc_ctx),
+		.digestsize     = CHKSUM_DIGEST_SIZE,
+		.base           = {
+			.cra_name               = "crc32",
+			.cra_driver_name        = DRIVER_NAME,
+			.cra_priority           = 200,
+			.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
+			.cra_blocksize          = CHKSUM_BLOCK_SIZE,
+			.cra_ctxsize            = sizeof(struct vf_crc_tfm_ctx),
+			.cra_module             = THIS_MODULE,
+			.cra_init               = vf_crc_cra_init32,
+		}
+	},
+	{
+		.setkey         = vf_crc_setkey,
+		.init           = vf_crc_init,
+		.update         = vf_crc_update,
+		.final          = vf_crc_final,
+		.finup          = vf_crc_finup,
+		.digest         = vf_crc_digest,
+		.descsize       = sizeof(struct vf_crc_desc_ctx),
+		.digestsize     = (CHKSUM_DIGEST_SIZE / 2),
+		.base           = {
+			.cra_name               = "crc16",
+			.cra_driver_name        = DRIVER_NAME,
+			.cra_priority           = 200,
+			.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
+			.cra_blocksize          = CHKSUM_BLOCK_SIZE,
+			.cra_ctxsize            = sizeof(struct vf_crc_tfm_ctx),
+			.cra_module             = THIS_MODULE,
+			.cra_init               = vf_crc_cra_init16,
+		}
+	}
+};
+
+static int vf_crc_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct resource *res;
+	struct vf_crc *crc;
+	int ret;
+
+	if (vf_crc_data) {
+		dev_err(dev, "Device already registered (only one instance allowed)\n");
+		return -EINVAL;
+	}
+
+	crc = devm_kzalloc(dev, sizeof(*crc), GFP_KERNEL);
+	if (!crc)
+		return -ENOMEM;
+
+	crc->dev = dev;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	crc->iobase = devm_ioremap_resource(dev, res);
+	if (IS_ERR(crc->iobase))
+		return PTR_ERR(crc->iobase);
+
+	crc->clk = devm_clk_get(dev, "crc");
+	if (IS_ERR(crc->clk)) {
+		dev_err(dev, "Could not get clock\n");
+		return PTR_ERR(crc->clk);
+	}
+
+	vf_crc_data = crc;
+
+	ret = crypto_register_shashes(algs, ARRAY_SIZE(algs));
+	if (ret) {
+		dev_err(dev, "Failed to register crypto algorithms\n");
+		goto err;
+	}
+
+	mutex_init(&crc->lock);
+	dev_dbg(dev, "HW CRC accelerator initialized\n");
+
+	return 0;
+
+err:
+	vf_crc_data = NULL;
+
+	return ret;
+}
+
+static int vf_crc_remove(struct platform_device *pdev)
+{
+	crypto_unregister_shashes(algs, ARRAY_SIZE(algs));
+	vf_crc_data = NULL;
+
+	return 0;
+}
+
+static const struct of_device_id vf_crc_dt_match[] = {
+	{ .compatible = "fsl,vf610-crc", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, vf_crc_dt_match);
+
+static struct platform_driver vf_crc_driver = {
+	.probe  = vf_crc_probe,
+	.remove = vf_crc_remove,
+	.driver = {
+		.name           = DRIVER_NAME,
+		.of_match_table = vf_crc_dt_match,
+	},
+};
+
+module_platform_driver(vf_crc_driver);
+
+MODULE_AUTHOR("Krzysztof Kozlowski <krzk@kernel.org>");
+MODULE_DESCRIPTION("Freescale/NXP Vybrid CRC32 hardware driver");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/crc32poly.h b/include/linux/crc32poly.h
index 62c4b7790a28..ca06942ba75b 100644
--- a/include/linux/crc32poly.h
+++ b/include/linux/crc32poly.h
@@ -17,4 +17,11 @@
  */
 #define CRC32C_POLY_LE 0x82F63B78
 
+/*
+ * CRC16 polynomial as defined by ITU-T V.41 (ITU Telecommunication
+ * Standardization Sector recommendations)
+ * x^16 + x^12 + x^5 + x^0
+ */
+#define CRC16_POLY_BE 0x1021
+
 #endif /* _LINUX_CRC32_POLY_H */
-- 
2.14.1
