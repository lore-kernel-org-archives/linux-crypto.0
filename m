From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: [RFC PATCH 3/6] crypto: blowfish - add AVX2/x86_64 implementation
 of blowfish cipher
Date: Sat, 13 Apr 2013 13:46:45 +0300
Message-ID: <20130413104645.10667.99298.stgit@localhost6.localdomain6>
References: <20130413104245.10667.62267.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130413104245.10667.62267.stgit@localhost6.localdomain6>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Patch adds AVX2/x86-64 implementation of Blowfish cipher, requiring 32 =
parallel
blocks for input (256 bytes). Table look-ups are performed using vpgath=
erdd
instruction directly from vector registers and thus should be faster th=
an
earlier implementations.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
---
 arch/x86/crypto/Makefile               |   11 +
 arch/x86/crypto/blowfish-avx2-asm_64.S |  449 ++++++++++++++++++++++++=
+
 arch/x86/crypto/blowfish_avx2_glue.c   |  585 ++++++++++++++++++++++++=
++++++++
 arch/x86/crypto/blowfish_glue.c        |   32 --
 arch/x86/include/asm/cpufeature.h      |    1=20
 arch/x86/include/asm/crypto/blowfish.h |   43 ++
 crypto/Kconfig                         |   18 +
 crypto/testmgr.c                       |   12 +
 8 files changed, 1127 insertions(+), 24 deletions(-)
 create mode 100644 arch/x86/crypto/blowfish-avx2-asm_64.S
 create mode 100644 arch/x86/crypto/blowfish_avx2_glue.c
 create mode 100644 arch/x86/include/asm/crypto/blowfish.h

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index 03cd731..28464ef 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -3,6 +3,8 @@
 #
=20
 avx_supported :=3D $(call as-instr,vpxor %xmm0$(comma)%xmm0$(comma)%xm=
m0,yes,no)
+avx2_supported :=3D $(call as-instr,vpgatherdd %ymm0$(comma)(%eax$(com=
ma)%ymm1\
+					$(comma)4)$(comma)%ymm2,yes,no)
=20
 obj-$(CONFIG_CRYPTO_ABLK_HELPER_X86) +=3D ablk_helper.o
 obj-$(CONFIG_CRYPTO_GLUE_HELPER_X86) +=3D glue_helper.o
@@ -38,6 +40,11 @@ ifeq ($(avx_supported),yes)
 	obj-$(CONFIG_CRYPTO_SERPENT_AVX_X86_64) +=3D serpent-avx-x86_64.o
 endif
=20
+# These modules require assembler to support AVX2.
+ifeq ($(avx2_supported),yes)
+	obj-$(CONFIG_CRYPTO_BLOWFISH_AVX2_X86_64) +=3D blowfish-avx2.o
+endif
+
 aes-i586-y :=3D aes-i586-asm_32.o aes_glue.o
 twofish-i586-y :=3D twofish-i586-asm_32.o twofish_glue.o
 salsa20-i586-y :=3D salsa20-i586-asm_32.o salsa20_glue.o
@@ -62,6 +69,10 @@ ifeq ($(avx_supported),yes)
 				serpent_avx_glue.o
 endif
=20
+ifeq ($(avx2_supported),yes)
+	blowfish-avx2-y :=3D blowfish-avx2-asm_64.o blowfish_avx2_glue.o
+endif
+
 aesni-intel-y :=3D aesni-intel_asm.o aesni-intel_glue.o fpu.o
 ghash-clmulni-intel-y :=3D ghash-clmulni-intel_asm.o ghash-clmulni-int=
el_glue.o
 sha1-ssse3-y :=3D sha1_ssse3_asm.o sha1_ssse3_glue.o
