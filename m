From: "George Spelvin" <linux@horizon.com>
Subject: [PATCH 03/17] crypto: ansi_cprng - Eliminate ctx->I
Date: 2 Dec 2014 03:37:07 -0500
Message-ID: <20141202083707.17996.qmail@ns.horizon.com>
References: <20141202083314.17647.qmail@ns.horizon.com>
Cc: linux-crypto@vger.kernel.org, linux@horizon.com,
	smueller@chronox.de
To: herbert@gondor.apana.org.au, nhorman@tuxdriver.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:42555 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751285AbaLBIhI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Dec 2014 03:37:08 -0500
In-Reply-To: <20141202083314.17647.qmail@ns.horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

It's also not necessary.  We do have to change some debugging
output.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 crypto/ansi_cprng.c | 39 ++++++++++++++++++++-------------------
 1 file changed, 20 insertions(+), 19 deletions(-)

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index c0a27288..6b844f13 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -35,19 +35,22 @@
 #define PRNG_NEED_RESET 0x2
 
 /*
- * Note: DT is our counter value
- *	 I is our intermediate value
- *	 V is our seed vector
+ * Note: In addition to the fixed encryption key, there are three
+ *	 block-sized state buffers:
+ * 1. rand_data is the current output data (R in the spec).
+ * 2. V is our main state vector
+ * 3. DT is the current "data/time" used for seeding.  The fact that
+ *    this is a deterministic counter rather than an actual timestamp
+ *    (with some small amount of seed entropy) means that this code is
+ *    NOT an implmentation of X9.31.
+ *
  * See http://csrc.nist.gov/groups/STM/cavp/documents/rng/931rngext.pdf
  * for implementation details
  */
-
-
 struct prng_context {
 	spinlock_t prng_lock;
 	unsigned char rand_data[DEFAULT_BLK_SZ];
 	unsigned char DT[DEFAULT_BLK_SZ];
-	unsigned char I[DEFAULT_BLK_SZ];
 	unsigned char V[DEFAULT_BLK_SZ];
 	u32 rand_read_pos;	/* Offset into rand_data[] */
 	struct crypto_cipher *tfm;
@@ -93,13 +96,13 @@ static int _get_more_prng_bytes(struct prng_context *ctx, int cont_test)
 		ctx);
 
 	hexdump("Input DT: ", ctx->DT, DEFAULT_BLK_SZ);
-	hexdump("Input I: ", ctx->I, DEFAULT_BLK_SZ);
 	hexdump("Input V: ", ctx->V, DEFAULT_BLK_SZ);
 
 	/*
 	 * This algorithm is a 3 stage state machine
 	 */
 	for (i = 0; i < 3; i++) {
+		unsigned char const *input;
 		unsigned char *output;
 
 		switch (i) {
@@ -108,9 +111,9 @@ static int _get_more_prng_bytes(struct prng_context *ctx, int cont_test)
 			 * Start by encrypting the counter value
 			 * This gives us an intermediate value I
 			 */
-			memcpy(tmp, ctx->DT, DEFAULT_BLK_SZ);
-			output = ctx->I;
-			hexdump("tmp stage 0: ", tmp, DEFAULT_BLK_SZ);
+			input = ctx->DT;
+			output = tmp;
+			hexdump("input stage 0: ", ctx->DT, DEFAULT_BLK_SZ);
 			break;
 		case 1:
 			/*
@@ -120,9 +123,9 @@ static int _get_more_prng_bytes(struct prng_context *ctx, int cont_test)
 			 * in (no longer used) V until we have done the
 			 * anti-repetition compare.
 			 */
-			xor_vectors(ctx->I, ctx->V, tmp, DEFAULT_BLK_SZ);
-			hexdump("tmp stage 1: ", tmp, DEFAULT_BLK_SZ);
-			output = ctx->V;
+			xor_vectors(tmp, ctx->V, ctx->V, DEFAULT_BLK_SZ);
+			hexdump("input stage 1: ", ctx->V, DEFAULT_BLK_SZ);
+			input = output = ctx->V;
 			break;
 		case 2:
 			/*
@@ -148,15 +151,14 @@ static int _get_more_prng_bytes(struct prng_context *ctx, int cont_test)
 			 * Lastly xor the random data with I
 			 * and encrypt that to obtain a new secret vector V
 			 */
-			xor_vectors(ctx->I, ctx->V, tmp, DEFAULT_BLK_SZ);
-			output = ctx->V;
-			hexdump("tmp stage 2: ", tmp, DEFAULT_BLK_SZ);
+			xor_vectors(tmp, ctx->V, ctx->V, DEFAULT_BLK_SZ);
+			hexdump("input stage 2: ", ctx->V, DEFAULT_BLK_SZ);
+			input = output = ctx->V;
 			break;
 		}
 
-
 		/* do the encryption */
-		crypto_cipher_encrypt_one(ctx->tfm, output, tmp);
+		crypto_cipher_encrypt_one(ctx->tfm, output, input);
 	}
 
 	/*
@@ -172,7 +174,6 @@ static int _get_more_prng_bytes(struct prng_context *ctx, int cont_test)
 	ctx->rand_read_pos = 0;
 
 	hexdump("Output DT: ", ctx->DT, DEFAULT_BLK_SZ);
-	hexdump("Output I: ", ctx->I, DEFAULT_BLK_SZ);
 	hexdump("Output V: ", ctx->V, DEFAULT_BLK_SZ);
 	hexdump("New Random Data: ", ctx->rand_data, DEFAULT_BLK_SZ);
 
-- 
2.1.3
