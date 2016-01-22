From: Stephan Mueller <sm@eperm.de>
Subject: [PATCH] crypto: drbg - remove FIPS 140-2 continuous test
Date: Fri, 22 Jan 2016 09:52:28 +0100
Message-ID: <1788690.PnFbicKICx@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto <linux-crypto@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:42288 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818AbcAVIxt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Jan 2016 03:53:49 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

the following patch is fully CAVS tested on 64 bit and 32 bit.

Note, this change cannot be made for random.c or ansi_cprng.c, unfortunately.

---8<---
The newly released FIPS 140-2 IG 9.8 specifies that for SP800-90A
compliant DRBGs, the FIPS 140-2 continuous random number generator test
is not required any more.

This patch removes the test and all associated data structures.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c         | 64 ---------------------------------------------------
 include/crypto/drbg.h |  4 ----
 2 files changed, 68 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index ab6ef1d..1b86310 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -220,48 +220,6 @@ static inline unsigned short drbg_sec_strength(drbg_flag_t flags)
 }
 
 /*
- * FIPS 140-2 continuous self test
- * The test is performed on the result of one round of the output
- * function. Thus, the function implicitly knows the size of the
- * buffer.
- *
- * @drbg DRBG handle
- * @buf output buffer of random data to be checked
- *
- * return:
- *	true on success
- *	false on error
- */
-static bool drbg_fips_continuous_test(struct drbg_state *drbg,
-				      const unsigned char *buf)
-{
-#ifdef CONFIG_CRYPTO_FIPS
-	int ret = 0;
-	/* skip test if we test the overall system */
-	if (list_empty(&drbg->test_data.list))
-		return true;
-	/* only perform test in FIPS mode */
-	if (0 == fips_enabled)
-		return true;
-	if (!drbg->fips_primed) {
-		/* Priming of FIPS test */
-		memcpy(drbg->prev, buf, drbg_blocklen(drbg));
-		drbg->fips_primed = true;
-		/* return false due to priming, i.e. another round is needed */
-		return false;
-	}
-	ret = memcmp(drbg->prev, buf, drbg_blocklen(drbg));
-	if (!ret)
-		panic("DRBG continuous self test failed\n");
-	memcpy(drbg->prev, buf, drbg_blocklen(drbg));
-	/* the test shall pass when the two compared values are not equal */
-	return ret != 0;
-#else
-	return true;
-#endif /* CONFIG_CRYPTO_FIPS */
-}
-
-/*
  * Convert an integer into a byte representation of this integer.
  * The byte representation is big-endian
  *
@@ -603,11 +561,6 @@ static int drbg_ctr_generate(struct drbg_state *drbg,
 		}
 		outlen = (drbg_blocklen(drbg) < (buflen - len)) ?
 			  drbg_blocklen(drbg) : (buflen - len);
-		if (!drbg_fips_continuous_test(drbg, drbg->scratchpad)) {
-			/* 10.2.1.5.2 step 6 */
-			crypto_inc(drbg->V, drbg_blocklen(drbg));
-			continue;
-		}
 		/* 10.2.1.5.2 step 4.3 */
 		memcpy(buf + len, drbg->scratchpad, outlen);
 		len += outlen;
@@ -733,8 +686,6 @@ static int drbg_hmac_generate(struct drbg_state *drbg,
 			return ret;
 		outlen = (drbg_blocklen(drbg) < (buflen - len)) ?
 			  drbg_blocklen(drbg) : (buflen - len);
-		if (!drbg_fips_continuous_test(drbg, drbg->V))
-			continue;
 
 		/* 10.1.2.5 step 4.2 */
 		memcpy(buf + len, drbg->V, outlen);
@@ -963,10 +914,6 @@ static int drbg_hash_hashgen(struct drbg_state *drbg,
 		}
 		outlen = (drbg_blocklen(drbg) < (buflen - len)) ?
 			  drbg_blocklen(drbg) : (buflen - len);
-		if (!drbg_fips_continuous_test(drbg, dst)) {
-			crypto_inc(src, drbg_statelen(drbg));
-			continue;
-		}
 		/* 10.1.1.4 step hashgen 4.2 */
 		memcpy(buf + len, dst, outlen);
 		len += outlen;
@@ -1201,11 +1148,6 @@ static inline void drbg_dealloc_state(struct drbg_state *drbg)
 	drbg->reseed_ctr = 0;
 	drbg->d_ops = NULL;
 	drbg->core = NULL;
-#ifdef CONFIG_CRYPTO_FIPS
-	kzfree(drbg->prev);
-	drbg->prev = NULL;
-	drbg->fips_primed = false;
-#endif
 }
 
 /*
@@ -1244,12 +1186,6 @@ static inline int drbg_alloc_state(struct drbg_state *drbg)
 	drbg->C = kmalloc(drbg_statelen(drbg), GFP_KERNEL);
 	if (!drbg->C)
 		goto err;
-#ifdef CONFIG_CRYPTO_FIPS
-	drbg->prev = kmalloc(drbg_blocklen(drbg), GFP_KERNEL);
-	if (!drbg->prev)
-		goto err;
-	drbg->fips_primed = false;
-#endif
 	/* scratchpad is only generated for CTR and Hash */
 	if (drbg->core->flags & DRBG_HMAC)
 		sb_size = 0;
diff --git a/include/crypto/drbg.h b/include/crypto/drbg.h
index 9756c70..d961b2b 100644
--- a/include/crypto/drbg.h
+++ b/include/crypto/drbg.h
@@ -117,10 +117,6 @@ struct drbg_state {
 	void *priv_data;	/* Cipher handle */
 	bool seeded;		/* DRBG fully seeded? */
 	bool pr;		/* Prediction resistance enabled? */
-#ifdef CONFIG_CRYPTO_FIPS
-	bool fips_primed;	/* Continuous test primed? */
-	unsigned char *prev;	/* FIPS 140-2 continuous test value */
-#endif
 	struct work_struct seed_work;	/* asynchronous seeding support */
 	struct crypto_rng *jent;
 	const struct drbg_state_ops *d_ops;
-- 
2.5.0
