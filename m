From: Ryder Lee <ryder.lee@mediatek.com>
Subject: [PATCH 8/9] crypto: mediatek - make hardware operation flow more efficient
Date: Mon, 20 Feb 2017 17:27:01 +0800
Message-ID: <1487582822-30393-9-git-send-email-ryder.lee@mediatek.com>
References: <1487582822-30393-1-git-send-email-ryder.lee@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-mediatek@lists.infradead.org>,
        <linux-crypto@vger.kernel.org>, Ryder Lee <ryder.lee@mediatek.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:60294 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752454AbdBTJ1S (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Feb 2017 04:27:18 -0500
In-Reply-To: <1487582822-30393-1-git-send-email-ryder.lee@mediatek.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch refines data structures, which are used to control engine's
data path, to make it more efficient. Hence current change are:

- gathers the broken pieces of structures 'mtk_aes_ct''mtk_aes_tfm'
into struct mtk_aes_info hence avoiding additional DMA-mapping.

- adds 'keymode' in struct mtk_aes_base_ctx. When .setkey() callback is
called, we store keybit setting in keymode. Doing so, there is no need
to check keylen second time in mtk_aes_info_init() / mtk_aes_gcm_info_init().

Besides, this patch also removes unused macro definitions and adds helper
inline function to write security information(key, IV,...) to info->state.

Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
---
 drivers/crypto/mediatek/mtk-aes.c | 263 ++++++++++++++++++--------------------
 drivers/crypto/mediatek/mtk-sha.c |  90 ++++++-------
 2 files changed, 165 insertions(+), 188 deletions(-)

diff --git a/drivers/crypto/mediatek/mtk-aes.c b/drivers/crypto/mediatek/mtk-aes.c
index 8f3efa5..9e845e8 100644
--- a/drivers/crypto/mediatek/mtk-aes.c
+++ b/drivers/crypto/mediatek/mtk-aes.c
@@ -19,13 +19,10 @@
 #define AES_BUF_ORDER		2
 #define AES_BUF_SIZE		((PAGE_SIZE << AES_BUF_ORDER) \
 				& ~(AES_BLOCK_SIZE - 1))
+#define AES_MAX_STATE_BUF_SIZE	SIZE_IN_WORDS(AES_KEYSIZE_256 + \
+				AES_BLOCK_SIZE * 2)
+#define AES_MAX_CT_SIZE		6
 
-/* AES command token size */
-#define AES_CT_SIZE_ECB		2
-#define AES_CT_SIZE_CBC		3
-#define AES_CT_SIZE_CTR		3
-#define AES_CT_SIZE_GCM_OUT	5
-#define AES_CT_SIZE_GCM_IN	6
 #define AES_CT_CTRL_HDR		cpu_to_le32(0x00220000)
 
 /* AES-CBC/ECB/CTR command token */
@@ -50,6 +47,8 @@
 #define AES_TFM_128BITS		cpu_to_le32(0xb << 16)
 #define AES_TFM_192BITS		cpu_to_le32(0xd << 16)
 #define AES_TFM_256BITS		cpu_to_le32(0xf << 16)
+#define AES_TFM_GHASH_DIGEST	cpu_to_le32(0x2 << 21)
+#define AES_TFM_GHASH		cpu_to_le32(0x4 << 23)
 /* AES transform information word 1 fields */
 #define AES_TFM_ECB		cpu_to_le32(0x0 << 0)
 #define AES_TFM_CBC		cpu_to_le32(0x1 << 0)
@@ -59,10 +58,9 @@
 #define AES_TFM_FULL_IV		cpu_to_le32(0xf << 5)	/* using IV 0-3 */
 #define AES_TFM_IV_CTR_MODE	cpu_to_le32(0x1 << 10)
 #define AES_TFM_ENC_HASH	cpu_to_le32(0x1 << 17)
-#define AES_TFM_GHASH_DIG	cpu_to_le32(0x2 << 21)
-#define AES_TFM_GHASH		cpu_to_le32(0x4 << 23)
 
 /* AES flags */
+#define AES_FLAGS_CIPHER_MSK	GENMASK(2, 0)
 #define AES_FLAGS_ECB		BIT(0)
 #define AES_FLAGS_CBC		BIT(1)
 #define AES_FLAGS_CTR		BIT(2)
