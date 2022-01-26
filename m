Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20BF4C63686
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Jan 2022 07:07:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237569AbiAZHHa (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Jan 2022 02:07:30 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.82]:42143 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237567AbiAZHH2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Jan 2022 02:07:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1643180842;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=cCB2fmWYlFXySacF9soKSUtojjqAlOvUGhKoMAxqYXc=;
    b=BhsCb0RTCBiflBUJpMt7fPjZTD2EK4KSJztPk9G9ZNCBSR7aY6vIRXnI/OUoePUGco
    9L5G9wGHJjvVWmCnCVy195E7dTCPSRsI9oAkmXhnyYLEO3cpg4iYEz1TzCaA6MT/iCvD
    CnDJJsyVSOxr5oQW+CBpa7yi+NmKuW3oEoEZpLINiXPgnE6h6ypNskLkuXGVrTI2msOd
    ELapUM0agsgat//q5GbUr8Kk6PE2v2Y27iB3TFZCUBNR0CR7UgIWXoWNhTp1LxR14Uo7
    gL7IVf3TNBtcY5SSVZu++Q3zFDAvUzmLYnZVq9IXqdUzCRFpxOzOD4E1QhKP2mkS0k91
    idTQ==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaJvScdWrN"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.38.0 DYNA|AUTH)
    with ESMTPSA id v5f65ay0Q77MiuS
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 26 Jan 2022 08:07:22 +0100 (CET)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, simo@redhat.com,
        Nicolai Stange <nstange@suse.de>
Subject: [PATCH 1/7] crypto: DRBG - remove internal reseeding operation
Date:   Wed, 26 Jan 2022 08:03:16 +0100
Message-ID: <2450379.h6RI2rZIcs@positron.chronox.de>
In-Reply-To: <2486550.t9SDvczpPo@positron.chronox.de>
References: <2486550.t9SDvczpPo@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The DRBG's internal seeding support is completely removed. When
initializing the DRBG, it is now completely unseeded. The caller must
provide the seed data and perform the reseeding as needed using the
standard API of crypto_rng_reset.

The seeding and reseeding is a security-critical task which is provided
with a separate framework, the entropy source and DRNG manager (ESDM).
When using the ESDM, the DRBG may be integrated to offer a fully seeded
DRBG. The output of the ESDM in this case is generated from the DRBG,
but the ESDM ensures the DRBG is appropriately seeded and reseeded.

The change removes the "prediction resistance" variants of the DRBG.
Those variants would cause the DRBG to constantly reseed from the
entropy sources. As the seeding is appropriately performed by the ESDM,
the prediction resistance variants are not needed.

Due to the limitations of the kernel crypto API RNG framework, adding a
personalization string is not supported during initial seeding. In
addition, providing an additional information string during reseeding is
not supported by the DRBG. If a user wants to still apply either string,
the caller must concatenate it to the seed that is submitted to the
DRBG. Yet, using an additional information string during the
generation of random numbers is supported. The patch implies that the
DRBG fully complies with the kernel crypto API RNG framework interfaces.
All auxiliary interfaces are removed.

The change also simplifies the drbg_instantiate function: the resolution
of the coreref is now performed in the drbg_instantiate function as it
is only needed during initial seeding. Subsequent reseeding operations
flowing through this function do not need to perform this resolution.

The DRBG code now rejects the initial instantiation with an empty seed
buffer. An empty seed buffer during initial instantiation implies that
the DRBG will not be seeded and does not have any internal state based
on seed. Thus, a crypto_rng_reset(tfm, NULL, 0) immediately after an
crypto_alloc_rng() will now fail.

In addition, the patch removes FIPS 140-2 continuous test as its
more sane equivalent is handled by the ESDM by applying a proper health
test to the entropy sources that deliver entropy.

The change is validated with the NIST ACVP reference implementation. The
testing covered:

- Hash DRBG with SHA-1, SHA-256, SHA-384, SHA-512

- HMAC DRBG with SHA-1, SHA-256, SHA-384, SHA-512

- CTR DRBG with AES-128, AES-192, AES-256

- reseeding, but without additional information

- no reseeding, but with additional information

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/algif_rng.c    |   3 +-
 crypto/drbg.c         | 640 ++++++++---------------------------------
 crypto/testmgr.c      |  96 +------
 crypto/testmgr.h      | 641 +-----------------------------------------
 include/crypto/drbg.h |  84 ------
 5 files changed, 140 insertions(+), 1324 deletions(-)

diff --git a/crypto/algif_rng.c b/crypto/algif_rng.c
index 407408c43730..b204f1427542 100644
--- a/crypto/algif_rng.c
+++ b/crypto/algif_rng.c
@@ -305,7 +305,8 @@ static int __maybe_unused rng_setentropy(void *private, sockptr_t entropy,
 			return PTR_ERR(kentropy);
 	}
 
-	crypto_rng_alg(pctx->drng)->set_ent(pctx->drng, kentropy, len);
+	if (crypto_rng_alg(pctx->drng)->set_ent)
+		crypto_rng_alg(pctx->drng)->set_ent(pctx->drng, kentropy, len);
 	/*
 	 * Since rng doesn't perform any memory management for the entropy
 	 * buffer, save kentropy pointer to pctx now to free it after use.
diff --git a/crypto/drbg.c b/crypto/drbg.c
index 177983b6ae38..67d9fef1af2a 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -7,7 +7,7 @@
  *		* HMAC DRBG with DF with SHA-1, SHA-256, SHA-384, SHA-512 cores
  *		* with and without prediction resistance
  *
- * Copyright Stephan Mueller <smueller@chronox.de>, 2014
+ * Copyright Stephan Mueller <smueller@chronox.de>, 2014 - 2022
  *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
@@ -43,10 +43,10 @@
  *
  * DRBG Usage
  * ==========
- * The SP 800-90A DRBG allows the user to specify a personalization string
- * for initialization as well as an additional information string for each
- * random number request. The following code fragments show how a caller
- * uses the kernel crypto API to use the full functionality of the DRBG.
+ * The SP 800-90A DRBG allows the user to specify an additional information
+ * string for each random number request. The following code fragments show how
+ * a caller uses the kernel crypto API to use the full functionality of the
+ * DRBG.
  *
  * Usage without any additional data
  * ---------------------------------
@@ -55,25 +55,22 @@
  * char data[DATALEN];
  *
  * drng = crypto_alloc_rng(drng_name, 0, 0);
+ * // The reset initializes the DRBG with the provided seed string
+ * err = crypto_rng_reset(drng, &seed, strlen(seed));
  * err = crypto_rng_get_bytes(drng, &data, DATALEN);
  * crypto_free_rng(drng);
  *
  *
  * Usage with personalization string during initialization
  * -------------------------------------------------------
- * struct crypto_rng *drng;
- * int err;
- * char data[DATALEN];
- * struct drbg_string pers;
- * char personalization[11] = "some-string";
+ * This is not supported internally. If you want to use a personalization
+ * string during seeding, concatenate it at the end of the seed.
  *
- * drbg_string_fill(&pers, personalization, strlen(personalization));
- * drng = crypto_alloc_rng(drng_name, 0, 0);
- * // The reset completely re-initializes the DRBG with the provided
- * // personalization string
- * err = crypto_rng_reset(drng, &personalization, strlen(personalization));
- * err = crypto_rng_get_bytes(drng, &data, DATALEN);
- * crypto_free_rng(drng);
+ *
+ * Usage with additional information during reseeding
+ * --------------------------------------------------
+ * This is not supported internally. If you want to use an additional
+ * string during reseeding, concatenate it at the end of the reseed.
  *
  *
  * Usage with additional information string during random number request
@@ -81,20 +78,17 @@
  * struct crypto_rng *drng;
  * int err;
  * char data[DATALEN];
+ * char addtlbuf[ADDTLLEN];
  * char addtl_string[11] = "some-string";
- * string drbg_string addtl;
  *
  * drbg_string_fill(&addtl, addtl_string, strlen(addtl_string));
  * drng = crypto_alloc_rng(drng_name, 0, 0);
+ * // The reset initializes the DRBG with the provided seed string
+ * err = crypto_rng_reset(drng, &seed, strlen(seed));
  * // The following call is a wrapper to crypto_rng_get_bytes() and returns
  * // the same error codes.
- * err = crypto_drbg_get_bytes_addtl(drng, &data, DATALEN, &addtl);
+ * err = crypto_rng_generate(drng, addtlbuf, ADDTLLEN, &data, DATALEN, &addtl);
  * crypto_free_rng(drng);
- *
- *
- * Usage with personalization and additional information strings
- * -------------------------------------------------------------
- * Just mix both scenarios above.
  */
 
 #include <crypto/drbg.h>
@@ -221,57 +215,6 @@ static inline unsigned short drbg_sec_strength(drbg_flag_t flags)
 	}
 }
 
-/*
- * FIPS 140-2 continuous self test for the noise source
- * The test is performed on the noise source input data. Thus, the function
- * implicitly knows the size of the buffer to be equal to the security
- * strength.
- *
- * Note, this function disregards the nonce trailing the entropy data during
- * initial seeding.
- *
- * drbg->drbg_mutex must have been taken.
- *
- * @drbg DRBG handle
- * @entropy buffer of seed data to be checked
- *
- * return:
- *	0 on success
- *	-EAGAIN on when the CTRNG is not yet primed
- *	< 0 on error
- */
-static int drbg_fips_continuous_test(struct drbg_state *drbg,
-				     const unsigned char *entropy)
-{
-	unsigned short entropylen = drbg_sec_strength(drbg->core->flags);
-	int ret = 0;
-
-	if (!IS_ENABLED(CONFIG_CRYPTO_FIPS))
-		return 0;
-
-	/* skip test if we test the overall system */
-	if (list_empty(&drbg->test_data.list))
-		return 0;
-	/* only perform test in FIPS mode */
-	if (!fips_enabled)
-		return 0;
-
-	if (!drbg->fips_primed) {
-		/* Priming of FIPS test */
-		memcpy(drbg->prev, entropy, entropylen);
-		drbg->fips_primed = true;
-		/* priming: another round is needed */
-		return -EAGAIN;
-	}
-	ret = memcmp(drbg->prev, entropy, entropylen);
-	if (!ret)
-		panic("DRBG continuous self test failed\n");
-	memcpy(drbg->prev, entropy, entropylen);
-
-	/* the test shall pass when the two values are not equal */
-	return 0;
-}
-
 /*
  * Convert an integer into a byte representation of this integer.
  * The byte representation is big-endian
@@ -298,11 +241,8 @@ static inline void drbg_cpu_to_be32(__u32 val, unsigned char *buf)
 
 #ifdef CONFIG_CRYPTO_DRBG_CTR
 #define CRYPTO_DRBG_CTR_STRING "CTR "
-MODULE_ALIAS_CRYPTO("drbg_pr_ctr_aes256");
 MODULE_ALIAS_CRYPTO("drbg_nopr_ctr_aes256");
-MODULE_ALIAS_CRYPTO("drbg_pr_ctr_aes192");
 MODULE_ALIAS_CRYPTO("drbg_nopr_ctr_aes192");
-MODULE_ALIAS_CRYPTO("drbg_pr_ctr_aes128");
 MODULE_ALIAS_CRYPTO("drbg_nopr_ctr_aes128");
 
 static void drbg_kcapi_symsetkey(struct drbg_state *drbg,
@@ -642,13 +582,9 @@ static int drbg_fini_hash_kernel(struct drbg_state *drbg);
 
 #ifdef CONFIG_CRYPTO_DRBG_HMAC
 #define CRYPTO_DRBG_HMAC_STRING "HMAC "
-MODULE_ALIAS_CRYPTO("drbg_pr_hmac_sha512");
 MODULE_ALIAS_CRYPTO("drbg_nopr_hmac_sha512");
-MODULE_ALIAS_CRYPTO("drbg_pr_hmac_sha384");
 MODULE_ALIAS_CRYPTO("drbg_nopr_hmac_sha384");
-MODULE_ALIAS_CRYPTO("drbg_pr_hmac_sha256");
 MODULE_ALIAS_CRYPTO("drbg_nopr_hmac_sha256");
-MODULE_ALIAS_CRYPTO("drbg_pr_hmac_sha1");
 MODULE_ALIAS_CRYPTO("drbg_nopr_hmac_sha1");
 
 /* update function of HMAC DRBG as defined in 10.1.2.2 */
