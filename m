From: Borislav Petkov <bp@alien8.de>
Subject: [PATCH 03/10] x86/cpufeature: Remove cpu_has_avx
Date: Mon,  4 Apr 2016 22:24:56 +0200
Message-ID: <1459801503-15600-4-git-send-email-bp@alien8.de>
References: <1459801503-15600-1-git-send-email-bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
To: X86 ML <x86@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459801503-15600-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: linux-crypto@vger.kernel.org
---
 arch/x86/crypto/aesni-intel_glue.c         | 2 +-
 arch/x86/crypto/camellia_aesni_avx2_glue.c | 3 ++-
 arch/x86/crypto/camellia_aesni_avx_glue.c  | 2 +-
 arch/x86/crypto/chacha20_glue.c            | 3 ++-
 arch/x86/crypto/poly1305_glue.c            | 3 ++-
 arch/x86/crypto/sha1_ssse3_glue.c          | 2 +-
 arch/x86/crypto/sha256_ssse3_glue.c        | 2 +-
 arch/x86/crypto/sha512_ssse3_glue.c        | 2 +-
 arch/x86/include/asm/cpufeature.h          | 1 -
 arch/x86/include/asm/xor_avx.h             | 4 ++--
 10 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 064c7e2bd7c8..5b7fa1471007 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -1477,7 +1477,7 @@ static int __init aesni_init(void)
 	}
 	aesni_ctr_enc_tfm = aesni_ctr_enc;
 #ifdef CONFIG_AS_AVX
