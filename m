From: Huang Ying <ying.huang@intel.com>
Subject: [BUGFIX for .32] crypto, gcm, fix another complete call in
 complete fuction
Date: Tue, 03 Nov 2009 10:40:17 +0800
Message-ID: <1257216017.30470.1183.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:9157 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756168AbZKCCkP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 Nov 2009 21:40:15 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The flow of the complete function (xxx_done) in gcm.c is as follow:

void complete(struct crypto_async_request *areq, int err)
{
	if (!err) {
		err = async_next_step();
		if (err == -EINPROGRESS || err == -EBUSY)
			return;
	}

	complete_for_next_step(areq, err);
}

But *areq may be destroyed in async_next_step(), this makes
complete_for_next_step() can not work properly. To fix this, one of
following methods is used for each complete function.

- Setup areq for complete_for_next_step if async_next_step() is called.

- Expand complete_for_next_step().

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 crypto/gcm.c |   43 ++++++++++++++++++++++++++++---------------
 1 file changed, 28 insertions(+), 15 deletions(-)

--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -267,8 +267,7 @@ static int gcm_hash_final(struct aead_re
 	return crypto_ahash_final(ahreq);
 }
 
-static void gcm_hash_final_done(struct crypto_async_request *areq,
-				int err)
+static void gcm_hash_final_done(struct crypto_async_request *areq, int err)
 {
 	struct aead_request *req = areq->data;
 	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
@@ -280,8 +279,7 @@ static void gcm_hash_final_done(struct c
 	gctx->complete(areq, err);
 }
 
-static void gcm_hash_len_done(struct crypto_async_request *areq,
-			      int err)
+static void gcm_hash_len_done(struct crypto_async_request *areq, int err)
 {
 	struct aead_request *req = areq->data;
 	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
@@ -290,6 +288,8 @@ static void gcm_hash_len_done(struct cry
 		err = gcm_hash_final(req, pctx);
 		if (err == -EINPROGRESS || err == -EBUSY)
 			return;
+		areq = &pctx->u.ahreq.base;
+		areq->data = req;
 	}
 
 	gcm_hash_final_done(areq, err);
@@ -305,13 +305,14 @@ static void gcm_hash_crypt_remain_done(s
 		err = gcm_hash_len(req, pctx);
 		if (err == -EINPROGRESS || err == -EBUSY)
 			return;
+		areq = &pctx->u.ahreq.base;
+		areq->data = req;
 	}
 
 	gcm_hash_len_done(areq, err);
 }
 
-static void gcm_hash_crypt_done(struct crypto_async_request *areq,
-				int err)
+static void gcm_hash_crypt_done(struct crypto_async_request *areq, int err)
 {
 	struct aead_request *req = areq->data;
 	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
@@ -325,13 +326,15 @@ static void gcm_hash_crypt_done(struct c
 				      gcm_hash_crypt_remain_done);
 		if (err == -EINPROGRESS || err == -EBUSY)
 			return;
+		areq = &pctx->u.ahreq.base;
+		areq->data = req;
 	}
 
 	gcm_hash_crypt_remain_done(areq, err);
 }
 
 static void gcm_hash_assoc_remain_done(struct crypto_async_request *areq,
-					   int err)
+				       int err)
 {
 	struct aead_request *req = areq->data;
 	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
@@ -347,6 +350,8 @@ static void gcm_hash_assoc_remain_done(s
 				      gctx->src, gctx->cryptlen);
 		if (err == -EINPROGRESS || err == -EBUSY)
 			return;
+		areq = &pctx->u.ahreq.base;
+		areq->data = req;
 	}
 
 	if (remain)
@@ -355,8 +360,7 @@ static void gcm_hash_assoc_remain_done(s
 		gcm_hash_crypt_remain_done(areq, err);
 }
 
-static void gcm_hash_assoc_done(struct crypto_async_request *areq,
-				int err)
+static void gcm_hash_assoc_done(struct crypto_async_request *areq, int err)
 {
 	struct aead_request *req = areq->data;
 	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
@@ -369,13 +373,14 @@ static void gcm_hash_assoc_done(struct c
 				      gcm_hash_assoc_remain_done);
 		if (err == -EINPROGRESS || err == -EBUSY)
 			return;
+		areq = &pctx->u.ahreq.base;
+		areq->data = req;
 	}
 
 	gcm_hash_assoc_remain_done(areq, err);
 }
 
-static void gcm_hash_init_done(struct crypto_async_request *areq,
-			       int err)
+static void gcm_hash_init_done(struct crypto_async_request *areq, int err)
 {
 	struct aead_request *req = areq->data;
 	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
@@ -390,6 +395,8 @@ static void gcm_hash_init_done(struct cr
 				      req->assoc, req->assoclen);
 		if (err == -EINPROGRESS || err == -EBUSY)
 			return;
+		areq = &pctx->u.ahreq.base;
+		areq->data = req;
 	}
 
 	if (remain)
@@ -458,7 +465,7 @@ static void gcm_enc_copy_hash(struct aea
 }
 
 static void gcm_enc_hash_done(struct crypto_async_request *areq,
-				     int err)
+			      int err)
 {
 	struct aead_request *req = areq->data;
 	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
@@ -470,7 +477,7 @@ static void gcm_enc_hash_done(struct cry
 }
 
 static void gcm_encrypt_done(struct crypto_async_request *areq,
-				     int err)
+			     int err)
 {
 	struct aead_request *req = areq->data;
 	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
@@ -479,9 +486,13 @@ static void gcm_encrypt_done(struct cryp
 		err = gcm_hash(req, pctx);
 		if (err == -EINPROGRESS || err == -EBUSY)
 			return;
+		else if (!err) {
+			crypto_xor(pctx->auth_tag, pctx->iauth_tag, 16);
+			gcm_enc_copy_hash(req, pctx);
+		}
 	}
 
-	gcm_enc_hash_done(areq, err);
+	aead_request_complete(req, err);
 }
 
 static int crypto_gcm_encrypt(struct aead_request *req)
@@ -552,9 +563,11 @@ static void gcm_dec_hash_done(struct cry
 		err = crypto_ablkcipher_decrypt(abreq);
 		if (err == -EINPROGRESS || err == -EBUSY)
 			return;
+		else if (!err)
+			err = crypto_gcm_verify(req, pctx);
 	}
 
-	gcm_decrypt_done(areq, err);
+	aead_request_complete(req, err);
 }
 
 static int crypto_gcm_decrypt(struct aead_request *req)


