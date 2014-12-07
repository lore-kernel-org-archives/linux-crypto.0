From: George Spelvin <linux@horizon.com>
Subject: [PATCH v2 05/25] crypto: ansi_cprng - Eliminate ctx->I and ctx->last_rand_data
Date: Sun,  7 Dec 2014 07:26:13 -0500
Message-ID: <d9f54bc1e51a49edd568a31ffa557dc0569d1028.1417951990.git.linux@horizon.com>
References: <cover.1417951990.git.linux@horizon.com>
Cc: smueller@chronox.de, herbert@gondor.apana.org.au, linux@horizon.com
To: nhorman@tuxdriver.com, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:43354 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753147AbaLGM1A (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2014 07:27:00 -0500
In-Reply-To: <cover.1417951990.git.linux@horizon.com>
In-Reply-To: <cover.1417951990.git.linux@horizon.com>
References: <cover.1417951990.git.linux@horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Careful use of the other available buffers avoids the need for
these, shrinking the context by 32 bytes.

Neither the debug output nor the FIPS-required anti-repetition check
are changed in the slightest.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 crypto/ansi_cprng.c | 50 ++++++++++++++++++++++++--------------------------
 1 file changed, 24 insertions(+), 26 deletions(-)

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index 325aa727d..2edac42e 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -37,19 +37,14 @@
 
 /*
  * Note: DT is our counter value
- *	 I is our intermediate value
  *	 V is our seed vector
  * See http://csrc.nist.gov/groups/STM/cavp/documents/rng/931rngext.pdf
  * for implementation details
  */
-
-
 struct prng_context {
 	spinlock_t prng_lock;
 	unsigned char rand_data[DEFAULT_BLK_SZ];
-	unsigned char last_rand_data[DEFAULT_BLK_SZ];
 	unsigned char DT[DEFAULT_BLK_SZ];
-	unsigned char I[DEFAULT_BLK_SZ];
 	unsigned char V[DEFAULT_BLK_SZ];
 	u32 rand_data_valid;
 	struct crypto_cipher *tfm;
@@ -97,27 +92,27 @@ static int _get_more_prng_bytes(struct prng_context *ctx, int cont_test)
 
 	/*
 	 * Start by encrypting the counter value
-	 * This gives us an intermediate value I
+	 * This gives us an intermediate value I (stored in tmp)
 	 */
-	memcpy(tmp, ctx->DT, DEFAULT_BLK_SZ);
-	crypto_cipher_encrypt_one(ctx->tfm, ctx->I, tmp);
-	hexdump("I", ctx->I);
+	crypto_cipher_encrypt_one(ctx->tfm, tmp, ctx->DT);
+	hexdump("I", tmp);
 
 	/*
-	 * Next xor I with our secret vector V
-	 * encrypt that result to obtain our
-	 * pseudo random data which we output
+	 * Next xor I with our secret vector V.  Encrypt that result
+	 * to obtain our pseudo random data which we output.  But
+	 * keep that output in ctx->V for the moment; we need the
+	 * previous rand_data for ons more thing.
 	 */
-	xor_vectors(ctx->I, ctx->V, tmp, DEFAULT_BLK_SZ);
-	hexdump("V^I", tmp);
-	crypto_cipher_encrypt_one(ctx->tfm, ctx->rand_data, tmp);
-	hexdump("R", ctx->rand_data);
+	xor_vectors(tmp, ctx->V, ctx->V, DEFAULT_BLK_SZ);
+	hexdump("V^I", ctx->V);
+	crypto_cipher_encrypt_one(ctx->tfm, ctx->V, ctx->V);
+	hexdump("R", ctx->V);
 
 	/*
-	 * First check that we didn't produce the same
-	 * random data that we did last time around through this
+	 * Check that we didn't produce the same random data that we
+	 * did last time around.
 	 */
-	if (!memcmp(ctx->rand_data, ctx->last_rand_data, DEFAULT_BLK_SZ)) {
+	if (!memcmp(ctx->V, ctx->rand_data, DEFAULT_BLK_SZ)) {
 		if (cont_test) {
 			panic("cprng %p Failed repetition check!\n", ctx);
 		}
@@ -127,15 +122,19 @@ static int _get_more_prng_bytes(struct prng_context *ctx, int cont_test)
 		ctx->flags |= PRNG_NEED_RESET;
 		return -EINVAL;
 	}
-	memcpy(ctx->last_rand_data, ctx->rand_data, DEFAULT_BLK_SZ);
+	/*
+	 * Okay, the new data is okay, copy it to the buffer.
+	 */
+	memcpy(ctx->rand_data, ctx->V, DEFAULT_BLK_SZ);
 
 	/*
-	 * Lastly xor the random data with I
-	 * and encrypt that to obtain a new secret vector V
+	 * Lastly xor the random data with I and encrypt that to obtain
+	 * a new secret vector V.
 	 */
-	xor_vectors(ctx->rand_data, ctx->I, tmp, DEFAULT_BLK_SZ);
-	hexdump("R^I", tmp);
-	crypto_cipher_encrypt_one(ctx->tfm, ctx->V, tmp);
+	xor_vectors(tmp, ctx->V, ctx->V, DEFAULT_BLK_SZ);
+	hexdump("R^I", ctx->V);
+	memzero_explicit(tmp, DEFAULT_BLK_SZ);
+	crypto_cipher_encrypt_one(ctx->tfm, ctx->V, ctx->V);
 	hexdump("V'", ctx->V);
 
 	/*
@@ -272,7 +271,6 @@ static int reset_prng_context(struct prng_context *ctx,
 		memset(ctx->DT, 0, DEFAULT_BLK_SZ);
 
 	memset(ctx->rand_data, 0, DEFAULT_BLK_SZ);
-	memset(ctx->last_rand_data, 0, DEFAULT_BLK_SZ);
 
 	ctx->rand_data_valid = DEFAULT_BLK_SZ;
 
-- 
2.1.3
