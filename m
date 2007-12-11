From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 17/19] [CRYPTO] authenc: Add givencrypt operation
Date: Tue, 11 Dec 2007 12:05:45 +0800
Message-ID: <E1J1wNN-0002lT-00@gondolin.me.apana.org.au>
References: <20071211040215.GA10360@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1973 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751956AbXLKEFy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Dec 2007 23:05:54 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J1wNQ-00068H-Fl
	for <linux-crypto@vger.kernel.org>; Tue, 11 Dec 2007 15:05:49 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] authenc: Add givencrypt operation

This patch implements the givencrypt function for authenc.  It simply
calls the givencrypt operation on the underlying cipher instead of encrypt.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/authenc.c |  136 ++++++++++++++++++++++++++++++++++++++++++++++---------
 1 files changed, 114 insertions(+), 22 deletions(-)

diff --git a/crypto/authenc.c b/crypto/authenc.c
index 7ef0a58..caa0853 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -10,6 +10,7 @@
  *
  */
 
+#include <crypto/aead.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/authenc.h>
 #include <crypto/scatterwalk.h>
@@ -87,6 +88,20 @@ badkey:
 	goto out;
 }
 
+static void authenc_chain(struct scatterlist *head, struct scatterlist *sg,
+			  int chain)
+{
+	if (chain) {
+		head->length += sg->length;
+		sg = scatterwalk_sg_next(sg);
+	}
+
+	if (sg)
+		scatterwalk_sg_chain(head, 2, sg);
+	else
+		sg_mark_end(head);
+}
+
 static u8 *crypto_authenc_hash(struct aead_request *req, unsigned int flags,
 			       struct scatterlist *cipher,
 			       unsigned int cryptlen)
@@ -127,18 +142,31 @@ auth_unlock:
 	return hash;
 }
 
