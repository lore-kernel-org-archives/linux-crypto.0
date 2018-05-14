From: Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [PATCH v2 08/10] crypto: inside-secure - authenc(hmac(sha256),cbc(aes)) support
Date: Mon, 14 May 2018 15:11:02 +0200
Message-ID: <20180514131104.25552-9-antoine.tenart@bootlin.com>
References: <20180514131104.25552-1-antoine.tenart@bootlin.com>
Cc: Antoine Tenart <antoine.tenart@bootlin.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, maxime.chevallier@bootlin.com,
        gregory.clement@bootlin.com, miquel.raynal@bootlin.com,
        nadavh@marvell.com, oferh@marvell.com, igall@marvell.com
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180514131104.25552-1-antoine.tenart@bootlin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch adds support for the first AEAD algorithm in the Inside
Secure SafeXcel driver, authenc(hmac(sha256),cbc(aes)). As this is the
first AEAD algorithm added to this driver, common AEAD functions are
added as well.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/crypto/Kconfig                        |   1 +
 drivers/crypto/inside-secure/safexcel.c       |   9 +
 drivers/crypto/inside-secure/safexcel.h       |  27 +-
 .../crypto/inside-secure/safexcel_cipher.c    | 335 +++++++++++++++++-
 drivers/crypto/inside-secure/safexcel_hash.c  |  14 +-
 5 files changed, 353 insertions(+), 33 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index d1ea1a07cecb..d2cabd842654 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -691,6 +691,7 @@ config CRYPTO_DEV_SAFEXCEL
 	depends on HAS_DMA && OF
 	depends on (ARM64 && ARCH_MVEBU) || (COMPILE_TEST && 64BIT)
 	select CRYPTO_AES
+	select CRYPTO_AUTHENC
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_HASH
 	select CRYPTO_HMAC
diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 87e6d1a63886..8c963ef0953a 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -20,6 +20,7 @@
 #include <linux/platform_device.h>
 #include <linux/workqueue.h>
 
+#include <crypto/internal/aead.h>
 #include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
 
@@ -352,6 +353,7 @@ static int safexcel_hw_init(struct safexcel_crypto_priv *priv)
 	/* H/W capabilities selection */
 	val = EIP197_FUNCTION_RSVD;
 	val |= EIP197_PROTOCOL_ENCRYPT_ONLY | EIP197_PROTOCOL_HASH_ONLY;
+	val |= EIP197_PROTOCOL_ENCRYPT_HASH | EIP197_PROTOCOL_HASH_DECRYPT;
 	val |= EIP197_ALG_AES_ECB | EIP197_ALG_AES_CBC;
 	val |= EIP197_ALG_SHA1 | EIP197_ALG_HMAC_SHA1;
 	val |= EIP197_ALG_SHA2 | EIP197_ALG_HMAC_SHA2;
@@ -791,6 +793,7 @@ static struct safexcel_alg_template *safexcel_algs[] = {
 	&safexcel_alg_hmac_sha1,
 	&safexcel_alg_hmac_sha224,
 	&safexcel_alg_hmac_sha256,
+	&safexcel_alg_authenc_hmac_sha256_cbc_aes,
 };
 
 static int safexcel_register_algorithms(struct safexcel_crypto_priv *priv)
@@ -802,6 +805,8 @@ static int safexcel_register_algorithms(struct safexcel_crypto_priv *priv)
 
 		if (safexcel_algs[i]->type == SAFEXCEL_ALG_TYPE_SKCIPHER)
 			ret = crypto_register_skcipher(&safexcel_algs[i]->alg.skcipher);
+		else if (safexcel_algs[i]->type == SAFEXCEL_ALG_TYPE_AEAD)
+			ret = crypto_register_aead(&safexcel_algs[i]->alg.aead);
 		else
 			ret = crypto_register_ahash(&safexcel_algs[i]->alg.ahash);
 
