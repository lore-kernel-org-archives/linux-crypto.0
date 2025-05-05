Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E2226E146;
	Mon,  5 May 2025 20:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746477436; cv=none; b=mdFaNZ+DNJqz6Hwm7Fgd167cL6et/XzfuR2XZ9awB2y4sU6Hjz5XcPQOCK/rsbXd2GXjXufgBEH29SxdaISsfIxQvIxl6hNInecez0ktwPTMyE5oj6yOpQqGZP6MZ5mf8Bcu6ZHT5cVkJfRCY7kD3EbpiHuAPA/t11W/rjAczjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746477436; c=relaxed/simple;
	bh=Ys/DLc22AQdwyibFfw+021/gNZaqBQm7V3MkQwM7aMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MTJFe7/Qm1W1nM+LBqS91s/oGy1NA89UCDbZSAB7BvgYyaHDwujui+Uu5Prim1xZgLri4t5Ug26RJsWmBIm8cvVgN68ZiBXnMnVM48IpcJycCvuN1L6sseXQUGus+Cop8Zbhe8Ts3UJ5tIZxOx4DB/DgNL5jzYUUcBJA+fF+tXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bgiSNiia; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bgiSNiia"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEFDCC4CEEF;
	Mon,  5 May 2025 20:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746477436;
	bh=Ys/DLc22AQdwyibFfw+021/gNZaqBQm7V3MkQwM7aMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bgiSNiiasy4abZEgM+1yY6gSgNLio2WsEOXFX9rmCRKUyNGytado0kigfd9M7sg+2
	 5i/fuo+xwGj+lNQ++mujVCrWztEf7Rkhck4556V3R3mx5P3S4QfhjSbFg76u158cSU
	 xpwii11HVv8DvleEev8VHHl3rNAXm86SXRUZ85XuLhj6UEFyRbMBWomwWvlkCykMty
	 Yu1UQUmuB9PVfCuaR4zM7ng4lTL1Dv8aTsp5hIEqH8Yf6bFUv4IdZP7BaSdvSTheus
	 l0Q9C8jJDHLb7dS2d6byqLuDHcomOs4zvEIQ+lmimUcbDpgFXDFTTNeIEYnUfO90xx
	 4GqpHEtLYaWsw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/7] crypto: testmgr - replace CRYPTO_MANAGER_DISABLE_TESTS with CRYPTO_SELFTESTS
Date: Mon,  5 May 2025 13:33:41 -0700
Message-ID: <20250505203345.802740-4-ebiggers@kernel.org>
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

The negative-sense of CRYPTO_MANAGER_DISABLE_TESTS is a longstanding
mistake that regularly causes confusion.  Especially bad is that you can
have CRYPTO=n && CRYPTO_MANAGER_DISABLE_TESTS=n, which is ambiguous.

Replace CRYPTO_MANAGER_DISABLE_TESTS with CRYPTO_SELFTESTS which has the
expected behavior.

The tests continue to be disabled by default.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm/configs/milbeaut_m10v_defconfig   |  2 +-
 arch/loongarch/configs/loongson3_defconfig |  2 +-
 arch/s390/configs/debug_defconfig          |  2 +-
 arch/s390/configs/defconfig                |  2 +-
 crypto/Kconfig                             | 24 ++++++++++++++--------
 crypto/algapi.c                            |  4 ++--
 crypto/algboss.c                           |  2 +-
 crypto/api.c                               |  3 +--
 crypto/hkdf.c                              |  2 +-
 crypto/internal.h                          |  5 ++---
 crypto/kdf_sp800108.c                      |  2 +-
 crypto/testmgr.c                           | 12 +++++------
 lib/crypto/Makefile                        |  9 +++-----
 lib/crypto/aescfb.c                        |  2 +-
 lib/crypto/aesgcm.c                        |  2 +-
 lib/crypto/blake2s.c                       |  2 +-
 lib/crypto/chacha20poly1305.c              |  2 +-
 lib/crypto/curve25519.c                    |  2 +-
 18 files changed, 41 insertions(+), 40 deletions(-)

