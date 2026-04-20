Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A713638C2BF;
	Mon, 20 Apr 2026 06:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776667028; cv=none; b=madzvztFy1m2Ax/ejKz4wfg1s69o80qjG2moTIu+JXcVuHGMBAT1hDRTaYZ4qhOYSMjYhGtjOuxOtdplcN86TkrIX7Hcl+dElGe/1NCcl6FQ4eQsHHCce1WZbtX8PJIMRpES0hh5M01Lv7exKIeaOU12S8rPXPxeIkGfZvtOCGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776667028; c=relaxed/simple;
	bh=ab8Oa2H2wZFJso1ODU8GqfkTnczdmMsLEyZChrbqkyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AVDFVGsuszPnE4OLy+qX4ZmjOvf8fjJ0dkSCHOYQLUCOfOVLgviN1o7nUpG/HHvK7+y2DErOjSg7IQT1JVj9gZrDYvsBP34Dj9FBZYpsLBjKG9xo2PMX2JXX5seKIiT91abzdraA/VvoaSQYFn0YNzMJDiOiICBCxBD3Nm4+FEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KjcsmHhT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KjcsmHhT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 418BEC2BCB7;
	Mon, 20 Apr 2026 06:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776667028;
	bh=ab8Oa2H2wZFJso1ODU8GqfkTnczdmMsLEyZChrbqkyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KjcsmHhTUSWES02V0OrAX+WNt6kiE6FbaPHiUd857CaJjDMofOCMxWnMOBl3A91qH
	 tbKxkZCW1vK2/h7gzw6grI3lMlFlaFLKZNjex2sAp+Lhp6Ay4TAkeB+ncwlXjnRTps
	 d5ABGzJq7UvsyozgTaVpFhX7dwjU0KawD5+FTP59+Wlhb6iFUoBhe/VDKIhErrWXOd
	 v+1hXw0201FKj12OcO/aAhckAh+7v0xQT69KcR1urHVRWLH/on0EQDAFPCJZ8eLvxt
	 6ZEU1UKa2Jki5WJmg/a9/AuAfsuhYnwvnA68c+YUBZSxHDYmdJTBguLFuJpjMpBH1s
	 bAVBzvuZ1spkw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 29/38] crypto: drbg - Put rng_alg methods in logical order
Date: Sun, 19 Apr 2026 23:34:13 -0700
Message-ID: <20260420063422.324906-30-ebiggers@kernel.org>
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

Put the DRBG implementation of the rng_alg methods in the order in which
they're called (cra_init => set_ent => seed => generate => cra_exit) so
that it's easier to understand the flow.

Also rename drbg_kcapi_random to drbg_kcapi_generate, and
drbg_kcapi_cleanup to drbg_kcapi_exit, so they match the method names.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/drbg.c | 82 ++++++++++++++++++++++-----------------------------
 1 file changed, 36 insertions(+), 46 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 9ff1a0e1b129..ef9c3e9fdf6e 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -607,17 +607,24 @@ static int drbg_uninstantiate(struct drbg_state *drbg)
 	drbg_dealloc_state(drbg);
 	/* no scrubbing of test_data -- this shall survive an uninstantiate */
 	return 0;
 }
 
