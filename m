From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 3/5] crypto: twofish/avx - avoid using temporary stack buffers
Date: Sat, 20 Oct 2012 15:06:46 +0300
Message-ID: <20121020120646.19422.76908.stgit@localhost6.localdomain6>
References: <20121020120431.19422.17000.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:43745 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163Ab2JTMGu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 20 Oct 2012 08:06:50 -0400
In-Reply-To: <20121020120431.19422.17000.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Introduce new assembler functions to avoid use temporary stack buffers in glue
code. This also allows use of vector instructions for xoring output in CTR and
CBC modes and construction of IVs for CTR mode.

ECB mode sees ~0.2% decrease in speed because added one extra function
call. CBC mode decryption and CTR mode benefit from vector operations
and gain ~3%.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/twofish-avx-x86_64-asm_64.S |  208 ++++++++++++++++++---------
 arch/x86/crypto/twofish_avx_glue.c          |   73 ++-------
 2 files changed, 152 insertions(+), 129 deletions(-)

diff --git a/arch/x86/crypto/twofish-avx-x86_64-asm_64.S b/arch/x86/crypto/twofish-avx-x86_64-asm_64.S
index 1585abb..ebac16b 100644
--- a/arch/x86/crypto/twofish-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/twofish-avx-x86_64-asm_64.S
@@ -23,7 +23,16 @@
  *
  */
 
+#include "glue_helper-asm-avx.S"
+
 .file "twofish-avx-x86_64-asm_64.S"
+
+.data
+.align 16
+
+.Lbswap128_mask:
+	.byte 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0
+
 .text
 
 /* structure of crypto context */
@@ -217,69 +226,45 @@
 	vpunpcklqdq		x3, t2, x2; \
 	vpunpckhqdq		x3, t2, x3;
 
-#define inpack_blocks(in, x0, x1, x2, x3, wkey, t0, t1, t2) \
-	vpxor (0*4*4)(in),	wkey, x0; \
-	vpxor (1*4*4)(in),	wkey, x1; \
-	vpxor (2*4*4)(in),	wkey, x2; \
-	vpxor (3*4*4)(in),	wkey, x3; \
+#define inpack_blocks(x0, x1, x2, x3, wkey, t0, t1, t2) \
+	vpxor		x0, wkey, x0; \
+	vpxor		x1, wkey, x1; \
+	vpxor		x2, wkey, x2; \
+	vpxor		x3, wkey, x3; \
 	\
 	transpose_4x4(x0, x1, x2, x3, t0, t1, t2)
 
-#define outunpack_blocks(out, x0, x1, x2, x3, wkey, t0, t1, t2) \
-	transpose_4x4(x0, x1, x2, x3, t0, t1, t2) \
-	\
-	vpxor		x0, wkey, x0;     \
-	vmovdqu 	x0, (0*4*4)(out); \
-	vpxor		x1, wkey, x1;     \
-	vmovdqu		x1, (1*4*4)(out); \
-	vpxor		x2, wkey, x2;     \
-	vmovdqu		x2, (2*4*4)(out); \
-	vpxor		x3, wkey, x3;     \
-	vmovdqu		x3, (3*4*4)(out);
-
-#define outunpack_xor_blocks(out, x0, x1, x2, x3, wkey, t0, t1, t2) \
+#define outunpack_blocks(x0, x1, x2, x3, wkey, t0, t1, t2) \
 	transpose_4x4(x0, x1, x2, x3, t0, t1, t2) \
 	\
-	vpxor		x0, wkey, x0;         \
-	vpxor		(0*4*4)(out), x0, x0; \
-	vmovdqu 	x0, (0*4*4)(out);     \
-	vpxor		x1, wkey, x1;         \
-	vpxor		(1*4*4)(out), x1, x1; \
-	vmovdqu	        x1, (1*4*4)(out);     \
-	vpxor		x2, wkey, x2;         \
-	vpxor           (2*4*4)(out), x2, x2; \
-	vmovdqu		x2, (2*4*4)(out);     \
-	vpxor		x3, wkey, x3;         \
-	vpxor           (3*4*4)(out), x3, x3; \
-	vmovdqu		x3, (3*4*4)(out);
+	vpxor		x0, wkey, x0; \
+	vpxor		x1, wkey, x1; \
+	vpxor		x2, wkey, x2; \
+	vpxor		x3, wkey, x3;
 
 .align 8
