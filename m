From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 5/5] crypto: cast5/avx - avoid using temporary stack buffers
Date: Sat, 20 Oct 2012 15:06:56 +0300
Message-ID: <20121020120656.19422.83543.stgit@localhost6.localdomain6>
References: <20121020120431.19422.17000.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:43768 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352Ab2JTMHA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 20 Oct 2012 08:07:00 -0400
In-Reply-To: <20121020120431.19422.17000.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Introduce new assembler functions to avoid use temporary stack buffers in glue
code. This also allows use of vector instructions for xoring output in CTR and
CBC modes and construction of IVs for CTR mode.

ECB mode sees ~0.5% decrease in speed because added one extra function
call. CBC mode decryption and CTR mode benefit from vector operations
and gain ~5%.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/cast5-avx-x86_64-asm_64.S |  332 ++++++++++++++++++++++-------
 arch/x86/crypto/cast5_avx_glue.c          |   79 ++-----
 2 files changed, 280 insertions(+), 131 deletions(-)

diff --git a/arch/x86/crypto/cast5-avx-x86_64-asm_64.S b/arch/x86/crypto/cast5-avx-x86_64-asm_64.S
index a41a3aa..12478e4 100644
--- a/arch/x86/crypto/cast5-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/cast5-avx-x86_64-asm_64.S
@@ -180,31 +180,17 @@
 	vpunpcklqdq		t1, t0, x0; \
 	vpunpckhqdq		t1, t0, x1;
 
-#define inpack_blocks(in, x0, x1, t0, t1, rmask) \
-	vmovdqu (0*4*4)(in),	x0; \
-	vmovdqu (1*4*4)(in),	x1; \
+#define inpack_blocks(x0, x1, t0, t1, rmask) \
 	vpshufb rmask, 	x0,	x0; \
 	vpshufb rmask, 	x1,	x1; \
 	\
 	transpose_2x4(x0, x1, t0, t1)
 
-#define outunpack_blocks(out, x0, x1, t0, t1, rmask) \
+#define outunpack_blocks(x0, x1, t0, t1, rmask) \
 	transpose_2x4(x0, x1, t0, t1) \
 	\
 	vpshufb rmask,	x0, x0;           \
-	vpshufb rmask,	x1, x1;           \
-	vmovdqu 	x0, (0*4*4)(out); \
-	vmovdqu		x1, (1*4*4)(out);
-
-#define outunpack_xor_blocks(out, x0, x1, t0, t1, rmask) \
-	transpose_2x4(x0, x1, t0, t1) \
-	\
-	vpshufb rmask,	x0, x0;               \
-	vpshufb rmask,	x1, x1;               \
-	vpxor		(0*4*4)(out), x0, x0; \
-	vmovdqu 	x0, (0*4*4)(out);     \
-	vpxor		(1*4*4)(out), x1, x1; \
-	vmovdqu	        x1, (1*4*4)(out);
+	vpshufb rmask,	x1, x1;
 
 .data
 
@@ -213,6 +199,8 @@
 	.byte 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12
 .Lbswap128_mask:
 	.byte 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0
+.Lbswap_iv_mask:
+	.byte 7, 6, 5, 4, 3, 2, 1, 0, 7, 6, 5, 4, 3, 2, 1, 0
 .L16_mask:
 	.byte 16, 16, 16, 16
 .L32_mask:
@@ -223,35 +211,42 @@
 .text
 
 .align 16
-.global __cast5_enc_blk_16way
-.type   __cast5_enc_blk_16way,@function;
+.type   __cast5_enc_blk16,@function;
 
-__cast5_enc_blk_16way:
+__cast5_enc_blk16:
 	/* input:
 	 *	%rdi: ctx, CTX
-	 *	%rsi: dst
-	 *	%rdx: src
-	 *	%rcx: bool, if true: xor output
+	 *	RL1: blocks 1 and 2
+	 *	RR1: blocks 3 and 4
+	 *	RL2: blocks 5 and 6
+	 *	RR2: blocks 7 and 8
+	 *	RL3: blocks 9 and 10
+	 *	RR3: blocks 11 and 12
+	 *	RL4: blocks 13 and 14
+	 *	RR4: blocks 15 and 16
+	 * output:
+	 *	RL1: encrypted blocks 1 and 2
+	 *	RR1: encrypted blocks 3 and 4
+	 *	RL2: encrypted blocks 5 and 6
+	 *	RR2: encrypted blocks 7 and 8
+	 *	RL3: encrypted blocks 9 and 10
+	 *	RR3: encrypted blocks 11 and 12
+	 *	RL4: encrypted blocks 13 and 14
+	 *	RR4: encrypted blocks 15 and 16
 	 */
 
 	pushq %rbp;
 	pushq %rbx;