diff --git a/arch/arm/configs/milbeaut_m10v_defconfig b/arch/arm/configs/milbeaut_m10v_defconfig
index 4ec21f477c63..9dd47e1d90bb 100644
--- a/arch/arm/configs/milbeaut_m10v_defconfig
+++ b/arch/arm/configs/milbeaut_m10v_defconfig
@@ -92,11 +92,11 @@ CONFIG_CONFIGFS_FS=y
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ISO8859_1=y
 CONFIG_NLS_UTF8=y
 CONFIG_KEYS=y
 CONFIG_CRYPTO_MANAGER=y
-# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
+CONFIG_CRYPTO_SELFTESTS=y
 # CONFIG_CRYPTO_ECHAINIV is not set
 CONFIG_CRYPTO_AES=y
 CONFIG_CRYPTO_SEQIV=m
 CONFIG_CRYPTO_GHASH_ARM_CE=m
 CONFIG_CRYPTO_SHA1_ARM_NEON=m
diff --git a/arch/loongarch/configs/loongson3_defconfig b/arch/loongarch/configs/loongson3_defconfig
index 90f21dfe22b1..0d59af6007b7 100644
--- a/arch/loongarch/configs/loongson3_defconfig
+++ b/arch/loongarch/configs/loongson3_defconfig
@@ -1024,11 +1024,11 @@ CONFIG_SECURITY_SELINUX=y
 CONFIG_SECURITY_SELINUX_BOOTPARAM=y
 CONFIG_SECURITY_APPARMOR=y
 CONFIG_SECURITY_YAMA=y
 CONFIG_DEFAULT_SECURITY_DAC=y
 CONFIG_CRYPTO_USER=m
-# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
+CONFIG_CRYPTO_SELFTESTS=y
 CONFIG_CRYPTO_PCRYPT=m
 CONFIG_CRYPTO_CRYPTD=m
 CONFIG_CRYPTO_ANUBIS=m
 CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_CAST5=m
diff --git a/arch/s390/configs/debug_defconfig b/arch/s390/configs/debug_defconfig
index e6f7c8f4ee8b..bc960b1eabae 100644
--- a/arch/s390/configs/debug_defconfig
+++ b/arch/s390/configs/debug_defconfig
@@ -741,11 +741,11 @@ CONFIG_IMA=y
 CONFIG_IMA_DEFAULT_HASH_SHA256=y
 CONFIG_IMA_WRITE_POLICY=y
 CONFIG_IMA_APPRAISE=y
 CONFIG_BUG_ON_DATA_CORRUPTION=y
 CONFIG_CRYPTO_USER=m
-# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
+CONFIG_CRYPTO_SELFTESTS=y
 CONFIG_CRYPTO_PCRYPT=m
 CONFIG_CRYPTO_CRYPTD=m
 CONFIG_CRYPTO_BENCHMARK=m
 CONFIG_CRYPTO_DH=m
 CONFIG_CRYPTO_ECDH=m
diff --git a/arch/s390/configs/defconfig b/arch/s390/configs/defconfig
index 7495bf8e483c..fda2f264e7d3 100644
--- a/arch/s390/configs/defconfig
+++ b/arch/s390/configs/defconfig
@@ -727,11 +727,11 @@ CONFIG_IMA_DEFAULT_HASH_SHA256=y
 CONFIG_IMA_WRITE_POLICY=y
 CONFIG_IMA_APPRAISE=y
 CONFIG_BUG_ON_DATA_CORRUPTION=y
 CONFIG_CRYPTO_FIPS=y
 CONFIG_CRYPTO_USER=m
-# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
+CONFIG_CRYPTO_SELFTESTS=y
 CONFIG_CRYPTO_PCRYPT=m
 CONFIG_CRYPTO_CRYPTD=m
 CONFIG_CRYPTO_BENCHMARK=m
 CONFIG_CRYPTO_DH=m
 CONFIG_CRYPTO_ECDH=m
diff --git a/crypto/Kconfig b/crypto/Kconfig
index da352f1984ea..8f1353bbba18 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -23,11 +23,11 @@ if CRYPTO
 
 menu "Crypto core or helper"
 
 config CRYPTO_FIPS
 	bool "FIPS 200 compliance"
-	depends on (CRYPTO_ANSI_CPRNG || CRYPTO_DRBG) && !CRYPTO_MANAGER_DISABLE_TESTS
+	depends on (CRYPTO_ANSI_CPRNG || CRYPTO_DRBG) && CRYPTO_SELFTESTS
 	depends on (MODULE_SIG || !MODULES)
 	help
 	  This option enables the fips boot option which is
 	  required if you want the system to operate in a FIPS 200
 	  certification.  You should say no unless you know what
