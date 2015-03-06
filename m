From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH] crypto: RNGs must return 0 in success case
Date: Fri, 06 Mar 2015 08:26:31 +0100
Message-ID: <1936568.p0IkOmavk3@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: 'Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:36522 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932119AbbCFH0e (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 Mar 2015 02:26:34 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Change the RNGs to always return 0 in success case.

This patch ensures that seqiv.c works with RNGs other than krng. seqiv
expects that any return code other than 0 is an error. Without the
patch, rfc4106(gcm(aes)) will not work when using a DRBG or an ANSI
X9.31 RNG.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/ansi_cprng.c  | 6 +++++-
 crypto/drbg.c        | 7 ++++++-
 include/crypto/rng.h | 3 +--
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index 6f5bebc..765fe76 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -210,7 +210,11 @@ static int get_prng_bytes(char *buf, size_t nbytes, struct prng_context *ctx,
 		byte_count = DEFAULT_BLK_SZ;
 	}
 
-	err = byte_count;
+	/*
+	 * Return 0 in case of success as mandated by the kernel
+	 * crypto API interface definition.
+	 */
+	err = 0;
 
 	dbgprint(KERN_CRIT "getting %d random bytes for context %p\n",
 		byte_count, ctx);
diff --git a/crypto/drbg.c b/crypto/drbg.c
index 56c1d7e..b69409c 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1280,7 +1280,7 @@ static void drbg_restore_shadow(struct drbg_state *drbg,
  *	  as defined in SP800-90A. The additional input is mixed into
  *	  the state in addition to the pulled entropy.
  *
- * return: generated number of bytes
+ * return: 0 when all bytes are generated; < 0 in case of an error
  */
 static int drbg_generate(struct drbg_state *drbg,
 			 unsigned char *buf, unsigned int buflen,
@@ -1419,6 +1419,11 @@ static int drbg_generate(struct drbg_state *drbg,
 	}
 #endif
 
+	/*
+	 * All operations were successful, return 0 as mandated by
+	 * the kernel crypto API interface.
+	 */
+	len = 0;
 err:
 	shadow->d_ops->crypto_fini(shadow);
 	drbg_restore_shadow(drbg, &shadow);
diff --git a/include/crypto/rng.h b/include/crypto/rng.h
index a16fb10..6e28ea5 100644
--- a/include/crypto/rng.h
+++ b/include/crypto/rng.h
@@ -103,8 +103,7 @@ static inline void crypto_free_rng(struct crypto_rng *tfm)
  * This function fills the caller-allocated buffer with random numbers using the
  * random number generator referenced by the cipher handle.
  *
- * Return: > 0 function was successful and returns the number of generated
- *	   bytes; < 0 if an error occurred
+ * Return: 0 function was successful; < 0 if an error occurred
  */
 static inline int crypto_rng_get_bytes(struct crypto_rng *tfm,
 				       u8 *rdata, unsigned int dlen)
-- 
2.1.0
