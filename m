From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5/14] crypto: echainiv - Fix encryption convention
Date: Thu, 09 Jul 2015 07:17:20 +0800
Message-ID: <E1ZCyae-0007YQ-OW@gondolin.me.apana.org.au>
References: <20150708231330.GA28797@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54923 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbbGHXRY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Jul 2015 19:17:24 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1ZCyaf-0005EB-Q3
	for <linux-crypto@vger.kernel.org>; Thu, 09 Jul 2015 09:17:22 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch fixes a bug where we were incorrectly including the
IV in the AD during encryption.  The IV must remain in the plain
text for it to be encrypted.

During decryption there is no need to copy the IV to dst because
it's now part of the AD.

This patch removes an unncessary check on authsize which would be
performed by the underlying decrypt call.

Finally this patch makes use of the type-safe init/exit functions.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/echainiv.c |   24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/crypto/echainiv.c b/crypto/echainiv.c
index b6e43dc..d3896c7 100644
--- a/crypto/echainiv.c
+++ b/crypto/echainiv.c
@@ -145,8 +145,8 @@ static int echainiv_encrypt(struct aead_request *req)
 
 	aead_request_set_callback(subreq, req->base.flags, compl, data);
 	aead_request_set_crypt(subreq, req->dst, req->dst,
-			       req->cryptlen - ivsize, info);
-	aead_request_set_ad(subreq, req->assoclen + ivsize);
+			       req->cryptlen, info);
+	aead_request_set_ad(subreq, req->assoclen);
 
 	crypto_xor(info, ctx->salt, ivsize);
 	scatterwalk_map_and_copy(info, req->dst, req->assoclen, ivsize, 1);
@@ -166,7 +166,7 @@ static int echainiv_decrypt(struct aead_request *req)
 	void *data;
 	unsigned int ivsize = crypto_aead_ivsize(geniv);
 
-	if (req->cryptlen < ivsize + crypto_aead_authsize(geniv))
+	if (req->cryptlen < ivsize)
 		return -EINVAL;
 
 	aead_request_set_tfm(subreq, ctx->geniv.child);
@@ -180,16 +180,12 @@ static int echainiv_decrypt(struct aead_request *req)
 	aead_request_set_ad(subreq, req->assoclen + ivsize);
 
 	scatterwalk_map_and_copy(req->iv, req->src, req->assoclen, ivsize, 0);
-	if (req->src != req->dst)
-		scatterwalk_map_and_copy(req->iv, req->dst,
-					 req->assoclen, ivsize, 1);
 
 	return crypto_aead_decrypt(subreq);
 }
 
-static int echainiv_init(struct crypto_tfm *tfm)
+static int echainiv_init(struct crypto_aead *geniv)
 {
-	struct crypto_aead *geniv = __crypto_aead_cast(tfm);
 	struct echainiv_ctx *ctx = crypto_aead_ctx(geniv);
 	int err;
 
@@ -212,7 +208,7 @@ static int echainiv_init(struct crypto_tfm *tfm)
 	if (IS_ERR(ctx->null))
 		goto out;
 
-	err = aead_geniv_init(tfm);
+	err = aead_geniv_init(crypto_aead_tfm(geniv));
 	if (err)
 		goto drop_null;
 
@@ -227,9 +223,9 @@ drop_null:
 	goto out;
 }
 
-static void echainiv_exit(struct crypto_tfm *tfm)
+static void echainiv_exit(struct crypto_aead *tfm)
 {
-	struct echainiv_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct echainiv_ctx *ctx = crypto_aead_ctx(tfm);
 
 	crypto_free_aead(ctx->geniv.child);
 	crypto_put_default_null_skcipher();
@@ -262,13 +258,15 @@ static int echainiv_aead_create(struct crypto_template *tmpl,
 	inst->alg.encrypt = echainiv_encrypt;
 	inst->alg.decrypt = echainiv_decrypt;
 
-	inst->alg.base.cra_init = echainiv_init;
-	inst->alg.base.cra_exit = echainiv_exit;
+	inst->alg.init = echainiv_init;
+	inst->alg.exit = echainiv_exit;
 
 	inst->alg.base.cra_alignmask |= __alignof__(u32) - 1;
 	inst->alg.base.cra_ctxsize = sizeof(struct echainiv_ctx);
 	inst->alg.base.cra_ctxsize += inst->alg.ivsize;
 
+	inst->free = aead_geniv_free;
+
 done:
 	err = aead_register_instance(tmpl, inst);
 	if (err)
