Return-Path: <SRS0=XFsj=M6=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727351AbeJRMiu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Oct 2018 08:38:50 -0400
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Paul Crowley <paulcrowley@google.com>
Subject: [PATCH v3 2/2] crypto: arm/aes - add some hardening against cache-timing attacks
Date: Wed, 17 Oct 2018 21:37:59 -0700
Message-Id: <20181018043759.7669-3-ebiggers@kernel.org>
In-Reply-To: <20181018043759.7669-1-ebiggers@kernel.org>
References: <20181018043759.7669-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

Make the ARM scalar AES implementation closer to constant-time by
disabling interrupts and prefetching the tables into L1 cache.  This is
feasible because due to ARM's "free" rotations, the main tables are only
1024 bytes instead of the usual 4096 used by most AES implementations.

On ARM Cortex-A7, the speed loss is only about 5%.  The resulting code
is still over twice as fast as aes_ti.c.  Responsiveness is potentially
a concern, but interrupts are only disabled for a single AES block.

Note that even after these changes, the implementation still isn't
necessarily guaranteed to be constant-time; see
https://cr.yp.to/antiforgery/cachetiming-20050414.pdf for a discussion
of the many difficulties involved in writing truly constant-time AES
software.  But it's valuable to make such attacks more difficult.

Much of this patch is based on patches suggested by Ard Biesheuvel.

Suggested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm/crypto/Kconfig           |  9 +++++
 arch/arm/crypto/aes-cipher-core.S | 62 ++++++++++++++++++++++++++-----
 crypto/aes_generic.c              |  9 +++--
 3 files changed, 66 insertions(+), 14 deletions(-)

diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
index ef0c7feea6e29..0473a8f683896 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -69,6 +69,15 @@ config CRYPTO_AES_ARM
 	help
 	  Use optimized AES assembler routines for ARM platforms.
 
+	  On ARM processors without the Crypto Extensions, this is the
+	  fastest AES implementation for single blocks.  For multiple
+	  blocks, the NEON bit-sliced implementation is usually faster.
+
+	  This implementation may be vulnerable to cache timing attacks,
+	  since it uses lookup tables.  However, as countermeasures it
+	  disables IRQs and preloads the tables; it is hoped this makes
+	  such attacks very difficult.
+
 config CRYPTO_AES_ARM_BS
 	tristate "Bit sliced AES using NEON instructions"
 	depends on KERNEL_MODE_NEON
diff --git a/arch/arm/crypto/aes-cipher-core.S b/arch/arm/crypto/aes-cipher-core.S
index 184d6c2d15d5e..f2d67c095e596 100644
--- a/arch/arm/crypto/aes-cipher-core.S
+++ b/arch/arm/crypto/aes-cipher-core.S
@@ -10,6 +10,7 @@
  */
 
 #include <linux/linkage.h>
+#include <asm/assembler.h>
 #include <asm/cache.h>
 
 	.text
@@ -41,7 +42,7 @@
 	.endif
 	.endm
 
-	.macro		__hround, out0, out1, in0, in1, in2, in3, t3, t4, enc, sz, op
+	.macro		__hround, out0, out1, in0, in1, in2, in3, t3, t4, enc, sz, op, oldcpsr
 	__select	\out0, \in0, 0
 	__select	t0, \in1, 1
 	__load		\out0, \out0, 0, \sz, \op
@@ -73,6 +74,14 @@
 	__load		t0, t0, 3, \sz, \op
 	__load		\t4, \t4, 3, \sz, \op
 
+	.ifnb		\oldcpsr
+	/*
+	 * This is the final round and we're done with all data-dependent table
+	 * lookups, so we can safely re-enable interrupts.
+	 */
+	restore_irqs	\oldcpsr
+	.endif
+
 	eor		\out1, \out1, t1, ror #24
 	eor		\out0, \out0, t2, ror #16
 	ldm		rk!, {t1, t2}
@@ -83,14 +92,14 @@
 	eor		\out1, \out1, t2
 	.endm
 
-	.macro		fround, out0, out1, out2, out3, in0, in1, in2, in3, sz=2, op
+	.macro		fround, out0, out1, out2, out3, in0, in1, in2, in3, sz=2, op, oldcpsr
 	__hround	\out0, \out1, \in0, \in1, \in2, \in3, \out2, \out3, 1, \sz, \op
-	__hround	\out2, \out3, \in2, \in3, \in0, \in1, \in1, \in2, 1, \sz, \op
+	__hround	\out2, \out3, \in2, \in3, \in0, \in1, \in1, \in2, 1, \sz, \op, \oldcpsr
 	.endm
 
-	.macro		iround, out0, out1, out2, out3, in0, in1, in2, in3, sz=2, op
+	.macro		iround, out0, out1, out2, out3, in0, in1, in2, in3, sz=2, op, oldcpsr
 	__hround	\out0, \out1, \in0, \in3, \in2, \in1, \out2, \out3, 0, \sz, \op
-	__hround	\out2, \out3, \in2, \in1, \in0, \in3, \in1, \in0, 0, \sz, \op
+	__hround	\out2, \out3, \in2, \in1, \in0, \in3, \in1, \in0, 0, \sz, \op, \oldcpsr
 	.endm
 
 	.macro		__rev, out, in
