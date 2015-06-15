From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/8] crypto: gcm - Convert to new AEAD interface
Date: Mon, 15 Jun 2015 16:09:40 +0800
Message-ID: <E1Z4PSe-00083Q-Hl@gondolin.me.apana.org.au>
References: <20150615080716.GA30753@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Marcelo Henrique Cerri <mhcerri@linux.vnet.ibm.com>,
	Fionnuala Gunter <fin@linux.vnet.ibm.com>,
	horia.geanta@freescale.com, ruchika.gupta@freescale.com,
	cristian.stoica@freescale.com, NiteshNarayanLal@freescale.com,
	jinyanjiang@gmail.com, Kim Phillips <kim.phillips@freescale.com>,
	Tudor Ambarus <tudor.ambarus@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44382 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbbFOIJq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2015 04:09:46 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch converts generic gcm and its associated transforms to
the new AEAD interface.  The biggest reward is in code reduction
for rfc4543 where it used to do IV stitching which is no longer
needed as the IV is already part of the AD on input.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/gcm.c |  905 ++++++++++++++++++++++++-----------------------------------
 1 file changed, 373 insertions(+), 532 deletions(-)

diff --git a/crypto/gcm.c b/crypto/gcm.c
index fc2b55e..7d32d47 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -49,25 +49,22 @@ struct crypto_rfc4543_ctx {
 };
 
 struct crypto_rfc4543_req_ctx {
-	u8 auth_tag[16];
-	u8 assocbuf[32];
-	struct scatterlist cipher[1];
-	struct scatterlist payload[2];
-	struct scatterlist assoc[2];
 	struct aead_request subreq;
 };
 
 struct crypto_gcm_ghash_ctx {
 	unsigned int cryptlen;
 	struct scatterlist *src;
-	void (*complete)(struct aead_request *req, int err);
+	int (*complete)(struct aead_request *req, u32 flags);
 };
 
 struct crypto_gcm_req_priv_ctx {
+	u8 iv[16];
 	u8 auth_tag[16];
 	u8 iauth_tag[16];
-	struct scatterlist src[2];
-	struct scatterlist dst[2];
+	struct scatterlist src[3];
+	struct scatterlist dst[3];
+	struct scatterlist sg;
 	struct crypto_gcm_ghash_ctx ghash_ctx;
 	union {
 		struct ahash_request ahreq;
@@ -80,7 +77,12 @@ struct crypto_gcm_setkey_result {
 	struct completion completion;
 };
 
-static void *gcm_zeroes;
+static struct {
+	u8 buf[16];
+	struct scatterlist sg;
+} *gcm_zeroes;
+
+static int crypto_rfc4543_copy_src_to_dst(struct aead_request *req, bool enc);
 
 static inline struct crypto_gcm_req_priv_ctx *crypto_gcm_reqctx(
 	struct aead_request *req)
@@ -120,15 +122,13 @@ static int crypto_gcm_setkey(struct crypto_aead *aead, const u8 *key,
 
 	crypto_ablkcipher_clear_flags(ctr, CRYPTO_TFM_REQ_MASK);
 	crypto_ablkcipher_set_flags(ctr, crypto_aead_get_flags(aead) &
-				   CRYPTO_TFM_REQ_MASK);
-
+					 CRYPTO_TFM_REQ_MASK);
 	err = crypto_ablkcipher_setkey(ctr, key, keylen);
+	crypto_aead_set_flags(aead, crypto_ablkcipher_get_flags(ctr) &
+				    CRYPTO_TFM_RES_MASK);
 	if (err)
 		return err;
 
-	crypto_aead_set_flags(aead, crypto_ablkcipher_get_flags(ctr) &
-				       CRYPTO_TFM_RES_MASK);
-
 	data = kzalloc(sizeof(*data) + crypto_ablkcipher_reqsize(ctr),
 		       GFP_KERNEL);
 	if (!data)
@@ -163,7 +163,7 @@ static int crypto_gcm_setkey(struct crypto_aead *aead, const u8 *key,
 			      CRYPTO_TFM_RES_MASK);
 
 out:
-	kfree(data);
+	kzfree(data);
 	return err;
 }
 
@@ -186,35 +186,46 @@ static int crypto_gcm_setauthsize(struct crypto_aead *tfm,
 	return 0;
 }
 
-static void crypto_gcm_init_crypt(struct ablkcipher_request *ablk_req,
-				  struct aead_request *req,
-				  unsigned int cryptlen)
+static void crypto_gcm_init_common(struct aead_request *req)
 {
-	struct crypto_aead *aead = crypto_aead_reqtfm(req);
-	struct crypto_gcm_ctx *ctx = crypto_aead_ctx(aead);
 	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
-	struct scatterlist *dst;
 	__be32 counter = cpu_to_be32(1);
+	struct scatterlist *sg;
 
 	memset(pctx->auth_tag, 0, sizeof(pctx->auth_tag));
-	memcpy(req->iv + 12, &counter, 4);
+	memcpy(pctx->iv, req->iv, 12);
+	memcpy(pctx->iv + 12, &counter, 4);
 
-	sg_init_table(pctx->src, 2);
+	sg_init_table(pctx->src, 3);
 	sg_set_buf(pctx->src, pctx->auth_tag, sizeof(pctx->auth_tag));
-	scatterwalk_sg_chain(pctx->src, 2, req->src);
+	sg = scatterwalk_ffwd(pctx->src + 1, req->src, req->assoclen);
+	if (sg != pctx->src + 1)
+		scatterwalk_sg_chain(pctx->src, 2, sg);
 
-	dst = pctx->src;
 	if (req->src != req->dst) {
-		sg_init_table(pctx->dst, 2);
+		sg_init_table(pctx->dst, 3);
 		sg_set_buf(pctx->dst, pctx->auth_tag, sizeof(pctx->auth_tag));
-		scatterwalk_sg_chain(pctx->dst, 2, req->dst);
-		dst = pctx->dst;
+		sg = scatterwalk_ffwd(pctx->dst + 1, req->dst, req->assoclen);
+		if (sg != pctx->dst + 1)
+			scatterwalk_sg_chain(pctx->dst, 2, sg);
 	}
+}
+
+static void crypto_gcm_init_crypt(struct aead_request *req,
+				  unsigned int cryptlen)
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct crypto_gcm_ctx *ctx = crypto_aead_ctx(aead);
+	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
+	struct ablkcipher_request *ablk_req = &pctx->u.abreq;
+	struct scatterlist *dst;
+
+	dst = req->src == req->dst ? pctx->src : pctx->dst;
 
 	ablkcipher_request_set_tfm(ablk_req, ctx->ctr);
 	ablkcipher_request_set_crypt(ablk_req, pctx->src, dst,
 				     cryptlen + sizeof(pctx->auth_tag),
-				     req->iv);
+				     pctx->iv);
 }
 
 static inline unsigned int gcm_remain(unsigned int len)
@@ -224,41 +235,31 @@ static inline unsigned int gcm_remain(unsigned int len)
 }
 
 static void gcm_hash_len_done(struct crypto_async_request *areq, int err);
-static void gcm_hash_final_done(struct crypto_async_request *areq, int err);
 
 static int gcm_hash_update(struct aead_request *req,
-			   struct crypto_gcm_req_priv_ctx *pctx,
 			   crypto_completion_t compl,
 			   struct scatterlist *src,
-			   unsigned int len)
+			   unsigned int len, u32 flags)
 {
+	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
 	struct ahash_request *ahreq = &pctx->u.ahreq;
 
-	ahash_request_set_callback(ahreq, aead_request_flags(req),
-				   compl, req);
+	ahash_request_set_callback(ahreq, flags, compl, req);
 	ahash_request_set_crypt(ahreq, src, NULL, len);
 
 	return crypto_ahash_update(ahreq);
 }
 
 static int gcm_hash_remain(struct aead_request *req,
-			   struct crypto_gcm_req_priv_ctx *pctx,
 			   unsigned int remain,
-			   crypto_completion_t compl)
+			   crypto_completion_t compl, u32 flags)
 {
-	struct ahash_request *ahreq = &pctx->u.ahreq;
-
-	ahash_request_set_callback(ahreq, aead_request_flags(req),
-				   compl, req);
-	sg_init_one(pctx->src, gcm_zeroes, remain);
-	ahash_request_set_crypt(ahreq, pctx->src, NULL, remain);
-
-	return crypto_ahash_update(ahreq);
+	return gcm_hash_update(req, compl, &gcm_zeroes->sg, remain, flags);
 }
 
