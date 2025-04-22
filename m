Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B1F28FFFA;
	Tue, 22 Apr 2025 15:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745335336; cv=none; b=PgSVSqiUkh0tzt20gIuIRMpvV571wHv7677LPLddr7Ulm/emmXKGnaLsh1y1TmiU1iMpmNbO6poj2/fh2bn/XCkNUktwF7vNE8bWI4kpn0EObXHN9xIVwVLCKFTquFVIX6mSRAn8eY2D2Rb41sGMygkpHXCNNKCF8yauu199lws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745335336; c=relaxed/simple;
	bh=GGSO1yYbdIWtIwnAfQJZknbPvq35AGmLMGTT02gokeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UwKyDond6iG3gfQ5xV2iEWRDakLCEDo8371nAvkgWHKl9sveFusI9edgTgm4cqlI+pMNmOm8L2wZiOvuXCQXh4XOAgP55I7yaD5PuSztz2l8iWPpbglBjiFB+RXeubspzGgOZrch6q0UZRMrixwqoM3vAxnH+z+g2LD3+OYNL94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q0RWd2tn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q0RWd2tn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D84DC4CEF5;
	Tue, 22 Apr 2025 15:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745335336;
	bh=GGSO1yYbdIWtIwnAfQJZknbPvq35AGmLMGTT02gokeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q0RWd2tnVNyKgSpDcwIdBsIVdDPHVSQpl3aATHxIrb34N9oMBG2HpqFHA223Kc8kn
	 wKpmcOrjhMTRrMmo3sWvEydbZ+4eMgG2StMQGZdCTexTbJeV1+xQe529+v3sN07h0F
	 UPGOwEoaHU01GM4e2b2HGaFLQPxeKczRjPwUb+2dbfG4Umi4b+sJV7Fw1tKARltWtl
	 JhiJONT8rEdSlMJxL2ONlvLRlEDa9CXyzto9VscUEqaftlk315a+UKmE7mPjP3jg7c
	 vfHF0c3hv+M9GTSfjnI8AURuZR6PYrgJUA1viReyAD2nLhji9SYE2mZtLTA+YaGfvV
	 4orB/JKMpaXYg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2 6/9] crypto: testmgr - make it easier to enable the full set of tests
Date: Tue, 22 Apr 2025 08:21:48 -0700
Message-ID: <20250422152151.3691-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250422152151.3691-1-ebiggers@kernel.org>
References: <20250422152151.3691-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Currently the full set of crypto self-tests requires
CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y.  This is problematic in two ways.
First, developers regularly overlook this option.  Second, the
description of the tests as "extra" sometimes gives the impression that
it is not required that all algorithms pass these tests.

Given that the main use case for the crypto self-tests is for
developers, make enabling CONFIG_CRYPTO_SELFTESTS=y just enable the full
set of crypto self-tests by default.

The slow tests can still be disabled by adding the command-line
parameter cryptomgr.noextratests=1, soon to be renamed to
cryptomgr.noslowtests=1.  The only known use case for doing this is for
people trying to use the crypto self-tests to satisfy the FIPS 140-3
pre-operational self-testing requirements when the kernel is being
validated as a FIPS 140-3 cryptographic module.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/Kconfig                 | 10 ------
 crypto/testmgr.c               | 62 +++-------------------------------
 include/crypto/internal/simd.h |  6 ++--
 lib/crypto/Makefile            |  2 +-
 4 files changed, 8 insertions(+), 72 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 8bac10e4c1cc1..538a874262fc5 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -183,20 +183,10 @@ config CRYPTO_SELFTESTS
 
 	  This is primarily intended for developer use.  It should not be
 	  enabled in production kernels, unless you are trying to use these
 	  tests to fulfill a FIPS testing requirement.
 
-config CRYPTO_MANAGER_EXTRA_TESTS
-	bool "Enable extra run-time crypto self tests"
-	depends on DEBUG_KERNEL && CRYPTO_SELFTESTS && CRYPTO_MANAGER
-	help
-	  Enable extra run-time self tests of registered crypto algorithms,
-	  including randomized fuzz tests.
-
-	  This is intended for developer use only, as these tests take much
-	  longer to run than the normal self tests.
-
 config CRYPTO_NULL
 	tristate "Null algorithms"
 	select CRYPTO_NULL2
 	help
 	  These are 'Null' algorithms, used by IPsec, which do nothing.
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 1b2f7a4724d8d..a02cb7f828673 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -43,19 +43,17 @@ MODULE_IMPORT_NS("CRYPTO_INTERNAL");
 
 static bool notests;
 module_param(notests, bool, 0644);
 MODULE_PARM_DESC(notests, "disable crypto self-tests");
 
-#ifdef CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
 static bool noextratests;
 module_param(noextratests, bool, 0644);
 MODULE_PARM_DESC(noextratests, "disable expensive crypto self-tests");
 
 static unsigned int fuzz_iterations = 100;
 module_param(fuzz_iterations, uint, 0644);
 MODULE_PARM_DESC(fuzz_iterations, "number of fuzz test iterations");
