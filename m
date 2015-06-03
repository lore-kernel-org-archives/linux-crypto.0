From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 8/8] crypto: rng - Remove krng
Date: Wed, 03 Jun 2015 14:49:32 +0800
Message-ID: <E1Z02UW-0001Hy-Mo@gondolin.me.apana.org.au>
References: <20150603064641.GA4655@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51829 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142AbbFCGtg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Jun 2015 02:49:36 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch removes krng so that DRBG can take its place.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/Makefile |    1 
 crypto/krng.c   |   61 --------------------------------------------------------
 2 files changed, 62 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index 5db5b95..a0f49c3 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -92,7 +92,6 @@ obj-$(CONFIG_CRYPTO_LZ4) += lz4.o
 obj-$(CONFIG_CRYPTO_LZ4HC) += lz4hc.o
 obj-$(CONFIG_CRYPTO_842) += 842.o
 obj-$(CONFIG_CRYPTO_RNG2) += rng.o
-obj-$(CONFIG_CRYPTO_RNG2) += krng.o
 obj-$(CONFIG_CRYPTO_ANSI_CPRNG) += ansi_cprng.o
 obj-$(CONFIG_CRYPTO_DRBG) += drbg.o
 CFLAGS_jitterentropy.o = -O0
diff --git a/crypto/krng.c b/crypto/krng.c
deleted file mode 100644
index 40ed78e..0000000
--- a/crypto/krng.c
+++ /dev/null
@@ -1,61 +0,0 @@
-/*
- * RNG implementation using standard kernel RNG.
- *
- * Copyright (c) 2008 Herbert Xu <herbert@gondor.apana.org.au>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the
- * Free Software Foundation; either version 2 of the License, or (at your
- * any later version.
- *
- */
-
-#include <crypto/internal/rng.h>
-#include <linux/err.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/random.h>
-
-static int krng_generate(struct crypto_rng *tfm,
-			 const u8 *src, unsigned int slen,
-			 u8 *rdata, unsigned int dlen)
-{
-	get_random_bytes(rdata, dlen);
-	return 0;
-}
-
-static int krng_seed(struct crypto_rng *tfm, const u8 *seed, unsigned int slen)
-{
-	return 0;
-}
-
-static struct rng_alg krng_alg = {
-	.generate		= krng_generate,
-	.seed			= krng_seed,
-	.base			=	{
-		.cra_name		= "stdrng",
-		.cra_driver_name	= "krng",
-		.cra_priority		= 200,
-		.cra_module		= THIS_MODULE,
-	}
-};
-
-
-/* Module initalization */
-static int __init krng_mod_init(void)
-{
-	return crypto_register_rng(&krng_alg);
-}
-
-static void __exit krng_mod_fini(void)
-{
-	crypto_unregister_rng(&krng_alg);
-}
-
-module_init(krng_mod_init);
-module_exit(krng_mod_fini);
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Kernel Random Number Generator");
-MODULE_ALIAS_CRYPTO("stdrng");
-MODULE_ALIAS_CRYPTO("krng");