-	pushq %rcx;
 
 	vmovdqa .Lbswap_mask, RKM;
 	vmovd .Lfirst_mask, R1ST;
 	vmovd .L32_mask, R32;
 	enc_preload_rkr();
 
-	leaq 1*(2*4*4)(%rdx), %rax;
-	inpack_blocks(%rdx, RL1, RR1, RTMP, RX, RKM);
-	inpack_blocks(%rax, RL2, RR2, RTMP, RX, RKM);
-	leaq 2*(2*4*4)(%rdx), %rax;
-	inpack_blocks(%rax, RL3, RR3, RTMP, RX, RKM);
-	leaq 3*(2*4*4)(%rdx), %rax;
-	inpack_blocks(%rax, RL4, RR4, RTMP, RX, RKM);
-
-	movq %rsi, %r11;
+	inpack_blocks(RL1, RR1, RTMP, RX, RKM);
+	inpack_blocks(RL2, RR2, RTMP, RX, RKM);
+	inpack_blocks(RL3, RR3, RTMP, RX, RKM);
+	inpack_blocks(RL4, RR4, RTMP, RX, RKM);
 
 	round(RL, RR, 0, 1);
 	round(RR, RL, 1, 2);
@@ -276,44 +271,41 @@ __cast5_enc_blk_16way:
 	round(RR, RL, 15, 1);
 
 __skip_enc:
-	popq %rcx;
 	popq %rbx;
 	popq %rbp;
 
 	vmovdqa .Lbswap_mask, RKM;
-	leaq 1*(2*4*4)(%r11), %rax;
 
-	testb %cl, %cl;
-	jnz __enc_xor16;
-
-	outunpack_blocks(%r11, RR1, RL1, RTMP, RX, RKM);
-	outunpack_blocks(%rax, RR2, RL2, RTMP, RX, RKM);
-	leaq 2*(2*4*4)(%r11), %rax;
-	outunpack_blocks(%rax, RR3, RL3, RTMP, RX, RKM);
-	leaq 3*(2*4*4)(%r11), %rax;
-	outunpack_blocks(%rax, RR4, RL4, RTMP, RX, RKM);
-
-	ret;
-
-__enc_xor16:
-	outunpack_xor_blocks(%r11, RR1, RL1, RTMP, RX, RKM);
-	outunpack_xor_blocks(%rax, RR2, RL2, RTMP, RX, RKM);
-	leaq 2*(2*4*4)(%r11), %rax;
-	outunpack_xor_blocks(%rax, RR3, RL3, RTMP, RX, RKM);
-	leaq 3*(2*4*4)(%r11), %rax;
-	outunpack_xor_blocks(%rax, RR4, RL4, RTMP, RX, RKM);
+	outunpack_blocks(RR1, RL1, RTMP, RX, RKM);
+	outunpack_blocks(RR2, RL2, RTMP, RX, RKM);
+	outunpack_blocks(RR3, RL3, RTMP, RX, RKM);
+	outunpack_blocks(RR4, RL4, RTMP, RX, RKM);
 
 	ret;
 
 .align 16
-.global cast5_dec_blk_16way
-.type   cast5_dec_blk_16way,@function;
+.type   __cast5_dec_blk16,@function;
 
-cast5_dec_blk_16way:
+__cast5_dec_blk16:
 	/* input:
 	 *	%rdi: ctx, CTX
-	 *	%rsi: dst
-	 *	%rdx: src
+	 *	RL1: encrypted blocks 1 and 2
+	 *	RR1: encrypted blocks 3 and 4
+	 *	RL2: encrypted blocks 5 and 6
+	 *	RR2: encrypted blocks 7 and 8
+	 *	RL3: encrypted blocks 9 and 10
+	 *	RR3: encrypted blocks 11 and 12
+	 *	RL4: encrypted blocks 13 and 14
+	 *	RR4: encrypted blocks 15 and 16
+	 * output:
+	 *	RL1: decrypted blocks 1 and 2
+	 *	RR1: decrypted blocks 3 and 4
+	 *	RL2: decrypted blocks 5 and 6
+	 *	RR2: decrypted blocks 7 and 8
+	 *	RL3: decrypted blocks 9 and 10
+	 *	RR3: decrypted blocks 11 and 12
+	 *	RL4: decrypted blocks 13 and 14
+	 *	RR4: decrypted blocks 15 and 16
 	 */
 
 	pushq %rbp;
