From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/6] crypto: xcbc - Fix shash conversion
Date: Wed, 22 Jul 2009 14:40:05 +0800
Message-ID: <E1MTVUj-0007ji-G2@gondolin.me.apana.org.au>
References: <20090722063844.GA28998@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:51382 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752794AbZGVGkG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jul 2009 02:40:06 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MTVUj-0005yo-Ps
	for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2009 16:40:05 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: xcbc - Fix shash conversion

Although xcbc was converted to shash, it didn't obey the new
requirement that all hash state must be stored in the descriptor
rather than the transform.

This patch fixes this issue and also optimises away the rekeying
by precomputing K2 and K3 within setkey.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/xcbc.c |  164 +++++++++++++++++++++++++---------------------------------
 1 file changed, 73 insertions(+), 91 deletions(-)

diff --git a/crypto/xcbc.c b/crypto/xcbc.c
index 9d502e6..1e30b31 100644
--- a/crypto/xcbc.c
+++ b/crypto/xcbc.c
@@ -26,69 +26,67 @@
 static u_int32_t ks[12] = {0x01010101, 0x01010101, 0x01010101, 0x01010101,
 			   0x02020202, 0x02020202, 0x02020202, 0x02020202,
 			   0x03030303, 0x03030303, 0x03030303, 0x03030303};
+
 /*
  * +------------------------
  * | <parent tfm>
  * +------------------------
- * | crypto_xcbc_ctx
+ * | xcbc_tfm_ctx
  * +------------------------
- * | odds (block size)
+ * | consts (block size * 2)
  * +------------------------
- * | prev (block size)
+ */
+struct xcbc_tfm_ctx {
+	struct crypto_cipher *child;
+	u8 ctx[];
+};
+
+/*
  * +------------------------
- * | key (block size)
+ * | <shash desc>
  * +------------------------
- * | consts (block size * 3)
+ * | xcbc_desc_ctx
+ * +------------------------
+ * | odds (block size)
+ * +------------------------
+ * | prev (block size)
  * +------------------------
  */
