From: Rameshwar Prasad Sahu <rsahu-qTEPVZfXA3Y@public.gmane.org>
Subject: [PATCH v2 3/3] Crypto: Add support for APM X-Gene SoC CRC32C h/w accelerator driver
Date: Sat,  7 Nov 2015 22:07:06 +0530
Message-ID: <1446914226-23402-4-git-send-email-rsahu@apm.com>
References: <1446914226-23402-1-git-send-email-rsahu@apm.com>
Cc: linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dmaengine-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	arnd-r2nGTMty4D4@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
	jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kgondkar-qTEPVZfXA3Y@public.gmane.org, patches-qTEPVZfXA3Y@public.gmane.org,
	Rameshwar Prasad Sahu <rsahu-qTEPVZfXA3Y@public.gmane.org>
To: vinod.koul-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org,
	herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1446914226-23402-1-git-send-email-rsahu-qTEPVZfXA3Y@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

This patch implements support for APM X-Gene SoC CRC32C h/w accelerator.
DMA engine in APM X-Gene SoC is capable of doing CRC32C computations.

Signed-off-by: Rameshwar Prasad Sahu <rsahu-qTEPVZfXA3Y@public.gmane.org>
---
 drivers/crypto/Kconfig        |    8 ++
 drivers/crypto/Makefile       |    1 +
 drivers/crypto/xgene-crc32c.c |  234 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 243 insertions(+), 0 deletions(-)
 create mode 100755 drivers/crypto/xgene-crc32c.c

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index d234719..5d90b64 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -497,4 +497,12 @@ config CRYPTO_DEV_SUN4I_SS
 	  To compile this driver as a module, choose M here: the module
 	  will be called sun4i-ss.

+config CRYPTO_DEV_XGENE_CRC32C
+	tristate "Support for APM SoC X-Gene CRC32C HW accelerator"
+	depends on XGENE_DMA
+	select CRYPTO_HASH
+	help
+	  This option enables support for CRC32C offload by using
+	  APM X-Gene SoC DMA engine.
+
 endif # CRYPTO_HW
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index c3ced6f..199d4e4 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -29,3 +29,4 @@ obj-$(CONFIG_CRYPTO_DEV_QAT) += qat/
 obj-$(CONFIG_CRYPTO_DEV_QCE) += qce/
 obj-$(CONFIG_CRYPTO_DEV_VMX) += vmx/
 obj-$(CONFIG_CRYPTO_DEV_SUN4I_SS) += sunxi-ss/
