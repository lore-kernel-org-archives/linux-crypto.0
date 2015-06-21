From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/8] crypto: skcipher - Allow givencrypt to be NULL
Date: Sun, 21 Jun 2015 19:11:41 +0800
Message-ID: <E1Z6dA5-0007pO-TO@gondolin.me.apana.org.au>
References: <20150621110702.GA29747@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:58585 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbbFULLp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 21 Jun 2015 07:11:45 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1Z6dA6-0000Eh-8y
	for <linux-crypto@vger.kernel.org>; Sun, 21 Jun 2015 21:11:42 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Currently for skcipher IV generators they must provide givencrypt
as that is the whole point.  We are currently replacing skcipher
IV generators with explicit IV generators.  In order to maintain
backwards compatibility, we need to allow the IV generators to
still function as a normal skcipher when the RNG Is not present
(e.g., in the initramfs during boot).  IOW everything but givencrypt
and givdecrypt will still work but those two will fail.

Therefore this patch assigns a default givencrypt that simply
returns an error should it be NULL.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/ablkcipher.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index b15d797..b788f16 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -454,7 +454,7 @@ static int crypto_init_givcipher_ops(struct crypto_tfm *tfm, u32 type,
 		      alg->setkey : setkey;
 	crt->encrypt = alg->encrypt;
 	crt->decrypt = alg->decrypt;
-	crt->givencrypt = alg->givencrypt;
+	crt->givencrypt = alg->givencrypt ?: no_givdecrypt;
 	crt->givdecrypt = alg->givdecrypt ?: no_givdecrypt;
 	crt->base = __crypto_ablkcipher_cast(tfm);
 	crt->ivsize = alg->ivsize;
