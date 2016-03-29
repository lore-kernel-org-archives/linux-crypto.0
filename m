From: Borislav Petkov <bp@alien8.de>
Subject: [PATCH 07/10] x86/cpufeature: Kill cpu_has_xmm2
Date: Tue, 29 Mar 2016 17:42:00 +0200
Message-ID: <1459266123-21878-8-git-send-email-bp@alien8.de>
References: <1459266123-21878-1-git-send-email-bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
To: X86 ML <x86@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.skyhub.de ([78.46.96.112]:50471 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757385AbcC2PmR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 29 Mar 2016 11:42:17 -0400
In-Reply-To: <1459266123-21878-1-git-send-email-bp@alien8.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Borislav Petkov <bp@suse.de>

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: linux-crypto@vger.kernel.org
---
 arch/x86/crypto/poly1305_glue.c     | 2 +-
 arch/x86/crypto/serpent_sse2_glue.c | 2 +-
 arch/x86/include/asm/cpufeature.h   | 1 -
 arch/x86/kernel/cpu/amd.c           | 2 +-
 arch/x86/kernel/cpu/intel.c         | 2 +-
 arch/x86/lib/usercopy_32.c          | 4 ++--
 6 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/crypto/poly1305_glue.c b/arch/x86/crypto/poly1305_glue.c
index 4264a3d59589..b283868acdf8 100644
--- a/arch/x86/crypto/poly1305_glue.c
+++ b/arch/x86/crypto/poly1305_glue.c
@@ -179,7 +179,7 @@ static struct shash_alg alg = {
 
 static int __init poly1305_simd_mod_init(void)
 {
-	if (!cpu_has_xmm2)
+	if (!boot_cpu_has(X86_FEATURE_XMM2))
 		return -ENODEV;
 
 #ifdef CONFIG_AS_AVX2
diff --git a/arch/x86/crypto/serpent_sse2_glue.c b/arch/x86/crypto/serpent_sse2_glue.c
index 8943407e8917..644f97ab8cac 100644
--- a/arch/x86/crypto/serpent_sse2_glue.c
+++ b/arch/x86/crypto/serpent_sse2_glue.c
@@ -600,7 +600,7 @@ static struct crypto_alg serpent_algs[10] = { {
 
 static int __init serpent_sse2_init(void)
 {
-	if (!cpu_has_xmm2) {
+	if (!boot_cpu_has(X86_FEATURE_XMM2)) {
 		printk(KERN_INFO "SSE2 instructions are not detected.\n");
 		return -ENODEV;
 	}
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index a75154232db5..5e02bc2e8444 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -125,7 +125,6 @@ extern const char * const x86_bug_flags[NBUGINTS*32];
 #define cpu_has_apic		boot_cpu_has(X86_FEATURE_APIC)
 #define cpu_has_fxsr		boot_cpu_has(X86_FEATURE_FXSR)
 #define cpu_has_xmm		boot_cpu_has(X86_FEATURE_XMM)
-#define cpu_has_xmm2		boot_cpu_has(X86_FEATURE_XMM2)
 #define cpu_has_aes		boot_cpu_has(X86_FEATURE_AES)
 #define cpu_has_avx		boot_cpu_has(X86_FEATURE_AVX)
 #define cpu_has_avx2		boot_cpu_has(X86_FEATURE_AVX2)
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 6e47e3a916f1..ea8f88a2a688 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -750,7 +750,7 @@ static void init_amd(struct cpuinfo_x86 *c)
 	if (c->x86 >= 0xf)
 		set_cpu_cap(c, X86_FEATURE_K8);
 
-	if (cpu_has_xmm2) {
+	if (cpu_has(c, X86_FEATURE_XMM2)) {
 		/* MFENCE stops RDTSC speculation */
 		set_cpu_cap(c, X86_FEATURE_MFENCE_RDTSC);
 	}
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 628a9f853b84..1dba36fe73e5 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -456,7 +456,7 @@ static void init_intel(struct cpuinfo_x86 *c)
 			set_cpu_cap(c, X86_FEATURE_ARCH_PERFMON);
 	}
 
-	if (cpu_has_xmm2)
+	if (cpu_has(c, X86_FEATURE_XMM2))
 		set_cpu_cap(c, X86_FEATURE_LFENCE_RDTSC);
 
 	if (boot_cpu_has(X86_FEATURE_DS)) {
diff --git a/arch/x86/lib/usercopy_32.c b/arch/x86/lib/usercopy_32.c
index 91d93b95bd86..b559d9238781 100644
--- a/arch/x86/lib/usercopy_32.c
+++ b/arch/x86/lib/usercopy_32.c
@@ -612,7 +612,7 @@ unsigned long __copy_from_user_ll_nocache(void *to, const void __user *from,
 {
 	stac();
 #ifdef CONFIG_X86_INTEL_USERCOPY
-	if (n > 64 && cpu_has_xmm2)
+	if (n > 64 && static_cpu_has(X86_FEATURE_XMM2))
 		n = __copy_user_zeroing_intel_nocache(to, from, n);
 	else
 		__copy_user_zeroing(to, from, n);
@@ -629,7 +629,7 @@ unsigned long __copy_from_user_ll_nocache_nozero(void *to, const void __user *fr
 {
 	stac();
 #ifdef CONFIG_X86_INTEL_USERCOPY
-	if (n > 64 && cpu_has_xmm2)
+	if (n > 64 && static_cpu_has(X86_FEATURE_XMM2))
 		n = __copy_user_intel_nocache(to, from, n);
 	else
 		__copy_user(to, from, n);
-- 
2.7.3
