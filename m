From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH 1/2] crypto: add new driver for Marvell CESA
Date: Thu,  9 Apr 2015 16:58:42 +0200
Message-ID: <1428591523-1780-2-git-send-email-boris.brezillon@free-electrons.com>
References: <1428591523-1780-1-git-send-email-boris.brezillon@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
	Tawfik Bayouk <tawfik@marvell.com>,
	Lior Amsalem <alior@marvell.com>,
	Nadav Haklai <nadavh@marvell.com>,
	Eran Ben-Avi <benavi@marvell.com>,
	Thomas Petazzoni <info@free-electrons.com>,
	Gregory CLEMENT <gregory.clement@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Arnaud Ebalard <arno@natisbad.org>,
	Boris Brezillon <boris.brezillon@free-electrons.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1428591523-1780-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The existing mv_cesa driver supports some features of the CESA IP but i=
s
quite limited, and reworking it to support new features (like involving=
 the
TDMA engine to offload the CPU) is almost impossible.
This driver has been rewritten from scratch to take those new features =
into
account.

This new driver adds support for:
- new armada SoCs (up to 38x) while keeping support for older ones (Ori=
on
  and Kirkwood)
- DMA mode to offload the CPU in case of intensive crypto usage
- new algorithms: SHA256, DES and 3DES

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Signed-off-by: Arnaud Ebalard <arno@natisbad.org>
---
 drivers/crypto/Kconfig          |    2 +
 drivers/crypto/Makefile         |    2 +-
 drivers/crypto/marvell/Makefile |    1 +
 drivers/crypto/marvell/cesa.c   |  539 ++++++++++++++++
 drivers/crypto/marvell/cesa.h   |  802 +++++++++++++++++++++++
 drivers/crypto/marvell/cipher.c |  761 ++++++++++++++++++++++
 drivers/crypto/marvell/hash.c   | 1349 +++++++++++++++++++++++++++++++=
++++++++
 drivers/crypto/marvell/tdma.c   |  223 +++++++
 drivers/crypto/mv_cesa.c        | 1193 -------------------------------=
---
 drivers/crypto/mv_cesa.h        |  150 -----
 10 files changed, 3678 insertions(+), 1344 deletions(-)
 create mode 100644 drivers/crypto/marvell/Makefile
 create mode 100644 drivers/crypto/marvell/cesa.c
 create mode 100644 drivers/crypto/marvell/cesa.h
 create mode 100644 drivers/crypto/marvell/cipher.c
 create mode 100644 drivers/crypto/marvell/hash.c
 create mode 100644 drivers/crypto/marvell/tdma.c
 delete mode 100644 drivers/crypto/mv_cesa.c
 delete mode 100644 drivers/crypto/mv_cesa.h

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 2fb0fdf..a3f61ab 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -164,8 +164,10 @@ config CRYPTO_DEV_MV_CESA
 	depends on PLAT_ORION
 	select CRYPTO_ALGAPI
 	select CRYPTO_AES
+	select CRYPTO_DES
 	select CRYPTO_BLKCIPHER2
 	select CRYPTO_HASH
+	select SRAM
 	help
 	  This driver allows you to utilize the Cryptographic Engines and
 	  Security Accelerator (CESA) which can be found on the Marvell Orion
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 3924f93..77a56aa 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -7,7 +7,7 @@ obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM) +=3D caam/
 obj-$(CONFIG_CRYPTO_DEV_GEODE) +=3D geode-aes.o
 obj-$(CONFIG_CRYPTO_DEV_HIFN_795X) +=3D hifn_795x.o
 obj-$(CONFIG_CRYPTO_DEV_IXP4XX) +=3D ixp4xx_crypto.o
-obj-$(CONFIG_CRYPTO_DEV_MV_CESA) +=3D mv_cesa.o
+obj-$(CONFIG_CRYPTO_DEV_MV_CESA) +=3D marvell/
 obj-$(CONFIG_CRYPTO_DEV_MXS_DCP) +=3D mxs-dcp.o
 obj-$(CONFIG_CRYPTO_DEV_NIAGARA2) +=3D n2_crypto.o
 n2_crypto-y :=3D n2_core.o n2_asm.o
