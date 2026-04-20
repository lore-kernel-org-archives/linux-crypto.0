Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C7E38836D;
	Mon, 20 Apr 2026 06:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776667026; cv=none; b=tOBn88cOhDZ7/h7FXfmtOdbxGdAQlCVExJ/1r9XTEE72jFoxUw707rMZ+1SqgEUlJCbeVVuwX6RK3LX8EXKp0PdIVEaw0lsTZmwkzeZYLJBx2z1pj8vGVJDyqyYlrbphoDl9GmHq6/sl3UW5hE45705gftMX1CerYFg1bIMdvzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776667026; c=relaxed/simple;
	bh=zzFCH0KnOpAsHnvWir879hACmOS8kb5vbZ1hTL7p5A4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JlcVsjVcOqVyo9aB02zvlBWaUTMUiVHcF6KyWzpgX5p/2EPifucfp/3vgJ2m0Lz0V4JW8AJGh5N0jySiZ/RubqtiynpGA0DMZStm6/9nFc7ttdjfqnsTKhQvmn5wOcw7moNouIZXwguYX4aGM9H3DE720FzSgOS7MvHZgPVmzIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DsARZgyd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DsARZgyd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2184EC19425;
	Mon, 20 Apr 2026 06:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776667026;
	bh=zzFCH0KnOpAsHnvWir879hACmOS8kb5vbZ1hTL7p5A4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DsARZgydcpUMWDPZemrRYS7kJbQNBEuTZe3R0cL2NpXBuy5KkDYs93T5I/CY1XtY9
	 Byd16Ja5dprRq2KPA4hsoOlnCnYXQu2GCvk8NZjoFAlSOxzxX/m5E18GotzUD2kWkH
	 vtp+sU0LV5f6kUNQtFfuXZN7t99nh/6SI6wTGXJGE1ZQhrVF5O19QNQz0W8jLTxC0Y
	 eZhK03s6y+hkuNVrUTD396zr4WZcAMH1F8rSfFpvwxWrLF0M5+Yk0w2JLizxpvolmo
	 Yr9VS1mwPSLkSn8LElxQ79n0Yk9Dscr+WUgMfU9RdLHCTU6m1bMtwBUsnbgSQOFYA2
	 fTagKScNASunQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 22/38] crypto: drbg - Use HMAC-SHA512 library API
Date: Sun, 19 Apr 2026 23:34:06 -0700
Message-ID: <20260420063422.324906-23-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420063422.324906-1-ebiggers@kernel.org>
References: <20260420063422.324906-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since the HMAC algorithm is now fixed at HMAC-SHA512, just use the
HMAC-SHA512 library API.  This is simpler and more efficient.

Remove error-handling code that is no longer needed.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/Kconfig |   3 +-
 crypto/drbg.c  | 213 ++++++++++---------------------------------------
 2 files changed, 41 insertions(+), 175 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 1abb3d356458..608b2c739193 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1113,14 +1113,13 @@ endmenu
 
 menu "Random number generation"
 
 config CRYPTO_DRBG
 	tristate "NIST SP800-90A DRBG (Deterministic Random Bit Generator)"
-	select CRYPTO_HMAC
 	select CRYPTO_JITTERENTROPY
+	select CRYPTO_LIB_SHA512
 	select CRYPTO_RNG
-	select CRYPTO_SHA512
 	help
 	  DRBG (Deterministic Random Bit Generator) (NIST SP800-90A)
 
 	  Enable this only if you need it for a FIPS 140 certification.
 	  It's otherwise redundant with the kernel's regular RNG.
diff --git a/crypto/drbg.c b/crypto/drbg.c
index e62bde7aab43..4f326385cf36 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -2,10 +2,11 @@
  * DRBG: Deterministic Random Bits Generator
  *       Implementation of the HMAC SHA-512 DRBG from NIST SP800-90A,
  *       both with and without prediction resistance
  *
  * Copyright Stephan Mueller <smueller@chronox.de>, 2014
+ * Copyright 2026 Google LLC
  *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
  * are met:
  * 1. Redistributions of source code must retain the above copyright
