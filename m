Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59DC383C71;
	Mon, 20 Apr 2026 06:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776667030; cv=none; b=HzAALMKmNfJEA7zBG7Dw5kMPhTNqP5tqdGyBJV/Etf/vTj7OSBRrvUqYeTJ95say5uaKi5ifGpTbsI2NolICULwXbD+7GPMnqPJvqeC4A8A1hXaV9cerzltr7YVccH1kLDxJUK1LUw2hszdfiEQXwvJtCi4+hgj9mdhD99/tqVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776667030; c=relaxed/simple;
	bh=UJcGkrcANIp2Qfwc38sW1iuZbpAt4vof+QkhjDCxD/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CIZkr1tI0xSgUGrnlMDngMkrJJbF6Q3lwVhYWTQtVVZyUPf4Lr5B2yeTYJwWMfyqk3Nu4IogLQjSwkk7Ul3z5dkVwg7Cni17BRDqMtLNtP/AcIhZdFVeWPtnPM/nhO156lKEWIpovNoNXPBRSQr54/Scbw9b2Sl7jVH/Eb0dxVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X+vk09X7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X+vk09X7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63ED5C2BCB7;
	Mon, 20 Apr 2026 06:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776667030;
	bh=UJcGkrcANIp2Qfwc38sW1iuZbpAt4vof+QkhjDCxD/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X+vk09X7oPNkAdQy+tKJYS/JZxG2Ljc358kVN3SnaJwL2W/g64QKerOFihda9BK69
	 gKPlVD1zsf0Ua2+5lKXQbbWt20J4oU4zh2Lg5Lcj+OEfoyc7cb/C2nGum758OlOmO9
	 6C/Gd49DqBhO39O8vhwlX6xTF9NKX3Ez/jmErMlVcbsMg9m04cgmEMJJdUr9EX1H4v
	 8++Nvc785PH9/YqIsyXdS0HDaj6+BMjIxAcgAyrw6HUyOdFXe7YtmfVV4vMonU8Qao
	 /wPyqlHa3W66E1uA5zLGTlQJFxuADusE4v7fIYmhTy7+8VOdefB25XJKw38tv7gi5H
	 yb2d3/jq6nEiw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 36/38] crypto: drbg - Remove redundant reseeding based on random.c state
Date: Sun, 19 Apr 2026 23:34:20 -0700
Message-ID: <20260420063422.324906-37-ebiggers@kernel.org>
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

We're now incorporating 32 bytes from get_random_bytes() in the
additional input string on every request.  The additional input string
is processed with a call to drbg_hmac_update(), which is exactly how the
seed is processed.  Thus, in reality this is as good as a reseed.

From the perspective of FIPS 140-3, it isn't as good as a reseed.  But
it doesn't actually matter, because from FIPS's point of view
get_random_bytes() provides zero entropy anyway.

Thus, neither the reseed with more get_random_bytes() every 300s, nor
the logic that reseeds more frequently before rng_is_initialized(), is
actually needed anymore.  Remove it to simplify the code significantly.

