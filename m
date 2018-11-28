Return-Path: <SRS0=p+N9=OH=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727341AbeK1Rry (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Nov 2018 12:47:54 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Paul Crowley <paulcrowley@google.com>,
        Martin Willi <martin@strongswan.org>,
        Milan Broz <gmazyland@gmail.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] crypto: x86/nhpoly1305 - add AVX2 accelerated NHPoly1305
Date: Tue, 27 Nov 2018 22:44:41 -0800
Message-Id: <20181128064445.3813-3-ebiggers@kernel.org>
In-Reply-To: <20181128064445.3813-1-ebiggers@kernel.org>
References: <20181128064445.3813-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

Add a 64-bit AVX2 implementation of NHPoly1305, an ε-almost-∆-universal
hash function used in the Adiantum encryption mode.  For now, only the
NH portion is actually AVX2-accelerated; the Poly1305 part is less
performance-critical so is just implemented in C.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/Makefile               |   3 +
 arch/x86/crypto/nh-avx2-x86_64.S       | 157 +++++++++++++++++++++++++
 arch/x86/crypto/nhpoly1305-avx2-glue.c |  77 ++++++++++++
 crypto/Kconfig                         |   8 ++
 4 files changed, 245 insertions(+)
 create mode 100644 arch/x86/crypto/nh-avx2-x86_64.S
 create mode 100644 arch/x86/crypto/nhpoly1305-avx2-glue.c

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index 49dc3d50041c9..006433da45f8c 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -47,6 +47,7 @@ obj-$(CONFIG_CRYPTO_MORUS640_SSE2) += morus640-sse2.o
 obj-$(CONFIG_CRYPTO_MORUS1280_SSE2) += morus1280-sse2.o
 
 obj-$(CONFIG_CRYPTO_NHPOLY1305_SSE2) += nhpoly1305-sse2.o
+obj-$(CONFIG_CRYPTO_NHPOLY1305_AVX2) += nhpoly1305-avx2.o
 
 # These modules require assembler to support AVX.
 ifeq ($(avx_supported),yes)
@@ -105,6 +106,8 @@ ifeq ($(avx2_supported),yes)
 	serpent-avx2-y := serpent-avx2-asm_64.o serpent_avx2_glue.o
 
 	morus1280-avx2-y := morus1280-avx2-asm.o morus1280-avx2-glue.o
+
+	nhpoly1305-avx2-y := nh-avx2-x86_64.o nhpoly1305-avx2-glue.o
 endif
 
 aesni-intel-y := aesni-intel_asm.o aesni-intel_glue.o
