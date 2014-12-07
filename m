From: George Spelvin <linux@horizon.com>
Subject: [PATCH v2 21/25] crypto: ansi_cprng - Rename rand_data_valid more sensibly
Date: Sun,  7 Dec 2014 07:26:29 -0500
Message-ID: <85e415e299a11429a58d3585e0198f591222cd19.1417951990.git.linux@horizon.com>
References: <cover.1417951990.git.linux@horizon.com>
Cc: smueller@chronox.de, herbert@gondor.apana.org.au, linux@horizon.com
To: nhorman@tuxdriver.com, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:25089 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753173AbaLGM1H (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2014 07:27:07 -0500
In-Reply-To: <cover.1417951990.git.linux@horizon.com>
In-Reply-To: <cover.1417951990.git.linux@horizon.com>
References: <cover.1417951990.git.linux@horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Since it counts the number of bytes in rand_data which have been output,
and are no longer available for output, it's hardly a count of
"valid" bytes.  rand_data_pos is more appropriate.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 crypto/ansi_cprng.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index f345b575..f3e280c4 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -41,7 +41,7 @@
 struct prng_context {
 	spinlock_t prng_lock;
 	u8 flags;
-	u8 rand_data_valid;
+	u8 rand_read_pos;
 	u8 rand_data[DEFAULT_BLK_SZ];
 	u8 DT[DEFAULT_BLK_SZ];
 	u8 V[DEFAULT_BLK_SZ];
@@ -165,7 +165,7 @@ static int get_prng_bytes(u8 *buf, unsigned int nbytes,
 	if (ctx->flags & PRNG_NEED_RESET)
 		goto done;
 
-	read_pos = ctx->rand_data_valid;
+	read_pos = ctx->rand_read_pos;
 	if (byte_count > DEFAULT_BLK_SZ - read_pos) {
 		/* Leading partial block */
 		unsigned int avail = DEFAULT_BLK_SZ - read_pos;
@@ -191,7 +191,7 @@ static int get_prng_bytes(u8 *buf, unsigned int nbytes,
 
 	/* The final partial block; read_pos + byte_count <= DEFAULT_BLK_SZ */
 	memcpy(ptr, ctx->rand_data + read_pos, byte_count);
-	ctx->rand_data_valid = read_pos + byte_count;
+	ctx->rand_read_pos = read_pos + byte_count;
 	err = nbytes;
 
 done:
@@ -213,7 +213,7 @@ static int reset_prng_context(struct prng_context *ctx, const u8 *key,
 
 	spin_lock_bh(&ctx->prng_lock);
 	ctx->flags |= PRNG_NEED_RESET;
-	ctx->rand_data_valid = DEFAULT_BLK_SZ;
+	ctx->rand_read_pos = DEFAULT_BLK_SZ;
 
 	memset(ctx->rand_data, 0, DEFAULT_BLK_SZ);
 
@@ -324,7 +324,7 @@ static int fips_cprng_reset(struct crypto_rng *tfm, const u8 *seed,
 
 	/* this primes our continuity test */
 	rc = _get_more_prng_bytes(prng, false);
-	prng->rand_data_valid = DEFAULT_BLK_SZ;
+	prng->rand_read_pos = DEFAULT_BLK_SZ;
 
 out:
 	return rc;
-- 
2.1.3
