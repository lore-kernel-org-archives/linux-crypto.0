From: "George Spelvin" <linux@horizon.com>
Subject: [PATCH 01/17] crypto: ansi_cprng - Rename rand_data_valid more sensibly
Date: 2 Dec 2014 03:34:41 -0500
Message-ID: <20141202083441.17772.qmail@ns.horizon.com>
References: <20141202083314.17647.qmail@ns.horizon.com>
Cc: linux-crypto@vger.kernel.org, linux@horizon.com,
	smueller@chronox.de
To: herbert@gondor.apana.org.au, nhorman@tuxdriver.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:24376 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751035AbaLBIen (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Dec 2014 03:34:43 -0500
In-Reply-To: <20141202083314.17647.qmail@ns.horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

It's more like rand_data_invalid (data which has already been output),
so it's a pretty bad misnomer.  But rand_data_pos is even better.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 crypto/ansi_cprng.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index 97fe3110..c9e1684b 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -50,7 +50,7 @@ struct prng_context {
 	unsigned char DT[DEFAULT_BLK_SZ];
 	unsigned char I[DEFAULT_BLK_SZ];
 	unsigned char V[DEFAULT_BLK_SZ];
-	u32 rand_data_valid;
+	u32 rand_read_pos;	/* Offset into rand_data[] */
 	struct crypto_cipher *tfm;
 	u32 flags;
 };
@@ -174,7 +174,7 @@ static int _get_more_prng_bytes(struct prng_context *ctx, int cont_test)
 	}
 
 	dbgprint("Returning new block for context %p\n", ctx);
-	ctx->rand_data_valid = 0;
+	ctx->rand_read_pos = 0;
 
 	hexdump("Output DT: ", ctx->DT, DEFAULT_BLK_SZ);
 	hexdump("Output I: ", ctx->I, DEFAULT_BLK_SZ);
@@ -217,7 +217,7 @@ static int get_prng_bytes(char *buf, size_t nbytes, struct prng_context *ctx,
 
 
 remainder:
-	if (ctx->rand_data_valid == DEFAULT_BLK_SZ) {
+	if (ctx->rand_read_pos == DEFAULT_BLK_SZ) {
 		if (_get_more_prng_bytes(ctx, do_cont_test) < 0) {
 			memset(buf, 0, nbytes);
 			err = -EINVAL;
@@ -230,12 +230,9 @@ remainder:
 	 */
 	if (byte_count < DEFAULT_BLK_SZ) {
 empty_rbuf:
-		while (ctx->rand_data_valid < DEFAULT_BLK_SZ) {
-			*ptr = ctx->rand_data[ctx->rand_data_valid];
-			ptr++;
-			byte_count--;
-			ctx->rand_data_valid++;
-			if (byte_count == 0)
+		while (ctx->rand_read_pos < DEFAULT_BLK_SZ) {
+			*ptr++ = ctx->rand_data[ctx->rand_read_pos++];
+			if (--byte_count == 0)
 				goto done;
 		}
 	}
@@ -244,17 +241,17 @@ empty_rbuf:
 	 * Now copy whole blocks
 	 */
 	for (; byte_count >= DEFAULT_BLK_SZ; byte_count -= DEFAULT_BLK_SZ) {
-		if (ctx->rand_data_valid == DEFAULT_BLK_SZ) {
+		if (ctx->rand_read_pos == DEFAULT_BLK_SZ) {
 			if (_get_more_prng_bytes(ctx, do_cont_test) < 0) {
 				memset(buf, 0, nbytes);
 				err = -EINVAL;
 				goto done;
 			}
 		}
-		if (ctx->rand_data_valid > 0)
+		if (ctx->rand_read_pos > 0)
 			goto empty_rbuf;
 		memcpy(ptr, ctx->rand_data, DEFAULT_BLK_SZ);
-		ctx->rand_data_valid += DEFAULT_BLK_SZ;
+		ctx->rand_read_pos += DEFAULT_BLK_SZ;
 		ptr += DEFAULT_BLK_SZ;
 	}
 
@@ -304,7 +301,7 @@ static int reset_prng_context(struct prng_context *ctx,
 	memset(ctx->rand_data, 0, DEFAULT_BLK_SZ);
 	memset(ctx->last_rand_data, 0, DEFAULT_BLK_SZ);
 
-	ctx->rand_data_valid = DEFAULT_BLK_SZ;
+	ctx->rand_read_pos = DEFAULT_BLK_SZ;	/* Force immediate refill */
 
 	ret = crypto_cipher_setkey(ctx->tfm, prng_key, klen);
 	if (ret) {
@@ -413,7 +410,7 @@ static int fips_cprng_reset(struct crypto_rng *tfm, u8 *seed, unsigned int slen)
 
 	/* this primes our continuity test */
 	rc = get_prng_bytes(rdata, DEFAULT_BLK_SZ, prng, 0);
-	prng->rand_data_valid = DEFAULT_BLK_SZ;
+	prng->rand_read_pos = DEFAULT_BLK_SZ;
 
 out:
 	return rc;
-- 
2.1.3