-struct crypto_xcbc_ctx {
-	struct crypto_cipher *child;
-	u8 *odds;
-	u8 *prev;
-	u8 *key;
-	u8 *consts;
-	unsigned int keylen;
+struct xcbc_desc_ctx {
 	unsigned int len;
+	u8 ctx[];
 };
 
-static int _crypto_xcbc_digest_setkey(struct crypto_shash *parent,
-				      struct crypto_xcbc_ctx *ctx)
+static int crypto_xcbc_digest_setkey(struct crypto_shash *parent,
+				     const u8 *inkey, unsigned int keylen)
 {
+	unsigned long alignmask = crypto_shash_alignmask(parent);
+	struct xcbc_tfm_ctx *ctx = crypto_shash_ctx(parent);
 	int bs = crypto_shash_blocksize(parent);
+	u8 *consts = PTR_ALIGN(&ctx->ctx[0], alignmask + 1);
 	int err = 0;
 	u8 key1[bs];
 
-	if ((err = crypto_cipher_setkey(ctx->child, ctx->key, ctx->keylen)))
-	    return err;
+	if ((err = crypto_cipher_setkey(ctx->child, inkey, keylen)))
+		return err;
 
-	crypto_cipher_encrypt_one(ctx->child, key1, ctx->consts);
+	crypto_cipher_encrypt_one(ctx->child, consts, (u8 *)ks + bs);
+	crypto_cipher_encrypt_one(ctx->child, consts + bs, (u8 *)ks + bs * 2);
+	crypto_cipher_encrypt_one(ctx->child, key1, (u8 *)ks);
 
 	return crypto_cipher_setkey(ctx->child, key1, bs);
-}
-
-static int crypto_xcbc_digest_setkey(struct crypto_shash *parent,
-				     const u8 *inkey, unsigned int keylen)
-{
-	struct crypto_xcbc_ctx *ctx = crypto_shash_ctx(parent);
-
-	if (keylen != crypto_cipher_blocksize(ctx->child))
-		return -EINVAL;
 
-	ctx->keylen = keylen;
-	memcpy(ctx->key, inkey, keylen);
-	ctx->consts = (u8*)ks;
-
-	return _crypto_xcbc_digest_setkey(parent, ctx);
 }
 
 static int crypto_xcbc_digest_init(struct shash_desc *pdesc)
 {
-	struct crypto_xcbc_ctx *ctx = crypto_shash_ctx(pdesc->tfm);
+	unsigned long alignmask = crypto_shash_alignmask(pdesc->tfm);
+	struct xcbc_desc_ctx *ctx = shash_desc_ctx(pdesc);
 	int bs = crypto_shash_blocksize(pdesc->tfm);
+	u8 *prev = PTR_ALIGN(&ctx->ctx[0], alignmask + 1) + bs;
 
 	ctx->len = 0;
-	memset(ctx->odds, 0, bs);
-	memset(ctx->prev, 0, bs);
+	memset(prev, 0, bs);
 
 	return 0;
 }
@@ -97,39 +95,43 @@ static int crypto_xcbc_digest_update(struct shash_desc *pdesc, const u8 *p,
 				     unsigned int len)
 {
 	struct crypto_shash *parent = pdesc->tfm;
-	struct crypto_xcbc_ctx *ctx = crypto_shash_ctx(parent);
-	struct crypto_cipher *tfm = ctx->child;
+	unsigned long alignmask = crypto_shash_alignmask(parent);
+	struct xcbc_tfm_ctx *tctx = crypto_shash_ctx(parent);
+	struct xcbc_desc_ctx *ctx = shash_desc_ctx(pdesc);
+	struct crypto_cipher *tfm = tctx->child;
 	int bs = crypto_shash_blocksize(parent);
+	u8 *odds = PTR_ALIGN(&ctx->ctx[0], alignmask + 1);
+	u8 *prev = odds + bs;
 
 	/* checking the data can fill the block */
 	if ((ctx->len + len) <= bs) {
-		memcpy(ctx->odds + ctx->len, p, len);
+		memcpy(odds + ctx->len, p, len);
 		ctx->len += len;
 		return 0;
 	}
 
 	/* filling odds with new data and encrypting it */
-	memcpy(ctx->odds + ctx->len, p, bs - ctx->len);
+	memcpy(odds + ctx->len, p, bs - ctx->len);
 	len -= bs - ctx->len;
 	p += bs - ctx->len;
 
-	crypto_xor(ctx->prev, ctx->odds, bs);
-	crypto_cipher_encrypt_one(tfm, ctx->prev, ctx->prev);
+	crypto_xor(prev, odds, bs);
+	crypto_cipher_encrypt_one(tfm, prev, prev);
 
 	/* clearing the length */
 	ctx->len = 0;
 
 	/* encrypting the rest of data */
 	while (len > bs) {
-		crypto_xor(ctx->prev, p, bs);
-		crypto_cipher_encrypt_one(tfm, ctx->prev, ctx->prev);
+		crypto_xor(prev, p, bs);
+		crypto_cipher_encrypt_one(tfm, prev, prev);
 		p += bs;
 		len -= bs;
 	}
 
 	/* keeping the surplus of blocksize */
 	if (len) {
-		memcpy(ctx->odds, p, len);
+		memcpy(odds, p, len);
 		ctx->len = len;
 	}
 
@@ -139,29 +141,20 @@ static int crypto_xcbc_digest_update(struct shash_desc *pdesc, const u8 *p,
 static int crypto_xcbc_digest_final(struct shash_desc *pdesc, u8 *out)
 {
 	struct crypto_shash *parent = pdesc->tfm;
-	struct crypto_xcbc_ctx *ctx = crypto_shash_ctx(parent);
-	struct crypto_cipher *tfm = ctx->child;
+	unsigned long alignmask = crypto_shash_alignmask(parent);
+	struct xcbc_tfm_ctx *tctx = crypto_shash_ctx(parent);
+	struct xcbc_desc_ctx *ctx = shash_desc_ctx(pdesc);
+	struct crypto_cipher *tfm = tctx->child;
 	int bs = crypto_shash_blocksize(parent);
-	int err = 0;
+	u8 *consts = PTR_ALIGN(&tctx->ctx[0], alignmask + 1);
+	u8 *odds = PTR_ALIGN(&ctx->ctx[0], alignmask + 1);
+	u8 *prev = odds + bs;
+	unsigned int offset = 0;
 
-	if (ctx->len == bs) {
-		u8 key2[bs];
-
-		if ((err = crypto_cipher_setkey(tfm, ctx->key, ctx->keylen)) != 0)
-			return err;
-
-		crypto_cipher_encrypt_one(tfm, key2,
-					  (u8 *)(ctx->consts + bs));
-
-		crypto_xor(ctx->prev, ctx->odds, bs);
-		crypto_xor(ctx->prev, key2, bs);
-		_crypto_xcbc_digest_setkey(parent, ctx);
-
-		crypto_cipher_encrypt_one(tfm, out, ctx->prev);
-	} else {
-		u8 key3[bs];
+	if (ctx->len != bs) {
 		unsigned int rlen;
-		u8 *p = ctx->odds + ctx->len;
+		u8 *p = odds + ctx->len;
+
 		*p = 0x80;
 		p++;
 
@@ -169,19 +162,13 @@ static int crypto_xcbc_digest_final(struct shash_desc *pdesc, u8 *out)
 		if (rlen)
 			memset(p, 0, rlen);
 
-		if ((err = crypto_cipher_setkey(tfm, ctx->key, ctx->keylen)) != 0)
-			return err;
-
-		crypto_cipher_encrypt_one(tfm, key3,
-					  (u8 *)(ctx->consts + bs * 2));
+		offset += bs;
+	}
 
-		crypto_xor(ctx->prev, ctx->odds, bs);
-		crypto_xor(ctx->prev, key3, bs);
+	crypto_xor(prev, odds, bs);
+	crypto_xor(prev, consts + offset, bs);
 
-		_crypto_xcbc_digest_setkey(parent, ctx);
-
-		crypto_cipher_encrypt_one(tfm, out, ctx->prev);
-	}
+	crypto_cipher_encrypt_one(tfm, out, prev);
 
 	return 0;
 }
@@ -191,31 +178,20 @@ static int xcbc_init_tfm(struct crypto_tfm *tfm)
 	struct crypto_cipher *cipher;
 	struct crypto_instance *inst = (void *)tfm->__crt_alg;
 	struct crypto_spawn *spawn = crypto_instance_ctx(inst);
-	struct crypto_xcbc_ctx *ctx = crypto_tfm_ctx(tfm);
-	int bs = crypto_tfm_alg_blocksize(tfm);
+	struct xcbc_tfm_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	cipher = crypto_spawn_cipher(spawn);
 	if (IS_ERR(cipher))
 		return PTR_ERR(cipher);
 
-	switch(bs) {
-	case 16:
-		break;
-	default:
-		return -EINVAL;
-	}
-
 	ctx->child = cipher;
-	ctx->odds = (u8*)(ctx+1);
-	ctx->prev = ctx->odds + bs;
-	ctx->key = ctx->prev + bs;
 
 	return 0;
 };
 
 static void xcbc_exit_tfm(struct crypto_tfm *tfm)
 {
-	struct crypto_xcbc_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct xcbc_tfm_ctx *ctx = crypto_tfm_ctx(tfm);
 	crypto_free_cipher(ctx->child);
 }
 
@@ -254,12 +230,18 @@ static int xcbc_create(struct crypto_template *tmpl, struct rtattr **tb)
 
 	inst->alg.base.cra_priority = alg->cra_priority;
 	inst->alg.base.cra_blocksize = alg->cra_blocksize;
-	inst->alg.base.cra_alignmask = alg->cra_alignmask;
+	inst->alg.base.cra_alignmask = alg->cra_alignmask | 3;
 
 	inst->alg.digestsize = alg->cra_blocksize;
-	inst->alg.base.cra_ctxsize = sizeof(struct crypto_xcbc_ctx) +
-				     ALIGN(alg->cra_blocksize * 3,
-					   sizeof(void *));
+	inst->alg.descsize = ALIGN(sizeof(struct xcbc_desc_ctx),
+				   crypto_tfm_ctx_alignment()) +
+			     (alg->cra_alignmask &
+			      ~(crypto_tfm_ctx_alignment() - 1)) +
+			     alg->cra_blocksize * 2;
+
+	inst->alg.base.cra_ctxsize = ALIGN(sizeof(struct xcbc_tfm_ctx),
+					   alg->cra_alignmask) +
+				     alg->cra_blocksize * 2;
 	inst->alg.base.cra_init = xcbc_init_tfm;
 	inst->alg.base.cra_exit = xcbc_exit_tfm;
 
