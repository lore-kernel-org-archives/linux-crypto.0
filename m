From: "Mark A. Greer" <mgreer@animalcreek.com>
Subject: [PATCH 7/7] crypto: omap-aes: Remove usage of private DMA API
Date: Mon, 19 Nov 2012 12:03:52 -0700
Message-ID: <1353351832-6685-8-git-send-email-mgreer@animalcreek.com>
References: <1353351832-6685-1-git-send-email-mgreer@animalcreek.com>
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, dmitry.kasatkin@intel.com,
	rmk+kernel@arm.linux.org.uk, paul@pwsan.com,
	khilman@deeprootsystems.com,
	"Mark A. Greer" <mgreer@animalcreek.com>
To: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Return-path: <linux-omap-owner@vger.kernel.org>
In-Reply-To: <1353351832-6685-1-git-send-email-mgreer@animalcreek.com>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: "Mark A. Greer" <mgreer@animalcreek.com>

Remove usage of the private OMAP DMA API.
The dmaengine API will be used instead.

CC: Russell King <rmk+kernel@arm.linux.org.uk>
CC: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Signed-off-by: Mark A. Greer <mgreer@animalcreek.com>
---
 drivers/crypto/omap-aes.c | 140 ----------------------------------------------
 1 file changed, 140 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index c0a84b2..1fbfd2e 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -12,8 +12,6 @@
  *
  */
 
-#define OMAP_AES_DMA_PRIVATE
-
 #define pr_fmt(fmt) "%s: " fmt, __func__
 
 #include <linux/err.h>
@@ -24,10 +22,8 @@
 #include <linux/platform_device.h>
 #include <linux/scatterlist.h>
 #include <linux/dma-mapping.h>
-#ifndef OMAP_AES_DMA_PRIVATE
 #include <linux/dmaengine.h>
 #include <linux/omap-dma.h>
-#endif
 #include <linux/pm_runtime.h>
 #include <linux/io.h>
 #include <linux/crypto.h>
@@ -35,11 +31,6 @@
 #include <crypto/scatterwalk.h>
 #include <crypto/aes.h>
 
-#ifdef OMAP_AES_DMA_PRIVATE
-#include <plat/cpu.h>
-#include <plat/dma.h>
-#endif
-
 #define DST_MAXBURST			4 /* Really element number (en) */
 
 /* OMAP TRM gives bitfields as start:end, where start is the higher bit
@@ -121,33 +112,21 @@ struct omap_aes_dev {
 	struct ablkcipher_request	*req;
 	size_t				total;
 	struct scatterlist		*in_sg;
-#ifndef OMAP_AES_DMA_PRIVATE
 	struct scatterlist		in_sgl;
-#endif
 	size_t				in_offset;
 	struct scatterlist		*out_sg;
-#ifndef OMAP_AES_DMA_PRIVATE
 	struct scatterlist		out_sgl;
-#endif
 	size_t				out_offset;
 
 	size_t			buflen;
 	void			*buf_in;
 	size_t			dma_size;
 	int			dma_in;
-#ifdef OMAP_AES_DMA_PRIVATE
-	int			dma_lch_in;
-#else
 	struct dma_chan		*dma_lch_in;
-#endif
 	dma_addr_t		dma_addr_in;
 	void			*buf_out;
 	int			dma_out;
-#ifdef OMAP_AES_DMA_PRIVATE
-	int			dma_lch_out;
-#else
 	struct dma_chan		*dma_lch_out;
-#endif
 	dma_addr_t		dma_addr_out;
 };
 
@@ -239,17 +218,10 @@ static int omap_aes_write_ctrl(struct omap_aes_dev *dd)
 		return err;
 
 	val = 0;
-#ifdef OMAP_AES_DMA_PRIVATE
-	if (dd->dma_lch_out >= 0)
-		val |= AES_REG_MASK_DMA_OUT_EN;
-	if (dd->dma_lch_in >= 0)
-		val |= AES_REG_MASK_DMA_IN_EN;
-#else
 	if (dd->dma_lch_out != NULL)
 		val |= AES_REG_MASK_DMA_OUT_EN;
 	if (dd->dma_lch_in != NULL)
 		val |= AES_REG_MASK_DMA_IN_EN;
-#endif
 
 	mask = AES_REG_MASK_DMA_IN_EN | AES_REG_MASK_DMA_OUT_EN;
 
@@ -277,22 +249,6 @@ static int omap_aes_write_ctrl(struct omap_aes_dev *dd)
 
 	omap_aes_write_mask(dd, AES_REG_CTRL, val, mask);
 
-#ifdef OMAP_AES_DMA_PRIVATE
-	/* IN */
-	omap_set_dma_dest_params(dd->dma_lch_in, 0, OMAP_DMA_AMODE_CONSTANT,
-				 dd->phys_base + AES_REG_DATA, 0, 4);
-
-	omap_set_dma_dest_burst_mode(dd->dma_lch_in, OMAP_DMA_DATA_BURST_4);
-	omap_set_dma_src_burst_mode(dd->dma_lch_in, OMAP_DMA_DATA_BURST_4);
-
-	/* OUT */
-	omap_set_dma_src_params(dd->dma_lch_out, 0, OMAP_DMA_AMODE_CONSTANT,
-				dd->phys_base + AES_REG_DATA, 0, 4);
-
-	omap_set_dma_src_burst_mode(dd->dma_lch_out, OMAP_DMA_DATA_BURST_4);
-	omap_set_dma_dest_burst_mode(dd->dma_lch_out, OMAP_DMA_DATA_BURST_4);
-#endif
-
 	return 0;
 }
 
