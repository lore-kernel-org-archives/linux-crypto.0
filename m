From: George Spelvin <linux@horizon.com>
Subject: [PATCH v2 20/25] crypto: ansi_cprng - simplify xor_vectors() to xor_block()
Date: Sun,  7 Dec 2014 07:26:28 -0500
Message-ID: <8aa0c562a25d97770212f3e71f21d50a9177dc2d.1417951990.git.linux@horizon.com>
References: <cover.1417951990.git.linux@horizon.com>
Cc: smueller@chronox.de, herbert@gondor.apana.org.au, linux@horizon.com
To: nhorman@tuxdriver.com, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:27220 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753195AbaLGM1G (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2014 07:27:06 -0500
In-Reply-To: <cover.1417951990.git.linux@horizon.com>
In-Reply-To: <cover.1417951990.git.linux@horizon.com>
References: <cover.1417951990.git.linux@horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

It doesn't need a second input or a length parameter.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 crypto/ansi_cprng.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index a8cf98a5..f345b575 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -63,15 +63,14 @@ if (dbg)\
 	printk(format, ##args);\
 } while (0)
 
-static void xor_vectors(const u8 *in1, const u8 *in2,
-			u8 *out, unsigned int size)
+static void xor_block(const u8 in[DEFAULT_BLK_SZ], u8 out[DEFAULT_BLK_SZ])
 {
 	int i;
 
-	for (i = 0; i < size; i++)
-		out[i] = in1[i] ^ in2[i];
-
+	for (i = 0; i < DEFAULT_BLK_SZ; i++)
+		out[i] ^= in[i];
 }
+
 /*
  * Returns DEFAULT_BLK_SZ bytes of random data per call
  * returns 0 if generation succeeded, <0 if something went wrong
@@ -100,7 +99,7 @@ static int _get_more_prng_bytes(struct prng_context *ctx, bool cont_test)
 	 * keep that output in ctx->V for the moment; we need the
 	 * previous rand_data for ons more thing.
 	 */
-	xor_vectors(tmp, ctx->V, ctx->V, DEFAULT_BLK_SZ);
+	xor_block(tmp, ctx->V);
 	hexdump("V^I", ctx->V);
 	crypto_cipher_encrypt_one(ctx->tfm, ctx->V, ctx->V);
 	hexdump("R", ctx->V);
@@ -128,7 +127,7 @@ static int _get_more_prng_bytes(struct prng_context *ctx, bool cont_test)
 	 * Lastly xor the random data with I and encrypt that to obtain
 	 * a new secret vector V.
 	 */
-	xor_vectors(tmp, ctx->V, ctx->V, DEFAULT_BLK_SZ);
+	xor_block(tmp, ctx->V);
 	hexdump("R^I", ctx->V);
 	memzero_explicit(tmp, DEFAULT_BLK_SZ);
 	crypto_cipher_encrypt_one(ctx->tfm, ctx->V, ctx->V);
-- 
2.1.3
