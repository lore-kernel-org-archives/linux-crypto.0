From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 17/24] crypto: pcrypt - Use crypto_aead_set_reqsize helper
Date: Mon, 11 May 2015 17:48:01 +0800
Message-ID: <E1YrkJd-0001Dt-7K@gondolin.me.apana.org.au>
References: <20150511094444.GA4260@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:48992 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060AbbEKJsF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2015 05:48:05 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YrkJe-0000Jw-9F
	for <linux-crypto@vger.kernel.org>; Mon, 11 May 2015 19:48:02 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch uses the crypto_aead_set_reqsize helper to avoid directly
touching the internals of aead.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/pcrypt.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index c305d41..ac115d5 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -292,9 +292,10 @@ static int pcrypt_aead_init_tfm(struct crypto_tfm *tfm)
 		return PTR_ERR(cipher);
 
 	ctx->child = cipher;
-	tfm->crt_aead.reqsize = sizeof(struct pcrypt_request)
-		+ sizeof(struct aead_givcrypt_request)
-		+ crypto_aead_reqsize(cipher);
+	crypto_aead_set_reqsize(__crypto_aead_cast(tfm),
+		sizeof(struct pcrypt_request) +
+		sizeof(struct aead_givcrypt_request) +
+		crypto_aead_reqsize(cipher));
 
 	return 0;
 }
