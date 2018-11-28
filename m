Return-Path: <SRS0=p+N9=OH=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727285AbeK1Rry (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Nov 2018 12:47:54 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Paul Crowley <paulcrowley@google.com>,
        Martin Willi <martin@strongswan.org>,
        Milan Broz <gmazyland@gmail.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] crypto: x86/nhpoly1305 - add SSE2 accelerated NHPoly1305
Date: Tue, 27 Nov 2018 22:44:40 -0800
Message-Id: <20181128064445.3813-2-ebiggers@kernel.org>
In-Reply-To: <20181128064445.3813-1-ebiggers@kernel.org>
References: <20181128064445.3813-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

Add a 64-bit SSE2 implementation of NHPoly1305, an ε-almost-∆-universal
hash function used in the Adiantum encryption mode.  For now, only the
NH portion is actually SSE2-accelerated; the Poly1305 part is less
performance-critical so is just implemented in C.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/Makefile               |   4 +
 arch/x86/crypto/nh-sse2-x86_64.S       | 123 +++++++++++++++++++++++++
 arch/x86/crypto/nhpoly1305-sse2-glue.c |  76 +++++++++++++++
 crypto/Kconfig                         |   8 ++
 4 files changed, 211 insertions(+)
 create mode 100644 arch/x86/crypto/nh-sse2-x86_64.S
 create mode 100644 arch/x86/crypto/nhpoly1305-sse2-glue.c

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index a4b0007a54e17..49dc3d50041c9 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -46,6 +46,8 @@ obj-$(CONFIG_CRYPTO_MORUS1280_GLUE) += morus1280_glue.o
 obj-$(CONFIG_CRYPTO_MORUS640_SSE2) += morus640-sse2.o
 obj-$(CONFIG_CRYPTO_MORUS1280_SSE2) += morus1280-sse2.o
 
+obj-$(CONFIG_CRYPTO_NHPOLY1305_SSE2) += nhpoly1305-sse2.o
+
 # These modules require assembler to support AVX.
 ifeq ($(avx_supported),yes)
 	obj-$(CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64) += \
@@ -84,6 +86,8 @@ aegis256-aesni-y := aegis256-aesni-asm.o aegis256-aesni-glue.o
 morus640-sse2-y := morus640-sse2-asm.o morus640-sse2-glue.o
 morus1280-sse2-y := morus1280-sse2-asm.o morus1280-sse2-glue.o
 
+nhpoly1305-sse2-y := nh-sse2-x86_64.o nhpoly1305-sse2-glue.o
+
 ifeq ($(avx_supported),yes)
 	camellia-aesni-avx-x86_64-y := camellia-aesni-avx-asm_64.o \
 					camellia_aesni_avx_glue.o