-.global __twofish_enc_blk_8way
-.type   __twofish_enc_blk_8way,@function;
+.type	__twofish_enc_blk8,@function;
 
-__twofish_enc_blk_8way:
+__twofish_enc_blk8:
 	/* input:
 	 *	%rdi: ctx, CTX
-	 *	%rsi: dst
-	 *	%rdx: src
-	 *	%rcx: bool, if true: xor output
+	 *	RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2: blocks
+	 * output:
+	 *	RC1, RD1, RA1, RB1, RC2, RD2, RA2, RB2: encrypted blocks
 	 */
 
+	vmovdqu w(CTX), RK1;
+
 	pushq %rbp;
 	pushq %rbx;
 	pushq %rcx;
 
-	vmovdqu w(CTX), RK1;
-
-	leaq (4*4*4)(%rdx), %rax;
-	inpack_blocks(%rdx, RA1, RB1, RC1, RD1, RK1, RX0, RY0, RK2);
+	inpack_blocks(RA1, RB1, RC1, RD1, RK1, RX0, RY0, RK2);
 	preload_rgi(RA1);
 	rotate_1l(RD1);
-	inpack_blocks(%rax, RA2, RB2, RC2, RD2, RK1, RX0, RY0, RK2);
+	inpack_blocks(RA2, RB2, RC2, RD2, RK1, RX0, RY0, RK2);
 	rotate_1l(RD2);
 
-	movq %rsi, %r11;
-
 	encrypt_cycle(0);
 	encrypt_cycle(1);
 	encrypt_cycle(2);
@@ -295,47 +280,33 @@ __twofish_enc_blk_8way:
 	popq %rbx;
 	popq %rbp;
 
-	leaq (4*4*4)(%r11), %rax;
-
-	testb %cl, %cl;
-	jnz __enc_xor8;
-
-	outunpack_blocks(%r11, RC1, RD1, RA1, RB1, RK1, RX0, RY0, RK2);
-	outunpack_blocks(%rax, RC2, RD2, RA2, RB2, RK1, RX0, RY0, RK2);
-
-	ret;
-
-__enc_xor8:
-	outunpack_xor_blocks(%r11, RC1, RD1, RA1, RB1, RK1, RX0, RY0, RK2);
-	outunpack_xor_blocks(%rax, RC2, RD2, RA2, RB2, RK1, RX0, RY0, RK2);
+	outunpack_blocks(RC1, RD1, RA1, RB1, RK1, RX0, RY0, RK2);
+	outunpack_blocks(RC2, RD2, RA2, RB2, RK1, RX0, RY0, RK2);
 
 	ret;
 
 .align 8
-.global twofish_dec_blk_8way
-.type   twofish_dec_blk_8way,@function;
+.type	__twofish_dec_blk8,@function;
 
-twofish_dec_blk_8way:
+__twofish_dec_blk8:
 	/* input:
 	 *	%rdi: ctx, CTX
-	 *	%rsi: dst
-	 *	%rdx: src
+	 *	RC1, RD1, RA1, RB1, RC2, RD2, RA2, RB2: encrypted blocks
+	 * output:
+	 *	RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2: decrypted blocks
 	 */
 
+	vmovdqu (w+4*4)(CTX), RK1;
+
 	pushq %rbp;
 	pushq %rbx;
 
-	vmovdqu (w+4*4)(CTX), RK1;
-
-	leaq (4*4*4)(%rdx), %rax;
-	inpack_blocks(%rdx, RC1, RD1, RA1, RB1, RK1, RX0, RY0, RK2);
+	inpack_blocks(RC1, RD1, RA1, RB1, RK1, RX0, RY0, RK2);
 	preload_rgi(RC1);
 	rotate_1l(RA1);
-	inpack_blocks(%rax, RC2, RD2, RA2, RB2, RK1, RX0, RY0, RK2);
+	inpack_blocks(RC2, RD2, RA2, RB2, RK1, RX0, RY0, RK2);
 	rotate_1l(RA2);
 
-	movq %rsi, %r11;
-
 	decrypt_cycle(7);
 	decrypt_cycle(6);
 	decrypt_cycle(5);
