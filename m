Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2443353A65;
	Mon, 21 Sep 2026 05:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789967773; cv=none; b=CH6dGk4QH0/20NOTuPkwD0M1OTReKBMhlVQNBnRY/B+XQ2NuWvTbj1Xax7+/NRM/wcduNRLSqNH8Tr6CdnQWtaOt3b8bCnUtJt3se6D5RyuzWu700DO6WMungV2jRrG+W3vYstOlJDD22bRG8fuziuDstM6//siinv4sn/O/l5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789967773; c=relaxed/simple;
	bh=LsE2vmlgbkaxmbjgsiAWLEGy6zXp+UESQ+dwDznW6AY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VONw6TlVvLNzXyMvKZA+1CVXig+t/cEjDjFS0ND+xRcBexOCijI1J9aTB0N6F6sg1oT+lxD2nmCnwE84Xv/buw9kRrVHMiXgGJf+KYqVXwjuhjJE8W2hqSbTA/48jeqRkMmQtIrfEOtChkC5b45LTMzLUvhpm/Kuuzv+3faEVck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W0YAIjI+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W0YAIjI+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04D291F00893;
	Mon, 21 Sep 2026 05:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789967768;
	bh=nQAxI9vIMtDk2I+S4IW8A5jdoMKPiNLsvoe4yfa0L3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W0YAIjI+t30bZvQYizfK0VUjZFStlmvnnZnjGaKMQJIiGreK/9pdQiphPvNwv3lj2
	 OC9CAE1ND1Ky6O4gMIuUPLkJQ8NjdMBjUIjKchQ6deRo36eRWxWRh8Bd5Ve4FSyZYB
	 porB0DO+Y0rhwwxB3mtURvdEVvarjR3XqzAKvqjjKjiCKM57/NEvkBzEVU2jcqIbOb
	 Y5FZPi3OoNc8UifPxYOUez2zqrl98B4Vajs37POxYiwlU++7/o5KlHlhzkQLxyHP0O
	 RfPfs1/iUayaChbb7kKMdiKny9ZJ3jvE9PaD41YeHMP6dchCpDZUboymu6m9AAS8Ci
	 Wm31OtX4d7qQQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	linux-riscv@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 13/20] lib/crypto: x86/aes-xts: Migrate AVX-optimized code into library
Date: Sun, 20 Sep 2026 22:08:59 -0700
Message-ID: <20260921050910.296144-14-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260921050910.296144-1-ebiggers@kernel.org>
References: <20260921050910.296144-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Migrate aes-xts-avx-x86_64.S into lib/crypto/, wiring it up to the XTS
library functions instead of the crypto_skcipher API.  It still remains
available through crypto_skcipher via crypto/aes.c.

Some adjustments to the assembly code were needed:

- Take 'struct aes_key' instead of 'struct crypto_aes_ctx'.

- Remove the ciphertext stealing support from the assembly code, as the
  library implements it in a generic way instead.  (This does slightly
  reduce performance when the length isn't a multiple of 16 bytes;
  however, that case seems to never be reached in practice in the
  kernel.  So it makes sense to not extensively optimize for it yet.)

- Change 'int len' to 'long nblocks' for compatibility with the
  library's use of size_t lengths.

- Remove the CFI stubs, as the functions are now called directly.

To reduce the diff, the argument order of the assembly functions is kept
as-is for now rather than changed to match their callers.

This makes the remaining code in aesni-intel_asm.S (which just handled
key expansion) unused, so remove that too.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/x86/crypto/Kconfig                       |   4 +-
 arch/x86/crypto/Makefile                      |   5 +-
 arch/x86/crypto/aesni-intel_asm.S             | 220 ----------------
 arch/x86/crypto/aesni-intel_glue.c            | 236 +-----------------
 crypto/aes.c                                  |   2 +-
 lib/crypto/Makefile                           |   3 +
 .../crypto/x86}/aes-xts-avx-x86_64.S          | 172 ++++---------
 lib/crypto/x86/aes.h                          |  62 ++++-
 8 files changed, 107 insertions(+), 597 deletions(-)
 delete mode 100644 arch/x86/crypto/aesni-intel_asm.S
 rename {arch/x86/crypto => lib/crypto/x86}/aes-xts-avx-x86_64.S (81%)

diff --git a/arch/x86/crypto/Kconfig b/arch/x86/crypto/Kconfig
index 60d9a144d63a..d68b31fad508 100644
--- a/arch/x86/crypto/Kconfig
+++ b/arch/x86/crypto/Kconfig
@@ -3,14 +3,12 @@
 menu "Accelerated Cryptographic Algorithms for CPU (x86)"
 
 config CRYPTO_AES_NI_INTEL
-	tristate "Ciphers: AES, modes: XTS, GCM (AES-NI/VAES)"
+	tristate "Ciphers: AES, modes: GCM (AES-NI/VAES)"
 	select CRYPTO_AEAD
 	select CRYPTO_LIB_AES
 	select CRYPTO_LIB_GF128MUL
-	select CRYPTO_SKCIPHER
 	help
 	  AEAD cipher: AES with GCM
-	  Length-preserving ciphers: AES with XTS
 
 	  Architecture: x86 (32-bit and 64-bit) using:
 	  - AES-NI (AES new instructions)
diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index 370a9cc7eab2..e05d6e2257d4 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -40,11 +40,10 @@ obj-$(CONFIG_CRYPTO_AEGIS128_AESNI_SSE2) += aegis128-aesni.o
 aegis128-aesni-y := aegis128-aesni-asm.o aegis128-aesni-glue.o
 
 obj-$(CONFIG_CRYPTO_AES_NI_INTEL) += aesni-intel.o
-aesni-intel-y := aesni-intel_asm.o aesni-intel_glue.o
+aesni-intel-y := aesni-intel_glue.o
 aesni-intel-$(CONFIG_64BIT) += aes-gcm-aesni-x86_64.o \
 			       aes-gcm-vaes-avx2.o \
-			       aes-gcm-vaes-avx512.o \
-			       aes-xts-avx-x86_64.o
+			       aes-gcm-vaes-avx512.o
 
 obj-$(CONFIG_CRYPTO_SM4_AESNI_AVX_X86_64) += sm4-aesni-avx-x86_64.o
 sm4-aesni-avx-x86_64-y := sm4-aesni-avx-asm_64.o sm4_aesni_avx_glue.o
diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
deleted file mode 100644
index b12a0f2bf006..000000000000
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ /dev/null
@@ -1,220 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-or-later */
-/*
- * Implement AES algorithm in Intel AES-NI instructions.
- *
- * The white paper of AES-NI instructions can be downloaded from:
- *   http://softwarecommunity.intel.com/isn/downloads/intelavx/AES-Instructions-Set_WP.pdf
- *
- * Copyright (C) 2008, Intel Corp.
- *    Author: Huang Ying <ying.huang@intel.com>
- *            Vinodh Gopal <vinodh.gopal@intel.com>
- *            Kahraman Akdemir
- *
- * Copyright (c) 2010, Intel Corporation.
- *
- * Ported x86_64 version to x86:
- *    Author: Mathias Krause <minipli@googlemail.com>
- */
-
-#include <linux/linkage.h>
-#include <linux/objtool.h>
-#include <asm/frame.h>
-
-#ifdef __x86_64__
-#define AREG	%rax
-#define KEYP	%rdi
-#define OUTP	%rsi
-#define UKEYP	OUTP
-#define T1	%r10
-#define TKEYP	T1
-#define T2	%r11
-#else
-#define AREG	%eax
-#define KEYP	%edi
-#define OUTP	AREG
-#define UKEYP	OUTP
-#define T1	%ecx
-#define TKEYP	T1
-#endif
-
-SYM_FUNC_START_LOCAL(_key_expansion_256a)
-	pshufd $0b11111111, %xmm1, %xmm1
-	shufps $0b00010000, %xmm0, %xmm4
-	pxor %xmm4, %xmm0
-	shufps $0b10001100, %xmm0, %xmm4
-	pxor %xmm4, %xmm0
-	pxor %xmm1, %xmm0
-	movaps %xmm0, (TKEYP)
-	add $0x10, TKEYP
-	RET
-SYM_FUNC_END(_key_expansion_256a)
-SYM_FUNC_ALIAS_LOCAL(_key_expansion_128, _key_expansion_256a)
-
-SYM_FUNC_START_LOCAL(_key_expansion_192a)
-	pshufd $0b01010101, %xmm1, %xmm1
-	shufps $0b00010000, %xmm0, %xmm4
-	pxor %xmm4, %xmm0
-	shufps $0b10001100, %xmm0, %xmm4
-	pxor %xmm4, %xmm0
-	pxor %xmm1, %xmm0
-
-	movaps %xmm2, %xmm5
-	movaps %xmm2, %xmm6
-	pslldq $4, %xmm5
-	pshufd $0b11111111, %xmm0, %xmm3
-	pxor %xmm3, %xmm2
-	pxor %xmm5, %xmm2
-
-	movaps %xmm0, %xmm1
-	shufps $0b01000100, %xmm0, %xmm6
-	movaps %xmm6, (TKEYP)
-	shufps $0b01001110, %xmm2, %xmm1
-	movaps %xmm1, 0x10(TKEYP)
-	add $0x20, TKEYP
-	RET
-SYM_FUNC_END(_key_expansion_192a)
-
-SYM_FUNC_START_LOCAL(_key_expansion_192b)
-	pshufd $0b01010101, %xmm1, %xmm1
-	shufps $0b00010000, %xmm0, %xmm4
-	pxor %xmm4, %xmm0
-	shufps $0b10001100, %xmm0, %xmm4
-	pxor %xmm4, %xmm0
-	pxor %xmm1, %xmm0
-
-	movaps %xmm2, %xmm5
-	pslldq $4, %xmm5
-	pshufd $0b11111111, %xmm0, %xmm3
-	pxor %xmm3, %xmm2
-	pxor %xmm5, %xmm2
-
-	movaps %xmm0, (TKEYP)
-	add $0x10, TKEYP
-	RET
-SYM_FUNC_END(_key_expansion_192b)
-
-SYM_FUNC_START_LOCAL(_key_expansion_256b)
-	pshufd $0b10101010, %xmm1, %xmm1
-	shufps $0b00010000, %xmm2, %xmm4
-	pxor %xmm4, %xmm2
-	shufps $0b10001100, %xmm2, %xmm4
-	pxor %xmm4, %xmm2
-	pxor %xmm1, %xmm2
-	movaps %xmm2, (TKEYP)
-	add $0x10, TKEYP
-	RET
-SYM_FUNC_END(_key_expansion_256b)
-
-/*
- * void aesni_set_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
- *                    unsigned int key_len)
- */
-SYM_FUNC_START(aesni_set_key)
-	FRAME_BEGIN
-#ifndef __x86_64__
-	pushl KEYP
-	movl (FRAME_OFFSET+8)(%esp), KEYP	# ctx
-	movl (FRAME_OFFSET+12)(%esp), UKEYP	# in_key
-	movl (FRAME_OFFSET+16)(%esp), %edx	# key_len
-#endif
-	movups (UKEYP), %xmm0		# user key (first 16 bytes)
-	movaps %xmm0, (KEYP)
-	lea 0x10(KEYP), TKEYP		# key addr
-	movl %edx, 480(KEYP)
-	pxor %xmm4, %xmm4		# xmm4 is assumed 0 in _key_expansion_x
-	cmp $24, %dl
-	jb .Lenc_key128
-	je .Lenc_key192
-	movups 0x10(UKEYP), %xmm2	# other user key
-	movaps %xmm2, (TKEYP)
-	add $0x10, TKEYP
-	aeskeygenassist $0x1, %xmm2, %xmm1	# round 1
-	call _key_expansion_256a
-	aeskeygenassist $0x1, %xmm0, %xmm1
-	call _key_expansion_256b
-	aeskeygenassist $0x2, %xmm2, %xmm1	# round 2
-	call _key_expansion_256a
-	aeskeygenassist $0x2, %xmm0, %xmm1
-	call _key_expansion_256b
-	aeskeygenassist $0x4, %xmm2, %xmm1	# round 3
-	call _key_expansion_256a
-	aeskeygenassist $0x4, %xmm0, %xmm1
-	call _key_expansion_256b
-	aeskeygenassist $0x8, %xmm2, %xmm1	# round 4
-	call _key_expansion_256a
-	aeskeygenassist $0x8, %xmm0, %xmm1
-	call _key_expansion_256b
-	aeskeygenassist $0x10, %xmm2, %xmm1	# round 5
-	call _key_expansion_256a
-	aeskeygenassist $0x10, %xmm0, %xmm1
-	call _key_expansion_256b
-	aeskeygenassist $0x20, %xmm2, %xmm1	# round 6
-	call _key_expansion_256a
-	aeskeygenassist $0x20, %xmm0, %xmm1
-	call _key_expansion_256b
-	aeskeygenassist $0x40, %xmm2, %xmm1	# round 7
-	call _key_expansion_256a
-	jmp .Ldec_key
-.Lenc_key192:
-	movq 0x10(UKEYP), %xmm2		# other user key
-	aeskeygenassist $0x1, %xmm2, %xmm1	# round 1
-	call _key_expansion_192a
-	aeskeygenassist $0x2, %xmm2, %xmm1	# round 2
-	call _key_expansion_192b
-	aeskeygenassist $0x4, %xmm2, %xmm1	# round 3
-	call _key_expansion_192a
-	aeskeygenassist $0x8, %xmm2, %xmm1	# round 4
-	call _key_expansion_192b
-	aeskeygenassist $0x10, %xmm2, %xmm1	# round 5
-	call _key_expansion_192a
-	aeskeygenassist $0x20, %xmm2, %xmm1	# round 6
-	call _key_expansion_192b
-	aeskeygenassist $0x40, %xmm2, %xmm1	# round 7
-	call _key_expansion_192a
-	aeskeygenassist $0x80, %xmm2, %xmm1	# round 8
-	call _key_expansion_192b
-	jmp .Ldec_key
-.Lenc_key128:
-	aeskeygenassist $0x1, %xmm0, %xmm1	# round 1
-	call _key_expansion_128
-	aeskeygenassist $0x2, %xmm0, %xmm1	# round 2
-	call _key_expansion_128
-	aeskeygenassist $0x4, %xmm0, %xmm1	# round 3
-	call _key_expansion_128
-	aeskeygenassist $0x8, %xmm0, %xmm1	# round 4
-	call _key_expansion_128
-	aeskeygenassist $0x10, %xmm0, %xmm1	# round 5
-	call _key_expansion_128
-	aeskeygenassist $0x20, %xmm0, %xmm1	# round 6
-	call _key_expansion_128
-	aeskeygenassist $0x40, %xmm0, %xmm1	# round 7
-	call _key_expansion_128
-	aeskeygenassist $0x80, %xmm0, %xmm1	# round 8
-	call _key_expansion_128
-	aeskeygenassist $0x1b, %xmm0, %xmm1	# round 9
-	call _key_expansion_128
-	aeskeygenassist $0x36, %xmm0, %xmm1	# round 10
-	call _key_expansion_128
-.Ldec_key:
-	sub $0x10, TKEYP
-	movaps (KEYP), %xmm0
-	movaps (TKEYP), %xmm1
-	movaps %xmm0, 240(TKEYP)
-	movaps %xmm1, 240(KEYP)
-	add $0x10, KEYP
-	lea 240-16(TKEYP), UKEYP
-.align 4
-.Ldec_key_loop:
-	movaps (KEYP), %xmm0
-	aesimc %xmm0, %xmm1
-	movaps %xmm1, (UKEYP)
-	add $0x10, KEYP
-	sub $0x10, UKEYP
-	cmp TKEYP, KEYP
-	jb .Ldec_key_loop
-#ifndef __x86_64__
-	popl KEYP
-#endif
-	FRAME_END
-	RET
-SYM_FUNC_END(aesni_set_key)
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 0bda9abae368..3f86c8997d7d 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Support for AES-NI and VAES instructions.  This file contains glue code.
- * The real AES implementations are in aesni-intel_asm.S and other .S files.
+ * The real AES implementations are in .S files.
  *
  * Copyright (C) 2008, Intel Corp.
  *    Author: Huang Ying <ying.huang@intel.com>
