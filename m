From: Shikhar <shikhark@gmail.com>
Subject: Possible bug in AUTHENC
Date: Wed, 19 May 2010 15:24:24 +0200
Message-ID: <AANLkTiltCjRr91OASbzzDplRp3zl5yaUnM0RKwzg3S_G@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: herbert@gondor.apana.org.au
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61203 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab0ESNYq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 May 2010 09:24:46 -0400
Received: by wyg36 with SMTP id 36so417339wyg.19
        for <linux-crypto@vger.kernel.org>; Wed, 19 May 2010 06:24:44 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

I am currently working on a driver for our crypto HW and the initial
aim was to offload IPSec (ESP for now) to HW. I did this by
registering the cipher and hash algorithms (both asynchronous)
separately (AES-CBC, HMAC-SHA1 only for now) and let the API handle
the request using the AUTHENC interface.

The problem seems to be after the asynchronous hash request is
completed, the length of the ABLKCIPHER decrypt request is not
calculated correctly in "authenc_verify_ahash_update_done()" and
"authenc_verify_ahash_done()". The length should be subtracted by
"authsize" as done in "crypto_authenc_decrypt()".

The following patch (applied against 2.6.34) should fix it. I hope I
didn't miss anything.

Thanks,
Shikhar

--------
diff -pu linux-2.6.34/crypto/authenc.c linux-2.6.34_mod/crypto/authenc.c

--- linux-2.6.34/crypto/authenc.c	2010-05-16 23:17:36.000000000 +0200
+++ linux-2.6.34_mod/crypto/authenc.c	2010-05-19 14:32:51.000000000 +0200
@@ -181,6 +181,7 @@ static void authenc_verify_ahash_update_
 	struct crypto_authenc_ctx *ctx = crypto_aead_ctx(authenc);
 	struct authenc_request_ctx *areq_ctx = aead_request_ctx(req);
 	struct ahash_request *ahreq = (void *)(areq_ctx->tail + ctx->reqoff);
+	unsigned int cryptlen = req->cryptlen;

 	if (err)
 		goto out;
@@ -196,6 +197,7 @@ static void authenc_verify_ahash_update_
 		goto out;

 	authsize = crypto_aead_authsize(authenc);
+	cryptlen -= authsize;
 	ihash = ahreq->result + authsize;
 	scatterwalk_map_and_copy(ihash, areq_ctx->sg, areq_ctx->cryptlen,
 				 authsize, 0);
@@ -209,7 +211,7 @@ static void authenc_verify_ahash_update_
 	ablkcipher_request_set_callback(abreq, aead_request_flags(req),
 					req->base.complete, req->base.data);
 	ablkcipher_request_set_crypt(abreq, req->src, req->dst,
-				     req->cryptlen, req->iv);
+				     cryptlen, req->iv);

 	err = crypto_ablkcipher_decrypt(abreq);

@@ -228,11 +230,13 @@ static void authenc_verify_ahash_done(st
 	struct crypto_authenc_ctx *ctx = crypto_aead_ctx(authenc);
 	struct authenc_request_ctx *areq_ctx = aead_request_ctx(req);
 	struct ahash_request *ahreq = (void *)(areq_ctx->tail + ctx->reqoff);
+	unsigned int cryptlen = req->cryptlen;

 	if (err)
 		goto out;

 	authsize = crypto_aead_authsize(authenc);
+	cryptlen -= authsize;
 	ihash = ahreq->result + authsize;
 	scatterwalk_map_and_copy(ihash, areq_ctx->sg, areq_ctx->cryptlen,
 				 authsize, 0);
@@ -246,7 +250,7 @@ static void authenc_verify_ahash_done(st
 	ablkcipher_request_set_callback(abreq, aead_request_flags(req),
 					req->base.complete, req->base.data);
 	ablkcipher_request_set_crypt(abreq, req->src, req->dst,
-				     req->cryptlen, req->iv);
+				     cryptlen, req->iv);

 	err = crypto_ablkcipher_decrypt(abreq);

--- linux-2.6.34/crypto/authenc.c	2010-05-16 23:17:36.000000000 +0200
+++ linux-2.6.34_mod/crypto/authenc.c	2010-05-19 14:32:51.000000000 +0200
@@ -181,6 +181,7 @@ static void authenc_verify_ahash_update_
 	struct crypto_authenc_ctx *ctx = crypto_aead_ctx(authenc);
 	struct authenc_request_ctx *areq_ctx = aead_request_ctx(req);
 	struct ahash_request *ahreq = (void *)(areq_ctx->tail + ctx->reqoff);
+	unsigned int cryptlen = req->cryptlen;

 	if (err)
 		goto out;
@@ -196,6 +197,7 @@ static void authenc_verify_ahash_update_
 		goto out;

 	authsize = crypto_aead_authsize(authenc);
+	cryptlen -= authsize;
 	ihash = ahreq->result + authsize;
 	scatterwalk_map_and_copy(ihash, areq_ctx->sg, areq_ctx->cryptlen,
 				 authsize, 0);
@@ -209,7 +211,7 @@ static void authenc_verify_ahash_update_
 	ablkcipher_request_set_callback(abreq, aead_request_flags(req),
 					req->base.complete, req->base.data);
 	ablkcipher_request_set_crypt(abreq, req->src, req->dst,
-				     req->cryptlen, req->iv);
+				     cryptlen, req->iv);

 	err = crypto_ablkcipher_decrypt(abreq);

@@ -228,11 +230,13 @@ static void authenc_verify_ahash_done(st
 	struct crypto_authenc_ctx *ctx = crypto_aead_ctx(authenc);
 	struct authenc_request_ctx *areq_ctx = aead_request_ctx(req);
 	struct ahash_request *ahreq = (void *)(areq_ctx->tail + ctx->reqoff);
+	unsigned int cryptlen = req->cryptlen;

 	if (err)
 		goto out;

 	authsize = crypto_aead_authsize(authenc);
+	cryptlen -= authsize;
 	ihash = ahreq->result + authsize;
 	scatterwalk_map_and_copy(ihash, areq_ctx->sg, areq_ctx->cryptlen,
 				 authsize, 0);
@@ -246,7 +250,7 @@ static void authenc_verify_ahash_done(st
 	ablkcipher_request_set_callback(abreq, aead_request_flags(req),
 					req->base.complete, req->base.data);
 	ablkcipher_request_set_crypt(abreq, req->src, req->dst,
-				     req->cryptlen, req->iv);
+				     cryptlen, req->iv);

 	err = crypto_ablkcipher_decrypt(abreq);

 --------