diff --git a/arch/x86/crypto/nh-sse2-x86_64.S b/arch/x86/crypto/nh-sse2-x86_64.S
new file mode 100644
index 0000000000000..51f52d4ab4bbc
--- /dev/null
+++ b/arch/x86/crypto/nh-sse2-x86_64.S
@@ -0,0 +1,123 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * NH - ε-almost-universal hash function, x86_64 SSE2 accelerated
+ *
+ * Copyright 2018 Google LLC
+ *
+ * Author: Eric Biggers <ebiggers@google.com>
+ */
+
+#include <linux/linkage.h>
+
+#define		PASS0_SUMS	%xmm0
+#define		PASS1_SUMS	%xmm1
+#define		PASS2_SUMS	%xmm2
+#define		PASS3_SUMS	%xmm3
+#define		K0		%xmm4
+#define		K1		%xmm5
+#define		K2		%xmm6
+#define		K3		%xmm7
+#define		T0		%xmm8
+#define		T1		%xmm9
+#define		T2		%xmm10
+#define		T3		%xmm11
+#define		T4		%xmm12
+#define		T5		%xmm13
+#define		T6		%xmm14
+#define		T7		%xmm15
+#define		KEY		%rdi
+#define		MESSAGE		%rsi
+#define		MESSAGE_LEN	%rdx
+#define		HASH		%rcx
+
+.macro _nh_stride	k0, k1, k2, k3, offset
+
+	// Load next message stride
+	movdqu		\offset(MESSAGE), T1
+
+	// Load next key stride
+	movdqu		\offset(KEY), \k3
+
+	// Add message words to key words
+	movdqa		T1, T2
+	movdqa		T1, T3
+	paddd		T1, \k0    // reuse k0 to avoid a move
+	paddd		\k1, T1
+	paddd		\k2, T2
+	paddd		\k3, T3
+
+	// Multiply 32x32 => 64 and accumulate
+	pshufd		$0x10, \k0, T4
+	pshufd		$0x32, \k0, \k0
+	pshufd		$0x10, T1, T5
+	pshufd		$0x32, T1, T1
+	pshufd		$0x10, T2, T6
+	pshufd		$0x32, T2, T2
+	pshufd		$0x10, T3, T7
+	pshufd		$0x32, T3, T3
+	pmuludq		T4, \k0
+	pmuludq		T5, T1
+	pmuludq		T6, T2
+	pmuludq		T7, T3
+	paddq		\k0, PASS0_SUMS
+	paddq		T1, PASS1_SUMS
+	paddq		T2, PASS2_SUMS
+	paddq		T3, PASS3_SUMS
+.endm
+
+/*
+ * void nh_sse2(const u32 *key, const u8 *message, size_t message_len,
+ *		u8 hash[NH_HASH_BYTES])
+ *
+ * It's guaranteed that message_len % 16 == 0.
+ */
+ENTRY(nh_sse2)
+
+	movdqu		0x00(KEY), K0
+	movdqu		0x10(KEY), K1
+	movdqu		0x20(KEY), K2
+	add		$0x30, KEY
+	pxor		PASS0_SUMS, PASS0_SUMS
+	pxor		PASS1_SUMS, PASS1_SUMS
+	pxor		PASS2_SUMS, PASS2_SUMS
+	pxor		PASS3_SUMS, PASS3_SUMS
+
+	sub		$0x40, MESSAGE_LEN
+	jl		.Lloop4_done
+.Lloop4:
+	_nh_stride	K0, K1, K2, K3, 0x00
+	_nh_stride	K1, K2, K3, K0, 0x10
+	_nh_stride	K2, K3, K0, K1, 0x20
+	_nh_stride	K3, K0, K1, K2, 0x30
+	add		$0x40, KEY
+	add		$0x40, MESSAGE
+	sub		$0x40, MESSAGE_LEN
+	jge		.Lloop4
+
+.Lloop4_done:
+	and		$0x3f, MESSAGE_LEN
+	jz		.Ldone
+	_nh_stride	K0, K1, K2, K3, 0x00
+
+	sub		$0x10, MESSAGE_LEN
+	jz		.Ldone
+	_nh_stride	K1, K2, K3, K0, 0x10
+
+	sub		$0x10, MESSAGE_LEN
+	jz		.Ldone
+	_nh_stride	K2, K3, K0, K1, 0x20
+
+.Ldone:
+	// Sum the accumulators for each pass, then store the sums to 'hash'
+	movdqa		PASS0_SUMS, T0
+	movdqa		PASS2_SUMS, T1
+	punpcklqdq	PASS1_SUMS, T0		// => (PASS0_SUM_A PASS1_SUM_A)
+	punpcklqdq	PASS3_SUMS, T1		// => (PASS2_SUM_A PASS3_SUM_A)
+	punpckhqdq	PASS1_SUMS, PASS0_SUMS	// => (PASS0_SUM_B PASS1_SUM_B)
+	punpckhqdq	PASS3_SUMS, PASS2_SUMS	// => (PASS2_SUM_B PASS3_SUM_B)
+	paddq		PASS0_SUMS, T0
+	paddq		PASS2_SUMS, T1
+	movdqu		T0, 0x00(HASH)
+	movdqu		T1, 0x10(HASH)
+	ret
+ENDPROC(nh_sse2)
diff --git a/arch/x86/crypto/nhpoly1305-sse2-glue.c b/arch/x86/crypto/nhpoly1305-sse2-glue.c
new file mode 100644
index 0000000000000..ed68d164ce140
--- /dev/null
+++ b/arch/x86/crypto/nhpoly1305-sse2-glue.c
@@ -0,0 +1,76 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * NHPoly1305 - ε-almost-∆-universal hash function for Adiantum
+ * (SSE2 accelerated version)
+ *
+ * Copyright 2018 Google LLC
+ */
+
+#include <crypto/internal/hash.h>
+#include <crypto/nhpoly1305.h>
+#include <linux/module.h>
+#include <asm/fpu/api.h>
+
+asmlinkage void nh_sse2(const u32 *key, const u8 *message, size_t message_len,
+			u8 hash[NH_HASH_BYTES]);
+
+/* wrapper to avoid indirect call to assembly, which doesn't work with CFI */
+static void _nh_sse2(const u32 *key, const u8 *message, size_t message_len,
+		     __le64 hash[NH_NUM_PASSES])
+{
+	nh_sse2(key, message, message_len, (u8 *)hash);
+}
+
+static int nhpoly1305_sse2_update(struct shash_desc *desc,
+				  const u8 *src, unsigned int srclen)
+{
+	if (srclen < 64 || !irq_fpu_usable())
+		return crypto_nhpoly1305_update(desc, src, srclen);
+
+	do {
+		unsigned int n = min_t(unsigned int, srclen, PAGE_SIZE);
+
+		kernel_fpu_begin();
+		crypto_nhpoly1305_update_helper(desc, src, n, _nh_sse2);
+		kernel_fpu_end();
+		src += n;
+		srclen -= n;
+	} while (srclen);
+	return 0;
+}
+
+static struct shash_alg nhpoly1305_alg = {
+	.base.cra_name		= "nhpoly1305",
+	.base.cra_driver_name	= "nhpoly1305-sse2",
+	.base.cra_priority	= 200,
+	.base.cra_ctxsize	= sizeof(struct nhpoly1305_key),
+	.base.cra_module	= THIS_MODULE,
+	.digestsize		= POLY1305_DIGEST_SIZE,
+	.init			= crypto_nhpoly1305_init,
+	.update			= nhpoly1305_sse2_update,
+	.final			= crypto_nhpoly1305_final,
+	.setkey			= crypto_nhpoly1305_setkey,
+	.descsize		= sizeof(struct nhpoly1305_state),
+};
+
+static int __init nhpoly1305_mod_init(void)
+{
+	if (!boot_cpu_has(X86_FEATURE_XMM2))
+		return -ENODEV;
+
+	return crypto_register_shash(&nhpoly1305_alg);
+}
+
+static void __exit nhpoly1305_mod_exit(void)
+{
+	crypto_unregister_shash(&nhpoly1305_alg);
+}
+
+module_init(nhpoly1305_mod_init);
+module_exit(nhpoly1305_mod_exit);
+
+MODULE_DESCRIPTION("NHPoly1305 ε-almost-∆-universal hash function (SSE2-accelerated)");
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Eric Biggers <ebiggers@google.com>");
+MODULE_ALIAS_CRYPTO("nhpoly1305");
+MODULE_ALIAS_CRYPTO("nhpoly1305-sse2");
diff --git a/crypto/Kconfig b/crypto/Kconfig
index b6376d5d973e0..b85133966d643 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -501,6 +501,14 @@ config CRYPTO_NHPOLY1305
 	select CRYPTO_HASH
 	select CRYPTO_POLY1305
 
+config CRYPTO_NHPOLY1305_SSE2
+	tristate "NHPoly1305 hash function (x86_64 SSE2 implementation)"
+	depends on X86 && 64BIT
+	select CRYPTO_NHPOLY1305
+	help
+	  SSE2 optimized implementation of the hash function used by the
+	  Adiantum encryption mode.
+
 config CRYPTO_ADIANTUM
 	tristate "Adiantum support"
 	select CRYPTO_CHACHA20
-- 
2.19.2
