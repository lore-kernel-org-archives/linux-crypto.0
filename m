From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH 3/3] augment CPRNG to correctly implement continuous
	test for FIPS, and support TEST_MODE flags
Date: Wed, 16 Sep 2009 12:25:59 -0400
Message-ID: <20090916162559.GF11163@hmsreliant.think-freely.org>
References: <20090916160456.GC11163@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jarod@redhat.com, herbert@gondor.apana.org.au, davem@davemloft.net
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57866 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759587AbZIPQ0F (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Sep 2009 12:26:05 -0400
Content-Disposition: inline
In-Reply-To: <20090916160456.GC11163@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

patch 3/3: modify cprng to make contnuity check fips compliant and allow for a
disabling of the continuity test when the RNG is placed in FIPS mode

Signed-off-by: Neil Horman <nhorman@txudriver.com>


 ansi_cprng.c |   56 +++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 51 insertions(+), 5 deletions(-)

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index 3aa6e38..c1ba5e8 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -33,6 +33,7 @@
 
 #define PRNG_FIXED_SIZE 0x1
 #define PRNG_NEED_RESET 0x2
+#define PRNG_DISABLE_CONT_TEST 0x3
 
 /*
  * Note: DT is our counter value
@@ -85,7 +86,7 @@ static void xor_vectors(unsigned char *in1, unsigned char *in2,
  * Returns DEFAULT_BLK_SZ bytes of random data per call
  * returns 0 if generation succeded, <0 if something went wrong
  */
-static int _get_more_prng_bytes(struct prng_context *ctx)
+static int _get_more_prng_bytes(struct prng_context *ctx, int test)
 {
 	int i;
 	unsigned char tmp[DEFAULT_BLK_SZ];
@@ -130,6 +131,9 @@ static int _get_more_prng_bytes(struct prng_context *ctx)
 			 * First check that we didn't produce the same
 			 * random data that we did last time around through this
 			 */
+			if (ctx->flags & PRNG_DISABLE_CONT_TEST)
+				goto skip_test;
+
 			if (!memcmp(ctx->rand_data, ctx->last_rand_data,
 					DEFAULT_BLK_SZ)) {
 				if (fips_enabled) {
@@ -146,7 +150,7 @@ static int _get_more_prng_bytes(struct prng_context *ctx)
 			}
 			memcpy(ctx->last_rand_data, ctx->rand_data,
 				DEFAULT_BLK_SZ);
-
+skip_test:
 			/*
 			 * Lastly xor the random data with I
 			 * and encrypt that to obtain a new secret vector V
@@ -220,7 +224,7 @@ static int get_prng_bytes(char *buf, size_t nbytes, struct prng_context *ctx)
 
 remainder:
 	if (ctx->rand_data_valid == DEFAULT_BLK_SZ) {
-		if (_get_more_prng_bytes(ctx) < 0) {
+		if (_get_more_prng_bytes(ctx, 1) < 0) {
 			memset(buf, 0, nbytes);
 			err = -EINVAL;
 			goto done;
@@ -247,7 +251,7 @@ empty_rbuf:
 	 */
 	for (; byte_count >= DEFAULT_BLK_SZ; byte_count -= DEFAULT_BLK_SZ) {
 		if (ctx->rand_data_valid == DEFAULT_BLK_SZ) {
-			if (_get_more_prng_bytes(ctx) < 0) {
+			if (_get_more_prng_bytes(ctx, 1) < 0) {
 				memset(buf, 0, nbytes);
 				err = -EINVAL;
 				goto done;
@@ -306,7 +310,6 @@ static int reset_prng_context(struct prng_context *ctx,
 	memset(ctx->rand_data, 0, DEFAULT_BLK_SZ);
 	memset(ctx->last_rand_data, 0, DEFAULT_BLK_SZ);
 
-	ctx->rand_data_valid = DEFAULT_BLK_SZ;
 
 	ret = crypto_cipher_setkey(ctx->tfm, prng_key, klen);
 	if (ret) {
@@ -317,6 +320,18 @@ static int reset_prng_context(struct prng_context *ctx,
 
 	ret = 0;
 	ctx->flags &= ~PRNG_NEED_RESET;
+
+	/*
+	 * If we don't disable the continuity test
+	 * we need to seed the n=0 iteration for test
+	 * comparison, so we get a first block here that
+	 * we never return to the user
+	 */
+	ctx->rand_data_valid = DEFAULT_BLK_SZ;
+	if (!(ctx->flags & PRNG_DISABLE_CONT_TEST))
+		_get_more_prng_bytes(ctx, 0);
+	
+	ctx->rand_data_valid = DEFAULT_BLK_SZ;
 out:
 	spin_unlock_bh(&ctx->prng_lock);
 	return ret;
@@ -384,6 +399,35 @@ static int cprng_reset(struct crypto_rng *tfm, u8 *seed, unsigned int slen)
 	return 0;
 }
 
+  /*
+   *  These are the registered functions which export behavioral flags
+   *  to the crypto api.  Most rng's don't have flags, but some might, like
+   *  the cprng which implements a 'test mode' for validation of vecotors
+   *  which disables the internal continuity tests
+   */
+static int cprng_set_flags(struct crypto_rng *tfm, u8 flags)
+{
+	struct prng_context *prng = crypto_rng_ctx(tfm);
+  
+	if (flags & CRYPTO_RNG_TEST_MODE)
+		prng->flags |= PRNG_DISABLE_CONT_TEST;
+  
+	return 0;
+}
+  
+  static int cprng_get_flags(struct crypto_rng *tfm, u8 *flags)
+{
+	struct prng_context *prng = crypto_rng_ctx(tfm);
+  
+	*flags = 0;
+  
+	if (prng->flags & PRNG_DISABLE_CONT_TEST)
+		*flags |= CRYPTO_RNG_TEST_MODE;
+  
+	return 0;
+}
+  
+
 static struct crypto_alg rng_alg = {
 	.cra_name		= "stdrng",
 	.cra_driver_name	= "ansi_cprng",
@@ -399,6 +443,8 @@ static struct crypto_alg rng_alg = {
 		.rng = {
 			.rng_make_random	= cprng_get_random,
 			.rng_reset		= cprng_reset,
+			.rng_set_flags		= cprng_set_flags,
+			.rng_get_flags		= cprng_get_flags,
 			.seedsize = DEFAULT_PRNG_KSZ + 2*DEFAULT_BLK_SZ,
 		}
 	}
