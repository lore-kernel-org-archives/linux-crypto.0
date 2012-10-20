From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 4/5] crypto: serpent/avx - avoid using temporary stack buffers
Date: Sat, 20 Oct 2012 15:06:51 +0300
Message-ID: <20121020120651.19422.8156.stgit@localhost6.localdomain6>
References: <20121020120431.19422.17000.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:56145 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163Ab2JTMG4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 20 Oct 2012 08:06:56 -0400
In-Reply-To: <20121020120431.19422.17000.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Introduce new assembler functions to avoid use temporary stack buffers in glue
code. This also allows use of vector instructions for xoring output in CTR and
CBC modes and construction of IVs for CTR mode.

ECB mode sees ~0.5% decrease in speed because added one extra function
call. CBC mode decryption and CTR mode benefit from vector operations
and gain ~3%.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/serpent-avx-x86_64-asm_64.S |  166 ++++++++++++++++++---------
 arch/x86/crypto/serpent_avx_glue.c          |   43 +------
 arch/x86/include/asm/crypto/serpent-avx.h   |   27 +---
 3 files changed, 121 insertions(+), 115 deletions(-)

diff --git a/arch/x86/crypto/serpent-avx-x86_64-asm_64.S b/arch/x86/crypto/serpent-avx-x86_64-asm_64.S
index 504106b..02b0e9f 100644
--- a/arch/x86/crypto/serpent-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/serpent-avx-x86_64-asm_64.S
@@ -24,7 +24,16 @@
  *
  */
 
+#include "glue_helper-asm-avx.S"
+
 .file "serpent-avx-x86_64-asm_64.S"
+
+.data
+.align 16
+
+.Lbswap128_mask:
+	.byte 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0
+
 .text
 
 #define CTX %rdi
@@ -550,51 +559,27 @@
 	vpunpcklqdq		x3, t2, x2; \
 	vpunpckhqdq		x3, t2, x3;
 
-#define read_blocks(in, x0, x1, x2, x3, t0, t1, t2) \
-	vmovdqu (0*4*4)(in),	x0; \
-	vmovdqu (1*4*4)(in),	x1; \
-	vmovdqu (2*4*4)(in),	x2; \
-	vmovdqu (3*4*4)(in),	x3; \
-	\
+#define read_blocks(x0, x1, x2, x3, t0, t1, t2) \
 	transpose_4x4(x0, x1, x2, x3, t0, t1, t2)
 
-#define write_blocks(out, x0, x1, x2, x3, t0, t1, t2) \
-	transpose_4x4(x0, x1, x2, x3, t0, t1, t2) \
-	\
-	vmovdqu x0,		(0*4*4)(out); \
-	vmovdqu x1,		(1*4*4)(out); \
-	vmovdqu x2,		(2*4*4)(out); \
-	vmovdqu x3,		(3*4*4)(out);
-
-#define xor_blocks(out, x0, x1, x2, x3, t0, t1, t2) \
-	transpose_4x4(x0, x1, x2, x3, t0, t1, t2) \
-	\
-	vpxor (0*4*4)(out),	x0, x0;       \
-	vmovdqu x0,		(0*4*4)(out); \
-	vpxor (1*4*4)(out),	x1, x1;       \
-	vmovdqu x1,		(1*4*4)(out); \
-	vpxor (2*4*4)(out),	x2, x2;       \
-	vmovdqu x2,		(2*4*4)(out); \
-	vpxor (3*4*4)(out),	x3, x3;       \
-	vmovdqu x3,		(3*4*4)(out);
+#define write_blocks(x0, x1, x2, x3, t0, t1, t2) \
+	transpose_4x4(x0, x1, x2, x3, t0, t1, t2)
 
 .align 8
-.global __serpent_enc_blk_8way_avx
-.type   __serpent_enc_blk_8way_avx,@function;
+.type   __serpent_enc_blk8_avx,@function;
 
-__serpent_enc_blk_8way_avx:
+__serpent_enc_blk8_avx:
 	/* input:
 	 *	%rdi: ctx, CTX
-	 *	%rsi: dst
-	 *	%rdx: src
-	 *	%rcx: bool, if true: xor output
+	 *	RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2: blocks
+	 * output:
+	 *	RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2: encrypted blocks
 	 */
 
 	vpcmpeqd RNOT, RNOT, RNOT;
 
