From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 7/11] crypto: ansi_cprng - Convert to new rng interface
Date: Tue, 21 Apr 2015 10:46:44 +0800
Message-ID: <E1YkOCy-0007LC-9B@gondolin.me.apana.org.au>
References: <20150421024436.GA28057@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:42375 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbbDUCqr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Apr 2015 22:46:47 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch ocnverts the ANSI CPRNG implementation to the new
low-level rng interface.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/ansi_cprng.c |   86 ++++++++++++++++++++++++----------------------------
 1 file changed, 41 insertions(+), 45 deletions(-)

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index e4945ec..eff337c 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -279,11 +279,11 @@ static void free_prng_context(struct prng_context *ctx)
 }
 
 static int reset_prng_context(struct prng_context *ctx,
-			      unsigned char *key, size_t klen,
-			      unsigned char *V, unsigned char *DT)
+			      const unsigned char *key, size_t klen,
+			      const unsigned char *V, const unsigned char *DT)
 {
 	int ret;
-	unsigned char *prng_key;
+	const unsigned char *prng_key;
 
 	spin_lock_bh(&ctx->prng_lock);
 	ctx->flags |= PRNG_NEED_RESET;
@@ -351,8 +351,9 @@ static void cprng_exit(struct crypto_tfm *tfm)
 	free_prng_context(crypto_tfm_ctx(tfm));
 }
 
-static int cprng_get_random(struct crypto_rng *tfm, u8 *rdata,
-			    unsigned int dlen)
+static int cprng_get_random(struct crypto_rng *tfm,
+			    const u8 *src, unsigned int slen,
+			    u8 *rdata, unsigned int dlen)
 {
 	struct prng_context *prng = crypto_rng_ctx(tfm);
 
@@ -365,11 +366,12 @@ static int cprng_get_random(struct crypto_rng *tfm, u8 *rdata,
  *  V and KEY are required during reset, and DT is optional, detected
  *  as being present by testing the length of the seed
  */
-static int cprng_reset(struct crypto_rng *tfm, u8 *seed, unsigned int slen)
+static int cprng_reset(struct crypto_rng *tfm,
+		       const u8 *seed, unsigned int slen)
 {
 	struct prng_context *prng = crypto_rng_ctx(tfm);
-	u8 *key = seed + DEFAULT_BLK_SZ;
-	u8 *dt = NULL;
+	const u8 *key = seed + DEFAULT_BLK_SZ;
+	const u8 *dt = NULL;
 
 	if (slen < DEFAULT_PRNG_KSZ + DEFAULT_BLK_SZ)
 		return -EINVAL;
@@ -385,18 +387,20 @@ static int cprng_reset(struct crypto_rng *tfm, u8 *seed, unsigned int slen)
 }
 
 #ifdef CONFIG_CRYPTO_FIPS
-static int fips_cprng_get_random(struct crypto_rng *tfm, u8 *rdata,
-			    unsigned int dlen)
+static int fips_cprng_get_random(struct crypto_rng *tfm,
+				 const u8 *src, unsigned int slen,
+				 u8 *rdata, unsigned int dlen)
 {
 	struct prng_context *prng = crypto_rng_ctx(tfm);
 
 	return get_prng_bytes(rdata, dlen, prng, 1);
 }
 
-static int fips_cprng_reset(struct crypto_rng *tfm, u8 *seed, unsigned int slen)
+static int fips_cprng_reset(struct crypto_rng *tfm,
+			    const u8 *seed, unsigned int slen)
 {
 	u8 rdata[DEFAULT_BLK_SZ];
-	u8 *key = seed + DEFAULT_BLK_SZ;
+	const u8 *key = seed + DEFAULT_BLK_SZ;
 	int rc;
 
 	struct prng_context *prng = crypto_rng_ctx(tfm);
@@ -422,40 +426,32 @@ out:
 }
 #endif
 
-static struct crypto_alg rng_algs[] = { {
-	.cra_name		= "stdrng",
-	.cra_driver_name	= "ansi_cprng",
-	.cra_priority		= 100,
-	.cra_flags		= CRYPTO_ALG_TYPE_RNG,
-	.cra_ctxsize		= sizeof(struct prng_context),
-	.cra_type		= &crypto_rng_type,
-	.cra_module		= THIS_MODULE,
-	.cra_init		= cprng_init,
-	.cra_exit		= cprng_exit,
-	.cra_u			= {
-		.rng = {
-			.rng_make_random	= cprng_get_random,
-			.rng_reset		= cprng_reset,
-			.seedsize = DEFAULT_PRNG_KSZ + 2*DEFAULT_BLK_SZ,
-		}
+static struct rng_alg rng_algs[] = { {
+	.generate		= cprng_get_random,
+	.seed			= cprng_reset,
+	.seedsize		= DEFAULT_PRNG_KSZ + 2 * DEFAULT_BLK_SZ,
+	.base			=	{
+		.cra_name		= "stdrng",
+		.cra_driver_name	= "ansi_cprng",
+		.cra_priority		= 100,
+		.cra_ctxsize		= sizeof(struct prng_context),
+		.cra_module		= THIS_MODULE,
+		.cra_init		= cprng_init,
+		.cra_exit		= cprng_exit,
 	}
 #ifdef CONFIG_CRYPTO_FIPS
 }, {
-	.cra_name		= "fips(ansi_cprng)",
-	.cra_driver_name	= "fips_ansi_cprng",
-	.cra_priority		= 300,
-	.cra_flags		= CRYPTO_ALG_TYPE_RNG,
-	.cra_ctxsize		= sizeof(struct prng_context),
-	.cra_type		= &crypto_rng_type,
-	.cra_module		= THIS_MODULE,
-	.cra_init		= cprng_init,
-	.cra_exit		= cprng_exit,
-	.cra_u			= {
-		.rng = {
-			.rng_make_random	= fips_cprng_get_random,
-			.rng_reset		= fips_cprng_reset,
-			.seedsize = DEFAULT_PRNG_KSZ + 2*DEFAULT_BLK_SZ,
-		}
+	.generate		= fips_cprng_get_random,
+	.seed			= fips_cprng_reset,
+	.seedsize		= DEFAULT_PRNG_KSZ + 2 * DEFAULT_BLK_SZ,
+	.base			=	{
+		.cra_name		= "fips(ansi_cprng)",
+		.cra_driver_name	= "fips_ansi_cprng",
+		.cra_priority		= 300,
+		.cra_ctxsize		= sizeof(struct prng_context),
+		.cra_module		= THIS_MODULE,
+		.cra_init		= cprng_init,
+		.cra_exit		= cprng_exit,
 	}
 #endif
 } };
@@ -463,12 +459,12 @@ static struct crypto_alg rng_algs[] = { {
 /* Module initalization */
 static int __init prng_mod_init(void)
 {
-	return crypto_register_algs(rng_algs, ARRAY_SIZE(rng_algs));
+	return crypto_register_rngs(rng_algs, ARRAY_SIZE(rng_algs));
 }
 
 static void __exit prng_mod_fini(void)
 {
-	crypto_unregister_algs(rng_algs, ARRAY_SIZE(rng_algs));
+	crypto_unregister_rngs(rng_algs, ARRAY_SIZE(rng_algs));
 }
 
 MODULE_LICENSE("GPL");
