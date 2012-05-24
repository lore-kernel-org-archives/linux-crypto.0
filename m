From: Mathias Krause <minipli@googlemail.com>
Subject: [PATCH] crypto: sha1 - use Kbuild supplied flags for AVX test
Date: Thu, 24 May 2012 11:13:42 +0200
Message-ID: <1337850822-1855-1-git-send-email-minipli@googlemail.com>
Cc: linux-crypto@vger.kernel.org,
	Mathias Krause <minipli@googlemail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from grimli.r00tworld.net ([83.169.44.195]:59373 "EHLO
	mail.r00tworld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625Ab2EXJVx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 24 May 2012 05:21:53 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Commit ea4d26ae ("raid5: add AVX optimized RAID5 checksumming")
introduced x86/ arch wide defines for AFLAGS and CFLAGS indicating AVX
support in binutils based on the same test we have in x86/crypto/ right
now. To minimize duplication drop our implementation in favour to the
one in x86/.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---

This should be applied to cryptodev-2.6.git after it contains the above
mentioned commit, e.g. after cryptodev-2.6.git rebased to/merged v3.5-rc1.

 arch/x86/crypto/Makefile          |    7 -------
 arch/x86/crypto/sha1_ssse3_asm.S  |    2 +-
 arch/x86/crypto/sha1_ssse3_glue.c |    6 +++---
 3 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index e191ac0..479f95a 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -34,12 +34,5 @@ salsa20-x86_64-y := salsa20-x86_64-asm_64.o salsa20_glue.o
 serpent-sse2-x86_64-y := serpent-sse2-x86_64-asm_64.o serpent_sse2_glue.o
 
 aesni-intel-y := aesni-intel_asm.o aesni-intel_glue.o fpu.o
-
 ghash-clmulni-intel-y := ghash-clmulni-intel_asm.o ghash-clmulni-intel_glue.o
-
-# enable AVX support only when $(AS) can actually assemble the instructions
-ifeq ($(call as-instr,vpxor %xmm0$(comma)%xmm1$(comma)%xmm2,yes,no),yes)
-AFLAGS_sha1_ssse3_asm.o += -DSHA1_ENABLE_AVX_SUPPORT
-CFLAGS_sha1_ssse3_glue.o += -DSHA1_ENABLE_AVX_SUPPORT
-endif
 sha1-ssse3-y := sha1_ssse3_asm.o sha1_ssse3_glue.o
diff --git a/arch/x86/crypto/sha1_ssse3_asm.S b/arch/x86/crypto/sha1_ssse3_asm.S
index b2c2f57..49d6987 100644
--- a/arch/x86/crypto/sha1_ssse3_asm.S
+++ b/arch/x86/crypto/sha1_ssse3_asm.S
@@ -468,7 +468,7 @@ W_PRECALC_SSSE3
  */
 SHA1_VECTOR_ASM     sha1_transform_ssse3
 
-#ifdef SHA1_ENABLE_AVX_SUPPORT
+#ifdef CONFIG_AS_AVX
 
 .macro W_PRECALC_AVX
 
diff --git a/arch/x86/crypto/sha1_ssse3_glue.c b/arch/x86/crypto/sha1_ssse3_glue.c
index f916499..4a11a9d 100644
--- a/arch/x86/crypto/sha1_ssse3_glue.c
+++ b/arch/x86/crypto/sha1_ssse3_glue.c
@@ -35,7 +35,7 @@
 
 asmlinkage void sha1_transform_ssse3(u32 *digest, const char *data,
 				     unsigned int rounds);
-#ifdef SHA1_ENABLE_AVX_SUPPORT
+#ifdef CONFIG_AS_AVX
 asmlinkage void sha1_transform_avx(u32 *digest, const char *data,
 				   unsigned int rounds);
 #endif
@@ -184,7 +184,7 @@ static struct shash_alg alg = {
 	}
 };
 
-#ifdef SHA1_ENABLE_AVX_SUPPORT
+#ifdef CONFIG_AS_AVX
 static bool __init avx_usable(void)
 {
 	u64 xcr0;
@@ -209,7 +209,7 @@ static int __init sha1_ssse3_mod_init(void)
 	if (cpu_has_ssse3)
 		sha1_transform_asm = sha1_transform_ssse3;
 
-#ifdef SHA1_ENABLE_AVX_SUPPORT
+#ifdef CONFIG_AS_AVX
 	/* allow AVX to override SSSE3, it's a little faster */
 	if (avx_usable())
 		sha1_transform_asm = sha1_transform_avx;
-- 
1.5.6.5
