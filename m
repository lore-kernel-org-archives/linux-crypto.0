From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/4] [CRYPTO] aead: Make authsize a run-time parameter
Date: Sun, 02 Dec 2007 18:53:09 +1100
Message-ID: <E1IyjdV-0001Wy-00@gondolin.me.apana.org.au>
References: <20071122083656.GB7368@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2735 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751793AbXLBHxM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 2 Dec 2007 02:53:12 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1IyjdV-00089N-Vg
	for <linux-crypto@vger.kernel.org>; Sun, 02 Dec 2007 18:53:10 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] aead: Make authsize a run-time parameter

As it is authsize is an algorithm paramter which cannot be changed at
run-time.  This is inconvenient because hardware that implements such
algorithms would have to register each authsize that they support
separately.

Since authsize is a property common to all AEAD algorithms, we can add
a function setauthsize that sets it at run-time, just like setkey.

This patch does exactly that and also changes authenc so that authsize
is no longer a parameter of its template.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/aead.c          |   24 +++++++++++++++++++++---
 crypto/authenc.c       |   39 ++++++++++++---------------------------
 crypto/gcm.c           |    2 +-
 include/linux/crypto.h |    5 ++++-
 4 files changed, 38 insertions(+), 32 deletions(-)

diff --git a/crypto/aead.c b/crypto/aead.c
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -53,6 +53,24 @@ static int setkey(struct crypto_aead *tf
 	return aead->setkey(tfm, key, keylen);
 }
 
