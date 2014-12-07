From: George Spelvin <linux@horizon.com>
Subject: [PATCH v2 11/25] crypto: ansi_cprng - Eliminate unused PRNG_FIXED_SIZE flag
Date: Sun,  7 Dec 2014 07:26:19 -0500
Message-ID: <3b88d963e7feb8e2ea0a0cc6588b90b422f1896e.1417951990.git.linux@horizon.com>
References: <cover.1417951990.git.linux@horizon.com>
Cc: smueller@chronox.de, herbert@gondor.apana.org.au, linux@horizon.com
To: nhorman@tuxdriver.com, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:11414 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753214AbaLGM1H (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2014 07:27:07 -0500
In-Reply-To: <cover.1417951990.git.linux@horizon.com>
In-Reply-To: <cover.1417951990.git.linux@horizon.com>
References: <cover.1417951990.git.linux@horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

There's no way to set it, so it's dead code.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 crypto/ansi_cprng.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index 74ec151e..f6a1e987 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -30,8 +30,7 @@
  * Flags for the prng_context flags field
  */
 
-#define PRNG_FIXED_SIZE 0x1
-#define PRNG_NEED_RESET 0x2
+#define PRNG_NEED_RESET 0x1
 
 /*
  * Note: DT is our counter value
@@ -166,17 +165,6 @@ static int get_prng_bytes(u8 *buf, unsigned int nbytes,
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
-- 
2.1.3
