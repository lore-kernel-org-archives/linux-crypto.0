From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 6/6] arm/crypto: accelerated SHA-512 using ARM generic ASM and NEON
Date: Sat, 28 Mar 2015 23:10:28 +0100
Message-ID: <1427580628-7128-7-git-send-email-ard.biesheuvel@linaro.org>
References: <1427580628-7128-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	samitolvanen@google.com, herbert@gondor.apana.org.au,
	jussi.kivilinna@iki.fi
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38676 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbbC1WMC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 28 Mar 2015 18:12:02 -0400
Received: by wibgn9 with SMTP id gn9so76066782wib.1
        for <linux-crypto@vger.kernel.org>; Sat, 28 Mar 2015 15:12:00 -0700 (PDT)
In-Reply-To: <1427580628-7128-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This updates the SHA-512 NEON module with the faster and more
versatile implementation from the OpenSSL project. It consists
of both a NEON and a generic ASM version of the core SHA-512
transform, where the NEON version reverts to the ASM version
when invoked in non-process context.

Performance relative to the generic implementation (measured
using tcrypt.ko mode=306 sec=1 running on a Cortex-A57 under
KVM):

  input size	block size	asm	neon	old neon

  16		16		1.39	2.54	2.21
  64		16		1.32	2.33	2.09
  64		64		1.38	2.53	2.19
  256		16		1.31	2.28	2.06
  256		64		1.38	2.54	2.25
  256		256		1.40	2.77	2.39
  1024		16		1.29	2.22	2.01
  1024		256		1.40	2.82	2.45
  1024		1024		1.41	2.93	2.53
  2048		16		1.33	2.21	2.00
  2048		256		1.40	2.84	2.46
  2048		1024		1.41	2.96	2.55
  2048		2048		1.41	2.98	2.56
  4096		16		1.34	2.20	1.99
  4096		256		1.40	2.84	2.46
  4096		1024		1.41	2.97	2.56
  4096		4096		1.41	3.01	2.58
  8192		16		1.34	2.19	1.99
  8192		256		1.40	2.85	2.47
  8192		1024		1.41	2.98	2.56
  8192		4096		1.41	2.71	2.59
  8192		8192		1.51	3.51	2.69

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/Kconfig               |    8 +
 arch/arm/crypto/Makefile              |    8 +-
 arch/arm/crypto/sha512-armv4.pl       |  656 ++++++++++++
 arch/arm/crypto/sha512-core.S_shipped | 1814 +++++++++++++++++++++++++++++++++
 arch/arm/crypto/sha512-glue.c         |  137 +++
 arch/arm/crypto/sha512-neon-glue.c    |  111 ++
 arch/arm/crypto/sha512.h              |    8 +
 7 files changed, 2741 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/crypto/sha512-armv4.pl
 create mode 100644 arch/arm/crypto/sha512-core.S_shipped
 create mode 100644 arch/arm/crypto/sha512-glue.c
 create mode 100644 arch/arm/crypto/sha512-neon-glue.c
 create mode 100644 arch/arm/crypto/sha512.h

diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
index 458729d2ce22..6b50c6d77b77 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -53,6 +53,14 @@ config CRYPTO_SHA256_ARM
 	  SHA-256 secure hash standard (DFIPS 180-2) implemented
 	  using optimized ARM assembler and NEON, when available.
 
+config CRYPTO_SHA512_ARM
+	tristate "SHA-384/512 digest algorithm (ARM-asm and NEON)"
+	select CRYPTO_HASH
+	select CRYPTO_SHA512_BASE
+	help
+	  SHA-512 secure hash standard (DFIPS 180-2) implemented
+	  using optimized ARM assembler and NEON, when available.
+
 config CRYPTO_SHA512_ARM_NEON
 	tristate "SHA384 and SHA512 digest algorithm (ARM NEON)"
 	depends on KERNEL_MODE_NEON
diff --git a/arch/arm/crypto/Makefile b/arch/arm/crypto/Makefile
index ef46e898f98b..322a6ca999a2 100644
--- a/arch/arm/crypto/Makefile
+++ b/arch/arm/crypto/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_CRYPTO_AES_ARM_CE) += aes-arm-ce.o
 obj-$(CONFIG_CRYPTO_SHA1_ARM) += sha1-arm.o
 obj-$(CONFIG_CRYPTO_SHA1_ARM_NEON) += sha1-arm-neon.o
 obj-$(CONFIG_CRYPTO_SHA256_ARM) += sha256-arm.o
+obj-$(CONFIG_CRYPTO_SHA512_ARM) += sha512-arm.o
 obj-$(CONFIG_CRYPTO_SHA512_ARM_NEON) += sha512-arm-neon.o
 obj-$(CONFIG_CRYPTO_SHA1_ARM_CE) += sha1-arm-ce.o
 obj-$(CONFIG_CRYPTO_SHA2_ARM_CE) += sha2-arm-ce.o
@@ -19,6 +20,8 @@ sha1-arm-y	:= sha1-armv4-large.o sha1_glue.o
 sha1-arm-neon-y	:= sha1-armv7-neon.o sha1_neon_glue.o
 sha256-arm-neon-$(CONFIG_KERNEL_MODE_NEON) := sha256_neon_glue.o
 sha256-arm-y	:= sha256-core.o sha256_glue.o $(sha256-arm-neon-y)
+sha512-arm-neon-$(CONFIG_KERNEL_MODE_NEON) := sha512-neon-glue.o
+sha512-arm-y	:= sha512-core.o sha512-glue.o $(sha512-arm-neon-y)
 sha512-arm-neon-y := sha512-armv7-neon.o sha512_neon_glue.o
 sha1-arm-ce-y	:= sha1-ce-core.o sha1-ce-glue.o
 sha2-arm-ce-y	:= sha2-ce-core.o sha2-ce-glue.o
@@ -34,4 +37,7 @@ $(src)/aesbs-core.S_shipped: $(src)/bsaes-armv7.pl
 $(src)/sha256-core.S_shipped: $(src)/sha256-armv4.pl
 	$(call cmd,perl)
 
