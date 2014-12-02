From: "George Spelvin" <linux@horizon.com>
Subject: [PATCH 06/17] crypto: ansi_cprng - Eliminate unused PRNG_FIXED_SIZE flag
Date: 2 Dec 2014 03:40:34 -0500
Message-ID: <20141202084034.18215.qmail@ns.horizon.com>
References: <20141202083314.17647.qmail@ns.horizon.com>
Cc: linux-crypto@vger.kernel.org, linux@horizon.com,
	smueller@chronox.de
To: herbert@gondor.apana.org.au, nhorman@tuxdriver.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:45623 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750969AbaLBIkg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Dec 2014 03:40:36 -0500
In-Reply-To: <20141202083314.17647.qmail@ns.horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

There's no way to set it, so it's dead code.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 crypto/ansi_cprng.c | 16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

I really hope I'm reading this right!

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index 1a0ba6a3..93ed00f6 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -31,8 +31,7 @@
  * Flags for the prng_context flags field
  */
 
-#define PRNG_FIXED_SIZE 0x1
-#define PRNG_NEED_RESET 0x2
+#define PRNG_NEED_RESET 0x1
 
 /*
  * Note: In addition to the fixed encryption key, there are three
@@ -186,30 +185,17 @@ static int get_prng_bytes(char *buf, size_t nbytes, struct prng_context *ctx,
 	unsigned int byte_count = (unsigned int)nbytes;
 	int err;
 
-
 	spin_lock_bh(&ctx->prng_lock);
 
 	err = -EINVAL;
 	if (ctx->flags & PRNG_NEED_RESET)
 		goto done;
 
-	/*
-	 * If the FIXED_SIZE flag is on, only return whole blocks of
-	 * pseudo random data
-	 */
-	err = -EINVAL;
-	if (ctx->flags & PRNG_FIXED_SIZE) {
-		if (nbytes < DEFAULT_BLK_SZ)
-			goto done;
-		byte_count = DEFAULT_BLK_SZ;
-	}
-
 	err = byte_count;
 
 	dbgprint(KERN_CRIT "getting %d random bytes for context %p\n",
 		byte_count, ctx);
 
-
 remainder:
 	if (ctx->rand_read_pos == DEFAULT_BLK_SZ) {
 		if (_get_more_prng_bytes(ctx, do_cont_test) < 0) {
-- 
2.1.3
