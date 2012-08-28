From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 3/3] crypto: cast6-avx - tune assembler code for more
 performance
Date: Tue, 28 Aug 2012 14:24:54 +0300
Message-ID: <20120828112454.22504.67324.stgit@localhost6.localdomain6>
References: <20120828112443.22504.68633.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Johannes Goetzfried
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:50650 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab2H1LY5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 Aug 2012 07:24:57 -0400
In-Reply-To: <20120828112443.22504.68633.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Patch replaces 'movb' instructions with 'movzbl' to break false registe=
r
dependencies, interleaves instructions better for out-of-order scheduli=
ng
and merges constant 16-bit rotation with round-key variable rotation.

tcrypt ECB results:

Intel Core i5-2450M:

size    old-vs-new      new-vs-generic  old-vs-generic
        enc     dec     enc     dec     enc     dec
256     1.13x   1.19x   2.05x   2.17x   1.82x   1.82x
1k      1.18x   1.21x   2.26x   2.33x   1.93x   1.93x
8k      1.19x   1.19x   2.32x   2.33x   1.95x   1.95x

[v2]
 - Do instruction interleaving another way to avoid adding new FPU<=3D>=
CPU
   register moves as these cause performance drop on Bulldozer.
 - Improvements to round-key variable rotation handling.
 - Further interleaving improvements for better out-of-order scheduling=
=2E

Cc: Johannes Goetzfried <Johannes.Goetzfried@informatik.stud.uni-erlang=
en.de>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/cast6-avx-x86_64-asm_64.S |  277 +++++++++++++++++----=
--------
 1 file changed, 163 insertions(+), 114 deletions(-)

diff --git a/arch/x86/crypto/cast6-avx-x86_64-asm_64.S b/arch/x86/crypt=
o/cast6-avx-x86_64-asm_64.S
index d258ce0..325b0a7 100644
--- a/arch/x86/crypto/cast6-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/cast6-avx-x86_64-asm_64.S
@@ -4,6 +4,8 @@
  * Copyright (C) 2012 Johannes Goetzfried
  *     <Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
  *
+ * Copyright =C2=A9 2012 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
+ *
  * This program is free software; you can redistribute it and/or modif=
y
  * it under the terms of the GNU General Public License as published b=
y
  * the Free Software Foundation; either version 2 of the License, or
@@ -22,7 +24,6 @@
  */
=20
 .file "cast6-avx-x86_64-asm_64.S"
-.text
=20
 .extern cast6_s1
 .extern cast6_s2
@@ -54,20 +55,21 @@
 #define RC2 %xmm6
 #define RD2 %xmm7
=20
-#define RX %xmm8
+#define RX  %xmm8
=20
 #define RKM  %xmm9
-#define RKRF %xmm10
-#define RKRR %xmm11
+#define RKR  %xmm10
+#define RKRF %xmm11
+#define RKRR %xmm12
+#define R32  %xmm13
+#define R1ST %xmm14
=20
-#define RTMP  %xmm12
-#define RMASK %xmm13
-#define R32   %xmm14
+#define RTMP %xmm15
=20
-#define RID1  %rax
-#define RID1b %al
-#define RID2  %rbx
-#define RID2b %bl
+#define RID1  %rbp
+#define RID1d %ebp
+#define RID2  %rsi
+#define RID2d %esi
=20
 #define RGI1   %rdx
 #define RGI1bl %dl
@@ -76,6 +78,13 @@
 #define RGI2bl %cl
 #define RGI2bh %ch
=20
+#define RGI3   %rax
+#define RGI3bl %al
+#define RGI3bh %ah
+#define RGI4   %rbx
+#define RGI4bl %bl
+#define RGI4bh %bh
+
 #define RFS1  %r8
 #define RFS1d %r8d
 #define RFS2  %r9
@@ -84,95 +93,106 @@
 #define RFS3d %r10d
=20
=20
-#define lookup_32bit(src, dst, op1, op2, op3) \
-	movb		src ## bl,     RID1b;    \
-	movb		src ## bh,     RID2b;    \
+#define lookup_32bit(src, dst, op1, op2, op3, interleave_op, il_reg) \
+	movzbl		src ## bh,     RID1d;    \
+	movzbl		src ## bl,     RID2d;    \
+	shrq $16,	src;                     \
 	movl		s1(, RID1, 4), dst ## d; \
 	op1		s2(, RID2, 4), dst ## d; \
