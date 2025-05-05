Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D8E2701D5;
	Mon,  5 May 2025 20:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746477436; cv=none; b=XkDNVRSW4Rv+F3QuRNcR67tdVp+31ewtiInx0BPqKajVf2Urq6/kvgukVIpsfV+ux7o+rE9f6UPazK8wQ87XQmVcrzOos2A+JsUrQ05aY+DzZUuBK5lNivlYUarZk1rFfQwqyWXayoTAdHAAaIfJd5lzEDhkaaCOL1IxeNjHArg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746477436; c=relaxed/simple;
	bh=9nWIi+6i6x8RE1w7WFYRNj2dzIS3Y6HB+c31ckaf7GQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oU7QawzBTdACUYltrJV839z/oM03OyPbG8vr3W0RuTSwN0avdsjV+ZKOq1oTT/Q6DTHLNF56k13ar/myRYTOUT9ic2BW1rOArsCZMfVg0AwEi5CB/KY465N0apyPCW3pGSz/WgXBAsrhp4pxlZd2psNPiDW6OxCbn0XxClXBcVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oCcKG9YC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oCcKG9YC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F8EBC4CEF1;
	Mon,  5 May 2025 20:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746477436;
	bh=9nWIi+6i6x8RE1w7WFYRNj2dzIS3Y6HB+c31ckaf7GQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oCcKG9YCj+VWyavVnITRbLZFZuo+VpmH0i3gJ+dpV9a/BAbV0GqTDJWvHaDz1LBfy
	 f28mi0Q+OhWjdRSoNbZDby64saLVD5GN1fvjQG3t8UNEMzJC2Kd8VHbBGyftnI8x+O
	 83MKWJ1+ezVco+Lb00t5r3XJ2G1pQT+7wzFQUxsn7eLYv5R5n/ROgBr2z7Qp7mVYuR
	 oeRvOlRADlMxej2Cek3SrqEPSDz4sb85eVIRqa05BD7TTYu+vFqr1UrgQDVN4mXEwK
	 TbhsemDO706GmwH2NEzJ470P1zCyH2vxDnms+bE2UpCzDRqN575lheUXLbifh8t3vW
	 M+/ZFwDELz8TA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/7] crypto: testmgr - make it easier to enable the full set of tests
Date: Mon,  5 May 2025 13:33:42 -0700
Message-ID: <20250505203345.802740-5-ebiggers@kernel.org>
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
index 8f1353bbba18..bbe9cc408927 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -184,20 +184,10 @@ config CRYPTO_SELFTESTS
 
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
index 3a624c9b5525..a6707cda8328 100644
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
@@ -5758,13 +5707,12 @@ static void alg_check_testvec_configs(void)
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
index f56049bd1660..7e7f1ac3b7fd 100644
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
index 842fcef16e4d..a2aca61fb42e 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -57,9 +57,9 @@ libsha256-y					:= sha256.o
 obj-$(CONFIG_CRYPTO_LIB_SHA256_GENERIC)		+= libsha256-generic.o
 libsha256-generic-y				:= sha256-generic.o
 
 obj-$(CONFIG_MPILIB) += mpi/
 
-obj-$(CONFIG_CRYPTO_MANAGER_EXTRA_TESTS)	+= simd.o
+obj-$(CONFIG_CRYPTO_SELFTESTS)			+= simd.o
 
 obj-$(CONFIG_CRYPTO_LIB_SM3)			+= libsm3.o
 libsm3-y					:= sm3.o
-- 
2.49.0

