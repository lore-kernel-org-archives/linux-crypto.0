From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 13/24] crypto: authencesn - Use crypto_aead_set_reqsize helper
Date: Mon, 11 May 2015 17:47:55 +0800
Message-ID: <E1YrkJX-0001Ck-4x@gondolin.me.apana.org.au>
References: <20150511094444.GA4260@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39361 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017AbbEKJr7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2015 05:47:59 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YrkJY-0000Hz-Ch
	for <linux-crypto@vger.kernel.org>; Mon, 11 May 2015 19:47:56 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch uses the crypto_aead_set_reqsize helper to avoid directly
touching the internals of aead.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/authencesn.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/crypto/authencesn.c b/crypto/authencesn.c
index 91e2cc3..a3da677 100644
--- a/crypto/authencesn.c
+++ b/crypto/authencesn.c
@@ -662,13 +662,14 @@ static int crypto_authenc_esn_init_tfm(struct crypto_tfm *tfm)
 			    crypto_ahash_alignmask(auth) + 1) +
 		      crypto_ablkcipher_ivsize(enc);
 
-	tfm->crt_aead.reqsize = sizeof(struct authenc_esn_request_ctx) +
-				ctx->reqoff +
-				max_t(unsigned int,
-				crypto_ahash_reqsize(auth) +
-				sizeof(struct ahash_request),
-				sizeof(struct skcipher_givcrypt_request) +
-				crypto_ablkcipher_reqsize(enc));
+	crypto_aead_set_reqsize(__crypto_aead_cast(tfm),
+		sizeof(struct authenc_esn_request_ctx) +
+		ctx->reqoff +
+		max_t(unsigned int,
+			crypto_ahash_reqsize(auth) +
+			sizeof(struct ahash_request),
+			sizeof(struct skcipher_givcrypt_request) +
+			crypto_ablkcipher_reqsize(enc)));
 
 	return 0;
 