@@ -141,12 +141,12 @@ config CRYPTO_ACOMP
 	select CRYPTO_ALGAPI
 	select CRYPTO_ACOMP2
 
 config CRYPTO_HKDF
 	tristate
-	select CRYPTO_SHA256 if !CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
-	select CRYPTO_SHA512 if !CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
+	select CRYPTO_SHA256 if CRYPTO_SELFTESTS
+	select CRYPTO_SHA512 if CRYPTO_SELFTESTS
 	select CRYPTO_HASH2
 
 config CRYPTO_MANAGER
 	tristate "Cryptographic algorithm manager"
 	select CRYPTO_MANAGER2
@@ -171,20 +171,26 @@ config CRYPTO_USER
 	select CRYPTO_MANAGER
 	help
 	  Userspace configuration for cryptographic instantiations such as
 	  cbc(aes).
 
-config CRYPTO_MANAGER_DISABLE_TESTS
-	bool "Disable run-time self tests"
-	default y
+config CRYPTO_SELFTESTS
+	bool "Enable cryptographic self-tests"
+	depends on DEBUG_KERNEL
 	help
-	  Disable run-time self tests that normally take place at
-	  algorithm registration.
+	  Enable the cryptographic self-tests.
+
+	  The cryptographic self-tests run at boot time, or at algorithm
+	  registration time if algorithms are dynamically loaded later.
+
+	  This is primarily intended for developer use.  It should not be
+	  enabled in production kernels, unless you are trying to use these
+	  tests to fulfill a FIPS testing requirement.
 
 config CRYPTO_MANAGER_EXTRA_TESTS
 	bool "Enable extra run-time crypto self tests"
-	depends on DEBUG_KERNEL && !CRYPTO_MANAGER_DISABLE_TESTS && CRYPTO_MANAGER
+	depends on DEBUG_KERNEL && CRYPTO_SELFTESTS && CRYPTO_MANAGER
 	help
 	  Enable extra run-time self tests of registered crypto algorithms,
 	  including randomized fuzz tests.
 
 	  This is intended for developer use only, as these tests take much
