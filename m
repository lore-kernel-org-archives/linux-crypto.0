From: George Spelvin <linux@horizon.com>
Subject: [PATCH v2 08/25] crypto: ansi_cprng - Don't call reset_prng_context from cprng_init
Date: Sun,  7 Dec 2014 07:26:16 -0500
Message-ID: <a832d6925ae2a6a9443939dd43397428790113d5.1417951990.git.linux@horizon.com>
References: <cover.1417951990.git.linux@horizon.com>
Cc: smueller@chronox.de, herbert@gondor.apana.org.au, linux@horizon.com
To: nhorman@tuxdriver.com, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:39555 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753147AbaLGM07 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2014 07:26:59 -0500
In-Reply-To: <cover.1417951990.git.linux@horizon.com>
In-Reply-To: <cover.1417951990.git.linux@horizon.com>
References: <cover.1417951990.git.linux@horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The PRNG_NEEDS_RESET flag ensures that it will be called, so
reset_prng_context() no longer needs to support NULL key and V pointers.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 crypto/ansi_cprng.c | 47 ++++++++++++++---------------------------------
 1 file changed, 14 insertions(+), 33 deletions(-)

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index 022662d7..62b8f958 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -23,10 +23,8 @@
 
 #include "internal.h"
 
-#define DEFAULT_PRNG_KEY "0123456789abcdef"
 #define DEFAULT_PRNG_KSZ 16
 #define DEFAULT_BLK_SZ 16
-#define DEFAULT_V_SEED "zaybxcwdveuftgsh"
 
 /*
  * Flags for the prng_context flags field
@@ -250,41 +248,28 @@ static int reset_prng_context(struct prng_context *ctx,
 			      unsigned char *V, unsigned char *DT)
 {
 	int ret;
-	unsigned char *prng_key;
 
 	spin_lock_bh(&ctx->prng_lock);
 	ctx->flags |= PRNG_NEED_RESET;
-
-	prng_key = (key != NULL) ? key : (unsigned char *)DEFAULT_PRNG_KEY;
-
-	if (!key)
-		klen = DEFAULT_PRNG_KSZ;
-
-	if (V)
-		memcpy(ctx->V, V, DEFAULT_BLK_SZ);
-	else
-		memcpy(ctx->V, DEFAULT_V_SEED, DEFAULT_BLK_SZ);
-
-	if (DT)
-		memcpy(ctx->DT, DT, DEFAULT_BLK_SZ);
-	else
-		memset(ctx->DT, 0, DEFAULT_BLK_SZ);
-
-	memset(ctx->rand_data, 0, DEFAULT_BLK_SZ);
-
 	ctx->rand_data_valid = DEFAULT_BLK_SZ;
 
-	ret = crypto_cipher_setkey(ctx->tfm, prng_key, klen);
+	memset(ctx->rand_data, 0, DEFAULT_BLK_SZ);
+
+	if (!DT)
+		DT = ctx->rand_data;	/* Use all-zeros if NULL */
+
+	memcpy(ctx->DT, DT, DEFAULT_BLK_SZ);
+	memcpy(ctx->V, V, DEFAULT_BLK_SZ);
+
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
+
 	return ret;
 }
 
@@ -300,13 +285,9 @@ static int cprng_init(struct crypto_tfm *tfm)
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