+int crypto_aead_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
+{
+	int err;
+
+	if (authsize > crypto_aead_alg(tfm)->maxauthsize)
+		return -EINVAL;
+
+	if (crypto_aead_alg(tfm)->setauthsize) {
+		err = crypto_aead_alg(tfm)->setauthsize(tfm, authsize);
+		if (err)
+			return err;
+	}
+
+	crypto_aead_crt(tfm)->authsize = authsize;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(crypto_aead_setauthsize);
+
 static unsigned int crypto_aead_ctxsize(struct crypto_alg *alg, u32 type,
 					u32 mask)
 {
@@ -64,14 +82,14 @@ static int crypto_init_aead_ops(struct c
 	struct aead_alg *alg = &tfm->__crt_alg->cra_aead;
 	struct aead_tfm *crt = &tfm->crt_aead;
 
-	if (max(alg->authsize, alg->ivsize) > PAGE_SIZE / 8)
+	if (max(alg->maxauthsize, alg->ivsize) > PAGE_SIZE / 8)
 		return -EINVAL;
 
 	crt->setkey = setkey;
 	crt->encrypt = alg->encrypt;
 	crt->decrypt = alg->decrypt;
 	crt->ivsize = alg->ivsize;
-	crt->authsize = alg->authsize;
+	crt->authsize = alg->maxauthsize;
 
 	return 0;
 }
@@ -85,7 +103,7 @@ static void crypto_aead_show(struct seq_
 	seq_printf(m, "type         : aead\n");
 	seq_printf(m, "blocksize    : %u\n", alg->cra_blocksize);
 	seq_printf(m, "ivsize       : %u\n", aead->ivsize);
-	seq_printf(m, "authsize     : %u\n", aead->authsize);
+	seq_printf(m, "maxauthsize  : %u\n", aead->maxauthsize);
 }
 
 const struct crypto_type crypto_aead_type = {
diff --git a/crypto/authenc.c b/crypto/authenc.c
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -24,7 +24,6 @@ struct authenc_instance_ctx {
 	struct crypto_spawn auth;
 	struct crypto_spawn enc;
 
-	unsigned int authsize;
 	unsigned int enckeylen;
 };
 
@@ -76,8 +75,6 @@ out:
 static int crypto_authenc_hash(struct aead_request *req)
 {
 	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
-	struct authenc_instance_ctx *ictx =
-		crypto_instance_ctx(crypto_aead_alg_instance(authenc));
 	struct crypto_authenc_ctx *ctx = crypto_aead_ctx(authenc);
 	struct crypto_hash *auth = ctx->auth;
 	struct hash_desc desc = {
@@ -111,7 +108,8 @@ auth_unlock:
 	if (err)
 		return err;
 
-	scatterwalk_map_and_copy(hash, dst, cryptlen, ictx->authsize, 1);
+	scatterwalk_map_and_copy(hash, dst, cryptlen,
+				 crypto_aead_authsize(authenc), 1);
 	return 0;
 }
 
@@ -147,8 +145,6 @@ static int crypto_authenc_encrypt(struct
 static int crypto_authenc_verify(struct aead_request *req)
 {
 	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
-	struct authenc_instance_ctx *ictx =
-		crypto_instance_ctx(crypto_aead_alg_instance(authenc));
 	struct crypto_authenc_ctx *ctx = crypto_aead_ctx(authenc);
 	struct crypto_hash *auth = ctx->auth;
 	struct hash_desc desc = {
@@ -186,7 +182,7 @@ auth_unlock:
 	if (err)
 		return err;
 
-	authsize = ictx->authsize;
+	authsize = crypto_aead_authsize(authenc);
 	scatterwalk_map_and_copy(ihash, src, cryptlen, authsize, 0);
 	return memcmp(ihash, ohash, authsize) ? -EINVAL : 0;
 }
@@ -224,18 +220,12 @@ static int crypto_authenc_init_tfm(struc
 	struct crypto_authenc_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct crypto_hash *auth;
 	struct crypto_ablkcipher *enc;
-	unsigned int digestsize;
 	int err;
 
 	auth = crypto_spawn_hash(&ictx->auth);
 	if (IS_ERR(auth))
 		return PTR_ERR(auth);
 
-	err = -EINVAL;
-	digestsize = crypto_hash_digestsize(auth);
-	if (ictx->authsize > digestsize)
-		goto err_free_hash;
-
 	enc = crypto_spawn_ablkcipher(&ictx->enc);
 	err = PTR_ERR(enc);
 	if (IS_ERR(enc))
@@ -246,7 +236,7 @@ static int crypto_authenc_init_tfm(struc
 	tfm->crt_aead.reqsize = max_t(unsigned int,
 				      (crypto_hash_alignmask(auth) &
 				       ~(crypto_tfm_ctx_alignment() - 1)) +
-				      digestsize * 2,
+				      crypto_hash_digestsize(auth) * 2,
 				      sizeof(struct ablkcipher_request) +
 				      crypto_ablkcipher_reqsize(enc));
 
@@ -273,7 +263,6 @@ static struct crypto_instance *crypto_au
 	struct crypto_alg *auth;
 	struct crypto_alg *enc;
 	struct authenc_instance_ctx *ctx;
-	unsigned int authsize;
 	unsigned int enckeylen;
 	int err;
 
@@ -286,18 +275,13 @@ static struct crypto_instance *crypto_au
 	if (IS_ERR(auth))
 		return ERR_PTR(PTR_ERR(auth));
 
-	err = crypto_attr_u32(tb[2], &authsize);
-	inst = ERR_PTR(err);
-	if (err)
-		goto out_put_auth;
-
-	enc = crypto_attr_alg(tb[3], CRYPTO_ALG_TYPE_BLKCIPHER,
+	enc = crypto_attr_alg(tb[2], CRYPTO_ALG_TYPE_BLKCIPHER,
 			      CRYPTO_ALG_TYPE_BLKCIPHER_MASK);
 	inst = ERR_PTR(PTR_ERR(enc));
 	if (IS_ERR(enc))
 		goto out_put_auth;
 
-	err = crypto_attr_u32(tb[4], &enckeylen);
+	err = crypto_attr_u32(tb[3], &enckeylen);
 	if (err)
 		goto out_put_enc;
 
@@ -308,18 +292,17 @@ static struct crypto_instance *crypto_au
 
 	err = -ENAMETOOLONG;
 	if (snprintf(inst->alg.cra_name, CRYPTO_MAX_ALG_NAME,
-		     "authenc(%s,%u,%s,%u)", auth->cra_name, authsize,
+		     "authenc(%s,%s,%u)", auth->cra_name,
 		     enc->cra_name, enckeylen) >= CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
 	if (snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME,
-		     "authenc(%s,%u,%s,%u)", auth->cra_driver_name,
-		     authsize, enc->cra_driver_name, enckeylen) >=
+		     "authenc(%s,%s,%u)", auth->cra_driver_name,
+		     enc->cra_driver_name, enckeylen) >=
 	    CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
 	ctx = crypto_instance_ctx(inst);
-	ctx->authsize = authsize;
 	ctx->enckeylen = enckeylen;
 
 	err = crypto_init_spawn(&ctx->auth, auth, inst, CRYPTO_ALG_TYPE_MASK);
@@ -337,7 +320,9 @@ static struct crypto_instance *crypto_au
 	inst->alg.cra_type = &crypto_aead_type;
 
 	inst->alg.cra_aead.ivsize = enc->cra_blkcipher.ivsize;
-	inst->alg.cra_aead.authsize = authsize;
+	inst->alg.cra_aead.maxauthsize = auth->cra_type == &crypto_hash_type ?
+					 auth->cra_hash.digestsize :
+					 auth->cra_digest.dia_digestsize;
 
 	inst->alg.cra_ctxsize = sizeof(struct crypto_authenc_ctx);
 
diff --git a/crypto/gcm.c b/crypto/gcm.c
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -414,7 +414,7 @@ static struct crypto_instance *crypto_gc
 	inst->alg.cra_alignmask = __alignof__(u32) - 1;
 	inst->alg.cra_type = &crypto_aead_type;
 	inst->alg.cra_aead.ivsize = 12;
-	inst->alg.cra_aead.authsize = 16;
+	inst->alg.cra_aead.maxauthsize = 16;
 	inst->alg.cra_ctxsize = sizeof(struct crypto_gcm_ctx);
 	inst->alg.cra_init = crypto_gcm_init_tfm;
 	inst->alg.cra_exit = crypto_gcm_exit_tfm;
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -187,11 +187,12 @@ struct ablkcipher_alg {
 struct aead_alg {
 	int (*setkey)(struct crypto_aead *tfm, const u8 *key,
 	              unsigned int keylen);
+	int (*setauthsize)(struct crypto_aead *tfm, unsigned int authsize);
 	int (*encrypt)(struct aead_request *req);
 	int (*decrypt)(struct aead_request *req);
 
 	unsigned int ivsize;
-	unsigned int authsize;
+	unsigned int maxauthsize;
 };
 
 struct blkcipher_alg {
@@ -754,6 +755,8 @@ static inline int crypto_aead_setkey(str
 	return crypto_aead_crt(tfm)->setkey(tfm, key, keylen);
 }
 
+int crypto_aead_setauthsize(struct crypto_aead *tfm, unsigned int authsize);
+
 static inline struct crypto_aead *crypto_aead_reqtfm(struct aead_request *req)
 {
 	return __crypto_aead_cast(req->base.tfm);
