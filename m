From: "George Spelvin" <linux@horizon.com>
Subject: [PATCH 12/17] crypto: ansi_cprng - Create a "block buffer" data type
Date: 2 Dec 2014 03:56:04 -0500
Message-ID: <20141202085604.19318.qmail@ns.horizon.com>
References: <20141202083314.17647.qmail@ns.horizon.com>
Cc: linux-crypto@vger.kernel.org, linux@horizon.com,
	smueller@chronox.de
To: herbert@gondor.apana.org.au, nhorman@tuxdriver.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:57521 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750973AbaLBI4G (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Dec 2014 03:56:06 -0500
In-Reply-To: <20141202083314.17647.qmail@ns.horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

It's just a union of various word sizes to address the buffer.
This achieves three things:
1) Aligns the buffers for (hopefully) slight performance benefit
2) Allows XOR to be done long-at-a-time
3) Prepares for later patches where I want int-at-a-time access

Signed-off-by: George Spelvin <linux@horizon.com>
---
 crypto/ansi_cprng.c | 78 ++++++++++++++++++++++++++++++-----------------------
 1 file changed, 44 insertions(+), 34 deletions(-)

This is the sort of style issue I fear will attract loud screams.

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index 09bb1252..7b6b263d 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -26,6 +26,19 @@
 #define DEFAULT_BLK_SZ 16
 
 /*
+ * A cipher block is defined as a union, so we can address individual bytes,
+ * or do things word-at-a-time when byte order doesn't matter, such as XOR
+ * or adding in entropy.
+ */
+#define BLK_INTS ((DEFAULT_BLK_SZ-1) / sizeof(int) + 1)
+#define BLK_LONGS ((DEFAULT_BLK_SZ-1) / sizeof(long) + 1)
+union block {
+	unsigned char bytes[DEFAULT_BLK_SZ];
+	unsigned long ints[BLK_INTS];
+	unsigned long longs[BLK_LONGS];
+};
+
+/*
  * Flags for the prng_context flags field
  */
 
@@ -46,23 +59,20 @@
  */
 struct prng_context {
 	spinlock_t prng_lock;
-	unsigned char rand_data[DEFAULT_BLK_SZ];
-	unsigned char DT[DEFAULT_BLK_SZ];
-	unsigned char V[DEFAULT_BLK_SZ];
-	unsigned char rand_read_pos;	/* Offset into rand_data[] */
+	unsigned char rand_read_pos;	/* Offset into rand_data.bytes[] */
 	unsigned char flags;
+	union block rand_data, DT, V;
 	struct crypto_cipher *tfm;
 };
 
 static int dbg;
 
-static void hexdump(char const *note, void const *buf, unsigned int len)
+static void hexdump(char const *note, union block const *block)
 {
 	if (dbg) {
 		printk(KERN_CRIT "%s", note);
 		print_hex_dump(KERN_CONT, "", DUMP_PREFIX_OFFSET,
-				16, 1,
-				buf, len, false);
+				16, 1, block->bytes, DEFAULT_BLK_SZ, false);
 	}
 }
 
@@ -71,12 +81,12 @@ if (dbg)\
 	printk(format, ##args);\
 } while (0)
 
-static void xor_block(unsigned char const *in, unsigned char *out)
+static void xor_block(union block const *in, union block *out)
 {
 	int i;
 
-	for (i = 0; i < DEFAULT_BLK_SZ; i++)
-		out[i] ^= in[i];
+	for (i = 0; i < BLK_LONGS; i++)
+		out->longs[i] ^= in->longs[i];
 }
 /*
  * Returns DEFAULT_BLK_SZ bytes of random data per call
@@ -85,20 +95,20 @@ static void xor_block(unsigned char const *in, unsigned char *out)
 static int _get_more_prng_bytes(struct prng_context *ctx, bool cont_test)
 {
 	int i;
-	unsigned char tmp[DEFAULT_BLK_SZ];
+	union block tmp;
 
 	dbgprint(KERN_CRIT "Calling _get_more_prng_bytes for context %p\n",
 		ctx);
 
-	hexdump("Input DT: ", ctx->DT, DEFAULT_BLK_SZ);
-	hexdump("Input V: ", ctx->V, DEFAULT_BLK_SZ);
+	hexdump("Input DT: ", &ctx->DT);
+	hexdump("Input V: ", &ctx->V);
 
 	/*
 	 * Start by encrypting the counter value.
 	 * This gives us an intermediate value I.
 	 */
-	crypto_cipher_encrypt_one(ctx->tfm, tmp, ctx->DT);
-	hexdump("input I: ", tmp, DEFAULT_BLK_SZ);
+	crypto_cipher_encrypt_one(ctx->tfm, tmp.bytes, ctx->DT.bytes);
+	hexdump("input I: ", &tmp);
 
 	/*
 	 * Next xor I with our secret vector V.
@@ -106,15 +116,15 @@ static int _get_more_prng_bytes(struct prng_context *ctx, bool cont_test)
 	 * we output.  It is kept temporarily in (no longer used)
 	 * V until we have done the anti-repetition compare.
 	 */
