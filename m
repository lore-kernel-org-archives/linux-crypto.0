From: Huang Ying <ying.huang@intel.com>
Subject: [BUGFIX -v3 for .32] crypto, gcm, fix another complete call in
 complete fuction
Date: Tue, 10 Nov 2009 15:39:11 +0800
Message-ID: <1257838751.22519.2513.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:19040 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752050AbZKJHjI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Nov 2009 02:39:08 -0500
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
 crypto/gcm.c |  107 ++++++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 73 insertions(+), 34 deletions(-)

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
@@ -267,23 +267,26 @@ static int gcm_hash_final(struct aead_re
 	return crypto_ahash_final(ahreq);
 }
 
-static void gcm_hash_final_done(struct crypto_async_request *areq,
-				int err)
+static void __gcm_hash_final_done(struct aead_request *req, int err)
 {
-	struct aead_request *req = areq->data;
 	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
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
+
+	__gcm_hash_final_done(req, err);
+}
+
+static void __gcm_hash_len_done(struct aead_request *req, int err)
+{
 	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
 
 	if (!err) {
@@ -292,13 +295,18 @@ static void gcm_hash_len_done(struct cry
 			return;
 	}
 
-	gcm_hash_final_done(areq, err);
+	__gcm_hash_final_done(req, err);
 }
 
-static void gcm_hash_crypt_remain_done(struct crypto_async_request *areq,
-				       int err)
+static void gcm_hash_len_done(struct crypto_async_request *areq, int err)
 {
 	struct aead_request *req = areq->data;
+
+	__gcm_hash_len_done(req, err);
+}
+
+static void __gcm_hash_crypt_remain_done(struct aead_request *req, int err)
+{
 	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
 
 	if (!err) {
@@ -307,13 +315,19 @@ static void gcm_hash_crypt_remain_done(s
 			return;
 	}
 
-	gcm_hash_len_done(areq, err);
+	__gcm_hash_len_done(req, err);
 }
 
-static void gcm_hash_crypt_done(struct crypto_async_request *areq,
-				int err)
+static void gcm_hash_crypt_remain_done(struct crypto_async_request *areq,
+				       int err)
 {
 	struct aead_request *req = areq->data;
+
+	__gcm_hash_crypt_remain_done(req, err);
+}
+
+static void __gcm_hash_crypt_done(struct aead_request *req, int err)
+{
 	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
 	struct crypto_gcm_ghash_ctx *gctx = &pctx->ghash_ctx;
 	unsigned int remain;
@@ -327,13 +341,18 @@ static void gcm_hash_crypt_done(struct c
 			return;
 	}
 
-	gcm_hash_crypt_remain_done(areq, err);
+	__gcm_hash_crypt_remain_done(req, err);
 }
 
-static void gcm_hash_assoc_remain_done(struct crypto_async_request *areq,
-					   int err)
+static void gcm_hash_crypt_done(struct crypto_async_request *areq, int err)
 {
 	struct aead_request *req = areq->data;
+
+	__gcm_hash_crypt_done(req, err);
+}
+
+static void __gcm_hash_assoc_remain_done(struct aead_request *req, int err)
+{
 	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
 	struct crypto_gcm_ghash_ctx *gctx = &pctx->ghash_ctx;
 	crypto_completion_t complete;
@@ -350,15 +369,21 @@ static void gcm_hash_assoc_remain_done(s
 	}
 
 	if (remain)
-		gcm_hash_crypt_done(areq, err);
+		__gcm_hash_crypt_done(req, err);
 	else
-		gcm_hash_crypt_remain_done(areq, err);
+		__gcm_hash_crypt_remain_done(req, err);
 }
 
-static void gcm_hash_assoc_done(struct crypto_async_request *areq,
-				int err)
+static void gcm_hash_assoc_remain_done(struct crypto_async_request *areq,
+				       int err)
 {
 	struct aead_request *req = areq->data;
+
+	__gcm_hash_assoc_remain_done(req, err);
+}
+
+static void __gcm_hash_assoc_done(struct aead_request *req, int err)
+{
 	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
 	unsigned int remain;
 
@@ -371,13 +396,18 @@ static void gcm_hash_assoc_done(struct c
 			return;
 	}
 
-	gcm_hash_assoc_remain_done(areq, err);
+	__gcm_hash_assoc_remain_done(req, err);
 }
 
-static void gcm_hash_init_done(struct crypto_async_request *areq,
-			       int err)
+static void gcm_hash_assoc_done(struct crypto_async_request *areq, int err)
 {
 	struct aead_request *req = areq->data;
+
+	__gcm_hash_assoc_done(req, err);
+}
+
+static void __gcm_hash_init_done(struct aead_request *req, int err)
+{
 	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
 	crypto_completion_t complete;
 	unsigned int remain = 0;
@@ -393,9 +423,16 @@ static void gcm_hash_init_done(struct cr
 	}
 
 	if (remain)
-		gcm_hash_assoc_done(areq, err);
+		__gcm_hash_assoc_done(req, err);
 	else
-		gcm_hash_assoc_remain_done(areq, err);
+		__gcm_hash_assoc_remain_done(req, err);
+}
+
+static void gcm_hash_init_done(struct crypto_async_request *areq, int err)
+{
+	struct aead_request *req = areq->data;
+
+	__gcm_hash_init_done(req, err);
 }
 
 static int gcm_hash(struct aead_request *req,
@@ -457,10 +494,8 @@ static void gcm_enc_copy_hash(struct aea
 				 crypto_aead_authsize(aead), 1);
 }
 
-static void gcm_enc_hash_done(struct crypto_async_request *areq,
-				     int err)
+static void gcm_enc_hash_done(struct aead_request *req, int err)
 {
-	struct aead_request *req = areq->data;
 	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
 
 	if (!err)
@@ -469,8 +504,7 @@ static void gcm_enc_hash_done(struct cry
 	aead_request_complete(req, err);
 }
 
-static void gcm_encrypt_done(struct crypto_async_request *areq,
-				     int err)
+static void gcm_encrypt_done(struct crypto_async_request *areq, int err)
 {
 	struct aead_request *req = areq->data;
 	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
@@ -479,9 +513,13 @@ static void gcm_encrypt_done(struct cryp
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
@@ -538,9 +576,8 @@ static void gcm_decrypt_done(struct cryp
 	aead_request_complete(req, err);
 }
 
-static void gcm_dec_hash_done(struct crypto_async_request *areq, int err)
+static void gcm_dec_hash_done(struct aead_request *req, int err)
 {
-	struct aead_request *req = areq->data;
 	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
 	struct ablkcipher_request *abreq = &pctx->u.abreq;
 	struct crypto_gcm_ghash_ctx *gctx = &pctx->ghash_ctx;
@@ -552,9 +589,11 @@ static void gcm_dec_hash_done(struct cry
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


