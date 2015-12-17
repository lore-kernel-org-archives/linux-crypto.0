From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH 21/24] crypto: atmel-aes: fix the counter overflow in CTR mode
Date: Thu, 17 Dec 2015 18:13:05 +0100
Message-ID: <b7cfde4884b7a41696cbe0ad23c8a82da8f423ac.1450366831.git.cyrille.pitchen@atmel.com>
References: <cover.1450366831.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	Cyrille Pitchen <cyrille.pitchen@atmel.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<nicolas.ferre@atmel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1450366831.git.cyrille.pitchen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Depending on its hardware version, the AES IP provides either a 16 or a
32 bit counter. However the CTR mode expects the size of the counter to be
the same as the size of the cipher block, ie 128 bits for AES.
This patch detects and handles counter overflows.

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
---
 drivers/crypto/atmel-aes.c | 117 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 115 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 5f6dc48616c0..a34919f6b7d7 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -82,6 +82,7 @@
 struct atmel_aes_caps {
 	bool			has_dualbuff;
 	bool			has_cfb64;
+	bool			has_ctr32;
 	u32			max_burst_size;
 };
 
@@ -103,6 +104,15 @@ struct atmel_aes_ctx {
 	struct atmel_aes_base_ctx	base;
 };
 
+struct atmel_aes_ctr_ctx {
+	struct atmel_aes_base_ctx	base;
+
+	u32			iv[AES_BLOCK_SIZE / sizeof(u32)];
+	size_t			offset;
+	struct scatterlist	src[2];
+	struct scatterlist	dst[2];
+};
+
 struct atmel_aes_reqctx {
 	unsigned long		mode;
 };
@@ -762,6 +772,96 @@ static int atmel_aes_start(struct atmel_aes_dev *dd)
 				   atmel_aes_transfer_complete);
 }
 
+static inline struct atmel_aes_ctr_ctx *
+atmel_aes_ctr_ctx_cast(struct atmel_aes_base_ctx *ctx)
+{
+	return container_of(ctx, struct atmel_aes_ctr_ctx, base);
+}
+
+static int atmel_aes_ctr_transfer(struct atmel_aes_dev *dd)
+{
+	struct atmel_aes_ctr_ctx *ctx = atmel_aes_ctr_ctx_cast(dd->ctx);
+	struct ablkcipher_request *req = ablkcipher_request_cast(dd->areq);
+	struct scatterlist *src, *dst;
+	u32 ctr, blocks;
+	size_t datalen;
+	bool use_dma, fragmented = false;
+
+	/* Check for transfer completion. */
+	ctx->offset += dd->total;
+	if (ctx->offset >= req->nbytes)
+		return atmel_aes_transfer_complete(dd);
+
+	/* Compute data length. */
+	datalen = req->nbytes - ctx->offset;
+	blocks = DIV_ROUND_UP(datalen, AES_BLOCK_SIZE);
+	ctr = be32_to_cpu(ctx->iv[3]);
+	if (dd->caps.has_ctr32) {
+		/* Check 32bit counter overflow. */
+		u32 start = ctr;
+		u32 end = start + blocks - 1;
+
+		if (end < start) {
+			ctr |= 0xffffffff;
+			datalen = AES_BLOCK_SIZE * -start;
+			fragmented = true;
+		}
+	} else {
+		/* Check 16bit counter overflow. */
+		u16 start = ctr & 0xffff;
+		u16 end = start + (u16)blocks - 1;
+
+		if (blocks >> 16 || end < start) {
+			ctr |= 0xffff;
+			datalen = AES_BLOCK_SIZE * (0x10000-start);
+			fragmented = true;
+		}
+	}
+	use_dma = (datalen >= ATMEL_AES_DMA_THRESHOLD);
+
+	/* Jump to offset. */
+	src = scatterwalk_ffwd(ctx->src, req->src, ctx->offset);
+	dst = ((req->src == req->dst) ? src :
+	       scatterwalk_ffwd(ctx->dst, req->dst, ctx->offset));
+
+	/* Configure hardware. */
+	atmel_aes_write_ctrl(dd, use_dma, ctx->iv);
+	if (unlikely(fragmented)) {
+		/*
+		 * Increment the counter manually to cope with the hardware
+		 * counter overflow.
+		 */
+		ctx->iv[3] = cpu_to_be32(ctr);
+		crypto_inc((u8 *)ctx->iv, AES_BLOCK_SIZE);
+	}
+
+	if (use_dma)
+		return atmel_aes_dma_start(dd, src, dst, datalen,
+					   atmel_aes_ctr_transfer);
+
+	return atmel_aes_cpu_start(dd, src, dst, datalen,
+				   atmel_aes_ctr_transfer);
+}
+
+static int atmel_aes_ctr_start(struct atmel_aes_dev *dd)
+{
+	struct atmel_aes_ctr_ctx *ctx = atmel_aes_ctr_ctx_cast(dd->ctx);
+	struct ablkcipher_request *req = ablkcipher_request_cast(dd->areq);
+	struct atmel_aes_reqctx *rctx = ablkcipher_request_ctx(req);
+	int err;
+
+	atmel_aes_set_mode(dd, rctx);
+
+	err = atmel_aes_hw_init(dd);
+	if (err)
+		return atmel_aes_complete(dd, err);
+
+	memcpy(ctx->iv, req->info, AES_BLOCK_SIZE);
+	ctx->offset = 0;
+	dd->total = 0;
+	return atmel_aes_ctr_transfer(dd);
+}
+
 static int atmel_aes_crypt(struct ablkcipher_request *req, unsigned long mode)
 {
 	struct atmel_aes_base_ctx *ctx;
@@ -919,6 +1019,16 @@ static int atmel_aes_cra_init(struct crypto_tfm *tfm)
 	return 0;
 }
 