@@ -324,15 +316,10 @@ cast5_dec_blk_16way:
 	vmovd .L32_mask, R32;
 	dec_preload_rkr();
 
-	leaq 1*(2*4*4)(%rdx), %rax;
-	inpack_blocks(%rdx, RL1, RR1, RTMP, RX, RKM);
-	inpack_blocks(%rax, RL2, RR2, RTMP, RX, RKM);
-	leaq 2*(2*4*4)(%rdx), %rax;
-	inpack_blocks(%rax, RL3, RR3, RTMP, RX, RKM);
-	leaq 3*(2*4*4)(%rdx), %rax;
-	inpack_blocks(%rax, RL4, RR4, RTMP, RX, RKM);
-
-	movq %rsi, %r11;
+	inpack_blocks(RL1, RR1, RTMP, RX, RKM);
+	inpack_blocks(RL2, RR2, RTMP, RX, RKM);
+	inpack_blocks(RL3, RR3, RTMP, RX, RKM);
+	inpack_blocks(RL4, RR4, RTMP, RX, RKM);
 
 	movzbl rr(CTX), %eax;
 	testl %eax, %eax;
@@ -361,16 +348,211 @@ __dec_tail:
 	popq %rbx;
 	popq %rbp;
 
-	leaq 1*(2*4*4)(%r11), %rax;
-	outunpack_blocks(%r11, RR1, RL1, RTMP, RX, RKM);
-	outunpack_blocks(%rax, RR2, RL2, RTMP, RX, RKM);
-	leaq 2*(2*4*4)(%r11), %rax;
-	outunpack_blocks(%rax, RR3, RL3, RTMP, RX, RKM);
-	leaq 3*(2*4*4)(%r11), %rax;
-	outunpack_blocks(%rax, RR4, RL4, RTMP, RX, RKM);
+	outunpack_blocks(RR1, RL1, RTMP, RX, RKM);
+	outunpack_blocks(RR2, RL2, RTMP, RX, RKM);
+	outunpack_blocks(RR3, RL3, RTMP, RX, RKM);
+	outunpack_blocks(RR4, RL4, RTMP, RX, RKM);
 
 	ret;
 
 __skip_dec:
 	vpsrldq $4, RKR, RKR;
 	jmp __dec_tail;
