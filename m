From: George Spelvin <linux@horizon.com>
Subject: [PATCH v2 19/25] crypto: ansi_cprng - simplify get_prng_bytes
Date: Sun,  7 Dec 2014 07:26:27 -0500
Message-ID: <3c1891cbc6a74d6abf98ac2911f6c89225dc1fbe.1417951990.git.linux@horizon.com>
References: <cover.1417951990.git.linux@horizon.com>
Cc: smueller@chronox.de, herbert@gondor.apana.org.au, linux@horizon.com
To: nhorman@tuxdriver.com, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:31309 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753197AbaLGM1G (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2014 07:27:06 -0500
In-Reply-To: <cover.1417951990.git.linux@horizon.com>
In-Reply-To: <cover.1417951990.git.linux@horizon.com>
References: <cover.1417951990.git.linux@horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The crypto is so slow that there's no point unrolling this function.

A simpler and clearer implementation will do just fine.

Two other changes:
1. Move the debug print outside the spinlock;
2. Move all modification of rand_data_valid out of _get_more_prng_bytes;
   that variable belongs to the byte-at-a-time layer outside the
   block-oriented primitive.

This is the code that gave us CVE-2013-4345; it's full of corner cases
which the standard test vectors don't exercise.  The stutter test was
created to exercise it.  (And yes, it did catch problems during
development.)

Signed-off-by: George Spelvin <linux@horizon.com>
---
 crypto/ansi_cprng.c | 74 ++++++++++++++++++-----------------------------------
 1 file changed, 25 insertions(+), 49 deletions(-)

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index c1c81266..a8cf98a5 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -145,7 +145,6 @@ static int _get_more_prng_bytes(struct prng_context *ctx, bool cont_test)
 	hexdump("DT'", ctx->DT);
 
 	dbgprint("Returning new block for context %p\n", ctx);
-	ctx->rand_data_valid = 0;
 
 	return 0;
 }
@@ -156,68 +155,45 @@ static int get_prng_bytes(u8 *buf, unsigned int nbytes,
 {
 	u8 *ptr = buf;
 	unsigned int byte_count = nbytes;
-	int err;
+	unsigned int read_pos;
+	int err = -EINVAL;
 
+	dbgprint(KERN_CRIT "getting %u random bytes for context %p\n",
+		nbytes, ctx);
 
 	spin_lock_bh(&ctx->prng_lock);
 
-	err = -EINVAL;
 	if (ctx->flags & PRNG_NEED_RESET)
 		goto done;
 
-	err = byte_count;
-
-	dbgprint(KERN_CRIT "getting %d random bytes for context %p\n",
-		byte_count, ctx);
-
-
-remainder:
-	if (ctx->rand_data_valid == DEFAULT_BLK_SZ) {
-		if (_get_more_prng_bytes(ctx, do_cont_test) < 0) {
-			memset(buf, 0, nbytes);
-			err = -EINVAL;
-			goto done;
-		}
-	}
-
-	/*
-	 * Copy any data less than an entire block
-	 */
-	if (byte_count < DEFAULT_BLK_SZ) {
-empty_rbuf:
-		while (ctx->rand_data_valid < DEFAULT_BLK_SZ) {
-			*ptr = ctx->rand_data[ctx->rand_data_valid];
-			ptr++;
-			byte_count--;
-			ctx->rand_data_valid++;
-			if (byte_count == 0)
-				goto done;
-		}
-	}
-
-	/*
-	 * Now copy whole blocks
-	 */
-	for (; byte_count >= DEFAULT_BLK_SZ; byte_count -= DEFAULT_BLK_SZ) {
-		if (ctx->rand_data_valid == DEFAULT_BLK_SZ) {
+	read_pos = ctx->rand_data_valid;
+	if (byte_count > DEFAULT_BLK_SZ - read_pos) {
+		/* Leading partial block */
+		unsigned int avail = DEFAULT_BLK_SZ - read_pos;
+
+		memcpy(ptr, ctx->rand_data + read_pos, avail);
+		ptr += avail;
+		byte_count -= avail;
+		read_pos = 0;
+
+		/* Intermediate full blocks */
+		for (;;) {
 			if (_get_more_prng_bytes(ctx, do_cont_test) < 0) {
 				memset(buf, 0, nbytes);
-				err = -EINVAL;
 				goto done;
 			}
+			if (byte_count < DEFAULT_BLK_SZ)
+				break;
+			memcpy(ptr, ctx->rand_data, DEFAULT_BLK_SZ);
+			ptr += DEFAULT_BLK_SZ;
+			byte_count -= DEFAULT_BLK_SZ;
 		}
-		if (ctx->rand_data_valid > 0)
-			goto empty_rbuf;
-		memcpy(ptr, ctx->rand_data, DEFAULT_BLK_SZ);
-		ctx->rand_data_valid += DEFAULT_BLK_SZ;
-		ptr += DEFAULT_BLK_SZ;
 	}
 
-	/*
-	 * Now go back and get any remaining partial block
-	 */
-	if (byte_count)
-		goto remainder;
+	/* The final partial block; read_pos + byte_count <= DEFAULT_BLK_SZ */
+	memcpy(ptr, ctx->rand_data + read_pos, byte_count);
+	ctx->rand_data_valid = read_pos + byte_count;
+	err = nbytes;
 
 done:
 	spin_unlock_bh(&ctx->prng_lock);
-- 
2.1.3
