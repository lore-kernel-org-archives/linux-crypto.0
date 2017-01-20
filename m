From: Ryder Lee <ryder.lee@mediatek.com>
Subject: [PATCH 8/8] crypto: mediatek - add support to GCM mode
Date: Fri, 20 Jan 2017 13:41:15 +0800
Message-ID: <1484890875-57105-9-git-send-email-ryder.lee@mediatek.com>
References: <1484890875-57105-1-git-send-email-ryder.lee@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Ryder Lee <ryder.lee@mediatek.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:56258 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751366AbdATFld (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Jan 2017 00:41:33 -0500
In-Reply-To: <1484890875-57105-1-git-send-email-ryder.lee@mediatek.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds support to the GCM mode.

Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
---
 drivers/crypto/Kconfig                 |   2 +
 drivers/crypto/mediatek/mtk-aes.c      | 369 ++++++++++++++++++++++++++++++++-
 drivers/crypto/mediatek/mtk-platform.h |   2 +
 3 files changed, 369 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index ee5057a..bf7da55 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -557,7 +557,9 @@ config CRYPTO_DEV_MEDIATEK
 	tristate "MediaTek's EIP97 Cryptographic Engine driver"
 	depends on (ARM && ARCH_MEDIATEK) || COMPILE_TEST
 	select CRYPTO_AES
+	select CRYPTO_AEAD
 	select CRYPTO_BLKCIPHER
+	select CRYPTO_CTR
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
 	select CRYPTO_SHA512
diff --git a/drivers/crypto/mediatek/mtk-aes.c b/drivers/crypto/mediatek/mtk-aes.c
index bb5b4ff..3a47cdb 100644
--- a/drivers/crypto/mediatek/mtk-aes.c
+++ b/drivers/crypto/mediatek/mtk-aes.c
@@ -24,16 +24,28 @@
 #define AES_CT_SIZE_ECB		2
 #define AES_CT_SIZE_CBC		3
 #define AES_CT_SIZE_CTR		3
+#define AES_CT_SIZE_GCM_OUT	5
+#define AES_CT_SIZE_GCM_IN	6
 #define AES_CT_CTRL_HDR		cpu_to_le32(0x00220000)
 
 /* AES-CBC/ECB/CTR command token */
 #define AES_CMD0		cpu_to_le32(0x05000000)
 #define AES_CMD1		cpu_to_le32(0x2d060000)
 #define AES_CMD2		cpu_to_le32(0xe4a63806)
+/* AES-GCM command token */
+#define AES_GCM_CMD0		cpu_to_le32(0x0b000000)
+#define AES_GCM_CMD1		cpu_to_le32(0xa0800000)
+#define AES_GCM_CMD2		cpu_to_le32(0x25000010)
+#define AES_GCM_CMD3		cpu_to_le32(0x0f020000)
+#define AES_GCM_CMD4		cpu_to_le32(0x21e60000)
+#define AES_GCM_CMD5		cpu_to_le32(0x40e60000)
+#define AES_GCM_CMD6		cpu_to_le32(0xd0070000)
 
 /* AES transform information word 0 fields */
 #define AES_TFM_BASIC_OUT	cpu_to_le32(0x4 << 0)
 #define AES_TFM_BASIC_IN	cpu_to_le32(0x5 << 0)
+#define AES_TFM_GCM_OUT		cpu_to_le32(0x6 << 0)
+#define AES_TFM_GCM_IN		cpu_to_le32(0xf << 0)
 #define AES_TFM_SIZE(x)		cpu_to_le32((x) << 8)
 #define AES_TFM_128BITS		cpu_to_le32(0xb << 16)
 #define AES_TFM_192BITS		cpu_to_le32(0xd << 16)
@@ -41,15 +53,22 @@
 /* AES transform information word 1 fields */
 #define AES_TFM_ECB		cpu_to_le32(0x0 << 0)
 #define AES_TFM_CBC		cpu_to_le32(0x1 << 0)
+#define AES_TFM_CTR_INIT	cpu_to_le32(0x2 << 0)	/* init counter to 1 */
 #define AES_TFM_CTR_LOAD	cpu_to_le32(0x6 << 0)	/* load/reuse counter */
+#define AES_TFM_3IV		cpu_to_le32(0x7 << 5)	/* using IV 0-2 */
 #define AES_TFM_FULL_IV		cpu_to_le32(0xf << 5)	/* using IV 0-3 */
+#define AES_TFM_IV_CTR_MODE	cpu_to_le32(0x1 << 10)
+#define AES_TFM_ENC_HASH	cpu_to_le32(0x1 << 17)
+#define AES_TFM_GHASH_DIG	cpu_to_le32(0x2 << 21)
+#define AES_TFM_GHASH		cpu_to_le32(0x4 << 23)
 
 /* AES flags */
 #define AES_FLAGS_ECB		BIT(0)
 #define AES_FLAGS_CBC		BIT(1)
 #define AES_FLAGS_CTR		BIT(2)
-#define AES_FLAGS_ENCRYPT	BIT(3)
-#define AES_FLAGS_BUSY		BIT(4)
+#define AES_FLAGS_GCM		BIT(3)
+#define AES_FLAGS_ENCRYPT	BIT(4)
+#define AES_FLAGS_BUSY		BIT(5)
 
 /**
  * Command token(CT) is a set of hardware instructions that
@@ -62,14 +81,23 @@
  * - Commands decoding and control of the engine's data path.
  * - Coordinating hardware data fetch and store operations.
  * - Result token construction and output.
+ *
+ * Memory map of GCM's TFM:
+ * /-----------\
+ * |  AES KEY  | 128/196/256 bits
+ * |-----------|
+ * |  HASH KEY | a string 128 zero bits encrypted using the block cipher
+ * |-----------|
+ * |    IVs    | 4 * 4 bytes
+ * \-----------/
  */
 struct mtk_aes_ct {
-	__le32 cmd[AES_CT_SIZE_CBC];
+	__le32 cmd[AES_CT_SIZE_GCM_IN];
 };
 
 struct mtk_aes_tfm {
 	__le32 ctrl[2];
-	__le32 state[SIZE_IN_WORDS(AES_KEYSIZE_256 + AES_BLOCK_SIZE)];
+	__le32 state[SIZE_IN_WORDS(AES_KEYSIZE_256 + AES_BLOCK_SIZE * 2)];
 };
 
 struct mtk_aes_reqctx {
@@ -103,6 +131,20 @@ struct mtk_aes_ctr_ctx {
 	struct scatterlist dst[2];
 };
 
+struct mtk_aes_gcm_ctx {
+	struct mtk_aes_base_ctx base;
+
+	u32 authsize;
+	size_t textlen;
+
+	struct crypto_skcipher *ctr;
+};
+
+struct mtk_aes_gcm_setkey_result {
+	int err;
+	struct completion completion;
+};
+
 struct mtk_aes_drv {
 	struct list_head dev_list;
 	/* Device list lock */
@@ -251,6 +293,10 @@ static int mtk_aes_xmit(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
 	}
 	res->hdr |= MTK_DESC_LAST;
 
+	/* Prepare enough space for authenticated tag */
+	if (aes->flags & AES_FLAGS_GCM)
+		res->hdr += AES_BLOCK_SIZE;
+
 	/*
 	 * Make sure that all changes to the DMA ring are done before we
 	 * start engine.
@@ -737,6 +783,315 @@ static int mtk_aes_ctr_cra_init(struct crypto_tfm *tfm)
 },
 };
 
+static inline struct mtk_aes_gcm_ctx *
+mtk_aes_gcm_ctx_cast(struct mtk_aes_base_ctx *ctx)
+{
+	return container_of(ctx, struct mtk_aes_gcm_ctx, base);
+}
+
+/* Initialize transform information of GCM mode */
+static void mtk_aes_gcm_info_init(struct mtk_cryp *cryp,
+				  struct mtk_aes_rec *aes,
+				  size_t len)
+{
+	struct aead_request *req = aead_request_cast(aes->areq);
+	struct mtk_aes_base_ctx *ctx = aes->ctx;
+	struct mtk_aes_gcm_ctx *gctx = mtk_aes_gcm_ctx_cast(ctx);
+	const u32 *iv = (const u32 *)req->iv;
+	u32 *iv_state = ctx->tfm.state + ctx->keylen +
+			SIZE_IN_WORDS(AES_BLOCK_SIZE);
+	u32 ivsize = crypto_aead_ivsize(crypto_aead_reqtfm(req));
+	int i;
+
+	ctx->ct_hdr = AES_CT_CTRL_HDR | len;
+
+	ctx->ct.cmd[0] = AES_GCM_CMD0 | cpu_to_le32(req->assoclen);
+	ctx->ct.cmd[1] = AES_GCM_CMD1 | cpu_to_le32(req->assoclen);
+	ctx->ct.cmd[2] = AES_GCM_CMD2;
+	ctx->ct.cmd[3] = AES_GCM_CMD3 | cpu_to_le32(gctx->textlen);
+
+	if (aes->flags & AES_FLAGS_ENCRYPT) {
+		ctx->ct.cmd[4] = AES_GCM_CMD4 | cpu_to_le32(gctx->authsize);
+		ctx->ct_size = AES_CT_SIZE_GCM_OUT;
+		ctx->tfm.ctrl[0] = AES_TFM_GCM_OUT;
+	} else {
+		ctx->ct.cmd[4] = AES_GCM_CMD5 | cpu_to_le32(gctx->authsize);
+		ctx->ct.cmd[5] = AES_GCM_CMD6 | cpu_to_le32(gctx->authsize);
+		ctx->ct_size = AES_CT_SIZE_GCM_IN;
+		ctx->tfm.ctrl[0] = AES_TFM_GCM_IN;
+	}
+
+	if (ctx->keylen == SIZE_IN_WORDS(AES_KEYSIZE_128))
+		ctx->tfm.ctrl[0] |= AES_TFM_128BITS;
+	else if (ctx->keylen == SIZE_IN_WORDS(AES_KEYSIZE_256))
+		ctx->tfm.ctrl[0] |= AES_TFM_256BITS;
+	else
+		ctx->tfm.ctrl[0] |= AES_TFM_192BITS;
+
+	ctx->tfm.ctrl[0] |= AES_TFM_GHASH_DIG | AES_TFM_GHASH |
+			    AES_TFM_SIZE(ctx->keylen + SIZE_IN_WORDS(
+			    AES_BLOCK_SIZE + ivsize));
+	ctx->tfm.ctrl[1] = AES_TFM_CTR_INIT | AES_TFM_IV_CTR_MODE |
+			   AES_TFM_3IV | AES_TFM_ENC_HASH;
+
+	for (i = 0; i < SIZE_IN_WORDS(ivsize); i++)
+		iv_state[i] = cpu_to_le32(iv[i]);
+}
+
+static int mtk_aes_gcm_dma(struct mtk_cryp *cryp, struct mtk_aes_rec *aes,
+			   struct scatterlist *src, struct scatterlist *dst,
+			   size_t len)
+{
+	bool src_aligned, dst_aligned;
+
+	aes->src.sg = src;
+	aes->dst.sg = dst;
+	aes->real_dst = dst;
+
+	src_aligned = mtk_aes_check_aligned(src, len, &aes->src);
+	if (src == dst)
+		dst_aligned = src_aligned;
+	else
+		dst_aligned = mtk_aes_check_aligned(dst, len, &aes->dst);
+
+	if (!src_aligned || !dst_aligned) {
+		if (aes->total > AES_BUF_SIZE)
+			return -ENOMEM;
+
+		if (!src_aligned) {
+			sg_copy_to_buffer(src, sg_nents(src), aes->buf, len);
+			aes->src.sg = &aes->aligned_sg;
+			aes->src.nents = 1;
+			aes->src.remainder = 0;
+		}
+
+		if (!dst_aligned) {
+			aes->dst.sg = &aes->aligned_sg;
+			aes->dst.nents = 1;
+			aes->dst.remainder = 0;
+		}
+
+		sg_init_table(&aes->aligned_sg, 1);
+		sg_set_buf(&aes->aligned_sg, aes->buf, aes->total);
+	}
+
+	mtk_aes_gcm_info_init(cryp, aes, len);
+
+	return mtk_aes_map(cryp, aes);
+}
+
+/* Todo: GMAC */
+static int mtk_aes_gcm_start(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
+{
+	struct mtk_aes_gcm_ctx *gctx = mtk_aes_gcm_ctx_cast(aes->ctx);
+	struct aead_request *req = aead_request_cast(aes->areq);
+	struct mtk_aes_reqctx *rctx = aead_request_ctx(req);
+	u32 len = req->assoclen + req->cryptlen;
+
+	mtk_aes_set_mode(aes, rctx);
+
+	if (aes->flags & AES_FLAGS_ENCRYPT) {
+		u32 tag[4];
+		/* Compute total process length. */
+		aes->total = len + gctx->authsize;
+		/* Compute text length. */
+		gctx->textlen = req->cryptlen;
+		/* Hardware will append authenticated tag to output buffer */
+		scatterwalk_map_and_copy(tag, req->dst, len, gctx->authsize, 1);
+	} else {
+		aes->total = len;
+		gctx->textlen = req->cryptlen - gctx->authsize;
+	}
+	aes->resume = mtk_aes_complete;
+
+	return mtk_aes_gcm_dma(cryp, aes, req->src, req->dst, len);
+}
+
+static int mtk_aes_gcm_crypt(struct aead_request *req, u64 mode)
+{
+	struct mtk_aes_base_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
+	struct mtk_aes_reqctx *rctx = aead_request_ctx(req);
+
+	rctx->mode = AES_FLAGS_GCM | mode;
+
+	return mtk_aes_handle_queue(ctx->cryp, !!(mode & AES_FLAGS_ENCRYPT),
+								&req->base);
+}
+
+static void mtk_gcm_setkey_done(struct crypto_async_request *req, int err)
+{
+	struct mtk_aes_gcm_setkey_result *result = req->data;
+
+	if (err == -EINPROGRESS)
+		return;
+
+	result->err = err;
+	complete(&result->completion);
+}
+
+/*
+ * Because of the hardware limitation, we need to pre-calculate key(H)
+ * for the GHASH operation. The result of the encryption operation
+ * need to be stored in the transform state buffer.
+ */
+static int mtk_aes_gcm_setkey(struct crypto_aead *aead, const u8 *key,
+			      u32 keylen)
+{
+	struct mtk_aes_base_ctx *ctx = crypto_aead_ctx(aead);
+	struct mtk_aes_gcm_ctx *gctx = mtk_aes_gcm_ctx_cast(ctx);
+	struct crypto_skcipher *ctr = gctx->ctr;
+	struct {
+		u32 hash[4];
+		u8 iv[8];
+
+		struct mtk_aes_gcm_setkey_result result;
+
+		struct scatterlist sg[1];
+		struct skcipher_request req;
+	} *data;
+	const u32 *aes_key;
+	u32 *key_state, *hash_state;
+	int err, i;
+
+	if (keylen != AES_KEYSIZE_256 &&
+	    keylen != AES_KEYSIZE_192 &&
+	    keylen != AES_KEYSIZE_128) {
+		crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+
+	key_state = ctx->tfm.state;
+	aes_key = (u32 *)key;
+	ctx->keylen = SIZE_IN_WORDS(keylen);
+
+	for (i = 0; i < ctx->keylen; i++)
+		ctx->tfm.state[i] = cpu_to_le32(aes_key[i]);
+
+	/* Same as crypto_gcm_setkey() from crypto/gcm.c */
+	crypto_skcipher_clear_flags(ctr, CRYPTO_TFM_REQ_MASK);
+	crypto_skcipher_set_flags(ctr, crypto_aead_get_flags(aead) &
+				  CRYPTO_TFM_REQ_MASK);
+	err = crypto_skcipher_setkey(ctr, key, keylen);
+	crypto_aead_set_flags(aead, crypto_skcipher_get_flags(ctr) &
+			      CRYPTO_TFM_RES_MASK);
+	if (err)
+		return err;
+
+	data = kzalloc(sizeof(*data) + crypto_skcipher_reqsize(ctr),
+		       GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	init_completion(&data->result.completion);
+	sg_init_one(data->sg, &data->hash, AES_BLOCK_SIZE);
+	skcipher_request_set_tfm(&data->req, ctr);
+	skcipher_request_set_callback(&data->req, CRYPTO_TFM_REQ_MAY_SLEEP |
+				      CRYPTO_TFM_REQ_MAY_BACKLOG,
+				      mtk_gcm_setkey_done, &data->result);
+	skcipher_request_set_crypt(&data->req, data->sg, data->sg,
+				   AES_BLOCK_SIZE, data->iv);
+
+	err = crypto_skcipher_encrypt(&data->req);
+	if (err == -EINPROGRESS || err == -EBUSY) {
+		err = wait_for_completion_interruptible(
+			&data->result.completion);
+		if (!err)
+			err = data->result.err;
+	}
+	if (err)
+		goto out;
+
+	hash_state = key_state + ctx->keylen;
+
+	for (i = 0; i < 4; i++)
+		hash_state[i] = cpu_to_be32(data->hash[i]);
+out:
+	kzfree(data);
+	return err;
+}
+
+static int mtk_aes_gcm_setauthsize(struct crypto_aead *aead,
+				   u32 authsize)
+{
+	struct mtk_aes_base_ctx *ctx = crypto_aead_ctx(aead);
+	struct mtk_aes_gcm_ctx *gctx = mtk_aes_gcm_ctx_cast(ctx);
+
+	/* Same as crypto_gcm_authsize() from crypto/gcm.c */
+	switch (authsize) {
+	case 8:
+	case 12:
+	case 16:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	gctx->authsize = authsize;
+	return 0;
+}
+
+static int mtk_aes_gcm_encrypt(struct aead_request *req)
+{
+	return mtk_aes_gcm_crypt(req, AES_FLAGS_ENCRYPT);
+}
+
+static int mtk_aes_gcm_decrypt(struct aead_request *req)
+{
+	return mtk_aes_gcm_crypt(req, 0);
+}
+
+static int mtk_aes_gcm_init(struct crypto_aead *aead)
+{
+	struct mtk_aes_gcm_ctx *ctx = crypto_aead_ctx(aead);
+	struct mtk_cryp *cryp = NULL;
+
+	cryp = mtk_aes_find_dev(&ctx->base);
+	if (!cryp) {
+		pr_err("can't find crypto device\n");
+		return -ENODEV;
+	}
+
+	ctx->ctr = crypto_alloc_skcipher("ctr(aes)", 0,
+					 CRYPTO_ALG_ASYNC);
+	if (IS_ERR(ctx->ctr)) {
+		pr_err("Error allocating ctr(aes)\n");
+		return PTR_ERR(ctx->ctr);
+	}
+
+	crypto_aead_set_reqsize(aead, sizeof(struct mtk_aes_reqctx));
+	ctx->base.start = mtk_aes_gcm_start;
+	return 0;
+}
+
+static void mtk_aes_gcm_exit(struct crypto_aead *aead)
+{
+	struct mtk_aes_gcm_ctx *ctx = crypto_aead_ctx(aead);
+
+	crypto_free_skcipher(ctx->ctr);
+}
+
+static struct aead_alg aes_gcm_alg = {
+	.setkey		= mtk_aes_gcm_setkey,
+	.setauthsize	= mtk_aes_gcm_setauthsize,
+	.encrypt	= mtk_aes_gcm_encrypt,
+	.decrypt	= mtk_aes_gcm_decrypt,
+	.init		= mtk_aes_gcm_init,
+	.exit		= mtk_aes_gcm_exit,
+	.ivsize		= 12,
+	.maxauthsize	= AES_BLOCK_SIZE,
+
+	.base = {
+		.cra_name		= "gcm(aes)",
+		.cra_driver_name	= "gcm-aes-mtk",
+		.cra_priority		= 400,
+		.cra_flags		= CRYPTO_ALG_ASYNC,
+		.cra_blocksize		= 1,
+		.cra_ctxsize		= sizeof(struct mtk_aes_gcm_ctx),
+		.cra_alignmask		= 0xf,
+		.cra_module		= THIS_MODULE,
+	},
+};
+
 static void mtk_aes_enc_task(unsigned long data)
 {
 	struct mtk_cryp *cryp = (struct mtk_cryp *)data;
@@ -851,6 +1206,8 @@ static void mtk_aes_unregister_algs(void)
 {
 	int i;
 
+	crypto_unregister_aead(&aes_gcm_alg);
+
 	for (i = 0; i < ARRAY_SIZE(aes_algs); i++)
 		crypto_unregister_alg(&aes_algs[i]);
 }
@@ -865,6 +1222,10 @@ static int mtk_aes_register_algs(void)
 			goto err_aes_algs;
 	}
 
+	err = crypto_register_aead(&aes_gcm_alg);
+	if (err)
+		goto err_aes_algs;
+
 	return 0;
 
 err_aes_algs:
diff --git a/drivers/crypto/mediatek/mtk-platform.h b/drivers/crypto/mediatek/mtk-platform.h
index 7cd5f98..ed6d871 100644
--- a/drivers/crypto/mediatek/mtk-platform.h
+++ b/drivers/crypto/mediatek/mtk-platform.h
@@ -13,8 +13,10 @@
 #define __MTK_PLATFORM_H_
 
 #include <crypto/algapi.h>
+#include <crypto/internal/aead.h>
 #include <crypto/internal/hash.h>
 #include <crypto/scatterwalk.h>
+#include <crypto/skcipher.h>
 #include <linux/crypto.h>
 #include <linux/dma-mapping.h>
 #include <linux/interrupt.h>
-- 
1.9.1