-	leaq (4*4*4)(%rdx), %rax;
-	read_blocks(%rdx, RA1, RB1, RC1, RD1, RK0, RK1, RK2);
-	read_blocks(%rax, RA2, RB2, RC2, RD2, RK0, RK1, RK2);
+	read_blocks(RA1, RB1, RC1, RD1, RK0, RK1, RK2);
+	read_blocks(RA2, RB2, RC2, RD2, RK0, RK1, RK2);
 
 						 K2(RA, RB, RC, RD, RE, 0);
 	S(S0, RA, RB, RC, RD, RE);		LK2(RC, RB, RD, RA, RE, 1);
@@ -630,38 +615,26 @@ __serpent_enc_blk_8way_avx:
 	S(S6, RA, RB, RD, RC, RE);		LK2(RD, RE, RB, RC, RA, 31);
 	S(S7, RD, RE, RB, RC, RA);		 K2(RA, RB, RC, RD, RE, 32);
 
-	leaq (4*4*4)(%rsi), %rax;
-
-	testb %cl, %cl;
-	jnz __enc_xor8;
-
-	write_blocks(%rsi, RA1, RB1, RC1, RD1, RK0, RK1, RK2);
-	write_blocks(%rax, RA2, RB2, RC2, RD2, RK0, RK1, RK2);
-
-	ret;
-
-__enc_xor8:
-	xor_blocks(%rsi, RA1, RB1, RC1, RD1, RK0, RK1, RK2);
-	xor_blocks(%rax, RA2, RB2, RC2, RD2, RK0, RK1, RK2);
+	write_blocks(RA1, RB1, RC1, RD1, RK0, RK1, RK2);
+	write_blocks(RA2, RB2, RC2, RD2, RK0, RK1, RK2);
 
 	ret;
 
 .align 8
-.global serpent_dec_blk_8way_avx
-.type   serpent_dec_blk_8way_avx,@function;
+.type   __serpent_dec_blk8_avx,@function;
 
-serpent_dec_blk_8way_avx:
+__serpent_dec_blk8_avx:
 	/* input:
 	 *	%rdi: ctx, CTX
-	 *	%rsi: dst
-	 *	%rdx: src
+	 *	RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2: encrypted blocks
+	 * output:
+	 *	RC1, RD1, RB1, RE1, RC2, RD2, RB2, RE2: decrypted blocks
 	 */
 
 	vpcmpeqd RNOT, RNOT, RNOT;
 
-	leaq (4*4*4)(%rdx), %rax;
-	read_blocks(%rdx, RA1, RB1, RC1, RD1, RK0, RK1, RK2);
-	read_blocks(%rax, RA2, RB2, RC2, RD2, RK0, RK1, RK2);
+	read_blocks(RA1, RB1, RC1, RD1, RK0, RK1, RK2);
+	read_blocks(RA2, RB2, RC2, RD2, RK0, RK1, RK2);
 
 						 K2(RA, RB, RC, RD, RE, 32);
 	SP(SI7, RA, RB, RC, RD, RE, 31);	KL2(RB, RD, RA, RE, RC, 31);
@@ -697,8 +670,85 @@ serpent_dec_blk_8way_avx:
 	SP(SI1, RD, RB, RC, RA, RE, 1);		KL2(RE, RB, RC, RA, RD, 1);
 	S(SI0, RE, RB, RC, RA, RD);		 K2(RC, RD, RB, RE, RA, 0);
 
