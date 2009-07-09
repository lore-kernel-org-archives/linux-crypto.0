From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 16/16] crypto: hmac - Prehash ipad/opad
Date: Thu, 09 Jul 2009 12:54:02 +0800
Message-ID: <E1MOldy-0005Xj-RH@gondolin.me.apana.org.au>
References: <20090709045052.GA21092@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:44874 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758608AbZGIEyE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Jul 2009 00:54:04 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MOldz-0006F0-3z
	for <linux-crypto@vger.kernel.org>; Thu, 09 Jul 2009 14:54:03 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: hmac - Prehash ipad/opad

This patch uses crypto_shash_export/crypto_shash_import to prehash
ipad/opad to speed up hmac.  This is partly based on a similar patch
by Steffen Klassert.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/hmac.c |   61 ++++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 40 insertions(+), 21 deletions(-)

diff --git a/crypto/hmac.c b/crypto/hmac.c
index aa8ea14..9666181 100644
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -38,7 +38,8 @@ static inline void *align_ptr(void *p, unsigned int align)
 static inline struct hmac_ctx *hmac_ctx(struct crypto_shash *tfm)
 {
 	return align_ptr(crypto_shash_ctx_aligned(tfm) +
-			 crypto_shash_blocksize(tfm) * 2 +
+			 (crypto_shash_descsize(tfm) -
+			  sizeof(struct shash_desc)) * 2 +
 			 crypto_shash_digestsize(tfm),
 			 crypto_tfm_ctx_alignment());
 }
@@ -48,19 +49,19 @@ static int hmac_setkey(struct crypto_shash *parent,
 {
 	int bs = crypto_shash_blocksize(parent);
 	int ds = crypto_shash_digestsize(parent);
+	int des = crypto_shash_descsize(parent) - sizeof(struct shash_desc);
 	char *ipad = crypto_shash_ctx_aligned(parent);
-	char *opad = ipad + bs;
-	char *digest = opad + bs;
+	char *opad = ipad + des;
+	char *digest = opad + des;
 	struct hmac_ctx *ctx = align_ptr(digest + ds, 
 					 crypto_tfm_ctx_alignment());
 	unsigned int i;
+	int err;
 
-	if (keylen > bs) {
-		int err;
-
-		ctx->desc.flags = crypto_shash_get_flags(parent) &
-				  CRYPTO_TFM_REQ_MAY_SLEEP;
+	ctx->desc.flags = crypto_shash_get_flags(parent) &
+			  CRYPTO_TFM_REQ_MAY_SLEEP;
 
+	if (keylen > bs) {
 		err = crypto_shash_digest(&ctx->desc, inkey, keylen, digest);
 		if (err)
 			return err;
@@ -78,24 +79,37 @@ static int hmac_setkey(struct crypto_shash *parent,
 		opad[i] ^= 0x5c;
 	}
 
+	err = crypto_shash_init(&ctx->desc) ?:
+	      crypto_shash_update(&ctx->desc, ipad, bs);
+	if (err)
+		return err;
+
+	crypto_shash_export(&ctx->desc, ipad);
+
+	err = crypto_shash_init(&ctx->desc) ?:
+	      crypto_shash_update(&ctx->desc, opad, bs);
+	if (err)
+		return err;
+
+	crypto_shash_export(&ctx->desc, opad);
+
 	return 0;
 }
 
 static int hmac_init(struct shash_desc *pdesc)
 {
 	struct crypto_shash *parent = pdesc->tfm;
-	int bs = crypto_shash_blocksize(parent);
 	int ds = crypto_shash_digestsize(parent);
+	int des = crypto_shash_descsize(parent) - sizeof(struct shash_desc);
 	char *ipad = crypto_shash_ctx_aligned(parent);
-	struct hmac_ctx *ctx = align_ptr(ipad + bs * 2 + ds,
+	struct hmac_ctx *ctx = align_ptr(ipad + des * 2 + ds,
 					 crypto_tfm_ctx_alignment());
 	struct shash_desc *desc = shash_desc_ctx(pdesc);
 
 	desc->tfm = ctx->desc.tfm;
 	desc->flags = pdesc->flags & CRYPTO_TFM_REQ_MAY_SLEEP;
 
-	return crypto_shash_init(desc) ?:
-	       crypto_shash_update(desc, ipad, bs);
+	return crypto_shash_import(desc, ipad);
 }
 
 static int hmac_update(struct shash_desc *pdesc,
@@ -111,16 +125,17 @@ static int hmac_update(struct shash_desc *pdesc,
 static int hmac_final(struct shash_desc *pdesc, u8 *out)
 {
 	struct crypto_shash *parent = pdesc->tfm;
-	int bs = crypto_shash_blocksize(parent);
 	int ds = crypto_shash_digestsize(parent);
-	char *opad = crypto_shash_ctx_aligned(parent) + bs;
-	char *digest = opad + bs;
+	int des = crypto_shash_descsize(parent) - sizeof(struct shash_desc);
+	char *opad = crypto_shash_ctx_aligned(parent) + des;
+	char *digest = opad + des;
 	struct shash_desc *desc = shash_desc_ctx(pdesc);
 
 	desc->flags = pdesc->flags & CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	return crypto_shash_final(desc, digest) ?:
-	       crypto_shash_digest(desc, opad, bs + ds, out);
+	       crypto_shash_import(desc, opad) ?:
+	       crypto_shash_finup(desc, digest, ds, out);
 }
 
 static int hmac_finup(struct shash_desc *pdesc, const u8 *data,
@@ -128,16 +143,17 @@ static int hmac_finup(struct shash_desc *pdesc, const u8 *data,
 {
 
 	struct crypto_shash *parent = pdesc->tfm;
-	int bs = crypto_shash_blocksize(parent);
 	int ds = crypto_shash_digestsize(parent);
-	char *opad = crypto_shash_ctx_aligned(parent) + bs;
-	char *digest = opad + bs;
+	int des = crypto_shash_descsize(parent) - sizeof(struct shash_desc);
+	char *opad = crypto_shash_ctx_aligned(parent) + des;
+	char *digest = opad + des;
 	struct shash_desc *desc = shash_desc_ctx(pdesc);
 
 	desc->flags = pdesc->flags & CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	return crypto_shash_finup(desc, data, nbytes, digest) ?:
-	       crypto_shash_digest(desc, opad, bs + ds, out);
+	       crypto_shash_import(desc, opad) ?:
+	       crypto_shash_finup(desc, digest, ds, out);
 }
 
 static int hmac_reinit(struct shash_desc *pdesc)
@@ -192,6 +208,9 @@ static int hmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	if (ds > alg->cra_blocksize)
 		goto out_put_alg;
 
+	if (WARN_ON(salg->descsize < alg->cra_blocksize))
+		goto out_put_alg;
+
 	inst = shash_alloc_instance("hmac", alg);
 	if (IS_ERR(inst))
 		goto out_put_alg;
@@ -209,7 +228,7 @@ static int hmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.descsize = sizeof(struct shash_desc) + salg->descsize;
 
 	inst->alg.base.cra_ctxsize = sizeof(struct hmac_ctx) + salg->descsize +
-				     ALIGN(alg->cra_blocksize * 2 + ds,
+				     ALIGN(salg->descsize * 2 + ds,
 					   crypto_tfm_ctx_alignment());
 
 	inst->alg.base.cra_init = hmac_init_tfm;