-static int crypto_authenc_genicv(struct aead_request *req, unsigned int flags)
+static int crypto_authenc_genicv(struct aead_request *req, u8 *iv,
+				 unsigned int flags)
 {
 	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
 	struct scatterlist *dst = req->dst;
-	unsigned int cryptlen = req->cryptlen;
+	struct scatterlist cipher[2];
+	struct page *dstp;
+	unsigned int ivsize = crypto_aead_ivsize(authenc);
+	unsigned int cryptlen;
+	u8 *vdst;
 	u8 *hash;
 
-	hash = crypto_authenc_hash(req, flags, dst, cryptlen);
+	dstp = sg_page(dst);
+	vdst = PageHighMem(dstp) ? NULL : page_address(dstp) + dst->offset;
+
+	sg_init_table(cipher, 2);
+	sg_set_buf(cipher, iv, ivsize);
+	authenc_chain(cipher, dst, vdst == iv + ivsize);
+
+	cryptlen = req->cryptlen + ivsize;
+	hash = crypto_authenc_hash(req, flags, cipher, cryptlen);
 	if (IS_ERR(hash))
 		return PTR_ERR(hash);
 
-	scatterwalk_map_and_copy(hash, dst, cryptlen,
+	scatterwalk_map_and_copy(hash, cipher, cryptlen,
 				 crypto_aead_authsize(authenc), 1);
 	return 0;
 }
@@ -146,8 +174,16 @@ static int crypto_authenc_genicv(struct aead_request *req, unsigned int flags)
 static void crypto_authenc_encrypt_done(struct crypto_async_request *req,
 					int err)
 {
-	if (!err)
-		err = crypto_authenc_genicv(req->data, 0);
+	if (!err) {
+		struct aead_request *areq = req->data;
+		struct crypto_aead *authenc = crypto_aead_reqtfm(areq);
+		struct crypto_authenc_ctx *ctx = crypto_aead_ctx(authenc);
+		struct ablkcipher_request *abreq = aead_request_ctx(areq);
+		u8 *iv = (u8 *)(abreq + 1) +
+			 crypto_ablkcipher_reqsize(ctx->enc);
+
+		err = crypto_authenc_genicv(areq, iv, 0);
+	}
 
 	aead_request_complete(req->data, err);
 }
@@ -157,45 +193,99 @@ static int crypto_authenc_encrypt(struct aead_request *req)
 	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
 	struct crypto_authenc_ctx *ctx = crypto_aead_ctx(authenc);
 	struct ablkcipher_request *abreq = aead_request_ctx(req);
+	struct crypto_ablkcipher *enc = ctx->enc;
+	struct scatterlist *dst = req->dst;
+	unsigned int cryptlen = req->cryptlen;
+	u8 *iv = (u8 *)(abreq + 1) + crypto_ablkcipher_reqsize(enc);
 	int err;
 
-	ablkcipher_request_set_tfm(abreq, ctx->enc);
+	ablkcipher_request_set_tfm(abreq, enc);
 	ablkcipher_request_set_callback(abreq, aead_request_flags(req),
 					crypto_authenc_encrypt_done, req);
-	ablkcipher_request_set_crypt(abreq, req->src, req->dst, req->cryptlen,
-				     req->iv);
+	ablkcipher_request_set_crypt(abreq, req->src, dst, cryptlen, req->iv);
+
+	memcpy(iv, req->iv, crypto_aead_ivsize(authenc));
 
 	err = crypto_ablkcipher_encrypt(abreq);
 	if (err)
 		return err;
 
-	return crypto_authenc_genicv(req, CRYPTO_TFM_REQ_MAY_SLEEP);
+	return crypto_authenc_genicv(req, iv, CRYPTO_TFM_REQ_MAY_SLEEP);
+}
+
+static void crypto_authenc_givencrypt_done(struct crypto_async_request *req,
+					   int err)
+{
+	if (!err) {
+		struct aead_givcrypt_request *greq = req->data;
+
+		err = crypto_authenc_genicv(&greq->areq, greq->giv, 0);
+	}
+
+	aead_request_complete(req->data, err);
+}
+
+static int crypto_authenc_givencrypt(struct aead_givcrypt_request *req)
+{
+	struct crypto_aead *authenc = aead_givcrypt_reqtfm(req);
+	struct crypto_authenc_ctx *ctx = crypto_aead_ctx(authenc);
+	struct aead_request *areq = &req->areq;
+	struct skcipher_givcrypt_request *greq = aead_request_ctx(areq);
+	u8 *iv = req->giv;
+	int err;
+
+	skcipher_givcrypt_set_tfm(greq, ctx->enc);
+	skcipher_givcrypt_set_callback(greq, aead_request_flags(areq),
+				       crypto_authenc_givencrypt_done, areq);
+	skcipher_givcrypt_set_crypt(greq, areq->src, areq->dst, areq->cryptlen,
+				    areq->iv);
+	skcipher_givcrypt_set_giv(greq, iv, req->seq);
+
+	err = crypto_skcipher_givencrypt(greq);
+	if (err)
+		return err;
+
+	return crypto_authenc_genicv(areq, iv, CRYPTO_TFM_REQ_MAY_SLEEP);
 }
 
 static int crypto_authenc_verify(struct aead_request *req,
+				 struct scatterlist *cipher,
 				 unsigned int cryptlen)
 {
 	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
 	u8 *ohash;
 	u8 *ihash;
-	struct scatterlist *src = req->src;
 	unsigned int authsize;
 
-	ohash = crypto_authenc_hash(req, CRYPTO_TFM_REQ_MAY_SLEEP, src,
+	ohash = crypto_authenc_hash(req, CRYPTO_TFM_REQ_MAY_SLEEP, cipher,
 				    cryptlen);
 	if (IS_ERR(ohash))
 		return PTR_ERR(ohash);
 
 	authsize = crypto_aead_authsize(authenc);
 	ihash = ohash + authsize;
-	scatterwalk_map_and_copy(ihash, src, cryptlen, authsize, 0);
+	scatterwalk_map_and_copy(ihash, cipher, cryptlen, authsize, 0);
 	return memcmp(ihash, ohash, authsize) ? -EBADMSG: 0;
 }
 
-static void crypto_authenc_decrypt_done(struct crypto_async_request *req,
-					int err)
+static int crypto_authenc_iverify(struct aead_request *req, u8 *iv,
+				  unsigned int cryptlen)
 {
-	aead_request_complete(req->data, err);
+	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
+	struct scatterlist *src = req->src;
+	struct scatterlist cipher[2];
+	struct page *srcp;
+	unsigned int ivsize = crypto_aead_ivsize(authenc);
+	u8 *vsrc;
+
+	srcp = sg_page(src);
+	vsrc = PageHighMem(srcp) ? NULL : page_address(srcp) + src->offset;
+
+	sg_init_table(cipher, 2);
+	sg_set_buf(cipher, iv, ivsize);
+	authenc_chain(cipher, src, vsrc == iv + ivsize);
+
+	return crypto_authenc_verify(req, cipher, cryptlen + ivsize);
 }
 
 static int crypto_authenc_decrypt(struct aead_request *req)
@@ -205,21 +295,21 @@ static int crypto_authenc_decrypt(struct aead_request *req)
 	struct ablkcipher_request *abreq = aead_request_ctx(req);
 	unsigned int cryptlen = req->cryptlen;
 	unsigned int authsize = crypto_aead_authsize(authenc);
+	u8 *iv = req->iv;
 	int err;
 
 	if (cryptlen < authsize)
 		return -EINVAL;
 	cryptlen -= authsize;
 
-	err = crypto_authenc_verify(req, cryptlen);
+	err = crypto_authenc_iverify(req, iv, cryptlen);
 	if (err)
 		return err;
 
 	ablkcipher_request_set_tfm(abreq, ctx->enc);
 	ablkcipher_request_set_callback(abreq, aead_request_flags(req),
-					crypto_authenc_decrypt_done, req);
-	ablkcipher_request_set_crypt(abreq, req->src, req->dst, cryptlen,
-				     req->iv);
+					req->base.complete, req->base.data);
+	ablkcipher_request_set_crypt(abreq, req->src, req->dst, cryptlen, iv);
 
 	return crypto_ablkcipher_decrypt(abreq);
 }
@@ -248,8 +338,9 @@ static int crypto_authenc_init_tfm(struct crypto_tfm *tfm)
 				      (crypto_hash_alignmask(auth) &
 				       ~(crypto_tfm_ctx_alignment() - 1)) +
 				      crypto_hash_digestsize(auth) * 2,
-				      sizeof(struct ablkcipher_request) +
-				      crypto_ablkcipher_reqsize(enc));
+				      sizeof(struct skcipher_givcrypt_request) +
+				      crypto_ablkcipher_reqsize(enc) +
+				      crypto_ablkcipher_ivsize(enc));
 
 	spin_lock_init(&ctx->auth_lock);
 
@@ -346,6 +437,7 @@ static struct crypto_instance *crypto_authenc_alloc(struct rtattr **tb)
 	inst->alg.cra_aead.setkey = crypto_authenc_setkey;
 	inst->alg.cra_aead.encrypt = crypto_authenc_encrypt;
 	inst->alg.cra_aead.decrypt = crypto_authenc_decrypt;
+	inst->alg.cra_aead.givencrypt = crypto_authenc_givencrypt;
 
 out:
 	crypto_mod_put(auth);
