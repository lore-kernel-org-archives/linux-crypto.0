From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 6/7] crypto: rsa-pkcs1pad - Move key size check to setkey
Date: Wed, 29 Jun 2016 17:58:33 +0800
Message-ID: <E1bICGP-0006oY-1j@gondolin.me.apana.org.au>
References: <20160629095655.GA26056@gondor.apana.org.au>
To: Andrzej Zaborowski <andrew.zaborowski@intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
	Stephan Mueller <smueller@chronox.de>,
	Mat Martineau <mathew.j.martineau@linux.intel.com>,
	Denis Kenzior <denkenz@gmail.com>,
	Salvatore Benedetto <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43062 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbcF2J6v (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Jun 2016 05:58:51 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Rather than repeatedly checking the key size on each operation,
we should be checking it once when the key is set.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/rsa-pkcs1pad.c |   56 +++++++++++++++++++++++---------------------------
 1 file changed, 26 insertions(+), 30 deletions(-)

diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index db19284..ebd8514 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -111,40 +111,48 @@ static int pkcs1pad_set_pub_key(struct crypto_akcipher *tfm, const void *key,
 		unsigned int keylen)
 {
 	struct pkcs1pad_ctx *ctx = akcipher_tfm_ctx(tfm);
-	int err, size;
+	int err;
+
+	ctx->key_size = 0;
 
 	err = crypto_akcipher_set_pub_key(ctx->child, key, keylen);
+	if (err)
+		return err;
 
-	if (!err) {
-		/* Find out new modulus size from rsa implementation */
-		size = crypto_akcipher_maxsize(ctx->child);
+	/* Find out new modulus size from rsa implementation */
+	err = crypto_akcipher_maxsize(ctx->child);
+	if (err < 0)
+		return err;
 
-		ctx->key_size = size > 0 ? size : 0;
-		if (size <= 0)
-			err = size;
-	}
+	if (err > PAGE_SIZE)
+		return -ENOTSUPP;
 
-	return err;
+	ctx->key_size = err;
+	return 0;
 }
 
 static int pkcs1pad_set_priv_key(struct crypto_akcipher *tfm, const void *key,
 		unsigned int keylen)
 {
 	struct pkcs1pad_ctx *ctx = akcipher_tfm_ctx(tfm);
-	int err, size;
+	int err;
+
+	ctx->key_size = 0;
 
 	err = crypto_akcipher_set_priv_key(ctx->child, key, keylen);
+	if (err)
+		return err;
 
-	if (!err) {
-		/* Find out new modulus size from rsa implementation */
-		size = crypto_akcipher_maxsize(ctx->child);
+	/* Find out new modulus size from rsa implementation */
+	err = crypto_akcipher_maxsize(ctx->child);
+	if (err < 0)
+		return err;
 
-		ctx->key_size = size > 0 ? size : 0;
-		if (size <= 0)
-			err = size;
-	}
+	if (err > PAGE_SIZE)
+		return -ENOTSUPP;
 
-	return err;
+	ctx->key_size = err;
+	return 0;
 }
 
 static int pkcs1pad_get_max_size(struct crypto_akcipher *tfm)
@@ -247,9 +255,6 @@ static int pkcs1pad_encrypt(struct akcipher_request *req)
 		return -EOVERFLOW;
 	}
 
-	if (ctx->key_size > PAGE_SIZE)
-		return -ENOTSUPP;
-
 	/*
 	 * Replace both input and output to add the padding in the input and
 	 * the potential missing leading zeros in the output.
@@ -367,9 +372,6 @@ static int pkcs1pad_decrypt(struct akcipher_request *req)
 	if (!ctx->key_size || req->src_len != ctx->key_size)
 		return -EINVAL;
 
-	if (ctx->key_size > PAGE_SIZE)
-		return -ENOTSUPP;
-
 	/* Reuse input buffer, output to a new buffer */
 	req_ctx->child_req.src = req->src;
 	req_ctx->child_req.src_len = req->src_len;
@@ -420,9 +422,6 @@ static int pkcs1pad_sign(struct akcipher_request *req)
 		return -EOVERFLOW;
 	}
 
-	if (ctx->key_size > PAGE_SIZE)
-		return -ENOTSUPP;
-
 	/*
 	 * Replace both input and output to add the padding in the input and
 	 * the potential missing leading zeros in the output.
@@ -560,9 +559,6 @@ static int pkcs1pad_verify(struct akcipher_request *req)
 	if (!ctx->key_size || req->src_len < ctx->key_size)
 		return -EINVAL;
 
-	if (ctx->key_size > PAGE_SIZE)
-		return -ENOTSUPP;
-
 	/* Reuse input buffer, output to a new buffer */
 	req_ctx->child_req.src = req->src;
 	req_ctx->child_req.src_len = req->src_len;
