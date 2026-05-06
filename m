Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34134A0C;
	Wed,  6 May 2026 00:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778025820; cv=none; b=UlQqPbwlL8wWfQEjArsIi6LwhujgQfwwsDFTL7uNm90FwOmTZZRsWNq7lWBiS40Gthx9IHh/9+siPlmtZwJu60Z1R3bQN1FuBBxz2GZ3hNjhhIxcuW+Q4AAx2gbiCGaGv1y7baSYt2bgNualYynYCk3yrSbrePdTVT/DrJIBaEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778025820; c=relaxed/simple;
	bh=YIOQwhqm2rlhegoFdSVGKOxTO6PDBATPRzOBfggqi5I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GQcqZNsTdnKPC3sTHRnjPS8VnW8crXASeMZeCcIcQpEv5B/0FoHFx85RlfNQmflTPQfKyMyfqoS0k1n++cJzmkQUXOEb8mQCFGtOX3ZwT09b8ObfT8mCAFWIwbfHhAjbCVQsFkAJfl7s6waPCrloD+gOIorb734xALYYHdKL2zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QfDkUlgY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QfDkUlgY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2FF3C2BCB4;
	Wed,  6 May 2026 00:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778025819;
	bh=YIOQwhqm2rlhegoFdSVGKOxTO6PDBATPRzOBfggqi5I=;
	h=From:To:Cc:Subject:Date:From;
	b=QfDkUlgY5uN6t7FclozlkKy6qTm0KdjLFWXaJLTw8ILYivJlmqKRMcU5uGwBMEbVR
	 LV74KVHZEriIyuO6daRLlsoy9k7Swb51OGnyjAsy+2tMBbfUxvIEhBbmPoYk1RfBCe
	 aqCyJN7JCZ6DK4OYxdEs4VZtmm2GAucd1ZFSQo6TDV4ephF3830lwgybJqRrTz7X0n
	 EMi/s/BGfhfq27OPHN44XoPHbCQ/653BlXA7JLGNuX4fhxvrJo9SGZJqiOvKNWGx4+
	 s0HiR1q56dfFAUHDj+oCd35vmuo3cPxROZ+fHOPK72Wiy8R+6+Djz+gEocW0M0uAtj
	 2IOHq8jE53OCA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Joachim Vandersmissen <joachim@jvdsn.com>
Subject: [PATCH] crypto: drbg - Remove support for "prediction resistance"
Date: Tue,  5 May 2026 17:02:58 -0700
Message-ID: <20260506000258.70807-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

"Prediction resistance", i.e. the property that the RNG's output is
unpredictable even after a state compromise, might sound like a nice
property to have.  In reality, it's not very practical, as it requires
that fresh entropy be pulled on every request.  (The normal Linux RNG
doesn't provide prediction resistance.)  In the case of drbg.c, that
means pulling from "jitterentropy", which is extremely slow.

For some perspective, running a simple benchmark, generating 32 random
bytes takes the following amount of time:

    get_random_bytes(): 90 ns
    drbg_nopr_hmac_sha512: 3707 ns
    drbg_pr_hmac_sha512: 773082 ns

So at least in this case, the "pr" (prediction-resistant) DRBG is over
200 times slower than the "nopr" (non-prediction-resistant) DRBG, or
over 8000 times slower than the normal Linux RNG.  While anyone using
drbg.c has always had to tolerate that it's slower than the normal Linux
RNG, the "pr" DRBG is clearly at another level of slowness.

Thus, the following is also entirely unsurprising:

  - FIPS 140-3 doesn't actually require that SP800-90A DRBG
    implementations support prediction resistance.  The non-prediction
    resistant DRBGs can be, and have been, certified.

  - drbg.c registers "drbg_nopr_hmac_sha512" with a higher cra_priority
    than "drbg_pr_hmac_sha512".  So "drbg_nopr_hmac_sha512" is already
    the one actually being used in practice.

Given these considerations, it's clear that "drbg_pr_hmac_sha512" isn't
actually useful, and it essentially just existed as another curiosity in
the museum of crypto algorithms.  Remove it to simplify the code.

Suggested-by: Joachim Vandersmissen <joachim@jvdsn.com>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/drbg.c    |  82 ++++++-------------
 crypto/testmgr.c |  21 +----
 crypto/testmgr.h | 202 -----------------------------------------------
 3 files changed, 27 insertions(+), 278 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index ab443be199a0..d66c7211d6bb 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1,9 +1,8 @@
 /*
  * DRBG: Deterministic Random Bits Generator
- *       Implementation of the HMAC SHA-512 DRBG from NIST SP800-90A,
- *       both with and without prediction resistance
+ *       Implementation of the HMAC SHA-512 DRBG from NIST SP800-90A
  *
  * Copyright Stephan Mueller <smueller@chronox.de>, 2014
  * Copyright 2026 Google LLC
  *
  * Redistribution and use in source and binary forms, with or without
@@ -129,11 +128,10 @@ struct drbg_state {
 	u8 V[DRBG_STATE_LEN];		/* internal state -- 10.1.2.1 1a */
 	struct hmac_sha512_key key;	/* current key -- 10.1.2.1 1b */
 	/* Number of RNG requests since last reseed -- 10.1.2.1 1c */
 	size_t reseed_ctr;
 	bool instantiated;
-	bool pr;		/* Prediction resistance enabled? */
 	struct crypto_rng *jent;
 	const u8 *test_entropy;
 	size_t test_entropylen;
 };
 