-	leaq (4*4*4)(%rsi), %rax;
-	write_blocks(%rsi, RC1, RD1, RB1, RE1, RK0, RK1, RK2);
-	write_blocks(%rax, RC2, RD2, RB2, RE2, RK0, RK1, RK2);
+	write_blocks(RC1, RD1, RB1, RE1, RK0, RK1, RK2);
+	write_blocks(RC2, RD2, RB2, RE2, RK0, RK1, RK2);
+
+	ret;
+
+.align 8
+.global serpent_ecb_enc_8way_avx
+.type   serpent_ecb_enc_8way_avx,@function;
+
+serpent_ecb_enc_8way_avx:
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst
+	 *	%rdx: src
+	 */
+
+	load_8way(%rdx, RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2);
+
+	call __serpent_enc_blk8_avx;
+
+	store_8way(%rsi, RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2);
+
+	ret;
+
+.align 8
+.global serpent_ecb_dec_8way_avx
+.type   serpent_ecb_dec_8way_avx,@function;
+
+serpent_ecb_dec_8way_avx:
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst
+	 *	%rdx: src
+	 */
+
+	load_8way(%rdx, RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2);
+
+	call __serpent_dec_blk8_avx;
+
+	store_8way(%rsi, RC1, RD1, RB1, RE1, RC2, RD2, RB2, RE2);
+
+	ret;
+
+.align 8
+.global serpent_cbc_dec_8way_avx
+.type   serpent_cbc_dec_8way_avx,@function;
+
+serpent_cbc_dec_8way_avx:
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst
+	 *	%rdx: src
+	 */
+
+	load_8way(%rdx, RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2);
+
+	call __serpent_dec_blk8_avx;
+
+	store_cbc_8way(%rdx, %rsi, RC1, RD1, RB1, RE1, RC2, RD2, RB2, RE2);
+
+	ret;
+
+.align 8
+.global serpent_ctr_8way_avx
+.type   serpent_ctr_8way_avx,@function;
+
+serpent_ctr_8way_avx:
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst
+	 *	%rdx: src
+	 *	%rcx: iv (little endian, 128bit)
+	 */
+
+	load_ctr_8way(%rcx, .Lbswap128_mask, RA1, RB1, RC1, RD1, RA2, RB2, RC2,
+		      RD2, RK0, RK1, RK2);
+
+	call __serpent_enc_blk8_avx;
+
+	store_ctr_8way(%rdx, %rsi, RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2);
 
 	ret;
diff --git a/arch/x86/crypto/serpent_avx_glue.c b/arch/x86/crypto/serpent_avx_glue.c
index 2aa31ad..52abaaf 100644
--- a/arch/x86/crypto/serpent_avx_glue.c
+++ b/arch/x86/crypto/serpent_avx_glue.c
@@ -42,20 +42,6 @@
 #include <asm/crypto/ablk_helper.h>
 #include <asm/crypto/glue_helper.h>
 
