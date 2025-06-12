Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4922D1EF09B;
	Thu, 12 Jun 2025 17:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749750560; cv=none; b=LjTDDs31srPQilS5XWMMkm40jAq6tuu09h7tWkpsYXXKmTwGgR3rTOsu/zLc046XDD/47V7uGvnK2fdhZEBGvY904aza8zeUqOHfHcbpxQ0B7jEtBm5kLlQBUicG2mVIRna5le4yPUgJ/5f5pZLUBIFgsNwkRJX+hJ3+S/R05Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749750560; c=relaxed/simple;
	bh=1C7tbX5h16fULDRXLA8bSbeAAQenS0PW4YgZFWKcptM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kbfBQXYSGsMYzzSJ/upiATr5RSCZCkofhbFoaIX7VVEUWmaKUpMyB6sxLoCT/MOeB9CDUuSjQT4947c+JjvWBWqu4cD9l0VqPHsZJpkEU/TJmBK0HiGEI2w+XuYe9NxDtic9graWeayvEWR/nEqQAf+xkxaBwwJxskYhcXNTX4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FvnqO/0c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FvnqO/0c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A99DC4CEEE;
	Thu, 12 Jun 2025 17:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749750558;
	bh=1C7tbX5h16fULDRXLA8bSbeAAQenS0PW4YgZFWKcptM=;
	h=From:To:Cc:Subject:Date:From;
	b=FvnqO/0ckWWd3kabT8BqxJlAlUkI3uT0MFB1MlSAyTWgVNr0QvlMcBXp2H2gm7dKF
	 dePP80Puz6FVpAPE/k/NTn8alB3u7LMf1C+M/yMneOrI30Y4E3h0e7uenHDw1NVc6t
	 2LgHXS1muKFbshLNQOkKUuBUQQsTgebCOsSECgsV6gHeFe9DhCZDtxZnpR37EQhrqb
	 dmKL/2IX1pWRYeKP76/LcOCckbfj/ygceWOx+byzQAMeCyvb/v1ll+G3iEjtUochVS
	 Kyxq6B/qyHtym7RYcc5lk4GXbM516Mmx4jNhQG3qVW2NM4ahBdr2E/4wf03XRKYphT
	 8lJAn2qzfRAVQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Diederik de Haas <didi.debian@cknow.org>,
	Ingo Franzki <ifranzki@linux.ibm.com>