@@ -368,13 +366,12 @@ static int drbg_generate(struct drbg_state *drbg, u8 *out, size_t outlen,
 	 *
 	 * We no longer try to detect when random.c has reseeded itself and call
 	 * drbg_seed() then too, since drbg_hmac_generate() adds bytes from
 	 * random.c to the additional input, which is a de facto reseed anyway.
 	 */
-	if (drbg->pr || drbg->reseed_ctr > DRBG_MAX_REQUESTS) {
-		pr_devel("DRBG: reseeding before generation (prediction resistance: %s)\n",
-			 str_true_false(drbg->pr));
+	if (drbg->reseed_ctr > DRBG_MAX_REQUESTS) {
+		pr_devel("DRBG: reseeding before generation\n");
 		/* 9.3.1 steps 7.1 through 7.3 */
 		err = drbg_seed(drbg, addtl, addtl_len, true);
 		if (err)
 			return err;
 		/* 9.3.1 step 7.4 */
@@ -429,33 +426,31 @@ static void drbg_kcapi_set_entropy(struct crypto_rng *tfm,
 	mutex_unlock(&drbg->drbg_mutex);
 }
 
 /* Seed (i.e. instantiate) or re-seed the DRBG. */
 static int drbg_kcapi_seed(struct crypto_rng *tfm,
-			   const u8 *pers, size_t pers_len, bool pr)
+			   const u8 *pers, unsigned int pers_len)
 {
 	static const u8 initial_key[DRBG_STATE_LEN]; /* all zeroes */
 	struct drbg_state *drbg = crypto_rng_ctx(tfm);
 	int ret;
 
-	pr_devel("DRBG: Initializing DRBG with prediction resistance %s\n",
-		 str_enabled_disabled(pr));
+	pr_devel("DRBG: Initializing DRBG\n");
 	guard(mutex)(&drbg->drbg_mutex);
 
 	if (drbg->instantiated)
 		return drbg_seed(drbg, pers, pers_len, /* reseed= */ true);
 
 	/* 9.1 step 1 is implicit with the selected DRBG type */
 
 	/*
-	 * 9.1 step 2 is implicit as caller can select prediction resistance
-	 * all DRBG types support prediction resistance
+	 * 9.1 step 2 is implicit, as this implementation doesn't support
+	 * prediction resistance
 	 */
 
 	/* 9.1 step 4 is implicit in DRBG_SEC_STRENGTH */
 
-	drbg->pr = pr;
 	memset(drbg->V, 1, DRBG_STATE_LEN);
 	hmac_sha512_preparekey(&drbg->key, initial_key, DRBG_STATE_LEN);
 
 	/* Allocate jitterentropy_rng if not in test mode. */
 	if (drbg->test_entropylen == 0) {
@@ -477,22 +472,10 @@ static int drbg_kcapi_seed(struct crypto_rng *tfm,
 	}
 	drbg->instantiated = true;
 	return 0;
 }
 
-static int drbg_kcapi_seed_pr(struct crypto_rng *tfm,
-			      const u8 *seed, unsigned int slen)
-{
-	return drbg_kcapi_seed(tfm, seed, slen, /* pr= */ true);
-}
-
-static int drbg_kcapi_seed_nopr(struct crypto_rng *tfm,
-				const u8 *seed, unsigned int slen)
-{
-	return drbg_kcapi_seed(tfm, seed, slen, /* pr= */ false);
-}
-
 /*
  * Generate random numbers invoked by the kernel crypto API:
  *
  * src is additional input supplied to the RNG.
  * slen is the length of src.
@@ -587,35 +570,21 @@ static inline int __init drbg_healthcheck_sanity(void)
 
 	kfree(drbg);
 	return 0;
 }
 
-static struct rng_alg drbg_algs[] = {
-	{
-		.base.cra_name		= "stdrng",
-		.base.cra_driver_name	= "drbg_pr_hmac_sha512",
-		.base.cra_priority	= 200,
-		.base.cra_ctxsize	= sizeof(struct drbg_state),
-		.base.cra_module	= THIS_MODULE,
-		.base.cra_init		= drbg_kcapi_init,
-		.set_ent		= drbg_kcapi_set_entropy,
-		.seed			= drbg_kcapi_seed_pr,
-		.generate		= drbg_kcapi_generate,
-		.base.cra_exit		= drbg_kcapi_exit,
-	},
-	{
-		.base.cra_name		= "stdrng",
-		.base.cra_driver_name	= "drbg_nopr_hmac_sha512",
-		.base.cra_priority	= 201,
-		.base.cra_ctxsize	= sizeof(struct drbg_state),
-		.base.cra_module	= THIS_MODULE,
-		.base.cra_init		= drbg_kcapi_init,
-		.set_ent		= drbg_kcapi_set_entropy,
-		.seed			= drbg_kcapi_seed_nopr,
-		.generate		= drbg_kcapi_generate,
-		.base.cra_exit		= drbg_kcapi_exit,
-	},
+static struct rng_alg drbg_alg = {
+	.base.cra_name		= "stdrng",
+	.base.cra_driver_name	= "drbg_nopr_hmac_sha512",
+	.base.cra_priority	= 201,
+	.base.cra_ctxsize	= sizeof(struct drbg_state),
+	.base.cra_module	= THIS_MODULE,
+	.base.cra_init		= drbg_kcapi_init,
+	.set_ent		= drbg_kcapi_set_entropy,
+	.seed			= drbg_kcapi_seed,
+	.generate		= drbg_kcapi_generate,
+	.base.cra_exit		= drbg_kcapi_exit,
 };
 
 static int __init drbg_init(void)
 {
 	int ret;
@@ -623,29 +592,26 @@ static int __init drbg_init(void)
 	ret = drbg_healthcheck_sanity();
 	if (ret)
 		return ret;
 
 	/*
-	 * In FIPS mode, boost the algorithm priorities to ensure that when
-	 * users request "stdrng", they really get an algorithm from here.
+	 * In FIPS mode, boost the algorithm priority to ensure that when users
+	 * request "stdrng", they really get the algorithm from here.
 	 */
-	if (fips_enabled) {
-		for (size_t i = 0; i < ARRAY_SIZE(drbg_algs); i++)
-			drbg_algs[i].base.cra_priority += 2000;
-	}
+	if (fips_enabled)
+		drbg_alg.base.cra_priority += 2000;
 
-	return crypto_register_rngs(drbg_algs, ARRAY_SIZE(drbg_algs));
+	return crypto_register_rng(&drbg_alg);
 }
 
 static void __exit drbg_exit(void)
 {
-	crypto_unregister_rngs(drbg_algs, ARRAY_SIZE(drbg_algs));
+	crypto_unregister_rng(&drbg_alg);
 }
 
 module_init(drbg_init);
 module_exit(drbg_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Stephan Mueller <smueller@chronox.de>");
 MODULE_DESCRIPTION("NIST SP800-90A Deterministic Random Bit Generator (DRBG)");
 MODULE_ALIAS_CRYPTO("stdrng");
-MODULE_ALIAS_CRYPTO("drbg_pr_hmac_sha512");
 MODULE_ALIAS_CRYPTO("drbg_nopr_hmac_sha512");
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 9059bea7a5b0..a3e80de91d4d 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -3479,12 +3479,12 @@ static int alg_test_comp(const struct alg_test_desc *desc, const char *driver,
 			 desc->suite.comp.decomp.count);
 	crypto_free_acomp(acomp);
 	return err;
 }
 
-static int drbg_cavs_test(const struct drbg_testvec *test, int pr,
-			  const char *driver, u32 type, u32 mask)
+static int drbg_cavs_test(const struct drbg_testvec *test, const char *driver,
+			  u32 type, u32 mask)
 {
 	int ret = -EAGAIN;
 	struct crypto_rng *drng;
 	unsigned char *buf = kzalloc(test->expectedlen, GFP_KERNEL);
 
@@ -3517,22 +3517,18 @@ static int drbg_cavs_test(const struct drbg_testvec *test, int pr,
 			printk(KERN_ERR "alg: drbg: Failed to reseed rng\n");
 			goto outbuf;
 		}
 	}
 
-	if (pr)
-		crypto_rng_set_entropy(drng, test->entpra, test->entprlen);
 	ret = crypto_rng_generate(drng, test->addtla, test->addtllen,
 				  buf, test->expectedlen);
 	if (ret < 0) {
 		printk(KERN_ERR "alg: drbg: could not obtain random data for "
 		       "driver %s\n", driver);
 		goto outbuf;
 	}
 
-	if (pr)
-		crypto_rng_set_entropy(drng, test->entprb, test->entprlen);
 	ret = crypto_rng_generate(drng, test->addtlb, test->addtllen,
 				  buf, test->expectedlen);
 	if (ret < 0) {
 		printk(KERN_ERR "alg: drbg: could not obtain random data for "
 		       "driver %s\n", driver);
@@ -3550,20 +3546,16 @@ static int drbg_cavs_test(const struct drbg_testvec *test, int pr,
 
 static int alg_test_drbg(const struct alg_test_desc *desc, const char *driver,
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
 			err = -EINVAL;
 			break;
@@ -4654,17 +4646,10 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_drbg,
 		.fips_allowed = 1,
 		.suite = {
 			.drbg = __VECS(drbg_nopr_hmac_sha512_tv_template)
 		}
-	}, {
-		.alg = "drbg_pr_hmac_sha512",
-		.test = alg_test_drbg,
-		.fips_allowed = 1,
-		.suite = {
-			.drbg = __VECS(drbg_pr_hmac_sha512_tv_template)
-		}
 	}, {
 		.alg = "ecb(aes)",
 		.generic_driver = "ecb(aes-lib)",
 		.test = alg_test_skcipher,
 		.fips_allowed = 1,
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index c47203f73fd1..b7dcf40af6db 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -131,13 +131,10 @@ struct drbg_testvec {
 	size_t ent_reseed_len;
 	const unsigned char *addtl_reseed;
 	size_t addtl_reseed_len;
 
 	/* Generate (twice) */
-	const unsigned char *entpra;
-	const unsigned char *entprb;
-	size_t entprlen;
 	const unsigned char *addtla;
 	const unsigned char *addtlb;
 	size_t addtllen;
 
 	/* Expected output from last call to Generate */
@@ -23431,209 +23428,10 @@ static const struct aead_testvec aegis128_tv_template[] = {
 			  "\x78\x93\xec\xfc\xf4\xff\xe1\x2d",
 		.clen	= 24,
 	},
 };
 
-static const struct drbg_testvec drbg_pr_hmac_sha512_tv_template[] = {
-	/*
-	 * Borrowed from the first applicable test vector from ACVP:
-	 * https://github.com/usnistgov/ACVP-Server/blob/v1.1.0.33/gen-val/json-files/hmacDRBG-1.0/prompt.json#L1161
-	 * https://github.com/usnistgov/ACVP-Server/blob/v1.1.0.33/gen-val/json-files/hmacDRBG-1.0/expectedResults.json#L271
-	 */
-	{
-		/* .entropy = ACVP entropyInput || nonce */
-		.entropy = "\x9B\xE9\xB2\x87\xA3\x9A\x08\x44\x1D\x67\x82\x20"
-			   "\xC9\x53\xFB\xEB\xA4\xB9\x0F\x44\x0B\x98\x33\x18"
-			   "\xAC\x6E\x25\x4A\x85\x83\x2D\x26\x21\x9F\x93\x64"
-			   "\xC8\x5A\x5F\x72\xDB\x88\x45\x96\x71\x41\xF4\xBF"
-			   "\x6E\xA7\x98\x00\x9D\xD1\x0C\x2E\x4D\x7A\xE2\x03"
-			   "\x0D\xE3\xCD\x62\xFE\xF3\x62\xBD\x12\x69\x92\x3D"
-			   "\xBA\xAC\x15\x17\xC7\x80\x93\x8E\x72\x32\x2D\x52"
-			   "\xE5\x2C\x19\x84\x5C\xA5\xCE\x5B\x98\x19\x1F\xF1"
-			   "\x9F\x0C\x17\x04\xD0\x66\xF1\x9B\xFA\x7E\x2C\xB6"
-			   "\x55\x68\xD4\x1B\xD6\x7A\x1D\x2C\xD4\x6D\x6E\x15"
-			   "\xF7\x32\x23\x04\x05\x8C\xBB\xE6\x63\x6B\x80\x9B"
-			   "\x9C\x69\x09\x8F\x5F\x02\xBF\x53\x42\x11\xB7\x80"
-			   "\xAA\xD4\xE8\x54\x00\x83\x5C\x20\xA8\xB3\x6E\xD9"
-			   "\xF5\x51\x9E\xB9\xD1\x6E\xC7\x0C\xE9\x7F\xF0\xBF"
-			   "\xCE\x1D\xB0\x31\x8D\x16\xC9\x65\x0C\x18\x55\xA4"
-			   "\x46\x8D\x54\x2B\x78\x69\x1B\x8C\x29\xD7\xAC\x0F"
-			   "\x34\x4D\x69\x0B\x76\xC3\x98\x00\x78\x2F\xE2\x54"
-			   "\xAF\xD5\x8A\xC3\x40\x97\xB1\xA2\x60\xD3\x07\x3B"
-			   "\x7A\x3E\xD0\x82\x80\x68\xEE\xB0\x72\x5F\x07\x17"
-			   "\xD9\x0A\xFC\xBD\xBA\xB6\x77\x4E\xC9\xCE\x6A\x48"
-			   "\xEB\x9C\xF5\x18\x88\x1E\x6E\x3B\x65\x43\x16\x73"
-			   "\x80\x53\xB7\xF0\x7E\xAB\x23\x19\x1E\x75\x60\x36"
-			   "\xAF\x39\xC0\xCF\x0F\x6D\x7F\x90\xB2\x50\xD5\x37"
-			   "\x58\x6D\x5C\x95\x78\x25\x8D\x3A\x40\xAB\xF6\x7B"
-			   "\x85\x86\xBB\x48\x5E\x1C\x99\xC1\xD3\x4E\x85\xE5"
-			   "\xB4\xE7\x61\xF3\x7D\x56\x1F\x77\xCF\x3C\x76\x3A"
-			   "\xF4\x82\x36\xB7\x37\x33\x84\x34\xBA\x0E\xE2\xE1"
-			   "\xAF\x0C\xD2\xAE\x97\x5C\x80\xD4\xD2\xFD\x37\x71"
-			   "\xC8\x70\x04\x29\x8B\x44\xB9\xD7\xC9\x8F\xE7\x99"
-			   "\x94\x9E\xFC\x49\x66\x24\xCB\x8B\x41\x40\x66\xC5"
-			   "\xA4\x00\xD5\x3F\x68\xDD\xB5\xA5\x62\x96\x7C\xAC"
-			   "\x63\x58\x95\x85\x99\x24\x21\x15\xD2\x76\xAF\x6D",
-		.entropylen = 384,
-		.pers = "\xDD\x07\x10\x10\x17\x34\xD5\xBD\x43\xAF\x03\x79\xE4"
-			"\x64\x2C\x58\x06\xEA\xE0\x39\xDA\x42\x96\x16\x0B\xF9"
-			"\xB8\xCE\x57\x7D\x53\x67\xBF\xF8\x0C\x40\x02\xB2\x77"
-			"\x16\xD5\x23\x75\x9F\x6A\x42\x0E\xE8\xCC\xD0\x9F\x40"
-			"\x64\xE9\x3B\xE9\x48\x13\xC3\x8E\x4B\xAB\xE1\xB9\x4F"
-			"\x6D\xBB\xF2\x4C\xF8\x29\xA5\x2B\x44\x23\x15\x2C\xDE"
-			"\x2A\xCF\x88\x04\x7A\x38\x37\xA2\xD5\x7B\xEA\x59\x39"
-			"\x2C\x58\xA2\x5B\xF9\x39\xA2\x7E\x94\x11\x97\xEC\x47"
-			"\x08\xD6\xE2\x39\x65\x26\x43\x81\x3F\x1B\x31\xA6\xA4"
-			"\x1A\x5C\xCD\x02\xCC\x89\x38\x3F\x32\x7C\x0E\x7E\x88"
-			"\x3B\x6F\x60\x69\xEA\xBA\xAA\x1F\x53\x93\x70\xD7\x48"
-			"\x74\x91\x79\x5E\xD4\xB0\xD9\x82\x74\x12\xDE\xFE\xFB"
-			"\x51\x96\x66\x5C\x6A\x53\x11\xAD\x9A\xD4\xFA\x9D\xF0"
-			"\xE2\x7F\x26\x8F\x6F\xAC\x00\xC8\xDB\xCF\xA5\x8E\xE6"
-			"\x61\x8F\x36\xD6\x44\x5B\x07\xDA\x9C\x2A\x46\xE3\x03"
-			"\x1C\xD8\x11\x4F\x61\x1F\xEC\xBA\x12\x68\xB9\x4B\x57"
-			"\x39\x05\xD6\xEE\xC1\xAC\x3F\x6D\x6F\xE9\xBF\xEA\x36"
-			"\x1A\x8A\xAA\xF4\xE8\xE0\xDB\xC6\xE5\x06\x9F\xC9\x91"
-			"\x52\xCD\x53\xD0\x78\xF6\xC1\x7B\x75\x91\x85\x91\x13"
-			"\x26\xBE\xC9\x02\xDE\xB0\x19\xF2\x71",
-		.perslen = 256,
-
-		.entpra = "\xDB\xBA\x25\xC7\x02\x0D\x3D\x95\x9C\xEB\xF5\x42"
-			  "\x52\x3A\x6B\xDA\xE8\xAF\xE9\x3D\x76\x2A\x9E\xB5"
-			  "\xD7\xE7\x5D\xC9\xB8\x1F\x3A\xC2\x91\x95\x9D\xFD"
-			  "\xE5\x48\x5F\x63\xD8\x84\x44\x82\x6A\x71\xF9\xDD"
-			  "\xAF\x4B\xE2\x28\xB4\x30\xCF\x78\xB7\x0B\x0F\x61"
-			  "\x71\x16\x1A\xE0\x6D\x5F\xB4\x4B\x17\x1A\x26\xCA"
-			  "\xD8\x9D\x6D\x46\xA3\x56\xC0\xE7\x49\xCF\xE0\xD2"
-			  "\xFF\xA8\x22\x45\xE0\xB4\x18\x0B\x13\x37\x01\x46"
-			  "\xCB\xE7\xD8\x2A\x59\x43\xAD\x90\x1E\xE1\xD0\xD7"
-			  "\x76\xB0\x2D\xCF\x17\x23\x99\x73\x5D\xE5\xC7\x46"
-			  "\x8A\x0D\x8E\xC4\xAB\x45\xAC\xA8\x74\xE4\xF7\xD0"
-			  "\x26\xD7\x0A\xE2\x43\x3D\xB8\xC7\xEE\xAD\x53\x6F"
-			  "\x78\xC3\x51\xC0\xE0\x76\x2A\xC2\xB7\xFE\x02\x64"
-			  "\x25\xF0\xCE\xD7\xA9\xBF\x85\xCA\x20\xA6\x93\x68"
-			  "\xE3\x79\xE9\x88\xA8\x7F\x45\x8D\x71\xB4\xB4\x79"
-			  "\x1C\x56\x68\xF9\xAE\x18\x76\xB9\x3F\xEE\x5B\x2C"
-			  "\xC6\x61\x47\x34\x3B\xC5\x24\x2D\x3C\x6D\x16\x48"
-			  "\x70\xD9\xDB\x2E\xB8\x42\x52\x81\x1C\x94\x39\xF0"
-			  "\xF4\xC0\x8F\x44\xD3\xCF\xD5\xF9\xC1\x59\x61\x83"
-			  "\xAE\xFD\xD0\xC4\x35\xD1\x0E\x55\x46\x5C\xBA\x3D"
-			  "\x5C\x4A\x89\x15\xE8\x1D\x86\x28\xE5\xF5\x31\x0B"
-			  "\x89\x59\xFE\x4A\xC3\x5D\xA5\x2A\x16\x37\x78\x41"
-			  "\x58\x3A\x9E\xA3\xBD\x1F\xE6\x25\xCC\x18\x9E\xD2"
-			  "\x1A\x99\x56\x66\x83\x78\xBB\x27\x3E\x28\xFE\xD4"
-			  "\x74\xCB\x75\x2D\x82\x86\x55\xFB\x1C\xA4\xAF\x3F"
-			  "\x84\x0A\xA0\xA1\x1C\x70\x34\x87\x2E\x73\x15\x38"
-			  "\x8A\x27\xB1\x6C\x33\x95\xE5\x07",
-		.entprb = "\x38\xF2\xC4\x8F\x4B\x9C\x2F\x03\x67\x8C\x8A\x47"
-			  "\xE1\xF2\x18\xC5\xB8\x4C\x05\x77\x77\x15\xA8\x94"
-			  "\x1F\x1F\x45\x6D\xD0\xEF\x60\x67\x63\x12\x5D\x38"
-			  "\x89\x22\x76\xF5\xF2\xC4\xE1\x15\x26\x7E\x8F\x52"
-			  "\x79\x1E\x96\x71\xCD\xE7\x32\x95\x2B\x4E\xB2\xC2"
-			  "\x92\x21\xC7\x48\xA2\xB1\xC5\x71\x44\x91\xE4\x4F"
-			  "\xBE\xD3\x5E\xA9\xAB\xD3\xE2\xD1\xE2\xD8\x8F\x98"
-			  "\x38\x03\x18\x29\x84\xA2\xCA\x6E\x72\x34\xC9\x51"
-			  "\x6D\x8C\xE8\x09\x50\x71\x2A\x08\xB7\xCF\x74\xE6"
-			  "\x11\xB6\x38\xF5\xBC\x24\xF7\x5B\x73\x34\xD5\x8B"
-			  "\xBB\x15\xE3\x6F\x9A\x9B\x1E\x32\xB9\x6F\x5F\xE3"
-			  "\xC9\x9F\xF6\xD9\x33\x03\xCD\x0D\x8E\xD4\x3F\x67"
-			  "\x11\x65\x0A\x90\x67\x83\xC1\xCC\x70\xB1\xA9\x46"
-			  "\x4B\x5E\x0B\x84\xDC\x02\xBA\x50\x1D\x4A\x5B\xC7"
-			  "\xB4\x5E\xDF\x35\x01\x45\x3D\x64\x5C\x2E\xCD\xA6"
-			  "\x20\xFB\x35\x74\xC0\x7C\x2D\x24\x66\xAB\x38\x12"
-			  "\x38\xCE\x52\xCB\x38\x9B\x95\xDE\x0C\x2A\x8C\x9D"
-			  "\xF7\x81\x48\x9E\xD6\x10\xF1\x83\x71\x44\x53\x2F"
-			  "\xCE\xF3\xEC\xB3\x29\x67\xF1\x41\xFC\xD6\xB6\x49"
-			  "\xE3\x13\x74\x4D\xB2\x3E\xEA\x73\x2B\x03\x68\xAC"
-			  "\x2F\x57\x8C\x58\xEC\x34\xE9\xEF\x18\x36\xDE\xAD"
-			  "\xE9\x48\x1D\xF7\x9E\xB7\xA1\x60\x2E\x78\xF5\x62"
-			  "\x68\xDD\xB8\x5B\x33\x6B\x66\xAD\xA1\xD5\xFB\x46"
-			  "\x5E\x8F\xF8\x9D\x37\xE5\xC2\xD8\x76\xDC\x2B\x6A"
-			  "\x99\x1E\xDF\x91\xB1\x0A\x81\x2A\x9D\xEB\xE7\xE4"
-			  "\xD1\x21\xD4\xDA\x0E\x55\x8A\x14\xB2\xB6\x15\x7D"
-			  "\x48\x52\x6A\xB0\xA2\x92\x4D\x50",
-		.entprlen = 320,
-		.addtla = "\xC2\x89\x7C\x07\x46\x74\x02\x2C\xEA\xAD\xFD\x74"
-			  "\x0C\x40\xEF\xA2\x95\x64\x6B\xC4\x2D\xED\xF4\x16"
-			  "\x26\x25\x06\xB3\x36\x6B\xD8\x9A\x5F\xF4\x25\xC1"
-			  "\xC3\x69\x3F\x7A\x19\xB7\x02\xA6\xCC\x3B\xA2\x4E"
-			  "\x05\xA1\x1C\x7B\x2D\xAD\x44\xE7\x4A\x40\x71\x85"
-			  "\xEF\x1C\xE4\xEC\x54\xCA\xB0\xAF\x8F\xF5\x43\xB1"
-			  "\xE0\x99\x71\x71\xD4\x3E\x56\x97\xAA\xF5\xD0\x1A"
-			  "\x58\x2D\x65\x0F\xA4\xB4\xB6\x07\x1B\x1F\x13\x8B"
-			  "\x29\xD6\xE5\x23\xD3\x4D\x43\xD6\xBC\x74\xA8\x92"
-			  "\xBD\xE9\x9B\x01\x47\x8C\xA5\x02\xA8\x0D\xC3\x3A"
-			  "\xED\x83\xFD\xD2\xCB\xFF\x25\x89\x2C\x2F\x5B\x70"
-			  "\x3F\x9E\x24\x50\xF8\x78\x28\x1B\x67\x52\x92\xA2"
-			  "\x87\x81\x07\x40\xA9\x40\xBA\x84\x47\x25\xC1\xF7"
-			  "\x9E\x3B\x4E\xE4\x8F\x10\xE5\x50\x8B\x22\x83\x4F"
-			  "\xCD\x4E\x42\x63\x92\x0A\x5F\xAF\x7A\x9B\x0E\x1A"
-			  "\xE3\xB4\x99\x11\x7F\xE6\x93\xC3\xED\xF1\x9F\x3A",
-		.addtlb = "\x1E\x75\xB6\x70\x60\xFD\xE6\xD1\xC7\xA5\x74\xCF"
-			  "\xA7\x50\x17\xAE\xDD\xC4\x6E\xC4\xE0\x15\xF0\x3B"
-			  "\xF7\x1C\x46\x45\xEE\x60\x66\x48\x1D\x2C\x36\xCC"
-			  "\x95\x3E\xB7\xEB\x1B\xFF\x8C\xC0\x78\x6D\x56\x3A"
-			  "\xC7\x24\x18\x9E\x7C\xA1\x60\x54\x41\x4B\xAF\x18"
-			  "\xE8\x02\xD1\x54\x65\xEC\x3D\xFD\x8B\xDF\xD2\xF5"
-			  "\x62\xEA\x66\x41\x6A\x32\x87\xA6\x34\x2F\x48\xBF"
-			  "\xB5\xCC\x35\x5A\x2A\xC1\xAB\x68\x34\x1A\xD6\x82"
-			  "\x40\xF7\xF2\x00\x14\x8B\x69\x0F\xE4\xCD\x6B\xB1"
-			  "\xFC\x8B\x16\xEC\xB4\xE3\x33\xBF\x84\x12\x4B\x58"
-			  "\xED\x51\x88\xF5\xEF\xB6\xC3\xCE\x9B\x63\xCC\x80"
-			  "\x1F\x3C\x8A\x67\xEE\xCD\xD2\x01\x25\x22\xAC\xB3"
-			  "\xB6\x9B\x1F\xF8\xE8\x71\xE6\x0D\x78\x11\x3C\x9E"
-			  "\xF2\x57\xDC\xB6\xCF\x90\xD3\xA8\x3E\xCD\x88\xD4"
-			  "\xDC\x1C\x31\x6B\x1F\xC3\x6A\x29\xF0\x7B\x4C\xCC"
-			  "\x6D\x92\x5E\x6F\x0C\x0B\x4D\xA7\x10\x66\x84\x1F",
-		.addtllen = 192,
-
-		.expected = "\xAA\x76\x91\xAE\x99\xCD\x8D\x83\x49\x9D\xC5\x51"
-			    "\xA5\x95\xC6\x9D\xAD\x4B\x40\x2B\x5F\x8C\x30\x5D"
-			    "\x1E\x89\x58\xD1\x8A\x86\xF9\x61\x2C\x45\x41\x8E"
-			    "\xC5\xC6\x0E\x33\x7C\xFE\x91\x71\xC9\x53\x76\xD6"
-			    "\xC2\x8D\x05\x09\xB8\x2A\x2B\x9B\x36\x1D\x31\xD7"
-			    "\x50\x45\xB1\x08\x58\xC4\x99\x25\xEA\x2F\x18\xDB"
-			    "\x34\x8A\x02\xD8\x38\xDD\x7B\x9E\x0E\xEF\x9C\x45"
-			    "\xC7\x4F\x7E\x36\x3A\x90\x8B\x41\x51\x4A\x1B\xE9"
-			    "\x8A\x61\xE9\xB5\x4E\xA5\xE2\xBD\x16\x59\x61\x0F"
-			    "\x9C\x5A\x63\xA7\x87\x79\x5C\x0A\x16\xDF\x6D\x88"
-			    "\x11\x25\x56\x8B\x5D\xA6\xF8\x4F\xB9\x01\x19\xAE"
-			    "\x57\x3B\xC4\x06\xBB\xE7\xCB\xAF\xB3\x8D\xE2\x40"
-			    "\xED\x42\x29\xB3\x0D\x64\x20\xF2\x66\x58\xB1\xDD"
-			    "\x59\xB1\x39\x7C\xD9\xB2\x34\x08\x53\x9B\x3A\xB7"
-			    "\x18\x35\xD0\x90\x7F\xB5\x30\xF2\x27\xA0\x90\x63"
-			    "\x6F\xF2\x72\x49\xBF\xD0\xAE\x4A\xF4\xCA\xB3\x1A"
-			    "\xAE\x7F\x93\xF3\xB9\x84\x99\x09\x50\xB9\xA0\x43"
-			    "\x4F\x83\x33\x92\xA5\xC7\x25\x44\x6A\x74\xF4\xFA"
-			    "\xBA\x60\x43\x13\x97\x53\x99\x98\xA3\x05\x02\xC1"
-			    "\x03\xDF\x53\x76\x9E\x74\xE7\xA0\xB5\xD7\xA7\x87"
-			    "\x1E\x00\x1D\x29\x47\x8F\x65\x4E\x0F\x76\xCA\xA9"
-			    "\x2A\xC5\x05\x4F\xA6\xFE\x96\xC6\x81\xC0\x55\xFC"
-			    "\x92\x89\xA6\x81\xF0\x37\xF1\x41\xA6\x88\x0B\x01"
-			    "\xE0\xA5\x78\x4C\xF4\x61\xA7\x91\xD8\x4B\xE9\x2C"
-			    "\xF0\x68\xEE\x46\x41\xD2\x74\xE5\x5F\x6F\x1F\xE6"
-			    "\xBE\x5C\xB1\x3C\x60\x1A\xAA\xB9\x88\x3C\xB9\x1C"
-			    "\xCD\x67\x78\x1F\x45\x18\xE7\x8B\xBD\xE4\x24\xDA"
-			    "\xA8\x26\xD1\x03\xF1\xC7\x6B\x28\x62\xAB\x5C\xAB"
-			    "\x98\xCA\xFB\xCB\x0B\x2D\x01\xD9\xC1\xA6\xFA\x91"
-			    "\x71\x3D\x9B\x3B\x60\xEB\xD7\xA2\x61\xC1\x92\x60"
-			    "\xB1\x02\x44\x0C\x97\x70\x77\x83\xF9\x35\xEA\x24"
-			    "\x85\xF8\x0A\x32\xA2\xC7\x05\x40\x90\x83\x4F\x87"
-			    "\x57\x66\xB5\xDE\xEE\xFF\x8B\x01\xBC\x96\xB0\xC5"
-			    "\x29\xB6\xC1\xF0\x11\x31\x51\x11\xB0\xC2\x0F\x08"
-			    "\xCF\x09\x69\x74\xE1\x0D\x6C\x0A\x10\xD0\x73\xF0"
-			    "\x8E\xDC\x5F\xB1\xBD\x47\x8A\xA7\x90\xB3\x08\x86"
-			    "\xD2\xE4\x58\xE5\x68\x33\x67\x3B\x37\xF1\x28\x28"
-			    "\x59\x91\xB5\x5F\x8D\x84\x54\xCE\x18\x76\xE3\x5C"
-			    "\x55\x37\x8E\x10\x34\x9B\x6E\x1F\x73\x88\x31\xBF"
-			    "\x0D\x5C\xED\x7A\xBC\xF2\xCE\x7A\x2E\x2E\xE7\x04"
-			    "\xE7\xF2\x8F\x33\xCC\x06\x77\x96\xBB\xA8\x65\x03"
-			    "\x26\x79\xC0\xF0\x52\x3B\xD4\xF2\x5D\x00\xE4\x80"
-			    "\x7F\x78\xC0\x45\x29\x55\xCA\x63",
-		.expectedlen = 512,
-	}
-};
-
 static const struct drbg_testvec drbg_nopr_hmac_sha512_tv_template[] = {
 	/*
 	 * Borrowed from the first applicable test vector from ACVP:
 	 * https://github.com/usnistgov/ACVP-Server/blob/v1.1.0.33/gen-val/json-files/hmacDRBG-1.0/prompt.json#L4596
 	 * https://github.com/usnistgov/ACVP-Server/blob/v1.1.0.33/gen-val/json-files/hmacDRBG-1.0/expectedResults.json#L986

base-commit: 5b03b1f97542c49a498dbb3b4c1fefb3aca60032
prerequisite-patch-id: a1deee4f4c866867dadd5eee0efe2b669ef2d650
-- 
2.54.0

