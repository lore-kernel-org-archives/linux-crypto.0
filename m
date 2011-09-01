From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [[RFC] PATCH 4/4] crypto: blowfish: add x86_64 assembly implementation
Date: Fri, 02 Sep 2011 01:45:22 +0300
Message-ID: <20110901224522.7795.76402.stgit@localhost6.localdomain6>
References: <20110901224506.7795.35128.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:48814 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932202Ab1IAWxt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 1 Sep 2011 18:53:49 -0400
In-Reply-To: <20110901224506.7795.35128.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Patch adds x86_64 assembly implementation of blowfish. Two set of assembler
functions are provided. First set is regular 'one-block at time'
encrypt/decrypt functions. Second is 'four-block at time' functions that
gain performance increase on out-of-order CPUs. Performance of 4-way
functions should be equal to 1-way functions with in-order CPUs.

Summary of the tcrypt benchmarks:

Blowfish assembler vs blowfish C (256bit 8kb block ECB)
encrypt: 2.2x speed
decrypt: 2.3x speed

Blowfish assembler vs blowfish C (256bit 8kb block CBC)
encrypt: 1.12x speed
decrypt: 2.5x speed

Blowfish assembler vs blowfish C (256bit 8kb block CTR)
encrypt: 2.5x speed

Full output:
http://koti.mbnet.fi/axh/kernel/crypto/tcrypt-speed-blowfish-asm-x86_64.txt
http://koti.mbnet.fi/axh/kernel/crypto/tcrypt-speed-blowfish-c-x86_64.txt

Tests were run on:
 vendor_id	: AuthenticAMD
 cpu family	: 16
 model		: 10
 model name	: AMD Phenom(tm) II X6 1055T Processor
 stepping	: 0

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/Makefile                 |    2 
 arch/x86/crypto/blowfish-x86_64-asm_64.S |  392 ++++++++++++++++++++++++
 arch/x86/crypto/blowfish_glue.c          |  487 ++++++++++++++++++++++++++++++
 crypto/Kconfig                           |   15 +
 4 files changed, 896 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/crypto/blowfish-x86_64-asm_64.S
 create mode 100644 arch/x86/crypto/blowfish_glue.c

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index 57c7f7b..725addf 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_CRYPTO_TWOFISH_586) += twofish-i586.o
 obj-$(CONFIG_CRYPTO_SALSA20_586) += salsa20-i586.o
 
 obj-$(CONFIG_CRYPTO_AES_X86_64) += aes-x86_64.o
+obj-$(CONFIG_CRYPTO_BLOWFISH_X86_64) += blowfish-x86_64.o
 obj-$(CONFIG_CRYPTO_TWOFISH_X86_64) += twofish-x86_64.o
 obj-$(CONFIG_CRYPTO_SALSA20_X86_64) += salsa20-x86_64.o
 obj-$(CONFIG_CRYPTO_AES_NI_INTEL) += aesni-intel.o
@@ -20,6 +21,7 @@ twofish-i586-y := twofish-i586-asm_32.o twofish_glue.o
 salsa20-i586-y := salsa20-i586-asm_32.o salsa20_glue.o
 
 aes-x86_64-y := aes-x86_64-asm_64.o aes_glue.o
+blowfish-x86_64-y := blowfish-x86_64-asm_64.o blowfish_glue.o
 twofish-x86_64-y := twofish-x86_64-asm_64.o twofish_glue.o
 salsa20-x86_64-y := salsa20-x86_64-asm_64.o salsa20_glue.o
 