diff --git a/arch/x86/crypto/blowfish-avx2-asm_64.S b/arch/x86/crypto/b=
lowfish-avx2-asm_64.S
new file mode 100644
index 0000000..784452e
--- /dev/null
+++ b/arch/x86/crypto/blowfish-avx2-asm_64.S
@@ -0,0 +1,449 @@
+/*
+ * x86_64/AVX2 assembler optimized version of Blowfish
+ *
+ * Copyright =C2=A9 2012-2013 Jussi Kivilinna <jussi.kivilinna@iki.fi>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include <linux/linkage.h>
+
+.file "blowfish-avx2-asm_64.S"
+
+.data
+.align 32
+
+.Lprefetch_mask:
+.long 0*64
+.long 1*64
+.long 2*64
+.long 3*64
+.long 4*64
+.long 5*64
+.long 6*64
+.long 7*64
+
+.Lbswap32_mask:
+.long 0x00010203
+.long 0x04050607
+.long 0x08090a0b
+.long 0x0c0d0e0f
+
+.Lbswap128_mask:
+	.byte 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0
+.Lbswap_iv_mask:
+	.byte 7, 6, 5, 4, 3, 2, 1, 0, 7, 6, 5, 4, 3, 2, 1, 0
+
+.text
+/* structure of crypto context */
+#define p	0
+#define s0	((16 + 2) * 4)
+#define s1	((16 + 2 + (1 * 256)) * 4)
+#define s2	((16 + 2 + (2 * 256)) * 4)
+#define s3	((16 + 2 + (3 * 256)) * 4)
+
+/* register macros */
+#define CTX	%rdi
+#define RIO	 %rdx
+
+#define RS0	%rax
+#define RS1	%r8
+#define RS2	%r9
+#define RS3	%r10
+
+#define RLOOP	%r11
+#define RLOOPd	%r11d
+
+#define RXr0	%ymm8
+#define RXr1	%ymm9
+#define RXr2	%ymm10
+#define RXr3	%ymm11
+#define RXl0	%ymm12
+#define RXl1	%ymm13
+#define RXl2	%ymm14
+#define RXl3	%ymm15
+
+/* temp regs */
+#define RT0	%ymm0
+#define RT0x	%xmm0
+#define RT1	%ymm1
+#define RT1x	%xmm1
+#define RIDX0	%ymm2
+#define RIDX1	%ymm3
+#define RIDX1x	%xmm3
+#define RIDX2	%ymm4
+#define RIDX3	%ymm5
+
+/* vpgatherdd mask and '-1' */
+#define RNOT	%ymm6
+
+/* byte mask, (-1 >> 24) */
+#define RBYTE	%ymm7
+
+/*********************************************************************=
**
+ * 32-way AVX2 blowfish
+ *********************************************************************=
**/
+#define F(xl, xr) \
+	vpsrld $24, xl, RIDX0; \
+	vpsrld $16, xl, RIDX1; \
+	vpsrld $8, xl, RIDX2; \
+	vpand RBYTE, RIDX1, RIDX1; \
+	vpand RBYTE, RIDX2, RIDX2; \
+	vpand RBYTE, xl, RIDX3; \
+	\
+	vpgatherdd RNOT, (RS0, RIDX0, 4), RT0; \
+	vpcmpeqd RNOT, RNOT, RNOT; \
+	vpcmpeqd RIDX0, RIDX0, RIDX0; \
+	\
+	vpgatherdd RNOT, (RS1, RIDX1, 4), RT1; \
+	vpcmpeqd RIDX1, RIDX1, RIDX1; \
+	vpaddd RT0, RT1, RT0; \
+	\
+	vpgatherdd RIDX0, (RS2, RIDX2, 4), RT1; \
+	vpxor RT0, RT1, RT0; \
+	\
+	vpgatherdd RIDX1, (RS3, RIDX3, 4), RT1; \
+	vpcmpeqd RNOT, RNOT, RNOT; \
+	vpaddd RT0, RT1, RT0; \
+	\
+	vpxor RT0, xr, xr;
+
+#define add_roundkey(xl, nmem) \
+	vpbroadcastd nmem, RT0; \
+	vpxor RT0, xl ## 0, xl ## 0; \
+	vpxor RT0, xl ## 1, xl ## 1; \
+	vpxor RT0, xl ## 2, xl ## 2; \
+	vpxor RT0, xl ## 3, xl ## 3;
+
+#define round_enc() \
+	add_roundkey(RXr, p(CTX,RLOOP,4)); \
+	F(RXl0, RXr0); \
+	F(RXl1, RXr1); \
+	F(RXl2, RXr2); \
+	F(RXl3, RXr3); \
+	\
+	add_roundkey(RXl, p+4(CTX,RLOOP,4)); \
+	F(RXr0, RXl0); \
+	F(RXr1, RXl1); \
+	F(RXr2, RXl2); \
+	F(RXr3, RXl3);
+
+#define round_dec() \
+	add_roundkey(RXr, p+4*2(CTX,RLOOP,4)); \
+	F(RXl0, RXr0); \
+	F(RXl1, RXr1); \
+	F(RXl2, RXr2); \
+	F(RXl3, RXr3); \
+	\
+	add_roundkey(RXl, p+4(CTX,RLOOP,4)); \
+	F(RXr0, RXl0); \
+	F(RXr1, RXl1); \
+	F(RXr2, RXl2); \
+	F(RXr3, RXl3);
+
+#define init_round_constants() \
+	vpcmpeqd RNOT, RNOT, RNOT; \
+	leaq s0(CTX), RS0; \
+	leaq s1(CTX), RS1; \
+	leaq s2(CTX), RS2; \
+	leaq s3(CTX), RS3; \
+	vpsrld $24, RNOT, RBYTE;
+
+#define transpose_2x2(x0, x1, t0) \
+	vpunpckldq x0, x1, t0; \
+	vpunpckhdq x0, x1, x1; \
+	\
+	vpunpcklqdq t0, x1, x0; \
+	vpunpckhqdq t0, x1, x1;
+
+#define read_block(xl, xr) \
+	vbroadcasti128 .Lbswap32_mask, RT1; \
+	\
+	vpshufb RT1, xl ## 0, xl ## 0; \
+	vpshufb RT1, xr ## 0, xr ## 0; \
+	vpshufb RT1, xl ## 1, xl ## 1; \
+	vpshufb RT1, xr ## 1, xr ## 1; \
+	vpshufb RT1, xl ## 2, xl ## 2; \
+	vpshufb RT1, xr ## 2, xr ## 2; \
+	vpshufb RT1, xl ## 3, xl ## 3; \
+	vpshufb RT1, xr ## 3, xr ## 3; \
+	\
+	transpose_2x2(xl ## 0, xr ## 0, RT0); \
+	transpose_2x2(xl ## 1, xr ## 1, RT0); \
+	transpose_2x2(xl ## 2, xr ## 2, RT0); \
+	transpose_2x2(xl ## 3, xr ## 3, RT0);
+
+#define write_block(xl, xr) \
+	vbroadcasti128 .Lbswap32_mask, RT1; \
+	\
+	transpose_2x2(xl ## 0, xr ## 0, RT0); \
+	transpose_2x2(xl ## 1, xr ## 1, RT0); \
+	transpose_2x2(xl ## 2, xr ## 2, RT0); \
+	transpose_2x2(xl ## 3, xr ## 3, RT0); \
+	\
+	vpshufb RT1, xl ## 0, xl ## 0; \
+	vpshufb RT1, xr ## 0, xr ## 0; \
+	vpshufb RT1, xl ## 1, xl ## 1; \
+	vpshufb RT1, xr ## 1, xr ## 1; \
+	vpshufb RT1, xl ## 2, xl ## 2; \
+	vpshufb RT1, xr ## 2, xr ## 2; \
+	vpshufb RT1, xl ## 3, xl ## 3; \
+	vpshufb RT1, xr ## 3, xr ## 3;
+
+.align 8
+__blowfish_enc_blk32:
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	RXl0..4, RXr0..4: plaintext
+	 * output:
+	 *	RXl0..4, RXr0..4: ciphertext (RXl <=3D> RXr swapped)
+	 */
+	init_round_constants();
+
+	read_block(RXl, RXr);
+
+	movl $1, RLOOPd;
+	add_roundkey(RXl, p+4*(0)(CTX));
+
+.align 4
+.L__enc_loop:
+	round_enc();
+
+	leal 2(RLOOPd), RLOOPd;
+	cmpl $17, RLOOPd;
+	jne .L__enc_loop;
+
+	add_roundkey(RXr, p+4*(17)(CTX));
+
+	write_block(RXl, RXr);
+
+	ret;
+ENDPROC(__blowfish_enc_blk32)
+
+.align 8
+__blowfish_dec_blk32:
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	RXl0..4, RXr0..4: ciphertext
+	 * output:
+	 *	RXl0..4, RXr0..4: plaintext (RXl <=3D> RXr swapped)
+	 */
+	init_round_constants();
+
+	read_block(RXl, RXr);
+
+	movl $14, RLOOPd;
+	add_roundkey(RXl, p+4*(17)(CTX));
+
+.align 4
+.L__dec_loop:
+	round_dec();
+
+	addl $-2, RLOOPd;
+	jns .L__dec_loop;
+
+	add_roundkey(RXr, p+4*(0)(CTX));
+
+	write_block(RXl, RXr);
+
+	ret;
+ENDPROC(__blowfish_dec_blk32)
+
+ENTRY(blowfish_ecb_enc_32way)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst
+	 *	%rdx: src
+	 */
+
+	vzeroupper;
+
+	vmovdqu 0*32(%rdx), RXl0;
+	vmovdqu 1*32(%rdx), RXr0;
+	vmovdqu 2*32(%rdx), RXl1;
+	vmovdqu 3*32(%rdx), RXr1;
+	vmovdqu 4*32(%rdx), RXl2;
+	vmovdqu 5*32(%rdx), RXr2;
+	vmovdqu 6*32(%rdx), RXl3;
+	vmovdqu 7*32(%rdx), RXr3;
+
+	call __blowfish_enc_blk32;
+
+	vmovdqu RXr0, 0*32(%rsi);
+	vmovdqu RXl0, 1*32(%rsi);
+	vmovdqu RXr1, 2*32(%rsi);
+	vmovdqu RXl1, 3*32(%rsi);
+	vmovdqu RXr2, 4*32(%rsi);
+	vmovdqu RXl2, 5*32(%rsi);
+	vmovdqu RXr3, 6*32(%rsi);
+	vmovdqu RXl3, 7*32(%rsi);
+
+	vzeroupper;
+
+	ret;
+ENDPROC(blowfish_ecb_enc_32way)
+
+ENTRY(blowfish_ecb_dec_32way)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst
+	 *	%rdx: src
+	 */
+
+	vzeroupper;
+
+	vmovdqu 0*32(%rdx), RXl0;
+	vmovdqu 1*32(%rdx), RXr0;
+	vmovdqu 2*32(%rdx), RXl1;
+	vmovdqu 3*32(%rdx), RXr1;
+	vmovdqu 4*32(%rdx), RXl2;
+	vmovdqu 5*32(%rdx), RXr2;
+	vmovdqu 6*32(%rdx), RXl3;
+	vmovdqu 7*32(%rdx), RXr3;
+
+	call __blowfish_dec_blk32;
+
+	vmovdqu RXr0, 0*32(%rsi);
+	vmovdqu RXl0, 1*32(%rsi);
+	vmovdqu RXr1, 2*32(%rsi);
+	vmovdqu RXl1, 3*32(%rsi);
+	vmovdqu RXr2, 4*32(%rsi);
+	vmovdqu RXl2, 5*32(%rsi);
+	vmovdqu RXr3, 6*32(%rsi);
+	vmovdqu RXl3, 7*32(%rsi);
+
+	vzeroupper;
+
+	ret;
+ENDPROC(blowfish_ecb_dec_32way)
+
+ENTRY(blowfish_cbc_dec_32way)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst
+	 *	%rdx: src
+	 */
+
+	vzeroupper;
+
+	vmovdqu 0*32(%rdx), RXl0;
+	vmovdqu 1*32(%rdx), RXr0;
+	vmovdqu 2*32(%rdx), RXl1;
+	vmovdqu 3*32(%rdx), RXr1;
+	vmovdqu 4*32(%rdx), RXl2;
+	vmovdqu 5*32(%rdx), RXr2;
+	vmovdqu 6*32(%rdx), RXl3;
+	vmovdqu 7*32(%rdx), RXr3;
+
+	call __blowfish_dec_blk32;
+
+	/* xor with src */
+	vmovq (%rdx), RT0x;
+	vpshufd $0x4f, RT0x, RT0x;
+	vinserti128 $1, 8(%rdx), RT0, RT0;
+	vpxor RT0, RXr0, RXr0;
+	vpxor 0*32+24(%rdx), RXl0, RXl0;
+	vpxor 1*32+24(%rdx), RXr1, RXr1;
+	vpxor 2*32+24(%rdx), RXl1, RXl1;
+	vpxor 3*32+24(%rdx), RXr2, RXr2;
+	vpxor 4*32+24(%rdx), RXl2, RXl2;
+	vpxor 5*32+24(%rdx), RXr3, RXr3;
+	vpxor 6*32+24(%rdx), RXl3, RXl3;
+
+	vmovdqu RXr0, (0*32)(%rsi);
+	vmovdqu RXl0, (1*32)(%rsi);
+	vmovdqu RXr1, (2*32)(%rsi);
+	vmovdqu RXl1, (3*32)(%rsi);
+	vmovdqu RXr2, (4*32)(%rsi);
+	vmovdqu RXl2, (5*32)(%rsi);
+	vmovdqu RXr3, (6*32)(%rsi);
+	vmovdqu RXl3, (7*32)(%rsi);
+
+	vzeroupper;
+
+	ret;
+ENDPROC(blowfish_cbc_dec_32way)
+
+ENTRY(blowfish_ctr_32way)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst
+	 *	%rdx: src
+	 *	%rcx: iv (big endian, 64bit)
+	 */
+
+	vzeroupper;
+
+	vpcmpeqd RT0, RT0, RT0;
+	vpsrldq $8, RT0, RT0; /* a: -1, b: 0, c: -1, d: 0 */
+
+	vpcmpeqd RT1x, RT1x, RT1x;
+	vpaddq RT1x, RT1x, RT1x; /* a: -2, b: -2 */
+	vpxor RIDX0, RIDX0, RIDX0;
+	vinserti128 $1, RT1x, RIDX0, RIDX0; /* a: 0, b: 0, c: -2, d: -2 */
+
+	vpaddq RIDX0, RT0, RT0; /* a: -1, b: 0, c: -3, d: -2 */
+
+	vpcmpeqd RT1, RT1, RT1;
+	vpaddq RT1, RT1, RT1; /* a: -2, b: -2, c: -2, d: -2 */
+	vpaddq RT1, RT1, RIDX2; /* a: -4, b: -4, c: -4, d: -4 */
+
+	vbroadcasti128 .Lbswap_iv_mask, RIDX0;
+	vbroadcasti128 .Lbswap128_mask, RIDX1;
+
+	/* load IV and byteswap */
+	vmovq (%rcx), RT1x;
+	vinserti128 $1, RT1x, RT1, RT1; /* a: BE, b: 0, c: BE, d: 0 */
+	vpshufb RIDX0, RT1, RT1; /* a: LE, b: LE, c: LE, d: LE */
+
+	/* construct IVs */
+	vpsubq RT0, RT1, RT1;		/* a: le1, b: le0, c: le3, d: le2 */
+	vpshufb RIDX1, RT1, RXl0;	/* a: be0, b: be1, c: be2, d: be3 */
+	vpsubq RIDX2, RT1, RT1;		/* le5, le4, le7, le6 */
+	vpshufb RIDX1, RT1, RXr0;	/* be4, be5, be6, be7 */
+	vpsubq RIDX2, RT1, RT1;
+	vpshufb RIDX1, RT1, RXl1;
+	vpsubq RIDX2, RT1, RT1;
+	vpshufb RIDX1, RT1, RXr1;
+	vpsubq RIDX2, RT1, RT1;
+	vpshufb RIDX1, RT1, RXl2;
+	vpsubq RIDX2, RT1, RT1;
+	vpshufb RIDX1, RT1, RXr2;
+	vpsubq RIDX2, RT1, RT1;
+	vpshufb RIDX1, RT1, RXl3;
+	vpsubq RIDX2, RT1, RT1;
+	vpshufb RIDX1, RT1, RXr3;
+
+	/* store last IV */
+	vpsubq RIDX2, RT1, RT1; /* a: le33, b: le32, ... */
+	vpshufb RIDX1x, RT1x, RT1x; /* a: be32, ... */
+	vmovq RT1x, (%rcx);
+
+	call __blowfish_enc_blk32;
+
+	/* dst =3D src ^ iv */
+	vpxor 0*32(%rdx), RXr0, RXr0;
+	vpxor 1*32(%rdx), RXl0, RXl0;
+	vpxor 2*32(%rdx), RXr1, RXr1;
+	vpxor 3*32(%rdx), RXl1, RXl1;
+	vpxor 4*32(%rdx), RXr2, RXr2;
+	vpxor 5*32(%rdx), RXl2, RXl2;
+	vpxor 6*32(%rdx), RXr3, RXr3;
+	vpxor 7*32(%rdx), RXl3, RXl3;
+	vmovdqu RXr0, (0*32)(%rsi);
+	vmovdqu RXl0, (1*32)(%rsi);
+	vmovdqu RXr1, (2*32)(%rsi);
+	vmovdqu RXl1, (3*32)(%rsi);
+	vmovdqu RXr2, (4*32)(%rsi);
+	vmovdqu RXl2, (5*32)(%rsi);
+	vmovdqu RXr3, (6*32)(%rsi);
+	vmovdqu RXl3, (7*32)(%rsi);
+
+	vzeroupper;
+
+	ret;
+ENDPROC(blowfish_ctr_32way)
diff --git a/arch/x86/crypto/blowfish_avx2_glue.c b/arch/x86/crypto/blo=
wfish_avx2_glue.c
new file mode 100644
index 0000000..4417e9a
--- /dev/null
+++ b/arch/x86/crypto/blowfish_avx2_glue.c
@@ -0,0 +1,585 @@
+/*
+ * Glue Code for x86_64/AVX2 assembler optimized version of Blowfish
+ *
+ * Copyright =C2=A9 2012-2013 Jussi Kivilinna <jussi.kivilinna@mbnet.f=
i>
+ *
+ * CBC & ECB parts based on code (crypto/cbc.c,ecb.c) by:
+ *   Copyright (c) 2006 Herbert Xu <herbert@gondor.apana.org.au>
+ * CTR part based on code (crypto/ctr.c) by:
+ *   (C) Copyright IBM Corp. 2007 - Joy Latten <latten@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/crypto.h>
+#include <linux/err.h>
+#include <crypto/algapi.h>
+#include <crypto/blowfish.h>
+#include <crypto/cryptd.h>
+#include <crypto/ctr.h>
+#include <asm/i387.h>
+#include <asm/xcr.h>
+#include <asm/xsave.h>
+#include <asm/crypto/blowfish.h>
+#include <asm/crypto/ablk_helper.h>
+#include <crypto/scatterwalk.h>
+
+#define BF_AVX2_PARALLEL_BLOCKS 32
+
+/* 32-way AVX2 parallel cipher functions */
+asmlinkage void blowfish_ecb_enc_32way(struct bf_ctx *ctx, u8 *dst,
+				       const u8 *src);
+asmlinkage void blowfish_ecb_dec_32way(struct bf_ctx *ctx, u8 *dst,
+				       const u8 *src);
+asmlinkage void blowfish_cbc_dec_32way(struct bf_ctx *ctx, u8 *dst,
+				       const u8 *src);
+asmlinkage void blowfish_ctr_32way(struct bf_ctx *ctx, u8 *dst, const =
u8 *src,
+				   __be64 *iv);
+
+static inline bool bf_fpu_begin(bool fpu_enabled, unsigned int nbytes)
+{
+	if (fpu_enabled)
+		return true;
+
+	/* FPU is only used when chunk to be processed is large enough, so
+	 * do not enable FPU until it is necessary.
+	 */
+	if (nbytes < BF_BLOCK_SIZE * BF_AVX2_PARALLEL_BLOCKS)
+		return false;
+
+	kernel_fpu_begin();
+	return true;
+}
+
+static inline void bf_fpu_end(bool fpu_enabled)
+{
+	if (fpu_enabled)
+		kernel_fpu_end();
+}
+
+static int ecb_crypt(struct blkcipher_desc *desc, struct blkcipher_wal=
k *walk,
+		     bool enc)
+{
+	bool fpu_enabled =3D false;
+	struct bf_ctx *ctx =3D crypto_blkcipher_ctx(desc->tfm);
+	const unsigned int bsize =3D BF_BLOCK_SIZE;
+	unsigned int nbytes;
+	int err;
+
+	err =3D blkcipher_walk_virt(desc, walk);
+	desc->flags &=3D ~CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	while ((nbytes =3D walk->nbytes)) {
+		u8 *wsrc =3D walk->src.virt.addr;
+		u8 *wdst =3D walk->dst.virt.addr;
+
+		fpu_enabled =3D bf_fpu_begin(fpu_enabled, nbytes);
+
+		/* Process multi-block AVX2 batch */
+		if (nbytes >=3D bsize * BF_AVX2_PARALLEL_BLOCKS) {
+			do {
+				if (enc)
+					blowfish_ecb_enc_32way(ctx, wdst, wsrc);
+				else
+					blowfish_ecb_dec_32way(ctx, wdst, wsrc);
+
+				wsrc +=3D bsize * BF_AVX2_PARALLEL_BLOCKS;
+				wdst +=3D bsize * BF_AVX2_PARALLEL_BLOCKS;
+				nbytes -=3D bsize * BF_AVX2_PARALLEL_BLOCKS;
+			} while (nbytes >=3D bsize * BF_AVX2_PARALLEL_BLOCKS);
+
+			if (nbytes < bsize)
+				goto done;
+		}
+
+		/* Process multi-block batch */
+		if (nbytes >=3D bsize * BF_PARALLEL_BLOCKS) {
+			do {
+				if (enc)
+					blowfish_enc_blk_4way(ctx, wdst, wsrc);
+				else
+					blowfish_dec_blk_4way(ctx, wdst, wsrc);
+
+				wsrc +=3D bsize * BF_PARALLEL_BLOCKS;
+				wdst +=3D bsize * BF_PARALLEL_BLOCKS;
+				nbytes -=3D bsize * BF_PARALLEL_BLOCKS;
+			} while (nbytes >=3D bsize * BF_PARALLEL_BLOCKS);
+
+			if (nbytes < bsize)
+				goto done;
+		}
+
+		/* Handle leftovers */
+		do {
+			if (enc)
+				blowfish_enc_blk(ctx, wdst, wsrc);
+			else
+				blowfish_dec_blk(ctx, wdst, wsrc);
+
+			wsrc +=3D bsize;
+			wdst +=3D bsize;
+			nbytes -=3D bsize;
+		} while (nbytes >=3D bsize);
+
+done:
+		err =3D blkcipher_walk_done(desc, walk, nbytes);
+	}
+
+	bf_fpu_end(fpu_enabled);
+	return err;
+}
+
+static int ecb_encrypt(struct blkcipher_desc *desc, struct scatterlist=
 *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct blkcipher_walk walk;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	return ecb_crypt(desc, &walk, true);
+}
+
+static int ecb_decrypt(struct blkcipher_desc *desc, struct scatterlist=
 *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct blkcipher_walk walk;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	return ecb_crypt(desc, &walk, false);
+}
+
+static unsigned int __cbc_encrypt(struct blkcipher_desc *desc,
+				  struct blkcipher_walk *walk)
+{
+	struct bf_ctx *ctx =3D crypto_blkcipher_ctx(desc->tfm);
+	unsigned int bsize =3D BF_BLOCK_SIZE;
+	unsigned int nbytes =3D walk->nbytes;
+	u64 *src =3D (u64 *)walk->src.virt.addr;
+	u64 *dst =3D (u64 *)walk->dst.virt.addr;
+	u64 *iv =3D (u64 *)walk->iv;
+
+	do {
+		*dst =3D *src ^ *iv;
+		blowfish_enc_blk(ctx, (u8 *)dst, (u8 *)dst);
+		iv =3D dst;
+
+		src +=3D 1;
+		dst +=3D 1;
+		nbytes -=3D bsize;
+	} while (nbytes >=3D bsize);
+
+	*(u64 *)walk->iv =3D *iv;
+	return nbytes;
+}
+
+static int cbc_encrypt(struct blkcipher_desc *desc, struct scatterlist=
 *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct blkcipher_walk walk;
+	int err;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err =3D blkcipher_walk_virt(desc, &walk);
+
+	while ((nbytes =3D walk.nbytes)) {
+		nbytes =3D __cbc_encrypt(desc, &walk);
+		err =3D blkcipher_walk_done(desc, &walk, nbytes);
+	}
+
+	return err;
+}
+
+static unsigned int __cbc_decrypt(struct blkcipher_desc *desc,
+				  struct blkcipher_walk *walk)
+{
+	struct bf_ctx *ctx =3D crypto_blkcipher_ctx(desc->tfm);
+	const unsigned int bsize =3D BF_BLOCK_SIZE;
+	unsigned int nbytes =3D walk->nbytes;
+	u64 *src =3D (u64 *)walk->src.virt.addr;
+	u64 *dst =3D (u64 *)walk->dst.virt.addr;
+	u64 last_iv;
+	int i;
+
+	/* Start of the last block. */
+	src +=3D nbytes / bsize - 1;
+	dst +=3D nbytes / bsize - 1;
+
+	last_iv =3D *src;
+
+	/* Process multi-block AVX2 batch */
+	if (nbytes >=3D bsize * BF_AVX2_PARALLEL_BLOCKS) {
+		do {
+			nbytes -=3D bsize * (BF_AVX2_PARALLEL_BLOCKS - 1);
+			src -=3D BF_AVX2_PARALLEL_BLOCKS - 1;
+			dst -=3D BF_AVX2_PARALLEL_BLOCKS - 1;
+
+			blowfish_cbc_dec_32way(ctx, (u8 *)dst, (u8 *)src);
+
+			nbytes -=3D bsize;
+			if (nbytes < bsize)
+				goto done;
+
+			*dst ^=3D *(src - 1);
+			src -=3D 1;
+			dst -=3D 1;
+		} while (nbytes >=3D bsize * BF_AVX2_PARALLEL_BLOCKS);
+
+		if (nbytes < bsize)
+			goto done;
+	}
+
+	/* Process multi-block batch */
+	if (nbytes >=3D bsize * BF_PARALLEL_BLOCKS) {
+		u64 ivs[BF_PARALLEL_BLOCKS - 1];
+
+		do {
+			nbytes -=3D bsize * (BF_PARALLEL_BLOCKS - 1);
+			src -=3D BF_PARALLEL_BLOCKS - 1;
+			dst -=3D BF_PARALLEL_BLOCKS - 1;
+
+			for (i =3D 0; i < BF_PARALLEL_BLOCKS - 1; i++)
+				ivs[i] =3D src[i];
+
+			blowfish_dec_blk_4way(ctx, (u8 *)dst, (u8 *)src);
+
+			for (i =3D 0; i < BF_PARALLEL_BLOCKS - 1; i++)
+				dst[i + 1] ^=3D ivs[i];
+
+			nbytes -=3D bsize;
+			if (nbytes < bsize)
+				goto done;
+
+			*dst ^=3D *(src - 1);
+			src -=3D 1;
+			dst -=3D 1;
+		} while (nbytes >=3D bsize * BF_PARALLEL_BLOCKS);
+
+		if (nbytes < bsize)
+			goto done;
+	}
+
+	/* Handle leftovers */
+	for (;;) {
+		blowfish_dec_blk(ctx, (u8 *)dst, (u8 *)src);
+
+		nbytes -=3D bsize;
+		if (nbytes < bsize)
+			break;
+
+		*dst ^=3D *(src - 1);
+		src -=3D 1;
+		dst -=3D 1;
+	}
+
+done:
+	*dst ^=3D *(u64 *)walk->iv;
+	*(u64 *)walk->iv =3D last_iv;
+
+	return nbytes;
+}
+
+static int cbc_decrypt(struct blkcipher_desc *desc, struct scatterlist=
 *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	bool fpu_enabled =3D false;
+	struct blkcipher_walk walk;
+	int err;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err =3D blkcipher_walk_virt(desc, &walk);
+	desc->flags &=3D ~CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	while ((nbytes =3D walk.nbytes)) {
+		fpu_enabled =3D bf_fpu_begin(fpu_enabled, nbytes);
+		nbytes =3D __cbc_decrypt(desc, &walk);
+		err =3D blkcipher_walk_done(desc, &walk, nbytes);
+	}
+
+	bf_fpu_end(fpu_enabled);
+	return err;
+}
+
+static void ctr_crypt_final(struct blkcipher_desc *desc,
+			    struct blkcipher_walk *walk)
+{
+	struct bf_ctx *ctx =3D crypto_blkcipher_ctx(desc->tfm);
+	u8 *ctrblk =3D walk->iv;
+	u8 keystream[BF_BLOCK_SIZE];
+	u8 *src =3D walk->src.virt.addr;
+	u8 *dst =3D walk->dst.virt.addr;
+	unsigned int nbytes =3D walk->nbytes;
+
+	blowfish_enc_blk(ctx, keystream, ctrblk);
+	crypto_xor(keystream, src, nbytes);
+	memcpy(dst, keystream, nbytes);
+
+	crypto_inc(ctrblk, BF_BLOCK_SIZE);
+}
+
+static unsigned int __ctr_crypt(struct blkcipher_desc *desc,
+				struct blkcipher_walk *walk)
+{
+	struct bf_ctx *ctx =3D crypto_blkcipher_ctx(desc->tfm);
+	unsigned int bsize =3D BF_BLOCK_SIZE;
+	unsigned int nbytes =3D walk->nbytes;
+	u64 *src =3D (u64 *)walk->src.virt.addr;
+	u64 *dst =3D (u64 *)walk->dst.virt.addr;
+	int i;
+
+	/* Process multi-block AVX2 batch */
+	if (nbytes >=3D bsize * BF_AVX2_PARALLEL_BLOCKS) {
+		do {
+			blowfish_ctr_32way(ctx, (u8 *)dst, (u8 *)src,
+					   (__be64 *)walk->iv);
+
+			src +=3D BF_AVX2_PARALLEL_BLOCKS;
+			dst +=3D BF_AVX2_PARALLEL_BLOCKS;
+			nbytes -=3D bsize * BF_AVX2_PARALLEL_BLOCKS;
+		} while (nbytes >=3D bsize * BF_AVX2_PARALLEL_BLOCKS);
+
+		if (nbytes < bsize)
+			goto done;
+	}
+
+	/* Process four block batch */
+	if (nbytes >=3D bsize * BF_PARALLEL_BLOCKS) {
+		__be64 ctrblocks[BF_PARALLEL_BLOCKS];
+		u64 ctrblk =3D be64_to_cpu(*(__be64 *)walk->iv);
+
+		do {
+			/* create ctrblks for parallel encrypt */
+			for (i =3D 0; i < BF_PARALLEL_BLOCKS; i++) {
+				if (dst !=3D src)
+					dst[i] =3D src[i];
+
+				ctrblocks[i] =3D cpu_to_be64(ctrblk++);
+			}
+
+			blowfish_enc_blk_xor_4way(ctx, (u8 *)dst,
+						  (u8 *)ctrblocks);
+
+			src +=3D BF_PARALLEL_BLOCKS;
+			dst +=3D BF_PARALLEL_BLOCKS;
+			nbytes -=3D bsize * BF_PARALLEL_BLOCKS;
+		} while (nbytes >=3D bsize * BF_PARALLEL_BLOCKS);
+
+		*(__be64 *)walk->iv =3D cpu_to_be64(ctrblk);
+
+		if (nbytes < bsize)
+			goto done;
+	}
+
+	/* Handle leftovers */
+	do {
+		u64 ctrblk;
+
+		if (dst !=3D src)
+			*dst =3D *src;
+
+		ctrblk =3D *(u64 *)walk->iv;
+		be64_add_cpu((__be64 *)walk->iv, 1);
+
+		blowfish_enc_blk_xor(ctx, (u8 *)dst, (u8 *)&ctrblk);
+
+		src +=3D 1;
+		dst +=3D 1;
+	} while ((nbytes -=3D bsize) >=3D bsize);
+
+done:
+	return nbytes;
+}
+
+static int ctr_crypt(struct blkcipher_desc *desc, struct scatterlist *=
dst,
+		     struct scatterlist *src, unsigned int nbytes)
+{
+	bool fpu_enabled =3D false;
+	struct blkcipher_walk walk;
+	int err;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err =3D blkcipher_walk_virt_block(desc, &walk, BF_BLOCK_SIZE);
+	desc->flags &=3D ~CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	while ((nbytes =3D walk.nbytes) >=3D BF_BLOCK_SIZE) {
+		fpu_enabled =3D bf_fpu_begin(fpu_enabled, nbytes);
+		nbytes =3D __ctr_crypt(desc, &walk);
+		err =3D blkcipher_walk_done(desc, &walk, nbytes);
+	}
+
+	bf_fpu_end(fpu_enabled);
+
+	if (walk.nbytes) {
+		ctr_crypt_final(desc, &walk);
+		err =3D blkcipher_walk_done(desc, &walk, 0);
+	}
+
+	return err;
+}
+
+static struct crypto_alg bf_algs[6] =3D { {
+	.cra_name		=3D "__ecb-blowfish-avx2",
+	.cra_driver_name	=3D "__driver-ecb-blowfish-avx2",
+	.cra_priority		=3D 0,
+	.cra_flags		=3D CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		=3D BF_BLOCK_SIZE,
+	.cra_ctxsize		=3D sizeof(struct bf_ctx),
+	.cra_alignmask		=3D 0,
+	.cra_type		=3D &crypto_blkcipher_type,
+	.cra_module		=3D THIS_MODULE,
+	.cra_u =3D {
+		.blkcipher =3D {
+			.min_keysize	=3D BF_MIN_KEY_SIZE,
+			.max_keysize	=3D BF_MAX_KEY_SIZE,
+			.setkey		=3D blowfish_setkey,
+			.encrypt	=3D ecb_encrypt,
+			.decrypt	=3D ecb_decrypt,
+		},
+	},
+}, {
+	.cra_name		=3D "__cbc-blowfish-avx2",
+	.cra_driver_name	=3D "__driver-cbc-blowfish-avx2",
+	.cra_priority		=3D 0,
+	.cra_flags		=3D CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		=3D BF_BLOCK_SIZE,
+	.cra_ctxsize		=3D sizeof(struct bf_ctx),
+	.cra_alignmask		=3D 0,
+	.cra_type		=3D &crypto_blkcipher_type,
+	.cra_module		=3D THIS_MODULE,
+	.cra_u =3D {
+		.blkcipher =3D {
+			.min_keysize	=3D BF_MIN_KEY_SIZE,
+			.max_keysize	=3D BF_MAX_KEY_SIZE,
+			.setkey		=3D blowfish_setkey,
+			.encrypt	=3D cbc_encrypt,
+			.decrypt	=3D cbc_decrypt,
+		},
+	},
+}, {
+	.cra_name		=3D "__ctr-blowfish-avx2",
+	.cra_driver_name	=3D "__driver-ctr-blowfish-avx2",
+	.cra_priority		=3D 0,
+	.cra_flags		=3D CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		=3D 1,
+	.cra_ctxsize		=3D sizeof(struct bf_ctx),
+	.cra_alignmask		=3D 0,
+	.cra_type		=3D &crypto_blkcipher_type,
+	.cra_module		=3D THIS_MODULE,
+	.cra_u =3D {
+		.blkcipher =3D {
+			.min_keysize	=3D BF_MIN_KEY_SIZE,
+			.max_keysize	=3D BF_MAX_KEY_SIZE,
+			.ivsize		=3D BF_BLOCK_SIZE,
+			.setkey		=3D blowfish_setkey,
+			.encrypt	=3D ctr_crypt,
+			.decrypt	=3D ctr_crypt,
+		},
+	},
+}, {
+	.cra_name		=3D "ecb(blowfish)",
+	.cra_driver_name	=3D "ecb-blowfish-avx2",
+	.cra_priority		=3D 400,
+	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		=3D BF_BLOCK_SIZE,
+	.cra_ctxsize		=3D sizeof(struct async_helper_ctx),
+	.cra_alignmask		=3D 0,
+	.cra_type		=3D &crypto_ablkcipher_type,
+	.cra_module		=3D THIS_MODULE,
+	.cra_init		=3D ablk_init,
+	.cra_exit		=3D ablk_exit,
+	.cra_u =3D {
+		.ablkcipher =3D {
+			.min_keysize	=3D BF_MIN_KEY_SIZE,
+			.max_keysize	=3D BF_MAX_KEY_SIZE,
+			.setkey		=3D ablk_set_key,
+			.encrypt	=3D ablk_encrypt,
+			.decrypt	=3D ablk_decrypt,
+		},
+	},
+}, {
+	.cra_name		=3D "cbc(blowfish)",
+	.cra_driver_name	=3D "cbc-blowfish-avx2",
+	.cra_priority		=3D 400,
+	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		=3D BF_BLOCK_SIZE,
+	.cra_ctxsize		=3D sizeof(struct async_helper_ctx),
+	.cra_alignmask		=3D 0,
+	.cra_type		=3D &crypto_ablkcipher_type,
+	.cra_module		=3D THIS_MODULE,
+	.cra_init		=3D ablk_init,
+	.cra_exit		=3D ablk_exit,
+	.cra_u =3D {
+		.ablkcipher =3D {
+			.min_keysize	=3D BF_MIN_KEY_SIZE,
+			.max_keysize	=3D BF_MAX_KEY_SIZE,
+			.ivsize		=3D BF_BLOCK_SIZE,
+			.setkey		=3D ablk_set_key,
+			.encrypt	=3D __ablk_encrypt,
+			.decrypt	=3D ablk_decrypt,
+		},
+	},
+}, {
+	.cra_name		=3D "ctr(blowfish)",
+	.cra_driver_name	=3D "ctr-blowfish-avx2",
+	.cra_priority		=3D 400,
+	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		=3D 1,
+	.cra_ctxsize		=3D sizeof(struct async_helper_ctx),
+	.cra_alignmask		=3D 0,
+	.cra_type		=3D &crypto_ablkcipher_type,
+	.cra_module		=3D THIS_MODULE,
+	.cra_init		=3D ablk_init,
+	.cra_exit		=3D ablk_exit,
+	.cra_u =3D {
+		.ablkcipher =3D {
+			.min_keysize	=3D BF_MIN_KEY_SIZE,
+			.max_keysize	=3D BF_MAX_KEY_SIZE,
+			.ivsize		=3D BF_BLOCK_SIZE,
+			.setkey		=3D ablk_set_key,
+			.encrypt	=3D ablk_encrypt,
+			.decrypt	=3D ablk_encrypt,
+			.geniv		=3D "chainiv",
+		},
+	},
+} };
+
+
+static int __init init(void)
+{
+	u64 xcr0;
+
+	if (!cpu_has_avx2 || !cpu_has_osxsave) {
+		pr_info("AVX2 instructions are not detected.\n");
+		return -ENODEV;
+	}
+
+	xcr0 =3D xgetbv(XCR_XFEATURE_ENABLED_MASK);
+	if ((xcr0 & (XSTATE_SSE | XSTATE_YMM)) !=3D (XSTATE_SSE | XSTATE_YMM)=
) {
+		pr_info("AVX detected but unusable.\n");
+		return -ENODEV;
+	}
+
+	return crypto_register_algs(bf_algs, ARRAY_SIZE(bf_algs));
+}
+
+static void __exit fini(void)
+{
+	crypto_unregister_algs(bf_algs, ARRAY_SIZE(bf_algs));
+}
+
+module_init(init);
+module_exit(fini);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Blowfish Cipher Algorithm, AVX2 optimized");
+MODULE_ALIAS("blowfish");
+MODULE_ALIAS("blowfish-asm");
diff --git a/arch/x86/crypto/blowfish_glue.c b/arch/x86/crypto/blowfish=
_glue.c
index 50ec333..3548d76 100644
--- a/arch/x86/crypto/blowfish_glue.c
+++ b/arch/x86/crypto/blowfish_glue.c
@@ -1,7 +1,7 @@
 /*
  * Glue Code for assembler optimized version of Blowfish
  *
- * Copyright (c) 2011 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
+ * Copyright =C2=A9 2011-2013 Jussi Kivilinna <jussi.kivilinna@iki.fi>
  *
  * CBC & ECB parts based on code (crypto/cbc.c,ecb.c) by:
  *   Copyright (c) 2006 Herbert Xu <herbert@gondor.apana.org.au>
@@ -32,40 +32,24 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <crypto/algapi.h>
+#include <asm/crypto/blowfish.h>
=20
 /* regular block cipher functions */
 asmlinkage void __blowfish_enc_blk(struct bf_ctx *ctx, u8 *dst, const =
u8 *src,
 				   bool xor);
+EXPORT_SYMBOL_GPL(__blowfish_enc_blk);
+
 asmlinkage void blowfish_dec_blk(struct bf_ctx *ctx, u8 *dst, const u8=
 *src);
+EXPORT_SYMBOL_GPL(blowfish_dec_blk);
=20
 /* 4-way parallel cipher functions */
 asmlinkage void __blowfish_enc_blk_4way(struct bf_ctx *ctx, u8 *dst,
 					const u8 *src, bool xor);
+EXPORT_SYMBOL_GPL(__blowfish_enc_blk_4way);
+
 asmlinkage void blowfish_dec_blk_4way(struct bf_ctx *ctx, u8 *dst,
 				      const u8 *src);
-
-static inline void blowfish_enc_blk(struct bf_ctx *ctx, u8 *dst, const=
 u8 *src)
-{
-	__blowfish_enc_blk(ctx, dst, src, false);
-}
-
-static inline void blowfish_enc_blk_xor(struct bf_ctx *ctx, u8 *dst,
-					const u8 *src)
-{
-	__blowfish_enc_blk(ctx, dst, src, true);
-}
-
-static inline void blowfish_enc_blk_4way(struct bf_ctx *ctx, u8 *dst,
-					 const u8 *src)
-{
-	__blowfish_enc_blk_4way(ctx, dst, src, false);
-}
-
-static inline void blowfish_enc_blk_xor_4way(struct bf_ctx *ctx, u8 *d=
st,
-				      const u8 *src)
-{
-	__blowfish_enc_blk_4way(ctx, dst, src, true);
-}
+EXPORT_SYMBOL_GPL(blowfish_dec_blk_4way);
=20
 static void blowfish_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8=
 *src)
 {
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/c=
pufeature.h
index 93fe929..1243272 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -278,6 +278,7 @@ extern const char * const x86_power_flags[32];
 #define cpu_has_ssse3		boot_cpu_has(X86_FEATURE_SSSE3)
 #define cpu_has_aes		boot_cpu_has(X86_FEATURE_AES)
 #define cpu_has_avx		boot_cpu_has(X86_FEATURE_AVX)
+#define cpu_has_avx2		boot_cpu_has(X86_FEATURE_AVX2)
 #define cpu_has_ht		boot_cpu_has(X86_FEATURE_HT)
 #define cpu_has_mp		boot_cpu_has(X86_FEATURE_MP)
 #define cpu_has_nx		boot_cpu_has(X86_FEATURE_NX)
diff --git a/arch/x86/include/asm/crypto/blowfish.h b/arch/x86/include/=
asm/crypto/blowfish.h
new file mode 100644
index 0000000..f097b2f
--- /dev/null
+++ b/arch/x86/include/asm/crypto/blowfish.h
@@ -0,0 +1,43 @@
+#ifndef ASM_X86_BLOWFISH_H
+#define ASM_X86_BLOWFISH_H
+
+#include <linux/crypto.h>
+#include <crypto/blowfish.h>
+
+#define BF_PARALLEL_BLOCKS 4
+
+/* regular block cipher functions */
+asmlinkage void __blowfish_enc_blk(struct bf_ctx *ctx, u8 *dst, const =
u8 *src,
+				   bool xor);
+asmlinkage void blowfish_dec_blk(struct bf_ctx *ctx, u8 *dst, const u8=
 *src);
+
+/* 4-way parallel cipher functions */
+asmlinkage void __blowfish_enc_blk_4way(struct bf_ctx *ctx, u8 *dst,
+					const u8 *src, bool xor);
+asmlinkage void blowfish_dec_blk_4way(struct bf_ctx *ctx, u8 *dst,
+				      const u8 *src);
+
+static inline void blowfish_enc_blk(struct bf_ctx *ctx, u8 *dst, const=
 u8 *src)
+{
+	__blowfish_enc_blk(ctx, dst, src, false);
+}
+
+static inline void blowfish_enc_blk_xor(struct bf_ctx *ctx, u8 *dst,
+					const u8 *src)
+{
+	__blowfish_enc_blk(ctx, dst, src, true);
+}
+
+static inline void blowfish_enc_blk_4way(struct bf_ctx *ctx, u8 *dst,
+					 const u8 *src)
+{
+	__blowfish_enc_blk_4way(ctx, dst, src, false);
+}
+
+static inline void blowfish_enc_blk_xor_4way(struct bf_ctx *ctx, u8 *d=
st,
+				      const u8 *src)
+{
+	__blowfish_enc_blk_4way(ctx, dst, src, true);
+}
+
+#endif
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 0e7a237..6b9564f 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -820,6 +820,24 @@ config CRYPTO_BLOWFISH_X86_64
 	  See also:
 	  <http://www.schneier.com/blowfish.html>
=20
+config CRYPTO_BLOWFISH_AVX2_X86_64
+	tristate "Blowfish cipher algorithm (x86_64/AVX2)"
+	depends on X86 && 64BIT
+	select CRYPTO_ALGAPI
+	select CRYPTO_CRYPTD
+	select CRYPTO_ABLK_HELPER_X86
+	select CRYPTO_BLOWFISH_COMMON
+	select CRYPTO_BLOWFISH_X86_64
+	help
+	  Blowfish cipher algorithm (x86_64/AVX2), by Bruce Schneier.
+
+	  This is a variable key length cipher which can use keys from 32
+	  bits to 448 bits in length.  It's fast, simple and specifically
+	  designed for use on "large microprocessors".
+
+	  See also:
+	  <http://www.schneier.com/blowfish.html>
+
 config CRYPTO_CAMELLIA
 	tristate "Camellia cipher algorithms"
 	depends on CRYPTO
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 3807084..f3effb4 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1655,6 +1655,9 @@ static const struct alg_test_desc alg_test_descs[=
] =3D {
 		.test =3D alg_test_null,
 		.fips_allowed =3D 1,
 	}, {
+		.alg =3D "__driver-cbc-blowfish-avx2",
+		.test =3D alg_test_null,
+	}, {
 		.alg =3D "__driver-cbc-camellia-aesni",
 		.test =3D alg_test_null,
 	}, {
@@ -1677,6 +1680,9 @@ static const struct alg_test_desc alg_test_descs[=
] =3D {
 		.test =3D alg_test_null,
 		.fips_allowed =3D 1,
 	}, {
+		.alg =3D "__driver-ecb-blowfish-avx2",
+		.test =3D alg_test_null,
+	}, {
 		.alg =3D "__driver-ecb-camellia-aesni",
 		.test =3D alg_test_null,
 	}, {
@@ -1948,6 +1954,9 @@ static const struct alg_test_desc alg_test_descs[=
] =3D {
 		.test =3D alg_test_null,
 		.fips_allowed =3D 1,
 	}, {
+		.alg =3D "cryptd(__driver-cbc-blowfish-avx2)",
+		.test =3D alg_test_null,
+	}, {
 		.alg =3D "cryptd(__driver-cbc-camellia-aesni)",
 		.test =3D alg_test_null,
 	}, {
@@ -1955,6 +1964,9 @@ static const struct alg_test_desc alg_test_descs[=
] =3D {
 		.test =3D alg_test_null,
 		.fips_allowed =3D 1,
 	}, {
+		.alg =3D "cryptd(__driver-ecb-blowfish-avx2)",
+		.test =3D alg_test_null,
+	}, {
 		.alg =3D "cryptd(__driver-ecb-camellia-aesni)",
 		.test =3D alg_test_null,
 	}, {
