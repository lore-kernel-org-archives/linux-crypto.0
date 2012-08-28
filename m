From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 2/3] crypto: cast5-avx - tune assembler code for more
 performance
Date: Tue, 28 Aug 2012 14:24:49 +0300
Message-ID: <20120828112449.22504.71799.stgit@localhost6.localdomain6>
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
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:58680 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab2H1LYy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 Aug 2012 07:24:54 -0400
In-Reply-To: <20120828112443.22504.68633.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Patch replaces 'movb' instructions with 'movzbl' to break false registe=
r
dependencies, interleaves instructions better for out-of-order scheduli=
ng
and merges constant 16-bit rotation with round-key variable rotation.

tcrypt ECB results (128bit key):

Intel Core i5-2450M:

size    old-vs-new      new-vs-generic  old-vs-generic
        enc     dec     enc     dec     enc     dec
256     1.18x   1.18x   2.45x   2.47x   2.08x   2.10x
1k      1.20x   1.20x   2.73x   2.73x   2.28x   2.28x
8k      1.20x   1.19x   2.73x   2.73x   2.28x   2.29x

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
 arch/x86/crypto/cast5-avx-x86_64-asm_64.S |  266 +++++++++++++++++----=
--------
 1 file changed, 160 insertions(+), 106 deletions(-)

diff --git a/arch/x86/crypto/cast5-avx-x86_64-asm_64.S b/arch/x86/crypt=
o/cast5-avx-x86_64-asm_64.S
index 94693c8..a41a3aa 100644
--- a/arch/x86/crypto/cast5-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/cast5-avx-x86_64-asm_64.S
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
 .file "cast5-avx-x86_64-asm_64.S"
-.text
=20
 .extern cast5_s1
 .extern cast5_s2
@@ -57,17 +58,19 @@
 #define RX %xmm8
=20
 #define RKM  %xmm9
-#define RKRF %xmm10
-#define RKRR %xmm11
+#define RKR  %xmm10
+#define RKRF %xmm11
+#define RKRR %xmm12
+
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
@@ -76,6 +79,13 @@
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
@@ -84,60 +94,84 @@
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
=20
-#define subround(a, b, x, n, f) \
-	F ## f(b, x);  \
-	vpxor a, x, a;
+#define subround(a1, b1, a2, b2, f) \
+	F ## f ## _2(a1, b1, a2, b2);
=20
 #define round(l, r, n, f) \
 	vbroadcastss 	(km+(4*n))(CTX), RKM;        \
-	vpinsrb $0,	(kr+n)(CTX),     RKRF, RKRF; \
+	vpand		R1ST,            RKR,  RKRF; \
 	vpsubq		RKRF,            R32,  RKRR; \
