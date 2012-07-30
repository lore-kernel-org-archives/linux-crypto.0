From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 2/3] crypto: cast5-avx - tune assembler code for ~11% more
 performance
Date: Mon, 30 Jul 2012 14:36:25 +0300
Message-ID: <20120730113625.23527.66931.stgit@localhost6.localdomain6>
References: <20120730113620.23527.64087.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Johannes Goetzfried
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:58263 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab2G3Lg3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 30 Jul 2012 07:36:29 -0400
In-Reply-To: <20120730113620.23527.64087.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Patch replaces 'movb' instructions with 'movzbl' to break false register
dependencies, interleaves instructions better for out-of-order scheduling
and merges constant 16-bit rotation with round-key variable rotation.

Tested on Core i5-2450M.

Cc: Johannes Goetzfried <Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/cast5-avx-x86_64-asm_64.S |  273 ++++++++++++++++-------------
 1 file changed, 151 insertions(+), 122 deletions(-)

diff --git a/arch/x86/crypto/cast5-avx-x86_64-asm_64.S b/arch/x86/crypto/cast5-avx-x86_64-asm_64.S
index 94693c8..6d064d0 100644
--- a/arch/x86/crypto/cast5-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/cast5-avx-x86_64-asm_64.S
@@ -56,18 +56,20 @@
 
 #define RX %xmm8
 
-#define RKM  %xmm9
-#define RKRF %xmm10
-#define RKRR %xmm11
+#define RKM0  %xmm9
+#define RKRL0 %xmm10
+#define RKRR0 %xmm11
 
-#define RTMP  %xmm12
-#define RMASK %xmm13
-#define R32   %xmm14
+#define RKM1  %xmm12
+#define RKRL1 %xmm13
+#define RKRR1 %xmm14
+
+#define RTMP  %xmm15
 
 #define RID1  %rax
-#define RID1b %al
+#define RID1d %eax
 #define RID2  %rbx
-#define RID2b %bl
+#define RID2d %ebx
 
 #define RGI1   %rdx
 #define RGI1bl %dl
@@ -84,60 +86,76 @@
 #define RFS3d %r10d
 
 
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
 
-#define F(a, x, op0, op1, op2, op3) \
-	op0	a,	RKM,  x;                 \
-	vpslld  RKRF,	x,    RTMP;              \
-	vpsrld  RKRR,	x,    x;                 \
+#define dummy(d) /* do nothing */
+
+#define shr_next(reg) \
+	shrq $16,	reg;
+
+#define F(a, x, op0, op1, op2, op3, rkm, rkrl, rkrr) \
+	op0	a,	rkm,  x;                 \
+	vpslld  rkrl,	x,    RTMP;              \
+	vpsrld  rkrr,	x,    x;                 \
 	vpor	RTMP,	x,    x;                 \
 	\
-	vpshufb	RMASK,	x,    x;                 \
 	vmovq		x,    RGI1;              \
-	vpsrldq $8,	x,    x;                 \
-	vmovq		x,    RGI2;              \
-	\
-	lookup_32bit(RGI1, RFS1, op1, op2, op3); \
-	shrq $16,	RGI1;                    \
-	lookup_32bit(RGI1, RFS2, op1, op2, op3); \
-	shlq $32,	RFS2;                    \
-	orq		RFS1, RFS2;              \
+	vpextrq $1,	x,    RGI2;              \
 	\
-	lookup_32bit(RGI2, RFS1, op1, op2, op3); \
-	shrq $16,	RGI2;                    \
-	lookup_32bit(RGI2, RFS3, op1, op2, op3); \
-	shlq $32,	RFS3;                    \
-	orq		RFS1, RFS3;              \
+	lookup_32bit(RGI1, RFS1, op1, op2, op3, shr_next, RGI1); \
+	vmovd		RFS1d, x;                \
+	lookup_32bit(RGI1, RFS2, op1, op2, op3, dummy, none); \
+	vpinsrd $1,     RFS2d, x, x;             \
 	\
