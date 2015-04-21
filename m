From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 8/11] crypto: krng - Convert to new rng interface
Date: Tue, 21 Apr 2015 10:46:45 +0800
Message-ID: <E1YkOCz-0007LT-Eg@gondolin.me.apana.org.au>
References: <20150421024436.GA28057@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43598 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbbDUCqs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Apr 2015 22:46:48 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch ocnverts the KRNG implementation to the new low-level
rng interface.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/krng.c |   33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)

diff --git a/crypto/krng.c b/crypto/krng.c
index 0224841..40ed78e 100644
--- a/crypto/krng.c
+++ b/crypto/krng.c
@@ -16,31 +16,27 @@
 #include <linux/module.h>
 #include <linux/random.h>
 
-static int krng_get_random(struct crypto_rng *tfm, u8 *rdata, unsigned int dlen)
+static int krng_generate(struct crypto_rng *tfm,
+			 const u8 *src, unsigned int slen,
+			 u8 *rdata, unsigned int dlen)
 {
 	get_random_bytes(rdata, dlen);
 	return 0;
 }
 
-static int krng_reset(struct crypto_rng *tfm, u8 *seed, unsigned int slen)
+static int krng_seed(struct crypto_rng *tfm, const u8 *seed, unsigned int slen)
 {
 	return 0;
 }
 
-static struct crypto_alg krng_alg = {
-	.cra_name		= "stdrng",
-	.cra_driver_name	= "krng",
-	.cra_priority		= 200,
-	.cra_flags		= CRYPTO_ALG_TYPE_RNG,
-	.cra_ctxsize		= 0,
-	.cra_type		= &crypto_rng_type,
-	.cra_module		= THIS_MODULE,
-	.cra_u			= {
-		.rng = {
-			.rng_make_random	= krng_get_random,
-			.rng_reset		= krng_reset,
-			.seedsize		= 0,
-		}
+static struct rng_alg krng_alg = {
+	.generate		= krng_generate,
+	.seed			= krng_seed,
+	.base			=	{
+		.cra_name		= "stdrng",
+		.cra_driver_name	= "krng",
+		.cra_priority		= 200,
+		.cra_module		= THIS_MODULE,
 	}
 };
 
@@ -48,13 +44,12 @@ static struct crypto_alg krng_alg = {
 /* Module initalization */
 static int __init krng_mod_init(void)
 {
-	return crypto_register_alg(&krng_alg);
+	return crypto_register_rng(&krng_alg);
 }
 
 static void __exit krng_mod_fini(void)
 {
-	crypto_unregister_alg(&krng_alg);
-	return;
+	crypto_unregister_rng(&krng_alg);
 }
 
 module_init(krng_mod_init);
