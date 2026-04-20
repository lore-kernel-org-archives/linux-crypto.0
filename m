Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A4438737E;
	Mon, 20 Apr 2026 06:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776667025; cv=none; b=XTDR6XElujOTjjn+/OtfGBnKzvvMiGcE86Bs257GiNkfsg6sRaYJtrHpdv2zEZaEVHgd+/91SB43O6IINo/h5dtwSyKAlSd6pcUM941NCRige6yOh93I4cRvAavHbbrim1bDMC9yLv63AMk3TBkGfVG0/4lmmvyDPHIVPzTM0JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776667025; c=relaxed/simple;
	bh=e0/wdAoJWFcZFuqkqc1p5usIC0haifOuj3ZtHG1edmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RgSYnYSxYjg1XSduK8bD70JoF756qBtJHhbiYm6HgP8eP6QTQbvu2WvlGP3d3JE2A28yGOsPj0uzRqtm3+c0tH6ol6SpUW/fcfzW035UhhKLjFnS787AxVXqIoOudhL1GRoTuD+Tig5tT5ejnxvLSLS8GMHNgyAtlDSdlBTA9pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PlsvAmWo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PlsvAmWo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36751C2BCB7;
	Mon, 20 Apr 2026 06:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776667025;
	bh=e0/wdAoJWFcZFuqkqc1p5usIC0haifOuj3ZtHG1edmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PlsvAmWoAv9Wxdlqa863PYiblDYyMszllVJq2YlTEgzi2/s145DjGztUQIlf4A+yI
	 43gR7tw+x12h6M0AsJzSTufh/YrPvy8BTbUj3nZfrQBpu5pSseOY7PONmnhYH2auoy
	 Sapf7jYkWAUHrMwfjwLHmL3gG87Cn2i97pwL2PYVLMBehfqR9KNlh7lNbODupo8b8z
	 FBtS/zCIC40QmQ3zG/14qyK4HdGIFlQZv0XcRPjz2xj7Zkd62Zr19ByWBlYfizEEbv
	 rVOf2Fm2z2KeysiPxr7uITo3s+Ye+EBFCnklIjXGjB392dcPkDds87m+PdSfN4SnG7
	 DxyBhL0YAHi3w==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 19/38] crypto: drbg - De-virtualize drbg_state_ops
Date: Sun, 19 Apr 2026 23:34:03 -0700
Message-ID: <20260420063422.324906-20-ebiggers@kernel.org>
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

Now that there's only one set of state operations, use direct calls to
those operations.

No change in behavior.  In particular, drbg_alloc_state() doesn't change
behavior, because the only remaining drbg_core uses HMAC_DRBG.
drbg_uninstantiate() doesn't change behavior, because a NULL d_ops
implied NULL priv_data which makes a drbg_fini_hash_kernel() a no-op.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/drbg.c | 50 ++++++--------------------------------------------
 1 file changed, 6 insertions(+), 44 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 4a778d0d1fc4..04c798d7a8b6 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -109,21 +109,10 @@ struct drbg_core {
 	char cra_name[CRYPTO_MAX_ALG_NAME]; /* mapping to kernel crypto API */
 	 /* kernel crypto API backend cipher name */
 	char backend_cra_name[CRYPTO_MAX_ALG_NAME];
 };
 
-struct drbg_state_ops {
-	int (*update)(struct drbg_state *drbg, struct list_head *seed,
-		      int reseed);
-	int (*generate)(struct drbg_state *drbg,
-			unsigned char *buf, unsigned int buflen,
-			struct list_head *addtl);
-	int (*crypto_init)(struct drbg_state *drbg);
-	int (*crypto_fini)(struct drbg_state *drbg);
-
-};
-
 enum drbg_seed_state {
 	DRBG_SEED_STATE_UNSEEDED,
 	DRBG_SEED_STATE_PARTIAL, /* Seeded with !rng_is_initialized() */
 	DRBG_SEED_STATE_FULL,
 };
@@ -141,11 +130,10 @@ struct drbg_state {
 
 	enum drbg_seed_state seeded;		/* DRBG fully seeded? */
 	unsigned long last_seed_time;
 	bool pr;		/* Prediction resistance enabled? */
 	struct crypto_rng *jent;
-	const struct drbg_state_ops *d_ops;
 	const struct drbg_core *core;
 	struct drbg_string test_data;
 };
 
 static inline __u8 drbg_statelen(struct drbg_state *drbg)
