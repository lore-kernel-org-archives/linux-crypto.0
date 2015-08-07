From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: authencesn - Convert to new AEAD interface
Date: Fri, 7 Aug 2015 16:42:59 +0800
Message-ID: <20150807084259.GA26416@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:58664 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbbHGInD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Aug 2015 04:43:03 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch converts authencesn to the new AEAD interface.
    
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/authencesn.c b/crypto/authencesn.c
index a3da677..c30393e 100644
--- a/crypto/authencesn.c
+++ b/crypto/authencesn.c
@@ -4,6 +4,7 @@
  *
  * Copyright (C) 2010 secunet Security Networks AG
  * Copyright (C) 2010 Steffen Klassert <steffen.klassert@secunet.com>
+ * Copyright (c) 2015 Herbert Xu <herbert@gondor.apana.org.au>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
@@ -16,6 +17,7 @@
 #include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/authenc.h>
+#include <crypto/null.h>
 #include <crypto/scatterwalk.h>
 #include <linux/err.h>
 #include <linux/init.h>
@@ -34,19 +36,12 @@ struct crypto_authenc_esn_ctx {
 	unsigned int reqoff;
 	struct crypto_ahash *auth;
 	struct crypto_ablkcipher *enc;
+	struct crypto_blkcipher *null;
 };
 
 struct authenc_esn_request_ctx {
-	unsigned int cryptlen;
-	unsigned int headlen;
-	unsigned int trailen;
-	struct scatterlist *sg;
-	struct scatterlist hsg[2];
-	struct scatterlist tsg[1];
-	struct scatterlist cipher[2];
-	crypto_completion_t complete;
-	crypto_completion_t update_complete;
-	crypto_completion_t update_complete2;
+	struct scatterlist src[2];
+	struct scatterlist dst[2];
 	char tail[];
 };
 
@@ -56,6 +51,15 @@ static void authenc_esn_request_complete(struct aead_request *req, int err)
 		aead_request_complete(req, err);
 }
 
+static int crypto_authenc_esn_setauthsize(struct crypto_aead *authenc_esn,
+					  unsigned int authsize)
+{
+	if (authsize > 0 && authsize < 4)
+		return -EINVAL;
+
+	return 0;
+}
+
 static int crypto_authenc_esn_setkey(struct crypto_aead *authenc_esn, const u8 *key,
 				     unsigned int keylen)
 {
@@ -93,556 +97,242 @@ badkey:
 	goto out;
 }
 
-static void authenc_esn_geniv_ahash_update_done(struct crypto_async_request *areq,
-						int err)
-{
-	struct aead_request *req = areq->data;
-	struct crypto_aead *authenc_esn = crypto_aead_reqtfm(req);
-	struct crypto_authenc_esn_ctx *ctx = crypto_aead_ctx(authenc_esn);
-	struct authenc_esn_request_ctx *areq_ctx = aead_request_ctx(req);
-	struct ahash_request *ahreq = (void *)(areq_ctx->tail + ctx->reqoff);
-
-	if (err)
-		goto out;
-
-	ahash_request_set_crypt(ahreq, areq_ctx->sg, ahreq->result,
-				areq_ctx->cryptlen);
-	ahash_request_set_callback(ahreq, aead_request_flags(req) &
-					  CRYPTO_TFM_REQ_MAY_SLEEP,
-				   areq_ctx->update_complete2, req);
-
-	err = crypto_ahash_update(ahreq);
-	if (err)
-		goto out;
-
-	ahash_request_set_crypt(ahreq, areq_ctx->tsg, ahreq->result,
-				areq_ctx->trailen);
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
-				 crypto_aead_authsize(authenc_esn), 1);
-
-out:
-	authenc_esn_request_complete(req, err);
-}
-
-static void authenc_esn_geniv_ahash_update_done2(struct crypto_async_request *areq,
-						 int err)
+static int crypto_authenc_esn_genicv_tail(struct aead_request *req,
+					  unsigned int flags)
 {
-	struct aead_request *req = areq->data;
 	struct crypto_aead *authenc_esn = crypto_aead_reqtfm(req);
 	struct crypto_authenc_esn_ctx *ctx = crypto_aead_ctx(authenc_esn);
 	struct authenc_esn_request_ctx *areq_ctx = aead_request_ctx(req);
-	struct ahash_request *ahreq = (void *)(areq_ctx->tail + ctx->reqoff);
-
-	if (err)
-		goto out;
-
-	ahash_request_set_crypt(ahreq, areq_ctx->tsg, ahreq->result,
-				areq_ctx->trailen);
-	ahash_request_set_callback(ahreq, aead_request_flags(req) &
-					  CRYPTO_TFM_REQ_MAY_SLEEP,
-				   areq_ctx->complete, req);
-
-	err = crypto_ahash_finup(ahreq);
-	if (err)
-		goto out;
+	struct crypto_ahash *auth = ctx->auth;
+	u8 *hash = PTR_ALIGN((u8 *)areq_ctx->tail,
+			     crypto_ahash_alignmask(auth) + 1);
+	unsigned int authsize = crypto_aead_authsize(authenc_esn);
+	unsigned int assoclen = req->assoclen;
+	unsigned int cryptlen = req->cryptlen;
+	struct scatterlist *dst = req->dst;
+	u32 tmp[2];
 
-	scatterwalk_map_and_copy(ahreq->result, areq_ctx->sg,
-				 areq_ctx->cryptlen,
-				 crypto_aead_authsize(authenc_esn), 1);
+	/* Move high-order bits of sequence number back. */
+	scatterwalk_map_and_copy(tmp, dst, 4, 4, 0);
+	scatterwalk_map_and_copy(tmp + 1, dst, assoclen + cryptlen, 4, 0);
+	scatterwalk_map_and_copy(tmp, dst, 0, 8, 1);
 
-out:
-	authenc_esn_request_complete(req, err);
+	scatterwalk_map_and_copy(hash, dst, assoclen + cryptlen, authsize, 1);
+	return 0;
 }
 
