From: "George Spelvin" <linux@horizon.com>
Subject: [PATCH 08/17] crypto: ansi_cprng - Require non-null key & V in reset_prng_context
Date: 2 Dec 2014 03:46:17 -0500
Message-ID: <20141202084617.18608.qmail@ns.horizon.com>
References: <20141202083314.17647.qmail@ns.horizon.com>
Cc: linux-crypto@vger.kernel.org, linux@horizon.com,
	smueller@chronox.de
To: herbert@gondor.apana.org.au, nhorman@tuxdriver.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:39243 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750991AbaLBIqS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Dec 2014 03:46:18 -0500
In-Reply-To: <20141202083314.17647.qmail@ns.horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The PRNG_NEED_RESET flag forces a call to reset_prng_context(), so there's
no need to include one in cprng_init() at all.  That allows considerable
simplification of reset_prng_context().

Signed-off-by: George Spelvin <linux@horizon.com>
---
 crypto/ansi_cprng.c | 34 ++++++++--------------------------
 1 file changed, 8 insertions(+), 26 deletions(-)

I'm worried someone may seriously object to leaving part of the
context uninitialized, but it definitely simplifies the code.
I'm quite interested in comments.

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index f40f54cd..dff27a7a 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -22,10 +22,8 @@
 
 #include "internal.h"
 
-#define DEFAULT_PRNG_KEY "0123456789abcdef"
 #define DEFAULT_PRNG_KSZ 16
 #define DEFAULT_BLK_SZ 16
-#define DEFAULT_V_SEED "zaybxcwdveuftgsh"
 
 /*
  * Flags for the prng_context flags field
@@ -254,24 +252,15 @@ static void free_prng_context(struct prng_context *ctx)
 }
 
 static int reset_prng_context(struct prng_context *ctx,
-			      unsigned char *key, size_t klen,
-			      unsigned char *V, unsigned char *DT)
+			      unsigned char const *key, size_t klen,
+			      unsigned char const *V, unsigned char const *DT)
 {
 	int ret;
-	unsigned char *prng_key;
 
 	spin_lock_bh(&ctx->prng_lock);
 	ctx->flags |= PRNG_NEED_RESET;
 
-	prng_key = (key != NULL) ? key : (unsigned char *)DEFAULT_PRNG_KEY;
-
-	if (!key)
-		klen = DEFAULT_PRNG_KSZ;
-
-	if (V)
-		memcpy(ctx->V, V, DEFAULT_BLK_SZ);
-	else
-		memcpy(ctx->V, DEFAULT_V_SEED, DEFAULT_BLK_SZ);
+	memcpy(ctx->V, V, DEFAULT_BLK_SZ);
 
 	if (DT)
 		memcpy(ctx->DT, DT, DEFAULT_BLK_SZ);
@@ -282,16 +271,13 @@ static int reset_prng_context(struct prng_context *ctx,
 
 	ctx->rand_read_pos = DEFAULT_BLK_SZ;	/* Force immediate refill */
 
-	ret = crypto_cipher_setkey(ctx->tfm, prng_key, klen);
+	ret = crypto_cipher_setkey(ctx->tfm, key, klen);
 	if (ret) {
 		dbgprint(KERN_CRIT "PRNG: setkey() failed flags=%x\n",
 			crypto_cipher_get_flags(ctx->tfm));
-		goto out;
+	} else {
+		ctx->flags &= ~PRNG_NEED_RESET;
 	}
-
-	ret = 0;
-	ctx->flags &= ~PRNG_NEED_RESET;
-out:
 	spin_unlock_bh(&ctx->prng_lock);
 	return ret;
 }
@@ -308,13 +294,9 @@ static int cprng_init(struct crypto_tfm *tfm)
 		return PTR_ERR(ctx->tfm);
 	}
 
-	if (reset_prng_context(ctx, NULL, DEFAULT_PRNG_KSZ, NULL, NULL) < 0)
-		return -EINVAL;
-
 	/*
-	 * after allocation, we should always force the user to reset
-	 * so they don't inadvertently use the insecure default values
-	 * without specifying them intentially
+	 * After allocation, we always force the user to reset, which
+	 * completes initialization of the context.
 	 */
 	ctx->flags |= PRNG_NEED_RESET;
 	return 0;
-- 
2.1.3
