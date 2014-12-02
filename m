From: "George Spelvin" <linux@horizon.com>
Subject: [PATCH 02/17] crypto: ansi_cprng - Eliminate ctx->last_rand_data
Date: 2 Dec 2014 03:35:50 -0500
Message-ID: <20141202083550.17918.qmail@ns.horizon.com>
References: <20141202083314.17647.qmail@ns.horizon.com>
Cc: linux-crypto@vger.kernel.org, linux@horizon.com,
	smueller@chronox.de
To: herbert@gondor.apana.org.au, nhorman@tuxdriver.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:29887 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750931AbaLBIfw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Dec 2014 03:35:52 -0500
In-Reply-To: <20141202083314.17647.qmail@ns.horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

It's simply not necessary.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 crypto/ansi_cprng.c | 28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index c9e1684b..c0a27288 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -46,7 +46,6 @@
 struct prng_context {
 	spinlock_t prng_lock;
 	unsigned char rand_data[DEFAULT_BLK_SZ];
-	unsigned char last_rand_data[DEFAULT_BLK_SZ];
 	unsigned char DT[DEFAULT_BLK_SZ];
 	unsigned char I[DEFAULT_BLK_SZ];
 	unsigned char V[DEFAULT_BLK_SZ];
@@ -89,8 +88,6 @@ static int _get_more_prng_bytes(struct prng_context *ctx, int cont_test)
 {
 	int i;
 	unsigned char tmp[DEFAULT_BLK_SZ];
-	unsigned char *output = NULL;
-
 
 	dbgprint(KERN_CRIT "Calling _get_more_prng_bytes for context %p\n",
 		ctx);
@@ -103,6 +100,7 @@ static int _get_more_prng_bytes(struct prng_context *ctx, int cont_test)
 	 * This algorithm is a 3 stage state machine
 	 */
 	for (i = 0; i < 3; i++) {
+		unsigned char *output;
 
 		switch (i) {
 		case 0:
@@ -115,23 +113,23 @@ static int _get_more_prng_bytes(struct prng_context *ctx, int cont_test)
 			hexdump("tmp stage 0: ", tmp, DEFAULT_BLK_SZ);
 			break;
 		case 1:
-
 			/*
-			 * Next xor I with our secret vector V
-			 * encrypt that result to obtain our
-			 * pseudo random data which we output
+			 * Next xor I with our secret vector V.
+			 * Encrypt that result to obtain our pseudo random
+			 * data which we output.  It is kept temporarily
+			 * in (no longer used) V until we have done the
+			 * anti-repetition compare.
 			 */
 			xor_vectors(ctx->I, ctx->V, tmp, DEFAULT_BLK_SZ);
 			hexdump("tmp stage 1: ", tmp, DEFAULT_BLK_SZ);
-			output = ctx->rand_data;
+			output = ctx->V;
 			break;
 		case 2:
 			/*
 			 * First check that we didn't produce the same
-			 * random data that we did last time around through this
+			 * random data that we did last time around.
 			 */
-			if (!memcmp(ctx->rand_data, ctx->last_rand_data,
-					DEFAULT_BLK_SZ)) {
+			if (!memcmp(ctx->V, ctx->rand_data, DEFAULT_BLK_SZ)) {
 				if (cont_test) {
 					panic("cprng %p Failed repetition check!\n",
 						ctx);
@@ -144,15 +142,13 @@ static int _get_more_prng_bytes(struct prng_context *ctx, int cont_test)
 				ctx->flags |= PRNG_NEED_RESET;
 				return -EINVAL;
 			}
-			memcpy(ctx->last_rand_data, ctx->rand_data,
-				DEFAULT_BLK_SZ);
+			memcpy(ctx->rand_data, ctx->V, DEFAULT_BLK_SZ);
 
 			/*
 			 * Lastly xor the random data with I
 			 * and encrypt that to obtain a new secret vector V
 			 */
-			xor_vectors(ctx->rand_data, ctx->I, tmp,
-				DEFAULT_BLK_SZ);
+			xor_vectors(ctx->I, ctx->V, tmp, DEFAULT_BLK_SZ);
 			output = ctx->V;
 			hexdump("tmp stage 2: ", tmp, DEFAULT_BLK_SZ);
 			break;
@@ -161,7 +157,6 @@ static int _get_more_prng_bytes(struct prng_context *ctx, int cont_test)
 
 		/* do the encryption */
 		crypto_cipher_encrypt_one(ctx->tfm, output, tmp);
-
 	}
 
 	/*
@@ -299,7 +294,6 @@ static int reset_prng_context(struct prng_context *ctx,
 		memset(ctx->DT, 0, DEFAULT_BLK_SZ);
 
 	memset(ctx->rand_data, 0, DEFAULT_BLK_SZ);
-	memset(ctx->last_rand_data, 0, DEFAULT_BLK_SZ);
 
 	ctx->rand_read_pos = DEFAULT_BLK_SZ;	/* Force immediate refill */
 
-- 
2.1.3