@@ -815,6 +820,8 @@ static int safexcel_register_algorithms(struct safexcel_crypto_priv *priv)
 	for (j = 0; j < i; j++) {
 		if (safexcel_algs[j]->type == SAFEXCEL_ALG_TYPE_SKCIPHER)
 			crypto_unregister_skcipher(&safexcel_algs[j]->alg.skcipher);
+		else if (safexcel_algs[j]->type == SAFEXCEL_ALG_TYPE_AEAD)
+			crypto_unregister_aead(&safexcel_algs[j]->alg.aead);
 		else
 			crypto_unregister_ahash(&safexcel_algs[j]->alg.ahash);
 	}
@@ -829,6 +836,8 @@ static void safexcel_unregister_algorithms(struct safexcel_crypto_priv *priv)
 	for (i = 0; i < ARRAY_SIZE(safexcel_algs); i++) {
 		if (safexcel_algs[i]->type == SAFEXCEL_ALG_TYPE_SKCIPHER)
 			crypto_unregister_skcipher(&safexcel_algs[i]->alg.skcipher);
+		else if (safexcel_algs[i]->type == SAFEXCEL_ALG_TYPE_AEAD)
+			crypto_unregister_aead(&safexcel_algs[i]->alg.aead);
 		else
 			crypto_unregister_ahash(&safexcel_algs[i]->alg.ahash);
 	}
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index dce02bf92dff..ae113c14caea 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -11,8 +11,10 @@
 #ifndef __SAFEXCEL_H__
 #define __SAFEXCEL_H__
 
+#include <crypto/aead.h>
 #include <crypto/algapi.h>
 #include <crypto/internal/hash.h>
+#include <crypto/sha.h>
 #include <crypto/skcipher.h>
 
 #define EIP197_HIA_VERSION_LE			0xca35
@@ -20,7 +22,7 @@
 
 /* Static configuration */
 #define EIP197_DEFAULT_RING_SIZE		400
-#define EIP197_MAX_TOKENS			5
+#define EIP197_MAX_TOKENS			8
 #define EIP197_MAX_RINGS			4
 #define EIP197_FETCH_COUNT			1
 #define EIP197_MAX_BATCH_SZ			64
@@ -33,6 +35,8 @@
 					sizeof(struct safexcel_cipher_req)
 #define EIP197_AHASH_REQ_SIZE		sizeof(struct ahash_request) + \
 					sizeof(struct safexcel_ahash_req)
+#define EIP197_AEAD_REQ_SIZE		sizeof(struct aead_request) + \
+					sizeof(struct safexcel_cipher_req)
 #define EIP197_REQUEST_ON_STACK(name, type, size) \
 	char __##name##_desc[size] CRYPTO_MINALIGN_ATTR; \
 	struct type##_request *name = (void *)__##name##_desc
@@ -283,7 +287,7 @@ struct safexcel_context_record {
 	u32 control0;
 	u32 control1;
 
-	__le32 data[12];
+	__le32 data[24];
 } __packed;
 
 /* control0 */
@@ -400,11 +404,15 @@ struct safexcel_token {
 	u8 opcode:4;
 } __packed;
 
+#define EIP197_TOKEN_HASH_RESULT_VERIFY		BIT(16)
+
 #define EIP197_TOKEN_STAT_LAST_HASH		BIT(0)
 #define EIP197_TOKEN_STAT_LAST_PACKET		BIT(1)
 #define EIP197_TOKEN_OPCODE_DIRECTION		0x0
 #define EIP197_TOKEN_OPCODE_INSERT		0x2
 #define EIP197_TOKEN_OPCODE_NOOP		EIP197_TOKEN_OPCODE_INSERT
+#define EIP197_TOKEN_OPCODE_RETRIEVE		0x4
+#define EIP197_TOKEN_OPCODE_VERIFY		0xd
 #define EIP197_TOKEN_OPCODE_BYPASS		GENMASK(3, 0)
 
 static inline void eip197_noop_token(struct safexcel_token *token)
