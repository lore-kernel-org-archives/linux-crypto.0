Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB2E8C0015E
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Jul 2023 17:30:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232450AbjGZRaO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Jul 2023 13:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232435AbjGZRaN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Jul 2023 13:30:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A41021BE2
        for <linux-crypto@vger.kernel.org>; Wed, 26 Jul 2023 10:30:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3932B61BE3
        for <linux-crypto@vger.kernel.org>; Wed, 26 Jul 2023 17:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89277C433C8;
        Wed, 26 Jul 2023 17:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690392611;
        bh=irpEcK2hViWhMC6eJYNN+kDzd1Lu4XfH2c+CFE61cEY=;
        h=From:To:Cc:Subject:Date:From;
        b=jVeCArQpCWaTOxRvV6JVbpoNLKw8uax30+FykVwVORxEY8bNgye7o0H79AkmVINaL
         fvbjuBitkcBkFC10+mga7yUYICzRcZuPjXEslQqtcKC07fVSooNuSI2TW+eZ9rpAg0
         6fN+3E9BC7rpSXLPhGhXvRT6LrgZIe4xU2He2H6x2eo91HsJm3NCMMo1OXI7yjWCin
         KGivsIhCaLHH57GQygZ4MDUuuABul28RTkVkTjtJPWBKTiCoPYRxp53bShSLJVs3Z9
         g8uP4XE538xVq7PlGi7q4zOTSU6RokFT/h10IBAfGn0E9VNKlTF9FHV3Rw1JeHu9HV
         SoDSYRvT7tOUA==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        linux-riscv@lists.infradead.org, Ard Biesheuvel <ardb@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        =?UTF-8?q?Christoph=20M=C3=BCllner?= <christoph.muellner@vrull.eu>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>
Subject: [PATCH] crypto: riscv/aes - Implement scalar Zkn version for RV32
Date:   Wed, 26 Jul 2023 19:29:58 +0200
Message-Id: <20230726172958.1215472-1-ardb@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=8501; i=ardb@kernel.org; h=from:subject; bh=irpEcK2hViWhMC6eJYNN+kDzd1Lu4XfH2c+CFE61cEY=; b=owGbwMvMwCFmkMcZplerG8N4Wi2JIeVghOg1Kxsj1TNeCY0Fr+ZpHTHv+WfmISLaEMjhncKR8 EfvtWtHKQuDGAeDrJgii8Dsv+92np4oVes8SxZmDisTyBAGLk4BmMiSWYwMZxIPX/Nd8jt6VtXl Bvv1iQq3JjMw3bwfuZznZU+34KwGPkaGRW8lGtY9Xs29XW5JiV/Qpj/mzq9X7zuq5ZqxUilbrv8 oPwA=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The generic AES implementation we rely on if no architecture specific
one is available relies on lookup tables that are relatively large with
respect to the typical L1 D-cache size, which not only affects
performance, it may also result in timing variances that correlate with
the encryption keys.

So we tend to avoid the generic code if we can, usually by using a
driver that makes use of special AES instructions which supplant most of
the logic of the table based implementation the AES algorithm.

The Zkn RISC-V extension provides another interesting take on this: it
defines instructions operating on scalar registers that implement the
table lookups without relying on tables in memory. Those tables carry
32-bit quantities, making them a natural fit for a 32-bit architecture.
And given the use of scalars, we don't have to rely in in-kernel SIMD,
which is a bonus.

So let's use the instructions to implement the core AES cipher for RV32.

Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Christoph Müllner <christoph.muellner@vrull.eu>
Cc: Heiko Stuebner <heiko.stuebner@vrull.eu>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/riscv/crypto/Kconfig             |  12 ++
 arch/riscv/crypto/Makefile            |   3 +
 arch/riscv/crypto/aes-riscv32-glue.c  |  75 ++++++++++++
 arch/riscv/crypto/aes-riscv32-zkned.S | 119 ++++++++++++++++++++
 4 files changed, 209 insertions(+)

diff --git a/arch/riscv/crypto/Kconfig b/arch/riscv/crypto/Kconfig
index 7542330916079447..fa3917859c2bbbc3 100644
--- a/arch/riscv/crypto/Kconfig
+++ b/arch/riscv/crypto/Kconfig
@@ -2,6 +2,18 @@
 
 menu "Accelerated Cryptographic Algorithms for CPU (riscv)"
 
+config CRYPTO_AES_RISCV32
+	tristate "Scalar AES using the Zkn extension"
+	depends on !64BIT
+	select CRYPTO_LIB_AES
+	help
+	  Implement scalar AES using the RV32 instructions specified by the Zkn
+	  extension. These instructions replace the table lookups used by the
+	  generic implementation, making this implementation time invariant
+	  (provided that the instructions themselves are). It also reduces the
+	  D-cache footprint substantially, as the AES lookup tables are quite
+	  large.
+
 config CRYPTO_AES_RISCV
 	tristate "Ciphers: AES (RISCV)"
 	depends on 64BIT && RISCV_ISA_V
