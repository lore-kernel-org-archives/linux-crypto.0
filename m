From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: authenc - convert to ahash
Date: Fri, 24 Jul 2009 15:23:11 +0800
Message-ID: <20090724072311.GA22961@gondor.apana.org.au>
References: <20090721090217.GF20288@secunet.com> <20090721122509.GG20288@secunet.com> <20090721130725.GA19550@gondor.apana.org.au> <20090723102314.GN20288@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:45421 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751932AbZGXHXO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Jul 2009 03:23:14 -0400
Content-Disposition: inline
In-Reply-To: <20090723102314.GN20288@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 23, 2009 at 12:23:14PM +0200, Steffen Klassert wrote:
>
> I found the problem. It's the digest state that is saved on the
> transform right behind the opad in hmac_finup() and hmac_final().
> The digest state is of course not constant and must be saved on the
> request. That's why I needed the locks in authenc to get pcrypt to
> work. I have a patch which moves the digest state to the request,
> based on the cryptodev-2.6 tree.
> However, as soon as your recent import/export patches are in the
> cryptodev-2.6 tree we could probaply change hmac to do prehashing of the
> keys what would fix the problem too.

Ah, that makes sense.  I've done the prehash patch, let me know
if this works.

commit 0b767b4df360bd442434d9d40b8a495e64202254
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Fri Jul 24 15:18:41 2009 +0800

    crypto: hmac - Prehash ipad/opad
    
    This patch uses crypto_shash_export/crypto_shash_import to prehash
    ipad/opad to speed up hmac.  This is partly based on a similar patch
    by Steffen Klassert.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/hmac.c b/crypto/hmac.c
index 02aa53e..15c2eb5 100644
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -27,7 +27,7 @@
 #include <linux/string.h>
 
 struct hmac_ctx {
-	struct shash_desc *desc;
+	struct crypto_shash *hash;
 };
 
 static inline void *align_ptr(void *p, unsigned int align)
@@ -38,8 +38,7 @@ static inline void *align_ptr(void *p, unsigned int align)
 static inline struct hmac_ctx *hmac_ctx(struct crypto_shash *tfm)
 {
 	return align_ptr(crypto_shash_ctx_aligned(tfm) +
-			 crypto_shash_blocksize(tfm) * 2 +
-			 crypto_shash_digestsize(tfm),
+			 crypto_shash_statesize(tfm) * 2,
 			 crypto_tfm_ctx_alignment());
 }
 