-static int gcm_hash_len(struct aead_request *req,
-			struct crypto_gcm_req_priv_ctx *pctx)
+static int gcm_hash_len(struct aead_request *req, u32 flags)
 {
+	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
 	struct ahash_request *ahreq = &pctx->u.ahreq;
 	struct crypto_gcm_ghash_ctx *gctx = &pctx->ghash_ctx;
 	u128 lengths;
@@ -266,76 +267,41 @@ static int gcm_hash_len(struct aead_request *req,
 	lengths.a = cpu_to_be64(req->assoclen * 8);
 	lengths.b = cpu_to_be64(gctx->cryptlen * 8);
 	memcpy(pctx->iauth_tag, &lengths, 16);
-	sg_init_one(pctx->src, pctx->iauth_tag, 16);
-	ahash_request_set_callback(ahreq, aead_request_flags(req),
-				   gcm_hash_len_done, req);
-	ahash_request_set_crypt(ahreq, pctx->src,
-				NULL, sizeof(lengths));
-
-	return crypto_ahash_update(ahreq);
-}
-
-static int gcm_hash_final(struct aead_request *req,
-			  struct crypto_gcm_req_priv_ctx *pctx)
-{
-	struct ahash_request *ahreq = &pctx->u.ahreq;
-
-	ahash_request_set_callback(ahreq, aead_request_flags(req),
-				   gcm_hash_final_done, req);
-	ahash_request_set_crypt(ahreq, NULL, pctx->iauth_tag, 0);
+	sg_init_one(&pctx->sg, pctx->iauth_tag, 16);
+	ahash_request_set_callback(ahreq, flags, gcm_hash_len_done, req);
+	ahash_request_set_crypt(ahreq, &pctx->sg,
+				pctx->iauth_tag, sizeof(lengths));
 
-	return crypto_ahash_final(ahreq);
+	return crypto_ahash_finup(ahreq);
 }
 
-static void __gcm_hash_final_done(struct aead_request *req, int err)
+static int gcm_hash_len_continue(struct aead_request *req, u32 flags)
 {
 	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
 	struct crypto_gcm_ghash_ctx *gctx = &pctx->ghash_ctx;
 
-	if (!err)
-		crypto_xor(pctx->auth_tag, pctx->iauth_tag, 16);
-
-	gctx->complete(req, err);
+	return gctx->complete(req, flags);
 }
 
-static void gcm_hash_final_done(struct crypto_async_request *areq, int err)
+static void gcm_hash_len_done(struct crypto_async_request *areq, int err)
 {
 	struct aead_request *req = areq->data;
 
-	__gcm_hash_final_done(req, err);
-}
-
-static void __gcm_hash_len_done(struct aead_request *req, int err)
-{
-	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
-
-	if (!err) {
-		err = gcm_hash_final(req, pctx);
-		if (err == -EINPROGRESS || err == -EBUSY)
-			return;
-	}
-
-	__gcm_hash_final_done(req, err);
-}
+	if (err)
+		goto out;
 
-static void gcm_hash_len_done(struct crypto_async_request *areq, int err)
-{
-	struct aead_request *req = areq->data;
+	err = gcm_hash_len_continue(req, 0);
+	if (err == -EINPROGRESS)
+		return;
 
-	__gcm_hash_len_done(req, err);
+out:
+	aead_request_complete(req, err);
 }
 
-static void __gcm_hash_crypt_remain_done(struct aead_request *req, int err)
+static int gcm_hash_crypt_remain_continue(struct aead_request *req, u32 flags)
 {
-	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
-
-	if (!err) {
-		err = gcm_hash_len(req, pctx);
-		if (err == -EINPROGRESS || err == -EBUSY)
-			return;
-	}
-
-	__gcm_hash_len_done(req, err);
+	return gcm_hash_len(req, flags) ?:
+	       gcm_hash_len_continue(req, flags);
 }
 
 static void gcm_hash_crypt_remain_done(struct crypto_async_request *areq,
@@ -343,55 +309,58 @@ static void gcm_hash_crypt_remain_done(struct crypto_async_request *areq,
 {
 	struct aead_request *req = areq->data;
 
-	__gcm_hash_crypt_remain_done(req, err);
+	if (err)
+		goto out;
+
+	err = gcm_hash_crypt_remain_continue(req, 0);
+	if (err == -EINPROGRESS)
+		return;
+
+out:
+	aead_request_complete(req, err);
 }
 
-static void __gcm_hash_crypt_done(struct aead_request *req, int err)
+static int gcm_hash_crypt_continue(struct aead_request *req, u32 flags)
 {
 	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
 	struct crypto_gcm_ghash_ctx *gctx = &pctx->ghash_ctx;
 	unsigned int remain;
 
-	if (!err) {
-		remain = gcm_remain(gctx->cryptlen);
-		BUG_ON(!remain);
-		err = gcm_hash_remain(req, pctx, remain,
-				      gcm_hash_crypt_remain_done);
-		if (err == -EINPROGRESS || err == -EBUSY)
-			return;
-	}
+	remain = gcm_remain(gctx->cryptlen);
+	if (remain)
+		return gcm_hash_remain(req, remain,
+				       gcm_hash_crypt_remain_done, flags) ?:
+		       gcm_hash_crypt_remain_continue(req, flags);
 
-	__gcm_hash_crypt_remain_done(req, err);
+	return gcm_hash_crypt_remain_continue(req, flags);
 }
 
 static void gcm_hash_crypt_done(struct crypto_async_request *areq, int err)
 {
 	struct aead_request *req = areq->data;
 
-	__gcm_hash_crypt_done(req, err);
+	if (err)
+		goto out;
+
+	err = gcm_hash_crypt_continue(req, 0);
+	if (err == -EINPROGRESS)
+		return;
+
+out:
+	aead_request_complete(req, err);
 }
 
-static void __gcm_hash_assoc_remain_done(struct aead_request *req, int err)
+static int gcm_hash_assoc_remain_continue(struct aead_request *req, u32 flags)
 {
 	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
 	struct crypto_gcm_ghash_ctx *gctx = &pctx->ghash_ctx;
-	crypto_completion_t compl;
-	unsigned int remain = 0;
-
-	if (!err && gctx->cryptlen) {
-		remain = gcm_remain(gctx->cryptlen);
-		compl = remain ? gcm_hash_crypt_done :
-			gcm_hash_crypt_remain_done;
-		err = gcm_hash_update(req, pctx, compl,
-				      gctx->src, gctx->cryptlen);
-		if (err == -EINPROGRESS || err == -EBUSY)
-			return;
-	}
 
-	if (remain)
-		__gcm_hash_crypt_done(req, err);
-	else
-		__gcm_hash_crypt_remain_done(req, err);
+	if (gctx->cryptlen)
+		return gcm_hash_update(req, gcm_hash_crypt_done,
+				       gctx->src, gctx->cryptlen, flags) ?:
+		       gcm_hash_crypt_continue(req, flags);
+
+	return gcm_hash_crypt_remain_continue(req, flags);
 }
 
 static void gcm_hash_assoc_remain_done(struct crypto_async_request *areq,
@@ -399,146 +368,120 @@ static void gcm_hash_assoc_remain_done(struct crypto_async_request *areq,
 {
 	struct aead_request *req = areq->data;
 
-	__gcm_hash_assoc_remain_done(req, err);
+	if (err)
+		goto out;
+
+	err = gcm_hash_assoc_remain_continue(req, 0);
+	if (err == -EINPROGRESS)
+		return;
+
+out:
+	aead_request_complete(req, err);
 }
 
-static void __gcm_hash_assoc_done(struct aead_request *req, int err)
+static int gcm_hash_assoc_continue(struct aead_request *req, u32 flags)
 {
-	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
 	unsigned int remain;
 
-	if (!err) {
-		remain = gcm_remain(req->assoclen);
-		BUG_ON(!remain);
-		err = gcm_hash_remain(req, pctx, remain,
-				      gcm_hash_assoc_remain_done);
-		if (err == -EINPROGRESS || err == -EBUSY)
-			return;
-	}
+	remain = gcm_remain(req->assoclen);
+	if (remain)
+		return gcm_hash_remain(req, remain,
+				       gcm_hash_assoc_remain_done, flags) ?:
+		       gcm_hash_assoc_remain_continue(req, flags);
 
-	__gcm_hash_assoc_remain_done(req, err);
+	return gcm_hash_assoc_remain_continue(req, flags);
 }
 
 static void gcm_hash_assoc_done(struct crypto_async_request *areq, int err)
 {
 	struct aead_request *req = areq->data;
 
-	__gcm_hash_assoc_done(req, err);
+	if (err)
+		goto out;
+
+	err = gcm_hash_assoc_continue(req, 0);
+	if (err == -EINPROGRESS)
+		return;
+
+out:
+	aead_request_complete(req, err);
 }
 
-static void __gcm_hash_init_done(struct aead_request *req, int err)
+static int gcm_hash_init_continue(struct aead_request *req, u32 flags)
 {
-	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
-	crypto_completion_t compl;
-	unsigned int remain = 0;
-
-	if (!err && req->assoclen) {
-		remain = gcm_remain(req->assoclen);
-		compl = remain ? gcm_hash_assoc_done :
-			gcm_hash_assoc_remain_done;
-		err = gcm_hash_update(req, pctx, compl,
-				      req->assoc, req->assoclen);
-		if (err == -EINPROGRESS || err == -EBUSY)
-			return;
-	}
+	if (req->assoclen)
+		return gcm_hash_update(req, gcm_hash_assoc_done,
+				       req->src, req->assoclen, flags) ?:
+		       gcm_hash_assoc_continue(req, flags);
 
-	if (remain)
-		__gcm_hash_assoc_done(req, err);
-	else
-		__gcm_hash_assoc_remain_done(req, err);
+	return gcm_hash_assoc_remain_continue(req, flags);
 }
 
 static void gcm_hash_init_done(struct crypto_async_request *areq, int err)
 {
 	struct aead_request *req = areq->data;
 
-	__gcm_hash_init_done(req, err);
+	if (err)
+		goto out;
+
+	err = gcm_hash_init_continue(req, 0);
+	if (err == -EINPROGRESS)
+		return;
+
+out:
+	aead_request_complete(req, err);
 }
 
-static int gcm_hash(struct aead_request *req,
-		    struct crypto_gcm_req_priv_ctx *pctx)
+static int gcm_hash(struct aead_request *req, u32 flags)
 {
+	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
 	struct ahash_request *ahreq = &pctx->u.ahreq;
-	struct crypto_gcm_ghash_ctx *gctx = &pctx->ghash_ctx;
-	struct crypto_gcm_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
-	unsigned int remain;
-	crypto_completion_t compl;
-	int err;
+	struct crypto_gcm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
 
 	ahash_request_set_tfm(ahreq, ctx->ghash);
 
-	ahash_request_set_callback(ahreq, aead_request_flags(req),
-				   gcm_hash_init_done, req);
-	err = crypto_ahash_init(ahreq);
-	if (err)
-		return err;
-	remain = gcm_remain(req->assoclen);
-	compl = remain ? gcm_hash_assoc_done : gcm_hash_assoc_remain_done;
-	err = gcm_hash_update(req, pctx, compl, req->assoc, req->assoclen);
-	if (err)
-		return err;
-	if (remain) {
-		err = gcm_hash_remain(req, pctx, remain,
-				      gcm_hash_assoc_remain_done);
-		if (err)
-			return err;
-	}
-	remain = gcm_remain(gctx->cryptlen);
-	compl = remain ? gcm_hash_crypt_done : gcm_hash_crypt_remain_done;
-	err = gcm_hash_update(req, pctx, compl, gctx->src, gctx->cryptlen);
-	if (err)
-		return err;
-	if (remain) {
-		err = gcm_hash_remain(req, pctx, remain,
-				      gcm_hash_crypt_remain_done);
-		if (err)
-			return err;
-	}
-	err = gcm_hash_len(req, pctx);
-	if (err)
-		return err;
-	err = gcm_hash_final(req, pctx);
-	if (err)
-		return err;
-
-	return 0;
+	ahash_request_set_callback(ahreq, flags, gcm_hash_init_done, req);
+	return crypto_ahash_init(ahreq) ?:
+	       gcm_hash_init_continue(req, flags);
 }
 
-static void gcm_enc_copy_hash(struct aead_request *req,
-			      struct crypto_gcm_req_priv_ctx *pctx)
+static int gcm_enc_copy_hash(struct aead_request *req, u32 flags)
 {
+	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	u8 *auth_tag = pctx->auth_tag;
 
-	scatterwalk_map_and_copy(auth_tag, req->dst, req->cryptlen,
+	crypto_xor(auth_tag, pctx->iauth_tag, 16);
+	scatterwalk_map_and_copy(auth_tag, req->dst,
+				 req->assoclen + req->cryptlen,
 				 crypto_aead_authsize(aead), 1);
+	return 0;
 }
 
-static void gcm_enc_hash_done(struct aead_request *req, int err)
+static int gcm_encrypt_continue(struct aead_request *req, u32 flags)
 {
 	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
+	struct crypto_gcm_ghash_ctx *gctx = &pctx->ghash_ctx;
 
-	if (!err)
-		gcm_enc_copy_hash(req, pctx);
+	gctx->src = sg_next(req->src == req->dst ? pctx->src : pctx->dst);
+	gctx->cryptlen = req->cryptlen;
+	gctx->complete = gcm_enc_copy_hash;
 
-	aead_request_complete(req, err);
+	return gcm_hash(req, flags);
 }
 
 static void gcm_encrypt_done(struct crypto_async_request *areq, int err)
 {
 	struct aead_request *req = areq->data;
-	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
 
-	if (!err) {
-		err = gcm_hash(req, pctx);
-		if (err == -EINPROGRESS || err == -EBUSY)
-			return;
-		else if (!err) {
-			crypto_xor(pctx->auth_tag, pctx->iauth_tag, 16);
-			gcm_enc_copy_hash(req, pctx);
-		}
-	}
+	if (err)
+		goto out;
+
+	err = gcm_encrypt_continue(req, 0);
+	if (err == -EINPROGRESS)
+		return;
 
+out:
 	aead_request_complete(req, err);
 }
 
@@ -546,34 +489,19 @@ static int crypto_gcm_encrypt(struct aead_request *req)
 {
 	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
 	struct ablkcipher_request *abreq = &pctx->u.abreq;
-	struct crypto_gcm_ghash_ctx *gctx = &pctx->ghash_ctx;
-	int err;
-
-	crypto_gcm_init_crypt(abreq, req, req->cryptlen);
-	ablkcipher_request_set_callback(abreq, aead_request_flags(req),
-					gcm_encrypt_done, req);
-
-	gctx->src = req->dst;
-	gctx->cryptlen = req->cryptlen;
-	gctx->complete = gcm_enc_hash_done;
-
-	err = crypto_ablkcipher_encrypt(abreq);
-	if (err)
-		return err;
-
-	err = gcm_hash(req, pctx);
-	if (err)
-		return err;
+	u32 flags = aead_request_flags(req);
 
-	crypto_xor(pctx->auth_tag, pctx->iauth_tag, 16);
-	gcm_enc_copy_hash(req, pctx);
+	crypto_gcm_init_common(req);
+	crypto_gcm_init_crypt(req, req->cryptlen);
+	ablkcipher_request_set_callback(abreq, flags, gcm_encrypt_done, req);
 
-	return 0;
+	return crypto_ablkcipher_encrypt(abreq) ?:
+	       gcm_encrypt_continue(req, flags);
 }
 
-static int crypto_gcm_verify(struct aead_request *req,
-			     struct crypto_gcm_req_priv_ctx *pctx)
+static int crypto_gcm_verify(struct aead_request *req)
 {
+	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	u8 *auth_tag = pctx->auth_tag;
 	u8 *iauth_tag = pctx->iauth_tag;
@@ -581,78 +509,57 @@ static int crypto_gcm_verify(struct aead_request *req,
 	unsigned int cryptlen = req->cryptlen - authsize;
 
 	crypto_xor(auth_tag, iauth_tag, 16);
-	scatterwalk_map_and_copy(iauth_tag, req->src, cryptlen, authsize, 0);
+	scatterwalk_map_and_copy(iauth_tag, req->src,
+				 req->assoclen + cryptlen, authsize, 0);
 	return crypto_memneq(iauth_tag, auth_tag, authsize) ? -EBADMSG : 0;
 }
 
 static void gcm_decrypt_done(struct crypto_async_request *areq, int err)
 {
 	struct aead_request *req = areq->data;
-	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
 
 	if (!err)
-		err = crypto_gcm_verify(req, pctx);
+		err = crypto_gcm_verify(req);
 
 	aead_request_complete(req, err);
 }
 
-static void gcm_dec_hash_done(struct aead_request *req, int err)
+static int gcm_dec_hash_continue(struct aead_request *req, u32 flags)
 {
 	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
 	struct ablkcipher_request *abreq = &pctx->u.abreq;
 	struct crypto_gcm_ghash_ctx *gctx = &pctx->ghash_ctx;
 
-	if (!err) {
-		ablkcipher_request_set_callback(abreq, aead_request_flags(req),
-						gcm_decrypt_done, req);
-		crypto_gcm_init_crypt(abreq, req, gctx->cryptlen);
-		err = crypto_ablkcipher_decrypt(abreq);
-		if (err == -EINPROGRESS || err == -EBUSY)
-			return;
-		else if (!err)
-			err = crypto_gcm_verify(req, pctx);
-	}
-
-	aead_request_complete(req, err);
+	crypto_gcm_init_crypt(req, gctx->cryptlen);
+	ablkcipher_request_set_callback(abreq, flags, gcm_decrypt_done, req);
+	return crypto_ablkcipher_decrypt(abreq) ?: crypto_gcm_verify(req);
 }
 
 static int crypto_gcm_decrypt(struct aead_request *req)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
-	struct ablkcipher_request *abreq = &pctx->u.abreq;
 	struct crypto_gcm_ghash_ctx *gctx = &pctx->ghash_ctx;
 	unsigned int authsize = crypto_aead_authsize(aead);
 	unsigned int cryptlen = req->cryptlen;
-	int err;
+	u32 flags = aead_request_flags(req);
 
-	if (cryptlen < authsize)
-		return -EINVAL;
 	cryptlen -= authsize;
 
-	gctx->src = req->src;
-	gctx->cryptlen = cryptlen;
-	gctx->complete = gcm_dec_hash_done;
-
-	err = gcm_hash(req, pctx);
-	if (err)
-		return err;
+	crypto_gcm_init_common(req);
 
-	ablkcipher_request_set_callback(abreq, aead_request_flags(req),
-					gcm_decrypt_done, req);
-	crypto_gcm_init_crypt(abreq, req, cryptlen);
-	err = crypto_ablkcipher_decrypt(abreq);
-	if (err)
-		return err;
+	gctx->src = sg_next(pctx->src);
+	gctx->cryptlen = cryptlen;
+	gctx->complete = gcm_dec_hash_continue;
 
-	return crypto_gcm_verify(req, pctx);
+	return gcm_hash(req, flags);
 }
 
-static int crypto_gcm_init_tfm(struct crypto_tfm *tfm)
+static int crypto_gcm_init_tfm(struct crypto_aead *tfm)
 {
-	struct crypto_instance *inst = (void *)tfm->__crt_alg;
-	struct gcm_instance_ctx *ictx = crypto_instance_ctx(inst);
-	struct crypto_gcm_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct aead_instance *inst = aead_alg_instance(tfm);
+	struct gcm_instance_ctx *ictx = aead_instance_ctx(inst);
+	struct crypto_gcm_ctx *ctx = crypto_aead_ctx(tfm);
 	struct crypto_ablkcipher *ctr;
 	struct crypto_ahash *ghash;
 	unsigned long align;
@@ -670,9 +577,9 @@ static int crypto_gcm_init_tfm(struct crypto_tfm *tfm)
 	ctx->ctr = ctr;
 	ctx->ghash = ghash;
 
-	align = crypto_tfm_alg_alignmask(tfm);
+	align = crypto_aead_alignmask(tfm);
 	align &= ~(crypto_tfm_ctx_alignment() - 1);
-	crypto_aead_set_reqsize(__crypto_aead_cast(tfm),
+	crypto_aead_set_reqsize(tfm,
 		align + offsetof(struct crypto_gcm_req_priv_ctx, u) +
 		max(sizeof(struct ablkcipher_request) +
 		    crypto_ablkcipher_reqsize(ctr),
@@ -686,53 +593,59 @@ err_free_hash:
 	return err;
 }
 
-static void crypto_gcm_exit_tfm(struct crypto_tfm *tfm)
+static void crypto_gcm_exit_tfm(struct crypto_aead *tfm)
 {
-	struct crypto_gcm_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct crypto_gcm_ctx *ctx = crypto_aead_ctx(tfm);
 
 	crypto_free_ahash(ctx->ghash);
 	crypto_free_ablkcipher(ctx->ctr);
 }
 
-static struct crypto_instance *crypto_gcm_alloc_common(struct rtattr **tb,
-						       const char *full_name,
-						       const char *ctr_name,
-						       const char *ghash_name)
+static int crypto_gcm_create_common(struct crypto_template *tmpl,
+				    struct rtattr **tb,
+				    const char *full_name,
+				    const char *ctr_name,
+				    const char *ghash_name)
 {
 	struct crypto_attr_type *algt;
-	struct crypto_instance *inst;
+	struct aead_instance *inst;
 	struct crypto_alg *ctr;
 	struct crypto_alg *ghash_alg;
-	struct ahash_alg *ghash_ahash_alg;
+	struct hash_alg_common *ghash;
 	struct gcm_instance_ctx *ctx;
 	int err;
 
 	algt = crypto_get_attr_type(tb);
 	if (IS_ERR(algt))
-		return ERR_CAST(algt);
+		return PTR_ERR(algt);
 
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
-		return ERR_PTR(-EINVAL);
+		return -EINVAL;
 
 	ghash_alg = crypto_find_alg(ghash_name, &crypto_ahash_type,
 				    CRYPTO_ALG_TYPE_HASH,
 				    CRYPTO_ALG_TYPE_AHASH_MASK);
 	if (IS_ERR(ghash_alg))
-		return ERR_CAST(ghash_alg);
+		return PTR_ERR(ghash_alg);
+
+	ghash = __crypto_hash_alg_common(ghash_alg);
 
 	err = -ENOMEM;
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	if (!inst)
 		goto out_put_ghash;
 
-	ctx = crypto_instance_ctx(inst);
-	ghash_ahash_alg = container_of(ghash_alg, struct ahash_alg, halg.base);
-	err = crypto_init_ahash_spawn(&ctx->ghash, &ghash_ahash_alg->halg,
-				      inst);
+	ctx = aead_instance_ctx(inst);
+	err = crypto_init_ahash_spawn(&ctx->ghash, ghash,
+				      aead_crypto_instance(inst));
 	if (err)
 		goto err_free_inst;
 
-	crypto_set_skcipher_spawn(&ctx->ctr, inst);
+	err = -EINVAL;
+	if (ghash->digestsize != 16)
+		goto err_drop_ghash;
+
+	crypto_set_skcipher_spawn(&ctx->ctr, aead_crypto_instance(inst));
 	err = crypto_grab_skcipher(&ctx->ctr, ctr_name, 0,
 				   crypto_requires_sync(algt->type,
 							algt->mask));
@@ -751,33 +664,38 @@ static struct crypto_instance *crypto_gcm_alloc_common(struct rtattr **tb,
 		goto out_put_ctr;
 
 	err = -ENAMETOOLONG;
-	if (snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME,
+	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
 		     "gcm_base(%s,%s)", ctr->cra_driver_name,
 		     ghash_alg->cra_driver_name) >=
 	    CRYPTO_MAX_ALG_NAME)
 		goto out_put_ctr;
 
-	memcpy(inst->alg.cra_name, full_name, CRYPTO_MAX_ALG_NAME);
-
-	inst->alg.cra_flags = CRYPTO_ALG_TYPE_AEAD;
-	inst->alg.cra_flags |= ctr->cra_flags & CRYPTO_ALG_ASYNC;
-	inst->alg.cra_priority = ctr->cra_priority;
-	inst->alg.cra_blocksize = 1;
-	inst->alg.cra_alignmask = ctr->cra_alignmask | (__alignof__(u64) - 1);
-	inst->alg.cra_type = &crypto_aead_type;
-	inst->alg.cra_aead.ivsize = 16;
-	inst->alg.cra_aead.maxauthsize = 16;
-	inst->alg.cra_ctxsize = sizeof(struct crypto_gcm_ctx);
-	inst->alg.cra_init = crypto_gcm_init_tfm;
-	inst->alg.cra_exit = crypto_gcm_exit_tfm;
-	inst->alg.cra_aead.setkey = crypto_gcm_setkey;
-	inst->alg.cra_aead.setauthsize = crypto_gcm_setauthsize;
-	inst->alg.cra_aead.encrypt = crypto_gcm_encrypt;
-	inst->alg.cra_aead.decrypt = crypto_gcm_decrypt;
+	memcpy(inst->alg.base.cra_name, full_name, CRYPTO_MAX_ALG_NAME);
+
+	inst->alg.base.cra_flags = (ghash->base.cra_flags | ctr->cra_flags) &
+				   CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_priority = (ghash->base.cra_priority +
+				       ctr->cra_priority) / 2;
+	inst->alg.base.cra_blocksize = 1;
+	inst->alg.base.cra_alignmask = ghash->base.cra_alignmask |
+				       ctr->cra_alignmask;
+	inst->alg.base.cra_ctxsize = sizeof(struct crypto_gcm_ctx);
+	inst->alg.ivsize = 12;
+	inst->alg.maxauthsize = 16;
+	inst->alg.init = crypto_gcm_init_tfm;
+	inst->alg.exit = crypto_gcm_exit_tfm;
+	inst->alg.setkey = crypto_gcm_setkey;
+	inst->alg.setauthsize = crypto_gcm_setauthsize;
+	inst->alg.encrypt = crypto_gcm_encrypt;
+	inst->alg.decrypt = crypto_gcm_decrypt;
+
+	err = aead_register_instance(tmpl, inst);
+	if (err)
+		goto out_put_ctr;
 
-out:
+out_put_ghash:
 	crypto_mod_put(ghash_alg);
-	return inst;
+	return err;
 
 out_put_ctr:
 	crypto_drop_skcipher(&ctx->ctr);
@@ -785,12 +703,10 @@ err_drop_ghash:
 	crypto_drop_ahash(&ctx->ghash);
 err_free_inst:
 	kfree(inst);
-out_put_ghash:
-	inst = ERR_PTR(err);
-	goto out;
+	goto out_put_ghash;
 }
 
-static struct crypto_instance *crypto_gcm_alloc(struct rtattr **tb)
+static int crypto_gcm_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
 	const char *cipher_name;
 	char ctr_name[CRYPTO_MAX_ALG_NAME];
@@ -798,17 +714,18 @@ static struct crypto_instance *crypto_gcm_alloc(struct rtattr **tb)
 
 	cipher_name = crypto_attr_alg_name(tb[1]);
 	if (IS_ERR(cipher_name))
-		return ERR_CAST(cipher_name);
+		return PTR_ERR(cipher_name);
 
 	if (snprintf(ctr_name, CRYPTO_MAX_ALG_NAME, "ctr(%s)", cipher_name) >=
 	    CRYPTO_MAX_ALG_NAME)
-		return ERR_PTR(-ENAMETOOLONG);
+		return -ENAMETOOLONG;
 
 	if (snprintf(full_name, CRYPTO_MAX_ALG_NAME, "gcm(%s)", cipher_name) >=
 	    CRYPTO_MAX_ALG_NAME)
-		return ERR_PTR(-ENAMETOOLONG);
+		return -ENAMETOOLONG;
 
-	return crypto_gcm_alloc_common(tb, full_name, ctr_name, "ghash");
+	return crypto_gcm_create_common(tmpl, tb, full_name,
+					ctr_name, "ghash");
 }
 
 static void crypto_gcm_free(struct crypto_instance *inst)
@@ -817,17 +734,18 @@ static void crypto_gcm_free(struct crypto_instance *inst)
 
 	crypto_drop_skcipher(&ctx->ctr);
 	crypto_drop_ahash(&ctx->ghash);
-	kfree(inst);
+	kfree(aead_instance(inst));
 }
 
 static struct crypto_template crypto_gcm_tmpl = {
 	.name = "gcm",
-	.alloc = crypto_gcm_alloc,
+	.create = crypto_gcm_create,
 	.free = crypto_gcm_free,
 	.module = THIS_MODULE,
 };
 
-static struct crypto_instance *crypto_gcm_base_alloc(struct rtattr **tb)
+static int crypto_gcm_base_create(struct crypto_template *tmpl,
+				  struct rtattr **tb)
 {
 	const char *ctr_name;
 	const char *ghash_name;
@@ -835,22 +753,23 @@ static struct crypto_instance *crypto_gcm_base_alloc(struct rtattr **tb)
 
 	ctr_name = crypto_attr_alg_name(tb[1]);
 	if (IS_ERR(ctr_name))
-		return ERR_CAST(ctr_name);
+		return PTR_ERR(ctr_name);
 
 	ghash_name = crypto_attr_alg_name(tb[2]);
 	if (IS_ERR(ghash_name))
-		return ERR_CAST(ghash_name);
+		return PTR_ERR(ghash_name);
 
 	if (snprintf(full_name, CRYPTO_MAX_ALG_NAME, "gcm_base(%s,%s)",
 		     ctr_name, ghash_name) >= CRYPTO_MAX_ALG_NAME)
-		return ERR_PTR(-ENAMETOOLONG);
+		return -ENAMETOOLONG;
 
-	return crypto_gcm_alloc_common(tb, full_name, ctr_name, ghash_name);
+	return crypto_gcm_create_common(tmpl, tb, full_name,
+					ctr_name, ghash_name);
 }
 
 static struct crypto_template crypto_gcm_base_tmpl = {
 	.name = "gcm_base",
-	.alloc = crypto_gcm_base_alloc,
+	.create = crypto_gcm_base_create,
 	.free = crypto_gcm_free,
 	.module = THIS_MODULE,
 };
@@ -911,7 +830,7 @@ static struct aead_request *crypto_rfc4106_crypt(struct aead_request *req)
 	aead_request_set_callback(subreq, req->base.flags, req->base.complete,
 				  req->base.data);
 	aead_request_set_crypt(subreq, req->src, req->dst, req->cryptlen, iv);
-	aead_request_set_assoc(subreq, req->assoc, req->assoclen);
+	aead_request_set_ad(subreq, req->assoclen);
 
 	return subreq;
 }
@@ -930,11 +849,11 @@ static int crypto_rfc4106_decrypt(struct aead_request *req)
 	return crypto_aead_decrypt(req);
 }
 
-static int crypto_rfc4106_init_tfm(struct crypto_tfm *tfm)
+static int crypto_rfc4106_init_tfm(struct crypto_aead *tfm)
 {
-	struct crypto_instance *inst = (void *)tfm->__crt_alg;
-	struct crypto_aead_spawn *spawn = crypto_instance_ctx(inst);
-	struct crypto_rfc4106_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct aead_instance *inst = aead_alg_instance(tfm);
+	struct crypto_aead_spawn *spawn = aead_instance_ctx(inst);
+	struct crypto_rfc4106_ctx *ctx = crypto_aead_ctx(tfm);
 	struct crypto_aead *aead;
 	unsigned long align;
 
@@ -946,126 +865,120 @@ static int crypto_rfc4106_init_tfm(struct crypto_tfm *tfm)
 
 	align = crypto_aead_alignmask(aead);
 	align &= ~(crypto_tfm_ctx_alignment() - 1);
-	crypto_aead_set_reqsize(__crypto_aead_cast(tfm),
+	crypto_aead_set_reqsize(
+		tfm,
 		sizeof(struct aead_request) +
 		ALIGN(crypto_aead_reqsize(aead), crypto_tfm_ctx_alignment()) +
-		align + 16);
+		align + 12);
 
 	return 0;
 }
 
-static void crypto_rfc4106_exit_tfm(struct crypto_tfm *tfm)
+static void crypto_rfc4106_exit_tfm(struct crypto_aead *tfm)
 {
-	struct crypto_rfc4106_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct crypto_rfc4106_ctx *ctx = crypto_aead_ctx(tfm);
 
 	crypto_free_aead(ctx->child);
 }
 
-static struct crypto_instance *crypto_rfc4106_alloc(struct rtattr **tb)
+static int crypto_rfc4106_create(struct crypto_template *tmpl,
+				 struct rtattr **tb)
 {
 	struct crypto_attr_type *algt;
-	struct crypto_instance *inst;
+	struct aead_instance *inst;
 	struct crypto_aead_spawn *spawn;
-	struct crypto_alg *alg;
+	struct aead_alg *alg;
 	const char *ccm_name;
 	int err;
 
 	algt = crypto_get_attr_type(tb);
 	if (IS_ERR(algt))
-		return ERR_CAST(algt);
+		return PTR_ERR(algt);
 
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
-		return ERR_PTR(-EINVAL);
+		return -EINVAL;
 
 	ccm_name = crypto_attr_alg_name(tb[1]);
 	if (IS_ERR(ccm_name))
-		return ERR_CAST(ccm_name);
+		return PTR_ERR(ccm_name);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
 	if (!inst)
-		return ERR_PTR(-ENOMEM);
+		return -ENOMEM;
 
-	spawn = crypto_instance_ctx(inst);
-	crypto_set_aead_spawn(spawn, inst);
+	spawn = aead_instance_ctx(inst);
+	crypto_set_aead_spawn(spawn, aead_crypto_instance(inst));
 	err = crypto_grab_aead(spawn, ccm_name, 0,
 			       crypto_requires_sync(algt->type, algt->mask));
 	if (err)
 		goto out_free_inst;
 
-	alg = crypto_aead_spawn_alg(spawn);
+	alg = crypto_spawn_aead_alg(spawn);
 
 	err = -EINVAL;
 
-	/* We only support 16-byte blocks. */
-	if (alg->cra_aead.ivsize != 16)
+	/* Underlying IV size must be 12. */
+	if (crypto_aead_alg_ivsize(alg) != 12)
 		goto out_drop_alg;
 
 	/* Not a stream cipher? */
-	if (alg->cra_blocksize != 1)
+	if (alg->base.cra_blocksize != 1)
 		goto out_drop_alg;
 
 	err = -ENAMETOOLONG;
-	if (snprintf(inst->alg.cra_name, CRYPTO_MAX_ALG_NAME,
-		     "rfc4106(%s)", alg->cra_name) >= CRYPTO_MAX_ALG_NAME ||
-	    snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME,
-		     "rfc4106(%s)", alg->cra_driver_name) >=
+	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
+		     "rfc4106(%s)", alg->base.cra_name) >=
+	    CRYPTO_MAX_ALG_NAME ||
+	    snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
+		     "rfc4106(%s)", alg->base.cra_driver_name) >=
 	    CRYPTO_MAX_ALG_NAME)
 		goto out_drop_alg;
 
-	inst->alg.cra_flags = CRYPTO_ALG_TYPE_AEAD;
-	inst->alg.cra_flags |= alg->cra_flags & CRYPTO_ALG_ASYNC;
-	inst->alg.cra_priority = alg->cra_priority;
-	inst->alg.cra_blocksize = 1;
-	inst->alg.cra_alignmask = alg->cra_alignmask;
-	inst->alg.cra_type = &crypto_nivaead_type;
+	inst->alg.base.cra_flags |= alg->base.cra_flags & CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_priority = alg->base.cra_priority;
+	inst->alg.base.cra_blocksize = 1;
+	inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
 
-	inst->alg.cra_aead.ivsize = 8;
-	inst->alg.cra_aead.maxauthsize = 16;
+	inst->alg.base.cra_ctxsize = sizeof(struct crypto_rfc4106_ctx);
 
-	inst->alg.cra_ctxsize = sizeof(struct crypto_rfc4106_ctx);
+	inst->alg.ivsize = 8;
+	inst->alg.maxauthsize = crypto_aead_alg_maxauthsize(alg);
 
-	inst->alg.cra_init = crypto_rfc4106_init_tfm;
-	inst->alg.cra_exit = crypto_rfc4106_exit_tfm;
+	inst->alg.init = crypto_rfc4106_init_tfm;
+	inst->alg.exit = crypto_rfc4106_exit_tfm;
 
-	inst->alg.cra_aead.setkey = crypto_rfc4106_setkey;
-	inst->alg.cra_aead.setauthsize = crypto_rfc4106_setauthsize;
-	inst->alg.cra_aead.encrypt = crypto_rfc4106_encrypt;
-	inst->alg.cra_aead.decrypt = crypto_rfc4106_decrypt;
+	inst->alg.setkey = crypto_rfc4106_setkey;
+	inst->alg.setauthsize = crypto_rfc4106_setauthsize;
+	inst->alg.encrypt = crypto_rfc4106_encrypt;
+	inst->alg.decrypt = crypto_rfc4106_decrypt;
 
-	inst->alg.cra_aead.geniv = "seqiv";
+	err = aead_register_instance(tmpl, inst);
+	if (err)
+		goto out_drop_alg;
 
 out:
-	return inst;
+	return err;
 
 out_drop_alg:
 	crypto_drop_aead(spawn);
 out_free_inst:
 	kfree(inst);
-	inst = ERR_PTR(err);
 	goto out;
 }
 
 static void crypto_rfc4106_free(struct crypto_instance *inst)
 {
-	crypto_drop_spawn(crypto_instance_ctx(inst));
-	kfree(inst);
+	crypto_drop_aead(crypto_instance_ctx(inst));
+	kfree(aead_instance(inst));
 }
 
 static struct crypto_template crypto_rfc4106_tmpl = {
 	.name = "rfc4106",
-	.alloc = crypto_rfc4106_alloc,
+	.create = crypto_rfc4106_create,
 	.free = crypto_rfc4106_free,
 	.module = THIS_MODULE,
 };
 
-static inline struct crypto_rfc4543_req_ctx *crypto_rfc4543_reqctx(
-	struct aead_request *req)
-{
-	unsigned long align = crypto_aead_alignmask(crypto_aead_reqtfm(req));
-
-	return (void *)PTR_ALIGN((u8 *)aead_request_ctx(req), align + 1);
-}
-
 static int crypto_rfc4543_setkey(struct crypto_aead *parent, const u8 *key,
 				 unsigned int keylen)
 {
@@ -1100,83 +1013,35 @@ static int crypto_rfc4543_setauthsize(struct crypto_aead *parent,
 	return crypto_aead_setauthsize(ctx->child, authsize);
 }
 
-static void crypto_rfc4543_done(struct crypto_async_request *areq, int err)
-{
-	struct aead_request *req = areq->data;
-	struct crypto_aead *aead = crypto_aead_reqtfm(req);
-	struct crypto_rfc4543_req_ctx *rctx = crypto_rfc4543_reqctx(req);
-
-	if (!err) {
-		scatterwalk_map_and_copy(rctx->auth_tag, req->dst,
-					 req->cryptlen,
-					 crypto_aead_authsize(aead), 1);
-	}
-
-	aead_request_complete(req, err);
-}
-
-static struct aead_request *crypto_rfc4543_crypt(struct aead_request *req,
-						 bool enc)
+static int crypto_rfc4543_crypt(struct aead_request *req, bool enc)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct crypto_rfc4543_ctx *ctx = crypto_aead_ctx(aead);
-	struct crypto_rfc4543_req_ctx *rctx = crypto_rfc4543_reqctx(req);
+	struct crypto_rfc4543_req_ctx *rctx = aead_request_ctx(req);
 	struct aead_request *subreq = &rctx->subreq;
-	struct scatterlist *src = req->src;
-	struct scatterlist *cipher = rctx->cipher;
-	struct scatterlist *payload = rctx->payload;
-	struct scatterlist *assoc = rctx->assoc;
 	unsigned int authsize = crypto_aead_authsize(aead);
-	unsigned int assoclen = req->assoclen;
-	struct page *srcp;
-	u8 *vsrc;
 	u8 *iv = PTR_ALIGN((u8 *)(rctx + 1) + crypto_aead_reqsize(ctx->child),
 			   crypto_aead_alignmask(ctx->child) + 1);
+	int err;
+
+	if (req->src != req->dst) {
+		err = crypto_rfc4543_copy_src_to_dst(req, enc);
+		if (err)
+			return err;
+	}
 
 	memcpy(iv, ctx->nonce, 4);
 	memcpy(iv + 4, req->iv, 8);
 
-	/* construct cipher/plaintext */
-	if (enc)
-		memset(rctx->auth_tag, 0, authsize);
-	else
-		scatterwalk_map_and_copy(rctx->auth_tag, src,
-					 req->cryptlen - authsize,
-					 authsize, 0);
-
-	sg_init_one(cipher, rctx->auth_tag, authsize);
-
-	/* construct the aad */
-	srcp = sg_page(src);
-	vsrc = PageHighMem(srcp) ? NULL : page_address(srcp) + src->offset;
-
-	sg_init_table(payload, 2);
-	sg_set_buf(payload, req->iv, 8);
-	scatterwalk_crypto_chain(payload, src, vsrc == req->iv + 8, 2);
-	assoclen += 8 + req->cryptlen - (enc ? 0 : authsize);
-
-	if (req->assoc->length == req->assoclen) {
-		sg_init_table(assoc, 2);
-		sg_set_page(assoc, sg_page(req->assoc), req->assoc->length,
-			    req->assoc->offset);
-	} else {
-		BUG_ON(req->assoclen > sizeof(rctx->assocbuf));
-
-		scatterwalk_map_and_copy(rctx->assocbuf, req->assoc, 0,
-					 req->assoclen, 0);
-
-		sg_init_table(assoc, 2);
-		sg_set_buf(assoc, rctx->assocbuf, req->assoclen);
-	}
-	scatterwalk_crypto_chain(assoc, payload, 0, 2);
-
 	aead_request_set_tfm(subreq, ctx->child);
-	aead_request_set_callback(subreq, req->base.flags, crypto_rfc4543_done,
-				  req);
-	aead_request_set_crypt(subreq, cipher, cipher, enc ? 0 : authsize, iv);
-	aead_request_set_assoc(subreq, assoc, assoclen);
-
-	return subreq;
+	aead_request_set_callback(subreq, req->base.flags,
+				  req->base.complete, req->base.data);
+	aead_request_set_crypt(subreq, req->src, req->dst,
+			       enc ? 0 : authsize, iv);
+	aead_request_set_ad(subreq, req->assoclen + req->cryptlen -
+				    subreq->cryptlen);
+
+	return enc ? crypto_aead_encrypt(subreq) : crypto_aead_decrypt(subreq);
 }
 
 static int crypto_rfc4543_copy_src_to_dst(struct aead_request *req, bool enc)
@@ -1184,7 +1049,8 @@ static int crypto_rfc4543_copy_src_to_dst(struct aead_request *req, bool enc)
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct crypto_rfc4543_ctx *ctx = crypto_aead_ctx(aead);
 	unsigned int authsize = crypto_aead_authsize(aead);
-	unsigned int nbytes = req->cryptlen - (enc ? 0 : authsize);
+	unsigned int nbytes = req->assoclen + req->cryptlen -
+			      (enc ? 0 : authsize);
 	struct blkcipher_desc desc = {
 		.tfm = ctx->null,
 	};
@@ -1194,49 +1060,20 @@ static int crypto_rfc4543_copy_src_to_dst(struct aead_request *req, bool enc)
 
 static int crypto_rfc4543_encrypt(struct aead_request *req)
 {
-	struct crypto_aead *aead = crypto_aead_reqtfm(req);
-	struct crypto_rfc4543_req_ctx *rctx = crypto_rfc4543_reqctx(req);
-	struct aead_request *subreq;
-	int err;
-
-	if (req->src != req->dst) {
-		err = crypto_rfc4543_copy_src_to_dst(req, true);
-		if (err)
-			return err;
-	}
-
-	subreq = crypto_rfc4543_crypt(req, true);
-	err = crypto_aead_encrypt(subreq);
-	if (err)
-		return err;
-
-	scatterwalk_map_and_copy(rctx->auth_tag, req->dst, req->cryptlen,
-				 crypto_aead_authsize(aead), 1);
-
-	return 0;
+	return crypto_rfc4543_crypt(req, true);
 }
 
 static int crypto_rfc4543_decrypt(struct aead_request *req)
 {
-	int err;
-
-	if (req->src != req->dst) {
-		err = crypto_rfc4543_copy_src_to_dst(req, false);
-		if (err)
-			return err;
-	}
-
-	req = crypto_rfc4543_crypt(req, false);
-
-	return crypto_aead_decrypt(req);
+	return crypto_rfc4543_crypt(req, false);
 }
 
-static int crypto_rfc4543_init_tfm(struct crypto_tfm *tfm)
+static int crypto_rfc4543_init_tfm(struct crypto_aead *tfm)
 {
-	struct crypto_instance *inst = (void *)tfm->__crt_alg;
-	struct crypto_rfc4543_instance_ctx *ictx = crypto_instance_ctx(inst);
+	struct aead_instance *inst = aead_alg_instance(tfm);
+	struct crypto_rfc4543_instance_ctx *ictx = aead_instance_ctx(inst);
 	struct crypto_aead_spawn *spawn = &ictx->aead;
-	struct crypto_rfc4543_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct crypto_rfc4543_ctx *ctx = crypto_aead_ctx(tfm);
 	struct crypto_aead *aead;
 	struct crypto_blkcipher *null;
 	unsigned long align;
@@ -1256,10 +1093,11 @@ static int crypto_rfc4543_init_tfm(struct crypto_tfm *tfm)
 
 	align = crypto_aead_alignmask(aead);
 	align &= ~(crypto_tfm_ctx_alignment() - 1);
-	crypto_aead_set_reqsize(__crypto_aead_cast(tfm),
+	crypto_aead_set_reqsize(
+		tfm,
 		sizeof(struct crypto_rfc4543_req_ctx) +
 		ALIGN(crypto_aead_reqsize(aead), crypto_tfm_ctx_alignment()) +
-		align + 16);
+		align + 12);
 
 	return 0;
 
@@ -1268,97 +1106,98 @@ err_free_aead:
 	return err;
 }
 
-static void crypto_rfc4543_exit_tfm(struct crypto_tfm *tfm)
+static void crypto_rfc4543_exit_tfm(struct crypto_aead *tfm)
 {
-	struct crypto_rfc4543_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct crypto_rfc4543_ctx *ctx = crypto_aead_ctx(tfm);
 
 	crypto_free_aead(ctx->child);
 	crypto_put_default_null_skcipher();
 }
 
-static struct crypto_instance *crypto_rfc4543_alloc(struct rtattr **tb)
+static int crypto_rfc4543_create(struct crypto_template *tmpl,
+				struct rtattr **tb)
 {
 	struct crypto_attr_type *algt;
-	struct crypto_instance *inst;
+	struct aead_instance *inst;
 	struct crypto_aead_spawn *spawn;
-	struct crypto_alg *alg;
+	struct aead_alg *alg;
 	struct crypto_rfc4543_instance_ctx *ctx;
 	const char *ccm_name;
 	int err;
 
 	algt = crypto_get_attr_type(tb);
 	if (IS_ERR(algt))
-		return ERR_CAST(algt);
+		return PTR_ERR(algt);
 
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
-		return ERR_PTR(-EINVAL);
+		return -EINVAL;
 
 	ccm_name = crypto_attr_alg_name(tb[1]);
 	if (IS_ERR(ccm_name))
-		return ERR_CAST(ccm_name);
+		return PTR_ERR(ccm_name);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	if (!inst)
-		return ERR_PTR(-ENOMEM);
+		return -ENOMEM;
 
-	ctx = crypto_instance_ctx(inst);
+	ctx = aead_instance_ctx(inst);
 	spawn = &ctx->aead;
-	crypto_set_aead_spawn(spawn, inst);
+	crypto_set_aead_spawn(spawn, aead_crypto_instance(inst));
 	err = crypto_grab_aead(spawn, ccm_name, 0,
 			       crypto_requires_sync(algt->type, algt->mask));
 	if (err)
 		goto out_free_inst;
 
-	alg = crypto_aead_spawn_alg(spawn);
+	alg = crypto_spawn_aead_alg(spawn);
 
 	err = -EINVAL;
 
-	/* We only support 16-byte blocks. */
-	if (alg->cra_aead.ivsize != 16)
+	/* Underlying IV size must be 12. */
+	if (crypto_aead_alg_ivsize(alg) != 12)
 		goto out_drop_alg;
 
 	/* Not a stream cipher? */
-	if (alg->cra_blocksize != 1)
+	if (alg->base.cra_blocksize != 1)
 		goto out_drop_alg;
 
 	err = -ENAMETOOLONG;
-	if (snprintf(inst->alg.cra_name, CRYPTO_MAX_ALG_NAME,
-		     "rfc4543(%s)", alg->cra_name) >= CRYPTO_MAX_ALG_NAME ||
-	    snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME,
-		     "rfc4543(%s)", alg->cra_driver_name) >=
+	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
+		     "rfc4543(%s)", alg->base.cra_name) >=
+	    CRYPTO_MAX_ALG_NAME ||
+	    snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
+		     "rfc4543(%s)", alg->base.cra_driver_name) >=
 	    CRYPTO_MAX_ALG_NAME)
 		goto out_drop_alg;
 
