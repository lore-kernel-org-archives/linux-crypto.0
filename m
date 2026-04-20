Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B84338A707;
	Mon, 20 Apr 2026 06:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776667028; cv=none; b=Yi8O//DkiM/klfujFCyBaW5ioMbXde5ZOzXye615xxYpp1uSWerDU4YBuGAS9ATd60m75wzJs2UkCbQq/Xu8SlWaHx9wx9bBY9hVl5jmTFd4Wcm9X/HpQJmh9pr2X3XV5VhC/rj5YbB9Yuod6h493yujbv/TKCQx1OKs9a9T/0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776667028; c=relaxed/simple;
	bh=gIhoMgxti7dBPNACnVTQxAD2wGAJf4EW5s0NlkoSJec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U97LzTM+jyz8z//CwNgwk4CgGthYB80op03xNyAp8TO6VmJGOYy+/e/1PkoG8RBHW7lduUXeh/mxwIiRim9aqIKwR3hz9oZZ0k6XcnKZeEf1miPohI+ojun+7dtvBWl53xqw299SkQg6zT1SHAoHCGwJDdpvTvMqymu1CbOO7SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NV41mknZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NV41mknZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0D75C2BCB8;
	Mon, 20 Apr 2026 06:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776667027;
	bh=gIhoMgxti7dBPNACnVTQxAD2wGAJf4EW5s0NlkoSJec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NV41mknZsPgdNXJD7AI7kV0tHwqaAFdnDHbVX8QraEDCaFnglfCjZzKh2b3Q2PYBG
	 EYRZycbMtM0VlqvHtvz0x+cEvCEpjWYpacEurGrTPuIhjh8FIqLlZibp9FmBZt7EwH
	 BAUa0F68A8kFfd1uP8ZQZ7yV6hOp90sxbpxi7J/2FDzZ28VSNati9uF6Od2h3No9L+
	 /5bxju7oKtqQSeQvhHsvMIm5W7m11QOMTAidWf/3C/nbvnvkofRXmgv1A93brEm/k0
	 +y00Pe1dlNHoWCUcLJt6ikZm9nQavgon/LJYceVBFon8i0xYkworDC8/31H+fKKHjw
	 ilakZpeQL+Y0Q==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 27/38] crypto: drbg - Eliminate use of 'drbg_string' and lists
Date: Sun, 19 Apr 2026 23:34:11 -0700
Message-ID: <20260420063422.324906-28-ebiggers@kernel.org>
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

Use straightforward (buffer, len) parameters instead of struct
drbg_string or lists of strings.  This simplifies the code considerably.

For now struct drbg_string is still used in crypto_drbg_ctr_df(), so
move its definition to crypto/df_sp80090a.h.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/df_sp80090a.c                |   1 -
 crypto/drbg.c                       | 179 +++++++++++-----------------
 drivers/crypto/xilinx/xilinx-trng.c |   1 -
 include/crypto/df_sp80090a.h        |  25 ++++
 include/crypto/internal/drbg.h      |  39 ------
 5 files changed, 94 insertions(+), 151 deletions(-)
 delete mode 100644 include/crypto/internal/drbg.h

diff --git a/crypto/df_sp80090a.c b/crypto/df_sp80090a.c
index f4bb7be016e8..90e1973ee40c 100644
--- a/crypto/df_sp80090a.c
+++ b/crypto/df_sp80090a.c
@@ -11,11 +11,10 @@
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/unaligned.h>
 #include <crypto/aes.h>
 #include <crypto/df_sp80090a.h>
