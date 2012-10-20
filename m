From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 2/5] crypto: cast6/avx - avoid using temporary stack buffers
Date: Sat, 20 Oct 2012 15:06:41 +0300
Message-ID: <20121020120641.19422.97531.stgit@localhost6.localdomain6>
References: <20121020120431.19422.17000.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:56110 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163Ab2JTMGo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 20 Oct 2012 08:06:44 -0400
In-Reply-To: <20121020120431.19422.17000.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Introduce new assembler functions to avoid use temporary stack buffers in
glue code. This also allows use of vector instructions for xoring output
in CTR and CBC modes and construction of IVs for CTR mode.

ECB mode sees ~0.5% decrease in speed because added one extra function
call. CBC mode decryption and CTR mode benefit from vector operations
and gain ~2%.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/cast6-avx-x86_64-asm_64.S |  190 +++++++++++++++++++----------
 arch/x86/crypto/cast6_avx_glue.c          |   71 ++---------
 arch/x86/crypto/glue_helper-asm-avx.S     |   91 ++++++++++++++
 3 files changed, 227 insertions(+), 125 deletions(-)
 create mode 100644 arch/x86/crypto/glue_helper-asm-avx.S

diff --git a/arch/x86/crypto/cast6-avx-x86_64-asm_64.S b/arch/x86/crypto/cast6-avx-x86_64-asm_64.S
index 218d283..83a5381 100644
--- a/arch/x86/crypto/cast6-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/cast6-avx-x86_64-asm_64.S
@@ -23,6 +23,8 @@
  *
  */
 
+#include "glue_helper-asm-avx.S"
+
 .file "cast6-avx-x86_64-asm_64.S"
 
 .extern cast6_s1
@@ -205,11 +207,7 @@
 	vpunpcklqdq		x3, t2, x2; \
 	vpunpckhqdq		x3, t2, x3;
 
-#define inpack_blocks(in, x0, x1, x2, x3, t0, t1, t2, rmask) \
-	vmovdqu (0*4*4)(in),	x0; \
-	vmovdqu (1*4*4)(in),	x1; \
-	vmovdqu (2*4*4)(in),	x2; \
-	vmovdqu (3*4*4)(in),	x3; \
+#define inpack_blocks(x0, x1, x2, x3, t0, t1, t2, rmask) \
 	vpshufb rmask, x0,	x0; \
 	vpshufb rmask, x1,	x1; \
 	vpshufb rmask, x2,	x2; \
@@ -217,39 +215,21 @@
 	\
 	transpose_4x4(x0, x1, x2, x3, t0, t1, t2)
 
-#define outunpack_blocks(out, x0, x1, x2, x3, t0, t1, t2, rmask) \
+#define outunpack_blocks(x0, x1, x2, x3, t0, t1, t2, rmask) \
 	transpose_4x4(x0, x1, x2, x3, t0, t1, t2) \
 	\
 	vpshufb rmask,		x0, x0;       \
 	vpshufb rmask,		x1, x1;       \
 	vpshufb rmask,		x2, x2;       \
-	vpshufb rmask,		x3, x3;       \
-	vmovdqu x0,		(0*4*4)(out); \
-	vmovdqu	x1,		(1*4*4)(out); \
-	vmovdqu	x2,		(2*4*4)(out); \
-	vmovdqu	x3,		(3*4*4)(out);
-
-#define outunpack_xor_blocks(out, x0, x1, x2, x3, t0, t1, t2, rmask) \
-	transpose_4x4(x0, x1, x2, x3, t0, t1, t2) \
-	\
-	vpshufb rmask,		x0, x0;       \
-	vpshufb rmask,		x1, x1;       \
-	vpshufb rmask,		x2, x2;       \
-	vpshufb rmask,		x3, x3;       \
-	vpxor (0*4*4)(out),	x0, x0;       \
-	vmovdqu	x0,		(0*4*4)(out); \
-	vpxor (1*4*4)(out),	x1, x1;       \
-	vmovdqu	x1,		(1*4*4)(out); \
-	vpxor (2*4*4)(out),	x2, x2;       \
-	vmovdqu x2,		(2*4*4)(out); \
-	vpxor (3*4*4)(out),	x3, x3;       \
-	vmovdqu x3,		(3*4*4)(out);
+	vpshufb rmask,		x3, x3;
 
 .data
 
 .align 16
 .Lbswap_mask:
 	.byte 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12
