From: "George Spelvin" <linux@horizon.com>
Subject: [PATCH 11/17] crypto: ansi_cprng - unroll _get_more_prng_bytes
Date: 2 Dec 2014 03:54:52 -0500
Message-ID: <20141202085452.19204.qmail@ns.horizon.com>
References: <20141202083314.17647.qmail@ns.horizon.com>
Cc: linux-crypto@vger.kernel.org, linux@horizon.com,
	smueller@chronox.de
To: herbert@gondor.apana.org.au, nhorman@tuxdriver.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:26171 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751072AbaLBIyy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Dec 2014 03:54:54 -0500
In-Reply-To: <20141202083314.17647.qmail@ns.horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

It's more legible, and the code is 15 bytes smaller (i386).

Signed-off-by: George Spelvin <linux@horizon.com>
---
 crypto/ansi_cprng.c | 87 ++++++++++++++++++++---------------------------------
 1 file changed, 32 insertions(+), 55 deletions(-)

I'm not really sure why this was implemented this convoluted way
in the first place.  Did crypto_cipher_encrypt_one() used to be
an enormous inline function?

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index de13e741..09bb1252 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -94,67 +94,44 @@ static int _get_more_prng_bytes(struct prng_context *ctx, bool cont_test)
 	hexdump("Input V: ", ctx->V, DEFAULT_BLK_SZ);
 
 	/*
-	 * This algorithm is a 3 stage state machine
+	 * Start by encrypting the counter value.
+	 * This gives us an intermediate value I.
 	 */
-	for (i = 0; i < 3; i++) {
-		unsigned char const *input;
-		unsigned char *output;
+	crypto_cipher_encrypt_one(ctx->tfm, tmp, ctx->DT);
+	hexdump("input I: ", tmp, DEFAULT_BLK_SZ);
 
-		switch (i) {
-		case 0:
-			/*
-			 * Start by encrypting the counter value
-			 * This gives us an intermediate value I
-			 */
-			input = ctx->DT;
-			output = tmp;
-			hexdump("input stage 0: ", input, DEFAULT_BLK_SZ);
-			break;
-		case 1:
-			/*
-			 * Next xor I with our secret vector V.
-			 * Encrypt that result to obtain our pseudo random
-			 * data which we output.  It is kept temporarily
-			 * in (no longer used) V until we have done the
-			 * anti-repetition compare.
-			 */
-			xor_block(tmp, ctx->V);
-			input = output = ctx->V;
-			hexdump("input stage 1: ", input, DEFAULT_BLK_SZ);
-			break;
-		case 2:
-			/*
-			 * First check that we didn't produce the same
-			 * random data that we did last time around.
-			 */
-			if (!memcmp(ctx->V, ctx->rand_data, DEFAULT_BLK_SZ)) {
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
-			memcpy(ctx->rand_data, ctx->V, DEFAULT_BLK_SZ);
+	/*
+	 * Next xor I with our secret vector V.
+	 * Encrypt that result to obtain our pseudo random data which
+	 * we output.  It is kept temporarily in (no longer used)
+	 * V until we have done the anti-repetition compare.
+	 */
+	xor_block(tmp, ctx->V);
+	hexdump("input stage 1: ", ctx->V, DEFAULT_BLK_SZ);
+	crypto_cipher_encrypt_one(ctx->tfm, ctx->V, ctx->V);
 
-			/*
-			 * Lastly xor the random data with I
-			 * and encrypt that to obtain a new secret vector V
-			 */
-			xor_block(tmp, ctx->V);
-			input = output = ctx->V;
-			hexdump("input stage 2: ", input, DEFAULT_BLK_SZ);
-			break;
+	/*
+	 * Check that we didn't produce the same random data
+	 * that we did last time around.
+	 */
+	if (!memcmp(ctx->V, ctx->rand_data, DEFAULT_BLK_SZ)) {
+		if (cont_test) {
+			panic("cprng %p Failed repetition check!\n", ctx);
 		}
 
-		/* do the encryption */
-		crypto_cipher_encrypt_one(ctx->tfm, output, input);
+		printk(KERN_ERR "ctx %p Failed repetition check!\n", ctx);
+		ctx->flags |= PRNG_NEED_RESET;
+		return -EINVAL;
 	}
+	memcpy(ctx->rand_data, ctx->V, DEFAULT_BLK_SZ);
+
+	/*
+	 * Lastly xor the random data with I and encrypt that to
+	 * obtain a new secret vector V
+	 */
+	xor_block(tmp, ctx->V);
+	hexdump("input stage 2: ", ctx->V, DEFAULT_BLK_SZ);
+	crypto_cipher_encrypt_one(ctx->tfm, ctx->V, ctx->V);
 
 	/*
 	 * Now update our DT value
-- 
2.1.3