@@ -762,13 +698,9 @@ static const struct drbg_state_ops drbg_hmac_ops = {
 
 #ifdef CONFIG_CRYPTO_DRBG_HASH
 #define CRYPTO_DRBG_HASH_STRING "HASH "
-MODULE_ALIAS_CRYPTO("drbg_pr_sha512");
 MODULE_ALIAS_CRYPTO("drbg_nopr_sha512");
-MODULE_ALIAS_CRYPTO("drbg_pr_sha384");
 MODULE_ALIAS_CRYPTO("drbg_nopr_sha384");
-MODULE_ALIAS_CRYPTO("drbg_pr_sha256");
 MODULE_ALIAS_CRYPTO("drbg_nopr_sha256");
-MODULE_ALIAS_CRYPTO("drbg_pr_sha1");
 MODULE_ALIAS_CRYPTO("drbg_nopr_sha1");
 
 /*
@@ -1036,221 +968,6 @@ static const struct drbg_state_ops drbg_hash_ops = {
  * Functions common for DRBG implementations
  ******************************************************************/
 
-static inline int __drbg_seed(struct drbg_state *drbg, struct list_head *seed,
-			      int reseed, enum drbg_seed_state new_seed_state)
-{
-	int ret = drbg->d_ops->update(drbg, seed, reseed);
-
-	if (ret)
-		return ret;
-
-	drbg->seeded = new_seed_state;
-	drbg->last_seed_time = jiffies;
-	/* 10.1.1.2 / 10.1.1.3 step 5 */
-	drbg->reseed_ctr = 1;
-
-	switch (drbg->seeded) {
-	case DRBG_SEED_STATE_UNSEEDED:
-		/* Impossible, but handle it to silence compiler warnings. */
-		fallthrough;
-	case DRBG_SEED_STATE_PARTIAL:
-		/*
-		 * Require frequent reseeds until the seed source is
-		 * fully initialized.
-		 */
-		drbg->reseed_threshold = 50;
-		break;
-
-	case DRBG_SEED_STATE_FULL:
-		/*
-		 * Seed source has become fully initialized, frequent
-		 * reseeds no longer required.
-		 */
-		drbg->reseed_threshold = drbg_max_requests(drbg);
-		break;
-	}
-
-	return ret;
-}
-
-static inline int drbg_get_random_bytes(struct drbg_state *drbg,
-					unsigned char *entropy,
-					unsigned int entropylen)
-{
-	int ret;
-
-	do {
-		get_random_bytes(entropy, entropylen);
-		ret = drbg_fips_continuous_test(drbg, entropy);
-		if (ret && ret != -EAGAIN)
-			return ret;
-	} while (ret);
-
-	return 0;
-}
-
-static int drbg_seed_from_random(struct drbg_state *drbg)
-{
-	struct drbg_string data;
-	LIST_HEAD(seedlist);
-	unsigned int entropylen = drbg_sec_strength(drbg->core->flags);
-	unsigned char entropy[32];
-	int ret;
-
-	BUG_ON(!entropylen);
-	BUG_ON(entropylen > sizeof(entropy));
-
-	drbg_string_fill(&data, entropy, entropylen);
-	list_add_tail(&data.list, &seedlist);
-
-	ret = drbg_get_random_bytes(drbg, entropy, entropylen);
-	if (ret)
-		goto out;
-
-	ret = __drbg_seed(drbg, &seedlist, true, DRBG_SEED_STATE_FULL);
-
-out:
-	memzero_explicit(entropy, entropylen);
-	return ret;
-}
-
-static bool drbg_nopr_reseed_interval_elapsed(struct drbg_state *drbg)
-{
-	unsigned long next_reseed;
-
-	/* Don't ever reseed from get_random_bytes() in test mode. */
-	if (list_empty(&drbg->test_data.list))
-		return false;
-
-	/*
-	 * Obtain fresh entropy for the nopr DRBGs after 300s have
-	 * elapsed in order to still achieve sort of partial
-	 * prediction resistance over the time domain at least. Note
-	 * that the period of 300s has been chosen to match the
-	 * CRNG_RESEED_INTERVAL of the get_random_bytes()' chacha
-	 * rngs.
-	 */
-	next_reseed = drbg->last_seed_time + 300 * HZ;
-	return time_after(jiffies, next_reseed);
-}
-
-/*
- * Seeding or reseeding of the DRBG
- *
- * @drbg: DRBG state struct
- * @pers: personalization / additional information buffer
- * @reseed: 0 for initial seed process, 1 for reseeding
- *
- * return:
- *	0 on success
- *	error value otherwise
- */
-static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
-		     bool reseed)
-{
-	int ret;
-	unsigned char entropy[((32 + 16) * 2)];
-	unsigned int entropylen = drbg_sec_strength(drbg->core->flags);
-	struct drbg_string data1;
-	LIST_HEAD(seedlist);
-	enum drbg_seed_state new_seed_state = DRBG_SEED_STATE_FULL;
-
-	/* 9.1 / 9.2 / 9.3.1 step 3 */
-	if (pers && pers->len > (drbg_max_addtl(drbg))) {
-		pr_devel("DRBG: personalization string too long %zu\n",
-			 pers->len);
-		return -EINVAL;
-	}
-
-	if (list_empty(&drbg->test_data.list)) {
-		drbg_string_fill(&data1, drbg->test_data.buf,
-				 drbg->test_data.len);
-		pr_devel("DRBG: using test entropy\n");
-	} else {
-		/*
-		 * Gather entropy equal to the security strength of the DRBG.
-		 * With a derivation function, a nonce is required in addition
-		 * to the entropy. A nonce must be at least 1/2 of the security
-		 * strength of the DRBG in size. Thus, entropy + nonce is 3/2
-		 * of the strength. The consideration of a nonce is only
-		 * applicable during initial seeding.
-		 */
-		BUG_ON(!entropylen);
-		if (!reseed)
-			entropylen = ((entropylen + 1) / 2) * 3;
-		BUG_ON((entropylen * 2) > sizeof(entropy));
-
-		/* Get seed from in-kernel /dev/urandom */
-		if (!rng_is_initialized())
-			new_seed_state = DRBG_SEED_STATE_PARTIAL;
-
-		ret = drbg_get_random_bytes(drbg, entropy, entropylen);
-		if (ret)
-			goto out;
-
-		if (!drbg->jent) {
-			drbg_string_fill(&data1, entropy, entropylen);
-			pr_devel("DRBG: (re)seeding with %u bytes of entropy\n",
-				 entropylen);
-		} else {
-			/*
-			 * Get seed from Jitter RNG, failures are
-			 * fatal only in FIPS mode.
-			 */
-			ret = crypto_rng_get_bytes(drbg->jent,
-						   entropy + entropylen,
-						   entropylen);
-			if (fips_enabled && ret) {
-				pr_devel("DRBG: jent failed with %d\n", ret);
-
-				/*
-				 * Do not treat the transient failure of the
-				 * Jitter RNG as an error that needs to be
-				 * reported. The combined number of the
-				 * maximum reseed threshold times the maximum
-				 * number of Jitter RNG transient errors is
-				 * less than the reseed threshold required by
-				 * SP800-90A allowing us to treat the
-				 * transient errors as such.
-				 *
-				 * However, we mandate that at least the first
-				 * seeding operation must succeed with the
-				 * Jitter RNG.
-				 */
-				if (!reseed || ret != -EAGAIN)
-					goto out;
-			}
-
-			drbg_string_fill(&data1, entropy, entropylen * 2);
-			pr_devel("DRBG: (re)seeding with %u bytes of entropy\n",
-				 entropylen * 2);
-		}
-	}
-	list_add_tail(&data1.list, &seedlist);
-
-	/*
-	 * concatenation of entropy with personalization str / addtl input)
-	 * the variable pers is directly handed in by the caller, so check its
-	 * contents whether it is appropriate
-	 */
-	if (pers && pers->buf && 0 < pers->len) {
-		list_add_tail(&pers->list, &seedlist);
-		pr_devel("DRBG: using personalization string\n");
-	}
-
-	if (!reseed) {
-		memset(drbg->V, 0, drbg_statelen(drbg));
-		memset(drbg->C, 0, drbg_statelen(drbg));
-	}
-
-	ret = __drbg_seed(drbg, &seedlist, reseed, new_seed_state);
-
-out:
-	memzero_explicit(entropy, entropylen * 2);
-
-	return ret;
-}
-
 /* Free all substructures in a DRBG state without the DRBG state structure */
 static inline void drbg_dealloc_state(struct drbg_state *drbg)
 {
@@ -1267,11 +984,6 @@ static inline void drbg_dealloc_state(struct drbg_state *drbg)
 	drbg->reseed_ctr = 0;
 	drbg->d_ops = NULL;
 	drbg->core = NULL;
-	if (IS_ENABLED(CONFIG_CRYPTO_FIPS)) {
-		kfree_sensitive(drbg->prev);
-		drbg->prev = NULL;
-		drbg->fips_primed = false;
-	}
 }
 
 /*
@@ -1314,12 +1026,14 @@ static inline int drbg_alloc_state(struct drbg_state *drbg)
 		goto fini;
 	}
 	drbg->V = PTR_ALIGN(drbg->Vbuf, ret + 1);
+	memset(drbg->V, 0, drbg_statelen(drbg));
 	drbg->Cbuf = kmalloc(drbg_statelen(drbg) + ret, GFP_KERNEL);
 	if (!drbg->Cbuf) {
 		ret = -ENOMEM;
 		goto fini;
 	}
 	drbg->C = PTR_ALIGN(drbg->Cbuf, ret + 1);
+	memset(drbg->C, 0, drbg_statelen(drbg));
 	/* scratchpad is only generated for CTR and Hash */
 	if (drbg->core->flags & DRBG_HMAC)
 		sb_size = 0;
@@ -1341,16 +1055,6 @@ static inline int drbg_alloc_state(struct drbg_state *drbg)
 		drbg->scratchpad = PTR_ALIGN(drbg->scratchpadbuf, ret + 1);
 	}
 
-	if (IS_ENABLED(CONFIG_CRYPTO_FIPS)) {
-		drbg->prev = kzalloc(drbg_sec_strength(drbg->core->flags),
-				     GFP_KERNEL);
-		if (!drbg->prev) {
-			ret = -ENOMEM;
-			goto fini;
-		}
-		drbg->fips_primed = false;
-	}
-
 	return 0;
 
 fini:
