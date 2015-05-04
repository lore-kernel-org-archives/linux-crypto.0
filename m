From: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v2 2/7] crypto: add new driver for Marvell CESA
Date: Mon,  4 May 2015 14:27:01 +0200
Message-ID: <1430742426-21202-3-git-send-email-boris.brezillon@free-electrons.com>
References: <1430742426-21202-1-git-send-email-boris.brezillon@free-electrons.com>
Cc: Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>,
	Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
	Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>,
	Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Tawfik Bayouk <tawfik-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
	Lior Amsalem <alior-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
	Nadav Haklai <nadavh-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
	Eran Ben-Avi <benavi-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
	Thomas Petazzoni <thomas.petazzoni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
	Gregory CLEMENT <gregory.clement-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
	Jason Cooper <jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org>,
	Sebastian Hesselbarth <sebastian.hesselbarth-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Andrew Lunn <andrew-g2DYL2Zd6BY@public.gmane.org>,
	linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Arnaud Ebalard <arno-LkuqDEemtHBg9hUCZPvPmw@public.gmane.org>,
	Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430742426-21202-1-git-send-email-boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

The existing mv_cesa driver supports some features of the CESA IP but is
quite limited, and reworking it to support new features (like involving the
TDMA engine to offload the CPU) is almost impossible.
This driver has been rewritten from scratch to take those new features into
account.

This new driver adds support for:
- new armada SoCs (up to 38x) while keeping support for older ones (Orion
  and Kirkwood)
- DMA mode to offload the CPU in case of intensive crypto usage
- new algorithms: SHA256, DES and 3DES

The existing CESA driver is kept around to ease transition to this new
driver (take some time to audit the code and/or wait for users feedback).

Signed-off-by: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Signed-off-by: Arnaud Ebalard <arno-LkuqDEemtHBg9hUCZPvPmw@public.gmane.org>
---
 drivers/crypto/Kconfig          |   17 +
 drivers/crypto/Makefile         |    1 +
 drivers/crypto/marvell/Makefile |    2 +
 drivers/crypto/marvell/cesa.c   |  543 ++++++++++++++++
 drivers/crypto/marvell/cesa.h   |  802 +++++++++++++++++++++++
 drivers/crypto/marvell/cipher.c |  761 ++++++++++++++++++++++
 drivers/crypto/marvell/hash.c   | 1349 +++++++++++++++++++++++++++++++++++++++
 drivers/crypto/marvell/tdma.c   |  223 +++++++
 8 files changed, 3698 insertions(+)
 create mode 100644 drivers/crypto/marvell/Makefile
 create mode 100644 drivers/crypto/marvell/cesa.c
 create mode 100644 drivers/crypto/marvell/cesa.h
 create mode 100644 drivers/crypto/marvell/cipher.c
 create mode 100644 drivers/crypto/marvell/hash.c
 create mode 100644 drivers/crypto/marvell/tdma.c

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 2fb0fdf..f7a6677 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -173,6 +173,23 @@ config CRYPTO_DEV_MV_CESA
 
 	  Currently the driver supports AES in ECB and CBC mode without DMA.
 
+config CRYPTO_DEV_MARVELL_CESA
+	tristate "New Marvell's Cryptographic Engine driver"
+	depends on (PLAT_ORION || ARCH_MVEBU || COMPILE_TEST) && HAS_DMA && HAS_IOMEM
+	select CRYPTO_ALGAPI
+	select CRYPTO_AES
+	select CRYPTO_DES
+	select CRYPTO_BLKCIPHER2
+	select CRYPTO_HASH
+	select SRAM
+	help
+	  This driver allows you to utilize the Cryptographic Engines and
+	  Security Accelerator (CESA) which can be found on several Marvell
+	  SoCs: Armada, Kirkwood and Orion.
+
+	  This driver is a replacement of the mv_cesa driver: it adds support
+	  for DMA and several crypto algorithms (DES, 3DES, SHA256, MD5).
+
 config CRYPTO_DEV_NIAGARA2
        tristate "Niagara2 Stream Processing Unit driver"
        select CRYPTO_DES
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 3924f93..ad07ba7 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_CRYPTO_DEV_GEODE) += geode-aes.o
 obj-$(CONFIG_CRYPTO_DEV_HIFN_795X) += hifn_795x.o
 obj-$(CONFIG_CRYPTO_DEV_IXP4XX) += ixp4xx_crypto.o
 obj-$(CONFIG_CRYPTO_DEV_MV_CESA) += mv_cesa.o
+obj-$(CONFIG_CRYPTO_DEV_MARVELL_CESA) += marvell/
 obj-$(CONFIG_CRYPTO_DEV_MXS_DCP) += mxs-dcp.o
 obj-$(CONFIG_CRYPTO_DEV_NIAGARA2) += n2_crypto.o
 n2_crypto-y := n2_core.o n2_asm.o