-#endif
 
 #ifndef CONFIG_CRYPTO_SELFTESTS
 
 /* a perfect nop */
 int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
@@ -319,14 +317,13 @@ struct testvec_config {
 
 #define TESTVEC_CONFIG_NAMELEN	192
 
 /*
  * The following are the lists of testvec_configs to test for each algorithm
- * type when the basic crypto self-tests are enabled.  They aim to provide good
- * test coverage, while keeping the test time much shorter than the full fuzz
- * tests so that the basic tests can be enabled in a wider range of
- * circumstances.
+ * type when the fast crypto self-tests are enabled.  They aim to provide good
+ * test coverage, while keeping the test time much shorter than the full tests
+ * so that the fast tests can be used to fulfill FIPS 140 testing requirements.
  */
 
 /* Configs for skciphers and aeads */
 static const struct testvec_config default_cipher_testvec_configs[] = {
 	{
@@ -871,12 +868,10 @@ static int prepare_keybuf(const u8 *key, unsigned int ksize,
 		kfree(keybuf);						\
 	}								\
 	err;								\
 })
 
-#ifdef CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
-
 /*
  * The fuzz tests use prandom instead of the normal Linux RNG since they don't
  * need cryptographically secure random numbers.  This greatly improves the
  * performance of these tests, especially if they are run before the Linux RNG
  * has been initialized or if they are run on a lockdep-enabled kernel.
@@ -1237,19 +1232,10 @@ static int build_generic_driver_name(const char *algname,
 too_long:
 	pr_err("alg: generic driver name for \"%s\" would be too long\n",
 	       algname);
 	return -ENAMETOOLONG;
 }
-#else /* !CONFIG_CRYPTO_MANAGER_EXTRA_TESTS */
-static void crypto_disable_simd_for_test(void)
-{
-}
-
-static void crypto_reenable_simd_for_test(void)
-{
-}
-#endif /* !CONFIG_CRYPTO_MANAGER_EXTRA_TESTS */
 
 static int build_hash_sglist(struct test_sglist *tsgl,
 			     const struct hash_testvec *vec,
 			     const struct testvec_config *cfg,
 			     unsigned int alignmask,
@@ -1686,11 +1672,10 @@ static int test_hash_vec(const struct hash_testvec *vec, unsigned int vec_num,
 					req, desc, tsgl, hashstate);
 		if (err)
 			return err;
 	}
 
-#ifdef CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
 	if (!noextratests) {
 		struct rnd_state rng;
 		struct testvec_config cfg;
 		char cfgname[TESTVEC_CONFIG_NAMELEN];
 
@@ -1704,15 +1689,13 @@ static int test_hash_vec(const struct hash_testvec *vec, unsigned int vec_num,
 			if (err)
 				return err;
 			cond_resched();
 		}
 	}
-#endif
 	return 0;
 }
 
-#ifdef CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
 /*
  * Generate a hash test vector from the given implementation.
  * Assumes the buffers in 'vec' were already allocated.
  */
 static void generate_random_hash_testvec(struct rnd_state *rng,
@@ -1874,21 +1857,10 @@ static int test_hash_vs_generic_impl(const char *generic_driver,
 	kfree(vec.digest);
 	crypto_free_shash(generic_tfm);
 	kfree_sensitive(generic_desc);
 	return err;
 }
-#else /* !CONFIG_CRYPTO_MANAGER_EXTRA_TESTS */
-static int test_hash_vs_generic_impl(const char *generic_driver,
-				     unsigned int maxkeysize,
-				     struct ahash_request *req,
-				     struct shash_desc *desc,
-				     struct test_sglist *tsgl,
-				     u8 *hashstate)
-{
-	return 0;
-}
-#endif /* !CONFIG_CRYPTO_MANAGER_EXTRA_TESTS */
 
 static int alloc_shash(const char *driver, u32 type, u32 mask,
 		       struct crypto_shash **tfm_ret,
 		       struct shash_desc **desc_ret)
 {
@@ -2258,11 +2230,10 @@ static int test_aead_vec(int enc, const struct aead_testvec *vec,
 					req, tsgls);
 		if (err)
 			return err;
 	}
 
-#ifdef CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
 	if (!noextratests) {
 		struct rnd_state rng;
 		struct testvec_config cfg;
 		char cfgname[TESTVEC_CONFIG_NAMELEN];
 
@@ -2276,16 +2247,13 @@ static int test_aead_vec(int enc, const struct aead_testvec *vec,
 			if (err)
 				return err;
 			cond_resched();
 		}
 	}
-#endif
 	return 0;
 }
 
