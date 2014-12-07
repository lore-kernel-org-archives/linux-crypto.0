From: George Spelvin <linux@horizon.com>
Subject: [PATCH v2 24/25] crypto: ansi_cprng - Introduce non-deterministic mode
Date: Sun,  7 Dec 2014 07:26:32 -0500
Message-ID: <915716fb77852c29ffb7f0b38b979b2fdd8ad405.1417951990.git.linux@horizon.com>
References: <cover.1417951990.git.linux@horizon.com>
Cc: smueller@chronox.de, herbert@gondor.apana.org.au, linux@horizon.com
To: nhorman@tuxdriver.com, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:50263 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753211AbaLGM1H (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2014 07:27:07 -0500
In-Reply-To: <cover.1417951990.git.linux@horizon.com>
In-Reply-To: <cover.1417951990.git.linux@horizon.com>
References: <cover.1417951990.git.linux@horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

If DT is not provided, use timetamp data for the DT vector.

This is permitted by the NIST spec (although the determinstic
mode is still required for testing purposes), and encouraged by
the X9.31 and X9.17 standards the RNG is adopted from.

The question, however, is whether it's okay to have a "CPRNG"
that's not deterministic.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 crypto/ansi_cprng.c | 52 ++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 40 insertions(+), 12 deletions(-)

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index 4d256d74..d39ce301 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -40,6 +40,7 @@ union cipherblock {
  */
 
 #define PRNG_NEED_RESET 0x1
+#define PRNG_DETERMINISTIC 0x02
 
 /*
  * Note: DT is our counter value
@@ -47,10 +48,12 @@ union cipherblock {
  * See http://csrc.nist.gov/groups/STM/cavp/documents/rng/931rngext.pdf
  * for implementation details.
  *
- * Note that even though DT stands for "date/time", since this is a
- * deterministic pseudo-random generator, it is a determinsitic counter,
- * not a timestamp.  Its function is not to inject seed entropy, but to
- * ensure a long period in the output.
+ * Note that even though DT stands for "date/time", this generator may be
+ * operated in a fully determinsitic mode by specifying it in the initial
+ * seed.  In this case, it does not inject any timestamp-based entropy,
+ * but operates as a simple counter to ensure a long period in the output.
+ *
+ * Both options are permitted by the NIST recommendation.
  */
 struct prng_context {
 	spinlock_t prng_lock;
@@ -97,6 +100,16 @@ static int _get_more_prng_bytes(struct prng_context *ctx, bool cont_test)
 	dbgprint(KERN_CRIT "Calling _get_more_prng_bytes for context %p\n",
 		ctx);
 
+	/*
+	 * get_random_int produces a result based on the system jiffies
+	 * and random_get_entropy(), the highest-resolution timestamp
+	 * available.  This meets the spirit of the X9.17/X9.31 generation
+	 * specifications, but it's masked by hashing, so it can't be used
+	 * to leak information about /dev/random's seed material.
+	 */
+	if (!(ctx->flags & PRNG_DETERMINISTIC))
+		ctx->DT.i[0] = get_random_int();
+
 	hexdump("DT", &ctx->DT);
 	hexdump("V", &ctx->V);
 
@@ -150,12 +163,16 @@ static int _get_more_prng_bytes(struct prng_context *ctx, bool cont_test)
 	/*
 	 * Now update our DT value
 	 */
-	for (i = DEFAULT_BLK_SZ - 1; i >= 0; i--) {
-		ctx->DT.b[i] += 1;
-		if (ctx->DT.b[i] != 0)
-			break;
+	if (ctx->flags & PRNG_DETERMINISTIC) {
+		for (i = DEFAULT_BLK_SZ - 1; i >= 0; i--) {
+			ctx->DT.b[i] += 1;
+			if (ctx->DT.b[i] != 0)
+				break;
+		}
+		hexdump("DT'", &ctx->DT);
+	} else {
+		ctx->DT.i[0] = 0;	/* Prevent backtracking */
 	}
-	hexdump("DT'", &ctx->DT);
 
 	dbgprint("Returning new block for context %p\n", ctx);
 
@@ -226,13 +243,24 @@ static int reset_prng_context(struct prng_context *ctx, const u8 *key,
 	int ret;
 
 	spin_lock_bh(&ctx->prng_lock);
-	ctx->flags |= PRNG_NEED_RESET;
+	ctx->flags = PRNG_NEED_RESET;
 	ctx->rand_read_pos = DEFAULT_BLK_SZ;
 
 	memset(ctx->rand_data.b, 0, DEFAULT_BLK_SZ);
 
-	if (!DT)
-		DT = ctx->rand_data.b;	/* Use all-zeros if NULL */
+	if (DT) {
+		ctx->flags |= PRNG_DETERMINISTIC;
+		memcpy(ctx->DT.b, DT, DEFAULT_BLK_SZ);
+	} else {
+		int i;
+		/*
+		 * We will generate a fresh DT based on timestamp each time.
+		 * Also pad rest of buffer with seed, on general principles.
+		 * We reserve the first int for fresh entropy.
+		 */
+		for (i = 1; i < BLK_INTS; i++)
+			ctx->DT.i[i] = get_random_int();
+	}
 
 	memcpy(ctx->DT.b, DT, DEFAULT_BLK_SZ);
 	memcpy(ctx->V.b, V, DEFAULT_BLK_SZ);
-- 
2.1.3
