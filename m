From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 14/35] crypto: xcbc - Switch to shash
Date: Wed, 15 Jul 2009 15:16:07 +0800
Message-ID: <E1MQyil-0004zf-Jd@gondolin.me.apana.org.au>
References: <20090715071424.GA19023@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:53630 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752620AbZGOHQK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2009 03:16:10 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MQyim-0004r0-7J
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2009 17:16:08 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: xcbc - Switch to shash

This patch converts the xcbc algorithm to the new shash type.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/xcbc.c |  235 +++++++++++++++++++++-------------------------------------
 1 file changed, 87 insertions(+), 148 deletions(-)

diff --git a/crypto/xcbc.c b/crypto/xcbc.c
index b63b633..b2cc855 100644
--- a/crypto/xcbc.c
+++ b/crypto/xcbc.c
@@ -19,15 +19,9 @@
  * 	Kazunori Miyazawa <miyazawa@linux-ipv6.org>
  */
 
-#include <crypto/scatterwalk.h>
-#include <linux/crypto.h>
+#include <crypto/internal/hash.h>
 #include <linux/err.h>
-#include <linux/hardirq.h>
 #include <linux/kernel.h>
-#include <linux/mm.h>
-#include <linux/rtnetlink.h>
-#include <linux/slab.h>
-#include <linux/scatterlist.h>
 
 static u_int32_t ks[12] = {0x01010101, 0x01010101, 0x01010101, 0x01010101,
 			   0x02020202, 0x02020202, 0x02020202, 0x02020202,
@@ -66,10 +60,10 @@ static void xor_128(u8 *a, const u8 *b, unsigned int bs)
 	((u32 *)a)[3] ^= ((u32 *)b)[3];
 }
 
