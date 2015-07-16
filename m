From: Martin Willi <martin@strongswan.org>
Subject: [PATCH v2 08/10] crypto: poly1305 - Add a SSE2 SIMD variant for x86_64
Date: Thu, 16 Jul 2015 19:14:06 +0200
Message-ID: <1437066848-18048-9-git-send-email-martin@strongswan.org>
References: <1437066848-18048-1-git-send-email-martin@strongswan.org>
Cc: x86@kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from revosec.ch ([5.148.177.19]:45573 "EHLO revosec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754905AbbGPROW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 16 Jul 2015 13:14:22 -0400
In-Reply-To: <1437066848-18048-1-git-send-email-martin@strongswan.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Implements an x86_64 assembler driver for the Poly1305 authenticator. This
single block variant holds the 130-bit integer in 5 32-bit words, but uses
SSE to do two multiplications/additions in parallel.

When calling updates with small blocks, the overhead for kernel_fpu_begin/
kernel_fpu_end() negates the perfmance gain. We therefore use the
poly1305-generic fallback for small updates.

For large messages, throughput increases by ~5-10% compared to
poly1305-generic:

testing speed of poly1305 (poly1305-generic)
test  0 (   96 byte blocks,   16 bytes per update,   6 updates): 4080026 opers/sec,  391682496 bytes/sec
test  1 (   96 byte blocks,   32 bytes per update,   3 updates): 6221094 opers/sec,  597225024 bytes/sec
test  2 (   96 byte blocks,   96 bytes per update,   1 updates): 9609750 opers/sec,  922536057 bytes/sec
test  3 (  288 byte blocks,   16 bytes per update,  18 updates): 1459379 opers/sec,  420301267 bytes/sec
test  4 (  288 byte blocks,   32 bytes per update,   9 updates): 2115179 opers/sec,  609171609 bytes/sec
test  5 (  288 byte blocks,  288 bytes per update,   1 updates): 3729874 opers/sec, 1074203856 bytes/sec
test  6 ( 1056 byte blocks,   32 bytes per update,  33 updates):  593000 opers/sec,  626208000 bytes/sec
test  7 ( 1056 byte blocks, 1056 bytes per update,   1 updates): 1081536 opers/sec, 1142102332 bytes/sec
test  8 ( 2080 byte blocks,   32 bytes per update,  65 updates):  302077 opers/sec,  628320576 bytes/sec
test  9 ( 2080 byte blocks, 2080 bytes per update,   1 updates):  554384 opers/sec, 1153120176 bytes/sec
test 10 ( 4128 byte blocks, 4128 bytes per update,   1 updates):  278715 opers/sec, 1150536345 bytes/sec
test 11 ( 8224 byte blocks, 8224 bytes per update,   1 updates):  140202 opers/sec, 1153022070 bytes/sec

testing speed of poly1305 (poly1305-simd)
test  0 (   96 byte blocks,   16 bytes per update,   6 updates): 3790063 opers/sec,  363846076 bytes/sec
test  1 (   96 byte blocks,   32 bytes per update,   3 updates): 5913378 opers/sec,  567684355 bytes/sec
test  2 (   96 byte blocks,   96 bytes per update,   1 updates): 9352574 opers/sec,  897847104 bytes/sec
test  3 (  288 byte blocks,   16 bytes per update,  18 updates): 1362145 opers/sec,  392297990 bytes/sec
test  4 (  288 byte blocks,   32 bytes per update,   9 updates): 2007075 opers/sec,  578037628 bytes/sec
test  5 (  288 byte blocks,  288 bytes per update,   1 updates): 3709811 opers/sec, 1068425798 bytes/sec
test  6 ( 1056 byte blocks,   32 bytes per update,  33 updates):  566272 opers/sec,  597984182 bytes/sec
test  7 ( 1056 byte blocks, 1056 bytes per update,   1 updates): 1111657 opers/sec, 1173910108 bytes/sec
test  8 ( 2080 byte blocks,   32 bytes per update,  65 updates):  288857 opers/sec,  600823808 bytes/sec
test  9 ( 2080 byte blocks, 2080 bytes per update,   1 updates):  590746 opers/sec, 1228751888 bytes/sec
test 10 ( 4128 byte blocks, 4128 bytes per update,   1 updates):  301825 opers/sec, 1245936902 bytes/sec
test 11 ( 8224 byte blocks, 8224 bytes per update,   1 updates):  153075 opers/sec, 1258896201 bytes/sec

Benchmark results from a Core i5-4670T.

Signed-off-by: Martin Willi <martin@strongswan.org>
---
 arch/x86/crypto/Makefile               |   2 +
 arch/x86/crypto/poly1305-sse2-x86_64.S | 276 +++++++++++++++++++++++++++++++++
 arch/x86/crypto/poly1305_glue.c        | 123 +++++++++++++++
 crypto/Kconfig                         |  12 ++
 4 files changed, 413 insertions(+)
 create mode 100644 arch/x86/crypto/poly1305-sse2-x86_64.S
 create mode 100644 arch/x86/crypto/poly1305_glue.c

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index ce39b3c..5cf405c 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -31,6 +31,7 @@ obj-$(CONFIG_CRYPTO_CRC32_PCLMUL) += crc32-pclmul.o
 obj-$(CONFIG_CRYPTO_SHA256_SSSE3) += sha256-ssse3.o
 obj-$(CONFIG_CRYPTO_SHA512_SSSE3) += sha512-ssse3.o
 obj-$(CONFIG_CRYPTO_CRCT10DIF_PCLMUL) += crct10dif-pclmul.o
+obj-$(CONFIG_CRYPTO_POLY1305_X86_64) += poly1305-x86_64.o
 
 # These modules require assembler to support AVX.
 ifeq ($(avx_supported),yes)
@@ -85,6 +86,7 @@ aesni-intel-y := aesni-intel_asm.o aesni-intel_glue.o fpu.o
 aesni-intel-$(CONFIG_64BIT) += aesni-intel_avx-x86_64.o aes_ctrby8_avx-x86_64.o
 ghash-clmulni-intel-y := ghash-clmulni-intel_asm.o ghash-clmulni-intel_glue.o
 sha1-ssse3-y := sha1_ssse3_asm.o sha1_ssse3_glue.o
+poly1305-x86_64-y := poly1305-sse2-x86_64.o poly1305_glue.o
 ifeq ($(avx2_supported),yes)
 sha1-ssse3-y += sha1_avx2_x86_64_asm.o
 endif
diff --git a/arch/x86/crypto/poly1305-sse2-x86_64.S b/arch/x86/crypto/poly1305-sse2-x86_64.S
new file mode 100644
index 0000000..a3d2b5e
--- /dev/null
+++ b/arch/x86/crypto/poly1305-sse2-x86_64.S
@@ -0,0 +1,276 @@
+/*
+ * Poly1305 authenticator algorithm, RFC7539, x64 SSE2 functions
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
+ANMASK:	.octa 0x0000000003ffffff0000000003ffffff
+
+.text
+
+#define h0 0x00(%rdi)
+#define h1 0x04(%rdi)
+#define h2 0x08(%rdi)
+#define h3 0x0c(%rdi)
+#define h4 0x10(%rdi)
+#define r0 0x00(%rdx)
+#define r1 0x04(%rdx)
+#define r2 0x08(%rdx)
+#define r3 0x0c(%rdx)
+#define r4 0x10(%rdx)
+#define s1 0x00(%rsp)
+#define s2 0x04(%rsp)
+#define s3 0x08(%rsp)
+#define s4 0x0c(%rsp)
+#define m %rsi
+#define h01 %xmm0
+#define h23 %xmm1
+#define h44 %xmm2
+#define t1 %xmm3
+#define t2 %xmm4
+#define t3 %xmm5
+#define t4 %xmm6
+#define mask %xmm7
+#define d0 %r8
+#define d1 %r9
+#define d2 %r10
+#define d3 %r11
+#define d4 %r12
+
+ENTRY(poly1305_block_sse2)
+	# %rdi: Accumulator h[5]
+	# %rsi: 16 byte input block m
+	# %rdx: Poly1305 key r[5]
+	# %rcx: Block count
+
+	# This single block variant tries to improve performance by doing two
+	# multiplications in parallel using SSE instructions. There is quite
+	# some quardword packing involved, hence the speedup is marginal.
+
+	push		%rbx
+	push		%r12
+	sub		$0x10,%rsp
+
+	# s1..s4 = r1..r4 * 5
+	mov		r1,%eax
+	lea		(%eax,%eax,4),%eax
+	mov		%eax,s1
+	mov		r2,%eax
+	lea		(%eax,%eax,4),%eax
+	mov		%eax,s2
+	mov		r3,%eax
+	lea		(%eax,%eax,4),%eax
+	mov		%eax,s3
+	mov		r4,%eax
+	lea		(%eax,%eax,4),%eax
+	mov		%eax,s4
+
+	movdqa		ANMASK(%rip),mask
+
+.Ldoblock:
+	# h01 = [0, h1, 0, h0]
+	# h23 = [0, h3, 0, h2]
+	# h44 = [0, h4, 0, h4]
+	movd		h0,h01
+	movd		h1,t1
+	movd		h2,h23
+	movd		h3,t2
+	movd		h4,h44
+	punpcklqdq	t1,h01
+	punpcklqdq	t2,h23
+	punpcklqdq	h44,h44
+
+	# h01 += [ (m[3-6] >> 2) & 0x3ffffff, m[0-3] & 0x3ffffff ]
+	movd		0x00(m),t1
+	movd		0x03(m),t2
+	psrld		$2,t2
+	punpcklqdq	t2,t1
+	pand		mask,t1
+	paddd		t1,h01
+	# h23 += [ (m[9-12] >> 6) & 0x3ffffff, (m[6-9] >> 4) & 0x3ffffff ]
+	movd		0x06(m),t1
+	movd		0x09(m),t2
+	psrld		$4,t1
+	psrld		$6,t2
+	punpcklqdq	t2,t1
+	pand		mask,t1
+	paddd		t1,h23
+	# h44 += [ (m[12-15] >> 8) | (1 << 24), (m[12-15] >> 8) | (1 << 24) ]
+	mov		0x0c(m),%eax
+	shr		$8,%eax
+	or		$0x01000000,%eax
+	movd		%eax,t1
+	pshufd		$0xc4,t1,t1
+	paddd		t1,h44
+
+	# t1[0] = h0 * r0 + h2 * s3
+	# t1[1] = h1 * s4 + h3 * s2
+	movd		r0,t1
+	movd		s4,t2
+	punpcklqdq	t2,t1
+	pmuludq		h01,t1
+	movd		s3,t2
+	movd		s2,t3
+	punpcklqdq	t3,t2
+	pmuludq		h23,t2
+	paddq		t2,t1
+	# t2[0] = h0 * r1 + h2 * s4
+	# t2[1] = h1 * r0 + h3 * s3
+	movd		r1,t2
+	movd		r0,t3
+	punpcklqdq	t3,t2
+	pmuludq		h01,t2
+	movd		s4,t3
+	movd		s3,t4
+	punpcklqdq	t4,t3
+	pmuludq		h23,t3
+	paddq		t3,t2
+	# t3[0] = h4 * s1
+	# t3[1] = h4 * s2
+	movd		s1,t3
+	movd		s2,t4
+	punpcklqdq	t4,t3
+	pmuludq		h44,t3
+	# d0 = t1[0] + t1[1] + t3[0]
+	# d1 = t2[0] + t2[1] + t3[1]
+	movdqa		t1,t4
+	punpcklqdq	t2,t4
+	punpckhqdq	t2,t1
+	paddq		t4,t1
+	paddq		t3,t1
+	movq		t1,d0
+	psrldq		$8,t1
+	movq		t1,d1
+
+	# t1[0] = h0 * r2 + h2 * r0
+	# t1[1] = h1 * r1 + h3 * s4
+	movd		r2,t1
+	movd		r1,t2
+	punpcklqdq 	t2,t1
+	pmuludq		h01,t1
+	movd		r0,t2
+	movd		s4,t3
+	punpcklqdq	t3,t2
+	pmuludq		h23,t2
+	paddq		t2,t1
+	# t2[0] = h0 * r3 + h2 * r1
+	# t2[1] = h1 * r2 + h3 * r0
+	movd		r3,t2
+	movd		r2,t3
+	punpcklqdq	t3,t2
+	pmuludq		h01,t2
+	movd		r1,t3
+	movd		r0,t4
+	punpcklqdq	t4,t3
+	pmuludq		h23,t3
+	paddq		t3,t2
+	# t3[0] = h4 * s3
+	# t3[1] = h4 * s4
+	movd		s3,t3
+	movd		s4,t4
+	punpcklqdq	t4,t3
+	pmuludq		h44,t3
+	# d2 = t1[0] + t1[1] + t3[0]
+	# d3 = t2[0] + t2[1] + t3[1]
+	movdqa		t1,t4
+	punpcklqdq	t2,t4
+	punpckhqdq	t2,t1
+	paddq		t4,t1
+	paddq		t3,t1
+	movq		t1,d2
+	psrldq		$8,t1
+	movq		t1,d3
+
+	# t1[0] = h0 * r4 + h2 * r2
+	# t1[1] = h1 * r3 + h3 * r1
+	movd		r4,t1
+	movd		r3,t2
+	punpcklqdq	t2,t1
+	pmuludq		h01,t1
+	movd		r2,t2
+	movd		r1,t3
+	punpcklqdq	t3,t2
+	pmuludq		h23,t2
+	paddq		t2,t1
+	# t3[0] = h4 * r0
+	movd		r0,t3
+	pmuludq		h44,t3
+	# d4 = t1[0] + t1[1] + t3[0]
+	movdqa		t1,t4
+	psrldq		$8,t4
+	paddq		t4,t1
+	paddq		t3,t1
+	movq		t1,d4
+
+	# d1 += d0 >> 26
+	mov		d0,%rax
+	shr		$26,%rax
+	add		%rax,d1
+	# h0 = d0 & 0x3ffffff
+	mov		d0,%rbx
+	and		$0x3ffffff,%ebx
+
+	# d2 += d1 >> 26
+	mov		d1,%rax
+	shr		$26,%rax
+	add		%rax,d2
+	# h1 = d1 & 0x3ffffff
+	mov		d1,%rax
+	and		$0x3ffffff,%eax
+	mov		%eax,h1
+
+	# d3 += d2 >> 26
+	mov		d2,%rax
+	shr		$26,%rax
+	add		%rax,d3
+	# h2 = d2 & 0x3ffffff
+	mov		d2,%rax
+	and		$0x3ffffff,%eax
+	mov		%eax,h2
+
+	# d4 += d3 >> 26
+	mov		d3,%rax
+	shr		$26,%rax
+	add		%rax,d4
+	# h3 = d3 & 0x3ffffff
+	mov		d3,%rax
+	and		$0x3ffffff,%eax
+	mov		%eax,h3
+
+	# h0 += (d4 >> 26) * 5
+	mov		d4,%rax
+	shr		$26,%rax
+	lea		(%eax,%eax,4),%eax
+	add		%eax,%ebx
+	# h4 = d4 & 0x3ffffff
+	mov		d4,%rax
+	and		$0x3ffffff,%eax
+	mov		%eax,h4
+
+	# h1 += h0 >> 26
+	mov		%ebx,%eax
+	shr		$26,%eax
+	add		%eax,h1
+	# h0 = h0 & 0x3ffffff
+	andl		$0x3ffffff,%ebx
+	mov		%ebx,h0
+
+	add		$0x10,m
+	dec		%rcx
+	jnz		.Ldoblock
+
+	add		$0x10,%rsp
+	pop		%r12
+	pop		%rbx
+	ret
+ENDPROC(poly1305_block_sse2)
diff --git a/arch/x86/crypto/poly1305_glue.c b/arch/x86/crypto/poly1305_glue.c
new file mode 100644
index 0000000..1e59274
--- /dev/null
+++ b/arch/x86/crypto/poly1305_glue.c
@@ -0,0 +1,123 @@
+/*
+ * Poly1305 authenticator algorithm, RFC7539, SIMD glue code
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
+#include <crypto/internal/hash.h>
+#include <crypto/poly1305.h>
+#include <linux/crypto.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <asm/fpu/api.h>
+#include <asm/simd.h>
+
+asmlinkage void poly1305_block_sse2(u32 *h, const u8 *src,
+				    const u32 *r, unsigned int blocks);
+
+static unsigned int poly1305_simd_blocks(struct poly1305_desc_ctx *dctx,
+					 const u8 *src, unsigned int srclen)
+{
+	unsigned int blocks, datalen;
+
+	if (unlikely(!dctx->sset)) {
+		datalen = crypto_poly1305_setdesckey(dctx, src, srclen);
+		src += srclen - datalen;
+		srclen = datalen;
+	}
+
+	if (srclen >= POLY1305_BLOCK_SIZE) {
+		blocks = srclen / POLY1305_BLOCK_SIZE;
+		poly1305_block_sse2(dctx->h, src, dctx->r, blocks);
+		srclen -= POLY1305_BLOCK_SIZE * blocks;
+	}
+	return srclen;
+}
+
+static int poly1305_simd_update(struct shash_desc *desc,
+				const u8 *src, unsigned int srclen)
+{
+	struct poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
+	unsigned int bytes;
+
+	/* kernel_fpu_begin/end is costly, use fallback for small updates */
+	if (srclen <= 288 || !may_use_simd())
+		return crypto_poly1305_update(desc, src, srclen);
+
+	kernel_fpu_begin();
+
+	if (unlikely(dctx->buflen)) {
+		bytes = min(srclen, POLY1305_BLOCK_SIZE - dctx->buflen);
+		memcpy(dctx->buf + dctx->buflen, src, bytes);
+		src += bytes;
+		srclen -= bytes;
+		dctx->buflen += bytes;
+
+		if (dctx->buflen == POLY1305_BLOCK_SIZE) {
+			poly1305_simd_blocks(dctx, dctx->buf,
+					     POLY1305_BLOCK_SIZE);
+			dctx->buflen = 0;
+		}
+	}
+
+	if (likely(srclen >= POLY1305_BLOCK_SIZE)) {
+		bytes = poly1305_simd_blocks(dctx, src, srclen);
+		src += srclen - bytes;
+		srclen = bytes;
+	}
+
+	kernel_fpu_end();
+
+	if (unlikely(srclen)) {
+		dctx->buflen = srclen;
+		memcpy(dctx->buf, src, srclen);
+	}
+
+	return 0;
+}
+
+static struct shash_alg alg = {
+	.digestsize	= POLY1305_DIGEST_SIZE,
+	.init		= crypto_poly1305_init,
+	.update		= poly1305_simd_update,
+	.final		= crypto_poly1305_final,
+	.setkey		= crypto_poly1305_setkey,
+	.descsize	= sizeof(struct poly1305_desc_ctx),
+	.base		= {
+		.cra_name		= "poly1305",
+		.cra_driver_name	= "poly1305-simd",
+		.cra_priority		= 300,
+		.cra_flags		= CRYPTO_ALG_TYPE_SHASH,
+		.cra_alignmask		= sizeof(u32) - 1,
+		.cra_blocksize		= POLY1305_BLOCK_SIZE,
+		.cra_module		= THIS_MODULE,
+	},
+};
+
+static int __init poly1305_simd_mod_init(void)
+{
+	if (!cpu_has_xmm2)
+		return -ENODEV;
+
+	return crypto_register_shash(&alg);
+}
+
+static void __exit poly1305_simd_mod_exit(void)
+{
+	crypto_unregister_shash(&alg);
+}
+
+module_init(poly1305_simd_mod_init);
+module_exit(poly1305_simd_mod_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Martin Willi <martin@strongswan.org>");
+MODULE_DESCRIPTION("Poly1305 authenticator");
+MODULE_ALIAS_CRYPTO("poly1305");
+MODULE_ALIAS_CRYPTO("poly1305-simd");
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 82caab0..c57478c 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -470,6 +470,18 @@ config CRYPTO_POLY1305
 	  It is used for the ChaCha20-Poly1305 AEAD, specified in RFC7539 for use
 	  in IETF protocols. This is the portable C implementation of Poly1305.
 
+config CRYPTO_POLY1305_X86_64
+	tristate "Poly1305 authenticator algorithm (x86_64/SSE2)"
+	depends on X86 && 64BIT
+	select CRYPTO_POLY1305
+	help
+	  Poly1305 authenticator algorithm, RFC7539.
+
+	  Poly1305 is an authenticator algorithm designed by Daniel J. Bernstein.
+	  It is used for the ChaCha20-Poly1305 AEAD, specified in RFC7539 for use
+	  in IETF protocols. This is the x86_64 assembler implementation using SIMD
+	  instructions.
+
 config CRYPTO_MD4
 	tristate "MD4 digest algorithm"
 	select CRYPTO_HASH
-- 
1.9.1
