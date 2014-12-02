From: "George Spelvin" <linux@horizon.com>
Subject: PATCH 04/17] crypto: ansi_cprng - simplify xor_vectors() to xor_block()
Date: 2 Dec 2014 03:37:49 -0500
Message-ID: <20141202083749.18039.qmail@ns.horizon.com>
References: <20141202083314.17647.qmail@ns.horizon.com>
Cc: linux-crypto@vger.kernel.org, linux@horizon.com,
	smueller@chronox.de
To: herbert@gondor.apana.org.au, nhorman@tuxdriver.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:21489 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751047AbaLBIhu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Dec 2014 03:37:50 -0500
In-Reply-To: <20141202083314.17647.qmail@ns.horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

It doesn't need a second input or a length parameter.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 crypto/ansi_cprng.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index 6b844f13..4856c84c7 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -74,14 +74,12 @@ if (dbg)\
 	printk(format, ##args);\
 } while (0)
 
-static void xor_vectors(unsigned char *in1, unsigned char *in2,
-			unsigned char *out, unsigned int size)
+static void xor_block(unsigned char const *in, unsigned char *out)
 {
 	int i;
 
-	for (i = 0; i < size; i++)
-		out[i] = in1[i] ^ in2[i];
-
+	for (i = 0; i < DEFAULT_BLK_SZ; i++)
+		out[i] ^= in[i];
 }
 /*
  * Returns DEFAULT_BLK_SZ bytes of random data per call
@@ -123,7 +121,7 @@ static int _get_more_prng_bytes(struct prng_context *ctx, int cont_test)
 			 * in (no longer used) V until we have done the
 			 * anti-repetition compare.
 			 */
-			xor_vectors(tmp, ctx->V, ctx->V, DEFAULT_BLK_SZ);
+			xor_block(tmp, ctx->V);
 			hexdump("input stage 1: ", ctx->V, DEFAULT_BLK_SZ);
 			input = output = ctx->V;
 			break;
@@ -151,7 +149,7 @@ static int _get_more_prng_bytes(struct prng_context *ctx, int cont_test)
 			 * Lastly xor the random data with I
 			 * and encrypt that to obtain a new secret vector V
 			 */
-			xor_vectors(tmp, ctx->V, ctx->V, DEFAULT_BLK_SZ);
+			xor_block(tmp, ctx->V);
 			hexdump("input stage 2: ", ctx->V, DEFAULT_BLK_SZ);
 			input = output = ctx->V;
 			break;
-- 
2.1.3