-#ifdef CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
-
 struct aead_extra_tests_ctx {
 	struct rnd_state rng;
 	struct aead_request *req;
 	struct crypto_aead *tfm;
 	const struct alg_test_desc *test_desc;
@@ -2666,18 +2634,10 @@ static int test_aead_extra(const struct alg_test_desc *test_desc,
 	kfree(ctx->vec.ptext);
 	kfree(ctx->vec.ctext);
 	kfree(ctx);
 	return err;
 }
-#else /* !CONFIG_CRYPTO_MANAGER_EXTRA_TESTS */
-static int test_aead_extra(const struct alg_test_desc *test_desc,
-			   struct aead_request *req,
-			   struct cipher_test_sglists *tsgls)
-{
-	return 0;
-}
-#endif /* !CONFIG_CRYPTO_MANAGER_EXTRA_TESTS */
 
 static int test_aead(int enc, const struct aead_test_suite *suite,
 		     struct aead_request *req,
 		     struct cipher_test_sglists *tsgls)
 {
@@ -3013,11 +2973,10 @@ static int test_skcipher_vec(int enc, const struct cipher_testvec *vec,
 					    req, tsgls);
 		if (err)
 			return err;
 	}
 
-#ifdef CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
 	if (!noextratests) {
 		struct rnd_state rng;
 		struct testvec_config cfg;
 		char cfgname[TESTVEC_CONFIG_NAMELEN];
 
@@ -3031,15 +2990,13 @@ static int test_skcipher_vec(int enc, const struct cipher_testvec *vec,
 			if (err)
 				return err;
 			cond_resched();
 		}
 	}
-#endif
 	return 0;
 }
 
-#ifdef CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
 /*
  * Generate a symmetric cipher test vector from the given implementation.
  * Assumes the buffers in 'vec' were already allocated.
  */
 static void generate_random_cipher_testvec(struct rnd_state *rng,
@@ -3234,18 +3191,10 @@ static int test_skcipher_vs_generic_impl(const char *generic_driver,
 	kfree(vec.ctext);
 	crypto_free_skcipher(generic_tfm);
 	skcipher_request_free(generic_req);
 	return err;
 }
-#else /* !CONFIG_CRYPTO_MANAGER_EXTRA_TESTS */
-static int test_skcipher_vs_generic_impl(const char *generic_driver,
-					 struct skcipher_request *req,
-					 struct cipher_test_sglists *tsgls)
-{
-	return 0;
-}
-#endif /* !CONFIG_CRYPTO_MANAGER_EXTRA_TESTS */
 
 static int test_skcipher(int enc, const struct cipher_test_suite *suite,
 			 struct skcipher_request *req,
 			 struct cipher_test_sglists *tsgls)
 {
@@ -5764,13 +5713,12 @@ static void alg_check_testvec_configs(void)
 static void testmgr_onetime_init(void)
 {
 	alg_check_test_descs_order();
 	alg_check_testvec_configs();
 
-#ifdef CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
-	pr_warn("alg: extra crypto tests enabled.  This is intended for developer use only.\n");
-#endif
+	if (!noextratests)
+		pr_warn("alg: full crypto tests enabled.  This is intended for developer use only.\n");
 }
 
 static int alg_find_test(const char *alg)
 {
 	int start = 0;
diff --git a/include/crypto/internal/simd.h b/include/crypto/internal/simd.h
index f56049bd1660d..7e7f1ac3b7fda 100644
--- a/include/crypto/internal/simd.h
+++ b/include/crypto/internal/simd.h
@@ -42,15 +42,13 @@ void simd_unregister_aeads(struct aead_alg *algs, int count,
  * crypto_simd_usable() - is it allowed at this time to use SIMD instructions or
  *			  access the SIMD register file?
  *
  * This delegates to may_use_simd(), except that this also returns false if SIMD
  * in crypto code has been temporarily disabled on this CPU by the crypto
- * self-tests, in order to test the no-SIMD fallback code.  This override is
- * currently limited to configurations where the extra self-tests are enabled,
- * because it might be a bit too invasive to be part of the regular self-tests.
+ * self-tests, in order to test the no-SIMD fallback code.
  */
-#ifdef CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
+#ifdef CONFIG_CRYPTO_SELFTESTS
 DECLARE_PER_CPU(bool, crypto_simd_disabled_for_test);
 #define crypto_simd_usable() \
 	(may_use_simd() && !this_cpu_read(crypto_simd_disabled_for_test))
 #else
 #define crypto_simd_usable() may_use_simd()
diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index 8e8cfbc9051fa..e20b038adb1ad 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -54,9 +54,9 @@ libsha1-y					:= sha1.o
 obj-$(CONFIG_CRYPTO_LIB_SHA256)			+= libsha256.o
 libsha256-y					:= sha256.o
 
 obj-$(CONFIG_MPILIB) += mpi/
 
-obj-$(CONFIG_CRYPTO_MANAGER_EXTRA_TESTS)	+= simd.o
+obj-$(CONFIG_CRYPTO_SELFTESTS)			+= simd.o
 
 obj-$(CONFIG_CRYPTO_LIB_SM3)			+= libsm3.o
 libsm3-y					:= sm3.o
-- 
2.49.0

