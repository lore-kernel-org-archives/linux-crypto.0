Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B86E5388394;
	Mon, 20 Apr 2026 06:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776667026; cv=none; b=M6eBJcSBe7zRk99q4ibE1/4tQOo8Tafkn2FMTt2DxQctmMgHPZQ+prB+LDfP5rCRT9jvXie9gXuFicWw7qAmYTqpYgtRxRIxiKgX7nnxpppo/5t1XC/l1gCyAS5rk5BcPXmHL8kf2dauLh+BXsxYKv5YgGsmExtUtdRkSyNLO2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776667026; c=relaxed/simple;
	bh=6iWFXwT7g3CwESLmufrOgjkn1qk9gLL0VmCEt7dkSlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QNt8CAmDju61KXRoetgkGXS91y3ofrHZJD8zIcbc5E8WBDWt/l50twtcszyRPw7zhjija6RCXNEs9Kv7IhO8Fj/67Pp3UdwDrWQTHQytn5Sy+YkTnA1gdrZYHGdwb6idLEJNn5PMbJLOthBNvPWo27LTDTQF2tzLXdnkaWgM7i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a/fGi8e8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a/fGi8e8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C004C2BCB3;
	Mon, 20 Apr 2026 06:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776667026;
	bh=6iWFXwT7g3CwESLmufrOgjkn1qk9gLL0VmCEt7dkSlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a/fGi8e8azkQRbEnvMvzOgNs9P1uXnC6F7mxm51prQvIs5U2WHNnvSOjdVVeD9paf
	 mCrb6D/m49PHRfsWQAQsmwWHE9jV5sAYciTaglSQSW0Vly/BHJED1/xpxpCxDa/B6L
	 mAd4GVXtfXN+3IwZE2C8WGhywicghlhsCtt183k5+oG+446LHHR04ebsY2c25+v8qb
	 +cEdccsLOcYIp+03KXsM9+CkiXXb+B4+RKtCvTkp2gwRLXUe0F8TtREtHZDdgZN9Mj
	 idhez2p7ADwfQfuuxyx5AXKVkbmle2ErPDhunw6yGlEC5vqL1OvejS/RsQaoMLRJ+7
	 czWT5FIp+Btpg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 23/38] crypto: drbg - Remove drbg_core
Date: Sun, 19 Apr 2026 23:34:07 -0700
Message-ID: <20260420063422.324906-24-ebiggers@kernel.org>
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

Now that none of the information in struct drbg_core is used, remove it.

The null-ity of the pointer drbg_state::core was used to keep track of
whether the DRBG has been instantiated.  Replace it with a boolean.

No functional change.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/drbg.c | 99 +++++++--------------------------------------------
 1 file changed, 13 insertions(+), 86 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 4f326385cf36..161070b10f85 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -98,18 +98,10 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/string_choices.h>
 #include <linux/unaligned.h>
 
-struct drbg_state;
-
-struct drbg_core {
-	char cra_name[CRYPTO_MAX_ALG_NAME]; /* mapping to kernel crypto API */
-	 /* kernel crypto API backend cipher name */
-	char backend_cra_name[CRYPTO_MAX_ALG_NAME];
-};
-
 enum drbg_seed_state {
 	DRBG_SEED_STATE_UNSEEDED,
 	DRBG_SEED_STATE_PARTIAL, /* Seeded with !rng_is_initialized() */
 	DRBG_SEED_STATE_FULL,
 };
@@ -148,39 +140,21 @@ struct drbg_state {
 	/* Number of RNG requests since last reseed -- 10.1.2.1 1c */
 	size_t reseed_ctr;
 	size_t reseed_threshold;
 	enum drbg_seed_state seeded;		/* DRBG fully seeded? */
 	unsigned long last_seed_time;
+	bool instantiated;
 	bool pr;		/* Prediction resistance enabled? */
 	struct crypto_rng *jent;
-	const struct drbg_core *core;
 	struct drbg_string test_data;
 };
 
 enum drbg_prefixes {
 	DRBG_PREFIX0 = 0x00,
 	DRBG_PREFIX1,
 };
 
-/***************************************************************
- * Backend cipher definitions available to DRBG
- ***************************************************************/
-
-/*
- * The order of the DRBG definitions here matter: every DRBG is registered
- * as stdrng. Each DRBG receives an increasing cra_priority values the later
- * they are defined in this array (see drbg_fill_array).
- *
- * Thus, the favored DRBGs are the latest entries in this array.
- */
-static const struct drbg_core drbg_cores[] = {
-	{
-		.cra_name = "hmac_sha512",
-		.backend_cra_name = "hmac(sha512)",
-	},
-};
-
 static int drbg_uninstantiate(struct drbg_state *drbg);
 
 /******************************************************************
  * HMAC DRBG functions
  ******************************************************************/
@@ -453,11 +427,11 @@ static inline void drbg_dealloc_state(struct drbg_state *drbg)
 		return;
 	memzero_explicit(&drbg->key, sizeof(drbg->key));
 	memzero_explicit(drbg->V, sizeof(drbg->V));
 	memzero_explicit(drbg->C, sizeof(drbg->C));
 	drbg->reseed_ctr = 0;
