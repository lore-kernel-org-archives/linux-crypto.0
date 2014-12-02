From: "George Spelvin" <linux@horizon.com>
Subject: [PATCH 05/17] crypto: ansi_cprng - Add const annotations to hexdump()
Date: 2 Dec 2014 03:39:20 -0500
Message-ID: <20141202083920.18122.qmail@ns.horizon.com>
References: <20141202083314.17647.qmail@ns.horizon.com>
Cc: linux-crypto@vger.kernel.org, linux@horizon.com,
	smueller@chronox.de
To: herbert@gondor.apana.org.au, nhorman@tuxdriver.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:16282 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750927AbaLBIjW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Dec 2014 03:39:22 -0500
In-Reply-To: <20141202083314.17647.qmail@ns.horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

So I can pass the "input" variable to it.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 crypto/ansi_cprng.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

I like to declare things const, and the lack of this in the prototype
causes compiler complaints.

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index 4856c84c7..1a0ba6a3 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -59,7 +59,7 @@ struct prng_context {
 
 static int dbg;
 
-static void hexdump(char *note, unsigned char *buf, unsigned int len)
+static void hexdump(char const *note, void const *buf, unsigned int len)
 {
 	if (dbg) {
 		printk(KERN_CRIT "%s", note);
@@ -111,7 +111,7 @@ static int _get_more_prng_bytes(struct prng_context *ctx, int cont_test)
 			 */
 			input = ctx->DT;
 			output = tmp;
-			hexdump("input stage 0: ", ctx->DT, DEFAULT_BLK_SZ);
+			hexdump("input stage 0: ", input, DEFAULT_BLK_SZ);
 			break;
 		case 1:
 			/*
@@ -122,8 +122,8 @@ static int _get_more_prng_bytes(struct prng_context *ctx, int cont_test)
 			 * anti-repetition compare.
 			 */
 			xor_block(tmp, ctx->V);
-			hexdump("input stage 1: ", ctx->V, DEFAULT_BLK_SZ);
 			input = output = ctx->V;
+			hexdump("input stage 1: ", input, DEFAULT_BLK_SZ);
 			break;
 		case 2:
 			/*
@@ -150,8 +150,8 @@ static int _get_more_prng_bytes(struct prng_context *ctx, int cont_test)
 			 * and encrypt that to obtain a new secret vector V
 			 */
 			xor_block(tmp, ctx->V);
-			hexdump("input stage 2: ", ctx->V, DEFAULT_BLK_SZ);
 			input = output = ctx->V;
+			hexdump("input stage 2: ", input, DEFAULT_BLK_SZ);
 			break;
 		}
 
-- 
2.1.3