Subject: [PATCH v2] crypto: testmgr - reinstate kconfig control over full self-tests
Date: Thu, 12 Jun 2025 10:47:09 -0700
Message-ID: <20250612174709.26990-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Commit 698de822780f ("crypto: testmgr - make it easier to enable the
full set of tests") removed support for building kernels that run only
the "fast" set of crypto self-tests by default.  This assumed that
nearly everyone actually wanted the full set of tests, *if* they had
already chosen to enable the tests at all.

Unfortunately, it turns out that both Debian and Fedora intentionally
have the crypto self-tests enabled in their production kernels.  And for
production kernels we do need to keep the testing time down, which
implies just running the "fast" tests, not the full set of tests.

For Fedora, a reason for enabling the tests in production is that they
are being (mis)used to meet the FIPS 140-3 pre-operational testing
requirement.

However, the other reason for enabling the tests in production, which
applies to both distros, is that they provide some value in protecting
users from buggy drivers.  Unfortunately, the crypto/ subsystem has many
buggy and untested drivers for off-CPU hardware accelerators on rare
platforms.  These broken drivers get shipped to users, and there have
been multiple examples of the tests preventing these buggy drivers from
being used.  So effectively, the tests are being relied on in production
kernels.  I think this is kind of crazy (untested drivers should just
not be enabled at all), but that seems to be how things work currently.

Thus, reintroduce a kconfig option that controls the level of testing.
Call it CRYPTO_SELFTESTS_FULL instead of the original name
CRYPTO_MANAGER_EXTRA_TESTS, which was slightly misleading.

Moreover, given the "production kernel" use case, make CRYPTO_SELFTESTS
depend on EXPERT instead of DEBUG_KERNEL.

I also haven't reinstated all the #ifdefs in crypto/testmgr.c.  Instead,
just rely on the compiler to optimize out unused code.

Fixes: 40b9969796bf ("crypto: testmgr - replace CRYPTO_MANAGER_DISABLE_TESTS with CRYPTO_SELFTESTS")
Fixes: 698de822780f ("crypto: testmgr - make it easier to enable the full set of tests")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---

This patch is targeting the crypto tree for 6.16.

Changed in v2:
   - Made CRYPTO_SELFTESTS depend on EXPERT
   - Removed 'default y' from CRYPTO_SELFTESTS_FULL
   - Improved commit message

 crypto/Kconfig                 | 25 +++++++++++++++++++++----
 crypto/testmgr.c               | 15 ++++++++++++---
 include/crypto/internal/simd.h |  6 ++++--
 lib/crypto/Makefile            |  2 +-
 4 files changed, 38 insertions(+), 10 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index e9fee7818e270..e9a27043f5282 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -174,20 +174,37 @@ config CRYPTO_USER
 	  Userspace configuration for cryptographic instantiations such as
 	  cbc(aes).
 
 config CRYPTO_SELFTESTS
 	bool "Enable cryptographic self-tests"
-	depends on DEBUG_KERNEL
+	depends on EXPERT
 	help
 	  Enable the cryptographic self-tests.
 
 	  The cryptographic self-tests run at boot time, or at algorithm
 	  registration time if algorithms are dynamically loaded later.
 
-	  This is primarily intended for developer use.  It should not be
-	  enabled in production kernels, unless you are trying to use these
-	  tests to fulfill a FIPS testing requirement.
+	  There are two main use cases for these tests:
+
+	  - Development and pre-release testing.  In this case, also enable
+	    CRYPTO_SELFTESTS_FULL to get the full set of tests.  All crypto code
+	    in the kernel is expected to pass the full set of tests.
+
+	  - Production kernels, to help prevent buggy drivers from being used
+	    and/or meet FIPS 140-3 pre-operational testing requirements.  In
+	    this case, enable CRYPTO_SELFTESTS but not CRYPTO_SELFTESTS_FULL.
+
+config CRYPTO_SELFTESTS_FULL
+	bool "Enable the full set of cryptographic self-tests"
+	depends on CRYPTO_SELFTESTS
+	help
+	  Enable the full set of cryptographic self-tests for each algorithm.
+
+	  The full set of tests should be enabled for development and
+	  pre-release testing, but not in production kernels.
+
+	  All crypto code in the kernel is expected to pass the full tests.
 
 config CRYPTO_NULL
 	tristate "Null algorithms"
 	select CRYPTO_ALGAPI
 	select CRYPTO_SKCIPHER
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 72005074a5c26..32f753d6c4302 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -43,17 +43,22 @@ MODULE_IMPORT_NS("CRYPTO_INTERNAL");
 
 static bool notests;
 module_param(notests, bool, 0644);
 MODULE_PARM_DESC(notests, "disable all crypto self-tests");
 
+#ifdef CONFIG_CRYPTO_SELFTESTS_FULL
 static bool noslowtests;
 module_param(noslowtests, bool, 0644);
 MODULE_PARM_DESC(noslowtests, "disable slow crypto self-tests");
 
 static unsigned int fuzz_iterations = 100;
 module_param(fuzz_iterations, uint, 0644);
 MODULE_PARM_DESC(fuzz_iterations, "number of fuzz test iterations");
+#else
+#define noslowtests 1
+#define fuzz_iterations 0
+#endif
 
 #ifndef CONFIG_CRYPTO_SELFTESTS
 
 /* a perfect nop */
 int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
@@ -317,13 +322,13 @@ struct testvec_config {
 
 #define TESTVEC_CONFIG_NAMELEN	192
 
 /*
  * The following are the lists of testvec_configs to test for each algorithm
- * type when the fast crypto self-tests are enabled.  They aim to provide good
- * test coverage, while keeping the test time much shorter than the full tests
- * so that the fast tests can be used to fulfill FIPS 140 testing requirements.
+ * type when the "fast" crypto self-tests are enabled.  They aim to provide good
+ * test coverage, while keeping the test time much shorter than the "full" tests
+ * so that the "fast" tests can be enabled in a wider range of circumstances.
  */
 
 /* Configs for skciphers and aeads */
 static const struct testvec_config default_cipher_testvec_configs[] = {
 	{
@@ -1181,18 +1186,22 @@ static void generate_random_testvec_config(struct rnd_state *rng,
 	WARN_ON_ONCE(!valid_testvec_config(cfg));
 }
 
 static void crypto_disable_simd_for_test(void)
 {
+#ifdef CONFIG_CRYPTO_SELFTESTS_FULL
 	migrate_disable();
 	__this_cpu_write(crypto_simd_disabled_for_test, true);
+#endif
 }
 
 static void crypto_reenable_simd_for_test(void)
 {
+#ifdef CONFIG_CRYPTO_SELFTESTS_FULL
 	__this_cpu_write(crypto_simd_disabled_for_test, false);
 	migrate_enable();
+#endif
 }
 
 /*
  * Given an algorithm name, build the name of the generic implementation of that
  * algorithm, assuming the usual naming convention.  Specifically, this appends
diff --git a/include/crypto/internal/simd.h b/include/crypto/internal/simd.h
index 7e7f1ac3b7fda..9e338e7aafbd9 100644
--- a/include/crypto/internal/simd.h
+++ b/include/crypto/internal/simd.h
@@ -42,13 +42,15 @@ void simd_unregister_aeads(struct aead_alg *algs, int count,
  * crypto_simd_usable() - is it allowed at this time to use SIMD instructions or
  *			  access the SIMD register file?
  *
  * This delegates to may_use_simd(), except that this also returns false if SIMD
  * in crypto code has been temporarily disabled on this CPU by the crypto
- * self-tests, in order to test the no-SIMD fallback code.
+ * self-tests, in order to test the no-SIMD fallback code.  This override is
+ * currently limited to configurations where the "full" self-tests are enabled,
+ * because it might be a bit too invasive to be part of the "fast" self-tests.
  */
-#ifdef CONFIG_CRYPTO_SELFTESTS
+#ifdef CONFIG_CRYPTO_SELFTESTS_FULL
 DECLARE_PER_CPU(bool, crypto_simd_disabled_for_test);
 #define crypto_simd_usable() \
 	(may_use_simd() && !this_cpu_read(crypto_simd_disabled_for_test))
 #else
 #define crypto_simd_usable() may_use_simd()
diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index 3e79283b617d9..f9e44aac6619b 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -60,9 +60,9 @@ libsha256-y					:= sha256.o
 obj-$(CONFIG_CRYPTO_LIB_SHA256_GENERIC)		+= libsha256-generic.o
 libsha256-generic-y				:= sha256-generic.o
 
 obj-$(CONFIG_MPILIB) += mpi/
 
-obj-$(CONFIG_CRYPTO_SELFTESTS)			+= simd.o
+obj-$(CONFIG_CRYPTO_SELFTESTS_FULL)		+= simd.o
 
 obj-$(CONFIG_CRYPTO_LIB_SM3)			+= libsm3.o
 libsm3-y					:= sm3.o

base-commit: 19272b37aa4f83ca52bdf9c16d5d81bdd1354494
-- 
2.49.0

