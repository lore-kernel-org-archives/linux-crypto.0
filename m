From: George Spelvin <linux@horizon.com>
Subject: [PATCH v2 23/25] crypto: ansi_cprng - Introduce a "union cipherblock"
Date: Sun,  7 Dec 2014 07:26:31 -0500
Message-ID: <c338b4113c0a7d1665333752864f6d84a48080d4.1417951990.git.linux@horizon.com>
References: <cover.1417951990.git.linux@horizon.com>
Cc: smueller@chronox.de, herbert@gondor.apana.org.au, linux@horizon.com
To: nhorman@tuxdriver.com, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:59435 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753183AbaLGM1H (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2014 07:27:07 -0500
In-Reply-To: <cover.1417951990.git.linux@horizon.com>
In-Reply-To: <cover.1417951990.git.linux@horizon.com>
References: <cover.1417951990.git.linux@horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This ensures alignment and makes xor_block more efficient,
but it's mostly in preparation for later changes.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 crypto/ansi_cprng.c | 73 ++++++++++++++++++++++++++++++-----------------------
 1 file changed, 41 insertions(+), 32 deletions(-)

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index 9c8475a2..4d256d74 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -25,6 +25,15 @@
 
 #define DEFAULT_PRNG_KSZ 16
 #define DEFAULT_BLK_SZ 16
+#define BLK_INTS ((DEFAULT_BLK_SZ + 3) / 4)
+#define BLK_LONGS ((DEFAULT_BLK_SZ + 7) / 8)
+
+/* An aligned buffer thant can be accessed various ways */
+union cipherblock {
+	u8 b[DEFAULT_BLK_SZ];
+	u32 i[BLK_INTS];
+	u64 l[BLK_LONGS];
+};
 
 /*
  * Flags for the prng_context flags field
@@ -47,15 +56,15 @@ struct prng_context {
 	spinlock_t prng_lock;
 	u8 flags;
 	u8 rand_read_pos;
-	u8 rand_data[DEFAULT_BLK_SZ];
-	u8 DT[DEFAULT_BLK_SZ];
-	u8 V[DEFAULT_BLK_SZ];
+	union cipherblock rand_data;
+	union cipherblock DT;
+	union cipherblock V;
 	struct crypto_cipher *tfm;
 };
 
 static int dbg;
 
-static void hexdump(char const *note, const u8 buf[DEFAULT_BLK_SZ])
+static void hexdump(char const *note, const union cipherblock *buf)
 {
 	if (dbg) {
 		printk(KERN_CRIT "%s = %" __stringify(DEFAULT_BLK_SZ) "phN",
@@ -68,11 +77,11 @@ if (dbg)\
 	printk(format, ##args);\
 } while (0)
 
-static void xor_block(const u8 in[DEFAULT_BLK_SZ], u8 out[DEFAULT_BLK_SZ])
+static void xor_block(const u64 in[BLK_LONGS], u64 out[BLK_LONGS])
 {
 	int i;
 
-	for (i = 0; i < DEFAULT_BLK_SZ; i++)
+	for (i = 0; i < BLK_LONGS; i++)
 		out[i] ^= in[i];
 }
 
@@ -83,20 +92,20 @@ static void xor_block(const u8 in[DEFAULT_BLK_SZ], u8 out[DEFAULT_BLK_SZ])
 static int _get_more_prng_bytes(struct prng_context *ctx, bool cont_test)
 {
 	int i;
-	u8 tmp[DEFAULT_BLK_SZ];
+	union cipherblock tmp;
 
 	dbgprint(KERN_CRIT "Calling _get_more_prng_bytes for context %p\n",
 		ctx);
 
-	hexdump("DT", ctx->DT);
-	hexdump("V", ctx->V);
+	hexdump("DT", &ctx->DT);
+	hexdump("V", &ctx->V);
 
 	/*
 	 * Start by encrypting the counter value
 	 * This gives us an intermediate value I (stored in tmp)
 	 */
-	crypto_cipher_encrypt_one(ctx->tfm, tmp, ctx->DT);
-	hexdump("I", tmp);
+	crypto_cipher_encrypt_one(ctx->tfm, tmp.b, ctx->DT.b);
+	hexdump("I", &tmp);
 
 	/*
 	 * Next xor I with our secret vector V.  Encrypt that result
@@ -104,16 +113,16 @@ static int _get_more_prng_bytes(struct prng_context *ctx, bool cont_test)
 	 * keep that output in ctx->V for the moment; we need the
 	 * previous rand_data for ons more thing.
 	 */
-	xor_block(tmp, ctx->V);
-	hexdump("V^I", ctx->V);
-	crypto_cipher_encrypt_one(ctx->tfm, ctx->V, ctx->V);
-	hexdump("R", ctx->V);
+	xor_block(tmp.l, ctx->V.l);
+	hexdump("V^I", &ctx->V);
+	crypto_cipher_encrypt_one(ctx->tfm, ctx->V.b, ctx->V.b);
+	hexdump("R", &ctx->V);
 
 	/*
 	 * Check that we didn't produce the same random data that we
 	 * did last time around.
 	 */
-	if (!memcmp(ctx->V, ctx->rand_data, DEFAULT_BLK_SZ)) {
+	if (!memcmp(ctx->V.b, ctx->rand_data.b, DEFAULT_BLK_SZ)) {
 		if (cont_test) {
 			panic("cprng %p Failed repetition check!\n", ctx);
 		}
@@ -126,27 +135,27 @@ static int _get_more_prng_bytes(struct prng_context *ctx, bool cont_test)
 	/*
 	 * Okay, the new data is okay, copy it to the buffer.
 	 */
-	memcpy(ctx->rand_data, ctx->V, DEFAULT_BLK_SZ);
+	ctx->rand_data = ctx->V;
 
 	/*
 	 * Lastly xor the random data with I and encrypt that to obtain
 	 * a new secret vector V.
 	 */
-	xor_block(tmp, ctx->V);
-	hexdump("R^I", ctx->V);
-	memzero_explicit(tmp, DEFAULT_BLK_SZ);
-	crypto_cipher_encrypt_one(ctx->tfm, ctx->V, ctx->V);
-	hexdump("V'", ctx->V);
+	xor_block(tmp.l, ctx->V.l);
+	hexdump("R^I", &ctx->V);
+	memzero_explicit(tmp.b, DEFAULT_BLK_SZ);
+	crypto_cipher_encrypt_one(ctx->tfm, ctx->V.b, ctx->V.b);
+	hexdump("V'", &ctx->V);
 
 	/*
 	 * Now update our DT value
 	 */
 	for (i = DEFAULT_BLK_SZ - 1; i >= 0; i--) {
-		ctx->DT[i] += 1;
-		if (ctx->DT[i] != 0)
+		ctx->DT.b[i] += 1;
+		if (ctx->DT.b[i] != 0)
 			break;
 	}
-	hexdump("DT'", ctx->DT);
+	hexdump("DT'", &ctx->DT);
 
 	dbgprint("Returning new block for context %p\n", ctx);
 
@@ -175,7 +184,7 @@ static int get_prng_bytes(u8 *buf, unsigned int nbytes,
 		/* Leading partial block */
 		unsigned int avail = DEFAULT_BLK_SZ - read_pos;
 
-		memcpy(ptr, ctx->rand_data + read_pos, avail);
+		memcpy(ptr, ctx->rand_data.b + read_pos, avail);
 		ptr += avail;
 		byte_count -= avail;
 		read_pos = 0;
@@ -188,14 +197,14 @@ static int get_prng_bytes(u8 *buf, unsigned int nbytes,
 			}
 			if (byte_count < DEFAULT_BLK_SZ)
 				break;
-			memcpy(ptr, ctx->rand_data, DEFAULT_BLK_SZ);
+			memcpy(ptr, ctx->rand_data.b, DEFAULT_BLK_SZ);
 			ptr += DEFAULT_BLK_SZ;
 			byte_count -= DEFAULT_BLK_SZ;
 		}
 	}
 
 	/* The final partial block; read_pos + byte_count <= DEFAULT_BLK_SZ */
-	memcpy(ptr, ctx->rand_data + read_pos, byte_count);
+	memcpy(ptr, ctx->rand_data.b + read_pos, byte_count);
 	ctx->rand_read_pos = read_pos + byte_count;
 	err = nbytes;
 
@@ -220,13 +229,13 @@ static int reset_prng_context(struct prng_context *ctx, const u8 *key,
 	ctx->flags |= PRNG_NEED_RESET;
 	ctx->rand_read_pos = DEFAULT_BLK_SZ;
 
-	memset(ctx->rand_data, 0, DEFAULT_BLK_SZ);
+	memset(ctx->rand_data.b, 0, DEFAULT_BLK_SZ);
 
 	if (!DT)
-		DT = ctx->rand_data;	/* Use all-zeros if NULL */
+		DT = ctx->rand_data.b;	/* Use all-zeros if NULL */
 
-	memcpy(ctx->DT, DT, DEFAULT_BLK_SZ);
-	memcpy(ctx->V, V, DEFAULT_BLK_SZ);
+	memcpy(ctx->DT.b, DT, DEFAULT_BLK_SZ);
+	memcpy(ctx->V.b, V, DEFAULT_BLK_SZ);
 
 	ret = crypto_cipher_setkey(ctx->tfm, key, klen);
 	if (ret) {
-- 
2.1.3
