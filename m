Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DF92701D7;
	Mon,  5 May 2025 20:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746477436; cv=none; b=rB4pSK45QEg53bIXdwHCzVwQ7lSD2QYRRKFBpZ38oA8FnwmpwqgIPKeOdgruYFeIyQNpbV1GKpIAoNBn7/etOPQsFplvaqcIuLBYF1WmRKWAPKjyAENQRwj2tvhvvb+spKNRfiZXyD2ZP/kR5UY0pnxxe1nEAexDsQB9deM7Dxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746477436; c=relaxed/simple;
	bh=sZJXduD5Swr1H+smumPscoQKH6AGaXCzOQJ3PgpB5kQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XPh13LpwTkh4QeUQCve/rdqMlYBzSTEy1ssfwllzrqSDjxvIDxp1mhRYzIrLTgUDjUXTOPUyCZBFx0DG86WnTsNCbWg5qmQrmRAlzGLBKT6VfoFklsvVsBEvBWLoLdkd7BFYYf/IrW9lJiAl2D3gi4iRS2REpmshxMIAIyk1arI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F16rXTKp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F16rXTKp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547C9C4CEE4;
	Mon,  5 May 2025 20:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746477436;
	bh=sZJXduD5Swr1H+smumPscoQKH6AGaXCzOQJ3PgpB5kQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F16rXTKpgp5ndwUumEaFEudvDlQO2uuz7wNanTX+mQ9iSV0npsVu5OWfybjOPqKi7
	 X5YKwVqALQ1GImOqOy73znfAsqFV+SriAfKHkgGzFiHikNeTkQixuACyS884HeFZfC
	 ZQ4J5VaEO8g4UsTD4otxr4Plpt2guhI11SaTIYl4cPb1poSWfq0oZ8W752T3p4DRfD
	 rUNLW7NQNd54fZHUzD4ArrNeISy0Wk3ie7Y7tiKUe504E9Zn9oIJf8BDxVUDPcY4g0
	 ktDzuFMltgb4ZP2TFp6Ycbw1SvDF5IzkUgYuM/tdby6MjGSFGl0QordmwbwRV+hU7U
	 mcAceHfD3L05g==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v3 5/7] crypto: testmgr - rename noextratests to noslowtests
Date: Mon,  5 May 2025 13:33:43 -0700
Message-ID: <20250505203345.802740-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250505203345.802740-1-ebiggers@kernel.org>
References: <20250505203345.802740-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Rename the noextratests module parameter to noslowtests, and replace
other remaining mentions of "extra" in the code with "slow".  This
addresses confusion regarding the word "extra" like that seen at
https://lore.kernel.org/r/6cecf2de-9aa0-f6ea-0c2d-8e974a1a820b@huawei.com/.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.c | 41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index a6707cda8328..fc28000c27f5 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -41,15 +41,15 @@
 
 MODULE_IMPORT_NS("CRYPTO_INTERNAL");
 
 static bool notests;
 module_param(notests, bool, 0644);
-MODULE_PARM_DESC(notests, "disable crypto self-tests");
+MODULE_PARM_DESC(notests, "disable all crypto self-tests");
 
-static bool noextratests;
-module_param(noextratests, bool, 0644);
-MODULE_PARM_DESC(noextratests, "disable expensive crypto self-tests");
+static bool noslowtests;
+module_param(noslowtests, bool, 0644);
+MODULE_PARM_DESC(noslowtests, "disable slow crypto self-tests");
 
 static unsigned int fuzz_iterations = 100;
 module_param(fuzz_iterations, uint, 0644);
 MODULE_PARM_DESC(fuzz_iterations, "number of fuzz test iterations");
 
@@ -1672,11 +1672,11 @@ static int test_hash_vec(const struct hash_testvec *vec, unsigned int vec_num,
 					req, desc, tsgl, hashstate);
 		if (err)
 			return err;
 	}
 
