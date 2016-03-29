From: Borislav Petkov <bp@alien8.de>
Subject: [PATCH 03/10] x86/cpufeature: Kill cpu_has_osxsave
Date: Tue, 29 Mar 2016 17:41:56 +0200
Message-ID: <1459266123-21878-4-git-send-email-bp@alien8.de>
References: <1459266123-21878-1-git-send-email-bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
To: X86 ML <x86@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459266123-21878-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Use boot_cpu_has() instead.

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: linux-crypto@vger.kernel.org
---
 arch/x86/crypto/camellia_aesni_avx2_glue.c | 3 ++-
 arch/x86/crypto/camellia_aesni_avx_glue.c  | 2 +-
 arch/x86/crypto/serpent_avx2_glue.c        | 2 +-
 arch/x86/include/asm/cpufeature.h          | 1 -
 arch/x86/include/asm/xor_avx.h             | 4 ++--
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/crypto/camellia_aesni_avx2_glue.c b/arch/x86/crypto/camellia_aesni_avx2_glue.c
index d84456924563..c37f7028c85a 100644
--- a/arch/x86/crypto/camellia_aesni_avx2_glue.c
+++ b/arch/x86/crypto/camellia_aesni_avx2_glue.c
@@ -562,7 +562,8 @@ static int __init camellia_aesni_init(void)
 {
 	const char *feature_name;
 
-	if (!cpu_has_avx2 || !cpu_has_avx || !cpu_has_aes || !cpu_has_osxsave) {
+	if (!cpu_has_avx2 || !cpu_has_avx || !cpu_has_aes ||
+	    !boot_cpu_has(X86_FEATURE_OSXSAVE)) {
 		pr_info("AVX2 or AES-NI instructions are not detected.\n");
 		return -ENODEV;
 	}
diff --git a/arch/x86/crypto/camellia_aesni_avx_glue.c b/arch/x86/crypto/camellia_aesni_avx_glue.c
index 93d8f295784e..65f64556725b 100644
--- a/arch/x86/crypto/camellia_aesni_avx_glue.c
+++ b/arch/x86/crypto/camellia_aesni_avx_glue.c
@@ -554,7 +554,7 @@ static int __init camellia_aesni_init(void)
 {
 	const char *feature_name;
 
-	if (!cpu_has_avx || !cpu_has_aes || !cpu_has_osxsave) {
+	if (!cpu_has_avx || !cpu_has_aes || !boot_cpu_has(X86_FEATURE_OSXSAVE)) {
 		pr_info("AVX or AES-NI instructions are not detected.\n");
 		return -ENODEV;
 	}
diff --git a/arch/x86/crypto/serpent_avx2_glue.c b/arch/x86/crypto/serpent_avx2_glue.c
index 6d198342e2de..408cae2b3543 100644
--- a/arch/x86/crypto/serpent_avx2_glue.c
+++ b/arch/x86/crypto/serpent_avx2_glue.c
@@ -538,7 +538,7 @@ static int __init init(void)
 {
 	const char *feature_name;
 
-	if (!cpu_has_avx2 || !cpu_has_osxsave) {
+	if (!cpu_has_avx2 || !boot_cpu_has(X86_FEATURE_OSXSAVE)) {
 		pr_info("AVX2 instructions are not detected.\n");
 		return -ENODEV;
 	}
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 3aea54ecabfd..33c29aabc9aa 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -135,7 +135,6 @@ extern const char * const x86_bug_flags[NBUGINTS*32];
 #define cpu_has_x2apic		boot_cpu_has(X86_FEATURE_X2APIC)
 #define cpu_has_xsave		boot_cpu_has(X86_FEATURE_XSAVE)
 #define cpu_has_xsaves		boot_cpu_has(X86_FEATURE_XSAVES)
-#define cpu_has_osxsave		boot_cpu_has(X86_FEATURE_OSXSAVE)
 /*
  * Do not add any more of those clumsy macros - use static_cpu_has() for
  * fast paths and boot_cpu_has() otherwise!
diff --git a/arch/x86/include/asm/xor_avx.h b/arch/x86/include/asm/xor_avx.h
index 7c0a517ec751..e45e556140af 100644
--- a/arch/x86/include/asm/xor_avx.h
+++ b/arch/x86/include/asm/xor_avx.h
@@ -167,12 +167,12 @@ static struct xor_block_template xor_block_avx = {
 
 #define AVX_XOR_SPEED \
 do { \
-	if (cpu_has_avx && cpu_has_osxsave) \
+	if (cpu_has_avx && boot_cpu_has(X86_FEATURE_OSXSAVE)) \
 		xor_speed(&xor_block_avx); \
 } while (0)
 
 #define AVX_SELECT(FASTEST) \
-	(cpu_has_avx && cpu_has_osxsave ? &xor_block_avx : FASTEST)
+	(cpu_has_avx && boot_cpu_has(X86_FEATURE_OSXSAVE) ? &xor_block_avx : FASTEST)
 
 #else
 
-- 
2.7.3
