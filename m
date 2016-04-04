From: Borislav Petkov <bp@alien8.de>
Subject: [PATCH 02/10] x86/cpufeature: Remove cpu_has_aes
Date: Mon,  4 Apr 2016 22:24:55 +0200
Message-ID: <1459801503-15600-3-git-send-email-bp@alien8.de>
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
 arch/x86/crypto/camellia_aesni_avx2_glue.c | 3 ++-
 arch/x86/crypto/camellia_aesni_avx_glue.c  | 4 +++-
 arch/x86/include/asm/cpufeature.h          | 1 -
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/crypto/camellia_aesni_avx2_glue.c b/arch/x86/crypto/camellia_aesni_avx2_glue.c
index 39389662e29b..c07f699826a0 100644
--- a/arch/x86/crypto/camellia_aesni_avx2_glue.c
+++ b/arch/x86/crypto/camellia_aesni_avx2_glue.c
@@ -562,7 +562,8 @@ static int __init camellia_aesni_init(void)
 {
 	const char *feature_name;
 
-	if (!boot_cpu_has(X86_FEATURE_AVX2) || !cpu_has_avx || !cpu_has_aes ||
+	if (!boot_cpu_has(X86_FEATURE_AVX2) || !cpu_has_avx ||
+	    !boot_cpu_has(X86_FEATURE_AES) ||
 	    !boot_cpu_has(X86_FEATURE_OSXSAVE)) {
 		pr_info("AVX2 or AES-NI instructions are not detected.\n");
 		return -ENODEV;
diff --git a/arch/x86/crypto/camellia_aesni_avx_glue.c b/arch/x86/crypto/camellia_aesni_avx_glue.c
index 65f64556725b..6d256d59c5fd 100644
--- a/arch/x86/crypto/camellia_aesni_avx_glue.c
+++ b/arch/x86/crypto/camellia_aesni_avx_glue.c
@@ -554,7 +554,9 @@ static int __init camellia_aesni_init(void)
 {
 	const char *feature_name;
 
-	if (!cpu_has_avx || !cpu_has_aes || !boot_cpu_has(X86_FEATURE_OSXSAVE)) {
+	if (!cpu_has_avx ||
+	    !boot_cpu_has(X86_FEATURE_AES) ||
+	    !boot_cpu_has(X86_FEATURE_OSXSAVE)) {
 		pr_info("AVX or AES-NI instructions are not detected.\n");
 		return -ENODEV;
 	}
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 810166530cbf..a6627b30bf45 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -123,7 +123,6 @@ extern const char * const x86_bug_flags[NBUGINTS*32];
 #define cpu_has_apic		boot_cpu_has(X86_FEATURE_APIC)
 #define cpu_has_fxsr		boot_cpu_has(X86_FEATURE_FXSR)
 #define cpu_has_xmm		boot_cpu_has(X86_FEATURE_XMM)
-#define cpu_has_aes		boot_cpu_has(X86_FEATURE_AES)
 #define cpu_has_avx		boot_cpu_has(X86_FEATURE_AVX)
 #define cpu_has_xsave		boot_cpu_has(X86_FEATURE_XSAVE)
 #define cpu_has_xsaves		boot_cpu_has(X86_FEATURE_XSAVES)
-- 
2.7.3
