From: George Spelvin <linux@horizon.com>
Subject: [PATCH v2 01/25] crypto: ansi_cprng - unroll _get_more_prng_bytes
Date: Sun,  7 Dec 2014 07:26:09 -0500
Message-ID: <8986449e4ee611ddbf1310cde3ba8d25caa125c0.1417951990.git.linux@horizon.com>
References: <cover.1417951990.git.linux@horizon.com>
Cc: smueller@chronox.de, herbert@gondor.apana.org.au, linux@horizon.com
To: nhorman@tuxdriver.com, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:19533 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753075AbaLGM0w (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2014 07:26:52 -0500
In-Reply-To: <cover.1417951990.git.linux@horizon.com>
In-Reply-To: <cover.1417951990.git.linux@horizon.com>
References: <cover.1417951990.git.linux@horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

It's more legible, and the code is 16 bytes smaller (i386).

Signed-off-by: George Spelvin <linux@horizon.com>
---
 crypto/ansi_cprng.c | 91 +++++++++++++++++++++--------------------------------
 1 file changed, 35 insertions(+), 56 deletions(-)

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index b63b5094..ce315bf7 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -100,69 +100,48 @@ static int _get_more_prng_bytes(struct prng_context *ctx, int cont_test)
 	hexdump("Input V: ", ctx->V, DEFAULT_BLK_SZ);
 
 	/*
-	 * This algorithm is a 3 stage state machine
+	 * Start by encrypting the counter value
+	 * This gives us an intermediate value I
 	 */
-	for (i = 0; i < 3; i++) {
+	memcpy(tmp, ctx->DT, DEFAULT_BLK_SZ);
+	output = ctx->I;
+	hexdump("tmp stage 0: ", tmp, DEFAULT_BLK_SZ);
+	crypto_cipher_encrypt_one(ctx->tfm, output, tmp);
 
-		switch (i) {
-		case 0:
-			/*
-			 * Start by encrypting the counter value
-			 * This gives us an intermediate value I
-			 */
-			memcpy(tmp, ctx->DT, DEFAULT_BLK_SZ);
-			output = ctx->I;
-			hexdump("tmp stage 0: ", tmp, DEFAULT_BLK_SZ);
-			break;
-		case 1:
-
-			/*
-			 * Next xor I with our secret vector V
-			 * encrypt that result to obtain our
-			 * pseudo random data which we output
-			 */
-			xor_vectors(ctx->I, ctx->V, tmp, DEFAULT_BLK_SZ);
-			hexdump("tmp stage 1: ", tmp, DEFAULT_BLK_SZ);
-			output = ctx->rand_data;
-			break;
-		case 2:
-			/*
-			 * First check that we didn't produce the same
-			 * random data that we did last time around through this
-			 */
-			if (!memcmp(ctx->rand_data, ctx->last_rand_data,
-					DEFAULT_BLK_SZ)) {
-				if (cont_test) {
-					panic("cprng %p Failed repetition check!\n",
-						ctx);
-				}
-
-				printk(KERN_ERR
-					"ctx %p Failed repetition check!\n",
-					ctx);
-
-				ctx->flags |= PRNG_NEED_RESET;
-				return -EINVAL;
-			}
-			memcpy(ctx->last_rand_data, ctx->rand_data,
-				DEFAULT_BLK_SZ);
+	/*
+	 * Next xor I with our secret vector V
+	 * encrypt that result to obtain our
+	 * pseudo random data which we output
+	 */
+	xor_vectors(ctx->I, ctx->V, tmp, DEFAULT_BLK_SZ);
+	hexdump("tmp stage 1: ", tmp, DEFAULT_BLK_SZ);
+	output = ctx->rand_data;
+	crypto_cipher_encrypt_one(ctx->tfm, output, tmp);
 
-			/*
-			 * Lastly xor the random data with I
-			 * and encrypt that to obtain a new secret vector V
-			 */
-			xor_vectors(ctx->rand_data, ctx->I, tmp,
-				DEFAULT_BLK_SZ);
-			output = ctx->V;
-			hexdump("tmp stage 2: ", tmp, DEFAULT_BLK_SZ);
-			break;
+	/*
+	 * First check that we didn't produce the same
+	 * random data that we did last time around through this
+	 */
+	if (!memcmp(ctx->rand_data, ctx->last_rand_data, DEFAULT_BLK_SZ)) {
+		if (cont_test) {
+			panic("cprng %p Failed repetition check!\n", ctx);
 		}
 
+		printk(KERN_ERR "ctx %p Failed repetition check!\n", ctx);
 
-		/* do the encryption */
-		crypto_cipher_encrypt_one(ctx->tfm, output, tmp);
-
+		ctx->flags |= PRNG_NEED_RESET;
+		return -EINVAL;
 	}
+	memcpy(ctx->last_rand_data, ctx->rand_data, DEFAULT_BLK_SZ);
+
+	/*
+	 * Lastly xor the random data with I
+	 * and encrypt that to obtain a new secret vector V
+	 */
+	xor_vectors(ctx->rand_data, ctx->I, tmp, DEFAULT_BLK_SZ);
+	output = ctx->V;
+	hexdump("tmp stage 2: ", tmp, DEFAULT_BLK_SZ);
+	crypto_cipher_encrypt_one(ctx->tfm, output, tmp);
 
 	/*
 	 * Now update our DT value
-- 
2.1.3