@@ -26,7 +26,6 @@
 #include <crypto/b128ops.h>
 #include <crypto/gcm.h>
 #include <crypto/gf128mul.h>
-#include <crypto/xts.h>
 #include <asm/cpu_device_id.h>
 #include <asm/simd.h>
 #include <crypto/scatterwalk.h>
@@ -38,218 +37,7 @@
 #include <linux/spinlock.h>
 #include <linux/static_call.h>
 
-
-#define AESNI_ALIGN	16
-#define AESNI_ALIGN_ATTR __attribute__ ((__aligned__(AESNI_ALIGN)))
-#define AESNI_ALIGN_EXTRA ((AESNI_ALIGN - 1) & ~(CRYPTO_MINALIGN - 1))
-#define XTS_AES_CTX_SIZE (sizeof(struct aesni_xts_ctx) + AESNI_ALIGN_EXTRA)
-
-struct aesni_xts_ctx {
-	struct crypto_aes_ctx tweak_ctx AESNI_ALIGN_ATTR;
-	struct crypto_aes_ctx crypt_ctx AESNI_ALIGN_ATTR;
-};
-
-static inline void *aes_align_addr(void *addr)
-{
-	if (crypto_tfm_ctx_alignment() >= AESNI_ALIGN)
-		return addr;
-	return PTR_ALIGN(addr, AESNI_ALIGN);
-}
-
-asmlinkage void aesni_set_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
-			      unsigned int key_len);
-
-static inline struct aesni_xts_ctx *aes_xts_ctx(struct crypto_skcipher *tfm)
-{
-	return aes_align_addr(crypto_skcipher_ctx(tfm));
-}
-
-static int aes_set_key_common(struct crypto_aes_ctx *ctx,
-			      const u8 *in_key, unsigned int key_len)
-{
-	int err;
-
-	if (!crypto_simd_usable())
-		return aes_expandkey(ctx, in_key, key_len);
-
-	err = aes_check_keylen(key_len);
-	if (err)
-		return err;
-
-	kernel_fpu_begin();
-	aesni_set_key(ctx, in_key, key_len);
-	kernel_fpu_end();
-	return 0;
-}
-
-static int xts_setkey_aesni(struct crypto_skcipher *tfm, const u8 *key,
-			    unsigned int keylen)
-{
-	struct aesni_xts_ctx *ctx = aes_xts_ctx(tfm);
-	int err;
-
-	err = xts_verify_key(tfm, key, keylen);
-	if (err)
-		return err;
-
-	keylen /= 2;
-
-	/* first half of xts-key is for crypt */
-	err = aes_set_key_common(&ctx->crypt_ctx, key, keylen);
-	if (err)
-		return err;
-
-	/* second half of xts-key is for tweak */
-	return aes_set_key_common(&ctx->tweak_ctx, key + keylen, keylen);
-}
-
-typedef void (*xts_encrypt_iv_func)(const struct crypto_aes_ctx *tweak_key,
-				    u8 iv[AES_BLOCK_SIZE]);
-typedef void (*xts_crypt_func)(const struct crypto_aes_ctx *key,
-			       const u8 *src, u8 *dst, int len,
-			       u8 tweak[AES_BLOCK_SIZE]);
-
-/* This handles cases where the source and/or destination span pages. */
-static noinline int
-xts_crypt_slowpath(struct skcipher_request *req, xts_crypt_func crypt_func)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	const struct aesni_xts_ctx *ctx = aes_xts_ctx(tfm);
-	int tail = req->cryptlen % AES_BLOCK_SIZE;
-	struct scatterlist sg_src[2], sg_dst[2];
-	struct skcipher_request subreq;
-	struct skcipher_walk walk;
-	struct scatterlist *src, *dst;
-	int err;
-
-	/*
-	 * If the message length isn't divisible by the AES block size, then
-	 * separate off the last full block and the partial block.  This ensures
-	 * that they are processed in the same call to the assembly function,
-	 * which is required for ciphertext stealing.
-	 */
-	if (tail) {
-		skcipher_request_set_tfm(&subreq, tfm);
-		skcipher_request_set_callback(&subreq,
-					      skcipher_request_flags(req),
-					      NULL, NULL);
-		skcipher_request_set_crypt(&subreq, req->src, req->dst,
-					   req->cryptlen - tail - AES_BLOCK_SIZE,
-					   req->iv);
-		req = &subreq;
-	}
-
-	err = skcipher_walk_virt(&walk, req, false);
-
-	while (walk.nbytes) {
-		kernel_fpu_begin();
-		(*crypt_func)(&ctx->crypt_ctx,
-			      walk.src.virt.addr, walk.dst.virt.addr,
-			      walk.nbytes & ~(AES_BLOCK_SIZE - 1), req->iv);
-		kernel_fpu_end();
-		err = skcipher_walk_done(&walk,
-					 walk.nbytes & (AES_BLOCK_SIZE - 1));
-	}
-
-	if (err || !tail)
-		return err;
-
-	/* Do ciphertext stealing with the last full block and partial block. */
-
-	dst = src = scatterwalk_ffwd(sg_src, req->src, req->cryptlen);
-	if (req->dst != req->src)
-		dst = scatterwalk_ffwd(sg_dst, req->dst, req->cryptlen);
-
-	skcipher_request_set_crypt(req, src, dst, AES_BLOCK_SIZE + tail,
-				   req->iv);
-
-	err = skcipher_walk_virt(&walk, req, false);
-	if (err)
-		return err;
-
-	kernel_fpu_begin();
-	(*crypt_func)(&ctx->crypt_ctx, walk.src.virt.addr, walk.dst.virt.addr,
-		      walk.nbytes, req->iv);
-	kernel_fpu_end();
-
-	return skcipher_walk_done(&walk, 0);
-}
-
-/* __always_inline to avoid indirect call in fastpath */
-static __always_inline int
-xts_crypt(struct skcipher_request *req, xts_encrypt_iv_func encrypt_iv,
-	  xts_crypt_func crypt_func)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	const struct aesni_xts_ctx *ctx = aes_xts_ctx(tfm);
-
-	if (unlikely(req->cryptlen < AES_BLOCK_SIZE))
-		return -EINVAL;
-
-	kernel_fpu_begin();
-	(*encrypt_iv)(&ctx->tweak_ctx, req->iv);
-
-	/*
-	 * In practice, virtually all XTS plaintexts and ciphertexts are either
-	 * 512 or 4096 bytes and do not use multiple scatterlist elements.  To
-	 * optimize the performance of these cases, the below fast-path handles
-	 * single-scatterlist-element messages as efficiently as possible.  The
-	 * code is 64-bit specific, as it assumes no page mapping is needed.
-	 */
-	if (IS_ENABLED(CONFIG_X86_64) &&
-	    likely(req->src->length >= req->cryptlen &&
-		   req->dst->length >= req->cryptlen)) {
-		(*crypt_func)(&ctx->crypt_ctx, sg_virt(req->src),
-			      sg_virt(req->dst), req->cryptlen, req->iv);
-		kernel_fpu_end();
-		return 0;
-	}
-	kernel_fpu_end();
-	return xts_crypt_slowpath(req, crypt_func);
-}
-
 #ifdef CONFIG_X86_64