@@ -317,23 +273,6 @@ static struct omap_aes_dev *omap_aes_find_dev(struct omap_aes_ctx *ctx)
 	return dd;
 }
 
-#ifdef OMAP_AES_DMA_PRIVATE
-static void omap_aes_dma_callback(int lch, u16 ch_status, void *data)
-{
-	struct omap_aes_dev *dd = data;
-
-	if (ch_status != OMAP_DMA_BLOCK_IRQ) {
-		pr_err("omap-aes DMA error status: 0x%hx\n", ch_status);
-		dd->err = -EIO;
-		dd->flags &= ~FLAGS_INIT; /* request to re-initialize */
-	} else if (lch == dd->dma_lch_in) {
-		return;
-	}
-
-	/* dma_lch_out - completed */
-	tasklet_schedule(&dd->done_task);
-}
-#else
 static void omap_aes_dma_out_callback(void *data)
 {
 	struct omap_aes_dev *dd = data;
@@ -341,22 +280,14 @@ static void omap_aes_dma_out_callback(void *data)
 	/* dma_lch_out - completed */
 	tasklet_schedule(&dd->done_task);
 }
-#endif
 
 static int omap_aes_dma_init(struct omap_aes_dev *dd)
 {
 	int err = -ENOMEM;
-#ifndef OMAP_AES_DMA_PRIVATE
 	dma_cap_mask_t mask;
-#endif
 
-#ifdef OMAP_AES_DMA_PRIVATE
-	dd->dma_lch_out = -1;
-	dd->dma_lch_in = -1;
-#else
 	dd->dma_lch_out = NULL;
 	dd->dma_lch_in = NULL;
-#endif
 
 	dd->buf_in = (void *)__get_free_pages(GFP_KERNEL, OMAP_AES_CACHE_SIZE);
 	dd->buf_out = (void *)__get_free_pages(GFP_KERNEL, OMAP_AES_CACHE_SIZE);
@@ -385,20 +316,6 @@ static int omap_aes_dma_init(struct omap_aes_dev *dd)
 		goto err_map_out;
 	}
 
