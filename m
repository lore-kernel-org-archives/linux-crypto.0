From: Ryder Lee <ryder.lee@mediatek.com>
Subject: [PATCH 6/8] crypto: mediatek - fix typo and indentation
Date: Fri, 20 Jan 2017 13:41:13 +0800
Message-ID: <1484890875-57105-7-git-send-email-ryder.lee@mediatek.com>
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

Dummy patch to fix typo and indentation.

Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
---
 drivers/crypto/mediatek/mtk-aes.c      | 90 +++++++++++++++++-----------------
 drivers/crypto/mediatek/mtk-platform.h |  2 +-
 drivers/crypto/mediatek/mtk-sha.c      | 40 +++++++--------
 3 files changed, 63 insertions(+), 69 deletions(-)

diff --git a/drivers/crypto/mediatek/mtk-aes.c b/drivers/crypto/mediatek/mtk-aes.c
index b5946e9..5e7c3ce 100644
--- a/drivers/crypto/mediatek/mtk-aes.c
+++ b/drivers/crypto/mediatek/mtk-aes.c
@@ -314,8 +314,8 @@ static int mtk_aes_map(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
 		aes->dst.sg_len = dma_map_sg(cryp->dev, aes->dst.sg,
 					     aes->dst.nents, DMA_FROM_DEVICE);
 		if (unlikely(!aes->dst.sg_len)) {
-			dma_unmap_sg(cryp->dev, aes->src.sg,
-				     aes->src.nents, DMA_TO_DEVICE);
+			dma_unmap_sg(cryp->dev, aes->src.sg, aes->src.nents,
+				     DMA_TO_DEVICE);
 			goto sg_map_err;
 		}
 	}
@@ -484,7 +484,7 @@ static int mtk_aes_setkey(struct crypto_ablkcipher *tfm,
 			  const u8 *key, u32 keylen)
 {
 	struct mtk_aes_base_ctx *ctx = crypto_ablkcipher_ctx(tfm);
-	const u32 *key_tmp = (const u32 *)key;
+	const u32 *aes_key = (const u32 *)key;
 	u32 *key_state = ctx->tfm.state;
 	int i;
 
@@ -498,7 +498,7 @@ static int mtk_aes_setkey(struct crypto_ablkcipher *tfm,
 	ctx->keylen = SIZE_IN_WORDS(keylen);
 
 	for (i = 0; i < ctx->keylen; i++)
-		key_state[i] = cpu_to_le32(key_tmp[i]);
+		key_state[i] = cpu_to_le32(aes_key[i]);
 
 	return 0;
 }
@@ -512,26 +512,26 @@ static int mtk_aes_crypt(struct ablkcipher_request *req, u64 mode)
 	rctx = ablkcipher_request_ctx(req);
 	rctx->mode = mode;
 
-	return mtk_aes_handle_queue(ctx->cryp,
-			!(mode & AES_FLAGS_ENCRYPT), &req->base);
+	return mtk_aes_handle_queue(ctx->cryp, !(mode & AES_FLAGS_ENCRYPT),
+				    &req->base);
 }
 
-static int mtk_ecb_encrypt(struct ablkcipher_request *req)
+static int mtk_aes_ecb_encrypt(struct ablkcipher_request *req)
 {
 	return mtk_aes_crypt(req, AES_FLAGS_ENCRYPT | AES_FLAGS_ECB);
 }
 
-static int mtk_ecb_decrypt(struct ablkcipher_request *req)
+static int mtk_aes_ecb_decrypt(struct ablkcipher_request *req)
 {
 	return mtk_aes_crypt(req, AES_FLAGS_ECB);
 }
 
-static int mtk_cbc_encrypt(struct ablkcipher_request *req)
+static int mtk_aes_cbc_encrypt(struct ablkcipher_request *req)
 {
 	return mtk_aes_crypt(req, AES_FLAGS_ENCRYPT | AES_FLAGS_CBC);
 }
 