-	if (!noextratests) {
+	if (!noslowtests) {
 		struct rnd_state rng;
 		struct testvec_config cfg;
 		char cfgname[TESTVEC_CONFIG_NAMELEN];
 
 		init_rnd_state(&rng);
@@ -1762,11 +1762,11 @@ static int test_hash_vs_generic_impl(const char *generic_driver,
 	char vec_name[64];
 	struct testvec_config *cfg;
 	char cfgname[TESTVEC_CONFIG_NAMELEN];
 	int err;
 
-	if (noextratests)
+	if (noslowtests)
 		return 0;
 
 	init_rnd_state(&rng);
 
 	if (!generic_driver) { /* Use default naming convention? */
@@ -2230,11 +2230,11 @@ static int test_aead_vec(int enc, const struct aead_testvec *vec,
 					req, tsgls);
 		if (err)
 			return err;
 	}
 
-	if (!noextratests) {
+	if (!noslowtests) {
 		struct rnd_state rng;
 		struct testvec_config cfg;
 		char cfgname[TESTVEC_CONFIG_NAMELEN];
 
 		init_rnd_state(&rng);
@@ -2250,11 +2250,11 @@ static int test_aead_vec(int enc, const struct aead_testvec *vec,
 		}
 	}
 	return 0;
 }
 
-struct aead_extra_tests_ctx {
+struct aead_slow_tests_ctx {
 	struct rnd_state rng;
 	struct aead_request *req;
 	struct crypto_aead *tfm;
 	const struct alg_test_desc *test_desc;
 	struct cipher_test_sglists *tsgls;
@@ -2425,12 +2425,11 @@ static void generate_random_aead_testvec(struct rnd_state *rng,
 	snprintf(name, max_namelen,
 		 "\"random: alen=%u plen=%u authsize=%u klen=%u novrfy=%d\"",
 		 vec->alen, vec->plen, authsize, vec->klen, vec->novrfy);
 }
 
-static void try_to_generate_inauthentic_testvec(
-					struct aead_extra_tests_ctx *ctx)
+static void try_to_generate_inauthentic_testvec(struct aead_slow_tests_ctx *ctx)
 {
 	int i;
 
 	for (i = 0; i < 10; i++) {
 		generate_random_aead_testvec(&ctx->rng, ctx->req, &ctx->vec,
@@ -2445,11 +2444,11 @@ static void try_to_generate_inauthentic_testvec(
 
 /*
  * Generate inauthentic test vectors (i.e. ciphertext, AAD pairs that aren't the
  * result of an encryption with the key) and verify that decryption fails.
  */
-static int test_aead_inauthentic_inputs(struct aead_extra_tests_ctx *ctx)
+static int test_aead_inauthentic_inputs(struct aead_slow_tests_ctx *ctx)
 {
 	unsigned int i;
 	int err;
 
 	for (i = 0; i < fuzz_iterations * 8; i++) {
@@ -2480,11 +2479,11 @@ static int test_aead_inauthentic_inputs(struct aead_extra_tests_ctx *ctx)
 
 /*
  * Test the AEAD algorithm against the corresponding generic implementation, if
  * one is available.
  */
-static int test_aead_vs_generic_impl(struct aead_extra_tests_ctx *ctx)
+static int test_aead_vs_generic_impl(struct aead_slow_tests_ctx *ctx)
 {
 	struct crypto_aead *tfm = ctx->tfm;
 	const char *algname = crypto_aead_alg(tfm)->base.cra_name;
 	const char *driver = crypto_aead_driver_name(tfm);
 	const char *generic_driver = ctx->test_desc->generic_driver;
@@ -2584,19 +2583,19 @@ static int test_aead_vs_generic_impl(struct aead_extra_tests_ctx *ctx)
 	crypto_free_aead(generic_tfm);
 	aead_request_free(generic_req);
 	return err;
 }
 
-static int test_aead_extra(const struct alg_test_desc *test_desc,
-			   struct aead_request *req,
-			   struct cipher_test_sglists *tsgls)
+static int test_aead_slow(const struct alg_test_desc *test_desc,
+			  struct aead_request *req,
+			  struct cipher_test_sglists *tsgls)
 {
-	struct aead_extra_tests_ctx *ctx;
+	struct aead_slow_tests_ctx *ctx;
 	unsigned int i;
 	int err;
 
-	if (noextratests)
+	if (noslowtests)
 		return 0;
 
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
@@ -2699,11 +2698,11 @@ static int alg_test_aead(const struct alg_test_desc *desc, const char *driver,
 
 	err = test_aead(DECRYPT, suite, req, tsgls);
 	if (err)
 		goto out;
 
-	err = test_aead_extra(desc, req, tsgls);
+	err = test_aead_slow(desc, req, tsgls);
 out:
 	free_cipher_test_sglists(tsgls);
 	aead_request_free(req);
 	crypto_free_aead(tfm);
 	return err;
@@ -2973,11 +2972,11 @@ static int test_skcipher_vec(int enc, const struct cipher_testvec *vec,
 					    req, tsgls);
 		if (err)
 			return err;
 	}
 
-	if (!noextratests) {
+	if (!noslowtests) {
 		struct rnd_state rng;
 		struct testvec_config cfg;
 		char cfgname[TESTVEC_CONFIG_NAMELEN];
 
 		init_rnd_state(&rng);
@@ -3075,11 +3074,11 @@ static int test_skcipher_vs_generic_impl(const char *generic_driver,
 	char vec_name[64];
 	struct testvec_config *cfg;
 	char cfgname[TESTVEC_CONFIG_NAMELEN];
 	int err;
 
-	if (noextratests)
+	if (noslowtests)
 		return 0;
 
 	init_rnd_state(&rng);
 
 	if (!generic_driver) { /* Use default naming convention? */
@@ -5707,11 +5706,11 @@ static void alg_check_testvec_configs(void)
 static void testmgr_onetime_init(void)
 {
 	alg_check_test_descs_order();
 	alg_check_testvec_configs();
 
-	if (!noextratests)
+	if (!noslowtests)
 		pr_warn("alg: full crypto tests enabled.  This is intended for developer use only.\n");
 }
 
 static int alg_find_test(const char *alg)
 {
-- 
2.49.0