diff --git a/arch/x86/crypto/nh-avx2-x86_64.S b/arch/x86/crypto/nh-avx2-x86_64.S
new file mode 100644
index 0000000000000..f7946ea1b7046
--- /dev/null
+++ b/arch/x86/crypto/nh-avx2-x86_64.S
@@ -0,0 +1,157 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * NH - ε-almost-universal hash function, x86_64 AVX2 accelerated
+ *
+ * Copyright 2018 Google LLC
+ *
+ * Author: Eric Biggers <ebiggers@google.com>
+ */
+
+#include <linux/linkage.h>
+
+#define		PASS0_SUMS	%ymm0
+#define		PASS1_SUMS	%ymm1
+#define		PASS2_SUMS	%ymm2
+#define		PASS3_SUMS	%ymm3
+#define		K0		%ymm4
+#define		K0_XMM		%xmm4
+#define		K1		%ymm5
+#define		K1_XMM		%xmm5
+#define		K2		%ymm6
+#define		K2_XMM		%xmm6
+#define		K3		%ymm7
+#define		K3_XMM		%xmm7
+#define		T0		%ymm8
+#define		T1		%ymm9
+#define		T2		%ymm10
+#define		T2_XMM		%xmm10
+#define		T3		%ymm11
+#define		T3_XMM		%xmm11
+#define		T4		%ymm12
+#define		T5		%ymm13
+#define		T6		%ymm14
+#define		T7		%ymm15
+#define		KEY		%rdi
+#define		MESSAGE		%rsi
+#define		MESSAGE_LEN	%rdx
+#define		HASH		%rcx
+
+.macro _nh_2xstride	k0, k1, k2, k3
+
+	// Add message words to key words
+	vpaddd		\k0, T3, T0
+	vpaddd		\k1, T3, T1
+	vpaddd		\k2, T3, T2
+	vpaddd		\k3, T3, T3
+
+	// Multiply 32x32 => 64 and accumulate
+	vpshufd		$0x10, T0, T4
+	vpshufd		$0x32, T0, T0
+	vpshufd		$0x10, T1, T5
+	vpshufd		$0x32, T1, T1
+	vpshufd		$0x10, T2, T6
+	vpshufd		$0x32, T2, T2
+	vpshufd		$0x10, T3, T7
+	vpshufd		$0x32, T3, T3
+	vpmuludq	T4, T0, T0
+	vpmuludq	T5, T1, T1
+	vpmuludq	T6, T2, T2
+	vpmuludq	T7, T3, T3
+	vpaddq		T0, PASS0_SUMS, PASS0_SUMS
+	vpaddq		T1, PASS1_SUMS, PASS1_SUMS
+	vpaddq		T2, PASS2_SUMS, PASS2_SUMS
+	vpaddq		T3, PASS3_SUMS, PASS3_SUMS
+.endm
+
+/*
+ * void nh_avx2(const u32 *key, const u8 *message, size_t message_len,
+ *		u8 hash[NH_HASH_BYTES])
+ *
+ * It's guaranteed that message_len % 16 == 0.
+ */
+ENTRY(nh_avx2)
+
+	vmovdqu		0x00(KEY), K0
+	vmovdqu		0x10(KEY), K1
+	add		$0x20, KEY
+	vpxor		PASS0_SUMS, PASS0_SUMS, PASS0_SUMS
+	vpxor		PASS1_SUMS, PASS1_SUMS, PASS1_SUMS
+	vpxor		PASS2_SUMS, PASS2_SUMS, PASS2_SUMS
+	vpxor		PASS3_SUMS, PASS3_SUMS, PASS3_SUMS
+
+	sub		$0x40, MESSAGE_LEN
+	jl		.Lloop4_done
+.Lloop4:
+	vmovdqu		(MESSAGE), T3
+	vmovdqu		0x00(KEY), K2
+	vmovdqu		0x10(KEY), K3
+	_nh_2xstride	K0, K1, K2, K3
+
+	vmovdqu		0x20(MESSAGE), T3
+	vmovdqu		0x20(KEY), K0
+	vmovdqu		0x30(KEY), K1
+	_nh_2xstride	K2, K3, K0, K1
+
+	add		$0x40, MESSAGE
+	add		$0x40, KEY
+	sub		$0x40, MESSAGE_LEN
+	jge		.Lloop4
+
+.Lloop4_done:
+	and		$0x3f, MESSAGE_LEN
+	jz		.Ldone
+
+	cmp		$0x20, MESSAGE_LEN
+	jl		.Llast
+
+	// 2 or 3 strides remain; do 2 more.
+	vmovdqu		(MESSAGE), T3
+	vmovdqu		0x00(KEY), K2
+	vmovdqu		0x10(KEY), K3
+	_nh_2xstride	K0, K1, K2, K3
+	add		$0x20, MESSAGE
+	add		$0x20, KEY
+	sub		$0x20, MESSAGE_LEN
+	jz		.Ldone
+	vmovdqa		K2, K0
+	vmovdqa		K3, K1
+.Llast:
+	// Last stride.  Zero the high 128 bits of the message and keys so they
+	// don't affect the result when processing them like 2 strides.
+	vmovdqu		(MESSAGE), T3_XMM
+	vmovdqa		K0_XMM, K0_XMM
+	vmovdqa		K1_XMM, K1_XMM
+	vmovdqu		0x00(KEY), K2_XMM
+	vmovdqu		0x10(KEY), K3_XMM
+	_nh_2xstride	K0, K1, K2, K3
+
+.Ldone:
+	// Sum the accumulators for each pass, then store the sums to 'hash'
+
+	// PASS0_SUMS is (0A 0B 0C 0D)
+	// PASS1_SUMS is (1A 1B 1C 1D)
+	// PASS2_SUMS is (2A 2B 2C 2D)
+	// PASS3_SUMS is (3A 3B 3C 3D)
+	// We need the horizontal sums:
+	//     (0A + 0B + 0C + 0D,
+	//	1A + 1B + 1C + 1D,
+	//	2A + 2B + 2C + 2D,
+	//	3A + 3B + 3C + 3D)
+	//
+
+	vpunpcklqdq	PASS1_SUMS, PASS0_SUMS, T0	// T0 = (0A 1A 0C 1C)
+	vpunpckhqdq	PASS1_SUMS, PASS0_SUMS, T1	// T1 = (0B 1B 0D 1D)
+	vpunpcklqdq	PASS3_SUMS, PASS2_SUMS, T2	// T2 = (2A 3A 2C 3C)
+	vpunpckhqdq	PASS3_SUMS, PASS2_SUMS, T3	// T3 = (2B 3B 2D 3D)
+
+	vinserti128	$0x1, T2_XMM, T0, T4		// T4 = (0A 1A 2A 3A)
+	vinserti128	$0x1, T3_XMM, T1, T5		// T5 = (0B 1B 2B 3B)
+	vperm2i128	$0x31, T2, T0, T0		// T0 = (0C 1C 2C 3C)
+	vperm2i128	$0x31, T3, T1, T1		// T1 = (0D 1D 2D 3D)
+
+	vpaddq		T5, T4, T4
+	vpaddq		T1, T0, T0
+	vpaddq		T4, T0, T0
+	vmovdqu		T0, (HASH)
+	ret
+ENDPROC(nh_avx2)
diff --git a/arch/x86/crypto/nhpoly1305-avx2-glue.c b/arch/x86/crypto/nhpoly1305-avx2-glue.c
new file mode 100644
index 0000000000000..20d815ea4b6a9
--- /dev/null
+++ b/arch/x86/crypto/nhpoly1305-avx2-glue.c
@@ -0,0 +1,77 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * NHPoly1305 - ε-almost-∆-universal hash function for Adiantum
+ * (AVX2 accelerated version)
+ *
+ * Copyright 2018 Google LLC
+ */
+
+#include <crypto/internal/hash.h>
+#include <crypto/nhpoly1305.h>
+#include <linux/module.h>
+#include <asm/fpu/api.h>
+
+asmlinkage void nh_avx2(const u32 *key, const u8 *message, size_t message_len,
+			u8 hash[NH_HASH_BYTES]);
+
+/* wrapper to avoid indirect call to assembly, which doesn't work with CFI */
+static void _nh_avx2(const u32 *key, const u8 *message, size_t message_len,
+		     __le64 hash[NH_NUM_PASSES])
+{
+	nh_avx2(key, message, message_len, (u8 *)hash);
+}
+
+static int nhpoly1305_avx2_update(struct shash_desc *desc,
+				  const u8 *src, unsigned int srclen)
+{
+	if (srclen < 64 || !irq_fpu_usable())
+		return crypto_nhpoly1305_update(desc, src, srclen);
+
+	do {
+		unsigned int n = min_t(unsigned int, srclen, PAGE_SIZE);
+
+		kernel_fpu_begin();
+		crypto_nhpoly1305_update_helper(desc, src, n, _nh_avx2);
+		kernel_fpu_end();
+		src += n;
+		srclen -= n;
+	} while (srclen);
+	return 0;
+}
+
+static struct shash_alg nhpoly1305_alg = {
+	.base.cra_name		= "nhpoly1305",
+	.base.cra_driver_name	= "nhpoly1305-avx2",
+	.base.cra_priority	= 300,
+	.base.cra_ctxsize	= sizeof(struct nhpoly1305_key),
+	.base.cra_module	= THIS_MODULE,
+	.digestsize		= POLY1305_DIGEST_SIZE,
+	.init			= crypto_nhpoly1305_init,
+	.update			= nhpoly1305_avx2_update,
+	.final			= crypto_nhpoly1305_final,
+	.setkey			= crypto_nhpoly1305_setkey,
+	.descsize		= sizeof(struct nhpoly1305_state),
+};
+
+static int __init nhpoly1305_mod_init(void)
+{
+	if (!boot_cpu_has(X86_FEATURE_AVX2) ||
+	    !boot_cpu_has(X86_FEATURE_OSXSAVE))
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
+MODULE_DESCRIPTION("NHPoly1305 ε-almost-∆-universal hash function (AVX2-accelerated)");
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Eric Biggers <ebiggers@google.com>");
+MODULE_ALIAS_CRYPTO("nhpoly1305");
+MODULE_ALIAS_CRYPTO("nhpoly1305-avx2");
diff --git a/crypto/Kconfig b/crypto/Kconfig
index b85133966d643..e084e2fb6743b 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -509,6 +509,14 @@ config CRYPTO_NHPOLY1305_SSE2
 	  SSE2 optimized implementation of the hash function used by the
 	  Adiantum encryption mode.
 
+config CRYPTO_NHPOLY1305_AVX2
+	tristate "NHPoly1305 hash function (x86_64 AVX2 implementation)"
+	depends on X86 && 64BIT
+	select CRYPTO_NHPOLY1305
+	help
+	  AVX2 optimized implementation of the hash function used by the
+	  Adiantum encryption mode.
+
 config CRYPTO_ADIANTUM
 	tristate "Adiantum support"
 	select CRYPTO_CHACHA20
-- 
2.19.2
