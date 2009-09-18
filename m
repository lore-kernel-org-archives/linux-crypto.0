From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH 1/1] add fips(ansi_cprng) (v2)
Date: Fri, 18 Sep 2009 14:34:46 -0400
Message-ID: <20090918183446.GB28540@hmsreliant.think-freely.org>
References: <20090916160456.GC11163@hmsreliant.think-freely.org> <20090918183254.GA28540@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jarod@redhat.com, herbert@gondor.apana.org.au, davem@davemloft.net
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51536 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757772AbZIRSes (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Sep 2009 14:34:48 -0400
Content-Disposition: inline
In-Reply-To: <20090918183254.GA28540@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Patch to add fips(ansi_cprng) alg, which is ansi_cprng plus a continuous test

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>

 ansi_cprng.c |   79 ++++++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 70 insertions(+), 9 deletions(-)

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index 3aa6e38..027176a 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -85,7 +85,7 @@ static void xor_vectors(unsigned char *in1, unsigned char *in2,
  * Returns DEFAULT_BLK_SZ bytes of random data per call
  * returns 0 if generation succeded, <0 if something went wrong
  */
-static int _get_more_prng_bytes(struct prng_context *ctx)
+static int _get_more_prng_bytes(struct prng_context *ctx, int cont_test)
 {
 	int i;
 	unsigned char tmp[DEFAULT_BLK_SZ];
@@ -132,7 +132,7 @@ static int _get_more_prng_bytes(struct prng_context *ctx)
 			 */
 			if (!memcmp(ctx->rand_data, ctx->last_rand_data,
 					DEFAULT_BLK_SZ)) {
-				if (fips_enabled) {
+				if (cont_test) {
 					panic("cprng %p Failed repetition check!\n",
 						ctx);
 				}
@@ -185,7 +185,8 @@ static int _get_more_prng_bytes(struct prng_context *ctx)
 }
 
 /* Our exported functions */
-static int get_prng_bytes(char *buf, size_t nbytes, struct prng_context *ctx)
+static int get_prng_bytes(char *buf, size_t nbytes, struct prng_context *ctx,
+				int do_cont_test)
 {
 	unsigned char *ptr = buf;
 	unsigned int byte_count = (unsigned int)nbytes;
@@ -220,7 +221,7 @@ static int get_prng_bytes(char *buf, size_t nbytes, struct prng_context *ctx)
 
 remainder:
 	if (ctx->rand_data_valid == DEFAULT_BLK_SZ) {
-		if (_get_more_prng_bytes(ctx) < 0) {
+		if (_get_more_prng_bytes(ctx, do_cont_test) < 0) {
 			memset(buf, 0, nbytes);
 			err = -EINVAL;
 			goto done;
@@ -247,7 +248,7 @@ empty_rbuf:
 	 */
 	for (; byte_count >= DEFAULT_BLK_SZ; byte_count -= DEFAULT_BLK_SZ) {
 		if (ctx->rand_data_valid == DEFAULT_BLK_SZ) {
-			if (_get_more_prng_bytes(ctx) < 0) {
+			if (_get_more_prng_bytes(ctx, do_cont_test) < 0) {
 				memset(buf, 0, nbytes);
 				err = -EINVAL;
 				goto done;
@@ -356,7 +357,15 @@ static int cprng_get_random(struct crypto_rng *tfm, u8 *rdata,
 {
 	struct prng_context *prng = crypto_rng_ctx(tfm);
 
-	return get_prng_bytes(rdata, dlen, prng);
+	return get_prng_bytes(rdata, dlen, prng, 0);
+}
+
+static int fips_cprng_get_random(struct crypto_rng *tfm, u8 *rdata,
+			    unsigned int dlen)
+{
+	struct prng_context *prng = crypto_rng_ctx(tfm);
+
+	return get_prng_bytes(rdata, dlen, prng, 1);
 }
 
 /*
@@ -384,6 +393,26 @@ static int cprng_reset(struct crypto_rng *tfm, u8 *seed, unsigned int slen)
 	return 0;
 }
 
+static int fips_cprng_reset(struct crypto_rng *tfm, u8 *seed, unsigned int slen)
+{
+	u8 rdata[DEFAULT_BLK_SZ];
+	int rc;
+
+	struct prng_context *prng = crypto_rng_ctx(tfm);
+
+	rc = cprng_reset(tfm, seed, slen);
+
+	if (!rc)
+		goto out;
+
+	/* this primes our continuity test */
+	rc = get_prng_bytes(rdata, DEFAULT_BLK_SZ, prng, 0);
+	prng->rand_data_valid = DEFAULT_BLK_SZ;
+
+out:
+	return rc;
+}
+
 static struct crypto_alg rng_alg = {
 	.cra_name		= "stdrng",
 	.cra_driver_name	= "ansi_cprng",
@@ -404,19 +433,51 @@ static struct crypto_alg rng_alg = {
 	}
 };
 
+#ifdef CONFIG_CRYPTO_FIPS
+static struct crypto_alg fips_rng_alg = {
+	.cra_name		= "fips(ansi_cprng)",
+	.cra_driver_name	= "fips_ansi_cprng",
+	.cra_priority		= 300,
+	.cra_flags		= CRYPTO_ALG_TYPE_RNG,
+	.cra_ctxsize		= sizeof(struct prng_context),
+	.cra_type		= &crypto_rng_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(rng_alg.cra_list),
+	.cra_init		= cprng_init,
+	.cra_exit		= cprng_exit,
+	.cra_u			= {
+		.rng = {
+			.rng_make_random	= fips_cprng_get_random,
+			.rng_reset		= fips_cprng_reset,
+			.seedsize = DEFAULT_PRNG_KSZ + 2*DEFAULT_BLK_SZ,
+		}
+	}
+};
+#endif
 
 /* Module initalization */
 static int __init prng_mod_init(void)
 {
-	if (fips_enabled)
-		rng_alg.cra_priority += 200;
+	int rc = 0;
 
-	return crypto_register_alg(&rng_alg);
+	rc = crypto_register_alg(&rng_alg);
+#ifdef CONFIG_CRYPTO_FIPS
+	if (rc)
+		goto out;
+
+	rc = crypto_register_alg(&fips_rng_alg);
+
+out:
+#endif
+	return rc;
 }
 
 static void __exit prng_mod_fini(void)
 {
 	crypto_unregister_alg(&rng_alg);
+#ifdef CONFIG_CRYPTO_FIPS
+	crypto_unregister_alg(&fips_rng_alg);
+#endif
 	return;
 }
 
