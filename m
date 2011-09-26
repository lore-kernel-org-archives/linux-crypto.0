From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 3/3] crypto: twofish: add 3-way parallel x86_64 assembler
	implemention
Date: Mon, 26 Sep 2011 16:47:25 +0300
Message-ID: <20110926134725.21453.68210.stgit@localhost6.localdomain6>
References: <20110926134715.21453.18179.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:50299 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab1IZNra (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 26 Sep 2011 09:47:30 -0400
In-Reply-To: <20110926134715.21453.18179.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Patch adds 3-way parallel x86_64 assembly implementation of twofish as new
module. New assembler functions crypt data in three blocks chunks, improving
cipher performance on out-of-order CPUs.

Patch has been tested with tcrypt and automated filesystem tests.

Summary of the tcrypt benchmarks:

Twofish 3-way-asm vs twofish asm (128bit 8kb block ECB)
 encrypt: 1.3x speed
 decrypt: 1.3x speed

Twofish 3-way-asm vs twofish asm (128bit 8kb block CBC)
 encrypt: 1.07x speed
 decrypt: 1.4x speed

Twofish 3-way-asm vs twofish asm (128bit 8kb block CTR)
 encrypt: 1.4x speed

Twofish 3-way-asm vs AES asm (128bit 8kb block ECB)
 encrypt: 1.0x speed
 decrypt: 1.0x speed

Twofish 3-way-asm vs AES asm (128bit 8kb block CBC)
 encrypt: 0.84x speed
 decrypt: 1.09x speed

Twofish 3-way-asm vs AES asm (128bit 8kb block CTR)
 encrypt: 1.15x speed

Full output:
 http://koti.mbnet.fi/axh/kernel/crypto/tcrypt-speed-twofish-3way-asm-x86_64.txt
 http://koti.mbnet.fi/axh/kernel/crypto/tcrypt-speed-twofish-asm-x86_64.txt
 http://koti.mbnet.fi/axh/kernel/crypto/tcrypt-speed-aes-asm-x86_64.txt

Tests were run on:
 vendor_id  : AuthenticAMD
 cpu family : 16
 model      : 10
 model name : AMD Phenom(tm) II X6 1055T Processor

Also userspace test were run on:
 vendor_id  : GenuineIntel
 cpu family : 6
 model      : 15
 model name : Intel(R) Xeon(R) CPU           E7330  @ 2.40GHz
 stepping   : 11

Userspace test results:

Encryption/decryption of twofish 3-way vs x86_64-asm on AMD Phenom II:
 encrypt: 1.27x
 decrypt: 1.25x

Encryption/decryption of twofish 3-way vs x86_64-asm on Intel Xeon E7330:
 encrypt: 1.36x
 decrypt: 1.36x

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/Makefile                     |    2 
 arch/x86/crypto/twofish-x86_64-asm_64-3way.S |  316 +++++++++++++++++
 arch/x86/crypto/twofish_glue_3way.c          |  472 ++++++++++++++++++++++++++
 crypto/Kconfig                               |   20 +
 4 files changed, 810 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/crypto/twofish-x86_64-asm_64-3way.S
 create mode 100644 arch/x86/crypto/twofish_glue_3way.c

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index 725addf..3537d4b 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -9,6 +9,7 @@ obj-$(CONFIG_CRYPTO_SALSA20_586) += salsa20-i586.o
 obj-$(CONFIG_CRYPTO_AES_X86_64) += aes-x86_64.o
 obj-$(CONFIG_CRYPTO_BLOWFISH_X86_64) += blowfish-x86_64.o
 obj-$(CONFIG_CRYPTO_TWOFISH_X86_64) += twofish-x86_64.o
+obj-$(CONFIG_CRYPTO_TWOFISH_X86_64_3WAY) += twofish-x86_64-3way.o
 obj-$(CONFIG_CRYPTO_SALSA20_X86_64) += salsa20-x86_64.o
 obj-$(CONFIG_CRYPTO_AES_NI_INTEL) += aesni-intel.o
 obj-$(CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL) += ghash-clmulni-intel.o
@@ -23,6 +24,7 @@ salsa20-i586-y := salsa20-i586-asm_32.o salsa20_glue.o
 aes-x86_64-y := aes-x86_64-asm_64.o aes_glue.o
 blowfish-x86_64-y := blowfish-x86_64-asm_64.o blowfish_glue.o
 twofish-x86_64-y := twofish-x86_64-asm_64.o twofish_glue.o
+twofish-x86_64-3way-y := twofish-x86_64-asm_64-3way.o twofish_glue_3way.o
 salsa20-x86_64-y := salsa20-x86_64-asm_64.o salsa20_glue.o
 
 aesni-intel-y := aesni-intel_asm.o aesni-intel_glue.o fpu.o
diff --git a/arch/x86/crypto/twofish-x86_64-asm_64-3way.S b/arch/x86/crypto/twofish-x86_64-asm_64-3way.S
new file mode 100644
index 0000000..5b012a2
--- /dev/null
+++ b/arch/x86/crypto/twofish-x86_64-asm_64-3way.S
@@ -0,0 +1,316 @@
+/*
+ * Twofish Cipher 3-way parallel algorithm (x86_64)
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
+.file "twofish-x86_64-asm-3way.S"
+.text
+
+/* structure of crypto context */
+#define s0	0
+#define s1	1024
+#define s2	2048
+#define s3	3072
+#define w	4096
+#define k	4128
+
+/**********************************************************************
+  3-way twofish
+ **********************************************************************/
+#define CTX %rdi
+#define RIO %rdx
+
+#define RAB0 %rax
+#define RAB1 %rbx
+#define RAB2 %rcx
+
+#define RAB0d %eax
+#define RAB1d %ebx
+#define RAB2d %ecx
+
+#define RAB0bh %ah
+#define RAB1bh %bh
+#define RAB2bh %ch
+
+#define RAB0bl %al
+#define RAB1bl %bl
+#define RAB2bl %cl
+
+#define RCD0 %r8
+#define RCD1 %r9
+#define RCD2 %r10
+
+#define RCD0d %r8d
+#define RCD1d %r9d
+#define RCD2d %r10d
+
+#define RX0 %rbp
+#define RX1 %r11
+#define RX2 %r12
+
+#define RX0d %ebp
+#define RX1d %r11d
+#define RX2d %r12d
+
+#define RY0 %r13
+#define RY1 %r14
+#define RY2 %r15
+
+#define RY0d %r13d
+#define RY1d %r14d
+#define RY2d %r15d
+
+#define RT0 %rdx
+#define RT1 %rsi
+
+#define RT0d %edx
+#define RT1d %esi
+
+#define do16bit_ror(rot, op1, op2, T0, T1, tmp1, tmp2, ab, dst) \
+	movzbl ab ## bl,		tmp2 ## d; \
+	movzbl ab ## bh,		tmp1 ## d; \
+	rorq $(rot),			ab; \
+	op1##l T0(CTX, tmp2, 4),	dst ## d; \
+	op2##l T1(CTX, tmp1, 4),	dst ## d;
+
+/*
+ * Combined G1 & G2 function. Reordered with help of rotates to have moves
+ * at begining.
+ */
+#define g1g2_3(ab, cd, Tx0, Tx1, Tx2, Tx3, Ty0, Ty1, Ty2, Ty3, x, y) \
+	/* G1,1 && G2,1 */ \
+	do16bit_ror(32, mov, xor, Tx0, Tx1, RT0, x ## 0, ab ## 0, x ## 0); \
+	do16bit_ror(48, mov, xor, Ty1, Ty2, RT0, y ## 0, ab ## 0, y ## 0); \
+	\
+	do16bit_ror(32, mov, xor, Tx0, Tx1, RT0, x ## 1, ab ## 1, x ## 1); \
+	do16bit_ror(48, mov, xor, Ty1, Ty2, RT0, y ## 1, ab ## 1, y ## 1); \
+	\
+	do16bit_ror(32, mov, xor, Tx0, Tx1, RT0, x ## 2, ab ## 2, x ## 2); \
+	do16bit_ror(48, mov, xor, Ty1, Ty2, RT0, y ## 2, ab ## 2, y ## 2); \
+	\
+	/* G1,2 && G2,2 */ \
+	do16bit_ror(32, xor, xor, Tx2, Tx3, RT0, RT1, ab ## 0, x ## 0); \
+	do16bit_ror(16, xor, xor, Ty3, Ty0, RT0, RT1, ab ## 0, y ## 0); \
+	xchgq cd ## 0, ab ## 0; \
+	\
+	do16bit_ror(32, xor, xor, Tx2, Tx3, RT0, RT1, ab ## 1, x ## 1); \
+	do16bit_ror(16, xor, xor, Ty3, Ty0, RT0, RT1, ab ## 1, y ## 1); \
+	xchgq cd ## 1, ab ## 1; \
+	\
+	do16bit_ror(32, xor, xor, Tx2, Tx3, RT0, RT1, ab ## 2, x ## 2); \
+	do16bit_ror(16, xor, xor, Ty3, Ty0, RT0, RT1, ab ## 2, y ## 2); \
+	xchgq cd ## 2, ab ## 2;
+
+#define enc_round_end(ab, x, y, n) \
+	addl y ## d,			x ## d; \
+	addl x ## d,			y ## d; \
+	addl k+4*(2*(n))(CTX),		x ## d; \
+	xorl ab ## d,			x ## d; \
+	addl k+4*(2*(n)+1)(CTX),	y ## d; \
+	shrq $32,			ab; \
+	roll $1,			ab ## d; \
+	xorl y ## d,			ab ## d; \
+	shlq $32,			ab; \
+	rorl $1,			x ## d; \
+	orq x,				ab;
+
+#define dec_round_end(ba, x, y, n) \
+	addl y ## d,			x ## d; \
+	addl x ## d,			y ## d; \
+	addl k+4*(2*(n))(CTX),		x ## d; \
+	addl k+4*(2*(n)+1)(CTX),	y ## d; \
+	xorl ba ## d,			y ## d; \
+	shrq $32,			ba; \
+	roll $1,			ba ## d; \
+	xorl x ## d,			ba ## d; \
+	shlq $32,			ba; \
+	rorl $1,			y ## d; \
+	orq y,				ba;
+
+#define encrypt_round3(ab, cd, n) \
+	g1g2_3(ab, cd, s0, s1, s2, s3, s0, s1, s2, s3, RX, RY); \
+	\
+	enc_round_end(ab ## 0, RX0, RY0, n); \
+	enc_round_end(ab ## 1, RX1, RY1, n); \
+	enc_round_end(ab ## 2, RX2, RY2, n);
+
+#define decrypt_round3(ba, dc, n) \
+	g1g2_3(ba, dc, s1, s2, s3, s0, s3, s0, s1, s2, RY, RX); \
+	\
+	dec_round_end(ba ## 0, RX0, RY0, n); \
+	dec_round_end(ba ## 1, RX1, RY1, n); \
+	dec_round_end(ba ## 2, RX2, RY2, n);
+
+#define encrypt_cycle3(ab, cd, n) \
+	encrypt_round3(ab, cd, n*2); \
+	encrypt_round3(ab, cd, (n*2)+1);
+
+#define decrypt_cycle3(ba, dc, n) \
+	decrypt_round3(ba, dc, (n*2)+1); \
+	decrypt_round3(ba, dc, (n*2));
+
+#define inpack3(in, n, xy, m) \
+	movq 4*(n)(in),			xy ## 0; \
+	xorq w+4*m(CTX),		xy ## 0; \
+	\
+	movq 4*(4+(n))(in),		xy ## 1; \
+	xorq w+4*m(CTX),		xy ## 1; \
+	\
+	movq 4*(8+(n))(in),		xy ## 2; \
+	xorq w+4*m(CTX),		xy ## 2;
+
+#define outunpack3(op, out, n, xy, m) \
+	xorq w+4*m(CTX),		xy ## 0; \
+	op ## q xy ## 0,		4*(n)(out); \
+	\
+	xorq w+4*m(CTX),		xy ## 1; \
+	op ## q xy ## 1,		4*(4+(n))(out); \
+	\
+	xorq w+4*m(CTX),		xy ## 2; \
+	op ## q xy ## 2,		4*(8+(n))(out);
+
+#define inpack_enc3() \
+	inpack3(RIO, 0, RAB, 0); \
+	inpack3(RIO, 2, RCD, 2);
+
+#define outunpack_enc3(op) \
+	outunpack3(op, RIO, 2, RAB, 6); \
+	outunpack3(op, RIO, 0, RCD, 4);
+
+#define inpack_dec3() \
+	inpack3(RIO, 0, RAB, 4); \
+	rorq $32,			RAB0; \
+	rorq $32,			RAB1; \
+	rorq $32,			RAB2; \
+	inpack3(RIO, 2, RCD, 6); \
+	rorq $32,			RCD0; \
+	rorq $32,			RCD1; \
+	rorq $32,			RCD2;
+
+#define outunpack_dec3() \
+	rorq $32,			RCD0; \
+	rorq $32,			RCD1; \
+	rorq $32,			RCD2; \
+	outunpack3(mov, RIO, 0, RCD, 0); \
+	rorq $32,			RAB0; \
+	rorq $32,			RAB1; \
+	rorq $32,			RAB2; \
+	outunpack3(mov, RIO, 2, RAB, 2);
+
+.align 8
+.global __twofish_enc_blk_3way
+.type   __twofish_enc_blk_3way,@function;
+
+__twofish_enc_blk_3way:
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst
+	 *	%rdx: src, RIO
+	 *	%rcx: bool, if true: xor output
+	 */
+	pushq %r15;
+	pushq %r14;
+	pushq %r13;
+	pushq %r12;
+	pushq %rbp;
+	pushq %rbx;
+
+	pushq %rcx; /* bool xor */
+	pushq %rsi; /* dst */
+
+	inpack_enc3();
+
+	encrypt_cycle3(RAB, RCD, 0);
+	encrypt_cycle3(RAB, RCD, 1);
+	encrypt_cycle3(RAB, RCD, 2);
+	encrypt_cycle3(RAB, RCD, 3);
+	encrypt_cycle3(RAB, RCD, 4);
+	encrypt_cycle3(RAB, RCD, 5);
+	encrypt_cycle3(RAB, RCD, 6);
+	encrypt_cycle3(RAB, RCD, 7);
+
+	popq RIO; /* dst */
+	popq %rbp; /* bool xor */
+
+	testb %bpl, %bpl;
+	jnz __enc_xor3;
+
+	outunpack_enc3(mov);
+
+	popq %rbx;
+	popq %rbp;
+	popq %r12;
+	popq %r13;
+	popq %r14;
+	popq %r15;
+	ret;
+
+__enc_xor3:
+	outunpack_enc3(xor);
+
+	popq %rbx;
+	popq %rbp;
+	popq %r12;
+	popq %r13;
+	popq %r14;
+	popq %r15;
+	ret;
+
+.global twofish_dec_blk_3way
+.type   twofish_dec_blk_3way,@function;
+
+twofish_dec_blk_3way:
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst
+	 *	%rdx: src, RIO
+	 */
+	pushq %r15;
+	pushq %r14;
+	pushq %r13;
+	pushq %r12;
+	pushq %rbp;
+	pushq %rbx;
+
+	pushq %rsi; /* dst */
+
+	inpack_dec3();
+
+	decrypt_cycle3(RAB, RCD, 7);
+	decrypt_cycle3(RAB, RCD, 6);
+	decrypt_cycle3(RAB, RCD, 5);
+	decrypt_cycle3(RAB, RCD, 4);
+	decrypt_cycle3(RAB, RCD, 3);
+	decrypt_cycle3(RAB, RCD, 2);
+	decrypt_cycle3(RAB, RCD, 1);
+	decrypt_cycle3(RAB, RCD, 0);
+
+	popq RIO; /* dst */
+
+	outunpack_dec3();
+
+	popq %rbx;
+	popq %rbp;
+	popq %r12;
+	popq %r13;
+	popq %r14;
+	popq %r15;
+	ret;
+
diff --git a/arch/x86/crypto/twofish_glue_3way.c b/arch/x86/crypto/twofish_glue_3way.c
new file mode 100644
index 0000000..0cbf9fa
--- /dev/null
+++ b/arch/x86/crypto/twofish_glue_3way.c
@@ -0,0 +1,472 @@
+/*
+ * Glue Code for 3-way parallel assembler optimized version of Twofish
+ *
+ * Copyright (c) 2011 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
+ *
+ * CBC & ECB parts based on code (crypto/cbc.c,ecb.c) by:
+ *   Copyright (c) 2006 Herbert Xu <herbert@gondor.apana.org.au>
+ * CTR part based on code (crypto/ctr.c) by:
+ *   (C) Copyright IBM Corp. 2007 - Joy Latten <latten@us.ibm.com>
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
+#include <linux/crypto.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <crypto/algapi.h>
+#include <crypto/twofish.h>
+#include <crypto/b128ops.h>
+
+/* regular block cipher functions from twofish_x86_64 module */
+asmlinkage void twofish_enc_blk(struct twofish_ctx *ctx, u8 *dst,
+				const u8 *src);
+asmlinkage void twofish_dec_blk(struct twofish_ctx *ctx, u8 *dst,
+				const u8 *src);
+
+/* 3-way parallel cipher functions */
+asmlinkage void __twofish_enc_blk_3way(struct twofish_ctx *ctx, u8 *dst,
+				       const u8 *src, bool xor);
+asmlinkage void twofish_dec_blk_3way(struct twofish_ctx *ctx, u8 *dst,
+				     const u8 *src);
+
+static inline void twofish_enc_blk_3way(struct twofish_ctx *ctx, u8 *dst,
+					const u8 *src)
+{
+	__twofish_enc_blk_3way(ctx, dst, src, false);
+}
+
+static inline void twofish_enc_blk_xor_3way(struct twofish_ctx *ctx, u8 *dst,
+					    const u8 *src)
+{
+	__twofish_enc_blk_3way(ctx, dst, src, true);
+}
+
+static int ecb_crypt(struct blkcipher_desc *desc, struct blkcipher_walk *walk,
+		     void (*fn)(struct twofish_ctx *, u8 *, const u8 *),
+		     void (*fn_3way)(struct twofish_ctx *, u8 *, const u8 *))
+{
+	struct twofish_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	unsigned int bsize = TF_BLOCK_SIZE;
+	unsigned int nbytes;
+	int err;
+
+	err = blkcipher_walk_virt(desc, walk);
+
+	while ((nbytes = walk->nbytes)) {
+		u8 *wsrc = walk->src.virt.addr;
+		u8 *wdst = walk->dst.virt.addr;
+
+		/* Process three block batch */
+		if (nbytes >= bsize * 3) {
+			do {
+				fn_3way(ctx, wdst, wsrc);
+
+				wsrc += bsize * 3;
+				wdst += bsize * 3;
+				nbytes -= bsize * 3;
+			} while (nbytes >= bsize * 3);
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
+	return ecb_crypt(desc, &walk, twofish_enc_blk, twofish_enc_blk_3way);
+}
+
+static int ecb_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct blkcipher_walk walk;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	return ecb_crypt(desc, &walk, twofish_dec_blk, twofish_dec_blk_3way);
+}
+
+static struct crypto_alg blk_ecb_alg = {
+	.cra_name		= "ecb(twofish)",
+	.cra_driver_name	= "ecb-twofish-3way",
+	.cra_priority		= 300,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= TF_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct twofish_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(blk_ecb_alg.cra_list),
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= TF_MIN_KEY_SIZE,
+			.max_keysize	= TF_MAX_KEY_SIZE,
+			.setkey		= twofish_setkey,
+			.encrypt	= ecb_encrypt,
+			.decrypt	= ecb_decrypt,
+		},
+	},
+};
+
+static unsigned int __cbc_encrypt(struct blkcipher_desc *desc,
+				  struct blkcipher_walk *walk)
+{
+	struct twofish_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	unsigned int bsize = TF_BLOCK_SIZE;
+	unsigned int nbytes = walk->nbytes;
+	u128 *src = (u128 *)walk->src.virt.addr;
+	u128 *dst = (u128 *)walk->dst.virt.addr;
+	u128 *iv = (u128 *)walk->iv;
+
+	do {
+		u128_xor(dst, src, iv);
+		twofish_enc_blk(ctx, (u8 *)dst, (u8 *)dst);
+		iv = dst;
+
+		src += 1;
+		dst += 1;
+		nbytes -= bsize;
+	} while (nbytes >= bsize);
+
+	u128_xor((u128 *)walk->iv, (u128 *)walk->iv, iv);
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
+	struct twofish_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	unsigned int bsize = TF_BLOCK_SIZE;
+	unsigned int nbytes = walk->nbytes;
+	u128 *src = (u128 *)walk->src.virt.addr;
+	u128 *dst = (u128 *)walk->dst.virt.addr;
+	u128 ivs[3 - 1];
+	u128 last_iv;
+
+	/* Start of the last block. */
+	src += nbytes / bsize - 1;
+	dst += nbytes / bsize - 1;
+
+	last_iv = *src;
+
+	/* Process three block batch */
+	if (nbytes >= bsize * 3) {
+		do {
+			nbytes -= bsize * (3 - 1);
+			src -= 3 - 1;
+			dst -= 3 - 1;
+
+			ivs[0] = src[0];
+			ivs[1] = src[1];
+
+			twofish_dec_blk_3way(ctx, (u8 *)dst, (u8 *)src);
+
+			u128_xor(dst + 1, dst + 1, ivs + 0);
+			u128_xor(dst + 2, dst + 2, ivs + 1);
+
+			nbytes -= bsize;
+			if (nbytes < bsize)
+				goto done;
+
+			u128_xor(dst, dst, src - 1);
+			src -= 1;
+			dst -= 1;
+		} while (nbytes >= bsize * 3);
+
+		if (nbytes < bsize)
+			goto done;
+	}
+
+	/* Handle leftovers */
+	for (;;) {
+		twofish_dec_blk(ctx, (u8 *)dst, (u8 *)src);
+
+		nbytes -= bsize;
+		if (nbytes < bsize)
+			break;
+
+		u128_xor(dst, dst, src - 1);
+		src -= 1;
+		dst -= 1;
+	}
+
+done:
+	u128_xor(dst, dst, (u128 *)walk->iv);
+	*(u128 *)walk->iv = last_iv;
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
+	.cra_name		= "cbc(twofish)",
+	.cra_driver_name	= "cbc-twofish-3way",
+	.cra_priority		= 300,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= TF_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct twofish_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(blk_cbc_alg.cra_list),
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= TF_MIN_KEY_SIZE,
+			.max_keysize	= TF_MAX_KEY_SIZE,
+			.ivsize		= TF_BLOCK_SIZE,
+			.setkey		= twofish_setkey,
+			.encrypt	= cbc_encrypt,
+			.decrypt	= cbc_decrypt,
+		},
+	},
+};
+
+static inline void u128_to_be128(be128 *dst, const u128 *src)
+{
+	dst->a = cpu_to_be64(src->a);
+	dst->b = cpu_to_be64(src->b);
+}
+
+static inline void be128_to_u128(u128 *dst, const be128 *src)
+{
+	dst->a = be64_to_cpu(src->a);
+	dst->b = be64_to_cpu(src->b);
+}
+
+static inline void u128_inc(u128 *i)
+{
+	i->b++;
+	if (!i->b)
+		i->a++;
+}
+
+static void ctr_crypt_final(struct blkcipher_desc *desc,
+			    struct blkcipher_walk *walk)
+{
+	struct twofish_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	u8 *ctrblk = walk->iv;
+	u8 keystream[TF_BLOCK_SIZE];
+	u8 *src = walk->src.virt.addr;
+	u8 *dst = walk->dst.virt.addr;
+	unsigned int nbytes = walk->nbytes;
+
+	twofish_enc_blk(ctx, keystream, ctrblk);
+	crypto_xor(keystream, src, nbytes);
+	memcpy(dst, keystream, nbytes);
+
+	crypto_inc(ctrblk, TF_BLOCK_SIZE);
+}
+
+static unsigned int __ctr_crypt(struct blkcipher_desc *desc,
+				struct blkcipher_walk *walk)
+{
+	struct twofish_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	unsigned int bsize = TF_BLOCK_SIZE;
+	unsigned int nbytes = walk->nbytes;
+	u128 *src = (u128 *)walk->src.virt.addr;
+	u128 *dst = (u128 *)walk->dst.virt.addr;
+	u128 ctrblk;
+	be128 ctrblocks[3];
+
+	be128_to_u128(&ctrblk, (be128 *)walk->iv);
+
+	/* Process three block batch */
+	if (nbytes >= bsize * 3) {
+		do {
+			if (dst != src) {
+				dst[0] = src[0];
+				dst[1] = src[1];
+				dst[2] = src[2];
+			}
+
+			/* create ctrblks for parallel encrypt */
+			u128_to_be128(&ctrblocks[0], &ctrblk);
+			u128_inc(&ctrblk);
+			u128_to_be128(&ctrblocks[1], &ctrblk);
+			u128_inc(&ctrblk);
+			u128_to_be128(&ctrblocks[2], &ctrblk);
+			u128_inc(&ctrblk);
+
+			twofish_enc_blk_xor_3way(ctx, (u8 *)dst,
+						 (u8 *)ctrblocks);
+
+			src += 3;
+			dst += 3;
+			nbytes -= bsize * 3;
+		} while (nbytes >= bsize * 3);
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
+		u128_to_be128(&ctrblocks[0], &ctrblk);
+		u128_inc(&ctrblk);
+
+		twofish_enc_blk(ctx, (u8 *)ctrblocks, (u8 *)ctrblocks);
+		u128_xor(dst, dst, (u128 *)ctrblocks);
+
+		src += 1;
+		dst += 1;
+		nbytes -= bsize;
+	} while (nbytes >= bsize);
+
+done:
+	u128_to_be128((be128 *)walk->iv, &ctrblk);
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
+	err = blkcipher_walk_virt_block(desc, &walk, TF_BLOCK_SIZE);
+
+	while ((nbytes = walk.nbytes) >= TF_BLOCK_SIZE) {
+		nbytes = __ctr_crypt(desc, &walk);
+		err = blkcipher_walk_done(desc, &walk, nbytes);
+	}
+
+	if (walk.nbytes) {
+		ctr_crypt_final(desc, &walk);
+		err = blkcipher_walk_done(desc, &walk, 0);
+	}
+
+	return err;
+}
+
+static struct crypto_alg blk_ctr_alg = {
+	.cra_name		= "ctr(twofish)",
+	.cra_driver_name	= "ctr-twofish-3way",
+	.cra_priority		= 300,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= TF_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct twofish_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(blk_ctr_alg.cra_list),
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= TF_MIN_KEY_SIZE,
+			.max_keysize	= TF_MAX_KEY_SIZE,
+			.ivsize		= TF_BLOCK_SIZE,
+			.setkey		= twofish_setkey,
+			.encrypt	= ctr_crypt,
+			.decrypt	= ctr_crypt,
+		},
+	},
+};
+
+int __init init(void)
+{
+	int err;
+
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
+	return err;
+}
+
+void __exit fini(void)
+{
+	crypto_unregister_alg(&blk_ctr_alg);
+	crypto_unregister_alg(&blk_cbc_alg);
+	crypto_unregister_alg(&blk_ecb_alg);
+}
+
+module_init(init);
+module_exit(fini);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Twofish Cipher Algorithm, 3-way parallel asm optimized");
+MODULE_ALIAS("twofish");
+MODULE_ALIAS("twofish-asm");
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 0763774..404a846 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -828,6 +828,26 @@ config CRYPTO_TWOFISH_X86_64
 	  See also:
 	  <http://www.schneier.com/twofish.html>
 
+config CRYPTO_TWOFISH_X86_64_3WAY
+	tristate "Twofish cipher algorithm (x86_64, 3-way parallel)"
+	depends on (X86 || UML_X86) && 64BIT
+	select CRYPTO_ALGAPI
+	select CRYPTO_TWOFISH_COMMON
+	select CRYPTO_TWOFISH_X86_64
+	help
+	  Twofish cipher algorithm (x86_64, 3-way parallel).
+
+	  Twofish was submitted as an AES (Advanced Encryption Standard)
+	  candidate cipher by researchers at CounterPane Systems.  It is a
+	  16 round block cipher supporting key sizes of 128, 192, and 256
+	  bits.
+
+	  This module provides Twofish cipher algorithm that processes three
+	  blocks parallel, utilizing resources of out-of-order CPUs better.
+
+	  See also:
+	  <http://www.schneier.com/twofish.html>
+
 comment "Compression"
 
 config CRYPTO_DEFLATE