-	vmovq		RFS2, x;                 \
-	vpinsrq $1,	RFS3, x, x;
-
-#define F1(b, x) F(b, x, vpaddd, xorl, subl, addl)
-#define F2(b, x) F(b, x, vpxor,  subl, addl, xorl)
-#define F3(b, x) F(b, x, vpsubd, addl, xorl, subl)
-
-#define subround(a, b, x, n, f) \
-	F ## f(b, x);  \
+	lookup_32bit(RGI2, RFS1, op1, op2, op3, shr_next, RGI2); \
+	vpinsrd $2,     RFS1d, x, x;             \
+	lookup_32bit(RGI2, RFS3, op1, op2, op3, dummy, none); \
+	vpinsrd $3,	RFS3d, x, x;
+
+#define F1(b, x, rkm, rkrl, rkrr) \
+	F(b, x, vpaddd, xorl, subl, addl, rkm, rkrl, rkrr)
+#define F2(b, x, rkm, rkrl, rkrr) \
+	F(b, x, vpxor,  subl, addl, xorl, rkm, rkrl, rkrr)
+#define F3(b, x, rkm, rkrl, rkrr) \
+	F(b, x, vpsubd, addl, xorl, subl, rkm, rkrl, rkrr)
+
+#define subround(a, b, x, f, rkm, rkrl, rkrr) \
+	F ## f(b, x, rkm, rkrl, rkrr);  \
 	vpxor a, x, a;
 