+.Lbswap128_mask:
+	.byte 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0
 .Lrkr_enc_Q_Q_QBAR_QBAR:
 	.byte 0, 1, 2, 3, 4, 5, 6, 7, 11, 10, 9, 8, 15, 14, 13, 12
 .Lrkr_enc_QBAR_QBAR_QBAR_QBAR:
@@ -269,31 +249,26 @@
 
 .text
 
-.align 16
-.global __cast6_enc_blk_8way
-.type   __cast6_enc_blk_8way,@function;
+.align 8
+.type   __cast6_enc_blk8,@function;
 
-__cast6_enc_blk_8way:
+__cast6_enc_blk8:
 	/* input:
 	 *	%rdi: ctx, CTX
-	 *	%rsi: dst
-	 *	%rdx: src
-	 *	%rcx: bool, if true: xor output
+	 *	RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2: blocks
+	 * output:
+	 *	RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2: encrypted blocks
 	 */
 
 	pushq %rbp;
 	pushq %rbx;
-	pushq %rcx;
 
 	vmovdqa .Lbswap_mask, RKM;
 	vmovd .Lfirst_mask, R1ST;
 	vmovd .L32_mask, R32;
 
-	leaq (4*4*4)(%rdx), %rax;
-	inpack_blocks(%rdx, RA1, RB1, RC1, RD1, RTMP, RX, RKRF, RKM);
-	inpack_blocks(%rax, RA2, RB2, RC2, RD2, RTMP, RX, RKRF, RKM);
-
-	movq %rsi, %r11;
+	inpack_blocks(RA1, RB1, RC1, RD1, RTMP, RX, RKRF, RKM);
+	inpack_blocks(RA2, RB2, RC2, RD2, RTMP, RX, RKRF, RKM);
 
 	preload_rkr(0, dummy, none);
 	Q(0);
@@ -311,36 +286,25 @@ __cast6_enc_blk_8way:
 	QBAR(10);
 	QBAR(11);
 
-	popq %rcx;
 	popq %rbx;
 	popq %rbp;
 
 	vmovdqa .Lbswap_mask, RKM;
-	leaq (4*4*4)(%r11), %rax;
-
-	testb %cl, %cl;
-	jnz __enc_xor8;
-
-	outunpack_blocks(%r11, RA1, RB1, RC1, RD1, RTMP, RX, RKRF, RKM);
-	outunpack_blocks(%rax, RA2, RB2, RC2, RD2, RTMP, RX, RKRF, RKM);
-
-	ret;
 
-__enc_xor8:
-	outunpack_xor_blocks(%r11, RA1, RB1, RC1, RD1, RTMP, RX, RKRF, RKM);
-	outunpack_xor_blocks(%rax, RA2, RB2, RC2, RD2, RTMP, RX, RKRF, RKM);
+	outunpack_blocks(RA1, RB1, RC1, RD1, RTMP, RX, RKRF, RKM);
+	outunpack_blocks(RA2, RB2, RC2, RD2, RTMP, RX, RKRF, RKM);
 
 	ret;
 
-.align 16
-.global cast6_dec_blk_8way
-.type   cast6_dec_blk_8way,@function;
+.align 8
+.type   __cast6_dec_blk8,@function;
 
-cast6_dec_blk_8way:
+__cast6_dec_blk8:
 	/* input:
 	 *	%rdi: ctx, CTX
-	 *	%rsi: dst
-	 *	%rdx: src
+	 *	RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2: encrypted blocks
+	 * output:
+	 *	RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2: decrypted blocks
 	 */
 
 	pushq %rbp;
@@ -350,11 +314,8 @@ cast6_dec_blk_8way:
 	vmovd .Lfirst_mask, R1ST;
 	vmovd .L32_mask, R32;
 
-	leaq (4*4*4)(%rdx), %rax;
-	inpack_blocks(%rdx, RA1, RB1, RC1, RD1, RTMP, RX, RKRF, RKM);
-	inpack_blocks(%rax, RA2, RB2, RC2, RD2, RTMP, RX, RKRF, RKM);
-
-	movq %rsi, %r11;
+	inpack_blocks(RA1, RB1, RC1, RD1, RTMP, RX, RKRF, RKM);
+	inpack_blocks(RA2, RB2, RC2, RD2, RTMP, RX, RKRF, RKM);
 
 	preload_rkr(2, shuffle, .Lrkr_dec_Q_Q_Q_Q);
 	Q(11);