-#ifdef OMAP_AES_DMA_PRIVATE
-	err = omap_request_dma(dd->dma_in, "omap-aes-rx",
-			       omap_aes_dma_callback, dd, &dd->dma_lch_in);
-	if (err) {
-		dev_err(dd->dev, "Unable to request DMA channel\n");
-		goto err_dma_in;
-	}
-	err = omap_request_dma(dd->dma_out, "omap-aes-tx",
-			       omap_aes_dma_callback, dd, &dd->dma_lch_out);
-	if (err) {
-		dev_err(dd->dev, "Unable to request DMA channel\n");
-		goto err_dma_out;
-	}
-#else
 	dma_cap_zero(mask);
 	dma_cap_set(DMA_SLAVE, mask);
 
@@ -415,16 +332,11 @@ static int omap_aes_dma_init(struct omap_aes_dev *dd)
 		dev_err(dd->dev, "Unable to request out DMA channel\n");
 		goto err_dma_out;
 	}
-#endif
 
 	return 0;
 
 err_dma_out:
-#ifdef OMAP_AES_DMA_PRIVATE
-	omap_free_dma(dd->dma_lch_in);
-#else
 	dma_release_channel(dd->dma_lch_in);
-#endif
 err_dma_in:
 	dma_unmap_single(dd->dev, dd->dma_addr_out, dd->buflen,
 			 DMA_FROM_DEVICE);