-	inst->alg.cra_flags = CRYPTO_ALG_TYPE_AEAD;
-	inst->alg.cra_flags |= alg->cra_flags & CRYPTO_ALG_ASYNC;
-	inst->alg.cra_priority = alg->cra_priority;
-	inst->alg.cra_blocksize = 1;
-	inst->alg.cra_alignmask = alg->cra_alignmask;
-	inst->alg.cra_type = &crypto_nivaead_type;
+	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_priority = alg->base.cra_priority;
+	inst->alg.base.cra_blocksize = 1;
+	inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
 
-	inst->alg.cra_aead.ivsize = 8;
-	inst->alg.cra_aead.maxauthsize = 16;
+	inst->alg.base.cra_ctxsize = sizeof(struct crypto_rfc4543_ctx);
 
-	inst->alg.cra_ctxsize = sizeof(struct crypto_rfc4543_ctx);
+	inst->alg.ivsize = 8;
+	inst->alg.maxauthsize = crypto_aead_alg_maxauthsize(alg);
 
-	inst->alg.cra_init = crypto_rfc4543_init_tfm;
-	inst->alg.cra_exit = crypto_rfc4543_exit_tfm;
+	inst->alg.init = crypto_rfc4543_init_tfm;
+	inst->alg.exit = crypto_rfc4543_exit_tfm;
 