-#include <crypto/internal/drbg.h>
 
 static void drbg_kcapi_sym(struct aes_enckey *aeskey, unsigned char *outval,
 			   const struct drbg_string *in, u8 blocklen_bytes)
 {
 	/* there is only component in *in */
diff --git a/crypto/drbg.c b/crypto/drbg.c
index 7e3ab2f811b6..b0cd8da51b26 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -87,11 +87,10 @@
  * Usage with personalization and additional information strings
  * -------------------------------------------------------------
  * Just mix both scenarios above.
  */
 
-#include <crypto/internal/drbg.h>
 #include <crypto/internal/rng.h>
 #include <crypto/sha2.h>
 #include <linux/fips.h>
 #include <linux/kernel.h>
 #include <linux/jiffies.h>
@@ -142,11 +141,12 @@ struct drbg_state {
 	enum drbg_seed_state seeded;		/* DRBG fully seeded? */
 	unsigned long last_seed_time;
 	bool instantiated;
 	bool pr;		/* Prediction resistance enabled? */
 	struct crypto_rng *jent;
-	struct drbg_string test_data;
+	const u8 *test_entropy;
+	size_t test_entropylen;
 };
 
 enum drbg_prefixes {
 	DRBG_PREFIX0 = 0x00,
 	DRBG_PREFIX1,
@@ -157,11 +157,13 @@ static int drbg_uninstantiate(struct drbg_state *drbg);
 /******************************************************************
  * HMAC DRBG functions
  ******************************************************************/
 
 /* update function of HMAC DRBG as defined in 10.1.2.2 */
-static void drbg_hmac_update(struct drbg_state *drbg, struct list_head *seed)
+static void drbg_hmac_update(struct drbg_state *drbg,
+			     const u8 *data1, size_t data1_len,
+			     const u8 *data2, size_t data2_len)
 {
 	int i = 0;
 	struct hmac_sha512_ctx hmac_ctx;
 	u8 new_key[DRBG_STATE_LEN];
 
@@ -172,41 +174,36 @@ static void drbg_hmac_update(struct drbg_state *drbg, struct list_head *seed)
 			prefix = DRBG_PREFIX1;
 		/* 10.1.2.2 step 1 and 4 -- concatenation and HMAC for key */
 		hmac_sha512_init(&hmac_ctx, &drbg->key);
 		hmac_sha512_update(&hmac_ctx, drbg->V, DRBG_STATE_LEN);
 		hmac_sha512_update(&hmac_ctx, &prefix, 1);
-		if (seed) {
-			struct drbg_string *input;
-
-			list_for_each_entry(input, seed, list)
-				hmac_sha512_update(&hmac_ctx, input->buf,
-						   input->len);
-		}
+		hmac_sha512_update(&hmac_ctx, data1, data1_len);
+		hmac_sha512_update(&hmac_ctx, data2, data2_len);
 		hmac_sha512_final(&hmac_ctx, new_key);
 		hmac_sha512_preparekey(&drbg->key, new_key, DRBG_STATE_LEN);
 
 		/* 10.1.2.2 step 2 and 5 -- HMAC for V */
 		hmac_sha512(&drbg->key, drbg->V, DRBG_STATE_LEN, drbg->V);
 
 		/* 10.1.2.2 step 3 */
-		if (!seed)
+		if (data1_len == 0 && data2_len == 0)
 			break;
 	}
 	memzero_explicit(new_key, sizeof(new_key));
 }
 
 /* generate function of HMAC DRBG as defined in 10.1.2.5 */
 static void drbg_hmac_generate(struct drbg_state *drbg,
 			       unsigned char *buf,
 			       unsigned int buflen,
-			       struct list_head *addtl)
+			       const u8 *addtl, size_t addtl_len)
 {
 	int len = 0;
 
 	/* 10.1.2.5 step 2 */
-	if (addtl && !list_empty(addtl))
-		drbg_hmac_update(drbg, addtl);
+	if (addtl_len)
+		drbg_hmac_update(drbg, addtl, addtl_len, NULL, 0);
 
 	while (len < buflen) {
 		unsigned int outlen = 0;
 
 		/* 10.1.2.5 step 4.1 */
@@ -218,20 +215,19 @@ static void drbg_hmac_generate(struct drbg_state *drbg,
 		memcpy(buf + len, drbg->V, outlen);
 		len += outlen;
 	}
 
 	/* 10.1.2.5 step 6 */
-	if (addtl && !list_empty(addtl))
-		drbg_hmac_update(drbg, addtl);
-	else
-		drbg_hmac_update(drbg, NULL);
+	drbg_hmac_update(drbg, addtl, addtl_len, NULL, 0);
 }
 
-static inline void __drbg_seed(struct drbg_state *drbg, struct list_head *seed,
+static inline void __drbg_seed(struct drbg_state *drbg,
+			       const u8 *seed1, size_t seed1_len,
+			       const u8 *seed2, size_t seed2_len,
 			       enum drbg_seed_state new_seed_state)
 {
-	drbg_hmac_update(drbg, seed);
+	drbg_hmac_update(drbg, seed1, seed1_len, seed2, seed2_len);
 
 	drbg->seeded = new_seed_state;
 	drbg->last_seed_time = jiffies;
 	drbg->reseed_ctr = 1;
 
@@ -258,30 +254,26 @@ static inline void __drbg_seed(struct drbg_state *drbg, struct list_head *seed,
 }
 
 static void drbg_seed_from_random(struct drbg_state *drbg)
 	__must_hold(&drbg->drbg_mutex)
 {
-	struct drbg_string data;
-	LIST_HEAD(seedlist);
-	unsigned char entropy[DRBG_SEC_STRENGTH];
-
-	drbg_string_fill(&data, entropy, DRBG_SEC_STRENGTH);
-	list_add_tail(&data.list, &seedlist);
+	u8 entropy[DRBG_SEC_STRENGTH];
 
 	get_random_bytes(entropy, DRBG_SEC_STRENGTH);
 
-	__drbg_seed(drbg, &seedlist, DRBG_SEED_STATE_FULL);
+	__drbg_seed(drbg, entropy, DRBG_SEC_STRENGTH, NULL, 0,
+		    DRBG_SEED_STATE_FULL);
 
 	memzero_explicit(entropy, DRBG_SEC_STRENGTH);
 }
 
 static bool drbg_nopr_reseed_interval_elapsed(struct drbg_state *drbg)
 {
 	unsigned long next_reseed;
 
 	/* Don't ever reseed from get_random_bytes() in test mode. */
-	if (list_empty(&drbg->test_data.list))
+	if (drbg->test_entropylen)
 		return false;
 
 	/*
 	 * Obtain fresh entropy for the nopr DRBGs after 300s have
 	 * elapsed in order to still achieve sort of partial
@@ -297,70 +289,70 @@ static bool drbg_nopr_reseed_interval_elapsed(struct drbg_state *drbg)
 /*
  * Seeding or reseeding of the DRBG
  *
  * @drbg: DRBG state struct
  * @pers: personalization / additional information buffer
- * @reseed: 0 for initial seed process, 1 for reseeding
+ * @pers_len: length of @pers in bytes
+ * @reseed: false for initial seeding (instantiation), true for reseeding
  *
  * return:
  *	0 on success
  *	error value otherwise
  */
-static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
+static int drbg_seed(struct drbg_state *drbg, const u8 *pers, size_t pers_len,
 		     bool reseed)
 	__must_hold(&drbg->drbg_mutex)
 {
 	int ret;
-	unsigned char entropy[((32 + 16) * 2)];
-	unsigned int entropylen;
-	struct drbg_string data1;
-	LIST_HEAD(seedlist);
+	u8 entropy_buf[(32 + 16) * 2];
+	size_t entropylen;
+	const u8 *entropy;
 	enum drbg_seed_state new_seed_state = DRBG_SEED_STATE_FULL;
 
 	/* 9.1 / 9.2 / 9.3.1 step 3 */
-	if (pers && pers->len > DRBG_MAX_ADDTL) {
+	if (pers_len > DRBG_MAX_ADDTL) {
 		pr_devel("DRBG: personalization string too long %zu\n",
-			 pers->len);
+			 pers_len);
 		return -EINVAL;
 	}
 
-	if (list_empty(&drbg->test_data.list)) {
-		drbg_string_fill(&data1, drbg->test_data.buf,
-				 drbg->test_data.len);
+	if (drbg->test_entropylen) {
+		entropy = drbg->test_entropy;
+		entropylen = drbg->test_entropylen;
 		pr_devel("DRBG: using test entropy\n");
 	} else {
 		/*
 		 * Gather entropy equal to the security strength of the DRBG.
 		 * With a derivation function, a nonce is required in addition
 		 * to the entropy. A nonce must be at least 1/2 of the security
 		 * strength of the DRBG in size. Thus, entropy + nonce is 3/2
 		 * of the strength. The consideration of a nonce is only
 		 * applicable during initial seeding.
 		 */
+		entropy = entropy_buf;
 		if (!reseed)
 			entropylen = ((DRBG_SEC_STRENGTH + 1) / 2) * 3;
 		else
 			entropylen = DRBG_SEC_STRENGTH;
-		BUG_ON((entropylen * 2) > sizeof(entropy));
+		BUG_ON(entropylen * 2 > sizeof(entropy_buf));
 
 		/* Get seed from in-kernel /dev/urandom */
 		if (!rng_is_initialized())
 			new_seed_state = DRBG_SEED_STATE_PARTIAL;
 
-		get_random_bytes(entropy, entropylen);
+		get_random_bytes(entropy_buf, entropylen);
 
 		if (!drbg->jent) {
-			drbg_string_fill(&data1, entropy, entropylen);
-			pr_devel("DRBG: (re)seeding with %u bytes of entropy\n",
+			pr_devel("DRBG: (re)seeding with %zu bytes of entropy\n",
 				 entropylen);
 		} else {
 			/*
 			 * Get seed from Jitter RNG, failures are
 			 * fatal only in FIPS mode.
 			 */
 			ret = crypto_rng_get_bytes(drbg->jent,
-						   entropy + entropylen,
+						   &entropy_buf[entropylen],
 						   entropylen);
 			if (fips_enabled && ret) {
 				pr_devel("DRBG: jent failed with %d\n", ret);
 
 				/*
@@ -379,32 +371,23 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
 				 */
 				if (!reseed || ret != -EAGAIN)
 					goto out;
 			}
 
-			drbg_string_fill(&data1, entropy, entropylen * 2);
-			pr_devel("DRBG: (re)seeding with %u bytes of entropy\n",
-				 entropylen * 2);
+			entropylen *= 2;
+			pr_devel("DRBG: (re)seeding with %zu bytes of entropy\n",
+				 entropylen);
 		}
 	}
-	list_add_tail(&data1.list, &seedlist);
 
-	/*
-	 * concatenation of entropy with personalization str / addtl input)
-	 * the variable pers is directly handed in by the caller, so check its
-	 * contents whether it is appropriate
-	 */
-	if (pers && pers->buf && 0 < pers->len) {
-		list_add_tail(&pers->list, &seedlist);
+	if (pers_len)
 		pr_devel("DRBG: using personalization string\n");
-	}
 
-
-	__drbg_seed(drbg, &seedlist, new_seed_state);
+	__drbg_seed(drbg, entropy, entropylen, pers, pers_len, new_seed_state);
 	ret = 0;
 out:
-	memzero_explicit(entropy, sizeof(entropy));
+	memzero_explicit(entropy_buf, sizeof(entropy_buf));
 
 	return ret;
 }
 
 /* Free all substructures in a DRBG state without the DRBG state structure */
@@ -425,34 +408,31 @@ static inline void drbg_dealloc_state(struct drbg_state *drbg)
  * @drbg DRBG state handle
  * @buf Buffer where to store the random numbers -- the buffer must already
  *      be pre-allocated by caller
  * @buflen Length of output buffer - this value defines the number of random
  *	   bytes pulled from DRBG
- * @addtl Additional input that is mixed into state, may be NULL -- note
- *	  the entropy is pulled by the DRBG internally unconditionally
- *	  as defined in SP800-90A. The additional input is mixed into
- *	  the state in addition to the pulled entropy.
+ * @addtl Optional additional input that is mixed into state
+ * @addtl_len Length of @addtl in bytes, may be 0
  *
  * return: 0 when all bytes are generated; < 0 in case of an error
  */
 static int drbg_generate(struct drbg_state *drbg,
 			 unsigned char *buf, unsigned int buflen,
-			 struct drbg_string *addtl)
+			 const u8 *addtl, size_t addtl_len)
 	__must_hold(&drbg->drbg_mutex)
 {
 	int len = 0;
-	LIST_HEAD(addtllist);
 
 	if (!drbg->instantiated) {
 		pr_devel("DRBG: not yet instantiated\n");
 		return -EINVAL;
 	}
 	if (0 == buflen || !buf) {
 		pr_devel("DRBG: no output buffer provided\n");
 		return -EINVAL;
 	}
-	if (addtl && NULL == addtl->buf && 0 < addtl->len) {
+	if (addtl == NULL && addtl_len != 0) {
 		pr_devel("DRBG: wrong format of additional information\n");
 		return -EINVAL;
 	}
 
 	/* 9.3.1 step 2 */
@@ -463,13 +443,13 @@ static int drbg_generate(struct drbg_state *drbg,
 	}
 
 	/* 9.3.1 step 3 is implicit with the chosen DRBG */
 
 	/* 9.3.1 step 4 */
-	if (addtl && addtl->len > DRBG_MAX_ADDTL) {
+	if (addtl_len > DRBG_MAX_ADDTL) {
 		pr_devel("DRBG: additional information string too long %zu\n",
-			 addtl->len);
+			 addtl_len);
 		return -EINVAL;
 	}
 	/* 9.3.1 step 5 is implicit with the chosen DRBG */
 
 	/*
@@ -484,25 +464,24 @@ static int drbg_generate(struct drbg_state *drbg,
 			 "resistance: %s, state %s)\n",
 			 str_true_false(drbg->pr),
 			 (drbg->seeded ==  DRBG_SEED_STATE_FULL ?
 			  "seeded" : "unseeded"));
 		/* 9.3.1 steps 7.1 through 7.3 */
-		len = drbg_seed(drbg, addtl, true);
+		len = drbg_seed(drbg, addtl, addtl_len, true);
 		if (len)
 			goto err;
 		/* 9.3.1 step 7.4 */
 		addtl = NULL;
+		addtl_len = 0;
 	} else if (rng_is_initialized() &&
 		   (drbg->seeded == DRBG_SEED_STATE_PARTIAL ||
 		    drbg_nopr_reseed_interval_elapsed(drbg))) {
 		drbg_seed_from_random(drbg);
 	}
 
-	if (addtl && 0 < addtl->len)
-		list_add_tail(&addtl->list, &addtllist);
 	/* 9.3.1 step 8 and 10 */
-	drbg_hmac_generate(drbg, buf, buflen, &addtllist);
+	drbg_hmac_generate(drbg, buf, buflen, addtl, addtl_len);
 
 	/* 10.1.2.5 step 7 */
 	drbg->reseed_ctr++;
 
 	/*
@@ -535,21 +514,21 @@ static int drbg_generate(struct drbg_state *drbg,
  * Return codes: see drbg_generate -- if one drbg_generate request fails,
  *		 the entire drbg_generate_long request fails
  */
 static int drbg_generate_long(struct drbg_state *drbg,
 			      unsigned char *buf, unsigned int buflen,
-			      struct drbg_string *addtl)
+			      const u8 *addtl, size_t addtl_len)
 {
 	unsigned int len = 0;
 	unsigned int slice = 0;
 	do {
 		int err = 0;
 		unsigned int chunk = 0;
 		slice = (buflen - len) / DRBG_MAX_REQUEST_BYTES;
 		chunk = slice ? DRBG_MAX_REQUEST_BYTES : (buflen - len);
 		mutex_lock(&drbg->drbg_mutex);
-		err = drbg_generate(drbg, buf + len, chunk, addtl);
+		err = drbg_generate(drbg, buf + len, chunk, addtl, addtl_len);
 		mutex_unlock(&drbg->drbg_mutex);
 		if (0 > err)
 			return err;
 		len += chunk;
 	} while (slice > 0 && (len < buflen));
@@ -557,11 +536,11 @@ static int drbg_generate_long(struct drbg_state *drbg,
 }
 
 static int drbg_prepare_hrng(struct drbg_state *drbg)
 {
 	/* We do not need an HRNG in test mode. */
-	if (list_empty(&drbg->test_data.list))
+	if (drbg->test_entropylen != 0)
 		return 0;
 
 	drbg->jent = crypto_alloc_rng("jitterentropy_rng", 0, 0);
 	if (IS_ERR(drbg->jent)) {
 		const int err = PTR_ERR(drbg->jent);
@@ -579,22 +558,20 @@ static int drbg_prepare_hrng(struct drbg_state *drbg)
  * DRBG instantiation function as required by SP800-90A - this function
  * sets up the DRBG handle, performs the initial seeding and all sanity
  * checks required by SP800-90A
  *
  * @drbg memory of state -- if NULL, new memory is allocated
- * @pers Personalization string that is mixed into state, may be NULL -- note
- *	 the entropy is pulled by the DRBG internally unconditionally
- *	 as defined in SP800-90A. The additional input is mixed into
- *	 the state in addition to the pulled entropy.
+ * @pers Optional personalization string that is mixed into state
+ * @pers_len Length of personalization string in bytes, may be 0
  * @pr prediction resistance enabled
  *
  * return
  *	0 on success
  *	error value otherwise
  */
-static int drbg_instantiate(struct drbg_state *drbg, struct drbg_string *pers,
-			    bool pr)
+static int drbg_instantiate(struct drbg_state *drbg,
+			    const u8 *pers, size_t pers_len, bool pr)
 {
 	static const u8 initial_key[DRBG_STATE_LEN]; /* all zeroes */
 	int ret;
 	bool reseed = true;
 
@@ -625,11 +602,11 @@ static int drbg_instantiate(struct drbg_state *drbg, struct drbg_string *pers,
 			goto free_everything;
 
 		reseed = false;
 	}
 
-	ret = drbg_seed(drbg, pers, reseed);
+	ret = drbg_seed(drbg, pers, pers_len, reseed);
 
 	if (ret && !reseed)
 		goto free_everything;
 
 	mutex_unlock(&drbg->drbg_mutex);
@@ -672,11 +649,12 @@ static void drbg_kcapi_set_entropy(struct crypto_rng *tfm,
 				   const u8 *data, unsigned int len)
 {
 	struct drbg_state *drbg = crypto_rng_ctx(tfm);
 
 	mutex_lock(&drbg->drbg_mutex);
-	drbg_string_fill(&drbg->test_data, data, len);
+	drbg->test_entropy = data;
+	drbg->test_entropylen = len;
 	mutex_unlock(&drbg->drbg_mutex);
 }
 
 /***************************************************************
  * Kernel crypto API interface to register DRBG
@@ -708,36 +686,21 @@ static void drbg_kcapi_cleanup(struct crypto_tfm *tfm)
 static int drbg_kcapi_random(struct crypto_rng *tfm,
 			     const u8 *src, unsigned int slen,
 			     u8 *dst, unsigned int dlen)
 {
 	struct drbg_state *drbg = crypto_rng_ctx(tfm);
-	struct drbg_string *addtl = NULL;
-	struct drbg_string string;
-
-	if (slen) {
-		/* linked list variable is now local to allow modification */
-		drbg_string_fill(&string, src, slen);
-		addtl = &string;
-	}
 
-	return drbg_generate_long(drbg, dst, dlen, addtl);
+	return drbg_generate_long(drbg, dst, dlen, src, slen);
 }
 
 /* Seed (i.e. instantiate) or re-seed the DRBG. */
 static int drbg_kcapi_seed(struct crypto_rng *tfm,
 			   const u8 *seed, unsigned int slen, bool pr)
 {
 	struct drbg_state *drbg = crypto_rng_ctx(tfm);
-	struct drbg_string string;
-	struct drbg_string *seed_string = NULL;
 
-	if (0 < slen) {
-		drbg_string_fill(&string, seed, slen);
-		seed_string = &string;
-	}
-
-	return drbg_instantiate(drbg, seed_string, pr);
+	return drbg_instantiate(drbg, seed, slen, pr);
 }
 
 static int drbg_kcapi_seed_pr(struct crypto_rng *tfm,
 			      const u8 *seed, unsigned int slen)
 {
@@ -765,15 +728,13 @@ static int drbg_kcapi_seed_nopr(struct crypto_rng *tfm,
  * enforcement, so skip it.
  */
 static inline int __init drbg_healthcheck_sanity(void)
 {
 #define OUTBUFLEN 16
-	unsigned char buf[OUTBUFLEN];
+	u8 buf[OUTBUFLEN];
 	struct drbg_state *drbg = NULL;
 	int ret;
-	int rc = -EFAULT;
-	struct drbg_string addtl;
 
 	/* only perform test in FIPS mode */
 	if (!fips_enabled)
 		return 0;
 
@@ -791,29 +752,27 @@ static inline int __init drbg_healthcheck_sanity(void)
 	 * string lengths -- in case the error handling does not succeed
 	 * we may get an OOPS. And we want to get an OOPS as this is a
 	 * grave bug.
 	 */
 
-	drbg_string_fill(&addtl, buf, DRBG_MAX_ADDTL + 1);
 	/* overflow addtllen with additional info string */
-	ret = drbg_generate(drbg, buf, OUTBUFLEN, &addtl);
+	ret = drbg_generate(drbg, buf, OUTBUFLEN, buf, DRBG_MAX_ADDTL + 1);
 	BUG_ON(ret == 0);
 	/* overflow max_bits */
-	ret = drbg_generate(drbg, buf, DRBG_MAX_REQUEST_BYTES + 1, NULL);
+	ret = drbg_generate(drbg, buf, DRBG_MAX_REQUEST_BYTES + 1, NULL, 0);
 	BUG_ON(ret == 0);
 
 	/* overflow max addtllen with personalization string */
-	ret = drbg_seed(drbg, &addtl, false);
-	BUG_ON(0 == ret);
+	ret = drbg_seed(drbg, buf, DRBG_MAX_ADDTL + 1, false);
+	BUG_ON(ret == 0);
 	/* all tests passed */
-	rc = 0;
 
 	pr_devel("DRBG: Sanity tests for failure code paths successfully "
 		 "completed\n");
 
 	kfree(drbg);
-	return rc;
+	return 0;
 }
 
 static struct rng_alg drbg_algs[] = {
 	{
 		.base.cra_name		= "stdrng",
diff --git a/drivers/crypto/xilinx/xilinx-trng.c b/drivers/crypto/xilinx/xilinx-trng.c
index 5276ac2d82bb..43a4832f07e7 100644
--- a/drivers/crypto/xilinx/xilinx-trng.c
+++ b/drivers/crypto/xilinx/xilinx-trng.c
@@ -17,11 +17,10 @@
 #include <linux/mutex.h>
 #include <linux/mod_devicetable.h>
 #include <linux/platform_device.h>
 #include <crypto/aes.h>
 #include <crypto/df_sp80090a.h>
-#include <crypto/internal/drbg.h>
 #include <crypto/internal/cipher.h>
 #include <crypto/internal/rng.h>
 
 /* TRNG Registers Offsets */
 #define TRNG_STATUS_OFFSET			0x4U
diff --git a/include/crypto/df_sp80090a.h b/include/crypto/df_sp80090a.h
index cb5d6fe15d40..e594fb718eb8 100644
--- a/include/crypto/df_sp80090a.h
+++ b/include/crypto/df_sp80090a.h
@@ -7,10 +7,35 @@
 #ifndef _CRYPTO_DF80090A_H
 #define _CRYPTO_DF80090A_H
 
 #include <crypto/internal/cipher.h>
 #include <crypto/aes.h>
+#include <linux/list.h>
+
+/*
+ * Concatenation Helper and string operation helper
+ *
+ * SP800-90A requires the concatenation of different data. To avoid copying
+ * buffers around or allocate additional memory, the following data structure
+ * is used to point to the original memory with its size. In addition, it
+ * is used to build a linked list. The linked list defines the concatenation
+ * of individual buffers. The order of memory block referenced in that
+ * linked list determines the order of concatenation.
+ */
+struct drbg_string {
+	const unsigned char *buf;
+	size_t len;
+	struct list_head list;
+};
+
+static inline void drbg_string_fill(struct drbg_string *string,
+				    const unsigned char *buf, size_t len)
+{
+	string->buf = buf;
+	string->len = len;
+	INIT_LIST_HEAD(&string->list);
+}
 
 static inline int crypto_drbg_ctr_df_datalen(u8 statelen, u8 blocklen)
 {
 	return statelen +       /* df_data */
 		blocklen +      /* pad */
diff --git a/include/crypto/internal/drbg.h b/include/crypto/internal/drbg.h
deleted file mode 100644
index 5d4174cc6a53..000000000000
--- a/include/crypto/internal/drbg.h
+++ /dev/null
@@ -1,39 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-
-/*
- * NIST SP800-90A DRBG derivation function
- *
- * Copyright (C) 2014, Stephan Mueller <smueller@chronox.de>
- */
-
-#ifndef _INTERNAL_DRBG_H
-#define _INTERNAL_DRBG_H
-
-#include <linux/list.h>
-#include <linux/types.h>
-
-/*
- * Concatenation Helper and string operation helper
- *
- * SP800-90A requires the concatenation of different data. To avoid copying
- * buffers around or allocate additional memory, the following data structure
- * is used to point to the original memory with its size. In addition, it
- * is used to build a linked list. The linked list defines the concatenation
- * of individual buffers. The order of memory block referenced in that
- * linked list determines the order of concatenation.
- */
-struct drbg_string {
-	const unsigned char *buf;
-	size_t len;
-	struct list_head list;
-};
-
-static inline void drbg_string_fill(struct drbg_string *string,
-				    const unsigned char *buf, size_t len)
-{
-	string->buf = buf;
-	string->len = len;
-	INIT_LIST_HEAD(&string->list);
-}
-
-#endif //_INTERNAL_DRBG_H
-- 
2.53.0

