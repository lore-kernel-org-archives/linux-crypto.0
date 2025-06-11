Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0FA0223DD7;
	Wed, 11 Jun 2025 17:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749664606; cv=none; b=arypTYl4ZVvhkpWSGYx79/Q2j4DVrLxWr7X8RVom7umDGDKyENL7d2akfb6EF4JiamJl2gxp4SF+agzRIUppAGdLHzwuoJGAEXtcpbNk1KgRbLBseM3xYw+VMROxP5HCzbeqXUKpPh7yofVCnZt8JldUQh4QoZtBJ/6j5ne48PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749664606; c=relaxed/simple;
	bh=9UxSGzmrhJ12Y47WI59Uc32TrPJnAitCYA2IdeNdqcM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CyC1m0FgDS/wA2EGDgINVSbDKjSBilmC02QwSlQCHoKIp19PhO0K7A0BjUv7qG3DteOmO6aBSvjnU564EYfdBoaGkRFsk3dbDgUzcaiSoo2feBGBoaymfJjoL16CqE9t9TWNh1gZJg+h3aCv4tYbOpATkUu1Ry7x5UwQVrTPpMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rXgLQzXV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rXgLQzXV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CCD2C4CEE3;
	Wed, 11 Jun 2025 17:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749664606;
	bh=9UxSGzmrhJ12Y47WI59Uc32TrPJnAitCYA2IdeNdqcM=;
	h=From:To:Cc:Subject:Date:From;
	b=rXgLQzXVB+LkCqepBidBmbMMObHgmyB8sfv0yzleYjJSUX7OZsQz6RAJBxi2tYyiU
	 oudHjc95vj9UEYPSdtsrSb8sJWo1/itOUM/OUe+v7yCepBJ/7UcTJTRUszwxpBozgP
	 tlek6fYLL2ZKxYEaIYONyuUReP5yTBqZNeMmlbY1cIeEreKfAC2p4b7aXbCIe6hzoT
	 nL7u7/KnFvFfPv9/5ZHRRRogtW+XFbLSXOdqQK4HDV04h0j35fvlMnvag/EmFZ6vFq
	 xoHrQWioO/6dZ8bOKh/NhXZw1PZZSwEZERvuibzjVoWyq0W2Phbpnmtge56pqitU+R
	 67wt1Js1qSEqA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Diederik de Haas <didi.debian@cknow.org>,
	Ingo Franzki <ifranzki@linux.ibm.com>
Subject: [PATCH] crypto: testmgr - reinstate kconfig support for fast tests only
Date: Wed, 11 Jun 2025 10:55:25 -0700
Message-ID: <20250611175525.42516-1-ebiggers@kernel.org>
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

Unfortunately, it turns out that both Debian and Fedora have the crypto
self-tests enabled in their production kernels, and they seem to want to
keep them enabled.  The full set of tests isn't great for that, since
they take significantly longer to run and slow down the boot.

One issue is that the crypto self-tests are being (mis)used to meet FIPS
140-3 pre-operational testing requirements.  But actually the more
fundamental issue is that the crypto/ subsystem has many buggy and
untested drivers for off-CPU hardware accelerators on rare platforms.
As a result, apparently in some cases the tests are actually being
relied on *in production kernels* to stop buggy drivers from being used.
I think this is kind of crazy (untested drivers should just not be
enabled at all), but that seems to be how things work currently.

Thus, reintroduce a kconfig option that controls the level of testing.
Instead of the original CRYPTO_MANAGER_EXTRA_TESTS which was confusing
and disabled by default, go with CRYPTO_SELFTESTS_FULL which is enabled
by default (but dependent on CRYPTO_SELFTESTS, of course).

Given the "production kernel" use cases, also remove the dependency on
DEBUG_KERNEL from CRYPTO_SELFTESTS.  It was introduced by
commit 40b9969796bf ("crypto: testmgr - replace
CRYPTO_MANAGER_DISABLE_TESTS with CRYPTO_SELFTESTS") and wasn't present
on the original option.

I also haven't reinstated all the #ifdefs in crypto/testmgr.c.  Instead,
just rely on the compiler to optimize out unused code.

Fixes: 40b9969796bf ("crypto: testmgr - replace CRYPTO_MANAGER_DISABLE_TESTS with CRYPTO_SELFTESTS")
Fixes: 698de822780f ("crypto: testmgr - make it easier to enable the full set of tests")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---

This patch is targeting the crypto tree for 6.16.

 crypto/Kconfig                 | 18 ++++++++++++++----
 crypto/testmgr.c               | 15 ++++++++++++---
 include/crypto/internal/simd.h |  6 ++++--
 lib/crypto/Makefile            |  2 +-
 4 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index e9fee7818e270..8612ebf655647 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -174,20 +174,30 @@ config CRYPTO_USER
 	  Userspace configuration for cryptographic instantiations such as
 	  cbc(aes).
 
 config CRYPTO_SELFTESTS
 	bool "Enable cryptographic self-tests"
-	depends on DEBUG_KERNEL
 	help
 	  Enable the cryptographic self-tests.
 
 	  The cryptographic self-tests run at boot time, or at algorithm
 	  registration time if algorithms are dynamically loaded later.
 
-	  This is primarily intended for developer use.  It should not be
-	  enabled in production kernels, unless you are trying to use these
-	  tests to fulfill a FIPS testing requirement.
+config CRYPTO_SELFTESTS_FULL
+	bool "Enable the full set of cryptographic self-tests"
+	depends on CRYPTO_SELFTESTS
+	default y
+	help
+	  Enable the full set of cryptographic self-tests for each algorithm.
+
+	  For development and pre-release testing, leave this as 'y'.
+
+	  If you're keeping the crypto self-tests enabled in a production
+	  kernel, you likely want to set this to 'n' to speed up the boot.  This
+	  will cause the "slow" tests to be skipped.  This may suffice for a
+	  quick sanity check of drivers and for FIPS 140-3 pre-operational self-
+	  testing, but some issues can be found only by the full set of tests.
 
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

base-commit: aef17cb3d3c43854002956f24c24ec8e1a0e3546
-- 
2.49.0