-	drbg->core = NULL;
+	drbg->instantiated = false;
 }
 
 /*
  * DRBG generate function as required by SP800-90A - this function
  * generates random numbers
@@ -480,12 +454,12 @@ static int drbg_generate(struct drbg_state *drbg,
 	__must_hold(&drbg->drbg_mutex)
 {
 	int len = 0;
 	LIST_HEAD(addtllist);
 
-	if (!drbg->core) {
-		pr_devel("DRBG: not yet seeded\n");
+	if (!drbg->instantiated) {
+		pr_devel("DRBG: not yet instantiated\n");
 		return -EINVAL;
 	}
 	if (0 == buflen || !buf) {
 		pr_devel("DRBG: no output buffer provided\n");
 		return -EINVAL;
@@ -623,25 +597,24 @@ static int drbg_prepare_hrng(struct drbg_state *drbg)
  * @drbg memory of state -- if NULL, new memory is allocated
  * @pers Personalization string that is mixed into state, may be NULL -- note
  *	 the entropy is pulled by the DRBG internally unconditionally
  *	 as defined in SP800-90A. The additional input is mixed into
  *	 the state in addition to the pulled entropy.
- * @coreref reference to core
  * @pr prediction resistance enabled
  *
  * return
  *	0 on success
  *	error value otherwise
  */
 static int drbg_instantiate(struct drbg_state *drbg, struct drbg_string *pers,
-			    int coreref, bool pr)
+			    bool pr)
 {
 	int ret;
 	bool reseed = true;
 
-	pr_devel("DRBG: Initializing DRBG core %d with prediction resistance "
-		 "%s\n", coreref, str_enabled_disabled(pr));
+	pr_devel("DRBG: Initializing DRBG with prediction resistance %s\n",
+		 str_enabled_disabled(pr));
 	mutex_lock(&drbg->drbg_mutex);
 
 	/* 9.1 step 1 is implicit with the selected DRBG type */
 
 	/*
@@ -649,12 +622,12 @@ static int drbg_instantiate(struct drbg_state *drbg, struct drbg_string *pers,
 	 * all DRBG types support prediction resistance
 	 */
 
 	/* 9.1 step 4 is implicit in DRBG_SEC_STRENGTH */
 
-	if (!drbg->core) {
-		drbg->core = &drbg_cores[coreref];
+	if (!drbg->instantiated) {
+		drbg->instantiated = true;
 		drbg->pr = pr;
 		drbg->seeded = DRBG_SEED_STATE_UNSEEDED;
 		drbg->last_seed_time = 0;
 		drbg->reseed_threshold = DRBG_MAX_REQUESTS;
 
@@ -718,50 +691,10 @@ static void drbg_kcapi_set_entropy(struct crypto_rng *tfm,
 
 /***************************************************************
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
 
 	mutex_init(&drbg->drbg_mutex);
@@ -806,23 +739,21 @@ static int drbg_kcapi_random(struct crypto_rng *tfm,
 static int drbg_kcapi_seed(struct crypto_rng *tfm,
 			   const u8 *seed, unsigned int slen)
 {
 	struct drbg_state *drbg = crypto_rng_ctx(tfm);
 	struct crypto_tfm *tfm_base = crypto_rng_tfm(tfm);
-	bool pr = false;
+	bool pr = memcmp(crypto_tfm_alg_driver_name(tfm_base),
+			 "drbg_nopr_", 10) != 0;
 	struct drbg_string string;
 	struct drbg_string *seed_string = NULL;
-	int coreref = 0;
 
-	drbg_convert_tfm_core(crypto_tfm_alg_driver_name(tfm_base), &coreref,
-			      &pr);
 	if (0 < slen) {
 		drbg_string_fill(&string, seed, slen);
 		seed_string = &string;
 	}
 
-	return drbg_instantiate(drbg, seed_string, coreref, pr);
+	return drbg_instantiate(drbg, seed_string, pr);
 }
 
 /***************************************************************
  * Kernel module: code to load the module
  ***************************************************************/
@@ -842,26 +773,22 @@ static inline int __init drbg_healthcheck_sanity(void)
 #define OUTBUFLEN 16
 	unsigned char buf[OUTBUFLEN];
 	struct drbg_state *drbg = NULL;
 	int ret;
 	int rc = -EFAULT;
-	bool pr = false;
-	int coreref = 0;
 	struct drbg_string addtl;
 
 	/* only perform test in FIPS mode */
 	if (!fips_enabled)
 		return 0;
 
-	drbg_convert_tfm_core("drbg_nopr_hmac_sha512", &coreref, &pr);
-
 	drbg = kzalloc_obj(struct drbg_state);
 	if (!drbg)
 		return -ENOMEM;
 
 	guard(mutex_init)(&drbg->drbg_mutex);
-	drbg->core = &drbg_cores[coreref];
+	drbg->instantiated = true;
 	drbg->reseed_threshold = DRBG_MAX_REQUESTS;
 
 	/*
 	 * if the following tests fail, it is likely that there is a buffer
 	 * overflow as buf is much smaller than the requested or provided
-- 
2.53.0