diff --git a/drivers/crypto/marvell/Makefile b/drivers/crypto/marvell/M=
akefile
new file mode 100644
index 0000000..a241e94
--- /dev/null
+++ b/drivers/crypto/marvell/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_CRYPTO_DEV_MV_CESA) +=3D cesa.o cipher.o hash.o tdma.o
diff --git a/drivers/crypto/marvell/cesa.c b/drivers/crypto/marvell/ces=
a.c
new file mode 100644
index 0000000..0cefba8
--- /dev/null
+++ b/drivers/crypto/marvell/cesa.c
@@ -0,0 +1,539 @@
+/*
+ * Support for Marvell's Cryptographic Engine and Security Accelerator=
 (CESA)
+ * that can be found on the following platform: Orion, Kirkwood, Armad=
a. This
+ * driver supports the TDMA engine on platforms on which it is availab=
le.
+ *
+ * Author: Boris Brezillon <boris.brezillon@free-electrons.com>
+ * Author: Arnaud Ebalard <arno@natisbad.org>
+ *
+ * This work is based on an initial version written by
+ * Sebastian Andrzej Siewior < sebastian at breakpoint dot cc >
+ *
+ * This program is free software; you can redistribute it and/or modif=
y it
+ * under the terms of the GNU General Public License version 2 as publ=
ished
+ * by the Free Software Foundation.
+ */
+
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
+struct mv_cesa_dev *cesa_dev;
+
+static void mv_cesa_dequeue_req_unlocked(struct mv_cesa_engine *engine=
)
+{
+	struct crypto_async_request *req;
+	struct mv_cesa_ctx *ctx;
+
+	spin_lock_bh(&cesa_dev->lock);
+	req =3D crypto_dequeue_request(&cesa_dev->queue);
+	engine->req =3D req;
+	spin_unlock_bh(&cesa_dev->lock);
+
+	if (!req)
+		return;
+
+	ctx =3D crypto_tfm_ctx(req->tfm);
+	ctx->ops->prepare(req, engine);
+	ctx->ops->step(req);
+}
+
+static irqreturn_t mv_cesa_int(int irq, void *priv)
+{
+	struct mv_cesa_engine *engine =3D priv;
+	struct crypto_async_request *req;
+	struct mv_cesa_ctx *ctx;
+	u32 status, mask;
+	irqreturn_t ret =3D IRQ_NONE;
+
+	while (true) {
+		int res;
+
+		mask =3D mv_cesa_get_int_mask(engine);
+		status =3D readl(engine->regs + CESA_SA_INT_STATUS);
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
+		ret =3D IRQ_HANDLED;
+		spin_lock_bh(&engine->lock);
+		req =3D engine->req;
+		spin_unlock_bh(&engine->lock);
+		if (req) {
+			ctx =3D crypto_tfm_ctx(req->tfm);
+			res =3D ctx->ops->process(req, status & mask);
+			if (res !=3D -EINPROGRESS) {
+				spin_lock_bh(&engine->lock);
+				engine->req =3D NULL;
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
+	ret =3D crypto_enqueue_request(&cesa_dev->queue, req);
+	spin_unlock_bh(&cesa_dev->lock);
+
+	if (ret !=3D -EINPROGRESS)
+		return ret;
+
+	for (i =3D 0; i < cesa_dev->caps->nengines; i++) {
+		spin_lock_bh(&cesa_dev->engines[i].lock);
+		if (!cesa_dev->engines[i].req)
+			mv_cesa_dequeue_req_unlocked(&cesa_dev->engines[i]);
+		spin_unlock_bh(&cesa_dev->engines[i].lock);
+	}
+
+	return -EINPROGRESS;
+}
+
+
+
+static int mv_cesa_add_algs(struct mv_cesa_dev *cesa)
+{
+	int ret;
+	int i, j;
+
+	for (i =3D 0; i < cesa->caps->ncipher_algs; i++) {
+		ret =3D crypto_register_alg(cesa->caps->cipher_algs[i]);
+		if (ret)
+			goto err_unregister_crypto;
+	}
+
+	for (i =3D 0; i < cesa->caps->nahash_algs; i++) {
+		ret =3D crypto_register_ahash(cesa->caps->ahash_algs[i]);
+		if (ret)
+			goto err_unregister_ahash;
+	}
+
+	return 0;
+
+err_unregister_ahash:
+	for (j =3D 0; j < i; j++)
+		crypto_unregister_ahash(cesa->caps->ahash_algs[j]);
+	i =3D cesa->caps->ncipher_algs;
+
+err_unregister_crypto:
+	for (j =3D 0; j < i; j++)
+		crypto_unregister_alg(cesa->caps->cipher_algs[j]);
+
+	return ret;
+}
+
+static void mv_cesa_remove_algs(struct mv_cesa_dev *cesa)
+{
+	int i;
+
+	for (i =3D 0; i < cesa->caps->nahash_algs; i++)
+		crypto_unregister_ahash(cesa->caps->ahash_algs[i]);
+
+	for (i =3D 0; i < cesa->caps->ncipher_algs; i++)
+		crypto_unregister_alg(cesa->caps->cipher_algs[i]);
+}
+
+static struct crypto_alg *orion_cipher_algs[] =3D {
+	&mv_cesa_ecb_des_alg,
+	&mv_cesa_cbc_des_alg,
+	&mv_cesa_ecb_des3_ede_alg,
+	&mv_cesa_cbc_des3_ede_alg,
+	&mv_cesa_ecb_aes_alg,
+	&mv_cesa_cbc_aes_alg,
+};
+
+static struct ahash_alg *orion_ahash_algs[] =3D {
+	&mv_md5_alg,
+	&mv_sha1_alg,
+	&mv_ahmac_md5_alg,
+	&mv_ahmac_sha1_alg,
+};
+
+static struct crypto_alg *armada_370_cipher_algs[] =3D {
+	&mv_cesa_ecb_des_alg,
+	&mv_cesa_cbc_des_alg,
+	&mv_cesa_ecb_des3_ede_alg,
+	&mv_cesa_cbc_des3_ede_alg,
+	&mv_cesa_ecb_aes_alg,
+	&mv_cesa_cbc_aes_alg,
+};
+
+static struct ahash_alg *armada_370_ahash_algs[] =3D {
+	&mv_md5_alg,
+	&mv_sha1_alg,
+	&mv_sha256_alg,
+	&mv_ahmac_md5_alg,
+	&mv_ahmac_sha1_alg,
+	&mv_ahmac_sha256_alg,
+};
+
+static const struct mv_cesa_caps orion_caps =3D {
+	.nengines =3D 1,
+	.cipher_algs =3D orion_cipher_algs,
+	.ncipher_algs =3D ARRAY_SIZE(orion_cipher_algs),
+	.ahash_algs =3D orion_ahash_algs,
+	.nahash_algs =3D ARRAY_SIZE(orion_ahash_algs),
+	.has_tdma =3D false,
+};
+
+static const struct mv_cesa_caps kirkwood_caps =3D {
+	.nengines =3D 1,
+	.cipher_algs =3D orion_cipher_algs,
+	.ncipher_algs =3D ARRAY_SIZE(orion_cipher_algs),
+	.ahash_algs =3D orion_ahash_algs,
+	.nahash_algs =3D ARRAY_SIZE(orion_ahash_algs),
+	.has_tdma =3D true,
+};
+
+static const struct mv_cesa_caps armada_370_caps =3D {
+	.nengines =3D 1,
+	.cipher_algs =3D armada_370_cipher_algs,
+	.ncipher_algs =3D ARRAY_SIZE(armada_370_cipher_algs),
+	.ahash_algs =3D armada_370_ahash_algs,
+	.nahash_algs =3D ARRAY_SIZE(armada_370_ahash_algs),
+	.has_tdma =3D true,
+};
+
+static const struct mv_cesa_caps armada_xp_caps =3D {
+	.nengines =3D 2,
+	.cipher_algs =3D armada_370_cipher_algs,
+	.ncipher_algs =3D ARRAY_SIZE(armada_370_cipher_algs),
+	.ahash_algs =3D armada_370_ahash_algs,
+	.nahash_algs =3D ARRAY_SIZE(armada_370_ahash_algs),
+	.has_tdma =3D true,
+};
+
+static const struct of_device_id mv_cesa_of_match_table[] =3D {
+	{ .compatible =3D "marvell,orion-crypto", .data =3D &orion_caps },
+	{ .compatible =3D "marvell,kirkwood-crypto", .data =3D &kirkwood_caps=
 },
+	{ .compatible =3D "marvell,armada-370-crypto", .data =3D &armada_370_=
caps },
+	{ .compatible =3D "marvell,armada-xp-crypto", .data =3D &armada_xp_ca=
ps },
+	{ .compatible =3D "marvell,armada-375-crypto", .data =3D &armada_xp_c=
aps },
+	{ .compatible =3D "marvell,armada-38x-crypto", .data =3D &armada_xp_c=
aps },
+	{}
+};
+MODULE_DEVICE_TABLE(of, mv_cesa_of_match_table);
+
+static void
+mv_cesa_conf_mbus_windows(struct mv_cesa_engine *engine,
+			  const struct mbus_dram_target_info *dram)
+{
+	void __iomem *iobase =3D engine->regs;
+	int i;
+
+	for (i =3D 0; i < 4; i++) {
+		writel(0, iobase + CESA_TDMA_WINDOW_CTRL(i));
+		writel(0, iobase + CESA_TDMA_WINDOW_BASE(i));
+	}
+
+	for (i =3D 0; i < dram->num_cs; i++) {
+		const struct mbus_dram_window *cs =3D dram->cs + i;
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
+	struct device *dev =3D cesa->dev;
+	struct mv_cesa_dev_dma *dma;
+
+	if (!cesa->caps->has_tdma)
+		return 0;
+
+	dma =3D devm_kzalloc(dev, sizeof(*dma), GFP_KERNEL);
+	if (!dma)
+		return -ENOMEM;
+
+	dma->tdma_desc_pool =3D dmam_pool_create("tdma_desc", dev,
+					sizeof(struct mv_cesa_tdma_desc),
+					16, 0);
+	if (!dma->tdma_desc_pool)
+		return -ENOMEM;
+
+	dma->op_pool =3D dmam_pool_create("cesa_op", dev,
+					sizeof(struct mv_cesa_op_ctx), 16, 0);
+	if (!dma->op_pool)
+		return -ENOMEM;
+
+	dma->cache_pool =3D dmam_pool_create("cesa_cache", dev,
+					   CESA_MAX_HASH_BLOCK_SIZE, 1, 0);
+	if (!dma->cache_pool)
+		return -ENOMEM;
+
+	dma->padding_pool =3D dmam_pool_create("cesa_padding", dev, 72, 1, 0)=
;
+	if (!dma->cache_pool)
+		return -ENOMEM;
+
+	cesa->dma =3D dma;
+
+	return 0;
+}
+
+static int mv_cesa_get_sram(struct platform_device *pdev, int idx)
+{
+	struct mv_cesa_dev *cesa =3D platform_get_drvdata(pdev);
+	struct mv_cesa_engine *engine =3D &cesa->engines[idx];
+	const char *res_name =3D "sram";
+	struct resource *res;
+
+	engine->pool =3D of_get_named_gen_pool(cesa->dev->of_node,
+					     "marvell,crypto-srams",
+					     idx);
+	if (engine->pool) {
+		engine->sram =3D gen_pool_dma_alloc(engine->pool,
+						  cesa->sram_size,
+						  &engine->sram_dma);
+		if (engine->sram)
+			return 0;
+
+		engine->pool =3D NULL;
+		return -ENOMEM;
+	}
+
+	if (cesa->caps->nengines > 1) {
+		if (!idx)
+			res_name =3D "sram0";
+		else
+			res_name =3D "sram1";
+	}
+
+	res =3D platform_get_resource_byname(pdev, IORESOURCE_MEM,
+					   res_name);
+	if (!res || resource_size(res) < cesa->sram_size)
+		return -EINVAL;
+
+	engine->sram =3D devm_ioremap_resource(cesa->dev, res);
+	if (IS_ERR(engine->sram))
+		return PTR_ERR(engine->sram);
+
+	engine->sram_dma =3D phys_to_dma(cesa->dev,
+				       (phys_addr_t)res->start);
+
+	return 0;
+}
+
+static void mv_cesa_put_sram(struct platform_device *pdev, int idx)
+{
+	struct mv_cesa_dev *cesa =3D platform_get_drvdata(pdev);
+	struct mv_cesa_engine *engine =3D &cesa->engines[idx];
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
+	const struct mv_cesa_caps *caps =3D &armada_xp_caps;
+	const struct mbus_dram_target_info *dram;
+	const struct of_device_id *match;
+	struct device *dev =3D &pdev->dev;
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
+		match =3D of_match_node(mv_cesa_of_match_table, dev->of_node);
+		if (match && match->data)
+			caps =3D match->data;
+	}
+
+	cesa =3D devm_kzalloc(dev, sizeof(*cesa), GFP_KERNEL);
+	if (!cesa)
+		return -ENOMEM;
+
+	cesa->caps =3D caps;
+	cesa->dev =3D dev;
+
+	sram_size =3D CESA_SA_DEFAULT_SRAM_SIZE;
+	of_property_read_u32(cesa->dev->of_node, "marvell,crypto-sram-size",
+			     &sram_size);
+	if (sram_size < CESA_SA_MIN_SRAM_SIZE)
+		sram_size =3D CESA_SA_MIN_SRAM_SIZE;
+
+	cesa->sram_size =3D sram_size;
+	cesa->engines =3D devm_kzalloc(dev, caps->nengines * sizeof(*engines)=
,
+				     GFP_KERNEL);
+	if (!cesa->engines)
+		return -ENOMEM;
+
+	spin_lock_init(&cesa->lock);
+	crypto_init_queue(&cesa->queue, 50);
+	res =3D platform_get_resource_byname(pdev, IORESOURCE_MEM, "regs");
+	cesa->regs =3D devm_ioremap_resource(dev, res);
+	if (IS_ERR(cesa->regs))
+		return -ENOMEM;
+
+	ret =3D mv_cesa_dev_dma_init(cesa);
+	if (ret)
+		return ret;
+
+	dram =3D mv_mbus_dram_info();
+
+	platform_set_drvdata(pdev, cesa);
+
+	for (i =3D 0; i < caps->nengines; i++) {
+		struct mv_cesa_engine *engine =3D &cesa->engines[i];
+		char res_name[7];
+
+		engine->id =3D i;
+		spin_lock_init(&engine->lock);
+
+		ret =3D mv_cesa_get_sram(pdev, i);
+		if (ret)
+			goto err_cleanup;
+
+		irq =3D platform_get_irq(pdev, i);
+		if (irq < 0) {
+			ret =3D irq;
+			goto err_cleanup;
+		}
+
+		/*
+		 * Not all platforms can gate the CESA clocks: do not complain
+		 * if the clock does not exist.
+		 */
+		snprintf(res_name, sizeof(res_name), "cesa%d", i);
+		engine->clk =3D devm_clk_get(dev, res_name);
+		if (IS_ERR(engine->clk)) {
+			engine->clk =3D devm_clk_get(dev, NULL);
+			if (IS_ERR(engine->clk))
+				engine->clk =3D NULL;
+		}
+
+		snprintf(res_name, sizeof(res_name), "cesaz%d", i);
+		engine->zclk =3D devm_clk_get(dev, res_name);
+		if (IS_ERR(engine->zclk))
+			engine->zclk =3D NULL;
+
+		ret =3D clk_prepare_enable(engine->clk);
+		if (ret)
+			goto err_cleanup;
+
+		ret =3D clk_prepare_enable(engine->zclk);
+		if (ret)
+			goto err_cleanup;
+
+		engine->regs =3D cesa->regs + CESA_ENGINE_OFF(i);
+
+		if (dram)
+			mv_cesa_conf_mbus_windows(&cesa->engines[i], dram);
+
+		writel(0, cesa->engines[i].regs + CESA_SA_INT_STATUS);
+		writel(CESA_SA_CFG_STOP_DIG_ERR,
+		       cesa->engines[i].regs + CESA_SA_CFG);
+		writel(engine->sram_dma & CESA_SA_SRAM_MSK,
+		       cesa->engines[i].regs + CESA_SA_DESC_P0);
+
+		ret =3D devm_request_threaded_irq(dev, irq, NULL, mv_cesa_int,
+						IRQF_ONESHOT,
+						dev_name(&pdev->dev),
+						&cesa->engines[i]);
+		if (ret)
+			goto err_cleanup;
+	}
+
+	cesa_dev =3D cesa;
+
+	ret =3D mv_cesa_add_algs(cesa);
+	if (ret) {
+		cesa_dev =3D NULL;
+		goto err_cleanup;
+	}
+
+	dev_info(dev, "CESA device successfully registered\n");
+
+	return 0;
+
+err_cleanup:
+	for (i =3D 0; i < caps->nengines; i++) {
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
+	struct mv_cesa_dev *cesa =3D platform_get_drvdata(pdev);
+	int i;
+
+	mv_cesa_remove_algs(cesa);
+
+	for (i =3D 0; i < cesa->caps->nengines; i++) {
+		clk_disable_unprepare(cesa->engines[i].zclk);
+		clk_disable_unprepare(cesa->engines[i].clk);
+		mv_cesa_put_sram(pdev, i);
+	}
+
+	return 0;
+}
+
+
+static struct platform_driver marvell_cesa =3D {
+	.probe		=3D mv_cesa_probe,
+	.remove		=3D mv_cesa_remove,
+	.driver		=3D {
+		.owner	=3D THIS_MODULE,
+		.name	=3D "mv_crypto",
+		.of_match_table =3D mv_cesa_of_match_table,
+	},
+};
+MODULE_ALIAS("platform:mv_crypto");
+
+module_platform_driver(marvell_cesa);
+
+MODULE_AUTHOR("Boris Brezillon <boris.brezillon@free-electrons.com>");
+MODULE_AUTHOR("Arnaud Ebalard <arno@natisbad.org>");
+MODULE_DESCRIPTION("Support for Marvell's cryptographic engine");
+MODULE_LICENSE("GPL");
diff --git a/drivers/crypto/marvell/cesa.h b/drivers/crypto/marvell/ces=
a.h
new file mode 100644
index 0000000..008c964
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
+#define CESA_SA_ST_ACT_0			(1 << 0)
+#define CESA_SA_ST_ACT_1			(1 << 1)
+
+/*
+ * CESA_SA_FPGA_INT_STATUS looks like a FPGA leftover and is documente=
d only
+ * in Errata 4.12. It looks like that it was part of an IRQ-controller=
 in FPGA
+ * and someone forgot to remove  it while switching to the core and mo=
ving to
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
+#define CESA_SA_DESC_MAC_TOTAL_LEN(total_len)	cpu_to_le32((total_len) =
<< 16)
+#define CESA_SA_DESC_MAC_TOTAL_LEN_MSK		GENMASK(31, 16)
+
+#define CESA_SA_DESC_MAC_SRC_TOTAL_LEN_MAX	0xffff
+
+#define CESA_SA_DESC_MAC_DIGEST(offset)					\
+	cpu_to_le32(CESA_SA_MAC_DIG_SRAM_OFFSET + (offset))
+#define CESA_SA_DESC_MAC_DIGEST_MSK		GENMASK(15, 0)
+
+#define CESA_SA_DESC_MAC_FRAG_LEN(frag_len)	cpu_to_le32((frag_len) << =
16)
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
+ * Structure passed to the CESA engine to describe the crypto operatio=
n
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
+ * Iterator used to iterate over a scatterlist while creating a TDMA c=
hain for
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
+ * @op_len:	sub-operation length (the crypto engine can only act on 2k=
b
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
+ * @padding_pool:	padding pool (used by hash implementation when hardw=
are
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
+ * @max_req_len:	maximum chunk length (useful to create the TDMA chain=
)
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
+ * struct mv_cesa_sg_std_iter - CESA scatter-gather iterator for stand=
ard
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
+	op->desc.config &=3D cpu_to_le32(~mask);
+	op->desc.config |=3D cpu_to_le32(cfg);
+}
+
+static inline u32 mv_cesa_get_op_cfg(struct mv_cesa_op_ctx *op)
+{
+	return le32_to_cpu(op->desc.config);
+}
+
+static inline void mv_cesa_set_op_cfg(struct mv_cesa_op_ctx *op, u32 c=
fg)
+{
+	op->desc.config =3D cpu_to_le32(cfg);
+}
+
+static inline void mv_cesa_adjust_op(struct mv_cesa_engine *engine,
+				     struct mv_cesa_op_ctx *op)
+{
+	u32 offset =3D engine->sram_dma & CESA_SA_SRAM_MSK;
+
+	op->desc.enc_p =3D CESA_SA_DESC_CRYPT_DATA(offset);
+	op->desc.enc_key_p =3D CESA_SA_DESC_CRYPT_KEY(offset);
+	op->desc.enc_iv =3D CESA_SA_DESC_CRYPT_IV(offset);
+	op->desc.mac_src_p &=3D ~CESA_SA_DESC_MAC_DATA_MSK;
+	op->desc.mac_src_p |=3D CESA_SA_DESC_MAC_DATA(offset);
+	op->desc.mac_digest &=3D ~CESA_SA_DESC_MAC_DIGEST_MSK;
+	op->desc.mac_digest |=3D CESA_SA_DESC_MAC_DIGEST(offset);
+	op->desc.mac_iv =3D CESA_SA_DESC_MAC_IV(offset);
+}
+
+static inline void mv_cesa_set_crypt_op_len(struct mv_cesa_op_ctx *op,=
 int len)
+{
+	op->desc.enc_len =3D cpu_to_le32(len);
+}
+
+static inline void mv_cesa_set_mac_op_total_len(struct mv_cesa_op_ctx =
*op,
+						int len)
+{
+	op->desc.mac_src_p &=3D ~CESA_SA_DESC_MAC_TOTAL_LEN_MSK;
+	op->desc.mac_src_p |=3D CESA_SA_DESC_MAC_TOTAL_LEN(len);
+}
+
+static inline void mv_cesa_set_mac_op_frag_len(struct mv_cesa_op_ctx *=
op,
+					       int len)
+{
+	op->desc.mac_digest &=3D ~CESA_SA_DESC_MAC_FRAG_LEN_MSK;
+	op->desc.mac_digest |=3D CESA_SA_DESC_MAC_FRAG_LEN(len);
+}
+
+static inline void mv_cesa_set_int_mask(struct mv_cesa_engine *engine,
+					u32 int_mask)
+{
+	if (int_mask =3D=3D engine->int_mask)
+		return;
+
+	writel(int_mask, engine->regs + CESA_SA_INT_MSK);
+	engine->int_mask =3D int_mask;
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
+	int nents =3D 0;
+
+	while (nbytes > 0) {
+		nents++;
+		nbytes -=3D sg->length;
+		sg =3D sg_next(sg);
+	}
+
+	return nents;
+}
+
+/* TDMA functions */
+
+static inline void mv_cesa_req_dma_iter_init(struct mv_cesa_dma_iter *=
iter,
+					     unsigned int len)
+{
+	iter->len =3D len;
+	iter->op_len =3D min(len, CESA_SA_SRAM_PAYLOAD_SIZE);
+	iter->offset =3D 0;
+}
+
+static inline void mv_cesa_sg_dma_iter_init(struct mv_cesa_sg_dma_iter=
 *iter,
+					    struct scatterlist *sg,
+					    enum dma_data_direction dir)
+{
+	iter->op_offset =3D 0;
+	iter->offset =3D 0;
+	iter->sg =3D sg;
+	iter->dir =3D dir;
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
+bool mv_cesa_req_dma_iter_next_transfer(struct mv_cesa_dma_iter *chain=
,
+				    struct mv_cesa_sg_dma_iter *sgiter,
+				    unsigned int len);
+
+static inline bool mv_cesa_req_dma_iter_next_op(struct mv_cesa_dma_ite=
r *iter)
+{
+	iter->offset +=3D iter->op_len;
+	iter->op_len =3D min(iter->len - iter->offset,
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
+struct mv_cesa_op_ctx *mv_cesa_dma_add_op(struct mv_cesa_tdma_chain *c=
hain,
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
+int mv_cesa_dma_add_dummy_end(struct mv_cesa_tdma_chain *chain, u32 fl=
ags);
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
diff --git a/drivers/crypto/marvell/cipher.c b/drivers/crypto/marvell/c=
ipher.c
new file mode 100644
index 0000000..ddb8260
--- /dev/null
+++ b/drivers/crypto/marvell/cipher.c
@@ -0,0 +1,761 @@
+/*
+ * Cipher algorithms supported by the CESA: DES, 3DES and AES.
+ *
+ * Author: Boris Brezillon <boris.brezillon@free-electrons.com>
+ * Author: Arnaud Ebalard <arno@natisbad.org>
+ *
+ * This work is based on an initial version written by
+ * Sebastian Andrzej Siewior < sebastian at breakpoint dot cc >
+ *
+ * This program is free software; you can redistribute it and/or modif=
y it
+ * under the terms of the GNU General Public License version 2 as publ=
ished
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
+mv_cesa_ablkcipher_req_iter_init(struct mv_cesa_ablkcipher_dma_iter *i=
ter,
+				 struct ablkcipher_request *req)
+{
+	mv_cesa_req_dma_iter_init(&iter->base, req->nbytes);
+	mv_cesa_sg_dma_iter_init(&iter->src, req->src, DMA_TO_DEVICE);
+	mv_cesa_sg_dma_iter_init(&iter->dst, req->dst, DMA_FROM_DEVICE);
+}
+
+static inline bool
+mv_cesa_ablkcipher_req_iter_next_op(struct mv_cesa_ablkcipher_dma_iter=
 *iter)
+{
+	iter->src.op_offset =3D 0;
+	iter->dst.op_offset =3D 0;
+
+	return mv_cesa_req_dma_iter_next_op(&iter->base);
+}
+
+static inline void
+mv_cesa_ablkcipher_dma_cleanup(struct ablkcipher_request *req)
+{
+	struct mv_cesa_ablkcipher_req *creq =3D ablkcipher_request_ctx(req);
+
+	dma_unmap_sg(cesa_dev->dev, req->dst, creq->dst_nents, DMA_FROM_DEVIC=
E);
+	dma_unmap_sg(cesa_dev->dev, req->src, creq->src_nents, DMA_TO_DEVICE)=
;
+	mv_cesa_dma_cleanup(&creq->req.dma);
+}
+
+static inline void mv_cesa_ablkcipher_cleanup(struct ablkcipher_reques=
t *req)
+{
+	struct mv_cesa_ablkcipher_req *creq =3D ablkcipher_request_ctx(req);
+
+	if (creq->req.base.type =3D=3D CESA_DMA_REQ)
+		mv_cesa_ablkcipher_dma_cleanup(req);
+}
+
+static void mv_cesa_ablkcipher_std_step(struct ablkcipher_request *req=
)
+{
+	struct mv_cesa_ablkcipher_req *creq =3D ablkcipher_request_ctx(req);
+	struct mv_cesa_ablkcipher_std_req *sreq =3D &creq->req.std;
+	struct mv_cesa_engine *engine =3D sreq->base.engine;
+	size_t  len =3D min_t(size_t, req->nbytes - sreq->offset,
+			    CESA_SA_SRAM_PAYLOAD_SIZE);
+
+	len =3D sg_pcopy_to_buffer(req->src, creq->src_nents,
+				 engine->sram + CESA_SA_DATA_SRAM_OFFSET,
+				 len, sreq->offset);
+
+	sreq->size =3D len;
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
+static int mv_cesa_ablkcipher_std_process(struct ablkcipher_request *r=
eq,
+					  u32 status)
+{
+	struct mv_cesa_ablkcipher_req *creq =3D ablkcipher_request_ctx(req);
+	struct mv_cesa_ablkcipher_std_req *sreq =3D &creq->req.std;
+	struct mv_cesa_engine *engine =3D sreq->base.engine;
+	size_t len;
+
+	len =3D sg_pcopy_from_buffer(req->dst, creq->dst_nents,
+				   engine->sram + CESA_SA_DATA_SRAM_OFFSET,
+				   sreq->size, sreq->offset);
+
+	sreq->offset +=3D len;
+	if (sreq->offset < req->nbytes)
+		return -EINPROGRESS;
+
+	return 0;
+}
+
+static int mv_cesa_ablkcipher_process(struct crypto_async_request *req=
,
+				      u32 status)
+{
+	struct ablkcipher_request *ablkreq =3D ablkcipher_request_cast(req);
+	struct mv_cesa_ablkcipher_req *creq =3D ablkcipher_request_ctx(ablkre=
q);
+	int ret;
+
+	if (creq->req.base.type =3D=3D CESA_DMA_REQ)
+		ret =3D mv_cesa_dma_process(&creq->req.dma, status);
+	else
+		ret =3D mv_cesa_ablkcipher_std_process(ablkreq, status);
+
+	return ret;
+}
+
+static void mv_cesa_ablkcipher_step(struct crypto_async_request *req)
+{
+	struct ablkcipher_request *ablkreq =3D ablkcipher_request_cast(req);
+	struct mv_cesa_ablkcipher_req *creq =3D ablkcipher_request_ctx(ablkre=
q);
+
+	if (creq->req.base.type =3D=3D CESA_DMA_REQ)
+		mv_cesa_dma_step(&creq->req.dma);
+	else
+		mv_cesa_ablkcipher_std_step(ablkreq);
+}
+
+static inline void
+mv_cesa_ablkcipher_dma_prepare(struct ablkcipher_request *req)
+{
+	struct mv_cesa_ablkcipher_req *creq =3D ablkcipher_request_ctx(req);
+	struct mv_cesa_tdma_req *dreq =3D &creq->req.dma;
+
+	mv_cesa_dma_prepare(dreq, dreq->base.engine);
+}
+
+static inline void
+mv_cesa_ablkcipher_std_prepare(struct ablkcipher_request *req)
+{
+	struct mv_cesa_ablkcipher_req *creq =3D ablkcipher_request_ctx(req);
+	struct mv_cesa_ablkcipher_std_req *sreq =3D &creq->req.std;
+	struct mv_cesa_engine *engine =3D sreq->base.engine;
+
+	sreq->size =3D 0;
+	sreq->offset =3D 0;
+	mv_cesa_adjust_op(engine, &sreq->op);
+	memcpy(engine->sram, &sreq->op, sizeof(sreq->op));
+}
+
+static inline void mv_cesa_ablkcipher_prepare(struct crypto_async_requ=
est *req,
+					      struct mv_cesa_engine *engine)
+{
+	struct ablkcipher_request *ablkreq =3D ablkcipher_request_cast(req);
+	struct mv_cesa_ablkcipher_req *creq =3D ablkcipher_request_ctx(ablkre=
q);
+
+	creq->req.base.engine =3D engine;
+
+	if (creq->req.base.type =3D=3D CESA_DMA_REQ)
+		mv_cesa_ablkcipher_dma_prepare(ablkreq);
+	else
+		mv_cesa_ablkcipher_std_prepare(ablkreq);
+}
+
+static inline void
+mv_cesa_ablkcipher_req_cleanup(struct crypto_async_request *req)
+{
+	struct ablkcipher_request *ablkreq =3D ablkcipher_request_cast(req);
+
+	mv_cesa_ablkcipher_cleanup(ablkreq);
+}
+
+static const struct mv_cesa_req_ops mv_cesa_ablkcipher_req_ops =3D {
+	.step =3D mv_cesa_ablkcipher_step,
+	.process =3D mv_cesa_ablkcipher_process,
+	.prepare =3D mv_cesa_ablkcipher_prepare,
+	.cleanup =3D mv_cesa_ablkcipher_req_cleanup,
+};
+
+static int mv_cesa_ablkcipher_cra_init(struct crypto_tfm *tfm)
+{
+	struct mv_cesa_aes_ctx *ctx =3D crypto_tfm_ctx(tfm);
+
+	ctx->base.ops =3D &mv_cesa_ablkcipher_req_ops;
+
+	tfm->crt_ablkcipher.reqsize =3D sizeof(struct mv_cesa_ablkcipher_req)=
;
+
+	return 0;
+}
+
+static int mv_cesa_aes_setkey(struct crypto_ablkcipher *cipher, const =
u8 *key,
+			      unsigned int len)
+{
+	struct crypto_tfm *tfm =3D crypto_ablkcipher_tfm(cipher);
+	struct mv_cesa_aes_ctx *ctx =3D crypto_tfm_ctx(tfm);
+	int remaining;
+	int offset;
+	int ret;
+	int i;
+
+	ret =3D crypto_aes_expand_key(&ctx->aes, key, len);
+	if (ret) {
+		crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return ret;
+	}
+
+	remaining =3D (ctx->aes.key_length - 16) / 4;
+	offset =3D ctx->aes.key_length + 24 - remaining;
+	for (i =3D 0; i < remaining; i++)
+		ctx->aes.key_dec[4 + i] =3D
+			cpu_to_le32(ctx->aes.key_enc[offset + i]);
+
+	return 0;
+}
+
+static int mv_cesa_des_setkey(struct crypto_ablkcipher *cipher, const =
u8 *key,
+			      unsigned int len)
+{
+	struct crypto_tfm *tfm =3D crypto_ablkcipher_tfm(cipher);
+	struct mv_cesa_des_ctx *ctx =3D crypto_tfm_ctx(tfm);
+	u32 tmp[DES_EXPKEY_WORDS];
+	int ret;
+
+	if (len !=3D DES_KEY_SIZE) {
+		crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+
+	ret =3D des_ekey(tmp, key);
+	if (!ret && (tfm->crt_flags & CRYPTO_TFM_REQ_WEAK_KEY)) {
+		tfm->crt_flags |=3D CRYPTO_TFM_RES_WEAK_KEY;
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
+	struct crypto_tfm *tfm =3D crypto_ablkcipher_tfm(cipher);
+	struct mv_cesa_des_ctx *ctx =3D crypto_tfm_ctx(tfm);
+
+	if (len !=3D DES3_EDE_KEY_SIZE) {
+		crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+
+	memcpy(ctx->key, key, DES3_EDE_KEY_SIZE);
+
+	return 0;
+}
+
+static int mv_cesa_ablkcipher_dma_req_init(struct ablkcipher_request *=
req,
+				const struct mv_cesa_op_ctx *op_templ)
+{
+	struct mv_cesa_ablkcipher_req *creq =3D ablkcipher_request_ctx(req);
+	gfp_t flags =3D (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
+		      GFP_KERNEL : GFP_ATOMIC;
+	struct mv_cesa_tdma_req *dreq =3D &creq->req.dma;
+	struct mv_cesa_ablkcipher_dma_iter iter;
+	struct mv_cesa_tdma_chain chain;
+	int ret;
+
+	dreq->base.type =3D CESA_DMA_REQ;
+	dreq->chain.first =3D NULL;
+	dreq->chain.last =3D NULL;
+
+	ret =3D dma_map_sg(cesa_dev->dev, req->src, creq->src_nents,
+			 DMA_TO_DEVICE);
+	if (ret < 0)
+		return ret;
+
+	creq->src_nents =3D ret;
+
+	ret =3D dma_map_sg(cesa_dev->dev, req->dst, creq->dst_nents,
+			 DMA_FROM_DEVICE);
+	if (ret < 0)
+		goto err_unmap_src;
+
+	creq->dst_nents =3D ret;
+
+	mv_cesa_tdma_desc_iter_init(&chain);
+	mv_cesa_ablkcipher_req_iter_init(&iter, req);
+
+	do {
+		struct mv_cesa_op_ctx *op;
+
+		op =3D mv_cesa_dma_add_op(&chain, op_templ, flags);
+		if (IS_ERR(op)) {
+			ret =3D PTR_ERR(op);
+			goto err_free_tdma;
+		}
+
+		mv_cesa_set_crypt_op_len(op, iter.base.op_len);
+
+		/* Add input transfers */
+		ret =3D mv_cesa_dma_add_op_transfers(&chain, &iter.base,
+						   &iter.src, flags);
+		if (ret)
+			goto err_free_tdma;
+
+		/* Add dummy desc to launch the crypto operation */
+		ret =3D mv_cesa_dma_add_dummy_launch(&chain, flags);
+		if (ret)
+			goto err_free_tdma;
+
+		/* Add output transfers */
+		ret =3D mv_cesa_dma_add_op_transfers(&chain, &iter.base,
+						   &iter.dst, flags);
+		if (ret)
+			goto err_free_tdma;
+
+	} while (mv_cesa_ablkcipher_req_iter_next_op(&iter));
+
+	dreq->chain =3D chain;
+
+	return 0;
+
+err_free_tdma:
+	mv_cesa_dma_cleanup(dreq);
+	dma_unmap_sg(cesa_dev->dev, req->dst, creq->dst_nents, DMA_FROM_DEVIC=
E);
+
+err_unmap_src:
+	dma_unmap_sg(cesa_dev->dev, req->src, creq->src_nents, DMA_TO_DEVICE)=
;
+
+	return ret;
+}
+
+static inline int
+mv_cesa_ablkcipher_std_req_init(struct ablkcipher_request *req,
+				const struct mv_cesa_op_ctx *op_templ)
+{
+	struct mv_cesa_ablkcipher_req *creq =3D ablkcipher_request_ctx(req);
+	struct mv_cesa_ablkcipher_std_req *sreq =3D &creq->req.std;
+
+	sreq->base.type =3D CESA_STD_REQ;
+	sreq->op =3D *op_templ;
+
+	return 0;
+}
+
+static int mv_cesa_ablkcipher_req_init(struct ablkcipher_request *req,
+				       struct mv_cesa_op_ctx *tmpl)
+{
+	struct mv_cesa_ablkcipher_req *creq =3D ablkcipher_request_ctx(req);
+	int ret;
+
+	creq->src_nents =3D mv_cesa_sg_count(req->src, req->nbytes);
+	creq->dst_nents =3D mv_cesa_sg_count(req->src, req->nbytes);
+
+	mv_cesa_update_op_cfg(tmpl, CESA_SA_DESC_CFG_OP_CRYPT_ONLY,
+			      CESA_SA_DESC_CFG_OP_MSK);
+
+	/* TODO: add a threshold for DMA usage */
+	if (cesa_dev->caps->has_tdma)
+		ret =3D mv_cesa_ablkcipher_dma_req_init(req, tmpl);
+	else
+		ret =3D mv_cesa_ablkcipher_std_req_init(req, tmpl);
+
+	return ret;
+}
+
+static int mv_cesa_des_op(struct ablkcipher_request *req,
+			  struct mv_cesa_op_ctx *tmpl)
+{
+	struct mv_cesa_des_ctx *ctx =3D crypto_tfm_ctx(req->base.tfm);
+	int ret;
+
+	mv_cesa_update_op_cfg(tmpl, CESA_SA_DESC_CFG_CRYPTM_DES,
+			      CESA_SA_DESC_CFG_CRYPTM_MSK);
+
+	memcpy(tmpl->ctx.blkcipher.key, ctx->key, DES_KEY_SIZE);
+
+	ret =3D mv_cesa_ablkcipher_req_init(req, tmpl);
+	if (ret)
+		return ret;
+
+	ret =3D mv_cesa_queue_req(&req->base);
+	if (ret && ret !=3D -EINPROGRESS)
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
+struct crypto_alg mv_cesa_ecb_des_alg =3D {
+	.cra_name =3D "ecb(des)",
+	.cra_driver_name =3D "mv-ecb-des",
+	.cra_priority =3D 300,
+	.cra_flags =3D CRYPTO_ALG_TYPE_ABLKCIPHER |
+		     CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
+	.cra_blocksize =3D DES_BLOCK_SIZE,
+	.cra_ctxsize =3D sizeof(struct mv_cesa_des_ctx),
+	.cra_alignmask =3D 0,
+	.cra_type =3D &crypto_ablkcipher_type,
+	.cra_module =3D THIS_MODULE,
+	.cra_init =3D mv_cesa_ablkcipher_cra_init,
+	.cra_u =3D {
+		.ablkcipher =3D {
+			.min_keysize =3D DES_KEY_SIZE,
+			.max_keysize =3D DES_KEY_SIZE,
+			.setkey =3D mv_cesa_des_setkey,
+			.encrypt =3D mv_cesa_ecb_des_encrypt,
+			.decrypt =3D mv_cesa_ecb_des_decrypt,
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
+struct crypto_alg mv_cesa_cbc_des_alg =3D {
+	.cra_name =3D "cbc(des)",
+	.cra_driver_name =3D "mv-cbc-des",
+	.cra_priority =3D 300,
+	.cra_flags =3D CRYPTO_ALG_TYPE_ABLKCIPHER |
+		     CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
+	.cra_blocksize =3D DES_BLOCK_SIZE,
+	.cra_ctxsize =3D sizeof(struct mv_cesa_des_ctx),
+	.cra_alignmask =3D 0,
+	.cra_type =3D &crypto_ablkcipher_type,
+	.cra_module =3D THIS_MODULE,
+	.cra_init =3D mv_cesa_ablkcipher_cra_init,
+	.cra_u =3D {
+		.ablkcipher =3D {
+			.min_keysize =3D DES_KEY_SIZE,
+			.max_keysize =3D DES_KEY_SIZE,
+			.ivsize	     =3D DES_BLOCK_SIZE,
+			.setkey =3D mv_cesa_des_setkey,
+			.encrypt =3D mv_cesa_cbc_des_encrypt,
+			.decrypt =3D mv_cesa_cbc_des_decrypt,
+		},
+	},
+};
+
+static int mv_cesa_des3_op(struct ablkcipher_request *req,
+			   struct mv_cesa_op_ctx *tmpl)
+{
+	struct mv_cesa_des3_ctx *ctx =3D crypto_tfm_ctx(req->base.tfm);
+	int ret;
+
+	mv_cesa_update_op_cfg(tmpl, CESA_SA_DESC_CFG_CRYPTM_3DES,
+			      CESA_SA_DESC_CFG_CRYPTM_MSK);
+
+	memcpy(tmpl->ctx.blkcipher.key, ctx->key, DES3_EDE_KEY_SIZE);
+
+	ret =3D mv_cesa_ablkcipher_req_init(req, tmpl);
+	if (ret)
+		return ret;
+
+	ret =3D mv_cesa_queue_req(&req->base);
+	if (ret && ret !=3D -EINPROGRESS)
+		mv_cesa_ablkcipher_cleanup(req);
+
+	return ret;
+}
+
+static int mv_cesa_ecb_des3_ede_encrypt(struct ablkcipher_request *req=
)
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
+static int mv_cesa_ecb_des3_ede_decrypt(struct ablkcipher_request *req=
)
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
+struct crypto_alg mv_cesa_ecb_des3_ede_alg =3D {
+	.cra_name =3D "ecb(des3_ede)",
+	.cra_driver_name =3D "mv-ecb-des3-ede",
+	.cra_priority =3D 300,
+	.cra_flags =3D CRYPTO_ALG_TYPE_ABLKCIPHER |
+		     CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
+	.cra_blocksize =3D DES3_EDE_BLOCK_SIZE,
+	.cra_ctxsize =3D sizeof(struct mv_cesa_des3_ctx),
+	.cra_alignmask =3D 0,
+	.cra_type =3D &crypto_ablkcipher_type,
+	.cra_module =3D THIS_MODULE,
+	.cra_init =3D mv_cesa_ablkcipher_cra_init,
+	.cra_u =3D {
+		.ablkcipher =3D {
+			.min_keysize =3D DES3_EDE_KEY_SIZE,
+			.max_keysize =3D DES3_EDE_KEY_SIZE,
+			.ivsize	     =3D DES3_EDE_BLOCK_SIZE,
+			.setkey =3D mv_cesa_des3_ede_setkey,
+			.encrypt =3D mv_cesa_ecb_des3_ede_encrypt,
+			.decrypt =3D mv_cesa_ecb_des3_ede_decrypt,
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
+static int mv_cesa_cbc_des3_ede_encrypt(struct ablkcipher_request *req=
)
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
+static int mv_cesa_cbc_des3_ede_decrypt(struct ablkcipher_request *req=
)
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
+struct crypto_alg mv_cesa_cbc_des3_ede_alg =3D {
+	.cra_name =3D "cbc(des3_ede)",
+	.cra_driver_name =3D "mv-cbc-des3-ede",
+	.cra_priority =3D 300,
+	.cra_flags =3D CRYPTO_ALG_TYPE_ABLKCIPHER |
+		     CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
+	.cra_blocksize =3D DES3_EDE_BLOCK_SIZE,
+	.cra_ctxsize =3D sizeof(struct mv_cesa_des3_ctx),
+	.cra_alignmask =3D 0,
+	.cra_type =3D &crypto_ablkcipher_type,
+	.cra_module =3D THIS_MODULE,
+	.cra_init =3D mv_cesa_ablkcipher_cra_init,
+	.cra_u =3D {
+		.ablkcipher =3D {
+			.min_keysize =3D DES3_EDE_KEY_SIZE,
+			.max_keysize =3D DES3_EDE_KEY_SIZE,
+			.ivsize	     =3D DES3_EDE_BLOCK_SIZE,
+			.setkey =3D mv_cesa_des3_ede_setkey,
+			.encrypt =3D mv_cesa_cbc_des3_ede_encrypt,
+			.decrypt =3D mv_cesa_cbc_des3_ede_decrypt,
+		},
+	},
+};
+
+static int mv_cesa_aes_op(struct ablkcipher_request *req,
+			  struct mv_cesa_op_ctx *tmpl)
+{
+	struct mv_cesa_aes_ctx *ctx =3D crypto_tfm_ctx(req->base.tfm);
+	int ret, i;
+	u32 *key;
+	u32 cfg;
+
+	cfg =3D CESA_SA_DESC_CFG_CRYPTM_AES;
+
+	if (mv_cesa_get_op_cfg(tmpl) & CESA_SA_DESC_CFG_DIR_DEC)
+		key =3D ctx->aes.key_dec;
+	else
+		key =3D ctx->aes.key_enc;
+
+	for (i =3D 0; i < ctx->aes.key_length / sizeof(u32); i++)
+		tmpl->ctx.blkcipher.key[i] =3D cpu_to_le32(key[i]);
+
+	if (ctx->aes.key_length =3D=3D 24)
+		cfg |=3D CESA_SA_DESC_CFG_AES_LEN_192;
+	else if (ctx->aes.key_length =3D=3D 32)
+		cfg |=3D CESA_SA_DESC_CFG_AES_LEN_256;
+
+	mv_cesa_update_op_cfg(tmpl, cfg,
+			      CESA_SA_DESC_CFG_CRYPTM_MSK |
+			      CESA_SA_DESC_CFG_AES_LEN_MSK);
+
+	ret =3D mv_cesa_ablkcipher_req_init(req, tmpl);
+	if (ret)
+		return ret;
+
+	ret =3D mv_cesa_queue_req(&req->base);
+	if (ret && ret !=3D -EINPROGRESS)
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
+struct crypto_alg mv_cesa_ecb_aes_alg =3D {
+	.cra_name =3D "ecb(aes)",
+	.cra_driver_name =3D "mv-ecb-aes",
+	.cra_priority =3D 300,
+	.cra_flags =3D CRYPTO_ALG_TYPE_ABLKCIPHER |
+		     CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
+	.cra_blocksize =3D AES_BLOCK_SIZE,
+	.cra_ctxsize =3D sizeof(struct mv_cesa_aes_ctx),
+	.cra_alignmask =3D 0,
+	.cra_type =3D &crypto_ablkcipher_type,
+	.cra_module =3D THIS_MODULE,
+	.cra_init =3D mv_cesa_ablkcipher_cra_init,
+	.cra_u =3D {
+		.ablkcipher =3D {
+			.min_keysize =3D AES_MIN_KEY_SIZE,
+			.max_keysize =3D AES_MAX_KEY_SIZE,
+			.setkey =3D mv_cesa_aes_setkey,
+			.encrypt =3D mv_cesa_ecb_aes_encrypt,
+			.decrypt =3D mv_cesa_ecb_aes_decrypt,
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
+struct crypto_alg mv_cesa_cbc_aes_alg =3D {
+	.cra_name =3D "cbc(aes)",
+	.cra_driver_name =3D "mv-cbc-aes",
+	.cra_priority =3D 300,
+	.cra_flags =3D CRYPTO_ALG_TYPE_ABLKCIPHER |
+		     CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
+	.cra_blocksize =3D AES_BLOCK_SIZE,
+	.cra_ctxsize =3D sizeof(struct mv_cesa_aes_ctx),
+	.cra_alignmask =3D 0,
+	.cra_type =3D &crypto_ablkcipher_type,
+	.cra_module =3D THIS_MODULE,
+	.cra_init =3D mv_cesa_ablkcipher_cra_init,
+	.cra_u =3D {
+		.ablkcipher =3D {
+			.min_keysize =3D AES_MIN_KEY_SIZE,
+			.max_keysize =3D AES_MAX_KEY_SIZE,
+			.ivsize =3D AES_BLOCK_SIZE,
+			.setkey =3D mv_cesa_aes_setkey,
+			.encrypt =3D mv_cesa_cbc_aes_encrypt,
+			.decrypt =3D mv_cesa_cbc_aes_decrypt,
+		},
+	},
+};
diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/has=
h.c
new file mode 100644
index 0000000..ec8c1ed
--- /dev/null
+++ b/drivers/crypto/marvell/hash.c
@@ -0,0 +1,1349 @@
+/*
+ * Hash algorithms supported by the CESA: MD5, SHA1 and SHA256.
+ *
+ * Author: Boris Brezillon <boris.brezillon@free-electrons.com>
+ * Author: Arnaud Ebalard <arno@natisbad.org>
+ *
+ * This work is based on an initial version written by
+ * Sebastian Andrzej Siewior < sebastian at breakpoint dot cc >
+ *
+ * This program is free software; you can redistribute it and/or modif=
y it
+ * under the terms of the GNU General Public License version 2 as publ=
ished
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
+	struct mv_cesa_ahash_req *creq =3D ahash_request_ctx(req);
+	unsigned int len =3D req->nbytes;
+
+	if (!creq->last_req)
+		len =3D (len + creq->cache_ptr) & ~CESA_HASH_BLOCK_SIZE_MSK;
+
+	mv_cesa_req_dma_iter_init(&iter->base, len);
+	mv_cesa_sg_dma_iter_init(&iter->src, req->src, DMA_TO_DEVICE);
+	iter->src.op_offset =3D creq->cache_ptr;
+}
+
+static inline bool
+mv_cesa_ahash_req_iter_next_op(struct mv_cesa_ahash_dma_iter *iter)
+{
+	iter->src.op_offset =3D 0;
+
+	return mv_cesa_req_dma_iter_next_op(&iter->base);
+}
+
+static inline int mv_cesa_ahash_dma_alloc_cache(struct mv_cesa_ahash_r=
eq *creq,
+						gfp_t flags)
+{
+	struct mv_cesa_ahash_dma_req *dreq =3D &creq->req.dma;
+
+	creq->cache =3D dma_pool_alloc(cesa_dev->dma->cache_pool, flags,
+				     &dreq->cache_dma);
+	if (!creq->cache)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static inline int mv_cesa_ahash_std_alloc_cache(struct mv_cesa_ahash_r=
eq *creq,
+						gfp_t flags)
+{
+	creq->cache =3D kzalloc(CESA_MAX_HASH_BLOCK_SIZE, flags);
+	if (!creq->cache)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static int mv_cesa_ahash_alloc_cache(struct ahash_request *req)
+{
+	struct mv_cesa_ahash_req *creq =3D ahash_request_ctx(req);
+	gfp_t flags =3D (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
+		      GFP_KERNEL : GFP_ATOMIC;
+	int ret;
+
+	if (creq->cache)
+		return 0;
+
+	if (creq->req.base.type =3D=3D CESA_DMA_REQ)
+		ret =3D mv_cesa_ahash_dma_alloc_cache(creq, flags);
+	else
+		ret =3D mv_cesa_ahash_std_alloc_cache(creq, flags);
+
+	return ret;
+}
+
+static inline void mv_cesa_ahash_dma_free_cache(struct mv_cesa_ahash_r=
eq *creq)
+{
+	dma_pool_free(cesa_dev->dma->cache_pool, creq->cache,
+		      creq->req.dma.cache_dma);
+}
+
+static inline void mv_cesa_ahash_std_free_cache(struct mv_cesa_ahash_r=
eq *creq)
+{
+	kfree(creq->cache);
+}
+
+static void mv_cesa_ahash_free_cache(struct mv_cesa_ahash_req *creq)
+{
+	if (!creq->cache)
+		return;
+
+	if (creq->req.base.type =3D=3D CESA_DMA_REQ)
+		mv_cesa_ahash_dma_free_cache(creq);
+	else
+		mv_cesa_ahash_std_free_cache(creq);
+
+	creq->cache =3D NULL;
+}
+
+static int mv_cesa_ahash_dma_alloc_padding(struct mv_cesa_ahash_dma_re=
q *req,
+					   gfp_t flags)
+{
+	if (req->padding)
+		return 0;
+
+	req->padding =3D dma_pool_alloc(cesa_dev->dma->padding_pool, flags,
+				      &req->padding_dma);
+	if (!req->padding)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void mv_cesa_ahash_dma_free_padding(struct mv_cesa_ahash_dma_re=
q *req)
+{
+	if (!req->padding)
+		return;
+
+	dma_pool_free(cesa_dev->dma->padding_pool, req->padding,
+		      req->padding_dma);
+	req->padding =3D NULL;
+}
+
+static inline void mv_cesa_ahash_dma_last_cleanup(struct ahash_request=
 *req)
+{
+	struct mv_cesa_ahash_req *creq =3D ahash_request_ctx(req);
+
+	mv_cesa_ahash_dma_free_padding(&creq->req.dma);
+}
+
+static inline void mv_cesa_ahash_dma_cleanup(struct ahash_request *req=
)
+{
+	struct mv_cesa_ahash_req *creq =3D ahash_request_ctx(req);
+
+	dma_unmap_sg(cesa_dev->dev, req->src, creq->src_nents, DMA_TO_DEVICE)=
;
+	mv_cesa_dma_cleanup(&creq->req.dma.base);
+}
+
+static inline void mv_cesa_ahash_cleanup(struct ahash_request *req)
+{
+	struct mv_cesa_ahash_req *creq =3D ahash_request_ctx(req);
+
+	if (creq->req.base.type =3D=3D CESA_DMA_REQ)
+		mv_cesa_ahash_dma_cleanup(req);
+}
+
+static void mv_cesa_ahash_last_cleanup(struct ahash_request *req)
+{
+	struct mv_cesa_ahash_req *creq =3D ahash_request_ctx(req);
+
+	mv_cesa_ahash_free_cache(creq);
+
+	if (creq->req.base.type =3D=3D CESA_DMA_REQ)
+		mv_cesa_ahash_dma_last_cleanup(req);
+}
+
+static int mv_cesa_ahash_pad_len(struct mv_cesa_ahash_req *creq)
+{
+	unsigned int index, padlen;
+
+	index =3D creq->len & CESA_HASH_BLOCK_SIZE_MSK;
+	padlen =3D (index < 56) ? (56 - index) : (64 + 56 - index);
+
+	return padlen;
+}
+
+static int mv_cesa_ahash_pad_req(struct mv_cesa_ahash_req *creq, u8 *b=
uf)
+{
+	__be64 bits =3D cpu_to_be64(creq->len << 3);
+	unsigned int index, padlen;
+
+	buf[0] =3D 0x80;
+	/* Pad out to 56 mod 64 */
+	index =3D creq->len & CESA_HASH_BLOCK_SIZE_MSK;
+	padlen =3D mv_cesa_ahash_pad_len(creq);
+	memset(buf + 1, 0, padlen - 1);
+	memcpy(buf + padlen, &bits, sizeof(bits));
+
+	return padlen + 8;
+}
+
+static void mv_cesa_ahash_std_step(struct ahash_request *req)
+{
+	struct mv_cesa_ahash_req *creq =3D ahash_request_ctx(req);
+	struct mv_cesa_ahash_std_req *sreq =3D &creq->req.std;
+	struct mv_cesa_engine *engine =3D sreq->base.engine;
+	struct mv_cesa_op_ctx *op;
+	unsigned int new_cache_ptr =3D 0;
+	u32 frag_mode;
+	size_t  len;
+
+	if (creq->cache_ptr)
+		memcpy(engine->sram + CESA_SA_DATA_SRAM_OFFSET, creq->cache,
+		       creq->cache_ptr);
+
+	len =3D min_t(size_t, req->nbytes + creq->cache_ptr - sreq->offset,
+		    CESA_SA_SRAM_PAYLOAD_SIZE);
+
+	if (!creq->last_req) {
+		new_cache_ptr =3D len & CESA_HASH_BLOCK_SIZE_MSK;
+		len &=3D ~CESA_HASH_BLOCK_SIZE_MSK;
+	}
+
+	if (len - creq->cache_ptr)
+		sreq->offset +=3D sg_pcopy_to_buffer(req->src, creq->src_nents,
+						   engine->sram +
+						   CESA_SA_DATA_SRAM_OFFSET +
+						   creq->cache_ptr,
+						   len - creq->cache_ptr,
+						   sreq->offset);
+
+	op =3D &creq->op_tmpl;
+
+	frag_mode =3D mv_cesa_get_op_cfg(op) & CESA_SA_DESC_CFG_FRAG_MSK;
+
+	if (creq->last_req && sreq->offset =3D=3D req->nbytes &&
+	    creq->len <=3D CESA_SA_DESC_MAC_SRC_TOTAL_LEN_MAX) {
+		if (frag_mode =3D=3D CESA_SA_DESC_CFG_FIRST_FRAG)
+			frag_mode =3D CESA_SA_DESC_CFG_NOT_FRAG;
+		else if (frag_mode =3D=3D CESA_SA_DESC_CFG_MID_FRAG)
+			frag_mode =3D CESA_SA_DESC_CFG_LAST_FRAG;
+	}
+
+	if (frag_mode =3D=3D CESA_SA_DESC_CFG_NOT_FRAG ||
+	    frag_mode =3D=3D CESA_SA_DESC_CFG_LAST_FRAG) {
+		if (len &&
+		    creq->len <=3D CESA_SA_DESC_MAC_SRC_TOTAL_LEN_MAX) {
+			mv_cesa_set_mac_op_total_len(op, creq->len);
+		} else {
+			int trailerlen =3D mv_cesa_ahash_pad_len(creq) + 8;
+
+			if (len + trailerlen > CESA_SA_SRAM_PAYLOAD_SIZE) {
+				len &=3D CESA_HASH_BLOCK_SIZE_MSK;
+				new_cache_ptr =3D 64 - trailerlen;
+				memcpy(creq->cache,
+				       engine->sram +
+				       CESA_SA_DATA_SRAM_OFFSET + len,
+				       new_cache_ptr);
+			} else {
+				len +=3D mv_cesa_ahash_pad_req(creq,
+						engine->sram + len +
+						CESA_SA_DATA_SRAM_OFFSET);
+			}
+
+			if (frag_mode =3D=3D CESA_SA_DESC_CFG_LAST_FRAG)
+				frag_mode =3D CESA_SA_DESC_CFG_MID_FRAG;
+			else
+				frag_mode =3D CESA_SA_DESC_CFG_FIRST_FRAG;
+		}
+	}
+
+	mv_cesa_set_mac_op_frag_len(op, len);
+	mv_cesa_update_op_cfg(op, frag_mode, CESA_SA_DESC_CFG_FRAG_MSK);
+
+	/* FIXME: only update enc_len field */
+	memcpy(engine->sram, op, sizeof(*op));
+
+	if (frag_mode =3D=3D CESA_SA_DESC_CFG_FIRST_FRAG)
+		mv_cesa_update_op_cfg(op, CESA_SA_DESC_CFG_MID_FRAG,
+				      CESA_SA_DESC_CFG_FRAG_MSK);
+
+	creq->cache_ptr =3D new_cache_ptr;
+
+	mv_cesa_set_int_mask(engine, CESA_SA_INT_ACCEL0_DONE);
+	writel(CESA_SA_CFG_PARA_DIS, engine->regs + CESA_SA_CFG);
+	writel(CESA_SA_CMD_EN_CESA_SA_ACCL0, engine->regs + CESA_SA_CMD);
+}
+
+static int mv_cesa_ahash_std_process(struct ahash_request *req, u32 st=
atus)
+{
+	struct mv_cesa_ahash_req *creq =3D ahash_request_ctx(req);
+	struct mv_cesa_ahash_std_req *sreq =3D &creq->req.std;
+
+	if (sreq->offset < (req->nbytes - creq->cache_ptr))
+		return -EINPROGRESS;
+
+	return 0;
+}
+
+static inline void mv_cesa_ahash_dma_prepare(struct ahash_request *req=
)
+{
+	struct mv_cesa_ahash_req *creq =3D ahash_request_ctx(req);
+	struct mv_cesa_tdma_req *dreq =3D &creq->req.dma.base;
+
+	mv_cesa_dma_prepare(dreq, dreq->base.engine);
+}
+
+static void mv_cesa_ahash_std_prepare(struct ahash_request *req)
+{
+	struct mv_cesa_ahash_req *creq =3D ahash_request_ctx(req);
+	struct mv_cesa_ahash_std_req *sreq =3D &creq->req.std;
+	struct mv_cesa_engine *engine =3D sreq->base.engine;
+
+	sreq->offset =3D 0;
+	mv_cesa_adjust_op(engine, &creq->op_tmpl);
+	memcpy(engine->sram, &creq->op_tmpl, sizeof(creq->op_tmpl));
+}
+
+static void mv_cesa_ahash_step(struct crypto_async_request *req)
+{
+	struct ahash_request *ahashreq =3D ahash_request_cast(req);
+	struct mv_cesa_ahash_req *creq =3D ahash_request_ctx(ahashreq);
+
+	if (creq->req.base.type =3D=3D CESA_DMA_REQ)
+		mv_cesa_dma_step(&creq->req.dma.base);
+	else
+		mv_cesa_ahash_std_step(ahashreq);
+}
+
+static int mv_cesa_ahash_process(struct crypto_async_request *req, u32=
 status)
+{
+	struct ahash_request *ahashreq =3D ahash_request_cast(req);
+	struct mv_cesa_ahash_req *creq =3D ahash_request_ctx(ahashreq);
+	struct mv_cesa_engine *engine =3D creq->req.base.engine;
+	unsigned int digsize;
+	int ret, i;
+
+	if (creq->req.base.type =3D=3D CESA_DMA_REQ)
+		ret =3D mv_cesa_dma_process(&creq->req.dma.base, status);
+	else
+		ret =3D mv_cesa_ahash_std_process(ahashreq, status);
+
+	if (ret =3D=3D -EINPROGRESS)
+		return ret;
+
+	digsize =3D crypto_ahash_digestsize(crypto_ahash_reqtfm(ahashreq));
+	for (i =3D 0; i < digsize / 4; i++)
+		creq->state[i] =3D readl(engine->regs + CESA_IVDIG(i));
+
+	if (creq->cache_ptr)
+		sg_pcopy_to_buffer(ahashreq->src, creq->src_nents,
+				   creq->cache,
+				   creq->cache_ptr,
+				   ahashreq->nbytes - creq->cache_ptr);
+
+	if (creq->last_req) {
+		for (i =3D 0; i < digsize / 4; i++) {
+			/*
+			 * Hardware provides MD5 digest in a different
+			 * endianness than SHA-1 and SHA-256 ones.
+			 */
+			if (digsize =3D=3D MD5_DIGEST_SIZE)
+				creq->state[i] =3D cpu_to_le32(creq->state[i]);
+			else
+				creq->state[i] =3D cpu_to_be32(creq->state[i]);
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
+	struct ahash_request *ahashreq =3D ahash_request_cast(req);
+	struct mv_cesa_ahash_req *creq =3D ahash_request_ctx(ahashreq);
+	unsigned int digsize;
+	int i;
+
+	creq->req.base.engine =3D engine;
+
+	if (creq->req.base.type =3D=3D CESA_DMA_REQ)
+		mv_cesa_ahash_dma_prepare(ahashreq);
+	else
+		mv_cesa_ahash_std_prepare(ahashreq);
+
+	digsize =3D crypto_ahash_digestsize(crypto_ahash_reqtfm(ahashreq));
+	for (i =3D 0; i < digsize / 4; i++)
+		writel(creq->state[i],
+		       engine->regs + CESA_IVDIG(i));
+}
+
+static void mv_cesa_ahash_req_cleanup(struct crypto_async_request *req=
)
+{
+	struct ahash_request *ahashreq =3D ahash_request_cast(req);
+	struct mv_cesa_ahash_req *creq =3D ahash_request_ctx(ahashreq);
+
+	if (creq->last_req)
+		mv_cesa_ahash_last_cleanup(ahashreq);
+
+	mv_cesa_ahash_cleanup(ahashreq);
+}
+
+static const struct mv_cesa_req_ops mv_cesa_ahash_req_ops =3D {
+	.step =3D mv_cesa_ahash_step,
+	.process =3D mv_cesa_ahash_process,
+	.prepare =3D mv_cesa_ahash_prepare,
+	.cleanup =3D mv_cesa_ahash_req_cleanup,
+};
+
+static int mv_cesa_ahash_init(struct ahash_request *req,
+			      struct mv_cesa_op_ctx *tmpl)
+{
+	struct mv_cesa_ahash_req *creq =3D ahash_request_ctx(req);
+
+	memset(creq, 0, sizeof(*creq));
+	mv_cesa_update_op_cfg(tmpl,
+			      CESA_SA_DESC_CFG_OP_MAC_ONLY |
+			      CESA_SA_DESC_CFG_FIRST_FRAG,
+			      CESA_SA_DESC_CFG_OP_MSK |
+			      CESA_SA_DESC_CFG_FRAG_MSK);
+	mv_cesa_set_mac_op_total_len(tmpl, 0);
+	mv_cesa_set_mac_op_frag_len(tmpl, 0);
+	creq->op_tmpl =3D *tmpl;
+	creq->len =3D 0;
+
+	return 0;
+}
+
+static inline int mv_cesa_ahash_cra_init(struct crypto_tfm *tfm)
+{
+	struct mv_cesa_hash_ctx *ctx =3D crypto_tfm_ctx(tfm);
+
+	ctx->base.ops =3D &mv_cesa_ahash_req_ops;
+
+	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
+				 sizeof(struct mv_cesa_ahash_req));
+	return 0;
+}
+
+static int mv_cesa_ahash_cache_req(struct ahash_request *req, bool *ca=
ched)
+{
+	struct mv_cesa_ahash_req *creq =3D ahash_request_ctx(req);
+	int ret;
+
+	if (((creq->cache_ptr + req->nbytes) & CESA_HASH_BLOCK_SIZE_MSK) &&
+	    !creq->last_req) {
+		ret =3D mv_cesa_ahash_alloc_cache(req);
+		if (ret)
+			return ret;
+	}
+
+	if (creq->cache_ptr + req->nbytes < 64 && !creq->last_req) {
+		*cached =3D true;
+
+		if (!req->nbytes)
+			return 0;
+
+		sg_pcopy_to_buffer(req->src, creq->src_nents,
+				   creq->cache + creq->cache_ptr,
+				   req->nbytes, 0);
+
+		creq->cache_ptr +=3D req->nbytes;
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
+	struct mv_cesa_ahash_dma_req *ahashdreq =3D &creq->req.dma;
+	struct mv_cesa_op_ctx *op =3D NULL;
+	int ret;
+
+	if (!creq->cache_ptr)
+		return NULL;
+
+	ret =3D mv_cesa_dma_add_data_transfer(chain,
+					    CESA_SA_DATA_SRAM_OFFSET,
+					    ahashdreq->cache_dma,
+					    creq->cache_ptr,
+					    CESA_TDMA_DST_IN_SRAM,
+					    flags);
+	if (ret)
+		return ERR_PTR(ret);
+
+	if (!dma_iter->base.op_len) {
+		op =3D mv_cesa_dma_add_op(chain, &creq->op_tmpl, flags);
+		if (IS_ERR(op))
+			return op;
+
+		mv_cesa_set_mac_op_frag_len(op, creq->cache_ptr);
+
+		/* Add dummy desc to launch crypto operation */
+		ret =3D mv_cesa_dma_add_dummy_launch(chain, flags);
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
+	op =3D mv_cesa_dma_add_op(chain, &creq->op_tmpl, flags);
+	if (IS_ERR(op))
+		return op;
+
+	mv_cesa_set_mac_op_frag_len(op, dma_iter->base.op_len);
+
+	if ((mv_cesa_get_op_cfg(&creq->op_tmpl) & CESA_SA_DESC_CFG_FRAG_MSK) =
=3D=3D
+	    CESA_SA_DESC_CFG_FIRST_FRAG)
+		mv_cesa_update_op_cfg(&creq->op_tmpl,
+				      CESA_SA_DESC_CFG_MID_FRAG,
+				      CESA_SA_DESC_CFG_FRAG_MSK);
+
+	/* Add input transfers */
+	ret =3D mv_cesa_dma_add_op_transfers(chain, &dma_iter->base,
+					   &dma_iter->src, flags);
+	if (ret)
+		return ERR_PTR(ret);
+
+	/* Add dummy desc to launch crypto operation */
+	ret =3D mv_cesa_dma_add_dummy_launch(chain, flags);
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
+	struct mv_cesa_ahash_dma_req *ahashdreq =3D &creq->req.dma;
+	unsigned int len, trailerlen, padoff =3D 0;
+	int ret;
+
+	if (!creq->last_req)
+		return op;
+
+	if (op && creq->len <=3D CESA_SA_DESC_MAC_SRC_TOTAL_LEN_MAX) {
+		u32 frag =3D CESA_SA_DESC_CFG_NOT_FRAG;
+
+		if ((mv_cesa_get_op_cfg(op) & CESA_SA_DESC_CFG_FRAG_MSK) !=3D
+		    CESA_SA_DESC_CFG_FIRST_FRAG)
+			frag =3D CESA_SA_DESC_CFG_LAST_FRAG;
+
+		mv_cesa_update_op_cfg(op, frag, CESA_SA_DESC_CFG_FRAG_MSK);
+
+		return op;
+	}
+
+	ret =3D mv_cesa_ahash_dma_alloc_padding(ahashdreq, flags);
+	if (ret)
+		return ERR_PTR(ret);
+
+	trailerlen =3D mv_cesa_ahash_pad_req(creq, ahashdreq->padding);
+
+	if (op) {
+		len =3D min(CESA_SA_SRAM_PAYLOAD_SIZE - dma_iter->base.op_len,
+			  trailerlen);
+		if (len) {
+			ret =3D mv_cesa_dma_add_data_transfer(chain,
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
+			padoff +=3D len;
+		}
+	}
+
+	if (padoff >=3D trailerlen)
+		return op;
+
+	if ((mv_cesa_get_op_cfg(&creq->op_tmpl) & CESA_SA_DESC_CFG_FRAG_MSK) =
!=3D
+	    CESA_SA_DESC_CFG_FIRST_FRAG)
+		mv_cesa_update_op_cfg(&creq->op_tmpl,
+				      CESA_SA_DESC_CFG_MID_FRAG,
+				      CESA_SA_DESC_CFG_FRAG_MSK);
+
+	op =3D mv_cesa_dma_add_op(chain, &creq->op_tmpl, flags);
+	if (IS_ERR(op))
+		return op;
+
+	mv_cesa_set_mac_op_frag_len(op, trailerlen - padoff);
+
+	ret =3D mv_cesa_dma_add_data_transfer(chain,
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
+	ret =3D mv_cesa_dma_add_dummy_launch(chain, flags);
+	if (ret)
+		return ERR_PTR(ret);
+
+	return op;
+}
+
+static int mv_cesa_ahash_dma_req_init(struct ahash_request *req)
+{
+	struct mv_cesa_ahash_req *creq =3D ahash_request_ctx(req);
+	gfp_t flags =3D (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
+		      GFP_KERNEL : GFP_ATOMIC;
+	struct mv_cesa_ahash_dma_req *ahashdreq =3D &creq->req.dma;
+	struct mv_cesa_tdma_req *dreq =3D &ahashdreq->base;
+	struct mv_cesa_tdma_chain chain;
+	struct mv_cesa_ahash_dma_iter iter;
+	struct mv_cesa_op_ctx *op =3D NULL;
+	int ret;
+
+	dreq->chain.first =3D NULL;
+	dreq->chain.last =3D NULL;
+
+	ret =3D dma_map_sg(cesa_dev->dev, req->src, creq->src_nents,
+			 DMA_TO_DEVICE);
+	if (ret < 0)
+		goto err;
+
+	creq->src_nents =3D ret;
+
+	mv_cesa_tdma_desc_iter_init(&chain);
+	mv_cesa_ahash_req_iter_init(&iter, req);
+
+	op =3D mv_cesa_ahash_dma_add_cache(&chain, &iter,
+					 creq, flags);
+	if (IS_ERR(op)) {
+		ret =3D PTR_ERR(op);
+		goto err_free_tdma;
+	}
+
+	do {
+		if (!iter.base.op_len)
+			break;
+
+		op =3D mv_cesa_ahash_dma_add_data(&chain, &iter,
+						creq, flags);
+		if (IS_ERR(op)) {
+			ret =3D PTR_ERR(op);
+			goto err_free_tdma;
+		}
+	} while (mv_cesa_ahash_req_iter_next_op(&iter));
+
+	op =3D mv_cesa_ahash_dma_last_req(&chain, &iter, creq, op, flags);
+	if (IS_ERR(op)) {
+		ret =3D PTR_ERR(op);
+		goto err_free_tdma;
+	}
+
+	if (op) {
+		/* Add dummy desc to wait for crypto operation end */
+		ret =3D mv_cesa_dma_add_dummy_end(&chain, flags);
+		if (ret)
+			goto err_free_tdma;
+	}
+
+	if (!creq->last_req)
+		creq->cache_ptr =3D req->nbytes + creq->cache_ptr -
+				  iter.base.len;
+	else
+		creq->cache_ptr =3D 0;
+
+	dreq->chain =3D chain;
+
+	return 0;
+
+err_free_tdma:
+	mv_cesa_dma_cleanup(dreq);
+	dma_unmap_sg(cesa_dev->dev, req->src, creq->src_nents, DMA_TO_DEVICE)=
;
+
+err:
+	mv_cesa_ahash_last_cleanup(req);
+
+	return ret;
+}
+
+static int mv_cesa_ahash_req_init(struct ahash_request *req, bool *cac=
hed)
+{
+	struct mv_cesa_ahash_req *creq =3D ahash_request_ctx(req);
+	int ret;
+
+	if (cesa_dev->caps->has_tdma)
+		creq->req.base.type =3D CESA_DMA_REQ;
+	else
+		creq->req.base.type =3D CESA_STD_REQ;
+
+	creq->src_nents =3D mv_cesa_sg_count(req->src, req->nbytes);
+
+	ret =3D mv_cesa_ahash_cache_req(req, cached);
+	if (ret)
+		return ret;
+
+	if (*cached)
+		return 0;
+
+	if (creq->req.base.type =3D=3D CESA_DMA_REQ)
+		ret =3D mv_cesa_ahash_dma_req_init(req);
+
+	return ret;
+}
+
+static int mv_cesa_ahash_update(struct ahash_request *req)
+{
+	struct mv_cesa_ahash_req *creq =3D ahash_request_ctx(req);
+	bool cached =3D false;
+	int ret;
+
+	creq->len +=3D req->nbytes;
+	ret =3D mv_cesa_ahash_req_init(req, &cached);
+	if (ret)
+		return ret;
+
+	if (cached)
+		return 0;
+
+	ret =3D mv_cesa_queue_req(&req->base);
+	if (ret && ret !=3D -EINPROGRESS) {
+		mv_cesa_ahash_cleanup(req);
+		return ret;
+	}
+
+	return ret;
+}
+
+static int mv_cesa_ahash_final(struct ahash_request *req)
+{
+	struct mv_cesa_ahash_req *creq =3D ahash_request_ctx(req);
+	struct mv_cesa_op_ctx *tmpl =3D &creq->op_tmpl;
+	bool cached =3D false;
+	int ret;
+
+	mv_cesa_set_mac_op_total_len(tmpl, creq->len);
+	creq->last_req =3D true;
+	req->nbytes =3D 0;
+
+	ret =3D mv_cesa_ahash_req_init(req, &cached);
+	if (ret)
+		return ret;
+
+	if (cached)
+		return 0;
+
+	ret =3D mv_cesa_queue_req(&req->base);
+	if (ret && ret !=3D -EINPROGRESS)
+		mv_cesa_ahash_cleanup(req);
+
+	return ret;
+}
+
+static int mv_cesa_ahash_finup(struct ahash_request *req)
+{
+	struct mv_cesa_ahash_req *creq =3D ahash_request_ctx(req);
+	struct mv_cesa_op_ctx *tmpl =3D &creq->op_tmpl;
+	bool cached =3D false;
+	int ret;
+
+	creq->len +=3D req->nbytes;
+	mv_cesa_set_mac_op_total_len(tmpl, creq->len);
+	creq->last_req =3D true;
+
+	ret =3D mv_cesa_ahash_req_init(req, &cached);
+	if (ret)
+		return ret;
+
+	if (cached)
+		return 0;
+
+	ret =3D mv_cesa_queue_req(&req->base);
+	if (ret && ret !=3D -EINPROGRESS)
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
+	struct md5_state *out_state =3D out;
+	struct crypto_ahash *ahash =3D crypto_ahash_reqtfm(req);
+	struct mv_cesa_ahash_req *creq =3D ahash_request_ctx(req);
+	unsigned int digsize =3D crypto_ahash_digestsize(ahash);
+
+	out_state->byte_count =3D creq->len;
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
+	ret =3D mv_cesa_md5_init(req);
+	if (ret)
+		return ret;
+
+	return mv_cesa_ahash_finup(req);
+}
+
+struct ahash_alg mv_md5_alg =3D {
+	.init =3D mv_cesa_md5_init,
+	.update =3D mv_cesa_ahash_update,
+	.final =3D mv_cesa_ahash_final,
+	.finup =3D mv_cesa_ahash_finup,
+	.digest =3D mv_cesa_md5_digest,
+	.export =3D mv_cesa_md5_export,
+	.halg =3D {
+		.digestsize =3D MD5_DIGEST_SIZE,
+		.base =3D {
+			.cra_name =3D "md5",
+			.cra_driver_name =3D "mv-md5",
+			.cra_priority =3D 300,
+			.cra_flags =3D CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize =3D MD5_HMAC_BLOCK_SIZE,
+			.cra_ctxsize =3D sizeof(struct mv_cesa_hash_ctx),
+			.cra_init =3D mv_cesa_ahash_cra_init,
+			.cra_module =3D THIS_MODULE,
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
+	struct sha1_state *out_state =3D out;
+	struct crypto_ahash *ahash =3D crypto_ahash_reqtfm(req);
+	struct mv_cesa_ahash_req *creq =3D ahash_request_ctx(req);
+	unsigned int digsize =3D crypto_ahash_digestsize(ahash);
+
+	out_state->count =3D creq->len;
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
+	ret =3D mv_cesa_sha1_init(req);
+	if (ret)
+		return ret;
+
+	return mv_cesa_ahash_finup(req);
+}
+
+struct ahash_alg mv_sha1_alg =3D {
+	.init =3D mv_cesa_sha1_init,
+	.update =3D mv_cesa_ahash_update,
+	.final =3D mv_cesa_ahash_final,
+	.finup =3D mv_cesa_ahash_finup,
+	.digest =3D mv_cesa_sha1_digest,
+	.export =3D mv_cesa_sha1_export,
+	.halg =3D {
+		.digestsize =3D SHA1_DIGEST_SIZE,
+		.base =3D {
+			.cra_name =3D "sha1",
+			.cra_driver_name =3D "mv-sha1",
+			.cra_priority =3D 300,
+			.cra_flags =3D CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize =3D SHA1_BLOCK_SIZE,
+			.cra_ctxsize =3D sizeof(struct mv_cesa_hash_ctx),
+			.cra_init =3D mv_cesa_ahash_cra_init,
+			.cra_module =3D THIS_MODULE,
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
+	ret =3D mv_cesa_sha256_init(req);
+	if (ret)
+		return ret;
+
+	return mv_cesa_ahash_finup(req);
+}
+
+static int mv_cesa_sha256_export(struct ahash_request *req, void *out)
+{
+	struct sha256_state *out_state =3D out;
+	struct crypto_ahash *ahash =3D crypto_ahash_reqtfm(req);
+	struct mv_cesa_ahash_req *creq =3D ahash_request_ctx(req);
+	unsigned int ds =3D crypto_ahash_digestsize(ahash);
+
+	out_state->count =3D creq->len;
+	memcpy(out_state->state, creq->state, ds);
+	memset(out_state->buf, 0, sizeof(out_state->buf));
+	if (creq->cache)
+		memcpy(out_state->buf, creq->cache, creq->cache_ptr);
+
+	return 0;
+}
+
+struct ahash_alg mv_sha256_alg =3D {
+	.init =3D mv_cesa_sha256_init,
+	.update =3D mv_cesa_ahash_update,
+	.final =3D mv_cesa_ahash_final,
+	.finup =3D mv_cesa_ahash_finup,
+	.digest =3D mv_cesa_sha256_digest,
+	.export =3D mv_cesa_sha256_export,
+	.halg =3D {
+		.digestsize =3D SHA256_DIGEST_SIZE,
+		.base =3D {
+			.cra_name =3D "sha256",
+			.cra_driver_name =3D "mv-sha256",
+			.cra_priority =3D 300,
+			.cra_flags =3D CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize =3D SHA256_BLOCK_SIZE,
+			.cra_ctxsize =3D sizeof(struct mv_cesa_hash_ctx),
+			.cra_init =3D mv_cesa_ahash_cra_init,
+			.cra_module =3D THIS_MODULE,
+		 }
+	}
+};
+
+struct mv_cesa_ahash_result {
+	struct completion completion;
+	int error;
+};
+
+static void mv_cesa_hmac_ahash_complete(struct crypto_async_request *r=
eq,
+					int error)
+{
+	struct mv_cesa_ahash_result *result =3D req->data;
+
+	if (error =3D=3D -EINPROGRESS)
+		return;
+
+	result->error =3D error;
+	complete(&result->completion);
+}
+
+static int mv_cesa_ahmac_iv_state_init(struct ahash_request *req, u8 *=
pad,
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
+	ret =3D crypto_ahash_init(req);
+	if (ret)
+		return ret;
+
+	ret =3D crypto_ahash_update(req);
+	if (ret && ret !=3D -EINPROGRESS)
+		return ret;
+
+	wait_for_completion_interruptible(&result.completion);
+	if (result.error)
+		return result.error;
+
+	ret =3D crypto_ahash_export(req, state);
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
+	if (keylen <=3D blocksize) {
+		memcpy(ipad, key, keylen);
+	} else {
+		u8 *keydup =3D kmemdup(key, keylen, GFP_KERNEL);
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
+		ret =3D crypto_ahash_digest(req);
+		if (ret =3D=3D -EINPROGRESS) {
+			wait_for_completion_interruptible(&result.completion);
+			ret =3D result.error;
+		}
+
+		/* Set the memory region to 0 to avoid any leak. */
+		memset(keydup, 0, keylen);
+		kfree(keydup);
+
+		if (ret)
+			return ret;
+
+		keylen =3D crypto_ahash_digestsize(crypto_ahash_reqtfm(req));
+	}
+
+	memset(ipad + keylen, 0, blocksize - keylen);
+	memcpy(opad, ipad, blocksize);
+
+	for (i =3D 0; i < blocksize; i++) {
+		ipad[i] ^=3D 0x36;
+		opad[i] ^=3D 0x5c;
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
+	u8 *ipad =3D NULL;
+	u8 *opad;
+	int ret;
+
+	tfm =3D crypto_alloc_ahash(hash_alg_name, CRYPTO_ALG_TYPE_AHASH,
+				 CRYPTO_ALG_TYPE_AHASH_MASK);
+	if (IS_ERR(tfm))
+		return PTR_ERR(tfm);
+
+	req =3D ahash_request_alloc(tfm, GFP_KERNEL);
+	if (!req) {
+		ret =3D -ENOMEM;
+		goto free_ahash;
+	}
+
+	crypto_ahash_clear_flags(tfm, ~0);
+
+	blocksize =3D crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
+
+	ipad =3D kzalloc(2 * blocksize, GFP_KERNEL);
+	if (!ipad) {
+		ret =3D -ENOMEM;
+		goto free_req;
+	}
+
+	opad =3D ipad + blocksize;
+
+	ret =3D mv_cesa_ahmac_pad_init(req, key, keylen, ipad, opad, blocksiz=
e);
+	if (ret)
+		goto free_ipad;
+
+	ret =3D mv_cesa_ahmac_iv_state_init(req, ipad, istate, blocksize);
+	if (ret)
+		goto free_ipad;
+
+	ret =3D mv_cesa_ahmac_iv_state_init(req, opad, ostate, blocksize);
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
+	struct mv_cesa_hmac_ctx *ctx =3D crypto_tfm_ctx(tfm);
+
+	ctx->base.ops =3D &mv_cesa_ahash_req_ops;
+
+	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
+				 sizeof(struct mv_cesa_ahash_req));
+	return 0;
+}
+
+static int mv_cesa_ahmac_md5_init(struct ahash_request *req)
+{
+	struct mv_cesa_hmac_ctx *ctx =3D crypto_tfm_ctx(req->base.tfm);
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
+static int mv_cesa_ahmac_md5_setkey(struct crypto_ahash *tfm, const u8=
 *key,
+				    unsigned int keylen)
+{
+	struct mv_cesa_hmac_ctx *ctx =3D crypto_tfm_ctx(crypto_ahash_tfm(tfm)=
);
+	struct md5_state istate, ostate;
+	int ret, i;
+
+	ret =3D mv_cesa_ahmac_setkey("mv-md5", key, keylen, &istate, &ostate)=
;
+	if (ret)
+		return ret;
+
+	for (i =3D 0; i < ARRAY_SIZE(istate.hash); i++)
+		ctx->iv[i] =3D be32_to_cpu(istate.hash[i]);
+
+	for (i =3D 0; i < ARRAY_SIZE(ostate.hash); i++)
+		ctx->iv[i + 8] =3D be32_to_cpu(ostate.hash[i]);
+
+	return 0;
+}
+
+static int mv_cesa_ahmac_md5_digest(struct ahash_request *req)
+{
+	int ret;
+
+	ret =3D mv_cesa_ahmac_md5_init(req);
+	if (ret)
+		return ret;
+
+	return mv_cesa_ahash_finup(req);
+}
+
+struct ahash_alg mv_ahmac_md5_alg =3D {
+	.init =3D mv_cesa_ahmac_md5_init,
+	.update =3D mv_cesa_ahash_update,
+	.final =3D mv_cesa_ahash_final,
+	.finup =3D mv_cesa_ahash_finup,
+	.digest =3D mv_cesa_ahmac_md5_digest,
+	.setkey =3D mv_cesa_ahmac_md5_setkey,
+	.halg =3D {
+		.digestsize =3D MD5_DIGEST_SIZE,
+		.statesize =3D sizeof(struct md5_state),
+		.base =3D {
+			.cra_name =3D "hmac(md5)",
+			.cra_driver_name =3D "mv-hmac-md5",
+			.cra_priority =3D 300,
+			.cra_flags =3D CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize =3D MD5_HMAC_BLOCK_SIZE,
+			.cra_ctxsize =3D sizeof(struct mv_cesa_hmac_ctx),
+			.cra_init =3D mv_cesa_ahmac_cra_init,
+			.cra_module =3D THIS_MODULE,
+		 }
+	}
+};
+
+static int mv_cesa_ahmac_sha1_init(struct ahash_request *req)
+{
+	struct mv_cesa_hmac_ctx *ctx =3D crypto_tfm_ctx(req->base.tfm);
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
+static int mv_cesa_ahmac_sha1_setkey(struct crypto_ahash *tfm, const u=
8 *key,
+				     unsigned int keylen)
+{
+	struct mv_cesa_hmac_ctx *ctx =3D crypto_tfm_ctx(crypto_ahash_tfm(tfm)=
);
+	struct sha1_state istate, ostate;
+	int ret, i;
+
+	ret =3D mv_cesa_ahmac_setkey("mv-sha1", key, keylen, &istate, &ostate=
);
+	if (ret)
+		return ret;
+
+	for (i =3D 0; i < ARRAY_SIZE(istate.state); i++)
+		ctx->iv[i] =3D be32_to_cpu(istate.state[i]);
+
+	for (i =3D 0; i < ARRAY_SIZE(ostate.state); i++)
+		ctx->iv[i + 8] =3D be32_to_cpu(ostate.state[i]);
+
+	return 0;
+}
+
+static int mv_cesa_ahmac_sha1_digest(struct ahash_request *req)
+{
+	int ret;
+
+	ret =3D mv_cesa_ahmac_sha1_init(req);
+	if (ret)
+		return ret;
+
+	return mv_cesa_ahash_finup(req);
+}
+
+struct ahash_alg mv_ahmac_sha1_alg =3D {
+	.init =3D mv_cesa_ahmac_sha1_init,
+	.update =3D mv_cesa_ahash_update,
+	.final =3D mv_cesa_ahash_final,
+	.finup =3D mv_cesa_ahash_finup,
+	.digest =3D mv_cesa_ahmac_sha1_digest,
+	.setkey =3D mv_cesa_ahmac_sha1_setkey,
+	.halg =3D {
+		.digestsize =3D SHA1_DIGEST_SIZE,
+		.statesize =3D sizeof(struct sha1_state),
+		.base =3D {
+			.cra_name =3D "hmac(sha1)",
+			.cra_driver_name =3D "mv-hmac-sha1",
+			.cra_priority =3D 300,
+			.cra_flags =3D CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize =3D SHA1_BLOCK_SIZE,
+			.cra_ctxsize =3D sizeof(struct mv_cesa_hmac_ctx),
+			.cra_init =3D mv_cesa_ahmac_cra_init,
+			.cra_module =3D THIS_MODULE,
+		 }
+	}
+};
+
+static int mv_cesa_ahmac_sha256_setkey(struct crypto_ahash *tfm, const=
 u8 *key,
+				       unsigned int keylen)
+{
+	struct mv_cesa_hmac_ctx *ctx =3D crypto_tfm_ctx(crypto_ahash_tfm(tfm)=
);
+	struct sha256_state istate, ostate;
+	int ret, i;
+
+	ret =3D mv_cesa_ahmac_setkey("mv-sha256", key, keylen, &istate, &osta=
te);
+	if (ret)
+		return ret;
+
+	for (i =3D 0; i < ARRAY_SIZE(istate.state); i++)
+		ctx->iv[i] =3D be32_to_cpu(istate.state[i]);
+
+	for (i =3D 0; i < ARRAY_SIZE(ostate.state); i++)
+		ctx->iv[i + 8] =3D be32_to_cpu(ostate.state[i]);
+
+	return 0;
+}
+
+static int mv_cesa_ahmac_sha256_init(struct ahash_request *req)
+{
+	struct mv_cesa_hmac_ctx *ctx =3D crypto_tfm_ctx(req->base.tfm);
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
+	ret =3D mv_cesa_ahmac_sha256_init(req);
+	if (ret)
+		return ret;
+
+	return mv_cesa_ahash_finup(req);
+}
+
+struct ahash_alg mv_ahmac_sha256_alg =3D {
+	.init =3D mv_cesa_ahmac_sha256_init,
+	.update =3D mv_cesa_ahash_update,
+	.final =3D mv_cesa_ahash_final,
+	.finup =3D mv_cesa_ahash_finup,
+	.digest =3D mv_cesa_ahmac_sha256_digest,
+	.setkey =3D mv_cesa_ahmac_sha256_setkey,
+	.halg =3D {
+		.digestsize =3D SHA256_DIGEST_SIZE,
+		.statesize =3D sizeof(struct sha256_state),
+		.base =3D {
+			.cra_name =3D "hmac(sha256)",
+			.cra_driver_name =3D "mv-hmac-sha256",
+			.cra_priority =3D 300,
+			.cra_flags =3D CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize =3D SHA256_BLOCK_SIZE,
+			.cra_ctxsize =3D sizeof(struct mv_cesa_hmac_ctx),
+			.cra_init =3D mv_cesa_ahmac_cra_init,
+			.cra_module =3D THIS_MODULE,
+		 }
+	}
+};
diff --git a/drivers/crypto/marvell/tdma.c b/drivers/crypto/marvell/tdm=
a.c
new file mode 100644
index 0000000..1084c5a
--- /dev/null
+++ b/drivers/crypto/marvell/tdma.c
@@ -0,0 +1,223 @@
+/*
+ * Provide TDMA helper functions used by cipher and hash algorithm
+ * implementations.
+ *
+ * Author: Boris Brezillon <boris.brezillon@free-electrons.com>
+ * Author: Arnaud Ebalard <arno@natisbad.org>
+ *
+ * This work is based on an initial version written by
+ * Sebastian Andrzej Siewior < sebastian at breakpoint dot cc >
+ *
+ * This program is free software; you can redistribute it and/or modif=
y it
+ * under the terms of the GNU General Public License version 2 as publ=
ished
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
+	sgiter->op_offset +=3D len;
+	sgiter->offset +=3D len;
+	if (sgiter->offset =3D=3D sgiter->sg->length) {
+		if (sg_is_last(sgiter->sg))
+			return false;
+		sgiter->offset =3D 0;
+		sgiter->sg =3D sg_next(sgiter->sg);
+	}
+
+	if (sgiter->op_offset =3D=3D iter->op_len)
+		return false;
+
+	return true;
+}
+
+void mv_cesa_dma_step(struct mv_cesa_tdma_req *dreq)
+{
+	struct mv_cesa_engine *engine =3D dreq->base.engine;
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
+	for (tdma =3D dreq->chain.first; tdma;) {
+		struct mv_cesa_tdma_desc *old_tdma =3D tdma;
+
+		if (tdma->op)
+			dma_pool_free(cesa_dev->dma->op_pool, tdma->op,
+				      le32_to_cpu(tdma->src));
+
+		tdma =3D tdma->next;
+		dma_pool_free(cesa_dev->dma->tdma_desc_pool, old_tdma,
+			      le32_to_cpu(old_tdma->cur_dma));
+	}
+
+	dreq->chain.first =3D NULL;
+	dreq->chain.last =3D NULL;
+}
+
+void mv_cesa_dma_prepare(struct mv_cesa_tdma_req *dreq,
+			 struct mv_cesa_engine *engine)
+{
+	struct mv_cesa_tdma_desc *tdma;
+
+	for (tdma =3D dreq->chain.first; tdma; tdma =3D tdma->next) {
+		if (tdma->flags & CESA_TDMA_DST_IN_SRAM)
+			tdma->dst =3D cpu_to_le32(tdma->dst + engine->sram_dma);
+
+		if (tdma->flags & CESA_TDMA_SRC_IN_SRAM)
+			tdma->src =3D cpu_to_le32(tdma->src + engine->sram_dma);
+
+		if (tdma->op)
+			mv_cesa_adjust_op(engine, tdma->op);
+	}
+}
+
+static struct mv_cesa_tdma_desc *
+mv_cesa_dma_add_desc(struct mv_cesa_tdma_chain *chain, gfp_t flags)
+{
+	struct mv_cesa_tdma_desc *new_tdma =3D NULL;
+	dma_addr_t dma_handle;
+
+	new_tdma =3D dma_pool_alloc(cesa_dev->dma->tdma_desc_pool, flags,
+				  &dma_handle);
+	if (!new_tdma)
+		return ERR_PTR(-ENOMEM);
+
+	memset(new_tdma, 0, sizeof(*new_tdma));
+	new_tdma->cur_dma =3D cpu_to_le32(dma_handle);
+	if (chain->last) {
+		chain->last->next_dma =3D new_tdma->cur_dma;
+		chain->last->next =3D new_tdma;
+	} else {
+		chain->first =3D new_tdma;
+	}
+
+	chain->last =3D new_tdma;
+
+	return new_tdma;
+}
+
+struct mv_cesa_op_ctx *mv_cesa_dma_add_op(struct mv_cesa_tdma_chain *c=
hain,
+					const struct mv_cesa_op_ctx *op_templ,
+					gfp_t flags)
+{
+	struct mv_cesa_tdma_desc *tdma;
+	struct mv_cesa_op_ctx *op;
+	dma_addr_t dma_handle;
+
+	tdma =3D mv_cesa_dma_add_desc(chain, flags);
+	if (IS_ERR(tdma))
+		return ERR_CAST(tdma);
+
+	op =3D dma_pool_alloc(cesa_dev->dma->op_pool, flags, &dma_handle);
+	if (!op)
+		return ERR_PTR(-ENOMEM);
+
+	*op =3D *op_templ;
+
+	tdma =3D chain->last;
+	tdma->op =3D op;
+	tdma->byte_cnt =3D sizeof(*op) | BIT(31);
+	tdma->src =3D dma_handle;
+	tdma->flags =3D CESA_TDMA_DST_IN_SRAM | CESA_TDMA_OP;
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
+	tdma =3D mv_cesa_dma_add_desc(chain, gfp_flags);
+	if (IS_ERR(tdma))
+		return PTR_ERR(tdma);
+
+	tdma->byte_cnt =3D size | BIT(31);
+	tdma->src =3D src;
+	tdma->dst =3D dst;
+
+	flags &=3D (CESA_TDMA_DST_IN_SRAM | CESA_TDMA_SRC_IN_SRAM);
+	tdma->flags =3D flags | CESA_TDMA_DATA;
+
+	return 0;
+}
+
+int mv_cesa_dma_add_dummy_launch(struct mv_cesa_tdma_chain *chain,
+				 u32 flags)
+{
+	struct mv_cesa_tdma_desc *tdma;
+
+	tdma =3D mv_cesa_dma_add_desc(chain, flags);
+	if (IS_ERR(tdma))
+		return PTR_ERR(tdma);
+
+	return 0;
+}
+
+int mv_cesa_dma_add_dummy_end(struct mv_cesa_tdma_chain *chain, u32 fl=
ags)
+{
+	struct mv_cesa_tdma_desc *tdma;
+
+	tdma =3D mv_cesa_dma_add_desc(chain, flags);
+	if (IS_ERR(tdma))
+		return PTR_ERR(tdma);
+
+	tdma->byte_cnt =3D BIT(31);
+
+	return 0;
+}
+
+int mv_cesa_dma_add_op_transfers(struct mv_cesa_tdma_chain *chain,
+				 struct mv_cesa_dma_iter *dma_iter,
+				 struct mv_cesa_sg_dma_iter *sgiter,
+				 gfp_t gfp_flags)
+{
+	u32 flags =3D sgiter->dir =3D=3D DMA_TO_DEVICE ?
+		    CESA_TDMA_DST_IN_SRAM : CESA_TDMA_SRC_IN_SRAM;
+	unsigned int len;
+
+	do {
+		dma_addr_t dst, src;
+		int ret;
+
+		len =3D mv_cesa_req_dma_iter_transfer_len(dma_iter, sgiter);
+		if (sgiter->dir =3D=3D DMA_TO_DEVICE) {
+			dst =3D CESA_SA_DATA_SRAM_OFFSET + sgiter->op_offset;
+			src =3D sgiter->sg->dma_address + sgiter->offset;
+		} else {
+			dst =3D sgiter->sg->dma_address + sgiter->offset;
+			src =3D CESA_SA_DATA_SRAM_OFFSET + sgiter->op_offset;
+		}
+
+		ret =3D mv_cesa_dma_add_data_transfer(chain, dst, src, len,
+						    flags, gfp_flags);
+		if (ret)
+			return ret;
+
+	} while (mv_cesa_req_dma_iter_next_transfer(dma_iter, sgiter, len));
+
+	return 0;
+}
diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
deleted file mode 100644
index f91f15d..0000000
--- a/drivers/crypto/mv_cesa.c
+++ /dev/null
@@ -1,1193 +0,0 @@
-/*
- * Support for Marvell's crypto engine which can be found on some Orio=
n5X
- * boards.
- *
- * Author: Sebastian Andrzej Siewior < sebastian at breakpoint dot cc =
>
- * License: GPLv2
- *
- */
-#include <crypto/aes.h>
-#include <crypto/algapi.h>
-#include <linux/crypto.h>
-#include <linux/interrupt.h>
-#include <linux/io.h>
-#include <linux/kthread.h>
-#include <linux/platform_device.h>
-#include <linux/scatterlist.h>
-#include <linux/slab.h>
-#include <linux/module.h>
-#include <linux/clk.h>
-#include <crypto/internal/hash.h>
-#include <crypto/sha.h>
-#include <linux/of.h>
-#include <linux/of_platform.h>
-#include <linux/of_irq.h>
-
-#include "mv_cesa.h"
-
-#define MV_CESA	"MV-CESA:"
-#define MAX_HW_HASH_SIZE	0xFFFF
-#define MV_CESA_EXPIRE		500 /* msec */
-
-/*
- * STM:
- *   /---------------------------------------\
- *   |					     | request complete
- *  \./					     |
- * IDLE -> new request -> BUSY -> done -> DEQUEUE
- *                         /=C2=B0\               |
- *			    |		     | more scatter entries
- *			    \________________/
- */
-enum engine_status {
-	ENGINE_IDLE,
-	ENGINE_BUSY,
-	ENGINE_W_DEQUEUE,
-};
-
-/**
- * struct req_progress - used for every crypt request
- * @src_sg_it:		sg iterator for src
- * @dst_sg_it:		sg iterator for dst
- * @sg_src_left:	bytes left in src to process (scatter list)
- * @src_start:		offset to add to src start position (scatter list)
- * @crypt_len:		length of current hw crypt/hash process
- * @hw_nbytes:		total bytes to process in hw for this request
- * @copy_back:		whether to copy data back (crypt) or not (hash)
- * @sg_dst_left:	bytes left dst to process in this scatter list
- * @dst_start:		offset to add to dst start position (scatter list)
- * @hw_processed_bytes:	number of bytes processed by hw (request).
- *
- * sg helper are used to iterate over the scatterlist. Since the size =
of the
- * SRAM may be less than the scatter size, this struct struct is used =
to keep
- * track of progress within current scatterlist.
- */
-struct req_progress {
-	struct sg_mapping_iter src_sg_it;
-	struct sg_mapping_iter dst_sg_it;
-	void (*complete) (void);
-	void (*process) (int is_first);
-
-	/* src mostly */
-	int sg_src_left;
-	int src_start;
-	int crypt_len;
-	int hw_nbytes;
-	/* dst mostly */
-	int copy_back;
-	int sg_dst_left;
-	int dst_start;
-	int hw_processed_bytes;
-};
-
-struct crypto_priv {
-	void __iomem *reg;
-	void __iomem *sram;
-	int irq;
-	struct clk *clk;
-	struct task_struct *queue_th;
-
-	/* the lock protects queue and eng_st */
-	spinlock_t lock;
-	struct crypto_queue queue;
-	enum engine_status eng_st;
-	struct timer_list completion_timer;
-	struct crypto_async_request *cur_req;
-	struct req_progress p;
-	int max_req_size;
-	int sram_size;
-	int has_sha1;
-	int has_hmac_sha1;
-};
-
-static struct crypto_priv *cpg;
-
-struct mv_ctx {
-	u8 aes_enc_key[AES_KEY_LEN];
-	u32 aes_dec_key[8];
-	int key_len;
-	u32 need_calc_aes_dkey;
-};
-
-enum crypto_op {
-	COP_AES_ECB,
-	COP_AES_CBC,
-};
-
-struct mv_req_ctx {
-	enum crypto_op op;
-	int decrypt;
-};
-
-enum hash_op {
-	COP_SHA1,
-	COP_HMAC_SHA1
-};
-
-struct mv_tfm_hash_ctx {
-	struct crypto_shash *fallback;
-	struct crypto_shash *base_hash;
-	u32 ivs[2 * SHA1_DIGEST_SIZE / 4];
-	int count_add;
-	enum hash_op op;
-};
-
-struct mv_req_hash_ctx {
-	u64 count;
-	u32 state[SHA1_DIGEST_SIZE / 4];
-	u8 buffer[SHA1_BLOCK_SIZE];
-	int first_hash;		/* marks that we don't have previous state */
-	int last_chunk;		/* marks that this is the 'final' request */
-	int extra_bytes;	/* unprocessed bytes in buffer */
-	enum hash_op op;
-	int count_add;
-};
-
-static void mv_completion_timer_callback(unsigned long unused)
-{
-	int active =3D readl(cpg->reg + SEC_ACCEL_CMD) & SEC_CMD_EN_SEC_ACCL0=
;
-
-	printk(KERN_ERR MV_CESA
-	       "completion timer expired (CESA %sactive), cleaning up.\n",
-	       active ? "" : "in");
-
-	del_timer(&cpg->completion_timer);
-	writel(SEC_CMD_DISABLE_SEC, cpg->reg + SEC_ACCEL_CMD);
-	while(readl(cpg->reg + SEC_ACCEL_CMD) & SEC_CMD_DISABLE_SEC)
-		printk(KERN_INFO MV_CESA "%s: waiting for engine finishing\n", __fun=
c__);
-	cpg->eng_st =3D ENGINE_W_DEQUEUE;
-	wake_up_process(cpg->queue_th);
-}
-
-static void mv_setup_timer(void)
-{
-	setup_timer(&cpg->completion_timer, &mv_completion_timer_callback, 0)=
;
-	mod_timer(&cpg->completion_timer,
-			jiffies + msecs_to_jiffies(MV_CESA_EXPIRE));
-}
-
-static void compute_aes_dec_key(struct mv_ctx *ctx)
-{
-	struct crypto_aes_ctx gen_aes_key;
-	int key_pos;
-
-	if (!ctx->need_calc_aes_dkey)
-		return;
-
-	crypto_aes_expand_key(&gen_aes_key, ctx->aes_enc_key, ctx->key_len);
-
-	key_pos =3D ctx->key_len + 24;
-	memcpy(ctx->aes_dec_key, &gen_aes_key.key_enc[key_pos], 4 * 4);
-	switch (ctx->key_len) {
-	case AES_KEYSIZE_256:
-		key_pos -=3D 2;
-		/* fall */
-	case AES_KEYSIZE_192:
-		key_pos -=3D 2;
-		memcpy(&ctx->aes_dec_key[4], &gen_aes_key.key_enc[key_pos],
-				4 * 4);
-		break;
-	}
-	ctx->need_calc_aes_dkey =3D 0;
-}
-
-static int mv_setkey_aes(struct crypto_ablkcipher *cipher, const u8 *k=
ey,
-		unsigned int len)
-{
-	struct crypto_tfm *tfm =3D crypto_ablkcipher_tfm(cipher);
-	struct mv_ctx *ctx =3D crypto_tfm_ctx(tfm);
-
-	switch (len) {
-	case AES_KEYSIZE_128:
-	case AES_KEYSIZE_192:
-	case AES_KEYSIZE_256:
-		break;
-	default:
-		crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -EINVAL;
-	}
-	ctx->key_len =3D len;
-	ctx->need_calc_aes_dkey =3D 1;
-
-	memcpy(ctx->aes_enc_key, key, AES_KEY_LEN);
-	return 0;
-}
-
-static void copy_src_to_buf(struct req_progress *p, char *dbuf, int le=
n)
-{
-	int ret;
-	void *sbuf;
-	int copy_len;
-
-	while (len) {
-		if (!p->sg_src_left) {
-			ret =3D sg_miter_next(&p->src_sg_it);
-			BUG_ON(!ret);
-			p->sg_src_left =3D p->src_sg_it.length;
-			p->src_start =3D 0;
-		}
-
-		sbuf =3D p->src_sg_it.addr + p->src_start;
-
-		copy_len =3D min(p->sg_src_left, len);
-		memcpy(dbuf, sbuf, copy_len);
-
-		p->src_start +=3D copy_len;
-		p->sg_src_left -=3D copy_len;
-
-		len -=3D copy_len;
-		dbuf +=3D copy_len;
-	}
-}
-
-static void setup_data_in(void)
-{
-	struct req_progress *p =3D &cpg->p;
-	int data_in_sram =3D
-	    min(p->hw_nbytes - p->hw_processed_bytes, cpg->max_req_size);
-	copy_src_to_buf(p, cpg->sram + SRAM_DATA_IN_START + p->crypt_len,
-			data_in_sram - p->crypt_len);
-	p->crypt_len =3D data_in_sram;
-}
-
-static void mv_process_current_q(int first_block)
-{
-	struct ablkcipher_request *req =3D ablkcipher_request_cast(cpg->cur_r=
eq);
-	struct mv_ctx *ctx =3D crypto_tfm_ctx(req->base.tfm);
-	struct mv_req_ctx *req_ctx =3D ablkcipher_request_ctx(req);
-	struct sec_accel_config op;
-
-	switch (req_ctx->op) {
-	case COP_AES_ECB:
-		op.config =3D CFG_OP_CRYPT_ONLY | CFG_ENCM_AES | CFG_ENC_MODE_ECB;
-		break;
-	case COP_AES_CBC:
-	default:
-		op.config =3D CFG_OP_CRYPT_ONLY | CFG_ENCM_AES | CFG_ENC_MODE_CBC;
-		op.enc_iv =3D ENC_IV_POINT(SRAM_DATA_IV) |
-			ENC_IV_BUF_POINT(SRAM_DATA_IV_BUF);
-		if (first_block)
-			memcpy(cpg->sram + SRAM_DATA_IV, req->info, 16);
-		break;
-	}
-	if (req_ctx->decrypt) {
-		op.config |=3D CFG_DIR_DEC;
-		memcpy(cpg->sram + SRAM_DATA_KEY_P, ctx->aes_dec_key,
-				AES_KEY_LEN);
-	} else {
-		op.config |=3D CFG_DIR_ENC;
-		memcpy(cpg->sram + SRAM_DATA_KEY_P, ctx->aes_enc_key,
-				AES_KEY_LEN);
-	}
-
-	switch (ctx->key_len) {
-	case AES_KEYSIZE_128:
-		op.config |=3D CFG_AES_LEN_128;
-		break;
-	case AES_KEYSIZE_192:
-		op.config |=3D CFG_AES_LEN_192;
-		break;
-	case AES_KEYSIZE_256:
-		op.config |=3D CFG_AES_LEN_256;
-		break;
-	}
-	op.enc_p =3D ENC_P_SRC(SRAM_DATA_IN_START) |
-		ENC_P_DST(SRAM_DATA_OUT_START);
-	op.enc_key_p =3D SRAM_DATA_KEY_P;
-
-	setup_data_in();
-	op.enc_len =3D cpg->p.crypt_len;
-	memcpy(cpg->sram + SRAM_CONFIG, &op,
-			sizeof(struct sec_accel_config));
-
-	/* GO */
-	mv_setup_timer();
-	writel(SEC_CMD_EN_SEC_ACCL0, cpg->reg + SEC_ACCEL_CMD);
-}
-
-static void mv_crypto_algo_completion(void)
-{
-	struct ablkcipher_request *req =3D ablkcipher_request_cast(cpg->cur_r=
eq);
-	struct mv_req_ctx *req_ctx =3D ablkcipher_request_ctx(req);
-
-	sg_miter_stop(&cpg->p.src_sg_it);
-	sg_miter_stop(&cpg->p.dst_sg_it);
-
-	if (req_ctx->op !=3D COP_AES_CBC)
-		return ;
-
-	memcpy(req->info, cpg->sram + SRAM_DATA_IV_BUF, 16);
-}
-
-static void mv_process_hash_current(int first_block)
-{
-	struct ahash_request *req =3D ahash_request_cast(cpg->cur_req);
-	const struct mv_tfm_hash_ctx *tfm_ctx =3D crypto_tfm_ctx(req->base.tf=
m);
-	struct mv_req_hash_ctx *req_ctx =3D ahash_request_ctx(req);
-	struct req_progress *p =3D &cpg->p;
-	struct sec_accel_config op =3D { 0 };
-	int is_last;
-
-	switch (req_ctx->op) {
-	case COP_SHA1:
-	default:
-		op.config =3D CFG_OP_MAC_ONLY | CFG_MACM_SHA1;
-		break;
-	case COP_HMAC_SHA1:
-		op.config =3D CFG_OP_MAC_ONLY | CFG_MACM_HMAC_SHA1;
-		memcpy(cpg->sram + SRAM_HMAC_IV_IN,
-				tfm_ctx->ivs, sizeof(tfm_ctx->ivs));
-		break;
-	}
-
-	op.mac_src_p =3D
-		MAC_SRC_DATA_P(SRAM_DATA_IN_START) | MAC_SRC_TOTAL_LEN((u32)
-		req_ctx->
-		count);
-
-	setup_data_in();
-
-	op.mac_digest =3D
-		MAC_DIGEST_P(SRAM_DIGEST_BUF) | MAC_FRAG_LEN(p->crypt_len);
-	op.mac_iv =3D
-		MAC_INNER_IV_P(SRAM_HMAC_IV_IN) |
-		MAC_OUTER_IV_P(SRAM_HMAC_IV_OUT);
-
-	is_last =3D req_ctx->last_chunk
-		&& (p->hw_processed_bytes + p->crypt_len >=3D p->hw_nbytes)
-		&& (req_ctx->count <=3D MAX_HW_HASH_SIZE);
-	if (req_ctx->first_hash) {
-		if (is_last)
-			op.config |=3D CFG_NOT_FRAG;
-		else
-			op.config |=3D CFG_FIRST_FRAG;
-
-		req_ctx->first_hash =3D 0;
-	} else {
-		if (is_last)
-			op.config |=3D CFG_LAST_FRAG;
-		else
-			op.config |=3D CFG_MID_FRAG;
-
-		if (first_block) {
-			writel(req_ctx->state[0], cpg->reg + DIGEST_INITIAL_VAL_A);
-			writel(req_ctx->state[1], cpg->reg + DIGEST_INITIAL_VAL_B);
-			writel(req_ctx->state[2], cpg->reg + DIGEST_INITIAL_VAL_C);
-			writel(req_ctx->state[3], cpg->reg + DIGEST_INITIAL_VAL_D);
-			writel(req_ctx->state[4], cpg->reg + DIGEST_INITIAL_VAL_E);
-		}
-	}
-
-	memcpy(cpg->sram + SRAM_CONFIG, &op, sizeof(struct sec_accel_config))=
;
-
-	/* GO */
-	mv_setup_timer();
-	writel(SEC_CMD_EN_SEC_ACCL0, cpg->reg + SEC_ACCEL_CMD);
-}
-
-static inline int mv_hash_import_sha1_ctx(const struct mv_req_hash_ctx=
 *ctx,
-					  struct shash_desc *desc)
-{
-	int i;
-	struct sha1_state shash_state;
-
-	shash_state.count =3D ctx->count + ctx->count_add;
-	for (i =3D 0; i < 5; i++)
-		shash_state.state[i] =3D ctx->state[i];
-	memcpy(shash_state.buffer, ctx->buffer, sizeof(shash_state.buffer));
-	return crypto_shash_import(desc, &shash_state);
-}
-
-static int mv_hash_final_fallback(struct ahash_request *req)
-{
-	const struct mv_tfm_hash_ctx *tfm_ctx =3D crypto_tfm_ctx(req->base.tf=
m);
-	struct mv_req_hash_ctx *req_ctx =3D ahash_request_ctx(req);
-	SHASH_DESC_ON_STACK(shash, tfm_ctx->fallback);
-	int rc;
-
-	shash->tfm =3D tfm_ctx->fallback;
-	shash->flags =3D CRYPTO_TFM_REQ_MAY_SLEEP;
-	if (unlikely(req_ctx->first_hash)) {
-		crypto_shash_init(shash);
-		crypto_shash_update(shash, req_ctx->buffer,
-				    req_ctx->extra_bytes);
-	} else {
-		/* only SHA1 for now....
-		 */
-		rc =3D mv_hash_import_sha1_ctx(req_ctx, shash);
-		if (rc)
-			goto out;
-	}
-	rc =3D crypto_shash_final(shash, req->result);
-out:
-	return rc;
-}
-
-static void mv_save_digest_state(struct mv_req_hash_ctx *ctx)
-{
-	ctx->state[0] =3D readl(cpg->reg + DIGEST_INITIAL_VAL_A);
-	ctx->state[1] =3D readl(cpg->reg + DIGEST_INITIAL_VAL_B);
-	ctx->state[2] =3D readl(cpg->reg + DIGEST_INITIAL_VAL_C);
-	ctx->state[3] =3D readl(cpg->reg + DIGEST_INITIAL_VAL_D);
-	ctx->state[4] =3D readl(cpg->reg + DIGEST_INITIAL_VAL_E);
-}
-
-static void mv_hash_algo_completion(void)
-{
-	struct ahash_request *req =3D ahash_request_cast(cpg->cur_req);
-	struct mv_req_hash_ctx *ctx =3D ahash_request_ctx(req);
-
-	if (ctx->extra_bytes)
-		copy_src_to_buf(&cpg->p, ctx->buffer, ctx->extra_bytes);
-	sg_miter_stop(&cpg->p.src_sg_it);
-
-	if (likely(ctx->last_chunk)) {
-		if (likely(ctx->count <=3D MAX_HW_HASH_SIZE)) {
-			memcpy(req->result, cpg->sram + SRAM_DIGEST_BUF,
-			       crypto_ahash_digestsize(crypto_ahash_reqtfm
-						       (req)));
-		} else {
-			mv_save_digest_state(ctx);
-			mv_hash_final_fallback(req);
-		}
-	} else {
-		mv_save_digest_state(ctx);
-	}
-}
-
-static void dequeue_complete_req(void)
-{
-	struct crypto_async_request *req =3D cpg->cur_req;
-	void *buf;
-	int ret;
-	cpg->p.hw_processed_bytes +=3D cpg->p.crypt_len;
-	if (cpg->p.copy_back) {
-		int need_copy_len =3D cpg->p.crypt_len;
-		int sram_offset =3D 0;
-		do {
-			int dst_copy;
-
-			if (!cpg->p.sg_dst_left) {
-				ret =3D sg_miter_next(&cpg->p.dst_sg_it);
-				BUG_ON(!ret);
-				cpg->p.sg_dst_left =3D cpg->p.dst_sg_it.length;
-				cpg->p.dst_start =3D 0;
-			}
-
-			buf =3D cpg->p.dst_sg_it.addr;
-			buf +=3D cpg->p.dst_start;
-
-			dst_copy =3D min(need_copy_len, cpg->p.sg_dst_left);
-
-			memcpy(buf,
-			       cpg->sram + SRAM_DATA_OUT_START + sram_offset,
-			       dst_copy);
-			sram_offset +=3D dst_copy;
-			cpg->p.sg_dst_left -=3D dst_copy;
-			need_copy_len -=3D dst_copy;
-			cpg->p.dst_start +=3D dst_copy;
-		} while (need_copy_len > 0);
-	}
-
-	cpg->p.crypt_len =3D 0;
-
-	BUG_ON(cpg->eng_st !=3D ENGINE_W_DEQUEUE);
-	if (cpg->p.hw_processed_bytes < cpg->p.hw_nbytes) {
-		/* process next scatter list entry */
-		cpg->eng_st =3D ENGINE_BUSY;
-		cpg->p.process(0);
-	} else {
-		cpg->p.complete();
-		cpg->eng_st =3D ENGINE_IDLE;
-		local_bh_disable();
-		req->complete(req, 0);
-		local_bh_enable();
-	}
-}
-
-static int count_sgs(struct scatterlist *sl, unsigned int total_bytes)
-{
-	int i =3D 0;
-	size_t cur_len;
-
-	while (sl) {
-		cur_len =3D sl[i].length;
-		++i;
-		if (total_bytes > cur_len)
-			total_bytes -=3D cur_len;
-		else
-			break;
-	}
-
-	return i;
-}
-
-static void mv_start_new_crypt_req(struct ablkcipher_request *req)
-{
-	struct req_progress *p =3D &cpg->p;
-	int num_sgs;
-
-	cpg->cur_req =3D &req->base;
-	memset(p, 0, sizeof(struct req_progress));
-	p->hw_nbytes =3D req->nbytes;
-	p->complete =3D mv_crypto_algo_completion;
-	p->process =3D mv_process_current_q;
-	p->copy_back =3D 1;
-
-	num_sgs =3D count_sgs(req->src, req->nbytes);
-	sg_miter_start(&p->src_sg_it, req->src, num_sgs, SG_MITER_FROM_SG);
-
-	num_sgs =3D count_sgs(req->dst, req->nbytes);
-	sg_miter_start(&p->dst_sg_it, req->dst, num_sgs, SG_MITER_TO_SG);
-
-	mv_process_current_q(1);
-}
-
-static void mv_start_new_hash_req(struct ahash_request *req)
-{
-	struct req_progress *p =3D &cpg->p;
-	struct mv_req_hash_ctx *ctx =3D ahash_request_ctx(req);
-	int num_sgs, hw_bytes, old_extra_bytes, rc;
-	cpg->cur_req =3D &req->base;
-	memset(p, 0, sizeof(struct req_progress));
-	hw_bytes =3D req->nbytes + ctx->extra_bytes;
-	old_extra_bytes =3D ctx->extra_bytes;
-
-	ctx->extra_bytes =3D hw_bytes % SHA1_BLOCK_SIZE;
-	if (ctx->extra_bytes !=3D 0
-	    && (!ctx->last_chunk || ctx->count > MAX_HW_HASH_SIZE))
-		hw_bytes -=3D ctx->extra_bytes;
-	else
-		ctx->extra_bytes =3D 0;
-
-	num_sgs =3D count_sgs(req->src, req->nbytes);
-	sg_miter_start(&p->src_sg_it, req->src, num_sgs, SG_MITER_FROM_SG);
-
-	if (hw_bytes) {
-		p->hw_nbytes =3D hw_bytes;
-		p->complete =3D mv_hash_algo_completion;
-		p->process =3D mv_process_hash_current;
-
-		if (unlikely(old_extra_bytes)) {
-			memcpy(cpg->sram + SRAM_DATA_IN_START, ctx->buffer,
-			       old_extra_bytes);
-			p->crypt_len =3D old_extra_bytes;
-		}
-
-		mv_process_hash_current(1);
-	} else {
-		copy_src_to_buf(p, ctx->buffer + old_extra_bytes,
-				ctx->extra_bytes - old_extra_bytes);
-		sg_miter_stop(&p->src_sg_it);
-		if (ctx->last_chunk)
-			rc =3D mv_hash_final_fallback(req);
-		else
-			rc =3D 0;
-		cpg->eng_st =3D ENGINE_IDLE;
-		local_bh_disable();
-		req->base.complete(&req->base, rc);
-		local_bh_enable();
-	}
-}
-
-static int queue_manag(void *data)
-{
-	cpg->eng_st =3D ENGINE_IDLE;
-	do {
-		struct crypto_async_request *async_req =3D NULL;
-		struct crypto_async_request *backlog;
-
-		__set_current_state(TASK_INTERRUPTIBLE);
-
-		if (cpg->eng_st =3D=3D ENGINE_W_DEQUEUE)
-			dequeue_complete_req();
-
-		spin_lock_irq(&cpg->lock);
-		if (cpg->eng_st =3D=3D ENGINE_IDLE) {
-			backlog =3D crypto_get_backlog(&cpg->queue);
-			async_req =3D crypto_dequeue_request(&cpg->queue);
-			if (async_req) {
-				BUG_ON(cpg->eng_st !=3D ENGINE_IDLE);
-				cpg->eng_st =3D ENGINE_BUSY;
-			}
-		}
-		spin_unlock_irq(&cpg->lock);
-
-		if (backlog) {
-			backlog->complete(backlog, -EINPROGRESS);
-			backlog =3D NULL;
-		}
-
-		if (async_req) {
-			if (crypto_tfm_alg_type(async_req->tfm) !=3D
-			    CRYPTO_ALG_TYPE_AHASH) {
-				struct ablkcipher_request *req =3D
-				    ablkcipher_request_cast(async_req);
-				mv_start_new_crypt_req(req);
-			} else {
-				struct ahash_request *req =3D
-				    ahash_request_cast(async_req);
-				mv_start_new_hash_req(req);
-			}
-			async_req =3D NULL;
-		}
-
-		schedule();
-
-	} while (!kthread_should_stop());
-	return 0;
-}
-
-static int mv_handle_req(struct crypto_async_request *req)
-{
-	unsigned long flags;
-	int ret;
-
-	spin_lock_irqsave(&cpg->lock, flags);
-	ret =3D crypto_enqueue_request(&cpg->queue, req);
-	spin_unlock_irqrestore(&cpg->lock, flags);
-	wake_up_process(cpg->queue_th);
-	return ret;
-}
-
-static int mv_enc_aes_ecb(struct ablkcipher_request *req)
-{
-	struct mv_req_ctx *req_ctx =3D ablkcipher_request_ctx(req);
-
-	req_ctx->op =3D COP_AES_ECB;
-	req_ctx->decrypt =3D 0;
-
-	return mv_handle_req(&req->base);
-}
-
-static int mv_dec_aes_ecb(struct ablkcipher_request *req)
-{
-	struct mv_ctx *ctx =3D crypto_tfm_ctx(req->base.tfm);
-	struct mv_req_ctx *req_ctx =3D ablkcipher_request_ctx(req);
-
-	req_ctx->op =3D COP_AES_ECB;
-	req_ctx->decrypt =3D 1;
-
-	compute_aes_dec_key(ctx);
-	return mv_handle_req(&req->base);
-}
-
-static int mv_enc_aes_cbc(struct ablkcipher_request *req)
-{
-	struct mv_req_ctx *req_ctx =3D ablkcipher_request_ctx(req);
-
-	req_ctx->op =3D COP_AES_CBC;
-	req_ctx->decrypt =3D 0;
-
-	return mv_handle_req(&req->base);
-}
-
-static int mv_dec_aes_cbc(struct ablkcipher_request *req)
-{
-	struct mv_ctx *ctx =3D crypto_tfm_ctx(req->base.tfm);
-	struct mv_req_ctx *req_ctx =3D ablkcipher_request_ctx(req);
-
-	req_ctx->op =3D COP_AES_CBC;
-	req_ctx->decrypt =3D 1;
-
-	compute_aes_dec_key(ctx);
-	return mv_handle_req(&req->base);
-}
-
-static int mv_cra_init(struct crypto_tfm *tfm)
-{
-	tfm->crt_ablkcipher.reqsize =3D sizeof(struct mv_req_ctx);
-	return 0;
-}
-
-static void mv_init_hash_req_ctx(struct mv_req_hash_ctx *ctx, int op,
-				 int is_last, unsigned int req_len,
-				 int count_add)
-{
-	memset(ctx, 0, sizeof(*ctx));
-	ctx->op =3D op;
-	ctx->count =3D req_len;
-	ctx->first_hash =3D 1;
-	ctx->last_chunk =3D is_last;
-	ctx->count_add =3D count_add;
-}
-
-static void mv_update_hash_req_ctx(struct mv_req_hash_ctx *ctx, int is=
_last,
-				   unsigned req_len)
-{
-	ctx->last_chunk =3D is_last;
-	ctx->count +=3D req_len;
-}
-
-static int mv_hash_init(struct ahash_request *req)
-{
-	const struct mv_tfm_hash_ctx *tfm_ctx =3D crypto_tfm_ctx(req->base.tf=
m);
-	mv_init_hash_req_ctx(ahash_request_ctx(req), tfm_ctx->op, 0, 0,
-			     tfm_ctx->count_add);
-	return 0;
-}
-
-static int mv_hash_update(struct ahash_request *req)
-{
-	if (!req->nbytes)
-		return 0;
-
-	mv_update_hash_req_ctx(ahash_request_ctx(req), 0, req->nbytes);
-	return mv_handle_req(&req->base);
-}
-
-static int mv_hash_final(struct ahash_request *req)
-{
-	struct mv_req_hash_ctx *ctx =3D ahash_request_ctx(req);
-
-	ahash_request_set_crypt(req, NULL, req->result, 0);
-	mv_update_hash_req_ctx(ctx, 1, 0);
-	return mv_handle_req(&req->base);
-}
-
-static int mv_hash_finup(struct ahash_request *req)
-{
-	mv_update_hash_req_ctx(ahash_request_ctx(req), 1, req->nbytes);
-	return mv_handle_req(&req->base);
-}
-
-static int mv_hash_digest(struct ahash_request *req)
-{
-	const struct mv_tfm_hash_ctx *tfm_ctx =3D crypto_tfm_ctx(req->base.tf=
m);
-	mv_init_hash_req_ctx(ahash_request_ctx(req), tfm_ctx->op, 1,
-			     req->nbytes, tfm_ctx->count_add);
-	return mv_handle_req(&req->base);
-}
-
-static void mv_hash_init_ivs(struct mv_tfm_hash_ctx *ctx, const void *=
istate,
-			     const void *ostate)
-{
-	const struct sha1_state *isha1_state =3D istate, *osha1_state =3D ost=
ate;
-	int i;
-	for (i =3D 0; i < 5; i++) {
-		ctx->ivs[i] =3D cpu_to_be32(isha1_state->state[i]);
-		ctx->ivs[i + 5] =3D cpu_to_be32(osha1_state->state[i]);
-	}
-}
-
-static int mv_hash_setkey(struct crypto_ahash *tfm, const u8 * key,
-			  unsigned int keylen)
-{
-	int rc;
-	struct mv_tfm_hash_ctx *ctx =3D crypto_tfm_ctx(&tfm->base);
-	int bs, ds, ss;
-
-	if (!ctx->base_hash)
-		return 0;
-
-	rc =3D crypto_shash_setkey(ctx->fallback, key, keylen);
-	if (rc)
-		return rc;
-
-	/* Can't see a way to extract the ipad/opad from the fallback tfm
-	   so I'm basically copying code from the hmac module */
-	bs =3D crypto_shash_blocksize(ctx->base_hash);
-	ds =3D crypto_shash_digestsize(ctx->base_hash);
-	ss =3D crypto_shash_statesize(ctx->base_hash);
-
-	{
-		SHASH_DESC_ON_STACK(shash, ctx->base_hash);
-
-		unsigned int i;
-		char ipad[ss];
-		char opad[ss];
-
-		shash->tfm =3D ctx->base_hash;
-		shash->flags =3D crypto_shash_get_flags(ctx->base_hash) &
-		    CRYPTO_TFM_REQ_MAY_SLEEP;
-
-		if (keylen > bs) {
-			int err;
-
-			err =3D
-			    crypto_shash_digest(shash, key, keylen, ipad);
-			if (err)
-				return err;
-
-			keylen =3D ds;
-		} else
-			memcpy(ipad, key, keylen);
-
-		memset(ipad + keylen, 0, bs - keylen);
-		memcpy(opad, ipad, bs);
-
-		for (i =3D 0; i < bs; i++) {
-			ipad[i] ^=3D 0x36;
-			opad[i] ^=3D 0x5c;
-		}
-
-		rc =3D crypto_shash_init(shash) ? :
-		    crypto_shash_update(shash, ipad, bs) ? :
-		    crypto_shash_export(shash, ipad) ? :
-		    crypto_shash_init(shash) ? :
-		    crypto_shash_update(shash, opad, bs) ? :
-		    crypto_shash_export(shash, opad);
-
-		if (rc =3D=3D 0)
-			mv_hash_init_ivs(ctx, ipad, opad);
-
-		return rc;
-	}
-}
-
-static int mv_cra_hash_init(struct crypto_tfm *tfm, const char *base_h=
ash_name,
-			    enum hash_op op, int count_add)
-{
-	const char *fallback_driver_name =3D crypto_tfm_alg_name(tfm);
-	struct mv_tfm_hash_ctx *ctx =3D crypto_tfm_ctx(tfm);
-	struct crypto_shash *fallback_tfm =3D NULL;
-	struct crypto_shash *base_hash =3D NULL;
-	int err =3D -ENOMEM;
-
-	ctx->op =3D op;
-	ctx->count_add =3D count_add;
-
-	/* Allocate a fallback and abort if it failed. */
-	fallback_tfm =3D crypto_alloc_shash(fallback_driver_name, 0,
-					  CRYPTO_ALG_NEED_FALLBACK);
-	if (IS_ERR(fallback_tfm)) {
-		printk(KERN_WARNING MV_CESA
-		       "Fallback driver '%s' could not be loaded!\n",
-		       fallback_driver_name);
-		err =3D PTR_ERR(fallback_tfm);
-		goto out;
-	}
-	ctx->fallback =3D fallback_tfm;
-
-	if (base_hash_name) {
-		/* Allocate a hash to compute the ipad/opad of hmac. */
-		base_hash =3D crypto_alloc_shash(base_hash_name, 0,
-					       CRYPTO_ALG_NEED_FALLBACK);
-		if (IS_ERR(base_hash)) {
-			printk(KERN_WARNING MV_CESA
-			       "Base driver '%s' could not be loaded!\n",
-			       base_hash_name);
-			err =3D PTR_ERR(base_hash);
-			goto err_bad_base;
-		}
-	}
-	ctx->base_hash =3D base_hash;
-
-	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
-				 sizeof(struct mv_req_hash_ctx) +
-				 crypto_shash_descsize(ctx->fallback));
-	return 0;
-err_bad_base:
-	crypto_free_shash(fallback_tfm);
-out:
-	return err;
-}
-
-static void mv_cra_hash_exit(struct crypto_tfm *tfm)
-{
-	struct mv_tfm_hash_ctx *ctx =3D crypto_tfm_ctx(tfm);
-
-	crypto_free_shash(ctx->fallback);
-	if (ctx->base_hash)
-		crypto_free_shash(ctx->base_hash);
-}
-
-static int mv_cra_hash_sha1_init(struct crypto_tfm *tfm)
-{
-	return mv_cra_hash_init(tfm, NULL, COP_SHA1, 0);
-}
-
-static int mv_cra_hash_hmac_sha1_init(struct crypto_tfm *tfm)
-{
-	return mv_cra_hash_init(tfm, "sha1", COP_HMAC_SHA1, SHA1_BLOCK_SIZE);
-}
-
-static irqreturn_t crypto_int(int irq, void *priv)
-{
-	u32 val;
-
-	val =3D readl(cpg->reg + SEC_ACCEL_INT_STATUS);
-	if (!(val & SEC_INT_ACCEL0_DONE))
-		return IRQ_NONE;
-
-	if (!del_timer(&cpg->completion_timer)) {
-		printk(KERN_WARNING MV_CESA
-		       "got an interrupt but no pending timer?\n");
-	}
-	val &=3D ~SEC_INT_ACCEL0_DONE;
-	writel(val, cpg->reg + FPGA_INT_STATUS);
-	writel(val, cpg->reg + SEC_ACCEL_INT_STATUS);
-	BUG_ON(cpg->eng_st !=3D ENGINE_BUSY);
-	cpg->eng_st =3D ENGINE_W_DEQUEUE;
-	wake_up_process(cpg->queue_th);
-	return IRQ_HANDLED;
-}
-
-static struct crypto_alg mv_aes_alg_ecb =3D {
-	.cra_name		=3D "ecb(aes)",
-	.cra_driver_name	=3D "mv-ecb-aes",
-	.cra_priority	=3D 300,
-	.cra_flags	=3D CRYPTO_ALG_TYPE_ABLKCIPHER |
-			  CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
-	.cra_blocksize	=3D 16,
-	.cra_ctxsize	=3D sizeof(struct mv_ctx),
-	.cra_alignmask	=3D 0,
-	.cra_type	=3D &crypto_ablkcipher_type,
-	.cra_module	=3D THIS_MODULE,
-	.cra_init	=3D mv_cra_init,
-	.cra_u		=3D {
-		.ablkcipher =3D {
-			.min_keysize	=3D	AES_MIN_KEY_SIZE,
-			.max_keysize	=3D	AES_MAX_KEY_SIZE,
-			.setkey		=3D	mv_setkey_aes,
-			.encrypt	=3D	mv_enc_aes_ecb,
-			.decrypt	=3D	mv_dec_aes_ecb,
-		},
-	},
-};
-
-static struct crypto_alg mv_aes_alg_cbc =3D {
-	.cra_name		=3D "cbc(aes)",
-	.cra_driver_name	=3D "mv-cbc-aes",
-	.cra_priority	=3D 300,
-	.cra_flags	=3D CRYPTO_ALG_TYPE_ABLKCIPHER |
-			  CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
-	.cra_blocksize	=3D AES_BLOCK_SIZE,
-	.cra_ctxsize	=3D sizeof(struct mv_ctx),
-	.cra_alignmask	=3D 0,
-	.cra_type	=3D &crypto_ablkcipher_type,
-	.cra_module	=3D THIS_MODULE,
-	.cra_init	=3D mv_cra_init,
-	.cra_u		=3D {
-		.ablkcipher =3D {
-			.ivsize		=3D	AES_BLOCK_SIZE,
-			.min_keysize	=3D	AES_MIN_KEY_SIZE,
-			.max_keysize	=3D	AES_MAX_KEY_SIZE,
-			.setkey		=3D	mv_setkey_aes,
-			.encrypt	=3D	mv_enc_aes_cbc,
-			.decrypt	=3D	mv_dec_aes_cbc,
-		},
-	},
-};
-
-static struct ahash_alg mv_sha1_alg =3D {
-	.init =3D mv_hash_init,
-	.update =3D mv_hash_update,
-	.final =3D mv_hash_final,
-	.finup =3D mv_hash_finup,
-	.digest =3D mv_hash_digest,
-	.halg =3D {
-		 .digestsize =3D SHA1_DIGEST_SIZE,
-		 .base =3D {
-			  .cra_name =3D "sha1",
-			  .cra_driver_name =3D "mv-sha1",
-			  .cra_priority =3D 300,
-			  .cra_flags =3D
-			  CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY |
-			  CRYPTO_ALG_NEED_FALLBACK,
-			  .cra_blocksize =3D SHA1_BLOCK_SIZE,
-			  .cra_ctxsize =3D sizeof(struct mv_tfm_hash_ctx),
-			  .cra_init =3D mv_cra_hash_sha1_init,
-			  .cra_exit =3D mv_cra_hash_exit,
-			  .cra_module =3D THIS_MODULE,
-			  }
-		 }
-};
-
-static struct ahash_alg mv_hmac_sha1_alg =3D {
-	.init =3D mv_hash_init,
-	.update =3D mv_hash_update,
-	.final =3D mv_hash_final,
-	.finup =3D mv_hash_finup,
-	.digest =3D mv_hash_digest,
-	.setkey =3D mv_hash_setkey,
-	.halg =3D {
-		 .digestsize =3D SHA1_DIGEST_SIZE,
-		 .base =3D {
-			  .cra_name =3D "hmac(sha1)",
-			  .cra_driver_name =3D "mv-hmac-sha1",
-			  .cra_priority =3D 300,
-			  .cra_flags =3D
-			  CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY |
-			  CRYPTO_ALG_NEED_FALLBACK,
-			  .cra_blocksize =3D SHA1_BLOCK_SIZE,
-			  .cra_ctxsize =3D sizeof(struct mv_tfm_hash_ctx),
-			  .cra_init =3D mv_cra_hash_hmac_sha1_init,
-			  .cra_exit =3D mv_cra_hash_exit,
-			  .cra_module =3D THIS_MODULE,
-			  }
-		 }
-};
-
-static int mv_probe(struct platform_device *pdev)
-{
-	struct crypto_priv *cp;
-	struct resource *res;
-	int irq;
-	int ret;
-
-	if (cpg) {
-		printk(KERN_ERR MV_CESA "Second crypto dev?\n");
-		return -EEXIST;
-	}
-
-	res =3D platform_get_resource_byname(pdev, IORESOURCE_MEM, "regs");
-	if (!res)
-		return -ENXIO;
-
-	cp =3D kzalloc(sizeof(*cp), GFP_KERNEL);
-	if (!cp)
-		return -ENOMEM;
-
-	spin_lock_init(&cp->lock);
-	crypto_init_queue(&cp->queue, 50);
-	cp->reg =3D ioremap(res->start, resource_size(res));
-	if (!cp->reg) {
-		ret =3D -ENOMEM;
-		goto err;
-	}
-
-	res =3D platform_get_resource_byname(pdev, IORESOURCE_MEM, "sram");
-	if (!res) {
-		ret =3D -ENXIO;
-		goto err_unmap_reg;
-	}
-	cp->sram_size =3D resource_size(res);
-	cp->max_req_size =3D cp->sram_size - SRAM_CFG_SPACE;
-	cp->sram =3D ioremap(res->start, cp->sram_size);
-	if (!cp->sram) {
-		ret =3D -ENOMEM;
-		goto err_unmap_reg;
-	}
-
-	if (pdev->dev.of_node)
-		irq =3D irq_of_parse_and_map(pdev->dev.of_node, 0);
-	else
-		irq =3D platform_get_irq(pdev, 0);
-	if (irq < 0 || irq =3D=3D NO_IRQ) {
-		ret =3D irq;
-		goto err_unmap_sram;
-	}
-	cp->irq =3D irq;
-
-	platform_set_drvdata(pdev, cp);
-	cpg =3D cp;
-
-	cp->queue_th =3D kthread_run(queue_manag, cp, "mv_crypto");
-	if (IS_ERR(cp->queue_th)) {
-		ret =3D PTR_ERR(cp->queue_th);
-		goto err_unmap_sram;
-	}
-
-	ret =3D request_irq(irq, crypto_int, 0, dev_name(&pdev->dev),
-			cp);
-	if (ret)
-		goto err_thread;
-
-	/* Not all platforms can gate the clock, so it is not
-	   an error if the clock does not exists. */
-	cp->clk =3D clk_get(&pdev->dev, NULL);
-	if (!IS_ERR(cp->clk))
-		clk_prepare_enable(cp->clk);
-
-	writel(0, cpg->reg + SEC_ACCEL_INT_STATUS);
-	writel(SEC_INT_ACCEL0_DONE, cpg->reg + SEC_ACCEL_INT_MASK);
-	writel(SEC_CFG_STOP_DIG_ERR, cpg->reg + SEC_ACCEL_CFG);
-	writel(SRAM_CONFIG, cpg->reg + SEC_ACCEL_DESC_P0);
-
-	ret =3D crypto_register_alg(&mv_aes_alg_ecb);
-	if (ret) {
-		printk(KERN_WARNING MV_CESA
-		       "Could not register aes-ecb driver\n");
-		goto err_irq;
-	}
-
-	ret =3D crypto_register_alg(&mv_aes_alg_cbc);
-	if (ret) {
-		printk(KERN_WARNING MV_CESA
-		       "Could not register aes-cbc driver\n");
-		goto err_unreg_ecb;
-	}
-
-	ret =3D crypto_register_ahash(&mv_sha1_alg);
-	if (ret =3D=3D 0)
-		cpg->has_sha1 =3D 1;
-	else
-		printk(KERN_WARNING MV_CESA "Could not register sha1 driver\n");
-
-	ret =3D crypto_register_ahash(&mv_hmac_sha1_alg);
-	if (ret =3D=3D 0) {
-		cpg->has_hmac_sha1 =3D 1;
-	} else {
-		printk(KERN_WARNING MV_CESA
-		       "Could not register hmac-sha1 driver\n");
-	}
-
-	return 0;
-err_unreg_ecb:
-	crypto_unregister_alg(&mv_aes_alg_ecb);
-err_irq:
-	free_irq(irq, cp);
-	if (!IS_ERR(cp->clk)) {
-		clk_disable_unprepare(cp->clk);
-		clk_put(cp->clk);
-	}
-err_thread:
-	kthread_stop(cp->queue_th);
-err_unmap_sram:
-	iounmap(cp->sram);
-err_unmap_reg:
-	iounmap(cp->reg);
-err:
-	kfree(cp);
-	cpg =3D NULL;
-	return ret;
-}
-
-static int mv_remove(struct platform_device *pdev)
-{
-	struct crypto_priv *cp =3D platform_get_drvdata(pdev);
-
-	crypto_unregister_alg(&mv_aes_alg_ecb);
-	crypto_unregister_alg(&mv_aes_alg_cbc);
-	if (cp->has_sha1)
-		crypto_unregister_ahash(&mv_sha1_alg);
-	if (cp->has_hmac_sha1)
-		crypto_unregister_ahash(&mv_hmac_sha1_alg);
-	kthread_stop(cp->queue_th);
-	free_irq(cp->irq, cp);
-	memset(cp->sram, 0, cp->sram_size);
-	iounmap(cp->sram);
-	iounmap(cp->reg);
-
-	if (!IS_ERR(cp->clk)) {
-		clk_disable_unprepare(cp->clk);
-		clk_put(cp->clk);
-	}
-
-	kfree(cp);
-	cpg =3D NULL;
-	return 0;
-}
-
-static const struct of_device_id mv_cesa_of_match_table[] =3D {
-	{ .compatible =3D "marvell,orion-crypto", },
-	{}
-};
-MODULE_DEVICE_TABLE(of, mv_cesa_of_match_table);
-
-static struct platform_driver marvell_crypto =3D {
-	.probe		=3D mv_probe,
-	.remove		=3D mv_remove,
-	.driver		=3D {
-		.name	=3D "mv_crypto",
-		.of_match_table =3D mv_cesa_of_match_table,
-	},
-};
-MODULE_ALIAS("platform:mv_crypto");
-
-module_platform_driver(marvell_crypto);
-
-MODULE_AUTHOR("Sebastian Andrzej Siewior <sebastian@breakpoint.cc>");
-MODULE_DESCRIPTION("Support for Marvell's cryptographic engine");
-MODULE_LICENSE("GPL");
diff --git a/drivers/crypto/mv_cesa.h b/drivers/crypto/mv_cesa.h
deleted file mode 100644
index 9249d3e..0000000
--- a/drivers/crypto/mv_cesa.h
+++ /dev/null
@@ -1,150 +0,0 @@
-#ifndef __MV_CRYPTO_H__
-#define __MV_CRYPTO_H__
-
-#define DIGEST_INITIAL_VAL_A	0xdd00
-#define DIGEST_INITIAL_VAL_B	0xdd04
-#define DIGEST_INITIAL_VAL_C	0xdd08
-#define DIGEST_INITIAL_VAL_D	0xdd0c
-#define DIGEST_INITIAL_VAL_E	0xdd10
-#define DES_CMD_REG		0xdd58
-
-#define SEC_ACCEL_CMD		0xde00
-#define SEC_CMD_EN_SEC_ACCL0	(1 << 0)
-#define SEC_CMD_EN_SEC_ACCL1	(1 << 1)
-#define SEC_CMD_DISABLE_SEC	(1 << 2)
-
-#define SEC_ACCEL_DESC_P0	0xde04
-#define SEC_DESC_P0_PTR(x)	(x)
-
-#define SEC_ACCEL_DESC_P1	0xde14
-#define SEC_DESC_P1_PTR(x)	(x)
-
-#define SEC_ACCEL_CFG		0xde08
-#define SEC_CFG_STOP_DIG_ERR	(1 << 0)
-#define SEC_CFG_CH0_W_IDMA	(1 << 7)
-#define SEC_CFG_CH1_W_IDMA	(1 << 8)
-#define SEC_CFG_ACT_CH0_IDMA	(1 << 9)
-#define SEC_CFG_ACT_CH1_IDMA	(1 << 10)
-
-#define SEC_ACCEL_STATUS	0xde0c
-#define SEC_ST_ACT_0		(1 << 0)
-#define SEC_ST_ACT_1		(1 << 1)
-
-/*
- * FPGA_INT_STATUS looks like a FPGA leftover and is documented only i=
n Errata
- * 4.12. It looks like that it was part of an IRQ-controller in FPGA a=
nd
- * someone forgot to remove  it while switching to the core and moving=
 to
- * SEC_ACCEL_INT_STATUS.
- */
-#define FPGA_INT_STATUS		0xdd68
-#define SEC_ACCEL_INT_STATUS	0xde20
-#define SEC_INT_AUTH_DONE	(1 << 0)
-#define SEC_INT_DES_E_DONE	(1 << 1)
-#define SEC_INT_AES_E_DONE	(1 << 2)
-#define SEC_INT_AES_D_DONE	(1 << 3)
-#define SEC_INT_ENC_DONE	(1 << 4)
-#define SEC_INT_ACCEL0_DONE	(1 << 5)
-#define SEC_INT_ACCEL1_DONE	(1 << 6)
-#define SEC_INT_ACC0_IDMA_DONE	(1 << 7)
-#define SEC_INT_ACC1_IDMA_DONE	(1 << 8)
-
-#define SEC_ACCEL_INT_MASK	0xde24
-
-#define AES_KEY_LEN	(8 * 4)
-
-struct sec_accel_config {
-
-	u32 config;
-#define CFG_OP_MAC_ONLY		0
-#define CFG_OP_CRYPT_ONLY	1
-#define CFG_OP_MAC_CRYPT	2
-#define CFG_OP_CRYPT_MAC	3
-#define CFG_MACM_MD5		(4 << 4)
-#define CFG_MACM_SHA1		(5 << 4)
-#define CFG_MACM_HMAC_MD5	(6 << 4)
-#define CFG_MACM_HMAC_SHA1	(7 << 4)
-#define CFG_ENCM_DES		(1 << 8)
-#define CFG_ENCM_3DES		(2 << 8)
-#define CFG_ENCM_AES		(3 << 8)
-#define CFG_DIR_ENC		(0 << 12)
-#define CFG_DIR_DEC		(1 << 12)
-#define CFG_ENC_MODE_ECB	(0 << 16)
-#define CFG_ENC_MODE_CBC	(1 << 16)
-#define CFG_3DES_EEE		(0 << 20)
-#define CFG_3DES_EDE		(1 << 20)
-#define CFG_AES_LEN_128		(0 << 24)
-#define CFG_AES_LEN_192		(1 << 24)
-#define CFG_AES_LEN_256		(2 << 24)
-#define CFG_NOT_FRAG		(0 << 30)
-#define CFG_FIRST_FRAG		(1 << 30)
-#define CFG_LAST_FRAG		(2 << 30)
-#define CFG_MID_FRAG		(3 << 30)
-
-	u32 enc_p;
-#define ENC_P_SRC(x)		(x)
-#define ENC_P_DST(x)		((x) << 16)
-
-	u32 enc_len;
-#define ENC_LEN(x)		(x)
-
-	u32 enc_key_p;
-#define ENC_KEY_P(x)		(x)
-
-	u32 enc_iv;
-#define ENC_IV_POINT(x)		((x) << 0)
-#define ENC_IV_BUF_POINT(x)	((x) << 16)
-
-	u32 mac_src_p;
-#define MAC_SRC_DATA_P(x)	(x)
-#define MAC_SRC_TOTAL_LEN(x)	((x) << 16)
-
-	u32 mac_digest;
-#define MAC_DIGEST_P(x)	(x)
-#define MAC_FRAG_LEN(x)	((x) << 16)
-	u32 mac_iv;
-#define MAC_INNER_IV_P(x)	(x)
-#define MAC_OUTER_IV_P(x)	((x) << 16)
-}__attribute__ ((packed));
-	/*
-	 * /-----------\ 0
-	 * | ACCEL CFG |	4 * 8
-	 * |-----------| 0x20
-	 * | CRYPT KEY |	8 * 4
-	 * |-----------| 0x40
-	 * |  IV   IN  |	4 * 4
-	 * |-----------| 0x40 (inplace)
-	 * |  IV BUF   |	4 * 4
-	 * |-----------| 0x80
-	 * |  DATA IN  |	16 * x (max ->max_req_size)
-	 * |-----------| 0x80 (inplace operation)
-	 * |  DATA OUT |	16 * x (max ->max_req_size)
-	 * \-----------/ SRAM size
-	 */
-
-	/* Hashing memory map:
-	 * /-----------\ 0
-	 * | ACCEL CFG |        4 * 8
-	 * |-----------| 0x20
-	 * | Inner IV  |        5 * 4
-	 * |-----------| 0x34
-	 * | Outer IV  |        5 * 4
-	 * |-----------| 0x48
-	 * | Output BUF|        5 * 4
-	 * |-----------| 0x80
-	 * |  DATA IN  |        64 * x (max ->max_req_size)
-	 * \-----------/ SRAM size
-	 */
-#define SRAM_CONFIG		0x00
-#define SRAM_DATA_KEY_P		0x20
-#define SRAM_DATA_IV		0x40
-#define SRAM_DATA_IV_BUF	0x40
-#define SRAM_DATA_IN_START	0x80
-#define SRAM_DATA_OUT_START	0x80
-
-#define SRAM_HMAC_IV_IN		0x20
-#define SRAM_HMAC_IV_OUT	0x34
-#define SRAM_DIGEST_BUF		0x48
-
-#define SRAM_CFG_SPACE		0x80
-
-#endif
--=20
1.9.1
