From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 3/3] crypto: cast6-avx - tune assembler code for ~11% more
 performance
Date: Mon, 30 Jul 2012 14:36:30 +0300
Message-ID: <20120730113630.23527.4369.stgit@localhost6.localdomain6>
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
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:45915 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab2G3Lge (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 30 Jul 2012 07:36:34 -0400
In-Reply-To: <20120730113620.23527.64087.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Patch replaces 'movb' instructions with 'movzbl' to break false register
dependencies, interleaves instructions better for out-of-order scheduling
and merges constant 16-bit rotation with round-key variable rotation.

Also move common round code to separate functions to reduce object size.

Tested on Core i5-2450M.

Cc: Johannes Goetzfried <Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/cast6-avx-x86_64-asm_64.S |  235 +++++++++++++++--------------
 1 file changed, 121 insertions(+), 114 deletions(-)

diff --git a/arch/x86/crypto/cast6-avx-x86_64-asm_64.S b/arch/x86/crypto/cast6-avx-x86_64-asm_64.S
index d258ce0..3d65def 100644
--- a/arch/x86/crypto/cast6-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/cast6-avx-x86_64-asm_64.S
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
+#define RTMP %xmm15
 
 #define RID1  %rax
-#define RID1b %al
+#define RID1d %eax
 #define RID2  %rbx
-#define RID2b %bl
+#define RID2d %ebx
 
 #define RGI1   %rdx
 #define RGI1bl %dl
@@ -84,95 +86,106 @@
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
+	op0	a,	rkm,  x;                \
+	vpslld  rkrl,	x,    RTMP;              \
+	vpsrld  rkrr,	x,    x;                 \
 	vpor	RTMP,	x,    x;                 \
 	\
-	vpshufb	RMASK,	x,    x;                 \
 	vmovq		x,    RGI1;              \
-	vpsrldq $8,	x,    x;                 \
-	vmovq		x,    RGI2;              \
+	vpextrq $1,	x,    RGI2;              \
 	\
-	lookup_32bit(RGI1, RFS1, op1, op2, op3); \
-	shrq $16,	RGI1;                    \
-	lookup_32bit(RGI1, RFS2, op1, op2, op3); \
-	shlq $32,	RFS2;                    \
-	orq		RFS1, RFS2;              \
+	lookup_32bit(RGI1, RFS1, op1, op2, op3, shr_next, RGI1); \
+	vmovd		RFS1d, x;                \
+	lookup_32bit(RGI1, RFS2, op1, op2, op3, dummy, none); \
+	vpinsrd $1,     RFS2d, x, x;             \
 	\
-	lookup_32bit(RGI2, RFS1, op1, op2, op3); \
-	shrq $16,	RGI2;                    \
-	lookup_32bit(RGI2, RFS3, op1, op2, op3); \
-	shlq $32,	RFS3;                    \
-	orq		RFS1, RFS3;              \
-	\
-	vmovq		RFS2, x;                 \
-	vpinsrq $1,	RFS3, x, x;
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
+#define fn_qop(in, out, x, f, rkm, rkrl, rkrr) \
+	F ## f(in ## 1, x, rkm, rkrl, rkrr); \
+	vpxor out ## 1, x, out ## 1;         \
+	F ## f(in ## 2, x, rkm, rkrl, rkrr); \
+	vpxor out ## 2, x, out ## 2;
+
+.align 4
+__qop_RD_RC_RX1_RKM0__qop_RC_RB_RX2_RKM1:
+	fn_qop(RD, RC, RX, 1, RKM0, RKRL0, RKRR0);
+	fn_qop(RC, RB, RX, 2, RKM1, RKRL1, RKRR1);
+	ret;
 
-#define F1(b, x) F(b, x, vpaddd, xorl, subl, addl)
-#define F2(b, x) F(b, x, vpxor,  subl, addl, xorl)
-#define F3(b, x) F(b, x, vpsubd, addl, xorl, subl)
+.align 4
+__qop_RB_RA_RX_3_RKM0__qop_RA_RD_RX1_RKM1:
+	fn_qop(RB, RA, RX, 3, RKM0, RKRL0, RKRR0);
+	fn_qop(RA, RD, RX, 1, RKM1, RKRL1, RKRR1);
+	ret;
 
-#define qop(in, out, x, f) \
-	F ## f(in ## 1, x);          \
-	vpxor out ## 1, x, out ## 1; \
-	F ## f(in ## 2, x);          \
-	vpxor out ## 2, x, out ## 2; \
+.align 4
+__qop_RA_RD_RX1_RKM1__qop_RB_RA_RX3_RKM0:
+	fn_qop(RA, RD, RX, 1, RKM1, RKRL1, RKRR1);
+	fn_qop(RB, RA, RX, 3, RKM0, RKRL0, RKRR0);
+	ret;
+
+.align 4
+__qop_RC_RB_RX2_RKM1__qop_RD_RC_RX1_RKM0:
+	fn_qop(RC, RB, RX, 2, RKM1, RKRL1, RKRR1);
+	fn_qop(RD, RC, RX, 1, RKM0, RKRL0, RKRR0);
+	ret;
+
+#define load_round_key(x, rkm, rkrl, rkrr) \
+	movzbl		(kr+(x))(CTX), RID1d;        \
+	movl $32,	RID2d;                       \
+	/* merge (kr)-bit and 16-bit rotates */      \
+	xorl $16,	RID1d;                       \
+	vbroadcastss 	(km+(4*(x)))(CTX), rkm;      \
+	vmovd           RID1d, rkrl;                 \
+	subl            RID1d, RID2d;                \
+	vmovd           RID2d, rkrr;
 
 #define Q(n) \
-	vbroadcastss	(km+(4*(4*n+0)))(CTX), RKM;        \
-	vpinsrb $0,	(kr+(4*n+0))(CTX),     RKRF, RKRF; \
-	vpsubq		RKRF,                  R32,  RKRR; \
-	qop(RD, RC, RX, 1);                                \
-	\
-	vbroadcastss	(km+(4*(4*n+1)))(CTX), RKM;        \
-	vpinsrb $0,	(kr+(4*n+1))(CTX),     RKRF, RKRF; \
-	vpsubq		RKRF,                  R32,  RKRR; \
-	qop(RC, RB, RX, 2);                                \
+	load_round_key((4*n+0), RKM0, RKRL0, RKRR0);       \
+	load_round_key((4*n+1), RKM1, RKRL1, RKRR1);       \
+	call __qop_RD_RC_RX1_RKM0__qop_RC_RB_RX2_RKM1; \
 	\
-	vbroadcastss	(km+(4*(4*n+2)))(CTX), RKM;        \
-	vpinsrb $0,	(kr+(4*n+2))(CTX),     RKRF, RKRF; \
-	vpsubq		RKRF,                  R32,  RKRR; \
-	qop(RB, RA, RX, 3);                                \
-	\
-	vbroadcastss	(km+(4*(4*n+3)))(CTX), RKM;        \
-	vpinsrb $0,	(kr+(4*n+3))(CTX),     RKRF, RKRF; \
-	vpsubq		RKRF,                  R32,  RKRR; \
-	qop(RA, RD, RX, 1);
+	load_round_key((4*n+2), RKM0, RKRL0, RKRR0);       \
+	load_round_key((4*n+3), RKM1, RKRL1, RKRR1);       \
+	call __qop_RB_RA_RX_3_RKM0__qop_RA_RD_RX1_RKM1;
 
 #define QBAR(n) \
-	vbroadcastss	(km+(4*(4*n+3)))(CTX), RKM;        \
-	vpinsrb $0,	(kr+(4*n+3))(CTX),     RKRF, RKRF; \
-	vpsubq		RKRF,                  R32,  RKRR; \
-	qop(RA, RD, RX, 1);                                \
-	\
-	vbroadcastss	(km+(4*(4*n+2)))(CTX), RKM;        \
-	vpinsrb $0,	(kr+(4*n+2))(CTX),     RKRF, RKRF; \
-	vpsubq		RKRF,                  R32,  RKRR; \
-	qop(RB, RA, RX, 3);                                \
+	load_round_key((4*n+3), RKM1, RKRL1, RKRR1);       \
+	load_round_key((4*n+2), RKM0, RKRL0, RKRR0);       \
+	call __qop_RA_RD_RX1_RKM1__qop_RB_RA_RX3_RKM0; \
 	\
-	vbroadcastss	(km+(4*(4*n+1)))(CTX), RKM;        \
-	vpinsrb $0,	(kr+(4*n+1))(CTX),     RKRF, RKRF; \
-	vpsubq		RKRF,                  R32,  RKRR; \
-	qop(RC, RB, RX, 2);                                \
-	\
-	vbroadcastss	(km+(4*(4*n+0)))(CTX), RKM;        \
-	vpinsrb $0,	(kr+(4*n+0))(CTX),     RKRF, RKRF; \
-	vpsubq		RKRF,                  R32,  RKRR; \
-	qop(RD, RC, RX, 1);
-
+	load_round_key((4*n+1), RKM1, RKRL1, RKRR1);       \
+	load_round_key((4*n+0), RKM0, RKRL0, RKRR0);       \
+	call __qop_RC_RB_RX2_RKM1__qop_RD_RC_RX1_RKM0;
 
 #define transpose_4x4(x0, x1, x2, x3, t0, t1, t2) \
 	vpunpckldq		x1, x0, t0; \
@@ -185,37 +198,37 @@
 	vpunpcklqdq		x3, t2, x2; \
 	vpunpckhqdq		x3, t2, x3;
 
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
@@ -228,8 +241,6 @@
 .align 16
 .Lbswap_mask:
 	.byte 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12
-.L32_mask:
-	.byte 32, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 0
 
 .align 16
 .global __cast6_enc_blk_8way
@@ -246,13 +257,10 @@ __cast6_enc_blk_8way:
 	pushq %rbx;
 	pushq %rcx;
 
-	vmovdqu .Lbswap_mask, RMASK;
-	vmovdqu .L32_mask, R32;
-	vpxor RKRF, RKRF, RKRF;
-
+	vmovdqa .Lbswap_mask, RKM1;
 	leaq (4*4*4)(%rdx), %rax;
-	inpack_blocks(%rdx, RA1, RB1, RC1, RD1, RTMP, RX, RKM);
-	inpack_blocks(%rax, RA2, RB2, RC2, RD2, RTMP, RX, RKM);
+	inpack_blocks(%rdx, RA1, RB1, RC1, RD1, RTMP, RX, RKM0, RKM1);
+	inpack_blocks(%rax, RA2, RB2, RC2, RD2, RTMP, RX, RKM0, RKM1);
 
 	xorq RID1, RID1;
 	xorq RID2, RID2;
@@ -273,19 +281,20 @@ __cast6_enc_blk_8way:
 	popq %rcx;
 	popq %rbx;
 
+	vmovdqa .Lbswap_mask, RKM1;
 	leaq (4*4*4)(%rsi), %rax;
 
 	testb %cl, %cl;
 	jnz __enc_xor8;
 
-	outunpack_blocks(%rsi, RA1, RB1, RC1, RD1, RTMP, RX, RKM);
-	outunpack_blocks(%rax, RA2, RB2, RC2, RD2, RTMP, RX, RKM);
+	outunpack_blocks(%rsi, RA1, RB1, RC1, RD1, RTMP, RX, RKM0, RKM1);
+	outunpack_blocks(%rax, RA2, RB2, RC2, RD2, RTMP, RX, RKM0, RKM1);
 
 	ret;
 
 __enc_xor8:
-	outunpack_xor_blocks(%rsi, RA1, RB1, RC1, RD1, RTMP, RX, RKM);
-	outunpack_xor_blocks(%rax, RA2, RB2, RC2, RD2, RTMP, RX, RKM);
+	outunpack_xor_blocks(%rsi, RA1, RB1, RC1, RD1, RTMP, RX, RKM0, RKM1);
+	outunpack_xor_blocks(%rax, RA2, RB2, RC2, RD2, RTMP, RX, RKM0, RKM1);
 
 	ret;
 
@@ -302,13 +311,10 @@ cast6_dec_blk_8way:
 
 	pushq %rbx;
 
-	vmovdqu .Lbswap_mask, RMASK;
-	vmovdqu .L32_mask, R32;
-	vpxor RKRF, RKRF, RKRF;
-
+	vmovdqa .Lbswap_mask, RKM1;
 	leaq (4*4*4)(%rdx), %rax;
-	inpack_blocks(%rdx, RA1, RB1, RC1, RD1, RTMP, RX, RKM);
-	inpack_blocks(%rax, RA2, RB2, RC2, RD2, RTMP, RX, RKM);
+	inpack_blocks(%rdx, RA1, RB1, RC1, RD1, RTMP, RX, RKM0, RKM1);
+	inpack_blocks(%rax, RA2, RB2, RC2, RD2, RTMP, RX, RKM0, RKM1);
 
 	xorq RID1, RID1;
 	xorq RID2, RID2;
@@ -328,8 +334,9 @@ cast6_dec_blk_8way:
 
 	popq %rbx;
 
+	vmovdqa .Lbswap_mask, RKM1;
 	leaq (4*4*4)(%rsi), %rax;
-	outunpack_blocks(%rsi, RA1, RB1, RC1, RD1, RTMP, RX, RKM);
-	outunpack_blocks(%rax, RA2, RB2, RC2, RD2, RTMP, RX, RKM);
+	outunpack_blocks(%rsi, RA1, RB1, RC1, RD1, RTMP, RX, RKM0, RKM1);
+	outunpack_blocks(%rax, RA2, RB2, RC2, RD2, RTMP, RX, RKM0, RKM1);
 
 	ret;
