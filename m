From: Colin King <colin.king@canonical.com>
Subject: [PATCH] crypto: atmel-sha: use %zu for size_t print format specifier
Date: Tue,  7 Feb 2017 12:11:51 +0000
Message-ID: <20170207121151.19326-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Return-path: <kernel-janitors-owner@vger.kernel.org>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The size_t types should be using %zu as a format specifier rather
than %d and %u.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/crypto/atmel-sha.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 22d0c0c..b081e78 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -568,7 +568,7 @@ static int atmel_sha_xmit_cpu(struct atmel_sha_dev *dd, const u8 *buf,
 	int count, len32;
 	const u32 *buffer = (const u32 *)buf;
 
-	dev_dbg(dd->dev, "xmit_cpu: digcnt: 0x%llx 0x%llx, length: %d, final: %d\n",
+	dev_dbg(dd->dev, "xmit_cpu: digcnt: 0x%llx 0x%llx, length: %zu, final: %d\n",
 		ctx->digcnt[1], ctx->digcnt[0], length, final);
 
 	atmel_sha_write_ctrl(dd, 0);
@@ -597,7 +597,7 @@ static int atmel_sha_xmit_pdc(struct atmel_sha_dev *dd, dma_addr_t dma_addr1,
 	struct atmel_sha_reqctx *ctx = ahash_request_ctx(dd->req);
 	int len32;
 
-	dev_dbg(dd->dev, "xmit_pdc: digcnt: 0x%llx 0x%llx, length: %d, final: %d\n",
+	dev_dbg(dd->dev, "xmit_pdc: digcnt: 0x%llx 0x%llx, length: %zu, final: %d\n",
 		ctx->digcnt[1], ctx->digcnt[0], length1, final);
 
 	len32 = DIV_ROUND_UP(length1, sizeof(u32));
@@ -644,7 +644,7 @@ static int atmel_sha_xmit_dma(struct atmel_sha_dev *dd, dma_addr_t dma_addr1,
 	struct dma_async_tx_descriptor	*in_desc;
 	struct scatterlist sg[2];
 
-	dev_dbg(dd->dev, "xmit_dma: digcnt: 0x%llx 0x%llx, length: %d, final: %d\n",
+	dev_dbg(dd->dev, "xmit_dma: digcnt: 0x%llx 0x%llx, length: %zu, final: %d\n",
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
+	dev_dbg(dd->dev, "fast: digcnt: 0x%llx 0x%llx, bufcnt: %zu, total: %u\n",
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
+	dev_dbg(dd->dev, "digcnt: 0x%llx 0x%llx, bufcnt: %zu\n", ctx->digcnt[1],
 		ctx->digcnt[0], ctx->bufcnt);
 
 	return 0;
-- 
2.10.2

