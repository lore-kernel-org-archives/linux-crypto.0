From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/8] crypto: authenc - Convert to new AEAD interface
Date: Thu, 30 Jul 2015 17:53:16 +0800
Message-ID: <E1ZKkWa-0004B0-3S@gondolin.me.apana.org.au>
References: <20150730094138.GA15941@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46036 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbbG3JxT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Jul 2015 05:53:19 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1ZKkWa-0005hI-9Z
	for <linux-crypto@vger.kernel.org>; Thu, 30 Jul 2015 19:53:16 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch converts authenc to the new AEAD interface.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/authenc.c |  584 +++++++++++++++++--------------------------------------
 1 file changed, 183 insertions(+), 401 deletions(-)

diff --git a/crypto/authenc.c b/crypto/authenc.c
index 3e85229..bca3835 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -1,7 +1,7 @@
 /*
  * Authenc: Simple AEAD wrapper for IPsec
  *
- * Copyright (c) 2007 Herbert Xu <herbert@gondor.apana.org.au>
+ * Copyright (c) 2007-2015 Herbert Xu <herbert@gondor.apana.org.au>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
@@ -14,6 +14,7 @@
 #include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/authenc.h>
+#include <crypto/null.h>
 #include <crypto/scatterwalk.h>
 #include <linux/err.h>
 #include <linux/init.h>
@@ -23,26 +24,21 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 
-typedef u8 *(*authenc_ahash_t)(struct aead_request *req, unsigned int flags);
-
 struct authenc_instance_ctx {
 	struct crypto_ahash_spawn auth;
 	struct crypto_skcipher_spawn enc;
+	unsigned int reqoff;
 };
 
 struct crypto_authenc_ctx {
-	unsigned int reqoff;
 	struct crypto_ahash *auth;
 	struct crypto_ablkcipher *enc;
+	struct crypto_blkcipher *null;
 };
 
 struct authenc_request_ctx {
-	unsigned int cryptlen;
-	struct scatterlist *sg;
-	struct scatterlist asg[2];
-	struct scatterlist cipher[2];
-	crypto_completion_t complete;
-	crypto_completion_t update_complete;
+	struct scatterlist src[2];
+	struct scatterlist dst[2];
 	char tail[];
 };
 
@@ -119,189 +115,35 @@ badkey:
 	goto out;
 }
 
-static void authenc_geniv_ahash_update_done(struct crypto_async_request *areq,
-					    int err)
-{
-	struct aead_request *req = areq->data;
-	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
-	struct crypto_authenc_ctx *ctx = crypto_aead_ctx(authenc);
-	struct authenc_request_ctx *areq_ctx = aead_request_ctx(req);
-	struct ahash_request *ahreq = (void *)(areq_ctx->tail + ctx->reqoff);
-
-	if (err)
-		goto out;
-
-	ahash_request_set_crypt(ahreq, areq_ctx->sg, ahreq->result,
-				areq_ctx->cryptlen);
-	ahash_request_set_callback(ahreq, aead_request_flags(req) &
-					  CRYPTO_TFM_REQ_MAY_SLEEP,
-				   areq_ctx->complete, req);
-
-	err = crypto_ahash_finup(ahreq);
-	if (err)
-		goto out;
-
-	scatterwalk_map_and_copy(ahreq->result, areq_ctx->sg,
-				 areq_ctx->cryptlen,
-				 crypto_aead_authsize(authenc), 1);
-
-out:
-	authenc_request_complete(req, err);
-}
-
 static void authenc_geniv_ahash_done(struct crypto_async_request *areq, int err)
 {
 	struct aead_request *req = areq->data;
 	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
-	struct crypto_authenc_ctx *ctx = crypto_aead_ctx(authenc);
+	struct aead_instance *inst = aead_alg_instance(authenc);
+	struct authenc_instance_ctx *ictx = aead_instance_ctx(inst);
 	struct authenc_request_ctx *areq_ctx = aead_request_ctx(req);
-	struct ahash_request *ahreq = (void *)(areq_ctx->tail + ctx->reqoff);
+	struct ahash_request *ahreq = (void *)(areq_ctx->tail + ictx->reqoff);
 
 	if (err)
 		goto out;
 
-	scatterwalk_map_and_copy(ahreq->result, areq_ctx->sg,
-				 areq_ctx->cryptlen,
+	scatterwalk_map_and_copy(ahreq->result, req->dst,
+				 req->assoclen + req->cryptlen,
 				 crypto_aead_authsize(authenc), 1);
 
 out:
 	aead_request_complete(req, err);
 }
 
-static void authenc_verify_ahash_update_done(struct crypto_async_request *areq,
-					     int err)
-{
-	u8 *ihash;
-	unsigned int authsize;
-	struct ablkcipher_request *abreq;
-	struct aead_request *req = areq->data;
-	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
-	struct crypto_authenc_ctx *ctx = crypto_aead_ctx(authenc);
-	struct authenc_request_ctx *areq_ctx = aead_request_ctx(req);
-	struct ahash_request *ahreq = (void *)(areq_ctx->tail + ctx->reqoff);
-	unsigned int cryptlen = req->cryptlen;
-
-	if (err)
-		goto out;
-
-	ahash_request_set_crypt(ahreq, areq_ctx->sg, ahreq->result,
-				areq_ctx->cryptlen);
-	ahash_request_set_callback(ahreq, aead_request_flags(req) &
-					  CRYPTO_TFM_REQ_MAY_SLEEP,
-				   areq_ctx->complete, req);
-
-	err = crypto_ahash_finup(ahreq);
-	if (err)
-		goto out;
-
-	authsize = crypto_aead_authsize(authenc);
-	cryptlen -= authsize;
-	ihash = ahreq->result + authsize;
-	scatterwalk_map_and_copy(ihash, areq_ctx->sg, areq_ctx->cryptlen,
-				 authsize, 0);
-
-	err = crypto_memneq(ihash, ahreq->result, authsize) ? -EBADMSG : 0;
-	if (err)
-		goto out;
-
-	abreq = aead_request_ctx(req);
-	ablkcipher_request_set_tfm(abreq, ctx->enc);
-	ablkcipher_request_set_callback(abreq, aead_request_flags(req),
-					req->base.complete, req->base.data);
-	ablkcipher_request_set_crypt(abreq, req->src, req->dst,
-				     cryptlen, req->iv);
-
-	err = crypto_ablkcipher_decrypt(abreq);
-
-out:
-	authenc_request_complete(req, err);
-}
-
-static void authenc_verify_ahash_done(struct crypto_async_request *areq,
-				      int err)
-{
-	u8 *ihash;
-	unsigned int authsize;
-	struct ablkcipher_request *abreq;
-	struct aead_request *req = areq->data;
-	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
-	struct crypto_authenc_ctx *ctx = crypto_aead_ctx(authenc);
-	struct authenc_request_ctx *areq_ctx = aead_request_ctx(req);
-	struct ahash_request *ahreq = (void *)(areq_ctx->tail + ctx->reqoff);
-	unsigned int cryptlen = req->cryptlen;
-
-	if (err)
-		goto out;
-
-	authsize = crypto_aead_authsize(authenc);
-	cryptlen -= authsize;
-	ihash = ahreq->result + authsize;
-	scatterwalk_map_and_copy(ihash, areq_ctx->sg, areq_ctx->cryptlen,
-				 authsize, 0);
-
-	err = crypto_memneq(ihash, ahreq->result, authsize) ? -EBADMSG : 0;
-	if (err)
-		goto out;
-
-	abreq = aead_request_ctx(req);
-	ablkcipher_request_set_tfm(abreq, ctx->enc);
-	ablkcipher_request_set_callback(abreq, aead_request_flags(req),
-					req->base.complete, req->base.data);
-	ablkcipher_request_set_crypt(abreq, req->src, req->dst,
-				     cryptlen, req->iv);
-
-	err = crypto_ablkcipher_decrypt(abreq);
-
-out:
-	authenc_request_complete(req, err);
-}
-
-static u8 *crypto_authenc_ahash_fb(struct aead_request *req, unsigned int flags)
-{
-	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
-	struct crypto_authenc_ctx *ctx = crypto_aead_ctx(authenc);
-	struct crypto_ahash *auth = ctx->auth;
-	struct authenc_request_ctx *areq_ctx = aead_request_ctx(req);
-	struct ahash_request *ahreq = (void *)(areq_ctx->tail + ctx->reqoff);
-	u8 *hash = areq_ctx->tail;
-	int err;
-
-	hash = (u8 *)ALIGN((unsigned long)hash + crypto_ahash_alignmask(auth),
-			    crypto_ahash_alignmask(auth) + 1);
-
-	ahash_request_set_tfm(ahreq, auth);
-
-	err = crypto_ahash_init(ahreq);
-	if (err)
-		return ERR_PTR(err);
-
-	ahash_request_set_crypt(ahreq, req->assoc, hash, req->assoclen);
-	ahash_request_set_callback(ahreq, aead_request_flags(req) & flags,
-				   areq_ctx->update_complete, req);
-
-	err = crypto_ahash_update(ahreq);
-	if (err)
-		return ERR_PTR(err);
-
-	ahash_request_set_crypt(ahreq, areq_ctx->sg, hash,
-				areq_ctx->cryptlen);
-	ahash_request_set_callback(ahreq, aead_request_flags(req) & flags,
-				   areq_ctx->complete, req);
-
-	err = crypto_ahash_finup(ahreq);
-	if (err)
-		return ERR_PTR(err);
-
-	return hash;
-}
-
-static u8 *crypto_authenc_ahash(struct aead_request *req, unsigned int flags)
+static int crypto_authenc_genicv(struct aead_request *req, unsigned int flags)
 {
 	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
+	struct aead_instance *inst = aead_alg_instance(authenc);
 	struct crypto_authenc_ctx *ctx = crypto_aead_ctx(authenc);
+	struct authenc_instance_ctx *ictx = aead_instance_ctx(inst);
 	struct crypto_ahash *auth = ctx->auth;
 	struct authenc_request_ctx *areq_ctx = aead_request_ctx(req);
-	struct ahash_request *ahreq = (void *)(areq_ctx->tail + ctx->reqoff);
+	struct ahash_request *ahreq = (void *)(areq_ctx->tail + ictx->reqoff);
 	u8 *hash = areq_ctx->tail;
 	int err;
 
@@ -309,66 +151,18 @@ static u8 *crypto_authenc_ahash(struct aead_request *req, unsigned int flags)
 			   crypto_ahash_alignmask(auth) + 1);
 
 	ahash_request_set_tfm(ahreq, auth);
-	ahash_request_set_crypt(ahreq, areq_ctx->sg, hash,
-				areq_ctx->cryptlen);
-	ahash_request_set_callback(ahreq, aead_request_flags(req) & flags,
-				   areq_ctx->complete, req);
+	ahash_request_set_crypt(ahreq, req->dst, hash,
+				req->assoclen + req->cryptlen);
+	ahash_request_set_callback(ahreq, flags,
+				   authenc_geniv_ahash_done, req);
 
 	err = crypto_ahash_digest(ahreq);
 	if (err)
-		return ERR_PTR(err);
-
-	return hash;
-}
-
-static int crypto_authenc_genicv(struct aead_request *req, u8 *iv,
-				 unsigned int flags)
-{
-	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
-	struct authenc_request_ctx *areq_ctx = aead_request_ctx(req);
-	struct scatterlist *dst = req->dst;
-	struct scatterlist *assoc = req->assoc;
-	struct scatterlist *cipher = areq_ctx->cipher;
-	struct scatterlist *asg = areq_ctx->asg;
-	unsigned int ivsize = crypto_aead_ivsize(authenc);
-	unsigned int cryptlen = req->cryptlen;
-	authenc_ahash_t authenc_ahash_fn = crypto_authenc_ahash_fb;
-	struct page *dstp;
-	u8 *vdst;
-	u8 *hash;
-
-	dstp = sg_page(dst);
-	vdst = PageHighMem(dstp) ? NULL : page_address(dstp) + dst->offset;
-
-	if (ivsize) {
-		sg_init_table(cipher, 2);
-		sg_set_buf(cipher, iv, ivsize);
-		scatterwalk_crypto_chain(cipher, dst, vdst == iv + ivsize, 2);
-		dst = cipher;
-		cryptlen += ivsize;
-	}
-
-	if (req->assoclen && sg_is_last(assoc)) {
-		authenc_ahash_fn = crypto_authenc_ahash;
-		sg_init_table(asg, 2);
-		sg_set_page(asg, sg_page(assoc), assoc->length, assoc->offset);
-		scatterwalk_crypto_chain(asg, dst, 0, 2);
-		dst = asg;
-		cryptlen += req->assoclen;
-	}
-
-	areq_ctx->cryptlen = cryptlen;
-	areq_ctx->sg = dst;
-
-	areq_ctx->complete = authenc_geniv_ahash_done;
-	areq_ctx->update_complete = authenc_geniv_ahash_update_done;
-
-	hash = authenc_ahash_fn(req, flags);
-	if (IS_ERR(hash))
-		return PTR_ERR(hash);
+		return err;
 
-	scatterwalk_map_and_copy(hash, dst, cryptlen,
+	scatterwalk_map_and_copy(hash, req->dst, req->assoclen + req->cryptlen,
 				 crypto_aead_authsize(authenc), 1);
+
 	return 0;
 }
 
@@ -377,180 +171,155 @@ static void crypto_authenc_encrypt_done(struct crypto_async_request *req,
 {
 	struct aead_request *areq = req->data;
 
-	if (!err) {
-		struct crypto_aead *authenc = crypto_aead_reqtfm(areq);
-		struct crypto_authenc_ctx *ctx = crypto_aead_ctx(authenc);
-		struct authenc_request_ctx *areq_ctx = aead_request_ctx(areq);
-		struct ablkcipher_request *abreq = (void *)(areq_ctx->tail
-							    + ctx->reqoff);
-		u8 *iv = (u8 *)abreq - crypto_ablkcipher_ivsize(ctx->enc);
+	if (err)
+		goto out;
 
-		err = crypto_authenc_genicv(areq, iv, 0);
-	}
+	err = crypto_authenc_genicv(areq, 0);
 
+out:
 	authenc_request_complete(areq, err);
 }
 
+static int crypto_authenc_copy_assoc(struct aead_request *req)
+{
+	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
+	struct crypto_authenc_ctx *ctx = crypto_aead_ctx(authenc);
+	struct blkcipher_desc desc = {
+		.tfm = ctx->null,
+	};
+
+	return crypto_blkcipher_encrypt(&desc, req->dst, req->src,
+					req->assoclen);
+}
+
 static int crypto_authenc_encrypt(struct aead_request *req)
 {
 	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
+	struct aead_instance *inst = aead_alg_instance(authenc);
 	struct crypto_authenc_ctx *ctx = crypto_aead_ctx(authenc);
+	struct authenc_instance_ctx *ictx = aead_instance_ctx(inst);
 	struct authenc_request_ctx *areq_ctx = aead_request_ctx(req);
 	struct crypto_ablkcipher *enc = ctx->enc;
-	struct scatterlist *dst = req->dst;
 	unsigned int cryptlen = req->cryptlen;
-	struct ablkcipher_request *abreq = (void *)(areq_ctx->tail
-						    + ctx->reqoff);
-	u8 *iv = (u8 *)abreq - crypto_ablkcipher_ivsize(enc);
+	struct ablkcipher_request *abreq = (void *)(areq_ctx->tail +
+						    ictx->reqoff);
+	struct scatterlist *src, *dst;
 	int err;
 
+	sg_init_table(areq_ctx->src, 2);
+	src = scatterwalk_ffwd(areq_ctx->src, req->src, req->assoclen);
+	dst = src;
+
+	if (req->src != req->dst) {
+		err = crypto_authenc_copy_assoc(req);
+		if (err)
+			return err;
+
+		sg_init_table(areq_ctx->dst, 2);
+		dst = scatterwalk_ffwd(areq_ctx->dst, req->dst, req->assoclen);
+	}
+
 	ablkcipher_request_set_tfm(abreq, enc);
 	ablkcipher_request_set_callback(abreq, aead_request_flags(req),
 					crypto_authenc_encrypt_done, req);
-	ablkcipher_request_set_crypt(abreq, req->src, dst, cryptlen, req->iv);
-
-	memcpy(iv, req->iv, crypto_aead_ivsize(authenc));
+	ablkcipher_request_set_crypt(abreq, src, dst, cryptlen, req->iv);
 
 	err = crypto_ablkcipher_encrypt(abreq);
 	if (err)
 		return err;
 
-	return crypto_authenc_genicv(req, iv, CRYPTO_TFM_REQ_MAY_SLEEP);
+	return crypto_authenc_genicv(req, aead_request_flags(req));
 }
 
-static void crypto_authenc_givencrypt_done(struct crypto_async_request *req,
-					   int err)
+static int crypto_authenc_decrypt_tail(struct aead_request *req,
+				       unsigned int flags)
 {
-	struct aead_request *areq = req->data;
-
-	if (!err) {
-		struct skcipher_givcrypt_request *greq = aead_request_ctx(areq);
-
-		err = crypto_authenc_genicv(areq, greq->giv, 0);
-	}
+	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
+	struct aead_instance *inst = aead_alg_instance(authenc);
+	struct crypto_authenc_ctx *ctx = crypto_aead_ctx(authenc);
+	struct authenc_instance_ctx *ictx = aead_instance_ctx(inst);
+	struct authenc_request_ctx *areq_ctx = aead_request_ctx(req);
+	struct ahash_request *ahreq = (void *)(areq_ctx->tail + ictx->reqoff);
+	struct ablkcipher_request *abreq = (void *)(areq_ctx->tail +
+						    ictx->reqoff);
+	unsigned int authsize = crypto_aead_authsize(authenc);
+	u8 *ihash = ahreq->result + authsize;
+	struct scatterlist *src, *dst;
 
-	authenc_request_complete(areq, err);
-}
+	scatterwalk_map_and_copy(ihash, req->src, ahreq->nbytes, authsize, 0);
 
-static int crypto_authenc_givencrypt(struct aead_givcrypt_request *req)
-{
-	struct crypto_aead *authenc = aead_givcrypt_reqtfm(req);
-	struct crypto_authenc_ctx *ctx = crypto_aead_ctx(authenc);
-	struct aead_request *areq = &req->areq;
-	struct skcipher_givcrypt_request *greq = aead_request_ctx(areq);
-	u8 *iv = req->giv;
-	int err;
+	if (crypto_memneq(ihash, ahreq->result, authsize))
+		return -EBADMSG;
 
-	skcipher_givcrypt_set_tfm(greq, ctx->enc);
-	skcipher_givcrypt_set_callback(greq, aead_request_flags(areq),
-				       crypto_authenc_givencrypt_done, areq);
-	skcipher_givcrypt_set_crypt(greq, areq->src, areq->dst, areq->cryptlen,
-				    areq->iv);
-	skcipher_givcrypt_set_giv(greq, iv, req->seq);
+	sg_init_table(areq_ctx->src, 2);
+	src = scatterwalk_ffwd(areq_ctx->src, req->src, req->assoclen);
+	dst = src;
 
-	err = crypto_skcipher_givencrypt(greq);
-	if (err)
-		return err;
+	if (req->src != req->dst) {
+		sg_init_table(areq_ctx->dst, 2);
+		dst = scatterwalk_ffwd(areq_ctx->dst, req->dst, req->assoclen);
+	}
 
-	return crypto_authenc_genicv(areq, iv, CRYPTO_TFM_REQ_MAY_SLEEP);
-}
+	ablkcipher_request_set_tfm(abreq, ctx->enc);
+	ablkcipher_request_set_callback(abreq, aead_request_flags(req),
+					req->base.complete, req->base.data);
+	ablkcipher_request_set_crypt(abreq, src, dst,
+				     req->cryptlen - authsize, req->iv);
 
-static int crypto_authenc_verify(struct aead_request *req,
-				 authenc_ahash_t authenc_ahash_fn)
-{
-	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
-	struct authenc_request_ctx *areq_ctx = aead_request_ctx(req);
-	u8 *ohash;
-	u8 *ihash;
-	unsigned int authsize;
-
-	areq_ctx->complete = authenc_verify_ahash_done;
-	areq_ctx->update_complete = authenc_verify_ahash_update_done;
-
-	ohash = authenc_ahash_fn(req, CRYPTO_TFM_REQ_MAY_SLEEP);
-	if (IS_ERR(ohash))
-		return PTR_ERR(ohash);
-
-	authsize = crypto_aead_authsize(authenc);
-	ihash = ohash + authsize;
-	scatterwalk_map_and_copy(ihash, areq_ctx->sg, areq_ctx->cryptlen,
-				 authsize, 0);
-	return crypto_memneq(ihash, ohash, authsize) ? -EBADMSG : 0;
+	return crypto_ablkcipher_decrypt(abreq);
 }
 
-static int crypto_authenc_iverify(struct aead_request *req, u8 *iv,
-				  unsigned int cryptlen)
+static void authenc_verify_ahash_done(struct crypto_async_request *areq,
+				      int err)
 {
-	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
-	struct authenc_request_ctx *areq_ctx = aead_request_ctx(req);
-	struct scatterlist *src = req->src;
-	struct scatterlist *assoc = req->assoc;
-	struct scatterlist *cipher = areq_ctx->cipher;
-	struct scatterlist *asg = areq_ctx->asg;
-	unsigned int ivsize = crypto_aead_ivsize(authenc);
-	authenc_ahash_t authenc_ahash_fn = crypto_authenc_ahash_fb;
-	struct page *srcp;
-	u8 *vsrc;
-
-	srcp = sg_page(src);
-	vsrc = PageHighMem(srcp) ? NULL : page_address(srcp) + src->offset;
-
-	if (ivsize) {
-		sg_init_table(cipher, 2);
-		sg_set_buf(cipher, iv, ivsize);
-		scatterwalk_crypto_chain(cipher, src, vsrc == iv + ivsize, 2);
-		src = cipher;
-		cryptlen += ivsize;
-	}
+	struct aead_request *req = areq->data;
 
-	if (req->assoclen && sg_is_last(assoc)) {
-		authenc_ahash_fn = crypto_authenc_ahash;
-		sg_init_table(asg, 2);
-		sg_set_page(asg, sg_page(assoc), assoc->length, assoc->offset);
-		scatterwalk_crypto_chain(asg, src, 0, 2);
-		src = asg;
-		cryptlen += req->assoclen;
-	}
+	if (err)
+		goto out;
 
-	areq_ctx->cryptlen = cryptlen;
-	areq_ctx->sg = src;
+	err = crypto_authenc_decrypt_tail(req, 0);
 
-	return crypto_authenc_verify(req, authenc_ahash_fn);
+out:
+	authenc_request_complete(req, err);
 }
 
 static int crypto_authenc_decrypt(struct aead_request *req)
 {
 	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
-	struct crypto_authenc_ctx *ctx = crypto_aead_ctx(authenc);
-	struct ablkcipher_request *abreq = aead_request_ctx(req);
-	unsigned int cryptlen = req->cryptlen;
 	unsigned int authsize = crypto_aead_authsize(authenc);
-	u8 *iv = req->iv;
+	struct aead_instance *inst = aead_alg_instance(authenc);
+	struct crypto_authenc_ctx *ctx = crypto_aead_ctx(authenc);
+	struct authenc_instance_ctx *ictx = aead_instance_ctx(inst);
+	struct crypto_ahash *auth = ctx->auth;
+	struct authenc_request_ctx *areq_ctx = aead_request_ctx(req);
+	struct ahash_request *ahreq = (void *)(areq_ctx->tail + ictx->reqoff);
+	u8 *hash = areq_ctx->tail;
 	int err;
 
-	if (cryptlen < authsize)
-		return -EINVAL;
-	cryptlen -= authsize;
+	hash = (u8 *)ALIGN((unsigned long)hash + crypto_ahash_alignmask(auth),
+			   crypto_ahash_alignmask(auth) + 1);
 
-	err = crypto_authenc_iverify(req, iv, cryptlen);
+	ahash_request_set_tfm(ahreq, auth);
+	ahash_request_set_crypt(ahreq, req->src, hash,
+				req->assoclen + req->cryptlen - authsize);
+	ahash_request_set_callback(ahreq, aead_request_flags(req),
+				   authenc_verify_ahash_done, req);
+
+	err = crypto_ahash_digest(ahreq);
 	if (err)
 		return err;
 
-	ablkcipher_request_set_tfm(abreq, ctx->enc);
-	ablkcipher_request_set_callback(abreq, aead_request_flags(req),
-					req->base.complete, req->base.data);
-	ablkcipher_request_set_crypt(abreq, req->src, req->dst, cryptlen, iv);
-
-	return crypto_ablkcipher_decrypt(abreq);
+	return crypto_authenc_decrypt_tail(req, aead_request_flags(req));
 }
 
-static int crypto_authenc_init_tfm(struct crypto_tfm *tfm)
+static int crypto_authenc_init_tfm(struct crypto_aead *tfm)
 {
-	struct crypto_instance *inst = crypto_tfm_alg_instance(tfm);
-	struct authenc_instance_ctx *ictx = crypto_instance_ctx(inst);
-	struct crypto_authenc_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct aead_instance *inst = aead_alg_instance(tfm);
+	struct authenc_instance_ctx *ictx = aead_instance_ctx(inst);
+	struct crypto_authenc_ctx *ctx = crypto_aead_ctx(tfm);
 	struct crypto_ahash *auth;
 	struct crypto_ablkcipher *enc;
+	struct crypto_blkcipher *null;
 	int err;
 
 	auth = crypto_spawn_ahash(&ictx->auth);
@@ -562,42 +331,57 @@ static int crypto_authenc_init_tfm(struct crypto_tfm *tfm)
 	if (IS_ERR(enc))
 		goto err_free_ahash;
 
+	null = crypto_get_default_null_skcipher();
+	err = PTR_ERR(null);
+	if (IS_ERR(null))
+		goto err_free_skcipher;
+
 	ctx->auth = auth;
 	ctx->enc = enc;
+	ctx->null = null;
 
-	ctx->reqoff = ALIGN(2 * crypto_ahash_digestsize(auth) +
-			    crypto_ahash_alignmask(auth),
-			    crypto_ahash_alignmask(auth) + 1) +
-		      crypto_ablkcipher_ivsize(enc);
-
-	crypto_aead_set_reqsize(__crypto_aead_cast(tfm),
+	crypto_aead_set_reqsize(
+		tfm,
 		sizeof(struct authenc_request_ctx) +
-		ctx->reqoff +
+		ictx->reqoff +
 		max_t(unsigned int,
-			crypto_ahash_reqsize(auth) +
-			sizeof(struct ahash_request),
-			sizeof(struct skcipher_givcrypt_request) +
-			crypto_ablkcipher_reqsize(enc)));
+		      crypto_ahash_reqsize(auth) +
+		      sizeof(struct ahash_request),
+		      sizeof(struct ablkcipher_request) +
+		      crypto_ablkcipher_reqsize(enc)));
 
 	return 0;
 
+err_free_skcipher:
+	crypto_free_ablkcipher(enc);
 err_free_ahash:
 	crypto_free_ahash(auth);
 	return err;
 }
 
-static void crypto_authenc_exit_tfm(struct crypto_tfm *tfm)
+static void crypto_authenc_exit_tfm(struct crypto_aead *tfm)
 {
-	struct crypto_authenc_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct crypto_authenc_ctx *ctx = crypto_aead_ctx(tfm);
 
 	crypto_free_ahash(ctx->auth);
 	crypto_free_ablkcipher(ctx->enc);
+	crypto_put_default_null_skcipher();
 }
 
-static struct crypto_instance *crypto_authenc_alloc(struct rtattr **tb)
+static void crypto_authenc_free(struct aead_instance *inst)
+{
+	struct authenc_instance_ctx *ctx = aead_instance_ctx(inst);
+
+	crypto_drop_skcipher(&ctx->enc);
+	crypto_drop_ahash(&ctx->auth);
+	kfree(inst);
+}
+
+static int crypto_authenc_create(struct crypto_template *tmpl,
+				 struct rtattr **tb)
 {
 	struct crypto_attr_type *algt;
-	struct crypto_instance *inst;
+	struct aead_instance *inst;
 	struct hash_alg_common *auth;
 	struct crypto_alg *auth_base;
 	struct crypto_alg *enc;
@@ -607,15 +391,16 @@ static struct crypto_instance *crypto_authenc_alloc(struct rtattr **tb)
 
 	algt = crypto_get_attr_type(tb);
 	if (IS_ERR(algt))
-		return ERR_CAST(algt);
+		return PTR_ERR(algt);
 
-	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
-		return ERR_PTR(-EINVAL);
+	if ((algt->type ^ (CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_AEAD_NEW)) &
+	    algt->mask)
+		return -EINVAL;
 
 	auth = ahash_attr_alg(tb[1], CRYPTO_ALG_TYPE_HASH,
 			       CRYPTO_ALG_TYPE_AHASH_MASK);
 	if (IS_ERR(auth))
-		return ERR_CAST(auth);
+		return PTR_ERR(auth);
 
 	auth_base = &auth->base;
 
@@ -629,13 +414,14 @@ static struct crypto_instance *crypto_authenc_alloc(struct rtattr **tb)
 	if (!inst)
 		goto out_put_auth;
 
-	ctx = crypto_instance_ctx(inst);
+	ctx = aead_instance_ctx(inst);
 
-	err = crypto_init_ahash_spawn(&ctx->auth, auth, inst);
+	err = crypto_init_ahash_spawn(&ctx->auth, auth,
+				      aead_crypto_instance(inst));
 	if (err)
 		goto err_free_inst;
 
-	crypto_set_skcipher_spawn(&ctx->enc, inst);
+	crypto_set_skcipher_spawn(&ctx->enc, aead_crypto_instance(inst));
 	err = crypto_grab_skcipher(&ctx->enc, enc_name, 0,
 				   crypto_requires_sync(algt->type,
 							algt->mask));
@@ -644,41 +430,48 @@ static struct crypto_instance *crypto_authenc_alloc(struct rtattr **tb)
 
 	enc = crypto_skcipher_spawn_alg(&ctx->enc);
 
+	ctx->reqoff = ALIGN(2 * auth->digestsize + auth_base->cra_alignmask,
+			    auth_base->cra_alignmask + 1);
+
 	err = -ENAMETOOLONG;
-	if (snprintf(inst->alg.cra_name, CRYPTO_MAX_ALG_NAME,
+	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
 		     "authenc(%s,%s)", auth_base->cra_name, enc->cra_name) >=
 	    CRYPTO_MAX_ALG_NAME)
 		goto err_drop_enc;
 
-	if (snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME,
+	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
 		     "authenc(%s,%s)", auth_base->cra_driver_name,
 		     enc->cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
 		goto err_drop_enc;
 
-	inst->alg.cra_flags = CRYPTO_ALG_TYPE_AEAD;
-	inst->alg.cra_flags |= enc->cra_flags & CRYPTO_ALG_ASYNC;
-	inst->alg.cra_priority = enc->cra_priority *
-				 10 + auth_base->cra_priority;
-	inst->alg.cra_blocksize = enc->cra_blocksize;
-	inst->alg.cra_alignmask = auth_base->cra_alignmask | enc->cra_alignmask;
-	inst->alg.cra_type = &crypto_aead_type;
+	inst->alg.base.cra_flags = enc->cra_flags & CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_flags |= CRYPTO_ALG_AEAD_NEW;
+	inst->alg.base.cra_priority = enc->cra_priority * 10 +
+				      auth_base->cra_priority;
+	inst->alg.base.cra_blocksize = enc->cra_blocksize;
+	inst->alg.base.cra_alignmask = auth_base->cra_alignmask |
+				       enc->cra_alignmask;
+	inst->alg.base.cra_ctxsize = sizeof(struct crypto_authenc_ctx);
+
+	inst->alg.ivsize = enc->cra_ablkcipher.ivsize;
+	inst->alg.maxauthsize = auth->digestsize;
 
-	inst->alg.cra_aead.ivsize = enc->cra_ablkcipher.ivsize;
-	inst->alg.cra_aead.maxauthsize = auth->digestsize;
+	inst->alg.init = crypto_authenc_init_tfm;
+	inst->alg.exit = crypto_authenc_exit_tfm;
 
-	inst->alg.cra_ctxsize = sizeof(struct crypto_authenc_ctx);
+	inst->alg.setkey = crypto_authenc_setkey;
+	inst->alg.encrypt = crypto_authenc_encrypt;
+	inst->alg.decrypt = crypto_authenc_decrypt;
 
-	inst->alg.cra_init = crypto_authenc_init_tfm;
-	inst->alg.cra_exit = crypto_authenc_exit_tfm;
+	inst->free = crypto_authenc_free;
 
-	inst->alg.cra_aead.setkey = crypto_authenc_setkey;
-	inst->alg.cra_aead.encrypt = crypto_authenc_encrypt;
-	inst->alg.cra_aead.decrypt = crypto_authenc_decrypt;
-	inst->alg.cra_aead.givencrypt = crypto_authenc_givencrypt;
+	err = aead_register_instance(tmpl, inst);
+	if (err)
+		goto err_drop_enc;
 
 out:
 	crypto_mod_put(auth_base);
-	return inst;
+	return err;
 
 err_drop_enc:
 	crypto_drop_skcipher(&ctx->enc);
@@ -687,23 +480,12 @@ err_drop_auth:
 err_free_inst:
 	kfree(inst);
 out_put_auth:
-	inst = ERR_PTR(err);
 	goto out;
 }
 
-static void crypto_authenc_free(struct crypto_instance *inst)
-{
-	struct authenc_instance_ctx *ctx = crypto_instance_ctx(inst);
-
-	crypto_drop_skcipher(&ctx->enc);
-	crypto_drop_ahash(&ctx->auth);
-	kfree(inst);
-}
-
 static struct crypto_template crypto_authenc_tmpl = {
 	.name = "authenc",
-	.alloc = crypto_authenc_alloc,
-	.free = crypto_authenc_free,
+	.create = crypto_authenc_create,
 	.module = THIS_MODULE,
 };
 
