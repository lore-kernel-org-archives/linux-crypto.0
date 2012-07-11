From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 05/14] crypto: ansi_cprng - use crypto_[un]register_algs
Date: Wed, 11 Jul 2012 14:20:15 +0300
Message-ID: <20120711112015.6875.75821.stgit@localhost6.localdomain6>
References: <20120711111949.6875.60269.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Neil Horman <nhorman@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:34029 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab2GKLUT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Jul 2012 07:20:19 -0400
In-Reply-To: <20120711111949.6875.60269.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Combine all crypto_alg to be registered and use new crypto_[un]register_algs
functions. This simplifies init/exit code.

Cc: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/ansi_cprng.c |   63 +++++++++++++++++++--------------------------------
 1 file changed, 23 insertions(+), 40 deletions(-)

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index 6ddd99e..c0bb377 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -382,26 +382,6 @@ static int cprng_reset(struct crypto_rng *tfm, u8 *seed, unsigned int slen)
 	return 0;
 }
 
-static struct crypto_alg rng_alg = {
-	.cra_name		= "stdrng",
-	.cra_driver_name	= "ansi_cprng",
-	.cra_priority		= 100,
-	.cra_flags		= CRYPTO_ALG_TYPE_RNG,
-	.cra_ctxsize		= sizeof(struct prng_context),
-	.cra_type		= &crypto_rng_type,
-	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(rng_alg.cra_list),
-	.cra_init		= cprng_init,
-	.cra_exit		= cprng_exit,
-	.cra_u			= {
-		.rng = {
-			.rng_make_random	= cprng_get_random,
-			.rng_reset		= cprng_reset,
-			.seedsize = DEFAULT_PRNG_KSZ + 2*DEFAULT_BLK_SZ,
-		}
-	}
-};
-
 #ifdef CONFIG_CRYPTO_FIPS
 static int fips_cprng_get_random(struct crypto_rng *tfm, u8 *rdata,
 			    unsigned int dlen)
@@ -438,8 +418,27 @@ static int fips_cprng_reset(struct crypto_rng *tfm, u8 *seed, unsigned int slen)
 out:
 	return rc;
 }
+#endif
 
-static struct crypto_alg fips_rng_alg = {
+static struct crypto_alg rng_algs[] = { {
+	.cra_name		= "stdrng",
+	.cra_driver_name	= "ansi_cprng",
+	.cra_priority		= 100,
+	.cra_flags		= CRYPTO_ALG_TYPE_RNG,
+	.cra_ctxsize		= sizeof(struct prng_context),
+	.cra_type		= &crypto_rng_type,
+	.cra_module		= THIS_MODULE,
+	.cra_init		= cprng_init,
+	.cra_exit		= cprng_exit,
+	.cra_u			= {
+		.rng = {
+			.rng_make_random	= cprng_get_random,
+			.rng_reset		= cprng_reset,
+			.seedsize = DEFAULT_PRNG_KSZ + 2*DEFAULT_BLK_SZ,
+		}
+	}
+#ifdef CONFIG_CRYPTO_FIPS
+}, {
 	.cra_name		= "fips(ansi_cprng)",
 	.cra_driver_name	= "fips_ansi_cprng",
 	.cra_priority		= 300,
@@ -447,7 +446,6 @@ static struct crypto_alg fips_rng_alg = {
 	.cra_ctxsize		= sizeof(struct prng_context),
 	.cra_type		= &crypto_rng_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(rng_alg.cra_list),
 	.cra_init		= cprng_init,
 	.cra_exit		= cprng_exit,
 	.cra_u			= {
@@ -457,33 +455,18 @@ static struct crypto_alg fips_rng_alg = {
 			.seedsize = DEFAULT_PRNG_KSZ + 2*DEFAULT_BLK_SZ,
 		}
 	}
-};
 #endif
+} };
 
 /* Module initalization */
 static int __init prng_mod_init(void)
 {
-	int rc = 0;
-
-	rc = crypto_register_alg(&rng_alg);
-#ifdef CONFIG_CRYPTO_FIPS
-	if (rc)
-		goto out;
-
-	rc = crypto_register_alg(&fips_rng_alg);
-
-out:
-#endif
-	return rc;
+	return crypto_register_algs(rng_algs, ARRAY_SIZE(rng_algs));
 }
 
 static void __exit prng_mod_fini(void)
 {
-	crypto_unregister_alg(&rng_alg);
-#ifdef CONFIG_CRYPTO_FIPS
-	crypto_unregister_alg(&fips_rng_alg);
-#endif
-	return;
+	crypto_unregister_algs(rng_algs, ARRAY_SIZE(rng_algs));
 }
 
 MODULE_LICENSE("GPL");
