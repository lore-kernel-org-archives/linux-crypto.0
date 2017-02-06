From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 2/2] crypto: atmel - fix 64-bit build warnings
Date: Mon,  6 Feb 2017 13:32:16 +0100
Message-ID: <20170206123240.1698839-2-arnd@arndb.de>
References: <20170206123240.1698839-1-arnd@arndb.de>
Cc: Cyrille Pitchen <cyrille.pitchen@atmel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:51915 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751468AbdBFMdX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Feb 2017 07:33:23 -0500
In-Reply-To: <20170206123240.1698839-1-arnd@arndb.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When we enable COMPILE_TEST building for the Atmel sha and tdes implementations,
we run into a couple of warnings about incorrect format strings, e.g.

In file included from include/linux/platform_device.h:14:0,
                 from drivers/crypto/atmel-sha.c:24:
drivers/crypto/atmel-sha.c: In function 'atmel_sha_xmit_cpu':
drivers/crypto/atmel-sha.c:571:19: error: format '%d' expects argument of type 'int', but argument 6 has type 'size_t {aka long unsigned int}' [-Werror=format=]
In file included from include/linux/printk.h:6:0,
                 from include/linux/kernel.h:13,
                 from drivers/crypto/atmel-tdes.c:17:
drivers/crypto/atmel-tdes.c: In function 'atmel_tdes_crypt_dma_stop':
include/linux/kern_levels.h:4:18: error: format '%u' expects argument of type 'unsigned int', but argument 2 has type 'size_t {aka long unsigned int}' [-Werror=format=]

These are all fixed by using the "%z" modifier for size_t data.

There are also a few uses of min()/max() with incompatible types:

drivers/crypto/atmel-tdes.c: In function 'atmel_tdes_crypt_start':
drivers/crypto/atmel-tdes.c:528:181: error: comparison of distinct pointer types lacks a cast [-Werror]

