From: Ryder Lee <ryder.lee@mediatek.com>
Subject: [PATCH 7/8] crypto: mediatek - add support to CTR mode
Date: Fri, 20 Jan 2017 13:41:14 +0800
Message-ID: <1484890875-57105-8-git-send-email-ryder.lee@mediatek.com>
References: <1484890875-57105-1-git-send-email-ryder.lee@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Ryder Lee <ryder.lee@mediatek.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1484890875-57105-1-git-send-email-ryder.lee@mediatek.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch adds support to the CTR mode.

Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
---
 drivers/crypto/mediatek/mtk-aes.c | 151 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 146 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/mediatek/mtk-aes.c b/drivers/crypto/mediatek/mtk-aes.c
index 5e7c3ce..bb5b4ff 100644
--- a/drivers/crypto/mediatek/mtk-aes.c
+++ b/drivers/crypto/mediatek/mtk-aes.c
@@ -23,8 +23,10 @@
 /* AES command token size */
 #define AES_CT_SIZE_ECB		2
 #define AES_CT_SIZE_CBC		3
+#define AES_CT_SIZE_CTR		3
 #define AES_CT_CTRL_HDR		cpu_to_le32(0x00220000)
-/* AES-CBC/ECB command token */
+
+/* AES-CBC/ECB/CTR command token */
 #define AES_CMD0		cpu_to_le32(0x05000000)
 #define AES_CMD1		cpu_to_le32(0x2d060000)
 #define AES_CMD2		cpu_to_le32(0xe4a63806)
@@ -39,13 +41,15 @@
 /* AES transform information word 1 fields */
 #define AES_TFM_ECB		cpu_to_le32(0x0 << 0)
 #define AES_TFM_CBC		cpu_to_le32(0x1 << 0)
-#define AES_TFM_FULL_IV		cpu_to_le32(0xf << 5)
+#define AES_TFM_CTR_LOAD	cpu_to_le32(0x6 << 0)	/* load/reuse counter */
+#define AES_TFM_FULL_IV		cpu_to_le32(0xf << 5)	/* using IV 0-3 */
 
 /* AES flags */
 #define AES_FLAGS_ECB		BIT(0)
 #define AES_FLAGS_CBC		BIT(1)
-#define AES_FLAGS_ENCRYPT	BIT(2)
-#define AES_FLAGS_BUSY		BIT(3)
+#define AES_FLAGS_CTR		BIT(2)
+#define AES_FLAGS_ENCRYPT	BIT(3)
+#define AES_FLAGS_BUSY		BIT(4)
 
 /**
  * Command token(CT) is a set of hardware instructions that
@@ -90,6 +94,15 @@ struct mtk_aes_ctx {
 	struct mtk_aes_base_ctx	base;
 };
 
+struct mtk_aes_ctr_ctx {
+	struct mtk_aes_base_ctx base;
+
+	u32	iv[AES_BLOCK_SIZE / sizeof(u32)];
+	size_t offset;
+	struct scatterlist src[2];
+	struct scatterlist dst[2];
+};
+
 struct mtk_aes_drv {
 	struct list_head dev_list;
 	/* Device list lock */
@@ -332,7 +345,7 @@ static int mtk_aes_map(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
 	return -EINVAL;
 }
 
-/* Initialize transform information of CBC/ECB mode */
+/* Initialize transform information of CBC/ECB/CTR mode */
 static void mtk_aes_info_init(struct mtk_cryp *cryp, struct mtk_aes_rec *aes,
 			      size_t len)
 {
@@ -374,6 +387,13 @@ static void mtk_aes_info_init(struct mtk_cryp *cryp, struct mtk_aes_rec *aes,
 		ctx->tfm.ctrl[1] = AES_TFM_ECB;
 
 		ctx->ct_size = AES_CT_SIZE_ECB;
+	} else if (aes->flags & AES_FLAGS_CTR) {
+		ctx->tfm.ctrl[0] |= AES_TFM_SIZE(ctx->keylen +
+				    SIZE_IN_WORDS(AES_BLOCK_SIZE));
+		ctx->tfm.ctrl[1] = AES_TFM_CTR_LOAD | AES_TFM_FULL_IV;
+
+		ctx->ct.cmd[2] = AES_CMD2;
+		ctx->ct_size = AES_CT_SIZE_CTR;
 	}
 }
 
@@ -479,6 +499,80 @@ static int mtk_aes_start(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
 	return mtk_aes_dma(cryp, aes, req->src, req->dst, req->nbytes);
 }
 
