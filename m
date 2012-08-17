From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: Re: [PATCH] crypto: twofish - add x86_64/avx assembler implementation
Date: Fri, 17 Aug 2012 10:37:10 +0300
Message-ID: <20120817073048.16720.80328.stgit@localhost6.localdomain6>
References: <20120816132926.GB12029@x1.osrc.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Johannes Goetzfried
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Tilo =?utf-8?q?M=C3=BCller?=
	<tilo.mueller@informatik.uni-erlangen.de>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Borislav Petkov <bp@alien8.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:41034 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964805Ab2HQHhR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Aug 2012 03:37:17 -0400
In-Reply-To: <20120816132926.GB12029@x1.osrc.amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Quoting Borislav Petkov <bp@alien8.de>:

>
> Yep, looks better than the previous run and also a bit better or on p=
ar
> with the initial run I did.
>

I made few further changes, mainly moving/interleaving 'vmovq/vpextrq' =
ahead
so they should be completed before those target registers are needed. T=
his
only gave 0.5% increase on Sandy-bridge, but might help more on Bulldoz=
er.

-Jussi

---
 arch/x86/crypto/twofish-avx-x86_64-asm_64.S |  205 +++++++++++++++++--=
--------
 1 file changed, 130 insertions(+), 75 deletions(-)

diff --git a/arch/x86/crypto/twofish-avx-x86_64-asm_64.S b/arch/x86/cry=
pto/twofish-avx-x86_64-asm_64.S
index 35f4557..6638a87 100644
--- a/arch/x86/crypto/twofish-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/twofish-avx-x86_64-asm_64.S
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
@@ -47,16 +49,21 @@
 #define RC2 %xmm6
 #define RD2 %xmm7
=20
-#define RX %xmm8
-#define RY %xmm9
+#define RX0 %xmm8
+#define RY0 %xmm9
+
+#define RX1 %xmm10
+#define RY1 %xmm11
=20
-#define RK1 %xmm10
-#define RK2 %xmm11
+#define RK1 %xmm12
+#define RK2 %xmm13
=20
-#define RID1  %rax
-#define RID1b %al
-#define RID2  %rbx
-#define RID2b %bl
+#define RT %xmm14
+
+#define RID1  %rbp
+#define RID1d %ebp
+#define RID2  %rsi
+#define RID2d %esi
=20
 #define RGI1   %rdx
 #define RGI1bl %dl
@@ -65,6 +72,13 @@
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
 #define RGS1  %r8
 #define RGS1d %r8d
 #define RGS2  %r9
@@ -73,40 +87,53 @@
 #define RGS3d %r10d
=20
=20
-#define lookup_32bit(t0, t1, t2, t3, src, dst) \
-	movb		src ## bl,        RID1b;     \
-	movb		src ## bh,        RID2b;     \
+#define lookup_32bit(t0, t1, t2, t3, src, dst, interleave_op, il_reg) =
\
+	movzbl		src ## bl,        RID1d;     \
+	movzbl		src ## bh,        RID2d;     \
+	shrq $16,	src;                         \
 	movl		t0(CTX, RID1, 4), dst ## d;  \
 	xorl		t1(CTX, RID2, 4), dst ## d;  \
-	shrq $16,	src;                         \
-	movb		src ## bl,        RID1b;     \
-	movb		src ## bh,        RID2b;     \
+	movzbl		src ## bl,        RID1d;     \
+	movzbl		src ## bh,        RID2d;     \
+	interleave_op(il_reg);			     \
 	xorl		t2(CTX, RID1, 4), dst ## d;  \
 	xorl		t3(CTX, RID2, 4), dst ## d;
