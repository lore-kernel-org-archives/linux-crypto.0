From: "George Spelvin" <linux@horizon.com>
Subject: [PATCH 13/17] crypto: ansi_cprng - If DT is not provided, use a fresh timestamp
Date: 2 Dec 2014 03:57:03 -0500
Message-ID: <20141202085703.19443.qmail@ns.horizon.com>
References: <20141202083314.17647.qmail@ns.horizon.com>
Cc: linux-crypto@vger.kernel.org, linux@horizon.com,
	smueller@chronox.de
To: herbert@gondor.apana.org.au, nhorman@tuxdriver.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:35396 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751454AbaLBI5F (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Dec 2014 03:57:05 -0500
In-Reply-To: <20141202083314.17647.qmail@ns.horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Except for the switch from triple DES to AES-128, this results in an
actual implementation of the X9.31 Appendix A.2.4 generator, which is
the same as the X9.17 Appendix C one.

If a DT seed value is provided, it is the same fully deterministic
algorithm it has always been.  If DT is omitted (something already
allowed), it is generated fresh each time.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 crypto/ansi_cprng.c | 67 +++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 50 insertions(+), 17 deletions(-)

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index 7b6b263d..c2c285f3 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -1,7 +1,11 @@
 /*
  * PRNG: Pseudo Random Number Generator
- *       Based on NIST Recommended PRNG From ANSI X9.31 Appendix A.2.4 using
- *       AES 128 cipher
+ *       Based on "NIST Recommended PRNG From ANSI X9.31 Appendix A.2.4"
+ *       using AES 128 cipher. It may be seeded with a fixed DT value
+ *       for determinsitic generaton purposes, or if no DT value is
+ *       provided for seed material, it generates a fresh one each time
+ *       using a high-resolution timestamp, as specified in the X9.17
+ *       and X9.31 standards.
  *
  *  (C) Neil Horman <nhorman@tuxdriver.com>
  *
@@ -9,8 +13,6 @@
  *  under the terms of the GNU General Public License as published by the
  *  Free Software Foundation; either version 2 of the License, or (at your
  *  any later version.
- *
- *
  */
 
 #include <crypto/internal/rng.h>
@@ -41,8 +43,8 @@ union block {
 /*
  * Flags for the prng_context flags field
  */
-
-#define PRNG_NEED_RESET 0x1
+#define PRNG_NEED_RESET		0x1
+#define PRNG_DETERMINISTIC	0x2
 
 /*
  * Note: In addition to the fixed encryption key, there are three
@@ -104,6 +106,16 @@ static int _get_more_prng_bytes(struct prng_context *ctx, bool cont_test)
 	hexdump("Input V: ", &ctx->V);
 
 	/*
+	 * get_random_int produces a result based on the system jiffies
+	 * and random_get_entropy(), the highest-resolution timestamp
+	 * available.  This meets the spirit of the X9.17/X9.31 generation
+	 * specifications, but it's masked by hashing, so it can't be used
+	 * to leak information about the seed to /dev/random.
+	 */
+	if (!(ctx->flags & PRNG_DETERMINISTIC))
+		ctx->DT.ints[0] = get_random_int();
+
+	/*
 	 * Start by encrypting the counter value.
 	 * This gives us an intermediate value I.
 	 */
@@ -144,12 +156,19 @@ static int _get_more_prng_bytes(struct prng_context *ctx, bool cont_test)
 	crypto_cipher_encrypt_one(ctx->tfm, ctx->V.bytes, ctx->V.bytes);
 
 	/*
-	 * Now update our DT value
+	 * Now update our DT value.
 	 */
-	for (i = DEFAULT_BLK_SZ - 1; i >= 0; i--) {
-		ctx->DT.bytes[i] += 1;
-		if (ctx->DT.bytes[i] != 0)
-			break;
+	if (ctx->flags & PRNG_DETERMINISTIC) {
+		/* The big-endian byte order matches the NIST test vectors */
+		for (i = DEFAULT_BLK_SZ - 1; i >= 0; i--) {
+			ctx->DT.bytes[i] += 1;
+			if (ctx->DT.bytes[i] != 0)
+				break;
+		}
+	} else {
+		/* Prevent backtracking */
+		ctx->DT.ints[0] = 0;	/* Prevent backtracking */
+		memzero_explicit(tmp.bytes, DEFAULT_BLK_SZ);
 	}
 
 	dbgprint("Returning new block for context %p\n", ctx);
@@ -193,7 +212,9 @@ static int get_prng_bytes(unsigned char *buf, unsigned int nbytes,
 	/* The final partial block */
 	len = nbytes - pos;
 	memcpy(buf + pos, ctx->rand_data.bytes + read_pos, len);
-	ctx->rand_read_pos = read_pos + len;
+	read_pos += len;
+	memzero_explicit(ctx->rand_data.bytes, read_pos);
+	ctx->rand_read_pos = read_pos;
 	err = nbytes;
 
 done:
@@ -215,14 +236,26 @@ static int reset_prng_context(struct prng_context *ctx,
 	int ret;
 
 	spin_lock_bh(&ctx->prng_lock);
-	ctx->flags |= PRNG_NEED_RESET;
+	ctx->flags = PRNG_NEED_RESET;
 
 	memcpy(ctx->V.bytes, V, DEFAULT_BLK_SZ);
 
-	if (DT)
+	if (DT) {
+		/* Predictable DT, when repeatability is desired */
+		ctx->flags |= PRNG_DETERMINISTIC;
 		memcpy(ctx->DT.bytes, DT, DEFAULT_BLK_SZ);
-	else
-		memset(ctx->DT.bytes, 0, DEFAULT_BLK_SZ);
+	} else {
+		int i;
+		/*
+		 * Generate a fresh DT based on timestamp each time.
+		 * Also pad rest of buffer with seed, on general principles.
+		 * We reserve the first int for fresh entropy, in case
+		 * the key is not an even multiple of an int in size and
+		 * the last int is partially ignored.
+		 */
+		for (i = 1; i < BLK_INTS; i++)
+			ctx->DT.ints[i] = get_random_int();
+	}
 
 	memset(ctx->rand_data.bytes, 0, DEFAULT_BLK_SZ);
 
@@ -255,7 +288,7 @@ static int cprng_init(struct crypto_tfm *tfm)
 	 * After allocation, we always force the user to reset, which
 	 * completes initialization of the context.
 	 */
-	ctx->flags |= PRNG_NEED_RESET;
+	ctx->flags = PRNG_NEED_RESET;
 	return 0;
 }
 
-- 
2.1.3
