From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFT PATCH] crypto: arm64 - implement SHA-512 using special instructions
Date: Tue,  9 Jan 2018 18:23:02 +0000
Message-ID: <20180109182302.11521-1-ard.biesheuvel@linaro.org>
Cc: peter.maydell@linaro.org, will.deacon@arm.com,
        catalin.marinas@arm.com, steve.capper@linaro.org,
        linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:43525 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753473AbeAISXR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Jan 2018 13:23:17 -0500
Received: by mail-wr0-f195.google.com with SMTP id s13so12667558wra.10
        for <linux-crypto@vger.kernel.org>; Tue, 09 Jan 2018 10:23:16 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Implement the SHA-512 using the new special instructions that have
been introduced as an optional extension in ARMv8.2.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/Kconfig          |   6 ++
 arch/arm64/crypto/Makefile         |   3 +
 arch/arm64/crypto/sha512-ce-core.S | 207 +++++++++++++++++++++++++++++++++++++
 arch/arm64/crypto/sha512-ce-glue.c | 119 +++++++++++++++++++++
 4 files changed, 335 insertions(+)
 create mode 100644 arch/arm64/crypto/sha512-ce-core.S
 create mode 100644 arch/arm64/crypto/sha512-ce-glue.c

diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index 70c517aa4501..aad288f4b9de 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -29,6 +29,12 @@ config CRYPTO_SHA2_ARM64_CE
 	select CRYPTO_HASH
 	select CRYPTO_SHA256_ARM64
 
+config CRYPTO_SHA512_ARM64_CE
+	tristate "SHA-384/SHA-512 digest algorithm (ARMv8 Crypto Extensions)"
+	depends on KERNEL_MODE_NEON
+	select CRYPTO_HASH
+	select CRYPTO_SHA512_ARM64
+
 config CRYPTO_GHASH_ARM64_CE
 	tristate "GHASH/AES-GCM using ARMv8 Crypto Extensions"
 	depends on KERNEL_MODE_NEON
diff --git a/arch/arm64/crypto/Makefile b/arch/arm64/crypto/Makefile
index b5edc5918c28..d7573d31d397 100644
--- a/arch/arm64/crypto/Makefile
+++ b/arch/arm64/crypto/Makefile
@@ -14,6 +14,9 @@ sha1-ce-y := sha1-ce-glue.o sha1-ce-core.o
 obj-$(CONFIG_CRYPTO_SHA2_ARM64_CE) += sha2-ce.o
 sha2-ce-y := sha2-ce-glue.o sha2-ce-core.o
 
+obj-$(CONFIG_CRYPTO_SHA512_ARM64_CE) += sha512-ce.o
+sha512-ce-y := sha512-ce-glue.o sha512-ce-core.o
+
 obj-$(CONFIG_CRYPTO_GHASH_ARM64_CE) += ghash-ce.o
 ghash-ce-y := ghash-ce-glue.o ghash-ce-core.o
 