@@ -73,18 +71,12 @@
 #define AES_AUTH_TAG_ERR	cpu_to_le32(BIT(26))
 
 /**
- * Command token(CT) is a set of hardware instructions that
- * are used to control engine's processing flow of AES.
- *
- * Transform information(TFM) is used to define AES state and
- * contains all keys and initial vectors.
- *
- * The engine requires CT and TFM to do:
- * - Commands decoding and control of the engine's data path.
- * - Coordinating hardware data fetch and store operations.
- * - Result token construction and output.
+ * mtk_aes_info - hardware information of AES
+ * @cmd:	command token, hardware instruction
+ * @tfm:	transform state of cipher algorithm.
+ * @state:	contains keys and initial vectors.
  *
- * Memory map of GCM's TFM:
+ * Memory layout of GCM buffer:
  * /-----------\
  * |  AES KEY  | 128/196/256 bits
  * |-----------|
@@ -92,14 +84,16 @@
  * |-----------|
  * |    IVs    | 4 * 4 bytes
  * \-----------/
+ *
+ * The engine requires all these info to do:
+ * - Commands decoding and control of the engine's data path.
+ * - Coordinating hardware data fetch and store operations.
+ * - Result token construction and output.
  */
-struct mtk_aes_ct {
-	__le32 cmd[AES_CT_SIZE_GCM_IN];
-};
-
-struct mtk_aes_tfm {
-	__le32 ctrl[2];
-	__le32 state[SIZE_IN_WORDS(AES_KEYSIZE_256 + AES_BLOCK_SIZE * 2)];
+struct mtk_aes_info {
+	__le32 cmd[AES_MAX_CT_SIZE];
+	__le32 tfm[2];
+	__le32 state[AES_MAX_STATE_BUF_SIZE];
 };
 
 struct mtk_aes_reqctx {
@@ -109,11 +103,12 @@ struct mtk_aes_reqctx {
 struct mtk_aes_base_ctx {
 	struct mtk_cryp *cryp;
 	u32 keylen;
+	__le32 keymode;
+
 	mtk_aes_fn start;
 
-	struct mtk_aes_ct ct;
+	struct mtk_aes_info info;
 	dma_addr_t ct_dma;
-	struct mtk_aes_tfm tfm;
 	dma_addr_t tfm_dma;
 
 	__le32 ct_hdr;
@@ -250,6 +245,22 @@ static inline void mtk_aes_restore_sg(const struct mtk_aes_dma *dma)
 	sg->length += dma->remainder;
 }
 
+static inline void mtk_aes_write_state_le(__le32 *dst, const u32 *src, u32 size)
+{
+	int i;
+
+	for (i = 0; i < SIZE_IN_WORDS(size); i++)
+		dst[i] = cpu_to_le32(src[i]);
+}
+
+static inline void mtk_aes_write_state_be(__be32 *dst, const u32 *src, u32 size)
+{
+	int i;
+
+	for (i = 0; i < SIZE_IN_WORDS(size); i++)
+		dst[i] = cpu_to_be32(src[i]);
+}
+
 static inline int mtk_aes_complete(struct mtk_cryp *cryp,
 				   struct mtk_aes_rec *aes,
 				   int err)
@@ -331,9 +342,7 @@ static void mtk_aes_unmap(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
 {
 	struct mtk_aes_base_ctx *ctx = aes->ctx;
 
-	dma_unmap_single(cryp->dev, ctx->ct_dma, sizeof(ctx->ct),
-			 DMA_TO_DEVICE);
-	dma_unmap_single(cryp->dev, ctx->tfm_dma, sizeof(ctx->tfm),
+	dma_unmap_single(cryp->dev, ctx->ct_dma, sizeof(ctx->info),
 			 DMA_TO_DEVICE);
 
 	if (aes->src.sg == aes->dst.sg) {
@@ -364,16 +373,14 @@ static void mtk_aes_unmap(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
 static int mtk_aes_map(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
 {
 	struct mtk_aes_base_ctx *ctx = aes->ctx;
+	struct mtk_aes_info *info = &ctx->info;
 
-	ctx->ct_dma = dma_map_single(cryp->dev, &ctx->ct, sizeof(ctx->ct),
+	ctx->ct_dma = dma_map_single(cryp->dev, info, sizeof(*info),
 				     DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(cryp->dev, ctx->ct_dma)))
 		goto exit;
 
-	ctx->tfm_dma = dma_map_single(cryp->dev, &ctx->tfm, sizeof(ctx->tfm),
-				      DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(cryp->dev, ctx->tfm_dma)))
-		goto tfm_map_err;
+	ctx->tfm_dma = ctx->ct_dma + sizeof(info->cmd);
 
 	if (aes->src.sg == aes->dst.sg) {
 		aes->src.sg_len = dma_map_sg(cryp->dev, aes->src.sg,
@@ -400,11 +407,7 @@ static int mtk_aes_map(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
 	return mtk_aes_xmit(cryp, aes);
 
 sg_map_err:
-	dma_unmap_single(cryp->dev, ctx->tfm_dma, sizeof(ctx->tfm),
-			 DMA_TO_DEVICE);
-tfm_map_err:
-	dma_unmap_single(cryp->dev, ctx->ct_dma, sizeof(ctx->ct),
-			 DMA_TO_DEVICE);
+	dma_unmap_single(cryp->dev, ctx->ct_dma, sizeof(*info), DMA_TO_DEVICE);
 exit:
 	return mtk_aes_complete(cryp, aes, -EINVAL);
 }
@@ -415,50 +418,43 @@ static void mtk_aes_info_init(struct mtk_cryp *cryp, struct mtk_aes_rec *aes,
 {
 	struct ablkcipher_request *req = ablkcipher_request_cast(aes->areq);
 	struct mtk_aes_base_ctx *ctx = aes->ctx;
+	struct mtk_aes_info *info = &ctx->info;
+	u32 cnt = 0;
 
 	ctx->ct_hdr = AES_CT_CTRL_HDR | cpu_to_le32(len);
-	ctx->ct.cmd[0] = AES_CMD0 | cpu_to_le32(len);
-	ctx->ct.cmd[1] = AES_CMD1;
+	info->cmd[cnt++] = AES_CMD0 | cpu_to_le32(len);
+	info->cmd[cnt++] = AES_CMD1;
 
+	info->tfm[0] = AES_TFM_SIZE(ctx->keylen) | ctx->keymode;
 	if (aes->flags & AES_FLAGS_ENCRYPT)
-		ctx->tfm.ctrl[0] = AES_TFM_BASIC_OUT;
+		info->tfm[0] |= AES_TFM_BASIC_OUT;
 	else
-		ctx->tfm.ctrl[0] = AES_TFM_BASIC_IN;
+		info->tfm[0] |= AES_TFM_BASIC_IN;
 
-	if (ctx->keylen == SIZE_IN_WORDS(AES_KEYSIZE_128))
-		ctx->tfm.ctrl[0] |= AES_TFM_128BITS;
-	else if (ctx->keylen == SIZE_IN_WORDS(AES_KEYSIZE_256))
-		ctx->tfm.ctrl[0] |= AES_TFM_256BITS;
-	else
-		ctx->tfm.ctrl[0] |= AES_TFM_192BITS;
-
-	if (aes->flags & AES_FLAGS_CBC) {
-		const u32 *iv = (const u32 *)req->info;
-		u32 *iv_state = ctx->tfm.state + ctx->keylen;
-		int i;
-
-		ctx->tfm.ctrl[0] |= AES_TFM_SIZE(ctx->keylen +
-				    SIZE_IN_WORDS(AES_BLOCK_SIZE));
-		ctx->tfm.ctrl[1] = AES_TFM_CBC | AES_TFM_FULL_IV;
-
-		for (i = 0; i < SIZE_IN_WORDS(AES_BLOCK_SIZE); i++)
-			iv_state[i] = cpu_to_le32(iv[i]);
-
-		ctx->ct.cmd[2] = AES_CMD2;
-		ctx->ct_size = AES_CT_SIZE_CBC;
-	} else if (aes->flags & AES_FLAGS_ECB) {
-		ctx->tfm.ctrl[0] |= AES_TFM_SIZE(ctx->keylen);
-		ctx->tfm.ctrl[1] = AES_TFM_ECB;
-
-		ctx->ct_size = AES_CT_SIZE_ECB;
-	} else if (aes->flags & AES_FLAGS_CTR) {
-		ctx->tfm.ctrl[0] |= AES_TFM_SIZE(ctx->keylen +
-				    SIZE_IN_WORDS(AES_BLOCK_SIZE));
-		ctx->tfm.ctrl[1] = AES_TFM_CTR_LOAD | AES_TFM_FULL_IV;
-
-		ctx->ct.cmd[2] = AES_CMD2;
-		ctx->ct_size = AES_CT_SIZE_CTR;
+	switch (aes->flags & AES_FLAGS_CIPHER_MSK) {
+	case AES_FLAGS_CBC:
+		info->tfm[1] = AES_TFM_CBC;
+		break;
+	case AES_FLAGS_ECB:
+		info->tfm[1] = AES_TFM_ECB;
+		goto ecb;
+	case AES_FLAGS_CTR:
+		info->tfm[1] = AES_TFM_CTR_LOAD;
+		goto ctr;
+
+	default:
+		/* Should not happen... */
+		return;
 	}
+
+	mtk_aes_write_state_le(info->state + ctx->keylen, req->info,
+			       AES_BLOCK_SIZE);
+ctr:
+	info->tfm[0] += AES_TFM_SIZE(SIZE_IN_WORDS(AES_BLOCK_SIZE));
+	info->tfm[1] |= AES_TFM_FULL_IV;
+	info->cmd[cnt++] = AES_CMD2;
+ecb:
+	ctx->ct_size = cnt;
 }
 
 static int mtk_aes_dma(struct mtk_cryp *cryp, struct mtk_aes_rec *aes,
@@ -572,8 +568,7 @@ static int mtk_aes_ctr_transfer(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
 	struct mtk_aes_ctr_ctx *cctx = mtk_aes_ctr_ctx_cast(ctx);
 	struct ablkcipher_request *req = ablkcipher_request_cast(aes->areq);
 	struct scatterlist *src, *dst;
-	int i;
-	u32 start, end, ctr, blocks, *iv_state;
+	u32 start, end, ctr, blocks;
 	size_t datalen;
 	bool fragmented = false;
 
@@ -602,9 +597,8 @@ static int mtk_aes_ctr_transfer(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
 	       scatterwalk_ffwd(cctx->dst, req->dst, cctx->offset));
 
 	/* Write IVs into transform state buffer. */
-	iv_state = ctx->tfm.state + ctx->keylen;
-	for (i = 0; i < SIZE_IN_WORDS(AES_BLOCK_SIZE); i++)
-		iv_state[i] = cpu_to_le32(cctx->iv[i]);
+	mtk_aes_write_state_le(ctx->info.state + ctx->keylen, cctx->iv,
+			       AES_BLOCK_SIZE);
 
 	if (unlikely(fragmented)) {
 	/*
@@ -639,21 +633,25 @@ static int mtk_aes_setkey(struct crypto_ablkcipher *tfm,
 			  const u8 *key, u32 keylen)
 {
 	struct mtk_aes_base_ctx *ctx = crypto_ablkcipher_ctx(tfm);
-	const u32 *aes_key = (const u32 *)key;
-	u32 *key_state = ctx->tfm.state;
-	int i;
 
-	if (keylen != AES_KEYSIZE_128 &&
-	    keylen != AES_KEYSIZE_192 &&
-	    keylen != AES_KEYSIZE_256) {
+	switch (keylen) {
+	case AES_KEYSIZE_128:
+		ctx->keymode = AES_TFM_128BITS;
+		break;
+	case AES_KEYSIZE_192:
+		ctx->keymode = AES_TFM_192BITS;
+		break;
+	case AES_KEYSIZE_256:
+		ctx->keymode = AES_TFM_256BITS;
+		break;
+
+	default:
 		crypto_ablkcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
 	}
 
 	ctx->keylen = SIZE_IN_WORDS(keylen);
-
-	for (i = 0; i < ctx->keylen; i++)
-		key_state[i] = cpu_to_le32(aes_key[i]);
+	mtk_aes_write_state_le(ctx->info.state, (const u32 *)key, keylen);
 
 	return 0;
 }
@@ -825,45 +823,35 @@ static void mtk_aes_gcm_info_init(struct mtk_cryp *cryp,
 	struct aead_request *req = aead_request_cast(aes->areq);
 	struct mtk_aes_base_ctx *ctx = aes->ctx;
 	struct mtk_aes_gcm_ctx *gctx = mtk_aes_gcm_ctx_cast(ctx);
-	const u32 *iv = (const u32 *)req->iv;
-	u32 *iv_state = ctx->tfm.state + ctx->keylen +
-			SIZE_IN_WORDS(AES_BLOCK_SIZE);
+	struct mtk_aes_info *info = &ctx->info;
 	u32 ivsize = crypto_aead_ivsize(crypto_aead_reqtfm(req));
-	int i;
+	u32 cnt = 0;
 
 	ctx->ct_hdr = AES_CT_CTRL_HDR | len;
 
-	ctx->ct.cmd[0] = AES_GCM_CMD0 | cpu_to_le32(req->assoclen);
-	ctx->ct.cmd[1] = AES_GCM_CMD1 | cpu_to_le32(req->assoclen);
-	ctx->ct.cmd[2] = AES_GCM_CMD2;
-	ctx->ct.cmd[3] = AES_GCM_CMD3 | cpu_to_le32(gctx->textlen);
+	info->cmd[cnt++] = AES_GCM_CMD0 | cpu_to_le32(req->assoclen);
+	info->cmd[cnt++] = AES_GCM_CMD1 | cpu_to_le32(req->assoclen);
+	info->cmd[cnt++] = AES_GCM_CMD2;
+	info->cmd[cnt++] = AES_GCM_CMD3 | cpu_to_le32(gctx->textlen);
 
 	if (aes->flags & AES_FLAGS_ENCRYPT) {
-		ctx->ct.cmd[4] = AES_GCM_CMD4 | cpu_to_le32(gctx->authsize);
-		ctx->ct_size = AES_CT_SIZE_GCM_OUT;
-		ctx->tfm.ctrl[0] = AES_TFM_GCM_OUT;
+		info->cmd[cnt++] = AES_GCM_CMD4 | cpu_to_le32(gctx->authsize);
+		info->tfm[0] = AES_TFM_GCM_OUT;
 	} else {
-		ctx->ct.cmd[4] = AES_GCM_CMD5 | cpu_to_le32(gctx->authsize);
-		ctx->ct.cmd[5] = AES_GCM_CMD6 | cpu_to_le32(gctx->authsize);
-		ctx->ct_size = AES_CT_SIZE_GCM_IN;
-		ctx->tfm.ctrl[0] = AES_TFM_GCM_IN;
+		info->cmd[cnt++] = AES_GCM_CMD5 | cpu_to_le32(gctx->authsize);
+		info->cmd[cnt++] = AES_GCM_CMD6 | cpu_to_le32(gctx->authsize);
+		info->tfm[0] = AES_TFM_GCM_IN;
 	}
+	ctx->ct_size = cnt;
 
-	if (ctx->keylen == SIZE_IN_WORDS(AES_KEYSIZE_128))
-		ctx->tfm.ctrl[0] |= AES_TFM_128BITS;
-	else if (ctx->keylen == SIZE_IN_WORDS(AES_KEYSIZE_256))
-		ctx->tfm.ctrl[0] |= AES_TFM_256BITS;
-	else
-		ctx->tfm.ctrl[0] |= AES_TFM_192BITS;
-
-	ctx->tfm.ctrl[0] |= AES_TFM_GHASH_DIG | AES_TFM_GHASH |
-			    AES_TFM_SIZE(ctx->keylen + SIZE_IN_WORDS(
-			    AES_BLOCK_SIZE + ivsize));
-	ctx->tfm.ctrl[1] = AES_TFM_CTR_INIT | AES_TFM_IV_CTR_MODE |
-			   AES_TFM_3IV | AES_TFM_ENC_HASH;
+	info->tfm[0] |= AES_TFM_GHASH_DIGEST | AES_TFM_GHASH | AES_TFM_SIZE(
+			ctx->keylen + SIZE_IN_WORDS(AES_BLOCK_SIZE + ivsize)) |
+			ctx->keymode;
+	info->tfm[1] = AES_TFM_CTR_INIT | AES_TFM_IV_CTR_MODE | AES_TFM_3IV |
+		       AES_TFM_ENC_HASH;
 
-	for (i = 0; i < SIZE_IN_WORDS(ivsize); i++)
-		iv_state[i] = cpu_to_le32(iv[i]);
+	mtk_aes_write_state_le(info->state + ctx->keylen + SIZE_IN_WORDS(
+			       AES_BLOCK_SIZE), (const u32 *)req->iv, ivsize);
 }
 
 static int mtk_aes_gcm_dma(struct mtk_cryp *cryp, struct mtk_aes_rec *aes,
@@ -979,24 +967,26 @@ static int mtk_aes_gcm_setkey(struct crypto_aead *aead, const u8 *key,
 		struct scatterlist sg[1];
 		struct skcipher_request req;
 	} *data;
-	const u32 *aes_key;
-	u32 *key_state, *hash_state;
-	int err, i;
+	int err;
 
-	if (keylen != AES_KEYSIZE_256 &&
-	    keylen != AES_KEYSIZE_192 &&
-	    keylen != AES_KEYSIZE_128) {
+	switch (keylen) {
+	case AES_KEYSIZE_128:
+		ctx->keymode = AES_TFM_128BITS;
+		break;
+	case AES_KEYSIZE_192:
+		ctx->keymode = AES_TFM_192BITS;
+		break;
+	case AES_KEYSIZE_256:
+		ctx->keymode = AES_TFM_256BITS;
+		break;
+
+	default:
 		crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
 	}
 
-	key_state = ctx->tfm.state;
-	aes_key = (u32 *)key;
 	ctx->keylen = SIZE_IN_WORDS(keylen);
 
-	for (i = 0; i < ctx->keylen; i++)
-		ctx->tfm.state[i] = cpu_to_le32(aes_key[i]);
-
 	/* Same as crypto_gcm_setkey() from crypto/gcm.c */
 	crypto_skcipher_clear_flags(ctr, CRYPTO_TFM_REQ_MASK);
 	crypto_skcipher_set_flags(ctr, crypto_aead_get_flags(aead) &
@@ -1031,10 +1021,11 @@ static int mtk_aes_gcm_setkey(struct crypto_aead *aead, const u8 *key,
 	if (err)
 		goto out;
 
-	hash_state = key_state + ctx->keylen;
-
-	for (i = 0; i < 4; i++)
-		hash_state[i] = cpu_to_be32(data->hash[i]);
+	/* Write key into state buffer */
+	mtk_aes_write_state_le(ctx->info.state, (const u32 *)key, keylen);
+	/* Write key(H) into state buffer */
+	mtk_aes_write_state_be(ctx->info.state + ctx->keylen, data->hash,
+			       AES_BLOCK_SIZE);
 out:
 	kzfree(data);
 	return err;
diff --git a/drivers/crypto/mediatek/mtk-sha.c b/drivers/crypto/mediatek/mtk-sha.c
index dd3582b..2226f12 100644
--- a/drivers/crypto/mediatek/mtk-sha.c
+++ b/drivers/crypto/mediatek/mtk-sha.c
@@ -23,6 +23,7 @@
 #define SHA_OP_FINAL		2
 
 #define SHA_DATA_LEN_MSK	cpu_to_le32(GENMASK(16, 0))
+#define SHA_MAX_DIGEST_BUF_SIZE	32
 
 /* SHA command token */
 #define SHA_CT_SIZE		5
@@ -33,7 +34,6 @@
 
 /* SHA transform information */
 #define SHA_TFM_HASH		cpu_to_le32(0x2 << 0)
-#define SHA_TFM_INNER_DIG	cpu_to_le32(0x1 << 21)
 #define SHA_TFM_SIZE(x)		cpu_to_le32((x) << 8)
 #define SHA_TFM_START		cpu_to_le32(0x1 << 4)
 #define SHA_TFM_CONTINUE	cpu_to_le32(0x1 << 5)
@@ -60,31 +60,17 @@
 #define SHA_FLAGS_PAD		BIT(10)
 
 /**
- * mtk_sha_ct is a set of hardware instructions(command token)
- * that are used to control engine's processing flow of SHA,
- * and it contains the first two words of transform state.
+ * mtk_sha_info - hardware information of AES
+ * @cmd:	command token, hardware instruction
+ * @tfm:	transform state of cipher algorithm.
+ * @state:	contains keys and initial vectors.
+ *
  */
-struct mtk_sha_ct {
+struct mtk_sha_info {
 	__le32 ctrl[2];
 	__le32 cmd[3];
-};
-
-/**
- * mtk_sha_tfm is used to define SHA transform state
- * and store result digest that produced by engine.
- */
-struct mtk_sha_tfm {
-	__le32 ctrl[2];
-	__le32 digest[SIZE_IN_WORDS(SHA512_DIGEST_SIZE)];
-};
-
-/**
- * mtk_sha_info consists of command token and transform state
- * of SHA, its role is similar to mtk_aes_info.
- */
-struct mtk_sha_info {
-	struct mtk_sha_ct ct;
-	struct mtk_sha_tfm tfm;
+	__le32 tfm[2];
+	__le32 digest[SHA_MAX_DIGEST_BUF_SIZE];
 };
 
 struct mtk_sha_reqctx {
@@ -93,7 +79,6 @@ struct mtk_sha_reqctx {
 	unsigned long op;
 
 	u64 digcnt;
-	bool start;
 	size_t bufcnt;
 	dma_addr_t dma_addr;
 
@@ -265,7 +250,9 @@ static void mtk_sha_fill_padding(struct mtk_sha_reqctx *ctx, u32 len)
 	bits[1] = cpu_to_be64(size << 3);
 	bits[0] = cpu_to_be64(size >> 61);
 
-	if (ctx->flags & (SHA_FLAGS_SHA384 | SHA_FLAGS_SHA512)) {
+	switch (ctx->flags & SHA_FLAGS_ALGO_MSK) {
+	case SHA_FLAGS_SHA384:
+	case SHA_FLAGS_SHA512:
 		index = ctx->bufcnt & 0x7f;
 		padlen = (index < 112) ? (112 - index) : ((128 + 112) - index);
 		*(ctx->buffer + ctx->bufcnt) = 0x80;
@@ -273,7 +260,9 @@ static void mtk_sha_fill_padding(struct mtk_sha_reqctx *ctx, u32 len)
 		memcpy(ctx->buffer + ctx->bufcnt + padlen, bits, 16);
 		ctx->bufcnt += padlen + 16;
 		ctx->flags |= SHA_FLAGS_PAD;
-	} else {
+		break;
+
+	default:
 		index = ctx->bufcnt & 0x3f;
 		padlen = (index < 56) ? (56 - index) : ((64 + 56) - index);
 		*(ctx->buffer + ctx->bufcnt) = 0x80;
@@ -281,36 +270,35 @@ static void mtk_sha_fill_padding(struct mtk_sha_reqctx *ctx, u32 len)
 		memcpy(ctx->buffer + ctx->bufcnt + padlen, &bits[1], 8);
 		ctx->bufcnt += padlen + 8;
 		ctx->flags |= SHA_FLAGS_PAD;
+		break;
 	}
 }
 
 /* Initialize basic transform information of SHA */
 static void mtk_sha_info_init(struct mtk_sha_reqctx *ctx)
 {
-	struct mtk_sha_ct *ct = &ctx->info.ct;
-	struct mtk_sha_tfm *tfm = &ctx->info.tfm;
+	struct mtk_sha_info *info = &ctx->info;
 
 	ctx->ct_hdr = SHA_CT_CTRL_HDR;
 	ctx->ct_size = SHA_CT_SIZE;
 
-	tfm->ctrl[0] = SHA_TFM_HASH | SHA_TFM_INNER_DIG |
-		       SHA_TFM_SIZE(SIZE_IN_WORDS(ctx->ds));
+	info->tfm[0] = SHA_TFM_HASH | SHA_TFM_SIZE(SIZE_IN_WORDS(ctx->ds));
 
 	switch (ctx->flags & SHA_FLAGS_ALGO_MSK) {
 	case SHA_FLAGS_SHA1:
-		tfm->ctrl[0] |= SHA_TFM_SHA1;
+		info->tfm[0] |= SHA_TFM_SHA1;
 		break;
 	case SHA_FLAGS_SHA224:
-		tfm->ctrl[0] |= SHA_TFM_SHA224;
+		info->tfm[0] |= SHA_TFM_SHA224;
 		break;
 	case SHA_FLAGS_SHA256:
-		tfm->ctrl[0] |= SHA_TFM_SHA256;
+		info->tfm[0] |= SHA_TFM_SHA256;
 		break;
 	case SHA_FLAGS_SHA384:
-		tfm->ctrl[0] |= SHA_TFM_SHA384;
+		info->tfm[0] |= SHA_TFM_SHA384;
 		break;
 	case SHA_FLAGS_SHA512:
-		tfm->ctrl[0] |= SHA_TFM_SHA512;
+		info->tfm[0] |= SHA_TFM_SHA512;
 		break;
 
 	default:
@@ -318,13 +306,13 @@ static void mtk_sha_info_init(struct mtk_sha_reqctx *ctx)
 		return;
 	}
 
-	tfm->ctrl[1] = SHA_TFM_HASH_STORE;
-	ct->ctrl[0] = tfm->ctrl[0] | SHA_TFM_CONTINUE | SHA_TFM_START;
-	ct->ctrl[1] = tfm->ctrl[1];
+	info->tfm[1] = SHA_TFM_HASH_STORE;
+	info->ctrl[0] = info->tfm[0] | SHA_TFM_CONTINUE | SHA_TFM_START;
+	info->ctrl[1] = info->tfm[1];
 
-	ct->cmd[0] = SHA_CMD0;
-	ct->cmd[1] = SHA_CMD1;
-	ct->cmd[2] = SHA_CMD2 | SHA_TFM_DIGEST(SIZE_IN_WORDS(ctx->ds));
+	info->cmd[0] = SHA_CMD0;
+	info->cmd[1] = SHA_CMD1;
+	info->cmd[2] = SHA_CMD2 | SHA_TFM_DIGEST(SIZE_IN_WORDS(ctx->ds));
 }
 
 /*
@@ -337,17 +325,15 @@ static int mtk_sha_info_update(struct mtk_cryp *cryp,
 {
 	struct mtk_sha_reqctx *ctx = ahash_request_ctx(sha->req);
 	struct mtk_sha_info *info = &ctx->info;
-	struct mtk_sha_ct *ct = &info->ct;
-
-	if (ctx->start)
-		ctx->start = false;
-	else
-		ct->ctrl[0] &= ~SHA_TFM_START;
 
 	ctx->ct_hdr &= ~SHA_DATA_LEN_MSK;
 	ctx->ct_hdr |= cpu_to_le32(len1 + len2);
-	ct->cmd[0] &= ~SHA_DATA_LEN_MSK;
-	ct->cmd[0] |= cpu_to_le32(len1 + len2);
+	info->cmd[0] &= ~SHA_DATA_LEN_MSK;
+	info->cmd[0] |= cpu_to_le32(len1 + len2);
+
+	/* Setting SHA_TFM_START only for the first iteration */
+	if (ctx->digcnt)
+		info->ctrl[0] &= ~SHA_TFM_START;
 
 	ctx->digcnt += len1;
 
@@ -357,7 +343,8 @@ static int mtk_sha_info_update(struct mtk_cryp *cryp,
 		dev_err(cryp->dev, "dma %zu bytes error\n", sizeof(*info));
 		return -EINVAL;
 	}
-	ctx->tfm_dma = ctx->ct_dma + sizeof(*ct);
+
+	ctx->tfm_dma = ctx->ct_dma + sizeof(info->ctrl) + sizeof(info->cmd);
 
 	return 0;
 }
@@ -422,7 +409,6 @@ static int mtk_sha_init(struct ahash_request *req)
 	ctx->bufcnt = 0;
 	ctx->digcnt = 0;
 	ctx->buffer = tctx->buf;
-	ctx->start = true;
 
 	if (tctx->flags & SHA_FLAGS_HMAC) {
 		struct mtk_sha_hmac_ctx *bctx = tctx->base;
@@ -635,7 +621,7 @@ static int mtk_sha_final_req(struct mtk_cryp *cryp,
 static int mtk_sha_finish(struct ahash_request *req)
 {
 	struct mtk_sha_reqctx *ctx = ahash_request_ctx(req);
-	u32 *digest = ctx->info.tfm.digest;
+	__le32 *digest = ctx->info.digest;
 	u32 *result = (u32 *)req->result;
 	int i;
 
-- 
1.9.1