@@ -1419,40 +1123,18 @@ static int drbg_generate(struct drbg_state *drbg,
 	/* 9.3.1 step 5 is implicit with the chosen DRBG */
 
 	/*
-	 * 9.3.1 step 6 and 9 supplemented by 9.3.2 step c is implemented
-	 * here. The spec is a bit convoluted here, we make it simpler.
+	 * 9.3.1 step 6 and 9 supplemented by 9.3.2 step c - the reseeding if
+	 * too much data is pulled - is not implemented here but must be
+	 * provided by the caller (e.g. the ESDM).
 	 */
-	if (drbg->reseed_threshold < drbg->reseed_ctr)
-		drbg->seeded = DRBG_SEED_STATE_UNSEEDED;
-
-	if (drbg->pr || drbg->seeded == DRBG_SEED_STATE_UNSEEDED) {
-		pr_devel("DRBG: reseeding before generation (prediction "
-			 "resistance: %s, state %s)\n",
-			 drbg->pr ? "true" : "false",
-			 (drbg->seeded ==  DRBG_SEED_STATE_FULL ?
-			  "seeded" : "unseeded"));
-		/* 9.3.1 steps 7.1 through 7.3 */
-		len = drbg_seed(drbg, addtl, true);
-		if (len)
-			goto err;
-		/* 9.3.1 step 7.4 */
-		addtl = NULL;
-	} else if (rng_is_initialized() &&
-		   (drbg->seeded == DRBG_SEED_STATE_PARTIAL ||
-		    drbg_nopr_reseed_interval_elapsed(drbg))) {
-		len = drbg_seed_from_random(drbg);
-		if (len)
-			goto err;
-	}
 
 	if (addtl && 0 < addtl->len)
 		list_add_tail(&addtl->list, &addtllist);
 	/* 9.3.1 step 8 and 10 */
 	len = drbg->d_ops->generate(drbg, buf, buflen, &addtllist);
-
 	/* 10.1.1.4 step 6, 10.1.2.5 step 7, 10.2.1.5.2 step 7 */
 	drbg->reseed_ctr++;
-	if (0 >= len)
+	if (len < 0)
 		goto err;
 
 	/*
@@ -1475,14 +1157,14 @@ static int drbg_generate(struct drbg_state *drbg,
 		int err = 0;
 		pr_devel("DRBG: start to perform self test\n");
 		if (drbg->core->flags & DRBG_HMAC)
-			err = alg_test("drbg_pr_hmac_sha256",
-				       "drbg_pr_hmac_sha256", 0, 0);
+			err = alg_test("drbg_nopr_hmac_sha256",
+				       "drbg_nopr_hmac_sha256", 0, 0);
 		else if (drbg->core->flags & DRBG_CTR)
-			err = alg_test("drbg_pr_ctr_aes128",
-				       "drbg_pr_ctr_aes128", 0, 0);
+			err = alg_test("drbg_nopr_ctr_aes128",
+				       "drbg_nopr_ctr_aes128", 0, 0);
 		else
-			err = alg_test("drbg_pr_sha256",
-				       "drbg_pr_sha256", 0, 0);
+			err = alg_test("drbg_nopr_sha256",
+				       "drbg_nopr_sha256", 0, 0);
 		if (err) {
 			pr_err("DRBG: periodical self test failed\n");
 			/*
@@ -1535,96 +1217,123 @@ static int drbg_generate_long(struct drbg_state *drbg,
 	return 0;
 }
 
-static int drbg_prepare_hrng(struct drbg_state *drbg)
+/*
+ * Seeding or reseeding of the DRBG
+ *
+ * @drbg: DRBG state struct
+ * @pers: personalization / additional information buffer
+ * @reseed: 0 for initial seed process, 1 for reseeding
+ *
+ * return:
+ *	0 on success
+ *	error value otherwise
+ */
+static int drbg_seed(struct drbg_state *drbg, struct list_head *seed,
+		     int reseed)
 {
-	/* We do not need an HRNG in test mode. */
-	if (list_empty(&drbg->test_data.list))
-		return 0;
+	int ret = drbg->d_ops->update(drbg, seed, reseed);
 
-	drbg->jent = crypto_alloc_rng("jitterentropy_rng", 0, 0);
-	if (IS_ERR(drbg->jent)) {
-		const int err = PTR_ERR(drbg->jent);
+	if (ret)
+		return ret;
 
-		drbg->jent = NULL;
-		if (fips_enabled || err != -ENOENT)
-			return err;
-		pr_info("DRBG: Continuing without Jitter RNG\n");
-	}
+	/* 10.1.1.2 / 10.1.1.3 step 5 */
+	drbg->reseed_ctr = 1;
 
-	return 0;
+	return ret;
+}
+
+/*
+ * Look up the DRBG flags by given kernel crypto API cra_name
+ * The code uses the drbg_cores definition to do this
+ *
+ * @cra_name kernel crypto API cra_name
+ * @coreref reference to integer which is filled with the pointer to
+ *  the applicable core
+ */
+static inline int drbg_convert_tfm_core(const char *cra_driver_name,
+					int *coreref)
+{
+	int i = 0, len = 0;
+
+	len = strlen(cra_driver_name);
+	if (len < 10)
+		return -ENOENT;
+	len -= 10;
+
+	/* disassemble the name */
+	if (memcmp(cra_driver_name, "drbg_nopr_", 10))
+		return -ENOENT;
+
+	/* remove the first part */
+	for (i = 0; ARRAY_SIZE(drbg_cores) > i; i++) {
+		if (!memcmp(cra_driver_name + 10, drbg_cores[i].cra_name,
+			    len)) {
+			*coreref = i;
+			return 0;
+		}
+	}
+	return -ENOENT;
 }
 
 /*
  * DRBG instantiation function as required by SP800-90A - this function
- * sets up the DRBG handle, performs the initial seeding and all sanity
- * checks required by SP800-90A
+ * sets up the DRBG handle if needed and seeds the DRBG with entropy. If the
+ * DRBG is already instantiated, the DRBG is simply reseeded.
  *
- * @drbg memory of state -- if NULL, new memory is allocated
- * @pers Personalization string that is mixed into state, may be NULL -- note
- *	 the entropy is pulled by the DRBG internally unconditionally
- *	 as defined in SP800-90A. The additional input is mixed into
- *	 the state in addition to the pulled entropy.
- * @coreref reference to core
- * @pr prediction resistance enabled
+ * @tfm: tfm cipher handle with DRBG state (may be uninitialized)
+ * @seed: buffer with the entropy data to (re)seed the DRBG
+ * @slen: length of seed buffer
  *
  * return
  *	0 on success
  *	error value otherwise
  */
-static int drbg_instantiate(struct drbg_state *drbg, struct drbg_string *pers,
-			    int coreref, bool pr)
+static int drbg_instantiate(struct crypto_rng *tfm,
+			    const u8 *seed, unsigned int slen)
 {
+	struct drbg_state *drbg = crypto_rng_ctx(tfm);
+	struct drbg_string seeddata;
+	LIST_HEAD(seedlist);
 	int ret;
 	bool reseed = true;
 
-	pr_devel("DRBG: Initializing DRBG core %d with prediction resistance "
-		 "%s\n", coreref, pr ? "enabled" : "disabled");
+	drbg_string_fill(&seeddata, seed, slen);
+	list_add_tail(&seeddata.list, &seedlist);
+
 	mutex_lock(&drbg->drbg_mutex);
 
 	/* 9.1 step 1 is implicit with the selected DRBG type */
-
-	/*
-	 * 9.1 step 2 is implicit as caller can select prediction resistance
-	 * and the flag is copied into drbg->flags --
-	 * all DRBG types support prediction resistance
-	 */
-
+	/* 9.1 step 2 is implicit as no prediction resistance is supported */
 	/* 9.1 step 4 is implicit in  drbg_sec_strength */
 
 	if (!drbg->core) {
+		struct crypto_tfm *tfm_base = crypto_rng_tfm(tfm);
+		int coreref = 0;
+
+		if (!slen) {
+			pr_warn("DRBG: initial seed missing\n");
+			return -EINVAL;
+		}
+
+		pr_devel("DRBG: Initializing DRBG core %d\n", coreref);
+		ret = drbg_convert_tfm_core(
+			crypto_tfm_alg_driver_name(tfm_base), &coreref);
+		if (ret)
+			return ret;
 		drbg->core = &drbg_cores[coreref];
-		drbg->pr = pr;
-		drbg->seeded = DRBG_SEED_STATE_UNSEEDED;
-		drbg->last_seed_time = 0;
-		drbg->reseed_threshold = drbg_max_requests(drbg);
 
 		ret = drbg_alloc_state(drbg);
 		if (ret)
 			goto unlock;
 
-		ret = drbg_prepare_hrng(drbg);
-		if (ret)
-			goto free_everything;
-
 		reseed = false;
 	}
 
-	ret = drbg_seed(drbg, pers, reseed);
-
-	if (ret && !reseed)
-		goto free_everything;
-
-	mutex_unlock(&drbg->drbg_mutex);
-	return ret;
+	ret = drbg_seed(drbg, &seedlist, reseed);
 
 unlock:
 	mutex_unlock(&drbg->drbg_mutex);
 	return ret;
-
-free_everything:
-	mutex_unlock(&drbg->drbg_mutex);
-	drbg_uninstantiate(drbg);
-	return ret;
 }
 
 /*
@@ -1638,34 +1347,12 @@ static int drbg_instantiate(struct drbg_state *drbg, struct drbg_string *pers,
  */
 static int drbg_uninstantiate(struct drbg_state *drbg)
 {
-	if (!IS_ERR_OR_NULL(drbg->jent))
-		crypto_free_rng(drbg->jent);
-	drbg->jent = NULL;
-
 	if (drbg->d_ops)
 		drbg->d_ops->crypto_fini(drbg);
 	drbg_dealloc_state(drbg);
-	/* no scrubbing of test_data -- this shall survive an uninstantiate */
 	return 0;
 }
 
-/*
- * Helper function for setting the test data in the DRBG
- *
- * @drbg DRBG state handle
- * @data test data
- * @len test data length
- */
-static void drbg_kcapi_set_entropy(struct crypto_rng *tfm,
-				   const u8 *data, unsigned int len)
-{
-	struct drbg_state *drbg = crypto_rng_ctx(tfm);
-
-	mutex_lock(&drbg->drbg_mutex);
-	drbg_string_fill(&drbg->test_data, data, len);
-	mutex_unlock(&drbg->drbg_mutex);
-}
-
 /***************************************************************
  * Kernel crypto API cipher invocations requested by DRBG
  ***************************************************************/
@@ -1884,46 +1571,6 @@ static int drbg_kcapi_sym_ctr(struct drbg_state *drbg,
  * Kernel crypto API interface to register DRBG
  ***************************************************************/
 
-/*
- * Look up the DRBG flags by given kernel crypto API cra_name
- * The code uses the drbg_cores definition to do this
- *
- * @cra_name kernel crypto API cra_name
- * @coreref reference to integer which is filled with the pointer to
- *  the applicable core
- * @pr reference for setting prediction resistance
- *
- * return: flags
- */
-static inline void drbg_convert_tfm_core(const char *cra_driver_name,
-					 int *coreref, bool *pr)
-{
-	int i = 0;
-	size_t start = 0;
-	int len = 0;
-
-	*pr = true;
-	/* disassemble the names */
-	if (!memcmp(cra_driver_name, "drbg_nopr_", 10)) {
-		start = 10;
-		*pr = false;
-	} else if (!memcmp(cra_driver_name, "drbg_pr_", 8)) {
-		start = 8;
-	} else {
-		return;
-	}
-
-	/* remove the first part */
-	len = strlen(cra_driver_name) - start;
-	for (i = 0; ARRAY_SIZE(drbg_cores) > i; i++) {
-		if (!memcmp(cra_driver_name + start, drbg_cores[i].cra_name,
-			    len)) {
-			*coreref = i;
-			return;
-		}
-	}
-}
-
 static int drbg_kcapi_init(struct crypto_tfm *tfm)
 {
 	struct drbg_state *drbg = crypto_tfm_ctx(tfm);
@@ -1970,21 +1617,7 @@ static int drbg_kcapi_random(struct crypto_rng *tfm,
 static int drbg_kcapi_seed(struct crypto_rng *tfm,
 			   const u8 *seed, unsigned int slen)
 {
-	struct drbg_state *drbg = crypto_rng_ctx(tfm);
-	struct crypto_tfm *tfm_base = crypto_rng_tfm(tfm);
-	bool pr = false;
-	struct drbg_string string;
-	struct drbg_string *seed_string = NULL;
-	int coreref = 0;
-
-	drbg_convert_tfm_core(crypto_tfm_alg_driver_name(tfm_base), &coreref,
-			      &pr);
-	if (0 < slen) {
-		drbg_string_fill(&string, seed, slen);
-		seed_string = &string;
-	}
-
-	return drbg_instantiate(drbg, seed_string, coreref, pr);
+	return drbg_instantiate(tfm, seed, slen);
 }
 
 /***************************************************************
@@ -2007,9 +1640,7 @@ static inline int __init drbg_healthcheck_sanity(void)
 #define OUTBUFLEN 16
 	unsigned char buf[OUTBUFLEN];
 	struct drbg_state *drbg = NULL;
-	int ret;
 	int rc = -EFAULT;
-	bool pr = false;
 	int coreref = 0;
 	struct drbg_string addtl;
 	size_t max_addtllen, max_request_bytes;
@@ -2019,12 +1650,14 @@ static inline int __init drbg_healthcheck_sanity(void)
 		return 0;
 
 #ifdef CONFIG_CRYPTO_DRBG_CTR
-	drbg_convert_tfm_core("drbg_nopr_ctr_aes128", &coreref, &pr);
+	rc = drbg_convert_tfm_core("drbg_nopr_ctr_aes128", &coreref);
 #elif defined CONFIG_CRYPTO_DRBG_HASH
-	drbg_convert_tfm_core("drbg_nopr_sha256", &coreref, &pr);
+	rc = drbg_convert_tfm_core("drbg_nopr_sha256", &coreref);
 #else
-	drbg_convert_tfm_core("drbg_nopr_hmac_sha256", &coreref, &pr);
+	rc = drbg_convert_tfm_core("drbg_nopr_hmac_sha256", &coreref);
 #endif
+	if (rc)
+		return rc;
 
 	drbg = kzalloc(sizeof(struct drbg_state), GFP_KERNEL);
 	if (!drbg)
@@ -2032,7 +1665,6 @@ static inline int __init drbg_healthcheck_sanity(void)
 
 	mutex_init(&drbg->drbg_mutex);
 	drbg->core = &drbg_cores[coreref];
-	drbg->reseed_threshold = drbg_max_requests(drbg);
 
 	/*
 	 * if the following tests fail, it is likely that there is a buffer
@@ -2052,9 +1684,6 @@ static inline int __init drbg_healthcheck_sanity(void)
 	len = drbg_generate(drbg, buf, (max_request_bytes + 1), NULL);
 	BUG_ON(0 < len);
 
-	/* overflow max addtllen with personalization string */
-	ret = drbg_seed(drbg, &addtl, false);
-	BUG_ON(0 == ret);
 	/* all tests passed */
 	rc = 0;
 
@@ -2065,7 +1694,7 @@ static inline int __init drbg_healthcheck_sanity(void)
 	return rc;
 }
 
-static struct rng_alg drbg_algs[22];
+static struct rng_alg drbg_algs[11];
 
 /*
  * Fill the array drbg_algs used to register the different DRBGs
@@ -2073,20 +1702,13 @@ static struct rng_alg drbg_algs[22];
  * from drbg_cores[] is used.
  */
 static inline void __init drbg_fill_array(struct rng_alg *alg,
-					  const struct drbg_core *core, int pr)
+					  const struct drbg_core *core)
 {
-	int pos = 0;
 	static int priority = 200;
 
 	memcpy(alg->base.cra_name, "stdrng", 6);
-	if (pr) {
-		memcpy(alg->base.cra_driver_name, "drbg_pr_", 8);
-		pos = 8;
-	} else {
-		memcpy(alg->base.cra_driver_name, "drbg_nopr_", 10);
-		pos = 10;
-	}
-	memcpy(alg->base.cra_driver_name + pos, core->cra_name,
+	memcpy(alg->base.cra_driver_name, "drbg_nopr_", 10);
+	memcpy(alg->base.cra_driver_name + 10, core->cra_name,
 	       strlen(core->cra_name));
 
 	alg->base.cra_priority = priority;
@@ -2105,41 +1727,29 @@ static inline void __init drbg_fill_array(struct rng_alg *alg,
 	alg->base.cra_exit	= drbg_kcapi_cleanup;
 	alg->generate		= drbg_kcapi_random;
 	alg->seed		= drbg_kcapi_seed;
-	alg->set_ent		= drbg_kcapi_set_entropy;
 	alg->seedsize		= 0;
 }
 
 static int __init drbg_init(void)
 {
-	unsigned int i = 0; /* pointer to drbg_algs */
-	unsigned int j = 0; /* pointer to drbg_cores */
+	unsigned int i;
 	int ret;
 
 	ret = drbg_healthcheck_sanity();
 	if (ret)
 		return ret;
 
-	if (ARRAY_SIZE(drbg_cores) * 2 > ARRAY_SIZE(drbg_algs)) {
-		pr_info("DRBG: Cannot register all DRBG types"
-			"(slots needed: %zu, slots available: %zu)\n",
-			ARRAY_SIZE(drbg_cores) * 2, ARRAY_SIZE(drbg_algs));
-		return -EFAULT;
-	}
+	BUILD_BUG_ON(ARRAY_SIZE(drbg_cores) != ARRAY_SIZE(drbg_algs));
 
 	/*
-	 * each DRBG definition can be used with PR and without PR, thus
-	 * we instantiate each DRBG in drbg_cores[] twice.
-	 *
 	 * As the order of placing them into the drbg_algs array matters
 	 * (the later DRBGs receive a higher cra_priority) we register the
 	 * prediction resistance DRBGs first as the should not be too
 	 * interesting.
 	 */
-	for (j = 0; ARRAY_SIZE(drbg_cores) > j; j++, i++)
-		drbg_fill_array(&drbg_algs[i], &drbg_cores[j], 1);
-	for (j = 0; ARRAY_SIZE(drbg_cores) > j; j++, i++)
-		drbg_fill_array(&drbg_algs[i], &drbg_cores[j], 0);
-	return crypto_register_rngs(drbg_algs, (ARRAY_SIZE(drbg_cores) * 2));
+	for (i = 0; i < ARRAY_SIZE(drbg_cores); i++)
+		drbg_fill_array(&drbg_algs[i], &drbg_cores[i]);
+	return crypto_register_rngs(drbg_algs, ARRAY_SIZE(drbg_cores));
 }
 
 static void __exit drbg_exit(void)
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 5831d4bbc64f..2ce698eb14b6 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -3635,13 +3635,11 @@ static int alg_test_cprng(const struct alg_test_desc *desc, const char *driver,
 }
 
 
-static int drbg_cavs_test(const struct drbg_testvec *test, int pr,
+static int drbg_cavs_test(const struct drbg_testvec *test,
 			  const char *driver, u32 type, u32 mask)
 {
 	int ret = -EAGAIN;
 	struct crypto_rng *drng;
-	struct drbg_test_data test_data;
-	struct drbg_string addtl, pers, testentropy;
 	unsigned char *buf = kzalloc(test->expectedlen, GFP_KERNEL);
 
 	if (!buf)
@@ -3655,47 +3653,29 @@ static int drbg_cavs_test(const struct drbg_testvec *test, int pr,
 		return -ENOMEM;
 	}
 
-	test_data.testentropy = &testentropy;
-	drbg_string_fill(&testentropy, test->entropy, test->entropylen);
-	drbg_string_fill(&pers, test->pers, test->perslen);
-	ret = crypto_drbg_reset_test(drng, &pers, &test_data);
+	ret = crypto_rng_reset(drng, test->entropy, test->entropylen);
 	if (ret) {
 		printk(KERN_ERR "alg: drbg: Failed to reset rng\n");
 		goto outbuf;
 	}
 
-	drbg_string_fill(&addtl, test->addtla, test->addtllen);
-	if (pr) {
-		drbg_string_fill(&testentropy, test->entpra, test->entprlen);
-		ret = crypto_drbg_get_bytes_addtl_test(drng,
-			buf, test->expectedlen, &addtl,	&test_data);
-	} else {
-		ret = crypto_drbg_get_bytes_addtl(drng,
-			buf, test->expectedlen, &addtl);
-	}
+	ret = crypto_rng_generate(drng, test->addtla, test->addtllen,
+				  buf, test->expectedlen);
+
 	if (ret < 0) {
 		printk(KERN_ERR "alg: drbg: could not obtain random data for "
 		       "driver %s\n", driver);
 		goto outbuf;
 	}
 
-	drbg_string_fill(&addtl, test->addtlb, test->addtllen);
-	if (pr) {
-		drbg_string_fill(&testentropy, test->entprb, test->entprlen);
-		ret = crypto_drbg_get_bytes_addtl_test(drng,
-			buf, test->expectedlen, &addtl, &test_data);
-	} else {
-		ret = crypto_drbg_get_bytes_addtl(drng,
-			buf, test->expectedlen, &addtl);
-	}
+	ret = crypto_rng_generate(drng, test->addtlb, test->addtllen,
+				  buf, test->expectedlen);
 	if (ret < 0) {
 		printk(KERN_ERR "alg: drbg: could not obtain random data for "
 		       "driver %s\n", driver);
 		goto outbuf;
 	}
 
-	ret = memcmp(test->expected, buf, test->expectedlen);
-
 outbuf:
 	crypto_free_rng(drng);
 	kfree_sensitive(buf);
@@ -3707,16 +3687,12 @@ static int alg_test_drbg(const struct alg_test_desc *desc, const char *driver,
 			 u32 type, u32 mask)
 {
 	int err = 0;
-	int pr = 0;
 	int i = 0;
 	const struct drbg_testvec *template = desc->suite.drbg.vecs;
 	unsigned int tcount = desc->suite.drbg.count;
 
-	if (0 == memcmp(driver, "drbg_pr_", 8))
-		pr = 1;
-
 	for (i = 0; i < tcount; i++) {
-		err = drbg_cavs_test(&template[i], pr, driver, type, mask);
+		err = drbg_cavs_test(&template[i], driver, type, mask);
 		if (err) {
 			printk(KERN_ERR "alg: drbg: Test %d failed for %s\n",
 			       i, driver);
@@ -4725,62 +4701,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "drbg_nopr_sha512",
 		.fips_allowed = 1,
 		.test = alg_test_null,
-	}, {
-		.alg = "drbg_pr_ctr_aes128",
-		.test = alg_test_drbg,
-		.fips_allowed = 1,
-		.suite = {
-			.drbg = __VECS(drbg_pr_ctr_aes128_tv_template)
-		}
-	}, {
-		/* covered by drbg_pr_ctr_aes128 test */
-		.alg = "drbg_pr_ctr_aes192",
-		.fips_allowed = 1,
-		.test = alg_test_null,
-	}, {
-		.alg = "drbg_pr_ctr_aes256",
-		.fips_allowed = 1,
-		.test = alg_test_null,
-	}, {
-		.alg = "drbg_pr_hmac_sha1",
-		.fips_allowed = 1,
-		.test = alg_test_null,
-	}, {
-		.alg = "drbg_pr_hmac_sha256",
-		.test = alg_test_drbg,
-		.fips_allowed = 1,
-		.suite = {
-			.drbg = __VECS(drbg_pr_hmac_sha256_tv_template)
-		}
-	}, {
-		/* covered by drbg_pr_hmac_sha256 test */
-		.alg = "drbg_pr_hmac_sha384",
-		.fips_allowed = 1,
-		.test = alg_test_null,
-	}, {
-		.alg = "drbg_pr_hmac_sha512",
-		.test = alg_test_null,
-		.fips_allowed = 1,
-	}, {
-		.alg = "drbg_pr_sha1",
-		.fips_allowed = 1,
-		.test = alg_test_null,
-	}, {
-		.alg = "drbg_pr_sha256",
-		.test = alg_test_drbg,
-		.fips_allowed = 1,
-		.suite = {
-			.drbg = __VECS(drbg_pr_sha256_tv_template)
-		}
-	}, {
-		/* covered by drbg_pr_sha256 test */
-		.alg = "drbg_pr_sha384",
-		.fips_allowed = 1,
-		.test = alg_test_null,
-	}, {
-		.alg = "drbg_pr_sha512",
-		.fips_allowed = 1,
-		.test = alg_test_null,
 	}, {
 		.alg = "ecb(aes)",
 		.test = alg_test_skcipher,
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index a253d66ba1c1..99a422816377 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -134,14 +134,9 @@ struct cprng_testvec {
 struct drbg_testvec {
 	const unsigned char *entropy;
 	size_t entropylen;
-	const unsigned char *entpra;
-	const unsigned char *entprb;
-	size_t entprlen;
 	const unsigned char *addtla;
 	const unsigned char *addtlb;
 	size_t addtllen;
-	const unsigned char *pers;
-	size_t perslen;
 	const unsigned char *expected;
 	size_t expectedlen;
 };
@@ -21440,453 +21435,13 @@ static const struct cprng_testvec ansi_cprng_aes_tv_template[] = {
 	},
 };
 
-/*
- * SP800-90A DRBG Test vectors from
- * http://csrc.nist.gov/groups/STM/cavp/documents/drbg/drbgtestvectors.zip
- *
- * Test vectors for DRBG with prediction resistance. All types of DRBGs
- * (Hash, HMAC, CTR) are tested with all permutations of use cases (w/ and
- * w/o personalization string, w/ and w/o additional input string).
- */
-static const struct drbg_testvec drbg_pr_sha256_tv_template[] = {
-	{
-		.entropy = (unsigned char *)
-			"\x72\x88\x4c\xcd\x6c\x85\x57\x70\xf7\x0b\x8b\x86"
-			"\xc1\xeb\xd2\x4e\x36\x14\xab\x18\xc4\x9c\xc9\xcf"
-			"\x1a\xe8\xf7\x7b\x02\x49\x73\xd7\xf1\x42\x7d\xc6"
-			"\x3f\x29\x2d\xec\xd3\x66\x51\x3f\x1d\x8d\x5b\x4e",
-		.entropylen = 48,
-		.entpra = (unsigned char *)
-			"\x38\x9c\x91\xfa\xc2\xa3\x46\x89\x56\x08\x3f\x62"
-			"\x73\xd5\x22\xa9\x29\x63\x3a\x1d\xe5\x5d\x5e\x4f"
-			"\x67\xb0\x67\x7a\x5e\x9e\x0c\x62",
-		.entprb = (unsigned char *)
-			"\xb2\x8f\x36\xb2\xf6\x8d\x39\x13\xfa\x6c\x66\xcf"
-			"\x62\x8a\x7e\x8c\x12\x33\x71\x9c\x69\xe4\xa5\xf0"
-			"\x8c\xee\xeb\x9c\xf5\x31\x98\x31",
-		.entprlen = 32,
-		.expected = (unsigned char *)
-			"\x52\x7b\xa3\xad\x71\x77\xa4\x49\x42\x04\x61\xc7"
-			"\xf0\xaf\xa5\xfd\xd3\xb3\x0d\x6a\x61\xba\x35\x49"
-			"\xbb\xaa\xaf\xe4\x25\x7d\xb5\x48\xaf\x5c\x18\x3d"
-			"\x33\x8d\x9d\x45\xdf\x98\xd5\x94\xa8\xda\x92\xfe"
-			"\xc4\x3c\x94\x2a\xcf\x7f\x7b\xf2\xeb\x28\xa9\xf1"
-			"\xe0\x86\x30\xa8\xfe\xf2\x48\x90\x91\x0c\x75\xb5"
-			"\x3c\x00\xf0\x4d\x09\x4f\x40\xa7\xa2\x8c\x52\xdf"
-			"\x52\xef\x17\xbf\x3d\xd1\xa2\x31\xb4\xb8\xdc\xe6"
-			"\x5b\x0d\x1f\x78\x36\xb4\xe6\x4b\xa7\x11\x25\xd5"
-			"\x94\xc6\x97\x36\xab\xf0\xe5\x31\x28\x6a\xbb\xce"
-			"\x30\x81\xa6\x8f\x27\x14\xf8\x1c",
-		.expectedlen = 128,
-		.addtla = NULL,
-		.addtlb = NULL,
-		.addtllen = 0,
-		.pers = NULL,
-		.perslen = 0,
-	}, {
-		.entropy = (unsigned char *)
-			"\x5d\xf2\x14\xbc\xf6\xb5\x4e\x0b\xf0\x0d\x6f\x2d"
-			"\xe2\x01\x66\x7b\xd0\xa4\x73\xa4\x21\xdd\xb0\xc0"
-			"\x51\x79\x09\xf4\xea\xa9\x08\xfa\xa6\x67\xe0\xe1"
-			"\xd1\x88\xa8\xad\xee\x69\x74\xb3\x55\x06\x9b\xf6",
-		.entropylen = 48,
-		.entpra = (unsigned char *)
-			"\xef\x48\x06\xa2\xc2\x45\xf1\x44\xfa\x34\x2c\xeb"
-			"\x8d\x78\x3c\x09\x8f\x34\x72\x20\xf2\xe7\xfd\x13"
-			"\x76\x0a\xf6\xdc\x3c\xf5\xc0\x15",
-		.entprb = (unsigned char *)
-			"\x4b\xbe\xe5\x24\xed\x6a\x2d\x0c\xdb\x73\x5e\x09"
-			"\xf9\xad\x67\x7c\x51\x47\x8b\x6b\x30\x2a\xc6\xde"
-			"\x76\xaa\x55\x04\x8b\x0a\x72\x95",
-		.entprlen = 32,
-		.expected = (unsigned char *)
-			"\x3b\x14\x71\x99\xa1\xda\xa0\x42\xe6\xc8\x85\x32"
-			"\x70\x20\x32\x53\x9a\xbe\xd1\x1e\x15\xef\xfb\x4c"
-			"\x25\x6e\x19\x3a\xf0\xb9\xcb\xde\xf0\x3b\xc6\x18"
-			"\x4d\x85\x5a\x9b\xf1\xe3\xc2\x23\x03\x93\x08\xdb"
-			"\xa7\x07\x4b\x33\x78\x40\x4d\xeb\x24\xf5\x6e\x81"
-			"\x4a\x1b\x6e\xa3\x94\x52\x43\xb0\xaf\x2e\x21\xf4"
-			"\x42\x46\x8e\x90\xed\x34\x21\x75\xea\xda\x67\xb6"
-			"\xe4\xf6\xff\xc6\x31\x6c\x9a\x5a\xdb\xb3\x97\x13"
-			"\x09\xd3\x20\x98\x33\x2d\x6d\xd7\xb5\x6a\xa8\xa9"
-			"\x9a\x5b\xd6\x87\x52\xa1\x89\x2b\x4b\x9c\x64\x60"
-			"\x50\x47\xa3\x63\x81\x16\xaf\x19",
-		.expectedlen = 128,
-		.addtla = (unsigned char *)
-			"\xbe\x13\xdb\x2a\xe9\xa8\xfe\x09\x97\xe1\xce\x5d"
-			"\xe8\xbb\xc0\x7c\x4f\xcb\x62\x19\x3f\x0f\xd2\xad"
-			"\xa9\xd0\x1d\x59\x02\xc4\xff\x70",
-		.addtlb = (unsigned char *)
-			"\x6f\x96\x13\xe2\xa7\xf5\x6c\xfe\xdf\x66\xe3\x31"
-			"\x63\x76\xbf\x20\x27\x06\x49\xf1\xf3\x01\x77\x41"
-			"\x9f\xeb\xe4\x38\xfe\x67\x00\xcd",
-		.addtllen = 32,
-		.pers = NULL,
-		.perslen = 0,
-	}, {
-		.entropy = (unsigned char *)
-			"\xc6\x1c\xaf\x83\xa2\x56\x38\xf9\xb0\xbc\xd9\x85"
-			"\xf5\x2e\xc4\x46\x9c\xe1\xb9\x40\x98\x70\x10\x72"
-			"\xd7\x7d\x15\x85\xa1\x83\x5a\x97\xdf\xc8\xa8\xe8"
-			"\x03\x4c\xcb\x70\x35\x8b\x90\x94\x46\x8a\x6e\xa1",
-		.entropylen = 48,
-		.entpra = (unsigned char *)
-			"\xc9\x05\xa4\xcf\x28\x80\x4b\x93\x0f\x8b\xc6\xf9"
-			"\x09\x41\x58\x74\xe9\xec\x28\xc7\x53\x0a\x73\x60"
-			"\xba\x0a\xde\x57\x5b\x4b\x9f\x29",
-		.entprb = (unsigned char *)
-			"\x4f\x31\xd2\xeb\xac\xfa\xa8\xe2\x01\x7d\xf3\xbd"
-			"\x42\xbd\x20\xa0\x30\x65\x74\xd5\x5d\xd2\xad\xa4"
-			"\xa9\xeb\x1f\x4d\xf6\xfd\xb8\x26",
-		.entprlen = 32,
-		.expected = (unsigned char *)
-			"\xf6\x13\x05\xcb\x83\x60\x16\x42\x49\x1d\xc6\x25"
-			"\x3b\x8c\x31\xa3\xbe\x8b\xbd\x1c\xe2\xec\x1d\xde"
-			"\xbb\xbf\xa1\xac\xa8\x9f\x50\xce\x69\xce\xef\xd5"
-			"\xd6\xf2\xef\x6a\xf7\x81\x38\xdf\xbc\xa7\x5a\xb9"
-			"\xb2\x42\x65\xab\xe4\x86\x8d\x2d\x9d\x59\x99\x2c"
-			"\x5a\x0d\x71\x55\x98\xa4\x45\xc2\x8d\xdb\x05\x5e"
-			"\x50\x21\xf7\xcd\xe8\x98\x43\xce\x57\x74\x63\x4c"
-			"\xf3\xb1\xa5\x14\x1e\x9e\x01\xeb\x54\xd9\x56\xae"
-			"\xbd\xb6\x6f\x1a\x47\x6b\x3b\x44\xe4\xa2\xe9\x3c"
-			"\x6c\x83\x12\x30\xb8\x78\x7f\x8e\x54\x82\xd4\xfe"
-			"\x90\x35\x0d\x4c\x4d\x85\xe7\x13",
-		.expectedlen = 128,
-		.addtla = NULL,
-		.addtlb = NULL,
-		.addtllen = 0,
-		.pers = (unsigned char *)
-			"\xa5\xbf\xac\x4f\x71\xa1\xbb\x67\x94\xc6\x50\xc7"
-			"\x2a\x45\x9e\x10\xa8\xed\xf7\x52\x4f\xfe\x21\x90"
-			"\xa4\x1b\xe1\xe2\x53\xcc\x61\x47",
-		.perslen = 32,
-	}, {
-		.entropy = (unsigned char *)
-			"\xb6\xc1\x8d\xdf\x99\x54\xbe\x95\x10\x48\xd9\xf6"
-			"\xd7\x48\xa8\x73\x2d\x74\xde\x1e\xde\x57\x7e\xf4"
-			"\x7b\x7b\x64\xef\x88\x7a\xa8\x10\x4b\xe1\xc1\x87"
-			"\xbb\x0b\xe1\x39\x39\x50\xaf\x68\x9c\xa2\xbf\x5e",
-		.entropylen = 48,
-		.entpra = (unsigned char *)
-			"\xdc\x81\x0a\x01\x58\xa7\x2e\xce\xee\x48\x8c\x7c"
-			"\x77\x9e\x3c\xf1\x17\x24\x7a\xbb\xab\x9f\xca\x12"
-			"\x19\xaf\x97\x2d\x5f\xf9\xff\xfc",
-		.entprb = (unsigned char *)
-			"\xaf\xfc\x4f\x98\x8b\x93\x95\xc1\xb5\x8b\x7f\x73"
-			"\x6d\xa6\xbe\x6d\x33\xeb\x2c\x82\xb1\xaf\xc1\xb6"
-			"\xb6\x05\xe2\x44\xaa\xfd\xe7\xdb",
-		.entprlen = 32,
-		.expected = (unsigned char *)
-			"\x51\x79\xde\x1c\x0f\x58\xf3\xf4\xc9\x57\x2e\x31"
-			"\xa7\x09\xa1\x53\x64\x63\xa2\xc5\x1d\x84\x88\x65"
-			"\x01\x1b\xc6\x16\x3c\x49\x5b\x42\x8e\x53\xf5\x18"
-			"\xad\x94\x12\x0d\x4f\x55\xcc\x45\x5c\x98\x0f\x42"
-			"\x28\x2f\x47\x11\xf9\xc4\x01\x97\x6b\xa0\x94\x50"
-			"\xa9\xd1\x5e\x06\x54\x3f\xdf\xbb\xc4\x98\xee\x8b"
-			"\xba\xa9\xfa\x49\xee\x1d\xdc\xfb\x50\xf6\x51\x9f"
-			"\x6c\x4a\x9a\x6f\x63\xa2\x7d\xad\xaf\x3a\x24\xa0"
-			"\xd9\x9f\x07\xeb\x15\xee\x26\xe0\xd5\x63\x39\xda"
-			"\x3c\x59\xd6\x33\x6c\x02\xe8\x05\x71\x46\x68\x44"
-			"\x63\x4a\x68\x72\xe9\xf5\x55\xfe",
-		.expectedlen = 128,
-		.addtla = (unsigned char *)
-			"\x15\x20\x2f\xf6\x98\x28\x63\xa2\xc4\x4e\xbb\x6c"
-			"\xb2\x25\x92\x61\x79\xc9\x22\xc4\x61\x54\x96\xff"
-			"\x4a\x85\xca\x80\xfe\x0d\x1c\xd0",
-		.addtlb = (unsigned char *)
-			"\xde\x29\x8e\x03\x42\x61\xa3\x28\x5e\xc8\x80\xc2"
-			"\x6d\xbf\xad\x13\xe1\x8d\x2a\xc7\xe8\xc7\x18\x89"
-			"\x42\x58\x9e\xd6\xcc\xad\x7b\x1e",
-		.addtllen = 32,
-		.pers = (unsigned char *)
-			"\x84\xc3\x73\x9e\xce\xb3\xbc\x89\xf7\x62\xb3\xe1"
-			"\xd7\x48\x45\x8a\xa9\xcc\xe9\xed\xd5\x81\x84\x52"
-			"\x82\x4c\xdc\x19\xb8\xf8\x92\x5c",
-		.perslen = 32,
-	},
-};
-
-static const struct drbg_testvec drbg_pr_hmac_sha256_tv_template[] = {
-	{
-		.entropy = (unsigned char *)
-			"\x99\x69\xe5\x4b\x47\x03\xff\x31\x78\x5b\x87\x9a"
-			"\x7e\x5c\x0e\xae\x0d\x3e\x30\x95\x59\xe9\xfe\x96"
-			"\xb0\x67\x6d\x49\xd5\x91\xea\x4d\x07\xd2\x0d\x46"
-			"\xd0\x64\x75\x7d\x30\x23\xca\xc2\x37\x61\x27\xab",
-		.entropylen = 48,
-		.entpra = (unsigned char *)
-			"\xc6\x0f\x29\x99\x10\x0f\x73\x8c\x10\xf7\x47\x92"
-			"\x67\x6a\x3f\xc4\xa2\x62\xd1\x37\x21\x79\x80\x46"
-			"\xe2\x9a\x29\x51\x81\x56\x9f\x54",
-		.entprb = (unsigned char *)
-			"\xc1\x1d\x45\x24\xc9\x07\x1b\xd3\x09\x60\x15\xfc"
-			"\xf7\xbc\x24\xa6\x07\xf2\x2f\xa0\x65\xc9\x37\x65"
-			"\x8a\x2a\x77\xa8\x69\x90\x89\xf4",
-		.entprlen = 32,
-		.expected = (unsigned char *)
-			"\xab\xc0\x15\x85\x60\x94\x80\x3a\x93\x8d\xff\xd2"
-			"\x0d\xa9\x48\x43\x87\x0e\xf9\x35\xb8\x2c\xfe\xc1"
-			"\x77\x06\xb8\xf5\x51\xb8\x38\x50\x44\x23\x5d\xd4"
-			"\x4b\x59\x9f\x94\xb3\x9b\xe7\x8d\xd4\x76\xe0\xcf"
-			"\x11\x30\x9c\x99\x5a\x73\x34\xe0\xa7\x8b\x37\xbc"
-			"\x95\x86\x23\x50\x86\xfa\x3b\x63\x7b\xa9\x1c\xf8"
-			"\xfb\x65\xef\xa2\x2a\x58\x9c\x13\x75\x31\xaa\x7b"
-			"\x2d\x4e\x26\x07\xaa\xc2\x72\x92\xb0\x1c\x69\x8e"
-			"\x6e\x01\xae\x67\x9e\xb8\x7c\x01\xa8\x9c\x74\x22"
-			"\xd4\x37\x2d\x6d\x75\x4a\xba\xbb\x4b\xf8\x96\xfc"
-			"\xb1\xcd\x09\xd6\x92\xd0\x28\x3f",
-		.expectedlen = 128,
-		.addtla = NULL,
-		.addtlb = NULL,
-		.addtllen = 0,
-		.pers = NULL,
-		.perslen = 0,
-	}, {
-		.entropy = (unsigned char *)
-			"\xb9\x1f\xe9\xef\xdd\x9b\x7d\x20\xb6\xec\xe0\x2f"
-			"\xdb\x76\x24\xce\x41\xc8\x3a\x4a\x12\x7f\x3e\x2f"
-			"\xae\x05\x99\xea\xb5\x06\x71\x0d\x0c\x4c\xb4\x05"
-			"\x26\xc6\xbd\xf5\x7f\x2a\x3d\xf2\xb5\x49\x7b\xda",
-		.entropylen = 48,
-		.entpra = (unsigned char *)
-			"\xef\x67\x50\x9c\xa7\x7d\xdf\xb7\x2d\x81\x01\xa4"
-			"\x62\x81\x6a\x69\x5b\xb3\x37\x45\xa7\x34\x8e\x26"
-			"\x46\xd9\x26\xa2\x19\xd4\x94\x43",
-		.entprb = (unsigned char *)
-			"\x97\x75\x53\x53\xba\xb4\xa6\xb2\x91\x60\x71\x79"
-			"\xd1\x6b\x4a\x24\x9a\x34\x66\xcc\x33\xab\x07\x98"
-			"\x51\x78\x72\xb2\x79\xfd\x2c\xff",
-		.entprlen = 32,
-		.expected = (unsigned char *)
-			"\x9c\xdc\x63\x8a\x19\x23\x22\x66\x0c\xc5\xb9\xd7"
-			"\xfb\x2a\xb0\x31\xe3\x8a\x36\xa8\x5a\xa8\x14\xda"
-			"\x1e\xa9\xcc\xfe\xb8\x26\x44\x83\x9f\xf6\xff\xaa"
-			"\xc8\x98\xb8\x30\x35\x3b\x3d\x36\xd2\x49\xd4\x40"
-			"\x62\x0a\x65\x10\x76\x55\xef\xc0\x95\x9c\xa7\xda"
-			"\x3f\xcf\xb7\x7b\xc6\xe1\x28\x52\xfc\x0c\xe2\x37"
-			"\x0d\x83\xa7\x51\x4b\x31\x47\x3c\xe1\x3c\xae\x70"
-			"\x01\xc8\xa3\xd3\xc2\xac\x77\x9c\xd1\x68\x77\x9b"
-			"\x58\x27\x3b\xa5\x0f\xc2\x7a\x8b\x04\x65\x62\xd5"
-			"\xe8\xd6\xfe\x2a\xaf\xd3\xd3\xfe\xbd\x18\xfb\xcd"
-			"\xcd\x66\xb5\x01\x69\x66\xa0\x3c",
-		.expectedlen = 128,
-		.addtla = (unsigned char *)
-			"\x17\xc1\x56\xcb\xcc\x50\xd6\x03\x7d\x45\x76\xa3"
-			"\x75\x76\xc1\x4a\x66\x1b\x2e\xdf\xb0\x2e\x7d\x56"
-			"\x6d\x99\x3b\xc6\x58\xda\x03\xf6",
-		.addtlb = (unsigned char *)
-			"\x7c\x7b\x4a\x4b\x32\x5e\x6f\x67\x34\xf5\x21\x4c"
-			"\xf9\x96\xf9\xbf\x1c\x8c\x81\xd3\x9b\x60\x6a\x44"
-			"\xc6\x03\xa2\xfb\x13\x20\x19\xb7",
-		.addtllen = 32,
-		.pers = NULL,
-		.perslen = 0,
-	}, {
-		.entropy = (unsigned char *)
-			"\x13\x54\x96\xfc\x1b\x7d\x28\xf3\x18\xc9\xa7\x89"
-			"\xb6\xb3\xc8\x72\xac\x00\xd4\x59\x36\x25\x05\xaf"
-			"\xa5\xdb\x96\xcb\x3c\x58\x46\x87\xa5\xaa\xbf\x20"
-			"\x3b\xfe\x23\x0e\xd1\xc7\x41\x0f\x3f\xc9\xb3\x67",
-		.entropylen = 48,
-		.entpra = (unsigned char *)
-			"\xe2\xbd\xb7\x48\x08\x06\xf3\xe1\x93\x3c\xac\x79"
-			"\xa7\x2b\x11\xda\xe3\x2e\xe1\x91\xa5\x02\x19\x57"
-			"\x20\x28\xad\xf2\x60\xd7\xcd\x45",
-		.entprb = (unsigned char *)
-			"\x8b\xd4\x69\xfc\xff\x59\x95\x95\xc6\x51\xde\x71"
-			"\x68\x5f\xfc\xf9\x4a\xab\xec\x5a\xcb\xbe\xd3\x66"
-			"\x1f\xfa\x74\xd3\xac\xa6\x74\x60",
-		.entprlen = 32,
-		.expected = (unsigned char *)
-			"\x1f\x9e\xaf\xe4\xd2\x46\xb7\x47\x41\x4c\x65\x99"
-			"\x01\xe9\x3b\xbb\x83\x0c\x0a\xb0\xc1\x3a\xe2\xb3"
-			"\x31\x4e\xeb\x93\x73\xee\x0b\x26\xc2\x63\xa5\x75"
-			"\x45\x99\xd4\x5c\x9f\xa1\xd4\x45\x87\x6b\x20\x61"
-			"\x40\xea\x78\xa5\x32\xdf\x9e\x66\x17\xaf\xb1\x88"
-			"\x9e\x2e\x23\xdd\xc1\xda\x13\x97\x88\xa5\xb6\x5e"
-			"\x90\x14\x4e\xef\x13\xab\x5c\xd9\x2c\x97\x9e\x7c"
-			"\xd7\xf8\xce\xea\x81\xf5\xcd\x71\x15\x49\x44\xce"
-			"\x83\xb6\x05\xfb\x7d\x30\xb5\x57\x2c\x31\x4f\xfc"
-			"\xfe\x80\xb6\xc0\x13\x0c\x5b\x9b\x2e\x8f\x3d\xfc"
-			"\xc2\xa3\x0c\x11\x1b\x80\x5f\xf3",
-		.expectedlen = 128,
-		.addtla = NULL,
-		.addtlb = NULL,
-		.addtllen = 0,
-		.pers = (unsigned char *)
-			"\x64\xb6\xfc\x60\xbc\x61\x76\x23\x6d\x3f\x4a\x0f"
-			"\xe1\xb4\xd5\x20\x9e\x70\xdd\x03\x53\x6d\xbf\xce"
-			"\xcd\x56\x80\xbc\xb8\x15\xc8\xaa",
-		.perslen = 32,
-	}, {
-		.entropy = (unsigned char *)
-			"\xc7\xcc\xbc\x67\x7e\x21\x66\x1e\x27\x2b\x63\xdd"
-			"\x3a\x78\xdc\xdf\x66\x6d\x3f\x24\xae\xcf\x37\x01"
-			"\xa9\x0d\x89\x8a\xa7\xdc\x81\x58\xae\xb2\x10\x15"
-			"\x7e\x18\x44\x6d\x13\xea\xdf\x37\x85\xfe\x81\xfb",
-		.entropylen = 48,
-		.entpra = (unsigned char *)
-			"\x7b\xa1\x91\x5b\x3c\x04\xc4\x1b\x1d\x19\x2f\x1a"
-			"\x18\x81\x60\x3c\x6c\x62\x91\xb7\xe9\xf5\xcb\x96"
-			"\xbb\x81\x6a\xcc\xb5\xae\x55\xb6",
-		.entprb = (unsigned char *)
-			"\x99\x2c\xc7\x78\x7e\x3b\x88\x12\xef\xbe\xd3\xd2"
-			"\x7d\x2a\xa5\x86\xda\x8d\x58\x73\x4a\x0a\xb2\x2e"
-			"\xbb\x4c\x7e\xe3\x9a\xb6\x81\xc1",
-		.entprlen = 32,
-		.expected = (unsigned char *)
-			"\x95\x6f\x95\xfc\x3b\xb7\xfe\x3e\xd0\x4e\x1a\x14"
-			"\x6c\x34\x7f\x7b\x1d\x0d\x63\x5e\x48\x9c\x69\xe6"
-			"\x46\x07\xd2\x87\xf3\x86\x52\x3d\x98\x27\x5e\xd7"
-			"\x54\xe7\x75\x50\x4f\xfb\x4d\xfd\xac\x2f\x4b\x77"
-			"\xcf\x9e\x8e\xcc\x16\xa2\x24\xcd\x53\xde\x3e\xc5"
-			"\x55\x5d\xd5\x26\x3f\x89\xdf\xca\x8b\x4e\x1e\xb6"
-			"\x88\x78\x63\x5c\xa2\x63\x98\x4e\x6f\x25\x59\xb1"
-			"\x5f\x2b\x23\xb0\x4b\xa5\x18\x5d\xc2\x15\x74\x40"
-			"\x59\x4c\xb4\x1e\xcf\x9a\x36\xfd\x43\xe2\x03\xb8"
-			"\x59\x91\x30\x89\x2a\xc8\x5a\x43\x23\x7c\x73\x72"
-			"\xda\x3f\xad\x2b\xba\x00\x6b\xd1",
-		.expectedlen = 128,
-		.addtla = (unsigned char *)
-			"\x18\xe8\x17\xff\xef\x39\xc7\x41\x5c\x73\x03\x03"
-			"\xf6\x3d\xe8\x5f\xc8\xab\xe4\xab\x0f\xad\xe8\xd6"
-			"\x86\x88\x55\x28\xc1\x69\xdd\x76",
-		.addtlb = (unsigned char *)
-			"\xac\x07\xfc\xbe\x87\x0e\xd3\xea\x1f\x7e\xb8\xe7"
-			"\x9d\xec\xe8\xe7\xbc\xf3\x18\x25\x77\x35\x4a\xaa"
-			"\x00\x99\x2a\xdd\x0a\x00\x50\x82",
-		.addtllen = 32,
-		.pers = (unsigned char *)
-			"\xbc\x55\xab\x3c\xf6\x52\xb0\x11\x3d\x7b\x90\xb8"
-			"\x24\xc9\x26\x4e\x5a\x1e\x77\x0d\x3d\x58\x4a\xda"
-			"\xd1\x81\xe9\xf8\xeb\x30\x8f\x6f",
-		.perslen = 32,
-	},
-};
-
-static const struct drbg_testvec drbg_pr_ctr_aes128_tv_template[] = {
-	{
-		.entropy = (unsigned char *)
-			"\xd1\x44\xc6\x61\x81\x6d\xca\x9d\x15\x28\x8a\x42"
-			"\x94\xd7\x28\x9c\x43\x77\x19\x29\x1a\x6d\xc3\xa2",
-		.entropylen = 24,
-		.entpra = (unsigned char *)
-			"\x96\xd8\x9e\x45\x32\xc9\xd2\x08\x7a\x6d\x97\x15"
-			"\xb4\xec\x80\xb1",
-		.entprb = (unsigned char *)
-			"\x8b\xb6\x72\xb5\x24\x0b\x98\x65\x95\x95\xe9\xc9"
-			"\x28\x07\xeb\xc2",
-		.entprlen = 16,
-		.expected = (unsigned char *)
-			"\x70\x19\xd0\x4c\x45\x78\xd6\x68\xa9\x9a\xaa\xfe"
-			"\xc1\xdf\x27\x9a\x1c\x0d\x0d\xf7\x24\x75\x46\xcc"
-			"\x77\x6b\xdf\x89\xc6\x94\xdc\x74\x50\x10\x70\x18"
-			"\x9b\xdc\x96\xb4\x89\x23\x40\x1a\xce\x09\x87\xce"
-			"\xd2\xf3\xd5\xe4\x51\x67\x74\x11\x5a\xcc\x8b\x3b"
-			"\x8a\xf1\x23\xa8",
-		.expectedlen = 64,
-		.addtla = NULL,
-		.addtlb = NULL,
-		.addtllen = 0,
-		.pers = NULL,
-		.perslen = 0,
-	}, {
-		.entropy = (unsigned char *)
-			"\x8e\x83\xe0\xeb\x37\xea\x3e\x53\x5e\x17\x6e\x77"
-			"\xbd\xb1\x53\x90\xfc\xdc\xc1\x3c\x9a\x88\x22\x94",
-		.entropylen = 24,
-		.entpra = (unsigned char *)
-			"\x6a\x85\xe7\x37\xc8\xf1\x04\x31\x98\x4f\xc8\x73"
-			"\x67\xd1\x08\xf8",
-		.entprb = (unsigned char *)
-			"\xd7\xa4\x68\xe2\x12\x74\xc3\xd9\xf1\xb7\x05\xbc"
-			"\xd4\xba\x04\x58",
-		.entprlen = 16,
-		.expected = (unsigned char *)
-			"\x78\xd6\xa6\x70\xff\xd1\x82\xf5\xa2\x88\x7f\x6d"
-			"\x3d\x8c\x39\xb1\xa8\xcb\x2c\x91\xab\x14\x7e\xbc"
-			"\x95\x45\x9f\x24\xb8\x20\xac\x21\x23\xdb\x72\xd7"
-			"\x12\x8d\x48\x95\xf3\x19\x0c\x43\xc6\x19\x45\xfc"
-			"\x8b\xac\x40\x29\x73\x00\x03\x45\x5e\x12\xff\x0c"
-			"\xc1\x02\x41\x82",
-		.expectedlen = 64,
-		.addtla = (unsigned char *)
-			"\xa2\xd9\x38\xcf\x8b\x29\x67\x5b\x65\x62\x6f\xe8"
-			"\xeb\xb3\x01\x76",
-		.addtlb = (unsigned char *)
-			"\x59\x63\x1e\x81\x8a\x14\xa8\xbb\xa1\xb8\x41\x25"
-			"\xd0\x7f\xcc\x43",
-		.addtllen = 16,
-		.pers = NULL,
-		.perslen = 0,
-	}, {
-		.entropy = (unsigned char *)
-			"\x04\xd9\x49\xa6\xdc\xe8\x6e\xbb\xf1\x08\x77\x2b"
-			"\x9e\x08\xca\x92\x65\x16\xda\x99\xa2\x59\xf3\xe8",
-		.entropylen = 24,
-		.entpra = (unsigned char *)
-			"\x38\x7e\x3f\x6b\x51\x70\x7b\x20\xec\x53\xd0\x66"
-			"\xc3\x0f\xe3\xb0",
-		.entprb = (unsigned char *)
-			"\xe0\x86\xa6\xaa\x5f\x72\x2f\xad\xf7\xef\x06\xb8"
-			"\xd6\x9c\x9d\xe8",
-		.entprlen = 16,
-		.expected = (unsigned char *)
-			"\xc9\x0a\xaf\x85\x89\x71\x44\x66\x4f\x25\x0b\x2b"
-			"\xde\xd8\xfa\xff\x52\x5a\x1b\x32\x5e\x41\x7a\x10"
-			"\x1f\xef\x1e\x62\x23\xe9\x20\x30\xc9\x0d\xad\x69"
-			"\xb4\x9c\x5b\xf4\x87\x42\xd5\xae\x5e\x5e\x43\xcc"
-			"\xd9\xfd\x0b\x93\x4a\xe3\xd4\x06\x37\x36\x0f\x3f"
-			"\x72\x82\x0c\xcf",
-		.expectedlen = 64,
-		.addtla = NULL,
-		.addtlb = NULL,
-		.addtllen = 0,
-		.pers = (unsigned char *)
-			"\xbf\xa4\x9a\x8f\x7b\xd8\xb1\x7a\x9d\xfa\x45\xed"
-			"\x21\x52\xb3\xad",
-		.perslen = 16,
-	}, {
-		.entropy = (unsigned char *)
-			"\x92\x89\x8f\x31\xfa\x1c\xff\x6d\x18\x2f\x26\x06"
-			"\x43\xdf\xf8\x18\xc2\xa4\xd9\x72\xc3\xb9\xb6\x97",
-		.entropylen = 24,
-		.entpra = (unsigned char *)
-			"\x20\x72\x8a\x06\xf8\x6f\x8d\xd4\x41\xe2\x72\xb7"
-			"\xc4\x2c\xe8\x10",
-		.entprb = (unsigned char *)
-			"\x3d\xb0\xf0\x94\xf3\x05\x50\x33\x17\x86\x3e\x22"
-			"\x08\xf7\xa5\x01",
-		.entprlen = 16,
-		.expected = (unsigned char *)
-			"\x5a\x35\x39\x87\x0f\x4d\x22\xa4\x09\x24\xee\x71"
-			"\xc9\x6f\xac\x72\x0a\xd6\xf0\x88\x82\xd0\x83\x28"
-			"\x73\xec\x3f\x93\xd8\xab\x45\x23\xf0\x7e\xac\x45"
-			"\x14\x5e\x93\x9f\xb1\xd6\x76\x43\x3d\xb6\xe8\x08"
-			"\x88\xf6\xda\x89\x08\x77\x42\xfe\x1a\xf4\x3f\xc4"
-			"\x23\xc5\x1f\x68",
-		.expectedlen = 64,
-		.addtla = (unsigned char *)
-			"\x1a\x40\xfa\xe3\xcc\x6c\x7c\xa0\xf8\xda\xba\x59"
-			"\x23\x6d\xad\x1d",
-		.addtlb = (unsigned char *)
-			"\x9f\x72\x76\x6c\xc7\x46\xe5\xed\x2e\x53\x20\x12"
-			"\xbc\x59\x31\x8c",
-		.addtllen = 16,
-		.pers = (unsigned char *)
-			"\xea\x65\xee\x60\x26\x4e\x7e\xb6\x0e\x82\x68\xc4"
-			"\x37\x3c\x5c\x0b",
-		.perslen = 16,
-	},
-};
-
 /*
  * SP800-90A DRBG Test vectors from
  * http://csrc.nist.gov/groups/STM/cavp/documents/drbg/drbgtestvectors.zip
  *
  * Test vectors for DRBG without prediction resistance. All types of DRBGs
- * (Hash, HMAC, CTR) are tested with all permutations of use cases (w/ and
- * w/o personalization string, w/ and w/o additional input string).
+ * (Hash, HMAC, CTR) are tested with all permutations of use cases (w/ and w/o
+ * additional input string).
  */
 static const struct drbg_testvec drbg_nopr_sha256_tv_template[] = {
 	{
@@ -21912,8 +21467,6 @@ static const struct drbg_testvec drbg_nopr_sha256_tv_template[] = {
 		.addtla = NULL,
 		.addtlb = NULL,
 		.addtllen = 0,
-		.pers = NULL,
-		.perslen = 0,
 	}, {
 		.entropy = (unsigned char *)
 			"\x73\xd3\xfb\xa3\x94\x5f\x2b\x5f\xb9\x8f\xf6\x9c"
@@ -21943,71 +21496,7 @@ static const struct drbg_testvec drbg_nopr_sha256_tv_template[] = {
 			"\x6f\x8c\x55\x1c\x44\xd1\xce\x6f\x28\xcc\xa4\x4d"
 			"\xa8\xc0\x85\xd1\x5a\x0c\x59\x40",
 		.addtllen = 32,
-		.pers = NULL,
-		.perslen = 0,
-	}, {
-		.entropy = (unsigned char *)
-			"\x2a\x85\xa9\x8b\xd0\xda\x83\xd6\xad\xab\x9f\xbb"
-			"\x54\x31\x15\x95\x1c\x4d\x49\x9f\x6a\x15\xf6\xe4"
-			"\x15\x50\x88\x06\x29\x0d\xed\x8d\xb9\x6f\x96\xe1"
-			"\x83\x9f\xf7\x88\xda\x84\xbf\x44\x28\xd9\x1d\xaa",
-		.entropylen = 48,
-		.expected = (unsigned char *)
-			"\x2d\x55\xde\xc9\xed\x05\x47\x07\x3d\x04\xfc\x28"
-			"\x0f\x92\xf0\x4d\xd8\x00\x32\x47\x0a\x1b\x1c\x4b"
-			"\xef\xd9\x97\xa1\x17\x67\xda\x26\x6c\xfe\x76\x46"
-			"\x6f\xbc\x6d\x82\x4e\x83\x8a\x98\x66\x6c\x01\xb6"
-			"\xe6\x64\xe0\x08\x10\x6f\xd3\x5d\x90\xe7\x0d\x72"
-			"\xa6\xa7\xe3\xbb\x98\x11\x12\x56\x23\xc2\x6d\xd1"
-			"\xc8\xa8\x7a\x39\xf3\x34\xe3\xb8\xf8\x66\x00\x77"
-			"\x7d\xcf\x3c\x3e\xfa\xc9\x0f\xaf\xe0\x24\xfa\xe9"
-			"\x84\xf9\x6a\x01\xf6\x35\xdb\x5c\xab\x2a\xef\x4e"
-			"\xac\xab\x55\xb8\x9b\xef\x98\x68\xaf\x51\xd8\x16"
-			"\xa5\x5e\xae\xf9\x1e\xd2\xdb\xe6",
-		.expectedlen = 128,
-		.addtla = NULL,
-		.addtlb = NULL,
-		.addtllen = 0,
-		.pers = (unsigned char *)
-			"\xa8\x80\xec\x98\x30\x98\x15\xd2\xc6\xc4\x68\xf1"
-			"\x3a\x1c\xbf\xce\x6a\x40\x14\xeb\x36\x99\x53\xda"
-			"\x57\x6b\xce\xa4\x1c\x66\x3d\xbc",
-		.perslen = 32,
-	}, {
-		.entropy = (unsigned char *)
-			"\x69\xed\x82\xa9\xc5\x7b\xbf\xe5\x1d\x2f\xcb\x7a"
-			"\xd3\x50\x7d\x96\xb4\xb9\x2b\x50\x77\x51\x27\x74"
-			"\x33\x74\xba\xf1\x30\xdf\x8e\xdf\x87\x1d\x87\xbc"
-			"\x96\xb2\xc3\xa7\xed\x60\x5e\x61\x4e\x51\x29\x1a",
-		.entropylen = 48,
-		.expected = (unsigned char *)
-			"\xa5\x71\x24\x31\x11\xfe\x13\xe1\xa8\x24\x12\xfb"
-			"\x37\xa1\x27\xa5\xab\x77\xa1\x9f\xae\x8f\xaf\x13"
-			"\x93\xf7\x53\x85\x91\xb6\x1b\xab\xd4\x6b\xea\xb6"
-			"\xef\xda\x4c\x90\x6e\xef\x5f\xde\xe1\xc7\x10\x36"
-			"\xd5\x67\xbd\x14\xb6\x89\x21\x0c\xc9\x92\x65\x64"
-			"\xd0\xf3\x23\xe0\x7f\xd1\xe8\x75\xc2\x85\x06\xea"
-			"\xca\xc0\xcb\x79\x2d\x29\x82\xfc\xaa\x9a\xc6\x95"
-			"\x7e\xdc\x88\x65\xba\xec\x0e\x16\x87\xec\xa3\x9e"
-			"\xd8\x8c\x80\xab\x3a\x64\xe0\xcb\x0e\x45\x98\xdd"
-			"\x7c\x6c\x6c\x26\x11\x13\xc8\xce\xa9\x47\xa6\x06"
-			"\x57\xa2\x66\xbb\x2d\x7f\xf3\xc1",
-		.expectedlen = 128,
-		.addtla = (unsigned char *)
-			"\x74\xd3\x6d\xda\xe8\xd6\x86\x5f\x63\x01\xfd\xf2"
-			"\x7d\x06\x29\x6d\x94\xd1\x66\xf0\xd2\x72\x67\x4e"
-			"\x77\xc5\x3d\x9e\x03\xe3\xa5\x78",
-		.addtlb = (unsigned char *)
-			"\xf6\xb6\x3d\xf0\x7c\x26\x04\xc5\x8b\xcd\x3e\x6a"
-			"\x9f\x9c\x3a\x2e\xdb\x47\x87\xe5\x8e\x00\x5e\x2b"
-			"\x74\x7f\xa6\xf6\x80\xcd\x9b\x21",
-		.addtllen = 32,
-		.pers = (unsigned char *)
-			"\x74\xa6\xe0\x08\xf9\x27\xee\x1d\x6e\x3c\x28\x20"
-			"\x87\xdd\xd7\x54\x31\x47\x78\x4b\xe5\x6d\xa3\x73"
-			"\xa9\x65\xb1\x10\xc1\xdc\x77\x7c",
-		.perslen = 32,
-	},
+	}
 };
 
 static const struct drbg_testvec drbg_nopr_hmac_sha256_tv_template[] = {
@@ -22034,8 +21523,6 @@ static const struct drbg_testvec drbg_nopr_hmac_sha256_tv_template[] = {
 		.addtla = NULL,
 		.addtlb = NULL,
 		.addtllen = 0,
-		.pers = NULL,
-		.perslen = 0,
 	}, {
 		.entropy = (unsigned char *)
 			"\xf9\x7a\x3c\xfd\x91\xfa\xa0\x46\xb9\xe6\x1b\x94"
@@ -22065,71 +21552,7 @@ static const struct drbg_testvec drbg_nopr_hmac_sha256_tv_template[] = {
 			"\x1d\x74\x49\xfe\x75\x06\x26\x82\xe8\x9c\x57\x14"
 			"\x40\xc0\xc9\xb5\x2c\x42\xa6\xe0",
 		.addtllen = 32,
-		.pers = NULL,
-		.perslen = 0,
-	}, {
-		.entropy = (unsigned char *)
-			"\x8d\xf0\x13\xb4\xd1\x03\x52\x30\x73\x91\x7d\xdf"
-			"\x6a\x86\x97\x93\x05\x9e\x99\x43\xfc\x86\x54\x54"
-			"\x9e\x7a\xb2\x2f\x7c\x29\xf1\x22\xda\x26\x25\xaf"
-			"\x2d\xdd\x4a\xbc\xce\x3c\xf4\xfa\x46\x59\xd8\x4e",
-		.entropylen = 48,
-		.expected = (unsigned char *)
-			"\xb9\x1c\xba\x4c\xc8\x4f\xa2\x5d\xf8\x61\x0b\x81"
-			"\xb6\x41\x40\x27\x68\xa2\x09\x72\x34\x93\x2e\x37"
-			"\xd5\x90\xb1\x15\x4c\xbd\x23\xf9\x74\x52\xe3\x10"
-			"\xe2\x91\xc4\x51\x46\x14\x7f\x0d\xa2\xd8\x17\x61"
-			"\xfe\x90\xfb\xa6\x4f\x94\x41\x9c\x0f\x66\x2b\x28"
-			"\xc1\xed\x94\xda\x48\x7b\xb7\xe7\x3e\xec\x79\x8f"
-			"\xbc\xf9\x81\xb7\x91\xd1\xbe\x4f\x17\x7a\x89\x07"
-			"\xaa\x3c\x40\x16\x43\xa5\xb6\x2b\x87\xb8\x9d\x66"
-			"\xb3\xa6\x0e\x40\xd4\xa8\xe4\xe9\xd8\x2a\xf6\xd2"
-			"\x70\x0e\x6f\x53\x5c\xdb\x51\xf7\x5c\x32\x17\x29"
-			"\x10\x37\x41\x03\x0c\xcc\x3a\x56",
-		.expectedlen = 128,
-		.addtla = NULL,
-		.addtlb = NULL,
-		.addtllen = 0,
-		.pers = (unsigned char *)
-			"\xb5\x71\xe6\x6d\x7c\x33\x8b\xc0\x7b\x76\xad\x37"
-			"\x57\xbb\x2f\x94\x52\xbf\x7e\x07\x43\x7a\xe8\x58"
-			"\x1c\xe7\xbc\x7c\x3a\xc6\x51\xa9",
-		.perslen = 32,
-	}, {
-		.entropy = (unsigned char *)
-			"\xc2\xa5\x66\xa9\xa1\x81\x7b\x15\xc5\xc3\xb7\x78"
-			"\x17\x7a\xc8\x7c\x24\xe7\x97\xbe\x0a\x84\x5f\x11"
-			"\xc2\xfe\x39\x9d\xd3\x77\x32\xf2\xcb\x18\x94\xeb"
-			"\x2b\x97\xb3\xc5\x6e\x62\x83\x29\x51\x6f\x86\xec",
-		.entropylen = 48,
-		.expected = (unsigned char *)
-			"\xb3\xa3\x69\x8d\x77\x76\x99\xa0\xdd\x9f\xa3\xf0"
-			"\xa9\xfa\x57\x83\x2d\x3c\xef\xac\x5d\xf2\x44\x37"
-			"\xc6\xd7\x3a\x0f\xe4\x10\x40\xf1\x72\x90\x38\xae"
-			"\xf1\xe9\x26\x35\x2e\xa5\x9d\xe1\x20\xbf\xb7\xb0"
-			"\x73\x18\x3a\x34\x10\x6e\xfe\xd6\x27\x8f\xf8\xad"
-			"\x84\x4b\xa0\x44\x81\x15\xdf\xdd\xf3\x31\x9a\x82"
-			"\xde\x6b\xb1\x1d\x80\xbd\x87\x1a\x9a\xcd\x35\xc7"
-			"\x36\x45\xe1\x27\x0f\xb9\xfe\x4f\xa8\x8e\xc0\xe4"
-			"\x65\x40\x9e\xa0\xcb\xa8\x09\xfe\x2f\x45\xe0\x49"
-			"\x43\xa2\xe3\x96\xbb\xb7\xdd\x2f\x4e\x07\x95\x30"
-			"\x35\x24\xcc\x9c\xc5\xea\x54\xa1",
-		.expectedlen = 128,
-		.addtla = (unsigned char *)
-			"\x41\x3d\xd8\x3f\xe5\x68\x35\xab\xd4\x78\xcb\x96"
-			"\x93\xd6\x76\x35\x90\x1c\x40\x23\x9a\x26\x64\x62"
-			"\xd3\x13\x3b\x83\xe4\x9c\x82\x0b",
-		.addtlb = (unsigned char *)
-			"\xd5\xc4\xa7\x1f\x9d\x6d\x95\xa1\xbe\xdf\x0b\xd2"
-			"\x24\x7c\x27\x7d\x1f\x84\xa4\xe5\x7a\x4a\x88\x25"
-			"\xb8\x2a\x2d\x09\x7d\xe6\x3e\xf1",
-		.addtllen = 32,
-		.pers = (unsigned char *)
-			"\x13\xce\x4d\x8d\xd2\xdb\x97\x96\xf9\x41\x56\xc8"
-			"\xe8\xf0\x76\x9b\x0a\xa1\xc8\x2c\x13\x23\xb6\x15"
-			"\x36\x60\x3b\xca\x37\xc9\xee\x29",
-		.perslen = 32,
-	},
+	}
 };
 
 /* Test vector obtained during NIST ACVP testing */
@@ -22176,8 +21599,6 @@ static const struct drbg_testvec drbg_nopr_hmac_sha512_tv_template[] = {
 			"\x2D\x1E\x22\x2A\xBD\x8B\x05\x6F\xA3\xFC\xBF\x16"
 			"\xED\xAA\x75\x8D\x73\x9A\xF6\xEC",
 		.addtllen = 32,
-		.pers = NULL,
-		.perslen = 0,
 	}
 };
 
@@ -22200,8 +21621,6 @@ static const struct drbg_testvec drbg_nopr_ctr_aes192_tv_template[] = {
 		.addtla = NULL,
 		.addtlb = NULL,
 		.addtllen = 0,
-		.pers = NULL,
-		.perslen = 0,
 	},
 };
 
@@ -22224,8 +21643,6 @@ static const struct drbg_testvec drbg_nopr_ctr_aes256_tv_template[] = {
 		.addtla = NULL,
 		.addtlb = NULL,
 		.addtllen = 0,
-		.pers = NULL,
-		.perslen = 0,
 	},
 };
 
@@ -22246,8 +21663,6 @@ static const struct drbg_testvec drbg_nopr_ctr_aes128_tv_template[] = {
 		.addtla = NULL,
 		.addtlb = NULL,
 		.addtllen = 0,
-		.pers = NULL,
-		.perslen = 0,
 	}, {
 		.entropy = (unsigned char *)
 			"\x71\xbd\xce\x35\x42\x7d\x20\xbf\x58\xcf\x17\x74"
@@ -22268,53 +21683,7 @@ static const struct drbg_testvec drbg_nopr_ctr_aes128_tv_template[] = {
 			"\xe3\x18\x83\xd9\x4b\x5e\xc4\xcc\xaa\x61\x2f\xbb"
 			"\x4a\x55\xd1\xc6",
 		.addtllen = 16,
-		.pers = NULL,
-		.perslen = 0,
-	}, {
-		.entropy = (unsigned char *)
-			"\xca\x4b\x1e\xfa\x75\xbd\x69\x36\x38\x73\xb8\xf9"
-			"\xdb\x4d\x35\x0e\x47\xbf\x6c\x37\x72\xfd\xf7\xa9",
-		.entropylen = 24,
-		.expected = (unsigned char *)
-			"\x59\xc3\x19\x79\x1b\xb1\xf3\x0e\xe9\x34\xae\x6e"
-			"\x8b\x1f\xad\x1f\x74\xca\x25\x45\x68\xb8\x7f\x75"
-			"\x12\xf8\xf2\xab\x4c\x23\x01\x03\x05\xe1\x70\xee"
-			"\x75\xd8\xcb\xeb\x23\x4c\x7a\x23\x6e\x12\x27\xdb"
-			"\x6f\x7a\xac\x3c\x44\xb7\x87\x4b\x65\x56\x74\x45"
-			"\x34\x30\x0c\x3d",
-		.expectedlen = 64,
-		.addtla = NULL,
-		.addtlb = NULL,
-		.addtllen = 0,
-		.pers = (unsigned char *)
-			"\xeb\xaa\x60\x2c\x4d\xbe\x33\xff\x1b\xef\xbf\x0a"
-			"\x0b\xc6\x97\x54",
-		.perslen = 16,
-	}, {
-		.entropy = (unsigned char *)
-			"\xc0\x70\x1f\x92\x50\x75\x8f\xcd\xf2\xbe\x73\x98"
-			"\x80\xdb\x66\xeb\x14\x68\xb4\xa5\x87\x9c\x2d\xa6",
-		.entropylen = 24,
-		.expected = (unsigned char *)
-			"\x97\xc0\xc0\xe5\xa0\xcc\xf2\x4f\x33\x63\x48\x8a"
-			"\xdb\x13\x0a\x35\x89\xbf\x80\x65\x62\xee\x13\x95"
-			"\x7c\x33\xd3\x7d\xf4\x07\x77\x7a\x2b\x65\x0b\x5f"
-			"\x45\x5c\x13\xf1\x90\x77\x7f\xc5\x04\x3f\xcc\x1a"
-			"\x38\xf8\xcd\x1b\xbb\xd5\x57\xd1\x4a\x4c\x2e\x8a"
-			"\x2b\x49\x1e\x5c",
-		.expectedlen = 64,
-		.addtla = (unsigned char *)
-			"\xf9\x01\xf8\x16\x7a\x1d\xff\xde\x8e\x3c\x83\xe2"
-			"\x44\x85\xe7\xfe",
-		.addtlb = (unsigned char *)
-			"\x17\x1c\x09\x38\xc2\x38\x9f\x97\x87\x60\x55\xb4"
-			"\x82\x16\x62\x7f",
-		.addtllen = 16,
-		.pers = (unsigned char *)
-			"\x80\x08\xae\xe8\xe9\x69\x40\xc5\x08\x73\xc7\x9f"
-			"\x8e\xcf\xe0\x02",
-		.perslen = 16,
-	},
+	}
 };
 
 /* Cast5 test vectors from RFC 2144 */
diff --git a/include/crypto/drbg.h b/include/crypto/drbg.h
index af5ad51d3eef..58787575d220 100644
--- a/include/crypto/drbg.h
+++ b/include/crypto/drbg.h
@@ -101,10 +101,6 @@ struct drbg_state_ops {
 
 };
 
-struct drbg_test_data {
-	struct drbg_string *testentropy; /* TEST PARAMETER: test entropy */
-};
-
 enum drbg_seed_state {
 	DRBG_SEED_STATE_UNSEEDED,
 	DRBG_SEED_STATE_PARTIAL, /* Seeded with !rng_is_initialized() */
@@ -120,7 +116,6 @@ struct drbg_state {
 	unsigned char *Cbuf;
 	/* Number of RNG requests since last reseed -- 10.1.1.1 1c) */
 	size_t reseed_ctr;
-	size_t reseed_threshold;
 	 /* some memory the DRBG can use for its operation */
 	unsigned char *scratchpad;
 	unsigned char *scratchpadbuf;
@@ -133,15 +128,8 @@ struct drbg_state {
 	struct crypto_wait ctr_wait;		/* CTR mode async wait obj */
 	struct scatterlist sg_in, sg_out;	/* CTR mode SGLs */
 
-	enum drbg_seed_state seeded;		/* DRBG fully seeded? */
-	unsigned long last_seed_time;
-	bool pr;		/* Prediction resistance enabled? */
-	bool fips_primed;	/* Continuous test primed? */
-	unsigned char *prev;	/* FIPS 140-2 continuous test value */
-	struct crypto_rng *jent;
 	const struct drbg_state_ops *d_ops;
 	const struct drbg_core *core;
-	struct drbg_string test_data;
 };
 
 static inline __u8 drbg_statelen(struct drbg_state *drbg)
@@ -192,78 +180,6 @@ static inline size_t drbg_max_requests(struct drbg_state *drbg)
 	return (1<<20);
 }
 
-/*
- * This is a wrapper to the kernel crypto API function of
- * crypto_rng_generate() to allow the caller to provide additional data.
- *
- * @drng DRBG handle -- see crypto_rng_get_bytes
- * @outbuf output buffer -- see crypto_rng_get_bytes
- * @outlen length of output buffer -- see crypto_rng_get_bytes
- * @addtl_input additional information string input buffer
- * @addtllen length of additional information string buffer
- *
- * return
- *	see crypto_rng_get_bytes
- */
-static inline int crypto_drbg_get_bytes_addtl(struct crypto_rng *drng,
-			unsigned char *outbuf, unsigned int outlen,
-			struct drbg_string *addtl)
-{
-	return crypto_rng_generate(drng, addtl->buf, addtl->len,
-				   outbuf, outlen);
-}
-
-/*
- * TEST code
- *
- * This is a wrapper to the kernel crypto API function of
- * crypto_rng_generate() to allow the caller to provide additional data and
- * allow furnishing of test_data
- *
- * @drng DRBG handle -- see crypto_rng_get_bytes
- * @outbuf output buffer -- see crypto_rng_get_bytes
- * @outlen length of output buffer -- see crypto_rng_get_bytes
- * @addtl_input additional information string input buffer
- * @addtllen length of additional information string buffer
- * @test_data filled test data
- *
- * return
- *	see crypto_rng_get_bytes
- */
-static inline int crypto_drbg_get_bytes_addtl_test(struct crypto_rng *drng,
-			unsigned char *outbuf, unsigned int outlen,
-			struct drbg_string *addtl,
-			struct drbg_test_data *test_data)
-{
-	crypto_rng_set_entropy(drng, test_data->testentropy->buf,
-			       test_data->testentropy->len);
-	return crypto_rng_generate(drng, addtl->buf, addtl->len,
-				   outbuf, outlen);
-}
-
-/*
- * TEST code
- *
- * This is a wrapper to the kernel crypto API function of
- * crypto_rng_reset() to allow the caller to provide test_data
- *
- * @drng DRBG handle -- see crypto_rng_reset
- * @pers personalization string input buffer
- * @perslen length of additional information string buffer
- * @test_data filled test data
- *
- * return
- *	see crypto_rng_reset
- */
-static inline int crypto_drbg_reset_test(struct crypto_rng *drng,
-					 struct drbg_string *pers,
-					 struct drbg_test_data *test_data)
-{
-	crypto_rng_set_entropy(drng, test_data->testentropy->buf,
-			       test_data->testentropy->len);
-	return crypto_rng_reset(drng, pers->buf, pers->len);
-}
-
 /* DRBG type flags */
 #define DRBG_CTR	((drbg_flag_t)1<<0)
 #define DRBG_HMAC	((drbg_flag_t)1<<1)
-- 
2.33.1




