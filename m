From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 10/13] crypto: cryptd - Remove reference to crypto_aead_crt
Date: Thu, 13 Aug 2015 17:29:02 +0800
Message-ID: <E1ZPooo-0005r0-MY@gondolin.me.apana.org.au>
References: <20150813092520.GA22268@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:42292 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbbHMJ3G (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Aug 2015 05:29:06 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1ZPoop-00036v-7v
	for <linux-crypto@vger.kernel.org>; Thu, 13 Aug 2015 19:29:03 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Pretty soon the crypto_aead encrypt/decrypt hooks will disappear
as they are now always identical to those in struct aead_alg.

This patch replaces the references to these hooks with the ones
from aead_alg instead.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/cryptd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 360ee85..e5076f8 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -709,7 +709,7 @@ static void cryptd_aead_encrypt(struct crypto_async_request *areq, int err)
 	struct aead_request *req;
 
 	req = container_of(areq, struct aead_request, base);
-	cryptd_aead_crypt(req, child, err, crypto_aead_crt(child)->encrypt);
+	cryptd_aead_crypt(req, child, err, crypto_aead_alg(child)->encrypt);
 }
 
 static void cryptd_aead_decrypt(struct crypto_async_request *areq, int err)
@@ -719,7 +719,7 @@ static void cryptd_aead_decrypt(struct crypto_async_request *areq, int err)
 	struct aead_request *req;
 
 	req = container_of(areq, struct aead_request, base);
-	cryptd_aead_crypt(req, child, err, crypto_aead_crt(child)->decrypt);
+	cryptd_aead_crypt(req, child, err, crypto_aead_alg(child)->decrypt);
 }
 
 static int cryptd_aead_enqueue(struct aead_request *req,
