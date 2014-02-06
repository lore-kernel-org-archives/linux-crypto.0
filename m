From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 3/3] arm64: add Crypto Extensions based core AES cipher
Date: Thu,  6 Feb 2014 13:25:04 +0100
Message-ID: <1391689504-28160-4-git-send-email-ard.biesheuvel@linaro.org>
References: <1391689504-28160-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
	jussi.kivilinna@iki.fi, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:42326 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756204AbaBFMZI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Feb 2014 07:25:08 -0500
Received: by mail-we0-f171.google.com with SMTP id u56so1221429wes.2
        for <linux-crypto@vger.kernel.org>; Thu, 06 Feb 2014 04:25:06 -0800 (PST)
In-Reply-To: <1391689504-28160-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/Makefile               |   1 +
 arch/arm64/crypto/Makefile        |  13 ++
 arch/arm64/crypto/aes-ce-cipher.c | 257 ++++++++++++++++++++++++++++++++++++++
 crypto/Kconfig                    |   6 +
 4 files changed, 277 insertions(+)
 create mode 100644 arch/arm64/crypto/Makefile
 create mode 100644 arch/arm64/crypto/aes-ce-cipher.c

diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index 2fceb71ac3b7..8185a913c5ed 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -45,6 +45,7 @@ export	TEXT_OFFSET GZFLAGS
 core-y		+= arch/arm64/kernel/ arch/arm64/mm/
 core-$(CONFIG_KVM) += arch/arm64/kvm/
 core-$(CONFIG_XEN) += arch/arm64/xen/
+core-$(CONFIG_CRYPTO) += arch/arm64/crypto/
 libs-y		:= arch/arm64/lib/ $(libs-y)
 libs-y		+= $(LIBGCC)
 
