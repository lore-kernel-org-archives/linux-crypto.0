From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH 10/24] crypto: atmel-aes: simplify the configuration of the AES IP
Date: Thu, 17 Dec 2015 17:48:41 +0100
Message-ID: <03a0f9108e284202b839f4a86fce693fbf449540.1450366831.git.cyrille.pitchen@atmel.com>
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

This patch reworks the AES_FLAGS_* to simplify the configuration of the
AES IP.

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
---
 drivers/crypto/atmel-aes.c | 216 +++++++++++++++++++--------------------------
 1 file changed, 93 insertions(+), 123 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index f1ea9c893561..c10c54ccc606 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -48,22 +48,28 @@
 #define CFB64_BLOCK_SIZE	8
 
 /* AES flags */
-#define AES_FLAGS_MODE_MASK	0x03ff
-#define AES_FLAGS_ENCRYPT	BIT(0)
-#define AES_FLAGS_CBC		BIT(1)
-#define AES_FLAGS_CFB		BIT(2)
-#define AES_FLAGS_CFB8		BIT(3)
-#define AES_FLAGS_CFB16		BIT(4)
-#define AES_FLAGS_CFB32		BIT(5)
-#define AES_FLAGS_CFB64		BIT(6)
-#define AES_FLAGS_CFB128	BIT(7)
-#define AES_FLAGS_OFB		BIT(8)
-#define AES_FLAGS_CTR		BIT(9)
-
-#define AES_FLAGS_INIT		BIT(16)
-#define AES_FLAGS_DMA		BIT(17)
-#define AES_FLAGS_BUSY		BIT(18)
-#define AES_FLAGS_FAST		BIT(19)
+/* Reserve bits [18:16] [14:12] [0] for mode (same as for AES_MR) */
+#define AES_FLAGS_ENCRYPT	AES_MR_CYPHER_ENC
+#define AES_FLAGS_OPMODE_MASK	(AES_MR_OPMOD_MASK | AES_MR_CFBS_MASK)
+#define AES_FLAGS_ECB		AES_MR_OPMOD_ECB
+#define AES_FLAGS_CBC		AES_MR_OPMOD_CBC
+#define AES_FLAGS_OFB		AES_MR_OPMOD_OFB
+#define AES_FLAGS_CFB128	(AES_MR_OPMOD_CFB | AES_MR_CFBS_128b)
+#define AES_FLAGS_CFB64		(AES_MR_OPMOD_CFB | AES_MR_CFBS_64b)
+#define AES_FLAGS_CFB32		(AES_MR_OPMOD_CFB | AES_MR_CFBS_32b)
+#define AES_FLAGS_CFB16		(AES_MR_OPMOD_CFB | AES_MR_CFBS_16b)
+#define AES_FLAGS_CFB8		(AES_MR_OPMOD_CFB | AES_MR_CFBS_8b)
+#define AES_FLAGS_CTR		AES_MR_OPMOD_CTR
+
+#define AES_FLAGS_MODE_MASK	(AES_FLAGS_OPMODE_MASK |	\
+				 AES_FLAGS_ENCRYPT)
+
+#define AES_FLAGS_INIT		BIT(2)
+#define AES_FLAGS_BUSY		BIT(3)
+#define AES_FLAGS_DMA		BIT(4)
+#define AES_FLAGS_FAST		BIT(5)
+
+#define AES_FLAGS_PERSISTENT	(AES_FLAGS_INIT | AES_FLAGS_BUSY)
 
 #define ATMEL_AES_QUEUE_LENGTH	50
 
@@ -306,6 +312,13 @@ static int atmel_aes_hw_version_init(struct atmel_aes_dev *dd)
 	return 0;
 }
 
