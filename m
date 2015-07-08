From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6/14] crypto: seqiv - Replace seqniv with seqiv
Date: Thu, 09 Jul 2015 07:17:22 +0800
Message-ID: <E1ZCyag-0007Yp-Cl@gondolin.me.apana.org.au>
References: <20150708231330.GA28797@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60478 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbbGHXR0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Jul 2015 19:17:26 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1ZCyah-0005EX-4f
	for <linux-crypto@vger.kernel.org>; Thu, 09 Jul 2015 09:17:23 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch replaces the seqniv generator with seqiv when the
underlying algorithm understands the new calling convention.

This not only makes more sense as now seqiv is solely responsible
for IV generation rather than also determining how the IV is going
to be used, it also allows for optimisations in the underlying
implementation.  For example, the space for the IV could be used
to add padding for authentication.

This patch also removes the unnecessary copying of IV to dst
during seqiv decryption as the IV is part of the AD and not cipher
text.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/seqiv.c |   34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/crypto/seqiv.c b/crypto/seqiv.c
index 122c56e..45d0563 100644
--- a/crypto/seqiv.c
+++ b/crypto/seqiv.c
@@ -467,9 +467,6 @@ static int seqiv_aead_decrypt(struct aead_request *req)
 	aead_request_set_ad(subreq, req->assoclen + ivsize);
 
 	scatterwalk_map_and_copy(req->iv, req->src, req->assoclen, ivsize, 0);
-	if (req->src != req->dst)
-		scatterwalk_map_and_copy(req->iv, req->dst,
-					 req->assoclen, ivsize, 1);
 
 	return crypto_aead_decrypt(subreq);
 }
@@ -516,9 +513,9 @@ static int seqiv_old_aead_init(struct crypto_tfm *tfm)
 	return err ?: aead_geniv_init(tfm);
 }
 
-static int seqiv_aead_init_common(struct crypto_tfm *tfm, unsigned int reqsize)
+static int seqiv_aead_init_common(struct crypto_aead *geniv,
+				  unsigned int reqsize)
 {
-	struct crypto_aead *geniv = __crypto_aead_cast(tfm);
 	struct seqiv_aead_ctx *ctx = crypto_aead_ctx(geniv);
 	int err;
 
@@ -541,7 +538,7 @@ static int seqiv_aead_init_common(struct crypto_tfm *tfm, unsigned int reqsize)
 	if (IS_ERR(ctx->null))
 		goto out;
 
-	err = aead_geniv_init(tfm);
+	err = aead_geniv_init(crypto_aead_tfm(geniv));
 	if (err)
 		goto drop_null;
 
@@ -556,19 +553,19 @@ drop_null:
 	goto out;
 }
 
-static int seqiv_aead_init(struct crypto_tfm *tfm)
+static int seqiv_aead_init(struct crypto_aead *tfm)
 {
 	return seqiv_aead_init_common(tfm, sizeof(struct aead_request));
 }
 
-static int seqniv_aead_init(struct crypto_tfm *tfm)
+static int seqniv_aead_init(struct crypto_aead *tfm)
 {
 	return seqiv_aead_init_common(tfm, sizeof(struct seqniv_request_ctx));
 }
 
-static void seqiv_aead_exit(struct crypto_tfm *tfm)
+static void seqiv_aead_exit(struct crypto_aead *tfm)
 {
-	struct seqiv_aead_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct seqiv_aead_ctx *ctx = crypto_aead_ctx(tfm);
 
 	crypto_free_aead(ctx->geniv.child);
 	crypto_put_default_null_skcipher();
@@ -666,11 +663,11 @@ static int seqiv_aead_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.encrypt = seqiv_aead_encrypt;
 	inst->alg.decrypt = seqiv_aead_decrypt;
 
-	inst->alg.base.cra_init = seqiv_aead_init;
-	inst->alg.base.cra_exit = seqiv_aead_exit;
+	inst->alg.init = seqiv_aead_init;
+	inst->alg.exit = seqiv_aead_exit;
 
 	inst->alg.base.cra_ctxsize = sizeof(struct seqiv_aead_ctx);
-	inst->alg.base.cra_ctxsize += inst->alg.base.cra_aead.ivsize;
+	inst->alg.base.cra_ctxsize += inst->alg.ivsize;
 
 done:
 	err = aead_register_instance(tmpl, inst);
@@ -727,8 +724,15 @@ static int seqniv_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.encrypt = seqniv_aead_encrypt;
 	inst->alg.decrypt = seqniv_aead_decrypt;
 
-	inst->alg.base.cra_init = seqniv_aead_init;
-	inst->alg.base.cra_exit = seqiv_aead_exit;
+	inst->alg.init = seqniv_aead_init;
+	inst->alg.exit = seqiv_aead_exit;
+
+	if ((alg->base.cra_flags & CRYPTO_ALG_AEAD_NEW)) {
+		inst->alg.encrypt = seqiv_aead_encrypt;
+		inst->alg.decrypt = seqiv_aead_decrypt;
+
+		inst->alg.init = seqiv_aead_init;
+	}
 
 	inst->alg.base.cra_alignmask |= __alignof__(u32) - 1;
 	inst->alg.base.cra_ctxsize = sizeof(struct seqiv_aead_ctx);
