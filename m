From: "George Spelvin" <linux@horizon.com>
Subject: [PATCH 10/17] crypto: ansi_cprng - simplify get_prng_bytes
Date: 2 Dec 2014 03:52:31 -0500
Message-ID: <20141202085231.19085.qmail@ns.horizon.com>
References: <20141202083314.17647.qmail@ns.horizon.com>
Cc: linux-crypto@vger.kernel.org, linux@horizon.com,
	smueller@chronox.de
To: herbert@gondor.apana.org.au, nhorman@tuxdriver.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:35977 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754589AbaLBIwc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Dec 2014 03:52:32 -0500
In-Reply-To: <20141202083314.17647.qmail@ns.horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The crypto is so slow that there's no point unrolling this function.

A simpler and clearer implementation will do just fine.

Also move all modification of rand_read_pos out of _get_more_prng_bytes;
that's variable belongs to the byte-at-a-time layer outside the
block-oriented primitive.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 crypto/ansi_cprng.c | 67 ++++++++++++++---------------------------------------
 1 file changed, 18 insertions(+), 49 deletions(-)

Friends don't let friends micro-optimize non-inner loops.

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index 6723a561..de13e741 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -166,7 +166,6 @@ static int _get_more_prng_bytes(struct prng_context *ctx, bool cont_test)
 	}
 
 	dbgprint("Returning new block for context %p\n", ctx);
-	ctx->rand_read_pos = 0;
 
 	hexdump("Output DT: ", ctx->DT, DEFAULT_BLK_SZ);
 	hexdump("Output V: ", ctx->V, DEFAULT_BLK_SZ);
@@ -179,65 +178,36 @@ static int _get_more_prng_bytes(struct prng_context *ctx, bool cont_test)
 static int get_prng_bytes(unsigned char *buf, unsigned int nbytes,
 				struct prng_context *ctx, bool do_cont_test)
 {
-	unsigned char *ptr = buf;
-	unsigned int byte_count = (unsigned int)nbytes;
-	int err;
+	unsigned int pos = 0;
+	unsigned int len;
+	int read_pos = ctx->rand_read_pos;
+	int err = -EINVAL;
+
+	dbgprint(KERN_CRIT "getting %u random bytes for context %p\n",
+		nbytes, ctx);
 
 	spin_lock_bh(&ctx->prng_lock);
 
-	err = -EINVAL;
 	if (ctx->flags & PRNG_NEED_RESET)
 		goto done;
 
-	err = byte_count;
+	while (nbytes - pos > DEFAULT_BLK_SZ - read_pos) {
+		len = DEFAULT_BLK_SZ - read_pos;
 
-	dbgprint(KERN_CRIT "getting %d random bytes for context %p\n",
-		byte_count, ctx);
-
-remainder:
-	if (ctx->rand_read_pos == DEFAULT_BLK_SZ) {
+		memcpy(buf + pos, ctx->rand_data + read_pos, len);
 		if (_get_more_prng_bytes(ctx, do_cont_test) < 0) {
 			memset(buf, 0, nbytes);
-			err = -EINVAL;
 			goto done;
 		}
+		pos += len;
+		read_pos = 0;
 	}
 
-	/*
-	 * Copy any data less than an entire block
-	 */
-	if (byte_count < DEFAULT_BLK_SZ) {
-empty_rbuf:
-		while (ctx->rand_read_pos < DEFAULT_BLK_SZ) {
-			*ptr++ = ctx->rand_data[ctx->rand_read_pos++];
-			if (--byte_count == 0)
-				goto done;
-		}
-	}
-
-	/*
-	 * Now copy whole blocks
-	 */
-	for (; byte_count >= DEFAULT_BLK_SZ; byte_count -= DEFAULT_BLK_SZ) {
-		if (ctx->rand_read_pos == DEFAULT_BLK_SZ) {
-			if (_get_more_prng_bytes(ctx, do_cont_test) < 0) {
-				memset(buf, 0, nbytes);
-				err = -EINVAL;
-				goto done;
-			}
-		}
-		if (ctx->rand_read_pos > 0)
-			goto empty_rbuf;
-		memcpy(ptr, ctx->rand_data, DEFAULT_BLK_SZ);
-		ctx->rand_read_pos += DEFAULT_BLK_SZ;
-		ptr += DEFAULT_BLK_SZ;
-	}
-
-	/*
-	 * Now go back and get any remaining partial block
-	 */
-	if (byte_count)
-		goto remainder;
+	/* The final partial block */
+	len = nbytes - pos;
+	memcpy(buf + pos, ctx->rand_data + read_pos, len);
+	ctx->rand_read_pos = read_pos + len;
+	err = nbytes;
 
 done:
 	spin_unlock_bh(&ctx->prng_lock);
@@ -351,7 +321,6 @@ static int fips_cprng_get_random(struct crypto_rng *tfm, u8 *rdata,
 
 static int fips_cprng_reset(struct crypto_rng *tfm, u8 *seed, unsigned int slen)
 {
-	u8 rdata[DEFAULT_BLK_SZ];
 	u8 const *key = seed + DEFAULT_BLK_SZ;
 	int rc;
 
@@ -370,7 +339,7 @@ static int fips_cprng_reset(struct crypto_rng *tfm, u8 *seed, unsigned int slen)
 		goto out;
 
 	/* this primes our continuity test */
-	rc = get_prng_bytes(rdata, DEFAULT_BLK_SZ, prng, 0);
+	rc = _get_more_prng_bytes(prng, false);
 	prng->rand_read_pos = DEFAULT_BLK_SZ;
 
 out:
-- 
2.1.3