diff --git a/arch/arm64/crypto/sha512-ce-core.S b/arch/arm64/crypto/sha512-ce-core.S
new file mode 100644
index 000000000000..6c562f8df0b0
--- /dev/null
+++ b/arch/arm64/crypto/sha512-ce-core.S
@@ -0,0 +1,207 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * sha512-ce-core.S - core SHA-384/SHA-512 transform using v8 Crypto Extensions
+ *
+ * Copyright (C) 2018 Linaro Ltd <ard.biesheuvel@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+
+	//
+	// Temporary - for testing only. binutils has no support for these yet
+	//
+	.irp		b,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
+	.set		.Lq\b, \b
+	.set		.Lv\b\().2d, \b
+	.endr
+
+	.macro		sha512h, rd, rn, rm
+	.inst		0xce608000 | .L\rd | (.L\rn << 5) | (.L\rm << 16)
+	.endm
+
+	.macro		sha512h2, rd, rn, rm
+	.inst		0xce608400 | .L\rd | (.L\rn << 5) | (.L\rm << 16)
+	.endm
+
+	.macro		sha512su0, rd, rn
+	.inst		0xcec08000 | .L\rd | (.L\rn << 5)
+	.endm
+
+	.macro		sha512su1, rd, rn, rm
+	.inst		0xce608800 | .L\rd | (.L\rn << 5) | (.L\rm << 16)
+	.endm
+
+	.text
+	.arch		armv8-a+crypto
+
+	/*
+	 * The SHA-512 round constants
+	 */
+	.align		4
+.Lsha512_rcon:
+	.quad		0x428a2f98d728ae22, 0x7137449123ef65cd
+	.quad		0xb5c0fbcfec4d3b2f, 0xe9b5dba58189dbbc
+	.quad		0x3956c25bf348b538, 0x59f111f1b605d019
+	.quad		0x923f82a4af194f9b, 0xab1c5ed5da6d8118
+	.quad		0xd807aa98a3030242, 0x12835b0145706fbe
+	.quad		0x243185be4ee4b28c, 0x550c7dc3d5ffb4e2
+	.quad		0x72be5d74f27b896f, 0x80deb1fe3b1696b1
+	.quad		0x9bdc06a725c71235, 0xc19bf174cf692694
+	.quad		0xe49b69c19ef14ad2, 0xefbe4786384f25e3
+	.quad		0x0fc19dc68b8cd5b5, 0x240ca1cc77ac9c65
+	.quad		0x2de92c6f592b0275, 0x4a7484aa6ea6e483
+	.quad		0x5cb0a9dcbd41fbd4, 0x76f988da831153b5
+	.quad		0x983e5152ee66dfab, 0xa831c66d2db43210
+	.quad		0xb00327c898fb213f, 0xbf597fc7beef0ee4
+	.quad		0xc6e00bf33da88fc2, 0xd5a79147930aa725
+	.quad		0x06ca6351e003826f, 0x142929670a0e6e70
+	.quad		0x27b70a8546d22ffc, 0x2e1b21385c26c926
+	.quad		0x4d2c6dfc5ac42aed, 0x53380d139d95b3df
+	.quad		0x650a73548baf63de, 0x766a0abb3c77b2a8
+	.quad		0x81c2c92e47edaee6, 0x92722c851482353b
+	.quad		0xa2bfe8a14cf10364, 0xa81a664bbc423001
+	.quad		0xc24b8b70d0f89791, 0xc76c51a30654be30
+	.quad		0xd192e819d6ef5218, 0xd69906245565a910
+	.quad		0xf40e35855771202a, 0x106aa07032bbd1b8
+	.quad		0x19a4c116b8d2d0c8, 0x1e376c085141ab53
+	.quad		0x2748774cdf8eeb99, 0x34b0bcb5e19b48a8
+	.quad		0x391c0cb3c5c95a63, 0x4ed8aa4ae3418acb
+	.quad		0x5b9cca4f7763e373, 0x682e6ff3d6b2b8a3
+	.quad		0x748f82ee5defb2fc, 0x78a5636f43172f60
+	.quad		0x84c87814a1f0ab72, 0x8cc702081a6439ec
+	.quad		0x90befffa23631e28, 0xa4506cebde82bde9
+	.quad		0xbef9a3f7b2c67915, 0xc67178f2e372532b
+	.quad		0xca273eceea26619c, 0xd186b8c721c0c207
+	.quad		0xeada7dd6cde0eb1e, 0xf57d4f7fee6ed178
+	.quad		0x06f067aa72176fba, 0x0a637dc5a2c898a6
+	.quad		0x113f9804bef90dae, 0x1b710b35131c471b
+	.quad		0x28db77f523047d84, 0x32caab7b40c72493
+	.quad		0x3c9ebe0a15c9bebc, 0x431d67c49c100d4c
+	.quad		0x4cc5d4becb3e42b6, 0x597f299cfc657e2a
+	.quad		0x5fcb6fab3ad6faec, 0x6c44198c4a475817
+
+	.macro		dround, i0, i1, i2, i3, i4, rc0, rc1, in0, in1, in2, in3, in4
+	.ifnb		\rc1
+	ld1		{v\rc1\().2d}, [x3], #16
+	.endif
+	add		v\rc0\().2d, v\rc0\().2d, v\in0\().2d
+	ext		v6.16b, v\i2\().16b, v\i3\().16b, #8
+	ext		v\rc0\().16b, v\rc0\().16b, v\rc0\().16b, #8
+	ext		v7.16b, v\i1\().16b, v\i2\().16b, #8
+	add		v\i3\().2d, v\i3\().2d, v\rc0\().2d
+	.ifnb		\in1
+	ext		v10.16b, v\in3\().16b, v\in4\().16b, #8
+	sha512su0	v\in0\().2d, v\in1\().2d
+	.endif
+	sha512h		q\i3, q6, v7.2d
+	.ifnb		\in1
+	sha512su1	v\in0\().2d, v\in2\().2d, v10.2d
+	.endif
+	add		v\i4\().2d, v\i1\().2d, v\i3\().2d
+	sha512h2	q\i3, q\i1, v\i0\().2d
+	.endm
+
+	/*
+	 * void sha512_ce_transform(struct sha512_state *sst, u8 const *src,
+	 *			  int blocks)
+	 */
+ENTRY(sha512_ce_transform)
+	/* load state */
+	ld1		{v20.2d-v23.2d}, [x0]
+
+	/* load input */
+0:	ld1		{v12.2d-v15.2d}, [x1], #64
+	ld1		{v16.2d-v19.2d}, [x1], #64
+	sub		w2, w2, #1
+
+	/* load round constants */
+	adr		x3, .Lsha512_rcon
+
+CPU_LE(	rev64		v12.16b, v12.16b	)
+CPU_LE(	rev64		v13.16b, v13.16b	)
+CPU_LE(	rev64		v14.16b, v14.16b	)
+CPU_LE(	rev64		v15.16b, v15.16b	)
+CPU_LE(	rev64		v16.16b, v16.16b	)
+CPU_LE(	rev64		v17.16b, v17.16b	)
+CPU_LE(	rev64		v18.16b, v18.16b	)
+CPU_LE(	rev64		v19.16b, v19.16b	)
+
+	ld1		{v8.2d}, [x3], #16
+
+	mov		v0.16b, v20.16b
+	mov		v1.16b, v21.16b
+	mov		v2.16b, v22.16b
+	mov		v3.16b, v23.16b
+
+	// v0  ab  cd  --  ef  gh  ab
+	// v1  cd  --  ef  gh  ab  cd
+	// v2  ef  gh  ab  cd  --  ef
+	// v3  gh  ab  cd  --  ef  gh
+	// v4  --  ef  gh  ab  cd  --
+
+	dround		0, 1, 2, 3, 4, 8, 9, 12, 13, 19, 16, 17
+	dround		3, 0, 4, 2, 1, 9, 8, 13, 14, 12, 17, 18
+	dround		2, 3, 1, 4, 0, 8, 9, 14, 15, 13, 18, 19
+	dround		4, 2, 0, 1, 3, 9, 8, 15, 16, 14, 19, 12
+	dround		1, 4, 3, 0, 2, 8, 9, 16, 17, 15, 12, 13
+
+	dround		0, 1, 2, 3, 4, 9, 8, 17, 18, 16, 13, 14
+	dround		3, 0, 4, 2, 1, 8, 9, 18, 19, 17, 14, 15
+	dround		2, 3, 1, 4, 0, 9, 8, 19, 12, 18, 15, 16
+	dround		4, 2, 0, 1, 3, 8, 9, 12, 13, 19, 16, 17
+	dround		1, 4, 3, 0, 2, 9, 8, 13, 14, 12, 17, 18
+
+	dround		0, 1, 2, 3, 4, 8, 9, 14, 15, 13, 18, 19
+	dround		3, 0, 4, 2, 1, 9, 8, 15, 16, 14, 19, 12
+	dround		2, 3, 1, 4, 0, 8, 9, 16, 17, 15, 12, 13
+	dround		4, 2, 0, 1, 3, 9, 8, 17, 18, 16, 13, 14
+	dround		1, 4, 3, 0, 2, 8, 9, 18, 19, 17, 14, 15
+
+	dround		0, 1, 2, 3, 4, 9, 8, 19, 12, 18, 15, 16
+	dround		3, 0, 4, 2, 1, 8, 9, 12, 13, 19, 16, 17
+	dround		2, 3, 1, 4, 0, 9, 8, 13, 14, 12, 17, 18
+	dround		4, 2, 0, 1, 3, 8, 9, 14, 15, 13, 18, 19
+	dround		1, 4, 3, 0, 2, 9, 8, 15, 16, 14, 19, 12
+
+	dround		0, 1, 2, 3, 4, 8, 9, 16, 17, 15, 12, 13
+	dround		3, 0, 4, 2, 1, 9, 8, 17, 18, 16, 13, 14
+	dround		2, 3, 1, 4, 0, 8, 9, 18, 19, 17, 14, 15
+	dround		4, 2, 0, 1, 3, 9, 8, 19, 12, 18, 15, 16
+	dround		1, 4, 3, 0, 2, 8, 9, 12, 13, 19, 16, 17
+
+	dround		0, 1, 2, 3, 4, 9, 8, 13, 14, 12, 17, 18
+	dround		3, 0, 4, 2, 1, 8, 9, 14, 15, 13, 18, 19
+	dround		2, 3, 1, 4, 0, 9, 8, 15, 16, 14, 19, 12
+	dround		4, 2, 0, 1, 3, 8, 9, 16, 17, 15, 12, 13
+	dround		1, 4, 3, 0, 2, 9, 8, 17, 18, 16, 13, 14
+
+	dround		0, 1, 2, 3, 4, 8, 9, 18, 19, 17, 14, 15
+	dround		3, 0, 4, 2, 1, 9, 8, 19, 12, 18, 15, 16
+	dround		2, 3, 1, 4, 0, 8, 9, 12
+	dround		4, 2, 0, 1, 3, 9, 8, 13
+	dround		1, 4, 3, 0, 2, 8, 9, 14
+
+	dround		0, 1, 2, 3, 4, 9, 8, 15
+	dround		3, 0, 4, 2, 1, 8, 9, 16
+	dround		2, 3, 1, 4, 0, 9, 8, 17
+	dround		4, 2, 0, 1, 3, 8, 9, 18
+	dround		1, 4, 3, 0, 2, 9,  , 19
+
+	/* update state */
+	add		v20.2d, v20.2d, v0.2d
+	add		v21.2d, v21.2d, v1.2d
+	add		v22.2d, v22.2d, v2.2d
+	add		v23.2d, v23.2d, v3.2d
+
+	/* handled all input blocks? */
+	cbnz		w2, 0b
+
+	/* store new state */
+3:	st1		{v20.2d-v23.2d}, [x0]
+	ret
+ENDPROC(sha512_ce_transform)
diff --git a/arch/arm64/crypto/sha512-ce-glue.c b/arch/arm64/crypto/sha512-ce-glue.c
new file mode 100644
index 000000000000..a77c8632a589
--- /dev/null
+++ b/arch/arm64/crypto/sha512-ce-glue.c
@@ -0,0 +1,119 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * sha512-ce-glue.c - SHA-384/SHA-512 using ARMv8 Crypto Extensions
+ *
+ * Copyright (C) 2018 Linaro Ltd <ard.biesheuvel@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <asm/neon.h>
+#include <asm/simd.h>
+#include <asm/unaligned.h>
+#include <crypto/internal/hash.h>
+#include <crypto/sha.h>
+#include <crypto/sha512_base.h>
+#include <linux/cpufeature.h>
+#include <linux/crypto.h>
+#include <linux/module.h>
+
+MODULE_DESCRIPTION("SHA-384/SHA-512 secure hash using ARMv8 Crypto Extensions");
+MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
+MODULE_LICENSE("GPL v2");
+
+asmlinkage void sha512_ce_transform(struct sha512_state *sst, u8 const *src,
+				    int blocks);
+
+asmlinkage void sha512_block_data_order(u64 *digest, u8 const *src, int blocks);
+
+static int sha512_ce_update(struct shash_desc *desc, const u8 *data,
+			    unsigned int len)
+{
+	if (!may_use_simd())
+		return sha512_base_do_update(desc, data, len,
+				(sha512_block_fn *)sha512_block_data_order);
+
+	kernel_neon_begin();
+	sha512_base_do_update(desc, data, len,
+			      (sha512_block_fn *)sha512_ce_transform);
+	kernel_neon_end();
+
+	return 0;
+}
+
+static int sha512_ce_finup(struct shash_desc *desc, const u8 *data,
+			   unsigned int len, u8 *out)
+{
+	if (!may_use_simd()) {
+		if (len)
+			sha512_base_do_update(desc, data, len,
+				(sha512_block_fn *)sha512_block_data_order);
+		sha512_base_do_finalize(desc,
+				(sha512_block_fn *)sha512_block_data_order);
+		return sha512_base_finish(desc, out);
+	}
+
+	kernel_neon_begin();
+	sha512_base_do_update(desc, data, len,
+			      (sha512_block_fn *)sha512_ce_transform);
+	sha512_base_do_finalize(desc, (sha512_block_fn *)sha512_ce_transform);
+	kernel_neon_end();
+	return sha512_base_finish(desc, out);
+}
+
+static int sha512_ce_final(struct shash_desc *desc, u8 *out)
+{
+	if (!may_use_simd()) {
+		sha512_base_do_finalize(desc,
+				(sha512_block_fn *)sha512_block_data_order);
+		return sha512_base_finish(desc, out);
+	}
+
+	kernel_neon_begin();
+	sha512_base_do_finalize(desc, (sha512_block_fn *)sha512_ce_transform);
+	kernel_neon_end();
+	return sha512_base_finish(desc, out);
+}
+
+static struct shash_alg algs[] = { {
+	.init			= sha384_base_init,
+	.update			= sha512_ce_update,
+	.final			= sha512_ce_final,
+	.finup			= sha512_ce_finup,
+	.descsize		= sizeof(struct sha512_state),
+	.digestsize		= SHA384_DIGEST_SIZE,
+	.base.cra_name		= "sha384",
+	.base.cra_driver_name	= "sha384-ce",
+	.base.cra_priority	= 200,
+	.base.cra_flags		= CRYPTO_ALG_TYPE_SHASH,
+	.base.cra_blocksize	= SHA512_BLOCK_SIZE,
+	.base.cra_module	= THIS_MODULE,
+}, {
+	.init			= sha512_base_init,
+	.update			= sha512_ce_update,
+	.final			= sha512_ce_final,
+	.finup			= sha512_ce_finup,
+	.descsize		= sizeof(struct sha512_state),
+	.digestsize		= SHA512_DIGEST_SIZE,
+	.base.cra_name		= "sha512",
+	.base.cra_driver_name	= "sha512-ce",
+	.base.cra_priority	= 200,
+	.base.cra_flags		= CRYPTO_ALG_TYPE_SHASH,
+	.base.cra_blocksize	= SHA512_BLOCK_SIZE,
+	.base.cra_module	= THIS_MODULE,
+} };
+
+static int __init sha512_ce_mod_init(void)
+{
+	return crypto_register_shashes(algs, ARRAY_SIZE(algs));
+}
+
+static void __exit sha512_ce_mod_fini(void)
+{
+	crypto_unregister_shashes(algs, ARRAY_SIZE(algs));
+}
+
+module_cpu_feature_match(SHA512, sha512_ce_mod_init);
+module_exit(sha512_ce_mod_fini);
-- 
2.11.0
