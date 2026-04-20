Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0132392C40;
	Mon, 20 Apr 2026 06:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776667030; cv=none; b=nPEjVO2+q8q19m9RDxPN9NofeW0AkcICY/tH4nyPvB/Nsm6Yds7/0P0VYRTB/z7RrP42CE2pEc+sNht4iWdDFk/s0x67fr3ZGEqriTP+4ptyL6yoE2wyhZKGGDETBZH0kOohP5cKNomAy3nnk4lqrJu6r1ZC5wTIoDl+0f6BBlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776667030; c=relaxed/simple;
	bh=hpWaYJuGiyxILUyD/IgvMd2mea6+6ohyJb+y/HjeAAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AeaYaL31WiOXqJEOWAU7g86kUHSE7fAGeyXEM4IZrV0sJww1ZWEhOhh2AMSSPIXi410J6I6Bb+SVqAelkxLUkD6J/qYJieGQP0CN590FlmY3mmGBFOhR+EGescWbi0fFasTrbv+HGiV8dpd07CkxtNUz47ZWVpx4oorlTvyaI0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XR8v9xOO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XR8v9xOO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76FA8C2BCC6;
	Mon, 20 Apr 2026 06:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776667029;
	bh=hpWaYJuGiyxILUyD/IgvMd2mea6+6ohyJb+y/HjeAAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XR8v9xOO2Pc8WPJm3ku95sprky7HvE3fspYZZ3lA+WMJcvdjJ3XtIjs4oPst2rIfk
	 +EEiR4Xj+08uLACNu7wcAb6f08SpZeVXJLJ2fLT/fANtR6GtUFDdiKOALft65A5M75
	 Lg8hRKeCDhjKtlCUGn+ZoFoUTonevNQjqplWX98Htk9m8lQ5Kz9HuwNwyUakrmGgpb
	 b4RSass9eNdO9KULc9/1WCbk3onm7IR8WNIsLTIxEdHhhY+4CGUHdXLyWKYgqko3h0
	 nnJzuBb7GuXXaJv8yN79l3XUeGbLTekCIef927tt+ekCJcf/jizA2vBstulchZ75Fg
	 P/kM1speK4fhw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 33/38] crypto: drbg - Simplify "uninstantiate" logic
Date: Sun, 19 Apr 2026 23:34:17 -0700
Message-ID: <20260420063422.324906-34-ebiggers@kernel.org>
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

drbg_kcapi_seed() calls drbg_uninstantiate() only to free drbg->jent and
set drbg->instantiated = false.  However, the latter is necessary only
because drbg_kcapi_seed() sets drbg->instantiated = true too early.  Fix
that, then just inline the freeing of drbg->jent.

Then, simplify the actual "uninstantiate" in drbg_kcapi_exit().  Just
free drbg->jent (note that this is a no-op on error and null pointers),
then memzero_explicit() the entire drbg_state.

