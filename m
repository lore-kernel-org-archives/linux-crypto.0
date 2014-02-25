From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH v2 3/3] arm64: add Crypto Extensions based core AES cipher and 4-way ECB
Date: Tue, 25 Feb 2014 08:34:20 +0100
Message-ID: <1393313660-5258-4-git-send-email-ard.biesheuvel@linaro.org>
References: <1393313660-5258-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:44880 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbaBYHea (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Feb 2014 02:34:30 -0500
Received: by mail-wi0-f169.google.com with SMTP id e4so3933517wiv.4
        for <linux-crypto@vger.kernel.org>; Mon, 24 Feb 2014 23:34:28 -0800 (PST)
In-Reply-To: <1393313660-5258-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/Makefile               |   1 +
 arch/arm64/crypto/Makefile        |  13 ++
 arch/arm64/crypto/aes-ce-cipher.c | 382 ++++++++++++++++++++++++++++++++++++++
 crypto/Kconfig                    |   6 +
 4 files changed, 402 insertions(+)
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
index 000000000000..e2015aae4e86
--- /dev/null
+++ b/arch/arm64/crypto/aes-ce-cipher.c
@@ -0,0 +1,382 @@
+/*
+ * linux/arch/arm64/crypto/aes-ce-cipher.c
+ *
+ * Copyright (C) 2013 - 2014 Linaro Ltd <ard.biesheuvel@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <asm/hwcap.h>
+#include <asm/neon.h>
+#include <crypto/aes.h>
+#include <crypto/algapi.h>
+#include <linux/crypto.h>
+#include <linux/module.h>
+
+MODULE_DESCRIPTION("Synchronous AES cipher using ARMv8 Crypto Extensions");
+MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
+MODULE_LICENSE("GPL");
+
+struct aes_vec {
+	u8 __attribute__((vector_size(16))) v;
+};
+
+struct aes_vec4 {
+	u8 __attribute__((vector_size(16))) v[4];
+};
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
+static void aes_encrypt(struct crypto_aes_ctx *ctx,
+			struct aes_vec *dst, struct aes_vec const *src)
+{
+	void *d1;
+	int d2;
+
+	__asm__("	ld1	{v0.16b}, %[in]			;"
+		"	ld1	{v1.2d}, [%[key]]		;"
+		"	cmp	%[rounds], #10			;"
+		"	bmi	0f				;"
+		"	bne	3f				;"
+		"	mov	v3.16b, v1.16b			;"
+		"	b	2f				;"
+		"0:	mov	v2.16b, v1.16b			;"
+		"	ld1	{v3.2d}, [%[key]], #16		;"
+		"1:	aese	v0.16b, v2.16b			;"
+		"	aesmc	v0.16b, v0.16b			;"
+		"2:	ld1	{v1.2d}, [%[key]], #16		;"
+		"	aese	v0.16b, v3.16b			;"
+		"	aesmc	v0.16b, v0.16b			;"
+		"3:	ld1	{v2.2d}, [%[key]], #16		;"
+		"	subs	%[rounds], %[rounds], #3	;"
+		"	aese	v0.16b, v1.16b			;"
+		"	aesmc	v0.16b, v0.16b			;"
+		"	ld1	{v3.2d}, [%[key]], #16		;"
+		"	bpl	1b				;"
+		"	aese	v0.16b, v2.16b			;"
+		"	eor	v0.16b, v0.16b, v3.16b		;"
+		"	st1	{v0.16b}, %[out]		;"
+
+	:	[out]		"=m"(*dst),
+				"=r"(d1), "=r"(d2) /* dummies */
+	:	[in]		"m"(*src),
+		[key]		"1"(ctx->key_enc),
+		[rounds]	"2"(num_rounds(ctx) - 2)
+	:	"cc");
+}
+
+static void aes_decrypt(struct crypto_aes_ctx *ctx,
+			struct aes_vec *dst, struct aes_vec const *src)
+{
+	void *d1;
+	int d2;
+
+	__asm__("	ld1	{v0.16b}, %[in]			;"
+		"	ld1	{v1.2d}, [%[key]]		;"
+		"	cmp	%[rounds], #10			;"
+		"	bmi	0f				;"
+		"	bne	3f				;"
+		"	mov	v3.16b, v1.16b			;"
+		"	b	2f				;"
+		"0:	mov	v2.16b, v1.16b			;"
+		"	ld1	{v3.2d}, [%[key]], #16		;"
+		"1:	aesd	v0.16b, v2.16b			;"
+		"	aesimc	v0.16b, v0.16b			;"
+		"2:	ld1	{v1.2d}, [%[key]], #16		;"
+		"	aesd	v0.16b, v3.16b			;"
+		"	aesimc	v0.16b, v0.16b			;"
+		"3:	ld1	{v2.2d}, [%[key]], #16		;"
+		"	subs	%[rounds], %[rounds], #3	;"
+		"	aesd	v0.16b, v1.16b			;"
+		"	aesimc	v0.16b, v0.16b			;"
+		"	ld1	{v3.2d}, [%[key]], #16		;"
+		"	bpl	1b				;"
+		"	aese	v0.16b, v2.16b			;"
+		"	eor	v0.16b, v0.16b, v3.16b		;"
+		"	st1	{v0.16b}, %[out]		;"
+
+	:	[out]		"=m"(*dst),
+				"=r"(d1), "=r"(d2) /* dummies */
+	:	[in]		"m"(*src),
+		[key]		"1"(ctx->key_dec),
+		[rounds]	"2"(num_rounds(ctx) - 2)
+	:	"cc");
+}
+
+static void aes_cipher_encrypt(struct crypto_tfm *tfm, u8 dst[], u8 const src[])
+{
+	kernel_neon_begin_partial(4);
+	aes_encrypt(crypto_tfm_ctx(tfm),
+		    (struct aes_vec *)dst, (struct aes_vec *)src);
+	kernel_neon_end();
+}
+
+static void aes_cipher_decrypt(struct crypto_tfm *tfm, u8 dst[], u8 const src[])
+{
+	kernel_neon_begin_partial(4);
+	aes_decrypt(crypto_tfm_ctx(tfm),
+		    (struct aes_vec *)dst, (struct aes_vec *)src);
+	kernel_neon_end();
+}
+
+static void aes_encrypt_4x(struct crypto_aes_ctx *ctx,
+			   struct aes_vec4 *dst, struct aes_vec4 const *src)
+{
+	void *d1;
+	int d2;
+
+	__asm__("	ld1	{v0.16b-v3.16b}, %[in]		;"
+		"	ld1	{v4.2d}, [%[key]]		;"
+		"	cmp	%[rounds], #10			;"
+		"	bmi	0f				;"
+		"	bne	3f				;"
+		"	mov	v6.16b, v4.16b			;"
+		"	b	2f				;"
+		"0:	mov	v5.16b, v4.16b			;"
+		"	ld1	{v6.2d}, [%[key]], #16		;"
+		"1:	aese	v0.16b, v5.16b			;"
+		"	aesmc	v0.16b, v0.16b			;"
+		"	aese	v1.16b, v5.16b			;"
+		"	aesmc	v1.16b, v1.16b			;"
+		"	aese	v2.16b, v5.16b			;"
+		"	aesmc	v2.16b, v2.16b			;"
+		"	aese	v3.16b, v5.16b			;"
+		"	aesmc	v3.16b, v3.16b			;"
+		"2:	ld1	{v4.2d}, [%[key]], #16		;"
+		"	aese	v0.16b, v6.16b			;"
+		"	aesmc	v0.16b, v0.16b			;"
+		"	aese	v1.16b, v6.16b			;"
+		"	aesmc	v1.16b, v1.16b			;"
+		"	aese	v2.16b, v6.16b			;"
+		"	aesmc	v2.16b, v2.16b			;"
+		"	aese	v3.16b, v6.16b			;"
+		"	aesmc	v3.16b, v3.16b			;"
+		"3:	ld1	{v5.2d}, [%[key]], #16		;"
+		"	subs	%[rounds], %[rounds], #3	;"
+		"	aese	v0.16b, v4.16b			;"
+		"	aesmc	v0.16b, v0.16b			;"
+		"	aese	v1.16b, v4.16b			;"
+		"	aesmc	v1.16b, v1.16b			;"
+		"	aese	v2.16b, v4.16b			;"
+		"	aesmc	v2.16b, v2.16b			;"
+		"	aese	v3.16b, v4.16b			;"
+		"	aesmc	v3.16b, v3.16b			;"
+		"	ld1	{v6.2d}, [%[key]], #16		;"
+		"	bpl	1b				;"
+		"	aese	v0.16b, v5.16b			;"
+		"	aese	v1.16b, v5.16b			;"
+		"	aese	v2.16b, v5.16b			;"
+		"	aese	v3.16b, v5.16b			;"
+		"	eor	v0.16b, v0.16b, v6.16b		;"
+		"	eor	v1.16b, v1.16b, v6.16b		;"
+		"	eor	v2.16b, v2.16b, v6.16b		;"
+		"	eor	v3.16b, v3.16b, v6.16b		;"
+		"	st1	{v0.16b-v3.16b}, %[out]		;"
+
+	:	[out]		"=m"(*dst),
+				"=r"(d1), "=r"(d2) /* dummies */
+	:	[in]		"m"(*src),
+		[key]		"1"(ctx->key_dec),
+		[rounds]	"2"(num_rounds(ctx) - 2)
+	:	"cc");
+}
+
+static void aes_decrypt_4x(struct crypto_aes_ctx *ctx,
+			   struct aes_vec4 *dst, struct aes_vec4 const *src)
+{
+	void *d1;
+	int d2;
+
+	__asm__("	ld1	{v0.16b-v3.16b}, %[in]		;"
+		"	ld1	{v4.2d}, [%[key]], #16		;"
+		"	cmp	%[rounds], #10			;"
+		"	bmi	0f				;"
+		"	bne	3f				;"
+		"	mov	v6.16b, v4.16b			;"
+		"	b	2f				;"
+		"0:	mov	v5.16b, v4.16b			;"
+		"	ld1	{v6.2d}, [%[key]], #16		;"
+		"1:	aesd	v0.16b, v5.16b			;"
+		"	aesimc	v0.16b, v0.16b			;"
+		"	aesd	v1.16b, v5.16b			;"
+		"	aesimc	v1.16b, v1.16b			;"
+		"	aesd	v2.16b, v5.16b			;"
+		"	aesimc	v2.16b, v2.16b			;"
+		"	aesd	v3.16b, v5.16b			;"
+		"	aesimc	v3.16b, v3.16b			;"
+		"2:	ld1	{v4.2d}, [%[key]], #16		;"
+		"	aesd	v0.16b, v6.16b			;"
+		"	aesimc	v0.16b, v0.16b			;"
+		"	aesd	v1.16b, v6.16b			;"
+		"	aesimc	v1.16b, v1.16b			;"
+		"	aesd	v2.16b, v6.16b			;"
+		"	aesimc	v2.16b, v2.16b			;"
+		"	aesd	v3.16b, v6.16b			;"
+		"	aesimc	v3.16b, v3.16b			;"
+		"3:	ld1	{v5.2d}, [%[key]], #16		;"
+		"	subs	%[rounds], %[rounds], #3	;"
+		"	aesd	v0.16b, v4.16b			;"
+		"	aesimc	v0.16b, v0.16b			;"
+		"	aesd	v1.16b, v4.16b			;"
+		"	aesimc	v1.16b, v1.16b			;"
+		"	aesd	v2.16b, v4.16b			;"
+		"	aesimc	v2.16b, v2.16b			;"
+		"	aesd	v3.16b, v4.16b			;"
+		"	aesimc	v3.16b, v3.16b			;"
+		"	ld1	{v6.2d}, [%[key]], #16		;"
+		"	bpl	1b				;"
+		"	aesd	v0.16b, v5.16b			;"
+		"	aesd	v1.16b, v5.16b			;"
+		"	aesd	v2.16b, v5.16b			;"
+		"	aesd	v3.16b, v5.16b			;"
+		"	eor	v0.16b, v0.16b, v6.16b		;"
+		"	eor	v1.16b, v1.16b, v6.16b		;"
+		"	eor	v2.16b, v2.16b, v6.16b		;"
+		"	eor	v3.16b, v3.16b, v6.16b		;"
+		"	st1	{v0.16b-v3.16b}, %[out]		;"
+
+	:	[out]		"=m"(*dst),
+				"=r"(d1), "=r"(d2) /* dummies */
+	:	[in]		"m"(*src),
+		[key]		"1"(ctx->key_dec),
+		[rounds]	"2"(num_rounds(ctx) - 2)
+	:	"cc");
+}
+
+static int ecb_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct crypto_aes_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	struct blkcipher_walk walk;
+	int err;
+
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt_block(desc, &walk, 4 * AES_BLOCK_SIZE);
+
+	kernel_neon_begin_partial(7);
+
+	do {
+		u8 *out = walk.dst.virt.addr;
+		u8 *in = walk.src.virt.addr;
+		int bl;
+
+		for (bl = walk.nbytes / AES_BLOCK_SIZE; bl >= 4; bl -= 4) {
+			aes_encrypt_4x(ctx, (struct aes_vec4 *)out,
+				       (struct aes_vec4 *)in);
+			out += 4 * AES_BLOCK_SIZE;
+			in += 4 * AES_BLOCK_SIZE;
+		}
+		while (bl--) {
+			aes_encrypt(ctx, (struct aes_vec *)out,
+				    (struct aes_vec *)in);
+			out += AES_BLOCK_SIZE;
+			in += AES_BLOCK_SIZE;
+		}
+		err = blkcipher_walk_done(desc, &walk, 0);
+	} while (walk.nbytes);
+
+	kernel_neon_end();
+
+	return err;
+}
+
+static int ecb_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+                       struct scatterlist *src, unsigned int nbytes)
+{
+	struct crypto_aes_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	struct blkcipher_walk walk;
+	int err;
+
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt_block(desc, &walk, 4 * AES_BLOCK_SIZE);
+
+	kernel_neon_begin_partial(7);
+
+	do {
+		u8 *out = walk.dst.virt.addr;
+		u8 *in = walk.src.virt.addr;
+		int bl;
+
+		for (bl = walk.nbytes / AES_BLOCK_SIZE; bl >= 4; bl -= 4) {
+			aes_decrypt_4x(ctx, (struct aes_vec4 *)out,
+				       (struct aes_vec4 *)in);
+			out += 4 * AES_BLOCK_SIZE;
+			in += 4 * AES_BLOCK_SIZE;
+		}
+		while (bl--) {
+			aes_decrypt(ctx, (struct aes_vec *)out,
+				    (struct aes_vec *)in);
+			out += AES_BLOCK_SIZE;
+			in += AES_BLOCK_SIZE;
+		}
+		err = blkcipher_walk_done(desc, &walk, 0);
+	} while (walk.nbytes);
+
+	kernel_neon_end();
+
+	return err;
+}
+
+static struct crypto_alg aes_algs[] = { {
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
+	}
+}, {
+	.cra_name		= "ecb(aes)",
+	.cra_driver_name	= "ecb-aes-ce",
+	.cra_priority		= 300,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= AES_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct crypto_aes_ctx),
+	.cra_alignmask		= 7,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_blkcipher = {
+		.min_keysize	= AES_MIN_KEY_SIZE,
+		.max_keysize	= AES_MAX_KEY_SIZE,
+		.ivsize		= AES_BLOCK_SIZE,
+		.setkey		= crypto_aes_set_key,
+		.encrypt	= ecb_encrypt,
+		.decrypt	= ecb_decrypt,
+	}
+} };
+
+static int __init aes_mod_init(void)
+{
+	if (!(elf_hwcap & HWCAP_AES))
+		return -ENODEV;
+	return crypto_register_algs(aes_algs, ARRAY_SIZE(aes_algs));
+}
+
+static void __exit aes_mod_exit(void)
+{
+	crypto_unregister_algs(aes_algs, ARRAY_SIZE(aes_algs));
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
