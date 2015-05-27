From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 8/11] crypto: seqiv - Copy AD along with plain/cipher text
Date: Wed, 27 May 2015 14:37:36 +0800
Message-ID: <E1YxUy8-0006mq-9g@gondolin.me.apana.org.au>
References: <20150527063539.GA25889@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:57269 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbbE0Ghk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 May 2015 02:37:40 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YxUy9-0005dE-Bj
	for <linux-crypto@vger.kernel.org>; Wed, 27 May 2015 16:37:37 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

As the AD does not necessarily exist in the destination buffer
it must be copied along with the plain/cipher text.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/seqiv.c |   33 ++++++---------------------------
 1 file changed, 6 insertions(+), 27 deletions(-)

diff --git a/crypto/seqiv.c b/crypto/seqiv.c
index 127970a..b55c685 100644
--- a/crypto/seqiv.c
+++ b/crypto/seqiv.c
@@ -315,19 +315,12 @@ static int seqiv_aead_encrypt_compat(struct aead_request *req)
 	data = req;
 
 	if (req->src != req->dst) {
-		struct scatterlist srcbuf[2];
-		struct scatterlist dstbuf[2];
 		struct blkcipher_desc desc = {
 			.tfm = ctx->null,
 		};
 
-		err = crypto_blkcipher_encrypt(
-			&desc,
-			scatterwalk_ffwd(dstbuf, req->dst,
-					 req->assoclen + ivsize),
-			scatterwalk_ffwd(srcbuf, req->src,
-					 req->assoclen + ivsize),
-			req->cryptlen - ivsize);
+		err = crypto_blkcipher_encrypt(&desc, req->dst, req->src,
+					       req->assoclen + req->cryptlen);
 		if (err)
 			return err;
 	}
@@ -373,19 +366,12 @@ static int seqiv_aead_encrypt(struct aead_request *req)
 	info = req->iv;
 
 	if (req->src != req->dst) {
-		struct scatterlist src[2];
-		struct scatterlist dst[2];
 		struct blkcipher_desc desc = {
 			.tfm = ctx->null,
 		};
 
-		err = crypto_blkcipher_encrypt(
-			&desc,
-			scatterwalk_ffwd(dst, req->dst,
-					 req->assoclen + ivsize),
-			scatterwalk_ffwd(src, req->src,
-					 req->assoclen + ivsize),
-			req->cryptlen - ivsize);
+		err = crypto_blkcipher_encrypt(&desc, req->dst, req->src,
+					       req->assoclen + req->cryptlen);
 		if (err)
 			return err;
 	}
@@ -446,19 +432,12 @@ static int seqiv_aead_decrypt_compat(struct aead_request *req)
 	}
 
 	if (req->src != req->dst) {
-		struct scatterlist srcbuf[2];
-		struct scatterlist dstbuf[2];
 		struct blkcipher_desc desc = {
 			.tfm = ctx->null,
 		};
 
-		err = crypto_blkcipher_encrypt(
-			&desc,
-			scatterwalk_ffwd(dstbuf, req->dst,
-					 req->assoclen + ivsize),
-			scatterwalk_ffwd(srcbuf, req->src,
-					 req->assoclen + ivsize),
-			req->cryptlen - ivsize);
+		err = crypto_blkcipher_encrypt(&desc, req->dst, req->src,
+					       req->assoclen + req->cryptlen);
 		if (err)
 			return err;
 	}