Where possible, we should use consistent types here, otherwise we can use
min_t()/max_t() to get well-defined behavior without a warning.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/crypto/atmel-sha.c  | 16 ++++++++--------
 drivers/crypto/atmel-tdes.c | 14 +++++++-------
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 22d0c0c118da..50a1dcd50c46 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -568,7 +568,7 @@ static int atmel_sha_xmit_cpu(struct atmel_sha_dev *dd, const u8 *buf,
 	int count, len32;
 	const u32 *buffer = (const u32 *)buf;
 
-	dev_dbg(dd->dev, "xmit_cpu: digcnt: 0x%llx 0x%llx, length: %d, final: %d\n",
+	dev_dbg(dd->dev, "xmit_cpu: digcnt: 0x%llx 0x%llx, length: %zd, final: %d\n",
 		ctx->digcnt[1], ctx->digcnt[0], length, final);
 
 	atmel_sha_write_ctrl(dd, 0);
@@ -597,7 +597,7 @@ static int atmel_sha_xmit_pdc(struct atmel_sha_dev *dd, dma_addr_t dma_addr1,
 	struct atmel_sha_reqctx *ctx = ahash_request_ctx(dd->req);
 	int len32;
 
-	dev_dbg(dd->dev, "xmit_pdc: digcnt: 0x%llx 0x%llx, length: %d, final: %d\n",
+	dev_dbg(dd->dev, "xmit_pdc: digcnt: 0x%llx 0x%llx, length: %zd, final: %d\n",
 		ctx->digcnt[1], ctx->digcnt[0], length1, final);
 
 	len32 = DIV_ROUND_UP(length1, sizeof(u32));
@@ -644,7 +644,7 @@ static int atmel_sha_xmit_dma(struct atmel_sha_dev *dd, dma_addr_t dma_addr1,
 	struct dma_async_tx_descriptor	*in_desc;
 	struct scatterlist sg[2];
 
-	dev_dbg(dd->dev, "xmit_dma: digcnt: 0x%llx 0x%llx, length: %d, final: %d\n",
+	dev_dbg(dd->dev, "xmit_dma: digcnt: 0x%llx 0x%llx, length: %zd, final: %d\n",
 		ctx->digcnt[1], ctx->digcnt[0], length1, final);
 
 	dd->dma_lch_in.dma_conf.src_maxburst = 16;
@@ -723,7 +723,7 @@ static int atmel_sha_xmit_dma_map(struct atmel_sha_dev *dd,
 	ctx->dma_addr = dma_map_single(dd->dev, ctx->buffer,
 				ctx->buflen + ctx->block_size, DMA_TO_DEVICE);
 	if (dma_mapping_error(dd->dev, ctx->dma_addr)) {
-		dev_err(dd->dev, "dma %u bytes error\n", ctx->buflen +
+		dev_err(dd->dev, "dma %zu bytes error\n", ctx->buflen +
 				ctx->block_size);
 		atmel_sha_complete(dd, -EINVAL);
 	}
@@ -744,7 +744,7 @@ static int atmel_sha_update_dma_slow(struct atmel_sha_dev *dd)
 
 	final = (ctx->flags & SHA_FLAGS_FINUP) && !ctx->total;
 
-	dev_dbg(dd->dev, "slow: bufcnt: %u, digcnt: 0x%llx 0x%llx, final: %d\n",
+	dev_dbg(dd->dev, "slow: bufcnt: %zu, digcnt: 0x%llx 0x%llx, final: %d\n",
 		 ctx->bufcnt, ctx->digcnt[1], ctx->digcnt[0], final);
 
 	if (final)
@@ -772,7 +772,7 @@ static int atmel_sha_update_dma_start(struct atmel_sha_dev *dd)
 	if (ctx->bufcnt || ctx->offset)
 		return atmel_sha_update_dma_slow(dd);
 
-	dev_dbg(dd->dev, "fast: digcnt: 0x%llx 0x%llx, bufcnt: %u, total: %u\n",
+	dev_dbg(dd->dev, "fast: digcnt: 0x%llx 0x%llx, bufcnt: %zd, total: %u\n",
 		ctx->digcnt[1], ctx->digcnt[0], ctx->bufcnt, ctx->total);
 
 	sg = ctx->sg;
@@ -814,7 +814,7 @@ static int atmel_sha_update_dma_start(struct atmel_sha_dev *dd)
 		ctx->dma_addr = dma_map_single(dd->dev, ctx->buffer,
 			ctx->buflen + ctx->block_size, DMA_TO_DEVICE);
 		if (dma_mapping_error(dd->dev, ctx->dma_addr)) {
-			dev_err(dd->dev, "dma %u bytes error\n",
+			dev_err(dd->dev, "dma %zu bytes error\n",
 				ctx->buflen + ctx->block_size);
 			atmel_sha_complete(dd, -EINVAL);
 		}
@@ -994,7 +994,7 @@ static int atmel_sha_finish(struct ahash_request *req)
 	if (ctx->digcnt[0] || ctx->digcnt[1])
 		atmel_sha_copy_ready_hash(req);
 
-	dev_dbg(dd->dev, "digcnt: 0x%llx 0x%llx, bufcnt: %d\n", ctx->digcnt[1],
+	dev_dbg(dd->dev, "digcnt: 0x%llx 0x%llx, bufcnt: %zd\n", ctx->digcnt[1],
 		ctx->digcnt[0], ctx->bufcnt);
 
 	return 0;
diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index bf467d7be35c..b25f1b3c981f 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -150,7 +150,7 @@ static struct atmel_tdes_drv atmel_tdes = {
 static int atmel_tdes_sg_copy(struct scatterlist **sg, size_t *offset,
 			void *buf, size_t buflen, size_t total, int out)
 {
-	unsigned int count, off = 0;
+	size_t count, off = 0;
 
 	while (buflen && total) {
 		count = min((*sg)->length - *offset, total);
@@ -336,7 +336,7 @@ static int atmel_tdes_crypt_pdc_stop(struct atmel_tdes_dev *dd)
 				dd->buf_out, dd->buflen, dd->dma_size, 1);
 		if (count != dd->dma_size) {
 			err = -EINVAL;
-			pr_err("not all data converted: %u\n", count);
+			pr_err("not all data converted: %zu\n", count);
 		}
 	}
 
@@ -361,7 +361,7 @@ static int atmel_tdes_buff_init(struct atmel_tdes_dev *dd)
 	dd->dma_addr_in = dma_map_single(dd->dev, dd->buf_in,
 					dd->buflen, DMA_TO_DEVICE);
 	if (dma_mapping_error(dd->dev, dd->dma_addr_in)) {
-		dev_err(dd->dev, "dma %d bytes error\n", dd->buflen);
+		dev_err(dd->dev, "dma %zd bytes error\n", dd->buflen);
 		err = -EINVAL;
 		goto err_map_in;
 	}
@@ -369,7 +369,7 @@ static int atmel_tdes_buff_init(struct atmel_tdes_dev *dd)
 	dd->dma_addr_out = dma_map_single(dd->dev, dd->buf_out,
 					dd->buflen, DMA_FROM_DEVICE);
 	if (dma_mapping_error(dd->dev, dd->dma_addr_out)) {
-		dev_err(dd->dev, "dma %d bytes error\n", dd->buflen);
+		dev_err(dd->dev, "dma %zd bytes error\n", dd->buflen);
 		err = -EINVAL;
 		goto err_map_out;
 	}
@@ -525,8 +525,8 @@ static int atmel_tdes_crypt_start(struct atmel_tdes_dev *dd)
 
 
 	if (fast)  {
-		count = min(dd->total, sg_dma_len(dd->in_sg));
-		count = min(count, sg_dma_len(dd->out_sg));
+		count = min_t(size_t, dd->total, sg_dma_len(dd->in_sg));
+		count = min_t(size_t, count, sg_dma_len(dd->out_sg));
 
 		err = dma_map_sg(dd->dev, dd->in_sg, 1, DMA_TO_DEVICE);
 		if (!err) {
@@ -661,7 +661,7 @@ static int atmel_tdes_crypt_dma_stop(struct atmel_tdes_dev *dd)
 				dd->buf_out, dd->buflen, dd->dma_size, 1);
 			if (count != dd->dma_size) {
 				err = -EINVAL;
-				pr_err("not all data converted: %u\n", count);
+				pr_err("not all data converted: %zu\n", count);
 			}
 		}
 	}
-- 
2.9.0