-
 static void authenc_esn_geniv_ahash_done(struct crypto_async_request *areq,
 					 int err)
 {
 	struct aead_request *req = areq->data;
-	struct crypto_aead *authenc_esn = crypto_aead_reqtfm(req);
-	struct crypto_authenc_esn_ctx *ctx = crypto_aead_ctx(authenc_esn);
-	struct authenc_esn_request_ctx *areq_ctx = aead_request_ctx(req);
-	struct ahash_request *ahreq = (void *)(areq_ctx->tail + ctx->reqoff);
 
-	if (err)
-		goto out;
-
-	scatterwalk_map_and_copy(ahreq->result, areq_ctx->sg,
-				 areq_ctx->cryptlen,
-				 crypto_aead_authsize(authenc_esn), 1);
-
-out:
+	err = err ?: crypto_authenc_esn_genicv_tail(req, 0);
 	aead_request_complete(req, err);
 }
 
-
-static void authenc_esn_verify_ahash_update_done(struct crypto_async_request *areq,
-						 int err)
+static int crypto_authenc_esn_genicv(struct aead_request *req,
+				     unsigned int flags)
 {
-	u8 *ihash;
-	unsigned int authsize;
-	struct ablkcipher_request *abreq;
-	struct aead_request *req = areq->data;
 	struct crypto_aead *authenc_esn = crypto_aead_reqtfm(req);
-	struct crypto_authenc_esn_ctx *ctx = crypto_aead_ctx(authenc_esn);
 	struct authenc_esn_request_ctx *areq_ctx = aead_request_ctx(req);
-	struct ahash_request *ahreq = (void *)(areq_ctx->tail + ctx->reqoff);
-	unsigned int cryptlen = req->cryptlen;
-
-	if (err)
-		goto out;
-
-	ahash_request_set_crypt(ahreq, areq_ctx->sg, ahreq->result,
-				areq_ctx->cryptlen);
-
-	ahash_request_set_callback(ahreq,
-				   aead_request_flags(req) &
-				   CRYPTO_TFM_REQ_MAY_SLEEP,
-				   areq_ctx->update_complete2, req);
-
-	err = crypto_ahash_update(ahreq);
-	if (err)
-		goto out;
-
-	ahash_request_set_crypt(ahreq, areq_ctx->tsg, ahreq->result,
-				areq_ctx->trailen);
-	ahash_request_set_callback(ahreq, aead_request_flags(req) &
-					  CRYPTO_TFM_REQ_MAY_SLEEP,
-				   areq_ctx->complete, req);
-
-	err = crypto_ahash_finup(ahreq);
-	if (err)
-		goto out;
-
-	authsize = crypto_aead_authsize(authenc_esn);
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
-	authenc_esn_request_complete(req, err);
-}
-
-static void authenc_esn_verify_ahash_update_done2(struct crypto_async_request *areq,
-						  int err)
-{
-	u8 *ihash;
-	unsigned int authsize;
-	struct ablkcipher_request *abreq;
-	struct aead_request *req = areq->data;
-	struct crypto_aead *authenc_esn = crypto_aead_reqtfm(req);
 	struct crypto_authenc_esn_ctx *ctx = crypto_aead_ctx(authenc_esn);
-	struct authenc_esn_request_ctx *areq_ctx = aead_request_ctx(req);
+	struct crypto_ahash *auth = ctx->auth;
+	u8 *hash = PTR_ALIGN((u8 *)areq_ctx->tail,
+			     crypto_ahash_alignmask(auth) + 1);
 	struct ahash_request *ahreq = (void *)(areq_ctx->tail + ctx->reqoff);
+	unsigned int authsize = crypto_aead_authsize(authenc_esn);
+	unsigned int assoclen = req->assoclen;
 	unsigned int cryptlen = req->cryptlen;
+	struct scatterlist *dst = req->dst;
+	u32 tmp[2];
 
-	if (err)
-		goto out;
-
-	ahash_request_set_crypt(ahreq, areq_ctx->tsg, ahreq->result,
-				areq_ctx->trailen);
-	ahash_request_set_callback(ahreq, aead_request_flags(req) &
-					  CRYPTO_TFM_REQ_MAY_SLEEP,
-				   areq_ctx->complete, req);
-
-	err = crypto_ahash_finup(ahreq);
-	if (err)
-		goto out;
-
-	authsize = crypto_aead_authsize(authenc_esn);
-	cryptlen -= authsize;
-	ihash = ahreq->result + authsize;
-	scatterwalk_map_and_copy(ihash, areq_ctx->sg, areq_ctx->cryptlen,
-				 authsize, 0);
+	if (!authsize)
+		return 0;
 
-	err = crypto_memneq(ihash, ahreq->result, authsize) ? -EBADMSG : 0;
-	if (err)
-		goto out;
+	/* Move high-order bits of sequence number to the end. */
+	scatterwalk_map_and_copy(tmp, dst, 0, 8, 0);
+	scatterwalk_map_and_copy(tmp, dst, 4, 4, 1);
+	scatterwalk_map_and_copy(tmp + 1, dst, assoclen + cryptlen, 4, 1);
 
-	abreq = aead_request_ctx(req);
-	ablkcipher_request_set_tfm(abreq, ctx->enc);
-	ablkcipher_request_set_callback(abreq, aead_request_flags(req),
-					req->base.complete, req->base.data);
-	ablkcipher_request_set_crypt(abreq, req->src, req->dst,
-				     cryptlen, req->iv);
+	sg_init_table(areq_ctx->dst, 2);
+	dst = scatterwalk_ffwd(areq_ctx->dst, dst, 4);
 
-	err = crypto_ablkcipher_decrypt(abreq);
+	ahash_request_set_tfm(ahreq, auth);
+	ahash_request_set_crypt(ahreq, dst, hash, assoclen + cryptlen);
+	ahash_request_set_callback(ahreq, flags,
+				   authenc_esn_geniv_ahash_done, req);
 
-out:
-	authenc_esn_request_complete(req, err);
+	return crypto_ahash_digest(ahreq) ?:
+	       crypto_authenc_esn_genicv_tail(req, aead_request_flags(req));
 }
 
 