diff --git a/crypto/algapi.c b/crypto/algapi.c
index 532d3efc3c7d..9030a30c89e8 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -273,11 +273,11 @@ static void crypto_alg_finish_registration(struct crypto_alg *alg,
 static struct crypto_larval *crypto_alloc_test_larval(struct crypto_alg *alg)
 {
 	struct crypto_larval *larval;
 
 	if (!IS_ENABLED(CONFIG_CRYPTO_MANAGER) ||
-	    IS_ENABLED(CONFIG_CRYPTO_MANAGER_DISABLE_TESTS) ||
+	    !IS_ENABLED(CONFIG_CRYPTO_SELFTESTS) ||
 	    (alg->cra_flags & CRYPTO_ALG_INTERNAL))
 		return NULL; /* No self-test needed */
 
 	larval = crypto_larval_alloc(alg->cra_name,
 				     alg->cra_flags | CRYPTO_ALG_TESTED, 0);
@@ -1057,11 +1057,11 @@ EXPORT_SYMBOL_GPL(crypto_type_has_alg);
 static void __init crypto_start_tests(void)
 {
 	if (!IS_BUILTIN(CONFIG_CRYPTO_ALGAPI))
 		return;
 
-	if (IS_ENABLED(CONFIG_CRYPTO_MANAGER_DISABLE_TESTS))
+	if (!IS_ENABLED(CONFIG_CRYPTO_SELFTESTS))
 		return;
 
 	set_crypto_boot_test_finished();
 
 	for (;;) {
diff --git a/crypto/algboss.c b/crypto/algboss.c
index ef5c73780fc7..846f586889ee 100644
--- a/crypto/algboss.c
+++ b/crypto/algboss.c
@@ -187,11 +187,11 @@ static int cryptomgr_test(void *data)
 static int cryptomgr_schedule_test(struct crypto_alg *alg)
 {
 	struct task_struct *thread;
 	struct crypto_test_param *param;
 
-	if (IS_ENABLED(CONFIG_CRYPTO_MANAGER_DISABLE_TESTS))
+	if (!IS_ENABLED(CONFIG_CRYPTO_SELFTESTS))
 		return NOTIFY_DONE;
 
 	if (!try_module_get(THIS_MODULE))
 		goto err;
 
diff --git a/crypto/api.c b/crypto/api.c
index 5cd5ec105bb1..133d9b626922 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -29,12 +29,11 @@ DECLARE_RWSEM(crypto_alg_sem);
 EXPORT_SYMBOL_GPL(crypto_alg_sem);
 
 BLOCKING_NOTIFIER_HEAD(crypto_chain);
 EXPORT_SYMBOL_GPL(crypto_chain);
 
-#if IS_BUILTIN(CONFIG_CRYPTO_ALGAPI) && \
-    !IS_ENABLED(CONFIG_CRYPTO_MANAGER_DISABLE_TESTS)
+#if IS_BUILTIN(CONFIG_CRYPTO_ALGAPI) && IS_ENABLED(CONFIG_CRYPTO_SELFTESTS)
 DEFINE_STATIC_KEY_FALSE(__crypto_boot_test_finished);
 #endif
 
 static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg,
 					     u32 type, u32 mask);
diff --git a/crypto/hkdf.c b/crypto/hkdf.c
index 2434c5c42545..f24c2a8d4df9 100644
--- a/crypto/hkdf.c
+++ b/crypto/hkdf.c
@@ -541,11 +541,11 @@ static int hkdf_test(const char *shash, const struct hkdf_testvec *tv)
 
 static int __init crypto_hkdf_module_init(void)
 {
 	int ret = 0, i;
 
-	if (IS_ENABLED(CONFIG_CRYPTO_MANAGER_DISABLE_TESTS))
+	if (!IS_ENABLED(CONFIG_CRYPTO_SELFTESTS))
 		return 0;
 
 	for (i = 0; i < ARRAY_SIZE(hkdf_sha256_tv); i++) {
 		ret = hkdf_test("hmac(sha256)", &hkdf_sha256_tv[i]);
 		if (ret)
diff --git a/crypto/internal.h b/crypto/internal.h
index 2ed79bf208ca..b9afd68767c1 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -65,12 +65,11 @@ extern struct list_head crypto_alg_list;
 extern struct rw_semaphore crypto_alg_sem;
 extern struct blocking_notifier_head crypto_chain;
 
 int alg_test(const char *driver, const char *alg, u32 type, u32 mask);
 
-#if !IS_BUILTIN(CONFIG_CRYPTO_ALGAPI) || \
-    IS_ENABLED(CONFIG_CRYPTO_MANAGER_DISABLE_TESTS)
+#if !IS_BUILTIN(CONFIG_CRYPTO_ALGAPI) || !IS_ENABLED(CONFIG_CRYPTO_SELFTESTS)
 static inline bool crypto_boot_test_finished(void)
 {
 	return true;
 }
 static inline void set_crypto_boot_test_finished(void)
@@ -85,11 +84,11 @@ static inline bool crypto_boot_test_finished(void)
 static inline void set_crypto_boot_test_finished(void)
 {
 	static_branch_enable(&__crypto_boot_test_finished);
 }
 #endif /* !IS_BUILTIN(CONFIG_CRYPTO_ALGAPI) ||
-	* IS_ENABLED(CONFIG_CRYPTO_MANAGER_DISABLE_TESTS)
+	* !IS_ENABLED(CONFIG_CRYPTO_SELFTESTS)
 	*/
 
 #ifdef CONFIG_PROC_FS
 void __init crypto_init_proc(void);
 void __exit crypto_exit_proc(void);
diff --git a/crypto/kdf_sp800108.c b/crypto/kdf_sp800108.c
index c3f9938e1ad2..b7a6bf9da773 100644
--- a/crypto/kdf_sp800108.c
+++ b/crypto/kdf_sp800108.c
@@ -125,11 +125,11 @@ static const struct kdf_testvec kdf_ctr_hmac_sha256_tv_template[] = {
 
 static int __init crypto_kdf108_init(void)
 {
 	int ret;
 
-	if (IS_ENABLED(CONFIG_CRYPTO_MANAGER_DISABLE_TESTS))
+	if (!IS_ENABLED(CONFIG_CRYPTO_SELFTESTS))
 		return 0;
 
 	ret = kdf_test(&kdf_ctr_hmac_sha256_tv_template[0], "hmac(sha256)",
 		       crypto_kdf108_setkey, crypto_kdf108_ctr_generate);
 	if (ret) {
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 1c71616ae2cf..3a624c9b5525 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -53,11 +53,11 @@ MODULE_PARM_DESC(noextratests, "disable expensive crypto self-tests");
 static unsigned int fuzz_iterations = 100;
 module_param(fuzz_iterations, uint, 0644);
 MODULE_PARM_DESC(fuzz_iterations, "number of fuzz test iterations");
 #endif
 
-#ifdef CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
+#ifndef CONFIG_CRYPTO_SELFTESTS
 
 /* a perfect nop */
 int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
 {
 	return 0;
@@ -319,14 +319,14 @@ struct testvec_config {
 
 #define TESTVEC_CONFIG_NAMELEN	192
 
 /*
  * The following are the lists of testvec_configs to test for each algorithm
- * type when the basic crypto self-tests are enabled, i.e. when
- * CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is unset.  They aim to provide good test
- * coverage, while keeping the test time much shorter than the full fuzz tests
- * so that the basic tests can be enabled in a wider range of circumstances.
+ * type when the basic crypto self-tests are enabled.  They aim to provide good
+ * test coverage, while keeping the test time much shorter than the full fuzz
+ * tests so that the basic tests can be enabled in a wider range of
+ * circumstances.
  */
 
 /* Configs for skciphers and aeads */
 static const struct testvec_config default_cipher_testvec_configs[] = {
 	{
@@ -5897,8 +5897,8 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
 	return 0;
 non_fips_alg:
 	return alg_fips_disabled(driver, alg);
 }
 
-#endif /* CONFIG_CRYPTO_MANAGER_DISABLE_TESTS */
+#endif /* CONFIG_CRYPTO_SELFTESTS */
 
 EXPORT_SYMBOL_GPL(alg_test);
diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index 71d3d05d666a..842fcef16e4d 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -23,21 +23,24 @@ obj-$(CONFIG_CRYPTO_LIB_GF128MUL)		+= gf128mul.o
 
 # blake2s is used by the /dev/random driver which is always builtin
 obj-y						+= libblake2s.o
 libblake2s-y					:= blake2s.o
 libblake2s-$(CONFIG_CRYPTO_LIB_BLAKE2S_GENERIC)	+= blake2s-generic.o
+libblake2s-$(CONFIG_CRYPTO_SELFTESTS)		+= blake2s-selftest.o
 
 obj-$(CONFIG_CRYPTO_LIB_CHACHA20POLY1305)	+= libchacha20poly1305.o
 libchacha20poly1305-y				+= chacha20poly1305.o
+libchacha20poly1305-$(CONFIG_CRYPTO_SELFTESTS)	+= chacha20poly1305-selftest.o
 
 obj-$(CONFIG_CRYPTO_LIB_CURVE25519_GENERIC)	+= libcurve25519-generic.o
 libcurve25519-generic-y				:= curve25519-fiat32.o
 libcurve25519-generic-$(CONFIG_ARCH_SUPPORTS_INT128)	:= curve25519-hacl64.o
 libcurve25519-generic-y				+= curve25519-generic.o
 
 obj-$(CONFIG_CRYPTO_LIB_CURVE25519)		+= libcurve25519.o
 libcurve25519-y					+= curve25519.o
+libcurve25519-$(CONFIG_CRYPTO_SELFTESTS)	+= curve25519-selftest.o
 
 obj-$(CONFIG_CRYPTO_LIB_DES)			+= libdes.o
 libdes-y					:= des.o
 
 obj-$(CONFIG_CRYPTO_LIB_POLY1305_GENERIC)	+= libpoly1305.o
@@ -52,16 +55,10 @@ obj-$(CONFIG_CRYPTO_LIB_SHA256)			+= libsha256.o
 libsha256-y					:= sha256.o
 
 obj-$(CONFIG_CRYPTO_LIB_SHA256_GENERIC)		+= libsha256-generic.o
 libsha256-generic-y				:= sha256-generic.o
 
-ifneq ($(CONFIG_CRYPTO_MANAGER_DISABLE_TESTS),y)
-libblake2s-y					+= blake2s-selftest.o
-libchacha20poly1305-y				+= chacha20poly1305-selftest.o
-libcurve25519-y					+= curve25519-selftest.o
-endif
-
 obj-$(CONFIG_MPILIB) += mpi/
 
 obj-$(CONFIG_CRYPTO_MANAGER_EXTRA_TESTS)	+= simd.o
 
 obj-$(CONFIG_CRYPTO_LIB_SM3)			+= libsm3.o
diff --git a/lib/crypto/aescfb.c b/lib/crypto/aescfb.c
index 749dc1258a44..437613265e14 100644
--- a/lib/crypto/aescfb.c
+++ b/lib/crypto/aescfb.c
@@ -97,11 +97,11 @@ EXPORT_SYMBOL(aescfb_decrypt);
 
 MODULE_DESCRIPTION("Generic AES-CFB library");
 MODULE_AUTHOR("Ard Biesheuvel <ardb@kernel.org>");
 MODULE_LICENSE("GPL");
 
-#ifndef CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
+#ifdef CONFIG_CRYPTO_SELFTESTS
 
 /*
  * Test code below. Vectors taken from crypto/testmgr.h
  */
 
diff --git a/lib/crypto/aesgcm.c b/lib/crypto/aesgcm.c
index 902e49410aaf..277824d6b4af 100644
--- a/lib/crypto/aesgcm.c
+++ b/lib/crypto/aesgcm.c
@@ -197,11 +197,11 @@ EXPORT_SYMBOL(aesgcm_decrypt);
 
 MODULE_DESCRIPTION("Generic AES-GCM library");
 MODULE_AUTHOR("Ard Biesheuvel <ardb@kernel.org>");
 MODULE_LICENSE("GPL");
 
-#ifndef CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
+#ifdef CONFIG_CRYPTO_SELFTESTS
 
 /*
  * Test code below. Vectors taken from crypto/testmgr.h
  */
 
diff --git a/lib/crypto/blake2s.c b/lib/crypto/blake2s.c
index 71a316552cc5..b0f9a678300b 100644
--- a/lib/crypto/blake2s.c
+++ b/lib/crypto/blake2s.c
@@ -58,11 +58,11 @@ void blake2s_final(struct blake2s_state *state, u8 *out)
 }
 EXPORT_SYMBOL(blake2s_final);
 
 static int __init blake2s_mod_init(void)
 {
-	if (!IS_ENABLED(CONFIG_CRYPTO_MANAGER_DISABLE_TESTS) &&
+	if (IS_ENABLED(CONFIG_CRYPTO_SELFTESTS) &&
 	    WARN_ON(!blake2s_selftest()))
 		return -ENODEV;
 	return 0;
 }
 
diff --git a/lib/crypto/chacha20poly1305.c b/lib/crypto/chacha20poly1305.c
index 9cfa886f1f89..57a84fee179e 100644
--- a/lib/crypto/chacha20poly1305.c
+++ b/lib/crypto/chacha20poly1305.c
@@ -353,11 +353,11 @@ bool chacha20poly1305_decrypt_sg_inplace(struct scatterlist *src, size_t src_len
 }
 EXPORT_SYMBOL(chacha20poly1305_decrypt_sg_inplace);
 
 static int __init chacha20poly1305_init(void)
 {
-	if (!IS_ENABLED(CONFIG_CRYPTO_MANAGER_DISABLE_TESTS) &&
+	if (IS_ENABLED(CONFIG_CRYPTO_SELFTESTS) &&
 	    WARN_ON(!chacha20poly1305_selftest()))
 		return -ENODEV;
 	return 0;
 }
 
diff --git a/lib/crypto/curve25519.c b/lib/crypto/curve25519.c
index 064b352c6907..6850b76a80c9 100644
--- a/lib/crypto/curve25519.c
+++ b/lib/crypto/curve25519.c
@@ -13,11 +13,11 @@
 #include <linux/module.h>
 #include <linux/init.h>
 
 static int __init curve25519_init(void)
 {
-	if (!IS_ENABLED(CONFIG_CRYPTO_MANAGER_DISABLE_TESTS) &&
+	if (IS_ENABLED(CONFIG_CRYPTO_SELFTESTS) &&
 	    WARN_ON(!curve25519_selftest()))
 		return -ENODEV;
 	return 0;
 }
 
-- 
2.49.0

