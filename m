From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] crypto: arm64/aes - add scalar implementation
Date: Wed,  4 Jan 2017 16:19:15 +0000
Message-ID: <1483546755-13429-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:33218 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754418AbdADQ2b (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Jan 2017 11:28:31 -0500
Received: by mail-wm0-f53.google.com with SMTP id v3so4360481wme.0
        for <linux-crypto@vger.kernel.org>; Wed, 04 Jan 2017 08:28:30 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This adds a scalar implementation of AES, based on the precomputed tables
that are exposed by the generic AES code. Since rotates are cheap on arm64,
this implementation only uses the 4 core tables (of 1 KB each), and avoids
the prerotated ones, reducing the D-cache footprint by 75%.

On Cortex-A57, this code manages 13.0 cycles per byte, which is ~34% faster
than the generic C code. (Note that this is still >13x slower than the code
that uses the optional ARMv8 Crypto Extensions, which manages <1 cycles per
byte.)

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---

Raw performance data after the patch, which was generated on a 2 GHz
Cortex-A57 (AMD Seattle B1).

 arch/arm64/crypto/Kconfig           |   4 +
 arch/arm64/crypto/Makefile          |   3 +
 arch/arm64/crypto/aes-cipher-core.S | 126 ++++++++++++++++++++
 arch/arm64/crypto/aes-cipher-glue.c |  69 +++++++++++
 4 files changed, 202 insertions(+)

diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index 0bf0f531f539..0826f8e599a6 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -41,6 +41,10 @@ config CRYPTO_CRC32_ARM64_CE
 	depends on KERNEL_MODE_NEON && CRC32
 	select CRYPTO_HASH
 
+config CRYPTO_AES_ARM64
+	tristate "AES core cipher using scalar instructions"
+	select CRYPTO_AES
+
 config CRYPTO_AES_ARM64_CE
 	tristate "AES core cipher using ARMv8 Crypto Extensions"
 	depends on ARM64 && KERNEL_MODE_NEON
diff --git a/arch/arm64/crypto/Makefile b/arch/arm64/crypto/Makefile
index 9d2826c5fccf..a893507629eb 100644
--- a/arch/arm64/crypto/Makefile
+++ b/arch/arm64/crypto/Makefile
@@ -44,6 +44,9 @@ sha512-arm64-y := sha512-glue.o sha512-core.o
 obj-$(CONFIG_CRYPTO_CHACHA20_NEON) += chacha20-neon.o
 chacha20-neon-y := chacha20-neon-core.o chacha20-neon-glue.o
 
+obj-$(CONFIG_CRYPTO_AES_ARM64) += aes-arm64.o
+aes-arm64-y := aes-cipher-core.o aes-cipher-glue.o
+
 AFLAGS_aes-ce.o		:= -DINTERLEAVE=4
 AFLAGS_aes-neon.o	:= -DINTERLEAVE=4
 
diff --git a/arch/arm64/crypto/aes-cipher-core.S b/arch/arm64/crypto/aes-cipher-core.S
new file mode 100644
index 000000000000..22d1bc46feba
--- /dev/null
+++ b/arch/arm64/crypto/aes-cipher-core.S
@@ -0,0 +1,126 @@
+/*
+ * Scalar AES core transform
+ *
+ * Copyright (C) 2017 Linaro Ltd <ard.biesheuvel@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+
+	.text
+	.align		5
+
+	rk		.req	x0
+	out		.req	x1
+	in		.req	x2
+	rounds		.req	x3
+	tt		.req	x4
+	lt		.req	x2
+
+	.macro		__hround, out0, out1, in0, in1, in2, in3, t0, t1, enc
+	ldp		\out0, \out1, [rk], #8
+
+	ubfx		w13, \in0, #0, #8
+	ubfx		w14, \in1, #8, #8
+	ldr		w13, [tt, w13, uxtw #2]
+	ldr		w14, [tt, w14, uxtw #2]
+
+	ubfx		w15, \in2, #16, #8
+	ubfx		w16, \in3, #24, #8
+	ldr		w15, [tt, w15, uxtw #2]
+	ldr		w16, [tt, w16, uxtw #2]
+
+	.if		\enc
+	ubfx		w17, \in1, #0, #8
+	ubfx		w18, \in2, #8, #8
+	.else
+	ubfx		w17, \in3, #0, #8
+	ubfx		w18, \in0, #8, #8
+	.endif
+	ldr		w17, [tt, w17, uxtw #2]
+	ldr		w18, [tt, w18, uxtw #2]
+
+	.if		\enc
+	ubfx		\t0, \in3, #16, #8
+	ubfx		\t1, \in0, #24, #8
+	.else
+	ubfx		\t0, \in1, #16, #8
+	ubfx		\t1, \in2, #24, #8
+	.endif
+	ldr		\t0, [tt, \t0, uxtw #2]
+	ldr		\t1, [tt, \t1, uxtw #2]
+
+	eor		\out0, \out0, w13
+	eor		\out1, \out1, w17
+	eor		\out0, \out0, w14, ror #24
+	eor		\out1, \out1, w18, ror #24
+	eor		\out0, \out0, w15, ror #16
+	eor		\out1, \out1, \t0, ror #16
+	eor		\out0, \out0, w16, ror #8
+	eor		\out1, \out1, \t1, ror #8
+	.endm
+
+	.macro		fround, out0, out1, out2, out3, in0, in1, in2, in3
+	__hround	\out0, \out1, \in0, \in1, \in2, \in3, \out2, \out3, 1
+	__hround	\out2, \out3, \in2, \in3, \in0, \in1, \in1, \in2, 1
+	.endm
+
+	.macro		iround, out0, out1, out2, out3, in0, in1, in2, in3
+	__hround	\out0, \out1, \in0, \in3, \in2, \in1, \out2, \out3, 0
+	__hround	\out2, \out3, \in2, \in1, \in0, \in3, \in1, \in0, 0
+	.endm
+
+	.macro		do_crypt, round, ttab, ltab
+	ldp		w5, w6, [in]
+	ldp		w7, w8, [in, #8]
+	ldp		w9, w10, [rk], #16
+	ldp		w11, w12, [rk, #-8]
+
+CPU_BE(	rev		w5, w5		)
+CPU_BE(	rev		w6, w6		)
+CPU_BE(	rev		w7, w7		)
+CPU_BE(	rev		w8, w8		)
+
+	eor		w5, w5, w9
+	eor		w6, w6, w10
+	eor		w7, w7, w11
+	eor		w8, w8, w12
+
+	ldr		tt, =\ttab
+	ldr		lt, =\ltab
+
+	tbnz		rounds, #1, 1f
+
+0:	\round		w9, w10, w11, w12, w5, w6, w7, w8
+	\round		w5, w6, w7, w8, w9, w10, w11, w12
+
+1:	subs		rounds, rounds, #4
+	\round		w9, w10, w11, w12, w5, w6, w7, w8
+	csel		tt, tt, lt, hi
+	\round		w5, w6, w7, w8, w9, w10, w11, w12
+	b.hi		0b
+
+CPU_BE(	rev		w5, w5		)
+CPU_BE(	rev		w6, w6		)
+CPU_BE(	rev		w7, w7		)
+CPU_BE(	rev		w8, w8		)
+
+	stp		w5, w6, [out]
+	stp		w7, w8, [out, #8]
+	ret
+
+	.align		4
+	.ltorg
+	.endm
+
+ENTRY(__aes_arm64_encrypt)
+	do_crypt	fround, crypto_ft_tab, crypto_fl_tab
+ENDPROC(__aes_arm64_encrypt)
+
+ENTRY(__aes_arm64_decrypt)
+	do_crypt	iround, crypto_it_tab, crypto_il_tab
+ENDPROC(__aes_arm64_decrypt)
diff --git a/arch/arm64/crypto/aes-cipher-glue.c b/arch/arm64/crypto/aes-cipher-glue.c
new file mode 100644
index 000000000000..7288e7cbebff
--- /dev/null
+++ b/arch/arm64/crypto/aes-cipher-glue.c
@@ -0,0 +1,69 @@
+/*
+ * Scalar AES core transform
+ *
+ * Copyright (C) 2017 Linaro Ltd <ard.biesheuvel@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <crypto/aes.h>
+#include <linux/crypto.h>
+#include <linux/module.h>
+
+asmlinkage void __aes_arm64_encrypt(u32 *rk, u8 *out, const u8 *in, int rounds);
+EXPORT_SYMBOL(__aes_arm64_encrypt);
+
+asmlinkage void __aes_arm64_decrypt(u32 *rk, u8 *out, const u8 *in, int rounds);
+EXPORT_SYMBOL(__aes_arm64_decrypt);
+
+static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+{
+	struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
+	int rounds = 6 + ctx->key_length / 4;
+
+	__aes_arm64_encrypt(ctx->key_enc, out, in, rounds);
+}
+
+static void aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+{
+	struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
+	int rounds = 6 + ctx->key_length / 4;
+
+	__aes_arm64_decrypt(ctx->key_dec, out, in, rounds);
+}
+
+static struct crypto_alg aes_alg = {
+	.cra_name			= "aes",
+	.cra_driver_name		= "aes-arm64",
+	.cra_priority			= 200,
+	.cra_flags			= CRYPTO_ALG_TYPE_CIPHER,
+	.cra_blocksize			= AES_BLOCK_SIZE,
+	.cra_ctxsize			= sizeof(struct crypto_aes_ctx),
+	.cra_module			= THIS_MODULE,
+
+	.cra_cipher.cia_min_keysize	= AES_MIN_KEY_SIZE,
+	.cra_cipher.cia_max_keysize	= AES_MAX_KEY_SIZE,
+	.cra_cipher.cia_setkey		= crypto_aes_set_key,
+	.cra_cipher.cia_encrypt		= aes_encrypt,
+	.cra_cipher.cia_decrypt		= aes_decrypt
+};
+
+static int __init aes_init(void)
+{
+	return crypto_register_alg(&aes_alg);
+}
+
+static void __exit aes_fini(void)
+{
+	crypto_unregister_alg(&aes_alg);
+}
+
+module_init(aes_init);
+module_exit(aes_fini);
+
+MODULE_DESCRIPTION("Scalar AES cipher for arm64");
+MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS_CRYPTO("aes");
-- 
2.7.4

testing speed of async ecb(aes) (ecb(aes-generic)) encryption
test 0 (128 bit key, 16 byte blocks): 4594689 operations in 1 seconds (73515024 bytes)
test 1 (128 bit key, 64 byte blocks): 1585137 operations in 1 seconds (101448768 bytes)
test 2 (128 bit key, 256 byte blocks): 435173 operations in 1 seconds (111404288 bytes)
test 3 (128 bit key, 1024 byte blocks): 111505 operations in 1 seconds (114181120 bytes)
test 4 (128 bit key, 8192 byte blocks): 14093 operations in 1 seconds (115449856 bytes)
test 5 (192 bit key, 16 byte blocks): 4078345 operations in 1 seconds (65253520 bytes)
test 6 (192 bit key, 64 byte blocks): 1349425 operations in 1 seconds (86363200 bytes)
test 7 (192 bit key, 256 byte blocks): 365631 operations in 1 seconds (93601536 bytes)
test 8 (192 bit key, 1024 byte blocks): 93362 operations in 1 seconds (95602688 bytes)
test 9 (192 bit key, 8192 byte blocks): 11729 operations in 1 seconds (96083968 bytes)
test 10 (256 bit key, 16 byte blocks): 3692945 operations in 1 seconds (59087120 bytes)
test 11 (256 bit key, 64 byte blocks): 1182522 operations in 1 seconds (75681408 bytes)
test 12 (256 bit key, 256 byte blocks): 317285 operations in 1 seconds (81224960 bytes)
test 13 (256 bit key, 1024 byte blocks): 80459 operations in 1 seconds (82390016 bytes)
test 14 (256 bit key, 8192 byte blocks): 10138 operations in 1 seconds (83050496 bytes)

testing speed of async ecb(aes) (ecb(aes-arm64)) encryption
test 0 (128 bit key, 16 byte blocks): 5455304 operations in 1 seconds (87284864 bytes)
test 1 (128 bit key, 64 byte blocks): 2000321 operations in 1 seconds (128020544 bytes)
test 2 (128 bit key, 256 byte blocks): 574174 operations in 1 seconds (146988544 bytes)
test 3 (128 bit key, 1024 byte blocks): 148497 operations in 1 seconds (152060928 bytes)
test 4 (128 bit key, 8192 byte blocks): 18836 operations in 1 seconds (154304512 bytes)
test 5 (192 bit key, 16 byte blocks): 4962478 operations in 1 seconds (79399648 bytes)
test 6 (192 bit key, 64 byte blocks): 1740157 operations in 1 seconds (111370048 bytes)
test 7 (192 bit key, 256 byte blocks): 490443 operations in 1 seconds (125553408 bytes)
test 8 (192 bit key, 1024 byte blocks): 126165 operations in 1 seconds (129192960 bytes)
test 9 (192 bit key, 8192 byte blocks): 15897 operations in 1 seconds (130228224 bytes)
test 10 (256 bit key, 16 byte blocks): 4527784 operations in 1 seconds (72444544 bytes)
test 11 (256 bit key, 64 byte blocks): 1527235 operations in 1 seconds (97743040 bytes)
test 12 (256 bit key, 256 byte blocks): 425302 operations in 1 seconds (108877312 bytes)
test 13 (256 bit key, 1024 byte blocks): 109013 operations in 1 seconds (111629312 bytes)
test 14 (256 bit key, 8192 byte blocks): 13778 operations in 1 seconds (112869376 bytes)