-static void authenc_esn_verify_ahash_done(struct crypto_async_request *areq,
-					  int err)
+static void crypto_authenc_esn_encrypt_done(struct crypto_async_request *req,
+					    int err)
 {
-	u8 *ihash;
-	unsigned int authsize;
-	struct ablkcipher_request *abreq;
-	struct aead_request *req = areq->data;
-	struct crypto_aead *authenc_esn = crypto_aead_reqtfm(req);
-	struct crypto_authenc_esn_ctx *ctx = crypto_aead_ctx(authenc_esn);
-	struct authenc_esn_request_ctx *areq_ctx = aead_request_ctx(req);
-	struct ahash_request *ahreq = (void *)(areq_ctx->tail + ctx->reqoff);
-	unsigned int cryptlen = req->cryptlen;
-
-	if (err)
-		goto out;
-
-	authsize = crypto_aead_authsize(authenc_esn);
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
+	struct aead_request *areq = req->data;
 
-	err = crypto_ablkcipher_decrypt(abreq);
+	if (!err)
+		err = crypto_authenc_esn_genicv(areq, 0);
 
-out:
-	authenc_esn_request_complete(req, err);
+	authenc_esn_request_complete(areq, err);
 }
 
-static u8 *crypto_authenc_esn_ahash(struct aead_request *req,
-				    unsigned int flags)
+static int crypto_authenc_esn_copy(struct aead_request *req, unsigned int len)
 {
 	struct crypto_aead *authenc_esn = crypto_aead_reqtfm(req);
 	struct crypto_authenc_esn_ctx *ctx = crypto_aead_ctx(authenc_esn);
-	struct crypto_ahash *auth = ctx->auth;
-	struct authenc_esn_request_ctx *areq_ctx = aead_request_ctx(req);
-	struct ahash_request *ahreq = (void *)(areq_ctx->tail + ctx->reqoff);
-	u8 *hash = areq_ctx->tail;
-	int err;
-
-	hash = (u8 *)ALIGN((unsigned long)hash + crypto_ahash_alignmask(auth),
-			    crypto_ahash_alignmask(auth) + 1);
-
-	ahash_request_set_tfm(ahreq, auth);
+	struct blkcipher_desc desc = {
+		.tfm = ctx->null,
+	};
 
-	err = crypto_ahash_init(ahreq);
-	if (err)
-		return ERR_PTR(err);
-
-	ahash_request_set_crypt(ahreq, areq_ctx->hsg, hash, areq_ctx->headlen);
-	ahash_request_set_callback(ahreq, aead_request_flags(req) & flags,
-				   areq_ctx->update_complete, req);
-
-	err = crypto_ahash_update(ahreq);
-	if (err)
-		return ERR_PTR(err);
-
-	ahash_request_set_crypt(ahreq, areq_ctx->sg, hash, areq_ctx->cryptlen);
-	ahash_request_set_callback(ahreq, aead_request_flags(req) & flags,
-				   areq_ctx->update_complete2, req);
-
-	err = crypto_ahash_update(ahreq);
-	if (err)
-		return ERR_PTR(err);
-
-	ahash_request_set_crypt(ahreq, areq_ctx->tsg, hash,
-				areq_ctx->trailen);
-	ahash_request_set_callback(ahreq, aead_request_flags(req) & flags,
-				   areq_ctx->complete, req);
-
-	err = crypto_ahash_finup(ahreq);
-	if (err)
-		return ERR_PTR(err);
-
-	return hash;
+	return crypto_blkcipher_encrypt(&desc, req->dst, req->src, len);
 }
 