-	xor_block(tmp, ctx->V);
-	hexdump("input stage 1: ", ctx->V, DEFAULT_BLK_SZ);
-	crypto_cipher_encrypt_one(ctx->tfm, ctx->V, ctx->V);
+	xor_block(&tmp, &ctx->V);
+	hexdump("input stage 1: ", &ctx->V);
+	crypto_cipher_encrypt_one(ctx->tfm, ctx->V.bytes, ctx->V.bytes);
 
 	/*
 	 * Check that we didn't produce the same random data
 	 * that we did last time around.
 	 */
-	if (!memcmp(ctx->V, ctx->rand_data, DEFAULT_BLK_SZ)) {
+	if (!memcmp(ctx->V.bytes, ctx->rand_data.bytes, DEFAULT_BLK_SZ)) {
 		if (cont_test) {
 			panic("cprng %p Failed repetition check!\n", ctx);
 		}
@@ -123,30 +133,30 @@ static int _get_more_prng_bytes(struct prng_context *ctx, bool cont_test)
 		ctx->flags |= PRNG_NEED_RESET;
 		return -EINVAL;
 	}
-	memcpy(ctx->rand_data, ctx->V, DEFAULT_BLK_SZ);
+	ctx->rand_data = ctx->V;
 
 	/*
 	 * Lastly xor the random data with I and encrypt that to
 	 * obtain a new secret vector V
 	 */
-	xor_block(tmp, ctx->V);
-	hexdump("input stage 2: ", ctx->V, DEFAULT_BLK_SZ);
-	crypto_cipher_encrypt_one(ctx->tfm, ctx->V, ctx->V);
+	xor_block(&tmp, &ctx->V);
+	hexdump("input stage 2: ", &ctx->V);
+	crypto_cipher_encrypt_one(ctx->tfm, ctx->V.bytes, ctx->V.bytes);
 
 	/*
 	 * Now update our DT value
 	 */
 	for (i = DEFAULT_BLK_SZ - 1; i >= 0; i--) {
-		ctx->DT[i] += 1;
-		if (ctx->DT[i] != 0)
+		ctx->DT.bytes[i] += 1;
+		if (ctx->DT.bytes[i] != 0)
 			break;
 	}
 
 	dbgprint("Returning new block for context %p\n", ctx);
 
-	hexdump("Output DT: ", ctx->DT, DEFAULT_BLK_SZ);
-	hexdump("Output V: ", ctx->V, DEFAULT_BLK_SZ);
-	hexdump("New Random Data: ", ctx->rand_data, DEFAULT_BLK_SZ);
+	hexdump("Output DT: ", &ctx->DT);
+	hexdump("Output V: ", &ctx->V);
+	hexdump("New Random Data: ", &ctx->rand_data);
 
 	return 0;
 }
@@ -171,7 +181,7 @@ static int get_prng_bytes(unsigned char *buf, unsigned int nbytes,
 	while (nbytes - pos > DEFAULT_BLK_SZ - read_pos) {
 		len = DEFAULT_BLK_SZ - read_pos;
 
-		memcpy(buf + pos, ctx->rand_data + read_pos, len);
+		memcpy(buf + pos, ctx->rand_data.bytes + read_pos, len);
 		if (_get_more_prng_bytes(ctx, do_cont_test) < 0) {
 			memset(buf, 0, nbytes);
 			goto done;
@@ -182,7 +192,7 @@ static int get_prng_bytes(unsigned char *buf, unsigned int nbytes,
 
 	/* The final partial block */
 	len = nbytes - pos;
-	memcpy(buf + pos, ctx->rand_data + read_pos, len);
+	memcpy(buf + pos, ctx->rand_data.bytes + read_pos, len);
 	ctx->rand_read_pos = read_pos + len;
 	err = nbytes;
 
@@ -207,14 +217,14 @@ static int reset_prng_context(struct prng_context *ctx,
 	spin_lock_bh(&ctx->prng_lock);
 	ctx->flags |= PRNG_NEED_RESET;
 
-	memcpy(ctx->V, V, DEFAULT_BLK_SZ);
+	memcpy(ctx->V.bytes, V, DEFAULT_BLK_SZ);
 
 	if (DT)
-		memcpy(ctx->DT, DT, DEFAULT_BLK_SZ);
+		memcpy(ctx->DT.bytes, DT, DEFAULT_BLK_SZ);
 	else
-		memset(ctx->DT, 0, DEFAULT_BLK_SZ);
+		memset(ctx->DT.bytes, 0, DEFAULT_BLK_SZ);
 
-	memset(ctx->rand_data, 0, DEFAULT_BLK_SZ);
+	memset(ctx->rand_data.bytes, 0, DEFAULT_BLK_SZ);
 
 	ctx->rand_read_pos = DEFAULT_BLK_SZ;	/* Force immediate refill */
 
-- 
2.1.3