=20
-#define G(a, x, t0, t1, t2, t3) \
-	vmovq		a,    RGI1;               \
-	vpsrldq $8,	a,    x;                  \
-	vmovq		x,    RGI2;               \
-	\
-	lookup_32bit(t0, t1, t2, t3, RGI1, RGS1); \
-	shrq $16,	RGI1;                     \
-	lookup_32bit(t0, t1, t2, t3, RGI1, RGS2); \
-	shlq $32,	RGS2;                     \
-	orq		RGS1, RGS2;               \
+#define dummy(d) /* do nothing */
+
+#define shr_next(reg) \
+	shrq $16,	reg;
+
+#define G(gi1, gi2, x, t0, t1, t2, t3) \
+	lookup_32bit(t0, t1, t2, t3, ##gi1, RGS1, shr_next, ##gi1);  \
+	lookup_32bit(t0, t1, t2, t3, ##gi1, RGS2, dummy, none);      \
+	shlq $32,	RGS2;                                        \
+	orq		RGS1, RGS2;                                  \
 	\
-	lookup_32bit(t0, t1, t2, t3, RGI2, RGS1); \
-	shrq $16,	RGI2;                     \
-	lookup_32bit(t0, t1, t2, t3, RGI2, RGS3); \
-	shlq $32,	RGS3;                     \
-	orq		RGS1, RGS3;               \
+	lookup_32bit(t0, t1, t2, t3, ##gi2, RGS3, shr_next, ##gi2);  \
+	lookup_32bit(t0, t1, t2, t3, ##gi2, RGS1, dummy, none);      \
+	shlq $32,	RGS1;                                        \
+	orq		RGS1, RGS3;                                  \
 	\
-	vmovq		RGS2, x;                  \
+	vmovq		RGS2, x;                                     \
 	vpinsrq $1,	RGS3, x, x;
=20
-#define encround(a, b, c, d, x, y) \
-	G(a, x, s0, s1, s2, s3);           \
-	G(b, y, s1, s2, s3, s0);           \
+#define encround_head_2(a, b, c, d, x1, y1, x2, y2) \
+	vmovq			b ## 1, RGI3;	\
+	vpextrq $1,		b ## 1, RGI4;   \
+	G(RGI1, RGI2, x1, s0, s1, s2, s3);      \
+	vmovq			a ## 2, RGI1;   \
+	vpextrq $1,		a ## 2, RGI2;   \
+	G(RGI3, RGI4, y1, s1, s2, s3, s0);      \
+	vmovq			b ## 2, RGI3;   \
+	vpextrq $1,		b ## 2, RGI4;   \
+	G(RGI1, RGI2, x2, s0, s1, s2, s3);      \
+	G(RGI3, RGI4, y2, s1, s2, s3, s0);
+
+#define encround_tail(a, b, c, d, x, y) \
+	vpslld $1,		d, RT;     \
+	vpsrld $(32 - 1),	d, d;      \
+	vpor			d, RT,  d; \
 	vpaddd			x, y,   x; \
 	vpaddd			y, x,   y; \
 	vpaddd			x, RK1, x; \
@@ -115,14 +142,24 @@
 	vpsrld $1,		c, x;      \
 	vpslld $(32 - 1),	c, c;      \
 	vpor			c, x,   c; \
-	vpslld $1,		d, x;      \
-	vpsrld $(32 - 1),	d, d;      \
-	vpor			d, x,   d; \
 	vpxor			d, y,   d;
=20
-#define decround(a, b, c, d, x, y) \
-	G(a, x, s0, s1, s2, s3);           \
-	G(b, y, s1, s2, s3, s0);           \
+#define decround_head_2(a, b, c, d, x1, y1, x2, y2) \
+	vmovq			b ## 1, RGI3;   \
+	vpextrq $1,		b ## 1, RGI4;   \
+	G(RGI1, RGI2, x1, s0, s1, s2, s3);      \
+	vmovq			a ## 2, RGI1;   \
+	vpextrq $1,		a ## 2, RGI2;   \
+	G(RGI3, RGI4, y1, s1, s2, s3, s0);      \
+	vmovq			b ## 2, RGI3;   \
+	vpextrq $1,		b ## 2, RGI4;   \
+	G(RGI1, RGI2, x2, s0, s1, s2, s3);      \
+	G(RGI3, RGI4, y2, s1, s2, s3, s0);
+
+#define decround_tail(a, b, c, d, x, y) \
+	vpslld $1,		c, RT;     \
+	vpsrld $(32 - 1),	c, c;      \
+	vpor			c, RT,  c; \
 	vpaddd			x, y,   x; \
 	vpaddd			y, x,   y; \
 	vpaddd			y, RK2, y; \
@@ -130,32 +167,44 @@
 	vpsrld $1,		d, y;      \
 	vpslld $(32 - 1),	d, d;      \
 	vpor			d, y,   d; \
-	vpslld $1,		c, y;      \
-	vpsrld $(32 - 1),	c, c;      \
-	vpor			c, y,   c; \
 	vpaddd			x, RK1, x; \
 	vpxor			x, c,   c;
=20
-#define encrypt_round(n, a, b, c, d) \
-	vbroadcastss (k+4*(2*(n)))(CTX),   RK1;           \
-	vbroadcastss (k+4*(2*(n)+1))(CTX), RK2;           \
-	encround(a ## 1, b ## 1, c ## 1, d ## 1, RX, RY); \
-	encround(a ## 2, b ## 2, c ## 2, d ## 2, RX, RY);
-
-#define decrypt_round(n, a, b, c, d) \
-	vbroadcastss (k+4*(2*(n)))(CTX),   RK1;           \
-	vbroadcastss (k+4*(2*(n)+1))(CTX), RK2;           \
-	decround(a ## 1, b ## 1, c ## 1, d ## 1, RX, RY); \
-	decround(a ## 2, b ## 2, c ## 2, d ## 2, RX, RY);
+#define preload_rgi(c) \
+	vmovq			c, RGI1; \
+	vpextrq $1,		c, RGI2;
+
+#define encrypt_round(n, a, b, c, d, preload) \
+	vbroadcastss (k+4*(2*(n)))(CTX),   RK1;                  \
+	vbroadcastss (k+4*(2*(n)+1))(CTX), RK2;                  \
+	encround_head_2(a, b, c, d, RX0, RY0, RX1, RY1);         \
+	encround_tail(a ## 1, b ## 1, c ## 1, d ## 1, RX0, RY0); \
+	preload(c ## 1);                                         \
+	encround_tail(a ## 2, b ## 2, c ## 2, d ## 2, RX1, RY1);
+
+#define decrypt_round(n, a, b, c, d, preload) \
+	vbroadcastss (k+4*(2*(n)))(CTX),   RK1;                  \
+	vbroadcastss (k+4*(2*(n)+1))(CTX), RK2;                  \
+	decround_head_2(a, b, c, d, RX0, RY0, RX1, RY1);         \
+	decround_tail(a ## 1, b ## 1, c ## 1, d ## 1, RX0, RY0); \
+	preload(c ## 1);                                         \
+	decround_tail(a ## 2, b ## 2, c ## 2, d ## 2, RX1, RY1);
=20
 #define encrypt_cycle(n) \
-	encrypt_round((2*n), RA, RB, RC, RD);       \
-	encrypt_round(((2*n) + 1), RC, RD, RA, RB);
+	encrypt_round((2*n), RA, RB, RC, RD, preload_rgi); \
+	encrypt_round(((2*n) + 1), RC, RD, RA, RB, preload_rgi);
+
+#define encrypt_cycle_last(n) \
+	encrypt_round((2*n), RA, RB, RC, RD, preload_rgi); \
+	encrypt_round(((2*n) + 1), RC, RD, RA, RB, dummy);
=20
 #define decrypt_cycle(n) \
-	decrypt_round(((2*n) + 1), RC, RD, RA, RB); \
-	decrypt_round((2*n), RA, RB, RC, RD);
+	decrypt_round(((2*n) + 1), RC, RD, RA, RB, preload_rgi); \
+	decrypt_round((2*n), RA, RB, RC, RD, preload_rgi);
=20
+#define decrypt_cycle_last(n) \
+	decrypt_round(((2*n) + 1), RC, RD, RA, RB, preload_rgi); \
+	decrypt_round((2*n), RA, RB, RC, RD, dummy);
=20
 #define transpose_4x4(x0, x1, x2, x3, t0, t1, t2) \
 	vpunpckldq		x1, x0, t0; \
@@ -216,17 +265,19 @@ __twofish_enc_blk_8way:
 	 *	%rcx: bool, if true: xor output
 	 */
=20
+	pushq %rbp;
 	pushq %rbx;
 	pushq %rcx;
=20
 	vmovdqu w(CTX), RK1;
=20
 	leaq (4*4*4)(%rdx), %rax;
-	inpack_blocks(%rdx, RA1, RB1, RC1, RD1, RK1, RX, RY, RK2);
-	inpack_blocks(%rax, RA2, RB2, RC2, RD2, RK1, RX, RY, RK2);
+	inpack_blocks(%rdx, RA1, RB1, RC1, RD1, RK1, RX0, RY0, RK2);
+	vmovq		RA1, RGI1;
+	vpextrq $1,	RA1, RGI2;
+	inpack_blocks(%rax, RA2, RB2, RC2, RD2, RK1, RX0, RY0, RK2);
=20
-	xorq RID1, RID1;
-	xorq RID2, RID2;
+	movq %rsi, %r11;
=20
 	encrypt_cycle(0);
 	encrypt_cycle(1);
@@ -235,26 +286,27 @@ __twofish_enc_blk_8way:
 	encrypt_cycle(4);
 	encrypt_cycle(5);
 	encrypt_cycle(6);
-	encrypt_cycle(7);
+	encrypt_cycle_last(7);
=20
 	vmovdqu (w+4*4)(CTX), RK1;
=20
 	popq %rcx;
 	popq %rbx;
+	popq %rbp;
=20
-	leaq (4*4*4)(%rsi), %rax;
+	leaq (4*4*4)(%r11), %rax;
=20
 	testb %cl, %cl;
 	jnz __enc_xor8;
=20
-	outunpack_blocks(%rsi, RC1, RD1, RA1, RB1, RK1, RX, RY, RK2);
-	outunpack_blocks(%rax, RC2, RD2, RA2, RB2, RK1, RX, RY, RK2);
+	outunpack_blocks(%r11, RC1, RD1, RA1, RB1, RK1, RX0, RY0, RK2);
+	outunpack_blocks(%rax, RC2, RD2, RA2, RB2, RK1, RX0, RY0, RK2);
=20
 	ret;
=20
 __enc_xor8:
-	outunpack_xor_blocks(%rsi, RC1, RD1, RA1, RB1, RK1, RX, RY, RK2);
-	outunpack_xor_blocks(%rax, RC2, RD2, RA2, RB2, RK1, RX, RY, RK2);
+	outunpack_xor_blocks(%r11, RC1, RD1, RA1, RB1, RK1, RX0, RY0, RK2);
+	outunpack_xor_blocks(%rax, RC2, RD2, RA2, RB2, RK1, RX0, RY0, RK2);
=20
 	ret;
=20
@@ -269,16 +321,18 @@ twofish_dec_blk_8way:
 	 *	%rdx: src
 	 */
=20
+	pushq %rbp;
 	pushq %rbx;
=20
 	vmovdqu (w+4*4)(CTX), RK1;
=20
 	leaq (4*4*4)(%rdx), %rax;
-	inpack_blocks(%rdx, RC1, RD1, RA1, RB1, RK1, RX, RY, RK2);
-	inpack_blocks(%rax, RC2, RD2, RA2, RB2, RK1, RX, RY, RK2);
+	inpack_blocks(%rdx, RC1, RD1, RA1, RB1, RK1, RX0, RY0, RK2);
+	vmovq		RC1, RGI1;
+	vpextrq $1,	RC1, RGI2;
+	inpack_blocks(%rax, RC2, RD2, RA2, RB2, RK1, RX0, RY0, RK2);
=20
-	xorq RID1, RID1;
-	xorq RID2, RID2;
+	movq %rsi, %r11;
=20
 	decrypt_cycle(7);
 	decrypt_cycle(6);
@@ -287,14 +341,15 @@ twofish_dec_blk_8way:
 	decrypt_cycle(3);
 	decrypt_cycle(2);
 	decrypt_cycle(1);
-	decrypt_cycle(0);
+	decrypt_cycle_last(0);
=20
 	vmovdqu (w)(CTX), RK1;
=20
 	popq %rbx;
+	popq %rbp;
=20
-	leaq (4*4*4)(%rsi), %rax;
-	outunpack_blocks(%rsi, RA1, RB1, RC1, RD1, RK1, RX, RY, RK2);
-	outunpack_blocks(%rax, RA2, RB2, RC2, RD2, RK1, RX, RY, RK2);
+	leaq (4*4*4)(%r11), %rax;
+	outunpack_blocks(%r11, RA1, RB1, RC1, RD1, RK1, RX0, RY0, RK2);
+	outunpack_blocks(%rax, RA2, RB2, RC2, RD2, RK1, RX0, RY0, RK2);
=20
 	ret;