@@ -88,11 +89,10 @@
  * Just mix both scenarios above.
  */
 
 #include <crypto/internal/drbg.h>
 #include <crypto/internal/rng.h>
-#include <crypto/hash.h>
 #include <crypto/sha2.h>
 #include <linux/fips.h>
 #include <linux/kernel.h>
 #include <linux/jiffies.h>
 #include <linux/module.h>
@@ -141,16 +141,15 @@ enum drbg_seed_state {
 #define DRBG_MAX_ADDTL		(U32_MAX - 1)
 
 struct drbg_state {
 	struct mutex drbg_mutex;	/* lock around DRBG */
 	u8 V[DRBG_STATE_LEN];		/* internal state -- 10.1.2.1 1a */
+	struct hmac_sha512_key key;	/* current key -- 10.1.2.1 1b */
 	u8 C[DRBG_STATE_LEN];		/* current key -- 10.1.2.1 1b */
 	/* Number of RNG requests since last reseed -- 10.1.2.1 1c */
 	size_t reseed_ctr;
 	size_t reseed_threshold;
-	void *priv_data;	/* Cipher handle */
-
 	enum drbg_seed_state seeded;		/* DRBG fully seeded? */
 	unsigned long last_seed_time;
 	bool pr;		/* Prediction resistance enabled? */
 	struct crypto_rng *jent;
 	const struct drbg_core *core;
@@ -184,124 +183,90 @@ static int drbg_uninstantiate(struct drbg_state *drbg);
 
 /******************************************************************
  * HMAC DRBG functions
  ******************************************************************/
 
-static int drbg_kcapi_hash(struct drbg_state *drbg, unsigned char *outval,
-			   const struct list_head *in);
-static void drbg_kcapi_hmacsetkey(struct drbg_state *drbg,
-				  const unsigned char *key);
-static int drbg_init_hash_kernel(struct drbg_state *drbg);
-static int drbg_fini_hash_kernel(struct drbg_state *drbg);
-
 MODULE_ALIAS_CRYPTO("drbg_pr_hmac_sha512");
 MODULE_ALIAS_CRYPTO("drbg_nopr_hmac_sha512");
 
 /* update function of HMAC DRBG as defined in 10.1.2.2 */
-static int drbg_hmac_update(struct drbg_state *drbg, struct list_head *seed,
-			    int reseed)
+static void drbg_hmac_update(struct drbg_state *drbg, struct list_head *seed,
+			     int reseed)
 {
-	int ret = -EFAULT;
 	int i = 0;
-	struct drbg_string seed1, seed2, vdata;
-	LIST_HEAD(seedlist);
-	LIST_HEAD(vdatalist);
+	struct hmac_sha512_ctx hmac_ctx;
 
 	if (!reseed) {
 		/* 10.1.2.3 step 2 -- memset(0) of C is implicit with kzalloc */
 		memset(drbg->V, 1, DRBG_STATE_LEN);
-		drbg_kcapi_hmacsetkey(drbg, drbg->C);
+		hmac_sha512_preparekey(&drbg->key, drbg->C, DRBG_STATE_LEN);
 	}
 
-	drbg_string_fill(&seed1, drbg->V, DRBG_STATE_LEN);
-	list_add_tail(&seed1.list, &seedlist);
-	/* buffer of seed2 will be filled in for loop below with one byte */
-	drbg_string_fill(&seed2, NULL, 1);
-	list_add_tail(&seed2.list, &seedlist);
-	/* input data of seed is allowed to be NULL at this point */
-	if (seed)
-		list_splice_tail(seed, &seedlist);
-
-	drbg_string_fill(&vdata, drbg->V, DRBG_STATE_LEN);
-	list_add_tail(&vdata.list, &vdatalist);
 	for (i = 2; 0 < i; i--) {
 		/* first round uses 0x0, second 0x1 */
 		unsigned char prefix = DRBG_PREFIX0;
 		if (1 == i)
 			prefix = DRBG_PREFIX1;
 		/* 10.1.2.2 step 1 and 4 -- concatenation and HMAC for key */
-		seed2.buf = &prefix;
-		ret = drbg_kcapi_hash(drbg, drbg->C, &seedlist);
-		if (ret)
-			return ret;
-		drbg_kcapi_hmacsetkey(drbg, drbg->C);
+		hmac_sha512_init(&hmac_ctx, &drbg->key);
+		hmac_sha512_update(&hmac_ctx, drbg->V, DRBG_STATE_LEN);
+		hmac_sha512_update(&hmac_ctx, &prefix, 1);
+		if (seed) {
+			struct drbg_string *input;
+
+			list_for_each_entry(input, seed, list)
+				hmac_sha512_update(&hmac_ctx, input->buf,
+						   input->len);
+		}
+		hmac_sha512_final(&hmac_ctx, drbg->C);
+		hmac_sha512_preparekey(&drbg->key, drbg->C, DRBG_STATE_LEN);
 
 		/* 10.1.2.2 step 2 and 5 -- HMAC for V */
-		ret = drbg_kcapi_hash(drbg, drbg->V, &vdatalist);
-		if (ret)
-			return ret;
+		hmac_sha512(&drbg->key, drbg->V, DRBG_STATE_LEN, drbg->V);
 
 		/* 10.1.2.2 step 3 */
 		if (!seed)
-			return ret;
+			break;
 	}
-
-	return 0;
 }
 
 /* generate function of HMAC DRBG as defined in 10.1.2.5 */
-static int drbg_hmac_generate(struct drbg_state *drbg,
-			      unsigned char *buf,
-			      unsigned int buflen,
-			      struct list_head *addtl)
+static void drbg_hmac_generate(struct drbg_state *drbg,
+			       unsigned char *buf,
+			       unsigned int buflen,
+			       struct list_head *addtl)
 {
 	int len = 0;
-	int ret = 0;
-	struct drbg_string data;
-	LIST_HEAD(datalist);
 
 	/* 10.1.2.5 step 2 */
-	if (addtl && !list_empty(addtl)) {
-		ret = drbg_hmac_update(drbg, addtl, 1);
-		if (ret)
-			return ret;
-	}
+	if (addtl && !list_empty(addtl))
+		drbg_hmac_update(drbg, addtl, 1);
 
-	drbg_string_fill(&data, drbg->V, DRBG_STATE_LEN);
-	list_add_tail(&data.list, &datalist);
 	while (len < buflen) {
 		unsigned int outlen = 0;
+
 		/* 10.1.2.5 step 4.1 */
-		ret = drbg_kcapi_hash(drbg, drbg->V, &datalist);
-		if (ret)
-			return ret;
+		hmac_sha512(&drbg->key, drbg->V, DRBG_STATE_LEN, drbg->V);
 		outlen = (DRBG_STATE_LEN < (buflen - len)) ?
 			  DRBG_STATE_LEN : (buflen - len);
 
 		/* 10.1.2.5 step 4.2 */
 		memcpy(buf + len, drbg->V, outlen);
 		len += outlen;
 	}
 
 	/* 10.1.2.5 step 6 */
 	if (addtl && !list_empty(addtl))
-		ret = drbg_hmac_update(drbg, addtl, 1);
+		drbg_hmac_update(drbg, addtl, 1);
 	else
-		ret = drbg_hmac_update(drbg, NULL, 1);
-	if (ret)
-		return ret;
-
-	return len;
+		drbg_hmac_update(drbg, NULL, 1);
 }
 
-static inline int __drbg_seed(struct drbg_state *drbg, struct list_head *seed,
-			      int reseed, enum drbg_seed_state new_seed_state)
+static inline void __drbg_seed(struct drbg_state *drbg, struct list_head *seed,
+			       int reseed, enum drbg_seed_state new_seed_state)
 {
-	int ret = drbg_hmac_update(drbg, seed, reseed);
-
-	if (ret)
-		return ret;
+	drbg_hmac_update(drbg, seed, reseed);
 
 	drbg->seeded = new_seed_state;
 	drbg->last_seed_time = jiffies;
 	drbg->reseed_ctr = 1;
 
@@ -323,31 +288,27 @@ static inline int __drbg_seed(struct drbg_state *drbg, struct list_head *seed,
 		 * reseeds no longer required.
 		 */
 		drbg->reseed_threshold = DRBG_MAX_REQUESTS;
 		break;
 	}
-
-	return ret;
 }
 
-static int drbg_seed_from_random(struct drbg_state *drbg)
+static void drbg_seed_from_random(struct drbg_state *drbg)
 	__must_hold(&drbg->drbg_mutex)
 {
 	struct drbg_string data;
 	LIST_HEAD(seedlist);
 	unsigned char entropy[DRBG_SEC_STRENGTH];
-	int ret;
 
 	drbg_string_fill(&data, entropy, DRBG_SEC_STRENGTH);
 	list_add_tail(&data.list, &seedlist);
 
 	get_random_bytes(entropy, DRBG_SEC_STRENGTH);
 
-	ret = __drbg_seed(drbg, &seedlist, true, DRBG_SEED_STATE_FULL);
+	__drbg_seed(drbg, &seedlist, true, DRBG_SEED_STATE_FULL);
 
 	memzero_explicit(entropy, DRBG_SEC_STRENGTH);
-	return ret;
 }
 
 static bool drbg_nopr_reseed_interval_elapsed(struct drbg_state *drbg)
 {
 	unsigned long next_reseed;
@@ -475,12 +436,12 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
 	if (!reseed) {
 		memset(drbg->V, 0, DRBG_STATE_LEN);
 		memset(drbg->C, 0, DRBG_STATE_LEN);
 	}
 
-	ret = __drbg_seed(drbg, &seedlist, reseed, new_seed_state);
-
+	__drbg_seed(drbg, &seedlist, reseed, new_seed_state);
+	ret = 0;
 out:
 	memzero_explicit(entropy, sizeof(entropy));
 
 	return ret;
 }
@@ -488,34 +449,17 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
 /* Free all substructures in a DRBG state without the DRBG state structure */
 static inline void drbg_dealloc_state(struct drbg_state *drbg)
 {
 	if (!drbg)
 		return;
+	memzero_explicit(&drbg->key, sizeof(drbg->key));
 	memzero_explicit(drbg->V, sizeof(drbg->V));
 	memzero_explicit(drbg->C, sizeof(drbg->C));
 	drbg->reseed_ctr = 0;
 	drbg->core = NULL;
 }
 
-/*
- * Allocate all sub-structures for a DRBG state.
- * The DRBG state structure must already be allocated.
- */
-static inline int drbg_alloc_state(struct drbg_state *drbg)
-{
-	int ret = -ENOMEM;
-
-	ret = drbg_init_hash_kernel(drbg);
-	if (ret < 0)
-		goto err;
-	return 0;
-
-err:
-	drbg_dealloc_state(drbg);
-	return ret;
-}
-
 /*
  * DRBG generate function as required by SP800-90A - this function
  * generates random numbers
  *
  * @drbg DRBG state handle
@@ -588,24 +532,20 @@ static int drbg_generate(struct drbg_state *drbg,
 		/* 9.3.1 step 7.4 */
 		addtl = NULL;
 	} else if (rng_is_initialized() &&
 		   (drbg->seeded == DRBG_SEED_STATE_PARTIAL ||
 		    drbg_nopr_reseed_interval_elapsed(drbg))) {
-		len = drbg_seed_from_random(drbg);
-		if (len)
-			goto err;
+		drbg_seed_from_random(drbg);
 	}
 
 	if (addtl && 0 < addtl->len)
 		list_add_tail(&addtl->list, &addtllist);
 	/* 9.3.1 step 8 and 10 */
-	len = drbg_hmac_generate(drbg, buf, buflen, &addtllist);
+	drbg_hmac_generate(drbg, buf, buflen, &addtllist);
 
 	/* 10.1.2.5 step 7 */
 	drbg->reseed_ctr++;
-	if (0 >= len)
-		goto err;
 
 	/*
 	 * Section 11.3.3 requires to re-perform self tests after some
 	 * generated random numbers. The chosen value after which self
 	 * test is performed is arbitrary, but it should be reasonable.
@@ -716,14 +656,10 @@ static int drbg_instantiate(struct drbg_state *drbg, struct drbg_string *pers,
 		drbg->pr = pr;
 		drbg->seeded = DRBG_SEED_STATE_UNSEEDED;
 		drbg->last_seed_time = 0;
 		drbg->reseed_threshold = DRBG_MAX_REQUESTS;
 
-		ret = drbg_alloc_state(drbg);
-		if (ret)
-			goto unlock;
-
 		ret = drbg_prepare_hrng(drbg);
 		if (ret)
 			goto free_everything;
 
 		reseed = false;
@@ -735,14 +671,10 @@ static int drbg_instantiate(struct drbg_state *drbg, struct drbg_string *pers,
 		goto free_everything;
 
 	mutex_unlock(&drbg->drbg_mutex);
 	return ret;
 
-unlock:
-	mutex_unlock(&drbg->drbg_mutex);
-	return ret;
-
 free_everything:
 	mutex_unlock(&drbg->drbg_mutex);
 	drbg_uninstantiate(drbg);
 	return ret;
 }
@@ -760,11 +692,10 @@ static int drbg_uninstantiate(struct drbg_state *drbg)
 {
 	if (!IS_ERR_OR_NULL(drbg->jent))
 		crypto_free_rng(drbg->jent);
 	drbg->jent = NULL;
 
-	drbg_fini_hash_kernel(drbg);
 	drbg_dealloc_state(drbg);
 	/* no scrubbing of test_data -- this shall survive an uninstantiate */
 	return 0;
 }
 