diff --git a/arch/riscv/crypto/Makefile b/arch/riscv/crypto/Makefile
index f7faba6c12c9d863..d073b18d2a0bbba3 100644
--- a/arch/riscv/crypto/Makefile
+++ b/arch/riscv/crypto/Makefile
@@ -3,6 +3,9 @@
 # linux/arch/riscv/crypto/Makefile
 #
 
+obj-$(CONFIG_CRYPTO_AES_RISCV32) += aes-riscv32.o
+aes-riscv32-y := aes-riscv32-glue.o aes-riscv32-zkned.o
+
 obj-$(CONFIG_CRYPTO_AES_RISCV) += aes-riscv.o
 aes-riscv-y := aes-riscv-glue.o aes-riscv64-zvkned.o
 
diff --git a/arch/riscv/crypto/aes-riscv32-glue.c b/arch/riscv/crypto/aes-riscv32-glue.c
new file mode 100644
index 0000000000000000..2055213304e21829
--- /dev/null
+++ b/arch/riscv/crypto/aes-riscv32-glue.c
@@ -0,0 +1,75 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Scalar AES core transform
+ *
+ * Copyright (C) 2023 Google, LLC.
+ * Author: Ard Biesheuvel <ardb@kernel.org>
+ */
+
+#include <crypto/aes.h>
+#include <crypto/algapi.h>
+#include <linux/module.h>
+
+asmlinkage void __aes_riscv32_encrypt(u32 *rk, u8 *out, const u8 *in, int rounds);
+asmlinkage void __aes_riscv32_decrypt(u32 *rk, u8 *out, const u8 *in, int rounds);
+
+static int aes_riscv32_set_key(struct crypto_tfm *tfm, const u8 *in_key,
+			       unsigned int key_len)
+{
+	struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	return aes_expandkey(ctx, in_key, key_len);
+}
+
+static void aes_riscv32_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+{
+	struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
+	int rounds = 6 + ctx->key_length / 4;
+
+	__aes_riscv32_encrypt(ctx->key_enc, out, in, rounds);
+}
+
+static void aes_riscv32_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+{
+	struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
+	int rounds = 6 + ctx->key_length / 4;
+
+	__aes_riscv32_decrypt(ctx->key_dec, out, in, rounds);
+}
+
+static struct crypto_alg aes_alg = {
+	.cra_name			= "aes",
+	.cra_driver_name		= "aes-riscv32",
+	.cra_priority			= 200,
+	.cra_flags			= CRYPTO_ALG_TYPE_CIPHER,
+	.cra_blocksize			= AES_BLOCK_SIZE,
+	.cra_ctxsize			= sizeof(struct crypto_aes_ctx),
+	.cra_module			= THIS_MODULE,
+
+	.cra_cipher.cia_min_keysize	= AES_MIN_KEY_SIZE,
+	.cra_cipher.cia_max_keysize	= AES_MAX_KEY_SIZE,
+	.cra_cipher.cia_setkey		= aes_riscv32_set_key,
+	.cra_cipher.cia_encrypt		= aes_riscv32_encrypt,
+	.cra_cipher.cia_decrypt		= aes_riscv32_decrypt
+};
+
+static int __init riscv32_aes_init(void)
+{
+	if (!riscv_isa_extension_available(NULL, ZKNE) ||
+	    !riscv_isa_extension_available(NULL, ZKND))
+		return -ENODEV;
+	return crypto_register_alg(&aes_alg);
+}
+
+static void __exit riscv32_aes_fini(void)
+{
+	crypto_unregister_alg(&aes_alg);
+}
+
+module_init(riscv32_aes_init);
+module_exit(riscv32_aes_fini);
+
+MODULE_DESCRIPTION("Scalar AES cipher for riscv32");
+MODULE_AUTHOR("Ard Biesheuvel <ardb@kernel.org>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_CRYPTO("aes");
diff --git a/arch/riscv/crypto/aes-riscv32-zkned.S b/arch/riscv/crypto/aes-riscv32-zkned.S
new file mode 100644
index 0000000000000000..89276bdc57b0045f
--- /dev/null
+++ b/arch/riscv/crypto/aes-riscv32-zkned.S
@@ -0,0 +1,119 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Scalar AES core transform
+ *
+ * Copyright (C) 2023 Google, LLC.
+ * Author: Ard Biesheuvel <ardb@kernel.org>
+ */
+
+#include <linux/linkage.h>
+
+	.irpc	r, 23456789
+	.set	.Ls\r, \r + 16
+	.endr
+
+	// Zkn RV32 opcodes
+	.macro	aes32esmi, rd, rs1, rs2, bs
+	.long	0x26000033 | (\bs << 30) | (.L\rd << 7) | (.L\rs1 << 15) | (.L\rs2 << 20)
+	.endm
+
+	.macro	aes32esi, rd, rs1, rs2, bs
+	.long	0x22000033 | (\bs << 30) | (.L\rd << 7) | (.L\rs1 << 15) | (.L\rs2 << 20)
+	.endm
+
+	.macro	aes32dsmi, rd, rs1, rs2, bs
+	.long	0x2e000033 | (\bs << 30) | (.L\rd << 7) | (.L\rs1 << 15) | (.L\rs2 << 20)
+	.endm
+
+	.macro	aes32dsi, rd, rs1, rs2, bs
+	.long	0x2a000033 | (\bs << 30) | (.L\rd << 7) | (.L\rs1 << 15) | (.L\rs2 << 20)
+	.endm
+
+	// AES quarter round
+	.macro		qround, op, o0, o1, o2, o3, i0, i1, i2, i3, bs
+	aes32\op	\o0, \o0, \i0, \bs
+	aes32\op	\o1, \o1, \i1, \bs
+	aes32\op	\o2, \o2, \i2, \bs
+	aes32\op	\o3, \o3, \i3, \bs
+	.endm
+
+	// One AES round
+	.macro		round, ed, op, o0, o1, o2, o3, i0, i1, i2, i3
+	.ifc		\ed,e
+	qround		e\op, \o0, \o1, \o2, \o3, \i0, \i1, \i2, \i3, 0
+	qround		e\op, \o0, \o1, \o2, \o3, \i1, \i2, \i3, \i0, 1
+	qround		e\op, \o0, \o1, \o2, \o3, \i2, \i3, \i0, \i1, 2
+	qround		e\op, \o0, \o1, \o2, \o3, \i3, \i0, \i1, \i2, 3
+	.else
+	qround		d\op, \o0, \o1, \o2, \o3, \i0, \i1, \i2, \i3, 0
+	qround		d\op, \o0, \o1, \o2, \o3, \i3, \i0, \i1, \i2, 1
+	qround		d\op, \o0, \o1, \o2, \o3, \i2, \i3, \i0, \i1, 2
+	qround		d\op, \o0, \o1, \o2, \o3, \i1, \i2, \i3, \i0, 3
+	.endif
+	.endm
+
+	// Load next round key and advance round key pointer
+	.macro		next_rk, rk, out0, out1, out2, out3
+	lw		\out0, 0(\rk)
+	lw		\out1, 4(\rk)
+	lw		\out2, 8(\rk)
+	lw		\out3, 12(\rk)
+	add		\rk, \rk, 16
+	.endm
+
+	.macro		crypt, ed
+	add		sp, sp, -32
+	sw		s2, 0(sp)
+	sw		s3, 4(sp)
+	sw		s4, 8(sp)
+	sw		s5, 12(sp)
+	sw		s6, 16(sp)
+	sw		s7, 20(sp)
+	sw		s8, 24(sp)
+	sw		s9, 28(sp)
+
+	lw		s2, 0(a2)
+	lw		s3, 4(a2)
+	lw		s4, 8(a2)
+	lw		s5, 12(a2)
+
+	next_rk		a0, s6, s7, s8, s9
+
+	xor		s2, s2, s6
+	xor		s3, s3, s7
+	xor		s4, s4, s8
+	xor		s5, s5, s9
+
+0:	add		a3, a3, -2
+	next_rk		a0, s6, s7, s8, s9
+	round		\ed, smi, s6, s7, s8, s9, s2, s3, s4, s5
+	next_rk		a0, s2, s3, s4, s5
+	beqz		a3, 1f
+	round		\ed, smi, s2, s3, s4, s5, s6, s7, s8, s9
+	j		0b
+1:	round		\ed, si, s2, s3, s4, s5, s6, s7, s8, s9
+
+	sw		s2, 0(a1)
+	sw		s3, 4(a1)
+	sw		s4, 8(a1)
+	sw		s5, 12(a1)
+
+	lw		s2, 0(sp)
+	lw		s3, 4(sp)
+	lw		s4, 8(sp)
+	lw		s5, 12(sp)
+	lw		s6, 16(sp)
+	lw		s7, 20(sp)
+	lw		s8, 24(sp)
+	lw		s9, 28(sp)
+	add		sp, sp, 32
+	ret
+	.endm
+
+SYM_FUNC_START(__aes_riscv32_encrypt)
+	crypt	e
+SYM_FUNC_END(__aes_riscv32_encrypt)
+
+SYM_FUNC_START(__aes_riscv32_decrypt)
+	crypt	d
+SYM_FUNC_END(__aes_riscv32_decrypt)
-- 
2.39.2