-	if (cpu_has_avx) {
+	if (boot_cpu_has(X86_FEATURE_AVX)) {
 		/* optimize performance of ctr mode encryption transform */
 		aesni_ctr_enc_tfm = aesni_ctr_enc_avx_tfm;
 		pr_info("AES CTR mode by8 optimization enabled\n");
diff --git a/arch/x86/crypto/camellia_aesni_avx2_glue.c b/arch/x86/crypto/camellia_aesni_avx2_glue.c
index c07f699826a0..60907c139c4e 100644
--- a/arch/x86/crypto/camellia_aesni_avx2_glue.c
+++ b/arch/x86/crypto/camellia_aesni_avx2_glue.c
@@ -562,7 +562,8 @@ static int __init camellia_aesni_init(void)
 {
 	const char *feature_name;
 
-	if (!boot_cpu_has(X86_FEATURE_AVX2) || !cpu_has_avx ||
+	if (!boot_cpu_has(X86_FEATURE_AVX) ||
+	    !boot_cpu_has(X86_FEATURE_AVX2) ||
 	    !boot_cpu_has(X86_FEATURE_AES) ||
 	    !boot_cpu_has(X86_FEATURE_OSXSAVE)) {
 		pr_info("AVX2 or AES-NI instructions are not detected.\n");
diff --git a/arch/x86/crypto/camellia_aesni_avx_glue.c b/arch/x86/crypto/camellia_aesni_avx_glue.c
index 6d256d59c5fd..d96429da88eb 100644
--- a/arch/x86/crypto/camellia_aesni_avx_glue.c
+++ b/arch/x86/crypto/camellia_aesni_avx_glue.c
@@ -554,7 +554,7 @@ static int __init camellia_aesni_init(void)
 {
 	const char *feature_name;
 
-	if (!cpu_has_avx ||
+	if (!boot_cpu_has(X86_FEATURE_AVX) ||
 	    !boot_cpu_has(X86_FEATURE_AES) ||
 	    !boot_cpu_has(X86_FEATURE_OSXSAVE)) {
 		pr_info("AVX or AES-NI instructions are not detected.\n");
diff --git a/arch/x86/crypto/chacha20_glue.c b/arch/x86/crypto/chacha20_glue.c
index cea061e137da..2d5c2e0bd939 100644
--- a/arch/x86/crypto/chacha20_glue.c
+++ b/arch/x86/crypto/chacha20_glue.c
@@ -129,7 +129,8 @@ static int __init chacha20_simd_mod_init(void)
 		return -ENODEV;
 
 #ifdef CONFIG_AS_AVX2
-	chacha20_use_avx2 = cpu_has_avx && boot_cpu_has(X86_FEATURE_AVX2) &&
+	chacha20_use_avx2 = boot_cpu_has(X86_FEATURE_AVX) &&
+			    boot_cpu_has(X86_FEATURE_AVX2) &&
 			    cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL);
 #endif
 	return crypto_register_alg(&alg);
diff --git a/arch/x86/crypto/poly1305_glue.c b/arch/x86/crypto/poly1305_glue.c
index ea21d2e440f7..e32142bc071d 100644
--- a/arch/x86/crypto/poly1305_glue.c
+++ b/arch/x86/crypto/poly1305_glue.c
@@ -183,7 +183,8 @@ static int __init poly1305_simd_mod_init(void)
 		return -ENODEV;
 
 #ifdef CONFIG_AS_AVX2
-	poly1305_use_avx2 = cpu_has_avx && boot_cpu_has(X86_FEATURE_AVX2) &&
+	poly1305_use_avx2 = boot_cpu_has(X86_FEATURE_AVX) &&
+			    boot_cpu_has(X86_FEATURE_AVX2) &&
 			    cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL);
 	alg.descsize = sizeof(struct poly1305_simd_desc_ctx);
 	if (poly1305_use_avx2)
diff --git a/arch/x86/crypto/sha1_ssse3_glue.c b/arch/x86/crypto/sha1_ssse3_glue.c
index dd14616b7739..1024e378a358 100644
--- a/arch/x86/crypto/sha1_ssse3_glue.c
+++ b/arch/x86/crypto/sha1_ssse3_glue.c
@@ -166,7 +166,7 @@ static struct shash_alg sha1_avx_alg = {
 static bool avx_usable(void)
 {
 	if (!cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL)) {
-		if (cpu_has_avx)
+		if (boot_cpu_has(X86_FEATURE_AVX))
 			pr_info("AVX detected but unusable.\n");
 		return false;
 	}
diff --git a/arch/x86/crypto/sha256_ssse3_glue.c b/arch/x86/crypto/sha256_ssse3_glue.c
index 5f4d6086dc59..3ae0f43ebd37 100644
--- a/arch/x86/crypto/sha256_ssse3_glue.c
+++ b/arch/x86/crypto/sha256_ssse3_glue.c
@@ -201,7 +201,7 @@ static struct shash_alg sha256_avx_algs[] = { {
 static bool avx_usable(void)
 {
 	if (!cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL)) {
-		if (cpu_has_avx)
+		if (boot_cpu_has(X86_FEATURE_AVX))
 			pr_info("AVX detected but unusable.\n");
 		return false;
 	}
diff --git a/arch/x86/crypto/sha512_ssse3_glue.c b/arch/x86/crypto/sha512_ssse3_glue.c
index 34e5083d6f36..0b17c83d027d 100644
--- a/arch/x86/crypto/sha512_ssse3_glue.c
+++ b/arch/x86/crypto/sha512_ssse3_glue.c
@@ -151,7 +151,7 @@ asmlinkage void sha512_transform_avx(u64 *digest, const char *data,
 static bool avx_usable(void)
 {
 	if (!cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL)) {
-		if (cpu_has_avx)
+		if (boot_cpu_has(X86_FEATURE_AVX))
 			pr_info("AVX detected but unusable.\n");
 		return false;
 	}
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index a6627b30bf45..3b232a120a5d 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -123,7 +123,6 @@ extern const char * const x86_bug_flags[NBUGINTS*32];
 #define cpu_has_apic		boot_cpu_has(X86_FEATURE_APIC)
 #define cpu_has_fxsr		boot_cpu_has(X86_FEATURE_FXSR)
 #define cpu_has_xmm		boot_cpu_has(X86_FEATURE_XMM)
-#define cpu_has_avx		boot_cpu_has(X86_FEATURE_AVX)
 #define cpu_has_xsave		boot_cpu_has(X86_FEATURE_XSAVE)
 #define cpu_has_xsaves		boot_cpu_has(X86_FEATURE_XSAVES)
 /*
diff --git a/arch/x86/include/asm/xor_avx.h b/arch/x86/include/asm/xor_avx.h
index e45e556140af..22a7b1870a31 100644
--- a/arch/x86/include/asm/xor_avx.h
+++ b/arch/x86/include/asm/xor_avx.h
@@ -167,12 +167,12 @@ static struct xor_block_template xor_block_avx = {
 
 #define AVX_XOR_SPEED \
 do { \
-	if (cpu_has_avx && boot_cpu_has(X86_FEATURE_OSXSAVE)) \
+	if (boot_cpu_has(X86_FEATURE_AVX) && boot_cpu_has(X86_FEATURE_OSXSAVE)) \
 		xor_speed(&xor_block_avx); \
 } while (0)
 
 #define AVX_SELECT(FASTEST) \
-	(cpu_has_avx && boot_cpu_has(X86_FEATURE_OSXSAVE) ? &xor_block_avx : FASTEST)
+	(boot_cpu_has(X86_FEATURE_AVX) && boot_cpu_has(X86_FEATURE_OSXSAVE) ? &xor_block_avx : FASTEST)
 
 #else
 
-- 
2.7.3
