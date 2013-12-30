From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1] crypto: aesni - fix build on x86 (32bit)
Date: Mon, 30 Dec 2013 15:52:24 +0200
Message-ID: <1388411544-4559-1-git-send-email-andriy.shevchenko@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Borislav Petkov <bp@alien8.de>, hpa@zytor.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:33699 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755914Ab3L3Nw7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 30 Dec 2013 08:52:59 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

It seems commit d764593a "crypto: aesni - AVX and AVX2 version of AESNI-GCM
encode and decode" breaks a build on x86_32 since it's designed only for
x86_64. This patch makes a compilation unit conditional to CONFIG_64BIT and
functions usage to CONFIG_X86_64.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 arch/x86/crypto/Makefile           | 3 ++-
 arch/x86/crypto/aesni-intel_glue.c | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index 84ee1e1..188b993 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -75,7 +75,8 @@ ifeq ($(avx2_supported),yes)
 	serpent-avx2-y := serpent-avx2-asm_64.o serpent_avx2_glue.o
 endif
 
-aesni-intel-y := aesni-intel_asm.o aesni-intel_avx.o aesni-intel_glue.o fpu.o
+aesni-intel-y := aesni-intel_asm.o aesni-intel_glue.o fpu.o
+aesni-intel-$(CONFIG_64BIT) += aesni-intel_avx.o
 ghash-clmulni-intel-y := ghash-clmulni-intel_asm.o ghash-clmulni-intel_glue.o
 sha1-ssse3-y := sha1_ssse3_asm.o sha1_ssse3_glue.o
 crc32c-intel-y := crc32c-intel_glue.o
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 3ae311d..948ad0e 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -1473,6 +1473,7 @@ static int __init aesni_init(void)
 
 	if (!x86_match_cpu(aesni_cpu_id))
 		return -ENODEV;
+#ifdef CONFIG_X86_64
 #ifdef CONFIG_AS_AVX2
 	if (boot_cpu_has(X86_FEATURE_AVX2)) {
 		pr_info("AVX2 version of gcm_enc/dec engaged.\n");
@@ -1492,6 +1493,7 @@ static int __init aesni_init(void)
 		aesni_gcm_enc_tfm = aesni_gcm_enc;
 		aesni_gcm_dec_tfm = aesni_gcm_dec;
 	}
+#endif
 
 	err = crypto_fpu_init();
 	if (err)
-- 
1.8.5.2
