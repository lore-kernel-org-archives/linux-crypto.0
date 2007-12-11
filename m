From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 18/19] [CRYPTO] gcm: Add givcrypt operations
Date: Tue, 11 Dec 2007 12:05:47 +0800
Message-ID: <E1J1wNP-0002la-00@gondolin.me.apana.org.au>
References: <20071211040215.GA10360@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1975 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751972AbXLKEF4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Dec 2007 23:05:56 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J1wNS-00068R-5C
	for <linux-crypto@vger.kernel.org>; Tue, 11 Dec 2007 15:05:51 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] gcm: Add givcrypt operations
    
This patch implements the givcrypt functions for gcm.  It simply calls
the givcrypt operations on the underlying cipher instead of encrypt or
decrypt.
    
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/gcm.c |   75 ++++++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 67 insertions(+), 8 deletions(-)

diff --git a/crypto/gcm.c b/crypto/gcm.c
index 1fdefe5..7775ea0 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -8,6 +8,7 @@
  * by the Free Software Foundation.
  */
 
+#include <crypto/aead.h>
 #include <crypto/ctr.h>
 #include <crypto/gf128mul.h>
 #include <crypto/internal/skcipher.h>
@@ -41,7 +42,7 @@ struct crypto_gcm_req_priv_ctx {
 	u8 auth_tag[16];
 	u8 iauth_tag[16];
 	struct crypto_gcm_ghash_ctx ghash;
-	struct ablkcipher_request abreq;
+	struct skcipher_givcrypt_request greq;
 };
 
 static void crypto_gcm_ghash_init(struct crypto_gcm_ghash_ctx *ctx, u32 flags,
@@ -271,15 +272,21 @@ static void crypto_gcm_encrypt_done(struct crypto_async_request *areq, int err)
 	aead_request_complete(req, err);
 }
 
+static void crypto_gcm_init_encrypt(struct ablkcipher_request *abreq,
+				    struct aead_request *req)
+{
+	crypto_gcm_init_crypt(abreq, req, req->cryptlen);
+	ablkcipher_request_set_callback(abreq, aead_request_flags(req),
+					crypto_gcm_encrypt_done, req);
+}
+
 static int crypto_gcm_encrypt(struct aead_request *req)
 {
 	struct crypto_gcm_req_priv_ctx *pctx = aead_request_ctx(req);
-	struct ablkcipher_request *abreq = &pctx->abreq;
+	struct ablkcipher_request *abreq = &pctx->greq.creq;
 	int err;
 
-	crypto_gcm_init_crypt(abreq, req, req->cryptlen);
-	ablkcipher_request_set_callback(abreq, aead_request_flags(req),
-					crypto_gcm_encrypt_done, req);
+	crypto_gcm_init_encrypt(abreq, req);
 
 	err = crypto_ablkcipher_encrypt(abreq);
 	if (err)
@@ -288,6 +295,24 @@ static int crypto_gcm_encrypt(struct aead_request *req)
 	return crypto_gcm_hash(req);
 }
 
+static int crypto_gcm_givencrypt(struct aead_givcrypt_request *req)
+{
+	struct aead_request *areq = &req->areq;
+	struct crypto_gcm_req_priv_ctx *pctx = aead_request_ctx(areq);
+	struct skcipher_givcrypt_request *greq = &pctx->greq;
+	struct ablkcipher_request *abreq = &greq->creq;
+	int err;
+
+	crypto_gcm_init_encrypt(abreq, areq);
+	skcipher_givcrypt_set_giv(greq, req->giv, req->seq);
+
+	err = crypto_skcipher_givencrypt(greq);
+	if (err)
+		return err;
+
+	return crypto_gcm_hash(areq);
+}
+
 static int crypto_gcm_verify(struct aead_request *req)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
@@ -315,15 +340,14 @@ static void crypto_gcm_decrypt_done(struct crypto_async_request *areq, int err)
 	aead_request_complete(req, err);
 }
 
-static int crypto_gcm_decrypt(struct aead_request *req)
+static int crypto_gcm_init_decrypt(struct ablkcipher_request *abreq,
+				   struct aead_request *req)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct crypto_gcm_req_priv_ctx *pctx = aead_request_ctx(req);
-	struct ablkcipher_request *abreq = &pctx->abreq;
 	struct crypto_gcm_ghash_ctx *ghash = &pctx->ghash;
 	unsigned int cryptlen = req->cryptlen;
 	unsigned int authsize = crypto_aead_authsize(aead);
-	int err;
 
 	if (cryptlen < authsize)
 		return -EINVAL;
@@ -334,6 +358,18 @@ static int crypto_gcm_decrypt(struct aead_request *req)
 					crypto_gcm_decrypt_done, req);
 
 	crypto_gcm_ghash_update_sg(ghash, req->src, cryptlen);
+	return 0;
+}
+
+static int crypto_gcm_decrypt(struct aead_request *req)
+{
+	struct crypto_gcm_req_priv_ctx *pctx = aead_request_ctx(req);
+	struct ablkcipher_request *abreq = &pctx->greq.creq;
+	int err;
+
+	err = crypto_gcm_init_decrypt(abreq, req);
+	if (err)
+		return err;
 
 	err = crypto_ablkcipher_decrypt(abreq);
 	if (err)
@@ -342,6 +378,27 @@ static int crypto_gcm_decrypt(struct aead_request *req)
 	return crypto_gcm_verify(req);
 }
 
+static int crypto_gcm_givdecrypt(struct aead_givcrypt_request *req)
+{
+	struct aead_request *areq = &req->areq;
+	struct crypto_gcm_req_priv_ctx *pctx = aead_request_ctx(areq);
+	struct skcipher_givcrypt_request *greq = &pctx->greq;
+	struct ablkcipher_request *abreq = &greq->creq;
+	int err;
+
+	err = crypto_gcm_init_decrypt(abreq, areq);
+	if (err)
+		return err;
+
+	skcipher_givcrypt_set_giv(greq, req->giv, req->seq);
+
+	err = crypto_skcipher_givdecrypt(greq);
+	if (err)
+		return err;
+
+	return crypto_gcm_verify(areq);
+}
+
 static int crypto_gcm_init_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_instance *inst = (void *)tfm->__crt_alg;
@@ -440,6 +497,8 @@ static struct crypto_instance *crypto_gcm_alloc_common(struct rtattr **tb,
 	inst->alg.cra_aead.setkey = crypto_gcm_setkey;
 	inst->alg.cra_aead.encrypt = crypto_gcm_encrypt;
 	inst->alg.cra_aead.decrypt = crypto_gcm_decrypt;
+	inst->alg.cra_aead.givencrypt = crypto_gcm_givencrypt;
+	inst->alg.cra_aead.givdecrypt = crypto_gcm_givdecrypt;
 
 out:
 	return inst;
