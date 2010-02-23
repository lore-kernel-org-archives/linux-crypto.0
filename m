From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 2/2] crypto: authenc - move saved IV in front of the
	ablkcipher request
Date: Tue, 23 Feb 2010 07:22:37 +0100
Message-ID: <20100223062237.GE29013@secunet.com>
References: <20100223062109.GD29013@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:55057 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254Ab0BWGZZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Feb 2010 01:25:25 -0500
Content-Disposition: inline
In-Reply-To: <20100223062109.GD29013@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In crypto_authenc_encrypt() we save the IV behind the ablkcipher
request. To save space on the request, we overwrite the ablkcipher
request with a ahash request after encryption. So the IV may be
overwritten by the ahash request. This patch fixes this by placing
the IV in front of the ablkcipher/ahash request.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/authenc.c |   25 ++++++++++++++-----------
 1 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/crypto/authenc.c b/crypto/authenc.c
index 6287cfd..2bb7348 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -386,11 +386,13 @@ static int crypto_authenc_encrypt(struct aead_request *req)
 {
 	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
 	struct crypto_authenc_ctx *ctx = crypto_aead_ctx(authenc);
-	struct ablkcipher_request *abreq = aead_request_ctx(req);
+	struct authenc_request_ctx *areq_ctx = aead_request_ctx(req);
 	struct crypto_ablkcipher *enc = ctx->enc;
 	struct scatterlist *dst = req->dst;
 	unsigned int cryptlen = req->cryptlen;
-	u8 *iv = (u8 *)(abreq + 1) + crypto_ablkcipher_reqsize(enc);
+	struct ablkcipher_request *abreq = (void *)(areq_ctx->tail
+						    + ctx->reqoff);
+	u8 *iv = (u8 *)abreq - crypto_ablkcipher_ivsize(enc);
 	int err;
 
 	ablkcipher_request_set_tfm(abreq, enc);
@@ -546,10 +548,6 @@ static int crypto_authenc_init_tfm(struct crypto_tfm *tfm)
 	if (IS_ERR(auth))
 		return PTR_ERR(auth);
 
-	ctx->reqoff = ALIGN(2 * crypto_ahash_digestsize(auth) +
-			    crypto_ahash_alignmask(auth),
-			    crypto_ahash_alignmask(auth) + 1);
-
 	enc = crypto_spawn_skcipher(&ictx->enc);
 	err = PTR_ERR(enc);
 	if (IS_ERR(enc))
@@ -558,13 +556,18 @@ static int crypto_authenc_init_tfm(struct crypto_tfm *tfm)
 	ctx->auth = auth;
 	ctx->enc = enc;
 
-	tfm->crt_aead.reqsize = max_t(unsigned int,
-				crypto_ahash_reqsize(auth) + ctx->reqoff +
-				sizeof(struct authenc_request_ctx) +
+	ctx->reqoff = ALIGN(2 * crypto_ahash_digestsize(auth) +
+			    crypto_ahash_alignmask(auth),
+			    crypto_ahash_alignmask(auth) + 1) +
+		      crypto_ablkcipher_ivsize(enc);
+
+	tfm->crt_aead.reqsize = sizeof(struct authenc_request_ctx) +
+				ctx->reqoff +
+				max_t(unsigned int,
+				crypto_ahash_reqsize(auth) +
 				sizeof(struct ahash_request),
 				sizeof(struct skcipher_givcrypt_request) +
-				crypto_ablkcipher_reqsize(enc) +
-				crypto_ablkcipher_ivsize(enc));
+				crypto_ablkcipher_reqsize(enc));
 
 	return 0;
 
-- 
1.5.6.5

