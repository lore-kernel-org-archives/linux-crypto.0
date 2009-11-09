From: Huang Ying <ying.huang@intel.com>
Subject: [BUGFIX -v2 for .32] crypto, gcm, fix another complete call in
 complete fuction
Date: Mon, 09 Nov 2009 15:24:14 +0800
Message-ID: <1257751454.22519.2287.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:18003 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754036AbZKIHYK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Nov 2009 02:24:10 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The flow of the complete function (xxx_done) in gcm.c is as follow:

void complete(struct crypto_async_request *areq, int err)
{
	struct aead_request *req = areq->data;

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

- Add a __complete() for each complete(), which accept struct
  aead_request *req instead of areq, so avoid using areq after it is
  destroyed.

- Expand complete_for_next_step().

The fixing method is based on the idea of Herbert Xu.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 crypto/gcm.c |  120 ++++++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 86 insertions(+), 34 deletions(-)

--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -40,7 +40,7 @@ struct crypto_rfc4106_ctx {
 struct crypto_gcm_ghash_ctx {
 	unsigned int cryptlen;
 	struct scatterlist *src;
-	crypto_completion_t complete;
+	void (*complete)(struct aead_request *req, int err);
 };
 
 struct crypto_gcm_req_priv_ctx {
@@ -267,54 +267,73 @@ static int gcm_hash_final(struct aead_re
 	return crypto_ahash_final(ahreq);
 }
 
-static void gcm_hash_final_done(struct crypto_async_request *areq,
-				int err)
+static void __gcm_hash_final_done(struct aead_request *req,
+				  struct crypto_gcm_req_priv_ctx *pctx,
+				  int err)
 {
-	struct aead_request *req = areq->data;
-	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
 	struct crypto_gcm_ghash_ctx *gctx = &pctx->ghash_ctx;
 
 	if (!err)
 		crypto_xor(pctx->auth_tag, pctx->iauth_tag, 16);
 
-	gctx->complete(areq, err);
+	gctx->complete(req, err);
 }
 
-static void gcm_hash_len_done(struct crypto_async_request *areq,
-			      int err)
+static void gcm_hash_final_done(struct crypto_async_request *areq, int err)
 {
 	struct aead_request *req = areq->data;
 	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
 
+	__gcm_hash_final_done(req, pctx, err);
+}
+
+static void __gcm_hash_len_done(struct aead_request *req,
+				struct crypto_gcm_req_priv_ctx *pctx,
+				int err)
+{
 	if (!err) {
 		err = gcm_hash_final(req, pctx);
 		if (err == -EINPROGRESS || err == -EBUSY)
 			return;
 	}
 
-	gcm_hash_final_done(areq, err);
+	__gcm_hash_final_done(req, pctx, err);
 }
 
-static void gcm_hash_crypt_remain_done(struct crypto_async_request *areq,
-				       int err)
+static void gcm_hash_len_done(struct crypto_async_request *areq, int err)
 {
 	struct aead_request *req = areq->data;
 	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
 
+	__gcm_hash_len_done(req, pctx, err);
+}
+
+static void __gcm_hash_crypt_remain_done(struct aead_request *req,
+					 struct crypto_gcm_req_priv_ctx *pctx,
+					 int err)
+{
 	if (!err) {
 		err = gcm_hash_len(req, pctx);
 		if (err == -EINPROGRESS || err == -EBUSY)
 			return;
 	}
 
-	gcm_hash_len_done(areq, err);
+	__gcm_hash_len_done(req, pctx, err);
 }
 
-static void gcm_hash_crypt_done(struct crypto_async_request *areq,
-				int err)
+static void gcm_hash_crypt_remain_done(struct crypto_async_request *areq,
+				       int err)
 {
 	struct aead_request *req = areq->data;
 	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
+
+	__gcm_hash_crypt_remain_done(req, pctx, err);
+}
+
+static void __gcm_hash_crypt_done(struct aead_request *req,
+				  struct crypto_gcm_req_priv_ctx *pctx,
+				  int err)
+{
 	struct crypto_gcm_ghash_ctx *gctx = &pctx->ghash_ctx;
 	unsigned int remain;
 
@@ -327,14 +346,21 @@ static void gcm_hash_crypt_done(struct c
 			return;
 	}
 
-	gcm_hash_crypt_remain_done(areq, err);
+	__gcm_hash_crypt_remain_done(req, pctx, err);
 }
 
-static void gcm_hash_assoc_remain_done(struct crypto_async_request *areq,
-					   int err)
+static void gcm_hash_crypt_done(struct crypto_async_request *areq, int err)
 {
 	struct aead_request *req = areq->data;
 	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
+
+	__gcm_hash_crypt_done(req, pctx, err);
+}
+
+static void __gcm_hash_assoc_remain_done(struct aead_request *req,
+					 struct crypto_gcm_req_priv_ctx *pctx,
+					 int err)
+{
 	struct crypto_gcm_ghash_ctx *gctx = &pctx->ghash_ctx;
 	crypto_completion_t complete;
 	unsigned int remain = 0;
@@ -350,16 +376,24 @@ static void gcm_hash_assoc_remain_done(s
 	}
 
 	if (remain)
-		gcm_hash_crypt_done(areq, err);
+		__gcm_hash_crypt_done(req, pctx, err);
 	else
-		gcm_hash_crypt_remain_done(areq, err);
+		__gcm_hash_crypt_remain_done(req, pctx, err);
 }
 
-static void gcm_hash_assoc_done(struct crypto_async_request *areq,
-				int err)
+static void gcm_hash_assoc_remain_done(struct crypto_async_request *areq,
+				       int err)
 {
 	struct aead_request *req = areq->data;
 	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
+
+	__gcm_hash_assoc_remain_done(req, pctx, err);
+}
+
+static void __gcm_hash_assoc_done(struct aead_request *req,
+				  struct crypto_gcm_req_priv_ctx *pctx,
+				  int err)
+{
 	unsigned int remain;
 
 	if (!err) {
@@ -371,14 +405,21 @@ static void gcm_hash_assoc_done(struct c
 			return;
 	}
 
-	gcm_hash_assoc_remain_done(areq, err);
+	__gcm_hash_assoc_remain_done(req, pctx, err);
 }
 
-static void gcm_hash_init_done(struct crypto_async_request *areq,
-			       int err)
+static void gcm_hash_assoc_done(struct crypto_async_request *areq, int err)
 {
 	struct aead_request *req = areq->data;
 	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
+
+	__gcm_hash_assoc_done(req, pctx, err);
+}
+
+static void __gcm_hash_init_done(struct aead_request *req,
+				 struct crypto_gcm_req_priv_ctx *pctx,
+				 int err)
+{
 	crypto_completion_t complete;
 	unsigned int remain = 0;
 
@@ -393,9 +434,17 @@ static void gcm_hash_init_done(struct cr
 	}
 
 	if (remain)
-		gcm_hash_assoc_done(areq, err);
+		__gcm_hash_assoc_done(req, pctx, err);
 	else
-		gcm_hash_assoc_remain_done(areq, err);
+		__gcm_hash_assoc_remain_done(req, pctx, err);
+}
+
+static void gcm_hash_init_done(struct crypto_async_request *areq, int err)
+{
+	struct aead_request *req = areq->data;
+	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
+
+	__gcm_hash_init_done(req, pctx, err);
 }
 
 static int gcm_hash(struct aead_request *req,
@@ -457,10 +506,8 @@ static void gcm_enc_copy_hash(struct aea
 				 crypto_aead_authsize(aead), 1);
 }
 
-static void gcm_enc_hash_done(struct crypto_async_request *areq,
-				     int err)
+static void gcm_enc_hash_done(struct aead_request *req, int err)
 {
-	struct aead_request *req = areq->data;
 	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
 
 	if (!err)
@@ -470,7 +517,7 @@ static void gcm_enc_hash_done(struct cry
 }
 
 static void gcm_encrypt_done(struct crypto_async_request *areq,
-				     int err)
+			     int err)
 {
 	struct aead_request *req = areq->data;
 	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
@@ -479,9 +526,13 @@ static void gcm_encrypt_done(struct cryp
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
@@ -538,9 +589,8 @@ static void gcm_decrypt_done(struct cryp
 	aead_request_complete(req, err);
 }
 
-static void gcm_dec_hash_done(struct crypto_async_request *areq, int err)
+static void gcm_dec_hash_done(struct aead_request *req, int err)
 {
-	struct aead_request *req = areq->data;
 	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
 	struct ablkcipher_request *abreq = &pctx->u.abreq;
 	struct crypto_gcm_ghash_ctx *gctx = &pctx->ghash_ctx;
@@ -552,9 +602,11 @@ static void gcm_dec_hash_done(struct cry
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


