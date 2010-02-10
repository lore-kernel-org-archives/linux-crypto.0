From: Richard Hartmann <richih.mailinglist@gmail.com>
Subject: [PATCH 1/1] CRYPTO: Fix checkpatch errors & warnings in authenc.c
Date: Wed, 10 Feb 2010 02:20:45 +0100
Message-ID: <1265764847-23516-1-git-send-email-richih.mailinglist@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: richih.mailinglist@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41794 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818Ab0BJBVi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Feb 2010 20:21:38 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>
---
 crypto/authenc.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/crypto/authenc.c b/crypto/authenc.c
index 4d6f49a..1887090 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -194,7 +194,7 @@ static void authenc_verify_ahash_update_done(struct crypto_async_request *areq,
 	scatterwalk_map_and_copy(ihash, areq_ctx->sg, areq_ctx->cryptlen,
 				 authsize, 0);
 
-	err = memcmp(ihash, ahreq->result, authsize) ? -EBADMSG: 0;
+	err = memcmp(ihash, ahreq->result, authsize) ? -EBADMSG : 0;
 	if (err)
 		goto out;
 
@@ -231,7 +231,7 @@ static void authenc_verify_ahash_done(struct crypto_async_request *areq,
 	scatterwalk_map_and_copy(ihash, areq_ctx->sg, areq_ctx->cryptlen,
 				 authsize, 0);
 
-	err = memcmp(ihash, ahreq->result, authsize) ? -EBADMSG: 0;
+	err = memcmp(ihash, ahreq->result, authsize) ? -EBADMSG : 0;
 	if (err)
 		goto out;
 
@@ -464,7 +464,7 @@ static int crypto_authenc_verify(struct aead_request *req,
 	ihash = ohash + authsize;
 	scatterwalk_map_and_copy(ihash, areq_ctx->sg, areq_ctx->cryptlen,
 				 authsize, 0);
-	return memcmp(ihash, ohash, authsize) ? -EBADMSG: 0;
+	return memcmp(ihash, ohash, authsize) ? -EBADMSG : 0;
 }
 
 static int crypto_authenc_iverify(struct aead_request *req, u8 *iv,
@@ -557,11 +557,11 @@ static int crypto_authenc_init_tfm(struct crypto_tfm *tfm)
 
 	ctx->auth = auth;
 	ctx->enc = enc;
-	
+
 	tfm->crt_aead.reqsize = max_t(unsigned int,
 				crypto_ahash_reqsize(auth) + ctx->reqoff +
 				sizeof(struct authenc_request_ctx) +
-				sizeof(struct ahash_request), 
+				sizeof(struct ahash_request),
 				sizeof(struct skcipher_givcrypt_request) +
 				crypto_ablkcipher_reqsize(enc) +
 				crypto_ablkcipher_ivsize(enc));
-- 
1.6.6.1

