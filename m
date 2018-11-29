Return-Path: <SRS0=WCFZ=OI=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727643AbeK2Rje (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Nov 2018 12:39:34 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Paul Crowley <paulcrowley@google.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] crypto: arm64/nhpoly1305 - add NEON-accelerated NHPoly1305
Date: Wed, 28 Nov 2018 22:34:19 -0800
Message-Id: <20181129063422.24307-2-ebiggers@kernel.org>
In-Reply-To: <20181129063422.24307-1-ebiggers@kernel.org>
References: <20181129063422.24307-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

Add an ARM64 NEON implementation of NHPoly1305, an ε-almost-∆-universal
hash function used in the Adiantum encryption mode.  For now, only the
NH portion is actually NEON-accelerated; the Poly1305 part is less
performance-critical so is just implemented in C.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm64/crypto/Kconfig                |   5 ++
 arch/arm64/crypto/Makefile               |   3 +
 arch/arm64/crypto/nh-neon-core.S         | 103 +++++++++++++++++++++++
 arch/arm64/crypto/nhpoly1305-neon-glue.c |  77 +++++++++++++++++
 4 files changed, 188 insertions(+)
 create mode 100644 arch/arm64/crypto/nh-neon-core.S
 create mode 100644 arch/arm64/crypto/nhpoly1305-neon-glue.c

diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index a5606823ed4da..3f5aeb786192b 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -106,6 +106,11 @@ config CRYPTO_CHACHA20_NEON
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_CHACHA20
 
+config CRYPTO_NHPOLY1305_NEON
+	tristate "NHPoly1305 hash function using NEON instructions (for Adiantum)"
+	depends on KERNEL_MODE_NEON
+	select CRYPTO_NHPOLY1305
+
 config CRYPTO_AES_ARM64_BS
 	tristate "AES in ECB/CBC/CTR/XTS modes using bit-sliced NEON algorithm"
 	depends on KERNEL_MODE_NEON
diff --git a/arch/arm64/crypto/Makefile b/arch/arm64/crypto/Makefile
index f476fede09ba4..125dbb10a93ed 100644
--- a/arch/arm64/crypto/Makefile
+++ b/arch/arm64/crypto/Makefile
@@ -53,6 +53,9 @@ sha512-arm64-y := sha512-glue.o sha512-core.o
 obj-$(CONFIG_CRYPTO_CHACHA20_NEON) += chacha20-neon.o
 chacha20-neon-y := chacha20-neon-core.o chacha20-neon-glue.o
 
+obj-$(CONFIG_CRYPTO_NHPOLY1305_NEON) += nhpoly1305-neon.o
+nhpoly1305-neon-y := nh-neon-core.o nhpoly1305-neon-glue.o
+
 obj-$(CONFIG_CRYPTO_AES_ARM64) += aes-arm64.o
 aes-arm64-y := aes-cipher-core.o aes-cipher-glue.o
 
