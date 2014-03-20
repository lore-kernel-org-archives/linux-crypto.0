From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] arm64: SHA-224/SHA-256 using ARMv8 Crypto Extensions
Date: Thu, 20 Mar 2014 15:48:06 +0100
Message-ID: <1395326886-5866-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: steve.capper@linaro.org, catalin.marinas@arm.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:38645 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933701AbaCTOsC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 20 Mar 2014 10:48:02 -0400
Received: by mail-we0-f176.google.com with SMTP id x48so669135wes.21
        for <linux-crypto@vger.kernel.org>; Thu, 20 Mar 2014 07:48:00 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds support for the SHA-224 and SHA-256 hash algorithms using the
NEON based SHA-256 instructions that were introduced in ARM v8.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---

Again, this patch depends on the FPSIMD optimization patches that I have posted
to the LAKML a while ago.

 arch/arm64/crypto/Kconfig        |   5 +
 arch/arm64/crypto/Makefile       |   3 +
 arch/arm64/crypto/sha2-ce-core.S | 131 ++++++++++++++++++++++++++
 arch/arm64/crypto/sha2-ce-glue.c | 198 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 337 insertions(+)
 create mode 100644 arch/arm64/crypto/sha2-ce-core.S
 create mode 100644 arch/arm64/crypto/sha2-ce-glue.c

diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index af378bb608e8..c14e2ae98193 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -10,4 +10,9 @@ config CRYPTO_SHA1_ARM64_CE
 	depends on ARM64 && KERNEL_MODE_NEON
 	select CRYPTO_HASH
 
+config CRYPTO_SHA2_ARM64_CE
+	tristate "SHA-224/SHA-256 digest algorithm (ARMv8 Crypto Extensions)"
+	depends on ARM64 && KERNEL_MODE_NEON
+	select CRYPTO_HASH
+
 endif
diff --git a/arch/arm64/crypto/Makefile b/arch/arm64/crypto/Makefile
index 18ceebc308dd..330742db69b3 100644
--- a/arch/arm64/crypto/Makefile
+++ b/arch/arm64/crypto/Makefile
@@ -10,3 +10,6 @@
 
 obj-$(CONFIG_CRYPTO_SHA1_ARM64_CE) += sha1-ce.o
 sha1-ce-y := sha1-ce-glue.o sha1-ce-core.o