+static inline void atmel_aes_set_mode(struct atmel_aes_dev *dd,
+				      const struct atmel_aes_reqctx *rctx)
+{
+	/* Clear all but persistent flags and set request flags. */
+	dd->flags = (dd->flags & AES_FLAGS_PERSISTENT) | rctx->mode;
+}
+
 static void atmel_aes_finish_req(struct atmel_aes_dev *dd, int err)
 {
 	struct ablkcipher_request *req = ablkcipher_request_cast(dd->areq);
@@ -329,6 +342,34 @@ static int atmel_aes_crypt_dma(struct atmel_aes_dev *dd,
 {
 	struct scatterlist sg[2];
 	struct dma_async_tx_descriptor	*in_desc, *out_desc;
+	enum dma_slave_buswidth addr_width;
+	u32 maxburst;
+
+	switch (dd->ctx->block_size) {
+	case CFB8_BLOCK_SIZE:
+		addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
+		maxburst = 1;
+		break;
+
+	case CFB16_BLOCK_SIZE:
+		addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES;
+		maxburst = 1;
+		break;
+
+	case CFB32_BLOCK_SIZE:
+	case CFB64_BLOCK_SIZE:
+		addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+		maxburst = 1;
+		break;
+
+	case AES_BLOCK_SIZE:
+		addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+		maxburst = dd->caps.max_burst_size;
+		break;
+
+	default:
+		return -EINVAL;
+	}
 
 	dd->dma_size = length;
 
@@ -337,35 +378,13 @@ static int atmel_aes_crypt_dma(struct atmel_aes_dev *dd,
 	dma_sync_single_for_device(dd->dev, dma_addr_out, length,
 				   DMA_FROM_DEVICE);
 
-	if (dd->flags & AES_FLAGS_CFB8) {
-		dd->dma_lch_in.dma_conf.dst_addr_width =
-			DMA_SLAVE_BUSWIDTH_1_BYTE;
-		dd->dma_lch_out.dma_conf.src_addr_width =
-			DMA_SLAVE_BUSWIDTH_1_BYTE;
-	} else if (dd->flags & AES_FLAGS_CFB16) {
-		dd->dma_lch_in.dma_conf.dst_addr_width =
-			DMA_SLAVE_BUSWIDTH_2_BYTES;
-		dd->dma_lch_out.dma_conf.src_addr_width =
-			DMA_SLAVE_BUSWIDTH_2_BYTES;
-	} else {
-		dd->dma_lch_in.dma_conf.dst_addr_width =
-			DMA_SLAVE_BUSWIDTH_4_BYTES;
-		dd->dma_lch_out.dma_conf.src_addr_width =
-			DMA_SLAVE_BUSWIDTH_4_BYTES;
-	}
+	dd->dma_lch_in.dma_conf.dst_addr_width = addr_width;
+	dd->dma_lch_in.dma_conf.src_maxburst = maxburst;
+	dd->dma_lch_in.dma_conf.dst_maxburst = maxburst;
 
-	if (dd->flags & (AES_FLAGS_CFB8 | AES_FLAGS_CFB16 |
-			AES_FLAGS_CFB32 | AES_FLAGS_CFB64)) {
-		dd->dma_lch_in.dma_conf.src_maxburst = 1;
-		dd->dma_lch_in.dma_conf.dst_maxburst = 1;
-		dd->dma_lch_out.dma_conf.src_maxburst = 1;
-		dd->dma_lch_out.dma_conf.dst_maxburst = 1;
-	} else {
-		dd->dma_lch_in.dma_conf.src_maxburst = dd->caps.max_burst_size;
-		dd->dma_lch_in.dma_conf.dst_maxburst = dd->caps.max_burst_size;
-		dd->dma_lch_out.dma_conf.src_maxburst = dd->caps.max_burst_size;
-		dd->dma_lch_out.dma_conf.dst_maxburst = dd->caps.max_burst_size;
-	}
+	dd->dma_lch_out.dma_conf.src_addr_width = addr_width;
+	dd->dma_lch_out.dma_conf.src_maxburst = maxburst;
+	dd->dma_lch_out.dma_conf.dst_maxburst = maxburst;
 
 	dmaengine_slave_config(dd->dma_lch_in.chan, &dd->dma_lch_in.dma_conf);
 	dmaengine_slave_config(dd->dma_lch_out.chan, &dd->dma_lch_out.dma_conf);
@@ -521,30 +540,7 @@ static void atmel_aes_write_ctrl(struct atmel_aes_dev *dd, bool use_dma,
 	else
 		valmr |= AES_MR_KEYSIZE_256;
 
-	if (dd->flags & AES_FLAGS_CBC) {
-		valmr |= AES_MR_OPMOD_CBC;
-	} else if (dd->flags & AES_FLAGS_CFB) {
-		valmr |= AES_MR_OPMOD_CFB;
-		if (dd->flags & AES_FLAGS_CFB8)
-			valmr |= AES_MR_CFBS_8b;
-		else if (dd->flags & AES_FLAGS_CFB16)
-			valmr |= AES_MR_CFBS_16b;
-		else if (dd->flags & AES_FLAGS_CFB32)
-			valmr |= AES_MR_CFBS_32b;
-		else if (dd->flags & AES_FLAGS_CFB64)
-			valmr |= AES_MR_CFBS_64b;
-		else if (dd->flags & AES_FLAGS_CFB128)
-			valmr |= AES_MR_CFBS_128b;
-	} else if (dd->flags & AES_FLAGS_OFB) {
-		valmr |= AES_MR_OPMOD_OFB;
-	} else if (dd->flags & AES_FLAGS_CTR) {
-		valmr |= AES_MR_OPMOD_CTR;
-	} else {
-		valmr |= AES_MR_OPMOD_ECB;
-	}
-
-	if (dd->flags & AES_FLAGS_ENCRYPT)
-		valmr |= AES_MR_CYPHER_ENC;
+	valmr |= dd->flags & AES_FLAGS_MODE_MASK;
 
 	if (use_dma) {
 		valmr |= AES_MR_SMOD_IDATAR0;
@@ -559,11 +555,8 @@ static void atmel_aes_write_ctrl(struct atmel_aes_dev *dd, bool use_dma,
 	atmel_aes_write_n(dd, AES_KEYWR(0), dd->ctx->key,
 						dd->ctx->keylen >> 2);
 
-	if (((dd->flags & AES_FLAGS_CBC) || (dd->flags & AES_FLAGS_CFB) ||
-	   (dd->flags & AES_FLAGS_OFB) || (dd->flags & AES_FLAGS_CTR)) &&
-	   iv) {
+	if (iv && (valmr & AES_MR_OPMOD_MASK) != AES_MR_OPMOD_ECB)
 		atmel_aes_write_n(dd, AES_IVR(0), iv, 4);
-	}
 }
 
 static int atmel_aes_handle_queue(struct atmel_aes_dev *dd,
@@ -617,8 +610,7 @@ static int atmel_aes_start(struct atmel_aes_dev *dd)
 	dd->out_sg = req->dst;
 
 	rctx = ablkcipher_request_ctx(req);
-	rctx->mode &= AES_FLAGS_MODE_MASK;
-	dd->flags = (dd->flags & ~AES_FLAGS_MODE_MASK) | rctx->mode;
+	atmel_aes_set_mode(dd, rctx);
 
 	err = atmel_aes_hw_init(dd);
 	if (!err) {
@@ -728,36 +720,26 @@ static int atmel_aes_crypt(struct ablkcipher_request *req, unsigned long mode)
 	struct atmel_aes_reqctx *rctx = ablkcipher_request_ctx(req);
 	struct atmel_aes_dev *dd;
 
-	if (mode & AES_FLAGS_CFB8) {
-		if (!IS_ALIGNED(req->nbytes, CFB8_BLOCK_SIZE)) {
-			pr_err("request size is not exact amount of CFB8 blocks\n");
-			return -EINVAL;
-		}
+	switch (mode & AES_FLAGS_OPMODE_MASK) {
+	case AES_FLAGS_CFB8:
 		ctx->block_size = CFB8_BLOCK_SIZE;
-	} else if (mode & AES_FLAGS_CFB16) {
-		if (!IS_ALIGNED(req->nbytes, CFB16_BLOCK_SIZE)) {
-			pr_err("request size is not exact amount of CFB16 blocks\n");
-			return -EINVAL;
-		}
+		break;
+
+	case AES_FLAGS_CFB16:
 		ctx->block_size = CFB16_BLOCK_SIZE;
-	} else if (mode & AES_FLAGS_CFB32) {
-		if (!IS_ALIGNED(req->nbytes, CFB32_BLOCK_SIZE)) {
-			pr_err("request size is not exact amount of CFB32 blocks\n");
-			return -EINVAL;
-		}
+		break;
+
+	case AES_FLAGS_CFB32:
 		ctx->block_size = CFB32_BLOCK_SIZE;
-	} else if (mode & AES_FLAGS_CFB64) {
-		if (!IS_ALIGNED(req->nbytes, CFB64_BLOCK_SIZE)) {
-			pr_err("request size is not exact amount of CFB64 blocks\n");
-			return -EINVAL;
-		}
+		break;
+
+	case AES_FLAGS_CFB64:
 		ctx->block_size = CFB64_BLOCK_SIZE;
-	} else {
-		if (!IS_ALIGNED(req->nbytes, AES_BLOCK_SIZE)) {
-			pr_err("request size is not exact amount of AES blocks\n");
-			return -EINVAL;
-		}
+		break;
+
+	default:
 		ctx->block_size = AES_BLOCK_SIZE;
+		break;
 	}
 
 	dd = atmel_aes_find_dev(ctx);
@@ -857,14 +839,12 @@ static int atmel_aes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 
 static int atmel_aes_ecb_encrypt(struct ablkcipher_request *req)
 {
-	return atmel_aes_crypt(req,
-		AES_FLAGS_ENCRYPT);
+	return atmel_aes_crypt(req, AES_FLAGS_ECB | AES_FLAGS_ENCRYPT);
 }
 
 static int atmel_aes_ecb_decrypt(struct ablkcipher_request *req)
 {
-	return atmel_aes_crypt(req,
-		0);
+	return atmel_aes_crypt(req, AES_FLAGS_ECB);
 }
 
 static int atmel_aes_cbc_encrypt(struct ablkcipher_request *req)
@@ -893,62 +873,52 @@ static int atmel_aes_ofb_decrypt(struct ablkcipher_request *req)
 
 static int atmel_aes_cfb_encrypt(struct ablkcipher_request *req)
 {
-	return atmel_aes_crypt(req,
-		AES_FLAGS_ENCRYPT | AES_FLAGS_CFB | AES_FLAGS_CFB128);
+	return atmel_aes_crypt(req, AES_FLAGS_CFB128 | AES_FLAGS_ENCRYPT);
 }
 
 static int atmel_aes_cfb_decrypt(struct ablkcipher_request *req)
 {
-	return atmel_aes_crypt(req,
-		AES_FLAGS_CFB | AES_FLAGS_CFB128);
+	return atmel_aes_crypt(req, AES_FLAGS_CFB128);
 }
 
 static int atmel_aes_cfb64_encrypt(struct ablkcipher_request *req)
 {
-	return atmel_aes_crypt(req,
-		AES_FLAGS_ENCRYPT | AES_FLAGS_CFB | AES_FLAGS_CFB64);
+	return atmel_aes_crypt(req, AES_FLAGS_CFB64 | AES_FLAGS_ENCRYPT);
 }
 
 static int atmel_aes_cfb64_decrypt(struct ablkcipher_request *req)
 {
-	return atmel_aes_crypt(req,
-		AES_FLAGS_CFB | AES_FLAGS_CFB64);
+	return atmel_aes_crypt(req, AES_FLAGS_CFB64);
 }
 
 static int atmel_aes_cfb32_encrypt(struct ablkcipher_request *req)
 {
-	return atmel_aes_crypt(req,
-		AES_FLAGS_ENCRYPT | AES_FLAGS_CFB | AES_FLAGS_CFB32);
+	return atmel_aes_crypt(req, AES_FLAGS_CFB32 | AES_FLAGS_ENCRYPT);
 }
 
 static int atmel_aes_cfb32_decrypt(struct ablkcipher_request *req)
 {
-	return atmel_aes_crypt(req,
-		AES_FLAGS_CFB | AES_FLAGS_CFB32);
+	return atmel_aes_crypt(req, AES_FLAGS_CFB32);
 }
 
 static int atmel_aes_cfb16_encrypt(struct ablkcipher_request *req)
 {
-	return atmel_aes_crypt(req,
-		AES_FLAGS_ENCRYPT | AES_FLAGS_CFB | AES_FLAGS_CFB16);
+	return atmel_aes_crypt(req, AES_FLAGS_CFB16 | AES_FLAGS_ENCRYPT);
 }
 
 static int atmel_aes_cfb16_decrypt(struct ablkcipher_request *req)
 {
-	return atmel_aes_crypt(req,
-		AES_FLAGS_CFB | AES_FLAGS_CFB16);
+	return atmel_aes_crypt(req, AES_FLAGS_CFB16);
 }
 
 static int atmel_aes_cfb8_encrypt(struct ablkcipher_request *req)
 {
-	return atmel_aes_crypt(req,
-		AES_FLAGS_ENCRYPT |	AES_FLAGS_CFB | AES_FLAGS_CFB8);
+	return atmel_aes_crypt(req, AES_FLAGS_CFB8 | AES_FLAGS_ENCRYPT);
 }
 
 static int atmel_aes_cfb8_decrypt(struct ablkcipher_request *req)
 {
-	return atmel_aes_crypt(req,
-		AES_FLAGS_CFB | AES_FLAGS_CFB8);
+	return atmel_aes_crypt(req, AES_FLAGS_CFB8);
 }
 
 static int atmel_aes_ctr_encrypt(struct ablkcipher_request *req)
-- 
1.8.2.2