diff --git a/arch/arm64/crypto/nh-neon-core.S b/arch/arm64/crypto/nh-neon-core.S
new file mode 100644
index 0000000000000..e08d57676127a
--- /dev/null
+++ b/arch/arm64/crypto/nh-neon-core.S
@@ -0,0 +1,103 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * NH - ε-almost-universal hash function, ARM64 NEON accelerated version
+ *
+ * Copyright 2018 Google LLC
+ *
+ * Author: Eric Biggers <ebiggers@google.com>
+ */
+
+#include <linux/linkage.h>
+
+	KEY		.req	x0
+	MESSAGE		.req	x1
+	MESSAGE_LEN	.req	x2
+	HASH		.req	x3
+
+	PASS0_SUMS	.req	v0
+	PASS1_SUMS	.req	v1
+	PASS2_SUMS	.req	v2
+	PASS3_SUMS	.req	v3
+	K0		.req	v4
+	K1		.req	v5
+	K2		.req	v6
+	K3		.req	v7
+	T0		.req	v8
+	T1		.req	v9
+	T2		.req	v10
+	T3		.req	v11
+	T4		.req	v12
+	T5		.req	v13
+	T6		.req	v14
+	T7		.req	v15
+
+.macro _nh_stride	k0, k1, k2, k3
+
+	// Load next message stride
+	ld1		{T3.16b}, [MESSAGE], #16
+
+	// Load next key stride
+	ld1		{\k3\().4s}, [KEY], #16
+
+	// Add message words to key words
+	add		T0.4s, T3.4s, \k0\().4s
+	add		T1.4s, T3.4s, \k1\().4s
+	add		T2.4s, T3.4s, \k2\().4s
+	add		T3.4s, T3.4s, \k3\().4s
+
+	// Multiply 32x32 => 64 and accumulate
+	mov             T4.d[0], T0.d[1]
+	mov             T5.d[0], T1.d[1]
+	mov             T6.d[0], T2.d[1]
+	mov             T7.d[0], T3.d[1]
+	umlal		PASS0_SUMS.2d, T0.2s, T4.2s
+	umlal		PASS1_SUMS.2d, T1.2s, T5.2s
+	umlal		PASS2_SUMS.2d, T2.2s, T6.2s
+	umlal		PASS3_SUMS.2d, T3.2s, T7.2s
+.endm
+
+/*
+ * void nh_neon(const u32 *key, const u8 *message, size_t message_len,
+ *		u8 hash[NH_HASH_BYTES])
+ *
+ * It's guaranteed that message_len % 16 == 0.
+ */
+ENTRY(nh_neon)
+
+	ld1		{K0.4s,K1.4s}, [KEY], #32
+	  movi		PASS0_SUMS.2d, #0
+	  movi		PASS1_SUMS.2d, #0
+	ld1		{K2.4s}, [KEY], #16
+	  movi		PASS2_SUMS.2d, #0
+	  movi		PASS3_SUMS.2d, #0
+
+	subs		MESSAGE_LEN, MESSAGE_LEN, #64
+	blt		.Lloop4_done
+.Lloop4:
+	_nh_stride	K0, K1, K2, K3
+	_nh_stride	K1, K2, K3, K0
+	_nh_stride	K2, K3, K0, K1
+	_nh_stride	K3, K0, K1, K2
+	subs		MESSAGE_LEN, MESSAGE_LEN, #64
+	bge		.Lloop4
+
+.Lloop4_done:
+	ands		MESSAGE_LEN, MESSAGE_LEN, #63
+	beq		.Ldone
+	_nh_stride	K0, K1, K2, K3
+
+	subs		MESSAGE_LEN, MESSAGE_LEN, #16
+	beq		.Ldone
+	_nh_stride	K1, K2, K3, K0
+
+	subs		MESSAGE_LEN, MESSAGE_LEN, #16
+	beq		.Ldone
+	_nh_stride	K2, K3, K0, K1
+
+.Ldone:
+	// Sum the accumulators for each pass, then store the sums to 'hash'
+	addp		T0.2d, PASS0_SUMS.2d, PASS1_SUMS.2d
+	addp		T1.2d, PASS2_SUMS.2d, PASS3_SUMS.2d
+	st1		{T0.16b,T1.16b}, [HASH]
+	ret
+ENDPROC(nh_neon)
diff --git a/arch/arm64/crypto/nhpoly1305-neon-glue.c b/arch/arm64/crypto/nhpoly1305-neon-glue.c
new file mode 100644
index 0000000000000..22cc32ac9448d
--- /dev/null
+++ b/arch/arm64/crypto/nhpoly1305-neon-glue.c
@@ -0,0 +1,77 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * NHPoly1305 - ε-almost-∆-universal hash function for Adiantum
+ * (ARM64 NEON accelerated version)
+ *
+ * Copyright 2018 Google LLC
+ */
+
+#include <asm/neon.h>
+#include <asm/simd.h>
+#include <crypto/internal/hash.h>
+#include <crypto/nhpoly1305.h>
+#include <linux/module.h>
+
+asmlinkage void nh_neon(const u32 *key, const u8 *message, size_t message_len,
+			u8 hash[NH_HASH_BYTES]);
+
+/* wrapper to avoid indirect call to assembly, which doesn't work with CFI */
+static void _nh_neon(const u32 *key, const u8 *message, size_t message_len,
+		     __le64 hash[NH_NUM_PASSES])
+{
+	nh_neon(key, message, message_len, (u8 *)hash);
+}
+
+static int nhpoly1305_neon_update(struct shash_desc *desc,
+				  const u8 *src, unsigned int srclen)
+{
+	if (srclen < 64 || !may_use_simd())
+		return crypto_nhpoly1305_update(desc, src, srclen);
+
+	do {
+		unsigned int n = min_t(unsigned int, srclen, PAGE_SIZE);
+
+		kernel_neon_begin();
+		crypto_nhpoly1305_update_helper(desc, src, n, _nh_neon);
+		kernel_neon_end();
+		src += n;
+		srclen -= n;
+	} while (srclen);
+	return 0;
+}
+
+static struct shash_alg nhpoly1305_alg = {
+	.base.cra_name		= "nhpoly1305",
+	.base.cra_driver_name	= "nhpoly1305-neon",
+	.base.cra_priority	= 200,
+	.base.cra_ctxsize	= sizeof(struct nhpoly1305_key),
+	.base.cra_module	= THIS_MODULE,
+	.digestsize		= POLY1305_DIGEST_SIZE,
+	.init			= crypto_nhpoly1305_init,
+	.update			= nhpoly1305_neon_update,
+	.final			= crypto_nhpoly1305_final,
+	.setkey			= crypto_nhpoly1305_setkey,
+	.descsize		= sizeof(struct nhpoly1305_state),
+};
+
+static int __init nhpoly1305_mod_init(void)
+{
+	if (!(elf_hwcap & HWCAP_ASIMD))
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
+MODULE_DESCRIPTION("NHPoly1305 ε-almost-∆-universal hash function (NEON-accelerated)");
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Eric Biggers <ebiggers@google.com>");
+MODULE_ALIAS_CRYPTO("nhpoly1305");
+MODULE_ALIAS_CRYPTO("nhpoly1305-neon");
-- 
2.19.2