-/*
- * Helper function for setting the test data in the DRBG
- *
- * @drbg DRBG state handle
- * @data test data
- * @len test data length
- */
+/***************************************************************
+ * Kernel crypto API interface to DRBG
+ ***************************************************************/
+
+static int drbg_kcapi_init(struct crypto_tfm *tfm)
+{
+	struct drbg_state *drbg = crypto_tfm_ctx(tfm);
+
+	mutex_init(&drbg->drbg_mutex);
+
+	return 0;
+}
+
+/* Set test entropy in the DRBG. */
 static void drbg_kcapi_set_entropy(struct crypto_rng *tfm,
 				   const u8 *data, unsigned int len)
 {
 	struct drbg_state *drbg = crypto_rng_ctx(tfm);
 
@@ -625,39 +632,42 @@ static void drbg_kcapi_set_entropy(struct crypto_rng *tfm,
 	drbg->test_entropy = data;
 	drbg->test_entropylen = len;
 	mutex_unlock(&drbg->drbg_mutex);
 }
 
-/***************************************************************
- * Kernel crypto API interface to register DRBG
- ***************************************************************/
-
-static int drbg_kcapi_init(struct crypto_tfm *tfm)
+/* Seed (i.e. instantiate) or re-seed the DRBG. */
+static int drbg_kcapi_seed(struct crypto_rng *tfm,
+			   const u8 *seed, unsigned int slen, bool pr)
 {
-	struct drbg_state *drbg = crypto_tfm_ctx(tfm);
+	struct drbg_state *drbg = crypto_rng_ctx(tfm);
 
-	mutex_init(&drbg->drbg_mutex);
+	return drbg_instantiate(drbg, seed, slen, pr);
+}
 
-	return 0;
+static int drbg_kcapi_seed_pr(struct crypto_rng *tfm,
+			      const u8 *seed, unsigned int slen)
+{
+	return drbg_kcapi_seed(tfm, seed, slen, /* pr= */ true);
 }
 
-static void drbg_kcapi_cleanup(struct crypto_tfm *tfm)
+static int drbg_kcapi_seed_nopr(struct crypto_rng *tfm,
+				const u8 *seed, unsigned int slen)
 {
-	drbg_uninstantiate(crypto_tfm_ctx(tfm));
+	return drbg_kcapi_seed(tfm, seed, slen, /* pr= */ false);
 }
 
 /*
  * Generate random numbers invoked by the kernel crypto API:
  *
  * src is additional input supplied to the RNG.
  * slen is the length of src.
  * dst is the output buffer where random data is to be stored.
  * dlen is the length of dst.
  */
-static int drbg_kcapi_random(struct crypto_rng *tfm,
-			     const u8 *src, unsigned int slen,
-			     u8 *dst, unsigned int dlen)
+static int drbg_kcapi_generate(struct crypto_rng *tfm,
+			       const u8 *src, unsigned int slen,
+			       u8 *dst, unsigned int dlen)
 {
 	struct drbg_state *drbg = crypto_rng_ctx(tfm);
 
 	/*
 	 * Break the request into multiple requests if needed, to avoid
@@ -676,35 +686,15 @@ static int drbg_kcapi_random(struct crypto_rng *tfm,
 		dlen -= n;
 	} while (dlen);
 	return 0;
 }
 
-/* Seed (i.e. instantiate) or re-seed the DRBG. */
-static int drbg_kcapi_seed(struct crypto_rng *tfm,
-			   const u8 *seed, unsigned int slen, bool pr)
+static void drbg_kcapi_exit(struct crypto_tfm *tfm)
 {
-	struct drbg_state *drbg = crypto_rng_ctx(tfm);
-
-	return drbg_instantiate(drbg, seed, slen, pr);
-}
-
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
+	drbg_uninstantiate(crypto_tfm_ctx(tfm));
 }
 
-/***************************************************************
- * Kernel module: code to load the module
- ***************************************************************/
-
 /*
  * Tests as defined in 11.3.2 in addition to the cipher tests: testing
  * of the error handling.
  *
  * Note: testing of failing seed source as defined in 11.3.2 is not applicable
@@ -767,24 +757,24 @@ static struct rng_alg drbg_algs[] = {
 		.base.cra_ctxsize	= sizeof(struct drbg_state),
 		.base.cra_module	= THIS_MODULE,
 		.base.cra_init		= drbg_kcapi_init,
 		.set_ent		= drbg_kcapi_set_entropy,
 		.seed			= drbg_kcapi_seed_pr,
-		.generate		= drbg_kcapi_random,
-		.base.cra_exit		= drbg_kcapi_cleanup,
+		.generate		= drbg_kcapi_generate,
+		.base.cra_exit		= drbg_kcapi_exit,
 	},
 	{
 		.base.cra_name		= "stdrng",
 		.base.cra_driver_name	= "drbg_nopr_hmac_sha512",
 		.base.cra_priority	= 201,
 		.base.cra_ctxsize	= sizeof(struct drbg_state),
 		.base.cra_module	= THIS_MODULE,
 		.base.cra_init		= drbg_kcapi_init,
 		.set_ent		= drbg_kcapi_set_entropy,
 		.seed			= drbg_kcapi_seed_nopr,
-		.generate		= drbg_kcapi_random,
-		.base.cra_exit		= drbg_kcapi_cleanup,
+		.generate		= drbg_kcapi_generate,
+		.base.cra_exit		= drbg_kcapi_exit,
 	},
 };
 
 static int __init drbg_init(void)
 {
-- 
2.53.0