@@ -783,74 +714,10 @@ static void drbg_kcapi_set_entropy(struct crypto_rng *tfm,
 	mutex_lock(&drbg->drbg_mutex);
 	drbg_string_fill(&drbg->test_data, data, len);
 	mutex_unlock(&drbg->drbg_mutex);
 }
 
-/***************************************************************
- * Kernel crypto API cipher invocations requested by DRBG
- ***************************************************************/
-
-struct sdesc {
-	struct shash_desc shash;
-};
-
-static int drbg_init_hash_kernel(struct drbg_state *drbg)
-{
-	struct sdesc *sdesc;
-	struct crypto_shash *tfm;
-
-	tfm = crypto_alloc_shash(drbg->core->backend_cra_name, 0, 0);
-	if (IS_ERR(tfm)) {
-		pr_info("DRBG: could not allocate digest TFM handle: %s\n",
-				drbg->core->backend_cra_name);
-		return PTR_ERR(tfm);
-	}
-	BUG_ON(DRBG_STATE_LEN != crypto_shash_digestsize(tfm));
-	sdesc = kzalloc(sizeof(struct shash_desc) + crypto_shash_descsize(tfm),
-			GFP_KERNEL);
-	if (!sdesc) {
-		crypto_free_shash(tfm);
-		return -ENOMEM;
-	}
-
-	sdesc->shash.tfm = tfm;
-	drbg->priv_data = sdesc;
-
-	return 0;
-}
-
-static int drbg_fini_hash_kernel(struct drbg_state *drbg)
-{
-	struct sdesc *sdesc = drbg->priv_data;
-	if (sdesc) {
-		crypto_free_shash(sdesc->shash.tfm);
-		kfree_sensitive(sdesc);
-	}
-	drbg->priv_data = NULL;
-	return 0;
-}
-
-static void drbg_kcapi_hmacsetkey(struct drbg_state *drbg,
-				  const unsigned char *key)
-{
-	struct sdesc *sdesc = drbg->priv_data;
-
-	crypto_shash_setkey(sdesc->shash.tfm, key, DRBG_STATE_LEN);
-}
-
-static int drbg_kcapi_hash(struct drbg_state *drbg, unsigned char *outval,
-			   const struct list_head *in)
-{
-	struct sdesc *sdesc = drbg->priv_data;
-	struct drbg_string *input = NULL;
-
-	crypto_shash_init(&sdesc->shash);
-	list_for_each_entry(input, in, list)
-		crypto_shash_update(&sdesc->shash, input->buf, input->len);
-	return crypto_shash_final(&sdesc->shash, outval);
-}
-
 /***************************************************************
  * Kernel crypto API interface to register DRBG
  ***************************************************************/
 
 /*
-- 
2.53.0