-#define round(l, r, n, f) \
-	vbroadcastss 	(km+(4*n))(CTX), RKM;        \
-	vpinsrb $0,	(kr+n)(CTX),     RKRF, RKRF; \
-	vpsubq		RKRF,            R32,  RKRR; \
-	subround(l ## 1, r ## 1, RX, n, f);          \
-	subround(l ## 2, r ## 2, RX, n, f);          \
-	subround(l ## 3, r ## 3, RX, n, f);          \
-	subround(l ## 4, r ## 4, RX, n, f);
-
+#define load_round_key(n, rkm, rkrl, rkrr) \
+	vbroadcastss 	(km+(4*n))(CTX), rkm;        \
+	movzbl		(kr+n)(CTX), RID1d;          \
+	movl $32,	RID2d;                       \
+	/* merge (kr)-bit and 16-bit rotates */      \
+	xorl $16,	RID1d;                       \
+	vmovd           RID1d, rkrl;                 \
+	subl            RID1d, RID2d;                \
+	vmovd           RID2d, rkrr;
+
+#define enc_load_keys(n) \
+	load_round_key((n + 0), RKM0, RKRL0, RKRR0); \
+	load_round_key((n + 1), RKM1, RKRL1, RKRR1);
+
+#define dec_load_keys(n) \
+	load_round_key((n - 0), RKM0, RKRL0, RKRR0); \
+	load_round_key((n - 1), RKM1, RKRL1, RKRR1);
+
+#define round(l, r, f, rkm, rkrl, rkrr) \
+	subround(l ## 1, r ## 1, RX, f, rkm, rkrl, rkrr); \
+	subround(l ## 2, r ## 2, RX, f, rkm, rkrl, rkrr); \
+	subround(l ## 3, r ## 3, RX, f, rkm, rkrl, rkrr); \
+	subround(l ## 4, r ## 4, RX, f, rkm, rkrl, rkrr);
 
 #define transpose_2x4(x0, x1, t0, t1) \
 	vpunpckldq		x1, x0, t0; \
@@ -146,27 +164,27 @@
 	vpunpcklqdq		t1, t0, x0; \
 	vpunpckhqdq		t1, t0, x1;
 
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
@@ -175,8 +193,6 @@
 .align 16
 .Lbswap_mask:
 	.byte 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12
-.L32_mask:
-	.byte 32, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 0
 
 .align 16
 .global __cast5_enc_blk_16way
@@ -193,68 +209,75 @@ __cast5_enc_blk_16way:
 	pushq %rbx;
 	pushq %rcx;
 
-	vmovdqu .Lbswap_mask, RMASK;
-	vmovdqu .L32_mask, R32;
-	vpxor RKRF, RKRF, RKRF;
-
-	inpack_blocks(%rdx, RL1, RR1, RTMP, RX);
+	vmovdqa .Lbswap_mask, RKM0;
+	inpack_blocks(%rdx, RL1, RR1, RTMP, RX, RKM0);
 	leaq (2*4*4)(%rdx), %rax;
-	inpack_blocks(%rax, RL2, RR2, RTMP, RX);
+	inpack_blocks(%rax, RL2, RR2, RTMP, RX, RKM0);
 	leaq (2*4*4)(%rax), %rax;
-	inpack_blocks(%rax, RL3, RR3, RTMP, RX);
+	inpack_blocks(%rax, RL3, RR3, RTMP, RX, RKM0);
 	leaq (2*4*4)(%rax), %rax;
-	inpack_blocks(%rax, RL4, RR4, RTMP, RX);
+	inpack_blocks(%rax, RL4, RR4, RTMP, RX, RKM0);
 
 	xorq RID1, RID1;
 	xorq RID2, RID2;
 
-	round(RL, RR, 0, 1);
-	round(RR, RL, 1, 2);
-	round(RL, RR, 2, 3);
-	round(RR, RL, 3, 1);
-	round(RL, RR, 4, 2);
-	round(RR, RL, 5, 3);
-	round(RL, RR, 6, 1);
-	round(RR, RL, 7, 2);
-	round(RL, RR, 8, 3);
-	round(RR, RL, 9, 1);
-	round(RL, RR, 10, 2);
-	round(RR, RL, 11, 3);
+	enc_load_keys(0);
+	round(RL, RR, 1, RKM0, RKRL0, RKRR0);
+	round(RR, RL, 2, RKM1, RKRL1, RKRR1);
+	enc_load_keys(2);
+	round(RL, RR, 3, RKM0, RKRL0, RKRR0);
+	round(RR, RL, 1, RKM1, RKRL1, RKRR1);
+	enc_load_keys(4);
+	round(RL, RR, 2, RKM0, RKRL0, RKRR0);
+	round(RR, RL, 3, RKM1, RKRL1, RKRR1);
+	enc_load_keys(6);
+	round(RL, RR, 1, RKM0, RKRL0, RKRR0);
+	round(RR, RL, 2, RKM1, RKRL1, RKRR1);
+	enc_load_keys(8);
+	round(RL, RR, 3, RKM0, RKRL0, RKRR0);
+	round(RR, RL, 1, RKM1, RKRL1, RKRR1);
+	enc_load_keys(10);
+	round(RL, RR, 2, RKM0, RKRL0, RKRR0);
+	round(RR, RL, 3, RKM1, RKRL1, RKRR1);
 
 	movb rr(CTX), %al;
 	testb %al, %al;
 	jnz __skip_enc;
 
-	round(RL, RR, 12, 1);
-	round(RR, RL, 13, 2);
-	round(RL, RR, 14, 3);
-	round(RR, RL, 15, 1);
+	enc_load_keys(12);
+	round(RL, RR, 1, RKM0, RKRL0, RKRR0);
+	round(RR, RL, 2, RKM1, RKRL1, RKRR1);
+	enc_load_keys(14);
+	round(RL, RR, 3, RKM0, RKRL0, RKRR0);
+	round(RR, RL, 1, RKM1, RKRL1, RKRR1);
 
 __skip_enc:
 	popq %rcx;
 	popq %rbx;
 
+	vmovdqa .Lbswap_mask, RKM0;
+
 	testb %cl, %cl;
 	jnz __enc_xor16;
 
-	outunpack_blocks(%rsi, RR1, RL1, RTMP, RX);
+	outunpack_blocks(%rsi, RR1, RL1, RTMP, RX, RKM0);
 	leaq (2*4*4)(%rsi), %rax;
-	outunpack_blocks(%rax, RR2, RL2, RTMP, RX);
+	outunpack_blocks(%rax, RR2, RL2, RTMP, RX, RKM0);
 	leaq (2*4*4)(%rax), %rax;
-	outunpack_blocks(%rax, RR3, RL3, RTMP, RX);
+	outunpack_blocks(%rax, RR3, RL3, RTMP, RX, RKM0);
 	leaq (2*4*4)(%rax), %rax;
-	outunpack_blocks(%rax, RR4, RL4, RTMP, RX);
+	outunpack_blocks(%rax, RR4, RL4, RTMP, RX, RKM0);
 
 	ret;
 
 __enc_xor16:
-	outunpack_xor_blocks(%rsi, RR1, RL1, RTMP, RX);
+	outunpack_xor_blocks(%rsi, RR1, RL1, RTMP, RX, RKM0);
 	leaq (2*4*4)(%rsi), %rax;
-	outunpack_xor_blocks(%rax, RR2, RL2, RTMP, RX);
+	outunpack_xor_blocks(%rax, RR2, RL2, RTMP, RX, RKM0);
 	leaq (2*4*4)(%rax), %rax;
-	outunpack_xor_blocks(%rax, RR3, RL3, RTMP, RX);
+	outunpack_xor_blocks(%rax, RR3, RL3, RTMP, RX, RKM0);
 	leaq (2*4*4)(%rax), %rax;
-	outunpack_xor_blocks(%rax, RR4, RL4, RTMP, RX);
+	outunpack_xor_blocks(%rax, RR4, RL4, RTMP, RX, RKM0);
 
 	ret;
 
@@ -271,17 +294,14 @@ cast5_dec_blk_16way:
 
 	pushq %rbx;
 
-	vmovdqu .Lbswap_mask, RMASK;
-	vmovdqu .L32_mask, R32;
-	vpxor RKRF, RKRF, RKRF;
-
-	inpack_blocks(%rdx, RL1, RR1, RTMP, RX);
+	vmovdqa .Lbswap_mask, RKM0;
+	inpack_blocks(%rdx, RL1, RR1, RTMP, RX, RKM0);
 	leaq (2*4*4)(%rdx), %rax;
-	inpack_blocks(%rax, RL2, RR2, RTMP, RX);
+	inpack_blocks(%rax, RL2, RR2, RTMP, RX, RKM0);
 	leaq (2*4*4)(%rax), %rax;
-	inpack_blocks(%rax, RL3, RR3, RTMP, RX);
+	inpack_blocks(%rax, RL3, RR3, RTMP, RX, RKM0);
 	leaq (2*4*4)(%rax), %rax;
-	inpack_blocks(%rax, RL4, RR4, RTMP, RX);
+	inpack_blocks(%rax, RL4, RR4, RTMP, RX, RKM0);
 
 	xorq RID1, RID1;
 	xorq RID2, RID2;
@@ -290,33 +310,42 @@ cast5_dec_blk_16way:
 	testb %al, %al;
 	jnz __skip_dec;
 
-	round(RL, RR, 15, 1);
-	round(RR, RL, 14, 3);
-	round(RL, RR, 13, 2);
-	round(RR, RL, 12, 1);
+	dec_load_keys(15);
+	round(RL, RR, 1, RKM0, RKRL0, RKRR0);
+	round(RR, RL, 3, RKM1, RKRL1, RKRR1);
+	dec_load_keys(13);
+	round(RL, RR, 2, RKM0, RKRL0, RKRR0);
+	round(RR, RL, 1, RKM1, RKRL1, RKRR1);
 
 __skip_dec:
-	round(RL, RR, 11, 3);
-	round(RR, RL, 10, 2);
-	round(RL, RR, 9, 1);
-	round(RR, RL, 8, 3);
-	round(RL, RR, 7, 2);
-	round(RR, RL, 6, 1);
-	round(RL, RR, 5, 3);
-	round(RR, RL, 4, 2);
-	round(RL, RR, 3, 1);
-	round(RR, RL, 2, 3);
-	round(RL, RR, 1, 2);
-	round(RR, RL, 0, 1);
-
+	dec_load_keys(11);
+	round(RL, RR, 3, RKM0, RKRL0, RKRR0);
+	round(RR, RL, 2, RKM1, RKRL1, RKRR1);
+	dec_load_keys(9);
+	round(RL, RR, 1, RKM0, RKRL0, RKRR0);
+	round(RR, RL, 3, RKM1, RKRL1, RKRR1);
+	dec_load_keys(7);
+	round(RL, RR, 2, RKM0, RKRL0, RKRR0);
+	round(RR, RL, 1, RKM1, RKRL1, RKRR1);
+	dec_load_keys(5);
+	round(RL, RR, 3, RKM0, RKRL0, RKRR0);
+	round(RR, RL, 2, RKM1, RKRL1, RKRR1);
+	dec_load_keys(3);
+	round(RL, RR, 1, RKM0, RKRL0, RKRR0);
+	round(RR, RL, 3, RKM1, RKRL1, RKRR1);
+	dec_load_keys(1);
+	round(RL, RR, 2, RKM0, RKRL0, RKRR0);
+	round(RR, RL, 1, RKM1, RKRL1, RKRR1);
+
+	vmovdqa .Lbswap_mask, RKM0;
 	popq %rbx;
 
-	outunpack_blocks(%rsi, RR1, RL1, RTMP, RX);
+	outunpack_blocks(%rsi, RR1, RL1, RTMP, RX, RKM0);
 	leaq (2*4*4)(%rsi), %rax;
-	outunpack_blocks(%rax, RR2, RL2, RTMP, RX);
+	outunpack_blocks(%rax, RR2, RL2, RTMP, RX, RKM0);
 	leaq (2*4*4)(%rax), %rax;
-	outunpack_blocks(%rax, RR3, RL3, RTMP, RX);
+	outunpack_blocks(%rax, RR3, RL3, RTMP, RX, RKM0);
 	leaq (2*4*4)(%rax), %rax;
-	outunpack_blocks(%rax, RR4, RL4, RTMP, RX);
+	outunpack_blocks(%rax, RR4, RL4, RTMP, RX, RKM0);
 
 	ret;
