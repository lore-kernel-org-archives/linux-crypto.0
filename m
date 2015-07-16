From: Martin Willi <martin@strongswan.org>
Subject: [PATCH v2 03/10] crypto: chacha20 - Add a SSSE3 SIMD variant for x86_64
Date: Thu, 16 Jul 2015 19:14:01 +0200
Message-ID: <1437066848-18048-4-git-send-email-martin@strongswan.org>
References: <1437066848-18048-1-git-send-email-martin@strongswan.org>
Cc: x86@kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from revosec.ch ([5.148.177.19]:45580 "EHLO revosec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754920AbbGPROW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 16 Jul 2015 13:14:22 -0400
In-Reply-To: <1437066848-18048-1-git-send-email-martin@strongswan.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Implements an x86_64 assembler driver for the ChaCha20 stream cipher. This
single block variant works on a single state matrix using SSE instructions.
It requires SSSE3 due the use of pshufb for efficient 8/16-bit rotate
operations.

For large messages, throughput increases by ~65% compared to
chacha20-generic:

testing speed of chacha20 (chacha20-generic) encryption
test 0 (256 bit key, 16 byte blocks): 45089207 operations in 10 seconds (721427312 bytes)
test 1 (256 bit key, 64 byte blocks): 43839521 operations in 10 seconds (2805729344 bytes)
test 2 (256 bit key, 256 byte blocks): 12702056 operations in 10 seconds (3251726336 bytes)
test 3 (256 bit key, 1024 byte blocks): 3371173 operations in 10 seconds (3452081152 bytes)
test 4 (256 bit key, 8192 byte blocks): 422468 operations in 10 seconds (3460857856 bytes)

testing speed of chacha20 (chacha20-simd) encryption
test 0 (256 bit key, 16 byte blocks): 43141886 operations in 10 seconds (690270176 bytes)
test 1 (256 bit key, 64 byte blocks): 46845874 operations in 10 seconds (2998135936 bytes)
test 2 (256 bit key, 256 byte blocks): 18458512 operations in 10 seconds (4725379072 bytes)
test 3 (256 bit key, 1024 byte blocks): 5360533 operations in 10 seconds (5489185792 bytes)
test 4 (256 bit key, 8192 byte blocks): 692846 operations in 10 seconds (5675794432 bytes)

Benchmark results from a Core i5-4670T.

Signed-off-by: Martin Willi <martin@strongswan.org>
---
 arch/x86/crypto/Makefile                |   2 +
 arch/x86/crypto/chacha20-ssse3-x86_64.S | 142 ++++++++++++++++++++++++++++++++
 arch/x86/crypto/chacha20_glue.c         | 123 +++++++++++++++++++++++++++
 crypto/Kconfig                          |  15 ++++
 4 files changed, 282 insertions(+)
 create mode 100644 arch/x86/crypto/chacha20-ssse3-x86_64.S
 create mode 100644 arch/x86/crypto/chacha20_glue.c

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index 5a4a089..b09e9a4 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_CRYPTO_BLOWFISH_X86_64) += blowfish-x86_64.o
 obj-$(CONFIG_CRYPTO_TWOFISH_X86_64) += twofish-x86_64.o
 obj-$(CONFIG_CRYPTO_TWOFISH_X86_64_3WAY) += twofish-x86_64-3way.o
 obj-$(CONFIG_CRYPTO_SALSA20_X86_64) += salsa20-x86_64.o
+obj-$(CONFIG_CRYPTO_CHACHA20_X86_64) += chacha20-x86_64.o
 obj-$(CONFIG_CRYPTO_SERPENT_SSE2_X86_64) += serpent-sse2-x86_64.o
 obj-$(CONFIG_CRYPTO_AES_NI_INTEL) += aesni-intel.o
 obj-$(CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL) += ghash-clmulni-intel.o
@@ -60,6 +61,7 @@ blowfish-x86_64-y := blowfish-x86_64-asm_64.o blowfish_glue.o
 twofish-x86_64-y := twofish-x86_64-asm_64.o twofish_glue.o
 twofish-x86_64-3way-y := twofish-x86_64-asm_64-3way.o twofish_glue_3way.o
 salsa20-x86_64-y := salsa20-x86_64-asm_64.o salsa20_glue.o
