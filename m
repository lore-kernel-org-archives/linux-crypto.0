From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 16/24] crypto: gcm - Use crypto_aead_set_reqsize helper
Date: Mon, 11 May 2015 17:47:59 +0800
Message-ID: <E1YrkJb-0001Dc-L3@gondolin.me.apana.org.au>
References: <20150511094444.GA4260@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53210 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbbEKJsD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2015 05:48:03 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YrkJc-0000JO-D6
	for <linux-crypto@vger.kernel.org>; Mon, 11 May 2015 19:48:00 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch uses the crypto_aead_set_reqsize helper to avoid directly
touching the internals of aead.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/gcm.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/crypto/gcm.c b/crypto/gcm.c
index 2e403f6..b56200e 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -672,12 +672,12 @@ static int crypto_gcm_init_tfm(struct crypto_tfm *tfm)
 
 	align = crypto_tfm_alg_alignmask(tfm);
 	align &= ~(crypto_tfm_ctx_alignment() - 1);
-	tfm->crt_aead.reqsize = align +
-		offsetof(struct crypto_gcm_req_priv_ctx, u) +
+	crypto_aead_set_reqsize(__crypto_aead_cast(tfm),
+		align + offsetof(struct crypto_gcm_req_priv_ctx, u) +
 		max(sizeof(struct ablkcipher_request) +
 		    crypto_ablkcipher_reqsize(ctr),
 		    sizeof(struct ahash_request) +
-		    crypto_ahash_reqsize(ghash));
+		    crypto_ahash_reqsize(ghash)));
 
 	return 0;
 
@@ -946,10 +946,10 @@ static int crypto_rfc4106_init_tfm(struct crypto_tfm *tfm)
 
 	align = crypto_aead_alignmask(aead);
 	align &= ~(crypto_tfm_ctx_alignment() - 1);
-	tfm->crt_aead.reqsize = sizeof(struct aead_request) +
-				ALIGN(crypto_aead_reqsize(aead),
-				      crypto_tfm_ctx_alignment()) +
-				align + 16;
+	crypto_aead_set_reqsize(__crypto_aead_cast(tfm),
+		sizeof(struct aead_request) +
+		ALIGN(crypto_aead_reqsize(aead), crypto_tfm_ctx_alignment()) +
+		align + 16);
 
 	return 0;
 }
@@ -1256,10 +1256,10 @@ static int crypto_rfc4543_init_tfm(struct crypto_tfm *tfm)
 
 	align = crypto_aead_alignmask(aead);
 	align &= ~(crypto_tfm_ctx_alignment() - 1);
-	tfm->crt_aead.reqsize = sizeof(struct crypto_rfc4543_req_ctx) +
-				ALIGN(crypto_aead_reqsize(aead),
-				      crypto_tfm_ctx_alignment()) +
-				align + 16;
+	crypto_aead_set_reqsize(__crypto_aead_cast(tfm),
+		sizeof(struct crypto_rfc4543_req_ctx) +
+		ALIGN(crypto_aead_reqsize(aead), crypto_tfm_ctx_alignment()) +
+		align + 16);
 
 	return 0;
 