-static void serpent_decrypt_cbc_xway(void *ctx, u128 *dst, const u128 *src)
-{
-	u128 ivs[SERPENT_PARALLEL_BLOCKS - 1];
-	unsigned int j;
-
-	for (j = 0; j < SERPENT_PARALLEL_BLOCKS - 1; j++)
-		ivs[j] = src[j];
-
-	serpent_dec_blk_xway(ctx, (u8 *)dst, (u8 *)src);
-
-	for (j = 0; j < SERPENT_PARALLEL_BLOCKS - 1; j++)
-		u128_xor(dst + (j + 1), dst + (j + 1), ivs + j);
-}
-
 static void serpent_crypt_ctr(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 {
 	be128 ctrblk;
@@ -67,30 +53,13 @@ static void serpent_crypt_ctr(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 	u128_xor(dst, src, (u128 *)&ctrblk);
 }
 
-static void serpent_crypt_ctr_xway(void *ctx, u128 *dst, const u128 *src,
-				   le128 *iv)
-{
-	be128 ctrblks[SERPENT_PARALLEL_BLOCKS];
-	unsigned int i;
-
-	for (i = 0; i < SERPENT_PARALLEL_BLOCKS; i++) {
-		if (dst != src)
-			dst[i] = src[i];
-
-		le128_to_be128(&ctrblks[i], iv);
-		le128_inc(iv);
-	}
-
-	serpent_enc_blk_xway_xor(ctx, (u8 *)dst, (u8 *)ctrblks);
-}
-
 static const struct common_glue_ctx serpent_enc = {
 	.num_funcs = 2,
 	.fpu_blocks_limit = SERPENT_PARALLEL_BLOCKS,
 
 	.funcs = { {
 		.num_blocks = SERPENT_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(serpent_enc_blk_xway) }
+		.fn_u = { .ecb = GLUE_FUNC_CAST(serpent_ecb_enc_8way_avx) }
 	}, {
 		.num_blocks = 1,
 		.fn_u = { .ecb = GLUE_FUNC_CAST(__serpent_encrypt) }
@@ -103,7 +72,7 @@ static const struct common_glue_ctx serpent_ctr = {
 
 	.funcs = { {
 		.num_blocks = SERPENT_PARALLEL_BLOCKS,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(serpent_crypt_ctr_xway) }
+		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(serpent_ctr_8way_avx) }
 	}, {
 		.num_blocks = 1,
 		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(serpent_crypt_ctr) }
@@ -116,7 +85,7 @@ static const struct common_glue_ctx serpent_dec = {
 
 	.funcs = { {
 		.num_blocks = SERPENT_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(serpent_dec_blk_xway) }
+		.fn_u = { .ecb = GLUE_FUNC_CAST(serpent_ecb_dec_8way_avx) }
 	}, {
 		.num_blocks = 1,
 		.fn_u = { .ecb = GLUE_FUNC_CAST(__serpent_decrypt) }
@@ -129,7 +98,7 @@ static const struct common_glue_ctx serpent_dec_cbc = {
 
 	.funcs = { {
 		.num_blocks = SERPENT_PARALLEL_BLOCKS,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(serpent_decrypt_cbc_xway) }
+		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(serpent_cbc_dec_8way_avx) }
 	}, {
 		.num_blocks = 1,
 		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(__serpent_decrypt) }
@@ -193,7 +162,7 @@ static void encrypt_callback(void *priv, u8 *srcdst, unsigned int nbytes)
 	ctx->fpu_enabled = serpent_fpu_begin(ctx->fpu_enabled, nbytes);
 
 	if (nbytes == bsize * SERPENT_PARALLEL_BLOCKS) {
-		serpent_enc_blk_xway(ctx->ctx, srcdst, srcdst);
+		serpent_ecb_enc_8way_avx(ctx->ctx, srcdst, srcdst);
 		return;
 	}
 
@@ -210,7 +179,7 @@ static void decrypt_callback(void *priv, u8 *srcdst, unsigned int nbytes)
 	ctx->fpu_enabled = serpent_fpu_begin(ctx->fpu_enabled, nbytes);
 
 	if (nbytes == bsize * SERPENT_PARALLEL_BLOCKS) {
-		serpent_dec_blk_xway(ctx->ctx, srcdst, srcdst);
+		serpent_ecb_dec_8way_avx(ctx->ctx, srcdst, srcdst);
 		return;
 	}
 
diff --git a/arch/x86/include/asm/crypto/serpent-avx.h b/arch/x86/include/asm/crypto/serpent-avx.h
index 432deed..0da1d3e 100644
--- a/arch/x86/include/asm/crypto/serpent-avx.h
+++ b/arch/x86/include/asm/crypto/serpent-avx.h
@@ -6,27 +6,14 @@
 
 #define SERPENT_PARALLEL_BLOCKS 8
 
-asmlinkage void __serpent_enc_blk_8way_avx(struct serpent_ctx *ctx, u8 *dst,
-					   const u8 *src, bool xor);
-asmlinkage void serpent_dec_blk_8way_avx(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage void serpent_ecb_enc_8way_avx(struct serpent_ctx *ctx, u8 *dst,
+					 const u8 *src);
+asmlinkage void serpent_ecb_dec_8way_avx(struct serpent_ctx *ctx, u8 *dst,
 					 const u8 *src);
 
-static inline void serpent_enc_blk_xway(struct serpent_ctx *ctx, u8 *dst,
-				   const u8 *src)
-{
-	__serpent_enc_blk_8way_avx(ctx, dst, src, false);
-}
-
-static inline void serpent_enc_blk_xway_xor(struct serpent_ctx *ctx, u8 *dst,
-				       const u8 *src)
-{
-	__serpent_enc_blk_8way_avx(ctx, dst, src, true);
-}
-
-static inline void serpent_dec_blk_xway(struct serpent_ctx *ctx, u8 *dst,
-				   const u8 *src)
-{
-	serpent_dec_blk_8way_avx(ctx, dst, src);
-}
+asmlinkage void serpent_cbc_dec_8way_avx(struct serpent_ctx *ctx, u8 *dst,
+					 const u8 *src);
+asmlinkage void serpent_ctr_8way_avx(struct serpent_ctx *ctx, u8 *dst,
+				     const u8 *src, le128 *iv);
 
 #endif
