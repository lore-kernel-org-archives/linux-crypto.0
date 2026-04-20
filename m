Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EED33845AC;
	Mon, 20 Apr 2026 06:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776667022; cv=none; b=clZUxWoHokRFoaslZcvS6NEspNY5ZoVbOyu+sCRd4gxMXJ0JgQyp0wvJ5QDGIRkKv0E5S7+HL2LdZIAOB6FYfwPTz7Z1oIr1e/YVJeY2ZPom2eGuvv+FXRnrK+TEsiu81ZxhZ2VpG5YKva2D1q938Cvbl+rij3O10TI4eCImoqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776667022; c=relaxed/simple;
	bh=KZcXy67sV84ulxFLxaLdP22xkti5GFL6GdBgNkqGEmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VliNqCK7T0iyS8Aa0HOXsr31pc8kwSZhOTIGBoeGyiSdBUq085xaIqHTYjxsli84eKN6hJlkN7NVEFIqNeW9mpK4xB60pWI2X64Y5EzYODrIz00FWYv7+ZK1XCB5NlVHM2+up3HpCsFBoTHMYciSzA999RlCIhlXheR0Q4Q43sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fvQSiOob; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fvQSiOob"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 071C0C2BCB3;
	Mon, 20 Apr 2026 06:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776667022;
	bh=KZcXy67sV84ulxFLxaLdP22xkti5GFL6GdBgNkqGEmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fvQSiOobkZhSsEssNNaqxpaR/UWfiqRiop6hfojpgK3ZgtJrtiM5+tcIjInc7vGTe
	 +kKQLkbBO+vHH2MFfa5C90SpeK5rIJBUkqxkRc1ekkfNKc80PIIFmyRqzD3WpGkFsN
	 aLKmVogCGdpSnVO6E1AXDGclgRb3kASQzGycMF6dh97JBtHLfvQESBTN/vAXv/0y6A
	 6lwtBVYLTw3SnmiM5Nl9ZwanFnJCLrneR+cHBsl4ToCvi14onds4uxJYS7StpxPMT1
	 x2csChQjVDe4JbBpVSeeCnb31jPEFwzpEBzfLHfn/8WDIY3WicZ1pPDGS5BrBaNpqR
	 htsTYi2lQsNsw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 09/38] crypto: drbg - Remove obsolete FIPS 140-2 continuous test
Date: Sun, 19 Apr 2026 23:33:53 -0700
Message-ID: <20260420063422.324906-10-ebiggers@kernel.org>
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

FIPS 140-2 required that a continuous test for repeated outputs be done
on both "Approved RNGs" and "Non-Approved RNGs".

That's apparently why crypto/drbg.c does such a test on the bytes it
pulls from get_random_bytes(), despite get_random_bytes() being a
"Non-Approved RNG" that is credited with zero entropy for FIPS purposes.
(From FIPS's point of view, the "Approved RNG" is jitterentropy.)

FIPS 140-3 "modernized" the continuous RNG test requirements.  They're
now a bit more sophisticated, requiring both an "Adaptive Proportion
Test" and a "Repetition Count Test".

At the same time, FIPS 140-3 doesn't require continuous RNG tests on
"Non-Approved RNGs" if a "vetted conditioning component" is used.  The
SP800-90A DRBGs are exactly such a vetted conditioning component, by
their design.  (In the case of HASH_DRBG and CTR_DRBG, the derivation
function does have to be implemented.  But the kernel does that.)

In other words: from FIPS 140-3's point of view, get_random_bytes()
still produces zero entropy, but the way the DRBG combines those bytes
with the jitterentropy bytes preserves all the "approved" entropy from
jitterentropy.  Thus no test for get_random_bytes() is required.

Seeing as FIPS 140-2 certificates stopped being issued in 2021 in favor
of FIPS 140-3, this means this code is obsolete.  Remove it.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/drbg.c         | 78 ++-----------------------------------------
 include/crypto/drbg.h |  2 --
 2 files changed, 2 insertions(+), 78 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 83cb6c1bbac0..66d7739469c6 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -203,59 +203,10 @@ static inline unsigned short drbg_sec_strength(drbg_flag_t flags)
 	default:
 		return 32;
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
- *	%true on success
- *	%false when the CTRNG is not yet primed
- */
-static bool drbg_fips_continuous_test(struct drbg_state *drbg,
-				      const unsigned char *entropy)
-	__must_hold(&drbg->drbg_mutex)
-{
-	unsigned short entropylen = drbg_sec_strength(drbg->core->flags);
-
-	if (!IS_ENABLED(CONFIG_CRYPTO_FIPS))
-		return true;
-
-	/* skip test if we test the overall system */
-	if (list_empty(&drbg->test_data.list))
-		return true;
-	/* only perform test in FIPS mode */
-	if (!fips_enabled)
-		return true;
-
-	if (!drbg->fips_primed) {
-		/* Priming of FIPS test */
-		memcpy(drbg->prev, entropy, entropylen);
-		drbg->fips_primed = true;
-		/* priming: another round is needed */
-		return false;
-	}
-	if (!memcmp(drbg->prev, entropy, entropylen))
-		panic("DRBG continuous self test failed\n");
-	memcpy(drbg->prev, entropy, entropylen);
-
-	/* the test shall pass when the two values are not equal */
-	return true;
-}
-
 /******************************************************************
  * CTR DRBG callback functions
  ******************************************************************/
 
 #ifdef CONFIG_CRYPTO_DRBG_CTR
@@ -831,20 +782,10 @@ static inline int __drbg_seed(struct drbg_state *drbg, struct list_head *seed,
 	}
 
 	return ret;
 }
 