-static int mtk_cbc_decrypt(struct ablkcipher_request *req)
+static int mtk_aes_cbc_decrypt(struct ablkcipher_request *req)
 {
 	return mtk_aes_crypt(req, AES_FLAGS_CBC);
 }
@@ -554,44 +554,44 @@ static int mtk_aes_cra_init(struct crypto_tfm *tfm)
 
 static struct crypto_alg aes_algs[] = {
 {
-	.cra_name		=	"cbc(aes)",
-	.cra_driver_name	=	"cbc-aes-mtk",
-	.cra_priority		=	400,
-	.cra_flags		=	CRYPTO_ALG_TYPE_ABLKCIPHER |
-						CRYPTO_ALG_ASYNC,
-	.cra_init		=	mtk_aes_cra_init,
-	.cra_blocksize		=	AES_BLOCK_SIZE,
-	.cra_ctxsize		=	sizeof(struct mtk_aes_ctx),
-	.cra_alignmask		=	15,
-	.cra_type		=	&crypto_ablkcipher_type,
-	.cra_module		=	THIS_MODULE,
-	.cra_u.ablkcipher	=	{
-		.min_keysize	=	AES_MIN_KEY_SIZE,
-		.max_keysize	=	AES_MAX_KEY_SIZE,
-		.setkey		=	mtk_aes_setkey,
-		.encrypt	=	mtk_cbc_encrypt,
-		.decrypt	=	mtk_cbc_decrypt,
-		.ivsize		=	AES_BLOCK_SIZE,
+	.cra_name		= "cbc(aes)",
+	.cra_driver_name	= "cbc-aes-mtk",
+	.cra_priority		= 400,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER |
+				  CRYPTO_ALG_ASYNC,
+	.cra_init		= mtk_aes_cra_init,
+	.cra_blocksize		= AES_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct mtk_aes_ctx),
+	.cra_alignmask		= 0xf,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_u.ablkcipher = {
+		.min_keysize	= AES_MIN_KEY_SIZE,
+		.max_keysize	= AES_MAX_KEY_SIZE,
+		.setkey		= mtk_aes_setkey,
+		.encrypt	= mtk_aes_cbc_encrypt,
+		.decrypt	= mtk_aes_cbc_decrypt,
+		.ivsize		= AES_BLOCK_SIZE,
 	}
 },
 {
-	.cra_name		=	"ecb(aes)",
-	.cra_driver_name	=	"ecb-aes-mtk",
-	.cra_priority		=	400,
-	.cra_flags		=	CRYPTO_ALG_TYPE_ABLKCIPHER |
-						CRYPTO_ALG_ASYNC,
-	.cra_init		=	mtk_aes_cra_init,
-	.cra_blocksize		=	AES_BLOCK_SIZE,
-	.cra_ctxsize		=	sizeof(struct mtk_aes_ctx),
-	.cra_alignmask		=	15,
-	.cra_type		=	&crypto_ablkcipher_type,
-	.cra_module		=	THIS_MODULE,
-	.cra_u.ablkcipher	=	{
-		.min_keysize	=	AES_MIN_KEY_SIZE,
-		.max_keysize	=	AES_MAX_KEY_SIZE,
-		.setkey		=	mtk_aes_setkey,
-		.encrypt	=	mtk_ecb_encrypt,
-		.decrypt	=	mtk_ecb_decrypt,
+	.cra_name		= "ecb(aes)",
+	.cra_driver_name	= "ecb-aes-mtk",
+	.cra_priority		= 400,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER |
+				  CRYPTO_ALG_ASYNC,
+	.cra_init		= mtk_aes_cra_init,
+	.cra_blocksize		= AES_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct mtk_aes_ctx),
+	.cra_alignmask		= 0xf,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_u.ablkcipher = {
+		.min_keysize	= AES_MIN_KEY_SIZE,
+		.max_keysize	= AES_MAX_KEY_SIZE,
+		.setkey		= mtk_aes_setkey,
+		.encrypt	= mtk_aes_ecb_encrypt,
+		.decrypt	= mtk_aes_ecb_decrypt,
 	}
 },
 };