@@ -248,11 +236,11 @@ static inline unsigned short drbg_sec_strength(drbg_flag_t flags)
 		return 32;
 	}
 }
 
 /******************************************************************
- * HMAC DRBG callback functions
+ * HMAC DRBG functions
  ******************************************************************/
 
 static int drbg_kcapi_hash(struct drbg_state *drbg, unsigned char *outval,
 			   const struct list_head *in);
 static void drbg_kcapi_hmacsetkey(struct drbg_state *drbg,
@@ -358,25 +346,14 @@ static int drbg_hmac_generate(struct drbg_state *drbg,
 		return ret;
 
 	return len;
 }
 
-static const struct drbg_state_ops drbg_hmac_ops = {
-	.update		= drbg_hmac_update,
-	.generate	= drbg_hmac_generate,
-	.crypto_init	= drbg_init_hash_kernel,
-	.crypto_fini	= drbg_fini_hash_kernel,
-};
-
-/******************************************************************
- * Functions common for DRBG implementations
- ******************************************************************/
-
 static inline int __drbg_seed(struct drbg_state *drbg, struct list_head *seed,
 			      int reseed, enum drbg_seed_state new_seed_state)
 {
-	int ret = drbg->d_ops->update(drbg, seed, reseed);
+	int ret = drbg_hmac_update(drbg, seed, reseed);
 
 	if (ret)
 		return ret;
 
 	drbg->seeded = new_seed_state;
@@ -576,11 +553,10 @@ static inline void drbg_dealloc_state(struct drbg_state *drbg)
 	drbg->V = NULL;
 	kfree_sensitive(drbg->Cbuf);
 	drbg->Cbuf = NULL;
 	drbg->C = NULL;
 	drbg->reseed_ctr = 0;
-	drbg->d_ops = NULL;
 	drbg->core = NULL;
 }
 
 /*
  * Allocate all sub-structures for a DRBG state.
@@ -588,20 +564,11 @@ static inline void drbg_dealloc_state(struct drbg_state *drbg)
  */
 static inline int drbg_alloc_state(struct drbg_state *drbg)
 {
 	int ret = -ENOMEM;
 
-	switch (drbg->core->flags & DRBG_TYPE_MASK) {
-	case DRBG_HMAC:
-		drbg->d_ops = &drbg_hmac_ops;
-		break;
-	default:
-		ret = -EOPNOTSUPP;
-		goto err;
-	}
-
-	ret = drbg->d_ops->crypto_init(drbg);
+	ret = drbg_init_hash_kernel(drbg);
 	if (ret < 0)
 		goto err;
 
 	drbg->Vbuf = kmalloc(drbg_statelen(drbg) + ret, GFP_KERNEL);
 	if (!drbg->Vbuf) {
@@ -617,20 +584,16 @@ static inline int drbg_alloc_state(struct drbg_state *drbg)
 	drbg->C = PTR_ALIGN(drbg->Cbuf, ret + 1);
 
 	return 0;
 
 fini:
-	drbg->d_ops->crypto_fini(drbg);
+	drbg_fini_hash_kernel(drbg);
 err:
 	drbg_dealloc_state(drbg);
 	return ret;
 }
 
-/*************************************************************************
- * DRBG interface functions
- *************************************************************************/
-
 /*
  * DRBG generate function as required by SP800-90A - this function
  * generates random numbers
  *
  * @drbg DRBG state handle
@@ -712,11 +675,11 @@ static int drbg_generate(struct drbg_state *drbg,
 	}
 
 	if (addtl && 0 < addtl->len)
 		list_add_tail(&addtl->list, &addtllist);
 	/* 9.3.1 step 8 and 10 */
-	len = drbg->d_ops->generate(drbg, buf, buflen, &addtllist);
+	len = drbg_hmac_generate(drbg, buf, buflen, &addtllist);
 
 	/* 10.1.2.5 step 7 */
 	drbg->reseed_ctr++;
 	if (0 >= len)
 		goto err;
@@ -877,12 +840,11 @@ static int drbg_uninstantiate(struct drbg_state *drbg)
 {
 	if (!IS_ERR_OR_NULL(drbg->jent))
 		crypto_free_rng(drbg->jent);
 	drbg->jent = NULL;
 
-	if (drbg->d_ops)
-		drbg->d_ops->crypto_fini(drbg);
+	drbg_fini_hash_kernel(drbg);
 	drbg_dealloc_state(drbg);
 	/* no scrubbing of test_data -- this shall survive an uninstantiate */
 	return 0;
 }
 
-- 
2.53.0

