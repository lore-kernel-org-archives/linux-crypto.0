From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/8] [CRYPTO] authenc: Merge common hashing code
Date: Tue, 11 Dec 2007 11:50:21 +0800
Message-ID: <E1J1w8T-0002eJ-00@gondolin.me.apana.org.au>
References: <20071211034945.GA10099@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1772 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751807AbXLKDu0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Dec 2007 22:50:26 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J1w8V-0005pJ-1o
	for <linux-crypto@vger.kernel.org>; Tue, 11 Dec 2007 14:50:23 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] authenc: Merge common hashing code

This patch merges the common hashing code between encryption and decryption.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/authenc.c |   66 +++++++++++++++++++++++--------------------------------
 1 files changed, 28 insertions(+), 38 deletions(-)

diff --git a/crypto/authenc.c b/crypto/authenc.c
index aa442de..394e733 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -87,17 +87,18 @@ badkey:
 	goto out;
 }
 
-static int crypto_authenc_hash(struct aead_request *req)
+static u8 *crypto_authenc_hash(struct aead_request *req, unsigned int flags,
+			       struct scatterlist *cipher,
+			       unsigned int cryptlen)
 {
 	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
 	struct crypto_authenc_ctx *ctx = crypto_aead_ctx(authenc);
 	struct crypto_hash *auth = ctx->auth;
 	struct hash_desc desc = {
 		.tfm = auth,
+		.flags = aead_request_flags(req) & flags,
 	};
 	u8 *hash = aead_request_ctx(req);
-	struct scatterlist *dst = req->dst;
-	unsigned int cryptlen = req->cryptlen;
 	int err;
 
 	hash = (u8 *)ALIGN((unsigned long)hash + crypto_hash_alignmask(auth), 
@@ -112,7 +113,7 @@ static int crypto_authenc_hash(struct aead_request *req)
 	if (err)
 		goto auth_unlock;
 
-	err = crypto_hash_update(&desc, dst, cryptlen);
+	err = crypto_hash_update(&desc, cipher, cryptlen);
 	if (err)
 		goto auth_unlock;
 
@@ -121,7 +122,21 @@ auth_unlock:
 	spin_unlock_bh(&ctx->auth_lock);
 
 	if (err)
-		return err;
+		return ERR_PTR(err);
+
+	return hash;
+}
+
+static int crypto_authenc_genicv(struct aead_request *req, unsigned int flags)
+{
+	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
+	struct scatterlist *dst = req->dst;
+	unsigned int cryptlen = req->cryptlen;
+	u8 *hash;
+
+	hash = crypto_authenc_hash(req, flags, dst, cryptlen);
+	if (IS_ERR(hash))
+		return PTR_ERR(hash);
 
 	scatterwalk_map_and_copy(hash, dst, cryptlen,
 				 crypto_aead_authsize(authenc), 1);
@@ -132,7 +147,7 @@ static void crypto_authenc_encrypt_done(struct crypto_async_request *req,
 					int err)
 {
 	if (!err)
-		err = crypto_authenc_hash(req->data);
+		err = crypto_authenc_genicv(req->data, 0);
 
 	aead_request_complete(req->data, err);
 }
@@ -154,50 +169,25 @@ static int crypto_authenc_encrypt(struct aead_request *req)
 	if (err)
 		return err;
 
-	return crypto_authenc_hash(req);
+	return crypto_authenc_genicv(req, CRYPTO_TFM_REQ_MAY_SLEEP);
 }
 
 static int crypto_authenc_verify(struct aead_request *req,
 				 unsigned int cryptlen)
 {
 	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
-	struct crypto_authenc_ctx *ctx = crypto_aead_ctx(authenc);
-	struct crypto_hash *auth = ctx->auth;
-	struct hash_desc desc = {
-		.tfm = auth,
-		.flags = aead_request_flags(req),
-	};
-	u8 *ohash = aead_request_ctx(req);
+	u8 *ohash;
 	u8 *ihash;
 	struct scatterlist *src = req->src;
 	unsigned int authsize;
-	int err;
 
-	ohash = (u8 *)ALIGN((unsigned long)ohash + crypto_hash_alignmask(auth), 
-			    crypto_hash_alignmask(auth) + 1);
-	ihash = ohash + crypto_hash_digestsize(auth);
-
-	spin_lock_bh(&ctx->auth_lock);
-	err = crypto_hash_init(&desc);
-	if (err)
-		goto auth_unlock;
-
-	err = crypto_hash_update(&desc, req->assoc, req->assoclen);
-	if (err)
-		goto auth_unlock;
-
-	err = crypto_hash_update(&desc, src, cryptlen);
-	if (err)
-		goto auth_unlock;
-
-	err = crypto_hash_final(&desc, ohash);
-auth_unlock:
-	spin_unlock_bh(&ctx->auth_lock);
-
-	if (err)
-		return err;
+	ohash = crypto_authenc_hash(req, CRYPTO_TFM_REQ_MAY_SLEEP, src,
+				    cryptlen);
+	if (IS_ERR(ohash))
+		return PTR_ERR(ohash);
 
 	authsize = crypto_aead_authsize(authenc);
+	ihash = ohash + authsize;
 	scatterwalk_map_and_copy(ihash, src, cryptlen, authsize, 0);
 	return memcmp(ihash, ohash, authsize) ? -EBADMSG: 0;
 }