@@ -488,6 +496,7 @@ struct safexcel_ring {
 
 enum safexcel_alg_type {
 	SAFEXCEL_ALG_TYPE_SKCIPHER,
+	SAFEXCEL_ALG_TYPE_AEAD,
 	SAFEXCEL_ALG_TYPE_AHASH,
 };
 
@@ -590,6 +599,16 @@ struct safexcel_context {
 	bool exit_inv;
 };
 
+struct safexcel_ahash_export_state {
+	u64 len;
+	u64 processed;
+
+	u32 digest;
+
+	u32 state[SHA256_DIGEST_SIZE / sizeof(u32)];
+	u8 cache[SHA256_BLOCK_SIZE];
+};
+
 /*
  * Template structure to describe the algorithms in order to register them.
  * It also has the purpose to contain our private structure and is actually
@@ -600,6 +619,7 @@ struct safexcel_alg_template {
 	enum safexcel_alg_type type;
 	union {
 		struct skcipher_alg skcipher;
+		struct aead_alg aead;
 		struct ahash_alg ahash;
 	} alg;
 };
@@ -636,6 +656,8 @@ struct safexcel_result_desc *safexcel_add_rdesc(struct safexcel_crypto_priv *pri
 						bool first, bool last,
 						dma_addr_t data, u32 len);
 void safexcel_inv_complete(struct crypto_async_request *req, int error);
+int safexcel_hmac_setkey(const char *alg, const u8 *key, unsigned int keylen,
+			 void *istate, void *ostate);
 
 /* available algorithms */
 extern struct safexcel_alg_template safexcel_alg_ecb_aes;
@@ -646,5 +668,6 @@ extern struct safexcel_alg_template safexcel_alg_sha256;
 extern struct safexcel_alg_template safexcel_alg_hmac_sha1;
 extern struct safexcel_alg_template safexcel_alg_hmac_sha224;
 extern struct safexcel_alg_template safexcel_alg_hmac_sha256;
+extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha256_cbc_aes;
 
 #endif
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 2452fce64fb7..51ab448f664e 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -12,8 +12,12 @@
 #include <linux/dma-mapping.h>
 #include <linux/dmapool.h>
 
+#include <crypto/aead.h>
 #include <crypto/aes.h>
+#include <crypto/authenc.h>
+#include <crypto/sha.h>
 #include <crypto/skcipher.h>
+#include <crypto/internal/aead.h>
 #include <crypto/internal/skcipher.h>
 
 #include "safexcel.h"
@@ -28,9 +32,16 @@ struct safexcel_cipher_ctx {
 	struct safexcel_crypto_priv *priv;
 
 	u32 mode;
+	bool aead;
 
 	__le32 key[8];
 	unsigned int key_len;
+
+	/* All the below is AEAD specific */
+	u32 alg;
+	u32 state_sz;
+	u32 ipad[SHA256_DIGEST_SIZE / sizeof(u32)];
+	u32 opad[SHA256_DIGEST_SIZE / sizeof(u32)];
 };
 
 struct safexcel_cipher_req {
@@ -63,6 +74,62 @@ static void safexcel_skcipher_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
 				EIP197_TOKEN_INS_TYPE_OUTPUT;
 }
 
+static void safexcel_aead_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
+				struct safexcel_command_desc *cdesc,
+				enum safexcel_cipher_direction direction,
+				u32 cryptlen, u32 assoclen, u32 digestsize)
+{
+	struct safexcel_token *token;
+	unsigned offset = 0;
+
+	if (ctx->mode == CONTEXT_CONTROL_CRYPTO_MODE_CBC) {
+		offset = AES_BLOCK_SIZE / sizeof(u32);
+		memcpy(cdesc->control_data.token, iv, AES_BLOCK_SIZE);
+
+		cdesc->control_data.options |= EIP197_OPTION_4_TOKEN_IV_CMD;
+	}
+
+	token = (struct safexcel_token *)(cdesc->control_data.token + offset);
+
+	if (direction == SAFEXCEL_DECRYPT)
+		cryptlen -= digestsize;
+
+	token[0].opcode = EIP197_TOKEN_OPCODE_DIRECTION;
+	token[0].packet_length = assoclen;
+	token[0].instructions = EIP197_TOKEN_INS_TYPE_HASH |
+				EIP197_TOKEN_INS_TYPE_OUTPUT;
+
+	token[1].opcode = EIP197_TOKEN_OPCODE_DIRECTION;
+	token[1].packet_length = cryptlen;
+	token[1].stat = EIP197_TOKEN_STAT_LAST_HASH;
+	token[1].instructions = EIP197_TOKEN_INS_LAST |
+				EIP197_TOKEN_INS_TYPE_CRYTO |
+				EIP197_TOKEN_INS_TYPE_HASH |
+				EIP197_TOKEN_INS_TYPE_OUTPUT;
+
+	if (direction == SAFEXCEL_ENCRYPT) {
+		token[2].opcode = EIP197_TOKEN_OPCODE_INSERT;
+		token[2].packet_length = digestsize;
+		token[2].stat = EIP197_TOKEN_STAT_LAST_HASH |
+				EIP197_TOKEN_STAT_LAST_PACKET;
+		token[2].instructions = EIP197_TOKEN_INS_TYPE_OUTPUT |
+					EIP197_TOKEN_INS_INSERT_HASH_DIGEST;
+	} else {
+		token[2].opcode = EIP197_TOKEN_OPCODE_RETRIEVE;
+		token[2].packet_length = digestsize;
+		token[2].stat = EIP197_TOKEN_STAT_LAST_HASH |
+				EIP197_TOKEN_STAT_LAST_PACKET;
+		token[2].instructions = EIP197_TOKEN_INS_INSERT_HASH_DIGEST;
+
+		token[3].opcode = EIP197_TOKEN_OPCODE_VERIFY;
+		token[3].packet_length = digestsize |
+					 EIP197_TOKEN_HASH_RESULT_VERIFY;
+		token[3].stat = EIP197_TOKEN_STAT_LAST_HASH |
+				EIP197_TOKEN_STAT_LAST_PACKET;
+		token[3].instructions = EIP197_TOKEN_INS_TYPE_OUTPUT;
+	}
+}
+
 static int safexcel_skcipher_aes_setkey(struct crypto_skcipher *ctfm,
 					const u8 *key, unsigned int len)
 {
@@ -96,6 +163,55 @@ static int safexcel_skcipher_aes_setkey(struct crypto_skcipher *ctfm,
 	return 0;
 }
 
+static int safexcel_aead_aes_setkey(struct crypto_aead *ctfm, const u8 *key,
+				    unsigned int len)
+{
+	struct crypto_tfm *tfm = crypto_aead_tfm(ctfm);
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct safexcel_ahash_export_state istate, ostate;
+	struct safexcel_crypto_priv *priv = ctx->priv;
+	struct crypto_authenc_keys keys;
+
+	if (crypto_authenc_extractkeys(&keys, key, len) != 0)
+		goto badkey;
+
+	if (keys.enckeylen > sizeof(ctx->key))
+		goto badkey;
+
+	/* Encryption key */
+	if (priv->version == EIP197 && ctx->base.ctxr_dma &&
+	    memcmp(ctx->key, keys.enckey, keys.enckeylen))
+		ctx->base.needs_inv = true;
+
+	/* Auth key */
+	if (safexcel_hmac_setkey("safexcel-sha256", keys.authkey,
+				 keys.authkeylen, &istate, &ostate))
+		goto badkey;
+
+	crypto_aead_set_flags(ctfm, crypto_aead_get_flags(ctfm) &
+				    CRYPTO_TFM_RES_MASK);
+
+	if (priv->version == EIP197 && ctx->base.ctxr_dma &&
+	    (memcmp(ctx->ipad, istate.state, ctx->state_sz) ||
+	     memcmp(ctx->opad, ostate.state, ctx->state_sz)))
+		ctx->base.needs_inv = true;
+
+	/* Now copy the keys into the context */
+	memcpy(ctx->key, keys.enckey, keys.enckeylen);
+	ctx->key_len = keys.enckeylen;
+
+	memcpy(ctx->ipad, &istate.state, ctx->state_sz);
+	memcpy(ctx->opad, &ostate.state, ctx->state_sz);
+
+	memzero_explicit(&keys, sizeof(keys));
+	return 0;
+
+badkey:
+	crypto_aead_set_flags(ctfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	memzero_explicit(&keys, sizeof(keys));
+	return -EINVAL;
+}
+
 static int safexcel_context_control(struct safexcel_cipher_ctx *ctx,
 				    struct crypto_async_request *async,
 				    struct safexcel_cipher_req *sreq,
@@ -104,17 +220,29 @@ static int safexcel_context_control(struct safexcel_cipher_ctx *ctx,
 	struct safexcel_crypto_priv *priv = ctx->priv;
 	int ctrl_size;
 
-	cdesc->control_data.control0 |= CONTEXT_CONTROL_TYPE_CRYPTO_OUT;
-
-	/* The decryption control type is a combination of the encryption type
-	 * and CONTEXT_CONTROL_TYPE_NULL_IN, for all types.
-	 */
-	if (sreq->direction == SAFEXCEL_DECRYPT)
-		cdesc->control_data.control0 |= CONTEXT_CONTROL_TYPE_NULL_IN;
+	if (ctx->aead) {
+		if (sreq->direction == SAFEXCEL_ENCRYPT)
+			cdesc->control_data.control0 |= CONTEXT_CONTROL_TYPE_ENCRYPT_HASH_OUT;
+		else
+			cdesc->control_data.control0 |= CONTEXT_CONTROL_TYPE_HASH_DECRYPT_IN;
+	} else {
+		cdesc->control_data.control0 |= CONTEXT_CONTROL_TYPE_CRYPTO_OUT;
+
+		/* The decryption control type is a combination of the
+		 * encryption type and CONTEXT_CONTROL_TYPE_NULL_IN, for all
+		 * types.
+		 */
+		if (sreq->direction == SAFEXCEL_DECRYPT)
+			cdesc->control_data.control0 |= CONTEXT_CONTROL_TYPE_NULL_IN;
+	}
 
 	cdesc->control_data.control0 |= CONTEXT_CONTROL_KEY_EN;
 	cdesc->control_data.control1 |= ctx->mode;
 
+	if (ctx->aead)
+		cdesc->control_data.control0 |= CONTEXT_CONTROL_DIGEST_HMAC |
+						ctx->alg;
+
 	switch (ctx->key_len) {
 	case AES_KEYSIZE_128:
 		cdesc->control_data.control0 |= CONTEXT_CONTROL_CRYPTO_ALG_AES128;
@@ -132,6 +260,9 @@ static int safexcel_context_control(struct safexcel_cipher_ctx *ctx,
 	}
 
 	ctrl_size = ctx->key_len / sizeof(u32);
+	if (ctx->aead)
+		/* Take in account the ipad+opad digests */
+		ctrl_size += ctx->state_sz / sizeof(u32) * 2;
 	cdesc->control_data.control0 |= CONTEXT_CONTROL_SIZE(ctrl_size);
 
 	return 0;
@@ -191,7 +322,8 @@ static int safexcel_aes_send(struct crypto_async_request *base, int ring,
 			     struct safexcel_request *request,
 			     struct safexcel_cipher_req *sreq,
 			     struct scatterlist *src, struct scatterlist *dst,
-			     unsigned int cryptlen, u8 *iv, int *commands,
+			     unsigned int cryptlen, unsigned int assoclen,
+			     unsigned int digestsize, u8 *iv, int *commands,
 			     int *results)
 {
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(base->tfm);
@@ -199,29 +331,30 @@ static int safexcel_aes_send(struct crypto_async_request *base, int ring,
 	struct safexcel_command_desc *cdesc;
 	struct safexcel_result_desc *rdesc;
 	struct scatterlist *sg;
-	int nr_src, nr_dst, n_cdesc = 0, n_rdesc = 0, queued = cryptlen;
+	unsigned int totlen = cryptlen + assoclen;
+	int nr_src, nr_dst, n_cdesc = 0, n_rdesc = 0, queued = totlen;
 	int i, ret = 0;
 
 	if (src == dst) {
 		nr_src = dma_map_sg(priv->dev, src,
-				    sg_nents_for_len(src, cryptlen),
+				    sg_nents_for_len(src, totlen),
 				    DMA_BIDIRECTIONAL);
 		nr_dst = nr_src;
 		if (!nr_src)
 			return -EINVAL;
 	} else {
 		nr_src = dma_map_sg(priv->dev, src,
-				    sg_nents_for_len(src, cryptlen),
+				    sg_nents_for_len(src, totlen),
 				    DMA_TO_DEVICE);
 		if (!nr_src)
 			return -EINVAL;
 
 		nr_dst = dma_map_sg(priv->dev, dst,
-				    sg_nents_for_len(dst, cryptlen),
+				    sg_nents_for_len(dst, totlen),
 				    DMA_FROM_DEVICE);
 		if (!nr_dst) {
 			dma_unmap_sg(priv->dev, src,
-				     sg_nents_for_len(src, cryptlen),
+				     sg_nents_for_len(src, totlen),
 				     DMA_TO_DEVICE);
 			return -EINVAL;
 		}
@@ -229,6 +362,13 @@ static int safexcel_aes_send(struct crypto_async_request *base, int ring,
 
 	memcpy(ctx->base.ctxr->data, ctx->key, ctx->key_len);
 
+	if (ctx->aead) {
+		memcpy(ctx->base.ctxr->data + ctx->key_len / sizeof(u32),
+		       ctx->ipad, ctx->state_sz);
+		memcpy(ctx->base.ctxr->data + (ctx->key_len + ctx->state_sz) / sizeof(u32),
+		       ctx->opad, ctx->state_sz);
+	}
+
 	spin_lock_bh(&priv->ring[ring].egress_lock);
 
 	/* command descriptors */
@@ -240,7 +380,7 @@ static int safexcel_aes_send(struct crypto_async_request *base, int ring,
 			len = queued;
 
 		cdesc = safexcel_add_cdesc(priv, ring, !n_cdesc, !(queued - len),
-					   sg_dma_address(sg), len, cryptlen,
+					   sg_dma_address(sg), len, totlen,
 					   ctx->base.ctxr_dma);
 		if (IS_ERR(cdesc)) {
 			/* No space left in the command descriptor ring */
@@ -251,7 +391,13 @@ static int safexcel_aes_send(struct crypto_async_request *base, int ring,
 
 		if (n_cdesc == 1) {
 			safexcel_context_control(ctx, base, sreq, cdesc);
-			safexcel_skcipher_token(ctx, iv, cdesc, cryptlen);
+			if (ctx->aead)
+				safexcel_aead_token(ctx, iv, cdesc,
+						    sreq->direction, cryptlen,
+						    assoclen, digestsize);
+			else
+				safexcel_skcipher_token(ctx, iv, cdesc,
+							cryptlen);
 		}
 
 		queued -= len;
@@ -293,14 +439,14 @@ static int safexcel_aes_send(struct crypto_async_request *base, int ring,
 
 	if (src == dst) {
 		dma_unmap_sg(priv->dev, src,
-			     sg_nents_for_len(src, cryptlen),
+			     sg_nents_for_len(src, totlen),
 			     DMA_BIDIRECTIONAL);
 	} else {
 		dma_unmap_sg(priv->dev, src,
-			     sg_nents_for_len(src, cryptlen),
+			     sg_nents_for_len(src, totlen),
 			     DMA_TO_DEVICE);
 		dma_unmap_sg(priv->dev, dst,
-			     sg_nents_for_len(dst, cryptlen),
+			     sg_nents_for_len(dst, totlen),
 			     DMA_FROM_DEVICE);
 	}
 
@@ -389,6 +535,30 @@ static int safexcel_skcipher_handle_result(struct safexcel_crypto_priv *priv,
 	return err;
 }
 
+static int safexcel_aead_handle_result(struct safexcel_crypto_priv *priv,
+				       int ring,
+				       struct crypto_async_request *async,
+				       bool *should_complete, int *ret)
+{
+	struct aead_request *req = aead_request_cast(async);
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct safexcel_cipher_req *sreq = aead_request_ctx(req);
+	int err;
+
+	if (sreq->needs_inv) {
+		sreq->needs_inv = false;
+		err = safexcel_handle_inv_result(priv, ring, async,
+						 should_complete, ret);
+	} else {
+		err = safexcel_handle_req_result(priv, ring, async, req->src,
+						 req->dst,
+						 req->cryptlen + crypto_aead_authsize(tfm),
+						 sreq, should_complete, ret);
+	}
+
+	return err;
+}
+
 static int safexcel_cipher_send_inv(struct crypto_async_request *base,
 				    int ring, struct safexcel_request *request,
 				    int *commands, int *results)
@@ -425,7 +595,31 @@ static int safexcel_skcipher_send(struct crypto_async_request *async, int ring,
 					       results);
 	else
 		ret = safexcel_aes_send(async, ring, request, sreq, req->src,
-					req->dst, req->cryptlen, req->iv,
+					req->dst, req->cryptlen, 0, 0, req->iv,
+					commands, results);
+	return ret;
+}
+
+static int safexcel_aead_send(struct crypto_async_request *async, int ring,
+			      struct safexcel_request *request, int *commands,
+			      int *results)
+{
+	struct aead_request *req = aead_request_cast(async);
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
+	struct safexcel_cipher_req *sreq = aead_request_ctx(req);
+	struct safexcel_crypto_priv *priv = ctx->priv;
+	int ret;
+
+	BUG_ON(priv->version == EIP97 && sreq->needs_inv);
+
+	if (sreq->needs_inv)
+		ret = safexcel_cipher_send_inv(async, ring, request, commands,
+					       results);
+	else
+		ret = safexcel_aes_send(async, ring, request, sreq, req->src,
+					req->dst, req->cryptlen, req->assoclen,
+					crypto_aead_authsize(tfm), req->iv,
 					commands, results);
 	return ret;
 }
@@ -479,6 +673,21 @@ static int safexcel_skcipher_exit_inv(struct crypto_tfm *tfm)
 	return safexcel_cipher_exit_inv(tfm, &req->base, sreq, &result);
 }
 
+static int safexcel_aead_exit_inv(struct crypto_tfm *tfm)
+{
+	EIP197_REQUEST_ON_STACK(req, aead, EIP197_AEAD_REQ_SIZE);
+	struct safexcel_cipher_req *sreq = aead_request_ctx(req);
+	struct safexcel_inv_result result = {};
+
+	memset(req, 0, sizeof(struct aead_request));
+
+	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				  safexcel_inv_complete, &result);
+	aead_request_set_tfm(req, __crypto_aead_cast(tfm));
+
+	return safexcel_cipher_exit_inv(tfm, &req->base, sreq, &result);
+}
+
 static int safexcel_aes(struct crypto_async_request *base,
 			struct safexcel_cipher_req *sreq,
 			enum safexcel_cipher_direction dir, u32 mode)
@@ -580,6 +789,26 @@ static void safexcel_skcipher_cra_exit(struct crypto_tfm *tfm)
 	}
 }
 
+static void safexcel_aead_cra_exit(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct safexcel_crypto_priv *priv = ctx->priv;
+	int ret;
+
+	if (safexcel_cipher_cra_exit(tfm))
+		return;
+
+	if (priv->version == EIP197) {
+		ret = safexcel_aead_exit_inv(tfm);
+		if (ret)
+			dev_warn(priv->dev, "aead: invalidation error %d\n",
+				 ret);
+	} else {
+		dma_pool_free(priv->context_pool, ctx->base.ctxr,
+			      ctx->base.ctxr_dma);
+	}
+}
+
 struct safexcel_alg_template safexcel_alg_ecb_aes = {
 	.type = SAFEXCEL_ALG_TYPE_SKCIPHER,
 	.alg.skcipher = {
@@ -640,3 +869,71 @@ struct safexcel_alg_template safexcel_alg_cbc_aes = {
 		},
 	},
 };
+
+static int safexcel_aead_encrypt(struct aead_request *req)
+{
+	struct safexcel_cipher_req *creq = aead_request_ctx(req);
+
+	return safexcel_aes(&req->base, creq, SAFEXCEL_ENCRYPT,
+			    CONTEXT_CONTROL_CRYPTO_MODE_CBC);
+}
+
+static int safexcel_aead_decrypt(struct aead_request *req)
+{
+	struct safexcel_cipher_req *creq = aead_request_ctx(req);
+
+	return safexcel_aes(&req->base, creq, SAFEXCEL_DECRYPT,
+			    CONTEXT_CONTROL_CRYPTO_MODE_CBC);
+}
+
+static int safexcel_aead_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct safexcel_alg_template *tmpl =
+		container_of(tfm->__crt_alg, struct safexcel_alg_template,
+			     alg.aead.base);
+
+	crypto_aead_set_reqsize(__crypto_aead_cast(tfm),
+				sizeof(struct safexcel_cipher_req));
+
+	ctx->priv = tmpl->priv;
+
+	ctx->aead = true;
+	ctx->base.send = safexcel_aead_send;
+	ctx->base.handle_result = safexcel_aead_handle_result;
+	return 0;
+}
+
+static int safexcel_aead_sha256_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	safexcel_aead_cra_init(tfm);
+	ctx->alg = CONTEXT_CONTROL_CRYPTO_ALG_SHA256;
+	ctx->state_sz = SHA256_DIGEST_SIZE;
+	return 0;
+}
+
+struct safexcel_alg_template safexcel_alg_authenc_hmac_sha256_cbc_aes = {
+	.type = SAFEXCEL_ALG_TYPE_AEAD,
+	.alg.aead = {
+		.setkey = safexcel_aead_aes_setkey,
+		.encrypt = safexcel_aead_encrypt,
+		.decrypt = safexcel_aead_decrypt,
+		.ivsize = AES_BLOCK_SIZE,
+		.maxauthsize = SHA256_DIGEST_SIZE,
+		.base = {
+			.cra_name = "authenc(hmac(sha256),cbc(aes))",
+			.cra_driver_name = "safexcel-authenc-hmac-sha256-cbc-aes",
+			.cra_priority = 300,
+			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
+			.cra_alignmask = 0,
+			.cra_init = safexcel_aead_sha256_cra_init,
+			.cra_exit = safexcel_aead_cra_exit,
+			.cra_module = THIS_MODULE,
+		},
+	},
+};
diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index 6cbd879e8fb5..d138d6b8fec5 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -50,16 +50,6 @@ struct safexcel_ahash_req {
 	u8 cache_next[SHA256_BLOCK_SIZE] __aligned(sizeof(u32));
 };
 
-struct safexcel_ahash_export_state {
-	u64 len;
-	u64 processed;
-
-	u32 digest;
-
-	u32 state[SHA256_DIGEST_SIZE / sizeof(u32)];
-	u8 cache[SHA256_BLOCK_SIZE];
-};
-
 static void safexcel_hash_token(struct safexcel_command_desc *cdesc,
 				u32 input_length, u32 result_length)
 {
@@ -909,8 +899,8 @@ static int safexcel_hmac_init_iv(struct ahash_request *areq,
 	return crypto_ahash_export(areq, state);
 }
 
-static int safexcel_hmac_setkey(const char *alg, const u8 *key,
-				unsigned int keylen, void *istate, void *ostate)
+int safexcel_hmac_setkey(const char *alg, const u8 *key, unsigned int keylen,
+			 void *istate, void *ostate)
 {
 	struct ahash_request *areq;
 	struct crypto_ahash *tfm;
-- 
2.17.0