diff --git a/drivers/crypto/marvell/Makefile b/drivers/crypto/marvell/Makefile
new file mode 100644
index 0000000..0c12b13
--- /dev/null
+++ b/drivers/crypto/marvell/Makefile
@@ -0,0 +1,2 @@
+obj-$(CONFIG_CRYPTO_DEV_MARVELL_CESA) += marvell-cesa.o
+marvell-cesa-objs := cesa.o cipher.o hash.o tdma.o
diff --git a/drivers/crypto/marvell/cesa.c b/drivers/crypto/marvell/cesa.c
new file mode 100644
index 0000000..fe957a1
--- /dev/null
+++ b/drivers/crypto/marvell/cesa.c
@@ -0,0 +1,543 @@
+/*
+ * Support for Marvell's Cryptographic Engine and Security Accelerator (CESA)
+ * that can be found on the following platform: Orion, Kirkwood, Armada. This
+ * driver supports the TDMA engine on platforms on which it is available.
+ *
+ * Author: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
+ * Author: Arnaud Ebalard <arno-LkuqDEemtHBg9hUCZPvPmw@public.gmane.org>
+ *
+ * This work is based on an initial version written by
+ * Sebastian Andrzej Siewior < sebastian at breakpoint dot cc >
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ */
+
+#include <linux/delay.h>
+#include <linux/genalloc.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/kthread.h>
+#include <linux/mbus.h>
+#include <linux/platform_device.h>
+#include <linux/scatterlist.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/clk.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/of_irq.h>
+
+#include "cesa.h"
+
+static int allhwsupport = !IS_ENABLED(CRYPTO_DEV_MV_CESA);
+module_param_named(allhwsupport, allhwsupport, int, 0444);
+MODULE_PARM_DESC(allhwsupport, "Enable support for all hardware (even it if overlaps with the mv_cesa driver)");
+
+struct mv_cesa_dev *cesa_dev;
+
+static void mv_cesa_dequeue_req_unlocked(struct mv_cesa_engine *engine)
+{
+	struct crypto_async_request *req;
+	struct mv_cesa_ctx *ctx;
+
+	spin_lock_bh(&cesa_dev->lock);
+	req = crypto_dequeue_request(&cesa_dev->queue);
+	engine->req = req;
+	spin_unlock_bh(&cesa_dev->lock);
+
+	if (!req)
+		return;
+
+	ctx = crypto_tfm_ctx(req->tfm);
+	ctx->ops->prepare(req, engine);
+	ctx->ops->step(req);
+}
+
+static irqreturn_t mv_cesa_int(int irq, void *priv)
+{
+	struct mv_cesa_engine *engine = priv;
+	struct crypto_async_request *req;
+	struct mv_cesa_ctx *ctx;
+	u32 status, mask;
+	irqreturn_t ret = IRQ_NONE;
+
+	while (true) {
+		int res;
+
+		mask = mv_cesa_get_int_mask(engine);
+		status = readl(engine->regs + CESA_SA_INT_STATUS);
+
+		if (!(status & mask))
+			break;
+
+		/*
+		 * TODO: avoid clearing the FPGA_INT_STATUS if this not
+		 * relevant on some platforms.
+		 */
+		writel(~status, engine->regs + CESA_SA_FPGA_INT_STATUS);
+		writel(~status, engine->regs + CESA_SA_INT_STATUS);
+
+		ret = IRQ_HANDLED;
+		spin_lock_bh(&engine->lock);
+		req = engine->req;
+		spin_unlock_bh(&engine->lock);
+		if (req) {
+			ctx = crypto_tfm_ctx(req->tfm);
+			res = ctx->ops->process(req, status & mask);
+			if (res != -EINPROGRESS) {
+				spin_lock_bh(&engine->lock);
+				engine->req = NULL;
+				mv_cesa_dequeue_req_unlocked(engine);
+				spin_unlock_bh(&engine->lock);
+				ctx->ops->cleanup(req);
+				local_bh_disable();
+				req->complete(req, res);
+				local_bh_enable();
+			} else {
+				ctx->ops->step(req);
+			}
+		}
+	}
+
+	return ret;
+}
+
+int mv_cesa_queue_req(struct crypto_async_request *req)
+{
+	int ret;
+	int i;
+
+	spin_lock_bh(&cesa_dev->lock);
+	ret = crypto_enqueue_request(&cesa_dev->queue, req);
+	spin_unlock_bh(&cesa_dev->lock);
+
+	if (ret != -EINPROGRESS)
+		return ret;
+
+	for (i = 0; i < cesa_dev->caps->nengines; i++) {
+		spin_lock_bh(&cesa_dev->engines[i].lock);
+		if (!cesa_dev->engines[i].req)
+			mv_cesa_dequeue_req_unlocked(&cesa_dev->engines[i]);
+		spin_unlock_bh(&cesa_dev->engines[i].lock);
+	}
+
+	return -EINPROGRESS;
+}
+
+static int mv_cesa_add_algs(struct mv_cesa_dev *cesa)
+{
+	int ret;
+	int i, j;
+
+	for (i = 0; i < cesa->caps->ncipher_algs; i++) {
+		ret = crypto_register_alg(cesa->caps->cipher_algs[i]);
+		if (ret)
+			goto err_unregister_crypto;
+	}
+
+	for (i = 0; i < cesa->caps->nahash_algs; i++) {
+		ret = crypto_register_ahash(cesa->caps->ahash_algs[i]);
+		if (ret)
+			goto err_unregister_ahash;
+	}
+
+	return 0;
+
+err_unregister_ahash:
+	for (j = 0; j < i; j++)
+		crypto_unregister_ahash(cesa->caps->ahash_algs[j]);
+	i = cesa->caps->ncipher_algs;
+
+err_unregister_crypto:
+	for (j = 0; j < i; j++)
+		crypto_unregister_alg(cesa->caps->cipher_algs[j]);
+
+	return ret;
+}
+
+static void mv_cesa_remove_algs(struct mv_cesa_dev *cesa)
+{
+	int i;
+
+	for (i = 0; i < cesa->caps->nahash_algs; i++)
+		crypto_unregister_ahash(cesa->caps->ahash_algs[i]);
+
+	for (i = 0; i < cesa->caps->ncipher_algs; i++)
+		crypto_unregister_alg(cesa->caps->cipher_algs[i]);
+}
+
+static struct crypto_alg *orion_cipher_algs[] = {
+	&mv_cesa_ecb_des_alg,
+	&mv_cesa_cbc_des_alg,
+	&mv_cesa_ecb_des3_ede_alg,
+	&mv_cesa_cbc_des3_ede_alg,
+	&mv_cesa_ecb_aes_alg,
+	&mv_cesa_cbc_aes_alg,
+};
+
+static struct ahash_alg *orion_ahash_algs[] = {
+	&mv_md5_alg,
+	&mv_sha1_alg,
+	&mv_ahmac_md5_alg,
+	&mv_ahmac_sha1_alg,
+};
+
+static struct crypto_alg *armada_370_cipher_algs[] = {
+	&mv_cesa_ecb_des_alg,
+	&mv_cesa_cbc_des_alg,
+	&mv_cesa_ecb_des3_ede_alg,
+	&mv_cesa_cbc_des3_ede_alg,
+	&mv_cesa_ecb_aes_alg,
+	&mv_cesa_cbc_aes_alg,
+};
+
+static struct ahash_alg *armada_370_ahash_algs[] = {
+	&mv_md5_alg,
+	&mv_sha1_alg,
+	&mv_sha256_alg,
+	&mv_ahmac_md5_alg,
+	&mv_ahmac_sha1_alg,
+	&mv_ahmac_sha256_alg,
+};
+
+static const struct mv_cesa_caps orion_caps = {
+	.nengines = 1,
+	.cipher_algs = orion_cipher_algs,
+	.ncipher_algs = ARRAY_SIZE(orion_cipher_algs),
+	.ahash_algs = orion_ahash_algs,
+	.nahash_algs = ARRAY_SIZE(orion_ahash_algs),
+	.has_tdma = false,
+};
+
+static const struct mv_cesa_caps kirkwood_caps = {
+	.nengines = 1,
+	.cipher_algs = orion_cipher_algs,
+	.ncipher_algs = ARRAY_SIZE(orion_cipher_algs),
+	.ahash_algs = orion_ahash_algs,
+	.nahash_algs = ARRAY_SIZE(orion_ahash_algs),
+	.has_tdma = true,
+};
+
+static const struct mv_cesa_caps armada_370_caps = {
+	.nengines = 1,
+	.cipher_algs = armada_370_cipher_algs,
+	.ncipher_algs = ARRAY_SIZE(armada_370_cipher_algs),
+	.ahash_algs = armada_370_ahash_algs,
+	.nahash_algs = ARRAY_SIZE(armada_370_ahash_algs),
+	.has_tdma = true,
+};
+
+static const struct mv_cesa_caps armada_xp_caps = {
+	.nengines = 2,
+	.cipher_algs = armada_370_cipher_algs,
+	.ncipher_algs = ARRAY_SIZE(armada_370_cipher_algs),
+	.ahash_algs = armada_370_ahash_algs,
+	.nahash_algs = ARRAY_SIZE(armada_370_ahash_algs),
+	.has_tdma = true,
+};
+
+static const struct of_device_id mv_cesa_of_match_table[] = {
+	{ .compatible = "marvell,orion-crypto", .data = &orion_caps },
+	{ .compatible = "marvell,kirkwood-crypto", .data = &kirkwood_caps },
+	{ .compatible = "marvell,armada-370-crypto", .data = &armada_370_caps },
+	{ .compatible = "marvell,armada-xp-crypto", .data = &armada_xp_caps },
+	{ .compatible = "marvell,armada-375-crypto", .data = &armada_xp_caps },
+	{ .compatible = "marvell,armada-38x-crypto", .data = &armada_xp_caps },
+	{}
+};
+MODULE_DEVICE_TABLE(of, mv_cesa_of_match_table);
+
+static void
+mv_cesa_conf_mbus_windows(struct mv_cesa_engine *engine,
+			  const struct mbus_dram_target_info *dram)
+{
+	void __iomem *iobase = engine->regs;
+	int i;
+
+	for (i = 0; i < 4; i++) {
+		writel(0, iobase + CESA_TDMA_WINDOW_CTRL(i));
+		writel(0, iobase + CESA_TDMA_WINDOW_BASE(i));
+	}
+
+	for (i = 0; i < dram->num_cs; i++) {
+		const struct mbus_dram_window *cs = dram->cs + i;
+
+		writel(((cs->size - 1) & 0xffff0000) |
+		       (cs->mbus_attr << 8) |
+		       (dram->mbus_dram_target_id << 4) | 1,
+		       iobase + CESA_TDMA_WINDOW_CTRL(i));
+		writel(cs->base, iobase + CESA_TDMA_WINDOW_BASE(i));
+	}
+}
+
+static int mv_cesa_dev_dma_init(struct mv_cesa_dev *cesa)
+{
+	struct device *dev = cesa->dev;
+	struct mv_cesa_dev_dma *dma;
+
+	if (!cesa->caps->has_tdma)
+		return 0;
+
+	dma = devm_kzalloc(dev, sizeof(*dma), GFP_KERNEL);
+	if (!dma)
+		return -ENOMEM;
+
+	dma->tdma_desc_pool = dmam_pool_create("tdma_desc", dev,
+					sizeof(struct mv_cesa_tdma_desc),
+					16, 0);
+	if (!dma->tdma_desc_pool)
+		return -ENOMEM;
+
+	dma->op_pool = dmam_pool_create("cesa_op", dev,
+					sizeof(struct mv_cesa_op_ctx), 16, 0);
+	if (!dma->op_pool)
+		return -ENOMEM;
+
+	dma->cache_pool = dmam_pool_create("cesa_cache", dev,
+					   CESA_MAX_HASH_BLOCK_SIZE, 1, 0);
+	if (!dma->cache_pool)
+		return -ENOMEM;
+
+	dma->padding_pool = dmam_pool_create("cesa_padding", dev, 72, 1, 0);
+	if (!dma->cache_pool)
+		return -ENOMEM;
+
+	cesa->dma = dma;
+
+	return 0;
+}
+
+static int mv_cesa_get_sram(struct platform_device *pdev, int idx)
+{
+	struct mv_cesa_dev *cesa = platform_get_drvdata(pdev);
+	struct mv_cesa_engine *engine = &cesa->engines[idx];
+	const char *res_name = "sram";
+	struct resource *res;
+
+	engine->pool = of_get_named_gen_pool(cesa->dev->of_node,
+					     "marvell,crypto-srams",
+					     idx);
+	if (engine->pool) {
+		engine->sram = gen_pool_dma_alloc(engine->pool,
+						  cesa->sram_size,
+						  &engine->sram_dma);
+		if (engine->sram)
+			return 0;
+
+		engine->pool = NULL;
+		return -ENOMEM;
+	}
+
+	if (cesa->caps->nengines > 1) {
+		if (!idx)
+			res_name = "sram0";
+		else
+			res_name = "sram1";
+	}
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
+					   res_name);
+	if (!res || resource_size(res) < cesa->sram_size)
+		return -EINVAL;
+
+	engine->sram = devm_ioremap_resource(cesa->dev, res);
+	if (IS_ERR(engine->sram))
+		return PTR_ERR(engine->sram);
+
+	engine->sram_dma = phys_to_dma(cesa->dev,
+				       (phys_addr_t)res->start);
+
+	return 0;
+}
+
+static void mv_cesa_put_sram(struct platform_device *pdev, int idx)
+{
+	struct mv_cesa_dev *cesa = platform_get_drvdata(pdev);
+	struct mv_cesa_engine *engine = &cesa->engines[idx];
+
+	if (!engine->pool)
+		return;
+
+	gen_pool_free(engine->pool, (unsigned long)engine->sram,
+		      cesa->sram_size);
+}
+
+static int mv_cesa_probe(struct platform_device *pdev)
+{
+	const struct mv_cesa_caps *caps = &orion_caps;
+	const struct mbus_dram_target_info *dram;
+	const struct of_device_id *match;
+	struct device *dev = &pdev->dev;
+	struct mv_cesa_dev *cesa;
+	struct mv_cesa_engine *engines;
+	struct resource *res;
+	int irq, ret, i;
+	u32 sram_size;
+
+	if (cesa_dev) {
+		dev_err(&pdev->dev, "Only one CESA device authorized\n");
+		return -EEXIST;
+	}
+
+	if (dev->of_node) {
+		match = of_match_node(mv_cesa_of_match_table, dev->of_node);
+		if (!match || !match->data)
+			return -ENOTSUPP;
+
+		caps = match->data;
+	}
+
+	if ((caps == &orion_caps || caps == &kirkwood_caps) && !allhwsupport)
+		return -ENOTSUPP;
+
+	cesa = devm_kzalloc(dev, sizeof(*cesa), GFP_KERNEL);
+	if (!cesa)
+		return -ENOMEM;
+
+	cesa->caps = caps;
+	cesa->dev = dev;
+
+	sram_size = CESA_SA_DEFAULT_SRAM_SIZE;
+	of_property_read_u32(cesa->dev->of_node, "marvell,crypto-sram-size",
+			     &sram_size);
+	if (sram_size < CESA_SA_MIN_SRAM_SIZE)
+		sram_size = CESA_SA_MIN_SRAM_SIZE;
+
+	cesa->sram_size = sram_size;
+	cesa->engines = devm_kzalloc(dev, caps->nengines * sizeof(*engines),
+				     GFP_KERNEL);
+	if (!cesa->engines)
+		return -ENOMEM;
+
+	spin_lock_init(&cesa->lock);
+	crypto_init_queue(&cesa->queue, 50);
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "regs");
+	cesa->regs = devm_ioremap_resource(dev, res);
+	if (IS_ERR(cesa->regs))
+		return -ENOMEM;
+
+	ret = mv_cesa_dev_dma_init(cesa);
+	if (ret)
+		return ret;
+
+	dram = mv_mbus_dram_info();
+
+	platform_set_drvdata(pdev, cesa);
+
+	for (i = 0; i < caps->nengines; i++) {
+		struct mv_cesa_engine *engine = &cesa->engines[i];
+		char res_name[7];
+
+		engine->id = i;
+		spin_lock_init(&engine->lock);
+
+		ret = mv_cesa_get_sram(pdev, i);
+		if (ret)
+			goto err_cleanup;
+
+		irq = platform_get_irq(pdev, i);
+		if (irq < 0) {
+			ret = irq;
+			goto err_cleanup;
+		}
+
+		/*
+		 * Not all platforms can gate the CESA clocks: do not complain
+		 * if the clock does not exist.
+		 */
+		snprintf(res_name, sizeof(res_name), "cesa%d", i);
+		engine->clk = devm_clk_get(dev, res_name);
+		if (IS_ERR(engine->clk)) {
+			engine->clk = devm_clk_get(dev, NULL);
+			if (IS_ERR(engine->clk))
+				engine->clk = NULL;
+		}
+
+		snprintf(res_name, sizeof(res_name), "cesaz%d", i);
+		engine->zclk = devm_clk_get(dev, res_name);
+		if (IS_ERR(engine->zclk))
+			engine->zclk = NULL;
+
+		ret = clk_prepare_enable(engine->clk);
+		if (ret)
+			goto err_cleanup;
+
+		ret = clk_prepare_enable(engine->zclk);
+		if (ret)
+			goto err_cleanup;
+
+		engine->regs = cesa->regs + CESA_ENGINE_OFF(i);
+
+		if (dram && cesa->caps->has_tdma)
+			mv_cesa_conf_mbus_windows(&cesa->engines[i], dram);
+
+		writel(0, cesa->engines[i].regs + CESA_SA_INT_STATUS);
+		writel(CESA_SA_CFG_STOP_DIG_ERR,
+		       cesa->engines[i].regs + CESA_SA_CFG);
+		writel(engine->sram_dma & CESA_SA_SRAM_MSK,
+		       cesa->engines[i].regs + CESA_SA_DESC_P0);
+
+		ret = devm_request_threaded_irq(dev, irq, NULL, mv_cesa_int,
+						IRQF_ONESHOT,
+						dev_name(&pdev->dev),
+						&cesa->engines[i]);
+		if (ret)
+			goto err_cleanup;
+	}
+
+	cesa_dev = cesa;
+
+	ret = mv_cesa_add_algs(cesa);
+	if (ret) {
+		cesa_dev = NULL;
+		goto err_cleanup;
+	}
+
+	dev_info(dev, "CESA device successfully registered\n");
+
+	return 0;
+
+err_cleanup:
+	for (i = 0; i < caps->nengines; i++) {
+		clk_disable_unprepare(cesa->engines[i].zclk);
+		clk_disable_unprepare(cesa->engines[i].clk);
+		mv_cesa_put_sram(pdev, i);
+	}
+
+	return ret;
+}
+
+static int mv_cesa_remove(struct platform_device *pdev)
+{
+	struct mv_cesa_dev *cesa = platform_get_drvdata(pdev);
+	int i;
+
+	mv_cesa_remove_algs(cesa);
+
+	for (i = 0; i < cesa->caps->nengines; i++) {
+		clk_disable_unprepare(cesa->engines[i].zclk);
+		clk_disable_unprepare(cesa->engines[i].clk);
+		mv_cesa_put_sram(pdev, i);
+	}
+
+	return 0;
+}
+
+static struct platform_driver marvell_cesa = {
+	.probe		= mv_cesa_probe,
+	.remove		= mv_cesa_remove,
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= "marvell-cesa",
+		.of_match_table = mv_cesa_of_match_table,
+	},
+};
+module_platform_driver(marvell_cesa);
+
+MODULE_ALIAS("platform:mv_crypto");
+MODULE_AUTHOR("Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>");
+MODULE_AUTHOR("Arnaud Ebalard <arno-LkuqDEemtHBg9hUCZPvPmw@public.gmane.org>");
+MODULE_DESCRIPTION("Support for Marvell's cryptographic engine");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/crypto/marvell/cesa.h b/drivers/crypto/marvell/cesa.h
new file mode 100644
index 0000000..263bdc7
--- /dev/null
+++ b/drivers/crypto/marvell/cesa.h
@@ -0,0 +1,802 @@
+#ifndef __MARVELL_CESA_H__
+#define __MARVELL_CESA_H__
+
+#include <crypto/algapi.h>
+#include <crypto/hash.h>
+#include <crypto/internal/hash.h>
+
+#include <linux/crypto.h>
+#include <linux/dmapool.h>
+
+#define CESA_ENGINE_OFF(i)			(((i) * 0x2000))
+
+#define CESA_TDMA_BYTE_CNT			0x800
+#define CESA_TDMA_SRC_ADDR			0x810
+#define CESA_TDMA_DST_ADDR			0x820
+#define CESA_TDMA_NEXT_ADDR			0x830
+
+#define CESA_TDMA_CONTROL			0x840
+#define CESA_TDMA_DST_BURST			GENMASK(2, 0)
+#define CESA_TDMA_DST_BURST_32B			3
+#define CESA_TDMA_DST_BURST_128B		4
+#define CESA_TDMA_OUT_RD_EN			BIT(4)
+#define CESA_TDMA_SRC_BURST			GENMASK(8, 6)
+#define CESA_TDMA_SRC_BURST_32B			(3 << 6)
+#define CESA_TDMA_SRC_BURST_128B		(4 << 6)
+#define CESA_TDMA_CHAIN				BIT(9)
+#define CESA_TDMA_BYTE_SWAP			BIT(11)
+#define CESA_TDMA_NO_BYTE_SWAP			BIT(11)
+#define CESA_TDMA_EN				BIT(12)
+#define CESA_TDMA_FETCH_ND			BIT(13)
+#define CESA_TDMA_ACT				BIT(14)
+
+#define CESA_TDMA_CUR				0x870
+#define CESA_TDMA_ERROR_CAUSE			0x8c8
+#define CESA_TDMA_ERROR_MSK			0x8cc
+
+#define CESA_TDMA_WINDOW_BASE(x)		(((x) * 0x8) + 0xa00)
+#define CESA_TDMA_WINDOW_CTRL(x)		(((x) * 0x8) + 0xa04)
+
+#define CESA_IVDIG(x)				(0xdd00 + ((x) * 4) +	\
+						 (((x) < 5) ? 0 : 0x14))
+
+#define CESA_SA_CMD				0xde00
+#define CESA_SA_CMD_EN_CESA_SA_ACCL0		BIT(0)
+#define CESA_SA_CMD_EN_CESA_SA_ACCL1		BIT(1)
+#define CESA_SA_CMD_DISABLE_SEC			BIT(2)
+
+#define CESA_SA_DESC_P0				0xde04
+
+#define CESA_SA_DESC_P1				0xde14
+
+#define CESA_SA_CFG				0xde08
+#define CESA_SA_CFG_STOP_DIG_ERR		GENMASK(1, 0)
+#define CESA_SA_CFG_DIG_ERR_CONT		0
+#define CESA_SA_CFG_DIG_ERR_SKIP		1
+#define CESA_SA_CFG_DIG_ERR_STOP		3
+#define CESA_SA_CFG_CH0_W_IDMA			BIT(7)
+#define CESA_SA_CFG_CH1_W_IDMA			BIT(8)
+#define CESA_SA_CFG_ACT_CH0_IDMA		BIT(9)
+#define CESA_SA_CFG_ACT_CH1_IDMA		BIT(10)
+#define CESA_SA_CFG_MULTI_PKT			BIT(11)
+#define CESA_SA_CFG_PARA_DIS			BIT(13)
+
+#define CESA_SA_ACCEL_STATUS			0xde0c
+#define CESA_SA_ST_ACT_0			BIT(0)
+#define CESA_SA_ST_ACT_1			BIT(1)
+
+/*
+ * CESA_SA_FPGA_INT_STATUS looks like a FPGA leftover and is documented only
+ * in Errata 4.12. It looks like that it was part of an IRQ-controller in FPGA
+ * and someone forgot to remove  it while switching to the core and moving to
+ * CESA_SA_INT_STATUS.
+ */
+#define CESA_SA_FPGA_INT_STATUS			0xdd68
+#define CESA_SA_INT_STATUS			0xde20
+#define CESA_SA_INT_AUTH_DONE			BIT(0)
+#define CESA_SA_INT_DES_E_DONE			BIT(1)
+#define CESA_SA_INT_AES_E_DONE			BIT(2)
+#define CESA_SA_INT_AES_D_DONE			BIT(3)
+#define CESA_SA_INT_ENC_DONE			BIT(4)
+#define CESA_SA_INT_ACCEL0_DONE			BIT(5)
+#define CESA_SA_INT_ACCEL1_DONE			BIT(6)
+#define CESA_SA_INT_ACC0_IDMA_DONE		BIT(7)
+#define CESA_SA_INT_ACC1_IDMA_DONE		BIT(8)
+#define CESA_SA_INT_IDMA_DONE			BIT(9)
+#define CESA_SA_INT_IDMA_OWN_ERR		BIT(10)
+
+#define CESA_SA_INT_MSK				0xde24
+
+#define CESA_SA_DESC_CFG_OP_MAC_ONLY		0
+#define CESA_SA_DESC_CFG_OP_CRYPT_ONLY		1
+#define CESA_SA_DESC_CFG_OP_MAC_CRYPT		2
+#define CESA_SA_DESC_CFG_OP_CRYPT_MAC		3
+#define CESA_SA_DESC_CFG_OP_MSK			GENMASK(1, 0)
+#define CESA_SA_DESC_CFG_MACM_SHA256		(1 << 4)
+#define CESA_SA_DESC_CFG_MACM_HMAC_SHA256	(3 << 4)
+#define CESA_SA_DESC_CFG_MACM_MD5		(4 << 4)
+#define CESA_SA_DESC_CFG_MACM_SHA1		(5 << 4)
+#define CESA_SA_DESC_CFG_MACM_HMAC_MD5		(6 << 4)
+#define CESA_SA_DESC_CFG_MACM_HMAC_SHA1		(7 << 4)
+#define CESA_SA_DESC_CFG_MACM_MSK		GENMASK(6, 4)
+#define CESA_SA_DESC_CFG_CRYPTM_DES		(1 << 8)
+#define CESA_SA_DESC_CFG_CRYPTM_3DES		(2 << 8)
+#define CESA_SA_DESC_CFG_CRYPTM_AES		(3 << 8)
+#define CESA_SA_DESC_CFG_CRYPTM_MSK		GENMASK(9, 8)
+#define CESA_SA_DESC_CFG_DIR_ENC		(0 << 12)
+#define CESA_SA_DESC_CFG_DIR_DEC		(1 << 12)
+#define CESA_SA_DESC_CFG_CRYPTCM_ECB		(0 << 16)
+#define CESA_SA_DESC_CFG_CRYPTCM_CBC		(1 << 16)
+#define CESA_SA_DESC_CFG_CRYPTCM_MSK		BIT(16)
+#define CESA_SA_DESC_CFG_3DES_EEE		(0 << 20)
+#define CESA_SA_DESC_CFG_3DES_EDE		(1 << 20)
+#define CESA_SA_DESC_CFG_AES_LEN_128		(0 << 24)
+#define CESA_SA_DESC_CFG_AES_LEN_192		(1 << 24)
+#define CESA_SA_DESC_CFG_AES_LEN_256		(2 << 24)
+#define CESA_SA_DESC_CFG_AES_LEN_MSK		GENMASK(25, 24)
+#define CESA_SA_DESC_CFG_NOT_FRAG		(0 << 30)
+#define CESA_SA_DESC_CFG_FIRST_FRAG		(1 << 30)
+#define CESA_SA_DESC_CFG_LAST_FRAG		(2 << 30)
+#define CESA_SA_DESC_CFG_MID_FRAG		(3 << 30)
+#define CESA_SA_DESC_CFG_FRAG_MSK		GENMASK(31, 30)
+
+/*
+ * /-----------\ 0
+ * | ACCEL CFG |	4 * 8
+ * |-----------| 0x20
+ * | CRYPT KEY |	8 * 4
+ * |-----------| 0x40
+ * |  IV   IN  |	4 * 4
+ * |-----------| 0x40 (inplace)
+ * |  IV BUF   |	4 * 4
+ * |-----------| 0x80
+ * |  DATA IN  |	16 * x (max ->max_req_size)
+ * |-----------| 0x80 (inplace operation)
+ * |  DATA OUT |	16 * x (max ->max_req_size)
+ * \-----------/ SRAM size
+ */
+
+/*
+ * Hashing memory map:
+ * /-----------\ 0
+ * | ACCEL CFG |        4 * 8
+ * |-----------| 0x20
+ * | Inner IV  |        8 * 4
+ * |-----------| 0x40
+ * | Outer IV  |        8 * 4
+ * |-----------| 0x60
+ * | Output BUF|        8 * 4
+ * |-----------| 0x80
+ * |  DATA IN  |        64 * x (max ->max_req_size)
+ * \-----------/ SRAM size
+ */
+
+#define CESA_SA_CFG_SRAM_OFFSET			0x00
+#define CESA_SA_DATA_SRAM_OFFSET		0x80
+
+#define CESA_SA_CRYPT_KEY_SRAM_OFFSET		0x20
+#define CESA_SA_CRYPT_IV_SRAM_OFFSET		0x40
+
+#define CESA_SA_MAC_IIV_SRAM_OFFSET		0x20
+#define CESA_SA_MAC_OIV_SRAM_OFFSET		0x40
+#define CESA_SA_MAC_DIG_SRAM_OFFSET		0x60
+
+#define CESA_SA_DESC_CRYPT_DATA(offset)					\
+	cpu_to_le32((CESA_SA_DATA_SRAM_OFFSET + (offset)) |		\
+		    ((CESA_SA_DATA_SRAM_OFFSET + (offset)) << 16))
+
+#define CESA_SA_DESC_CRYPT_IV(offset)					\
+	cpu_to_le32((CESA_SA_CRYPT_IV_SRAM_OFFSET + (offset)) |	\
+		    ((CESA_SA_CRYPT_IV_SRAM_OFFSET + (offset)) << 16))
+
+#define CESA_SA_DESC_CRYPT_KEY(offset)					\
+	cpu_to_le32(CESA_SA_CRYPT_KEY_SRAM_OFFSET + (offset))
+
+#define CESA_SA_DESC_MAC_DATA(offset)					\
+	cpu_to_le32(CESA_SA_DATA_SRAM_OFFSET + (offset))
+#define CESA_SA_DESC_MAC_DATA_MSK		GENMASK(15, 0)
+
+#define CESA_SA_DESC_MAC_TOTAL_LEN(total_len)	cpu_to_le32((total_len) << 16)
+#define CESA_SA_DESC_MAC_TOTAL_LEN_MSK		GENMASK(31, 16)
+
+#define CESA_SA_DESC_MAC_SRC_TOTAL_LEN_MAX	0xffff
+
+#define CESA_SA_DESC_MAC_DIGEST(offset)					\
+	cpu_to_le32(CESA_SA_MAC_DIG_SRAM_OFFSET + (offset))
+#define CESA_SA_DESC_MAC_DIGEST_MSK		GENMASK(15, 0)
+
+#define CESA_SA_DESC_MAC_FRAG_LEN(frag_len)	cpu_to_le32((frag_len) << 16)
+#define CESA_SA_DESC_MAC_FRAG_LEN_MSK		GENMASK(31, 16)
+
+#define CESA_SA_DESC_MAC_IV(offset)					\
+	cpu_to_le32((CESA_SA_MAC_IIV_SRAM_OFFSET + (offset)) |		\
+		    ((CESA_SA_MAC_OIV_SRAM_OFFSET + (offset)) << 16))
+
+#define CESA_SA_SRAM_SIZE			2048
+#define CESA_SA_SRAM_PAYLOAD_SIZE		(cesa_dev->sram_size - \
+						 CESA_SA_DATA_SRAM_OFFSET)
+
+#define CESA_SA_DEFAULT_SRAM_SIZE		2048
+#define CESA_SA_MIN_SRAM_SIZE			1024
+
+#define CESA_SA_SRAM_MSK			(2048 - 1)
+
+#define CESA_MAX_HASH_BLOCK_SIZE		64
+#define CESA_HASH_BLOCK_SIZE_MSK		(CESA_MAX_HASH_BLOCK_SIZE - 1)
+
+/**
+ * struct mv_cesa_sec_accel_desc - security accelerator descriptor
+ * @config:	engine config
+ * @enc_p:	input and output data pointers for a cipher operation
+ * @enc_len:	cipher operation length
+ * @enc_key_p:	cipher key pointer
+ * @enc_iv:	cipher IV pointers
+ * @mac_src_p:	input pointer and total hash length
+ * @mac_digest:	digest pointer and hash operation length
+ * @mac_iv:	hmac IV pointers
+ *
+ * Structure passed to the CESA engine to describe the crypto operation
+ * to be executed.
+ */
+struct mv_cesa_sec_accel_desc {
+	u32 config;
+	u32 enc_p;
+	u32 enc_len;
+	u32 enc_key_p;
+	u32 enc_iv;
+	u32 mac_src_p;
+	u32 mac_digest;
+	u32 mac_iv;
+} __packed;
+
+/**
+ * struct mv_cesa_blkcipher_op_ctx - cipher operation context
+ * @key:	cipher key
+ * @iv:		cipher IV
+ *
+ * Context associated to a cipher operation.
+ */
+struct mv_cesa_blkcipher_op_ctx {
+	u32 key[8];
+	u32 iv[4];
+};
+
+/**
+ * struct mv_cesa_hash_op_ctx - hash or hmac operation context
+ * @key:	cipher key
+ * @iv:		cipher IV
+ *
+ * Context associated to an hash or hmac operation.
+ */
+struct mv_cesa_hash_op_ctx {
+	u32 iv[16];
+	u32 hash[8];
+};
+
+/**
+ * struct mv_cesa_op_ctx - crypto operation context
+ * @desc:	CESA descriptor
+ * @ctx:	context associated to the crypto operation
+ *
+ * Context associated to a crypto operation.
+ */
+struct mv_cesa_op_ctx {
+	struct mv_cesa_sec_accel_desc desc;
+	union {
+		struct mv_cesa_blkcipher_op_ctx blkcipher;
+		struct mv_cesa_hash_op_ctx hash;
+	} ctx;
+};
+
+/* TDMA descriptor flags */
+#define CESA_TDMA_DST_IN_SRAM			BIT(31)
+#define CESA_TDMA_SRC_IN_SRAM			BIT(30)
+#define CESA_TDMA_TYPE_MSK			GENMASK(29, 0)
+#define CESA_TDMA_DUMMY				0
+#define CESA_TDMA_DATA				1
+#define CESA_TDMA_OP				2
+
+/**
+ * struct mv_cesa_tdma_desc - TDMA descriptor
+ * @byte_cnt:	number of bytes to transfer
+ * @src:	DMA address of the source
+ * @dst:	DMA address of the destination
+ * @next_dma:	DMA address of the next TDMA descriptor
+ * @cur_dma:	DMA address of this TDMA descriptor
+ * @next:	pointer to the next TDMA descriptor
+ * @op:		CESA operation attached to this TDMA descriptor
+ * @data:	raw data attached to this TDMA descriptor
+ * @flags:	flags describing the TDMA transfer. See the
+ *		"TDMA descriptor flags" section above
+ *
+ * TDMA descriptor used to create a transfer chain describing a crypto
+ * operation.
+ */
+struct mv_cesa_tdma_desc {
+	u32 byte_cnt;
+	u32 src;
+	u32 dst;
+	u32 next_dma;
+	u32 cur_dma;
+	struct mv_cesa_tdma_desc *next;
+	union {
+		struct mv_cesa_op_ctx *op;
+		void *data;
+	};
+	u32 flags;
+};
+
+/**
+ * struct mv_cesa_sg_dma_iter - scatter-gather iterator
+ * @dir:	transfer direction
+ * @sg:		scatter list
+ * @offset:	current position in the scatter list
+ * @op_offset:	current position in the crypto operation
+ *
+ * Iterator used to iterate over a scatterlist while creating a TDMA chain for
+ * a crypto operation.
+ */
+struct mv_cesa_sg_dma_iter {
+	enum dma_data_direction dir;
+	struct scatterlist *sg;
+	unsigned int offset;
+	unsigned int op_offset;
+};
+
+/**
+ * struct mv_cesa_dma_iter - crypto operation iterator
+ * @len:	the crypto operation length
+ * @offset:	current position in the crypto operation
+ * @op_len:	sub-operation length (the crypto engine can only act on 2kb
+ *		chunks)
+ *
+ * Iterator used to create a TDMA chain for a given crypto operation.
+ */
+struct mv_cesa_dma_iter {
+	unsigned int len;
+	unsigned int offset;
+	unsigned int op_len;
+};
+
+/**
+ * struct mv_cesa_tdma_chain - TDMA chain
+ * @first:	first entry in the TDMA chain
+ * @last:	last entry in the TDMA chain
+ *
+ * Stores a TDMA chain for a specific crypto operation.
+ */
+struct mv_cesa_tdma_chain {
+	struct mv_cesa_tdma_desc *first;
+	struct mv_cesa_tdma_desc *last;
+};
+
+struct mv_cesa_engine;
+
+/**
+ * struct mv_cesa_caps - CESA device capabilities
+ * @engines:		number of engines
+ * @has_tdma:		whether this device has a TDMA block
+ * @cipher_algs:	supported cipher algorithms
+ * @ncipher_algs:	number of supported cipher algorithms
+ * @ahash_algs:		supported hash algorithms
+ * @nahash_algs:	number of supported hash algorithms
+ *
+ * Structure used to describe CESA device capabilities.
+ */
+struct mv_cesa_caps {
+	int nengines;
+	bool has_tdma;
+	struct crypto_alg **cipher_algs;
+	int ncipher_algs;
+	struct ahash_alg **ahash_algs;
+	int nahash_algs;
+};
+
+/**
+ * struct mv_cesa_dev_dma - DMA pools
+ * @tdma_desc_pool:	TDMA desc pool
+ * @op_pool:		crypto operation pool
+ * @cache_pool:		data cache pool (used by hash implementation when the
+ *			hash request is smaller than the hash block size)
+ * @padding_pool:	padding pool (used by hash implementation when hardware
+ *			padding cannot be used)
+ *
+ * Structure containing the different DMA pools used by this driver.
+ */
+struct mv_cesa_dev_dma {
+	struct dma_pool *tdma_desc_pool;
+	struct dma_pool *op_pool;
+	struct dma_pool *cache_pool;
+	struct dma_pool *padding_pool;
+};
+
+/**
+ * struct mv_cesa_dev - CESA device
+ * @caps:	device capabilities
+ * @regs:	device registers
+ * @sram_size:	usable SRAM size
+ * @lock:	device lock
+ * @queue:	crypto request queue
+ * @engines:	array of engines
+ * @dma:	dma pools
+ *
+ * Structure storing CESA device information.
+ */
+struct mv_cesa_dev {
+	const struct mv_cesa_caps *caps;
+	void __iomem *regs;
+	struct device *dev;
+	unsigned int sram_size;
+	spinlock_t lock;
+	struct crypto_queue queue;
+	struct mv_cesa_engine *engines;
+	struct mv_cesa_dev_dma *dma;
+};
+
+/**
+ * struct mv_cesa_engine - CESA engine
+ * @id:			engine id
+ * @regs:		engine registers
+ * @sram:		SRAM memory region
+ * @sram_dma:		DMA address of the SRAM memory region
+ * @lock:		engine lock
+ * @req:		current crypto request
+ * @clk:		engine clk
+ * @zclk:		engine zclk
+ * @max_req_len:	maximum chunk length (useful to create the TDMA chain)
+ * @int_mask:		interrupt mask cache
+ * @pool:		memory pool pointing to the memory region reserved in
+ *			SRAM
+ *
+ * Structure storing CESA engine information.
+ */
+struct mv_cesa_engine {
+	int id;
+	void __iomem *regs;
+	void __iomem *sram;
+	dma_addr_t sram_dma;
+	spinlock_t lock;
+	struct crypto_async_request *req;
+	struct clk *clk;
+	struct clk *zclk;
+	size_t max_req_len;
+	u32 int_mask;
+	struct gen_pool *pool;
+};
+
+/**
+ * struct mv_cesa_req_ops - CESA request operations
+ * @prepare:	prepare a request to be executed on the specified engine
+ * @process:	process a request chunk result (should return 0 if the
+ *		operation, -EINPROGRESS if it needs more steps or an error
+ *		code)
+ * @step:	launch the crypto operation on the next chunk
+ * @cleanup:	cleanup the crypto request (release associated data)
+ */
+struct mv_cesa_req_ops {
+	void (*prepare)(struct crypto_async_request *req,
+			struct mv_cesa_engine *engine);
+	int (*process)(struct crypto_async_request *req, u32 status);
+	void (*step)(struct crypto_async_request *req);
+	void (*cleanup)(struct crypto_async_request *req);
+};
+
+/**
+ * struct mv_cesa_ctx - CESA operation context
+ * @ops:	crypto operations
+ *
+ * Base context structure inherited by operation specific ones.
+ */
+struct mv_cesa_ctx {
+	const struct mv_cesa_req_ops *ops;
+};
+
+/**
+ * struct mv_cesa_hash_ctx - CESA hash operation context
+ * @base:	base context structure
+ *
+ * Hash context structure.
+ */
+struct mv_cesa_hash_ctx {
+	struct mv_cesa_ctx base;
+};
+
+/**
+ * struct mv_cesa_hash_ctx - CESA hmac operation context
+ * @base:	base context structure
+ * @iv:		initialization vectors
+ *
+ * HMAC context structure.
+ */
+struct mv_cesa_hmac_ctx {
+	struct mv_cesa_ctx base;
+	u32 iv[16];
+};
+
+/**
+ * enum mv_cesa_req_type - request type definitions
+ * @CESA_STD_REQ:	standard request
+ * @CESA_DMA_REQ:	DMA request
+ */
+enum mv_cesa_req_type {
+	CESA_STD_REQ,
+	CESA_DMA_REQ,
+};
+
+/**
+ * struct mv_cesa_req - CESA request
+ * @type:	request type
+ * @engine:	engine associated with this request
+ */
+struct mv_cesa_req {
+	enum mv_cesa_req_type type;
+	struct mv_cesa_engine *engine;
+};
+
+/**
+ * struct mv_cesa_tdma_req - CESA TDMA request
+ * @base:	base information
+ * @chain:	TDMA chain
+ */
+struct mv_cesa_tdma_req {
+	struct mv_cesa_req base;
+	struct mv_cesa_tdma_chain chain;
+};
+
+/**
+ * struct mv_cesa_sg_std_iter - CESA scatter-gather iterator for standard
+ *				requests
+ * @iter:	sg mapping iterator
+ * @offset:	current offset in the SG entry mapped in memory
+ */
+struct mv_cesa_sg_std_iter {
+	struct sg_mapping_iter iter;
+	unsigned int offset;
+};
+
+/**
+ * struct mv_cesa_ablkcipher_std_req - cipher standard request
+ * @base:	base information
+ * @op:		operation context
+ * @offset:	current operation offset
+ * @size:	size of the crypto operation
+ */
+struct mv_cesa_ablkcipher_std_req {
+	struct mv_cesa_req base;
+	struct mv_cesa_op_ctx op;
+	unsigned int offset;
+	unsigned int size;
+};
+
+/**
+ * struct mv_cesa_ablkcipher_req - cipher request
+ * @req:	type specific request information
+ * @src_nents:	number of entries in the src sg list
+ * @dst_nents:	number of entries in the dest sg list
+ */
+struct mv_cesa_ablkcipher_req {
+	union {
+		struct mv_cesa_req base;
+		struct mv_cesa_tdma_req dma;
+		struct mv_cesa_ablkcipher_std_req std;
+	} req;
+	int src_nents;
+	int dst_nents;
+};
+
+/**
+ * struct mv_cesa_ahash_std_req - standard hash request
+ * @base:	base information
+ * @offset:	current operation offset
+ */
+struct mv_cesa_ahash_std_req {
+	struct mv_cesa_req base;
+	unsigned int offset;
+};
+
+/**
+ * struct mv_cesa_ahash_dma_req - DMA hash request
+ * @base:		base information
+ * @padding:		padding buffer
+ * @padding_dma:	DMA address of the padding buffer
+ * @cache_dma:		DMA address of the cache buffer
+ */
+struct mv_cesa_ahash_dma_req {
+	struct mv_cesa_tdma_req base;
+	u8 *padding;
+	dma_addr_t padding_dma;
+	dma_addr_t cache_dma;
+};
+
+/**
+ * struct mv_cesa_ahash_req - hash request
+ * @req:		type specific request information
+ * @cache:		cache buffer
+ * @cache_ptr:		write pointer in the cache buffer
+ * @len:		hash total length
+ * @src_nents:		number of entries in the scatterlist
+ * @last_req:		define whether the current operation is the last one
+ *			or not
+ * @state:		hash state
+ */
+struct mv_cesa_ahash_req {
+	union {
+		struct mv_cesa_req base;
+		struct mv_cesa_ahash_dma_req dma;
+		struct mv_cesa_ahash_std_req std;
+	} req;
+	struct mv_cesa_op_ctx op_tmpl;
+	u8 *cache;
+	unsigned int cache_ptr;
+	u64 len;
+	int src_nents;
+	bool last_req;
+	__be32 state[8];
+};
+
+/* CESA functions */
+
+extern struct mv_cesa_dev *cesa_dev;
+
+static inline void mv_cesa_update_op_cfg(struct mv_cesa_op_ctx *op,
+					 u32 cfg, u32 mask)
+{
+	op->desc.config &= cpu_to_le32(~mask);
+	op->desc.config |= cpu_to_le32(cfg);
+}
+
+static inline u32 mv_cesa_get_op_cfg(struct mv_cesa_op_ctx *op)
+{
+	return le32_to_cpu(op->desc.config);
+}
+
+static inline void mv_cesa_set_op_cfg(struct mv_cesa_op_ctx *op, u32 cfg)
+{
+	op->desc.config = cpu_to_le32(cfg);
+}
+
+static inline void mv_cesa_adjust_op(struct mv_cesa_engine *engine,
+				     struct mv_cesa_op_ctx *op)
+{
+	u32 offset = engine->sram_dma & CESA_SA_SRAM_MSK;
+
+	op->desc.enc_p = CESA_SA_DESC_CRYPT_DATA(offset);
+	op->desc.enc_key_p = CESA_SA_DESC_CRYPT_KEY(offset);
+	op->desc.enc_iv = CESA_SA_DESC_CRYPT_IV(offset);
+	op->desc.mac_src_p &= ~CESA_SA_DESC_MAC_DATA_MSK;
+	op->desc.mac_src_p |= CESA_SA_DESC_MAC_DATA(offset);
+	op->desc.mac_digest &= ~CESA_SA_DESC_MAC_DIGEST_MSK;
+	op->desc.mac_digest |= CESA_SA_DESC_MAC_DIGEST(offset);
+	op->desc.mac_iv = CESA_SA_DESC_MAC_IV(offset);
+}
+
+static inline void mv_cesa_set_crypt_op_len(struct mv_cesa_op_ctx *op, int len)
+{
+	op->desc.enc_len = cpu_to_le32(len);
+}
+
+static inline void mv_cesa_set_mac_op_total_len(struct mv_cesa_op_ctx *op,
+						int len)
+{
+	op->desc.mac_src_p &= ~CESA_SA_DESC_MAC_TOTAL_LEN_MSK;
+	op->desc.mac_src_p |= CESA_SA_DESC_MAC_TOTAL_LEN(len);
+}
+
+static inline void mv_cesa_set_mac_op_frag_len(struct mv_cesa_op_ctx *op,
+					       int len)
+{
+	op->desc.mac_digest &= ~CESA_SA_DESC_MAC_FRAG_LEN_MSK;
+	op->desc.mac_digest |= CESA_SA_DESC_MAC_FRAG_LEN(len);
+}
+
+static inline void mv_cesa_set_int_mask(struct mv_cesa_engine *engine,
+					u32 int_mask)
+{
+	if (int_mask == engine->int_mask)
+		return;
+
+	writel(int_mask, engine->regs + CESA_SA_INT_MSK);
+	engine->int_mask = int_mask;
+}
+
+static inline u32 mv_cesa_get_int_mask(struct mv_cesa_engine *engine)
+{
+	return engine->int_mask;
+}
+
+int mv_cesa_queue_req(struct crypto_async_request *req);
+
+static inline int mv_cesa_sg_count(struct scatterlist *sg, int nbytes)
+{
+	int nents = 0;
+
+	while (nbytes > 0) {
+		nents++;
+		nbytes -= sg->length;
+		sg = sg_next(sg);
+	}
+
+	return nents;
+}
+
+/* TDMA functions */
+
+static inline void mv_cesa_req_dma_iter_init(struct mv_cesa_dma_iter *iter,
+					     unsigned int len)
+{
+	iter->len = len;
+	iter->op_len = min(len, CESA_SA_SRAM_PAYLOAD_SIZE);
+	iter->offset = 0;
+}
+
+static inline void mv_cesa_sg_dma_iter_init(struct mv_cesa_sg_dma_iter *iter,
+					    struct scatterlist *sg,
+					    enum dma_data_direction dir)
+{
+	iter->op_offset = 0;
+	iter->offset = 0;
+	iter->sg = sg;
+	iter->dir = dir;
+}
+
+static inline unsigned int
+mv_cesa_req_dma_iter_transfer_len(struct mv_cesa_dma_iter *iter,
+				  struct mv_cesa_sg_dma_iter *sgiter)
+{
+	return min(iter->op_len - sgiter->op_offset,
+		   sgiter->sg->length - sgiter->offset);
+}
+
+bool mv_cesa_req_dma_iter_next_transfer(struct mv_cesa_dma_iter *chain,
+				    struct mv_cesa_sg_dma_iter *sgiter,
+				    unsigned int len);
+
+static inline bool mv_cesa_req_dma_iter_next_op(struct mv_cesa_dma_iter *iter)
+{
+	iter->offset += iter->op_len;
+	iter->op_len = min(iter->len - iter->offset,
+			   CESA_SA_SRAM_PAYLOAD_SIZE);
+
+	return iter->op_len;
+}
+
+void mv_cesa_dma_step(struct mv_cesa_tdma_req *dreq);
+
+static inline int mv_cesa_dma_process(struct mv_cesa_tdma_req *dreq,
+				      u32 status)
+{
+	if (!(status & CESA_SA_INT_ACC0_IDMA_DONE))
+		return -EINPROGRESS;
+
+	if (status & CESA_SA_INT_IDMA_OWN_ERR)
+		return -EINVAL;
+
+	return 0;
+}
+
+void mv_cesa_dma_prepare(struct mv_cesa_tdma_req *dreq,
+			 struct mv_cesa_engine *engine);
+
+void mv_cesa_dma_cleanup(struct mv_cesa_tdma_req *dreq);
+
+static inline void
+mv_cesa_tdma_desc_iter_init(struct mv_cesa_tdma_chain *chain)
+{
+	memset(chain, 0, sizeof(*chain));
+}
+
+struct mv_cesa_op_ctx *mv_cesa_dma_add_op(struct mv_cesa_tdma_chain *chain,
+					const struct mv_cesa_op_ctx *op_templ,
+					gfp_t flags);
+
+int mv_cesa_dma_add_data_transfer(struct mv_cesa_tdma_chain *chain,
+				  dma_addr_t dst, dma_addr_t src, u32 size,
+				  u32 flags, gfp_t gfp_flags);
+
+int mv_cesa_dma_add_dummy_launch(struct mv_cesa_tdma_chain *chain,
+				 u32 flags);
+
+int mv_cesa_dma_add_dummy_end(struct mv_cesa_tdma_chain *chain, u32 flags);
+
+int mv_cesa_dma_add_op_transfers(struct mv_cesa_tdma_chain *chain,
+				 struct mv_cesa_dma_iter *dma_iter,
+				 struct mv_cesa_sg_dma_iter *sgiter,
+				 gfp_t gfp_flags);
+
+/* Algorithm definitions */
+
+extern struct ahash_alg mv_md5_alg;
+extern struct ahash_alg mv_sha1_alg;
+extern struct ahash_alg mv_sha256_alg;
+extern struct ahash_alg mv_ahmac_md5_alg;
+extern struct ahash_alg mv_ahmac_sha1_alg;
+extern struct ahash_alg mv_ahmac_sha256_alg;
+
+extern struct crypto_alg mv_cesa_ecb_des_alg;
+extern struct crypto_alg mv_cesa_cbc_des_alg;
+extern struct crypto_alg mv_cesa_ecb_des3_ede_alg;
+extern struct crypto_alg mv_cesa_cbc_des3_ede_alg;
+extern struct crypto_alg mv_cesa_ecb_aes_alg;
+extern struct crypto_alg mv_cesa_cbc_aes_alg;
+
+#endif /* __MARVELL_CESA_H__ */
diff --git a/drivers/crypto/marvell/cipher.c b/drivers/crypto/marvell/cipher.c
new file mode 100644
index 0000000..ddb8260
--- /dev/null
+++ b/drivers/crypto/marvell/cipher.c
@@ -0,0 +1,761 @@
+/*
+ * Cipher algorithms supported by the CESA: DES, 3DES and AES.
+ *
+ * Author: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
+ * Author: Arnaud Ebalard <arno-LkuqDEemtHBg9hUCZPvPmw@public.gmane.org>
+ *
+ * This work is based on an initial version written by
+ * Sebastian Andrzej Siewior < sebastian at breakpoint dot cc >
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ */
+
+#include <crypto/aes.h>
+#include <crypto/des.h>
+
+#include "cesa.h"
+
+struct mv_cesa_des_ctx {
+	struct mv_cesa_ctx base;
+	u8 key[DES_KEY_SIZE];
+};
+
+struct mv_cesa_des3_ctx {
+	struct mv_cesa_ctx base;
+	u8 key[DES3_EDE_KEY_SIZE];
+};
+
+struct mv_cesa_aes_ctx {
+	struct mv_cesa_ctx base;
+	struct crypto_aes_ctx aes;
+};
+
+struct mv_cesa_ablkcipher_dma_iter {
+	struct mv_cesa_dma_iter base;
+	struct mv_cesa_sg_dma_iter src;
+	struct mv_cesa_sg_dma_iter dst;
+};
+
+static inline void
+mv_cesa_ablkcipher_req_iter_init(struct mv_cesa_ablkcipher_dma_iter *iter,
+				 struct ablkcipher_request *req)
+{
+	mv_cesa_req_dma_iter_init(&iter->base, req->nbytes);
+	mv_cesa_sg_dma_iter_init(&iter->src, req->src, DMA_TO_DEVICE);
+	mv_cesa_sg_dma_iter_init(&iter->dst, req->dst, DMA_FROM_DEVICE);
+}
+
+static inline bool
+mv_cesa_ablkcipher_req_iter_next_op(struct mv_cesa_ablkcipher_dma_iter *iter)
+{
+	iter->src.op_offset = 0;
+	iter->dst.op_offset = 0;
+
+	return mv_cesa_req_dma_iter_next_op(&iter->base);
+}
+
+static inline void
+mv_cesa_ablkcipher_dma_cleanup(struct ablkcipher_request *req)
+{
+	struct mv_cesa_ablkcipher_req *creq = ablkcipher_request_ctx(req);
+
+	dma_unmap_sg(cesa_dev->dev, req->dst, creq->dst_nents, DMA_FROM_DEVICE);
+	dma_unmap_sg(cesa_dev->dev, req->src, creq->src_nents, DMA_TO_DEVICE);
+	mv_cesa_dma_cleanup(&creq->req.dma);
+}
+
+static inline void mv_cesa_ablkcipher_cleanup(struct ablkcipher_request *req)
+{
+	struct mv_cesa_ablkcipher_req *creq = ablkcipher_request_ctx(req);
+
+	if (creq->req.base.type == CESA_DMA_REQ)
+		mv_cesa_ablkcipher_dma_cleanup(req);
+}
+
+static void mv_cesa_ablkcipher_std_step(struct ablkcipher_request *req)
+{
+	struct mv_cesa_ablkcipher_req *creq = ablkcipher_request_ctx(req);
+	struct mv_cesa_ablkcipher_std_req *sreq = &creq->req.std;
+	struct mv_cesa_engine *engine = sreq->base.engine;
+	size_t  len = min_t(size_t, req->nbytes - sreq->offset,
+			    CESA_SA_SRAM_PAYLOAD_SIZE);
+
+	len = sg_pcopy_to_buffer(req->src, creq->src_nents,
+				 engine->sram + CESA_SA_DATA_SRAM_OFFSET,
+				 len, sreq->offset);
+
+	sreq->size = len;
+	mv_cesa_set_crypt_op_len(&sreq->op, len);
+
+	/* FIXME: only update enc_len field */
+	memcpy(engine->sram, &sreq->op, sizeof(sreq->op));
+
+	mv_cesa_set_int_mask(engine, CESA_SA_INT_ACCEL0_DONE);
+	writel(CESA_SA_CFG_PARA_DIS, engine->regs + CESA_SA_CFG);
+	writel(CESA_SA_CMD_EN_CESA_SA_ACCL0, engine->regs + CESA_SA_CMD);
+}
+
+static int mv_cesa_ablkcipher_std_process(struct ablkcipher_request *req,
+					  u32 status)
+{
+	struct mv_cesa_ablkcipher_req *creq = ablkcipher_request_ctx(req);
+	struct mv_cesa_ablkcipher_std_req *sreq = &creq->req.std;
+	struct mv_cesa_engine *engine = sreq->base.engine;
+	size_t len;
+
+	len = sg_pcopy_from_buffer(req->dst, creq->dst_nents,
+				   engine->sram + CESA_SA_DATA_SRAM_OFFSET,
+				   sreq->size, sreq->offset);
+
+	sreq->offset += len;
+	if (sreq->offset < req->nbytes)
+		return -EINPROGRESS;
+
+	return 0;
+}
+
+static int mv_cesa_ablkcipher_process(struct crypto_async_request *req,
+				      u32 status)
+{
+	struct ablkcipher_request *ablkreq = ablkcipher_request_cast(req);
+	struct mv_cesa_ablkcipher_req *creq = ablkcipher_request_ctx(ablkreq);
+	int ret;
+
+	if (creq->req.base.type == CESA_DMA_REQ)
+		ret = mv_cesa_dma_process(&creq->req.dma, status);
+	else
+		ret = mv_cesa_ablkcipher_std_process(ablkreq, status);
+
+	return ret;
+}
+
+static void mv_cesa_ablkcipher_step(struct crypto_async_request *req)
+{
+	struct ablkcipher_request *ablkreq = ablkcipher_request_cast(req);
+	struct mv_cesa_ablkcipher_req *creq = ablkcipher_request_ctx(ablkreq);
+
+	if (creq->req.base.type == CESA_DMA_REQ)
+		mv_cesa_dma_step(&creq->req.dma);
+	else
+		mv_cesa_ablkcipher_std_step(ablkreq);
+}
+
+static inline void
+mv_cesa_ablkcipher_dma_prepare(struct ablkcipher_request *req)
+{
+	struct mv_cesa_ablkcipher_req *creq = ablkcipher_request_ctx(req);
+	struct mv_cesa_tdma_req *dreq = &creq->req.dma;
+
+	mv_cesa_dma_prepare(dreq, dreq->base.engine);
+}
+
+static inline void
+mv_cesa_ablkcipher_std_prepare(struct ablkcipher_request *req)
+{
+	struct mv_cesa_ablkcipher_req *creq = ablkcipher_request_ctx(req);
+	struct mv_cesa_ablkcipher_std_req *sreq = &creq->req.std;
+	struct mv_cesa_engine *engine = sreq->base.engine;
+
+	sreq->size = 0;
+	sreq->offset = 0;
+	mv_cesa_adjust_op(engine, &sreq->op);
+	memcpy(engine->sram, &sreq->op, sizeof(sreq->op));
+}
+
+static inline void mv_cesa_ablkcipher_prepare(struct crypto_async_request *req,
+					      struct mv_cesa_engine *engine)
+{
+	struct ablkcipher_request *ablkreq = ablkcipher_request_cast(req);
+	struct mv_cesa_ablkcipher_req *creq = ablkcipher_request_ctx(ablkreq);
+
+	creq->req.base.engine = engine;
+
+	if (creq->req.base.type == CESA_DMA_REQ)
+		mv_cesa_ablkcipher_dma_prepare(ablkreq);
+	else
+		mv_cesa_ablkcipher_std_prepare(ablkreq);
+}
+
+static inline void
+mv_cesa_ablkcipher_req_cleanup(struct crypto_async_request *req)
+{
+	struct ablkcipher_request *ablkreq = ablkcipher_request_cast(req);
+
+	mv_cesa_ablkcipher_cleanup(ablkreq);
+}
+
+static const struct mv_cesa_req_ops mv_cesa_ablkcipher_req_ops = {
+	.step = mv_cesa_ablkcipher_step,
+	.process = mv_cesa_ablkcipher_process,
+	.prepare = mv_cesa_ablkcipher_prepare,
+	.cleanup = mv_cesa_ablkcipher_req_cleanup,
+};
+
+static int mv_cesa_ablkcipher_cra_init(struct crypto_tfm *tfm)
+{
+	struct mv_cesa_aes_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	ctx->base.ops = &mv_cesa_ablkcipher_req_ops;
+
+	tfm->crt_ablkcipher.reqsize = sizeof(struct mv_cesa_ablkcipher_req);
+
+	return 0;
+}
+
+static int mv_cesa_aes_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
+			      unsigned int len)
+{
+	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
+	struct mv_cesa_aes_ctx *ctx = crypto_tfm_ctx(tfm);
+	int remaining;
+	int offset;
+	int ret;
+	int i;
+
+	ret = crypto_aes_expand_key(&ctx->aes, key, len);
+	if (ret) {
+		crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return ret;
+	}
+
+	remaining = (ctx->aes.key_length - 16) / 4;
+	offset = ctx->aes.key_length + 24 - remaining;
+	for (i = 0; i < remaining; i++)
+		ctx->aes.key_dec[4 + i] =
+			cpu_to_le32(ctx->aes.key_enc[offset + i]);
+
+	return 0;
+}
+
+static int mv_cesa_des_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
+			      unsigned int len)
+{
+	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
+	struct mv_cesa_des_ctx *ctx = crypto_tfm_ctx(tfm);
+	u32 tmp[DES_EXPKEY_WORDS];
+	int ret;
+
+	if (len != DES_KEY_SIZE) {
+		crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+
+	ret = des_ekey(tmp, key);
+	if (!ret && (tfm->crt_flags & CRYPTO_TFM_REQ_WEAK_KEY)) {
+		tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
+		return -EINVAL;
+	}
+
+	memcpy(ctx->key, key, DES_KEY_SIZE);
+
+	return 0;
+}
+
+static int mv_cesa_des3_ede_setkey(struct crypto_ablkcipher *cipher,
+				   const u8 *key, unsigned int len)
+{
+	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
+	struct mv_cesa_des_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	if (len != DES3_EDE_KEY_SIZE) {
+		crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+
+	memcpy(ctx->key, key, DES3_EDE_KEY_SIZE);
+
+	return 0;
+}
+
+static int mv_cesa_ablkcipher_dma_req_init(struct ablkcipher_request *req,
+				const struct mv_cesa_op_ctx *op_templ)
+{
+	struct mv_cesa_ablkcipher_req *creq = ablkcipher_request_ctx(req);
+	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
+		      GFP_KERNEL : GFP_ATOMIC;
+	struct mv_cesa_tdma_req *dreq = &creq->req.dma;
+	struct mv_cesa_ablkcipher_dma_iter iter;
+	struct mv_cesa_tdma_chain chain;
+	int ret;
+
+	dreq->base.type = CESA_DMA_REQ;
+	dreq->chain.first = NULL;
+	dreq->chain.last = NULL;
+
+	ret = dma_map_sg(cesa_dev->dev, req->src, creq->src_nents,
+			 DMA_TO_DEVICE);
+	if (ret < 0)
+		return ret;
+
+	creq->src_nents = ret;
+
+	ret = dma_map_sg(cesa_dev->dev, req->dst, creq->dst_nents,
+			 DMA_FROM_DEVICE);
+	if (ret < 0)
+		goto err_unmap_src;
+
+	creq->dst_nents = ret;
+
+	mv_cesa_tdma_desc_iter_init(&chain);
+	mv_cesa_ablkcipher_req_iter_init(&iter, req);
+
+	do {
+		struct mv_cesa_op_ctx *op;
+
+		op = mv_cesa_dma_add_op(&chain, op_templ, flags);
+		if (IS_ERR(op)) {
+			ret = PTR_ERR(op);
+			goto err_free_tdma;
+		}
+
+		mv_cesa_set_crypt_op_len(op, iter.base.op_len);
+
+		/* Add input transfers */
+		ret = mv_cesa_dma_add_op_transfers(&chain, &iter.base,
+						   &iter.src, flags);
+		if (ret)
+			goto err_free_tdma;
+
+		/* Add dummy desc to launch the crypto operation */
+		ret = mv_cesa_dma_add_dummy_launch(&chain, flags);
+		if (ret)
+			goto err_free_tdma;
+
+		/* Add output transfers */
+		ret = mv_cesa_dma_add_op_transfers(&chain, &iter.base,
+						   &iter.dst, flags);
+		if (ret)
+			goto err_free_tdma;
+
+	} while (mv_cesa_ablkcipher_req_iter_next_op(&iter));
+
+	dreq->chain = chain;
+
+	return 0;
+
+err_free_tdma:
+	mv_cesa_dma_cleanup(dreq);
+	dma_unmap_sg(cesa_dev->dev, req->dst, creq->dst_nents, DMA_FROM_DEVICE);
+
+err_unmap_src:
+	dma_unmap_sg(cesa_dev->dev, req->src, creq->src_nents, DMA_TO_DEVICE);
+
+	return ret;
+}
+
+static inline int
+mv_cesa_ablkcipher_std_req_init(struct ablkcipher_request *req,
+				const struct mv_cesa_op_ctx *op_templ)
+{
+	struct mv_cesa_ablkcipher_req *creq = ablkcipher_request_ctx(req);
+	struct mv_cesa_ablkcipher_std_req *sreq = &creq->req.std;
+
+	sreq->base.type = CESA_STD_REQ;
+	sreq->op = *op_templ;
+
+	return 0;
+}
+
+static int mv_cesa_ablkcipher_req_init(struct ablkcipher_request *req,
+				       struct mv_cesa_op_ctx *tmpl)
+{
+	struct mv_cesa_ablkcipher_req *creq = ablkcipher_request_ctx(req);
+	int ret;
+
+	creq->src_nents = mv_cesa_sg_count(req->src, req->nbytes);
+	creq->dst_nents = mv_cesa_sg_count(req->src, req->nbytes);
+
+	mv_cesa_update_op_cfg(tmpl, CESA_SA_DESC_CFG_OP_CRYPT_ONLY,
+			      CESA_SA_DESC_CFG_OP_MSK);
+
+	/* TODO: add a threshold for DMA usage */
+	if (cesa_dev->caps->has_tdma)
+		ret = mv_cesa_ablkcipher_dma_req_init(req, tmpl);
+	else
+		ret = mv_cesa_ablkcipher_std_req_init(req, tmpl);
+
+	return ret;
+}
+
+static int mv_cesa_des_op(struct ablkcipher_request *req,
+			  struct mv_cesa_op_ctx *tmpl)
+{
+	struct mv_cesa_des_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
+	int ret;
+
+	mv_cesa_update_op_cfg(tmpl, CESA_SA_DESC_CFG_CRYPTM_DES,
+			      CESA_SA_DESC_CFG_CRYPTM_MSK);
+
+	memcpy(tmpl->ctx.blkcipher.key, ctx->key, DES_KEY_SIZE);
+
+	ret = mv_cesa_ablkcipher_req_init(req, tmpl);
+	if (ret)
+		return ret;
+
+	ret = mv_cesa_queue_req(&req->base);
+	if (ret && ret != -EINPROGRESS)
+		mv_cesa_ablkcipher_cleanup(req);
+
+	return ret;
+}
+
+static int mv_cesa_ecb_des_encrypt(struct ablkcipher_request *req)
+{
+	struct mv_cesa_op_ctx tmpl;
+
+	mv_cesa_set_op_cfg(&tmpl,
+			   CESA_SA_DESC_CFG_CRYPTCM_ECB |
+			   CESA_SA_DESC_CFG_DIR_ENC);
+
+	return mv_cesa_des_op(req, &tmpl);
+}
+
+static int mv_cesa_ecb_des_decrypt(struct ablkcipher_request *req)
+{
+	struct mv_cesa_op_ctx tmpl;
+
+	mv_cesa_set_op_cfg(&tmpl,
+			   CESA_SA_DESC_CFG_CRYPTCM_ECB |
+			   CESA_SA_DESC_CFG_DIR_DEC);
+
+	return mv_cesa_des_op(req, &tmpl);
+}
+
+struct crypto_alg mv_cesa_ecb_des_alg = {
+	.cra_name = "ecb(des)",
+	.cra_driver_name = "mv-ecb-des",
+	.cra_priority = 300,
+	.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
+		     CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
+	.cra_blocksize = DES_BLOCK_SIZE,
+	.cra_ctxsize = sizeof(struct mv_cesa_des_ctx),
+	.cra_alignmask = 0,
+	.cra_type = &crypto_ablkcipher_type,
+	.cra_module = THIS_MODULE,
+	.cra_init = mv_cesa_ablkcipher_cra_init,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize = DES_KEY_SIZE,
+			.max_keysize = DES_KEY_SIZE,
+			.setkey = mv_cesa_des_setkey,
+			.encrypt = mv_cesa_ecb_des_encrypt,
+			.decrypt = mv_cesa_ecb_des_decrypt,
+		},
+	},
+};
+
+static int mv_cesa_cbc_des_op(struct ablkcipher_request *req,
+			      struct mv_cesa_op_ctx *tmpl)
+{
+	mv_cesa_update_op_cfg(tmpl, CESA_SA_DESC_CFG_CRYPTCM_CBC,
+			      CESA_SA_DESC_CFG_CRYPTCM_MSK);
+
+	memcpy(tmpl->ctx.blkcipher.iv, req->info, 8);
+
+	return mv_cesa_des_op(req, tmpl);
+}
+
+static int mv_cesa_cbc_des_encrypt(struct ablkcipher_request *req)
+{
+	struct mv_cesa_op_ctx tmpl;
+
+	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_DIR_ENC);
+
+	return mv_cesa_cbc_des_op(req, &tmpl);
+}
+
+static int mv_cesa_cbc_des_decrypt(struct ablkcipher_request *req)
+{
+	struct mv_cesa_op_ctx tmpl;
+
+	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_DIR_DEC);
+
+	return mv_cesa_cbc_des_op(req, &tmpl);
+}
+
+struct crypto_alg mv_cesa_cbc_des_alg = {
+	.cra_name = "cbc(des)",
+	.cra_driver_name = "mv-cbc-des",
+	.cra_priority = 300,
+	.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
+		     CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
+	.cra_blocksize = DES_BLOCK_SIZE,
+	.cra_ctxsize = sizeof(struct mv_cesa_des_ctx),
+	.cra_alignmask = 0,
+	.cra_type = &crypto_ablkcipher_type,
+	.cra_module = THIS_MODULE,
+	.cra_init = mv_cesa_ablkcipher_cra_init,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize = DES_KEY_SIZE,
+			.max_keysize = DES_KEY_SIZE,
+			.ivsize	     = DES_BLOCK_SIZE,
+			.setkey = mv_cesa_des_setkey,
+			.encrypt = mv_cesa_cbc_des_encrypt,
+			.decrypt = mv_cesa_cbc_des_decrypt,
+		},
+	},
+};
+
+static int mv_cesa_des3_op(struct ablkcipher_request *req,
+			   struct mv_cesa_op_ctx *tmpl)
+{
+	struct mv_cesa_des3_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
+	int ret;
+
+	mv_cesa_update_op_cfg(tmpl, CESA_SA_DESC_CFG_CRYPTM_3DES,
+			      CESA_SA_DESC_CFG_CRYPTM_MSK);
+
+	memcpy(tmpl->ctx.blkcipher.key, ctx->key, DES3_EDE_KEY_SIZE);
+
+	ret = mv_cesa_ablkcipher_req_init(req, tmpl);
+	if (ret)
+		return ret;
+
+	ret = mv_cesa_queue_req(&req->base);
+	if (ret && ret != -EINPROGRESS)
+		mv_cesa_ablkcipher_cleanup(req);
+
+	return ret;
+}
+
+static int mv_cesa_ecb_des3_ede_encrypt(struct ablkcipher_request *req)
+{
+	struct mv_cesa_op_ctx tmpl;
+
+	mv_cesa_set_op_cfg(&tmpl,
+			   CESA_SA_DESC_CFG_CRYPTCM_ECB |
+			   CESA_SA_DESC_CFG_3DES_EDE |
+			   CESA_SA_DESC_CFG_DIR_ENC);
+
+	return mv_cesa_des3_op(req, &tmpl);
+}
+
+static int mv_cesa_ecb_des3_ede_decrypt(struct ablkcipher_request *req)
+{
+	struct mv_cesa_op_ctx tmpl;
+
+	mv_cesa_set_op_cfg(&tmpl,
+			   CESA_SA_DESC_CFG_CRYPTCM_ECB |
+			   CESA_SA_DESC_CFG_3DES_EDE |
+			   CESA_SA_DESC_CFG_DIR_DEC);
+
+	return mv_cesa_des3_op(req, &tmpl);
+}
+
+struct crypto_alg mv_cesa_ecb_des3_ede_alg = {
+	.cra_name = "ecb(des3_ede)",
+	.cra_driver_name = "mv-ecb-des3-ede",
+	.cra_priority = 300,
+	.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
+		     CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
+	.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+	.cra_ctxsize = sizeof(struct mv_cesa_des3_ctx),
+	.cra_alignmask = 0,
+	.cra_type = &crypto_ablkcipher_type,
+	.cra_module = THIS_MODULE,
+	.cra_init = mv_cesa_ablkcipher_cra_init,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize = DES3_EDE_KEY_SIZE,
+			.max_keysize = DES3_EDE_KEY_SIZE,
+			.ivsize	     = DES3_EDE_BLOCK_SIZE,
+			.setkey = mv_cesa_des3_ede_setkey,
+			.encrypt = mv_cesa_ecb_des3_ede_encrypt,
+			.decrypt = mv_cesa_ecb_des3_ede_decrypt,
+		},
+	},
+};
+
+static int mv_cesa_cbc_des3_op(struct ablkcipher_request *req,
+			      struct mv_cesa_op_ctx *tmpl)
+{
+	memcpy(tmpl->ctx.blkcipher.iv, req->info, DES3_EDE_BLOCK_SIZE);
+
+	return mv_cesa_des3_op(req, tmpl);
+}
+
+static int mv_cesa_cbc_des3_ede_encrypt(struct ablkcipher_request *req)
+{
+	struct mv_cesa_op_ctx tmpl;
+
+	mv_cesa_set_op_cfg(&tmpl,
+			   CESA_SA_DESC_CFG_CRYPTCM_CBC |
+			   CESA_SA_DESC_CFG_3DES_EDE |
+			   CESA_SA_DESC_CFG_DIR_ENC);
+
+	return mv_cesa_cbc_des3_op(req, &tmpl);
+}
+
+static int mv_cesa_cbc_des3_ede_decrypt(struct ablkcipher_request *req)
+{
+	struct mv_cesa_op_ctx tmpl;
+
+	mv_cesa_set_op_cfg(&tmpl,
+			   CESA_SA_DESC_CFG_CRYPTCM_CBC |
+			   CESA_SA_DESC_CFG_3DES_EDE |
+			   CESA_SA_DESC_CFG_DIR_DEC);
+
+	return mv_cesa_cbc_des3_op(req, &tmpl);
+}
+
+struct crypto_alg mv_cesa_cbc_des3_ede_alg = {
+	.cra_name = "cbc(des3_ede)",
+	.cra_driver_name = "mv-cbc-des3-ede",
+	.cra_priority = 300,
+	.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
+		     CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
+	.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+	.cra_ctxsize = sizeof(struct mv_cesa_des3_ctx),
+	.cra_alignmask = 0,
+	.cra_type = &crypto_ablkcipher_type,
+	.cra_module = THIS_MODULE,
+	.cra_init = mv_cesa_ablkcipher_cra_init,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize = DES3_EDE_KEY_SIZE,
+			.max_keysize = DES3_EDE_KEY_SIZE,
+			.ivsize	     = DES3_EDE_BLOCK_SIZE,
+			.setkey = mv_cesa_des3_ede_setkey,
+			.encrypt = mv_cesa_cbc_des3_ede_encrypt,
+			.decrypt = mv_cesa_cbc_des3_ede_decrypt,
+		},
+	},
+};
+
+static int mv_cesa_aes_op(struct ablkcipher_request *req,
+			  struct mv_cesa_op_ctx *tmpl)
+{
+	struct mv_cesa_aes_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
+	int ret, i;
+	u32 *key;
+	u32 cfg;
+
+	cfg = CESA_SA_DESC_CFG_CRYPTM_AES;
+
+	if (mv_cesa_get_op_cfg(tmpl) & CESA_SA_DESC_CFG_DIR_DEC)
+		key = ctx->aes.key_dec;
+	else
+		key = ctx->aes.key_enc;
+
+	for (i = 0; i < ctx->aes.key_length / sizeof(u32); i++)
+		tmpl->ctx.blkcipher.key[i] = cpu_to_le32(key[i]);
+
+	if (ctx->aes.key_length == 24)
+		cfg |= CESA_SA_DESC_CFG_AES_LEN_192;
+	else if (ctx->aes.key_length == 32)
+		cfg |= CESA_SA_DESC_CFG_AES_LEN_256;
+
+	mv_cesa_update_op_cfg(tmpl, cfg,
+			      CESA_SA_DESC_CFG_CRYPTM_MSK |
+			      CESA_SA_DESC_CFG_AES_LEN_MSK);
+
+	ret = mv_cesa_ablkcipher_req_init(req, tmpl);
+	if (ret)
+		return ret;
+
+	ret = mv_cesa_queue_req(&req->base);
+	if (ret && ret != -EINPROGRESS)
+		mv_cesa_ablkcipher_cleanup(req);
+
+	return ret;
+}
+
+static int mv_cesa_ecb_aes_encrypt(struct ablkcipher_request *req)
+{
+	struct mv_cesa_op_ctx tmpl;
+
+	mv_cesa_set_op_cfg(&tmpl,
+			   CESA_SA_DESC_CFG_CRYPTCM_ECB |
+			   CESA_SA_DESC_CFG_DIR_ENC);
+
+	return mv_cesa_aes_op(req, &tmpl);
+}
+
+static int mv_cesa_ecb_aes_decrypt(struct ablkcipher_request *req)
+{
+	struct mv_cesa_op_ctx tmpl;
+
+	mv_cesa_set_op_cfg(&tmpl,
+			   CESA_SA_DESC_CFG_CRYPTCM_ECB |
+			   CESA_SA_DESC_CFG_DIR_DEC);
+
+	return mv_cesa_aes_op(req, &tmpl);
+}
+
+struct crypto_alg mv_cesa_ecb_aes_alg = {
+	.cra_name = "ecb(aes)",
+	.cra_driver_name = "mv-ecb-aes",
+	.cra_priority = 300,
+	.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
+		     CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
+	.cra_blocksize = AES_BLOCK_SIZE,
+	.cra_ctxsize = sizeof(struct mv_cesa_aes_ctx),
+	.cra_alignmask = 0,
+	.cra_type = &crypto_ablkcipher_type,
+	.cra_module = THIS_MODULE,
+	.cra_init = mv_cesa_ablkcipher_cra_init,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize = AES_MIN_KEY_SIZE,
+			.max_keysize = AES_MAX_KEY_SIZE,
+			.setkey = mv_cesa_aes_setkey,
+			.encrypt = mv_cesa_ecb_aes_encrypt,
+			.decrypt = mv_cesa_ecb_aes_decrypt,
+		},
+	},
+};
+
+static int mv_cesa_cbc_aes_op(struct ablkcipher_request *req,
+			      struct mv_cesa_op_ctx *tmpl)
+{
+	mv_cesa_update_op_cfg(tmpl, CESA_SA_DESC_CFG_CRYPTCM_CBC,
+			      CESA_SA_DESC_CFG_CRYPTCM_MSK);
+	memcpy(tmpl->ctx.blkcipher.iv, req->info, 16);
+
+	return mv_cesa_aes_op(req, tmpl);
+}
+
+static int mv_cesa_cbc_aes_encrypt(struct ablkcipher_request *req)
+{
+	struct mv_cesa_op_ctx tmpl;
+
+	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_DIR_ENC);
+
+	return mv_cesa_cbc_aes_op(req, &tmpl);
+}
+
+static int mv_cesa_cbc_aes_decrypt(struct ablkcipher_request *req)
+{
+	struct mv_cesa_op_ctx tmpl;
+
+	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_DIR_DEC);
+
+	return mv_cesa_cbc_aes_op(req, &tmpl);
+}
+
+struct crypto_alg mv_cesa_cbc_aes_alg = {
+	.cra_name = "cbc(aes)",
+	.cra_driver_name = "mv-cbc-aes",
+	.cra_priority = 300,
+	.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
+		     CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
+	.cra_blocksize = AES_BLOCK_SIZE,
+	.cra_ctxsize = sizeof(struct mv_cesa_aes_ctx),
+	.cra_alignmask = 0,
+	.cra_type = &crypto_ablkcipher_type,
+	.cra_module = THIS_MODULE,
+	.cra_init = mv_cesa_ablkcipher_cra_init,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize = AES_MIN_KEY_SIZE,
+			.max_keysize = AES_MAX_KEY_SIZE,
+			.ivsize = AES_BLOCK_SIZE,
+			.setkey = mv_cesa_aes_setkey,
+			.encrypt = mv_cesa_cbc_aes_encrypt,
+			.decrypt = mv_cesa_cbc_aes_decrypt,
+		},
+	},
+};
diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
new file mode 100644
index 0000000..ec8c1ed
--- /dev/null
+++ b/drivers/crypto/marvell/hash.c
@@ -0,0 +1,1349 @@
+/*
+ * Hash algorithms supported by the CESA: MD5, SHA1 and SHA256.
+ *
+ * Author: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
+ * Author: Arnaud Ebalard <arno-LkuqDEemtHBg9hUCZPvPmw@public.gmane.org>
+ *
+ * This work is based on an initial version written by
+ * Sebastian Andrzej Siewior < sebastian at breakpoint dot cc >
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ */
+
+#include <crypto/md5.h>
+#include <crypto/sha.h>
+
+#include "cesa.h"
+
+struct mv_cesa_ahash_dma_iter {
+	struct mv_cesa_dma_iter base;
+	struct mv_cesa_sg_dma_iter src;
+};
+
+static inline void
+mv_cesa_ahash_req_iter_init(struct mv_cesa_ahash_dma_iter *iter,
+			    struct ahash_request *req)
+{
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+	unsigned int len = req->nbytes;
+
+	if (!creq->last_req)
+		len = (len + creq->cache_ptr) & ~CESA_HASH_BLOCK_SIZE_MSK;
+
+	mv_cesa_req_dma_iter_init(&iter->base, len);
+	mv_cesa_sg_dma_iter_init(&iter->src, req->src, DMA_TO_DEVICE);
+	iter->src.op_offset = creq->cache_ptr;
+}
+
+static inline bool
+mv_cesa_ahash_req_iter_next_op(struct mv_cesa_ahash_dma_iter *iter)
+{
+	iter->src.op_offset = 0;
+
+	return mv_cesa_req_dma_iter_next_op(&iter->base);
+}
+
+static inline int mv_cesa_ahash_dma_alloc_cache(struct mv_cesa_ahash_req *creq,
+						gfp_t flags)
+{
+	struct mv_cesa_ahash_dma_req *dreq = &creq->req.dma;
+
+	creq->cache = dma_pool_alloc(cesa_dev->dma->cache_pool, flags,
+				     &dreq->cache_dma);
+	if (!creq->cache)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static inline int mv_cesa_ahash_std_alloc_cache(struct mv_cesa_ahash_req *creq,
+						gfp_t flags)
+{
+	creq->cache = kzalloc(CESA_MAX_HASH_BLOCK_SIZE, flags);
+	if (!creq->cache)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static int mv_cesa_ahash_alloc_cache(struct ahash_request *req)
+{
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
+		      GFP_KERNEL : GFP_ATOMIC;
+	int ret;
+
+	if (creq->cache)
+		return 0;
+
+	if (creq->req.base.type == CESA_DMA_REQ)
+		ret = mv_cesa_ahash_dma_alloc_cache(creq, flags);
+	else
+		ret = mv_cesa_ahash_std_alloc_cache(creq, flags);
+
+	return ret;
+}
+
+static inline void mv_cesa_ahash_dma_free_cache(struct mv_cesa_ahash_req *creq)
+{
+	dma_pool_free(cesa_dev->dma->cache_pool, creq->cache,
+		      creq->req.dma.cache_dma);
+}
+
+static inline void mv_cesa_ahash_std_free_cache(struct mv_cesa_ahash_req *creq)
+{
+	kfree(creq->cache);
+}
+
+static void mv_cesa_ahash_free_cache(struct mv_cesa_ahash_req *creq)
+{
+	if (!creq->cache)
+		return;
+
+	if (creq->req.base.type == CESA_DMA_REQ)
+		mv_cesa_ahash_dma_free_cache(creq);
+	else
+		mv_cesa_ahash_std_free_cache(creq);
+
+	creq->cache = NULL;
+}
+
+static int mv_cesa_ahash_dma_alloc_padding(struct mv_cesa_ahash_dma_req *req,
+					   gfp_t flags)
+{
+	if (req->padding)
+		return 0;
+
+	req->padding = dma_pool_alloc(cesa_dev->dma->padding_pool, flags,
+				      &req->padding_dma);
+	if (!req->padding)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void mv_cesa_ahash_dma_free_padding(struct mv_cesa_ahash_dma_req *req)
+{
+	if (!req->padding)
+		return;
+
+	dma_pool_free(cesa_dev->dma->padding_pool, req->padding,
+		      req->padding_dma);
+	req->padding = NULL;
+}
+
+static inline void mv_cesa_ahash_dma_last_cleanup(struct ahash_request *req)
+{
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+
+	mv_cesa_ahash_dma_free_padding(&creq->req.dma);
+}
+
+static inline void mv_cesa_ahash_dma_cleanup(struct ahash_request *req)
+{
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+
+	dma_unmap_sg(cesa_dev->dev, req->src, creq->src_nents, DMA_TO_DEVICE);
+	mv_cesa_dma_cleanup(&creq->req.dma.base);
+}
+
+static inline void mv_cesa_ahash_cleanup(struct ahash_request *req)
+{
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+
+	if (creq->req.base.type == CESA_DMA_REQ)
+		mv_cesa_ahash_dma_cleanup(req);
+}
+
+static void mv_cesa_ahash_last_cleanup(struct ahash_request *req)
+{
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+
+	mv_cesa_ahash_free_cache(creq);
+
+	if (creq->req.base.type == CESA_DMA_REQ)
+		mv_cesa_ahash_dma_last_cleanup(req);
+}
+
+static int mv_cesa_ahash_pad_len(struct mv_cesa_ahash_req *creq)
+{
+	unsigned int index, padlen;
+
+	index = creq->len & CESA_HASH_BLOCK_SIZE_MSK;
+	padlen = (index < 56) ? (56 - index) : (64 + 56 - index);
+
+	return padlen;
+}
+
+static int mv_cesa_ahash_pad_req(struct mv_cesa_ahash_req *creq, u8 *buf)
+{
+	__be64 bits = cpu_to_be64(creq->len << 3);
+	unsigned int index, padlen;
+
+	buf[0] = 0x80;
+	/* Pad out to 56 mod 64 */
+	index = creq->len & CESA_HASH_BLOCK_SIZE_MSK;
+	padlen = mv_cesa_ahash_pad_len(creq);
+	memset(buf + 1, 0, padlen - 1);
+	memcpy(buf + padlen, &bits, sizeof(bits));
+
+	return padlen + 8;
+}
+
+static void mv_cesa_ahash_std_step(struct ahash_request *req)
+{
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+	struct mv_cesa_ahash_std_req *sreq = &creq->req.std;
+	struct mv_cesa_engine *engine = sreq->base.engine;
+	struct mv_cesa_op_ctx *op;
+	unsigned int new_cache_ptr = 0;
+	u32 frag_mode;
+	size_t  len;
+
+	if (creq->cache_ptr)
+		memcpy(engine->sram + CESA_SA_DATA_SRAM_OFFSET, creq->cache,
+		       creq->cache_ptr);
+
+	len = min_t(size_t, req->nbytes + creq->cache_ptr - sreq->offset,
+		    CESA_SA_SRAM_PAYLOAD_SIZE);
+
+	if (!creq->last_req) {
+		new_cache_ptr = len & CESA_HASH_BLOCK_SIZE_MSK;
+		len &= ~CESA_HASH_BLOCK_SIZE_MSK;
+	}
+
+	if (len - creq->cache_ptr)
+		sreq->offset += sg_pcopy_to_buffer(req->src, creq->src_nents,
+						   engine->sram +
+						   CESA_SA_DATA_SRAM_OFFSET +
+						   creq->cache_ptr,
+						   len - creq->cache_ptr,
+						   sreq->offset);
+
+	op = &creq->op_tmpl;
+
+	frag_mode = mv_cesa_get_op_cfg(op) & CESA_SA_DESC_CFG_FRAG_MSK;
+
+	if (creq->last_req && sreq->offset == req->nbytes &&
+	    creq->len <= CESA_SA_DESC_MAC_SRC_TOTAL_LEN_MAX) {
+		if (frag_mode == CESA_SA_DESC_CFG_FIRST_FRAG)
+			frag_mode = CESA_SA_DESC_CFG_NOT_FRAG;
+		else if (frag_mode == CESA_SA_DESC_CFG_MID_FRAG)
+			frag_mode = CESA_SA_DESC_CFG_LAST_FRAG;
+	}
+
+	if (frag_mode == CESA_SA_DESC_CFG_NOT_FRAG ||
+	    frag_mode == CESA_SA_DESC_CFG_LAST_FRAG) {
+		if (len &&
+		    creq->len <= CESA_SA_DESC_MAC_SRC_TOTAL_LEN_MAX) {
+			mv_cesa_set_mac_op_total_len(op, creq->len);
+		} else {
+			int trailerlen = mv_cesa_ahash_pad_len(creq) + 8;
+
+			if (len + trailerlen > CESA_SA_SRAM_PAYLOAD_SIZE) {
+				len &= CESA_HASH_BLOCK_SIZE_MSK;
+				new_cache_ptr = 64 - trailerlen;
+				memcpy(creq->cache,
+				       engine->sram +
+				       CESA_SA_DATA_SRAM_OFFSET + len,
+				       new_cache_ptr);
+			} else {
+				len += mv_cesa_ahash_pad_req(creq,
+						engine->sram + len +
+						CESA_SA_DATA_SRAM_OFFSET);
+			}
+
+			if (frag_mode == CESA_SA_DESC_CFG_LAST_FRAG)
+				frag_mode = CESA_SA_DESC_CFG_MID_FRAG;
+			else
+				frag_mode = CESA_SA_DESC_CFG_FIRST_FRAG;
+		}
+	}
+
+	mv_cesa_set_mac_op_frag_len(op, len);
+	mv_cesa_update_op_cfg(op, frag_mode, CESA_SA_DESC_CFG_FRAG_MSK);
+
+	/* FIXME: only update enc_len field */
+	memcpy(engine->sram, op, sizeof(*op));
+
+	if (frag_mode == CESA_SA_DESC_CFG_FIRST_FRAG)
+		mv_cesa_update_op_cfg(op, CESA_SA_DESC_CFG_MID_FRAG,
+				      CESA_SA_DESC_CFG_FRAG_MSK);
+
+	creq->cache_ptr = new_cache_ptr;
+
+	mv_cesa_set_int_mask(engine, CESA_SA_INT_ACCEL0_DONE);
+	writel(CESA_SA_CFG_PARA_DIS, engine->regs + CESA_SA_CFG);
+	writel(CESA_SA_CMD_EN_CESA_SA_ACCL0, engine->regs + CESA_SA_CMD);
+}
+
+static int mv_cesa_ahash_std_process(struct ahash_request *req, u32 status)
+{
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+	struct mv_cesa_ahash_std_req *sreq = &creq->req.std;
+
+	if (sreq->offset < (req->nbytes - creq->cache_ptr))
+		return -EINPROGRESS;
+
+	return 0;
+}
+
+static inline void mv_cesa_ahash_dma_prepare(struct ahash_request *req)
+{
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+	struct mv_cesa_tdma_req *dreq = &creq->req.dma.base;
+
+	mv_cesa_dma_prepare(dreq, dreq->base.engine);
+}
+
+static void mv_cesa_ahash_std_prepare(struct ahash_request *req)
+{
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+	struct mv_cesa_ahash_std_req *sreq = &creq->req.std;
+	struct mv_cesa_engine *engine = sreq->base.engine;
+
+	sreq->offset = 0;
+	mv_cesa_adjust_op(engine, &creq->op_tmpl);
+	memcpy(engine->sram, &creq->op_tmpl, sizeof(creq->op_tmpl));
+}
+
+static void mv_cesa_ahash_step(struct crypto_async_request *req)
+{
+	struct ahash_request *ahashreq = ahash_request_cast(req);
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(ahashreq);
+
+	if (creq->req.base.type == CESA_DMA_REQ)
+		mv_cesa_dma_step(&creq->req.dma.base);
+	else
+		mv_cesa_ahash_std_step(ahashreq);
+}
+
+static int mv_cesa_ahash_process(struct crypto_async_request *req, u32 status)
+{
+	struct ahash_request *ahashreq = ahash_request_cast(req);
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(ahashreq);
+	struct mv_cesa_engine *engine = creq->req.base.engine;
+	unsigned int digsize;
+	int ret, i;
+
+	if (creq->req.base.type == CESA_DMA_REQ)
+		ret = mv_cesa_dma_process(&creq->req.dma.base, status);
+	else
+		ret = mv_cesa_ahash_std_process(ahashreq, status);
+
+	if (ret == -EINPROGRESS)
+		return ret;
+
+	digsize = crypto_ahash_digestsize(crypto_ahash_reqtfm(ahashreq));
+	for (i = 0; i < digsize / 4; i++)
+		creq->state[i] = readl(engine->regs + CESA_IVDIG(i));
+
+	if (creq->cache_ptr)
+		sg_pcopy_to_buffer(ahashreq->src, creq->src_nents,
+				   creq->cache,
+				   creq->cache_ptr,
+				   ahashreq->nbytes - creq->cache_ptr);
+
+	if (creq->last_req) {
+		for (i = 0; i < digsize / 4; i++) {
+			/*
+			 * Hardware provides MD5 digest in a different
+			 * endianness than SHA-1 and SHA-256 ones.
+			 */
+			if (digsize == MD5_DIGEST_SIZE)
+				creq->state[i] = cpu_to_le32(creq->state[i]);
+			else
+				creq->state[i] = cpu_to_be32(creq->state[i]);
+		}
+
+		memcpy(ahashreq->result, creq->state, digsize);
+	}
+
+	return ret;
+}
+
+static void mv_cesa_ahash_prepare(struct crypto_async_request *req,
+				  struct mv_cesa_engine *engine)
+{
+	struct ahash_request *ahashreq = ahash_request_cast(req);
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(ahashreq);
+	unsigned int digsize;
+	int i;
+
+	creq->req.base.engine = engine;
+
+	if (creq->req.base.type == CESA_DMA_REQ)
+		mv_cesa_ahash_dma_prepare(ahashreq);
+	else
+		mv_cesa_ahash_std_prepare(ahashreq);
+
+	digsize = crypto_ahash_digestsize(crypto_ahash_reqtfm(ahashreq));
+	for (i = 0; i < digsize / 4; i++)
+		writel(creq->state[i],
+		       engine->regs + CESA_IVDIG(i));
+}
+
+static void mv_cesa_ahash_req_cleanup(struct crypto_async_request *req)
+{
+	struct ahash_request *ahashreq = ahash_request_cast(req);
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(ahashreq);
+
+	if (creq->last_req)
+		mv_cesa_ahash_last_cleanup(ahashreq);
+
+	mv_cesa_ahash_cleanup(ahashreq);
+}
+
+static const struct mv_cesa_req_ops mv_cesa_ahash_req_ops = {
+	.step = mv_cesa_ahash_step,
+	.process = mv_cesa_ahash_process,
+	.prepare = mv_cesa_ahash_prepare,
+	.cleanup = mv_cesa_ahash_req_cleanup,
+};
+
+static int mv_cesa_ahash_init(struct ahash_request *req,
+			      struct mv_cesa_op_ctx *tmpl)
+{
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+
+	memset(creq, 0, sizeof(*creq));
+	mv_cesa_update_op_cfg(tmpl,
+			      CESA_SA_DESC_CFG_OP_MAC_ONLY |
+			      CESA_SA_DESC_CFG_FIRST_FRAG,
+			      CESA_SA_DESC_CFG_OP_MSK |
+			      CESA_SA_DESC_CFG_FRAG_MSK);
+	mv_cesa_set_mac_op_total_len(tmpl, 0);
+	mv_cesa_set_mac_op_frag_len(tmpl, 0);
+	creq->op_tmpl = *tmpl;
+	creq->len = 0;
+
+	return 0;
+}
+
+static inline int mv_cesa_ahash_cra_init(struct crypto_tfm *tfm)
+{
+	struct mv_cesa_hash_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	ctx->base.ops = &mv_cesa_ahash_req_ops;
+
+	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
+				 sizeof(struct mv_cesa_ahash_req));
+	return 0;
+}
+
+static int mv_cesa_ahash_cache_req(struct ahash_request *req, bool *cached)
+{
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+	int ret;
+
+	if (((creq->cache_ptr + req->nbytes) & CESA_HASH_BLOCK_SIZE_MSK) &&
+	    !creq->last_req) {
+		ret = mv_cesa_ahash_alloc_cache(req);
+		if (ret)
+			return ret;
+	}
+
+	if (creq->cache_ptr + req->nbytes < 64 && !creq->last_req) {
+		*cached = true;
+
+		if (!req->nbytes)
+			return 0;
+
+		sg_pcopy_to_buffer(req->src, creq->src_nents,
+				   creq->cache + creq->cache_ptr,
+				   req->nbytes, 0);
+
+		creq->cache_ptr += req->nbytes;
+	}
+
+	return 0;
+}
+
+static struct mv_cesa_op_ctx *
+mv_cesa_ahash_dma_add_cache(struct mv_cesa_tdma_chain *chain,
+			    struct mv_cesa_ahash_dma_iter *dma_iter,
+			    struct mv_cesa_ahash_req *creq,
+			    gfp_t flags)
+{
+	struct mv_cesa_ahash_dma_req *ahashdreq = &creq->req.dma;
+	struct mv_cesa_op_ctx *op = NULL;
+	int ret;
+
+	if (!creq->cache_ptr)
+		return NULL;
+
+	ret = mv_cesa_dma_add_data_transfer(chain,
+					    CESA_SA_DATA_SRAM_OFFSET,
+					    ahashdreq->cache_dma,
+					    creq->cache_ptr,
+					    CESA_TDMA_DST_IN_SRAM,
+					    flags);
+	if (ret)
+		return ERR_PTR(ret);
+
+	if (!dma_iter->base.op_len) {
+		op = mv_cesa_dma_add_op(chain, &creq->op_tmpl, flags);
+		if (IS_ERR(op))
+			return op;
+
+		mv_cesa_set_mac_op_frag_len(op, creq->cache_ptr);
+
+		/* Add dummy desc to launch crypto operation */
+		ret = mv_cesa_dma_add_dummy_launch(chain, flags);
+		if (ret)
+			return ERR_PTR(ret);
+	}
+
+	return op;
+}
+
+static struct mv_cesa_op_ctx *
+mv_cesa_ahash_dma_add_data(struct mv_cesa_tdma_chain *chain,
+			   struct mv_cesa_ahash_dma_iter *dma_iter,
+			   struct mv_cesa_ahash_req *creq,
+			   gfp_t flags)
+{
+	struct mv_cesa_op_ctx *op;
+	int ret;
+
+	op = mv_cesa_dma_add_op(chain, &creq->op_tmpl, flags);
+	if (IS_ERR(op))
+		return op;
+
+	mv_cesa_set_mac_op_frag_len(op, dma_iter->base.op_len);
+
+	if ((mv_cesa_get_op_cfg(&creq->op_tmpl) & CESA_SA_DESC_CFG_FRAG_MSK) ==
+	    CESA_SA_DESC_CFG_FIRST_FRAG)
+		mv_cesa_update_op_cfg(&creq->op_tmpl,
+				      CESA_SA_DESC_CFG_MID_FRAG,
+				      CESA_SA_DESC_CFG_FRAG_MSK);
+
+	/* Add input transfers */
+	ret = mv_cesa_dma_add_op_transfers(chain, &dma_iter->base,
+					   &dma_iter->src, flags);
+	if (ret)
+		return ERR_PTR(ret);
+
+	/* Add dummy desc to launch crypto operation */
+	ret = mv_cesa_dma_add_dummy_launch(chain, flags);
+	if (ret)
+		return ERR_PTR(ret);
+
+	return op;
+}
+
+static struct mv_cesa_op_ctx *
+mv_cesa_ahash_dma_last_req(struct mv_cesa_tdma_chain *chain,
+			   struct mv_cesa_ahash_dma_iter *dma_iter,
+			   struct mv_cesa_ahash_req *creq,
+			   struct mv_cesa_op_ctx *op,
+			   gfp_t flags)
+{
+	struct mv_cesa_ahash_dma_req *ahashdreq = &creq->req.dma;
+	unsigned int len, trailerlen, padoff = 0;
+	int ret;
+
+	if (!creq->last_req)
+		return op;
+
+	if (op && creq->len <= CESA_SA_DESC_MAC_SRC_TOTAL_LEN_MAX) {
+		u32 frag = CESA_SA_DESC_CFG_NOT_FRAG;
+
+		if ((mv_cesa_get_op_cfg(op) & CESA_SA_DESC_CFG_FRAG_MSK) !=
+		    CESA_SA_DESC_CFG_FIRST_FRAG)
+			frag = CESA_SA_DESC_CFG_LAST_FRAG;
+
+		mv_cesa_update_op_cfg(op, frag, CESA_SA_DESC_CFG_FRAG_MSK);
+
+		return op;
+	}
+
+	ret = mv_cesa_ahash_dma_alloc_padding(ahashdreq, flags);
+	if (ret)
+		return ERR_PTR(ret);
+
+	trailerlen = mv_cesa_ahash_pad_req(creq, ahashdreq->padding);
+
+	if (op) {
+		len = min(CESA_SA_SRAM_PAYLOAD_SIZE - dma_iter->base.op_len,
+			  trailerlen);
+		if (len) {
+			ret = mv_cesa_dma_add_data_transfer(chain,
+						CESA_SA_DATA_SRAM_OFFSET +
+						dma_iter->base.op_len,
+						ahashdreq->padding_dma,
+						len, CESA_TDMA_DST_IN_SRAM,
+						flags);
+			if (ret)
+				return ERR_PTR(ret);
+
+			mv_cesa_update_op_cfg(op, CESA_SA_DESC_CFG_MID_FRAG,
+					      CESA_SA_DESC_CFG_FRAG_MSK);
+			mv_cesa_set_mac_op_frag_len(op,
+					dma_iter->base.op_len + len);
+			padoff += len;
+		}
+	}
+
+	if (padoff >= trailerlen)
+		return op;
+
+	if ((mv_cesa_get_op_cfg(&creq->op_tmpl) & CESA_SA_DESC_CFG_FRAG_MSK) !=
+	    CESA_SA_DESC_CFG_FIRST_FRAG)
+		mv_cesa_update_op_cfg(&creq->op_tmpl,
+				      CESA_SA_DESC_CFG_MID_FRAG,
+				      CESA_SA_DESC_CFG_FRAG_MSK);
+
+	op = mv_cesa_dma_add_op(chain, &creq->op_tmpl, flags);
+	if (IS_ERR(op))
+		return op;
+
+	mv_cesa_set_mac_op_frag_len(op, trailerlen - padoff);
+
+	ret = mv_cesa_dma_add_data_transfer(chain,
+					CESA_SA_DATA_SRAM_OFFSET,
+					ahashdreq->padding_dma +
+					padoff,
+					trailerlen - padoff,
+					CESA_TDMA_DST_IN_SRAM,
+					flags);
+	if (ret)
+		return ERR_PTR(ret);
+
+	/* Add dummy desc to launch crypto operation */
+	ret = mv_cesa_dma_add_dummy_launch(chain, flags);
+	if (ret)
+		return ERR_PTR(ret);
+
+	return op;
+}
+
+static int mv_cesa_ahash_dma_req_init(struct ahash_request *req)
+{
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
+		      GFP_KERNEL : GFP_ATOMIC;
+	struct mv_cesa_ahash_dma_req *ahashdreq = &creq->req.dma;
+	struct mv_cesa_tdma_req *dreq = &ahashdreq->base;
+	struct mv_cesa_tdma_chain chain;
+	struct mv_cesa_ahash_dma_iter iter;
+	struct mv_cesa_op_ctx *op = NULL;
+	int ret;
+
+	dreq->chain.first = NULL;
+	dreq->chain.last = NULL;
+
+	ret = dma_map_sg(cesa_dev->dev, req->src, creq->src_nents,
+			 DMA_TO_DEVICE);
+	if (ret < 0)
+		goto err;
+
+	creq->src_nents = ret;
+
+	mv_cesa_tdma_desc_iter_init(&chain);
+	mv_cesa_ahash_req_iter_init(&iter, req);
+
+	op = mv_cesa_ahash_dma_add_cache(&chain, &iter,
+					 creq, flags);
+	if (IS_ERR(op)) {
+		ret = PTR_ERR(op);
+		goto err_free_tdma;
+	}
+
+	do {
+		if (!iter.base.op_len)
+			break;
+
+		op = mv_cesa_ahash_dma_add_data(&chain, &iter,
+						creq, flags);
+		if (IS_ERR(op)) {
+			ret = PTR_ERR(op);
+			goto err_free_tdma;
+		}
+	} while (mv_cesa_ahash_req_iter_next_op(&iter));
+
+	op = mv_cesa_ahash_dma_last_req(&chain, &iter, creq, op, flags);
+	if (IS_ERR(op)) {
+		ret = PTR_ERR(op);
+		goto err_free_tdma;
+	}
+
+	if (op) {
+		/* Add dummy desc to wait for crypto operation end */
+		ret = mv_cesa_dma_add_dummy_end(&chain, flags);
+		if (ret)
+			goto err_free_tdma;
+	}
+
+	if (!creq->last_req)
+		creq->cache_ptr = req->nbytes + creq->cache_ptr -
+				  iter.base.len;
+	else
+		creq->cache_ptr = 0;
+
+	dreq->chain = chain;
+
+	return 0;
+
+err_free_tdma:
+	mv_cesa_dma_cleanup(dreq);
+	dma_unmap_sg(cesa_dev->dev, req->src, creq->src_nents, DMA_TO_DEVICE);
+
+err:
+	mv_cesa_ahash_last_cleanup(req);
+
+	return ret;
+}
+
+static int mv_cesa_ahash_req_init(struct ahash_request *req, bool *cached)
+{
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+	int ret;
+
+	if (cesa_dev->caps->has_tdma)
+		creq->req.base.type = CESA_DMA_REQ;
+	else
+		creq->req.base.type = CESA_STD_REQ;
+
+	creq->src_nents = mv_cesa_sg_count(req->src, req->nbytes);
+
+	ret = mv_cesa_ahash_cache_req(req, cached);
+	if (ret)
+		return ret;
+
+	if (*cached)
+		return 0;
+
+	if (creq->req.base.type == CESA_DMA_REQ)
+		ret = mv_cesa_ahash_dma_req_init(req);
+
+	return ret;
+}
+
+static int mv_cesa_ahash_update(struct ahash_request *req)
+{
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+	bool cached = false;
+	int ret;
+
+	creq->len += req->nbytes;
+	ret = mv_cesa_ahash_req_init(req, &cached);
+	if (ret)
+		return ret;
+
+	if (cached)
+		return 0;
+
+	ret = mv_cesa_queue_req(&req->base);
+	if (ret && ret != -EINPROGRESS) {
+		mv_cesa_ahash_cleanup(req);
+		return ret;
+	}
+
+	return ret;
+}
+
+static int mv_cesa_ahash_final(struct ahash_request *req)
+{
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+	struct mv_cesa_op_ctx *tmpl = &creq->op_tmpl;
+	bool cached = false;
+	int ret;
+
+	mv_cesa_set_mac_op_total_len(tmpl, creq->len);
+	creq->last_req = true;
+	req->nbytes = 0;
+
+	ret = mv_cesa_ahash_req_init(req, &cached);
+	if (ret)
+		return ret;
+
+	if (cached)
+		return 0;
+
+	ret = mv_cesa_queue_req(&req->base);
+	if (ret && ret != -EINPROGRESS)
+		mv_cesa_ahash_cleanup(req);
+
+	return ret;
+}
+
+static int mv_cesa_ahash_finup(struct ahash_request *req)
+{
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+	struct mv_cesa_op_ctx *tmpl = &creq->op_tmpl;
+	bool cached = false;
+	int ret;
+
+	creq->len += req->nbytes;
+	mv_cesa_set_mac_op_total_len(tmpl, creq->len);
+	creq->last_req = true;
+
+	ret = mv_cesa_ahash_req_init(req, &cached);
+	if (ret)
+		return ret;
+
+	if (cached)
+		return 0;
+
+	ret = mv_cesa_queue_req(&req->base);
+	if (ret && ret != -EINPROGRESS)
+		mv_cesa_ahash_cleanup(req);
+
+	return ret;
+}
+
+static int mv_cesa_md5_init(struct ahash_request *req)
+{
+	struct mv_cesa_op_ctx tmpl;
+
+	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_MACM_MD5);
+
+	mv_cesa_ahash_init(req, &tmpl);
+
+	return 0;
+}
+
+static int mv_cesa_md5_export(struct ahash_request *req, void *out)
+{
+	struct md5_state *out_state = out;
+	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+	unsigned int digsize = crypto_ahash_digestsize(ahash);
+
+	out_state->byte_count = creq->len;
+	memcpy(out_state->hash, creq->state, digsize);
+	memset(out_state->block, 0, sizeof(out_state->block));
+	if (creq->cache)
+		memcpy(out_state->block, creq->cache, creq->cache_ptr);
+
+	return 0;
+}
+
+static int mv_cesa_md5_digest(struct ahash_request *req)
+{
+	int ret;
+
+	ret = mv_cesa_md5_init(req);
+	if (ret)
+		return ret;
+
+	return mv_cesa_ahash_finup(req);
+}
+
+struct ahash_alg mv_md5_alg = {
+	.init = mv_cesa_md5_init,
+	.update = mv_cesa_ahash_update,
+	.final = mv_cesa_ahash_final,
+	.finup = mv_cesa_ahash_finup,
+	.digest = mv_cesa_md5_digest,
+	.export = mv_cesa_md5_export,
+	.halg = {
+		.digestsize = MD5_DIGEST_SIZE,
+		.base = {
+			.cra_name = "md5",
+			.cra_driver_name = "mv-md5",
+			.cra_priority = 300,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct mv_cesa_hash_ctx),
+			.cra_init = mv_cesa_ahash_cra_init,
+			.cra_module = THIS_MODULE,
+		 }
+	}
+};
+
+static int mv_cesa_sha1_init(struct ahash_request *req)
+{
+	struct mv_cesa_op_ctx tmpl;
+
+	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_MACM_SHA1);
+
+	mv_cesa_ahash_init(req, &tmpl);
+
+	return 0;
+}
+
+static int mv_cesa_sha1_export(struct ahash_request *req, void *out)
+{
+	struct sha1_state *out_state = out;
+	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+	unsigned int digsize = crypto_ahash_digestsize(ahash);
+
+	out_state->count = creq->len;
+	memcpy(out_state->state, creq->state, digsize);
+	memset(out_state->buffer, 0, sizeof(out_state->buffer));
+	if (creq->cache)
+		memcpy(out_state->buffer, creq->cache, creq->cache_ptr);
+
+	return 0;
+}
+
+static int mv_cesa_sha1_digest(struct ahash_request *req)
+{
+	int ret;
+
+	ret = mv_cesa_sha1_init(req);
+	if (ret)
+		return ret;
+
+	return mv_cesa_ahash_finup(req);
+}
+
+struct ahash_alg mv_sha1_alg = {
+	.init = mv_cesa_sha1_init,
+	.update = mv_cesa_ahash_update,
+	.final = mv_cesa_ahash_final,
+	.finup = mv_cesa_ahash_finup,
+	.digest = mv_cesa_sha1_digest,
+	.export = mv_cesa_sha1_export,
+	.halg = {
+		.digestsize = SHA1_DIGEST_SIZE,
+		.base = {
+			.cra_name = "sha1",
+			.cra_driver_name = "mv-sha1",
+			.cra_priority = 300,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = SHA1_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct mv_cesa_hash_ctx),
+			.cra_init = mv_cesa_ahash_cra_init,
+			.cra_module = THIS_MODULE,
+		 }
+	}
+};
+
+static int mv_cesa_sha256_init(struct ahash_request *req)
+{
+	struct mv_cesa_op_ctx tmpl;
+
+	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_MACM_SHA256);
+
+	mv_cesa_ahash_init(req, &tmpl);
+
+	return 0;
+}
+
+static int mv_cesa_sha256_digest(struct ahash_request *req)
+{
+	int ret;
+
+	ret = mv_cesa_sha256_init(req);
+	if (ret)
+		return ret;
+
+	return mv_cesa_ahash_finup(req);
+}
+
+static int mv_cesa_sha256_export(struct ahash_request *req, void *out)
+{
+	struct sha256_state *out_state = out;
+	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+	unsigned int ds = crypto_ahash_digestsize(ahash);
+
+	out_state->count = creq->len;
+	memcpy(out_state->state, creq->state, ds);
+	memset(out_state->buf, 0, sizeof(out_state->buf));
+	if (creq->cache)
+		memcpy(out_state->buf, creq->cache, creq->cache_ptr);
+
+	return 0;
+}
+
+struct ahash_alg mv_sha256_alg = {
+	.init = mv_cesa_sha256_init,
+	.update = mv_cesa_ahash_update,
+	.final = mv_cesa_ahash_final,
+	.finup = mv_cesa_ahash_finup,
+	.digest = mv_cesa_sha256_digest,
+	.export = mv_cesa_sha256_export,
+	.halg = {
+		.digestsize = SHA256_DIGEST_SIZE,
+		.base = {
+			.cra_name = "sha256",
+			.cra_driver_name = "mv-sha256",
+			.cra_priority = 300,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = SHA256_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct mv_cesa_hash_ctx),
+			.cra_init = mv_cesa_ahash_cra_init,
+			.cra_module = THIS_MODULE,
+		 }
+	}
+};
+
+struct mv_cesa_ahash_result {
+	struct completion completion;
+	int error;
+};
+
+static void mv_cesa_hmac_ahash_complete(struct crypto_async_request *req,
+					int error)
+{
+	struct mv_cesa_ahash_result *result = req->data;
+
+	if (error == -EINPROGRESS)
+		return;
+
+	result->error = error;
+	complete(&result->completion);
+}
+
+static int mv_cesa_ahmac_iv_state_init(struct ahash_request *req, u8 *pad,
+				       void *state, unsigned int blocksize)
+{
+	struct mv_cesa_ahash_result result;
+	struct scatterlist sg;
+	int ret;
+
+	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				   mv_cesa_hmac_ahash_complete, &result);
+	sg_init_one(&sg, pad, blocksize);
+	ahash_request_set_crypt(req, &sg, pad, blocksize);
+	init_completion(&result.completion);
+
+	ret = crypto_ahash_init(req);
+	if (ret)
+		return ret;
+
+	ret = crypto_ahash_update(req);
+	if (ret && ret != -EINPROGRESS)
+		return ret;
+
+	wait_for_completion_interruptible(&result.completion);
+	if (result.error)
+		return result.error;
+
+	ret = crypto_ahash_export(req, state);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int mv_cesa_ahmac_pad_init(struct ahash_request *req,
+				  const u8 *key, unsigned int keylen,
+				  u8 *ipad, u8 *opad,
+				  unsigned int blocksize)
+{
+	struct mv_cesa_ahash_result result;
+	struct scatterlist sg;
+	int ret;
+	int i;
+
+	if (keylen <= blocksize) {
+		memcpy(ipad, key, keylen);
+	} else {
+		u8 *keydup = kmemdup(key, keylen, GFP_KERNEL);
+
+		if (!keydup)
+			return -ENOMEM;
+
+		ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+					   mv_cesa_hmac_ahash_complete,
+					   &result);
+		sg_init_one(&sg, keydup, keylen);
+		ahash_request_set_crypt(req, &sg, ipad, keylen);
+		init_completion(&result.completion);
+
+		ret = crypto_ahash_digest(req);
+		if (ret == -EINPROGRESS) {
+			wait_for_completion_interruptible(&result.completion);
+			ret = result.error;
+		}
+
+		/* Set the memory region to 0 to avoid any leak. */
+		memset(keydup, 0, keylen);
+		kfree(keydup);
+
+		if (ret)
+			return ret;
+
+		keylen = crypto_ahash_digestsize(crypto_ahash_reqtfm(req));
+	}
+
+	memset(ipad + keylen, 0, blocksize - keylen);
+	memcpy(opad, ipad, blocksize);
+
+	for (i = 0; i < blocksize; i++) {
+		ipad[i] ^= 0x36;
+		opad[i] ^= 0x5c;
+	}
+
+	return 0;
+}
+
+static int mv_cesa_ahmac_setkey(const char *hash_alg_name,
+				const u8 *key, unsigned int keylen,
+				void *istate, void *ostate)
+{
+	struct ahash_request *req;
+	struct crypto_ahash *tfm;
+	unsigned int blocksize;
+	u8 *ipad = NULL;
+	u8 *opad;
+	int ret;
+
+	tfm = crypto_alloc_ahash(hash_alg_name, CRYPTO_ALG_TYPE_AHASH,
+				 CRYPTO_ALG_TYPE_AHASH_MASK);
+	if (IS_ERR(tfm))
+		return PTR_ERR(tfm);
+
+	req = ahash_request_alloc(tfm, GFP_KERNEL);
+	if (!req) {
+		ret = -ENOMEM;
+		goto free_ahash;
+	}
+
+	crypto_ahash_clear_flags(tfm, ~0);
+
+	blocksize = crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
+
+	ipad = kzalloc(2 * blocksize, GFP_KERNEL);
+	if (!ipad) {
+		ret = -ENOMEM;
+		goto free_req;
+	}
+
+	opad = ipad + blocksize;
+
+	ret = mv_cesa_ahmac_pad_init(req, key, keylen, ipad, opad, blocksize);
+	if (ret)
+		goto free_ipad;
+
+	ret = mv_cesa_ahmac_iv_state_init(req, ipad, istate, blocksize);
+	if (ret)
+		goto free_ipad;
+
+	ret = mv_cesa_ahmac_iv_state_init(req, opad, ostate, blocksize);
+
+free_ipad:
+	kfree(ipad);
+free_req:
+	ahash_request_free(req);
+free_ahash:
+	crypto_free_ahash(tfm);
+
+	return ret;
+}
+
+static int mv_cesa_ahmac_cra_init(struct crypto_tfm *tfm)
+{
+	struct mv_cesa_hmac_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	ctx->base.ops = &mv_cesa_ahash_req_ops;
+
+	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
+				 sizeof(struct mv_cesa_ahash_req));
+	return 0;
+}
+
+static int mv_cesa_ahmac_md5_init(struct ahash_request *req)
+{
+	struct mv_cesa_hmac_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
+	struct mv_cesa_op_ctx tmpl;
+
+	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_MACM_HMAC_MD5);
+	memcpy(tmpl.ctx.hash.iv, ctx->iv, sizeof(ctx->iv));
+
+	mv_cesa_ahash_init(req, &tmpl);
+
+	return 0;
+}
+
+static int mv_cesa_ahmac_md5_setkey(struct crypto_ahash *tfm, const u8 *key,
+				    unsigned int keylen)
+{
+	struct mv_cesa_hmac_ctx *ctx = crypto_tfm_ctx(crypto_ahash_tfm(tfm));
+	struct md5_state istate, ostate;
+	int ret, i;
+
+	ret = mv_cesa_ahmac_setkey("mv-md5", key, keylen, &istate, &ostate);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < ARRAY_SIZE(istate.hash); i++)
+		ctx->iv[i] = be32_to_cpu(istate.hash[i]);
+
+	for (i = 0; i < ARRAY_SIZE(ostate.hash); i++)
+		ctx->iv[i + 8] = be32_to_cpu(ostate.hash[i]);
+
+	return 0;
+}
+
+static int mv_cesa_ahmac_md5_digest(struct ahash_request *req)
+{
+	int ret;
+
+	ret = mv_cesa_ahmac_md5_init(req);
+	if (ret)
+		return ret;
+
+	return mv_cesa_ahash_finup(req);
+}
+
+struct ahash_alg mv_ahmac_md5_alg = {
+	.init = mv_cesa_ahmac_md5_init,
+	.update = mv_cesa_ahash_update,
+	.final = mv_cesa_ahash_final,
+	.finup = mv_cesa_ahash_finup,
+	.digest = mv_cesa_ahmac_md5_digest,
+	.setkey = mv_cesa_ahmac_md5_setkey,
+	.halg = {
+		.digestsize = MD5_DIGEST_SIZE,
+		.statesize = sizeof(struct md5_state),
+		.base = {
+			.cra_name = "hmac(md5)",
+			.cra_driver_name = "mv-hmac-md5",
+			.cra_priority = 300,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct mv_cesa_hmac_ctx),
+			.cra_init = mv_cesa_ahmac_cra_init,
+			.cra_module = THIS_MODULE,
+		 }
+	}
+};
+
+static int mv_cesa_ahmac_sha1_init(struct ahash_request *req)
+{
+	struct mv_cesa_hmac_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
+	struct mv_cesa_op_ctx tmpl;
+
+	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_MACM_HMAC_SHA1);
+	memcpy(tmpl.ctx.hash.iv, ctx->iv, sizeof(ctx->iv));
+
+	mv_cesa_ahash_init(req, &tmpl);
+
+	return 0;
+}
+
+static int mv_cesa_ahmac_sha1_setkey(struct crypto_ahash *tfm, const u8 *key,
+				     unsigned int keylen)
+{
+	struct mv_cesa_hmac_ctx *ctx = crypto_tfm_ctx(crypto_ahash_tfm(tfm));
+	struct sha1_state istate, ostate;
+	int ret, i;
+
+	ret = mv_cesa_ahmac_setkey("mv-sha1", key, keylen, &istate, &ostate);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < ARRAY_SIZE(istate.state); i++)
+		ctx->iv[i] = be32_to_cpu(istate.state[i]);
+
+	for (i = 0; i < ARRAY_SIZE(ostate.state); i++)
+		ctx->iv[i + 8] = be32_to_cpu(ostate.state[i]);
+
+	return 0;
+}
+
+static int mv_cesa_ahmac_sha1_digest(struct ahash_request *req)
+{
+	int ret;
+
+	ret = mv_cesa_ahmac_sha1_init(req);
+	if (ret)
+		return ret;
+
+	return mv_cesa_ahash_finup(req);
+}
+
+struct ahash_alg mv_ahmac_sha1_alg = {
+	.init = mv_cesa_ahmac_sha1_init,
+	.update = mv_cesa_ahash_update,
+	.final = mv_cesa_ahash_final,
+	.finup = mv_cesa_ahash_finup,
+	.digest = mv_cesa_ahmac_sha1_digest,
+	.setkey = mv_cesa_ahmac_sha1_setkey,
+	.halg = {
+		.digestsize = SHA1_DIGEST_SIZE,
+		.statesize = sizeof(struct sha1_state),
+		.base = {
+			.cra_name = "hmac(sha1)",
+			.cra_driver_name = "mv-hmac-sha1",
+			.cra_priority = 300,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = SHA1_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct mv_cesa_hmac_ctx),
+			.cra_init = mv_cesa_ahmac_cra_init,
+			.cra_module = THIS_MODULE,
+		 }
+	}
+};
+
+static int mv_cesa_ahmac_sha256_setkey(struct crypto_ahash *tfm, const u8 *key,
+				       unsigned int keylen)
+{
+	struct mv_cesa_hmac_ctx *ctx = crypto_tfm_ctx(crypto_ahash_tfm(tfm));
+	struct sha256_state istate, ostate;
+	int ret, i;
+
+	ret = mv_cesa_ahmac_setkey("mv-sha256", key, keylen, &istate, &ostate);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < ARRAY_SIZE(istate.state); i++)
+		ctx->iv[i] = be32_to_cpu(istate.state[i]);
+
+	for (i = 0; i < ARRAY_SIZE(ostate.state); i++)
+		ctx->iv[i + 8] = be32_to_cpu(ostate.state[i]);
+
+	return 0;
+}
+
+static int mv_cesa_ahmac_sha256_init(struct ahash_request *req)
+{
+	struct mv_cesa_hmac_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
+	struct mv_cesa_op_ctx tmpl;
+
+	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_MACM_HMAC_SHA256);
+	memcpy(tmpl.ctx.hash.iv, ctx->iv, sizeof(ctx->iv));
+
+	mv_cesa_ahash_init(req, &tmpl);
+
+	return 0;
+}
+
+static int mv_cesa_ahmac_sha256_digest(struct ahash_request *req)
+{
+	int ret;
+
+	ret = mv_cesa_ahmac_sha256_init(req);
+	if (ret)
+		return ret;
+
+	return mv_cesa_ahash_finup(req);
+}
+
+struct ahash_alg mv_ahmac_sha256_alg = {
+	.init = mv_cesa_ahmac_sha256_init,
+	.update = mv_cesa_ahash_update,
+	.final = mv_cesa_ahash_final,
+	.finup = mv_cesa_ahash_finup,
+	.digest = mv_cesa_ahmac_sha256_digest,
+	.setkey = mv_cesa_ahmac_sha256_setkey,
+	.halg = {
+		.digestsize = SHA256_DIGEST_SIZE,
+		.statesize = sizeof(struct sha256_state),
+		.base = {
+			.cra_name = "hmac(sha256)",
+			.cra_driver_name = "mv-hmac-sha256",
+			.cra_priority = 300,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = SHA256_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct mv_cesa_hmac_ctx),
+			.cra_init = mv_cesa_ahmac_cra_init,
+			.cra_module = THIS_MODULE,
+		 }
+	}
+};
diff --git a/drivers/crypto/marvell/tdma.c b/drivers/crypto/marvell/tdma.c
new file mode 100644
index 0000000..1084c5a
--- /dev/null
+++ b/drivers/crypto/marvell/tdma.c
@@ -0,0 +1,223 @@
+/*
+ * Provide TDMA helper functions used by cipher and hash algorithm
+ * implementations.
+ *
+ * Author: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
+ * Author: Arnaud Ebalard <arno-LkuqDEemtHBg9hUCZPvPmw@public.gmane.org>
+ *
+ * This work is based on an initial version written by
+ * Sebastian Andrzej Siewior < sebastian at breakpoint dot cc >
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ */
+
+#include "cesa.h"
+
+bool mv_cesa_req_dma_iter_next_transfer(struct mv_cesa_dma_iter *iter,
+					struct mv_cesa_sg_dma_iter *sgiter,
+					unsigned int len)
+{
+	if (!sgiter->sg)
+		return false;
+
+	sgiter->op_offset += len;
+	sgiter->offset += len;
+	if (sgiter->offset == sgiter->sg->length) {
+		if (sg_is_last(sgiter->sg))
+			return false;
+		sgiter->offset = 0;
+		sgiter->sg = sg_next(sgiter->sg);
+	}
+
+	if (sgiter->op_offset == iter->op_len)
+		return false;
+
+	return true;
+}
+
+void mv_cesa_dma_step(struct mv_cesa_tdma_req *dreq)
+{
+	struct mv_cesa_engine *engine = dreq->base.engine;
+
+	writel(0, engine->regs + CESA_SA_CFG);
+
+	mv_cesa_set_int_mask(engine, CESA_SA_INT_ACC0_IDMA_DONE);
+	writel(CESA_TDMA_DST_BURST_128B | CESA_TDMA_SRC_BURST_128B |
+	       CESA_TDMA_NO_BYTE_SWAP | CESA_TDMA_EN,
+	       engine->regs + CESA_TDMA_CONTROL);
+
+	writel(CESA_SA_CFG_ACT_CH0_IDMA | CESA_SA_CFG_MULTI_PKT |
+	       CESA_SA_CFG_CH0_W_IDMA | CESA_SA_CFG_PARA_DIS,
+	       engine->regs + CESA_SA_CFG);
+	writel(dreq->chain.first->cur_dma,
+	       engine->regs + CESA_TDMA_NEXT_ADDR);
+	writel(CESA_SA_CMD_EN_CESA_SA_ACCL0, engine->regs + CESA_SA_CMD);
+}
+
+void mv_cesa_dma_cleanup(struct mv_cesa_tdma_req *dreq)
+{
+	struct mv_cesa_tdma_desc *tdma;
+
+	for (tdma = dreq->chain.first; tdma;) {
+		struct mv_cesa_tdma_desc *old_tdma = tdma;
+
+		if (tdma->op)
+			dma_pool_free(cesa_dev->dma->op_pool, tdma->op,
+				      le32_to_cpu(tdma->src));
+
+		tdma = tdma->next;
+		dma_pool_free(cesa_dev->dma->tdma_desc_pool, old_tdma,
+			      le32_to_cpu(old_tdma->cur_dma));
+	}
+
+	dreq->chain.first = NULL;
+	dreq->chain.last = NULL;
+}
+
+void mv_cesa_dma_prepare(struct mv_cesa_tdma_req *dreq,
+			 struct mv_cesa_engine *engine)
+{
+	struct mv_cesa_tdma_desc *tdma;
+
+	for (tdma = dreq->chain.first; tdma; tdma = tdma->next) {
+		if (tdma->flags & CESA_TDMA_DST_IN_SRAM)
+			tdma->dst = cpu_to_le32(tdma->dst + engine->sram_dma);
+
+		if (tdma->flags & CESA_TDMA_SRC_IN_SRAM)
+			tdma->src = cpu_to_le32(tdma->src + engine->sram_dma);
+
+		if (tdma->op)
+			mv_cesa_adjust_op(engine, tdma->op);
+	}
+}
+
+static struct mv_cesa_tdma_desc *
+mv_cesa_dma_add_desc(struct mv_cesa_tdma_chain *chain, gfp_t flags)
+{
+	struct mv_cesa_tdma_desc *new_tdma = NULL;
+	dma_addr_t dma_handle;
+
+	new_tdma = dma_pool_alloc(cesa_dev->dma->tdma_desc_pool, flags,
+				  &dma_handle);
+	if (!new_tdma)
+		return ERR_PTR(-ENOMEM);
+
+	memset(new_tdma, 0, sizeof(*new_tdma));
+	new_tdma->cur_dma = cpu_to_le32(dma_handle);
+	if (chain->last) {
+		chain->last->next_dma = new_tdma->cur_dma;
+		chain->last->next = new_tdma;
+	} else {
+		chain->first = new_tdma;
+	}
+
+	chain->last = new_tdma;
+
+	return new_tdma;
+}
+
+struct mv_cesa_op_ctx *mv_cesa_dma_add_op(struct mv_cesa_tdma_chain *chain,
+					const struct mv_cesa_op_ctx *op_templ,
+					gfp_t flags)
+{
+	struct mv_cesa_tdma_desc *tdma;
+	struct mv_cesa_op_ctx *op;
+	dma_addr_t dma_handle;
+
+	tdma = mv_cesa_dma_add_desc(chain, flags);
+	if (IS_ERR(tdma))
+		return ERR_CAST(tdma);
+
+	op = dma_pool_alloc(cesa_dev->dma->op_pool, flags, &dma_handle);
+	if (!op)
+		return ERR_PTR(-ENOMEM);
+
+	*op = *op_templ;
+
+	tdma = chain->last;
+	tdma->op = op;
+	tdma->byte_cnt = sizeof(*op) | BIT(31);
+	tdma->src = dma_handle;
+	tdma->flags = CESA_TDMA_DST_IN_SRAM | CESA_TDMA_OP;
+
+	return op;
+}
+
+int mv_cesa_dma_add_data_transfer(struct mv_cesa_tdma_chain *chain,
+				  dma_addr_t dst, dma_addr_t src, u32 size,
+				  u32 flags, gfp_t gfp_flags)
+{
+	struct mv_cesa_tdma_desc *tdma;
+
+	tdma = mv_cesa_dma_add_desc(chain, gfp_flags);
+	if (IS_ERR(tdma))
+		return PTR_ERR(tdma);
+
+	tdma->byte_cnt = size | BIT(31);
+	tdma->src = src;
+	tdma->dst = dst;
+
+	flags &= (CESA_TDMA_DST_IN_SRAM | CESA_TDMA_SRC_IN_SRAM);
+	tdma->flags = flags | CESA_TDMA_DATA;
+
+	return 0;
+}
+
+int mv_cesa_dma_add_dummy_launch(struct mv_cesa_tdma_chain *chain,
+				 u32 flags)
+{
+	struct mv_cesa_tdma_desc *tdma;
+
+	tdma = mv_cesa_dma_add_desc(chain, flags);
+	if (IS_ERR(tdma))
+		return PTR_ERR(tdma);
+
+	return 0;
+}
+
+int mv_cesa_dma_add_dummy_end(struct mv_cesa_tdma_chain *chain, u32 flags)
+{
+	struct mv_cesa_tdma_desc *tdma;
+
+	tdma = mv_cesa_dma_add_desc(chain, flags);
+	if (IS_ERR(tdma))
+		return PTR_ERR(tdma);
+
+	tdma->byte_cnt = BIT(31);
+
+	return 0;
+}
+
+int mv_cesa_dma_add_op_transfers(struct mv_cesa_tdma_chain *chain,
+				 struct mv_cesa_dma_iter *dma_iter,
+				 struct mv_cesa_sg_dma_iter *sgiter,
+				 gfp_t gfp_flags)
+{
+	u32 flags = sgiter->dir == DMA_TO_DEVICE ?
+		    CESA_TDMA_DST_IN_SRAM : CESA_TDMA_SRC_IN_SRAM;
+	unsigned int len;
+
+	do {
+		dma_addr_t dst, src;
+		int ret;
+
+		len = mv_cesa_req_dma_iter_transfer_len(dma_iter, sgiter);
+		if (sgiter->dir == DMA_TO_DEVICE) {
+			dst = CESA_SA_DATA_SRAM_OFFSET + sgiter->op_offset;
+			src = sgiter->sg->dma_address + sgiter->offset;
+		} else {
+			dst = sgiter->sg->dma_address + sgiter->offset;
+			src = CESA_SA_DATA_SRAM_OFFSET + sgiter->op_offset;
+		}
+
+		ret = mv_cesa_dma_add_data_transfer(chain, dst, src, len,
+						    flags, gfp_flags);
+		if (ret)
+			return ret;
+
+	} while (mv_cesa_req_dma_iter_next_transfer(dma_iter, sgiter, len));
+
+	return 0;
+}
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