@@ -48,28 +47,33 @@ static int hmac_setkey(struct crypto_shash *parent,
 {
 	int bs = crypto_shash_blocksize(parent);
 	int ds = crypto_shash_digestsize(parent);
+	int ss = crypto_shash_statesize(parent);
 	char *ipad = crypto_shash_ctx_aligned(parent);
-	char *opad = ipad + bs;
-	char *digest = opad + bs;
-	struct hmac_ctx *ctx = align_ptr(digest + ds,
+	char *opad = ipad + ss;
+	struct hmac_ctx *ctx = align_ptr(opad + ss,
 					 crypto_tfm_ctx_alignment());
+	struct crypto_shash *hash = ctx->hash;
+	struct {
+		struct shash_desc shash;
+		char ctx[crypto_shash_descsize(hash)];
+	} desc;
 	unsigned int i;
 
+	desc.shash.tfm = hash;
+	desc.shash.flags = crypto_shash_get_flags(parent) &
+			    CRYPTO_TFM_REQ_MAY_SLEEP;
+
 	if (keylen > bs) {
 		int err;
 
-		ctx->desc->flags = crypto_shash_get_flags(parent) &
-				   CRYPTO_TFM_REQ_MAY_SLEEP;
-
-		err = crypto_shash_digest(ctx->desc, inkey, keylen, digest);
+		err = crypto_shash_digest(&desc.shash, inkey, keylen, ipad);
 		if (err)
 			return err;
 
-		inkey = digest;
 		keylen = ds;
-	}
+	} else
+		memcpy(ipad, inkey, keylen);
 
-	memcpy(ipad, inkey, keylen);
 	memset(ipad + keylen, 0, bs - keylen);
 	memcpy(opad, ipad, bs);
 
@@ -78,24 +82,37 @@ static int hmac_setkey(struct crypto_shash *parent,
 		opad[i] ^= 0x5c;
 	}
 
-	return 0;
+	return crypto_shash_init(&desc.shash) ?:
+	       crypto_shash_update(&desc.shash, ipad, bs) ?:
+	       crypto_shash_export(&desc.shash, ipad) ?:
+	       crypto_shash_init(&desc.shash) ?:
+	       crypto_shash_update(&desc.shash, opad, bs) ?:
+	       crypto_shash_export(&desc.shash, opad);
 }
 
-static int hmac_init(struct shash_desc *pdesc)
+static int hmac_export(struct shash_desc *pdesc, void *out)
+{
+	struct shash_desc *desc = shash_desc_ctx(pdesc);
+
+	desc->flags = pdesc->flags & CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	return crypto_shash_export(desc, out);
+}
+
+static int hmac_import(struct shash_desc *pdesc, const void *in)
 {
-	struct crypto_shash *parent = pdesc->tfm;
-	int bs = crypto_shash_blocksize(parent);
-	int ds = crypto_shash_digestsize(parent);
-	char *ipad = crypto_shash_ctx_aligned(parent);
-	struct hmac_ctx *ctx = align_ptr(ipad + bs * 2 + ds,
-					 crypto_tfm_ctx_alignment());
 	struct shash_desc *desc = shash_desc_ctx(pdesc);
+	struct hmac_ctx *ctx = hmac_ctx(pdesc->tfm);
 
-	desc->tfm = ctx->desc->tfm;
+	desc->tfm = ctx->hash;
 	desc->flags = pdesc->flags & CRYPTO_TFM_REQ_MAY_SLEEP;
 
-	return crypto_shash_init(desc) ?:
-	       crypto_shash_update(desc, ipad, bs);
+	return crypto_shash_import(desc, in);
+}
+
+static int hmac_init(struct shash_desc *pdesc)
+{
+	return hmac_import(pdesc, crypto_shash_ctx_aligned(pdesc->tfm));
 }
 
 static int hmac_update(struct shash_desc *pdesc,
@@ -111,16 +128,16 @@ static int hmac_update(struct shash_desc *pdesc,
 static int hmac_final(struct shash_desc *pdesc, u8 *out)
 {
 	struct crypto_shash *parent = pdesc->tfm;
-	int bs = crypto_shash_blocksize(parent);
 	int ds = crypto_shash_digestsize(parent);
-	char *opad = crypto_shash_ctx_aligned(parent) + bs;
-	char *digest = opad + bs;
+	int ss = crypto_shash_statesize(parent);
+	char *opad = crypto_shash_ctx_aligned(parent) + ss;
 	struct shash_desc *desc = shash_desc_ctx(pdesc);
 
 	desc->flags = pdesc->flags & CRYPTO_TFM_REQ_MAY_SLEEP;
 
-	return crypto_shash_final(desc, digest) ?:
-	       crypto_shash_digest(desc, opad, bs + ds, out);
+	return crypto_shash_final(desc, out) ?:
+	       crypto_shash_import(desc, opad) ?:
+	       crypto_shash_finup(desc, out, ds, out);
 }
 
 static int hmac_finup(struct shash_desc *pdesc, const u8 *data,
@@ -128,16 +145,16 @@ static int hmac_finup(struct shash_desc *pdesc, const u8 *data,
 {
 
 	struct crypto_shash *parent = pdesc->tfm;
-	int bs = crypto_shash_blocksize(parent);
 	int ds = crypto_shash_digestsize(parent);
-	char *opad = crypto_shash_ctx_aligned(parent) + bs;
-	char *digest = opad + bs;
+	int ss = crypto_shash_statesize(parent);
+	char *opad = crypto_shash_ctx_aligned(parent) + ss;
 	struct shash_desc *desc = shash_desc_ctx(pdesc);
 
 	desc->flags = pdesc->flags & CRYPTO_TFM_REQ_MAY_SLEEP;
 
-	return crypto_shash_finup(desc, data, nbytes, digest) ?:
-	       crypto_shash_digest(desc, opad, bs + ds, out);
+	return crypto_shash_finup(desc, data, nbytes, out) ?:
+	       crypto_shash_import(desc, opad) ?:
+	       crypto_shash_finup(desc, out, ds, out);
 }
 
 static int hmac_init_tfm(struct crypto_tfm *tfm)
@@ -155,21 +172,14 @@ static int hmac_init_tfm(struct crypto_tfm *tfm)
 	parent->descsize = sizeof(struct shash_desc) +
 			   crypto_shash_descsize(hash);
 
-	ctx->desc = kmalloc(parent->descsize, GFP_KERNEL);
-	if (!ctx->desc) {
-		crypto_free_shash(hash);
-		return -ENOMEM;
-	}
-
-	ctx->desc->tfm = hash;
+	ctx->hash = hash;
 	return 0;
 }
 
 static void hmac_exit_tfm(struct crypto_tfm *tfm)
 {
 	struct hmac_ctx *ctx = hmac_ctx(__crypto_shash_cast(tfm));
-	crypto_free_shash(ctx->desc->tfm);
-	kzfree(ctx->desc);
+	crypto_free_shash(ctx->hash);
 }
 
 static int hmac_create(struct crypto_template *tmpl, struct rtattr **tb)
@@ -179,6 +189,7 @@ static int hmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	struct shash_alg *salg;
 	int err;
 	int ds;
+	int ss;
 
 	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SHASH);
 	if (err)
@@ -190,8 +201,10 @@ static int hmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 
 	err = -EINVAL;
 	ds = salg->digestsize;
+	ss = salg->statesize;
 	alg = &salg->base;
-	if (ds > alg->cra_blocksize)
+	if (ds > alg->cra_blocksize ||
+	    ss < alg->cra_blocksize)
 		goto out_put_alg;
 
 	inst = shash_alloc_instance("hmac", alg);
@@ -208,11 +221,12 @@ static int hmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.base.cra_blocksize = alg->cra_blocksize;
 	inst->alg.base.cra_alignmask = alg->cra_alignmask;
 
+	ss = ALIGN(ss, alg->cra_alignmask + 1);
 	inst->alg.digestsize = ds;
+	inst->alg.statesize = ss;
 
 	inst->alg.base.cra_ctxsize = sizeof(struct hmac_ctx) +
-				     ALIGN(alg->cra_blocksize * 2 + ds,
-					   crypto_tfm_ctx_alignment());
+				     ALIGN(ss * 2, crypto_tfm_ctx_alignment());
 
 	inst->alg.base.cra_init = hmac_init_tfm;
 	inst->alg.base.cra_exit = hmac_exit_tfm;
@@ -221,6 +235,8 @@ static int hmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.update = hmac_update;
 	inst->alg.final = hmac_final;
 	inst->alg.finup = hmac_finup;
+	inst->alg.export = hmac_export;
+	inst->alg.import = hmac_import;
 	inst->alg.setkey = hmac_setkey;
 
 	err = shash_register_instance(tmpl, inst);

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
