From: George Spelvin <linux@horizon.com>
Subject: [PATCH v2 04/25] crypto: ansi_cprng - Make debug output more like NIST test vectors
Date: Sun,  7 Dec 2014 07:26:12 -0500
Message-ID: <9dafebc68063a20a57a1c78e67823c94d9e0550b.1417951990.git.linux@horizon.com>
References: <cover.1417951990.git.linux@horizon.com>
Cc: smueller@chronox.de, herbert@gondor.apana.org.au, linux@horizon.com
To: nhorman@tuxdriver.com, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:15673 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753147AbaLGM0y (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2014 07:26:54 -0500
In-Reply-To: <cover.1417951990.git.linux@horizon.com>
In-Reply-To: <cover.1417951990.git.linux@horizon.com>
References: <cover.1417951990.git.linux@horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This uses more meaningful labels (if you have the spec as a
reference), and avoids printing some stuff (like the original DT)
twice.

It also strips out the len parameter and uses a fixed length of
DEFAULT_BLK_SZ.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 crypto/ansi_cprng.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index b54e4e75..325aa727d 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -19,6 +19,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/string.h>
+#include <linux/stringify.h>
 
 #include "internal.h"
 
@@ -57,10 +58,11 @@ struct prng_context {
 
 static int dbg;
 
-static void hexdump(char *note, unsigned char *buf, unsigned int len)
+static void hexdump(char const *note, const unsigned char buf[DEFAULT_BLK_SZ])
 {
 	if (dbg) {
-		printk(KERN_CRIT "%s%*phN", note, (int)len, buf);
+		printk(KERN_CRIT "%s = %" __stringify(DEFAULT_BLK_SZ) "phN",
+			note, buf);
 	}
 }
 
@@ -90,17 +92,16 @@ static int _get_more_prng_bytes(struct prng_context *ctx, int cont_test)
 	dbgprint(KERN_CRIT "Calling _get_more_prng_bytes for context %p\n",
 		ctx);
 
-	hexdump("Input DT: ", ctx->DT, DEFAULT_BLK_SZ);
-	hexdump("Input I: ", ctx->I, DEFAULT_BLK_SZ);
-	hexdump("Input V: ", ctx->V, DEFAULT_BLK_SZ);
+	hexdump("DT", ctx->DT);
+	hexdump("V", ctx->V);
 
 	/*
 	 * Start by encrypting the counter value
 	 * This gives us an intermediate value I
 	 */
 	memcpy(tmp, ctx->DT, DEFAULT_BLK_SZ);
-	hexdump("tmp stage 0: ", tmp, DEFAULT_BLK_SZ);
 	crypto_cipher_encrypt_one(ctx->tfm, ctx->I, tmp);
+	hexdump("I", ctx->I);
 
 	/*
 	 * Next xor I with our secret vector V
@@ -108,8 +109,9 @@ static int _get_more_prng_bytes(struct prng_context *ctx, int cont_test)
 	 * pseudo random data which we output
 	 */
 	xor_vectors(ctx->I, ctx->V, tmp, DEFAULT_BLK_SZ);
-	hexdump("tmp stage 1: ", tmp, DEFAULT_BLK_SZ);
+	hexdump("V^I", tmp);
 	crypto_cipher_encrypt_one(ctx->tfm, ctx->rand_data, tmp);
+	hexdump("R", ctx->rand_data);
 
 	/*
 	 * First check that we didn't produce the same
@@ -132,8 +134,9 @@ static int _get_more_prng_bytes(struct prng_context *ctx, int cont_test)
 	 * and encrypt that to obtain a new secret vector V
 	 */
 	xor_vectors(ctx->rand_data, ctx->I, tmp, DEFAULT_BLK_SZ);
-	hexdump("tmp stage 2: ", tmp, DEFAULT_BLK_SZ);
+	hexdump("R^I", tmp);
 	crypto_cipher_encrypt_one(ctx->tfm, ctx->V, tmp);
+	hexdump("V'", ctx->V);
 
 	/*
 	 * Now update our DT value
@@ -143,15 +146,11 @@ static int _get_more_prng_bytes(struct prng_context *ctx, int cont_test)
 		if (ctx->DT[i] != 0)
 			break;
 	}
+	hexdump("DT'", ctx->DT);
 
 	dbgprint("Returning new block for context %p\n", ctx);
 	ctx->rand_data_valid = 0;
 
-	hexdump("Output DT: ", ctx->DT, DEFAULT_BLK_SZ);
-	hexdump("Output I: ", ctx->I, DEFAULT_BLK_SZ);
-	hexdump("Output V: ", ctx->V, DEFAULT_BLK_SZ);
-	hexdump("New Random Data: ", ctx->rand_data, DEFAULT_BLK_SZ);
-
 	return 0;
 }
 
-- 
2.1.3