@@ -118,13 +127,14 @@
 	.macro		do_crypt, round, ttab, ltab, bsz
 	push		{r3-r11, lr}
 
+	// Load keys first, to reduce latency in case they're not cached yet.
+	ldm		rk!, {r8-r11}
+
 	ldr		r4, [in]
 	ldr		r5, [in, #4]
 	ldr		r6, [in, #8]
 	ldr		r7, [in, #12]
 
-	ldm		rk!, {r8-r11}
-
 #ifdef CONFIG_CPU_BIG_ENDIAN
 	__rev		r4, r4
 	__rev		r5, r5
@@ -138,6 +148,25 @@
 	eor		r7, r7, r11
 
 	__adrl		ttab, \ttab
+	/*
+	 * Disable interrupts and prefetch the 1024-byte 'ft' or 'it' table into
+	 * L1 cache, assuming cacheline size >= 32.  This is a hardening measure
+	 * intended to make cache-timing attacks more difficult.  They may not
+	 * be fully prevented, however; see the paper
+	 * https://cr.yp.to/antiforgery/cachetiming-20050414.pdf
+	 * ("Cache-timing attacks on AES") for a discussion of the many
+	 * difficulties involved in writing truly constant-time AES software.
+	 */
+	 save_and_disable_irqs	t0
+	.set		i, 0
+	.rept		1024 / 128
+	ldr		r8, [ttab, #i + 0]
+	ldr		r9, [ttab, #i + 32]
+	ldr		r10, [ttab, #i + 64]
+	ldr		r11, [ttab, #i + 96]
+	.set		i, i + 128
+	.endr
+	push		{t0}		// oldcpsr
 
 	tst		rounds, #2
 	bne		1f
@@ -151,8 +180,21 @@
 	\round		r4, r5, r6, r7, r8, r9, r10, r11
 	b		0b
 
-2:	__adrl		ttab, \ltab
-	\round		r4, r5, r6, r7, r8, r9, r10, r11, \bsz, b
+2:	.ifb		\ltab
+	add		ttab, ttab, #1
+	.else
+	__adrl		ttab, \ltab
+	// Prefetch inverse S-box for final round; see explanation above
+	.set		i, 0
+	.rept		256 / 64
+	ldr		t0, [ttab, #i + 0]
+	ldr		t1, [ttab, #i + 32]
+	.set		i, i + 64
+	.endr
+	.endif
+
+	pop		{rounds}	// oldcpsr
+	\round		r4, r5, r6, r7, r8, r9, r10, r11, \bsz, b, rounds
 
 #ifdef CONFIG_CPU_BIG_ENDIAN
 	__rev		r4, r4
@@ -175,7 +217,7 @@
 	.endm
 
 ENTRY(__aes_arm_encrypt)
-	do_crypt	fround, crypto_ft_tab, crypto_ft_tab + 1, 2
+	do_crypt	fround, crypto_ft_tab,, 2
 ENDPROC(__aes_arm_encrypt)
 
 	.align		5
diff --git a/crypto/aes_generic.c b/crypto/aes_generic.c
index ca554d57d01e9..13df33aca4631 100644
--- a/crypto/aes_generic.c
+++ b/crypto/aes_generic.c
@@ -63,7 +63,8 @@ static inline u8 byte(const u32 x, const unsigned n)
 
 static const u32 rco_tab[10] = { 1, 2, 4, 8, 16, 32, 64, 128, 27, 54 };
 
-__visible const u32 crypto_ft_tab[4][256] = {
+/* cacheline-aligned to facilitate prefetching into cache */
+__visible const u32 crypto_ft_tab[4][256] __cacheline_aligned = {
 	{
 		0xa56363c6, 0x847c7cf8, 0x997777ee, 0x8d7b7bf6,
 		0x0df2f2ff, 0xbd6b6bd6, 0xb16f6fde, 0x54c5c591,
@@ -327,7 +328,7 @@ __visible const u32 crypto_ft_tab[4][256] = {
 	}
 };
 
-__visible const u32 crypto_fl_tab[4][256] = {
+__visible const u32 crypto_fl_tab[4][256] __cacheline_aligned = {
 	{
 		0x00000063, 0x0000007c, 0x00000077, 0x0000007b,
 		0x000000f2, 0x0000006b, 0x0000006f, 0x000000c5,
@@ -591,7 +592,7 @@ __visible const u32 crypto_fl_tab[4][256] = {
 	}
 };
 
-__visible const u32 crypto_it_tab[4][256] = {
+__visible const u32 crypto_it_tab[4][256] __cacheline_aligned = {
 	{
 		0x50a7f451, 0x5365417e, 0xc3a4171a, 0x965e273a,
 		0xcb6bab3b, 0xf1459d1f, 0xab58faac, 0x9303e34b,
@@ -855,7 +856,7 @@ __visible const u32 crypto_it_tab[4][256] = {
 	}
 };
 
-__visible const u32 crypto_il_tab[4][256] = {
+__visible const u32 crypto_il_tab[4][256] __cacheline_aligned = {
 	{
 		0x00000052, 0x00000009, 0x0000006a, 0x000000d5,
 		0x00000030, 0x00000036, 0x000000a5, 0x00000038,
-- 
2.19.1