+
+.align 16
+.global cast5_ecb_enc_16way
+.type   cast5_ecb_enc_16way,@function;
+
+cast5_ecb_enc_16way:
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst
+	 *	%rdx: src
+	 */
+
+	movq %rsi, %r11;
+
+	vmovdqu (0*4*4)(%rdx), RL1;
+	vmovdqu (1*4*4)(%rdx), RR1;
+	vmovdqu (2*4*4)(%rdx), RL2;
+	vmovdqu (3*4*4)(%rdx), RR2;
+	vmovdqu (4*4*4)(%rdx), RL3;
+	vmovdqu (5*4*4)(%rdx), RR3;
+	vmovdqu (6*4*4)(%rdx), RL4;
+	vmovdqu (7*4*4)(%rdx), RR4;
+
+	call __cast5_enc_blk16;
+
+	vmovdqu RR1, (0*4*4)(%r11);
+	vmovdqu RL1, (1*4*4)(%r11);
+	vmovdqu RR2, (2*4*4)(%r11);
+	vmovdqu RL2, (3*4*4)(%r11);
+	vmovdqu RR3, (4*4*4)(%r11);
+	vmovdqu RL3, (5*4*4)(%r11);
+	vmovdqu RR4, (6*4*4)(%r11);
+	vmovdqu RL4, (7*4*4)(%r11);
+
+	ret;
+
+.align 16
+.global cast5_ecb_dec_16way
+.type   cast5_ecb_dec_16way,@function;
+
+cast5_ecb_dec_16way:
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst
+	 *	%rdx: src
+	 */
+
+	movq %rsi, %r11;
+
+	vmovdqu (0*4*4)(%rdx), RL1;
+	vmovdqu (1*4*4)(%rdx), RR1;
+	vmovdqu (2*4*4)(%rdx), RL2;
+	vmovdqu (3*4*4)(%rdx), RR2;
+	vmovdqu (4*4*4)(%rdx), RL3;
+	vmovdqu (5*4*4)(%rdx), RR3;
+	vmovdqu (6*4*4)(%rdx), RL4;
+	vmovdqu (7*4*4)(%rdx), RR4;
+
+	call __cast5_dec_blk16;
+
+	vmovdqu RR1, (0*4*4)(%r11);
+	vmovdqu RL1, (1*4*4)(%r11);
+	vmovdqu RR2, (2*4*4)(%r11);
+	vmovdqu RL2, (3*4*4)(%r11);
+	vmovdqu RR3, (4*4*4)(%r11);
+	vmovdqu RL3, (5*4*4)(%r11);
+	vmovdqu RR4, (6*4*4)(%r11);
+	vmovdqu RL4, (7*4*4)(%r11);
+
+	ret;
+
+.align 16
+.global cast5_cbc_dec_16way
+.type   cast5_cbc_dec_16way,@function;
+
+cast5_cbc_dec_16way:
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
+	vmovdqu (0*16)(%rdx), RL1;
+	vmovdqu (1*16)(%rdx), RR1;
+	vmovdqu (2*16)(%rdx), RL2;
+	vmovdqu (3*16)(%rdx), RR2;
+	vmovdqu (4*16)(%rdx), RL3;
+	vmovdqu (5*16)(%rdx), RR3;
+	vmovdqu (6*16)(%rdx), RL4;
+	vmovdqu (7*16)(%rdx), RR4;
+
+	call __cast5_dec_blk16;
+
+	/* xor with src */
+	vmovq (%r12), RX;
+	vpshufd $0x4f, RX, RX;
+	vpxor RX, RR1, RR1;
+	vpxor 0*16+8(%r12), RL1, RL1;
+	vpxor 1*16+8(%r12), RR2, RR2;
+	vpxor 2*16+8(%r12), RL2, RL2;
+	vpxor 3*16+8(%r12), RR3, RR3;
+	vpxor 4*16+8(%r12), RL3, RL3;
+	vpxor 5*16+8(%r12), RR4, RR4;
+	vpxor 6*16+8(%r12), RL4, RL4;
+
+	vmovdqu RR1, (0*16)(%r11);
+	vmovdqu RL1, (1*16)(%r11);
+	vmovdqu RR2, (2*16)(%r11);
+	vmovdqu RL2, (3*16)(%r11);
+	vmovdqu RR3, (4*16)(%r11);
+	vmovdqu RL3, (5*16)(%r11);
+	vmovdqu RR4, (6*16)(%r11);
+	vmovdqu RL4, (7*16)(%r11);
+
+	popq %r12;
+
+	ret;
+
+.align 16
+.global cast5_ctr_16way
+.type   cast5_ctr_16way,@function;
+
+cast5_ctr_16way:
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst
+	 *	%rdx: src
+	 *	%rcx: iv (big endian, 64bit)
+	 */
+
+	pushq %r12;
+
+	movq %rsi, %r11;
+	movq %rdx, %r12;
+
+	vpcmpeqd RTMP, RTMP, RTMP;
+	vpsrldq $8, RTMP, RTMP; /* low: -1, high: 0 */
+
+	vpcmpeqd RKR, RKR, RKR;
+	vpaddq RKR, RKR, RKR; /* low: -2, high: -2 */
+	vmovdqa .Lbswap_iv_mask, R1ST;
+	vmovdqa .Lbswap128_mask, RKM;
+
+	/* load IV and byteswap */
+	vmovq (%rcx), RX;
+	vpshufb R1ST, RX, RX;
+
+	/* construct IVs */
+	vpsubq RTMP, RX, RX;  /* le: IV1, IV0 */
+	vpshufb RKM, RX, RL1; /* be: IV0, IV1 */
+	vpsubq RKR, RX, RX;
+	vpshufb RKM, RX, RR1; /* be: IV2, IV3 */
+	vpsubq RKR, RX, RX;
+	vpshufb RKM, RX, RL2; /* be: IV4, IV5 */
+	vpsubq RKR, RX, RX;
+	vpshufb RKM, RX, RR2; /* be: IV6, IV7 */
+	vpsubq RKR, RX, RX;
+	vpshufb RKM, RX, RL3; /* be: IV8, IV9 */
+	vpsubq RKR, RX, RX;
+	vpshufb RKM, RX, RR3; /* be: IV10, IV11 */
+	vpsubq RKR, RX, RX;
+	vpshufb RKM, RX, RL4; /* be: IV12, IV13 */
+	vpsubq RKR, RX, RX;
+	vpshufb RKM, RX, RR4; /* be: IV14, IV15 */
+
+	/* store last IV */
+	vpsubq RTMP, RX, RX; /* le: IV16, IV14 */
+	vpshufb R1ST, RX, RX; /* be: IV16, IV16 */
+	vmovq RX, (%rcx);
+
+	call __cast5_enc_blk16;
+
+	/* dst = src ^ iv */
+	vpxor (0*16)(%r12), RR1, RR1;
+	vpxor (1*16)(%r12), RL1, RL1;
+	vpxor (2*16)(%r12), RR2, RR2;
+	vpxor (3*16)(%r12), RL2, RL2;
+	vpxor (4*16)(%r12), RR3, RR3;
+	vpxor (5*16)(%r12), RL3, RL3;
+	vpxor (6*16)(%r12), RR4, RR4;
+	vpxor (7*16)(%r12), RL4, RL4;
+	vmovdqu RR1, (0*16)(%r11);
+	vmovdqu RL1, (1*16)(%r11);
+	vmovdqu RR2, (2*16)(%r11);
+	vmovdqu RL2, (3*16)(%r11);
+	vmovdqu RR3, (4*16)(%r11);
+	vmovdqu RL3, (5*16)(%r11);
+	vmovdqu RR4, (6*16)(%r11);
+	vmovdqu RL4, (7*16)(%r11);
+
+	popq %r12;
+
+	ret;
diff --git a/arch/x86/crypto/cast5_avx_glue.c b/arch/x86/crypto/cast5_avx_glue.c
index e0ea14f..c663181 100644
--- a/arch/x86/crypto/cast5_avx_glue.c
+++ b/arch/x86/crypto/cast5_avx_glue.c
@@ -37,29 +37,14 @@
 
 #define CAST5_PARALLEL_BLOCKS 16
 