@@ -376,8 +337,103 @@ cast6_dec_blk_8way:
 	popq %rbp;
 
 	vmovdqa .Lbswap_mask, RKM;
-	leaq (4*4*4)(%r11), %rax;
-	outunpack_blocks(%r11, RA1, RB1, RC1, RD1, RTMP, RX, RKRF, RKM);
-	outunpack_blocks(%rax, RA2, RB2, RC2, RD2, RTMP, RX, RKRF, RKM);
+	outunpack_blocks(RA1, RB1, RC1, RD1, RTMP, RX, RKRF, RKM);
+	outunpack_blocks(RA2, RB2, RC2, RD2, RTMP, RX, RKRF, RKM);
+
+	ret;
+
+.align 8
+.global cast6_ecb_enc_8way
+.type   cast6_ecb_enc_8way,@function;
+
+cast6_ecb_enc_8way:
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst
+	 *	%rdx: src
+	 */
+
+	movq %rsi, %r11;
+
+	load_8way(%rdx, RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2);
+
+	call __cast6_enc_blk8;
+
+	store_8way(%r11, RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2);
+
+	ret;
+
+.align 8
+.global cast6_ecb_dec_8way
+.type   cast6_ecb_dec_8way,@function;
+
+cast6_ecb_dec_8way:
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst
+	 *	%rdx: src
+	 */
+
+	movq %rsi, %r11;
+
+	load_8way(%rdx, RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2);
+
+	call __cast6_dec_blk8;
+
+	store_8way(%r11, RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2);
+
+	ret;
+
+.align 8
+.global cast6_cbc_dec_8way
+.type   cast6_cbc_dec_8way,@function;
+
+cast6_cbc_dec_8way:
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst
+	 *	%rdx: src
+	 */
+
+	pushq %r12;
+
+	movq %rsi, %r11;
+	movq %rdx, %r12;
+
+	load_8way(%rdx, RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2);
+
+	call __cast6_dec_blk8;
+
+	store_cbc_8way(%r12, %r11, RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2);
+
+	popq %r12;
+
+	ret;
+
+.align 8
+.global cast6_ctr_8way
+.type   cast6_ctr_8way,@function;
+
+cast6_ctr_8way:
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst
+	 *	%rdx: src
+	 *	%rcx: iv (little endian, 128bit)
+	 */
+
+	pushq %r12;
+
+	movq %rsi, %r11;
+	movq %rdx, %r12;
+
+	load_ctr_8way(%rcx, .Lbswap128_mask, RA1, RB1, RC1, RD1, RA2, RB2, RC2,
+		      RD2, RX, RKR, RKM);
+
+	call __cast6_enc_blk8;
+
+	store_ctr_8way(%r12, %r11, RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2);
+
+	popq %r12;
 
 	ret;
diff --git a/arch/x86/crypto/cast6_avx_glue.c b/arch/x86/crypto/cast6_avx_glue.c
index 1dfd33b..92f7ca2 100644
--- a/arch/x86/crypto/cast6_avx_glue.c
+++ b/arch/x86/crypto/cast6_avx_glue.c
@@ -40,43 +40,15 @@
 
 #define CAST6_PARALLEL_BLOCKS 8
 