-	subround(l ## 1, r ## 1, RX, n, f);          \
-	subround(l ## 2, r ## 2, RX, n, f);          \
-	subround(l ## 3, r ## 3, RX, n, f);          \
-	subround(l ## 4, r ## 4, RX, n, f);
+	vpsrldq $1,	RKR,             RKR;        \
+	subround(l ## 1, r ## 1, l ## 2, r ## 2, f); \
+	subround(l ## 3, r ## 3, l ## 4, r ## 4, f);
+
+#define enc_preload_rkr() \
+	vbroadcastss	.L16_mask,                RKR;      \
+	/* add 16-bit rotation to key rotations (mod 32) */ \
+	vpxor		kr(CTX),                  RKR, RKR;
=20
+#define dec_preload_rkr() \
+	vbroadcastss	.L16_mask,                RKR;      \
+	/* add 16-bit rotation to key rotations (mod 32) */ \
+	vpxor		kr(CTX),                  RKR, RKR; \
+	vpshufb		.Lbswap128_mask,          RKR, RKR;
=20
 #define transpose_2x4(x0, x1, t0, t1) \
 	vpunpckldq		x1, x0, t0; \
@@ -146,37 +180,47 @@
 	vpunpcklqdq		t1, t0, x0; \
 	vpunpckhqdq		t1, t0, x1;
=20
-#define inpack_blocks(in, x0, x1, t0, t1) \
+#define inpack_blocks(in, x0, x1, t0, t1, rmask) \
 	vmovdqu (0*4*4)(in),	x0; \
 	vmovdqu (1*4*4)(in),	x1; \
-	vpshufb RMASK, x0,	x0; \
-	vpshufb RMASK, x1,	x1; \
+	vpshufb rmask, 	x0,	x0; \
+	vpshufb rmask, 	x1,	x1; \
 	\
 	transpose_2x4(x0, x1, t0, t1)
=20
-#define outunpack_blocks(out, x0, x1, t0, t1) \
+#define outunpack_blocks(out, x0, x1, t0, t1, rmask) \
 	transpose_2x4(x0, x1, t0, t1) \
 	\
-	vpshufb RMASK,	x0, x0;           \
-	vpshufb RMASK,	x1, x1;           \
+	vpshufb rmask,	x0, x0;           \
+	vpshufb rmask,	x1, x1;           \
 	vmovdqu 	x0, (0*4*4)(out); \
 	vmovdqu		x1, (1*4*4)(out);
=20
-#define outunpack_xor_blocks(out, x0, x1, t0, t1) \
+#define outunpack_xor_blocks(out, x0, x1, t0, t1, rmask) \
 	transpose_2x4(x0, x1, t0, t1) \
 	\
-	vpshufb RMASK,	x0, x0;               \
-	vpshufb RMASK,	x1, x1;               \
+	vpshufb rmask,	x0, x0;               \
+	vpshufb rmask,	x1, x1;               \
 	vpxor		(0*4*4)(out), x0, x0; \
 	vmovdqu 	x0, (0*4*4)(out);     \
 	vpxor		(1*4*4)(out), x1, x1; \
 	vmovdqu	        x1, (1*4*4)(out);
=20
+.data
+
 .align 16
 .Lbswap_mask:
 	.byte 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12
+.Lbswap128_mask:
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
 .global __cast5_enc_blk_16way
@@ -190,23 +234,24 @@ __cast5_enc_blk_16way:
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
+	enc_preload_rkr();
=20
-	inpack_blocks(%rdx, RL1, RR1, RTMP, RX);
-	leaq (2*4*4)(%rdx), %rax;
-	inpack_blocks(%rax, RL2, RR2, RTMP, RX);
-	leaq (2*4*4)(%rax), %rax;
-	inpack_blocks(%rax, RL3, RR3, RTMP, RX);
-	leaq (2*4*4)(%rax), %rax;
-	inpack_blocks(%rax, RL4, RR4, RTMP, RX);
+	leaq 1*(2*4*4)(%rdx), %rax;
+	inpack_blocks(%rdx, RL1, RR1, RTMP, RX, RKM);
+	inpack_blocks(%rax, RL2, RR2, RTMP, RX, RKM);
+	leaq 2*(2*4*4)(%rdx), %rax;
+	inpack_blocks(%rax, RL3, RR3, RTMP, RX, RKM);
+	leaq 3*(2*4*4)(%rdx), %rax;
+	inpack_blocks(%rax, RL4, RR4, RTMP, RX, RKM);
=20
-	xorq RID1, RID1;
-	xorq RID2, RID2;
+	movq %rsi, %r11;
=20
 	round(RL, RR, 0, 1);
 	round(RR, RL, 1, 2);
@@ -221,8 +266,8 @@ __cast5_enc_blk_16way:
 	round(RL, RR, 10, 2);
 	round(RR, RL, 11, 3);
=20
-	movb rr(CTX), %al;
-	testb %al, %al;
+	movzbl rr(CTX), %eax;
+	testl %eax, %eax;
 	jnz __skip_enc;
=20
 	round(RL, RR, 12, 1);
@@ -233,28 +278,30 @@ __cast5_enc_blk_16way:
 __skip_enc:
 	popq %rcx;
 	popq %rbx;
+	popq %rbp;
+
+	vmovdqa .Lbswap_mask, RKM;
+	leaq 1*(2*4*4)(%r11), %rax;
=20
 	testb %cl, %cl;
 	jnz __enc_xor16;
=20
-	outunpack_blocks(%rsi, RR1, RL1, RTMP, RX);
-	leaq (2*4*4)(%rsi), %rax;
-	outunpack_blocks(%rax, RR2, RL2, RTMP, RX);
-	leaq (2*4*4)(%rax), %rax;
-	outunpack_blocks(%rax, RR3, RL3, RTMP, RX);
-	leaq (2*4*4)(%rax), %rax;
-	outunpack_blocks(%rax, RR4, RL4, RTMP, RX);
+	outunpack_blocks(%r11, RR1, RL1, RTMP, RX, RKM);
+	outunpack_blocks(%rax, RR2, RL2, RTMP, RX, RKM);
+	leaq 2*(2*4*4)(%r11), %rax;
+	outunpack_blocks(%rax, RR3, RL3, RTMP, RX, RKM);
+	leaq 3*(2*4*4)(%r11), %rax;
+	outunpack_blocks(%rax, RR4, RL4, RTMP, RX, RKM);
=20
 	ret;
=20
 __enc_xor16:
-	outunpack_xor_blocks(%rsi, RR1, RL1, RTMP, RX);
-	leaq (2*4*4)(%rsi), %rax;
-	outunpack_xor_blocks(%rax, RR2, RL2, RTMP, RX);
-	leaq (2*4*4)(%rax), %rax;
-	outunpack_xor_blocks(%rax, RR3, RL3, RTMP, RX);
-	leaq (2*4*4)(%rax), %rax;
-	outunpack_xor_blocks(%rax, RR4, RL4, RTMP, RX);
+	outunpack_xor_blocks(%r11, RR1, RL1, RTMP, RX, RKM);
+	outunpack_xor_blocks(%rax, RR2, RL2, RTMP, RX, RKM);
+	leaq 2*(2*4*4)(%r11), %rax;
+	outunpack_xor_blocks(%rax, RR3, RL3, RTMP, RX, RKM);
+	leaq 3*(2*4*4)(%r11), %rax;
+	outunpack_xor_blocks(%rax, RR4, RL4, RTMP, RX, RKM);
=20
 	ret;
=20
@@ -269,25 +316,26 @@ cast5_dec_blk_16way:
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
+	dec_preload_rkr();
=20
-	inpack_blocks(%rdx, RL1, RR1, RTMP, RX);
-	leaq (2*4*4)(%rdx), %rax;
-	inpack_blocks(%rax, RL2, RR2, RTMP, RX);
-	leaq (2*4*4)(%rax), %rax;
-	inpack_blocks(%rax, RL3, RR3, RTMP, RX);
-	leaq (2*4*4)(%rax), %rax;
-	inpack_blocks(%rax, RL4, RR4, RTMP, RX);
+	leaq 1*(2*4*4)(%rdx), %rax;
+	inpack_blocks(%rdx, RL1, RR1, RTMP, RX, RKM);
+	inpack_blocks(%rax, RL2, RR2, RTMP, RX, RKM);
+	leaq 2*(2*4*4)(%rdx), %rax;
+	inpack_blocks(%rax, RL3, RR3, RTMP, RX, RKM);
+	leaq 3*(2*4*4)(%rdx), %rax;
+	inpack_blocks(%rax, RL4, RR4, RTMP, RX, RKM);
=20
-	xorq RID1, RID1;
-	xorq RID2, RID2;
+	movq %rsi, %r11;
=20
-	movb rr(CTX), %al;
-	testb %al, %al;
+	movzbl rr(CTX), %eax;
+	testl %eax, %eax;
 	jnz __skip_dec;
=20
 	round(RL, RR, 15, 1);
@@ -295,7 +343,7 @@ cast5_dec_blk_16way:
 	round(RL, RR, 13, 2);
 	round(RR, RL, 12, 1);
=20
-__skip_dec:
+__dec_tail:
 	round(RL, RR, 11, 3);
 	round(RR, RL, 10, 2);
 	round(RL, RR, 9, 1);
@@ -309,14 +357,20 @@ __skip_dec:
 	round(RL, RR, 1, 2);
 	round(RR, RL, 0, 1);
=20
+	vmovdqa .Lbswap_mask, RKM;
 	popq %rbx;
+	popq %rbp;
=20
-	outunpack_blocks(%rsi, RR1, RL1, RTMP, RX);
-	leaq (2*4*4)(%rsi), %rax;
-	outunpack_blocks(%rax, RR2, RL2, RTMP, RX);
-	leaq (2*4*4)(%rax), %rax;
-	outunpack_blocks(%rax, RR3, RL3, RTMP, RX);
-	leaq (2*4*4)(%rax), %rax;
-	outunpack_blocks(%rax, RR4, RL4, RTMP, RX);
+	leaq 1*(2*4*4)(%r11), %rax;
+	outunpack_blocks(%r11, RR1, RL1, RTMP, RX, RKM);
+	outunpack_blocks(%rax, RR2, RL2, RTMP, RX, RKM);
+	leaq 2*(2*4*4)(%r11), %rax;
+	outunpack_blocks(%rax, RR3, RL3, RTMP, RX, RKM);
+	leaq 3*(2*4*4)(%r11), %rax;
+	outunpack_blocks(%rax, RR4, RL4, RTMP, RX, RKM);
=20
 	ret;
+
+__skip_dec:
+	vpsrldq $4, RKR, RKR;
+	jmp __dec_tail;