+
+obj-$(CONFIG_CRYPTO_SHA2_ARM64_CE) += sha2-ce.o
+sha2-ce-y := sha2-ce-glue.o sha2-ce-core.o
diff --git a/arch/arm64/crypto/sha2-ce-core.S b/arch/arm64/crypto/sha2-ce-core.S
new file mode 100644
index 000000000000..79ade4be41c3
--- /dev/null
+++ b/arch/arm64/crypto/sha2-ce-core.S
@@ -0,0 +1,131 @@
+/*
+ * sha2-ce-core.S - core SHA-224/SHA-256 transform using v8 Crypto Extensions
+ *
+ * Copyright (C) 2014 Linaro Ltd <ard.biesheuvel@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/linkage.h>
+
+	.text
+	.arch		armv8-a+crypto
+
+	dga		.req	q20
+	dgav		.req	v20
+	dgb		.req	q21
+	dgbv		.req	v21
+
+	t0		.req	v22
+	t1		.req	v23
+
+	dg0q		.req	q24
+	dg0v		.req	v24
+	dg1q		.req	q25
+	dg1v		.req	v25
+	dg2q		.req	q26
+	dg2v		.req	v26
+
+	.macro		add_only, ev, rc, s0
+	mov		dg2v.16b, dg0v.16b
+	.ifc		\ev, ev
+	add		t1.4s, v\s0\().4s, \rc\().4s
+	sha256h		dg0q, dg1q, t0.4s
+	sha256h2	dg1q, dg2q, t0.4s
+	.else
+	.ifnb		\s0
+	add		t0.4s, v\s0\().4s, \rc\().4s
+	.endif
+	sha256h		dg0q, dg1q, t1.4s
+	sha256h2	dg1q, dg2q, t1.4s
+	.endif
+	.endm
+
+	.macro		add_update, ev, rc, s0, s1, s2, s3
+	sha256su0	v\s0\().4s, v\s1\().4s
+	sha256su1	v\s0\().4s, v\s2\().4s, v\s3\().4s
+	add_only	\ev, \rc, \s1
+	.endm
+
+	/*
+	 * The SHA-256 round constants
+	 */
+	.align		4
+.Lsha2_rcon:
+	.word		0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5
+	.word		0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5
+	.word		0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3
+	.word		0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174
+	.word		0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc
+	.word		0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da
+	.word		0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7
+	.word		0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967
+	.word		0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13
+	.word		0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85
+	.word		0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3
+	.word		0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070
+	.word		0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5
+	.word		0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3
+	.word		0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208
+	.word		0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
+
+	/*
+	 * void sha2_ce_transform(u32 *state, u8 const *src, int blocks)
+	 */
+ENTRY(sha2_ce_transform)
+	/* load round constants */
+	adr		x3, .Lsha2_rcon
+	.irp		r, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
+	ldr		q\r, [x3], #16
+	.endr
+
+	/* load state */
+	ldr		dga, [x0]
+	ldr		dgb, [x0, #16]
+
+	/* load input */
+0:	ld1		{v16.4s-v19.4s}, [x1], #64
+
+	sub		w2, w2, #1
+
+	rev32		v16.16b, v16.16b
+	rev32		v17.16b, v17.16b
+	rev32		v18.16b, v18.16b
+	rev32		v19.16b, v19.16b
+
+	add		t0.4s, v16.4s, v0.4s
+	mov		dg0v.16b, dgav.16b
+	mov		dg1v.16b, dgbv.16b
+
+	add_update	ev,  v1, 16, 17, 18, 19
+	add_update	od,  v2, 17, 18, 19, 16
+	add_update	ev,  v3, 18, 19, 16, 17
+	add_update	od,  v4, 19, 16, 17, 18
+
+	add_update	ev,  v5, 16, 17, 18, 19
+	add_update	od,  v6, 17, 18, 19, 16
+	add_update	ev,  v7, 18, 19, 16, 17
+	add_update	od,  v8, 19, 16, 17, 18
+
+	add_update	ev,  v9, 16, 17, 18, 19
+	add_update	od, v10, 17, 18, 19, 16
+	add_update	ev, v11, 18, 19, 16, 17
+	add_update	od, v12, 19, 16, 17, 18
+
+	add_only	ev, v13, 17
+	add_only	od, v14, 18
+	add_only	ev, v15, 19
+	add_only	od
+
+	/* update state */
+	add		dgav.4s, dgav.4s, dg0v.4s
+	add		dgbv.4s, dgbv.4s, dg1v.4s
+	cbnz		w2, 0b
+
+	/* store new state */
+	str		dga, [x0]
+	str		dgb, [x0, #16]
+	ret
+ENDPROC(sha2_ce_transform)
diff --git a/arch/arm64/crypto/sha2-ce-glue.c b/arch/arm64/crypto/sha2-ce-glue.c
new file mode 100644
index 000000000000..5c896221e282
--- /dev/null
+++ b/arch/arm64/crypto/sha2-ce-glue.c
@@ -0,0 +1,198 @@
+/*
+ * sha2-ce-glue.c - SHA-224/SHA-256 using ARMv8 Crypto Extensions
+ *
+ * Copyright (C) 2014 Linaro Ltd <ard.biesheuvel@linaro.org>
+ *
+ * Derived from linux/crypto/sha1_generic.c
+ *
+ * Copyright (c) Alan Smithee.
+ * Copyright (c) Andrew McDonald <andrew@mcdonald.org.uk>
+ * Copyright (c) Jean-Francois Dive <jef@linuxbe.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <asm/byteorder.h>
+#include <asm/hwcap.h>
+#include <asm/neon.h>
+#include <crypto/internal/hash.h>
+#include <crypto/sha.h>
+#include <linux/cpufeature.h>
+#include <linux/crypto.h>
+#include <linux/module.h>
+
+MODULE_DESCRIPTION("SHA-224/SHA-256 secure hash using ARMv8 Crypto Extensions");
+MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
+MODULE_LICENSE("GPL v2");
+
+asmlinkage void sha2_ce_transform(u32 *state, u8 const *src, int blocks);
+
+static int sha224_init(struct shash_desc *desc)
+{
+	struct sha256_state *sctx = shash_desc_ctx(desc);
+
+	*sctx = (struct sha256_state){
+		.state = {
+			SHA224_H0, SHA224_H1, SHA224_H2, SHA224_H3,
+			SHA224_H4, SHA224_H5, SHA224_H6, SHA224_H7,
+		}
+	};
+	return 0;
+}
+
+static int sha256_init(struct shash_desc *desc)
+{
+	struct sha256_state *sctx = shash_desc_ctx(desc);
+
+	*sctx = (struct sha256_state){
+		.state = {
+			SHA256_H0, SHA256_H1, SHA256_H2, SHA256_H3,
+			SHA256_H4, SHA256_H5, SHA256_H6, SHA256_H7,
+		}
+	};
+	return 0;
+}
+
+static int sha2_update(struct shash_desc *desc, const u8 *data,
+		       unsigned int len)
+{
+	struct sha256_state *sctx = shash_desc_ctx(desc);
+	unsigned int partial, done = 0;
+
+	partial = sctx->count % SHA256_BLOCK_SIZE;
+
+	if ((partial + len) >= SHA256_BLOCK_SIZE) {
+		int blocks;
+
+		kernel_neon_begin();
+		if (partial) {
+			done = SHA256_BLOCK_SIZE - partial;
+			memcpy(sctx->buf + partial, data, done);
+			sha2_ce_transform(sctx->state, sctx->buf, 1);
+			partial = 0;
+		}
+
+		blocks = (len - done) / SHA256_BLOCK_SIZE;
+		if (blocks) {
+			sha2_ce_transform(sctx->state, data + done, blocks);
+			done += blocks * SHA256_BLOCK_SIZE;
+		}
+		kernel_neon_end();
+	}
+	if (len > done)
+		memcpy(sctx->buf + partial, data + done, len - done);
+	sctx->count += len;
+	return 0;
+}
+
+static void sha2_final(struct shash_desc *desc)
+{
+	static const u8 padding[SHA256_BLOCK_SIZE] = { 0x80, };
+
+	struct sha256_state *sctx = shash_desc_ctx(desc);
+	__be64 bits = cpu_to_be64(sctx->count << 3);
+	u32 padlen = SHA256_BLOCK_SIZE
+		     - ((sctx->count + sizeof(bits)) % SHA256_BLOCK_SIZE);
+
+	sha2_update(desc, padding, padlen);
+	sha2_update(desc, (const u8 *)&bits, sizeof(bits));
+}
+
+static int sha224_final(struct shash_desc *desc, u8 *out)
+{
+	struct sha256_state *sctx = shash_desc_ctx(desc);
+	__be32 *dst = (__be32 *)out;
+	int i;
+
+	sha2_final(desc);
+
+	for (i = 0; i < SHA224_DIGEST_SIZE / sizeof(*dst); i++)
+		dst[i] = cpu_to_be32(sctx->state[i]);
+
+	*sctx = (struct sha256_state){};
+	return 0;
+}
+
+static int sha256_final(struct shash_desc *desc, u8 *out)
+{
+	struct sha256_state *sctx = shash_desc_ctx(desc);
+	__be32 *dst = (__be32 *)out;
+	int i;
+
+	sha2_final(desc);
+
+	for (i = 0; i < SHA256_DIGEST_SIZE / sizeof(*dst); i++)
+		dst[i] = cpu_to_be32(sctx->state[i]);
+
+	*sctx = (struct sha256_state){};
+	return 0;
+}
+
+static int sha2_export(struct shash_desc *desc, void *out)
+{
+	struct sha256_state *sctx = shash_desc_ctx(desc);
+	struct sha256_state *dst = out;
+
+	*dst = *sctx;
+	return 0;
+}
+
+static int sha2_import(struct shash_desc *desc, const void *in)
+{
+	struct sha256_state *sctx = shash_desc_ctx(desc);
+	struct sha256_state const *src = in;
+
+	*sctx = *src;
+	return 0;
+}
+
+static struct shash_alg algs[] = { {
+	.digestsize		= SHA224_DIGEST_SIZE,
+	.init			= sha224_init,
+	.update			= sha2_update,
+	.final			= sha224_final,
+	.export			= sha2_export,
+	.import			= sha2_import,
+	.descsize		= sizeof(struct sha256_state),
+	.statesize		= sizeof(struct sha256_state),
+	.base			= {
+		.cra_name		= "sha224",
+		.cra_driver_name	= "sha224-ce",
+		.cra_priority		= 200,
+		.cra_flags		= CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize		= SHA256_BLOCK_SIZE,
+		.cra_module		= THIS_MODULE,
+	}
+}, {
+	.digestsize		= SHA256_DIGEST_SIZE,
+	.init			= sha256_init,
+	.update			= sha2_update,
+	.final			= sha256_final,
+	.export			= sha2_export,
+	.import			= sha2_import,
+	.descsize		= sizeof(struct sha256_state),
+	.statesize		= sizeof(struct sha256_state),
+	.base			= {
+		.cra_name		= "sha256",
+		.cra_driver_name	= "sha256-ce",
+		.cra_priority		= 200,
+		.cra_flags		= CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize		= SHA256_BLOCK_SIZE,
+		.cra_module		= THIS_MODULE,
+	}
+} };
+
+static int __init sha2_generic_mod_init(void)
+{
+	return crypto_register_shashes(algs, ARRAY_SIZE(algs));
+}
+
+static void __exit sha2_generic_mod_fini(void)
+{
+	crypto_unregister_shashes(algs, ARRAY_SIZE(algs));
+}
+
+module_cpu_feature_match(SHA2, sha2_generic_mod_init);
+module_exit(sha2_generic_mod_fini);
-- 
1.8.3.2