-	shrq $16,	src;                     \
-	movb		src ## bl,     RID1b;    \
-	movb		src ## bh,     RID2b;    \
+	movzbl		src ## bh,     RID1d;    \
+	movzbl		src ## bl,     RID2d;    \
+	interleave_op(il_reg);			 \
 	op2		s3(, RID1, 4), dst ## d; \
 	op3		s4(, RID2, 4), dst ## d;
=20
-#define F(a, x, op0, op1, op2, op3) \
+#define dummy(d) /* do nothing */
+
+#define shr_next(reg) \
+	shrq $16,	reg;
+
+#define F_head(a, x, gi1, gi2, op0) \
 	op0	a,	RKM,  x;                 \
-	vpslld  RKRF,	x,    RTMP;              \
-	vpsrld  RKRR,	x,    x;                 \
+	vpslld	RKRF,	x,    RTMP;              \
+	vpsrld	RKRR,	x,    x;                 \
 	vpor	RTMP,	x,    x;                 \
 	\
-	vpshufb	RMASK,	x,    x;                 \
-	vmovq		x,    RGI1;              \
-	vpsrldq $8,	x,    x;                 \
-	vmovq		x,    RGI2;              \
-	\
-	lookup_32bit(RGI1, RFS1, op1, op2, op3); \
-	shrq $16,	RGI1;                    \
-	lookup_32bit(RGI1, RFS2, op1, op2, op3); \
-	shlq $32,	RFS2;                    \
-	orq		RFS1, RFS2;              \
+	vmovq		x,    gi1;               \
+	vpextrq $1,	x,    gi2;
+
+#define F_tail(a, x, gi1, gi2, op1, op2, op3) \
+	lookup_32bit(##gi1, RFS1, op1, op2, op3, shr_next, ##gi1); \
+	lookup_32bit(##gi2, RFS3, op1, op2, op3, shr_next, ##gi2); \
 	\
-	lookup_32bit(RGI2, RFS1, op1, op2, op3); \
-	shrq $16,	RGI2;                    \
-	lookup_32bit(RGI2, RFS3, op1, op2, op3); \
-	shlq $32,	RFS3;                    \
-	orq		RFS1, RFS3;              \
+	lookup_32bit(##gi1, RFS2, op1, op2, op3, dummy, none);     \
+	shlq $32,	RFS2;                                      \
+	orq		RFS1, RFS2;                                \
+	lookup_32bit(##gi2, RFS1, op1, op2, op3, dummy, none);     \
+	shlq $32,	RFS1;                                      \
+	orq		RFS1, RFS3;                                \
 	\
-	vmovq		RFS2, x;                 \
+	vmovq		RFS2, x;                                   \
 	vpinsrq $1,	RFS3, x, x;
=20
-#define F1(b, x) F(b, x, vpaddd, xorl, subl, addl)
-#define F2(b, x) F(b, x, vpxor,  subl, addl, xorl)
-#define F3(b, x) F(b, x, vpsubd, addl, xorl, subl)
+#define F_2(a1, b1, a2, b2, op0, op1, op2, op3) \
+	F_head(b1, RX, RGI1, RGI2, op0);              \
+	F_head(b2, RX, RGI3, RGI4, op0);              \
+	\
+	F_tail(b1, RX, RGI1, RGI2, op1, op2, op3);    \
+	F_tail(b2, RTMP, RGI3, RGI4, op1, op2, op3);  \
+	\
+	vpxor		a1, RX,   a1;                 \
+	vpxor		a2, RTMP, a2;
+
+#define F1_2(a1, b1, a2, b2) \
+	F_2(a1, b1, a2, b2, vpaddd, xorl, subl, addl)
+#define F2_2(a1, b1, a2, b2) \
+	F_2(a1, b1, a2, b2, vpxor, subl, addl, xorl)
+#define F3_2(a1, b1, a2, b2) \
+	F_2(a1, b1, a2, b2, vpsubd, addl, xorl, subl)
+
+#define qop(in, out, f) \
+	F ## f ## _2(out ## 1, in ## 1, out ## 2, in ## 2);
=20
-#define qop(in, out, x, f) \
-	F ## f(in ## 1, x);          \
-	vpxor out ## 1, x, out ## 1; \
-	F ## f(in ## 2, x);          \
-	vpxor out ## 2, x, out ## 2; \
+#define get_round_keys(nn) \
+	vbroadcastss	(km+(4*(nn)))(CTX), RKM;        \
+	vpand		R1ST,               RKR,  RKRF; \
+	vpsubq		RKRF,               R32,  RKRR; \
+	vpsrldq $1,	RKR,                RKR;
=20
 #define Q(n) \
-	vbroadcastss	(km+(4*(4*n+0)))(CTX), RKM;        \
-	vpinsrb $0,	(kr+(4*n+0))(CTX),     RKRF, RKRF; \
-	vpsubq		RKRF,                  R32,  RKRR; \
-	qop(RD, RC, RX, 1);                                \
+	get_round_keys(4*n+0); \
+	qop(RD, RC, 1);        \
 	\
-	vbroadcastss	(km+(4*(4*n+1)))(CTX), RKM;        \
-	vpinsrb $0,	(kr+(4*n+1))(CTX),     RKRF, RKRF; \
-	vpsubq		RKRF,                  R32,  RKRR; \
-	qop(RC, RB, RX, 2);                                \
+	get_round_keys(4*n+1); \
+	qop(RC, RB, 2);        \
 	\
-	vbroadcastss	(km+(4*(4*n+2)))(CTX), RKM;        \
-	vpinsrb $0,	(kr+(4*n+2))(CTX),     RKRF, RKRF; \
-	vpsubq		RKRF,                  R32,  RKRR; \
-	qop(RB, RA, RX, 3);                                \
+	get_round_keys(4*n+2); \
+	qop(RB, RA, 3);        \
 	\
-	vbroadcastss	(km+(4*(4*n+3)))(CTX), RKM;        \
-	vpinsrb $0,	(kr+(4*n+3))(CTX),     RKRF, RKRF; \
-	vpsubq		RKRF,                  R32,  RKRR; \
-	qop(RA, RD, RX, 1);
+	get_round_keys(4*n+3); \
+	qop(RA, RD, 1);
=20
 #define QBAR(n) \
-	vbroadcastss	(km+(4*(4*n+3)))(CTX), RKM;        \
-	vpinsrb $0,	(kr+(4*n+3))(CTX),     RKRF, RKRF; \
-	vpsubq		RKRF,                  R32,  RKRR; \
-	qop(RA, RD, RX, 1);                                \
+	get_round_keys(4*n+3); \
+	qop(RA, RD, 1);        \
 	\
-	vbroadcastss	(km+(4*(4*n+2)))(CTX), RKM;        \
-	vpinsrb $0,	(kr+(4*n+2))(CTX),     RKRF, RKRF; \
-	vpsubq		RKRF,                  R32,  RKRR; \
-	qop(RB, RA, RX, 3);                                \
+	get_round_keys(4*n+2); \
+	qop(RB, RA, 3);        \
 	\
-	vbroadcastss	(km+(4*(4*n+1)))(CTX), RKM;        \
-	vpinsrb $0,	(kr+(4*n+1))(CTX),     RKRF, RKRF; \
-	vpsubq		RKRF,                  R32,  RKRR; \
-	qop(RC, RB, RX, 2);                                \
+	get_round_keys(4*n+1); \
+	qop(RC, RB, 2);        \
 	\
-	vbroadcastss	(km+(4*(4*n+0)))(CTX), RKM;        \
-	vpinsrb $0,	(kr+(4*n+0))(CTX),     RKRF, RKRF; \
-	vpsubq		RKRF,                  R32,  RKRR; \
-	qop(RD, RC, RX, 1);
+	get_round_keys(4*n+0); \
+	qop(RD, RC, 1);
=20
+#define shuffle(mask) \
+	vpshufb		mask,            RKR, RKR;
+
+#define preload_rkr(n, do_mask, mask) \
+	vbroadcastss	.L16_mask,                RKR;      \
+	/* add 16-bit rotation to key rotations (mod 32) */ \
+	vpxor		(kr+n*16)(CTX),           RKR, RKR; \
+	do_mask(mask);
=20
 #define transpose_4x4(x0, x1, x2, x3, t0, t1, t2) \
 	vpunpckldq		x1, x0, t0; \
@@ -185,37 +205,37 @@
 	vpunpcklqdq		x3, t2, x2; \
 	vpunpckhqdq		x3, t2, x3;
=20
-#define inpack_blocks(in, x0, x1, x2, x3, t0, t1, t2) \
+#define inpack_blocks(in, x0, x1, x2, x3, t0, t1, t2, rmask) \
 	vmovdqu (0*4*4)(in),	x0; \
 	vmovdqu (1*4*4)(in),	x1; \
 	vmovdqu (2*4*4)(in),	x2; \
 	vmovdqu (3*4*4)(in),	x3; \
-	vpshufb RMASK, x0,	x0; \
-	vpshufb RMASK, x1,	x1; \
-	vpshufb RMASK, x2,	x2; \
-	vpshufb RMASK, x3,	x3; \
+	vpshufb rmask, x0,	x0; \
+	vpshufb rmask, x1,	x1; \
+	vpshufb rmask, x2,	x2; \
+	vpshufb rmask, x3,	x3; \
 	\
 	transpose_4x4(x0, x1, x2, x3, t0, t1, t2)
=20
-#define outunpack_blocks(out, x0, x1, x2, x3, t0, t1, t2) \
+#define outunpack_blocks(out, x0, x1, x2, x3, t0, t1, t2, rmask) \
 	transpose_4x4(x0, x1, x2, x3, t0, t1, t2) \
 	\
-	vpshufb RMASK,		x0, x0;       \
-	vpshufb RMASK,		x1, x1;       \
-	vpshufb RMASK,		x2, x2;       \
-	vpshufb RMASK,		x3, x3;       \
+	vpshufb rmask,		x0, x0;       \
+	vpshufb rmask,		x1, x1;       \
+	vpshufb rmask,		x2, x2;       \
+	vpshufb rmask,		x3, x3;       \
 	vmovdqu x0,		(0*4*4)(out); \
 	vmovdqu	x1,		(1*4*4)(out); \
 	vmovdqu	x2,		(2*4*4)(out); \
 	vmovdqu	x3,		(3*4*4)(out);
=20
-#define outunpack_xor_blocks(out, x0, x1, x2, x3, t0, t1, t2) \
+#define outunpack_xor_blocks(out, x0, x1, x2, x3, t0, t1, t2, rmask) \
 	transpose_4x4(x0, x1, x2, x3, t0, t1, t2) \
 	\
-	vpshufb RMASK,		x0, x0;       \
-	vpshufb RMASK,		x1, x1;       \
-	vpshufb RMASK,		x2, x2;       \
-	vpshufb RMASK,		x3, x3;       \
+	vpshufb rmask,		x0, x0;       \
+	vpshufb rmask,		x1, x1;       \
+	vpshufb rmask,		x2, x2;       \
+	vpshufb rmask,		x3, x3;       \
 	vpxor (0*4*4)(out),	x0, x0;       \
 	vmovdqu	x0,		(0*4*4)(out); \
 	vpxor (1*4*4)(out),	x1, x1;       \
@@ -225,11 +245,29 @@
 	vpxor (3*4*4)(out),	x3, x3;       \
 	vmovdqu x3,		(3*4*4)(out);
=20
+.data
+
 .align 16
 .Lbswap_mask:
 	.byte 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12
+.Lrkr_enc_Q_Q_QBAR_QBAR:
+	.byte 0, 1, 2, 3, 4, 5, 6, 7, 11, 10, 9, 8, 15, 14, 13, 12
+.Lrkr_enc_QBAR_QBAR_QBAR_QBAR:
+	.byte 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12
+.Lrkr_dec_Q_Q_Q_Q:
+	.byte 12, 13, 14, 15, 8, 9, 10, 11, 4, 5, 6, 7, 0, 1, 2, 3
+.Lrkr_dec_Q_Q_QBAR_QBAR:
+	.byte 12, 13, 14, 15, 8, 9, 10, 11, 7, 6, 5, 4, 3, 2, 1, 0
+.Lrkr_dec_QBAR_QBAR_QBAR_QBAR:
+	.byte 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0
+.L16_mask:
+	.byte 16, 16, 16, 16
 .L32_mask:
-	.byte 32, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 0
+	.byte 32, 0, 0, 0
+.Lfirst_mask:
+	.byte 0x1f, 0, 0, 0
+
+.text
=20
 .align 16
 .global __cast6_enc_blk_8way
@@ -243,28 +281,31 @@ __cast6_enc_blk_8way:
 	 *	%rcx: bool, if true: xor output
 	 */
=20
+	pushq %rbp;
 	pushq %rbx;
 	pushq %rcx;
=20
-	vmovdqu .Lbswap_mask, RMASK;
-	vmovdqu .L32_mask, R32;
-	vpxor RKRF, RKRF, RKRF;
+	vmovdqa .Lbswap_mask, RKM;
+	vmovd .Lfirst_mask, R1ST;
+	vmovd .L32_mask, R32;
=20
 	leaq (4*4*4)(%rdx), %rax;
-	inpack_blocks(%rdx, RA1, RB1, RC1, RD1, RTMP, RX, RKM);
-	inpack_blocks(%rax, RA2, RB2, RC2, RD2, RTMP, RX, RKM);
+	inpack_blocks(%rdx, RA1, RB1, RC1, RD1, RTMP, RX, RKRF, RKM);
+	inpack_blocks(%rax, RA2, RB2, RC2, RD2, RTMP, RX, RKRF, RKM);
=20
-	xorq RID1, RID1;
-	xorq RID2, RID2;
+	movq %rsi, %r11;
=20
+	preload_rkr(0, dummy, none);
 	Q(0);
 	Q(1);
 	Q(2);
 	Q(3);
+	preload_rkr(1, shuffle, .Lrkr_enc_Q_Q_QBAR_QBAR);
 	Q(4);
 	Q(5);
 	QBAR(6);
 	QBAR(7);
+	preload_rkr(2, shuffle, .Lrkr_enc_QBAR_QBAR_QBAR_QBAR);
 	QBAR(8);
 	QBAR(9);
 	QBAR(10);
@@ -272,20 +313,22 @@ __cast6_enc_blk_8way:
=20
 	popq %rcx;
 	popq %rbx;
+	popq %rbp;
=20
-	leaq (4*4*4)(%rsi), %rax;
+	vmovdqa .Lbswap_mask, RKM;
+	leaq (4*4*4)(%r11), %rax;
=20
 	testb %cl, %cl;
 	jnz __enc_xor8;
=20
-	outunpack_blocks(%rsi, RA1, RB1, RC1, RD1, RTMP, RX, RKM);
-	outunpack_blocks(%rax, RA2, RB2, RC2, RD2, RTMP, RX, RKM);
+	outunpack_blocks(%r11, RA1, RB1, RC1, RD1, RTMP, RX, RKRF, RKM);
+	outunpack_blocks(%rax, RA2, RB2, RC2, RD2, RTMP, RX, RKRF, RKM);
=20
 	ret;
=20
 __enc_xor8:
-	outunpack_xor_blocks(%rsi, RA1, RB1, RC1, RD1, RTMP, RX, RKM);
-	outunpack_xor_blocks(%rax, RA2, RB2, RC2, RD2, RTMP, RX, RKM);
+	outunpack_xor_blocks(%r11, RA1, RB1, RC1, RD1, RTMP, RX, RKRF, RKM);
+	outunpack_xor_blocks(%rax, RA2, RB2, RC2, RD2, RTMP, RX, RKRF, RKM);
=20
 	ret;
=20
@@ -300,36 +343,42 @@ cast6_dec_blk_8way:
 	 *	%rdx: src
 	 */
=20
+	pushq %rbp;
 	pushq %rbx;
=20
-	vmovdqu .Lbswap_mask, RMASK;
-	vmovdqu .L32_mask, R32;
-	vpxor RKRF, RKRF, RKRF;
+	vmovdqa .Lbswap_mask, RKM;
+	vmovd .Lfirst_mask, R1ST;
+	vmovd .L32_mask, R32;
=20
 	leaq (4*4*4)(%rdx), %rax;
-	inpack_blocks(%rdx, RA1, RB1, RC1, RD1, RTMP, RX, RKM);
-	inpack_blocks(%rax, RA2, RB2, RC2, RD2, RTMP, RX, RKM);
+	inpack_blocks(%rdx, RA1, RB1, RC1, RD1, RTMP, RX, RKRF, RKM);
+	inpack_blocks(%rax, RA2, RB2, RC2, RD2, RTMP, RX, RKRF, RKM);
=20
-	xorq RID1, RID1;
-	xorq RID2, RID2;
+	movq %rsi, %r11;
=20
+	preload_rkr(2, shuffle, .Lrkr_dec_Q_Q_Q_Q);
 	Q(11);
 	Q(10);
 	Q(9);
 	Q(8);
+	preload_rkr(1, shuffle, .Lrkr_dec_Q_Q_QBAR_QBAR);
 	Q(7);
 	Q(6);
 	QBAR(5);
 	QBAR(4);
+	preload_rkr(0, shuffle, .Lrkr_dec_QBAR_QBAR_QBAR_QBAR);
 	QBAR(3);
 	QBAR(2);
 	QBAR(1);
 	QBAR(0);
=20
 	popq %rbx;
+	popq %rbp;
=20
-	leaq (4*4*4)(%rsi), %rax;
-	outunpack_blocks(%rsi, RA1, RB1, RC1, RD1, RTMP, RX, RKM);
-	outunpack_blocks(%rax, RA2, RB2, RC2, RD2, RTMP, RX, RKM);
+	vmovdqa .Lbswap_mask, RKM;
+	leaq (4*4*4)(%r11), %rax;
+	outunpack_blocks(%r11, RA1, RB1, RC1, RD1, RTMP, RX, RKRF, RKM);
+	outunpack_blocks(%rax, RA2, RB2, RC2, RD2, RTMP, RX, RKRF, RKM);
=20
 	ret;
+