-asmlinkage void aes_xts_encrypt_iv(const struct crypto_aes_ctx *tweak_key,
-				   u8 iv[AES_BLOCK_SIZE]);
-
-#define DEFINE_AVX_SKCIPHER_ALGS(suffix, driver_name_suffix, priority)	       \
-									       \
-asmlinkage void								       \
-aes_xts_encrypt_##suffix(const struct crypto_aes_ctx *key, const u8 *src,      \
-			 u8 *dst, int len, u8 tweak[AES_BLOCK_SIZE]);	       \
-asmlinkage void								       \
-aes_xts_decrypt_##suffix(const struct crypto_aes_ctx *key, const u8 *src,      \
-			 u8 *dst, int len, u8 tweak[AES_BLOCK_SIZE]);	       \
-									       \
-static int xts_encrypt_##suffix(struct skcipher_request *req)		       \
-{									       \
-	return xts_crypt(req, aes_xts_encrypt_iv, aes_xts_encrypt_##suffix);   \
-}									       \
-									       \
-static int xts_decrypt_##suffix(struct skcipher_request *req)		       \
-{									       \
-	return xts_crypt(req, aes_xts_encrypt_iv, aes_xts_decrypt_##suffix);   \
-}									       \
-									       \
-static struct skcipher_alg skcipher_algs_##suffix[] = {{		       \
-	.base.cra_name		= "xts(aes)",				       \
-	.base.cra_driver_name	= "xts-aes-" driver_name_suffix,	       \
-	.base.cra_priority	= priority,				       \
-	.base.cra_blocksize	= AES_BLOCK_SIZE,			       \
-	.base.cra_ctxsize	= XTS_AES_CTX_SIZE,			       \
-	.base.cra_module	= THIS_MODULE,				       \
-	.min_keysize		= 2 * AES_MIN_KEY_SIZE,			       \
-	.max_keysize		= 2 * AES_MAX_KEY_SIZE,			       \
-	.ivsize			= AES_BLOCK_SIZE,			       \
-	.walksize		= 2 * AES_BLOCK_SIZE,			       \
-	.setkey			= xts_setkey_aesni,			       \
-	.encrypt		= xts_encrypt_##suffix,			       \
-	.decrypt		= xts_decrypt_##suffix,			       \
-}}
-
-DEFINE_AVX_SKCIPHER_ALGS(aesni_avx, "aesni-avx", 500);
-DEFINE_AVX_SKCIPHER_ALGS(vaes_avx2, "vaes-avx2", 600);
-DEFINE_AVX_SKCIPHER_ALGS(vaes_avx512, "vaes-avx512", 800);
 
 /* The common part of the x86_64 AES-GCM key struct */
 struct aes_gcm_key {
@@ -1004,10 +792,6 @@ static int __init register_avx_algs(void)
 
 	if (!boot_cpu_has(X86_FEATURE_AVX))
 		return 0;
-	err = crypto_register_skciphers(skcipher_algs_aesni_avx,
-					ARRAY_SIZE(skcipher_algs_aesni_avx));
-	if (err)
-		return err;
 	err = crypto_register_aeads(aes_gcm_algs_aesni_avx,
 				    ARRAY_SIZE(aes_gcm_algs_aesni_avx));
 	if (err)
@@ -1024,10 +808,6 @@ static int __init register_avx_algs(void)
 	    !boot_cpu_has(X86_FEATURE_PCLMULQDQ) ||
 	    !cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL))
 		return 0;
