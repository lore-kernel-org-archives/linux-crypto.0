From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 12/24] crypto: authenc - Use crypto_aead_set_reqsize helper
Date: Mon, 11 May 2015 17:47:53 +0800
Message-ID: <E1YrkJV-0001CW-L8@gondolin.me.apana.org.au>
References: <20150511094444.GA4260@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:42670 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbbEKJr6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2015 05:47:58 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YrkJW-0000HQ-Ja
	for <linux-crypto@vger.kernel.org>; Mon, 11 May 2015 19:47:55 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch uses the crypto_aead_set_reqsize helper to avoid directly
touching the internals of aead.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/authenc.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/crypto/authenc.c b/crypto/authenc.c
index 325f37a..3e85229 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -570,13 +570,14 @@ static int crypto_authenc_init_tfm(struct crypto_tfm *tfm)
 			    crypto_ahash_alignmask(auth) + 1) +
 		      crypto_ablkcipher_ivsize(enc);
 
-	tfm->crt_aead.reqsize = sizeof(struct authenc_request_ctx) +
-				ctx->reqoff +
-				max_t(unsigned int,
-				crypto_ahash_reqsize(auth) +
-				sizeof(struct ahash_request),
-				sizeof(struct skcipher_givcrypt_request) +
-				crypto_ablkcipher_reqsize(enc));
+	crypto_aead_set_reqsize(__crypto_aead_cast(tfm),
+		sizeof(struct authenc_request_ctx) +
+		ctx->reqoff +
+		max_t(unsigned int,
+			crypto_ahash_reqsize(auth) +
+			sizeof(struct ahash_request),
+			sizeof(struct skcipher_givcrypt_request) +
+			crypto_ablkcipher_reqsize(enc)));
 
 	return 0;
 