Note that in reality the memzero_explicit() is redundant, since the
crypto_rng API zeroizes the memory anyway.  But the way SP800-90A is
worded, it's easy to imagine that someone assessing conformance with it
would be looking for code in drbg.c that says it does an "Uninstantiate"
and does the zeroization.  So it's probably worth keeping it somewhat
explicit, even though that means double zeroization in practice.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/drbg.c | 57 ++++++++++++---------------------------------------
 1 file changed, 13 insertions(+), 44 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 45d97f3ba4ef..b2af481aef01 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -150,12 +150,10 @@ struct drbg_state {
 enum drbg_prefixes {
 	DRBG_PREFIX0 = 0x00,
 	DRBG_PREFIX1,
 };
 
-static int drbg_uninstantiate(struct drbg_state *drbg);
-
 /******************************************************************
  * HMAC DRBG functions
  ******************************************************************/
 
 /* update function of HMAC DRBG as defined in 10.1.2.2 */
@@ -388,21 +386,10 @@ static int drbg_seed(struct drbg_state *drbg, const u8 *pers, size_t pers_len,
 	memzero_explicit(entropy_buf, sizeof(entropy_buf));
 
 	return ret;
 }
 
-/* Free all substructures in a DRBG state without the DRBG state structure */
-static inline void drbg_dealloc_state(struct drbg_state *drbg)
-{
-	if (!drbg)
-		return;
-	memzero_explicit(&drbg->key, sizeof(drbg->key));
-	memzero_explicit(drbg->V, sizeof(drbg->V));
-	drbg->reseed_ctr = 0;
-	drbg->instantiated = false;
-}
-
 /*
  * DRBG generate function as required by SP800-90A - this function
  * generates random numbers
  *
  * @drbg DRBG state handle
@@ -504,30 +491,10 @@ static int drbg_generate(struct drbg_state *drbg,
 	len = 0;
 err:
 	return len;
 }
 
-/*
- * DRBG uninstantiate function as required by SP800-90A - this function
- * frees all buffers and the DRBG handle
- *
- * @drbg DRBG state handle
- *
- * return
- *	0 on success
- */
-static int drbg_uninstantiate(struct drbg_state *drbg)
-{
-	if (!IS_ERR_OR_NULL(drbg->jent))
-		crypto_free_rng(drbg->jent);
-	drbg->jent = NULL;
-
-	drbg_dealloc_state(drbg);
-	/* no scrubbing of test_data -- this shall survive an uninstantiate */
-	return 0;
-}
-
 /***************************************************************
  * Kernel crypto API interface to DRBG
  ***************************************************************/
 
 static int drbg_kcapi_init(struct crypto_tfm *tfm)
@@ -573,11 +540,10 @@ static int drbg_kcapi_seed(struct crypto_rng *tfm,
 	 * all DRBG types support prediction resistance
 	 */
 
 	/* 9.1 step 4 is implicit in DRBG_SEC_STRENGTH */
 
-	drbg->instantiated = true;
 	drbg->pr = pr;
 	drbg->seeded = DRBG_SEED_STATE_UNSEEDED;
 	drbg->last_seed_time = 0;
 	drbg->reseed_threshold = DRBG_MAX_REQUESTS;
 	memset(drbg->V, 1, DRBG_STATE_LEN);
@@ -588,24 +554,23 @@ static int drbg_kcapi_seed(struct crypto_rng *tfm,
 		drbg->jent = crypto_alloc_rng("jitterentropy_rng", 0, 0);
 		if (IS_ERR(drbg->jent)) {
 			ret = PTR_ERR(drbg->jent);
 			drbg->jent = NULL;
 			if (fips_enabled)
-				goto free_everything;
+				return ret;
 			pr_info("DRBG: Continuing without Jitter RNG\n");
 		}
 	}
 
 	ret = drbg_seed(drbg, pers, pers_len, /* reseed= */ false);
-	if (ret)
-		goto free_everything;
-
-	return ret;
-
-free_everything:
-	drbg_uninstantiate(drbg);
-	return ret;
+	if (ret) {
+		crypto_free_rng(drbg->jent);
+		drbg->jent = NULL;
+		return ret;
+	}
+	drbg->instantiated = true;
+	return 0;
 }
 
 static int drbg_kcapi_seed_pr(struct crypto_rng *tfm,
 			      const u8 *seed, unsigned int slen)
 {
@@ -649,13 +614,17 @@ static int drbg_kcapi_generate(struct crypto_rng *tfm,
 		dlen -= n;
 	} while (dlen);
 	return 0;
 }
 
+/* Uninstantiate the DRBG. */
 static void drbg_kcapi_exit(struct crypto_tfm *tfm)
 {
-	drbg_uninstantiate(crypto_tfm_ctx(tfm));
+	struct drbg_state *drbg = crypto_tfm_ctx(tfm);
+
+	crypto_free_rng(drbg->jent);
+	memzero_explicit(drbg, sizeof(*drbg));
 }
 
 /*
  * Tests as defined in 11.3.2 in addition to the cipher tests: testing
  * of the error handling.
-- 
2.53.0