@@ -441,13 +353,8 @@ err_alloc:
 
 static void omap_aes_dma_cleanup(struct omap_aes_dev *dd)
 {
-#ifdef OMAP_AES_DMA_PRIVATE
-	omap_free_dma(dd->dma_lch_out);
-	omap_free_dma(dd->dma_lch_in);
-#else
 	dma_release_channel(dd->dma_lch_out);
 	dma_release_channel(dd->dma_lch_in);
-#endif
 	dma_unmap_single(dd->dev, dd->dma_addr_out, dd->buflen,
 			 DMA_FROM_DEVICE);
 	dma_unmap_single(dd->dev, dd->dma_addr_in, dd->buflen, DMA_TO_DEVICE);
@@ -505,24 +412,15 @@ static int sg_copy(struct scatterlist **sg, size_t *offset, void *buf,
 	return off;
 }
 
-#ifdef OMAP_AES_DMA_PRIVATE
-static int omap_aes_crypt_dma(struct crypto_tfm *tfm, dma_addr_t dma_addr_in,
-			       dma_addr_t dma_addr_out, int length)
-#else
 static int omap_aes_crypt_dma(struct crypto_tfm *tfm,
 		struct scatterlist *in_sg, struct scatterlist *out_sg)
-#endif
 {
 	struct omap_aes_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct omap_aes_dev *dd = ctx->dd;
-#ifdef OMAP_AES_DMA_PRIVATE
-	int len32;
-#else
 	struct dma_async_tx_descriptor *tx_in, *tx_out;
 	struct dma_slave_config cfg;
 	dma_addr_t dma_addr_in = sg_dma_address(in_sg);
 	int ret, length = sg_dma_len(in_sg);
-#endif
 
 	pr_debug("len: %d\n", length);
 
@@ -532,28 +430,6 @@ static int omap_aes_crypt_dma(struct crypto_tfm *tfm,
 		dma_sync_single_for_device(dd->dev, dma_addr_in, length,
 					   DMA_TO_DEVICE);
 
-#ifdef OMAP_AES_DMA_PRIVATE
-	len32 = DIV_ROUND_UP(length, sizeof(u32));
-
-	/* IN */
-	omap_set_dma_transfer_params(dd->dma_lch_in, OMAP_DMA_DATA_TYPE_S32,
-				     len32, 1, OMAP_DMA_SYNC_PACKET, dd->dma_in,
-					OMAP_DMA_DST_SYNC);
-
-	omap_set_dma_src_params(dd->dma_lch_in, 0, OMAP_DMA_AMODE_POST_INC,
-				dma_addr_in, 0, 0);
-
-	/* OUT */
-	omap_set_dma_transfer_params(dd->dma_lch_out, OMAP_DMA_DATA_TYPE_S32,
-				     len32, 1, OMAP_DMA_SYNC_PACKET,
-					dd->dma_out, OMAP_DMA_SRC_SYNC);
-
-	omap_set_dma_dest_params(dd->dma_lch_out, 0, OMAP_DMA_AMODE_POST_INC,
-				 dma_addr_out, 0, 0);
-
-	omap_start_dma(dd->dma_lch_in);
-	omap_start_dma(dd->dma_lch_out);
-#else
 	memset(&cfg, 0, sizeof(cfg));
 
 	cfg.src_addr = dd->phys_base + AES_REG_DATA;
@@ -608,7 +484,6 @@ static int omap_aes_crypt_dma(struct crypto_tfm *tfm,
 
 	dma_async_issue_pending(dd->dma_lch_in);
 	dma_async_issue_pending(dd->dma_lch_out);
-#endif
 
 	/* start DMA or disable idle mode */
 	omap_aes_write_mask(dd, AES_REG_MASK, AES_REG_MASK_START,
@@ -624,9 +499,7 @@ static int omap_aes_crypt_dma_start(struct omap_aes_dev *dd)
 	int err, fast = 0, in, out;
 	size_t count;
 	dma_addr_t addr_in, addr_out;
-#ifndef OMAP_AES_DMA_PRIVATE
 	struct scatterlist *in_sg, *out_sg;
-#endif
 
 	pr_debug("total: %d\n", dd->total);
 
@@ -665,10 +538,8 @@ static int omap_aes_crypt_dma_start(struct omap_aes_dev *dd)
 		addr_in = sg_dma_address(dd->in_sg);
 		addr_out = sg_dma_address(dd->out_sg);
 
-#ifndef OMAP_AES_DMA_PRIVATE
 		in_sg = dd->in_sg;
 		out_sg = dd->out_sg;
-#endif
 
 		dd->flags |= FLAGS_FAST;
 
@@ -677,7 +548,6 @@ static int omap_aes_crypt_dma_start(struct omap_aes_dev *dd)
 		count = sg_copy(&dd->in_sg, &dd->in_offset, dd->buf_in,
 				 dd->buflen, dd->total, 0);
 
-#ifndef OMAP_AES_DMA_PRIVATE
 		/*
 		 * The data going into the AES module has been copied
 		 * to a local buffer and the data coming out will go
@@ -696,7 +566,6 @@ static int omap_aes_crypt_dma_start(struct omap_aes_dev *dd)
 
 		in_sg = &dd->in_sgl;
 		out_sg = &dd->out_sgl;
-#endif
 
 		addr_in = dd->dma_addr_in;
 		addr_out = dd->dma_addr_out;
@@ -707,11 +576,7 @@ static int omap_aes_crypt_dma_start(struct omap_aes_dev *dd)
 
 	dd->total -= count;
 
-#ifdef OMAP_AES_DMA_PRIVATE
-	err = omap_aes_crypt_dma(tfm, addr_in, addr_out, count);
-#else
 	err = omap_aes_crypt_dma(tfm, in_sg, out_sg);
-#endif
 	if (err) {
 		dma_unmap_sg(dd->dev, dd->in_sg, 1, DMA_TO_DEVICE);
 		dma_unmap_sg(dd->dev, dd->out_sg, 1, DMA_TO_DEVICE);
@@ -741,13 +606,8 @@ static int omap_aes_crypt_dma_stop(struct omap_aes_dev *dd)
 
 	omap_aes_write_mask(dd, AES_REG_MASK, 0, AES_REG_MASK_START);
 
-#ifdef OMAP_AES_DMA_PRIVATE
-	omap_stop_dma(dd->dma_lch_in);
-	omap_stop_dma(dd->dma_lch_out);
-#else
 	dmaengine_terminate_all(dd->dma_lch_in);
 	dmaengine_terminate_all(dd->dma_lch_out);
-#endif
 
 	if (dd->flags & FLAGS_FAST) {
 		dma_unmap_sg(dd->dev, dd->out_sg, 1, DMA_FROM_DEVICE);
-- 
1.7.12