@@ -350,8 +321,103 @@ twofish_dec_blk_8way:
 	popq %rbx;
 	popq %rbp;
 
-	leaq (4*4*4)(%r11), %rax;
-	outunpack_blocks(%r11, RA1, RB1, RC1, RD1, RK1, RX0, RY0, RK2);
-	outunpack_blocks(%rax, RA2, RB2, RC2, RD2, RK1, RX0, RY0, RK2);
+	outunpack_blocks(RA1, RB1, RC1, RD1, RK1, RX0, RY0, RK2);
+	outunpack_blocks(RA2, RB2, RC2, RD2, RK1, RX0, RY0, RK2);
+
+	ret;
+
+.align 8
+.global twofish_ecb_enc_8way
+.type   twofish_ecb_enc_8way,@function;
+
+twofish_ecb_enc_8way:
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
+	call __twofish_enc_blk8;
+
+	store_8way(%r11, RC1, RD1, RA1, RB1, RC2, RD2, RA2, RB2);
+
+	ret;
+
+.align 8
+.global twofish_ecb_dec_8way
+.type   twofish_ecb_dec_8way,@function;
+
+twofish_ecb_dec_8way:
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst
+	 *	%rdx: src
+	 */
+
+	movq %rsi, %r11;
+
+	load_8way(%rdx, RC1, RD1, RA1, RB1, RC2, RD2, RA2, RB2);
+
+	call __twofish_dec_blk8;
+
+	store_8way(%r11, RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2);
+
+	ret;
+
+.align 8
+.global twofish_cbc_dec_8way
+.type   twofish_cbc_dec_8way,@function;
+
+twofish_cbc_dec_8way:
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
+	load_8way(%rdx, RC1, RD1, RA1, RB1, RC2, RD2, RA2, RB2);
+
+	call __twofish_dec_blk8;
+
+	store_cbc_8way(%r12, %r11, RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2);
+
+	popq %r12;
+
+	ret;
+
+.align 8
+.global twofish_ctr_8way
+.type   twofish_ctr_8way,@function;
+
+twofish_ctr_8way:
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
+		      RD2, RX0, RX1, RY0);
+
+	call __twofish_enc_blk8;
+
+	store_ctr_8way(%r12, %r11, RC1, RD1, RA1, RB1, RC2, RD2, RA2, RB2);
+
+	popq %r12;
 
 	ret;
diff --git a/arch/x86/crypto/twofish_avx_glue.c b/arch/x86/crypto/twofish_avx_glue.c
index 810e45d..94ac91d 100644
--- a/arch/x86/crypto/twofish_avx_glue.c
+++ b/arch/x86/crypto/twofish_avx_glue.c
@@ -45,66 +45,23 @@
 
 #define TWOFISH_PARALLEL_BLOCKS 8
 
-static inline void twofish_enc_blk_3way(struct twofish_ctx *ctx, u8 *dst,
-					const u8 *src)
-{
-	__twofish_enc_blk_3way(ctx, dst, src, false);
-}
-
 /* 8-way parallel cipher functions */