diff --git a/drivers/crypto/mediatek/mtk-platform.h b/drivers/crypto/mediatek/mtk-platform.h
index 36d166b..7cd5f98 100644
--- a/drivers/crypto/mediatek/mtk-platform.h
+++ b/drivers/crypto/mediatek/mtk-platform.h
@@ -124,7 +124,7 @@ struct mtk_aes_dma {
 /**
  * struct mtk_aes_rec - AES operation record
  * @queue:	crypto request queue
- * @req:	pointer to async request
+ * @areq:	pointer to async request
  * @task:	the tasklet is use in AES interrupt
  * @ctx:	pointer to current context
  * @src:	the structure that holds source sg list info
diff --git a/drivers/crypto/mediatek/mtk-sha.c b/drivers/crypto/mediatek/mtk-sha.c
index 2536ebc..55e3805 100644
--- a/drivers/crypto/mediatek/mtk-sha.c
+++ b/drivers/crypto/mediatek/mtk-sha.c
@@ -317,9 +317,9 @@ static void mtk_sha_info_init(struct mtk_sha_reqctx *ctx)
  * Update input data length field of transform information and
  * map it to DMA region.
  */
-static int mtk_sha_info_map(struct mtk_cryp *cryp,
-			    struct mtk_sha_rec *sha,
-			    size_t len)
+static int mtk_sha_info_update(struct mtk_cryp *cryp,
+			       struct mtk_sha_rec *sha,
+			       size_t len)
 {
 	struct mtk_sha_reqctx *ctx = ahash_request_ctx(sha->req);
 	struct mtk_sha_info *info = &ctx->info;
@@ -338,7 +338,7 @@ static int mtk_sha_info_map(struct mtk_cryp *cryp,
 	ctx->digcnt += len;
 
 	ctx->ct_dma = dma_map_single(cryp->dev, info, sizeof(*info),
-				      DMA_BIDIRECTIONAL);
+				     DMA_BIDIRECTIONAL);
 	if (unlikely(dma_mapping_error(cryp->dev, ctx->ct_dma))) {
 		dev_err(cryp->dev, "dma %zu bytes error\n", sizeof(*info));
 		return -EINVAL;
@@ -430,20 +430,15 @@ static int mtk_sha_xmit(struct mtk_cryp *cryp, struct mtk_sha_rec *sha,
 	struct mtk_desc *res = ring->res_base + ring->res_pos;
 	int err;
 
-	err = mtk_sha_info_map(cryp, sha, len);
+	err = mtk_sha_info_update(cryp, sha, len);
 	if (err)
 		return err;
 
 	/* Fill in the command/result descriptors */
-	res->hdr = MTK_DESC_FIRST |
-		   MTK_DESC_LAST |
-		   MTK_DESC_BUF_LEN(len);
-
+	res->hdr = MTK_DESC_FIRST | MTK_DESC_LAST | MTK_DESC_BUF_LEN(len);
 	res->buf = cpu_to_le32(cryp->tmp_dma);
 
-	cmd->hdr = MTK_DESC_FIRST |
-		   MTK_DESC_LAST |
-		   MTK_DESC_BUF_LEN(len) |
+	cmd->hdr = MTK_DESC_FIRST | MTK_DESC_LAST | MTK_DESC_BUF_LEN(len) |
 		   MTK_DESC_CT_LEN(ctx->ct_size);
 
 	cmd->buf = cpu_to_le32(addr);
@@ -477,7 +472,7 @@ static int mtk_sha_xmit2(struct mtk_cryp *cryp,
 	struct mtk_desc *res = ring->res_base + ring->res_pos;
 	int err;
 
-	err = mtk_sha_info_map(cryp, sha, len1 + len2);
+	err = mtk_sha_info_update(cryp, sha, len1 + len2);
 	if (err)
 		return err;
 
@@ -485,8 +480,7 @@ static int mtk_sha_xmit2(struct mtk_cryp *cryp,
 	res->hdr = MTK_DESC_BUF_LEN(len1) | MTK_DESC_FIRST;
 	res->buf = cpu_to_le32(cryp->tmp_dma);
 
-	cmd->hdr = MTK_DESC_BUF_LEN(len1) |
-		   MTK_DESC_FIRST |
+	cmd->hdr = MTK_DESC_BUF_LEN(len1) | MTK_DESC_FIRST |
 		   MTK_DESC_CT_LEN(ctx->ct_size);
 	cmd->buf = cpu_to_le32(sg_dma_address(ctx->sg));
 	cmd->ct = cpu_to_le32(ctx->ct_dma);
@@ -530,7 +524,7 @@ static int mtk_sha_dma_map(struct mtk_cryp *cryp,
 			   size_t count)
 {
 	ctx->dma_addr = dma_map_single(cryp->dev, ctx->buffer,
-				SHA_BUF_SIZE, DMA_TO_DEVICE);
+				       SHA_BUF_SIZE, DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(cryp->dev, ctx->dma_addr))) {
 		dev_err(cryp->dev, "dma map error\n");
 		return -EINVAL;
@@ -619,7 +613,7 @@ static int mtk_sha_update_start(struct mtk_cryp *cryp,
 		mtk_sha_fill_padding(ctx, len);
 
 		ctx->dma_addr = dma_map_single(cryp->dev, ctx->buffer,
-			SHA_BUF_SIZE, DMA_TO_DEVICE);
+					       SHA_BUF_SIZE, DMA_TO_DEVICE);
 		if (unlikely(dma_mapping_error(cryp->dev, ctx->dma_addr))) {
 			dev_err(cryp->dev, "dma map bytes error\n");
 			return -EINVAL;
@@ -658,8 +652,7 @@ static int mtk_sha_update_start(struct mtk_cryp *cryp,
 static int mtk_sha_final_req(struct mtk_cryp *cryp,
 			     struct mtk_sha_rec *sha)
 {
-	struct ahash_request *req = sha->req;
-	struct mtk_sha_reqctx *ctx = ahash_request_ctx(req);
+	struct mtk_sha_reqctx *ctx = ahash_request_ctx(sha->req);
 	size_t count;
 
 	mtk_sha_fill_padding(ctx, 0);
@@ -690,7 +683,8 @@ static int mtk_sha_finish(struct ahash_request *req)
 }
 
 static void mtk_sha_finish_req(struct mtk_cryp *cryp,
-			       struct mtk_sha_rec *sha, int err)
+			       struct mtk_sha_rec *sha,
+			       int err)
 {
 	if (likely(!err && (SHA_FLAGS_FINAL & sha->flags)))
 		err = mtk_sha_finish(sha->req);
@@ -850,8 +844,8 @@ static int mtk_sha_digest(struct ahash_request *req)
 	return mtk_sha_init(req) ?: mtk_sha_finup(req);
 }
 
-static int mtk_sha_setkey(struct crypto_ahash *tfm,
-			  const unsigned char *key, u32 keylen)
+static int mtk_sha_setkey(struct crypto_ahash *tfm, const u8 *key,
+			  u32 keylen)
 {
 	struct mtk_sha_ctx *tctx = crypto_ahash_ctx(tfm);
 	struct mtk_sha_hmac_ctx *bctx = tctx->base;
@@ -863,7 +857,7 @@ static int mtk_sha_setkey(struct crypto_ahash *tfm,
 
 	shash->tfm = bctx->shash;
 	shash->flags = crypto_shash_get_flags(bctx->shash) &
-			CRYPTO_TFM_REQ_MAY_SLEEP;
+		       CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	if (keylen > bs) {
 		err = crypto_shash_digest(shash, key, keylen, bctx->ipad);
-- 
1.9.1
