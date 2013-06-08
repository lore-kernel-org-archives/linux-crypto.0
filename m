From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: [PATCH 2/2] Revert "crypto: twofish - add AVX2/x86_64 assembler
 implementation of twofish cipher"
Date: Sat, 08 Jun 2013 12:17:47 +0300
Message-ID: <20130608091747.31485.93164.stgit@localhost6.localdomain6>
References: <20130608091742.31485.50446.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sinikuusama.dnainternet.net ([83.102.40.134]:55510 "EHLO
	sinikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751861Ab3FHJR5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 8 Jun 2013 05:17:57 -0400
In-Reply-To: <20130608091742.31485.50446.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This reverts commit cf1521a1a5e21fd1e79a458605c4282fbfbbeee2.

Instruction (vpgatherdd) that this implementation relied on turned out =
to be
slow performer on real hardware (i5-4570). The previous 8-way twofish/A=
VX
implementation is therefore faster and this implementation should be re=
moved.

Converting this implementation to use the same method as in twofish/AVX=
 for
table look-ups would give additional ~3% speed up vs twofish/AVX, but w=
ould
hardly be worth of the added code and binary size.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
---
 arch/x86/crypto/Makefile              |    2=20
 arch/x86/crypto/twofish-avx2-asm_64.S |  600 -------------------------=
--------
 arch/x86/crypto/twofish_avx2_glue.c   |  584 -------------------------=
-------
 arch/x86/crypto/twofish_avx_glue.c    |   14 -
 arch/x86/include/asm/crypto/twofish.h |   18 -
 crypto/Kconfig                        |   24 -
 crypto/testmgr.c                      |   12 -
 7 files changed, 2 insertions(+), 1252 deletions(-)
 delete mode 100644 arch/x86/crypto/twofish-avx2-asm_64.S
 delete mode 100644 arch/x86/crypto/twofish_avx2_glue.c

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index 9ce3418..7d6ba9d 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -43,7 +43,6 @@ endif
 ifeq ($(avx2_supported),yes)
 	obj-$(CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64) +=3D camellia-aesni-a=
vx2.o
 	obj-$(CONFIG_CRYPTO_SERPENT_AVX2_X86_64) +=3D serpent-avx2.o
-	obj-$(CONFIG_CRYPTO_TWOFISH_AVX2_X86_64) +=3D twofish-avx2.o
 endif
=20
 aes-i586-y :=3D aes-i586-asm_32.o aes_glue.o
@@ -73,7 +72,6 @@ endif
 ifeq ($(avx2_supported),yes)
 	camellia-aesni-avx2-y :=3D camellia-aesni-avx2-asm_64.o camellia_aesn=
i_avx2_glue.o
 	serpent-avx2-y :=3D serpent-avx2-asm_64.o serpent_avx2_glue.o
-	twofish-avx2-y :=3D twofish-avx2-asm_64.o twofish_avx2_glue.o
 endif
=20
 aesni-intel-y :=3D aesni-intel_asm.o aesni-intel_glue.o fpu.o
diff --git a/arch/x86/crypto/twofish-avx2-asm_64.S b/arch/x86/crypto/tw=
ofish-avx2-asm_64.S
deleted file mode 100644
index e1a83b9..0000000
--- a/arch/x86/crypto/twofish-avx2-asm_64.S
+++ /dev/null
@@ -1,600 +0,0 @@
-/*
- * x86_64/AVX2 assembler optimized version of Twofish
- *
- * Copyright =C2=A9 2012-2013 Jussi Kivilinna <jussi.kivilinna@iki.fi>
- *
- * This program is free software; you can redistribute it and/or modif=
y
- * it under the terms of the GNU General Public License as published b=
y
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- */
-
-#include <linux/linkage.h>
-#include "glue_helper-asm-avx2.S"
-
-.file "twofish-avx2-asm_64.S"
-
-.data
-.align 16
-
-.Lvpshufb_mask0:
-.long 0x80808000
-.long 0x80808004
-.long 0x80808008
-.long 0x8080800c
-
-.Lbswap128_mask:
-	.byte 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0
-.Lxts_gf128mul_and_shl1_mask_0:
-	.byte 0x87, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0
-.Lxts_gf128mul_and_shl1_mask_1:
-	.byte 0x0e, 1, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0
-
-.text
-
-/* structure of crypto context */
-#define s0	0
-#define s1	1024
-#define s2	2048
-#define s3	3072
-#define w	4096
-#define	k	4128
-
-/* register macros */
-#define CTX	%rdi
-
-#define RS0	CTX
-#define RS1	%r8
-#define RS2	%r9
-#define RS3	%r10
-#define RK	%r11
-#define RW	%rax
-#define RROUND  %r12
-#define RROUNDd %r12d
-
-#define RA0	%ymm8
-#define RB0	%ymm9
-#define RC0	%ymm10
-#define RD0	%ymm11
-#define RA1	%ymm12
-#define RB1	%ymm13
-#define RC1	%ymm14
-#define RD1	%ymm15
-
-/* temp regs */
-#define RX0	%ymm0
-#define RY0	%ymm1
-#define RX1	%ymm2
-#define RY1	%ymm3
-#define RT0	%ymm4
-#define RIDX	%ymm5
-
-#define RX0x	%xmm0
-#define RY0x	%xmm1
-#define RX1x	%xmm2
-#define RY1x	%xmm3
-#define RT0x	%xmm4
-
-/* vpgatherdd mask and '-1' */
-#define RNOT	%ymm6
-
-/* byte mask, (-1 >> 24) */
-#define RBYTE	%ymm7
-
-/*********************************************************************=
*
-  16-way AVX2 twofish
- *********************************************************************=
*/
-#define init_round_constants() \
-	vpcmpeqd RNOT, RNOT, RNOT; \
-	vpsrld $24, RNOT, RBYTE; \
-	leaq k(CTX), RK; \
-	leaq w(CTX), RW; \
-	leaq s1(CTX), RS1; \
-	leaq s2(CTX), RS2; \
-	leaq s3(CTX), RS3; \
-
-#define g16(ab, rs0, rs1, rs2, rs3, xy) \
-	vpand RBYTE, ab ## 0, RIDX; \
-	vpgatherdd RNOT, (rs0, RIDX, 4), xy ## 0; \
-	vpcmpeqd RNOT, RNOT, RNOT; \
-		\
-		vpand RBYTE, ab ## 1, RIDX; \
-		vpgatherdd RNOT, (rs0, RIDX, 4), xy ## 1; \
-		vpcmpeqd RNOT, RNOT, RNOT; \
-	\
-	vpsrld $8, ab ## 0, RIDX; \
-	vpand RBYTE, RIDX, RIDX; \
-	vpgatherdd RNOT, (rs1, RIDX, 4), RT0; \
-	vpcmpeqd RNOT, RNOT, RNOT; \
-	vpxor RT0, xy ## 0, xy ## 0; \
-		\
-		vpsrld $8, ab ## 1, RIDX; \
-		vpand RBYTE, RIDX, RIDX; \
-		vpgatherdd RNOT, (rs1, RIDX, 4), RT0; \
-		vpcmpeqd RNOT, RNOT, RNOT; \
-		vpxor RT0, xy ## 1, xy ## 1; \
-	\
-	vpsrld $16, ab ## 0, RIDX; \
-	vpand RBYTE, RIDX, RIDX; \
-	vpgatherdd RNOT, (rs2, RIDX, 4), RT0; \
-	vpcmpeqd RNOT, RNOT, RNOT; \
-	vpxor RT0, xy ## 0, xy ## 0; \
-		\
-		vpsrld $16, ab ## 1, RIDX; \
-		vpand RBYTE, RIDX, RIDX; \
-		vpgatherdd RNOT, (rs2, RIDX, 4), RT0; \
-		vpcmpeqd RNOT, RNOT, RNOT; \
-		vpxor RT0, xy ## 1, xy ## 1; \
-	\
-	vpsrld $24, ab ## 0, RIDX; \
-	vpgatherdd RNOT, (rs3, RIDX, 4), RT0; \
-	vpcmpeqd RNOT, RNOT, RNOT; \
-	vpxor RT0, xy ## 0, xy ## 0; \
-		\
-		vpsrld $24, ab ## 1, RIDX; \
-		vpgatherdd RNOT, (rs3, RIDX, 4), RT0; \
-		vpcmpeqd RNOT, RNOT, RNOT; \
-		vpxor RT0, xy ## 1, xy ## 1;
-
-#define g1_16(a, x) \
-	g16(a, RS0, RS1, RS2, RS3, x);
-
-#define g2_16(b, y) \
-	g16(b, RS1, RS2, RS3, RS0, y);
-
-#define encrypt_round_end16(a, b, c, d, nk) \
-	vpaddd RY0, RX0, RX0; \
-	vpaddd RX0, RY0, RY0; \
-	vpbroadcastd nk(RK,RROUND,8), RT0; \
-	vpaddd RT0, RX0, RX0; \
-	vpbroadcastd 4+nk(RK,RROUND,8), RT0; \
-	vpaddd RT0, RY0, RY0; \
-	\
-	vpxor RY0, d ## 0, d ## 0; \
-	\
-	vpxor RX0, c ## 0, c ## 0; \
-	vpsrld $1, c ## 0, RT0; \
-	vpslld $31, c ## 0, c ## 0; \
-	vpor RT0, c ## 0, c ## 0; \
-	\
-		vpaddd RY1, RX1, RX1; \
-		vpaddd RX1, RY1, RY1; \
-		vpbroadcastd nk(RK,RROUND,8), RT0; \
-		vpaddd RT0, RX1, RX1; \
-		vpbroadcastd 4+nk(RK,RROUND,8), RT0; \
-		vpaddd RT0, RY1, RY1; \
-		\
-		vpxor RY1, d ## 1, d ## 1; \
-		\
-		vpxor RX1, c ## 1, c ## 1; \
-		vpsrld $1, c ## 1, RT0; \
-		vpslld $31, c ## 1, c ## 1; \
-		vpor RT0, c ## 1, c ## 1; \
-
-#define encrypt_round16(a, b, c, d, nk) \
-	g2_16(b, RY); \
-	\
-	vpslld $1, b ## 0, RT0; \
-	vpsrld $31, b ## 0, b ## 0; \
-	vpor RT0, b ## 0, b ## 0; \
-	\
-		vpslld $1, b ## 1, RT0; \
-		vpsrld $31, b ## 1, b ## 1; \
-		vpor RT0, b ## 1, b ## 1; \
-	\
-	g1_16(a, RX); \
-	\
-	encrypt_round_end16(a, b, c, d, nk);
-
-#define encrypt_round_first16(a, b, c, d, nk) \
-	vpslld $1, d ## 0, RT0; \
-	vpsrld $31, d ## 0, d ## 0; \
-	vpor RT0, d ## 0, d ## 0; \
-	\
-		vpslld $1, d ## 1, RT0; \
-		vpsrld $31, d ## 1, d ## 1; \
-		vpor RT0, d ## 1, d ## 1; \
-	\
-	encrypt_round16(a, b, c, d, nk);
-
-#define encrypt_round_last16(a, b, c, d, nk) \
-	g2_16(b, RY); \
-	\
-	g1_16(a, RX); \
-	\
-	encrypt_round_end16(a, b, c, d, nk);
-
-#define decrypt_round_end16(a, b, c, d, nk) \
-	vpaddd RY0, RX0, RX0; \
-	vpaddd RX0, RY0, RY0; \
-	vpbroadcastd nk(RK,RROUND,8), RT0; \
-	vpaddd RT0, RX0, RX0; \
-	vpbroadcastd 4+nk(RK,RROUND,8), RT0; \
-	vpaddd RT0, RY0, RY0; \
-	\
-	vpxor RX0, c ## 0, c ## 0; \
-	\
-	vpxor RY0, d ## 0, d ## 0; \
-	vpsrld $1, d ## 0, RT0; \
-	vpslld $31, d ## 0, d ## 0; \
-	vpor RT0, d ## 0, d ## 0; \
-	\
-		vpaddd RY1, RX1, RX1; \
-		vpaddd RX1, RY1, RY1; \
-		vpbroadcastd nk(RK,RROUND,8), RT0; \
-		vpaddd RT0, RX1, RX1; \
-		vpbroadcastd 4+nk(RK,RROUND,8), RT0; \
-		vpaddd RT0, RY1, RY1; \
-		\
-		vpxor RX1, c ## 1, c ## 1; \
-		\
-		vpxor RY1, d ## 1, d ## 1; \
-		vpsrld $1, d ## 1, RT0; \
-		vpslld $31, d ## 1, d ## 1; \
-		vpor RT0, d ## 1, d ## 1;
-
-#define decrypt_round16(a, b, c, d, nk) \
-	g1_16(a, RX); \
-	\
-	vpslld $1, a ## 0, RT0; \
-	vpsrld $31, a ## 0, a ## 0; \
-	vpor RT0, a ## 0, a ## 0; \
-	\
-		vpslld $1, a ## 1, RT0; \
-		vpsrld $31, a ## 1, a ## 1; \
-		vpor RT0, a ## 1, a ## 1; \
-	\
-	g2_16(b, RY); \
-	\
-	decrypt_round_end16(a, b, c, d, nk);
-
-#define decrypt_round_first16(a, b, c, d, nk) \
-	vpslld $1, c ## 0, RT0; \
-	vpsrld $31, c ## 0, c ## 0; \
-	vpor RT0, c ## 0, c ## 0; \
-	\
-		vpslld $1, c ## 1, RT0; \
-		vpsrld $31, c ## 1, c ## 1; \
-		vpor RT0, c ## 1, c ## 1; \
-	\
-	decrypt_round16(a, b, c, d, nk)
-
-#define decrypt_round_last16(a, b, c, d, nk) \
-	g1_16(a, RX); \
-	\
-	g2_16(b, RY); \
-	\
-	decrypt_round_end16(a, b, c, d, nk);
-
-#define encrypt_cycle16() \
-	encrypt_round16(RA, RB, RC, RD, 0); \
-	encrypt_round16(RC, RD, RA, RB, 8);
-
-#define encrypt_cycle_first16() \
-	encrypt_round_first16(RA, RB, RC, RD, 0); \
-	encrypt_round16(RC, RD, RA, RB, 8);
-
-#define encrypt_cycle_last16() \
-	encrypt_round16(RA, RB, RC, RD, 0); \
-	encrypt_round_last16(RC, RD, RA, RB, 8);
-
-#define decrypt_cycle16(n) \
-	decrypt_round16(RC, RD, RA, RB, 8); \
-	decrypt_round16(RA, RB, RC, RD, 0);
-
-#define decrypt_cycle_first16(n) \
-	decrypt_round_first16(RC, RD, RA, RB, 8); \
-	decrypt_round16(RA, RB, RC, RD, 0);
-
-#define decrypt_cycle_last16(n) \
-	decrypt_round16(RC, RD, RA, RB, 8); \
-	decrypt_round_last16(RA, RB, RC, RD, 0);
-
-#define transpose_4x4(x0,x1,x2,x3,t1,t2) \
-	vpunpckhdq x1, x0, t2; \
-	vpunpckldq x1, x0, x0; \
-	\
-	vpunpckldq x3, x2, t1; \
-	vpunpckhdq x3, x2, x2; \
-	\
-	vpunpckhqdq t1,	x0, x1; \
-	vpunpcklqdq t1,	x0, x0; \
-	\
-	vpunpckhqdq x2, t2, x3; \
-	vpunpcklqdq x2,	t2, x2;
-
-#define read_blocks8(offs,a,b,c,d) \
-	transpose_4x4(a, b, c, d, RX0, RY0);
-
-#define write_blocks8(offs,a,b,c,d) \
-	transpose_4x4(a, b, c, d, RX0, RY0);
-
-#define inpack_enc8(a,b,c,d) \
-	vpbroadcastd 4*0(RW), RT0; \
-	vpxor RT0, a, a; \
-	\
-	vpbroadcastd 4*1(RW), RT0; \
-	vpxor RT0, b, b; \
-	\
-	vpbroadcastd 4*2(RW), RT0; \
-	vpxor RT0, c, c; \
-	\
-	vpbroadcastd 4*3(RW), RT0; \
-	vpxor RT0, d, d;
-
-#define outunpack_enc8(a,b,c,d) \
-	vpbroadcastd 4*4(RW), RX0; \
-	vpbroadcastd 4*5(RW), RY0; \
-	vpxor RX0, c, RX0; \
-	vpxor RY0, d, RY0; \
-	\
-	vpbroadcastd 4*6(RW), RT0; \
-	vpxor RT0, a, c; \
-	vpbroadcastd 4*7(RW), RT0; \
-	vpxor RT0, b, d; \
-	\
-	vmovdqa RX0, a; \
-	vmovdqa RY0, b;
-
-#define inpack_dec8(a,b,c,d) \
-	vpbroadcastd 4*4(RW), RX0; \
-	vpbroadcastd 4*5(RW), RY0; \
-	vpxor RX0, a, RX0; \
-	vpxor RY0, b, RY0; \
-	\
-	vpbroadcastd 4*6(RW), RT0; \
-	vpxor RT0, c, a; \
-	vpbroadcastd 4*7(RW), RT0; \
-	vpxor RT0, d, b; \
-	\
-	vmovdqa RX0, c; \
-	vmovdqa RY0, d;
-
-#define outunpack_dec8(a,b,c,d) \
-	vpbroadcastd 4*0(RW), RT0; \
-	vpxor RT0, a, a; \
-	\
-	vpbroadcastd 4*1(RW), RT0; \
-	vpxor RT0, b, b; \
-	\
-	vpbroadcastd 4*2(RW), RT0; \
-	vpxor RT0, c, c; \
-	\
-	vpbroadcastd 4*3(RW), RT0; \
-	vpxor RT0, d, d;
-
-#define read_blocks16(a,b,c,d) \
-	read_blocks8(0, a ## 0, b ## 0, c ## 0, d ## 0); \
-	read_blocks8(8, a ## 1, b ## 1, c ## 1, d ## 1);
-
-#define write_blocks16(a,b,c,d) \
-	write_blocks8(0, a ## 0, b ## 0, c ## 0, d ## 0); \
-	write_blocks8(8, a ## 1, b ## 1, c ## 1, d ## 1);
-
-#define xor_blocks16(a,b,c,d) \
-	xor_blocks8(0, a ## 0, b ## 0, c ## 0, d ## 0); \
-	xor_blocks8(8, a ## 1, b ## 1, c ## 1, d ## 1);
-
-#define inpack_enc16(a,b,c,d) \
-	inpack_enc8(a ## 0, b ## 0, c ## 0, d ## 0); \
-	inpack_enc8(a ## 1, b ## 1, c ## 1, d ## 1);
-
-#define outunpack_enc16(a,b,c,d) \
-	outunpack_enc8(a ## 0, b ## 0, c ## 0, d ## 0); \
-	outunpack_enc8(a ## 1, b ## 1, c ## 1, d ## 1);
-
-#define inpack_dec16(a,b,c,d) \
-	inpack_dec8(a ## 0, b ## 0, c ## 0, d ## 0); \
-	inpack_dec8(a ## 1, b ## 1, c ## 1, d ## 1);
-
-#define outunpack_dec16(a,b,c,d) \
-	outunpack_dec8(a ## 0, b ## 0, c ## 0, d ## 0); \
-	outunpack_dec8(a ## 1, b ## 1, c ## 1, d ## 1);
-
-.align 8
-__twofish_enc_blk16:
-	/* input:
-	 *	%rdi: ctx, CTX
-	 *	RA0, RB0, RC0, RD0, RA1, RB1, RC1, RD1: plaintext
-	 * output:
-	 *	RA0, RB0, RC0, RD0, RA1, RB1, RC1, RD1: ciphertext
-	 */
-	init_round_constants();
-
-	read_blocks16(RA, RB, RC, RD);
-	inpack_enc16(RA, RB, RC, RD);
-
-	xorl RROUNDd, RROUNDd;
-	encrypt_cycle_first16();
-	movl $2, RROUNDd;
-
-.align 4
-.L__enc_loop:
-	encrypt_cycle16();
-
-	addl $2, RROUNDd;
-	cmpl $14, RROUNDd;
-	jne .L__enc_loop;
-
-	encrypt_cycle_last16();
-
-	outunpack_enc16(RA, RB, RC, RD);
-	write_blocks16(RA, RB, RC, RD);
-
-	ret;
-ENDPROC(__twofish_enc_blk16)
-
-.align 8
-__twofish_dec_blk16:
-	/* input:
-	 *	%rdi: ctx, CTX
-	 *	RA0, RB0, RC0, RD0, RA1, RB1, RC1, RD1: ciphertext
-	 * output:
-	 *	RA0, RB0, RC0, RD0, RA1, RB1, RC1, RD1: plaintext
-	 */
-	init_round_constants();
-
-	read_blocks16(RA, RB, RC, RD);
-	inpack_dec16(RA, RB, RC, RD);
-
-	movl $14, RROUNDd;
-	decrypt_cycle_first16();
-	movl $12, RROUNDd;
-
-.align 4
-.L__dec_loop:
-	decrypt_cycle16();
-
-	addl $-2, RROUNDd;
-	jnz .L__dec_loop;
-
-	decrypt_cycle_last16();
-
-	outunpack_dec16(RA, RB, RC, RD);
-	write_blocks16(RA, RB, RC, RD);
-
-	ret;
-ENDPROC(__twofish_dec_blk16)
-
-ENTRY(twofish_ecb_enc_16way)
-	/* input:
-	 *	%rdi: ctx, CTX
-	 *	%rsi: dst
-	 *	%rdx: src
-	 */
-
-	vzeroupper;
-	pushq %r12;
-
-	load_16way(%rdx, RA0, RB0, RC0, RD0, RA1, RB1, RC1, RD1);
-
-	call __twofish_enc_blk16;
-
-	store_16way(%rsi, RA0, RB0, RC0, RD0, RA1, RB1, RC1, RD1);
-
-	popq %r12;
-	vzeroupper;
-
-	ret;
-ENDPROC(twofish_ecb_enc_16way)
-
-ENTRY(twofish_ecb_dec_16way)
-	/* input:
-	 *	%rdi: ctx, CTX
-	 *	%rsi: dst
-	 *	%rdx: src
-	 */
-
-	vzeroupper;
-	pushq %r12;
-
-	load_16way(%rdx, RA0, RB0, RC0, RD0, RA1, RB1, RC1, RD1);
-
-	call __twofish_dec_blk16;
-
-	store_16way(%rsi, RA0, RB0, RC0, RD0, RA1, RB1, RC1, RD1);
-
-	popq %r12;
-	vzeroupper;
-
-	ret;
-ENDPROC(twofish_ecb_dec_16way)
-
-ENTRY(twofish_cbc_dec_16way)
-	/* input:
-	 *	%rdi: ctx, CTX
-	 *	%rsi: dst
-	 *	%rdx: src
-	 */
-
-	vzeroupper;
-	pushq %r12;
-
-	load_16way(%rdx, RA0, RB0, RC0, RD0, RA1, RB1, RC1, RD1);
-
-	call __twofish_dec_blk16;
-
-	store_cbc_16way(%rdx, %rsi, RA0, RB0, RC0, RD0, RA1, RB1, RC1, RD1,
-			RX0);
-
-	popq %r12;
-	vzeroupper;
-
-	ret;
-ENDPROC(twofish_cbc_dec_16way)
-
-ENTRY(twofish_ctr_16way)
-	/* input:
-	 *	%rdi: ctx, CTX
-	 *	%rsi: dst (16 blocks)
-	 *	%rdx: src (16 blocks)
-	 *	%rcx: iv (little endian, 128bit)
-	 */
-
-	vzeroupper;
-	pushq %r12;
-
-	load_ctr_16way(%rcx, .Lbswap128_mask, RA0, RB0, RC0, RD0, RA1, RB1, R=
C1,
-		       RD1, RX0, RX0x, RX1, RX1x, RY0, RY0x, RY1, RY1x, RNOT,
-		       RBYTE);
-
-	call __twofish_enc_blk16;
-
-	store_ctr_16way(%rdx, %rsi, RA0, RB0, RC0, RD0, RA1, RB1, RC1, RD1);
-
-	popq %r12;
-	vzeroupper;
-
-	ret;
-ENDPROC(twofish_ctr_16way)
-
-.align 8
-twofish_xts_crypt_16way:
-	/* input:
-	 *	%rdi: ctx, CTX
-	 *	%rsi: dst (16 blocks)
-	 *	%rdx: src (16 blocks)
-	 *	%rcx: iv (t =E2=8A=95 =CE=B1=E2=81=BF =E2=88=88 GF(2=C2=B9=C2=B2=E2=
=81=B8))
-	 *	%r8: pointer to __twofish_enc_blk16 or __twofish_dec_blk16
-	 */
-
-	vzeroupper;
-	pushq %r12;
-
-	load_xts_16way(%rcx, %rdx, %rsi, RA0, RB0, RC0, RD0, RA1, RB1, RC1,
-		       RD1, RX0, RX0x, RX1, RX1x, RY0, RY0x, RY1, RY1x, RNOT,
-		       .Lxts_gf128mul_and_shl1_mask_0,
-		       .Lxts_gf128mul_and_shl1_mask_1);
-
-	call *%r8;
-
-	store_xts_16way(%rsi, RA0, RB0, RC0, RD0, RA1, RB1, RC1, RD1);
-
-	popq %r12;
-	vzeroupper;
-
-	ret;
-ENDPROC(twofish_xts_crypt_16way)
-
-ENTRY(twofish_xts_enc_16way)
-	/* input:
-	 *	%rdi: ctx, CTX
-	 *	%rsi: dst (16 blocks)
-	 *	%rdx: src (16 blocks)
-	 *	%rcx: iv (t =E2=8A=95 =CE=B1=E2=81=BF =E2=88=88 GF(2=C2=B9=C2=B2=E2=
=81=B8))
-	 */
-	leaq __twofish_enc_blk16, %r8;
-	jmp twofish_xts_crypt_16way;
-ENDPROC(twofish_xts_enc_16way)
-
-ENTRY(twofish_xts_dec_16way)
-	/* input:
-	 *	%rdi: ctx, CTX
-	 *	%rsi: dst (16 blocks)
-	 *	%rdx: src (16 blocks)
-	 *	%rcx: iv (t =E2=8A=95 =CE=B1=E2=81=BF =E2=88=88 GF(2=C2=B9=C2=B2=E2=
=81=B8))
-	 */
-	leaq __twofish_dec_blk16, %r8;
-	jmp twofish_xts_crypt_16way;
-ENDPROC(twofish_xts_dec_16way)
diff --git a/arch/x86/crypto/twofish_avx2_glue.c b/arch/x86/crypto/twof=
ish_avx2_glue.c
deleted file mode 100644
index ce33b5b..0000000
--- a/arch/x86/crypto/twofish_avx2_glue.c
+++ /dev/null
@@ -1,584 +0,0 @@
-/*
- * Glue Code for x86_64/AVX2 assembler optimized version of Twofish
- *
- * Copyright =C2=A9 2012-2013 Jussi Kivilinna <jussi.kivilinna@mbnet.f=
i>
- *
- * This program is free software; you can redistribute it and/or modif=
y
- * it under the terms of the GNU General Public License as published b=
y
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- */
-
-#include <linux/module.h>
-#include <linux/types.h>
-#include <linux/crypto.h>
-#include <linux/err.h>
-#include <crypto/algapi.h>
-#include <crypto/ctr.h>
-#include <crypto/twofish.h>
-#include <crypto/lrw.h>
-#include <crypto/xts.h>
-#include <asm/xcr.h>
-#include <asm/xsave.h>
-#include <asm/crypto/twofish.h>
-#include <asm/crypto/ablk_helper.h>
-#include <asm/crypto/glue_helper.h>
-#include <crypto/scatterwalk.h>
-
-#define TF_AVX2_PARALLEL_BLOCKS 16
-
-/* 16-way AVX2 parallel cipher functions */
-asmlinkage void twofish_ecb_enc_16way(struct twofish_ctx *ctx, u8 *dst=
,
-				      const u8 *src);
-asmlinkage void twofish_ecb_dec_16way(struct twofish_ctx *ctx, u8 *dst=
,
-				      const u8 *src);
-asmlinkage void twofish_cbc_dec_16way(void *ctx, u128 *dst, const u128=
 *src);
-
-asmlinkage void twofish_ctr_16way(void *ctx, u128 *dst, const u128 *sr=
c,
-				  le128 *iv);
-
-asmlinkage void twofish_xts_enc_16way(struct twofish_ctx *ctx, u8 *dst=
,
-				      const u8 *src, le128 *iv);
-asmlinkage void twofish_xts_dec_16way(struct twofish_ctx *ctx, u8 *dst=
,
-				      const u8 *src, le128 *iv);
-
-static inline void twofish_enc_blk_3way(struct twofish_ctx *ctx, u8 *d=
st,
-					const u8 *src)
-{
-	__twofish_enc_blk_3way(ctx, dst, src, false);
-}
-
-static const struct common_glue_ctx twofish_enc =3D {
-	.num_funcs =3D 4,
-	.fpu_blocks_limit =3D 8,
-
-	.funcs =3D { {
-		.num_blocks =3D 16,
-		.fn_u =3D { .ecb =3D GLUE_FUNC_CAST(twofish_ecb_enc_16way) }
-	}, {
-		.num_blocks =3D 8,
-		.fn_u =3D { .ecb =3D GLUE_FUNC_CAST(twofish_ecb_enc_8way) }
-	}, {
-		.num_blocks =3D 3,
-		.fn_u =3D { .ecb =3D GLUE_FUNC_CAST(twofish_enc_blk_3way) }
-	}, {
-		.num_blocks =3D 1,
-		.fn_u =3D { .ecb =3D GLUE_FUNC_CAST(twofish_enc_blk) }
-	} }
-};
-
-static const struct common_glue_ctx twofish_ctr =3D {
-	.num_funcs =3D 4,
-	.fpu_blocks_limit =3D 8,
-
-	.funcs =3D { {
-		.num_blocks =3D 16,
-		.fn_u =3D { .ctr =3D GLUE_CTR_FUNC_CAST(twofish_ctr_16way) }
-	},  {
-		.num_blocks =3D 8,
-		.fn_u =3D { .ctr =3D GLUE_CTR_FUNC_CAST(twofish_ctr_8way) }
-	}, {
-		.num_blocks =3D 3,
-		.fn_u =3D { .ctr =3D GLUE_CTR_FUNC_CAST(twofish_enc_blk_ctr_3way) }
-	}, {
-		.num_blocks =3D 1,
-		.fn_u =3D { .ctr =3D GLUE_CTR_FUNC_CAST(twofish_enc_blk_ctr) }
-	} }
-};
-
-static const struct common_glue_ctx twofish_enc_xts =3D {
-	.num_funcs =3D 3,
-	.fpu_blocks_limit =3D 8,
-
-	.funcs =3D { {
-		.num_blocks =3D 16,
-		.fn_u =3D { .xts =3D GLUE_XTS_FUNC_CAST(twofish_xts_enc_16way) }
-	}, {
-		.num_blocks =3D 8,
-		.fn_u =3D { .xts =3D GLUE_XTS_FUNC_CAST(twofish_xts_enc_8way) }
-	}, {
-		.num_blocks =3D 1,
-		.fn_u =3D { .xts =3D GLUE_XTS_FUNC_CAST(twofish_xts_enc) }
-	} }
-};
-
-static const struct common_glue_ctx twofish_dec =3D {
-	.num_funcs =3D 4,
-	.fpu_blocks_limit =3D 8,
-
-	.funcs =3D { {
-		.num_blocks =3D 16,
-		.fn_u =3D { .ecb =3D GLUE_FUNC_CAST(twofish_ecb_dec_16way) }
-	}, {
-		.num_blocks =3D 8,
-		.fn_u =3D { .ecb =3D GLUE_FUNC_CAST(twofish_ecb_dec_8way) }
-	}, {
-		.num_blocks =3D 3,
-		.fn_u =3D { .ecb =3D GLUE_FUNC_CAST(twofish_dec_blk_3way) }
-	}, {
-		.num_blocks =3D 1,
-		.fn_u =3D { .ecb =3D GLUE_FUNC_CAST(twofish_dec_blk) }
-	} }
-};
-
-static const struct common_glue_ctx twofish_dec_cbc =3D {
-	.num_funcs =3D 4,
-	.fpu_blocks_limit =3D 8,
-
-	.funcs =3D { {
-		.num_blocks =3D 16,
-		.fn_u =3D { .cbc =3D GLUE_CBC_FUNC_CAST(twofish_cbc_dec_16way) }
-	}, {
-		.num_blocks =3D 8,
-		.fn_u =3D { .cbc =3D GLUE_CBC_FUNC_CAST(twofish_cbc_dec_8way) }
-	}, {
-		.num_blocks =3D 3,
-		.fn_u =3D { .cbc =3D GLUE_CBC_FUNC_CAST(twofish_dec_blk_cbc_3way) }
-	}, {
-		.num_blocks =3D 1,
-		.fn_u =3D { .cbc =3D GLUE_CBC_FUNC_CAST(twofish_dec_blk) }
-	} }
-};
-
-static const struct common_glue_ctx twofish_dec_xts =3D {
-	.num_funcs =3D 3,
-	.fpu_blocks_limit =3D 8,
-
-	.funcs =3D { {
-		.num_blocks =3D 16,
-		.fn_u =3D { .xts =3D GLUE_XTS_FUNC_CAST(twofish_xts_dec_16way) }
-	}, {
-		.num_blocks =3D 8,
-		.fn_u =3D { .xts =3D GLUE_XTS_FUNC_CAST(twofish_xts_dec_8way) }
-	}, {
-		.num_blocks =3D 1,
-		.fn_u =3D { .xts =3D GLUE_XTS_FUNC_CAST(twofish_xts_dec) }
-	} }
-};
-
-static int ecb_encrypt(struct blkcipher_desc *desc, struct scatterlist=
 *dst,
-		       struct scatterlist *src, unsigned int nbytes)
-{
-	return glue_ecb_crypt_128bit(&twofish_enc, desc, dst, src, nbytes);
-}
-
-static int ecb_decrypt(struct blkcipher_desc *desc, struct scatterlist=
 *dst,
-		       struct scatterlist *src, unsigned int nbytes)
-{
-	return glue_ecb_crypt_128bit(&twofish_dec, desc, dst, src, nbytes);
-}
-
-static int cbc_encrypt(struct blkcipher_desc *desc, struct scatterlist=
 *dst,
-		       struct scatterlist *src, unsigned int nbytes)
-{
-	return glue_cbc_encrypt_128bit(GLUE_FUNC_CAST(twofish_enc_blk), desc,
-				       dst, src, nbytes);
-}
-
-static int cbc_decrypt(struct blkcipher_desc *desc, struct scatterlist=
 *dst,
-		       struct scatterlist *src, unsigned int nbytes)
-{
-	return glue_cbc_decrypt_128bit(&twofish_dec_cbc, desc, dst, src,
-				       nbytes);
-}
-
-static int ctr_crypt(struct blkcipher_desc *desc, struct scatterlist *=
dst,
-		     struct scatterlist *src, unsigned int nbytes)
-{
-	return glue_ctr_crypt_128bit(&twofish_ctr, desc, dst, src, nbytes);
-}
-
-static inline bool twofish_fpu_begin(bool fpu_enabled, unsigned int nb=
ytes)
-{
-	/* since reusing AVX functions, starts using FPU at 8 parallel blocks=
 */
-	return glue_fpu_begin(TF_BLOCK_SIZE, 8, NULL, fpu_enabled, nbytes);
-}
-
-static inline void twofish_fpu_end(bool fpu_enabled)
-{
-	glue_fpu_end(fpu_enabled);
-}
-
-struct crypt_priv {
-	struct twofish_ctx *ctx;
-	bool fpu_enabled;
-};
-
-static void encrypt_callback(void *priv, u8 *srcdst, unsigned int nbyt=
es)
-{
-	const unsigned int bsize =3D TF_BLOCK_SIZE;
-	struct crypt_priv *ctx =3D priv;
-	int i;
-
-	ctx->fpu_enabled =3D twofish_fpu_begin(ctx->fpu_enabled, nbytes);
-
-	while (nbytes >=3D TF_AVX2_PARALLEL_BLOCKS * bsize) {
-		twofish_ecb_enc_16way(ctx->ctx, srcdst, srcdst);
-		srcdst +=3D bsize * TF_AVX2_PARALLEL_BLOCKS;
-		nbytes -=3D bsize * TF_AVX2_PARALLEL_BLOCKS;
-	}
-
-	while (nbytes >=3D 8 * bsize) {
-		twofish_ecb_enc_8way(ctx->ctx, srcdst, srcdst);
-		srcdst +=3D bsize * 8;
-		nbytes -=3D bsize * 8;
-	}
-
-	while (nbytes >=3D 3 * bsize) {
-		twofish_enc_blk_3way(ctx->ctx, srcdst, srcdst);
-		srcdst +=3D bsize * 3;
-		nbytes -=3D bsize * 3;
-	}
-
-	for (i =3D 0; i < nbytes / bsize; i++, srcdst +=3D bsize)
-		twofish_enc_blk(ctx->ctx, srcdst, srcdst);
-}
-
-static void decrypt_callback(void *priv, u8 *srcdst, unsigned int nbyt=
es)
-{
-	const unsigned int bsize =3D TF_BLOCK_SIZE;
-	struct crypt_priv *ctx =3D priv;
-	int i;
-
-	ctx->fpu_enabled =3D twofish_fpu_begin(ctx->fpu_enabled, nbytes);
-
-	while (nbytes >=3D TF_AVX2_PARALLEL_BLOCKS * bsize) {
-		twofish_ecb_dec_16way(ctx->ctx, srcdst, srcdst);
-		srcdst +=3D bsize * TF_AVX2_PARALLEL_BLOCKS;
-		nbytes -=3D bsize * TF_AVX2_PARALLEL_BLOCKS;
-	}
-
-	while (nbytes >=3D 8 * bsize) {
-		twofish_ecb_dec_8way(ctx->ctx, srcdst, srcdst);
-		srcdst +=3D bsize * 8;
-		nbytes -=3D bsize * 8;
-	}
-
-	while (nbytes >=3D 3 * bsize) {
-		twofish_dec_blk_3way(ctx->ctx, srcdst, srcdst);
-		srcdst +=3D bsize * 3;
-		nbytes -=3D bsize * 3;
-	}
-
-	for (i =3D 0; i < nbytes / bsize; i++, srcdst +=3D bsize)
-		twofish_dec_blk(ctx->ctx, srcdst, srcdst);
-}
-
-static int lrw_encrypt(struct blkcipher_desc *desc, struct scatterlist=
 *dst,
-		       struct scatterlist *src, unsigned int nbytes)
-{
-	struct twofish_lrw_ctx *ctx =3D crypto_blkcipher_ctx(desc->tfm);
-	be128 buf[TF_AVX2_PARALLEL_BLOCKS];
-	struct crypt_priv crypt_ctx =3D {
-		.ctx =3D &ctx->twofish_ctx,
-		.fpu_enabled =3D false,
-	};
-	struct lrw_crypt_req req =3D {
-		.tbuf =3D buf,
-		.tbuflen =3D sizeof(buf),
-
-		.table_ctx =3D &ctx->lrw_table,
-		.crypt_ctx =3D &crypt_ctx,
-		.crypt_fn =3D encrypt_callback,
-	};
-	int ret;
-
-	desc->flags &=3D ~CRYPTO_TFM_REQ_MAY_SLEEP;
-	ret =3D lrw_crypt(desc, dst, src, nbytes, &req);
-	twofish_fpu_end(crypt_ctx.fpu_enabled);
-
-	return ret;
-}
-
-static int lrw_decrypt(struct blkcipher_desc *desc, struct scatterlist=
 *dst,
-		       struct scatterlist *src, unsigned int nbytes)
-{
-	struct twofish_lrw_ctx *ctx =3D crypto_blkcipher_ctx(desc->tfm);
-	be128 buf[TF_AVX2_PARALLEL_BLOCKS];
-	struct crypt_priv crypt_ctx =3D {
-		.ctx =3D &ctx->twofish_ctx,
-		.fpu_enabled =3D false,
-	};
-	struct lrw_crypt_req req =3D {
-		.tbuf =3D buf,
-		.tbuflen =3D sizeof(buf),
-
-		.table_ctx =3D &ctx->lrw_table,
-		.crypt_ctx =3D &crypt_ctx,
-		.crypt_fn =3D decrypt_callback,
-	};
-	int ret;
-
-	desc->flags &=3D ~CRYPTO_TFM_REQ_MAY_SLEEP;
-	ret =3D lrw_crypt(desc, dst, src, nbytes, &req);
-	twofish_fpu_end(crypt_ctx.fpu_enabled);
-
-	return ret;
-}
-
-static int xts_encrypt(struct blkcipher_desc *desc, struct scatterlist=
 *dst,
-		       struct scatterlist *src, unsigned int nbytes)
-{
-	struct twofish_xts_ctx *ctx =3D crypto_blkcipher_ctx(desc->tfm);
-
-	return glue_xts_crypt_128bit(&twofish_enc_xts, desc, dst, src, nbytes=
,
-				     XTS_TWEAK_CAST(twofish_enc_blk),
-				     &ctx->tweak_ctx, &ctx->crypt_ctx);
-}
-
-static int xts_decrypt(struct blkcipher_desc *desc, struct scatterlist=
 *dst,
-		       struct scatterlist *src, unsigned int nbytes)
-{
-	struct twofish_xts_ctx *ctx =3D crypto_blkcipher_ctx(desc->tfm);
-
-	return glue_xts_crypt_128bit(&twofish_dec_xts, desc, dst, src, nbytes=
,
-				     XTS_TWEAK_CAST(twofish_enc_blk),
-				     &ctx->tweak_ctx, &ctx->crypt_ctx);
-}
-
-static struct crypto_alg tf_algs[10] =3D { {
-	.cra_name		=3D "__ecb-twofish-avx2",
-	.cra_driver_name	=3D "__driver-ecb-twofish-avx2",
-	.cra_priority		=3D 0,
-	.cra_flags		=3D CRYPTO_ALG_TYPE_BLKCIPHER,
-	.cra_blocksize		=3D TF_BLOCK_SIZE,
-	.cra_ctxsize		=3D sizeof(struct twofish_ctx),
-	.cra_alignmask		=3D 0,
-	.cra_type		=3D &crypto_blkcipher_type,
-	.cra_module		=3D THIS_MODULE,
-	.cra_u =3D {
-		.blkcipher =3D {
-			.min_keysize	=3D TF_MIN_KEY_SIZE,
-			.max_keysize	=3D TF_MAX_KEY_SIZE,
-			.setkey		=3D twofish_setkey,
-			.encrypt	=3D ecb_encrypt,
-			.decrypt	=3D ecb_decrypt,
-		},
-	},
-}, {
-	.cra_name		=3D "__cbc-twofish-avx2",
-	.cra_driver_name	=3D "__driver-cbc-twofish-avx2",
-	.cra_priority		=3D 0,
-	.cra_flags		=3D CRYPTO_ALG_TYPE_BLKCIPHER,
-	.cra_blocksize		=3D TF_BLOCK_SIZE,
-	.cra_ctxsize		=3D sizeof(struct twofish_ctx),
-	.cra_alignmask		=3D 0,
-	.cra_type		=3D &crypto_blkcipher_type,
-	.cra_module		=3D THIS_MODULE,
-	.cra_u =3D {
-		.blkcipher =3D {
-			.min_keysize	=3D TF_MIN_KEY_SIZE,
-			.max_keysize	=3D TF_MAX_KEY_SIZE,
-			.setkey		=3D twofish_setkey,
-			.encrypt	=3D cbc_encrypt,
-			.decrypt	=3D cbc_decrypt,
-		},
-	},
-}, {
-	.cra_name		=3D "__ctr-twofish-avx2",
-	.cra_driver_name	=3D "__driver-ctr-twofish-avx2",
-	.cra_priority		=3D 0,
-	.cra_flags		=3D CRYPTO_ALG_TYPE_BLKCIPHER,
-	.cra_blocksize		=3D 1,
-	.cra_ctxsize		=3D sizeof(struct twofish_ctx),
-	.cra_alignmask		=3D 0,
-	.cra_type		=3D &crypto_blkcipher_type,
-	.cra_module		=3D THIS_MODULE,
-	.cra_u =3D {
-		.blkcipher =3D {
-			.min_keysize	=3D TF_MIN_KEY_SIZE,
-			.max_keysize	=3D TF_MAX_KEY_SIZE,
-			.ivsize		=3D TF_BLOCK_SIZE,
-			.setkey		=3D twofish_setkey,
-			.encrypt	=3D ctr_crypt,
-			.decrypt	=3D ctr_crypt,
-		},
-	},
-}, {
-	.cra_name		=3D "__lrw-twofish-avx2",
-	.cra_driver_name	=3D "__driver-lrw-twofish-avx2",
-	.cra_priority		=3D 0,
-	.cra_flags		=3D CRYPTO_ALG_TYPE_BLKCIPHER,
-	.cra_blocksize		=3D TF_BLOCK_SIZE,
-	.cra_ctxsize		=3D sizeof(struct twofish_lrw_ctx),
-	.cra_alignmask		=3D 0,
-	.cra_type		=3D &crypto_blkcipher_type,
-	.cra_module		=3D THIS_MODULE,
-	.cra_exit		=3D lrw_twofish_exit_tfm,
-	.cra_u =3D {
-		.blkcipher =3D {
-			.min_keysize	=3D TF_MIN_KEY_SIZE +
-					  TF_BLOCK_SIZE,
-			.max_keysize	=3D TF_MAX_KEY_SIZE +
-					  TF_BLOCK_SIZE,
-			.ivsize		=3D TF_BLOCK_SIZE,
-			.setkey		=3D lrw_twofish_setkey,
-			.encrypt	=3D lrw_encrypt,
-			.decrypt	=3D lrw_decrypt,
-		},
-	},
-}, {
-	.cra_name		=3D "__xts-twofish-avx2",
-	.cra_driver_name	=3D "__driver-xts-twofish-avx2",
-	.cra_priority		=3D 0,
-	.cra_flags		=3D CRYPTO_ALG_TYPE_BLKCIPHER,
-	.cra_blocksize		=3D TF_BLOCK_SIZE,
-	.cra_ctxsize		=3D sizeof(struct twofish_xts_ctx),
-	.cra_alignmask		=3D 0,
-	.cra_type		=3D &crypto_blkcipher_type,
-	.cra_module		=3D THIS_MODULE,
-	.cra_u =3D {
-		.blkcipher =3D {
-			.min_keysize	=3D TF_MIN_KEY_SIZE * 2,
-			.max_keysize	=3D TF_MAX_KEY_SIZE * 2,
-			.ivsize		=3D TF_BLOCK_SIZE,
-			.setkey		=3D xts_twofish_setkey,
-			.encrypt	=3D xts_encrypt,
-			.decrypt	=3D xts_decrypt,
-		},
-	},
-}, {
-	.cra_name		=3D "ecb(twofish)",
-	.cra_driver_name	=3D "ecb-twofish-avx2",
-	.cra_priority		=3D 500,
-	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
-	.cra_blocksize		=3D TF_BLOCK_SIZE,
-	.cra_ctxsize		=3D sizeof(struct async_helper_ctx),
-	.cra_alignmask		=3D 0,
-	.cra_type		=3D &crypto_ablkcipher_type,
-	.cra_module		=3D THIS_MODULE,
-	.cra_init		=3D ablk_init,
-	.cra_exit		=3D ablk_exit,
-	.cra_u =3D {
-		.ablkcipher =3D {
-			.min_keysize	=3D TF_MIN_KEY_SIZE,
-			.max_keysize	=3D TF_MAX_KEY_SIZE,
-			.setkey		=3D ablk_set_key,
-			.encrypt	=3D ablk_encrypt,
-			.decrypt	=3D ablk_decrypt,
-		},
-	},
-}, {
-	.cra_name		=3D "cbc(twofish)",
-	.cra_driver_name	=3D "cbc-twofish-avx2",
-	.cra_priority		=3D 500,
-	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
-	.cra_blocksize		=3D TF_BLOCK_SIZE,
-	.cra_ctxsize		=3D sizeof(struct async_helper_ctx),
-	.cra_alignmask		=3D 0,
-	.cra_type		=3D &crypto_ablkcipher_type,
-	.cra_module		=3D THIS_MODULE,
-	.cra_init		=3D ablk_init,
-	.cra_exit		=3D ablk_exit,
-	.cra_u =3D {
-		.ablkcipher =3D {
-			.min_keysize	=3D TF_MIN_KEY_SIZE,
-			.max_keysize	=3D TF_MAX_KEY_SIZE,
-			.ivsize		=3D TF_BLOCK_SIZE,
-			.setkey		=3D ablk_set_key,
-			.encrypt	=3D __ablk_encrypt,
-			.decrypt	=3D ablk_decrypt,
-		},
-	},
-}, {
-	.cra_name		=3D "ctr(twofish)",
-	.cra_driver_name	=3D "ctr-twofish-avx2",
-	.cra_priority		=3D 500,
-	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
-	.cra_blocksize		=3D 1,
-	.cra_ctxsize		=3D sizeof(struct async_helper_ctx),
-	.cra_alignmask		=3D 0,
-	.cra_type		=3D &crypto_ablkcipher_type,
-	.cra_module		=3D THIS_MODULE,
-	.cra_init		=3D ablk_init,
-	.cra_exit		=3D ablk_exit,
-	.cra_u =3D {
-		.ablkcipher =3D {
-			.min_keysize	=3D TF_MIN_KEY_SIZE,
-			.max_keysize	=3D TF_MAX_KEY_SIZE,
-			.ivsize		=3D TF_BLOCK_SIZE,
-			.setkey		=3D ablk_set_key,
-			.encrypt	=3D ablk_encrypt,
-			.decrypt	=3D ablk_encrypt,
-			.geniv		=3D "chainiv",
-		},
-	},
-}, {
-	.cra_name		=3D "lrw(twofish)",
-	.cra_driver_name	=3D "lrw-twofish-avx2",
-	.cra_priority		=3D 500,
-	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
-	.cra_blocksize		=3D TF_BLOCK_SIZE,
-	.cra_ctxsize		=3D sizeof(struct async_helper_ctx),
-	.cra_alignmask		=3D 0,
-	.cra_type		=3D &crypto_ablkcipher_type,
-	.cra_module		=3D THIS_MODULE,
-	.cra_init		=3D ablk_init,
-	.cra_exit		=3D ablk_exit,
-	.cra_u =3D {
-		.ablkcipher =3D {
-			.min_keysize	=3D TF_MIN_KEY_SIZE +
-					  TF_BLOCK_SIZE,
-			.max_keysize	=3D TF_MAX_KEY_SIZE +
-					  TF_BLOCK_SIZE,
-			.ivsize		=3D TF_BLOCK_SIZE,
-			.setkey		=3D ablk_set_key,
-			.encrypt	=3D ablk_encrypt,
-			.decrypt	=3D ablk_decrypt,
-		},
-	},
-}, {
-	.cra_name		=3D "xts(twofish)",
-	.cra_driver_name	=3D "xts-twofish-avx2",
-	.cra_priority		=3D 500,
-	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
-	.cra_blocksize		=3D TF_BLOCK_SIZE,
-	.cra_ctxsize		=3D sizeof(struct async_helper_ctx),
-	.cra_alignmask		=3D 0,
-	.cra_type		=3D &crypto_ablkcipher_type,
-	.cra_module		=3D THIS_MODULE,
-	.cra_init		=3D ablk_init,
-	.cra_exit		=3D ablk_exit,
-	.cra_u =3D {
-		.ablkcipher =3D {
-			.min_keysize	=3D TF_MIN_KEY_SIZE * 2,
-			.max_keysize	=3D TF_MAX_KEY_SIZE * 2,
-			.ivsize		=3D TF_BLOCK_SIZE,
-			.setkey		=3D ablk_set_key,
-			.encrypt	=3D ablk_encrypt,
-			.decrypt	=3D ablk_decrypt,
-		},
-	},
-} };
-
-static int __init init(void)
-{
-	u64 xcr0;
-
-	if (!cpu_has_avx2 || !cpu_has_osxsave) {
-		pr_info("AVX2 instructions are not detected.\n");
-		return -ENODEV;
-	}
-
-	xcr0 =3D xgetbv(XCR_XFEATURE_ENABLED_MASK);
-	if ((xcr0 & (XSTATE_SSE | XSTATE_YMM)) !=3D (XSTATE_SSE | XSTATE_YMM)=
) {
-		pr_info("AVX2 detected but unusable.\n");
-		return -ENODEV;
-	}
-
-	return crypto_register_algs(tf_algs, ARRAY_SIZE(tf_algs));
-}
-
-static void __exit fini(void)
-{
-	crypto_unregister_algs(tf_algs, ARRAY_SIZE(tf_algs));
-}
-
-module_init(init);
-module_exit(fini);
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Twofish Cipher Algorithm, AVX2 optimized");
-MODULE_ALIAS("twofish");
-MODULE_ALIAS("twofish-asm");
diff --git a/arch/x86/crypto/twofish_avx_glue.c b/arch/x86/crypto/twofi=
sh_avx_glue.c
index 2047a56..a62ba54 100644
--- a/arch/x86/crypto/twofish_avx_glue.c
+++ b/arch/x86/crypto/twofish_avx_glue.c
@@ -50,26 +50,18 @@
 /* 8-way parallel cipher functions */
 asmlinkage void twofish_ecb_enc_8way(struct twofish_ctx *ctx, u8 *dst,
 				     const u8 *src);
-EXPORT_SYMBOL_GPL(twofish_ecb_enc_8way);
-
 asmlinkage void twofish_ecb_dec_8way(struct twofish_ctx *ctx, u8 *dst,
 				     const u8 *src);
-EXPORT_SYMBOL_GPL(twofish_ecb_dec_8way);
=20
 asmlinkage void twofish_cbc_dec_8way(struct twofish_ctx *ctx, u8 *dst,
 				     const u8 *src);
-EXPORT_SYMBOL_GPL(twofish_cbc_dec_8way);
-
 asmlinkage void twofish_ctr_8way(struct twofish_ctx *ctx, u8 *dst,
 				 const u8 *src, le128 *iv);
-EXPORT_SYMBOL_GPL(twofish_ctr_8way);
=20
 asmlinkage void twofish_xts_enc_8way(struct twofish_ctx *ctx, u8 *dst,
 				     const u8 *src, le128 *iv);
-EXPORT_SYMBOL_GPL(twofish_xts_enc_8way);
 asmlinkage void twofish_xts_dec_8way(struct twofish_ctx *ctx, u8 *dst,
 				     const u8 *src, le128 *iv);
-EXPORT_SYMBOL_GPL(twofish_xts_dec_8way);
=20
 static inline void twofish_enc_blk_3way(struct twofish_ctx *ctx, u8 *d=
st,
 					const u8 *src)
@@ -77,19 +69,17 @@ static inline void twofish_enc_blk_3way(struct twof=
ish_ctx *ctx, u8 *dst,
 	__twofish_enc_blk_3way(ctx, dst, src, false);
 }
=20
-void twofish_xts_enc(void *ctx, u128 *dst, const u128 *src, le128 *iv)
+static void twofish_xts_enc(void *ctx, u128 *dst, const u128 *src, le1=
28 *iv)
 {
 	glue_xts_crypt_128bit_one(ctx, dst, src, iv,
 				  GLUE_FUNC_CAST(twofish_enc_blk));
 }
-EXPORT_SYMBOL_GPL(twofish_xts_enc);
=20
-void twofish_xts_dec(void *ctx, u128 *dst, const u128 *src, le128 *iv)
+static void twofish_xts_dec(void *ctx, u128 *dst, const u128 *src, le1=
28 *iv)
 {
 	glue_xts_crypt_128bit_one(ctx, dst, src, iv,
 				  GLUE_FUNC_CAST(twofish_dec_blk));
 }
-EXPORT_SYMBOL_GPL(twofish_xts_dec);
=20
=20
 static const struct common_glue_ctx twofish_enc =3D {
diff --git a/arch/x86/include/asm/crypto/twofish.h b/arch/x86/include/a=
sm/crypto/twofish.h
index e655c60..878c51c 100644
--- a/arch/x86/include/asm/crypto/twofish.h
+++ b/arch/x86/include/asm/crypto/twofish.h
@@ -28,20 +28,6 @@ asmlinkage void __twofish_enc_blk_3way(struct twofis=
h_ctx *ctx, u8 *dst,
 asmlinkage void twofish_dec_blk_3way(struct twofish_ctx *ctx, u8 *dst,
 				     const u8 *src);
=20
-/* 8-way parallel cipher functions */
-asmlinkage void twofish_ecb_enc_8way(struct twofish_ctx *ctx, u8 *dst,
-				     const u8 *src);
-asmlinkage void twofish_ecb_dec_8way(struct twofish_ctx *ctx, u8 *dst,
-				     const u8 *src);
-asmlinkage void twofish_cbc_dec_8way(struct twofish_ctx *ctx, u8 *dst,
-				     const u8 *src);
-asmlinkage void twofish_ctr_8way(struct twofish_ctx *ctx, u8 *dst,
-				 const u8 *src, le128 *iv);
-asmlinkage void twofish_xts_enc_8way(struct twofish_ctx *ctx, u8 *dst,
-				     const u8 *src, le128 *iv);
-asmlinkage void twofish_xts_dec_8way(struct twofish_ctx *ctx, u8 *dst,
-				     const u8 *src, le128 *iv);
-
 /* helpers from twofish_x86_64-3way module */
 extern void twofish_dec_blk_cbc_3way(void *ctx, u128 *dst, const u128 =
*src);
 extern void twofish_enc_blk_ctr(void *ctx, u128 *dst, const u128 *src,
@@ -57,8 +43,4 @@ extern void lrw_twofish_exit_tfm(struct crypto_tfm *t=
fm);
 extern int xts_twofish_setkey(struct crypto_tfm *tfm, const u8 *key,
 			      unsigned int keylen);
=20
-/* helpers from twofish-avx module */
-extern void twofish_xts_enc(void *ctx, u128 *dst, const u128 *src, le1=
28 *iv);
-extern void twofish_xts_dec(void *ctx, u128 *dst, const u128 *src, le1=
28 *iv);
-
 #endif /* ASM_X86_TWOFISH_H */
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 4ef0ee7..904ffe8 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1297,30 +1297,6 @@ config CRYPTO_TWOFISH_AVX_X86_64
 	  See also:
 	  <http://www.schneier.com/twofish.html>
=20
-config CRYPTO_TWOFISH_AVX2_X86_64
-	tristate "Twofish cipher algorithm (x86_64/AVX2)"
-	depends on X86 && 64BIT
-	select CRYPTO_ALGAPI
-	select CRYPTO_CRYPTD
-	select CRYPTO_ABLK_HELPER_X86
-	select CRYPTO_GLUE_HELPER_X86
-	select CRYPTO_TWOFISH_COMMON
-	select CRYPTO_TWOFISH_X86_64
-	select CRYPTO_TWOFISH_X86_64_3WAY
-	select CRYPTO_TWOFISH_AVX_X86_64
-	select CRYPTO_LRW
-	select CRYPTO_XTS
-	help
-	  Twofish cipher algorithm (x86_64/AVX2).
-
-	  Twofish was submitted as an AES (Advanced Encryption Standard)
-	  candidate cipher by researchers at CounterPane Systems.  It is a
-	  16 round block cipher supporting key sizes of 128, 192, and 256
-	  bits.
-
-	  See also:
-	  <http://www.schneier.com/twofish.html>
-
 comment "Compression"
=20
 config CRYPTO_DEFLATE
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 27f1118..b2bc533 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1654,9 +1654,6 @@ static const struct alg_test_desc alg_test_descs[=
] =3D {
 		.alg =3D "__cbc-twofish-avx",
 		.test =3D alg_test_null,
 	}, {
-		.alg =3D "__cbc-twofish-avx2",
-		.test =3D alg_test_null,
-	}, {
 		.alg =3D "__driver-cbc-aes-aesni",
 		.test =3D alg_test_null,
 		.fips_allowed =3D 1,
@@ -1685,9 +1682,6 @@ static const struct alg_test_desc alg_test_descs[=
] =3D {
 		.alg =3D "__driver-cbc-twofish-avx",
 		.test =3D alg_test_null,
 	}, {
-		.alg =3D "__driver-cbc-twofish-avx2",
-		.test =3D alg_test_null,
-	}, {
 		.alg =3D "__driver-ecb-aes-aesni",
 		.test =3D alg_test_null,
 		.fips_allowed =3D 1,
@@ -1716,9 +1710,6 @@ static const struct alg_test_desc alg_test_descs[=
] =3D {
 		.alg =3D "__driver-ecb-twofish-avx",
 		.test =3D alg_test_null,
 	}, {
-		.alg =3D "__driver-ecb-twofish-avx2",
-		.test =3D alg_test_null,
-	}, {
 		.alg =3D "__ghash-pclmulqdqni",
 		.test =3D alg_test_null,
 		.fips_allowed =3D 1,
@@ -2019,9 +2010,6 @@ static const struct alg_test_desc alg_test_descs[=
] =3D {
 		.alg =3D "cryptd(__driver-ecb-twofish-avx)",
 		.test =3D alg_test_null,
 	}, {
-		.alg =3D "cryptd(__driver-ecb-twofish-avx2)",
-		.test =3D alg_test_null,
-	}, {
 		.alg =3D "cryptd(__driver-gcm-aes-aesni)",
 		.test =3D alg_test_null,
 		.fips_allowed =3D 1,