+static inline struct mtk_aes_ctr_ctx *
+mtk_aes_ctr_ctx_cast(struct mtk_aes_base_ctx *ctx)
+{
+	return container_of(ctx, struct mtk_aes_ctr_ctx, base);
+}
+
+static int mtk_aes_ctr_transfer(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
+{
+	struct mtk_aes_base_ctx *ctx = aes->ctx;
+	struct mtk_aes_ctr_ctx *cctx = mtk_aes_ctr_ctx_cast(ctx);
+	struct ablkcipher_request *req = ablkcipher_request_cast(aes->areq);
+	struct scatterlist *src, *dst;
+	int i;
+	u32 start, end, ctr, blocks, *iv_state;
+	size_t datalen;
+	bool fragmented = false;
+
+	/* Check for transfer completion. */
+	cctx->offset += aes->total;
+	if (cctx->offset >= req->nbytes)
+		return mtk_aes_complete(cryp, aes);
+
+	/* Compute data length. */
+	datalen = req->nbytes - cctx->offset;
+	blocks = DIV_ROUND_UP(datalen, AES_BLOCK_SIZE);
+	ctr = be32_to_cpu(cctx->iv[3]);
+
+	/* Check 32bit counter overflow. */
+	start = ctr;
+	end = start + blocks - 1;
+	if (end < start) {
+		ctr |= 0xffffffff;
+		datalen = AES_BLOCK_SIZE * -start;
+		fragmented = true;
+	}
+
+	/* Jump to offset. */
+	src = scatterwalk_ffwd(cctx->src, req->src, cctx->offset);
+	dst = ((req->src == req->dst) ? src :
+	       scatterwalk_ffwd(cctx->dst, req->dst, cctx->offset));
+
+	/* Write IVs into transform state buffer. */
+	iv_state = ctx->tfm.state + ctx->keylen;
+	for (i = 0; i < SIZE_IN_WORDS(AES_BLOCK_SIZE); i++)
+		iv_state[i] = cpu_to_le32(cctx->iv[i]);
+
+	if (unlikely(fragmented)) {
+	/*
+	 * Increment the counter manually to cope with the hardware
+	 * counter overflow.
+	 */
+		cctx->iv[3] = cpu_to_be32(ctr);
+		crypto_inc((u8 *)cctx->iv, AES_BLOCK_SIZE);
+	}
+	aes->resume = mtk_aes_ctr_transfer;
+
+	return mtk_aes_dma(cryp, aes, src, dst, datalen);
+}
+
+static int mtk_aes_ctr_start(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
+{
+	struct mtk_aes_ctr_ctx *cctx = mtk_aes_ctr_ctx_cast(aes->ctx);
+	struct ablkcipher_request *req = ablkcipher_request_cast(aes->areq);
+	struct mtk_aes_reqctx *rctx = ablkcipher_request_ctx(req);
+
+	mtk_aes_set_mode(aes, rctx);
+
+	memcpy(cctx->iv, req->info, AES_BLOCK_SIZE);
+	cctx->offset = 0;
+	aes->total = 0;
+
+	return mtk_aes_ctr_transfer(cryp, aes);
+}
+
 /* Check and set the AES key to transform state buffer */
 static int mtk_aes_setkey(struct crypto_ablkcipher *tfm,
 			  const u8 *key, u32 keylen)
@@ -536,6 +630,16 @@ static int mtk_aes_cbc_decrypt(struct ablkcipher_request *req)
 	return mtk_aes_crypt(req, AES_FLAGS_CBC);
 }
 
+static int mtk_aes_ctr_encrypt(struct ablkcipher_request *req)
+{
+	return mtk_aes_crypt(req, AES_FLAGS_ENCRYPT | AES_FLAGS_CTR);
+}
+
+static int mtk_aes_ctr_decrypt(struct ablkcipher_request *req)
+{
+	return mtk_aes_crypt(req, AES_FLAGS_CTR);
+}
+
 static int mtk_aes_cra_init(struct crypto_tfm *tfm)
 {
 	struct mtk_aes_ctx *ctx = crypto_tfm_ctx(tfm);
@@ -552,6 +656,22 @@ static int mtk_aes_cra_init(struct crypto_tfm *tfm)
 	return 0;
 }
 
+static int mtk_aes_ctr_cra_init(struct crypto_tfm *tfm)
+{
+	struct mtk_aes_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct mtk_cryp *cryp = NULL;
+
+	cryp = mtk_aes_find_dev(&ctx->base);
+	if (!cryp) {
+		pr_err("can't find crypto device\n");
+		return -ENODEV;
+	}
+
+	tfm->crt_ablkcipher.reqsize = sizeof(struct mtk_aes_reqctx);
+	ctx->base.start = mtk_aes_ctr_start;
+	return 0;
+}
+
 static struct crypto_alg aes_algs[] = {
 {
 	.cra_name		= "cbc(aes)",
@@ -594,6 +714,27 @@ static int mtk_aes_cra_init(struct crypto_tfm *tfm)
 		.decrypt	= mtk_aes_ecb_decrypt,
 	}
 },
+{
+	.cra_name		= "ctr(aes)",
+	.cra_driver_name	= "ctr-aes-mtk",
+	.cra_priority		= 400,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER |
+				  CRYPTO_ALG_ASYNC,
+	.cra_init		= mtk_aes_ctr_cra_init,
+	.cra_blocksize		= 1,
+	.cra_ctxsize		= sizeof(struct mtk_aes_ctr_ctx),
+	.cra_alignmask		= 0xf,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_u.ablkcipher = {
+		.min_keysize	= AES_MIN_KEY_SIZE,
+		.max_keysize	= AES_MAX_KEY_SIZE,
+		.ivsize		= AES_BLOCK_SIZE,
+		.setkey		= mtk_aes_setkey,
+		.encrypt	= mtk_aes_ctr_encrypt,
+		.decrypt	= mtk_aes_ctr_decrypt,
+	}
+},
 };
 
 static void mtk_aes_enc_task(unsigned long data)
-- 
1.9.1