-static inline void drbg_get_random_bytes(struct drbg_state *drbg,
-					 unsigned char *entropy,
-					 unsigned int entropylen)
-	__must_hold(&drbg->drbg_mutex)
-{
-	do
-		get_random_bytes(entropy, entropylen);
-	while (!drbg_fips_continuous_test(drbg, entropy));
-}
-
 static int drbg_seed_from_random(struct drbg_state *drbg)
 	__must_hold(&drbg->drbg_mutex)
 {
 	struct drbg_string data;
 	LIST_HEAD(seedlist);
@@ -856,11 +797,11 @@ static int drbg_seed_from_random(struct drbg_state *drbg)
 	BUG_ON(entropylen > sizeof(entropy));
 
 	drbg_string_fill(&data, entropy, entropylen);
 	list_add_tail(&data.list, &seedlist);
 
-	drbg_get_random_bytes(drbg, entropy, entropylen);
+	get_random_bytes(entropy, entropylen);
 
 	ret = __drbg_seed(drbg, &seedlist, true, DRBG_SEED_STATE_FULL);
 
 	memzero_explicit(entropy, entropylen);
 	return ret;
@@ -935,11 +876,11 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
 
 		/* Get seed from in-kernel /dev/urandom */
 		if (!rng_is_initialized())
 			new_seed_state = DRBG_SEED_STATE_PARTIAL;
 
-		drbg_get_random_bytes(drbg, entropy, entropylen);
+		get_random_bytes(entropy, entropylen);
 
 		if (!drbg->jent) {
 			drbg_string_fill(&data1, entropy, entropylen);
 			pr_devel("DRBG: (re)seeding with %u bytes of entropy\n",
 				 entropylen);
@@ -1016,15 +957,10 @@ static inline void drbg_dealloc_state(struct drbg_state *drbg)
 	kfree_sensitive(drbg->scratchpadbuf);
 	drbg->scratchpadbuf = NULL;
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
  * Allocate all sub-structures for a DRBG state.
  * The DRBG state structure must already be allocated.
@@ -1086,20 +1022,10 @@ static inline int drbg_alloc_state(struct drbg_state *drbg)
 			goto fini;
 		}
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
 	drbg->d_ops->crypto_fini(drbg);
 err:
diff --git a/include/crypto/drbg.h b/include/crypto/drbg.h
index 486aa793688e..4fafc69a8ee6 100644
--- a/include/crypto/drbg.h
+++ b/include/crypto/drbg.h
@@ -107,12 +107,10 @@ struct drbg_state {
 	struct scatterlist sg_in, sg_out;	/* CTR mode SGLs */
 
 	enum drbg_seed_state seeded;		/* DRBG fully seeded? */
 	unsigned long last_seed_time;
 	bool pr;		/* Prediction resistance enabled? */
-	bool fips_primed;	/* Continuous test primed? */
-	unsigned char *prev;	/* FIPS 140-2 continuous test value */
 	struct crypto_rng *jent;
 	const struct drbg_state_ops *d_ops;
 	const struct drbg_core *core;
 	struct drbg_string test_data;
 };
-- 
2.53.0