-static int _crypto_xcbc_digest_setkey(struct crypto_hash *parent,
+static int _crypto_xcbc_digest_setkey(struct crypto_shash *parent,
 				      struct crypto_xcbc_ctx *ctx)
 {
-	int bs = crypto_hash_blocksize(parent);
+	int bs = crypto_shash_blocksize(parent);
 	int err = 0;
 	u8 key1[bs];
 
@@ -81,10 +75,10 @@ static int _crypto_xcbc_digest_setkey(struct crypto_hash *parent,
 	return crypto_cipher_setkey(ctx->child, key1, bs);
 }
 
-static int crypto_xcbc_digest_setkey(struct crypto_hash *parent,
+static int crypto_xcbc_digest_setkey(struct crypto_shash *parent,
 				     const u8 *inkey, unsigned int keylen)
 {
-	struct crypto_xcbc_ctx *ctx = crypto_hash_ctx_aligned(parent);
+	struct crypto_xcbc_ctx *ctx = crypto_shash_ctx(parent);
 
 	if (keylen != crypto_cipher_blocksize(ctx->child))
 		return -EINVAL;
@@ -96,10 +90,10 @@ static int crypto_xcbc_digest_setkey(struct crypto_hash *parent,
 	return _crypto_xcbc_digest_setkey(parent, ctx);
 }
 
-static int crypto_xcbc_digest_init(struct hash_desc *pdesc)
+static int crypto_xcbc_digest_init(struct shash_desc *pdesc)
 {
-	struct crypto_xcbc_ctx *ctx = crypto_hash_ctx_aligned(pdesc->tfm);
-	int bs = crypto_hash_blocksize(pdesc->tfm);
+	struct crypto_xcbc_ctx *ctx = crypto_shash_ctx(pdesc->tfm);
+	int bs = crypto_shash_blocksize(pdesc->tfm);
 
 	ctx->len = 0;
 	memset(ctx->odds, 0, bs);
@@ -108,102 +102,55 @@ static int crypto_xcbc_digest_init(struct hash_desc *pdesc)
 	return 0;
 }
 
-static int crypto_xcbc_digest_update2(struct hash_desc *pdesc,
-				      struct scatterlist *sg,
-				      unsigned int nbytes)
+static int crypto_xcbc_digest_update(struct shash_desc *pdesc, const u8 *p,
+				     unsigned int len)
 {
-	struct crypto_hash *parent = pdesc->tfm;
-	struct crypto_xcbc_ctx *ctx = crypto_hash_ctx_aligned(parent);
+	struct crypto_shash *parent = pdesc->tfm;
+	struct crypto_xcbc_ctx *ctx = crypto_shash_ctx(parent);
 	struct crypto_cipher *tfm = ctx->child;
-	int bs = crypto_hash_blocksize(parent);
-
-	for (;;) {
-		struct page *pg = sg_page(sg);
-		unsigned int offset = sg->offset;
-		unsigned int slen = sg->length;
-
-		if (unlikely(slen > nbytes))
-			slen = nbytes;
-
-		nbytes -= slen;
-
-		while (slen > 0) {
-			unsigned int len = min(slen, ((unsigned int)(PAGE_SIZE)) - offset);
-			char *p = crypto_kmap(pg, 0) + offset;
-
-			/* checking the data can fill the block */
-			if ((ctx->len + len) <= bs) {
-				memcpy(ctx->odds + ctx->len, p, len);
-				ctx->len += len;
-				slen -= len;
-
-				/* checking the rest of the page */
-				if (len + offset >= PAGE_SIZE) {
-					offset = 0;
-					pg++;
-				} else
-					offset += len;
-
-				crypto_kunmap(p, 0);
-				crypto_yield(pdesc->flags);
-				continue;
-			}
-
-			/* filling odds with new data and encrypting it */
-			memcpy(ctx->odds + ctx->len, p, bs - ctx->len);
-			len -= bs - ctx->len;
-			p += bs - ctx->len;
-
-			ctx->xor(ctx->prev, ctx->odds, bs);
-			crypto_cipher_encrypt_one(tfm, ctx->prev, ctx->prev);
-
-			/* clearing the length */
-			ctx->len = 0;
-
-			/* encrypting the rest of data */
-			while (len > bs) {
-				ctx->xor(ctx->prev, p, bs);
-				crypto_cipher_encrypt_one(tfm, ctx->prev,
-							  ctx->prev);
-				p += bs;
-				len -= bs;
-			}
-
-			/* keeping the surplus of blocksize */
-			if (len) {
-				memcpy(ctx->odds, p, len);
-				ctx->len = len;
-			}
-			crypto_kunmap(p, 0);
-			crypto_yield(pdesc->flags);
-			slen -= min(slen, ((unsigned int)(PAGE_SIZE)) - offset);
-			offset = 0;
-			pg++;
-		}
-
-		if (!nbytes)
-			break;
-		sg = scatterwalk_sg_next(sg);
+	int bs = crypto_shash_blocksize(parent);
+
+	/* checking the data can fill the block */
+	if ((ctx->len + len) <= bs) {
+		memcpy(ctx->odds + ctx->len, p, len);
+		ctx->len += len;
+		return 0;
 	}
 
-	return 0;
-}
+	/* filling odds with new data and encrypting it */
+	memcpy(ctx->odds + ctx->len, p, bs - ctx->len);
+	len -= bs - ctx->len;
+	p += bs - ctx->len;
 
-static int crypto_xcbc_digest_update(struct hash_desc *pdesc,
-				     struct scatterlist *sg,
-				     unsigned int nbytes)
-{
-	if (WARN_ON_ONCE(in_irq()))
-		return -EDEADLK;
-	return crypto_xcbc_digest_update2(pdesc, sg, nbytes);
+	ctx->xor(ctx->prev, ctx->odds, bs);
+	crypto_cipher_encrypt_one(tfm, ctx->prev, ctx->prev);
+
+	/* clearing the length */
+	ctx->len = 0;
+
+	/* encrypting the rest of data */
+	while (len > bs) {
+		ctx->xor(ctx->prev, p, bs);
+		crypto_cipher_encrypt_one(tfm, ctx->prev, ctx->prev);
+		p += bs;
+		len -= bs;
+	}
+
+	/* keeping the surplus of blocksize */
+	if (len) {
+		memcpy(ctx->odds, p, len);
+		ctx->len = len;
+	}
+
+	return 0;
 }
 
-static int crypto_xcbc_digest_final(struct hash_desc *pdesc, u8 *out)
+static int crypto_xcbc_digest_final(struct shash_desc *pdesc, u8 *out)
 {
-	struct crypto_hash *parent = pdesc->tfm;
-	struct crypto_xcbc_ctx *ctx = crypto_hash_ctx_aligned(parent);
+	struct crypto_shash *parent = pdesc->tfm;
+	struct crypto_xcbc_ctx *ctx = crypto_shash_ctx(parent);
 	struct crypto_cipher *tfm = ctx->child;
-	int bs = crypto_hash_blocksize(parent);
+	int bs = crypto_shash_blocksize(parent);
 	int err = 0;
 
 	if (ctx->len == bs) {
@@ -248,24 +195,13 @@ static int crypto_xcbc_digest_final(struct hash_desc *pdesc, u8 *out)
 	return 0;
 }
 
-static int crypto_xcbc_digest(struct hash_desc *pdesc,
-		  struct scatterlist *sg, unsigned int nbytes, u8 *out)
-{
-	if (WARN_ON_ONCE(in_irq()))
-		return -EDEADLK;
-
-	crypto_xcbc_digest_init(pdesc);
-	crypto_xcbc_digest_update2(pdesc, sg, nbytes);
-	return crypto_xcbc_digest_final(pdesc, out);
-}
-
 static int xcbc_init_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_cipher *cipher;
 	struct crypto_instance *inst = (void *)tfm->__crt_alg;
 	struct crypto_spawn *spawn = crypto_instance_ctx(inst);
-	struct crypto_xcbc_ctx *ctx = crypto_hash_ctx_aligned(__crypto_hash_cast(tfm));
-	int bs = crypto_hash_blocksize(__crypto_hash_cast(tfm));
+	struct crypto_xcbc_ctx *ctx = crypto_tfm_ctx(tfm);
+	int bs = crypto_tfm_alg_blocksize(tfm);
 
 	cipher = crypto_spawn_cipher(spawn);
 	if (IS_ERR(cipher))
@@ -289,70 +225,73 @@ static int xcbc_init_tfm(struct crypto_tfm *tfm)
 
 static void xcbc_exit_tfm(struct crypto_tfm *tfm)
 {
-	struct crypto_xcbc_ctx *ctx = crypto_hash_ctx_aligned(__crypto_hash_cast(tfm));
+	struct crypto_xcbc_ctx *ctx = crypto_tfm_ctx(tfm);
 	crypto_free_cipher(ctx->child);
 }
 
-static struct crypto_instance *xcbc_alloc(struct rtattr **tb)
+static int xcbc_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
-	struct crypto_instance *inst;
+	struct shash_instance *inst;
 	struct crypto_alg *alg;
 	int err;
 
-	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_HASH);
+	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SHASH);
 	if (err)
-		return ERR_PTR(err);
+		return err;
 
 	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_CIPHER,
 				  CRYPTO_ALG_TYPE_MASK);
 	if (IS_ERR(alg))
-		return ERR_CAST(alg);
+		return PTR_ERR(alg);
 
 	switch(alg->cra_blocksize) {
 	case 16:
 		break;
 	default:
-		inst = ERR_PTR(-EINVAL);
 		goto out_put_alg;
 	}
 
-	inst = crypto_alloc_instance("xcbc", alg);
+	inst = shash_alloc_instance("xcbc", alg);
 	if (IS_ERR(inst))
 		goto out_put_alg;
 
-	inst->alg.cra_flags = CRYPTO_ALG_TYPE_HASH;
-	inst->alg.cra_priority = alg->cra_priority;
-	inst->alg.cra_blocksize = alg->cra_blocksize;
-	inst->alg.cra_alignmask = alg->cra_alignmask;
-	inst->alg.cra_type = &crypto_hash_type;
-
-	inst->alg.cra_hash.digestsize = alg->cra_blocksize;
-	inst->alg.cra_ctxsize = sizeof(struct crypto_xcbc_ctx) +
-				ALIGN(inst->alg.cra_blocksize * 3, sizeof(void *));
-	inst->alg.cra_init = xcbc_init_tfm;
-	inst->alg.cra_exit = xcbc_exit_tfm;
-
-	inst->alg.cra_hash.init = crypto_xcbc_digest_init;
-	inst->alg.cra_hash.update = crypto_xcbc_digest_update;
-	inst->alg.cra_hash.final = crypto_xcbc_digest_final;
-	inst->alg.cra_hash.digest = crypto_xcbc_digest;
-	inst->alg.cra_hash.setkey = crypto_xcbc_digest_setkey;
+	err = crypto_init_spawn(shash_instance_ctx(inst), alg,
+				shash_crypto_instance(inst),
+				CRYPTO_ALG_TYPE_MASK);
+	if (err)
+		goto out_free_inst;
+
+	inst->alg.base.cra_priority = alg->cra_priority;
+	inst->alg.base.cra_blocksize = alg->cra_blocksize;
+	inst->alg.base.cra_alignmask = alg->cra_alignmask;
+
+	inst->alg.digestsize = alg->cra_blocksize;
+	inst->alg.base.cra_ctxsize = sizeof(struct crypto_xcbc_ctx) +
+				     ALIGN(alg->cra_blocksize * 3,
+					   sizeof(void *));
+	inst->alg.base.cra_init = xcbc_init_tfm;
+	inst->alg.base.cra_exit = xcbc_exit_tfm;
+
+	inst->alg.init = crypto_xcbc_digest_init;
+	inst->alg.update = crypto_xcbc_digest_update;
+	inst->alg.final = crypto_xcbc_digest_final;
+	inst->alg.setkey = crypto_xcbc_digest_setkey;
+
+	err = shash_register_instance(tmpl, inst);
+	if (err) {
+out_free_inst:
+		shash_free_instance(shash_crypto_instance(inst));
+	}
 
 out_put_alg:
 	crypto_mod_put(alg);
-	return inst;
-}