-asmlinkage void __cast6_enc_blk_8way(struct cast6_ctx *ctx, u8 *dst,
-				     const u8 *src, bool xor);
-asmlinkage void cast6_dec_blk_8way(struct cast6_ctx *ctx, u8 *dst,
+asmlinkage void cast6_ecb_enc_8way(struct cast6_ctx *ctx, u8 *dst,
+				   const u8 *src);
+asmlinkage void cast6_ecb_dec_8way(struct cast6_ctx *ctx, u8 *dst,
 				   const u8 *src);
 
-static inline void cast6_enc_blk_xway(struct cast6_ctx *ctx, u8 *dst,
-				      const u8 *src)
-{
-	__cast6_enc_blk_8way(ctx, dst, src, false);
-}
-
-static inline void cast6_enc_blk_xway_xor(struct cast6_ctx *ctx, u8 *dst,
-					  const u8 *src)
-{
-	__cast6_enc_blk_8way(ctx, dst, src, true);
-}
-
-static inline void cast6_dec_blk_xway(struct cast6_ctx *ctx, u8 *dst,
-				      const u8 *src)
-{
-	cast6_dec_blk_8way(ctx, dst, src);
-}
-
-
-static void cast6_decrypt_cbc_xway(void *ctx, u128 *dst, const u128 *src)
-{
-	u128 ivs[CAST6_PARALLEL_BLOCKS - 1];
-	unsigned int j;
-
-	for (j = 0; j < CAST6_PARALLEL_BLOCKS - 1; j++)
-		ivs[j] = src[j];
-
-	cast6_dec_blk_xway(ctx, (u8 *)dst, (u8 *)src);
-
-	for (j = 0; j < CAST6_PARALLEL_BLOCKS - 1; j++)
-		u128_xor(dst + (j + 1), dst + (j + 1), ivs + j);
-}
+asmlinkage void cast6_cbc_dec_8way(struct cast6_ctx *ctx, u8 *dst,
+				   const u8 *src);
+asmlinkage void cast6_ctr_8way(struct cast6_ctx *ctx, u8 *dst, const u8 *src,
+			       le128 *iv);
 
 static void cast6_crypt_ctr(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 {
@@ -89,30 +61,13 @@ static void cast6_crypt_ctr(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 	u128_xor(dst, src, (u128 *)&ctrblk);
 }
 
-static void cast6_crypt_ctr_xway(void *ctx, u128 *dst, const u128 *src,
-				 le128 *iv)
-{
-	be128 ctrblks[CAST6_PARALLEL_BLOCKS];
-	unsigned int i;
-
-	for (i = 0; i < CAST6_PARALLEL_BLOCKS; i++) {
-		if (dst != src)
-			dst[i] = src[i];
-
-		le128_to_be128(&ctrblks[i], iv);
-		le128_inc(iv);
-	}
-
-	cast6_enc_blk_xway_xor(ctx, (u8 *)dst, (u8 *)ctrblks);
-}
-
 static const struct common_glue_ctx cast6_enc = {
 	.num_funcs = 2,
 	.fpu_blocks_limit = CAST6_PARALLEL_BLOCKS,
 
 	.funcs = { {
 		.num_blocks = CAST6_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(cast6_enc_blk_xway) }
+		.fn_u = { .ecb = GLUE_FUNC_CAST(cast6_ecb_enc_8way) }
 	}, {
 		.num_blocks = 1,
 		.fn_u = { .ecb = GLUE_FUNC_CAST(__cast6_encrypt) }
@@ -125,7 +80,7 @@ static const struct common_glue_ctx cast6_ctr = {
 
 	.funcs = { {
 		.num_blocks = CAST6_PARALLEL_BLOCKS,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(cast6_crypt_ctr_xway) }
+		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(cast6_ctr_8way) }
 	}, {
 		.num_blocks = 1,
 		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(cast6_crypt_ctr) }
@@ -138,7 +93,7 @@ static const struct common_glue_ctx cast6_dec = {
 
 	.funcs = { {
 		.num_blocks = CAST6_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(cast6_dec_blk_xway) }
+		.fn_u = { .ecb = GLUE_FUNC_CAST(cast6_ecb_dec_8way) }
 	}, {
 		.num_blocks = 1,
 		.fn_u = { .ecb = GLUE_FUNC_CAST(__cast6_decrypt) }
@@ -151,7 +106,7 @@ static const struct common_glue_ctx cast6_dec_cbc = {
 
 	.funcs = { {
 		.num_blocks = CAST6_PARALLEL_BLOCKS,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(cast6_decrypt_cbc_xway) }
+		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(cast6_cbc_dec_8way) }
 	}, {
 		.num_blocks = 1,
 		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(__cast6_decrypt) }
@@ -215,7 +170,7 @@ static void encrypt_callback(void *priv, u8 *srcdst, unsigned int nbytes)
 	ctx->fpu_enabled = cast6_fpu_begin(ctx->fpu_enabled, nbytes);
 
 	if (nbytes == bsize * CAST6_PARALLEL_BLOCKS) {
-		cast6_enc_blk_xway(ctx->ctx, srcdst, srcdst);
+		cast6_ecb_enc_8way(ctx->ctx, srcdst, srcdst);
 		return;
 	}
 
@@ -232,7 +187,7 @@ static void decrypt_callback(void *priv, u8 *srcdst, unsigned int nbytes)
 	ctx->fpu_enabled = cast6_fpu_begin(ctx->fpu_enabled, nbytes);
 
 	if (nbytes == bsize * CAST6_PARALLEL_BLOCKS) {
-		cast6_dec_blk_xway(ctx->ctx, srcdst, srcdst);
+		cast6_ecb_dec_8way(ctx->ctx, srcdst, srcdst);
 		return;
 	}
 
diff --git a/arch/x86/crypto/glue_helper-asm-avx.S b/arch/x86/crypto/glue_helper-asm-avx.S
new file mode 100644
index 0000000..f7b6ea2
--- /dev/null
+++ b/arch/x86/crypto/glue_helper-asm-avx.S
@@ -0,0 +1,91 @@
+/*
+ * Shared glue code for 128bit block ciphers, AVX assembler macros
+ *
+ * Copyright (c) 2012 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
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
+#define load_8way(src, x0, x1, x2, x3, x4, x5, x6, x7) \
+	vmovdqu (0*16)(src), x0; \
+	vmovdqu (1*16)(src), x1; \
+	vmovdqu (2*16)(src), x2; \
+	vmovdqu (3*16)(src), x3; \
+	vmovdqu (4*16)(src), x4; \
+	vmovdqu (5*16)(src), x5; \
+	vmovdqu (6*16)(src), x6; \
+	vmovdqu (7*16)(src), x7;
+
+#define store_8way(dst, x0, x1, x2, x3, x4, x5, x6, x7) \
+	vmovdqu x0, (0*16)(dst); \
+	vmovdqu x1, (1*16)(dst); \
+	vmovdqu x2, (2*16)(dst); \
+	vmovdqu x3, (3*16)(dst); \
+	vmovdqu x4, (4*16)(dst); \
+	vmovdqu x5, (5*16)(dst); \
+	vmovdqu x6, (6*16)(dst); \
+	vmovdqu x7, (7*16)(dst);
+
+#define store_cbc_8way(src, dst, x0, x1, x2, x3, x4, x5, x6, x7) \
+	vpxor (0*16)(src), x1, x1; \
+	vpxor (1*16)(src), x2, x2; \
+	vpxor (2*16)(src), x3, x3; \
+	vpxor (3*16)(src), x4, x4; \
+	vpxor (4*16)(src), x5, x5; \
+	vpxor (5*16)(src), x6, x6; \
+	vpxor (6*16)(src), x7, x7; \
+	store_8way(dst, x0, x1, x2, x3, x4, x5, x6, x7);
+
+#define inc_le128(x, minus_one, tmp) \
+	vpcmpeqq minus_one, x, tmp; \
+	vpsubq minus_one, x, x; \
+	vpslldq $8, tmp, tmp; \
+	vpsubq tmp, x, x;
+
+#define load_ctr_8way(iv, bswap, x0, x1, x2, x3, x4, x5, x6, x7, t0, t1, t2) \
+	vpcmpeqd t0, t0, t0; \
+	vpsrldq $8, t0, t0; /* low: -1, high: 0 */ \
+	vmovdqa bswap, t1; \
+	\
+	/* load IV and byteswap */ \
+	vmovdqu (iv), x7; \
+	vpshufb t1, x7, x0; \
+	\
+	/* construct IVs */ \
+	inc_le128(x7, t0, t2); \
+	vpshufb t1, x7, x1; \
+	inc_le128(x7, t0, t2); \
+	vpshufb t1, x7, x2; \
+	inc_le128(x7, t0, t2); \
+	vpshufb t1, x7, x3; \
+	inc_le128(x7, t0, t2); \
+	vpshufb t1, x7, x4; \
+	inc_le128(x7, t0, t2); \
+	vpshufb t1, x7, x5; \
+	inc_le128(x7, t0, t2); \
+	vpshufb t1, x7, x6; \
+	inc_le128(x7, t0, t2); \
+	vmovdqa x7, t2; \
+	vpshufb t1, x7, x7; \
+	inc_le128(t2, t0, t1); \
+	vmovdqu t2, (iv);
+
+#define store_ctr_8way(src, dst, x0, x1, x2, x3, x4, x5, x6, x7) \
+	vpxor (0*16)(src), x0, x0; \
+	vpxor (1*16)(src), x1, x1; \
+	vpxor (2*16)(src), x2, x2; \
+	vpxor (3*16)(src), x3, x3; \
+	vpxor (4*16)(src), x4, x4; \
+	vpxor (5*16)(src), x5, x5; \
+	vpxor (6*16)(src), x6, x6; \
+	vpxor (7*16)(src), x7, x7; \
+	store_8way(dst, x0, x1, x2, x3, x4, x5, x6, x7);