+obj-$(CONFIG_CRYPTO_DEV_XGENE_CRC32C) += xgene-crc32c.o
diff --git a/drivers/crypto/xgene-crc32c.c b/drivers/crypto/xgene-crc32c.c
new file mode 100755
index 0000000..142c681
--- /dev/null
+++ b/drivers/crypto/xgene-crc32c.c
@@ -0,0 +1,234 @@
+/*
+ * Applied Micro X-Gene SoC CRC32C HW acceleration by using DMA engine
+ *
+ * Copyright (c) 2015, Applied Micro Circuits Corporation
+ * Authors: Rameshwar Prasad Sahu <rsahu-qTEPVZfXA3Y@public.gmane.org>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/dmaengine.h>
+#include <linux/init.h>
+#include <crypto/internal/hash.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/string.h>
+
+#define CRC32C_DIGEST_SIZE		4
+#define CRC32C_BLOCK_SIZE		1
+#define XGENE_DMA_MAX_FLYBY_SRC_CNT	5
+#define XGENE_DMA_MAX_FLYBY_BYTE_CNT	0x7FFF	/* (32 KB - 1) */
+
+struct xgene_crc32c_session_ctx {
+	struct dma_chan *dchan;
+	u32 key;
+};
+
+struct xgene_crc32c_reqctx {
+	struct device *dev;
+	u32 nents;
+	u32 seed;
+};
+
+static void xgene_crc32c_callback(void *ctx)
+{
+	struct ahash_request *req = ctx;
+	struct xgene_crc32c_reqctx *reqctx = ahash_request_ctx(req);
+
+	if (req->base.complete)
+		req->base.complete(&req->base, 0);
+
+	dma_unmap_sg(reqctx->dev, req->src,
+		     reqctx->nents, DMA_TO_DEVICE);
+}
+
+static int xgene_crc32c_handle_req(struct ahash_request *req,
+				   struct dma_chan *dchan)
+{
+	struct xgene_crc32c_reqctx *reqctx = ahash_request_ctx(req);
+	struct device *dev = dchan->device->dev;
+	struct dma_async_tx_descriptor *tx;
+	enum dma_ctrl_flags flags;
+	u32 nents, sg_count;
+	dma_cookie_t cookie;
+
+	if (req->nbytes > XGENE_DMA_MAX_FLYBY_BYTE_CNT) {
+		dev_err(dev, "Src len is too long %u\n", req->nbytes);
+		return -EINVAL;
+	}
+
+	nents = sg_nents(req->src);
+	sg_count = dma_map_sg(dev, req->src, nents, DMA_TO_DEVICE);
+	if (!sg_count) {
+		dev_err(dev, "Failed to map src sg");
+		return -EIO;
+	}
+
+	if (sg_count > XGENE_DMA_MAX_FLYBY_SRC_CNT) {
+		dev_err(dev, "Unsupported src sg count %d\n", sg_count);
+		goto err;
+	}
+
+	flags = DMA_CTRL_ACK;
+
+	tx = dmaengine_prep_dma_crc3c(dchan, req->src, req->nbytes,
+				      reqctx->seed, req->result, flags);
+	if (!tx)
+		goto err;
+
+	/* Set callback parameters */
+	reqctx->dev = dev;
+	reqctx->nents = nents;
+	tx->callback_param = req;
+	tx->callback = xgene_crc32c_callback;
+
+	cookie = tx->tx_submit(tx);
+	if (dma_submit_error(cookie)) {
+		dev_err(dev, "Failed to submit descriptor\n");
+		goto err;
+	}
+
+	dma_async_issue_pending(dchan);
+
+	return -EINPROGRESS;
+
+err:
+	dma_unmap_sg(dev, req->src, nents, DMA_TO_DEVICE);
+	return -EINVAL;
+}
+
+static int xgene_crc32c_init(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct xgene_crc32c_session_ctx *session = crypto_ahash_ctx(tfm);
+
+	*(__le32 *)req->result = cpu_to_le32(session->key);
+
+	return 0;
+}
+
+static int xgene_crc32c_update(struct ahash_request *req)
+{
+	struct xgene_crc32c_reqctx *reqctx = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct xgene_crc32c_session_ctx *session = crypto_ahash_ctx(tfm);
+
+	reqctx->seed = le32_to_cpu(*(__le32 *)req->result);
+
+	return xgene_crc32c_handle_req(req, session->dchan);
+}
+
+static int xgene_crc32c_final(struct ahash_request *req)
+{
+	return 0;
+}
+
+static int xgene_crc32c_finup(struct ahash_request *req)
+{
+	struct xgene_crc32c_reqctx *reqctx = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct xgene_crc32c_session_ctx *session = crypto_ahash_ctx(tfm);
+
+	reqctx->seed = le32_to_cpu(*(__le32 *)req->result);
+
+	return xgene_crc32c_handle_req(req, session->dchan);
+}
+
+static int xgene_crc32c_digest(struct ahash_request *req)
+{
+	struct xgene_crc32c_reqctx *reqctx = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct xgene_crc32c_session_ctx *session = crypto_ahash_ctx(tfm);
+
+	reqctx->seed = session->key;
+
+	return xgene_crc32c_handle_req(req, session->dchan);
+}
+
+static int xgene_crc32c_setkey(struct crypto_ahash *tfm, const u8 *key,
+			       unsigned int keylen)
+{
+	struct xgene_crc32c_session_ctx *session = crypto_ahash_ctx(tfm);
+
+	if (keylen != CRC32C_DIGEST_SIZE) {
+		crypto_ahash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+
+	session->key = le32_to_cpu(*(__le32 *)key);
+
+	return 0;
+}
+
+static int xgene_crc32c_cra_init(struct crypto_tfm *tfm)
+{
+	struct xgene_crc32c_session_ctx *session = crypto_tfm_ctx(tfm);
+	dma_cap_mask_t mask;
+
+	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
+				 sizeof(struct xgene_crc32c_reqctx));
+	session->key = ~0;
+
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_CRC32C, mask);
+
+	session->dchan = dma_request_channel(mask, NULL, NULL);
+	if (!session->dchan) {
+		pr_err("Failed to request CRC32C DMA channel\n");
+		return -ENXIO;
+	}
+
+	return 0;
+}
+
+static struct ahash_alg xgene_crc32c_alg = {
+	.init		= xgene_crc32c_init,
+	.update		= xgene_crc32c_update,
+	.final		= xgene_crc32c_final,
+	.finup		= xgene_crc32c_finup,
+	.digest		= xgene_crc32c_digest,
+	.setkey		= xgene_crc32c_setkey,
+	.halg.digestsize = CRC32C_DIGEST_SIZE,
+	.halg.base	= {
+		.cra_name		= "crc32c",
+		.cra_driver_name	= "crc32c-xgene",
+		.cra_flags		= (CRYPTO_ALG_TYPE_AHASH |
+					   CRYPTO_ALG_ASYNC),
+		.cra_blocksize		= CRC32C_BLOCK_SIZE,
+		.cra_ctxsize		= sizeof(
+					  struct xgene_crc32c_session_ctx),
+		.cra_init		= xgene_crc32c_cra_init,
+		.cra_module		= THIS_MODULE,
+	},
+};
+
+static int __init xgene_crc32c_mod_init(void)
+{
+	return crypto_register_ahash(&xgene_crc32c_alg);
+}
+late_initcall(xgene_crc32c_mod_init);
+
+static void __exit xgene_crc32c_mod_exit(void)
+{
+	crypto_unregister_ahash(&xgene_crc32c_alg);
+}
+module_exit(xgene_crc32c_mod_exit);
+
+MODULE_DESCRIPTION("APM X-Gene SoC CRC32C HW accelerator driver");
+MODULE_AUTHOR("Rameshwar Prasad Sahu <rsahu-qTEPVZfXA3Y@public.gmane.org>");
+MODULE_LICENSE("GPL");
+MODULE_VERSION("1.0");
+MODULE_ALIAS_CRYPTO("crc32c");
+MODULE_ALIAS_CRYPTO("crc32c-xgene");
--
1.7.1
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