-asmlinkage void __cast5_enc_blk_16way(struct cast5_ctx *ctx, u8 *dst,
-				      const u8 *src, bool xor);
-asmlinkage void cast5_dec_blk_16way(struct cast5_ctx *ctx, u8 *dst,
+asmlinkage void cast5_ecb_enc_16way(struct cast5_ctx *ctx, u8 *dst,
 				    const u8 *src);
-
-static inline void cast5_enc_blk_xway(struct cast5_ctx *ctx, u8 *dst,
-				      const u8 *src)
-{
-	__cast5_enc_blk_16way(ctx, dst, src, false);
-}
-
-static inline void cast5_enc_blk_xway_xor(struct cast5_ctx *ctx, u8 *dst,
-					  const u8 *src)
-{
-	__cast5_enc_blk_16way(ctx, dst, src, true);
-}
-
-static inline void cast5_dec_blk_xway(struct cast5_ctx *ctx, u8 *dst,
-				      const u8 *src)
-{
-	cast5_dec_blk_16way(ctx, dst, src);
-}
-
+asmlinkage void cast5_ecb_dec_16way(struct cast5_ctx *ctx, u8 *dst,
+				    const u8 *src);
+asmlinkage void cast5_cbc_dec_16way(struct cast5_ctx *ctx, u8 *dst,
+				    const u8 *src);
+asmlinkage void cast5_ctr_16way(struct cast5_ctx *ctx, u8 *dst, const u8 *src,
+				__be64 *iv);
 
 static inline bool cast5_fpu_begin(bool fpu_enabled, unsigned int nbytes)
 {
@@ -79,8 +64,11 @@ static int ecb_crypt(struct blkcipher_desc *desc, struct blkcipher_walk *walk,
 	struct cast5_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
 	const unsigned int bsize = CAST5_BLOCK_SIZE;
 	unsigned int nbytes;
+	void (*fn)(struct cast5_ctx *ctx, u8 *dst, const u8 *src);
 	int err;
 
+	fn = (enc) ? cast5_ecb_enc_16way : cast5_ecb_dec_16way;
+
 	err = blkcipher_walk_virt(desc, walk);
 	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 
@@ -93,10 +81,7 @@ static int ecb_crypt(struct blkcipher_desc *desc, struct blkcipher_walk *walk,
 		/* Process multi-block batch */
 		if (nbytes >= bsize * CAST5_PARALLEL_BLOCKS) {
 			do {
-				if (enc)
-					cast5_enc_blk_xway(ctx, wdst, wsrc);
-				else
-					cast5_dec_blk_xway(ctx, wdst, wsrc);
+				fn(ctx, wdst, wsrc);
 
 				wsrc += bsize * CAST5_PARALLEL_BLOCKS;
 				wdst += bsize * CAST5_PARALLEL_BLOCKS;
@@ -107,12 +92,11 @@ static int ecb_crypt(struct blkcipher_desc *desc, struct blkcipher_walk *walk,
 				goto done;
 		}
 
+		fn = (enc) ? __cast5_encrypt : __cast5_decrypt;
+
 		/* Handle leftovers */
 		do {
-			if (enc)
-				__cast5_encrypt(ctx, wdst, wsrc);
-			else
-				__cast5_decrypt(ctx, wdst, wsrc);
+			fn(ctx, wdst, wsrc);
 
 			wsrc += bsize;
 			wdst += bsize;
@@ -194,9 +178,7 @@ static unsigned int __cbc_decrypt(struct blkcipher_desc *desc,
 	unsigned int nbytes = walk->nbytes;
 	u64 *src = (u64 *)walk->src.virt.addr;
 	u64 *dst = (u64 *)walk->dst.virt.addr;
-	u64 ivs[CAST5_PARALLEL_BLOCKS - 1];
 	u64 last_iv;
-	int i;
 
 	/* Start of the last block. */
 	src += nbytes / bsize - 1;
@@ -211,13 +193,7 @@ static unsigned int __cbc_decrypt(struct blkcipher_desc *desc,
 			src -= CAST5_PARALLEL_BLOCKS - 1;
 			dst -= CAST5_PARALLEL_BLOCKS - 1;
 
-			for (i = 0; i < CAST5_PARALLEL_BLOCKS - 1; i++)
-				ivs[i] = src[i];
-
-			cast5_dec_blk_xway(ctx, (u8 *)dst, (u8 *)src);
-
-			for (i = 0; i < CAST5_PARALLEL_BLOCKS - 1; i++)
-				*(dst + (i + 1)) ^= *(ivs + i);
+			cast5_cbc_dec_16way(ctx, (u8 *)dst, (u8 *)src);
 
 			nbytes -= bsize;
 			if (nbytes < bsize)
@@ -298,23 +274,12 @@ static unsigned int __ctr_crypt(struct blkcipher_desc *desc,
 	unsigned int nbytes = walk->nbytes;
 	u64 *src = (u64 *)walk->src.virt.addr;
 	u64 *dst = (u64 *)walk->dst.virt.addr;
-	u64 ctrblk = be64_to_cpu(*(__be64 *)walk->iv);
-	__be64 ctrblocks[CAST5_PARALLEL_BLOCKS];
-	int i;
 
 	/* Process multi-block batch */
 	if (nbytes >= bsize * CAST5_PARALLEL_BLOCKS) {
 		do {
-			/* create ctrblks for parallel encrypt */
-			for (i = 0; i < CAST5_PARALLEL_BLOCKS; i++) {
-				if (dst != src)
-					dst[i] = src[i];
-
-				ctrblocks[i] = cpu_to_be64(ctrblk++);
-			}
-
-			cast5_enc_blk_xway_xor(ctx, (u8 *)dst,
-					       (u8 *)ctrblocks);
+			cast5_ctr_16way(ctx, (u8 *)dst, (u8 *)src,
+					(__be64 *)walk->iv);
 
 			src += CAST5_PARALLEL_BLOCKS;
 			dst += CAST5_PARALLEL_BLOCKS;
@@ -327,13 +292,16 @@ static unsigned int __ctr_crypt(struct blkcipher_desc *desc,
 
 	/* Handle leftovers */
 	do {
+		u64 ctrblk;
+
 		if (dst != src)
 			*dst = *src;
 
-		ctrblocks[0] = cpu_to_be64(ctrblk++);
+		ctrblk = *(u64 *)walk->iv;
+		be64_add_cpu((__be64 *)walk->iv, 1);
 
-		__cast5_encrypt(ctx, (u8 *)ctrblocks, (u8 *)ctrblocks);
-		*dst ^= ctrblocks[0];
+		__cast5_encrypt(ctx, (u8 *)&ctrblk, (u8 *)&ctrblk);
+		*dst ^= ctrblk;
 
 		src += 1;
 		dst += 1;
@@ -341,7 +309,6 @@ static unsigned int __ctr_crypt(struct blkcipher_desc *desc,
 	} while (nbytes >= bsize);
 
 done:
-	*(__be64 *)walk->iv = cpu_to_be64(ctrblk);
 	return nbytes;
 }
 