+static int atmel_aes_ctr_cra_init(struct crypto_tfm *tfm)
+{
+	struct atmel_aes_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	tfm->crt_ablkcipher.reqsize = sizeof(struct atmel_aes_reqctx);
+	ctx->base.start = atmel_aes_ctr_start;
+
+	return 0;
+}
+
 static void atmel_aes_cra_exit(struct crypto_tfm *tfm)
 {
 }
@@ -1076,11 +1186,11 @@ static struct crypto_alg aes_algs[] = {
 	.cra_priority		= ATMEL_AES_PRIORITY,
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 	.cra_blocksize		= 1,
-	.cra_ctxsize		= sizeof(struct atmel_aes_ctx),
+	.cra_ctxsize		= sizeof(struct atmel_aes_ctr_ctx),
 	.cra_alignmask		= 0xf,
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_init		= atmel_aes_cra_init,
+	.cra_init		= atmel_aes_ctr_cra_init,
 	.cra_exit		= atmel_aes_cra_exit,
 	.cra_u.ablkcipher = {
 		.min_keysize	= AES_MIN_KEY_SIZE,
@@ -1262,6 +1372,7 @@ static void atmel_aes_get_cap(struct atmel_aes_dev *dd)
 {
 	dd->caps.has_dualbuff = 0;
 	dd->caps.has_cfb64 = 0;
+	dd->caps.has_ctr32 = 0;
 	dd->caps.max_burst_size = 1;
 
 	/* keep only major version number */
@@ -1269,11 +1380,13 @@ static void atmel_aes_get_cap(struct atmel_aes_dev *dd)
 	case 0x500:
 		dd->caps.has_dualbuff = 1;
 		dd->caps.has_cfb64 = 1;
+		dd->caps.has_ctr32 = 1;
 		dd->caps.max_burst_size = 4;
 		break;
 	case 0x200:
 		dd->caps.has_dualbuff = 1;
 		dd->caps.has_cfb64 = 1;
+		dd->caps.has_ctr32 = 1;
 		dd->caps.max_burst_size = 4;
 		break;
 	case 0x130:
-- 
1.8.2.2