-	err = crypto_register_skciphers(skcipher_algs_vaes_avx2,
-					ARRAY_SIZE(skcipher_algs_vaes_avx2));
-	if (err)
-		return err;
 	err = crypto_register_aeads(aes_gcm_algs_vaes_avx2,
 				    ARRAY_SIZE(aes_gcm_algs_vaes_avx2));
 	if (err)
@@ -1043,16 +823,10 @@ static int __init register_avx_algs(void)
 	if (boot_cpu_has(X86_FEATURE_PREFER_YMM)) {
 		int i;
 
-		for (i = 0; i < ARRAY_SIZE(skcipher_algs_vaes_avx512); i++)
-			skcipher_algs_vaes_avx512[i].base.cra_priority = 1;
 		for (i = 0; i < ARRAY_SIZE(aes_gcm_algs_vaes_avx512); i++)
 			aes_gcm_algs_vaes_avx512[i].base.cra_priority = 1;
 	}
 
-	err = crypto_register_skciphers(skcipher_algs_vaes_avx512,
-					ARRAY_SIZE(skcipher_algs_vaes_avx512));
-	if (err)
-		return err;
 	err = crypto_register_aeads(aes_gcm_algs_vaes_avx512,
 				    ARRAY_SIZE(aes_gcm_algs_vaes_avx512));
 	if (err)
@@ -1061,19 +835,13 @@ static int __init register_avx_algs(void)
 	return 0;
 }
 
-#define unregister_skciphers(A) \
-	if (refcount_read(&(A)[0].base.cra_refcnt) != 0) \
-		crypto_unregister_skciphers((A), ARRAY_SIZE(A))
 #define unregister_aeads(A) \
 	if (refcount_read(&(A)[0].base.cra_refcnt) != 0) \
 		crypto_unregister_aeads((A), ARRAY_SIZE(A))
 
 static void unregister_avx_algs(void)
 {
-	unregister_skciphers(skcipher_algs_aesni_avx);
 	unregister_aeads(aes_gcm_algs_aesni_avx);
-	unregister_skciphers(skcipher_algs_vaes_avx2);
-	unregister_skciphers(skcipher_algs_vaes_avx512);
 	unregister_aeads(aes_gcm_algs_vaes_avx2);
 	unregister_aeads(aes_gcm_algs_vaes_avx512);
 }
@@ -1131,6 +899,6 @@ static void __exit aesni_exit(void)
 module_init(aesni_init);
 module_exit(aesni_exit);
 
