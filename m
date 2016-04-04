From: Borislav Petkov <bp@alien8.de>
Subject: [PATCH 01/10] x86/cpufeature: Remove cpu_has_avx2
Date: Mon,  4 Apr 2016 22:24:54 +0200
Message-ID: <1459801503-15600-2-git-send-email-bp@alien8.de>
References: <1459801503-15600-1-git-send-email-bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
To: X86 ML <x86@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.skyhub.de ([78.46.96.112]:48005 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756662AbcDDUZM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Apr 2016 16:25:12 -0400
In-Reply-To: <1459801503-15600-1-git-send-email-bp@alien8.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Borislav Petkov <bp@suse.de>

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: linux-crypto@vger.kernel.org
---
 arch/x86/crypto/camellia_aesni_avx2_glue.c | 2 +-
 arch/x86/crypto/chacha20_glue.c            | 2 +-
 arch/x86/crypto/poly1305_glue.c            | 2 +-
 arch/x86/crypto/serpent_avx2_glue.c        | 2 +-
 arch/x86/include/asm/cpufeature.h          | 1 -
 5 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/crypto/camellia_aesni_avx2_glue.c b/arch/x86/crypto/camellia_aesni_avx2_glue.c
index c37f7028c85a..39389662e29b 100644
--- a/arch/x86/crypto/camellia_aesni_avx2_glue.c
+++ b/arch/x86/crypto/camellia_aesni_avx2_glue.c
@@ -562,7 +562,7 @@ static int __init camellia_aesni_init(void)
 {
 	const char *feature_name;
 
-	if (!cpu_has_avx2 || !cpu_has_avx || !cpu_has_aes ||
+	if (!boot_cpu_has(X86_FEATURE_AVX2) || !cpu_has_avx || !cpu_has_aes ||
 	    !boot_cpu_has(X86_FEATURE_OSXSAVE)) {
 		pr_info("AVX2 or AES-NI instructions are not detected.\n");
 		return -ENODEV;
diff --git a/arch/x86/crypto/chacha20_glue.c b/arch/x86/crypto/chacha20_glue.c
index 8baaff5af0b5..cea061e137da 100644
--- a/arch/x86/crypto/chacha20_glue.c
+++ b/arch/x86/crypto/chacha20_glue.c
@@ -129,7 +129,7 @@ static int __init chacha20_simd_mod_init(void)
 		return -ENODEV;
 
 #ifdef CONFIG_AS_AVX2
-	chacha20_use_avx2 = cpu_has_avx && cpu_has_avx2 &&
+	chacha20_use_avx2 = cpu_has_avx && boot_cpu_has(X86_FEATURE_AVX2) &&
 			    cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL);
 #endif
 	return crypto_register_alg(&alg);
diff --git a/arch/x86/crypto/poly1305_glue.c b/arch/x86/crypto/poly1305_glue.c
index b283868acdf8..ea21d2e440f7 100644
--- a/arch/x86/crypto/poly1305_glue.c
+++ b/arch/x86/crypto/poly1305_glue.c
@@ -183,7 +183,7 @@ static int __init poly1305_simd_mod_init(void)
 		return -ENODEV;
 
 #ifdef CONFIG_AS_AVX2
-	poly1305_use_avx2 = cpu_has_avx && cpu_has_avx2 &&
+	poly1305_use_avx2 = cpu_has_avx && boot_cpu_has(X86_FEATURE_AVX2) &&
 			    cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL);
 	alg.descsize = sizeof(struct poly1305_simd_desc_ctx);
 	if (poly1305_use_avx2)
diff --git a/arch/x86/crypto/serpent_avx2_glue.c b/arch/x86/crypto/serpent_avx2_glue.c
index 408cae2b3543..870f6d812a2d 100644
--- a/arch/x86/crypto/serpent_avx2_glue.c
+++ b/arch/x86/crypto/serpent_avx2_glue.c
@@ -538,7 +538,7 @@ static int __init init(void)
 {
 	const char *feature_name;
 
-	if (!cpu_has_avx2 || !boot_cpu_has(X86_FEATURE_OSXSAVE)) {
+	if (!boot_cpu_has(X86_FEATURE_AVX2) || !boot_cpu_has(X86_FEATURE_OSXSAVE)) {
 		pr_info("AVX2 instructions are not detected.\n");
 		return -ENODEV;
 	}
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index c594e04bf529..810166530cbf 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -125,7 +125,6 @@ extern const char * const x86_bug_flags[NBUGINTS*32];
 #define cpu_has_xmm		boot_cpu_has(X86_FEATURE_XMM)
 #define cpu_has_aes		boot_cpu_has(X86_FEATURE_AES)
 #define cpu_has_avx		boot_cpu_has(X86_FEATURE_AVX)
-#define cpu_has_avx2		boot_cpu_has(X86_FEATURE_AVX2)
 #define cpu_has_xsave		boot_cpu_has(X86_FEATURE_XSAVE)
 #define cpu_has_xsaves		boot_cpu_has(X86_FEATURE_XSAVES)
 /*
-- 
2.7.3