+chacha20-x86_64-y := chacha20-ssse3-x86_64.o chacha20_glue.o
 serpent-sse2-x86_64-y := serpent-sse2-x86_64-asm_64.o serpent_sse2_glue.o
 
 ifeq ($(avx_supported),yes)
diff --git a/arch/x86/crypto/chacha20-ssse3-x86_64.S b/arch/x86/crypto/chacha20-ssse3-x86_64.S
new file mode 100644
index 0000000..1b97ad0
--- /dev/null
+++ b/arch/x86/crypto/chacha20-ssse3-x86_64.S
@@ -0,0 +1,142 @@
+/*
+ * ChaCha20 256-bit cipher algorithm, RFC7539, x64 SSSE3 functions
+ *
+ * Copyright (C) 2015 Martin Willi
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/linkage.h>
+
+.data
+.align 16
+
+ROT8:	.octa 0x0e0d0c0f0a09080b0605040702010003
+ROT16:	.octa 0x0d0c0f0e09080b0a0504070601000302
+
+.text
+
+ENTRY(chacha20_block_xor_ssse3)
+	# %rdi: Input state matrix, s
+	# %rsi: 1 data block output, o
+	# %rdx: 1 data block input, i
+
+	# This function encrypts one ChaCha20 block by loading the state matrix
+	# in four SSE registers. It performs matrix operation on four words in
+	# parallel, but requireds shuffling to rearrange the words after each
+	# round. 8/16-bit word rotation is done with the slightly better
+	# performing SSSE3 byte shuffling, 7/12-bit word rotation uses
+	# traditional shift+OR.
+
+	# x0..3 = s0..3
+	movdqa		0x00(%rdi),%xmm0
+	movdqa		0x10(%rdi),%xmm1
+	movdqa		0x20(%rdi),%xmm2
+	movdqa		0x30(%rdi),%xmm3
+	movdqa		%xmm0,%xmm8
+	movdqa		%xmm1,%xmm9
+	movdqa		%xmm2,%xmm10
+	movdqa		%xmm3,%xmm11
+
+	movdqa		ROT8(%rip),%xmm4
+	movdqa		ROT16(%rip),%xmm5
+
+	mov	$10,%ecx
+
+.Ldoubleround:
+
+	# x0 += x1, x3 = rotl32(x3 ^ x0, 16)
+	paddd		%xmm1,%xmm0
+	pxor		%xmm0,%xmm3
+	pshufb		%xmm5,%xmm3
+
+	# x2 += x3, x1 = rotl32(x1 ^ x2, 12)
+	paddd		%xmm3,%xmm2
+	pxor		%xmm2,%xmm1
+	movdqa		%xmm1,%xmm6
+	pslld		$12,%xmm6
+	psrld		$20,%xmm1
+	por		%xmm6,%xmm1
+
+	# x0 += x1, x3 = rotl32(x3 ^ x0, 8)
+	paddd		%xmm1,%xmm0
+	pxor		%xmm0,%xmm3
+	pshufb		%xmm4,%xmm3
+
+	# x2 += x3, x1 = rotl32(x1 ^ x2, 7)
+	paddd		%xmm3,%xmm2
+	pxor		%xmm2,%xmm1
+	movdqa		%xmm1,%xmm7
+	pslld		$7,%xmm7
+	psrld		$25,%xmm1
+	por		%xmm7,%xmm1
+
+	# x1 = shuffle32(x1, MASK(0, 3, 2, 1))
+	pshufd		$0x39,%xmm1,%xmm1
+	# x2 = shuffle32(x2, MASK(1, 0, 3, 2))
+	pshufd		$0x4e,%xmm2,%xmm2
+	# x3 = shuffle32(x3, MASK(2, 1, 0, 3))
+	pshufd		$0x93,%xmm3,%xmm3
+
+	# x0 += x1, x3 = rotl32(x3 ^ x0, 16)
+	paddd		%xmm1,%xmm0
+	pxor		%xmm0,%xmm3
+	pshufb		%xmm5,%xmm3
+
+	# x2 += x3, x1 = rotl32(x1 ^ x2, 12)
+	paddd		%xmm3,%xmm2
+	pxor		%xmm2,%xmm1
+	movdqa		%xmm1,%xmm6
+	pslld		$12,%xmm6
+	psrld		$20,%xmm1
+	por		%xmm6,%xmm1
+
+	# x0 += x1, x3 = rotl32(x3 ^ x0, 8)
+	paddd		%xmm1,%xmm0
+	pxor		%xmm0,%xmm3
+	pshufb		%xmm4,%xmm3
+
+	# x2 += x3, x1 = rotl32(x1 ^ x2, 7)
+	paddd		%xmm3,%xmm2
+	pxor		%xmm2,%xmm1
+	movdqa		%xmm1,%xmm7
+	pslld		$7,%xmm7
+	psrld		$25,%xmm1
+	por		%xmm7,%xmm1
+
+	# x1 = shuffle32(x1, MASK(2, 1, 0, 3))
+	pshufd		$0x93,%xmm1,%xmm1
+	# x2 = shuffle32(x2, MASK(1, 0, 3, 2))
+	pshufd		$0x4e,%xmm2,%xmm2
+	# x3 = shuffle32(x3, MASK(0, 3, 2, 1))
+	pshufd		$0x39,%xmm3,%xmm3
+
+	dec		%ecx
+	jnz		.Ldoubleround
+
+	# o0 = i0 ^ (x0 + s0)
+	movdqu		0x00(%rdx),%xmm4
+	paddd		%xmm8,%xmm0
+	pxor		%xmm4,%xmm0
+	movdqu		%xmm0,0x00(%rsi)
+	# o1 = i1 ^ (x1 + s1)
+	movdqu		0x10(%rdx),%xmm5
+	paddd		%xmm9,%xmm1
+	pxor		%xmm5,%xmm1
+	movdqu		%xmm1,0x10(%rsi)
+	# o2 = i2 ^ (x2 + s2)
+	movdqu		0x20(%rdx),%xmm6
+	paddd		%xmm10,%xmm2
+	pxor		%xmm6,%xmm2
+	movdqu		%xmm2,0x20(%rsi)
+	# o3 = i3 ^ (x3 + s3)
+	movdqu		0x30(%rdx),%xmm7
+	paddd		%xmm11,%xmm3
+	pxor		%xmm7,%xmm3
+	movdqu		%xmm3,0x30(%rsi)
+
+	ret
+ENDPROC(chacha20_block_xor_ssse3)
diff --git a/arch/x86/crypto/chacha20_glue.c b/arch/x86/crypto/chacha20_glue.c
new file mode 100644
index 0000000..250de40
--- /dev/null
+++ b/arch/x86/crypto/chacha20_glue.c
@@ -0,0 +1,123 @@
+/*
+ * ChaCha20 256-bit cipher algorithm, RFC7539, SIMD glue code
+ *
+ * Copyright (C) 2015 Martin Willi
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <crypto/algapi.h>
+#include <crypto/chacha20.h>
+#include <linux/crypto.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <asm/fpu/api.h>
+#include <asm/simd.h>
+
+#define CHACHA20_STATE_ALIGN 16
+
+asmlinkage void chacha20_block_xor_ssse3(u32 *state, u8 *dst, const u8 *src);
+
+static void chacha20_dosimd(u32 *state, u8 *dst, const u8 *src,
+			    unsigned int bytes)
+{
+	u8 buf[CHACHA20_BLOCK_SIZE];
+
+	while (bytes >= CHACHA20_BLOCK_SIZE) {
+		chacha20_block_xor_ssse3(state, dst, src);
+		bytes -= CHACHA20_BLOCK_SIZE;
+		src += CHACHA20_BLOCK_SIZE;
+		dst += CHACHA20_BLOCK_SIZE;
+		state[12]++;
+	}
+	if (bytes) {
+		memcpy(buf, src, bytes);
+		chacha20_block_xor_ssse3(state, buf, buf);
+		memcpy(dst, buf, bytes);
+	}
+}
+
+static int chacha20_simd(struct blkcipher_desc *desc, struct scatterlist *dst,
+			 struct scatterlist *src, unsigned int nbytes)
+{
+	u32 *state, state_buf[16 + (CHACHA20_STATE_ALIGN / sizeof(u32)) - 1];
+	struct blkcipher_walk walk;
+	int err;
+
+	if (!may_use_simd())
+		return crypto_chacha20_crypt(desc, dst, src, nbytes);
+
+	state = (u32 *)roundup((uintptr_t)state_buf, CHACHA20_STATE_ALIGN);
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt_block(desc, &walk, CHACHA20_BLOCK_SIZE);
+
+	crypto_chacha20_init(state, crypto_blkcipher_ctx(desc->tfm), walk.iv);
+
+	kernel_fpu_begin();
+
+	while (walk.nbytes >= CHACHA20_BLOCK_SIZE) {
+		chacha20_dosimd(state, walk.dst.virt.addr, walk.src.virt.addr,
+				rounddown(walk.nbytes, CHACHA20_BLOCK_SIZE));
+		err = blkcipher_walk_done(desc, &walk,
+					  walk.nbytes % CHACHA20_BLOCK_SIZE);
+	}
+
+	if (walk.nbytes) {
+		chacha20_dosimd(state, walk.dst.virt.addr, walk.src.virt.addr,
+				walk.nbytes);
+		err = blkcipher_walk_done(desc, &walk, 0);
+	}
+
+	kernel_fpu_end();
+
+	return err;
+}
+
+static struct crypto_alg alg = {
+	.cra_name		= "chacha20",
+	.cra_driver_name	= "chacha20-simd",
+	.cra_priority		= 300,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= 1,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_ctxsize		= sizeof(struct chacha20_ctx),
+	.cra_alignmask		= sizeof(u32) - 1,
+	.cra_module		= THIS_MODULE,
+	.cra_u			= {
+		.blkcipher = {
+			.min_keysize	= CHACHA20_KEY_SIZE,
+			.max_keysize	= CHACHA20_KEY_SIZE,
+			.ivsize		= CHACHA20_IV_SIZE,
+			.geniv		= "seqiv",
+			.setkey		= crypto_chacha20_setkey,
+			.encrypt	= chacha20_simd,
+			.decrypt	= chacha20_simd,
+		},
+	},
+};
+
+static int __init chacha20_simd_mod_init(void)
+{
+	if (!cpu_has_ssse3)
+		return -ENODEV;
+
+	return crypto_register_alg(&alg);
+}
+
+static void __exit chacha20_simd_mod_fini(void)
+{
+	crypto_unregister_alg(&alg);
+}
+
+module_init(chacha20_simd_mod_init);
+module_exit(chacha20_simd_mod_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Martin Willi <martin@strongswan.org>");
+MODULE_DESCRIPTION("chacha20 cipher algorithm, SIMD accelerated");
+MODULE_ALIAS_CRYPTO("chacha20");
+MODULE_ALIAS_CRYPTO("chacha20-simd");
diff --git a/crypto/Kconfig b/crypto/Kconfig
index b4cfc57..8f24185 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1213,6 +1213,21 @@ config CRYPTO_CHACHA20
 	  See also:
 	  <http://cr.yp.to/chacha/chacha-20080128.pdf>
 
+config CRYPTO_CHACHA20_X86_64
+	tristate "ChaCha20 cipher algorithm (x86_64/SSSE3)"
+	depends on X86 && 64BIT
+	select CRYPTO_BLKCIPHER
+	select CRYPTO_CHACHA20
+	help
+	  ChaCha20 cipher algorithm, RFC7539.
+
+	  ChaCha20 is a 256-bit high-speed stream cipher designed by Daniel J.
+	  Bernstein and further specified in RFC7539 for use in IETF protocols.
+	  This is the x86_64 assembler implementation using SIMD instructions.
+
+	  See also:
+	  <http://cr.yp.to/chacha/chacha-20080128.pdf>
+
 config CRYPTO_SEED
 	tristate "SEED cipher algorithm"
 	select CRYPTO_ALGAPI
-- 
1.9.1