-	inst->alg.cra_aead.setkey = crypto_rfc4543_setkey;
-	inst->alg.cra_aead.setauthsize = crypto_rfc4543_setauthsize;
-	inst->alg.cra_aead.encrypt = crypto_rfc4543_encrypt;
-	inst->alg.cra_aead.decrypt = crypto_rfc4543_decrypt;
+	inst->alg.setkey = crypto_rfc4543_setkey;
+	inst->alg.setauthsize = crypto_rfc4543_setauthsize;
+	inst->alg.encrypt = crypto_rfc4543_encrypt;
+	inst->alg.decrypt = crypto_rfc4543_decrypt;
 
-	inst->alg.cra_aead.geniv = "seqiv";
+	err = aead_register_instance(tmpl, inst);
+	if (err)
+		goto out_drop_alg;
 
 out:
-	return inst;
+	return err;
 
 out_drop_alg:
 	crypto_drop_aead(spawn);
 out_free_inst:
 	kfree(inst);
-	inst = ERR_PTR(err);
 	goto out;
 }
 
@@ -1368,12 +1207,12 @@ static void crypto_rfc4543_free(struct crypto_instance *inst)
 
 	crypto_drop_aead(&ctx->aead);
 
-	kfree(inst);
+	kfree(aead_instance(inst));
 }
 
 static struct crypto_template crypto_rfc4543_tmpl = {
 	.name = "rfc4543",
-	.alloc = crypto_rfc4543_alloc,
+	.create = crypto_rfc4543_create,
 	.free = crypto_rfc4543_free,
 	.module = THIS_MODULE,
 };
@@ -1382,10 +1221,12 @@ static int __init crypto_gcm_module_init(void)
 {
 	int err;
 
-	gcm_zeroes = kzalloc(16, GFP_KERNEL);
+	gcm_zeroes = kzalloc(sizeof(*gcm_zeroes), GFP_KERNEL);
 	if (!gcm_zeroes)
 		return -ENOMEM;
 
+	sg_init_one(&gcm_zeroes->sg, gcm_zeroes->buf, sizeof(gcm_zeroes->buf));
+
 	err = crypto_register_template(&crypto_gcm_base_tmpl);
 	if (err)
 		goto out;
