Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFAD38F235;
	Mon, 20 Apr 2026 06:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776667029; cv=none; b=nx1uDLkykq3KKQOAf3JUuDuIGtdWfoRHrx78XXRYsPzR6NrQ2s+rozEQ/oHTerqCiEZkErnUK8hmHrak6z6+GTrRYEvzKDbIGG2V1gBl4a2j0Qq/w8FeBIXgKtk4V5mGOCItOnt62AYNg1kghtzN+w9DMXRev5pZsKHvsh319d4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776667029; c=relaxed/simple;
	bh=x4wTvOQdhlb6ypu8vKFrA0r6CQUf0ioTn5AGfIqle2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AQFRsoZu+iLBvtc06CeiLQp1j3alovGkpJltuqI63P8ZKL2lQ+NpGJOetUBcQdti96eHXZ/PpSMb7PfS0kzSeCXf4xMTMkxD3YQOnlcsxhmcI7z7gX/whLFUEkmWkuxJwFKB/zQ8lJSUJXpmtzLzFiL2vAWhH983F5952h7YcP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RhryhPQQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RhryhPQQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B5E9C2BCB3;
	Mon, 20 Apr 2026 06:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776667028;
	bh=x4wTvOQdhlb6ypu8vKFrA0r6CQUf0ioTn5AGfIqle2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RhryhPQQJ6t2v6VmjVxhhQT6mJ9EDg+0ERhQHQuoY5cmdJOx043hQ9mTQShC5lRFM
	 nA8ysQ9DAglZdU0V4i8akcIadVHu/8ETxGNHOFg9/gXZgLLV5vJUg6N04tkI83fl4N
	 P/1e5PdBAoSY1DuYFhPXc+vPXWaSsFhuCsyD8AjZ17l0H/Cwe7Ynb+inyZv+CO1bse
	 ZWnNMVuI3Eo4F8mLZKcS9Lc4MeK1OUKsTqOMTPYpguejLaDCZSExNF90ZEs33njkuA
	 RpCBdRHsSRpck0/xDXt5NPD6tqKoiGiJH3yJ+5MkpaDNp8JunrUO9eWFACSt3aPTPa
	 5LfvHdd+FvhMA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 30/38] crypto: drbg - Fold drbg_instantiate() into drbg_kcapi_seed()
Date: Sun, 19 Apr 2026 23:34:14 -0700
Message-ID: <20260420063422.324906-31-ebiggers@kernel.org>
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

Fold drbg_instantiate() into its only caller.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/drbg.c | 107 ++++++++++++++++++++------------------------------
 1 file changed, 43 insertions(+), 64 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index ef9c3e9fdf6e..763c14e3786c 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -524,27 +524,60 @@ static int drbg_prepare_hrng(struct drbg_state *drbg)
 
 	return 0;
 }
 
 /*
- * DRBG instantiation function as required by SP800-90A - this function
- * sets up the DRBG handle, performs the initial seeding and all sanity
- * checks required by SP800-90A
+ * DRBG uninstantiate function as required by SP800-90A - this function
+ * frees all buffers and the DRBG handle
  *
- * @drbg memory of state -- if NULL, new memory is allocated
- * @pers Optional personalization string that is mixed into state
- * @pers_len Length of personalization string in bytes, may be 0
- * @pr prediction resistance enabled
+ * @drbg DRBG state handle
  *
  * return
  *	0 on success
- *	error value otherwise
  */
-static int drbg_instantiate(struct drbg_state *drbg,
-			    const u8 *pers, size_t pers_len, bool pr)
+static int drbg_uninstantiate(struct drbg_state *drbg)
+{
+	if (!IS_ERR_OR_NULL(drbg->jent))
+		crypto_free_rng(drbg->jent);
+	drbg->jent = NULL;
+
+	drbg_dealloc_state(drbg);
+	/* no scrubbing of test_data -- this shall survive an uninstantiate */
+	return 0;
+}
+
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
+static void drbg_kcapi_set_entropy(struct crypto_rng *tfm,
+				   const u8 *data, unsigned int len)
+{
+	struct drbg_state *drbg = crypto_rng_ctx(tfm);
+
+	mutex_lock(&drbg->drbg_mutex);
+	drbg->test_entropy = data;
+	drbg->test_entropylen = len;
+	mutex_unlock(&drbg->drbg_mutex);
+}
+
+/* Seed (i.e. instantiate) or re-seed the DRBG. */
+static int drbg_kcapi_seed(struct crypto_rng *tfm,
+			   const u8 *pers, size_t pers_len, bool pr)
 {
 	static const u8 initial_key[DRBG_STATE_LEN]; /* all zeroes */
+	struct drbg_state *drbg = crypto_rng_ctx(tfm);
 	int ret;
 	bool reseed = true;
 
 	pr_devel("DRBG: Initializing DRBG with prediction resistance %s\n",
 		 str_enabled_disabled(pr));
@@ -587,64 +620,10 @@ static int drbg_instantiate(struct drbg_state *drbg,
 	mutex_unlock(&drbg->drbg_mutex);
 	drbg_uninstantiate(drbg);
 	return ret;
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
-/***************************************************************
- * Kernel crypto API interface to DRBG
- ***************************************************************/
-
-static int drbg_kcapi_init(struct crypto_tfm *tfm)
-{
-	struct drbg_state *drbg = crypto_tfm_ctx(tfm);
-
-	mutex_init(&drbg->drbg_mutex);
-
-	return 0;
-}
-
-/* Set test entropy in the DRBG. */
-static void drbg_kcapi_set_entropy(struct crypto_rng *tfm,
-				   const u8 *data, unsigned int len)
-{
-	struct drbg_state *drbg = crypto_rng_ctx(tfm);
-
-	mutex_lock(&drbg->drbg_mutex);
-	drbg->test_entropy = data;
-	drbg->test_entropylen = len;
-	mutex_unlock(&drbg->drbg_mutex);
-}
-
-/* Seed (i.e. instantiate) or re-seed the DRBG. */
-static int drbg_kcapi_seed(struct crypto_rng *tfm,
-			   const u8 *seed, unsigned int slen, bool pr)
-{
-	struct drbg_state *drbg = crypto_rng_ctx(tfm);
-
-	return drbg_instantiate(drbg, seed, slen, pr);
-}
-
 static int drbg_kcapi_seed_pr(struct crypto_rng *tfm,
 			      const u8 *seed, unsigned int slen)
 {
 	return drbg_kcapi_seed(tfm, seed, slen, /* pr= */ true);
 }
-- 
2.53.0