-.PRECIOUS: $(obj)/aesbs-core.S $(obj)/sha256-core.S
+$(src)/sha512-core.S_shipped: $(src)/sha512-armv4.pl
+	$(call cmd,perl)
+
+.PRECIOUS: $(obj)/aesbs-core.S $(obj)/sha256-core.S $(obj)/sha512-core.S
diff --git a/arch/arm/crypto/sha512-armv4.pl b/arch/arm/crypto/sha512-armv4.pl
new file mode 100644
index 000000000000..7e540f8439da
--- /dev/null
+++ b/arch/arm/crypto/sha512-armv4.pl
@@ -0,0 +1,656 @@
+#!/usr/bin/env perl
+
+# ====================================================================
+# Written by Andy Polyakov <appro@openssl.org> for the OpenSSL
+# project. The module is, however, dual licensed under OpenSSL and
+# CRYPTOGAMS licenses depending on where you obtain it. For further
+# details see http://www.openssl.org/~appro/cryptogams/.
+#
+# Permission to use under GPL terms is granted.
+# ====================================================================
+
+# SHA512 block procedure for ARMv4. September 2007.
+
+# This code is ~4.5 (four and a half) times faster than code generated
+# by gcc 3.4 and it spends ~72 clock cycles per byte [on single-issue
+# Xscale PXA250 core].
+#
+# July 2010.
+#
+# Rescheduling for dual-issue pipeline resulted in 6% improvement on
+# Cortex A8 core and ~40 cycles per processed byte.
+
+# February 2011.
+#
+# Profiler-assisted and platform-specific optimization resulted in 7%
+# improvement on Coxtex A8 core and ~38 cycles per byte.
+
+# March 2011.
+#
+# Add NEON implementation. On Cortex A8 it was measured to process
+# one byte in 23.3 cycles or ~60% faster than integer-only code.
+
+# August 2012.
+#
+# Improve NEON performance by 12% on Snapdragon S4. In absolute
+# terms it's 22.6 cycles per byte, which is disappointing result.
+# Technical writers asserted that 3-way S4 pipeline can sustain
+# multiple NEON instructions per cycle, but dual NEON issue could
+# not be observed, and for NEON-only sequences IPC(*) was found to
+# be limited by 1:-( 0.33 and 0.66 were measured for sequences with
+# ILPs(*) of 1 and 2 respectively. This in turn means that you can
+# even find yourself striving, as I did here, for achieving IPC
+# adequate to one delivered by Cortex A8 [for reference, it's
+# 0.5 for ILP of 1, and 1 for higher ILPs].
+#
+# (*) ILP, instruction-level parallelism, how many instructions
+#     *can* execute at the same time. IPC, instructions per cycle,
+#     indicates how many instructions actually execute.
+
+# Byte order [in]dependence. =========================================
+#
+# Originally caller was expected to maintain specific *dword* order in
+# h[0-7], namely with most significant dword at *lower* address, which
+# was reflected in below two parameters as 0 and 4. Now caller is
+# expected to maintain native byte order for whole 64-bit values.
+$hi="HI";
+$lo="LO";
+# ====================================================================
+
+while (($output=shift) && ($output!~/^\w[\w\-]*\.\w+$/)) {}
+open STDOUT,">$output";
+
+$ctx="r0";	# parameter block
+$inp="r1";
+$len="r2";
+
+$Tlo="r3";
+$Thi="r4";
+$Alo="r5";
+$Ahi="r6";
+$Elo="r7";
+$Ehi="r8";
+$t0="r9";
+$t1="r10";
+$t2="r11";
+$t3="r12";
+############	r13 is stack pointer
+$Ktbl="r14";
+############	r15 is program counter
+
+$Aoff=8*0;
+$Boff=8*1;
+$Coff=8*2;
+$Doff=8*3;
+$Eoff=8*4;
+$Foff=8*5;
+$Goff=8*6;
+$Hoff=8*7;
+$Xoff=8*8;
+
+sub BODY_00_15() {
+my $magic = shift;
+$code.=<<___;
+	@ Sigma1(x)	(ROTR((x),14) ^ ROTR((x),18)  ^ ROTR((x),41))
+	@ LO		lo>>14^hi<<18 ^ lo>>18^hi<<14 ^ hi>>9^lo<<23
+	@ HI		hi>>14^lo<<18 ^ hi>>18^lo<<14 ^ lo>>9^hi<<23
+	mov	$t0,$Elo,lsr#14
+	str	$Tlo,[sp,#$Xoff+0]
+	mov	$t1,$Ehi,lsr#14
+	str	$Thi,[sp,#$Xoff+4]
+	eor	$t0,$t0,$Ehi,lsl#18
+	ldr	$t2,[sp,#$Hoff+0]	@ h.lo
+	eor	$t1,$t1,$Elo,lsl#18
+	ldr	$t3,[sp,#$Hoff+4]	@ h.hi
+	eor	$t0,$t0,$Elo,lsr#18
+	eor	$t1,$t1,$Ehi,lsr#18
+	eor	$t0,$t0,$Ehi,lsl#14
+	eor	$t1,$t1,$Elo,lsl#14
+	eor	$t0,$t0,$Ehi,lsr#9
+	eor	$t1,$t1,$Elo,lsr#9
+	eor	$t0,$t0,$Elo,lsl#23
+	eor	$t1,$t1,$Ehi,lsl#23	@ Sigma1(e)
+	adds	$Tlo,$Tlo,$t0
+	ldr	$t0,[sp,#$Foff+0]	@ f.lo
+	adc	$Thi,$Thi,$t1		@ T += Sigma1(e)
+	ldr	$t1,[sp,#$Foff+4]	@ f.hi
+	adds	$Tlo,$Tlo,$t2
+	ldr	$t2,[sp,#$Goff+0]	@ g.lo
+	adc	$Thi,$Thi,$t3		@ T += h
+	ldr	$t3,[sp,#$Goff+4]	@ g.hi
+
+	eor	$t0,$t0,$t2
+	str	$Elo,[sp,#$Eoff+0]
+	eor	$t1,$t1,$t3
+	str	$Ehi,[sp,#$Eoff+4]
+	and	$t0,$t0,$Elo
+	str	$Alo,[sp,#$Aoff+0]
+	and	$t1,$t1,$Ehi
+	str	$Ahi,[sp,#$Aoff+4]
+	eor	$t0,$t0,$t2
+	ldr	$t2,[$Ktbl,#$lo]	@ K[i].lo
+	eor	$t1,$t1,$t3		@ Ch(e,f,g)
+	ldr	$t3,[$Ktbl,#$hi]	@ K[i].hi
+
+	adds	$Tlo,$Tlo,$t0
+	ldr	$Elo,[sp,#$Doff+0]	@ d.lo
+	adc	$Thi,$Thi,$t1		@ T += Ch(e,f,g)
+	ldr	$Ehi,[sp,#$Doff+4]	@ d.hi
+	adds	$Tlo,$Tlo,$t2
+	and	$t0,$t2,#0xff
+	adc	$Thi,$Thi,$t3		@ T += K[i]
+	adds	$Elo,$Elo,$Tlo
+	ldr	$t2,[sp,#$Boff+0]	@ b.lo
+	adc	$Ehi,$Ehi,$Thi		@ d += T
+	teq	$t0,#$magic
+
+	ldr	$t3,[sp,#$Coff+0]	@ c.lo
+#if __ARM_ARCH__>=7
+	it	eq			@ Thumb2 thing, sanity check in ARM
+#endif
+	orreq	$Ktbl,$Ktbl,#1
+	@ Sigma0(x)	(ROTR((x),28) ^ ROTR((x),34) ^ ROTR((x),39))
+	@ LO		lo>>28^hi<<4  ^ hi>>2^lo<<30 ^ hi>>7^lo<<25
+	@ HI		hi>>28^lo<<4  ^ lo>>2^hi<<30 ^ lo>>7^hi<<25
+	mov	$t0,$Alo,lsr#28
+	mov	$t1,$Ahi,lsr#28
+	eor	$t0,$t0,$Ahi,lsl#4
+	eor	$t1,$t1,$Alo,lsl#4
+	eor	$t0,$t0,$Ahi,lsr#2
+	eor	$t1,$t1,$Alo,lsr#2
+	eor	$t0,$t0,$Alo,lsl#30
+	eor	$t1,$t1,$Ahi,lsl#30
+	eor	$t0,$t0,$Ahi,lsr#7
+	eor	$t1,$t1,$Alo,lsr#7
+	eor	$t0,$t0,$Alo,lsl#25
+	eor	$t1,$t1,$Ahi,lsl#25	@ Sigma0(a)
+	adds	$Tlo,$Tlo,$t0
+	and	$t0,$Alo,$t2
+	adc	$Thi,$Thi,$t1		@ T += Sigma0(a)
+
+	ldr	$t1,[sp,#$Boff+4]	@ b.hi
+	orr	$Alo,$Alo,$t2
+	ldr	$t2,[sp,#$Coff+4]	@ c.hi
+	and	$Alo,$Alo,$t3
+	and	$t3,$Ahi,$t1
+	orr	$Ahi,$Ahi,$t1
+	orr	$Alo,$Alo,$t0		@ Maj(a,b,c).lo
+	and	$Ahi,$Ahi,$t2
+	adds	$Alo,$Alo,$Tlo
+	orr	$Ahi,$Ahi,$t3		@ Maj(a,b,c).hi
+	sub	sp,sp,#8
+	adc	$Ahi,$Ahi,$Thi		@ h += T
+	tst	$Ktbl,#1
+	add	$Ktbl,$Ktbl,#8
+___
+}
+$code=<<___;
+#ifndef __KERNEL__
+# include "arm_arch.h"
+# define VFP_ABI_PUSH	vstmdb	sp!,{d8-d15}
+# define VFP_ABI_POP	vldmia	sp!,{d8-d15}
+#else
+# define __ARM_ARCH__ __LINUX_ARM_ARCH__
+# define __ARM_MAX_ARCH__ 7
+# define VFP_ABI_PUSH
+# define VFP_ABI_POP
+#endif
+
+#ifdef __ARMEL__
+# define LO 0
+# define HI 4
+# define WORD64(hi0,lo0,hi1,lo1)	.word	lo0,hi0, lo1,hi1
+#else
+# define HI 0
+# define LO 4
+# define WORD64(hi0,lo0,hi1,lo1)	.word	hi0,lo0, hi1,lo1
+#endif
+
+.text
+#if __ARM_ARCH__<7
+.code	32
+#else
+.syntax unified
+# ifdef __thumb2__
+#  define adrl adr
+.thumb
+# else
+.code   32
+# endif
+#endif
+
+.type	K512,%object
+.align	5
+K512:
+WORD64(0x428a2f98,0xd728ae22, 0x71374491,0x23ef65cd)
+WORD64(0xb5c0fbcf,0xec4d3b2f, 0xe9b5dba5,0x8189dbbc)
+WORD64(0x3956c25b,0xf348b538, 0x59f111f1,0xb605d019)
+WORD64(0x923f82a4,0xaf194f9b, 0xab1c5ed5,0xda6d8118)
+WORD64(0xd807aa98,0xa3030242, 0x12835b01,0x45706fbe)
+WORD64(0x243185be,0x4ee4b28c, 0x550c7dc3,0xd5ffb4e2)
+WORD64(0x72be5d74,0xf27b896f, 0x80deb1fe,0x3b1696b1)
+WORD64(0x9bdc06a7,0x25c71235, 0xc19bf174,0xcf692694)
+WORD64(0xe49b69c1,0x9ef14ad2, 0xefbe4786,0x384f25e3)
+WORD64(0x0fc19dc6,0x8b8cd5b5, 0x240ca1cc,0x77ac9c65)
+WORD64(0x2de92c6f,0x592b0275, 0x4a7484aa,0x6ea6e483)
+WORD64(0x5cb0a9dc,0xbd41fbd4, 0x76f988da,0x831153b5)
+WORD64(0x983e5152,0xee66dfab, 0xa831c66d,0x2db43210)
+WORD64(0xb00327c8,0x98fb213f, 0xbf597fc7,0xbeef0ee4)
+WORD64(0xc6e00bf3,0x3da88fc2, 0xd5a79147,0x930aa725)
+WORD64(0x06ca6351,0xe003826f, 0x14292967,0x0a0e6e70)
+WORD64(0x27b70a85,0x46d22ffc, 0x2e1b2138,0x5c26c926)
+WORD64(0x4d2c6dfc,0x5ac42aed, 0x53380d13,0x9d95b3df)
+WORD64(0x650a7354,0x8baf63de, 0x766a0abb,0x3c77b2a8)
+WORD64(0x81c2c92e,0x47edaee6, 0x92722c85,0x1482353b)
+WORD64(0xa2bfe8a1,0x4cf10364, 0xa81a664b,0xbc423001)
+WORD64(0xc24b8b70,0xd0f89791, 0xc76c51a3,0x0654be30)
+WORD64(0xd192e819,0xd6ef5218, 0xd6990624,0x5565a910)
+WORD64(0xf40e3585,0x5771202a, 0x106aa070,0x32bbd1b8)
+WORD64(0x19a4c116,0xb8d2d0c8, 0x1e376c08,0x5141ab53)
+WORD64(0x2748774c,0xdf8eeb99, 0x34b0bcb5,0xe19b48a8)
+WORD64(0x391c0cb3,0xc5c95a63, 0x4ed8aa4a,0xe3418acb)
+WORD64(0x5b9cca4f,0x7763e373, 0x682e6ff3,0xd6b2b8a3)
+WORD64(0x748f82ee,0x5defb2fc, 0x78a5636f,0x43172f60)
+WORD64(0x84c87814,0xa1f0ab72, 0x8cc70208,0x1a6439ec)
+WORD64(0x90befffa,0x23631e28, 0xa4506ceb,0xde82bde9)
+WORD64(0xbef9a3f7,0xb2c67915, 0xc67178f2,0xe372532b)
+WORD64(0xca273ece,0xea26619c, 0xd186b8c7,0x21c0c207)
+WORD64(0xeada7dd6,0xcde0eb1e, 0xf57d4f7f,0xee6ed178)
+WORD64(0x06f067aa,0x72176fba, 0x0a637dc5,0xa2c898a6)
+WORD64(0x113f9804,0xbef90dae, 0x1b710b35,0x131c471b)
+WORD64(0x28db77f5,0x23047d84, 0x32caab7b,0x40c72493)
+WORD64(0x3c9ebe0a,0x15c9bebc, 0x431d67c4,0x9c100d4c)
+WORD64(0x4cc5d4be,0xcb3e42b6, 0x597f299c,0xfc657e2a)
+WORD64(0x5fcb6fab,0x3ad6faec, 0x6c44198c,0x4a475817)
+.size	K512,.-K512
+#if __ARM_MAX_ARCH__>=7 && !defined(__KERNEL__)
+.LOPENSSL_armcap:
+.word	OPENSSL_armcap_P-sha512_block_data_order
+.skip	32-4
+#else
+.skip	32
+#endif
+
+.global	sha512_block_data_order
+.type	sha512_block_data_order,%function
+sha512_block_data_order:
+#if __ARM_ARCH__<7
+	sub	r3,pc,#8		@ sha512_block_data_order
+#else
+	adr	r3,sha512_block_data_order
+#endif
+#if __ARM_MAX_ARCH__>=7 && !defined(__KERNEL__)
+	ldr	r12,.LOPENSSL_armcap
+	ldr	r12,[r3,r12]		@ OPENSSL_armcap_P
+	tst	r12,#1
+	bne	.LNEON
+#endif
+	add	$len,$inp,$len,lsl#7	@ len to point at the end of inp
+	stmdb	sp!,{r4-r12,lr}
+	sub	$Ktbl,r3,#672		@ K512
+	sub	sp,sp,#9*8
+
+	ldr	$Elo,[$ctx,#$Eoff+$lo]
+	ldr	$Ehi,[$ctx,#$Eoff+$hi]
+	ldr	$t0, [$ctx,#$Goff+$lo]
+	ldr	$t1, [$ctx,#$Goff+$hi]
+	ldr	$t2, [$ctx,#$Hoff+$lo]
+	ldr	$t3, [$ctx,#$Hoff+$hi]
+.Loop:
+	str	$t0, [sp,#$Goff+0]
+	str	$t1, [sp,#$Goff+4]
+	str	$t2, [sp,#$Hoff+0]
+	str	$t3, [sp,#$Hoff+4]
+	ldr	$Alo,[$ctx,#$Aoff+$lo]
+	ldr	$Ahi,[$ctx,#$Aoff+$hi]
+	ldr	$Tlo,[$ctx,#$Boff+$lo]
+	ldr	$Thi,[$ctx,#$Boff+$hi]
+	ldr	$t0, [$ctx,#$Coff+$lo]
+	ldr	$t1, [$ctx,#$Coff+$hi]
+	ldr	$t2, [$ctx,#$Doff+$lo]
+	ldr	$t3, [$ctx,#$Doff+$hi]
+	str	$Tlo,[sp,#$Boff+0]
+	str	$Thi,[sp,#$Boff+4]
+	str	$t0, [sp,#$Coff+0]
+	str	$t1, [sp,#$Coff+4]
+	str	$t2, [sp,#$Doff+0]
+	str	$t3, [sp,#$Doff+4]
+	ldr	$Tlo,[$ctx,#$Foff+$lo]
+	ldr	$Thi,[$ctx,#$Foff+$hi]
+	str	$Tlo,[sp,#$Foff+0]
+	str	$Thi,[sp,#$Foff+4]
+
+.L00_15:
+#if __ARM_ARCH__<7
+	ldrb	$Tlo,[$inp,#7]
+	ldrb	$t0, [$inp,#6]
+	ldrb	$t1, [$inp,#5]
+	ldrb	$t2, [$inp,#4]
+	ldrb	$Thi,[$inp,#3]
+	ldrb	$t3, [$inp,#2]
+	orr	$Tlo,$Tlo,$t0,lsl#8
+	ldrb	$t0, [$inp,#1]
+	orr	$Tlo,$Tlo,$t1,lsl#16
+	ldrb	$t1, [$inp],#8
+	orr	$Tlo,$Tlo,$t2,lsl#24
+	orr	$Thi,$Thi,$t3,lsl#8
+	orr	$Thi,$Thi,$t0,lsl#16
+	orr	$Thi,$Thi,$t1,lsl#24
+#else
+	ldr	$Tlo,[$inp,#4]
+	ldr	$Thi,[$inp],#8
+#ifdef __ARMEL__
+	rev	$Tlo,$Tlo
+	rev	$Thi,$Thi
+#endif
+#endif
+___
+	&BODY_00_15(0x94);
+$code.=<<___;
+	tst	$Ktbl,#1
+	beq	.L00_15
+	ldr	$t0,[sp,#`$Xoff+8*(16-1)`+0]
+	ldr	$t1,[sp,#`$Xoff+8*(16-1)`+4]
+	bic	$Ktbl,$Ktbl,#1
+.L16_79:
+	@ sigma0(x)	(ROTR((x),1)  ^ ROTR((x),8)  ^ ((x)>>7))
+	@ LO		lo>>1^hi<<31  ^ lo>>8^hi<<24 ^ lo>>7^hi<<25
+	@ HI		hi>>1^lo<<31  ^ hi>>8^lo<<24 ^ hi>>7
+	mov	$Tlo,$t0,lsr#1
+	ldr	$t2,[sp,#`$Xoff+8*(16-14)`+0]
+	mov	$Thi,$t1,lsr#1
+	ldr	$t3,[sp,#`$Xoff+8*(16-14)`+4]
+	eor	$Tlo,$Tlo,$t1,lsl#31
+	eor	$Thi,$Thi,$t0,lsl#31
+	eor	$Tlo,$Tlo,$t0,lsr#8
+	eor	$Thi,$Thi,$t1,lsr#8
+	eor	$Tlo,$Tlo,$t1,lsl#24
+	eor	$Thi,$Thi,$t0,lsl#24
+	eor	$Tlo,$Tlo,$t0,lsr#7
+	eor	$Thi,$Thi,$t1,lsr#7
+	eor	$Tlo,$Tlo,$t1,lsl#25
+
+	@ sigma1(x)	(ROTR((x),19) ^ ROTR((x),61) ^ ((x)>>6))
+	@ LO		lo>>19^hi<<13 ^ hi>>29^lo<<3 ^ lo>>6^hi<<26
+	@ HI		hi>>19^lo<<13 ^ lo>>29^hi<<3 ^ hi>>6
+	mov	$t0,$t2,lsr#19
+	mov	$t1,$t3,lsr#19
+	eor	$t0,$t0,$t3,lsl#13
+	eor	$t1,$t1,$t2,lsl#13
+	eor	$t0,$t0,$t3,lsr#29
+	eor	$t1,$t1,$t2,lsr#29
+	eor	$t0,$t0,$t2,lsl#3
+	eor	$t1,$t1,$t3,lsl#3
+	eor	$t0,$t0,$t2,lsr#6
+	eor	$t1,$t1,$t3,lsr#6
+	ldr	$t2,[sp,#`$Xoff+8*(16-9)`+0]
+	eor	$t0,$t0,$t3,lsl#26
+
+	ldr	$t3,[sp,#`$Xoff+8*(16-9)`+4]
+	adds	$Tlo,$Tlo,$t0
+	ldr	$t0,[sp,#`$Xoff+8*16`+0]
+	adc	$Thi,$Thi,$t1
+
+	ldr	$t1,[sp,#`$Xoff+8*16`+4]
+	adds	$Tlo,$Tlo,$t2
+	adc	$Thi,$Thi,$t3
+	adds	$Tlo,$Tlo,$t0
+	adc	$Thi,$Thi,$t1
+___
+	&BODY_00_15(0x17);
+$code.=<<___;
+#if __ARM_ARCH__>=7
+	ittt	eq			@ Thumb2 thing, sanity check in ARM
+#endif
+	ldreq	$t0,[sp,#`$Xoff+8*(16-1)`+0]
+	ldreq	$t1,[sp,#`$Xoff+8*(16-1)`+4]
+	beq	.L16_79
+	bic	$Ktbl,$Ktbl,#1
+
+	ldr	$Tlo,[sp,#$Boff+0]
+	ldr	$Thi,[sp,#$Boff+4]
+	ldr	$t0, [$ctx,#$Aoff+$lo]
+	ldr	$t1, [$ctx,#$Aoff+$hi]
+	ldr	$t2, [$ctx,#$Boff+$lo]
+	ldr	$t3, [$ctx,#$Boff+$hi]
+	adds	$t0,$Alo,$t0
+	str	$t0, [$ctx,#$Aoff+$lo]
+	adc	$t1,$Ahi,$t1
+	str	$t1, [$ctx,#$Aoff+$hi]
+	adds	$t2,$Tlo,$t2
+	str	$t2, [$ctx,#$Boff+$lo]
+	adc	$t3,$Thi,$t3
+	str	$t3, [$ctx,#$Boff+$hi]
+
+	ldr	$Alo,[sp,#$Coff+0]
+	ldr	$Ahi,[sp,#$Coff+4]
+	ldr	$Tlo,[sp,#$Doff+0]
+	ldr	$Thi,[sp,#$Doff+4]
+	ldr	$t0, [$ctx,#$Coff+$lo]
+	ldr	$t1, [$ctx,#$Coff+$hi]
+	ldr	$t2, [$ctx,#$Doff+$lo]
+	ldr	$t3, [$ctx,#$Doff+$hi]
+	adds	$t0,$Alo,$t0
+	str	$t0, [$ctx,#$Coff+$lo]
+	adc	$t1,$Ahi,$t1
+	str	$t1, [$ctx,#$Coff+$hi]
+	adds	$t2,$Tlo,$t2
+	str	$t2, [$ctx,#$Doff+$lo]
+	adc	$t3,$Thi,$t3
+	str	$t3, [$ctx,#$Doff+$hi]
+
+	ldr	$Tlo,[sp,#$Foff+0]
+	ldr	$Thi,[sp,#$Foff+4]
+	ldr	$t0, [$ctx,#$Eoff+$lo]
+	ldr	$t1, [$ctx,#$Eoff+$hi]
+	ldr	$t2, [$ctx,#$Foff+$lo]
+	ldr	$t3, [$ctx,#$Foff+$hi]
+	adds	$Elo,$Elo,$t0
+	str	$Elo,[$ctx,#$Eoff+$lo]
+	adc	$Ehi,$Ehi,$t1
+	str	$Ehi,[$ctx,#$Eoff+$hi]
+	adds	$t2,$Tlo,$t2
+	str	$t2, [$ctx,#$Foff+$lo]
+	adc	$t3,$Thi,$t3
+	str	$t3, [$ctx,#$Foff+$hi]
+
+	ldr	$Alo,[sp,#$Goff+0]
+	ldr	$Ahi,[sp,#$Goff+4]
+	ldr	$Tlo,[sp,#$Hoff+0]
+	ldr	$Thi,[sp,#$Hoff+4]
+	ldr	$t0, [$ctx,#$Goff+$lo]
+	ldr	$t1, [$ctx,#$Goff+$hi]
+	ldr	$t2, [$ctx,#$Hoff+$lo]
+	ldr	$t3, [$ctx,#$Hoff+$hi]
+	adds	$t0,$Alo,$t0
+	str	$t0, [$ctx,#$Goff+$lo]
+	adc	$t1,$Ahi,$t1
+	str	$t1, [$ctx,#$Goff+$hi]
+	adds	$t2,$Tlo,$t2
+	str	$t2, [$ctx,#$Hoff+$lo]
+	adc	$t3,$Thi,$t3
+	str	$t3, [$ctx,#$Hoff+$hi]
+
+	add	sp,sp,#640
+	sub	$Ktbl,$Ktbl,#640
+
+	teq	$inp,$len
+	bne	.Loop
+
+	add	sp,sp,#8*9		@ destroy frame
+#if __ARM_ARCH__>=5
+	ldmia	sp!,{r4-r12,pc}
+#else
+	ldmia	sp!,{r4-r12,lr}
+	tst	lr,#1
+	moveq	pc,lr			@ be binary compatible with V4, yet
+	bx	lr			@ interoperable with Thumb ISA:-)
+#endif
+.size	sha512_block_data_order,.-sha512_block_data_order
+___
+
+{
+my @Sigma0=(28,34,39);
+my @Sigma1=(14,18,41);
+my @sigma0=(1, 8, 7);
+my @sigma1=(19,61,6);
+
+my $Ktbl="r3";
+my $cnt="r12";	# volatile register known as ip, intra-procedure-call scratch
+
+my @X=map("d$_",(0..15));
+my @V=($A,$B,$C,$D,$E,$F,$G,$H)=map("d$_",(16..23));
+
+sub NEON_00_15() {
+my $i=shift;
+my ($a,$b,$c,$d,$e,$f,$g,$h)=@_;
+my ($t0,$t1,$t2,$T1,$K,$Ch,$Maj)=map("d$_",(24..31));	# temps
+
+$code.=<<___ if ($i<16 || $i&1);
+	vshr.u64	$t0,$e,#@Sigma1[0]	@ $i
+#if $i<16
+	vld1.64		{@X[$i%16]},[$inp]!	@ handles unaligned
+#endif
+	vshr.u64	$t1,$e,#@Sigma1[1]
+#if $i>0
+	 vadd.i64	$a,$Maj			@ h+=Maj from the past
+#endif
+	vshr.u64	$t2,$e,#@Sigma1[2]
+___
+$code.=<<___;
+	vld1.64		{$K},[$Ktbl,:64]!	@ K[i++]
+	vsli.64		$t0,$e,#`64-@Sigma1[0]`
+	vsli.64		$t1,$e,#`64-@Sigma1[1]`
+	vmov		$Ch,$e
+	vsli.64		$t2,$e,#`64-@Sigma1[2]`
+#if $i<16 && defined(__ARMEL__)
+	vrev64.8	@X[$i],@X[$i]
+#endif
+	veor		$t1,$t0
+	vbsl		$Ch,$f,$g		@ Ch(e,f,g)
+	vshr.u64	$t0,$a,#@Sigma0[0]
+	veor		$t2,$t1			@ Sigma1(e)
+	vadd.i64	$T1,$Ch,$h
+	vshr.u64	$t1,$a,#@Sigma0[1]
+	vsli.64		$t0,$a,#`64-@Sigma0[0]`
+	vadd.i64	$T1,$t2
+	vshr.u64	$t2,$a,#@Sigma0[2]
+	vadd.i64	$K,@X[$i%16]
+	vsli.64		$t1,$a,#`64-@Sigma0[1]`
+	veor		$Maj,$a,$b
+	vsli.64		$t2,$a,#`64-@Sigma0[2]`
+	veor		$h,$t0,$t1
+	vadd.i64	$T1,$K
+	vbsl		$Maj,$c,$b		@ Maj(a,b,c)
+	veor		$h,$t2			@ Sigma0(a)
+	vadd.i64	$d,$T1
+	vadd.i64	$Maj,$T1
+	@ vadd.i64	$h,$Maj
+___
+}
+
+sub NEON_16_79() {
+my $i=shift;
+
+if ($i&1)	{ &NEON_00_15($i,@_); return; }
+
+# 2x-vectorized, therefore runs every 2nd round
+my @X=map("q$_",(0..7));			# view @X as 128-bit vector
+my ($t0,$t1,$s0,$s1) = map("q$_",(12..15));	# temps
+my ($d0,$d1,$d2) = map("d$_",(24..26));		# temps from NEON_00_15
+my $e=@_[4];					# $e from NEON_00_15
+$i /= 2;
+$code.=<<___;
+	vshr.u64	$t0,@X[($i+7)%8],#@sigma1[0]
+	vshr.u64	$t1,@X[($i+7)%8],#@sigma1[1]
+	 vadd.i64	@_[0],d30			@ h+=Maj from the past
+	vshr.u64	$s1,@X[($i+7)%8],#@sigma1[2]
+	vsli.64		$t0,@X[($i+7)%8],#`64-@sigma1[0]`
+	vext.8		$s0,@X[$i%8],@X[($i+1)%8],#8	@ X[i+1]
+	vsli.64		$t1,@X[($i+7)%8],#`64-@sigma1[1]`
+	veor		$s1,$t0
+	vshr.u64	$t0,$s0,#@sigma0[0]
+	veor		$s1,$t1				@ sigma1(X[i+14])
+	vshr.u64	$t1,$s0,#@sigma0[1]
+	vadd.i64	@X[$i%8],$s1
+	vshr.u64	$s1,$s0,#@sigma0[2]
+	vsli.64		$t0,$s0,#`64-@sigma0[0]`
+	vsli.64		$t1,$s0,#`64-@sigma0[1]`
+	vext.8		$s0,@X[($i+4)%8],@X[($i+5)%8],#8	@ X[i+9]
+	veor		$s1,$t0
+	vshr.u64	$d0,$e,#@Sigma1[0]		@ from NEON_00_15
+	vadd.i64	@X[$i%8],$s0
+	vshr.u64	$d1,$e,#@Sigma1[1]		@ from NEON_00_15
+	veor		$s1,$t1				@ sigma0(X[i+1])
+	vshr.u64	$d2,$e,#@Sigma1[2]		@ from NEON_00_15
+	vadd.i64	@X[$i%8],$s1
+___
+	&NEON_00_15(2*$i,@_);
+}
+
+$code.=<<___;
+#if __ARM_MAX_ARCH__>=7
+.arch	armv7-a
+.fpu	neon
+
+.global	sha512_block_data_order_neon
+.type	sha512_block_data_order_neon,%function
+.align	4
+sha512_block_data_order_neon:
+.LNEON:
+	dmb				@ errata #451034 on early Cortex A8
+	add	$len,$inp,$len,lsl#7	@ len to point at the end of inp
+	VFP_ABI_PUSH
+	adrl	$Ktbl,K512
+	vldmia	$ctx,{$A-$H}		@ load context
+.Loop_neon:
+___
+for($i=0;$i<16;$i++)	{ &NEON_00_15($i,@V); unshift(@V,pop(@V)); }
+$code.=<<___;
+	mov		$cnt,#4
+.L16_79_neon:
+	subs		$cnt,#1
+___
+for(;$i<32;$i++)	{ &NEON_16_79($i,@V); unshift(@V,pop(@V)); }
+$code.=<<___;
+	bne		.L16_79_neon
+
+	 vadd.i64	$A,d30		@ h+=Maj from the past
+	vldmia		$ctx,{d24-d31}	@ load context to temp
+	vadd.i64	q8,q12		@ vectorized accumulate
+	vadd.i64	q9,q13
+	vadd.i64	q10,q14
+	vadd.i64	q11,q15
+	vstmia		$ctx,{$A-$H}	@ save context
+	teq		$inp,$len
+	sub		$Ktbl,#640	@ rewind K512
+	bne		.Loop_neon
+
+	VFP_ABI_POP
+	ret				@ bx lr
+.size	sha512_block_data_order_neon,.-sha512_block_data_order_neon
+#endif
+___
+}
+$code.=<<___;
+.asciz	"SHA512 block transform for ARMv4/NEON, CRYPTOGAMS by <appro\@openssl.org>"
+.align	2
+#if __ARM_MAX_ARCH__>=7 && !defined(__KERNEL__)
+.comm	OPENSSL_armcap_P,4,4
+#endif
+___
+
+$code =~ s/\`([^\`]*)\`/eval $1/gem;
+$code =~ s/\bbx\s+lr\b/.word\t0xe12fff1e/gm;	# make it possible to compile with -march=armv4
+$code =~ s/\bret\b/bx	lr/gm;
+
+open SELF,$0;
+while(<SELF>) {
+	next if (/^#!/);
+	last if (!s/^#/@/ and !/^$/);
+	print;
+}
+close SELF;
+
+print $code;
+close STDOUT; # enforce flush
diff --git a/arch/arm/crypto/sha512-core.S_shipped b/arch/arm/crypto/sha512-core.S_shipped
new file mode 100644
index 000000000000..281924c1238f
--- /dev/null
+++ b/arch/arm/crypto/sha512-core.S_shipped
@@ -0,0 +1,1814 @@
+#ifndef __KERNEL__
+# include "arm_arch.h"
+# define VFP_ABI_PUSH	vstmdb	sp!,{d8-d15}
+# define VFP_ABI_POP	vldmia	sp!,{d8-d15}
+#else
+# define __ARM_ARCH__ __LINUX_ARM_ARCH__
+# define __ARM_MAX_ARCH__ 7
+# define VFP_ABI_PUSH
+# define VFP_ABI_POP
+#endif
+
+#ifdef __ARMEL__
+# define LO 0
+# define HI 4
+# define WORD64(hi0,lo0,hi1,lo1)	.word	lo0,hi0, lo1,hi1
+#else
+# define HI 0
+# define LO 4
+# define WORD64(hi0,lo0,hi1,lo1)	.word	hi0,lo0, hi1,lo1
+#endif
+
+.text
+#if __ARM_ARCH__<7
+.code	32
+#else
+.syntax unified
+# ifdef __thumb2__
+#  define adrl adr
+.thumb
+# else
+.code   32
+# endif
+#endif
+
+.type	K512,%object
+.align	5
+K512:
+WORD64(0x428a2f98,0xd728ae22, 0x71374491,0x23ef65cd)
+WORD64(0xb5c0fbcf,0xec4d3b2f, 0xe9b5dba5,0x8189dbbc)
+WORD64(0x3956c25b,0xf348b538, 0x59f111f1,0xb605d019)
+WORD64(0x923f82a4,0xaf194f9b, 0xab1c5ed5,0xda6d8118)
+WORD64(0xd807aa98,0xa3030242, 0x12835b01,0x45706fbe)
+WORD64(0x243185be,0x4ee4b28c, 0x550c7dc3,0xd5ffb4e2)
+WORD64(0x72be5d74,0xf27b896f, 0x80deb1fe,0x3b1696b1)
+WORD64(0x9bdc06a7,0x25c71235, 0xc19bf174,0xcf692694)
+WORD64(0xe49b69c1,0x9ef14ad2, 0xefbe4786,0x384f25e3)
+WORD64(0x0fc19dc6,0x8b8cd5b5, 0x240ca1cc,0x77ac9c65)
+WORD64(0x2de92c6f,0x592b0275, 0x4a7484aa,0x6ea6e483)
+WORD64(0x5cb0a9dc,0xbd41fbd4, 0x76f988da,0x831153b5)
+WORD64(0x983e5152,0xee66dfab, 0xa831c66d,0x2db43210)
+WORD64(0xb00327c8,0x98fb213f, 0xbf597fc7,0xbeef0ee4)
+WORD64(0xc6e00bf3,0x3da88fc2, 0xd5a79147,0x930aa725)
+WORD64(0x06ca6351,0xe003826f, 0x14292967,0x0a0e6e70)
+WORD64(0x27b70a85,0x46d22ffc, 0x2e1b2138,0x5c26c926)
+WORD64(0x4d2c6dfc,0x5ac42aed, 0x53380d13,0x9d95b3df)
+WORD64(0x650a7354,0x8baf63de, 0x766a0abb,0x3c77b2a8)
+WORD64(0x81c2c92e,0x47edaee6, 0x92722c85,0x1482353b)
+WORD64(0xa2bfe8a1,0x4cf10364, 0xa81a664b,0xbc423001)
+WORD64(0xc24b8b70,0xd0f89791, 0xc76c51a3,0x0654be30)
+WORD64(0xd192e819,0xd6ef5218, 0xd6990624,0x5565a910)
+WORD64(0xf40e3585,0x5771202a, 0x106aa070,0x32bbd1b8)
+WORD64(0x19a4c116,0xb8d2d0c8, 0x1e376c08,0x5141ab53)
+WORD64(0x2748774c,0xdf8eeb99, 0x34b0bcb5,0xe19b48a8)
+WORD64(0x391c0cb3,0xc5c95a63, 0x4ed8aa4a,0xe3418acb)
+WORD64(0x5b9cca4f,0x7763e373, 0x682e6ff3,0xd6b2b8a3)
+WORD64(0x748f82ee,0x5defb2fc, 0x78a5636f,0x43172f60)
+WORD64(0x84c87814,0xa1f0ab72, 0x8cc70208,0x1a6439ec)
+WORD64(0x90befffa,0x23631e28, 0xa4506ceb,0xde82bde9)
+WORD64(0xbef9a3f7,0xb2c67915, 0xc67178f2,0xe372532b)
+WORD64(0xca273ece,0xea26619c, 0xd186b8c7,0x21c0c207)
+WORD64(0xeada7dd6,0xcde0eb1e, 0xf57d4f7f,0xee6ed178)
+WORD64(0x06f067aa,0x72176fba, 0x0a637dc5,0xa2c898a6)
+WORD64(0x113f9804,0xbef90dae, 0x1b710b35,0x131c471b)
+WORD64(0x28db77f5,0x23047d84, 0x32caab7b,0x40c72493)
+WORD64(0x3c9ebe0a,0x15c9bebc, 0x431d67c4,0x9c100d4c)
+WORD64(0x4cc5d4be,0xcb3e42b6, 0x597f299c,0xfc657e2a)
+WORD64(0x5fcb6fab,0x3ad6faec, 0x6c44198c,0x4a475817)
+.size	K512,.-K512
+#if __ARM_MAX_ARCH__>=7 && !defined(__KERNEL__)
+.LOPENSSL_armcap:
+.word	OPENSSL_armcap_P-sha512_block_data_order
+.skip	32-4
+#else
+.skip	32
+#endif
+
+.global	sha512_block_data_order
+.type	sha512_block_data_order,%function
+sha512_block_data_order:
+#if __ARM_ARCH__<7
+	sub	r3,pc,#8		@ sha512_block_data_order
+#else
+	adr	r3,sha512_block_data_order
+#endif
+#if __ARM_MAX_ARCH__>=7 && !defined(__KERNEL__)
+	ldr	r12,.LOPENSSL_armcap
+	ldr	r12,[r3,r12]		@ OPENSSL_armcap_P
+	tst	r12,#1
+	bne	.LNEON
+#endif
+	add	r2,r1,r2,lsl#7	@ len to point at the end of inp
+	stmdb	sp!,{r4-r12,lr}
+	sub	r14,r3,#672		@ K512
+	sub	sp,sp,#9*8
+
+	ldr	r7,[r0,#32+LO]
+	ldr	r8,[r0,#32+HI]
+	ldr	r9, [r0,#48+LO]
+	ldr	r10, [r0,#48+HI]
+	ldr	r11, [r0,#56+LO]
+	ldr	r12, [r0,#56+HI]
+.Loop:
+	str	r9, [sp,#48+0]
+	str	r10, [sp,#48+4]
+	str	r11, [sp,#56+0]
+	str	r12, [sp,#56+4]
+	ldr	r5,[r0,#0+LO]
+	ldr	r6,[r0,#0+HI]
+	ldr	r3,[r0,#8+LO]
+	ldr	r4,[r0,#8+HI]
+	ldr	r9, [r0,#16+LO]
+	ldr	r10, [r0,#16+HI]
+	ldr	r11, [r0,#24+LO]
+	ldr	r12, [r0,#24+HI]
+	str	r3,[sp,#8+0]
+	str	r4,[sp,#8+4]
+	str	r9, [sp,#16+0]
+	str	r10, [sp,#16+4]
+	str	r11, [sp,#24+0]
+	str	r12, [sp,#24+4]
+	ldr	r3,[r0,#40+LO]
+	ldr	r4,[r0,#40+HI]
+	str	r3,[sp,#40+0]
+	str	r4,[sp,#40+4]
+
+.L00_15:
+#if __ARM_ARCH__<7
+	ldrb	r3,[r1,#7]
+	ldrb	r9, [r1,#6]
+	ldrb	r10, [r1,#5]
+	ldrb	r11, [r1,#4]
+	ldrb	r4,[r1,#3]
+	ldrb	r12, [r1,#2]
+	orr	r3,r3,r9,lsl#8
+	ldrb	r9, [r1,#1]
+	orr	r3,r3,r10,lsl#16
+	ldrb	r10, [r1],#8
+	orr	r3,r3,r11,lsl#24
+	orr	r4,r4,r12,lsl#8
+	orr	r4,r4,r9,lsl#16
+	orr	r4,r4,r10,lsl#24
+#else
+	ldr	r3,[r1,#4]
+	ldr	r4,[r1],#8
+#ifdef __ARMEL__
+	rev	r3,r3
+	rev	r4,r4
+#endif
+#endif
+	@ Sigma1(x)	(ROTR((x),14) ^ ROTR((x),18)  ^ ROTR((x),41))
+	@ LO		lo>>14^hi<<18 ^ lo>>18^hi<<14 ^ hi>>9^lo<<23
+	@ HI		hi>>14^lo<<18 ^ hi>>18^lo<<14 ^ lo>>9^hi<<23
+	mov	r9,r7,lsr#14
+	str	r3,[sp,#64+0]
+	mov	r10,r8,lsr#14
+	str	r4,[sp,#64+4]
+	eor	r9,r9,r8,lsl#18
+	ldr	r11,[sp,#56+0]	@ h.lo
+	eor	r10,r10,r7,lsl#18
+	ldr	r12,[sp,#56+4]	@ h.hi
+	eor	r9,r9,r7,lsr#18
+	eor	r10,r10,r8,lsr#18
+	eor	r9,r9,r8,lsl#14
+	eor	r10,r10,r7,lsl#14
+	eor	r9,r9,r8,lsr#9
+	eor	r10,r10,r7,lsr#9
+	eor	r9,r9,r7,lsl#23
+	eor	r10,r10,r8,lsl#23	@ Sigma1(e)
+	adds	r3,r3,r9
+	ldr	r9,[sp,#40+0]	@ f.lo
+	adc	r4,r4,r10		@ T += Sigma1(e)
+	ldr	r10,[sp,#40+4]	@ f.hi
+	adds	r3,r3,r11
+	ldr	r11,[sp,#48+0]	@ g.lo
+	adc	r4,r4,r12		@ T += h
+	ldr	r12,[sp,#48+4]	@ g.hi
+
+	eor	r9,r9,r11
+	str	r7,[sp,#32+0]
+	eor	r10,r10,r12
+	str	r8,[sp,#32+4]
+	and	r9,r9,r7
+	str	r5,[sp,#0+0]
+	and	r10,r10,r8
+	str	r6,[sp,#0+4]
+	eor	r9,r9,r11
+	ldr	r11,[r14,#LO]	@ K[i].lo
+	eor	r10,r10,r12		@ Ch(e,f,g)
+	ldr	r12,[r14,#HI]	@ K[i].hi
+
+	adds	r3,r3,r9
+	ldr	r7,[sp,#24+0]	@ d.lo
+	adc	r4,r4,r10		@ T += Ch(e,f,g)
+	ldr	r8,[sp,#24+4]	@ d.hi
+	adds	r3,r3,r11
+	and	r9,r11,#0xff
+	adc	r4,r4,r12		@ T += K[i]
+	adds	r7,r7,r3
+	ldr	r11,[sp,#8+0]	@ b.lo
+	adc	r8,r8,r4		@ d += T
+	teq	r9,#148
+
+	ldr	r12,[sp,#16+0]	@ c.lo
+#if __ARM_ARCH__>=7
+	it	eq			@ Thumb2 thing, sanity check in ARM
+#endif
+	orreq	r14,r14,#1
+	@ Sigma0(x)	(ROTR((x),28) ^ ROTR((x),34) ^ ROTR((x),39))
+	@ LO		lo>>28^hi<<4  ^ hi>>2^lo<<30 ^ hi>>7^lo<<25
+	@ HI		hi>>28^lo<<4  ^ lo>>2^hi<<30 ^ lo>>7^hi<<25
+	mov	r9,r5,lsr#28
+	mov	r10,r6,lsr#28
+	eor	r9,r9,r6,lsl#4
+	eor	r10,r10,r5,lsl#4
+	eor	r9,r9,r6,lsr#2
+	eor	r10,r10,r5,lsr#2
+	eor	r9,r9,r5,lsl#30
+	eor	r10,r10,r6,lsl#30
+	eor	r9,r9,r6,lsr#7
+	eor	r10,r10,r5,lsr#7
+	eor	r9,r9,r5,lsl#25
+	eor	r10,r10,r6,lsl#25	@ Sigma0(a)
+	adds	r3,r3,r9
+	and	r9,r5,r11
+	adc	r4,r4,r10		@ T += Sigma0(a)
+
+	ldr	r10,[sp,#8+4]	@ b.hi
+	orr	r5,r5,r11
+	ldr	r11,[sp,#16+4]	@ c.hi
+	and	r5,r5,r12
+	and	r12,r6,r10
+	orr	r6,r6,r10
+	orr	r5,r5,r9		@ Maj(a,b,c).lo
+	and	r6,r6,r11
+	adds	r5,r5,r3
+	orr	r6,r6,r12		@ Maj(a,b,c).hi
+	sub	sp,sp,#8
+	adc	r6,r6,r4		@ h += T
+	tst	r14,#1
+	add	r14,r14,#8
+	tst	r14,#1
+	beq	.L00_15
+	ldr	r9,[sp,#184+0]
+	ldr	r10,[sp,#184+4]
+	bic	r14,r14,#1
+.L16_79:
+	@ sigma0(x)	(ROTR((x),1)  ^ ROTR((x),8)  ^ ((x)>>7))
+	@ LO		lo>>1^hi<<31  ^ lo>>8^hi<<24 ^ lo>>7^hi<<25
+	@ HI		hi>>1^lo<<31  ^ hi>>8^lo<<24 ^ hi>>7
+	mov	r3,r9,lsr#1
+	ldr	r11,[sp,#80+0]
+	mov	r4,r10,lsr#1
+	ldr	r12,[sp,#80+4]
+	eor	r3,r3,r10,lsl#31
+	eor	r4,r4,r9,lsl#31
+	eor	r3,r3,r9,lsr#8
+	eor	r4,r4,r10,lsr#8
+	eor	r3,r3,r10,lsl#24
+	eor	r4,r4,r9,lsl#24
+	eor	r3,r3,r9,lsr#7
+	eor	r4,r4,r10,lsr#7
+	eor	r3,r3,r10,lsl#25
+
+	@ sigma1(x)	(ROTR((x),19) ^ ROTR((x),61) ^ ((x)>>6))
+	@ LO		lo>>19^hi<<13 ^ hi>>29^lo<<3 ^ lo>>6^hi<<26
+	@ HI		hi>>19^lo<<13 ^ lo>>29^hi<<3 ^ hi>>6
+	mov	r9,r11,lsr#19
+	mov	r10,r12,lsr#19
+	eor	r9,r9,r12,lsl#13
+	eor	r10,r10,r11,lsl#13
+	eor	r9,r9,r12,lsr#29
+	eor	r10,r10,r11,lsr#29
+	eor	r9,r9,r11,lsl#3
+	eor	r10,r10,r12,lsl#3
+	eor	r9,r9,r11,lsr#6
+	eor	r10,r10,r12,lsr#6
+	ldr	r11,[sp,#120+0]
+	eor	r9,r9,r12,lsl#26
+
+	ldr	r12,[sp,#120+4]
+	adds	r3,r3,r9
+	ldr	r9,[sp,#192+0]
+	adc	r4,r4,r10
+
+	ldr	r10,[sp,#192+4]
+	adds	r3,r3,r11
+	adc	r4,r4,r12
+	adds	r3,r3,r9
+	adc	r4,r4,r10
+	@ Sigma1(x)	(ROTR((x),14) ^ ROTR((x),18)  ^ ROTR((x),41))
+	@ LO		lo>>14^hi<<18 ^ lo>>18^hi<<14 ^ hi>>9^lo<<23
+	@ HI		hi>>14^lo<<18 ^ hi>>18^lo<<14 ^ lo>>9^hi<<23
+	mov	r9,r7,lsr#14
+	str	r3,[sp,#64+0]
+	mov	r10,r8,lsr#14
+	str	r4,[sp,#64+4]
+	eor	r9,r9,r8,lsl#18
+	ldr	r11,[sp,#56+0]	@ h.lo
+	eor	r10,r10,r7,lsl#18
+	ldr	r12,[sp,#56+4]	@ h.hi
+	eor	r9,r9,r7,lsr#18
+	eor	r10,r10,r8,lsr#18
+	eor	r9,r9,r8,lsl#14
+	eor	r10,r10,r7,lsl#14
+	eor	r9,r9,r8,lsr#9
+	eor	r10,r10,r7,lsr#9
+	eor	r9,r9,r7,lsl#23
+	eor	r10,r10,r8,lsl#23	@ Sigma1(e)
+	adds	r3,r3,r9
+	ldr	r9,[sp,#40+0]	@ f.lo
+	adc	r4,r4,r10		@ T += Sigma1(e)
+	ldr	r10,[sp,#40+4]	@ f.hi
+	adds	r3,r3,r11
+	ldr	r11,[sp,#48+0]	@ g.lo
+	adc	r4,r4,r12		@ T += h
+	ldr	r12,[sp,#48+4]	@ g.hi
+
+	eor	r9,r9,r11
+	str	r7,[sp,#32+0]
+	eor	r10,r10,r12
+	str	r8,[sp,#32+4]
+	and	r9,r9,r7
+	str	r5,[sp,#0+0]
+	and	r10,r10,r8
+	str	r6,[sp,#0+4]
+	eor	r9,r9,r11
+	ldr	r11,[r14,#LO]	@ K[i].lo
+	eor	r10,r10,r12		@ Ch(e,f,g)
+	ldr	r12,[r14,#HI]	@ K[i].hi
+
+	adds	r3,r3,r9
+	ldr	r7,[sp,#24+0]	@ d.lo
+	adc	r4,r4,r10		@ T += Ch(e,f,g)
+	ldr	r8,[sp,#24+4]	@ d.hi
+	adds	r3,r3,r11
+	and	r9,r11,#0xff
+	adc	r4,r4,r12		@ T += K[i]
+	adds	r7,r7,r3
+	ldr	r11,[sp,#8+0]	@ b.lo
+	adc	r8,r8,r4		@ d += T
+	teq	r9,#23
+
+	ldr	r12,[sp,#16+0]	@ c.lo
+#if __ARM_ARCH__>=7
+	it	eq			@ Thumb2 thing, sanity check in ARM
+#endif
+	orreq	r14,r14,#1
+	@ Sigma0(x)	(ROTR((x),28) ^ ROTR((x),34) ^ ROTR((x),39))
+	@ LO		lo>>28^hi<<4  ^ hi>>2^lo<<30 ^ hi>>7^lo<<25
+	@ HI		hi>>28^lo<<4  ^ lo>>2^hi<<30 ^ lo>>7^hi<<25
+	mov	r9,r5,lsr#28
+	mov	r10,r6,lsr#28
+	eor	r9,r9,r6,lsl#4
+	eor	r10,r10,r5,lsl#4
+	eor	r9,r9,r6,lsr#2
+	eor	r10,r10,r5,lsr#2
+	eor	r9,r9,r5,lsl#30
+	eor	r10,r10,r6,lsl#30
+	eor	r9,r9,r6,lsr#7
+	eor	r10,r10,r5,lsr#7
+	eor	r9,r9,r5,lsl#25
+	eor	r10,r10,r6,lsl#25	@ Sigma0(a)
+	adds	r3,r3,r9
+	and	r9,r5,r11
+	adc	r4,r4,r10		@ T += Sigma0(a)
+
+	ldr	r10,[sp,#8+4]	@ b.hi
+	orr	r5,r5,r11
+	ldr	r11,[sp,#16+4]	@ c.hi
+	and	r5,r5,r12
+	and	r12,r6,r10
+	orr	r6,r6,r10
+	orr	r5,r5,r9		@ Maj(a,b,c).lo
+	and	r6,r6,r11
+	adds	r5,r5,r3
+	orr	r6,r6,r12		@ Maj(a,b,c).hi
+	sub	sp,sp,#8
+	adc	r6,r6,r4		@ h += T
+	tst	r14,#1
+	add	r14,r14,#8
+#if __ARM_ARCH__>=7
+	ittt	eq			@ Thumb2 thing, sanity check in ARM
+#endif
+	ldreq	r9,[sp,#184+0]
+	ldreq	r10,[sp,#184+4]
+	beq	.L16_79
+	bic	r14,r14,#1
+
+	ldr	r3,[sp,#8+0]
+	ldr	r4,[sp,#8+4]
+	ldr	r9, [r0,#0+LO]
+	ldr	r10, [r0,#0+HI]
+	ldr	r11, [r0,#8+LO]
+	ldr	r12, [r0,#8+HI]
+	adds	r9,r5,r9
+	str	r9, [r0,#0+LO]
+	adc	r10,r6,r10
+	str	r10, [r0,#0+HI]
+	adds	r11,r3,r11
+	str	r11, [r0,#8+LO]
+	adc	r12,r4,r12
+	str	r12, [r0,#8+HI]
+
+	ldr	r5,[sp,#16+0]
+	ldr	r6,[sp,#16+4]
+	ldr	r3,[sp,#24+0]
+	ldr	r4,[sp,#24+4]
+	ldr	r9, [r0,#16+LO]
+	ldr	r10, [r0,#16+HI]
+	ldr	r11, [r0,#24+LO]
+	ldr	r12, [r0,#24+HI]
+	adds	r9,r5,r9
+	str	r9, [r0,#16+LO]
+	adc	r10,r6,r10
+	str	r10, [r0,#16+HI]
+	adds	r11,r3,r11
+	str	r11, [r0,#24+LO]
+	adc	r12,r4,r12
+	str	r12, [r0,#24+HI]
+
+	ldr	r3,[sp,#40+0]
+	ldr	r4,[sp,#40+4]
+	ldr	r9, [r0,#32+LO]
+	ldr	r10, [r0,#32+HI]
+	ldr	r11, [r0,#40+LO]
+	ldr	r12, [r0,#40+HI]
+	adds	r7,r7,r9
+	str	r7,[r0,#32+LO]
+	adc	r8,r8,r10
+	str	r8,[r0,#32+HI]
+	adds	r11,r3,r11
+	str	r11, [r0,#40+LO]
+	adc	r12,r4,r12
+	str	r12, [r0,#40+HI]
+
+	ldr	r5,[sp,#48+0]
+	ldr	r6,[sp,#48+4]
+	ldr	r3,[sp,#56+0]
+	ldr	r4,[sp,#56+4]
+	ldr	r9, [r0,#48+LO]
+	ldr	r10, [r0,#48+HI]
+	ldr	r11, [r0,#56+LO]
+	ldr	r12, [r0,#56+HI]
+	adds	r9,r5,r9
+	str	r9, [r0,#48+LO]
+	adc	r10,r6,r10
+	str	r10, [r0,#48+HI]
+	adds	r11,r3,r11
+	str	r11, [r0,#56+LO]
+	adc	r12,r4,r12
+	str	r12, [r0,#56+HI]
+
+	add	sp,sp,#640
+	sub	r14,r14,#640
+
+	teq	r1,r2
+	bne	.Loop
+
+	add	sp,sp,#8*9		@ destroy frame
+#if __ARM_ARCH__>=5
+	ldmia	sp!,{r4-r12,pc}
+#else
+	ldmia	sp!,{r4-r12,lr}
+	tst	lr,#1
+	moveq	pc,lr			@ be binary compatible with V4, yet
+	.word	0xe12fff1e			@ interoperable with Thumb ISA:-)
+#endif
+.size	sha512_block_data_order,.-sha512_block_data_order
+#if __ARM_MAX_ARCH__>=7
+.arch	armv7-a
+.fpu	neon
+
+.global	sha512_block_data_order_neon
+.type	sha512_block_data_order_neon,%function
+.align	4
+sha512_block_data_order_neon:
+.LNEON:
+	dmb				@ errata #451034 on early Cortex A8
+	add	r2,r1,r2,lsl#7	@ len to point at the end of inp
+	VFP_ABI_PUSH
+	adrl	r3,K512
+	vldmia	r0,{d16-d23}		@ load context
+.Loop_neon:
+	vshr.u64	d24,d20,#14	@ 0
+#if 0<16
+	vld1.64		{d0},[r1]!	@ handles unaligned
+#endif
+	vshr.u64	d25,d20,#18
+#if 0>0
+	 vadd.i64	d16,d30			@ h+=Maj from the past
+#endif
+	vshr.u64	d26,d20,#41
+	vld1.64		{d28},[r3,:64]!	@ K[i++]
+	vsli.64		d24,d20,#50
+	vsli.64		d25,d20,#46
+	vmov		d29,d20
+	vsli.64		d26,d20,#23
+#if 0<16 && defined(__ARMEL__)
+	vrev64.8	d0,d0
+#endif
+	veor		d25,d24
+	vbsl		d29,d21,d22		@ Ch(e,f,g)
+	vshr.u64	d24,d16,#28
+	veor		d26,d25			@ Sigma1(e)
+	vadd.i64	d27,d29,d23
+	vshr.u64	d25,d16,#34
+	vsli.64		d24,d16,#36
+	vadd.i64	d27,d26
+	vshr.u64	d26,d16,#39
+	vadd.i64	d28,d0
+	vsli.64		d25,d16,#30
+	veor		d30,d16,d17
+	vsli.64		d26,d16,#25
+	veor		d23,d24,d25
+	vadd.i64	d27,d28
+	vbsl		d30,d18,d17		@ Maj(a,b,c)
+	veor		d23,d26			@ Sigma0(a)
+	vadd.i64	d19,d27
+	vadd.i64	d30,d27
+	@ vadd.i64	d23,d30
+	vshr.u64	d24,d19,#14	@ 1
+#if 1<16
+	vld1.64		{d1},[r1]!	@ handles unaligned
+#endif
+	vshr.u64	d25,d19,#18
+#if 1>0
+	 vadd.i64	d23,d30			@ h+=Maj from the past
+#endif
+	vshr.u64	d26,d19,#41
+	vld1.64		{d28},[r3,:64]!	@ K[i++]
+	vsli.64		d24,d19,#50
+	vsli.64		d25,d19,#46
+	vmov		d29,d19
+	vsli.64		d26,d19,#23
+#if 1<16 && defined(__ARMEL__)
+	vrev64.8	d1,d1
+#endif
+	veor		d25,d24
+	vbsl		d29,d20,d21		@ Ch(e,f,g)
+	vshr.u64	d24,d23,#28
+	veor		d26,d25			@ Sigma1(e)
+	vadd.i64	d27,d29,d22
+	vshr.u64	d25,d23,#34
+	vsli.64		d24,d23,#36
+	vadd.i64	d27,d26
+	vshr.u64	d26,d23,#39
+	vadd.i64	d28,d1
+	vsli.64		d25,d23,#30
+	veor		d30,d23,d16
+	vsli.64		d26,d23,#25
+	veor		d22,d24,d25
+	vadd.i64	d27,d28
+	vbsl		d30,d17,d16		@ Maj(a,b,c)
+	veor		d22,d26			@ Sigma0(a)
+	vadd.i64	d18,d27
+	vadd.i64	d30,d27
+	@ vadd.i64	d22,d30
+	vshr.u64	d24,d18,#14	@ 2
+#if 2<16
+	vld1.64		{d2},[r1]!	@ handles unaligned
+#endif
+	vshr.u64	d25,d18,#18
+#if 2>0
+	 vadd.i64	d22,d30			@ h+=Maj from the past
+#endif
+	vshr.u64	d26,d18,#41
+	vld1.64		{d28},[r3,:64]!	@ K[i++]
+	vsli.64		d24,d18,#50
+	vsli.64		d25,d18,#46
+	vmov		d29,d18
+	vsli.64		d26,d18,#23
+#if 2<16 && defined(__ARMEL__)
+	vrev64.8	d2,d2
+#endif
+	veor		d25,d24
+	vbsl		d29,d19,d20		@ Ch(e,f,g)
+	vshr.u64	d24,d22,#28
+	veor		d26,d25			@ Sigma1(e)
+	vadd.i64	d27,d29,d21
+	vshr.u64	d25,d22,#34
+	vsli.64		d24,d22,#36
+	vadd.i64	d27,d26
+	vshr.u64	d26,d22,#39
+	vadd.i64	d28,d2
+	vsli.64		d25,d22,#30
+	veor		d30,d22,d23
+	vsli.64		d26,d22,#25
+	veor		d21,d24,d25
+	vadd.i64	d27,d28
+	vbsl		d30,d16,d23		@ Maj(a,b,c)
+	veor		d21,d26			@ Sigma0(a)
+	vadd.i64	d17,d27
+	vadd.i64	d30,d27
+	@ vadd.i64	d21,d30
+	vshr.u64	d24,d17,#14	@ 3
+#if 3<16
+	vld1.64		{d3},[r1]!	@ handles unaligned
+#endif
+	vshr.u64	d25,d17,#18
+#if 3>0
+	 vadd.i64	d21,d30			@ h+=Maj from the past
+#endif
+	vshr.u64	d26,d17,#41
+	vld1.64		{d28},[r3,:64]!	@ K[i++]
+	vsli.64		d24,d17,#50
+	vsli.64		d25,d17,#46
+	vmov		d29,d17
+	vsli.64		d26,d17,#23
+#if 3<16 && defined(__ARMEL__)
+	vrev64.8	d3,d3
+#endif
+	veor		d25,d24
+	vbsl		d29,d18,d19		@ Ch(e,f,g)
+	vshr.u64	d24,d21,#28
+	veor		d26,d25			@ Sigma1(e)
+	vadd.i64	d27,d29,d20
+	vshr.u64	d25,d21,#34
+	vsli.64		d24,d21,#36
+	vadd.i64	d27,d26
+	vshr.u64	d26,d21,#39
+	vadd.i64	d28,d3
+	vsli.64		d25,d21,#30
+	veor		d30,d21,d22
+	vsli.64		d26,d21,#25
+	veor		d20,d24,d25
+	vadd.i64	d27,d28
+	vbsl		d30,d23,d22		@ Maj(a,b,c)
+	veor		d20,d26			@ Sigma0(a)
+	vadd.i64	d16,d27
+	vadd.i64	d30,d27
+	@ vadd.i64	d20,d30
+	vshr.u64	d24,d16,#14	@ 4
+#if 4<16
+	vld1.64		{d4},[r1]!	@ handles unaligned
+#endif
+	vshr.u64	d25,d16,#18
+#if 4>0
+	 vadd.i64	d20,d30			@ h+=Maj from the past
+#endif
+	vshr.u64	d26,d16,#41
+	vld1.64		{d28},[r3,:64]!	@ K[i++]
+	vsli.64		d24,d16,#50
+	vsli.64		d25,d16,#46
+	vmov		d29,d16
+	vsli.64		d26,d16,#23
+#if 4<16 && defined(__ARMEL__)
+	vrev64.8	d4,d4
+#endif
+	veor		d25,d24
+	vbsl		d29,d17,d18		@ Ch(e,f,g)
+	vshr.u64	d24,d20,#28
+	veor		d26,d25			@ Sigma1(e)
+	vadd.i64	d27,d29,d19
+	vshr.u64	d25,d20,#34
+	vsli.64		d24,d20,#36
+	vadd.i64	d27,d26
+	vshr.u64	d26,d20,#39
+	vadd.i64	d28,d4
+	vsli.64		d25,d20,#30
+	veor		d30,d20,d21
+	vsli.64		d26,d20,#25
+	veor		d19,d24,d25
+	vadd.i64	d27,d28
+	vbsl		d30,d22,d21		@ Maj(a,b,c)
+	veor		d19,d26			@ Sigma0(a)
+	vadd.i64	d23,d27
+	vadd.i64	d30,d27
+	@ vadd.i64	d19,d30
+	vshr.u64	d24,d23,#14	@ 5
+#if 5<16
+	vld1.64		{d5},[r1]!	@ handles unaligned
+#endif
+	vshr.u64	d25,d23,#18
+#if 5>0
+	 vadd.i64	d19,d30			@ h+=Maj from the past
+#endif
+	vshr.u64	d26,d23,#41
+	vld1.64		{d28},[r3,:64]!	@ K[i++]
+	vsli.64		d24,d23,#50
+	vsli.64		d25,d23,#46
+	vmov		d29,d23
+	vsli.64		d26,d23,#23
+#if 5<16 && defined(__ARMEL__)
+	vrev64.8	d5,d5
+#endif
+	veor		d25,d24
+	vbsl		d29,d16,d17		@ Ch(e,f,g)
+	vshr.u64	d24,d19,#28
+	veor		d26,d25			@ Sigma1(e)
+	vadd.i64	d27,d29,d18
+	vshr.u64	d25,d19,#34
+	vsli.64		d24,d19,#36
+	vadd.i64	d27,d26
+	vshr.u64	d26,d19,#39
+	vadd.i64	d28,d5
+	vsli.64		d25,d19,#30
+	veor		d30,d19,d20
+	vsli.64		d26,d19,#25
+	veor		d18,d24,d25
+	vadd.i64	d27,d28
+	vbsl		d30,d21,d20		@ Maj(a,b,c)
+	veor		d18,d26			@ Sigma0(a)
+	vadd.i64	d22,d27
+	vadd.i64	d30,d27
+	@ vadd.i64	d18,d30
+	vshr.u64	d24,d22,#14	@ 6
+#if 6<16
+	vld1.64		{d6},[r1]!	@ handles unaligned
+#endif
+	vshr.u64	d25,d22,#18
+#if 6>0
+	 vadd.i64	d18,d30			@ h+=Maj from the past
+#endif
+	vshr.u64	d26,d22,#41
+	vld1.64		{d28},[r3,:64]!	@ K[i++]
+	vsli.64		d24,d22,#50
+	vsli.64		d25,d22,#46
+	vmov		d29,d22
+	vsli.64		d26,d22,#23
+#if 6<16 && defined(__ARMEL__)
+	vrev64.8	d6,d6
+#endif
+	veor		d25,d24
+	vbsl		d29,d23,d16		@ Ch(e,f,g)
+	vshr.u64	d24,d18,#28
+	veor		d26,d25			@ Sigma1(e)
+	vadd.i64	d27,d29,d17
+	vshr.u64	d25,d18,#34
+	vsli.64		d24,d18,#36
+	vadd.i64	d27,d26
+	vshr.u64	d26,d18,#39
+	vadd.i64	d28,d6
+	vsli.64		d25,d18,#30
+	veor		d30,d18,d19
+	vsli.64		d26,d18,#25
+	veor		d17,d24,d25
+	vadd.i64	d27,d28
+	vbsl		d30,d20,d19		@ Maj(a,b,c)
+	veor		d17,d26			@ Sigma0(a)
+	vadd.i64	d21,d27
+	vadd.i64	d30,d27
+	@ vadd.i64	d17,d30
+	vshr.u64	d24,d21,#14	@ 7
+#if 7<16
+	vld1.64		{d7},[r1]!	@ handles unaligned
+#endif
+	vshr.u64	d25,d21,#18
+#if 7>0
+	 vadd.i64	d17,d30			@ h+=Maj from the past
+#endif
+	vshr.u64	d26,d21,#41
+	vld1.64		{d28},[r3,:64]!	@ K[i++]
+	vsli.64		d24,d21,#50
+	vsli.64		d25,d21,#46
+	vmov		d29,d21
+	vsli.64		d26,d21,#23
+#if 7<16 && defined(__ARMEL__)
+	vrev64.8	d7,d7
+#endif
+	veor		d25,d24
+	vbsl		d29,d22,d23		@ Ch(e,f,g)
+	vshr.u64	d24,d17,#28
+	veor		d26,d25			@ Sigma1(e)
+	vadd.i64	d27,d29,d16
+	vshr.u64	d25,d17,#34
+	vsli.64		d24,d17,#36
+	vadd.i64	d27,d26
+	vshr.u64	d26,d17,#39
+	vadd.i64	d28,d7
+	vsli.64		d25,d17,#30
+	veor		d30,d17,d18
+	vsli.64		d26,d17,#25
+	veor		d16,d24,d25
+	vadd.i64	d27,d28
+	vbsl		d30,d19,d18		@ Maj(a,b,c)
+	veor		d16,d26			@ Sigma0(a)
+	vadd.i64	d20,d27
+	vadd.i64	d30,d27
+	@ vadd.i64	d16,d30
+	vshr.u64	d24,d20,#14	@ 8
+#if 8<16
+	vld1.64		{d8},[r1]!	@ handles unaligned
+#endif
+	vshr.u64	d25,d20,#18
+#if 8>0
+	 vadd.i64	d16,d30			@ h+=Maj from the past
+#endif
+	vshr.u64	d26,d20,#41
+	vld1.64		{d28},[r3,:64]!	@ K[i++]
+	vsli.64		d24,d20,#50
+	vsli.64		d25,d20,#46
+	vmov		d29,d20
+	vsli.64		d26,d20,#23
+#if 8<16 && defined(__ARMEL__)
+	vrev64.8	d8,d8
+#endif
+	veor		d25,d24
+	vbsl		d29,d21,d22		@ Ch(e,f,g)
+	vshr.u64	d24,d16,#28
+	veor		d26,d25			@ Sigma1(e)
+	vadd.i64	d27,d29,d23
+	vshr.u64	d25,d16,#34
+	vsli.64		d24,d16,#36
+	vadd.i64	d27,d26
+	vshr.u64	d26,d16,#39
+	vadd.i64	d28,d8
+	vsli.64		d25,d16,#30
+	veor		d30,d16,d17
+	vsli.64		d26,d16,#25
+	veor		d23,d24,d25
+	vadd.i64	d27,d28
+	vbsl		d30,d18,d17		@ Maj(a,b,c)
+	veor		d23,d26			@ Sigma0(a)
+	vadd.i64	d19,d27
+	vadd.i64	d30,d27
+	@ vadd.i64	d23,d30
+	vshr.u64	d24,d19,#14	@ 9
+#if 9<16
+	vld1.64		{d9},[r1]!	@ handles unaligned
+#endif
+	vshr.u64	d25,d19,#18
+#if 9>0
+	 vadd.i64	d23,d30			@ h+=Maj from the past
+#endif
+	vshr.u64	d26,d19,#41
+	vld1.64		{d28},[r3,:64]!	@ K[i++]
+	vsli.64		d24,d19,#50
+	vsli.64		d25,d19,#46
+	vmov		d29,d19
+	vsli.64		d26,d19,#23
+#if 9<16 && defined(__ARMEL__)
+	vrev64.8	d9,d9
+#endif
+	veor		d25,d24
+	vbsl		d29,d20,d21		@ Ch(e,f,g)
+	vshr.u64	d24,d23,#28
+	veor		d26,d25			@ Sigma1(e)
+	vadd.i64	d27,d29,d22
+	vshr.u64	d25,d23,#34
+	vsli.64		d24,d23,#36
+	vadd.i64	d27,d26
+	vshr.u64	d26,d23,#39
+	vadd.i64	d28,d9
+	vsli.64		d25,d23,#30
+	veor		d30,d23,d16
+	vsli.64		d26,d23,#25
+	veor		d22,d24,d25
+	vadd.i64	d27,d28
+	vbsl		d30,d17,d16		@ Maj(a,b,c)
+	veor		d22,d26			@ Sigma0(a)
+	vadd.i64	d18,d27
+	vadd.i64	d30,d27
+	@ vadd.i64	d22,d30
+	vshr.u64	d24,d18,#14	@ 10
+#if 10<16
+	vld1.64		{d10},[r1]!	@ handles unaligned
+#endif
+	vshr.u64	d25,d18,#18
+#if 10>0
+	 vadd.i64	d22,d30			@ h+=Maj from the past
+#endif
+	vshr.u64	d26,d18,#41
+	vld1.64		{d28},[r3,:64]!	@ K[i++]
+	vsli.64		d24,d18,#50
+	vsli.64		d25,d18,#46
+	vmov		d29,d18
+	vsli.64		d26,d18,#23
+#if 10<16 && defined(__ARMEL__)
+	vrev64.8	d10,d10
+#endif
+	veor		d25,d24
+	vbsl		d29,d19,d20		@ Ch(e,f,g)
+	vshr.u64	d24,d22,#28
+	veor		d26,d25			@ Sigma1(e)
+	vadd.i64	d27,d29,d21
+	vshr.u64	d25,d22,#34
+	vsli.64		d24,d22,#36
+	vadd.i64	d27,d26
+	vshr.u64	d26,d22,#39
+	vadd.i64	d28,d10
+	vsli.64		d25,d22,#30
+	veor		d30,d22,d23
+	vsli.64		d26,d22,#25
+	veor		d21,d24,d25
+	vadd.i64	d27,d28
+	vbsl		d30,d16,d23		@ Maj(a,b,c)
+	veor		d21,d26			@ Sigma0(a)
+	vadd.i64	d17,d27
+	vadd.i64	d30,d27
+	@ vadd.i64	d21,d30
+	vshr.u64	d24,d17,#14	@ 11
+#if 11<16
+	vld1.64		{d11},[r1]!	@ handles unaligned
+#endif
+	vshr.u64	d25,d17,#18
+#if 11>0
+	 vadd.i64	d21,d30			@ h+=Maj from the past
+#endif
+	vshr.u64	d26,d17,#41
+	vld1.64		{d28},[r3,:64]!	@ K[i++]
+	vsli.64		d24,d17,#50
+	vsli.64		d25,d17,#46
+	vmov		d29,d17
+	vsli.64		d26,d17,#23
+#if 11<16 && defined(__ARMEL__)
+	vrev64.8	d11,d11
+#endif
+	veor		d25,d24
+	vbsl		d29,d18,d19		@ Ch(e,f,g)
+	vshr.u64	d24,d21,#28
+	veor		d26,d25			@ Sigma1(e)
+	vadd.i64	d27,d29,d20
+	vshr.u64	d25,d21,#34
+	vsli.64		d24,d21,#36
+	vadd.i64	d27,d26
+	vshr.u64	d26,d21,#39
+	vadd.i64	d28,d11
+	vsli.64		d25,d21,#30
+	veor		d30,d21,d22
+	vsli.64		d26,d21,#25
+	veor		d20,d24,d25
+	vadd.i64	d27,d28
+	vbsl		d30,d23,d22		@ Maj(a,b,c)
+	veor		d20,d26			@ Sigma0(a)
+	vadd.i64	d16,d27
+	vadd.i64	d30,d27
+	@ vadd.i64	d20,d30
+	vshr.u64	d24,d16,#14	@ 12
+#if 12<16
+	vld1.64		{d12},[r1]!	@ handles unaligned
+#endif
+	vshr.u64	d25,d16,#18
+#if 12>0
+	 vadd.i64	d20,d30			@ h+=Maj from the past
+#endif
+	vshr.u64	d26,d16,#41
+	vld1.64		{d28},[r3,:64]!	@ K[i++]
+	vsli.64		d24,d16,#50
+	vsli.64		d25,d16,#46
+	vmov		d29,d16
+	vsli.64		d26,d16,#23
+#if 12<16 && defined(__ARMEL__)
+	vrev64.8	d12,d12
+#endif
+	veor		d25,d24
+	vbsl		d29,d17,d18		@ Ch(e,f,g)
+	vshr.u64	d24,d20,#28
+	veor		d26,d25			@ Sigma1(e)
+	vadd.i64	d27,d29,d19
+	vshr.u64	d25,d20,#34
+	vsli.64		d24,d20,#36
+	vadd.i64	d27,d26
+	vshr.u64	d26,d20,#39
+	vadd.i64	d28,d12
+	vsli.64		d25,d20,#30
+	veor		d30,d20,d21
+	vsli.64		d26,d20,#25
+	veor		d19,d24,d25
+	vadd.i64	d27,d28
+	vbsl		d30,d22,d21		@ Maj(a,b,c)
+	veor		d19,d26			@ Sigma0(a)
+	vadd.i64	d23,d27
+	vadd.i64	d30,d27
+	@ vadd.i64	d19,d30
+	vshr.u64	d24,d23,#14	@ 13
+#if 13<16
+	vld1.64		{d13},[r1]!	@ handles unaligned
+#endif
+	vshr.u64	d25,d23,#18
+#if 13>0
+	 vadd.i64	d19,d30			@ h+=Maj from the past
+#endif
+	vshr.u64	d26,d23,#41
+	vld1.64		{d28},[r3,:64]!	@ K[i++]
+	vsli.64		d24,d23,#50
+	vsli.64		d25,d23,#46
+	vmov		d29,d23
+	vsli.64		d26,d23,#23
+#if 13<16 && defined(__ARMEL__)
+	vrev64.8	d13,d13
+#endif
+	veor		d25,d24
+	vbsl		d29,d16,d17		@ Ch(e,f,g)
+	vshr.u64	d24,d19,#28
+	veor		d26,d25			@ Sigma1(e)
+	vadd.i64	d27,d29,d18
+	vshr.u64	d25,d19,#34
+	vsli.64		d24,d19,#36
+	vadd.i64	d27,d26
+	vshr.u64	d26,d19,#39
+	vadd.i64	d28,d13
+	vsli.64		d25,d19,#30
+	veor		d30,d19,d20
+	vsli.64		d26,d19,#25
+	veor		d18,d24,d25
+	vadd.i64	d27,d28
+	vbsl		d30,d21,d20		@ Maj(a,b,c)
+	veor		d18,d26			@ Sigma0(a)
+	vadd.i64	d22,d27
+	vadd.i64	d30,d27
+	@ vadd.i64	d18,d30
+	vshr.u64	d24,d22,#14	@ 14
+#if 14<16
+	vld1.64		{d14},[r1]!	@ handles unaligned
+#endif
+	vshr.u64	d25,d22,#18
+#if 14>0
+	 vadd.i64	d18,d30			@ h+=Maj from the past
+#endif
+	vshr.u64	d26,d22,#41
+	vld1.64		{d28},[r3,:64]!	@ K[i++]
+	vsli.64		d24,d22,#50
+	vsli.64		d25,d22,#46
+	vmov		d29,d22
+	vsli.64		d26,d22,#23
+#if 14<16 && defined(__ARMEL__)
+	vrev64.8	d14,d14
+#endif
+	veor		d25,d24
+	vbsl		d29,d23,d16		@ Ch(e,f,g)
+	vshr.u64	d24,d18,#28
+	veor		d26,d25			@ Sigma1(e)
+	vadd.i64	d27,d29,d17
+	vshr.u64	d25,d18,#34
+	vsli.64		d24,d18,#36
+	vadd.i64	d27,d26
+	vshr.u64	d26,d18,#39
+	vadd.i64	d28,d14
+	vsli.64		d25,d18,#30
+	veor		d30,d18,d19
+	vsli.64		d26,d18,#25
+	veor		d17,d24,d25
+	vadd.i64	d27,d28
+	vbsl		d30,d20,d19		@ Maj(a,b,c)
+	veor		d17,d26			@ Sigma0(a)
+	vadd.i64	d21,d27
+	vadd.i64	d30,d27
+	@ vadd.i64	d17,d30
+	vshr.u64	d24,d21,#14	@ 15
+#if 15<16
+	vld1.64		{d15},[r1]!	@ handles unaligned
+#endif
+	vshr.u64	d25,d21,#18
+#if 15>0
+	 vadd.i64	d17,d30			@ h+=Maj from the past
+#endif
+	vshr.u64	d26,d21,#41
+	vld1.64		{d28},[r3,:64]!	@ K[i++]
+	vsli.64		d24,d21,#50
+	vsli.64		d25,d21,#46
+	vmov		d29,d21
+	vsli.64		d26,d21,#23
+#if 15<16 && defined(__ARMEL__)
+	vrev64.8	d15,d15
+#endif
+	veor		d25,d24
+	vbsl		d29,d22,d23		@ Ch(e,f,g)
+	vshr.u64	d24,d17,#28
+	veor		d26,d25			@ Sigma1(e)
+	vadd.i64	d27,d29,d16
+	vshr.u64	d25,d17,#34
+	vsli.64		d24,d17,#36
+	vadd.i64	d27,d26
+	vshr.u64	d26,d17,#39
+	vadd.i64	d28,d15
+	vsli.64		d25,d17,#30
+	veor		d30,d17,d18
+	vsli.64		d26,d17,#25
+	veor		d16,d24,d25
+	vadd.i64	d27,d28
+	vbsl		d30,d19,d18		@ Maj(a,b,c)
+	veor		d16,d26			@ Sigma0(a)
+	vadd.i64	d20,d27
+	vadd.i64	d30,d27
+	@ vadd.i64	d16,d30
+	mov		r12,#4
+.L16_79_neon:
+	subs		r12,#1
+	vshr.u64	q12,q7,#19
+	vshr.u64	q13,q7,#61
+	 vadd.i64	d16,d30			@ h+=Maj from the past
+	vshr.u64	q15,q7,#6
+	vsli.64		q12,q7,#45
+	vext.8		q14,q0,q1,#8	@ X[i+1]
+	vsli.64		q13,q7,#3
+	veor		q15,q12
+	vshr.u64	q12,q14,#1
+	veor		q15,q13				@ sigma1(X[i+14])
+	vshr.u64	q13,q14,#8
+	vadd.i64	q0,q15
+	vshr.u64	q15,q14,#7
+	vsli.64		q12,q14,#63
+	vsli.64		q13,q14,#56
+	vext.8		q14,q4,q5,#8	@ X[i+9]
+	veor		q15,q12
+	vshr.u64	d24,d20,#14		@ from NEON_00_15
+	vadd.i64	q0,q14
+	vshr.u64	d25,d20,#18		@ from NEON_00_15
+	veor		q15,q13				@ sigma0(X[i+1])
+	vshr.u64	d26,d20,#41		@ from NEON_00_15
+	vadd.i64	q0,q15
+	vld1.64		{d28},[r3,:64]!	@ K[i++]
+	vsli.64		d24,d20,#50
+	vsli.64		d25,d20,#46
+	vmov		d29,d20
+	vsli.64		d26,d20,#23
+#if 16<16 && defined(__ARMEL__)
+	vrev64.8	,
+#endif
+	veor		d25,d24
+	vbsl		d29,d21,d22		@ Ch(e,f,g)
+	vshr.u64	d24,d16,#28
+	veor		d26,d25			@ Sigma1(e)
+	vadd.i64	d27,d29,d23
+	vshr.u64	d25,d16,#34
+	vsli.64		d24,d16,#36
+	vadd.i64	d27,d26
+	vshr.u64	d26,d16,#39
+	vadd.i64	d28,d0
+	vsli.64		d25,d16,#30
+	veor		d30,d16,d17
+	vsli.64		d26,d16,#25
+	veor		d23,d24,d25
+	vadd.i64	d27,d28
+	vbsl		d30,d18,d17		@ Maj(a,b,c)
+	veor		d23,d26			@ Sigma0(a)
+	vadd.i64	d19,d27
+	vadd.i64	d30,d27
+	@ vadd.i64	d23,d30
+	vshr.u64	d24,d19,#14	@ 17
+#if 17<16
+	vld1.64		{d1},[r1]!	@ handles unaligned
+#endif
+	vshr.u64	d25,d19,#18
+#if 17>0
+	 vadd.i64	d23,d30			@ h+=Maj from the past
+#endif
+	vshr.u64	d26,d19,#41
+	vld1.64		{d28},[r3,:64]!	@ K[i++]
+	vsli.64		d24,d19,#50
+	vsli.64		d25,d19,#46
+	vmov		d29,d19
+	vsli.64		d26,d19,#23
+#if 17<16 && defined(__ARMEL__)
+	vrev64.8	,
+#endif
+	veor		d25,d24
+	vbsl		d29,d20,d21		@ Ch(e,f,g)
+	vshr.u64	d24,d23,#28
+	veor		d26,d25			@ Sigma1(e)
+	vadd.i64	d27,d29,d22
+	vshr.u64	d25,d23,#34
+	vsli.64		d24,d23,#36
+	vadd.i64	d27,d26
+	vshr.u64	d26,d23,#39
+	vadd.i64	d28,d1
+	vsli.64		d25,d23,#30
+	veor		d30,d23,d16
+	vsli.64		d26,d23,#25
+	veor		d22,d24,d25
+	vadd.i64	d27,d28
+	vbsl		d30,d17,d16		@ Maj(a,b,c)
+	veor		d22,d26			@ Sigma0(a)
+	vadd.i64	d18,d27
+	vadd.i64	d30,d27
+	@ vadd.i64	d22,d30
+	vshr.u64	q12,q0,#19
+	vshr.u64	q13,q0,#61
+	 vadd.i64	d22,d30			@ h+=Maj from the past
+	vshr.u64	q15,q0,#6
+	vsli.64		q12,q0,#45
+	vext.8		q14,q1,q2,#8	@ X[i+1]
+	vsli.64		q13,q0,#3
+	veor		q15,q12
+	vshr.u64	q12,q14,#1
+	veor		q15,q13				@ sigma1(X[i+14])
+	vshr.u64	q13,q14,#8
+	vadd.i64	q1,q15
+	vshr.u64	q15,q14,#7
+	vsli.64		q12,q14,#63
+	vsli.64		q13,q14,#56
+	vext.8		q14,q5,q6,#8	@ X[i+9]
+	veor		q15,q12
+	vshr.u64	d24,d18,#14		@ from NEON_00_15
+	vadd.i64	q1,q14
+	vshr.u64	d25,d18,#18		@ from NEON_00_15
+	veor		q15,q13				@ sigma0(X[i+1])
+	vshr.u64	d26,d18,#41		@ from NEON_00_15
+	vadd.i64	q1,q15
+	vld1.64		{d28},[r3,:64]!	@ K[i++]
+	vsli.64		d24,d18,#50
+	vsli.64		d25,d18,#46
+	vmov		d29,d18
+	vsli.64		d26,d18,#23
+#if 18<16 && defined(__ARMEL__)
+	vrev64.8	,
+#endif
+	veor		d25,d24
+	vbsl		d29,d19,d20		@ Ch(e,f,g)
+	vshr.u64	d24,d22,#28
+	veor		d26,d25			@ Sigma1(e)
+	vadd.i64	d27,d29,d21
+	vshr.u64	d25,d22,#34
+	vsli.64		d24,d22,#36
+	vadd.i64	d27,d26
+	vshr.u64	d26,d22,#39
+	vadd.i64	d28,d2
+	vsli.64		d25,d22,#30
+	veor		d30,d22,d23
+	vsli.64		d26,d22,#25
+	veor		d21,d24,d25
+	vadd.i64	d27,d28
+	vbsl		d30,d16,d23		@ Maj(a,b,c)
+	veor		d21,d26			@ Sigma0(a)
+	vadd.i64	d17,d27
+	vadd.i64	d30,d27
+	@ vadd.i64	d21,d30
+	vshr.u64	d24,d17,#14	@ 19
+#if 19<16
+	vld1.64		{d3},[r1]!	@ handles unaligned
+#endif
+	vshr.u64	d25,d17,#18
+#if 19>0
+	 vadd.i64	d21,d30			@ h+=Maj from the past
+#endif
+	vshr.u64	d26,d17,#41
+	vld1.64		{d28},[r3,:64]!	@ K[i++]
+	vsli.64		d24,d17,#50
+	vsli.64		d25,d17,#46
+	vmov		d29,d17
+	vsli.64		d26,d17,#23
+#if 19<16 && defined(__ARMEL__)
+	vrev64.8	,
+#endif
+	veor		d25,d24
+	vbsl		d29,d18,d19		@ Ch(e,f,g)
+	vshr.u64	d24,d21,#28
+	veor		d26,d25			@ Sigma1(e)
+	vadd.i64	d27,d29,d20
+	vshr.u64	d25,d21,#34
+	vsli.64		d24,d21,#36
+	vadd.i64	d27,d26
+	vshr.u64	d26,d21,#39
+	vadd.i64	d28,d3
+	vsli.64		d25,d21,#30
+	veor		d30,d21,d22
+	vsli.64		d26,d21,#25
+	veor		d20,d24,d25
+	vadd.i64	d27,d28
+	vbsl		d30,d23,d22		@ Maj(a,b,c)
+	veor		d20,d26			@ Sigma0(a)
+	vadd.i64	d16,d27
+	vadd.i64	d30,d27
+	@ vadd.i64	d20,d30
+	vshr.u64	q12,q1,#19
+	vshr.u64	q13,q1,#61
+	 vadd.i64	d20,d30			@ h+=Maj from the past
+	vshr.u64	q15,q1,#6
+	vsli.64		q12,q1,#45
+	vext.8		q14,q2,q3,#8	@ X[i+1]
+	vsli.64		q13,q1,#3
+	veor		q15,q12
+	vshr.u64	q12,q14,#1
+	veor		q15,q13				@ sigma1(X[i+14])
+	vshr.u64	q13,q14,#8
+	vadd.i64	q2,q15
+	vshr.u64	q15,q14,#7
+	vsli.64		q12,q14,#63
+	vsli.64		q13,q14,#56
+	vext.8		q14,q6,q7,#8	@ X[i+9]
+	veor		q15,q12
+	vshr.u64	d24,d16,#14		@ from NEON_00_15
+	vadd.i64	q2,q14
+	vshr.u64	d25,d16,#18		@ from NEON_00_15
+	veor		q15,q13				@ sigma0(X[i+1])
+	vshr.u64	d26,d16,#41		@ from NEON_00_15
+	vadd.i64	q2,q15
+	vld1.64		{d28},[r3,:64]!	@ K[i++]
+	vsli.64		d24,d16,#50
+	vsli.64		d25,d16,#46
+	vmov		d29,d16
+	vsli.64		d26,d16,#23
+#if 20<16 && defined(__ARMEL__)
+	vrev64.8	,
+#endif
+	veor		d25,d24
+	vbsl		d29,d17,d18		@ Ch(e,f,g)
+	vshr.u64	d24,d20,#28
+	veor		d26,d25			@ Sigma1(e)
+	vadd.i64	d27,d29,d19
+	vshr.u64	d25,d20,#34
+	vsli.64		d24,d20,#36
+	vadd.i64	d27,d26
+	vshr.u64	d26,d20,#39
+	vadd.i64	d28,d4
+	vsli.64		d25,d20,#30
+	veor		d30,d20,d21
+	vsli.64		d26,d20,#25
+	veor		d19,d24,d25
+	vadd.i64	d27,d28
+	vbsl		d30,d22,d21		@ Maj(a,b,c)
+	veor		d19,d26			@ Sigma0(a)
+	vadd.i64	d23,d27
+	vadd.i64	d30,d27
+	@ vadd.i64	d19,d30
+	vshr.u64	d24,d23,#14	@ 21
+#if 21<16
+	vld1.64		{d5},[r1]!	@ handles unaligned
+#endif
+	vshr.u64	d25,d23,#18
+#if 21>0
+	 vadd.i64	d19,d30			@ h+=Maj from the past
+#endif
+	vshr.u64	d26,d23,#41
+	vld1.64		{d28},[r3,:64]!	@ K[i++]
+	vsli.64		d24,d23,#50
+	vsli.64		d25,d23,#46
+	vmov		d29,d23
+	vsli.64		d26,d23,#23
+#if 21<16 && defined(__ARMEL__)
+	vrev64.8	,
+#endif
+	veor		d25,d24
+	vbsl		d29,d16,d17		@ Ch(e,f,g)
+	vshr.u64	d24,d19,#28
+	veor		d26,d25			@ Sigma1(e)
+	vadd.i64	d27,d29,d18
+	vshr.u64	d25,d19,#34
+	vsli.64		d24,d19,#36
+	vadd.i64	d27,d26
+	vshr.u64	d26,d19,#39
+	vadd.i64	d28,d5
+	vsli.64		d25,d19,#30
+	veor		d30,d19,d20
+	vsli.64		d26,d19,#25
+	veor		d18,d24,d25
+	vadd.i64	d27,d28
+	vbsl		d30,d21,d20		@ Maj(a,b,c)
+	veor		d18,d26			@ Sigma0(a)
+	vadd.i64	d22,d27
+	vadd.i64	d30,d27
+	@ vadd.i64	d18,d30
+	vshr.u64	q12,q2,#19
+	vshr.u64	q13,q2,#61
+	 vadd.i64	d18,d30			@ h+=Maj from the past
+	vshr.u64	q15,q2,#6
+	vsli.64		q12,q2,#45
+	vext.8		q14,q3,q4,#8	@ X[i+1]
+	vsli.64		q13,q2,#3
+	veor		q15,q12
+	vshr.u64	q12,q14,#1
+	veor		q15,q13				@ sigma1(X[i+14])
+	vshr.u64	q13,q14,#8
+	vadd.i64	q3,q15
+	vshr.u64	q15,q14,#7
+	vsli.64		q12,q14,#63
+	vsli.64		q13,q14,#56
+	vext.8		q14,q7,q0,#8	@ X[i+9]
+	veor		q15,q12
+	vshr.u64	d24,d22,#14		@ from NEON_00_15
+	vadd.i64	q3,q14
+	vshr.u64	d25,d22,#18		@ from NEON_00_15
+	veor		q15,q13				@ sigma0(X[i+1])
+	vshr.u64	d26,d22,#41		@ from NEON_00_15
+	vadd.i64	q3,q15
+	vld1.64		{d28},[r3,:64]!	@ K[i++]
+	vsli.64		d24,d22,#50
+	vsli.64		d25,d22,#46
+	vmov		d29,d22
+	vsli.64		d26,d22,#23
+#if 22<16 && defined(__ARMEL__)
+	vrev64.8	,
+#endif
+	veor		d25,d24
+	vbsl		d29,d23,d16		@ Ch(e,f,g)
+	vshr.u64	d24,d18,#28
+	veor		d26,d25			@ Sigma1(e)
+	vadd.i64	d27,d29,d17
+	vshr.u64	d25,d18,#34
+	vsli.64		d24,d18,#36
+	vadd.i64	d27,d26
+	vshr.u64	d26,d18,#39
+	vadd.i64	d28,d6
+	vsli.64		d25,d18,#30
+	veor		d30,d18,d19
+	vsli.64		d26,d18,#25
+	veor		d17,d24,d25
+	vadd.i64	d27,d28
+	vbsl		d30,d20,d19		@ Maj(a,b,c)
+	veor		d17,d26			@ Sigma0(a)
+	vadd.i64	d21,d27
+	vadd.i64	d30,d27
+	@ vadd.i64	d17,d30
+	vshr.u64	d24,d21,#14	@ 23
+#if 23<16
+	vld1.64		{d7},[r1]!	@ handles unaligned
+#endif
+	vshr.u64	d25,d21,#18
+#if 23>0
+	 vadd.i64	d17,d30			@ h+=Maj from the past
+#endif
+	vshr.u64	d26,d21,#41
+	vld1.64		{d28},[r3,:64]!	@ K[i++]
+	vsli.64		d24,d21,#50
+	vsli.64		d25,d21,#46
+	vmov		d29,d21
+	vsli.64		d26,d21,#23
+#if 23<16 && defined(__ARMEL__)
+	vrev64.8	,
+#endif
+	veor		d25,d24
+	vbsl		d29,d22,d23		@ Ch(e,f,g)
+	vshr.u64	d24,d17,#28
+	veor		d26,d25			@ Sigma1(e)
+	vadd.i64	d27,d29,d16
+	vshr.u64	d25,d17,#34
+	vsli.64		d24,d17,#36
+	vadd.i64	d27,d26
+	vshr.u64	d26,d17,#39
+	vadd.i64	d28,d7
+	vsli.64		d25,d17,#30
+	veor		d30,d17,d18
+	vsli.64		d26,d17,#25
+	veor		d16,d24,d25
+	vadd.i64	d27,d28
+	vbsl		d30,d19,d18		@ Maj(a,b,c)
+	veor		d16,d26			@ Sigma0(a)
+	vadd.i64	d20,d27
+	vadd.i64	d30,d27
+	@ vadd.i64	d16,d30
+	vshr.u64	q12,q3,#19
+	vshr.u64	q13,q3,#61
+	 vadd.i64	d16,d30			@ h+=Maj from the past
+	vshr.u64	q15,q3,#6
+	vsli.64		q12,q3,#45
+	vext.8		q14,q4,q5,#8	@ X[i+1]
+	vsli.64		q13,q3,#3
+	veor		q15,q12
+	vshr.u64	q12,q14,#1
+	veor		q15,q13				@ sigma1(X[i+14])
+	vshr.u64	q13,q14,#8
+	vadd.i64	q4,q15
+	vshr.u64	q15,q14,#7
+	vsli.64		q12,q14,#63
+	vsli.64		q13,q14,#56
+	vext.8		q14,q0,q1,#8	@ X[i+9]
+	veor		q15,q12
+	vshr.u64	d24,d20,#14		@ from NEON_00_15
+	vadd.i64	q4,q14
+	vshr.u64	d25,d20,#18		@ from NEON_00_15
+	veor		q15,q13				@ sigma0(X[i+1])
+	vshr.u64	d26,d20,#41		@ from NEON_00_15
+	vadd.i64	q4,q15
+	vld1.64		{d28},[r3,:64]!	@ K[i++]
+	vsli.64		d24,d20,#50
+	vsli.64		d25,d20,#46
+	vmov		d29,d20
+	vsli.64		d26,d20,#23
+#if 24<16 && defined(__ARMEL__)
+	vrev64.8	,
+#endif
+	veor		d25,d24
+	vbsl		d29,d21,d22		@ Ch(e,f,g)
+	vshr.u64	d24,d16,#28
+	veor		d26,d25			@ Sigma1(e)
+	vadd.i64	d27,d29,d23
+	vshr.u64	d25,d16,#34
+	vsli.64		d24,d16,#36
+	vadd.i64	d27,d26
+	vshr.u64	d26,d16,#39
+	vadd.i64	d28,d8
+	vsli.64		d25,d16,#30
+	veor		d30,d16,d17
+	vsli.64		d26,d16,#25
+	veor		d23,d24,d25
+	vadd.i64	d27,d28
+	vbsl		d30,d18,d17		@ Maj(a,b,c)
+	veor		d23,d26			@ Sigma0(a)
+	vadd.i64	d19,d27
+	vadd.i64	d30,d27
+	@ vadd.i64	d23,d30
+	vshr.u64	d24,d19,#14	@ 25
+#if 25<16
+	vld1.64		{d9},[r1]!	@ handles unaligned
+#endif
+	vshr.u64	d25,d19,#18
+#if 25>0
+	 vadd.i64	d23,d30			@ h+=Maj from the past
+#endif
+	vshr.u64	d26,d19,#41
+	vld1.64		{d28},[r3,:64]!	@ K[i++]
+	vsli.64		d24,d19,#50
+	vsli.64		d25,d19,#46
+	vmov		d29,d19
+	vsli.64		d26,d19,#23
+#if 25<16 && defined(__ARMEL__)
+	vrev64.8	,
+#endif
+	veor		d25,d24
+	vbsl		d29,d20,d21		@ Ch(e,f,g)
+	vshr.u64	d24,d23,#28
+	veor		d26,d25			@ Sigma1(e)
+	vadd.i64	d27,d29,d22
+	vshr.u64	d25,d23,#34
+	vsli.64		d24,d23,#36
+	vadd.i64	d27,d26
+	vshr.u64	d26,d23,#39
+	vadd.i64	d28,d9
+	vsli.64		d25,d23,#30
+	veor		d30,d23,d16
+	vsli.64		d26,d23,#25
+	veor		d22,d24,d25
+	vadd.i64	d27,d28
+	vbsl		d30,d17,d16		@ Maj(a,b,c)
+	veor		d22,d26			@ Sigma0(a)
+	vadd.i64	d18,d27
+	vadd.i64	d30,d27
+	@ vadd.i64	d22,d30
+	vshr.u64	q12,q4,#19
+	vshr.u64	q13,q4,#61
+	 vadd.i64	d22,d30			@ h+=Maj from the past
+	vshr.u64	q15,q4,#6
+	vsli.64		q12,q4,#45
+	vext.8		q14,q5,q6,#8	@ X[i+1]
+	vsli.64		q13,q4,#3
+	veor		q15,q12
+	vshr.u64	q12,q14,#1
+	veor		q15,q13				@ sigma1(X[i+14])
+	vshr.u64	q13,q14,#8
+	vadd.i64	q5,q15
+	vshr.u64	q15,q14,#7
+	vsli.64		q12,q14,#63
+	vsli.64		q13,q14,#56
+	vext.8		q14,q1,q2,#8	@ X[i+9]
+	veor		q15,q12
+	vshr.u64	d24,d18,#14		@ from NEON_00_15
+	vadd.i64	q5,q14
+	vshr.u64	d25,d18,#18		@ from NEON_00_15
+	veor		q15,q13				@ sigma0(X[i+1])
+	vshr.u64	d26,d18,#41		@ from NEON_00_15
+	vadd.i64	q5,q15
+	vld1.64		{d28},[r3,:64]!	@ K[i++]
+	vsli.64		d24,d18,#50
+	vsli.64		d25,d18,#46
+	vmov		d29,d18
+	vsli.64		d26,d18,#23
+#if 26<16 && defined(__ARMEL__)
+	vrev64.8	,
+#endif
+	veor		d25,d24
+	vbsl		d29,d19,d20		@ Ch(e,f,g)
+	vshr.u64	d24,d22,#28
+	veor		d26,d25			@ Sigma1(e)
+	vadd.i64	d27,d29,d21
+	vshr.u64	d25,d22,#34
+	vsli.64		d24,d22,#36
+	vadd.i64	d27,d26
+	vshr.u64	d26,d22,#39
+	vadd.i64	d28,d10
+	vsli.64		d25,d22,#30
+	veor		d30,d22,d23
+	vsli.64		d26,d22,#25
+	veor		d21,d24,d25
+	vadd.i64	d27,d28
+	vbsl		d30,d16,d23		@ Maj(a,b,c)
+	veor		d21,d26			@ Sigma0(a)
+	vadd.i64	d17,d27
+	vadd.i64	d30,d27
+	@ vadd.i64	d21,d30
+	vshr.u64	d24,d17,#14	@ 27
+#if 27<16
+	vld1.64		{d11},[r1]!	@ handles unaligned
+#endif
+	vshr.u64	d25,d17,#18
+#if 27>0
+	 vadd.i64	d21,d30			@ h+=Maj from the past
+#endif
+	vshr.u64	d26,d17,#41
+	vld1.64		{d28},[r3,:64]!	@ K[i++]
+	vsli.64		d24,d17,#50
+	vsli.64		d25,d17,#46
+	vmov		d29,d17
+	vsli.64		d26,d17,#23
+#if 27<16 && defined(__ARMEL__)
+	vrev64.8	,
+#endif
+	veor		d25,d24
+	vbsl		d29,d18,d19		@ Ch(e,f,g)
+	vshr.u64	d24,d21,#28
+	veor		d26,d25			@ Sigma1(e)
+	vadd.i64	d27,d29,d20
+	vshr.u64	d25,d21,#34
+	vsli.64		d24,d21,#36
+	vadd.i64	d27,d26
+	vshr.u64	d26,d21,#39
+	vadd.i64	d28,d11
+	vsli.64		d25,d21,#30
+	veor		d30,d21,d22
+	vsli.64		d26,d21,#25
+	veor		d20,d24,d25
+	vadd.i64	d27,d28
+	vbsl		d30,d23,d22		@ Maj(a,b,c)
+	veor		d20,d26			@ Sigma0(a)
+	vadd.i64	d16,d27
+	vadd.i64	d30,d27
+	@ vadd.i64	d20,d30
+	vshr.u64	q12,q5,#19
+	vshr.u64	q13,q5,#61
+	 vadd.i64	d20,d30			@ h+=Maj from the past
+	vshr.u64	q15,q5,#6
+	vsli.64		q12,q5,#45
+	vext.8		q14,q6,q7,#8	@ X[i+1]
+	vsli.64		q13,q5,#3
+	veor		q15,q12
+	vshr.u64	q12,q14,#1
+	veor		q15,q13				@ sigma1(X[i+14])
+	vshr.u64	q13,q14,#8
+	vadd.i64	q6,q15
+	vshr.u64	q15,q14,#7
+	vsli.64		q12,q14,#63
+	vsli.64		q13,q14,#56
+	vext.8		q14,q2,q3,#8	@ X[i+9]
+	veor		q15,q12
+	vshr.u64	d24,d16,#14		@ from NEON_00_15
+	vadd.i64	q6,q14
+	vshr.u64	d25,d16,#18		@ from NEON_00_15
+	veor		q15,q13				@ sigma0(X[i+1])
+	vshr.u64	d26,d16,#41		@ from NEON_00_15
+	vadd.i64	q6,q15
+	vld1.64		{d28},[r3,:64]!	@ K[i++]
+	vsli.64		d24,d16,#50
+	vsli.64		d25,d16,#46
+	vmov		d29,d16
+	vsli.64		d26,d16,#23
+#if 28<16 && defined(__ARMEL__)
+	vrev64.8	,
+#endif
+	veor		d25,d24
+	vbsl		d29,d17,d18		@ Ch(e,f,g)
+	vshr.u64	d24,d20,#28
+	veor		d26,d25			@ Sigma1(e)
+	vadd.i64	d27,d29,d19
+	vshr.u64	d25,d20,#34
+	vsli.64		d24,d20,#36
+	vadd.i64	d27,d26
+	vshr.u64	d26,d20,#39
+	vadd.i64	d28,d12
+	vsli.64		d25,d20,#30
+	veor		d30,d20,d21
+	vsli.64		d26,d20,#25
+	veor		d19,d24,d25
+	vadd.i64	d27,d28
+	vbsl		d30,d22,d21		@ Maj(a,b,c)
+	veor		d19,d26			@ Sigma0(a)
+	vadd.i64	d23,d27
+	vadd.i64	d30,d27
+	@ vadd.i64	d19,d30
+	vshr.u64	d24,d23,#14	@ 29
+#if 29<16
+	vld1.64		{d13},[r1]!	@ handles unaligned
+#endif
+	vshr.u64	d25,d23,#18
+#if 29>0
+	 vadd.i64	d19,d30			@ h+=Maj from the past
+#endif
+	vshr.u64	d26,d23,#41
+	vld1.64		{d28},[r3,:64]!	@ K[i++]
+	vsli.64		d24,d23,#50
+	vsli.64		d25,d23,#46
+	vmov		d29,d23
+	vsli.64		d26,d23,#23
+#if 29<16 && defined(__ARMEL__)
+	vrev64.8	,
+#endif
+	veor		d25,d24
+	vbsl		d29,d16,d17		@ Ch(e,f,g)
+	vshr.u64	d24,d19,#28
+	veor		d26,d25			@ Sigma1(e)
+	vadd.i64	d27,d29,d18
+	vshr.u64	d25,d19,#34
+	vsli.64		d24,d19,#36
+	vadd.i64	d27,d26
+	vshr.u64	d26,d19,#39
+	vadd.i64	d28,d13
+	vsli.64		d25,d19,#30
+	veor		d30,d19,d20
+	vsli.64		d26,d19,#25
+	veor		d18,d24,d25
+	vadd.i64	d27,d28
+	vbsl		d30,d21,d20		@ Maj(a,b,c)
+	veor		d18,d26			@ Sigma0(a)
+	vadd.i64	d22,d27
+	vadd.i64	d30,d27
+	@ vadd.i64	d18,d30
+	vshr.u64	q12,q6,#19
+	vshr.u64	q13,q6,#61
+	 vadd.i64	d18,d30			@ h+=Maj from the past
+	vshr.u64	q15,q6,#6
+	vsli.64		q12,q6,#45
+	vext.8		q14,q7,q0,#8	@ X[i+1]
+	vsli.64		q13,q6,#3
+	veor		q15,q12
+	vshr.u64	q12,q14,#1
+	veor		q15,q13				@ sigma1(X[i+14])
+	vshr.u64	q13,q14,#8
+	vadd.i64	q7,q15
+	vshr.u64	q15,q14,#7
+	vsli.64		q12,q14,#63
+	vsli.64		q13,q14,#56
+	vext.8		q14,q3,q4,#8	@ X[i+9]
+	veor		q15,q12
+	vshr.u64	d24,d22,#14		@ from NEON_00_15
+	vadd.i64	q7,q14
+	vshr.u64	d25,d22,#18		@ from NEON_00_15
+	veor		q15,q13				@ sigma0(X[i+1])
+	vshr.u64	d26,d22,#41		@ from NEON_00_15
+	vadd.i64	q7,q15
+	vld1.64		{d28},[r3,:64]!	@ K[i++]
+	vsli.64		d24,d22,#50
+	vsli.64		d25,d22,#46
+	vmov		d29,d22
+	vsli.64		d26,d22,#23
+#if 30<16 && defined(__ARMEL__)
+	vrev64.8	,
+#endif
+	veor		d25,d24
+	vbsl		d29,d23,d16		@ Ch(e,f,g)
+	vshr.u64	d24,d18,#28
+	veor		d26,d25			@ Sigma1(e)
+	vadd.i64	d27,d29,d17
+	vshr.u64	d25,d18,#34
+	vsli.64		d24,d18,#36
+	vadd.i64	d27,d26
+	vshr.u64	d26,d18,#39
+	vadd.i64	d28,d14
+	vsli.64		d25,d18,#30
+	veor		d30,d18,d19
+	vsli.64		d26,d18,#25
+	veor		d17,d24,d25
+	vadd.i64	d27,d28
+	vbsl		d30,d20,d19		@ Maj(a,b,c)
+	veor		d17,d26			@ Sigma0(a)
+	vadd.i64	d21,d27
+	vadd.i64	d30,d27
+	@ vadd.i64	d17,d30
+	vshr.u64	d24,d21,#14	@ 31
+#if 31<16
+	vld1.64		{d15},[r1]!	@ handles unaligned
+#endif
+	vshr.u64	d25,d21,#18
+#if 31>0
+	 vadd.i64	d17,d30			@ h+=Maj from the past
+#endif
+	vshr.u64	d26,d21,#41
+	vld1.64		{d28},[r3,:64]!	@ K[i++]
+	vsli.64		d24,d21,#50
+	vsli.64		d25,d21,#46
+	vmov		d29,d21
+	vsli.64		d26,d21,#23
+#if 31<16 && defined(__ARMEL__)
+	vrev64.8	,
+#endif
+	veor		d25,d24
+	vbsl		d29,d22,d23		@ Ch(e,f,g)
+	vshr.u64	d24,d17,#28
+	veor		d26,d25			@ Sigma1(e)
+	vadd.i64	d27,d29,d16
+	vshr.u64	d25,d17,#34
+	vsli.64		d24,d17,#36
+	vadd.i64	d27,d26
+	vshr.u64	d26,d17,#39
+	vadd.i64	d28,d15
+	vsli.64		d25,d17,#30
+	veor		d30,d17,d18
+	vsli.64		d26,d17,#25
+	veor		d16,d24,d25
+	vadd.i64	d27,d28
+	vbsl		d30,d19,d18		@ Maj(a,b,c)
+	veor		d16,d26			@ Sigma0(a)
+	vadd.i64	d20,d27
+	vadd.i64	d30,d27
+	@ vadd.i64	d16,d30
+	bne		.L16_79_neon
+
+	 vadd.i64	d16,d30		@ h+=Maj from the past
+	vldmia		r0,{d24-d31}	@ load context to temp
+	vadd.i64	q8,q12		@ vectorized accumulate
+	vadd.i64	q9,q13
+	vadd.i64	q10,q14
+	vadd.i64	q11,q15
+	vstmia		r0,{d16-d23}	@ save context
+	teq		r1,r2
+	sub		r3,#640	@ rewind K512
+	bne		.Loop_neon
+
+	VFP_ABI_POP
+	bx	lr				@ .word	0xe12fff1e
+.size	sha512_block_data_order_neon,.-sha512_block_data_order_neon
+#endif
+.asciz	"SHA512 block transform for ARMv4/NEON, CRYPTOGAMS by <appro@openssl.org>"
+.align	2
+#if __ARM_MAX_ARCH__>=7 && !defined(__KERNEL__)
+.comm	OPENSSL_armcap_P,4,4
+#endif
diff --git a/arch/arm/crypto/sha512-glue.c b/arch/arm/crypto/sha512-glue.c
new file mode 100644
index 000000000000..216e91c6aeb0
--- /dev/null
+++ b/arch/arm/crypto/sha512-glue.c
@@ -0,0 +1,137 @@
+/*
+ * sha512-glue.c - accelerated SHA-384/512 for ARM
+ *
+ * Copyright (C) 2015 Linaro Ltd <ard.biesheuvel@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <crypto/internal/hash.h>
+#include <crypto/sha.h>
+#include <linux/crypto.h>
+#include <linux/module.h>
+
+#include <asm/hwcap.h>
+#include <asm/neon.h>
+#include <asm/unaligned.h>
+
+#include "sha512.h"
+
+MODULE_DESCRIPTION("Accelerated SHA-384/SHA-512 secure hash for ARM");
+MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
+MODULE_LICENSE("GPL v2");
+
+MODULE_ALIAS_CRYPTO("sha384");
+MODULE_ALIAS_CRYPTO("sha512");
+MODULE_ALIAS_CRYPTO("sha384-arm");
+MODULE_ALIAS_CRYPTO("sha512-arm");
+
+asmlinkage void sha512_block_data_order(u64 *state, u8 const *src, int blocks);
+
+static void sha512_arm_transform(int blocks, u8 const *src, u64 *state,
+				 const u8 *head, void *p)
+{
+	if (head)
+		sha512_block_data_order(state, head, 1);
+	if (blocks)
+		sha512_block_data_order(state, src, blocks);
+}
+
+int sha512_arm_update(struct shash_desc *desc, const u8 *data,
+		      unsigned int len)
+{
+	return sha512_base_do_update(desc, data, len, sha512_arm_transform,
+				     NULL);
+}
+
+int sha512_arm_finup(struct shash_desc *desc, const u8 *data,
+		     unsigned int len, u8 *out)
+{
+	if (len)
+		sha512_base_do_update(desc, data, len, sha512_arm_transform,
+				      NULL);
+	sha512_base_do_finalize(desc, sha512_arm_transform, NULL);
+
+	return sha512_base_finish(desc, out);
+}
+
+int sha512_arm_final(struct shash_desc *desc, u8 *out)
+{
+	return sha512_arm_finup(desc, NULL, 0, out);
+}
+
+static struct shash_alg sha512_arm_algs[] = { {
+	.init			= sha384_base_init,
+	.update			= sha512_arm_update,
+	.final			= sha512_arm_final,
+	.finup			= sha512_arm_finup,
+	.export			= sha512_base_export,
+	.import			= sha512_base_import,
+	.descsize		= sizeof(struct sha512_state),
+	.digestsize		= SHA384_DIGEST_SIZE,
+	.statesize		= sizeof(struct sha512_state),
+	.base			= {
+		.cra_name		= "sha384",
+		.cra_driver_name	= "sha384-arm",
+		.cra_priority		= 250,
+		.cra_flags		= CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize		= SHA512_BLOCK_SIZE,
+		.cra_module		= THIS_MODULE,
+	}
+},  {
+	.init			= sha512_base_init,
+	.update			= sha512_arm_update,
+	.final			= sha512_arm_final,
+	.finup			= sha512_arm_finup,
+	.export			= sha512_base_export,
+	.import			= sha512_base_import,
+	.descsize		= sizeof(struct sha512_state),
+	.digestsize		= SHA512_DIGEST_SIZE,
+	.statesize		= sizeof(struct sha512_state),
+	.base			= {
+		.cra_name		= "sha512",
+		.cra_driver_name	= "sha512-arm",
+		.cra_priority		= 250,
+		.cra_flags		= CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize		= SHA512_BLOCK_SIZE,
+		.cra_module		= THIS_MODULE,
+	}
+} };
+
+static int __init sha512_arm_mod_init(void)
+{
+	int err;
+
+	err = crypto_register_shashes(sha512_arm_algs,
+				      ARRAY_SIZE(sha512_arm_algs));
+	if (err)
+		return err;
+
+	if (IS_ENABLED(CONFIG_KERNEL_MODE_NEON) && cpu_has_neon()) {
+		err = crypto_register_shashes(sha512_neon_algs,
+					      ARRAY_SIZE(sha512_neon_algs));
+		if (err)
+			goto err_unregister;
+	}
+	return 0;
+
+err_unregister:
+	crypto_unregister_shashes(sha512_arm_algs,
+				  ARRAY_SIZE(sha512_arm_algs));
+
+	return err;
+}
+
+static void __exit sha512_arm_mod_fini(void)
+{
+	crypto_unregister_shashes(sha512_arm_algs,
+				  ARRAY_SIZE(sha512_arm_algs));
+	if (IS_ENABLED(CONFIG_KERNEL_MODE_NEON) && cpu_has_neon())
+		crypto_unregister_shashes(sha512_neon_algs,
+					  ARRAY_SIZE(sha512_neon_algs));
+}
+
+module_init(sha512_arm_mod_init);
+module_exit(sha512_arm_mod_fini);
diff --git a/arch/arm/crypto/sha512-neon-glue.c b/arch/arm/crypto/sha512-neon-glue.c
new file mode 100644
index 000000000000..179bae60e822
--- /dev/null
+++ b/arch/arm/crypto/sha512-neon-glue.c
@@ -0,0 +1,111 @@
+/*
+ * sha512-neon-glue.c - accelerated SHA-384/512 for ARM NEON
+ *
+ * Copyright (C) 2015 Linaro Ltd <ard.biesheuvel@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <crypto/internal/hash.h>
+#include <crypto/sha.h>
+#include <linux/crypto.h>
+#include <linux/module.h>
+
+#include <asm/hwcap.h>
+#include <asm/simd.h>
+#include <asm/neon.h>
+#include <asm/unaligned.h>
+
+#include "sha512.h"
+
+asmlinkage void sha512_block_data_order_neon(u64 *state, u8 const *src,
+					     int blocks);
+
+static void sha512_neon_transform(int blocks, u8 const *src, u64 *state,
+				  const u8 *head, void *p)
+{
+	if (head)
+		sha512_block_data_order_neon(state, head, 1);
+	if (blocks)
+		sha512_block_data_order_neon(state, src, blocks);
+}
+
+static int sha512_neon_update(struct shash_desc *desc, const u8 *data,
+			      unsigned int len)
+{
+	struct sha512_state *sctx = shash_desc_ctx(desc);
+	int err;
+
+	if (!may_use_simd() ||
+	    (sctx->count[0] % SHA512_BLOCK_SIZE) + len < SHA512_BLOCK_SIZE)
+		return sha512_arm_update(desc, data, len);
+
+	kernel_neon_begin();
+	err = sha512_base_do_update(desc, data, len, sha512_neon_transform,
+				    NULL);
+	kernel_neon_end();
+
+	return err;
+}
+
+static int sha512_neon_finup(struct shash_desc *desc, const u8 *data,
+			     unsigned int len, u8 *out)
+{
+	if (!may_use_simd())
+		return sha512_arm_finup(desc, data, len, out);
+
+	kernel_neon_begin();
+	if (len)
+		sha512_base_do_update(desc, data, len, sha512_neon_transform,
+				      NULL);
+	sha512_base_do_finalize(desc, sha512_neon_transform, NULL);
+	kernel_neon_end();
+
+	return sha512_base_finish(desc, out);
+}
+
+static int sha512_neon_final(struct shash_desc *desc, u8 *out)
+{
+	return sha512_neon_finup(desc, NULL, 0, out);
+}
+
+struct shash_alg sha512_neon_algs[] = { {
+	.init			= sha384_base_init,
+	.update			= sha512_neon_update,
+	.final			= sha512_neon_final,
+	.finup			= sha512_neon_finup,
+	.export			= sha512_base_export,
+	.import			= sha512_base_import,
+	.descsize		= sizeof(struct sha512_state),
+	.digestsize		= SHA384_DIGEST_SIZE,
+	.statesize		= sizeof(struct sha512_state),
+	.base			= {
+		.cra_name		= "sha384",
+		.cra_driver_name	= "sha384-neon",
+		.cra_priority		= 300,
+		.cra_flags		= CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize		= SHA384_BLOCK_SIZE,
+		.cra_module		= THIS_MODULE,
+
+	}
+},  {
+	.init			= sha512_base_init,
+	.update			= sha512_neon_update,
+	.final			= sha512_neon_final,
+	.finup			= sha512_neon_finup,
+	.export			= sha512_base_export,
+	.import			= sha512_base_import,
+	.descsize		= sizeof(struct sha512_state),
+	.digestsize		= SHA512_DIGEST_SIZE,
+	.statesize		= sizeof(struct sha512_state),
+	.base			= {
+		.cra_name		= "sha512",
+		.cra_driver_name	= "sha512-neon",
+		.cra_priority		= 300,
+		.cra_flags		= CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize		= SHA512_BLOCK_SIZE,
+		.cra_module		= THIS_MODULE,
+	}
+} };
diff --git a/arch/arm/crypto/sha512.h b/arch/arm/crypto/sha512.h
new file mode 100644
index 000000000000..c91689babc36
--- /dev/null
+++ b/arch/arm/crypto/sha512.h
@@ -0,0 +1,8 @@
+
+int sha512_arm_update(struct shash_desc *desc, const u8 *data,
+		      unsigned int len);
+
+int sha512_arm_finup(struct shash_desc *desc, const u8 *data,
+			     unsigned int len, u8 *out);
+
+extern struct shash_alg sha512_neon_algs[2];
-- 
1.8.3.2