-static int crypto_authenc_esn_genicv(struct aead_request *req, u8 *iv,
-				     unsigned int flags)
+static int crypto_authenc_esn_encrypt(struct aead_request *req)
 {
 	struct crypto_aead *authenc_esn = crypto_aead_reqtfm(req);
 	struct authenc_esn_request_ctx *areq_ctx = aead_request_ctx(req);
-	struct scatterlist *dst = req->dst;
-	struct scatterlist *assoc = req->assoc;
-	struct scatterlist *cipher = areq_ctx->cipher;
-	struct scatterlist *hsg = areq_ctx->hsg;
-	struct scatterlist *tsg = areq_ctx->tsg;
-	struct scatterlist *assoc1;
-	struct scatterlist *assoc2;
-	unsigned int ivsize = crypto_aead_ivsize(authenc_esn);
+	struct crypto_authenc_esn_ctx *ctx = crypto_aead_ctx(authenc_esn);
+	struct ablkcipher_request *abreq = (void *)(areq_ctx->tail
+						    + ctx->reqoff);
+	struct crypto_ablkcipher *enc = ctx->enc;
+	unsigned int assoclen = req->assoclen;
 	unsigned int cryptlen = req->cryptlen;
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
-	if (sg_is_last(assoc))
-		return -EINVAL;
-
-	assoc1 = assoc + 1;
-	if (sg_is_last(assoc1))
-		return -EINVAL;
-
-	assoc2 = assoc + 2;
-	if (!sg_is_last(assoc2))
-		return -EINVAL;
-
-	sg_init_table(hsg, 2);
-	sg_set_page(hsg, sg_page(assoc), assoc->length, assoc->offset);
-	sg_set_page(hsg + 1, sg_page(assoc2), assoc2->length, assoc2->offset);
-
-	sg_init_table(tsg, 1);
-	sg_set_page(tsg, sg_page(assoc1), assoc1->length, assoc1->offset);
-
-	areq_ctx->cryptlen = cryptlen;
-	areq_ctx->headlen = assoc->length + assoc2->length;
-	areq_ctx->trailen = assoc1->length;
-	areq_ctx->sg = dst;
-
-	areq_ctx->complete = authenc_esn_geniv_ahash_done;
-	areq_ctx->update_complete = authenc_esn_geniv_ahash_update_done;
-	areq_ctx->update_complete2 = authenc_esn_geniv_ahash_update_done2;
+	struct scatterlist *src, *dst;
+	int err;
 
-	hash = crypto_authenc_esn_ahash(req, flags);
-	if (IS_ERR(hash))
-		return PTR_ERR(hash);
+	sg_init_table(areq_ctx->src, 2);
+	src = scatterwalk_ffwd(areq_ctx->src, req->src, assoclen);
+	dst = src;
 
-	scatterwalk_map_and_copy(hash, dst, cryptlen,
-				 crypto_aead_authsize(authenc_esn), 1);
-	return 0;
-}
+	if (req->src != req->dst) {
+		err = crypto_authenc_esn_copy(req, assoclen);
+		if (err)
+			return err;
 
-
-static void crypto_authenc_esn_encrypt_done(struct crypto_async_request *req,
-					    int err)
-{
-	struct aead_request *areq = req->data;
-
-	if (!err) {
-		struct crypto_aead *authenc_esn = crypto_aead_reqtfm(areq);
-		struct crypto_authenc_esn_ctx *ctx = crypto_aead_ctx(authenc_esn);
-		struct ablkcipher_request *abreq = aead_request_ctx(areq);
-		u8 *iv = (u8 *)(abreq + 1) +
-			 crypto_ablkcipher_reqsize(ctx->enc);
-
-		err = crypto_authenc_esn_genicv(areq, iv, 0);
+		sg_init_table(areq_ctx->dst, 2);
+		dst = scatterwalk_ffwd(areq_ctx->dst, req->dst, assoclen);
 	}
 
-	authenc_esn_request_complete(areq, err);
-}
-
-static int crypto_authenc_esn_encrypt(struct aead_request *req)
-{
-	struct crypto_aead *authenc_esn = crypto_aead_reqtfm(req);
-	struct crypto_authenc_esn_ctx *ctx = crypto_aead_ctx(authenc_esn);
-	struct authenc_esn_request_ctx *areq_ctx = aead_request_ctx(req);
-	struct crypto_ablkcipher *enc = ctx->enc;
-	struct scatterlist *dst = req->dst;
-	unsigned int cryptlen = req->cryptlen;
-	struct ablkcipher_request *abreq = (void *)(areq_ctx->tail
-						    + ctx->reqoff);
-	u8 *iv = (u8 *)abreq - crypto_ablkcipher_ivsize(enc);
-	int err;
-
 	ablkcipher_request_set_tfm(abreq, enc);
 	ablkcipher_request_set_callback(abreq, aead_request_flags(req),
 					crypto_authenc_esn_encrypt_done, req);
-	ablkcipher_request_set_crypt(abreq, req->src, dst, cryptlen, req->iv);
-
-	memcpy(iv, req->iv, crypto_aead_ivsize(authenc_esn));
+	ablkcipher_request_set_crypt(abreq, src, dst, cryptlen, req->iv);
 
 	err = crypto_ablkcipher_encrypt(abreq);
 	if (err)
 		return err;
 
-	return crypto_authenc_esn_genicv(req, iv, CRYPTO_TFM_REQ_MAY_SLEEP);
+	return crypto_authenc_esn_genicv(req, aead_request_flags(req));
 }
 
-static void crypto_authenc_esn_givencrypt_done(struct crypto_async_request *req,
-					       int err)
+static int crypto_authenc_esn_decrypt_tail(struct aead_request *req,
+					   unsigned int flags)
 {
-	struct aead_request *areq = req->data;
-
-	if (!err) {
-		struct skcipher_givcrypt_request *greq = aead_request_ctx(areq);
-
-		err = crypto_authenc_esn_genicv(areq, greq->giv, 0);
-	}
+	struct crypto_aead *authenc_esn = crypto_aead_reqtfm(req);
+	unsigned int authsize = crypto_aead_authsize(authenc_esn);
+	struct authenc_esn_request_ctx *areq_ctx = aead_request_ctx(req);
+	struct crypto_authenc_esn_ctx *ctx = crypto_aead_ctx(authenc_esn);
+	struct ablkcipher_request *abreq = (void *)(areq_ctx->tail
+						    + ctx->reqoff);
+	struct crypto_ahash *auth = ctx->auth;
+	u8 *ohash = PTR_ALIGN((u8 *)areq_ctx->tail,
+			      crypto_ahash_alignmask(auth) + 1);
+	unsigned int cryptlen = req->cryptlen - authsize;
+	unsigned int assoclen = req->assoclen;
+	struct scatterlist *dst = req->dst;
+	u8 *ihash = ohash + crypto_ahash_digestsize(auth);
+	u32 tmp[2];
 
-	authenc_esn_request_complete(areq, err);
-}
+	/* Move high-order bits of sequence number back. */
+	scatterwalk_map_and_copy(tmp, dst, 4, 4, 0);
+	scatterwalk_map_and_copy(tmp + 1, dst, assoclen + cryptlen, 4, 0);
+	scatterwalk_map_and_copy(tmp, dst, 0, 8, 1);
 
-static int crypto_authenc_esn_givencrypt(struct aead_givcrypt_request *req)
-{
-	struct crypto_aead *authenc_esn = aead_givcrypt_reqtfm(req);
-	struct crypto_authenc_esn_ctx *ctx = crypto_aead_ctx(authenc_esn);
-	struct aead_request *areq = &req->areq;
-	struct skcipher_givcrypt_request *greq = aead_request_ctx(areq);
-	u8 *iv = req->giv;
-	int err;
+	if (crypto_memneq(ihash, ohash, authsize))
+		return -EBADMSG;
 
-	skcipher_givcrypt_set_tfm(greq, ctx->enc);
-	skcipher_givcrypt_set_callback(greq, aead_request_flags(areq),
-				       crypto_authenc_esn_givencrypt_done, areq);
-	skcipher_givcrypt_set_crypt(greq, areq->src, areq->dst, areq->cryptlen,
-				    areq->iv);
-	skcipher_givcrypt_set_giv(greq, iv, req->seq);
+	sg_init_table(areq_ctx->dst, 2);
+	dst = scatterwalk_ffwd(areq_ctx->dst, dst, assoclen);
 
-	err = crypto_skcipher_givencrypt(greq);
-	if (err)
-		return err;
+	ablkcipher_request_set_tfm(abreq, ctx->enc);
+	ablkcipher_request_set_callback(abreq, flags,
+					req->base.complete, req->base.data);
+	ablkcipher_request_set_crypt(abreq, dst, dst, cryptlen, req->iv);
 
-	return crypto_authenc_esn_genicv(areq, iv, CRYPTO_TFM_REQ_MAY_SLEEP);
+	return crypto_ablkcipher_decrypt(abreq);
 }
 
-static int crypto_authenc_esn_verify(struct aead_request *req)
+static void authenc_esn_verify_ahash_done(struct crypto_async_request *areq,
+					  int err)
 {
-	struct crypto_aead *authenc_esn = crypto_aead_reqtfm(req);
-	struct authenc_esn_request_ctx *areq_ctx = aead_request_ctx(req);
-	u8 *ohash;
-	u8 *ihash;
-	unsigned int authsize;
-
-	areq_ctx->complete = authenc_esn_verify_ahash_done;
-	areq_ctx->update_complete = authenc_esn_verify_ahash_update_done;
-
-	ohash = crypto_authenc_esn_ahash(req, CRYPTO_TFM_REQ_MAY_SLEEP);
-	if (IS_ERR(ohash))
-		return PTR_ERR(ohash);
+	struct aead_request *req = areq->data;
 
-	authsize = crypto_aead_authsize(authenc_esn);
-	ihash = ohash + authsize;
-	scatterwalk_map_and_copy(ihash, areq_ctx->sg, areq_ctx->cryptlen,
-				 authsize, 0);
-	return crypto_memneq(ihash, ohash, authsize) ? -EBADMSG : 0;
+	err = err ?: crypto_authenc_esn_decrypt_tail(req, 0);
+	aead_request_complete(req, err);
 }
 
-static int crypto_authenc_esn_iverify(struct aead_request *req, u8 *iv,
-				      unsigned int cryptlen)
+static int crypto_authenc_esn_decrypt(struct aead_request *req)
 {
 	struct crypto_aead *authenc_esn = crypto_aead_reqtfm(req);
 	struct authenc_esn_request_ctx *areq_ctx = aead_request_ctx(req);
-	struct scatterlist *src = req->src;
-	struct scatterlist *assoc = req->assoc;
-	struct scatterlist *cipher = areq_ctx->cipher;
-	struct scatterlist *hsg = areq_ctx->hsg;
-	struct scatterlist *tsg = areq_ctx->tsg;
-	struct scatterlist *assoc1;
-	struct scatterlist *assoc2;
-	unsigned int ivsize = crypto_aead_ivsize(authenc_esn);
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
-
-	if (sg_is_last(assoc))
-		return -EINVAL;
-
-	assoc1 = assoc + 1;
-	if (sg_is_last(assoc1))
-		return -EINVAL;
+	struct crypto_authenc_esn_ctx *ctx = crypto_aead_ctx(authenc_esn);
+	struct ahash_request *ahreq = (void *)(areq_ctx->tail + ctx->reqoff);
+	unsigned int authsize = crypto_aead_authsize(authenc_esn);
+	struct crypto_ahash *auth = ctx->auth;
+	u8 *ohash = PTR_ALIGN((u8 *)areq_ctx->tail,
+			      crypto_ahash_alignmask(auth) + 1);
+	unsigned int assoclen = req->assoclen;
+	unsigned int cryptlen = req->cryptlen;
+	u8 *ihash = ohash + crypto_ahash_digestsize(auth);
+	struct scatterlist *dst = req->dst;
+	u32 tmp[2];
+	int err;
 
-	assoc2 = assoc + 2;
-	if (!sg_is_last(assoc2))
-		return -EINVAL;
+	cryptlen -= authsize;
 
-	sg_init_table(hsg, 2);
-	sg_set_page(hsg, sg_page(assoc), assoc->length, assoc->offset);
-	sg_set_page(hsg + 1, sg_page(assoc2), assoc2->length, assoc2->offset);
+	if (req->src != dst) {
+		err = crypto_authenc_esn_copy(req, assoclen + cryptlen);
+		if (err)
+			return err;
+	}
 
-	sg_init_table(tsg, 1);
-	sg_set_page(tsg, sg_page(assoc1), assoc1->length, assoc1->offset);
+	scatterwalk_map_and_copy(ihash, req->src, assoclen + cryptlen,
+				 authsize, 0);
 
-	areq_ctx->cryptlen = cryptlen;
-	areq_ctx->headlen = assoc->length + assoc2->length;
-	areq_ctx->trailen = assoc1->length;
-	areq_ctx->sg = src;
+	if (!authsize)
+		goto tail;
 
-	areq_ctx->complete = authenc_esn_verify_ahash_done;
-	areq_ctx->update_complete = authenc_esn_verify_ahash_update_done;
-	areq_ctx->update_complete2 = authenc_esn_verify_ahash_update_done2;
+	/* Move high-order bits of sequence number to the end. */
+	scatterwalk_map_and_copy(tmp, dst, 0, 8, 0);
+	scatterwalk_map_and_copy(tmp, dst, 4, 4, 1);
+	scatterwalk_map_and_copy(tmp + 1, dst, assoclen + cryptlen, 4, 1);
 
-	return crypto_authenc_esn_verify(req);
-}
+	sg_init_table(areq_ctx->dst, 2);
+	dst = scatterwalk_ffwd(areq_ctx->dst, dst, 4);
 
-static int crypto_authenc_esn_decrypt(struct aead_request *req)
-{
-	struct crypto_aead *authenc_esn = crypto_aead_reqtfm(req);
-	struct crypto_authenc_esn_ctx *ctx = crypto_aead_ctx(authenc_esn);
-	struct ablkcipher_request *abreq = aead_request_ctx(req);
-	unsigned int cryptlen = req->cryptlen;
-	unsigned int authsize = crypto_aead_authsize(authenc_esn);
-	u8 *iv = req->iv;
-	int err;
-
-	if (cryptlen < authsize)
-		return -EINVAL;
-	cryptlen -= authsize;
+	ahash_request_set_tfm(ahreq, auth);
+	ahash_request_set_crypt(ahreq, dst, ohash, assoclen + cryptlen);
+	ahash_request_set_callback(ahreq, aead_request_flags(req),
+				   authenc_esn_verify_ahash_done, req);
 
-	err = crypto_authenc_esn_iverify(req, iv, cryptlen);
+	err = crypto_ahash_digest(ahreq);
 	if (err)
 		return err;
 
-	ablkcipher_request_set_tfm(abreq, ctx->enc);
-	ablkcipher_request_set_callback(abreq, aead_request_flags(req),
-					req->base.complete, req->base.data);
-	ablkcipher_request_set_crypt(abreq, req->src, req->dst, cryptlen, iv);
-
-	return crypto_ablkcipher_decrypt(abreq);
+tail:
+	return crypto_authenc_esn_decrypt_tail(req, aead_request_flags(req));
 }
 
-static int crypto_authenc_esn_init_tfm(struct crypto_tfm *tfm)
+static int crypto_authenc_esn_init_tfm(struct crypto_aead *tfm)
 {
-	struct crypto_instance *inst = crypto_tfm_alg_instance(tfm);
-	struct authenc_esn_instance_ctx *ictx = crypto_instance_ctx(inst);
-	struct crypto_authenc_esn_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct aead_instance *inst = aead_alg_instance(tfm);
+	struct authenc_esn_instance_ctx *ictx = aead_instance_ctx(inst);
+	struct crypto_authenc_esn_ctx *ctx = crypto_aead_ctx(tfm);
 	struct crypto_ahash *auth;
 	struct crypto_ablkcipher *enc;
+	struct crypto_blkcipher *null;
 	int err;
 
 	auth = crypto_spawn_ahash(&ictx->auth);
@@ -654,15 +344,20 @@ static int crypto_authenc_esn_init_tfm(struct crypto_tfm *tfm)
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
+	ctx->reqoff = ALIGN(2 * crypto_ahash_digestsize(auth),
+			    crypto_ahash_alignmask(auth) + 1);
 
-	crypto_aead_set_reqsize(__crypto_aead_cast(tfm),
+	crypto_aead_set_reqsize(
+		tfm,
 		sizeof(struct authenc_esn_request_ctx) +
 		ctx->reqoff +
 		max_t(unsigned int,
@@ -673,23 +368,36 @@ static int crypto_authenc_esn_init_tfm(struct crypto_tfm *tfm)
 
 	return 0;
 
+err_free_skcipher:
+	crypto_free_ablkcipher(enc);
 err_free_ahash:
 	crypto_free_ahash(auth);
 	return err;
 }
 
-static void crypto_authenc_esn_exit_tfm(struct crypto_tfm *tfm)
+static void crypto_authenc_esn_exit_tfm(struct crypto_aead *tfm)
 {
-	struct crypto_authenc_esn_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct crypto_authenc_esn_ctx *ctx = crypto_aead_ctx(tfm);
 
 	crypto_free_ahash(ctx->auth);
 	crypto_free_ablkcipher(ctx->enc);
+	crypto_put_default_null_skcipher();
 }
 
-static struct crypto_instance *crypto_authenc_esn_alloc(struct rtattr **tb)
+static void crypto_authenc_esn_free(struct aead_instance *inst)
+{
+	struct authenc_esn_instance_ctx *ctx = aead_instance_ctx(inst);
+
+	crypto_drop_skcipher(&ctx->enc);
+	crypto_drop_ahash(&ctx->auth);
+	kfree(inst);
+}
+
+static int crypto_authenc_esn_create(struct crypto_template *tmpl,
+				     struct rtattr **tb)
 {
 	struct crypto_attr_type *algt;
-	struct crypto_instance *inst;
+	struct aead_instance *inst;
 	struct hash_alg_common *auth;
 	struct crypto_alg *auth_base;
 	struct crypto_alg *enc;
@@ -699,15 +407,16 @@ static struct crypto_instance *crypto_authenc_esn_alloc(struct rtattr **tb)
 
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
 
@@ -721,13 +430,14 @@ static struct crypto_instance *crypto_authenc_esn_alloc(struct rtattr **tb)
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
@@ -737,40 +447,45 @@ static struct crypto_instance *crypto_authenc_esn_alloc(struct rtattr **tb)
 	enc = crypto_skcipher_spawn_alg(&ctx->enc);
 
 	err = -ENAMETOOLONG;
-	if (snprintf(inst->alg.cra_name, CRYPTO_MAX_ALG_NAME,
-		     "authencesn(%s,%s)", auth_base->cra_name, enc->cra_name) >=
-	    CRYPTO_MAX_ALG_NAME)
+	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
+		     "authencesn(%s,%s)", auth_base->cra_name,
+		     enc->cra_name) >= CRYPTO_MAX_ALG_NAME)
 		goto err_drop_enc;
 
-	if (snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME,
+	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
 		     "authencesn(%s,%s)", auth_base->cra_driver_name,
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
+	inst->alg.base.cra_ctxsize = sizeof(struct crypto_authenc_esn_ctx);
+
+	inst->alg.ivsize = enc->cra_ablkcipher.ivsize;
+	inst->alg.maxauthsize = auth->digestsize;
 
-	inst->alg.cra_aead.ivsize = enc->cra_ablkcipher.ivsize;
-	inst->alg.cra_aead.maxauthsize = auth->digestsize;
+	inst->alg.init = crypto_authenc_esn_init_tfm;
+	inst->alg.exit = crypto_authenc_esn_exit_tfm;
 
-	inst->alg.cra_ctxsize = sizeof(struct crypto_authenc_esn_ctx);
+	inst->alg.setkey = crypto_authenc_esn_setkey;
+	inst->alg.setauthsize = crypto_authenc_esn_setauthsize;
+	inst->alg.encrypt = crypto_authenc_esn_encrypt;
+	inst->alg.decrypt = crypto_authenc_esn_decrypt;
 
-	inst->alg.cra_init = crypto_authenc_esn_init_tfm;
-	inst->alg.cra_exit = crypto_authenc_esn_exit_tfm;
+	inst->free = crypto_authenc_esn_free,
 
-	inst->alg.cra_aead.setkey = crypto_authenc_esn_setkey;
-	inst->alg.cra_aead.encrypt = crypto_authenc_esn_encrypt;
-	inst->alg.cra_aead.decrypt = crypto_authenc_esn_decrypt;
-	inst->alg.cra_aead.givencrypt = crypto_authenc_esn_givencrypt;
+	err = aead_register_instance(tmpl, inst);
+	if (err)
+		goto err_drop_enc;
 
 out:
 	crypto_mod_put(auth_base);
-	return inst;
+	return err;
 
 err_drop_enc:
 	crypto_drop_skcipher(&ctx->enc);
@@ -779,23 +494,12 @@ err_drop_auth:
 err_free_inst:
 	kfree(inst);
 out_put_auth:
-	inst = ERR_PTR(err);
 	goto out;
 }
 
-static void crypto_authenc_esn_free(struct crypto_instance *inst)
-{
-	struct authenc_esn_instance_ctx *ctx = crypto_instance_ctx(inst);
-
-	crypto_drop_skcipher(&ctx->enc);
-	crypto_drop_ahash(&ctx->auth);
-	kfree(inst);
-}
-
 static struct crypto_template crypto_authenc_esn_tmpl = {
 	.name = "authencesn",
-	.alloc = crypto_authenc_esn_alloc,
-	.free = crypto_authenc_esn_free,
+	.create = crypto_authenc_esn_create,
 	.module = THIS_MODULE,
 };
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