diff --git a/arch/x86/crypto/blowfish-x86_64-asm_64.S b/arch/x86/crypto/blowfish-x86_64-asm_64.S
new file mode 100644
index 0000000..44eb23a
--- /dev/null
+++ b/arch/x86/crypto/blowfish-x86_64-asm_64.S
@@ -0,0 +1,392 @@
+/*
+ * Blowfish Cipher Algorithm (x86_64)
+ *
+ * Copyright (C) 2011 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
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
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
+ * USA
+ *
+ */
+
+.file "blowfish-x86_64-asm.S"
+.text
+
+/* structure of crypto context */
+#define p	0
+#define s0	((16 + 2) * 4)
+#define s1	((16 + 2 + (1 * 256)) * 4)
+#define s2	((16 + 2 + (2 * 256)) * 4)
+#define s3	((16 + 2 + (3 * 256)) * 4)
+
+/* register macros */
+#define CTX %rdi
+#define RIO %rsi
+
+#define RX0 %rax
+#define RX1 %rbx
+#define RX2 %rcx
+#define RX3 %rdx
+
+#define RX0d %eax
+#define RX1d %ebx
+#define RX2d %ecx
+#define RX3d %edx
+
+#define RX0bl %al
+#define RX1bl %bl
+#define RX2bl %cl
+#define RX3bl %dl
+
+#define RX0bh %ah
+#define RX1bh %bh
+#define RX2bh %ch
+#define RX3bh %dh
+
+#define RT0 %rbp
+#define RT1 %rsi
+
+#define RT0d %ebp
+#define RT1d %esi
+
+#define RK0 %r8
+#define RK1 %r9
+#define RK2 %r10
+#define RK3 %r11
+
+#define RK0d %r8d
+#define RK1d %r9d
+#define RK2d %r10d
+#define RK3d %r11d
+
+#define RKEY %r12
+
+/***********************************************************************
+ * 1-way blowfish
+ ***********************************************************************/
+#define F(x, k) \
+	rorq $16,		x; \
+	movzbl x ## bh,		RT0d; \
+	movzbl x ## bl,		RT1d; \
+	rolq $16,		x; \
+	movl s0(CTX,RT0,4),	k ## d; \
+	addl s1(CTX,RT1,4),	k ## d; \
+	movzbl x ## bh,		RT0d; \
+	movzbl x ## bl,		RT1d; \
+	rolq $32,		x; \
+	xorl s2(CTX,RT0,4),	k ## d; \
+	addl s3(CTX,RT1,4),	k ## d; \
+	xorq k,			x;
+
+#define add_roundkey_enc(n) \
+	xorq p+4*(n)(CTX), 	RX0;
+
+#define round_enc(n) \
+	add_roundkey_enc(n); \
+	\
+	F(RX0, RK0); \
+	F(RX0, RK0);
+
+#define round_final_enc(n) \
+	xorq p+4*(n)(CTX), 	RX0;
+
+#define add_roundkey_dec(n) \
+	movq p+4*(n-1)(CTX),	RT0; \
+	rorq $32,		RT0; \
+	xorq RT0,		RX0;
+
+#define round_dec(n) \
+	add_roundkey_dec(n); \
+	\
+	F(RX0, RK0); \
+	F(RX0, RK0); \
+
+#define read_block() \
+	movq (RIO), 		RX0; \
+	rorq $32, 		RX0; \
+	bswapq 			RX0;
+
+#define write_block() \
+	bswapq 			RX0; \
+	movq RX0, 		(RIO);
+
+#define xor_block() \
+	bswapq 			RX0; \
+	xorq RX0, 		(RIO);
+
+.align 8
+.global __blowfish_enc_blk
+.type   __blowfish_enc_blk,@function;
+
+__blowfish_enc_blk:
+	// input:
+	//	%rdi: ctx, CTX
+	//	%rsi: dst
+	//	%rdx: src
+	//	%rcx: bool xor
+	pushq %rbp;
+	pushq %rbx;
+
+	pushq %rsi;
+	pushq %rcx;
+	movq %rdx, RIO;
+
+	read_block();
+
+	round_enc(0);
+	round_enc(2);
+	round_enc(4);
+	round_enc(6);
+	round_enc(8);
+	round_enc(10);
+	round_enc(12);
+	round_enc(14);
+	add_roundkey_enc(16);
+
+	popq %rbp;
+	popq RIO;
+
+	test %bpl, %bpl;
+	jnz __enc_xor;
+
+	write_block();
+
+__enc_ret:
+	popq %rbx;
+	popq %rbp;
+
+	ret;
+
+__enc_xor:
+	xor_block();
+
+	jmp __enc_ret;
+
+.align 8
+.global blowfish_dec_blk
+.type   blowfish_dec_blk,@function;
+
+blowfish_dec_blk:
+	// input:
+	//	%rdi: ctx, CTX
+	//	%rsi: dst
+	//	%rdx: src
+	pushq %rbp;
+	pushq %rbx;
+
+	pushq %rsi;
+	movq %rdx, RIO;
+
+	read_block();
+
+	round_dec(17);
+	round_dec(15);
+	round_dec(13);
+	round_dec(11);
+	round_dec(9);
+	round_dec(7);
+	round_dec(5);
+	round_dec(3);
+	add_roundkey_dec(1);
+
+	popq RIO;
+	write_block();
+
+	popq %rbx;
+	popq %rbp;
+
+	ret;
+
+/**********************************************************************
+  4-way blowfish, four blocks parallel
+ **********************************************************************/
+#define add_preloaded_roundkey4() \
+	xorq RKEY,		RX0; \
+	xorq RKEY,		RX1; \
+	xorq RKEY,		RX2; \
+	xorq RKEY,		RX3;
+
+#define preload_roundkey_enc(n) \
+	movq p+4*(n)(CTX),	RKEY;
+
+#define add_roundkey_enc4(n) \
+	add_preloaded_roundkey4(); \
+	preload_roundkey_enc(n + 2);
+
+#define round_enc4(n) \
+	add_roundkey_enc4(n); \
+	\
+	F(RX0, RK0); \
+	F(RX1, RK1); \
+	F(RX2, RK2); \
+	F(RX3, RK3); \
+	\
+	F(RX0, RK0); \
+	F(RX1, RK1); \
+	F(RX2, RK2); \
+	F(RX3, RK3);
+
+#define preload_roundkey_dec(n) \
+	movq p+4*((n)-1)(CTX),	RKEY; \
+	rorq $32,		RKEY;
+
+#define add_roundkey_dec4(n) \
+	add_preloaded_roundkey4(); \
+	preload_roundkey_dec(n - 2);
+
+#define round_dec4(n) \
+	add_roundkey_dec4(n); \
+	\
+	F(RX0, RK0); \
+	F(RX1, RK1); \
+	F(RX2, RK2); \
+	F(RX3, RK3); \
+	\
+	F(RX0, RK0); \
+	F(RX1, RK1); \
+	F(RX2, RK2); \
+	F(RX3, RK3);
+
+#define read_block4() \
+	movq (RIO),		RX0; \
+	rorq $32,		RX0; \
+	bswapq 			RX0; \
+	\
+	movq 8(RIO),		RX1; \
+	rorq $32,		RX1; \
+	bswapq 			RX1; \
+	\
+	movq 16(RIO),		RX2; \
+	rorq $32,		RX2; \
+	bswapq 			RX2; \
+	\
+	movq 24(RIO),		RX3; \
+	rorq $32,		RX3; \
+	bswapq 			RX3;
+
+#define write_block4() \
+	bswapq 			RX0; \
+	movq RX0,		(RIO); \
+	\
+	bswapq 			RX1; \
+	movq RX1,		8(RIO); \
+	\
+	bswapq 			RX2; \
+	movq RX2,		16(RIO); \
+	\
+	bswapq 			RX3; \
+	movq RX3,		24(RIO);
+
+#define xor_block4() \
+	bswapq 			RX0; \
+	xorq RX0,		(RIO); \
+	\
+	bswapq 			RX1; \
+	xorq RX1,		8(RIO); \
+	\
+	bswapq 			RX2; \
+	xorq RX2,		16(RIO); \
+	\
+	bswapq 			RX3; \
+	xorq RX3,		24(RIO);
+
+.align 8
+.global __blowfish_enc_blk_4way
+.type   __blowfish_enc_blk_4way,@function;
+
+__blowfish_enc_blk_4way:
+	// input:
+	//	%rdi: ctx, CTX
+	//	%rsi: dst
+	//	%rdx: src
+	//	%rcx: bool xor
+	pushq %rbp;
+	pushq %rbx;
+	pushq RKEY;
+	preload_roundkey_enc(0);
+
+	pushq %rsi;
+	pushq %rcx;
+	movq %rdx, RIO;
+
+	read_block4();
+
+	round_enc4(0);
+	round_enc4(2);
+	round_enc4(4);
+	round_enc4(6);
+	round_enc4(8);
+	round_enc4(10);
+	round_enc4(12);
+	round_enc4(14);
+	add_preloaded_roundkey4();
+
+	popq %rbp;
+	popq RIO;
+
+	test %bpl, %bpl;
+	jnz __enc_xor4;
+
+	write_block4();
+
+__enc_ret4:
+	popq RKEY;
+	popq %rbx;
+	popq %rbp;
+
+	ret;
+
+__enc_xor4:
+	xor_block4();
+
+	jmp __enc_ret4;
+
+.align 8
+.global blowfish_dec_blk_4way
+.type   blowfish_dec_blk_4way,@function;
+
+blowfish_dec_blk_4way:
+	// input:
+	//	%rdi: ctx, CTX
+	//	%rsi: dst
+	//	%rdx: src
+	pushq %rbp;
+	pushq %rbx;
+	pushq RKEY;
+	preload_roundkey_dec(17);
+
+	pushq %rsi;
+	movq %rdx, RIO;
+
+	read_block4();
+
+	round_dec4(17);
+	round_dec4(15);
+	round_dec4(13);
+	round_dec4(11);
+	round_dec4(9);
+	round_dec4(7);
+	round_dec4(5);
+	round_dec4(3);
+	add_preloaded_roundkey4();
+
+	popq RIO;
+	write_block4();
+
+	popq RKEY;
+	popq %rbx;
+	popq %rbp;
+
+	ret;
+
diff --git a/arch/x86/crypto/blowfish_glue.c b/arch/x86/crypto/blowfish_glue.c
new file mode 100644
index 0000000..40911ab
--- /dev/null
+++ b/arch/x86/crypto/blowfish_glue.c
@@ -0,0 +1,487 @@
+/*
+ * Glue Code for assembler optimized version of Blowfish
+ *
+ * Copyright (c) 2011 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
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
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
+ * USA
+ *
+ */
+
+#include <crypto/blowfish.h>
+#include <linux/crypto.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <crypto/algapi.h>
+
+/* regular block cipher functions */
+asmlinkage void __blowfish_enc_blk(struct bf_ctx *ctx, u8 *dst, const u8 *src,
+				   bool xor);
+asmlinkage void blowfish_dec_blk(struct bf_ctx *ctx, u8 *dst, const u8 *src);
+
+/* 4-way parallel cipher functions */
+asmlinkage void __blowfish_enc_blk_4way(struct bf_ctx *ctx, u8 *dst,
+					const u8 *src, bool xor);
+asmlinkage void blowfish_dec_blk_4way(struct bf_ctx *ctx, u8 *dst,
+				      const u8 *src);
+
+static inline void blowfish_enc_blk(struct bf_ctx *ctx, u8 *dst, const u8 *src)
+{
+	__blowfish_enc_blk(ctx, dst, src, false);
+}
+
+static inline void blowfish_enc_blk_xor(struct bf_ctx *ctx, u8 *dst,
+					const u8 *src)
+{
+	__blowfish_enc_blk(ctx, dst, src, true);
+}
+
+static inline void blowfish_enc_blk_4way(struct bf_ctx *ctx, u8 *dst,
+					 const u8 *src)
+{
+	__blowfish_enc_blk_4way(ctx, dst, src, false);
+}
+
+static inline void blowfish_enc_blk_xor_4way(struct bf_ctx *ctx, u8 *dst,
+				      const u8 *src)
+{
+	__blowfish_enc_blk_4way(ctx, dst, src, true);
+}
+
+static void blowfish_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+{
+	blowfish_enc_blk(crypto_tfm_ctx(tfm), dst, src);
+}
+
+static void blowfish_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+{
+	blowfish_dec_blk(crypto_tfm_ctx(tfm), dst, src);
+}
+
+static struct crypto_alg bf_alg = {
+	.cra_name		=	"blowfish",
+	.cra_driver_name	=	"blowfish-asm",
+	.cra_priority		=	200,
+	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
+	.cra_blocksize		=	BF_BLOCK_SIZE,
+	.cra_ctxsize		=	sizeof(struct bf_ctx),
+	.cra_alignmask		=	3,
+	.cra_module		=	THIS_MODULE,
+	.cra_list		=	LIST_HEAD_INIT(bf_alg.cra_list),
+	.cra_u			=	{
+		.cipher = {
+			.cia_min_keysize	=	BF_MIN_KEY_SIZE,
+			.cia_max_keysize	=	BF_MAX_KEY_SIZE,
+			.cia_setkey		=	blowfish_setkey,
+			.cia_encrypt		=	blowfish_encrypt,
+			.cia_decrypt		=	blowfish_decrypt,
+		}
+	}
+};
+
+static int ecb_crypt(struct blkcipher_desc *desc, struct blkcipher_walk *walk,
+		     void (*fn)(struct bf_ctx *, u8 *, const u8 *),
+		     void (*fn_4way)(struct bf_ctx *, u8 *, const u8 *))
+{
+	struct bf_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	unsigned int bsize = BF_BLOCK_SIZE;
+	unsigned int nbytes;
+	int err;
+
+	err = blkcipher_walk_virt(desc, walk);
+
+	while ((nbytes = walk->nbytes)) {
+		u8 *wsrc = walk->src.virt.addr;
+		u8 *wdst = walk->dst.virt.addr;
+
+		/* Process four block batch */
+		if (nbytes >= bsize * 4) {
+			do {
+				fn_4way(ctx, wdst, wsrc);
+
+				wsrc += bsize * 4;
+				wdst += bsize * 4;
+				nbytes -= bsize * 4;
+			} while (nbytes >= bsize * 4);
+
+			if (nbytes < bsize)
+				goto done;
+		}
+
+		/* Handle leftovers */
+		do {
+			fn(ctx, wdst, wsrc);
+
+			wsrc += bsize;
+			wdst += bsize;
+			nbytes -= bsize;
+		} while (nbytes >= bsize);
+
+done:
+		err = blkcipher_walk_done(desc, walk, nbytes);
+	}
+
+	return err;
+}
+
+static int ecb_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct blkcipher_walk walk;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	return ecb_crypt(desc, &walk, blowfish_enc_blk, blowfish_enc_blk_4way);
+}
+
+static int ecb_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct blkcipher_walk walk;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	return ecb_crypt(desc, &walk, blowfish_dec_blk, blowfish_dec_blk_4way);
+}
+
+static struct crypto_alg blk_ecb_alg = {
+	.cra_name		= "ecb(blowfish)",
+	.cra_driver_name	= "ecb-blowfish-asm",
+	.cra_priority		= 300,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= BF_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct bf_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(blk_ecb_alg.cra_list),
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= BF_MIN_KEY_SIZE,
+			.max_keysize	= BF_MAX_KEY_SIZE,
+			.setkey		= blowfish_setkey,
+			.encrypt	= ecb_encrypt,
+			.decrypt	= ecb_decrypt,
+		},
+	},
+};
+
+static unsigned int __cbc_encrypt(struct blkcipher_desc *desc,
+				  struct blkcipher_walk *walk)
+{
+	struct bf_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	unsigned int bsize = BF_BLOCK_SIZE;
+	unsigned int nbytes = walk->nbytes;
+	u64 *src = (u64 *)walk->src.virt.addr;
+	u64 *dst = (u64 *)walk->dst.virt.addr;
+	u64 *iv = (u64 *)walk->iv;
+
+	do {
+		*dst = *src ^ *iv;
+		blowfish_enc_blk(ctx, (u8 *)dst, (u8 *)dst);
+		iv = dst;
+
+		src += 1;
+		dst += 1;
+		nbytes -= bsize;
+	} while (nbytes >= bsize);
+
+	*(u64 *)walk->iv = *iv;
+	return nbytes;
+}
+
+static int cbc_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct blkcipher_walk walk;
+	int err;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt(desc, &walk);
+
+	while ((nbytes = walk.nbytes)) {
+		nbytes = __cbc_encrypt(desc, &walk);
+		err = blkcipher_walk_done(desc, &walk, nbytes);
+	}
+
+	return err;
+}
+
+static unsigned int __cbc_decrypt(struct blkcipher_desc *desc,
+				  struct blkcipher_walk *walk)
+{
+	struct bf_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	unsigned int bsize = BF_BLOCK_SIZE;
+	unsigned int nbytes = walk->nbytes;
+	u64 *src = (u64 *)walk->src.virt.addr;
+	u64 *dst = (u64 *)walk->dst.virt.addr;
+	u64 ivs[4 - 1];
+	u64 last_iv;
+
+	/* Start of the last block. */
+	src += nbytes / bsize - 1;
+	dst += nbytes / bsize - 1;
+
+	last_iv = *src;
+
+	/* Process four block batch */
+	if (nbytes >= bsize * 4) {
+		do {
+			nbytes -= bsize * 4 - bsize;
+			src -= 4 - 1;
+			dst -= 4 - 1;
+
+			ivs[0] = src[0];
+			ivs[1] = src[1];
+			ivs[2] = src[2];
+
+			blowfish_dec_blk_4way(ctx, (u8 *)dst, (u8 *)src);
+
+			dst[1] ^= ivs[0];
+			dst[2] ^= ivs[1];
+			dst[3] ^= ivs[2];
+
+			nbytes -= bsize;
+			if (nbytes < bsize)
+				goto done;
+
+			*dst ^= *(src - 1);
+			src -= 1;
+			dst -= 1;
+		} while (nbytes >= bsize * 4);
+
+		if (nbytes < bsize)
+			goto done;
+	}
+
+	/* Handle leftovers */
+	for (;;) {
+		blowfish_dec_blk(ctx, (u8 *)dst, (u8 *)src);
+
+		nbytes -= bsize;
+		if (nbytes < bsize)
+			break;
+
+		*dst ^= *(src - 1);
+		src -= 1;
+		dst -= 1;
+	}
+
+done:
+	*dst ^= *(u64 *)walk->iv;
+	*(u64 *)walk->iv = last_iv;
+
+	return nbytes;
+}
+
+static int cbc_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct blkcipher_walk walk;
+	int err;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt(desc, &walk);
+
+	while ((nbytes = walk.nbytes)) {
+		nbytes = __cbc_decrypt(desc, &walk);
+		err = blkcipher_walk_done(desc, &walk, nbytes);
+	}
+
+	return err;
+}
+
+static struct crypto_alg blk_cbc_alg = {
+	.cra_name		= "cbc(blowfish)",
+	.cra_driver_name	= "cbc-blowfish-asm",
+	.cra_priority		= 300,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= BF_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct bf_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(blk_cbc_alg.cra_list),
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= BF_MIN_KEY_SIZE,
+			.max_keysize	= BF_MAX_KEY_SIZE,
+			.ivsize		= BF_BLOCK_SIZE,
+			.setkey		= blowfish_setkey,
+			.encrypt	= cbc_encrypt,
+			.decrypt	= cbc_decrypt,
+		},
+	},
+};
+
+static void ctr_crypt_final(struct bf_ctx *ctx, struct blkcipher_walk *walk)
+{
+	u8 *ctrblk = walk->iv;
+	u8 keystream[BF_BLOCK_SIZE];
+	u8 *src = walk->src.virt.addr;
+	u8 *dst = walk->dst.virt.addr;
+	unsigned int nbytes = walk->nbytes;
+
+	blowfish_enc_blk(ctx, keystream, ctrblk);
+	crypto_xor(keystream, src, nbytes);
+	memcpy(dst, keystream, nbytes);
+
+	crypto_inc(ctrblk, BF_BLOCK_SIZE);
+}
+
+static unsigned int __ctr_crypt(struct blkcipher_desc *desc,
+				struct blkcipher_walk *walk)
+{
+	struct bf_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	unsigned int bsize = BF_BLOCK_SIZE;
+	unsigned int nbytes = walk->nbytes;
+	u64 *src = (u64 *)walk->src.virt.addr;
+	u64 *dst = (u64 *)walk->dst.virt.addr;
+	u64 ctrblk = be64_to_cpu(*(__be64 *)walk->iv);
+	__be64 ctrblocks[4];
+
+	/* Process four block batch */
+	if (nbytes >= bsize * 4) {
+		do {
+			if (dst != src) {
+				dst[0] = src[0];
+				dst[1] = src[1];
+				dst[2] = src[2];
+				dst[3] = src[3];
+			}
+
+			/* create ctrblks for parallel encrypt */
+			ctrblocks[0] = cpu_to_be64(ctrblk++);
+			ctrblocks[1] = cpu_to_be64(ctrblk++);
+			ctrblocks[2] = cpu_to_be64(ctrblk++);
+			ctrblocks[3] = cpu_to_be64(ctrblk++);
+
+			blowfish_enc_blk_xor_4way(ctx, (u8 *)dst,
+						  (u8 *)ctrblocks);
+
+			src += 4;
+			dst += 4;
+		} while ((nbytes -= bsize * 4) >= bsize * 4);
+
+		if (nbytes < bsize)
+			goto done;
+	}
+
+	/* Handle leftovers */
+	do {
+		if (dst != src)
+			*dst = *src;
+
+		ctrblocks[0] = cpu_to_be64(ctrblk++);
+
+		blowfish_enc_blk_xor(ctx, (u8 *)dst, (u8 *)ctrblocks);
+
+		src += 1;
+		dst += 1;
+	} while ((nbytes -= bsize) >= bsize);
+
+done:
+	*(__be64 *)walk->iv = cpu_to_be64(ctrblk);
+	return nbytes;
+}
+
+static int ctr_crypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		     struct scatterlist *src, unsigned int nbytes)
+{
+	struct blkcipher_walk walk;
+	int err;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt_block(desc, &walk, BF_BLOCK_SIZE);
+
+	while ((nbytes = walk.nbytes) >= BF_BLOCK_SIZE) {
+		nbytes = __ctr_crypt(desc, &walk);
+		err = blkcipher_walk_done(desc, &walk, nbytes);
+	}
+
+	if (walk.nbytes) {
+		ctr_crypt_final(crypto_blkcipher_ctx(desc->tfm), &walk);
+		err = blkcipher_walk_done(desc, &walk, 0);
+	}
+
+	return err;
+}
+
+static struct crypto_alg blk_ctr_alg = {
+	.cra_name		= "ctr(blowfish)",
+	.cra_driver_name	= "ctr-blowfish-asm",
+	.cra_priority		= 300,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= BF_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct bf_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(blk_ctr_alg.cra_list),
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= BF_MIN_KEY_SIZE,
+			.max_keysize	= BF_MAX_KEY_SIZE,
+			.ivsize		= BF_BLOCK_SIZE,
+			.setkey		= blowfish_setkey,
+			.encrypt	= ctr_crypt,
+			.decrypt	= ctr_crypt,
+		},
+	},
+};
+
+static int __init init(void)
+{
+	int err;
+
+	err = crypto_register_alg(&bf_alg);
+	if (err)
+		goto bf_err;
+	err = crypto_register_alg(&blk_ecb_alg);
+	if (err)
+		goto ecb_err;
+	err = crypto_register_alg(&blk_cbc_alg);
+	if (err)
+		goto cbc_err;
+	err = crypto_register_alg(&blk_ctr_alg);
+	if (err)
+		goto ctr_err;
+
+	return 0;
+
+ctr_err:
+	crypto_unregister_alg(&blk_cbc_alg);
+cbc_err:
+	crypto_unregister_alg(&blk_ecb_alg);
+ecb_err:
+	crypto_unregister_alg(&bf_alg);
+bf_err:
+	return err;
+}
+
+static void __exit fini(void)
+{
+	crypto_unregister_alg(&blk_ctr_alg);
+	crypto_unregister_alg(&blk_cbc_alg);
+	crypto_unregister_alg(&blk_ecb_alg);
+	crypto_unregister_alg(&bf_alg);
+}
+
+module_init(init);
+module_exit(fini);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Blowfish Cipher Algorithm, asm optimized");
+MODULE_ALIAS("blowfish");
+MODULE_ALIAS("blowfish-asm");
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 108cb98..0763774 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -620,6 +620,21 @@ config CRYPTO_BLOWFISH_COMMON
 	  See also:
 	  <http://www.schneier.com/blowfish.html>
 
+config CRYPTO_BLOWFISH_X86_64
+	tristate "Blowfish cipher algorithm (x86_64)"
+	depends on (X86 || UML_X86) && 64BIT
+	select CRYPTO_ALGAPI
+	select CRYPTO_BLOWFISH_COMMON
+	help
+	  Blowfish cipher algorithm (x86_64), by Bruce Schneier.
+
+	  This is a variable key length cipher which can use keys from 32
+	  bits to 448 bits in length.  It's fast, simple and specifically
+	  designed for use on "large microprocessors".
+
+	  See also:
+	  <http://www.schneier.com/blowfish.html>
+
 config CRYPTO_CAMELLIA
 	tristate "Camellia cipher algorithms"
 	depends on CRYPTO