diff --git a/arch/arm64/crypto/Makefile b/arch/arm64/crypto/Makefile
new file mode 100644
index 000000000000..ac58945c50b3
--- /dev/null
+++ b/arch/arm64/crypto/Makefile
@@ -0,0 +1,13 @@
+#
+# linux/arch/arm64/crypto/Makefile
+#
+# Copyright (C) 2013 Linaro Ltd <ard.biesheuvel@linaro.org>
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License version 2 as
+# published by the Free Software Foundation.
+#
+
+obj-$(CONFIG_CRYPTO_AES_ARM64_CE) += aes-ce-cipher.o
+
+CFLAGS_aes-ce-cipher.o += -march=armv8-a+crypto
diff --git a/arch/arm64/crypto/aes-ce-cipher.c b/arch/arm64/crypto/aes-ce-cipher.c
new file mode 100644
index 000000000000..034f90077eed
--- /dev/null
+++ b/arch/arm64/crypto/aes-ce-cipher.c
@@ -0,0 +1,257 @@
+/*
+ * linux/arch/arm64/crypto/aes-ce-cipher.c
+ *
+ * Copyright (C) 2013 Linaro Ltd <ard.biesheuvel@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <asm/hwcap.h>
+#include <asm/neon.h>
+#include <crypto/aes.h>
+#include <linux/crypto.h>
+#include <linux/module.h>
+
+MODULE_DESCRIPTION("Synchronous AES cipher using ARMv8 Crypto Extensions");
+MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
+MODULE_LICENSE("GPL");
+
+static int num_rounds(struct crypto_aes_ctx *ctx)
+{
+	/*
+	 * # of rounds specified by AES:
+	 * 128 bit key		10 rounds
+	 * 192 bit key		12 rounds
+	 * 256 bit key		14 rounds
+	 * => n byte key	=> 6 + (n/4) rounds
+	 */
+	return 6 + ctx->key_length / 4;
+}
+
+static void aes_cipher_encrypt(struct crypto_tfm *tfm, u8 dst[], u8 const src[])
+{
+	struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	kernel_neon_begin_partial(4);
+
+	__asm__("	ld1	{v0.16b}, [%[in]]		;"
+		"	cmp	%[rounds], #10			;"
+		"	bmi	0f				;"
+		"	bne	3f				;"
+		"	ld1	{v3.2d}, [%[key]], #16		;"
+		"	b	2f				;"
+		"0:	ld1	{v2.2d-v3.2d}, [%[key]], #32	;"
+		"1:	aese	v0.16b, v2.16b			;"
+		"	aesmc	v0.16b, v0.16b			;"
+		"2:	aese	v0.16b, v3.16b			;"
+		"	aesmc	v0.16b, v0.16b			;"
+		"3:	ld1	{v1.2d-v3.2d}, [%[key]], #48	;"
+		"	subs	%[rounds], %[rounds], #3	;"
+		"	aese	v0.16b, v1.16b			;"
+		"	aesmc	v0.16b, v0.16b			;"
+		"	bpl	1b				;"
+		"	aese	v0.16b, v2.16b			;"
+		"	eor	v0.16b, v0.16b, v3.16b		;"
+		"	st1	{v0.16b}, [%[out]]		;"
+	: :
+		[out]		"r"(dst),
+		[in]		"r"(src),
+		[rounds]	"r"(num_rounds(ctx) - 2),
+		[key]		"r"(ctx->key_enc)
+	:	"cc", "memory");
+
+	kernel_neon_end();
+}
+
+static void aes_cipher_decrypt(struct crypto_tfm *tfm, u8 dst[], u8 const src[])
+{
+	struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	kernel_neon_begin_partial(4);
+
+	__asm__("	ld1	{v0.16b}, [%[in]]		;"
+		"	cmp	%[rounds], #10			;"
+		"	bmi	0f				;"
+		"	bne	3f				;"
+		"	ld1	{v3.2d}, [%[key]], #16		;"
+		"	b	2f				;"
+		"0:	ld1	{v2.2d-v3.2d}, [%[key]], #32	;"
+		"1:	aesd	v0.16b, v2.16b			;"
+		"	aesimc	v0.16b, v0.16b			;"
+		"2:	aesd	v0.16b, v3.16b			;"
+		"	aesimc	v0.16b, v0.16b			;"
+		"3:	ld1	{v1.2d-v3.2d}, [%[key]], #48	;"
+		"	subs	%[rounds], %[rounds], #3	;"
+		"	aesd	v0.16b, v1.16b			;"
+		"	aesimc	v0.16b, v0.16b			;"
+		"	bpl	1b				;"
+		"	aesd	v0.16b, v2.16b			;"
+		"	eor	v0.16b, v0.16b, v3.16b		;"
+		"	st1	{v0.16b}, [%[out]]		;"
+	: :
+		[out]		"r"(dst),
+		[in]		"r"(src),
+		[rounds]	"r"(num_rounds(ctx) - 2),
+		[key]		"r"(ctx->key_dec)
+	:	"cc", "memory");
+
+	kernel_neon_end();
+}
+
+
+static void aes_cipher_enc_interleave(struct crypto_tfm *tfm, u8 dst[],
+				      u8 const src[])
+{
+	struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	kernel_neon_begin_partial(7);
+
+	__asm__("	ld1	{v0.16b-v3.16b}, [%[in]]	;"
+		"	cmp	%[rounds], #10			;"
+		"	bmi	0f				;"
+		"	bne	3f				;"
+		"	ld1	{v6.2d}, [%[key]], #16		;"
+		"	b	2f				;"
+		"0:	ld1	{v5.2d-v6.2d}, [%[key]], #32	;"
+		"1:	aese	v0.16b, v5.16b			;"
+		"	aesmc	v0.16b, v0.16b			;"
+		"	aese	v1.16b, v5.16b			;"
+		"	aesmc	v1.16b, v1.16b			;"
+		"	aese	v2.16b, v5.16b			;"
+		"	aesmc	v2.16b, v2.16b			;"
+		"	aese	v3.16b, v5.16b			;"
+		"	aesmc	v3.16b, v3.16b			;"
+		"2:	aese	v0.16b, v6.16b			;"
+		"	aesmc	v0.16b, v0.16b			;"
+		"	aese	v1.16b, v6.16b			;"
+		"	aesmc	v1.16b, v1.16b			;"
+		"	aese	v2.16b, v6.16b			;"
+		"	aesmc	v2.16b, v2.16b			;"
+		"	aese	v3.16b, v6.16b			;"
+		"	aesmc	v3.16b, v3.16b			;"
+		"3:	ld1	{v4.2d-v6.2d}, [%[key]], #48	;"
+		"	subs	%[rounds], %[rounds], #3	;"
+		"	aese	v0.16b, v4.16b			;"
+		"	aesmc	v0.16b, v0.16b			;"
+		"	aese	v1.16b, v4.16b			;"
+		"	aesmc	v1.16b, v1.16b			;"
+		"	aese	v2.16b, v4.16b			;"
+		"	aesmc	v2.16b, v2.16b			;"
+		"	aese	v3.16b, v4.16b			;"
+		"	aesmc	v3.16b, v3.16b			;"
+		"	bpl	1b				;"
+		"	aese	v0.16b, v5.16b			;"
+		"	aese	v1.16b, v5.16b			;"
+		"	aese	v2.16b, v5.16b			;"
+		"	aese	v3.16b, v5.16b			;"
+		"	eor	v0.16b, v0.16b, v6.16b		;"
+		"	eor	v1.16b, v1.16b, v6.16b		;"
+		"	eor	v2.16b, v2.16b, v6.16b		;"
+		"	eor	v3.16b, v3.16b, v6.16b		;"
+		"	st1	{v0.16b-v3.16b}, [%[out]]	;"
+	: :
+		[out]		"r"(dst),
+		[in]		"r"(src),
+		[rounds]	"r"(num_rounds(ctx) - 2),
+		[key]		"r"(ctx->key_enc)
+	:	"cc", "memory");
+
+	kernel_neon_end();
+}
+
+static void aes_cipher_dec_interleave(struct crypto_tfm *tfm, u8 dst[],
+				      u8 const src[])
+{
+	struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	kernel_neon_begin_partial(7);
+
+	__asm__("	ld1	{v0.16b-v3.16b}, [%[in]]	;"
+		"	cmp	%[rounds], #10			;"
+		"	bmi	0f				;"
+		"	bne	3f				;"
+		"	ld1	{v6.2d}, [%[key]], #16		;"
+		"	b	2f				;"
+		"0:	ld1	{v5.2d-v6.2d}, [%[key]], #32	;"
+		"1:	aesd	v0.16b, v5.16b			;"
+		"	aesimc	v0.16b, v0.16b			;"
+		"	aesd	v1.16b, v5.16b			;"
+		"	aesimc	v1.16b, v1.16b			;"
+		"	aesd	v2.16b, v5.16b			;"
+		"	aesimc	v2.16b, v2.16b			;"
+		"	aesd	v3.16b, v5.16b			;"
+		"	aesimc	v3.16b, v3.16b			;"
+		"2:	aesd	v0.16b, v6.16b			;"
+		"	aesimc	v0.16b, v0.16b			;"
+		"	aesd	v1.16b, v6.16b			;"
+		"	aesimc	v1.16b, v1.16b			;"
+		"	aesd	v2.16b, v6.16b			;"
+		"	aesimc	v2.16b, v2.16b			;"
+		"	aesd	v3.16b, v6.16b			;"
+		"	aesimc	v3.16b, v3.16b			;"
+		"3:	ld1	{v4.2d-v6.2d}, [%[key]], #48	;"
+		"	subs	%[rounds], %[rounds], #3	;"
+		"	aesd	v0.16b, v4.16b			;"
+		"	aesimc	v0.16b, v0.16b			;"
+		"	aesd	v1.16b, v4.16b			;"
+		"	aesimc	v1.16b, v1.16b			;"
+		"	aesd	v2.16b, v4.16b			;"
+		"	aesimc	v2.16b, v2.16b			;"
+		"	aesd	v3.16b, v4.16b			;"
+		"	aesimc	v3.16b, v3.16b			;"
+		"	bpl	1b				;"
+		"	aesd	v0.16b, v5.16b			;"
+		"	aesd	v1.16b, v5.16b			;"
+		"	aesd	v2.16b, v5.16b			;"
+		"	aesd	v3.16b, v5.16b			;"
+		"	eor	v0.16b, v0.16b, v6.16b		;"
+		"	eor	v1.16b, v1.16b, v6.16b		;"
+		"	eor	v2.16b, v2.16b, v6.16b		;"
+		"	eor	v3.16b, v3.16b, v6.16b		;"
+		"	st1	{v0.16b-v3.16b}, [%[out]]	;"
+	: :
+		[out]		"r"(dst),
+		[in]		"r"(src),
+		[rounds]	"r"(num_rounds(ctx) - 2),
+		[key]		"r"(ctx->key_dec)
+	:	"cc", "memory");
+
+	kernel_neon_end();
+}
+
+static struct crypto_alg aes_alg = {
+	.cra_name		= "aes",
+	.cra_driver_name	= "aes-ce",
+	.cra_priority		= 300,
+	.cra_flags		= CRYPTO_ALG_TYPE_CIPHER,
+	.cra_blocksize		= AES_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct crypto_aes_ctx),
+	.cra_module		= THIS_MODULE,
+	.cra_cipher = {
+		.cia_min_keysize	= AES_MIN_KEY_SIZE,
+		.cia_max_keysize	= AES_MAX_KEY_SIZE,
+		.cia_setkey		= crypto_aes_set_key,
+		.cia_encrypt		= aes_cipher_encrypt,
+		.cia_decrypt		= aes_cipher_decrypt,
+		.cia_interleave		= 4,
+		.cia_enc_interleave	= aes_cipher_enc_interleave,
+		.cia_dec_interleave	= aes_cipher_dec_interleave,
+	}
+};
+
+static int __init aes_mod_init(void)
+{
+	if (!(elf_hwcap & HWCAP_AES))
+		return -ENODEV;
+	return crypto_register_alg(&aes_alg);
+}
+
+static void __exit aes_mod_exit(void)
+{
+	crypto_unregister_alg(&aes_alg);
+}
+
+module_init(aes_mod_init);
+module_exit(aes_mod_exit);
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 7bcb70d216e1..f1d98bc346b6 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -791,6 +791,12 @@ config CRYPTO_AES_ARM_BS
 	  This implementation does not rely on any lookup tables so it is
 	  believed to be invulnerable to cache timing attacks.
 
+config CRYPTO_AES_ARM64_CE
+	tristate "Synchronous AES cipher using ARMv8 Crypto Extensions"
+	depends on ARM64 && KERNEL_MODE_NEON
+	select CRYPTO_ALGAPI
+	select CRYPTO_AES
+
 config CRYPTO_ANUBIS
 	tristate "Anubis cipher algorithm"
 	select CRYPTO_ALGAPI
-- 
1.8.3.2
