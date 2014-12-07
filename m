From: George Spelvin <linux@horizon.com>
Subject: [PATCH v2 02/25] crypto: ansi_cprng - Additional _get_more_prng_bytes cleanup
Date: Sun,  7 Dec 2014 07:26:10 -0500
Message-ID: <0adc66f32b0eb34ba267d7173f8ee4b732294a5e.1417951990.git.linux@horizon.com>
References: <cover.1417951990.git.linux@horizon.com>
Cc: smueller@chronox.de, herbert@gondor.apana.org.au, linux@horizon.com
To: nhorman@tuxdriver.com, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:29037 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753083AbaLGM0x (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2014 07:26:53 -0500
In-Reply-To: <cover.1417951990.git.linux@horizon.com>
In-Reply-To: <cover.1417951990.git.linux@horizon.com>
References: <cover.1417951990.git.linux@horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The local variable "output" is no longer required.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 crypto/ansi_cprng.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index ce315bf7..143e0cfa 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -89,8 +89,6 @@ static int _get_more_prng_bytes(struct prng_context *ctx, int cont_test)
 {
 	int i;
 	unsigned char tmp[DEFAULT_BLK_SZ];
-	unsigned char *output = NULL;
-
 
 	dbgprint(KERN_CRIT "Calling _get_more_prng_bytes for context %p\n",
 		ctx);
@@ -104,9 +102,8 @@ static int _get_more_prng_bytes(struct prng_context *ctx, int cont_test)
 	 * This gives us an intermediate value I
 	 */
 	memcpy(tmp, ctx->DT, DEFAULT_BLK_SZ);
-	output = ctx->I;
 	hexdump("tmp stage 0: ", tmp, DEFAULT_BLK_SZ);
-	crypto_cipher_encrypt_one(ctx->tfm, output, tmp);
+	crypto_cipher_encrypt_one(ctx->tfm, ctx->I, tmp);
 
 	/*
 	 * Next xor I with our secret vector V
@@ -115,8 +112,7 @@ static int _get_more_prng_bytes(struct prng_context *ctx, int cont_test)
 	 */
 	xor_vectors(ctx->I, ctx->V, tmp, DEFAULT_BLK_SZ);
 	hexdump("tmp stage 1: ", tmp, DEFAULT_BLK_SZ);
-	output = ctx->rand_data;
-	crypto_cipher_encrypt_one(ctx->tfm, output, tmp);
+	crypto_cipher_encrypt_one(ctx->tfm, ctx->rand_data, tmp);
 
 	/*
 	 * First check that we didn't produce the same
@@ -139,9 +135,8 @@ static int _get_more_prng_bytes(struct prng_context *ctx, int cont_test)
 	 * and encrypt that to obtain a new secret vector V
 	 */
 	xor_vectors(ctx->rand_data, ctx->I, tmp, DEFAULT_BLK_SZ);
-	output = ctx->V;
 	hexdump("tmp stage 2: ", tmp, DEFAULT_BLK_SZ);
-	crypto_cipher_encrypt_one(ctx->tfm, output, tmp);
+	crypto_cipher_encrypt_one(ctx->tfm, ctx->V, tmp);
 
 	/*
 	 * Now update our DT value
-- 
2.1.3
