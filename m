From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] crypto: arm: workaround for building with old binutils
Date: Fri, 10 Apr 2015 21:57:39 +0200
Message-ID: <3461827.FYLMCAIQyv@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Russell King <linux@arm.linux.org.uk>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:60588 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298AbbDJT6B (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 10 Apr 2015 15:58:01 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Old versions of binutils (before 2.23) do not yet understand the
crypto-neon-fp-armv8 fpu instructions, and an attempt to build these
files results in a build failure:

arch/arm/crypto/aes-ce-core.S:133: Error: selected processor does not support ARM mode `vld1.8 {q10-q11},[ip]!'
arch/arm/crypto/aes-ce-core.S:133: Error: bad instruction `aese.8 q0,q8'
arch/arm/crypto/aes-ce-core.S:133: Error: bad instruction `aesmc.8 q0,q0'
arch/arm/crypto/aes-ce-core.S:133: Error: bad instruction `aese.8 q0,q9'
arch/arm/crypto/aes-ce-core.S:133: Error: bad instruction `aesmc.8 q0,q0'

Since the affected versions are still in widespread use, and this breaks
'allmodconfig' builds, we should try to at least get a successful kernel
build. Unfortunately, I could not come up with a way to make the Kconfig
symbol depend on the binutils version, which would be the nicest solution.

This patch uses the 'as-option' Kbuild macro to find out whether the
support is present in the assembler, and otherwise passes a macro
definition to each affected file, which in turn disables that code
entirely and results in empty modules.

In order to help users figure out what to do, we also add a #warning
state in place of the removed to that tells users which version to use.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: http://storage.kernelci.org/next/next-20150410/arm-allmodconfig/build.log
Fixes: 864cbeed4ab22d ("crypto: arm - add support for SHA1 using ARMv8 Crypto Instructions")

diff --git a/arch/arm/crypto/Makefile b/arch/arm/crypto/Makefile
index ef46e898f98b..60f2101e0586 100644
--- a/arch/arm/crypto/Makefile
+++ b/arch/arm/crypto/Makefile
@@ -25,6 +25,10 @@ sha2-arm-ce-y	:= sha2-ce-core.o sha2-ce-glue.o
 aes-arm-ce-y	:= aes-ce-core.o aes-ce-glue.o
 ghash-arm-ce-y	:= ghash-ce-core.o ghash-ce-glue.o
 
+armv8-ce-flags	:= $(call as-option,-Wa$(comma)-mfpu=crypto-neon-fp-armv8,-DARMV8_CE_DISABLED)
+asflags-y := $(armv8-ce-flags)
+ccflags-y := $(armv8-ce-flags)
+
 quiet_cmd_perl = PERL    $@
       cmd_perl = $(PERL) $(<) > $(@)
 
diff --git a/arch/arm/crypto/aes-ce-core.S b/arch/arm/crypto/aes-ce-core.S
index 8cfa468ee570..f2132ba91353 100644
--- a/arch/arm/crypto/aes-ce-core.S
+++ b/arch/arm/crypto/aes-ce-core.S
@@ -8,11 +8,14 @@
  * published by the Free Software Foundation.
  */
 
+#ifdef ARMV8_CE_DISABLED
+#warning ARMv8 Crypto Extensions need binutils 2.23 or higher
+#else
+
 #include <linux/linkage.h>
 #include <asm/assembler.h>
 
 	.text
-	.fpu		crypto-neon-fp-armv8
 	.align		3
 
 	.macro		enc_round, state, key
@@ -516,3 +519,5 @@ ENTRY(ce_aes_invert)
 	vst1.8		{q0}, [r0]
 	bx		lr
 ENDPROC(ce_aes_invert)
+
+#endif
diff --git a/arch/arm/crypto/aes-ce-glue.c b/arch/arm/crypto/aes-ce-glue.c
index b445a5d56f43..4cba201a64a9 100644
--- a/arch/arm/crypto/aes-ce-glue.c
+++ b/arch/arm/crypto/aes-ce-glue.c
@@ -510,13 +510,16 @@ static struct crypto_alg aes_algs[] = { {
 
 static int __init aes_init(void)
 {
-	if (!(elf_hwcap2 & HWCAP2_AES))
+	if (IS_ENABLED(ARMV8_CE_DISABLED) || !(elf_hwcap2 & HWCAP2_AES))
 		return -ENODEV;
 	return crypto_register_algs(aes_algs, ARRAY_SIZE(aes_algs));
 }
 
 static void __exit aes_exit(void)
 {
+	if (IS_ENABLED(ARMV8_CE_DISABLED))
+		return;
+
 	crypto_unregister_algs(aes_algs, ARRAY_SIZE(aes_algs));
 }
 
diff --git a/arch/arm/crypto/ghash-ce-core.S b/arch/arm/crypto/ghash-ce-core.S
index f6ab8bcc9efe..4fe75df41162 100644
--- a/arch/arm/crypto/ghash-ce-core.S
+++ b/arch/arm/crypto/ghash-ce-core.S
@@ -8,6 +8,10 @@
  * by the Free Software Foundation.
  */
 
+#ifdef ARMV8_CE_DISABLED
+#warning ARMv8 Crypto Extensions need binutils 2.23 or higher
+#else
+
 #include <linux/linkage.h>
 #include <asm/assembler.h>
 
@@ -33,8 +37,6 @@
 	XH_L		.req	d14
 
 	.text
-	.fpu		crypto-neon-fp-armv8
-
 	/*
 	 * void pmull_ghash_update(int blocks, u64 dg[], const char *src,
 	 *			   struct ghash_key const *k, const char *head)
@@ -92,3 +94,5 @@ ENTRY(pmull_ghash_update)
 	vst1.64		{XL}, [r1]
 	bx		lr
 ENDPROC(pmull_ghash_update)
+
+#endif
diff --git a/arch/arm/crypto/ghash-ce-glue.c b/arch/arm/crypto/ghash-ce-glue.c
index 03a39fe29246..880afe904e5d 100644
--- a/arch/arm/crypto/ghash-ce-glue.c
+++ b/arch/arm/crypto/ghash-ce-glue.c
@@ -293,7 +293,7 @@ static int __init ghash_ce_mod_init(void)
 {
 	int err;
 
-	if (!(elf_hwcap2 & HWCAP2_PMULL))
+	if (IS_ENABLED(ARMV8_CE_DISABLED) || !(elf_hwcap2 & HWCAP2_AES))
 		return -ENODEV;
 
 	err = crypto_register_shash(&ghash_alg);
@@ -312,6 +312,9 @@ err_shash:
 
 static void __exit ghash_ce_mod_exit(void)
 {
+	if (IS_ENABLED(ARMV8_CE_DISABLED))
+		return;
+
 	crypto_unregister_ahash(&ghash_async_alg);
 	crypto_unregister_shash(&ghash_alg);
 }
diff --git a/arch/arm/crypto/sha1-ce-core.S b/arch/arm/crypto/sha1-ce-core.S
index 4aad520935d8..ab0fe554a6cf 100644
--- a/arch/arm/crypto/sha1-ce-core.S
+++ b/arch/arm/crypto/sha1-ce-core.S
@@ -9,11 +9,14 @@
  * published by the Free Software Foundation.
  */
 
+#ifdef ARMV8_CE_DISABLED
+#warning ARMv8 Crypto Extensions need binutils 2.23 or higher
+#else
+
 #include <linux/linkage.h>
 #include <asm/assembler.h>
 
 	.text
-	.fpu		crypto-neon-fp-armv8
 
 	k0		.req	q0
 	k1		.req	q1
@@ -132,3 +135,5 @@ ENTRY(sha1_ce_transform)
 	vstr		dgbs, [r2, #16]
 	bx		lr
 ENDPROC(sha1_ce_transform)
+
+#endif
diff --git a/arch/arm/crypto/sha1-ce-glue.c b/arch/arm/crypto/sha1-ce-glue.c
index a9dd90df9fd7..045cabad9296 100644
--- a/arch/arm/crypto/sha1-ce-glue.c
+++ b/arch/arm/crypto/sha1-ce-glue.c
@@ -136,13 +136,16 @@ static struct shash_alg alg = {
 
 static int __init sha1_ce_mod_init(void)
 {
-	if (!(elf_hwcap2 & HWCAP2_SHA1))
+	if (IS_ENABLED(ARMV8_CE_DISABLED) || !(elf_hwcap2 & HWCAP2_AES))
 		return -ENODEV;
 	return crypto_register_shash(&alg);
 }
 
 static void __exit sha1_ce_mod_fini(void)
 {
+	if (IS_ENABLED(ARMV8_CE_DISABLED))
+		return;
+
 	crypto_unregister_shash(&alg);
 }
 
diff --git a/arch/arm/crypto/sha2-ce-core.S b/arch/arm/crypto/sha2-ce-core.S
index 96af09fe957b..3db821c5f4cd 100644
--- a/arch/arm/crypto/sha2-ce-core.S
+++ b/arch/arm/crypto/sha2-ce-core.S
@@ -9,11 +9,14 @@
  * published by the Free Software Foundation.
  */
 
+#ifdef ARMV8_CE_DISABLED
+#warning ARMv8 Crypto Extensions need binutils 2.23 or higher
+#else
+
 #include <linux/linkage.h>
 #include <asm/assembler.h>
 
 	.text
-	.fpu		crypto-neon-fp-armv8
 
 	k0		.req	q7
 	k1		.req	q8
@@ -132,3 +135,5 @@ ENTRY(sha2_ce_transform)
 	vst1.32		{dga-dgb}, [r2]
 	bx		lr
 ENDPROC(sha2_ce_transform)
+
+#endif
diff --git a/arch/arm/crypto/sha2-ce-glue.c b/arch/arm/crypto/sha2-ce-glue.c
index 0449eca3aab3..3f8010837310 100644
--- a/arch/arm/crypto/sha2-ce-glue.c
+++ b/arch/arm/crypto/sha2-ce-glue.c
@@ -189,13 +189,16 @@ static struct shash_alg algs[] = { {
 
 static int __init sha2_ce_mod_init(void)
 {
-	if (!(elf_hwcap2 & HWCAP2_SHA2))
+	if (IS_ENABLED(ARMV8_CE_DISABLED) || !(elf_hwcap2 & HWCAP2_AES))
 		return -ENODEV;
 	return crypto_register_shashes(algs, ARRAY_SIZE(algs));
 }
 
 static void __exit sha2_ce_mod_fini(void)
 {
+	if (IS_ENABLED(ARMV8_CE_DISABLED))
+		return;
+
 	crypto_unregister_shashes(algs, ARRAY_SIZE(algs));
 }
 