-MODULE_DESCRIPTION("AES cipher and modes, optimized with AES-NI or VAES instructions");
+MODULE_DESCRIPTION("AES-GCM, optimized with AES-NI or VAES instructions");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_CRYPTO("aes");
diff --git a/crypto/aes.c b/crypto/aes.c
index ac484a28b30e..c19234f8a31c 100644
--- a/crypto/aes.c
+++ b/crypto/aes.c
@@ -701,7 +701,7 @@ static struct skcipher_alg skcipher_algs[] = {
 	{
 		.base.cra_name = "xts(aes)",
 		.base.cra_driver_name = "xts-aes-lib",
-		.base.cra_priority = 110,
+		.base.cra_priority = IS_ENABLED(CONFIG_X86) ? 300 : 110,
 		.base.cra_blocksize = AES_BLOCK_SIZE,
 		.base.cra_ctxsize = sizeof(struct aes_xts_key),
 		.base.cra_module = THIS_MODULE,
diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index 5d5484fc78ea..02d89a226377 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -57,6 +57,9 @@ libaes-$(CONFIG_X86) += x86/aes-aesni.o
 ifneq ($(CONFIG_CRYPTO_LIB_AES_CTR),)
 libaes-$(CONFIG_X86_64) += x86/aes-ctr-avx-x86_64.o
 endif
+ifneq ($(CONFIG_CRYPTO_LIB_AES_XTS),)
+libaes-$(CONFIG_X86_64) += x86/aes-xts-avx-x86_64.o
+endif
 endif # CONFIG_CRYPTO_LIB_AES_ARCH
 
 # clean-files must be defined unconditionally
diff --git a/arch/x86/crypto/aes-xts-avx-x86_64.S b/lib/crypto/x86/aes-xts-avx-x86_64.S
similarity index 81%
rename from arch/x86/crypto/aes-xts-avx-x86_64.S
rename to lib/crypto/x86/aes-xts-avx-x86_64.S
index a30753a3e207..76788b275ab4 100644
--- a/arch/x86/crypto/aes-xts-avx-x86_64.S
+++ b/lib/crypto/x86/aes-xts-avx-x86_64.S
@@ -80,14 +80,17 @@
  * any CPUs that support VAES but not VPCLMULQDQ.  If that changes, we might
  * need to start also providing an implementation using VAES alone.
  *
- * The AES-XTS implementations in this file support everything required by the
- * crypto API, including support for arbitrary input lengths and multi-part
- * processing.  However, they are most heavily optimized for the common case of
- * power-of-2 length inputs that are processed in a single part (disk sectors).
+ * These assembly functions don't handle ciphertext stealing, i.e, lengths that
+ * aren't a multiple of 16 bytes.  That case is not actually reached in the
+ * current use cases of AES-XTS in the kernel and is just handled by the C code.
  */
 
 #include <linux/linkage.h>
-#include <linux/cfi_types.h>
+
+// Offsets in struct aes_key
+#define OFFSETOF_KEYLEN		0
+#define OFFSETOF_RNDKEYS	16
+#define OFFSETOF_INVRNDKEYS	256
 
 .section .rodata
 .p2align 4
@@ -111,16 +114,6 @@
 .Llshift_amounts:
 	.byte	0, 0, 1, 1, 2, 2, 3, 3
 
-	// This table contains constants for vpshufb and vpblendvb, used to
-	// handle variable byte shifts and blending during ciphertext stealing
-	// on CPUs that don't support AVX512-style masking.
-.Lcts_permute_table:
-	.byte	0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80
-	.byte	0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80
-	.byte	0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07
-	.byte	0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f
-	.byte	0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80
-	.byte	0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80
 .text
 
 .macro	_define_Vi	i
@@ -149,13 +142,12 @@
 .endif
 
 	// Function parameters
-	.set	KEY,		%rdi	// Initially points to crypto_aes_ctx, then is
+	.set	KEY,		%rdi	// Initially points to struct aes_key, then is
 					// advanced to point to 7th-from-last round key
 	.set	SRC,		%rsi	// Pointer to next source data
 	.set	DST,		%rdx	// Pointer to next destination data
-	.set	LEN,		%ecx	// Remaining length in bytes
-	.set	LEN8,		%cl
-	.set	LEN64,		%rcx
+	.set	NBLOCKS,	%rcx	// Number of blocks remaining
+	.set	NBLOCKS32,	%ecx
 	.set	TWEAK,		%r8	// Pointer to next tweak
 
 	// %rax holds the AES key length in bytes.
@@ -468,9 +460,9 @@
 
 	// Select either the encryption round keys or the decryption round keys.
 .if \enc
-	.set	OFFS, 0
+	.set	OFFS, OFFSETOF_RNDKEYS
 .else
-	.set	OFFS, 240
+	.set	OFFS, OFFSETOF_INVRNDKEYS
 .endif
 
 	// Load the round key for "round 0".
@@ -615,19 +607,8 @@
 .macro	_aes_xts_crypt	enc
 	_define_aliases
 
-.if !\enc
-	// When decrypting a message whose length isn't a multiple of the AES
-	// block length, exclude the last full block from the main loop by
-	// subtracting 16 from LEN.  This is needed because ciphertext stealing
-	// decryption uses the last two tweaks in reverse order.  We'll handle
-	// the last full block and the partial block specially at the end.
-	lea		-16(LEN), %eax
-	test		$15, LEN8
-	cmovnz		%eax, LEN
-.endif
-
 	// Load the AES key length: 16 (AES-128), 24 (AES-192), or 32 (AES-256).
-	movl		480(KEY), KEYLEN
+	movl		OFFSETOF_KEYLEN(KEY), KEYLEN
 
 	// Setup the pointer to the round keys and cache as many as possible.
 	_setup_round_keys	\enc
@@ -635,7 +616,7 @@
 	// Compute the first set of tweaks TWEAK[0-3].
 	_compute_first_set_of_tweaks
 
-	add		$-4*VL, LEN  // shorter than 'sub 4*VL' when VL=32
+	sub		$4*VL/16, NBLOCKS
 	jl		.Lhandle_remainder\@
 
 .Lmain_loop\@:
@@ -715,13 +696,13 @@
 
 	sub		$-4*VL, SRC  // shorter than 'add 4*VL' when VL=32
 	sub		$-4*VL, DST
-	add		$-4*VL, LEN
+	sub		$4*VL/16, NBLOCKS
 	jge		.Lmain_loop\@
 
 	// Check for the uncommon case where the data length isn't a multiple of
 	// 4*VL.  Handle it out-of-line in order to optimize for the common
 	// case.  In the common case, just fall through to the ret.
-	test		$4*VL-1, LEN8
+	test		$(4*VL/16)-1, NBLOCKS32
 	jnz		.Lhandle_remainder\@
 .Ldone\@:
 	// Store the next tweak back to *TWEAK to support continuation calls.
@@ -733,9 +714,9 @@
 
 .Lhandle_remainder\@:
 
-	// En/decrypt any remaining full blocks, one vector at a time.
+	// En/decrypt any remaining blocks, one vector at a time.
 .if VL > 16
-	add		$3*VL, LEN	// Undo extra sub of 4*VL, then sub VL.
+	add		$3*VL/16, NBLOCKS32
 	jl		.Lvec_at_a_time_done\@
 .Lvec_at_a_time\@:
 	_vmovdqu	(SRC), V0
@@ -744,16 +725,16 @@
 	_next_tweakvec	TWEAK0, V0, V1, TWEAK0
 	add		$VL, SRC
 	add		$VL, DST
-	sub		$VL, LEN
+	sub		$VL/16, NBLOCKS32
 	jge		.Lvec_at_a_time\@
 .Lvec_at_a_time_done\@:
-	add		$VL-16, LEN	// Undo extra sub of VL, then sub 16.
+	add		$VL/16, NBLOCKS32
 .else
-	add		$4*VL-16, LEN	// Undo extra sub of 4*VL, then sub 16.
+	add		$4*VL/16, NBLOCKS32
 .endif
 
-	// En/decrypt any remaining full blocks, one at a time.
-	jl		.Lblock_at_a_time_done\@
+	// En/decrypt any remaining blocks, one at a time.
+	jz		.Ldone\@
 .Lblock_at_a_time\@:
 	vmovdqu		(SRC), %xmm0
 	_aes_crypt	\enc, _XMM, TWEAK0_XMM, %xmm0, tmp=%xmm1
@@ -761,92 +742,26 @@
 	_next_tweak	TWEAK0_XMM, %xmm0, TWEAK0_XMM
 	add		$16, SRC
 	add		$16, DST
-	sub		$16, LEN
-	jge		.Lblock_at_a_time\@
-.Lblock_at_a_time_done\@:
-	add		$16, LEN	// Undo the extra sub of 16.
-	// Now 0 <= LEN <= 15.  If LEN is zero, we're done.
-	jz		.Ldone\@
-
-	// Otherwise 1 <= LEN <= 15, but the real remaining length is 16 + LEN.
-	// Do ciphertext stealing to process the last 16 + LEN bytes.
-
-.if \enc
-	// If encrypting, the main loop already encrypted the last full block to
-	// create the CTS intermediate ciphertext.  Prepare for the rest of CTS
-	// by rewinding the pointers and loading the intermediate ciphertext.
-	sub		$16, SRC
-	sub		$16, DST
-	vmovdqu		(DST), %xmm0
-.else
-	// If decrypting, the main loop didn't decrypt the last full block
-	// because CTS decryption uses the last two tweaks in reverse order.
-	// Do it now by advancing the tweak and decrypting the last full block.
-	_next_tweak	TWEAK0_XMM, %xmm0, TWEAK1_XMM
-	vmovdqu		(SRC), %xmm0
-	_aes_crypt	\enc, _XMM, TWEAK1_XMM, %xmm0, tmp=%xmm1
-.endif
-
-.if USE_AVX512
-	// Create a mask that has the first LEN bits set.
-	mov		$-1, %r9d
-	bzhi		LEN, %r9d, %r9d
-	kmovd		%r9d, %k1
-
-	// Swap the first LEN bytes of the en/decryption of the last full block
-	// with the partial block.  Note that to support in-place en/decryption,
-	// the load from the src partial block must happen before the store to
-	// the dst partial block.
-	vmovdqa		%xmm0, %xmm1
-	vmovdqu8	16(SRC), %xmm0{%k1}
-	vmovdqu8	%xmm1, 16(DST){%k1}
-.else
-	lea		.Lcts_permute_table(%rip), %r9
-
-	// Load the src partial block, left-aligned.  Note that to support
-	// in-place en/decryption, this must happen before the store to the dst
-	// partial block.
-	vmovdqu		(SRC, LEN64, 1), %xmm1
-
-	// Shift the first LEN bytes of the en/decryption of the last full block
-	// to the end of a register, then store it to DST+LEN.  This stores the
-	// dst partial block.  It also writes to the second part of the dst last
-	// full block, but that part is overwritten later.
-	vpshufb		(%r9, LEN64, 1), %xmm0, %xmm2
-	vmovdqu		%xmm2, (DST, LEN64, 1)
-
-	// Make xmm3 contain [16-LEN,16-LEN+1,...,14,15,0x80,0x80,...].
-	sub		LEN64, %r9
-	vmovdqu		32(%r9), %xmm3
-
-	// Shift the src partial block to the beginning of its register.
-	vpshufb		%xmm3, %xmm1, %xmm1
-
-	// Do a blend to generate the src partial block followed by the second
-	// part of the en/decryption of the last full block.
-	vpblendvb	%xmm3, %xmm0, %xmm1, %xmm0
-.endif
-	// En/decrypt again and store the last full block.
-	_aes_crypt	\enc, _XMM, TWEAK0_XMM, %xmm0, tmp=%xmm1
-	vmovdqu		%xmm0, (DST)
+	dec		NBLOCKS32
+	jnz		.Lblock_at_a_time\@
 	jmp		.Ldone\@
 .endm
 
-// void aes_xts_encrypt_iv(const struct crypto_aes_ctx *tweak_key,
+// void aes_xts_encrypt_iv(const struct aes_enckey *tweak_key,
 //			   u8 iv[AES_BLOCK_SIZE]);
 //
 // Encrypt |iv| using the AES key |tweak_key| to get the first tweak.  Assumes
 // that the CPU supports AES-NI and AVX, but not necessarily VAES or AVX512.
-SYM_TYPED_FUNC_START(aes_xts_encrypt_iv)
+SYM_FUNC_START(aes_xts_encrypt_iv)
 	.set	TWEAK_KEY,	%rdi
 	.set	IV,		%rsi
 	.set	KEYLEN,		%eax
 	.set	KEYLEN64,	%rax
 
 	vmovdqu		(IV), %xmm0
-	vpxor		(TWEAK_KEY), %xmm0, %xmm0
-	movl		480(TWEAK_KEY), KEYLEN
-	lea		-16(TWEAK_KEY, KEYLEN64, 4), TWEAK_KEY
+	vpxor		OFFSETOF_RNDKEYS(TWEAK_KEY), %xmm0, %xmm0
+	movl		OFFSETOF_KEYLEN(TWEAK_KEY), KEYLEN
+	lea		OFFSETOF_RNDKEYS-16(TWEAK_KEY, KEYLEN64, 4), TWEAK_KEY
 	cmp		$24, KEYLEN
 	jl		.Lencrypt_iv_aes128
 	je		.Lencrypt_iv_aes192
@@ -867,39 +782,36 @@ SYM_FUNC_END(aes_xts_encrypt_iv)
 // Below are the actual AES-XTS encryption and decryption functions,
 // instantiated from the above macro.  They all have the following prototype:
 //
-// void (*xts_crypt_func)(const struct crypto_aes_ctx *key,
-//			  const u8 *src, u8 *dst, int len,
-//			  u8 tweak[AES_BLOCK_SIZE]);
+// void (*xts_crypt_func)(const struct aes_key *key, const u8 *src, u8 *dst,
+//			  long nblocks, u8 tweak[AES_BLOCK_SIZE]);
 //
-// |key| is the data key.  |tweak| contains the next tweak; the encryption of
-// the original IV with the tweak key was already done.  This function supports
-// incremental computation, but |len| must always be >= 16 (AES_BLOCK_SIZE), and
-// |len| must be a multiple of 16 except on the last call.  If |len| is a
-// multiple of 16, then this function updates |tweak| to contain the next tweak.
+// `tweak` must have already been encrypted by the tweak key; `key` is just the
+// main key.  To allow incremental computation, `tweak` is updated to contain
+// the next tweak.
 
 .set	VL, 16
 .set	USE_AVX512, 0
-SYM_TYPED_FUNC_START(aes_xts_encrypt_aesni_avx)
+SYM_FUNC_START(aes_xts_encrypt_aesni_avx)
 	_aes_xts_crypt	1
 SYM_FUNC_END(aes_xts_encrypt_aesni_avx)
-SYM_TYPED_FUNC_START(aes_xts_decrypt_aesni_avx)
+SYM_FUNC_START(aes_xts_decrypt_aesni_avx)
 	_aes_xts_crypt	0
 SYM_FUNC_END(aes_xts_decrypt_aesni_avx)
 
 .set	VL, 32
 .set	USE_AVX512, 0
-SYM_TYPED_FUNC_START(aes_xts_encrypt_vaes_avx2)
+SYM_FUNC_START(aes_xts_encrypt_vaes_avx2)
 	_aes_xts_crypt	1
 SYM_FUNC_END(aes_xts_encrypt_vaes_avx2)
-SYM_TYPED_FUNC_START(aes_xts_decrypt_vaes_avx2)
+SYM_FUNC_START(aes_xts_decrypt_vaes_avx2)
 	_aes_xts_crypt	0
 SYM_FUNC_END(aes_xts_decrypt_vaes_avx2)
 
 .set	VL, 64
 .set	USE_AVX512, 1
-SYM_TYPED_FUNC_START(aes_xts_encrypt_vaes_avx512)
+SYM_FUNC_START(aes_xts_encrypt_vaes_avx512)
 	_aes_xts_crypt	1
 SYM_FUNC_END(aes_xts_encrypt_vaes_avx512)
-SYM_TYPED_FUNC_START(aes_xts_decrypt_vaes_avx512)
+SYM_FUNC_START(aes_xts_decrypt_vaes_avx512)
 	_aes_xts_crypt	0
 SYM_FUNC_END(aes_xts_decrypt_vaes_avx512)
diff --git a/lib/crypto/x86/aes.h b/lib/crypto/x86/aes.h
index 5b4205870b9f..8b800f109263 100644
--- a/lib/crypto/x86/aes.h
+++ b/lib/crypto/x86/aes.h
@@ -307,6 +307,22 @@ void aes_xts_encrypt_aesni(u8 *dst, const u8 *src, long nblocks,
 			   u8 tweak[AES_BLOCK_SIZE], const struct aes_key *key);
 void aes_xts_decrypt_aesni(u8 *dst, const u8 *src, long nblocks,
 			   u8 tweak[AES_BLOCK_SIZE], const struct aes_key *key);
+void aes_xts_encrypt_iv(const struct aes_enckey *tweak_key,
+			u8 iv[AES_BLOCK_SIZE]);
+void aes_xts_encrypt_aesni_avx(const struct aes_key *key, const u8 *src,
+			       u8 *dst, long nblocks, u8 tweak[AES_BLOCK_SIZE]);
+void aes_xts_decrypt_aesni_avx(const struct aes_key *key, const u8 *src,
+			       u8 *dst, long nblocks, u8 tweak[AES_BLOCK_SIZE]);
+void aes_xts_encrypt_vaes_avx2(const struct aes_key *key, const u8 *src,
+			       u8 *dst, long nblocks, u8 tweak[AES_BLOCK_SIZE]);
+void aes_xts_decrypt_vaes_avx2(const struct aes_key *key, const u8 *src,
+			       u8 *dst, long nblocks, u8 tweak[AES_BLOCK_SIZE]);
+void aes_xts_encrypt_vaes_avx512(const struct aes_key *key, const u8 *src,
+				 u8 *dst, long nblocks,
+				 u8 tweak[AES_BLOCK_SIZE]);
+void aes_xts_decrypt_vaes_avx512(const struct aes_key *key, const u8 *src,
+				 u8 *dst, long nblocks,
+				 u8 tweak[AES_BLOCK_SIZE]);
 
 /* len is always a positive multiple of AES_BLOCK_SIZE here. */
 static __always_inline bool
@@ -319,12 +335,46 @@ aes_xts_crypt_x86(u8 *dst, const u8 *src, size_t len, u8 tweak[AES_BLOCK_SIZE],
 		return false;
 
 	kernel_fpu_begin();
-	if (!cont)
-		aes_encrypt_aesni(tweak, tweak, &key->tweak_key);
-	if (enc)
-		aes_xts_encrypt_aesni(dst, src, nblocks, tweak, &key->main_key);
-	else
-		aes_xts_decrypt_aesni(dst, src, nblocks, tweak, &key->main_key);
+	if (IS_ENABLED(CONFIG_X86_64) &&
+	    static_branch_likely(&have_vaes_avx512)) {
+		if (!cont)
+			aes_xts_encrypt_iv(&key->tweak_key, tweak);
+		if (enc)
+			aes_xts_encrypt_vaes_avx512(&key->main_key, src, dst,
+						    nblocks, tweak);
+		else
+			aes_xts_decrypt_vaes_avx512(&key->main_key, src, dst,
+						    nblocks, tweak);
+	} else if (IS_ENABLED(CONFIG_X86_64) &&
+		   static_branch_likely(&have_vaes_avx2)) {
+		if (!cont)
+			aes_xts_encrypt_iv(&key->tweak_key, tweak);
+		if (enc)
+			aes_xts_encrypt_vaes_avx2(&key->main_key, src, dst,
+						  nblocks, tweak);
+		else
+			aes_xts_decrypt_vaes_avx2(&key->main_key, src, dst,
+						  nblocks, tweak);
+	} else if (IS_ENABLED(CONFIG_X86_64) &&
+		   static_branch_likely(&have_aesni_avx)) {
+		if (!cont)
+			aes_xts_encrypt_iv(&key->tweak_key, tweak);
+		if (enc)
+			aes_xts_encrypt_aesni_avx(&key->main_key, src, dst,
+						  nblocks, tweak);
+		else
+			aes_xts_decrypt_aesni_avx(&key->main_key, src, dst,
+						  nblocks, tweak);
+	} else {
+		if (!cont)
+			aes_encrypt_aesni(tweak, tweak, &key->tweak_key);
+		if (enc)
+			aes_xts_encrypt_aesni(dst, src, nblocks, tweak,
+					      &key->main_key);
+		else
+			aes_xts_decrypt_aesni(dst, src, nblocks, tweak,
+					      &key->main_key);
+	}
 	kernel_fpu_end();
 	return true;
 }
-- 
2.55.0