(Technically the use of get_random_bytes() in drbg_seed() itself could
be removed too.  But it's safer to keep it there for now.)

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/drbg.c | 107 +++++---------------------------------------------
 1 file changed, 9 insertions(+), 98 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 7fd076ddc105..bab766026177 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -91,22 +91,15 @@
 
 #include <crypto/internal/rng.h>
 #include <crypto/sha2.h>
 #include <linux/fips.h>
 #include <linux/kernel.h>
-#include <linux/jiffies.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/string_choices.h>
 #include <linux/unaligned.h>
 
-enum drbg_seed_state {
-	DRBG_SEED_STATE_UNSEEDED,
-	DRBG_SEED_STATE_PARTIAL, /* Seeded with !rng_is_initialized() */
-	DRBG_SEED_STATE_FULL,
-};
-
 /* State length in bytes */
 #define DRBG_STATE_LEN		SHA512_DIGEST_SIZE
 
 /* Security strength in bytes */
 #define DRBG_SEC_STRENGTH	(SHA512_DIGEST_SIZE / 2)
@@ -135,13 +128,10 @@ struct drbg_state {
 	struct mutex drbg_mutex;	/* lock around DRBG */
 	u8 V[DRBG_STATE_LEN];		/* internal state -- 10.1.2.1 1a */
 	struct hmac_sha512_key key;	/* current key -- 10.1.2.1 1b */
 	/* Number of RNG requests since last reseed -- 10.1.2.1 1c */
 	size_t reseed_ctr;
-	size_t reseed_threshold;
-	enum drbg_seed_state seeded;		/* DRBG fully seeded? */
-	unsigned long last_seed_time;
 	bool instantiated;
 	bool pr;		/* Prediction resistance enabled? */
 	struct crypto_rng *jent;
 	const u8 *test_entropy;
 	size_t test_entropylen;
@@ -237,76 +227,10 @@ static void drbg_hmac_generate(struct drbg_state *drbg,
 	drbg_hmac_update(drbg, addtl1, addtl1_len, addtl2, addtl2_len);
 
 	memzero_explicit(addtl2, sizeof(addtl2));
 }
 
-static inline void __drbg_seed(struct drbg_state *drbg,
-			       const u8 *seed1, size_t seed1_len,
-			       const u8 *seed2, size_t seed2_len,
-			       enum drbg_seed_state new_seed_state)
-{
-	drbg_hmac_update(drbg, seed1, seed1_len, seed2, seed2_len);
-
-	drbg->seeded = new_seed_state;
-	drbg->last_seed_time = jiffies;
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
-		drbg->reseed_threshold = DRBG_MAX_REQUESTS;
-		break;
-	}
-}
-
-static void drbg_seed_from_random(struct drbg_state *drbg)
-	__must_hold(&drbg->drbg_mutex)
-{
-	u8 entropy[DRBG_SEC_STRENGTH];
-
-	get_random_bytes(entropy, DRBG_SEC_STRENGTH);
-
-	__drbg_seed(drbg, entropy, DRBG_SEC_STRENGTH, NULL, 0,
-		    DRBG_SEED_STATE_FULL);
-
-	memzero_explicit(entropy, DRBG_SEC_STRENGTH);
-}
-
-static bool drbg_nopr_reseed_interval_elapsed(struct drbg_state *drbg)
-{
-	unsigned long next_reseed;
-
-	/* Don't ever reseed from get_random_bytes() in test mode. */
-	if (drbg->test_entropylen)
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
 /*
  * Seeding or reseeding of the DRBG
  *
  * @drbg: DRBG state struct
  * @pers: personalization / additional information buffer
@@ -323,11 +247,10 @@ static int drbg_seed(struct drbg_state *drbg, const u8 *pers, size_t pers_len,
 {
 	int ret;
 	u8 entropy_buf[(32 + 16) * 2];
 	size_t entropylen;
 	const u8 *entropy;
-	enum drbg_seed_state new_seed_state = DRBG_SEED_STATE_FULL;
 
 	/* 9.1 / 9.2 / 9.3.1 step 3 */
 	if (pers_len > DRBG_MAX_ADDTL) {
 		pr_devel("DRBG: personalization string too long %zu\n",
 			 pers_len);
@@ -353,13 +276,10 @@ static int drbg_seed(struct drbg_state *drbg, const u8 *pers, size_t pers_len,
 		else
 			entropylen = DRBG_SEC_STRENGTH;
 		BUG_ON(entropylen * 2 > sizeof(entropy_buf));
 
 		/* Get seed from in-kernel /dev/urandom */
-		if (!rng_is_initialized())
-			new_seed_state = DRBG_SEED_STATE_PARTIAL;
-
 		get_random_bytes(entropy_buf, entropylen);
 
 		if (!drbg->jent) {
 			pr_devel("DRBG: (re)seeding with %zu bytes of entropy\n",
 				 entropylen);
@@ -399,11 +319,12 @@ static int drbg_seed(struct drbg_state *drbg, const u8 *pers, size_t pers_len,
 	}
 
 	if (pers_len)
 		pr_devel("DRBG: using personalization string\n");
 
-	__drbg_seed(drbg, entropy, entropylen, pers, pers_len, new_seed_state);
+	drbg_hmac_update(drbg, entropy, entropylen, pers, pers_len);
+	drbg->reseed_ctr = 1;
 	ret = 0;
 out:
 	memzero_explicit(entropy_buf, sizeof(entropy_buf));
 
 	return ret;
@@ -461,31 +382,25 @@ static int drbg_generate(struct drbg_state *drbg,
 	/* 9.3.1 step 5 is implicit with the chosen DRBG */
 
 	/*
 	 * 9.3.1 step 6 and 9 supplemented by 9.3.2 step c is implemented
 	 * here. The spec is a bit convoluted here, we make it simpler.
+	 *
+	 * We no longer try to detect when random.c has reseeded itself and call
+	 * drbg_seed() then too, since drbg_hmac_generate() adds bytes from
+	 * random.c to the additional input, which is a de facto reseed anyway.
 	 */
-	if (drbg->reseed_threshold < drbg->reseed_ctr)
-		drbg->seeded = DRBG_SEED_STATE_UNSEEDED;
-
-	if (drbg->pr || drbg->seeded == DRBG_SEED_STATE_UNSEEDED) {
-		pr_devel("DRBG: reseeding before generation (prediction "
-			 "resistance: %s, state %s)\n",
-			 str_true_false(drbg->pr),
-			 (drbg->seeded ==  DRBG_SEED_STATE_FULL ?
-			  "seeded" : "unseeded"));
+	if (drbg->pr || drbg->reseed_ctr > DRBG_MAX_REQUESTS) {
+		pr_devel("DRBG: reseeding before generation (prediction resistance: %s)\n",
+			 str_true_false(drbg->pr));
 		/* 9.3.1 steps 7.1 through 7.3 */
 		len = drbg_seed(drbg, addtl, addtl_len, true);
 		if (len)
 			goto err;
 		/* 9.3.1 step 7.4 */
 		addtl = NULL;
 		addtl_len = 0;
-	} else if (rng_is_initialized() &&
-		   (drbg->seeded == DRBG_SEED_STATE_PARTIAL ||
-		    drbg_nopr_reseed_interval_elapsed(drbg))) {
-		drbg_seed_from_random(drbg);
 	}
 
 	/* 9.3.1 step 8 and 10 */
 	drbg_hmac_generate(drbg, buf, buflen, addtl, addtl_len);
 
@@ -562,13 +477,10 @@ static int drbg_kcapi_seed(struct crypto_rng *tfm,
 	 */
 
 	/* 9.1 step 4 is implicit in DRBG_SEC_STRENGTH */
 
 	drbg->pr = pr;
-	drbg->seeded = DRBG_SEED_STATE_UNSEEDED;
-	drbg->last_seed_time = 0;
-	drbg->reseed_threshold = DRBG_MAX_REQUESTS;
 	memset(drbg->V, 1, DRBG_STATE_LEN);
 	hmac_sha512_preparekey(&drbg->key, initial_key, DRBG_STATE_LEN);
 
 	/* Allocate jitterentropy_rng if not in test mode. */
 	if (drbg->test_entropylen == 0) {
@@ -671,11 +583,10 @@ static inline int __init drbg_healthcheck_sanity(void)
 	if (!drbg)
 		return -ENOMEM;
 
 	guard(mutex_init)(&drbg->drbg_mutex);
 	drbg->instantiated = true;
-	drbg->reseed_threshold = DRBG_MAX_REQUESTS;
 
 	/*
 	 * if the following tests fail, it is likely that there is a buffer
 	 * overflow as buf is much smaller than the requested or provided
 	 * string lengths -- in case the error handling does not succeed
-- 
2.53.0