-asmlinkage void __twofish_enc_blk_8way(struct twofish_ctx *ctx, u8 *dst,
-				       const u8 *src, bool xor);
-asmlinkage void twofish_dec_blk_8way(struct twofish_ctx *ctx, u8 *dst,
+asmlinkage void twofish_ecb_enc_8way(struct twofish_ctx *ctx, u8 *dst,
+				     const u8 *src);
+asmlinkage void twofish_ecb_dec_8way(struct twofish_ctx *ctx, u8 *dst,
 				     const u8 *src);
 
-static inline void twofish_enc_blk_xway(struct twofish_ctx *ctx, u8 *dst,
-					const u8 *src)
-{
-	__twofish_enc_blk_8way(ctx, dst, src, false);
-}
-
-static inline void twofish_enc_blk_xway_xor(struct twofish_ctx *ctx, u8 *dst,
-					    const u8 *src)
-{
-	__twofish_enc_blk_8way(ctx, dst, src, true);
-}
+asmlinkage void twofish_cbc_dec_8way(struct twofish_ctx *ctx, u8 *dst,
+				     const u8 *src);
+asmlinkage void twofish_ctr_8way(struct twofish_ctx *ctx, u8 *dst,
+				 const u8 *src, le128 *iv);
 
-static inline void twofish_dec_blk_xway(struct twofish_ctx *ctx, u8 *dst,
+static inline void twofish_enc_blk_3way(struct twofish_ctx *ctx, u8 *dst,
 					const u8 *src)
 {
-	twofish_dec_blk_8way(ctx, dst, src);
-}
-
-static void twofish_dec_blk_cbc_xway(void *ctx, u128 *dst, const u128 *src)
-{
-	u128 ivs[TWOFISH_PARALLEL_BLOCKS - 1];
-	unsigned int j;
-
-	for (j = 0; j < TWOFISH_PARALLEL_BLOCKS - 1; j++)
-		ivs[j] = src[j];
-
-	twofish_dec_blk_xway(ctx, (u8 *)dst, (u8 *)src);
-
-	for (j = 0; j < TWOFISH_PARALLEL_BLOCKS - 1; j++)
-		u128_xor(dst + (j + 1), dst + (j + 1), ivs + j);
+	__twofish_enc_blk_3way(ctx, dst, src, false);
 }
 
-static void twofish_enc_blk_ctr_xway(void *ctx, u128 *dst, const u128 *src,
-				     le128 *iv)
-{
-	be128 ctrblks[TWOFISH_PARALLEL_BLOCKS];
-	unsigned int i;
-
-	for (i = 0; i < TWOFISH_PARALLEL_BLOCKS; i++) {
-		if (dst != src)
-			dst[i] = src[i];
-
-		le128_to_be128(&ctrblks[i], iv);
-		le128_inc(iv);
-	}
-
-	twofish_enc_blk_xway_xor(ctx, (u8 *)dst, (u8 *)ctrblks);
-}
 
 static const struct common_glue_ctx twofish_enc = {
 	.num_funcs = 3,
@@ -112,7 +69,7 @@ static const struct common_glue_ctx twofish_enc = {
 
 	.funcs = { {
 		.num_blocks = TWOFISH_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_enc_blk_xway) }
+		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_ecb_enc_8way) }
 	}, {
 		.num_blocks = 3,
 		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_enc_blk_3way) }
@@ -128,7 +85,7 @@ static const struct common_glue_ctx twofish_ctr = {
 
 	.funcs = { {
 		.num_blocks = TWOFISH_PARALLEL_BLOCKS,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(twofish_enc_blk_ctr_xway) }
+		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(twofish_ctr_8way) }
 	}, {
 		.num_blocks = 3,
 		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(twofish_enc_blk_ctr_3way) }
@@ -144,7 +101,7 @@ static const struct common_glue_ctx twofish_dec = {
 
 	.funcs = { {
 		.num_blocks = TWOFISH_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_dec_blk_xway) }
+		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_ecb_dec_8way) }
 	}, {
 		.num_blocks = 3,
 		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_dec_blk_3way) }
@@ -160,7 +117,7 @@ static const struct common_glue_ctx twofish_dec_cbc = {
 
 	.funcs = { {
 		.num_blocks = TWOFISH_PARALLEL_BLOCKS,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(twofish_dec_blk_cbc_xway) }
+		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(twofish_cbc_dec_8way) }
 	}, {
 		.num_blocks = 3,
 		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(twofish_dec_blk_cbc_3way) }
@@ -227,7 +184,7 @@ static void encrypt_callback(void *priv, u8 *srcdst, unsigned int nbytes)
 	ctx->fpu_enabled = twofish_fpu_begin(ctx->fpu_enabled, nbytes);
 
 	if (nbytes == bsize * TWOFISH_PARALLEL_BLOCKS) {
-		twofish_enc_blk_xway(ctx->ctx, srcdst, srcdst);
+		twofish_ecb_enc_8way(ctx->ctx, srcdst, srcdst);
 		return;
 	}
 
@@ -249,7 +206,7 @@ static void decrypt_callback(void *priv, u8 *srcdst, unsigned int nbytes)
 	ctx->fpu_enabled = twofish_fpu_begin(ctx->fpu_enabled, nbytes);
 
 	if (nbytes == bsize * TWOFISH_PARALLEL_BLOCKS) {
-		twofish_dec_blk_xway(ctx->ctx, srcdst, srcdst);
+		twofish_ecb_dec_8way(ctx->ctx, srcdst, srcdst);
 		return;
 	}
 
