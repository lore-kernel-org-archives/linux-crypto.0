From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 2/2] arm64: add support for AES using ARMv8 Crypto Extensions
Date: Fri, 13 Sep 2013 17:08:06 +0200
Message-ID: <1379084886-1178-3-git-send-email-ard.biesheuvel@linaro.org>
References: <1379084886-1178-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: linux-crypto@vger.kernel.org, nico@linaro.org,
	catalin.marinas@arm.com, steve.capper@arm.com,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:54698 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756358Ab3IMPId (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 Sep 2013 11:08:33 -0400
Received: by mail-ea0-f177.google.com with SMTP id f15so641583eak.36
        for <linux-crypto@vger.kernel.org>; Fri, 13 Sep 2013 08:08:32 -0700 (PDT)
In-Reply-To: <1379084886-1178-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This adds ARMv8 Crypto Extensions based implemenations of
AES in CBC, CTR and XTS mode.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/Makefile              |   8 +-
 arch/arm64/crypto/Makefile       |  12 ++
 arch/arm64/crypto/aesce-cbc.S    |  58 +++++++
 arch/arm64/crypto/aesce-ctr.S    |  83 +++++++++
 arch/arm64/crypto/aesce-glue.c   | 352 +++++++++++++++++++++++++++++++++++++++
 arch/arm64/crypto/aesce-macros.S |  95 +++++++++++
 arch/arm64/crypto/aesce-xts.S    | 129 ++++++++++++++
 crypto/Kconfig                   |   7 +
 8 files changed, 741 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm64/crypto/Makefile
 create mode 100644 arch/arm64/crypto/aesce-cbc.S
 create mode 100644 arch/arm64/crypto/aesce-ctr.S
 create mode 100644 arch/arm64/crypto/aesce-glue.c
 create mode 100644 arch/arm64/crypto/aesce-macros.S
 create mode 100644 arch/arm64/crypto/aesce-xts.S

diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index d90cf79..c7d4959 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -36,9 +36,11 @@ TEXT_OFFSET := 0x00080000
 
 export	TEXT_OFFSET GZFLAGS
 
-core-y		+= arch/arm64/kernel/ arch/arm64/mm/
-core-$(CONFIG_KVM) += arch/arm64/kvm/
-core-$(CONFIG_XEN) += arch/arm64/xen/
+core-y			+= arch/arm64/kernel/ arch/arm64/mm/
+core-$(CONFIG_KVM)	+= arch/arm64/kvm/
+core-$(CONFIG_XEN)	+= arch/arm64/xen/
+core-$(CONFIG_CRYPTO)	+= arch/arm64/crypto/
+
 libs-y		:= arch/arm64/lib/ $(libs-y)
 libs-y		+= $(LIBGCC)
 
diff --git a/arch/arm64/crypto/Makefile b/arch/arm64/crypto/Makefile
new file mode 100644
index 0000000..da1a437
--- /dev/null
+++ b/arch/arm64/crypto/Makefile
@@ -0,0 +1,12 @@
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
+aes-arm64ce-y := aesce-cbc.o aesce-ctr.o aesce-xts.o aesce-glue.o
+obj-$(CONFIG_CRYPTO_AES_ARM64CE) += aes-arm64ce.o
diff --git a/arch/arm64/crypto/aesce-cbc.S b/arch/arm64/crypto/aesce-cbc.S
new file mode 100644
index 0000000..d955bf2
--- /dev/null
+++ b/arch/arm64/crypto/aesce-cbc.S
@@ -0,0 +1,58 @@
+/*
+ * linux/arch/arm64/crypto/aesce-cbc.S - AES-CBC using ARMv8 crypto extensions
+ *
+ * Copyright (C) 2013 Linaro Ltd <ard.biesheuvel@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/linkage.h>
+
+#include "aesce-macros.S"
+
+	.text
+	.arch		armv8-a+crypto
+
+	// aesce_cbc_encrypt(u8 out[], u8 const in[], u8 const rk[], int rounds,
+	//		     int blocks, u8 iv[], int first)
+	// aesce_cbc_decrypt(u8 out[], u8 const in[], u8 const rk[], int rounds,
+	//		     int blocks, u8 iv[], int first)
+
+ENTRY(aesce_cbc_encrypt)
+	tst		w6, #1
+	beq		.Lencloop
+
+	ld1		{v2.16b}, [x5]			// get iv
+	load_round_keys	w3, x2
+
+.Lencloop:
+	ld1		{v1.16b}, [x1], #16		// get next pt block
+	eor		v0.16b, v1.16b, v2.16b		// ... and xor with iv
+	encrypt_block	v2.16b, v0.16b, w3
+	st1		{v2.16b}, [x0], #16
+	subs		w4, w4, #1
+	bne		.Lencloop
+	ret
+ENDPROC(aesce_cbc_encrypt)
+
+
+ENTRY(aesce_cbc_decrypt)
+	tst		w6, #1
+	beq		.Ldecloop
+
+	ld1		{v3.16b}, [x5]			// get iv
+	load_round_keys	w3, x2
+
+.Ldecloop:
+	ld1		{v1.16b}, [x1], #16		// get next ct block
+	mov		v0.16b, v1.16b			// ... and copy to v0
+	decrypt_block	v2.16b, v0.16b, w3
+	eor		v0.16b, v2.16b, v3.16b		// xor with iv to get pt
+	mov		v3.16b, v1.16b			// ct is next round's iv
+	st1		{v0.16b}, [x0], #16
+	subs		w4, w4, #1
+	bne		.Ldecloop
+	ret
+ENDPROC(aesce_cbc_decrypt)
diff --git a/arch/arm64/crypto/aesce-ctr.S b/arch/arm64/crypto/aesce-ctr.S
new file mode 100644
index 0000000..5b5f02f
--- /dev/null
+++ b/arch/arm64/crypto/aesce-ctr.S
@@ -0,0 +1,83 @@
+/*
+ * linux/arch/arm64/crypto/aesce-ctr.S - AES-CTR using ARMv8 crypto extensions
+ *
+ * Copyright (C) 2013 Linaro Ltd <ard.biesheuvel@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/linkage.h>
+
+#include "aesce-macros.S"
+
+	.text
+	.arch		armv8-a+crypto
+
+	// aesce_ctr_encrypt(u8 out[], u8 const in[], u8 const rk[], int rounds,
+	//		     size_t bytes, u8 ctr[], int first)
+
+ENTRY(aesce_ctr_encrypt)
+	ld1		{v1.16b}, [x5]
+	tst		w6, #1			// 1st time around?
+	umov		x6, v1.d[1]		// keep swabbed ctr
+	rev		x6, x6			// ... in x6
+	beq		.Linc
+
+	load_round_keys	w3, x2
+
+.Lloop:
+	mov		v0.16b, v1.16b
+	encrypt_block	v2.16b, v0.16b, w3
+	ld1		{v0.16b}, [x1], #16
+	eor		v2.16b, v2.16b, v0.16b
+
+	subs		x4, x4, #16
+	bmi		.Ltail8
+
+	st1		{v2.16b}, [x0], #16
+	beq		.Lout
+.Linc:
+	adds		x6, x6, #1		// increment BE ctr
+	rev		x7, x6
+	ins		v1.d[1], x7
+	bne		.Lloop			// no overflow?
+
+	umov		x7, v1.d[0]		// load upper word of ctr
+	rev		x7, x7			// ... to handle the carry
+	add		x7, x7, #1
+	rev		x7, x7
+	ins		v1.d[0], x7
+	b		.Lloop
+.Lout:
+	st1		{v1.16b}, [x5]
+	ret
+
+.Ltail8:
+	adds		x5, x4, #8
+	bmi		.Ltail4
+	mov		x4, x5
+	st1		{v2.8b}, [x0], #8
+	beq		.Lout
+	ext		v2.16b, v2.16b, v2.16b, #8
+.Ltail4:
+	subs		x5, x4, #4
+	bmi		.Ltail2
+	mov		x4, x5
+	umov		w7, v2.s[0]
+	str		w7, [x0], #4
+	beq		.Lout
+	ext		v2.16b, v2.16b, v2.16b, #4
+.Ltail2:
+	subs		x5, x4, #2
+	bmi		.Ltail1
+	umov		w7, v2.h[0]
+	strh		w7, [x0], #2
+	beq		.Lout
+	ext		v2.16b, v2.16b, v2.16b, #2
+.Ltail1:
+	umov		w7, v2.b[0]
+	strb		w7, [x0]
+	ret
+ENDPROC(aesce_ctr_encrypt)
diff --git a/arch/arm64/crypto/aesce-glue.c b/arch/arm64/crypto/aesce-glue.c
new file mode 100644
index 0000000..dd259b9
--- /dev/null
+++ b/arch/arm64/crypto/aesce-glue.c
@@ -0,0 +1,352 @@
+/*
+ * linux/arch/arm64/crypto/aesce-cbc-glue.c - wrapper code for AES-CBC for ARMv8
+ *
+ * Copyright (C) 2013 Linaro Ltd <ard.biesheuvel@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <asm/neon.h>
+#include <crypto/aes.h>
+#include <crypto/ablk_helper.h>
+#include <crypto/algapi.h>
+#include <linux/module.h>
+
+/* defined in aesce-cbc.S */
+asmlinkage void aesce_cbc_encrypt(u8 out[], u8 const in[], u8 const rk[],
+				  int rounds, int blocks, u8 iv[], int first);
+asmlinkage void aesce_cbc_decrypt(u8 out[], u8 const in[], u8 const rk[],
+				  int rounds, int blocks, u8 iv[], int first);
+
+/* defined in aesce-ctr.S */
+asmlinkage void aesce_ctr_encrypt(u8 out[], u8 const in[], u8 const rk[],
+				  int rounds, size_t bytes, u8 ctr[], int first);
+
+/* defined in aesce-xts.S */
+asmlinkage void aesce_xts_encrypt(u8 out[], u8 const in[], u8 const rk1[],
+			          u8 const rk2[], int rounds, size_t bytes,
+			          u8 iv[], int first);
+
+asmlinkage void aesce_xts_decrypt(u8 out[], u8 const in[], u8 const rk1[],
+				  u8 const rk2[], int rounds, size_t bytes,
+				  u8 iv[], int first);
+
+struct crypto_aes_xts_ctx {
+	struct crypto_aes_ctx key1;
+	struct crypto_aes_ctx key2;
+};
+
+static int xts_set_key(struct crypto_tfm *tfm, const u8 *in_key,
+		       unsigned int key_len)
+{
+	struct crypto_aes_xts_ctx *ctx = crypto_tfm_ctx(tfm);
+	u32 *flags = &tfm->crt_flags;
+	int ret;
+
+	ret = crypto_aes_expand_key(&ctx->key1, in_key, key_len/2);
+	if (!ret)
+		ret = crypto_aes_expand_key(&ctx->key2, &in_key[key_len/2],
+					    key_len/2);
+	if (!ret)
+		return 0;
+
+	*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
+	return -EINVAL;
+}
+
+static int cbc_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct crypto_aes_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	int err, first, rounds = 6 + ctx->key_length/4;
+	struct blkcipher_walk walk;
+	unsigned int blocks;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt(desc, &walk);
+
+	kernel_neon_begin();
+	for (first = 1; (blocks = (walk.nbytes / AES_BLOCK_SIZE)); first = 0) {
+		aesce_cbc_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
+				  (u8*)ctx->key_enc, rounds, blocks, walk.iv,
+				  first);
+
+		err = blkcipher_walk_done(desc, &walk, blocks * AES_BLOCK_SIZE);
+	}
+	kernel_neon_end();
+
+	/* non-integral sizes are not supported in CBC */
+	if (unlikely(walk.nbytes))
+		err = -EINVAL;
+
+	return err;
+}
+
+static int cbc_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct crypto_aes_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	int err, first, rounds = 6 + ctx->key_length/4;
+	struct blkcipher_walk walk;
+	unsigned int blocks;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt(desc, &walk);
+
+	kernel_neon_begin();
+	for (first = 1; (blocks = (walk.nbytes / AES_BLOCK_SIZE)); first = 0) {
+		aesce_cbc_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
+				  (u8*)ctx->key_dec, rounds, blocks, walk.iv,
+				  first);
+
+		err = blkcipher_walk_done(desc, &walk, blocks * AES_BLOCK_SIZE);
+	}
+	kernel_neon_end();
+
+	/* non-integral sizes are not supported in CBC */
+	if (unlikely(walk.nbytes))
+		err = -EINVAL;
+
+	return err;
+}
+
+static int ctr_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct crypto_aes_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	int err, first, rounds = 6 + ctx->key_length/4;
+	struct blkcipher_walk walk;
+	u8 ctr[AES_BLOCK_SIZE];
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt(desc, &walk);
+
+	memcpy(ctr, walk.iv, AES_BLOCK_SIZE);
+
+	kernel_neon_begin();
+	for (first = 1; (nbytes = walk.nbytes); first = 0) {
+		aesce_ctr_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
+				  (u8*)ctx->key_enc, rounds, nbytes, ctr, first);
+
+		err = blkcipher_walk_done(desc, &walk, 0);
+
+		/* non-integral block *must* be the last one */
+		if (unlikely(walk.nbytes && (nbytes & (AES_BLOCK_SIZE-1)))) {
+			err = -EINVAL;
+			break;
+		}
+	}
+	kernel_neon_end();
+
+	return err;
+}
+
+static int xts_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct crypto_aes_xts_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	int err, first, rounds = 6 + ctx->key1.key_length/4;
+	struct blkcipher_walk walk;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt(desc, &walk);
+
+	kernel_neon_begin();
+	for (first = 1; (nbytes = walk.nbytes); first = 0) {
+		aesce_xts_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
+				  (u8*)ctx->key1.key_enc,
+				  (u8*)ctx->key2.key_enc,
+				  rounds, nbytes, walk.iv, first);
+
+		err = blkcipher_walk_done(desc, &walk, 0);
+
+		/* non-integral block *must* be the last one */
+		if (unlikely(walk.nbytes && (nbytes & (AES_BLOCK_SIZE-1)))) {
+			err = -EINVAL;
+			break;
+		}
+	}
+	kernel_neon_end();
+
+	return err;
+}
+
+static int xts_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct crypto_aes_xts_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	int err, first, rounds = 6 + ctx->key1.key_length/4;
+	struct blkcipher_walk walk;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt(desc, &walk);
+
+	kernel_neon_begin();
+	for (first = 1; (nbytes = walk.nbytes); first = 0) {
+		aesce_xts_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
+				  (u8*)ctx->key1.key_enc,
+				  (u8*)ctx->key2.key_dec,
+				  rounds, nbytes, walk.iv, first);
+
+		err = blkcipher_walk_done(desc, &walk, 0);
+
+		/* non-integral block *must* be the last one */
+		if (unlikely(walk.nbytes && (nbytes & (AES_BLOCK_SIZE-1)))) {
+			err = -EINVAL;
+			break;
+		}
+	}
+	kernel_neon_end();
+
+	return err;
+}
+
+static struct crypto_alg aesce_cbc_algs[] = { {
+	.cra_name		= "__cbc-aes-aesce",
+	.cra_driver_name	= "__driver-cbc-aes-aesce",
+	.cra_priority		= 0,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= AES_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct crypto_aes_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= AES_MIN_KEY_SIZE,
+			.max_keysize	= AES_MAX_KEY_SIZE,
+			.ivsize		= AES_BLOCK_SIZE,
+			.setkey		= crypto_aes_set_key,
+			.encrypt	= cbc_encrypt,
+			.decrypt	= cbc_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "__ctr-aes-aesce",
+	.cra_driver_name	= "__driver-ctr-aes-aesce",
+	.cra_priority		= 0,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= AES_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct crypto_aes_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= AES_MIN_KEY_SIZE,
+			.max_keysize	= AES_MAX_KEY_SIZE,
+			.ivsize		= AES_BLOCK_SIZE,
+			.setkey		= crypto_aes_set_key,
+			.encrypt	= ctr_encrypt,
+			.decrypt	= ctr_encrypt,
+		},
+	},
+}, {
+	.cra_name		= "__xts-aes-aesce",
+	.cra_driver_name	= "__driver-xts-aes-aesce",
+	.cra_priority		= 0,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= AES_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct crypto_aes_xts_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= 2*AES_MIN_KEY_SIZE,
+			.max_keysize	= 2*AES_MAX_KEY_SIZE,
+			.ivsize		= AES_BLOCK_SIZE,
+			.setkey		= xts_set_key,
+			.encrypt	= xts_encrypt,
+			.decrypt	= xts_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "cbc(aes)",
+	.cra_driver_name	= "cbc-aes-aesce",
+	.cra_priority		= 200,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER|CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= AES_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct async_helper_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_init		= ablk_init,
+	.cra_exit		= ablk_exit,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize	= AES_MIN_KEY_SIZE,
+			.max_keysize	= AES_MAX_KEY_SIZE,
+			.ivsize		= AES_BLOCK_SIZE,
+			.setkey		= ablk_set_key,
+			.encrypt	= ablk_encrypt,
+			.decrypt	= ablk_decrypt,
+		}
+	}
+}, {
+	.cra_name		= "ctr(aes)",
+	.cra_driver_name	= "ctr-aes-aesce",
+	.cra_priority		= 200,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER|CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= AES_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct async_helper_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_init		= ablk_init,
+	.cra_exit		= ablk_exit,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize	= AES_MIN_KEY_SIZE,
+			.max_keysize	= AES_MAX_KEY_SIZE,
+			.ivsize		= AES_BLOCK_SIZE,
+			.setkey		= ablk_set_key,
+			.encrypt	= ablk_encrypt,
+			.decrypt	= ablk_decrypt,
+		}
+	}
+}, {
+	.cra_name		= "xts(aes)",
+	.cra_driver_name	= "xts-aes-aesce",
+	.cra_priority		= 200,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER|CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= AES_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct async_helper_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_init		= ablk_init,
+	.cra_exit		= ablk_exit,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize	= 2*AES_MIN_KEY_SIZE,
+			.max_keysize	= 2*AES_MAX_KEY_SIZE,
+			.ivsize		= AES_BLOCK_SIZE,
+			.setkey		= ablk_set_key,
+			.encrypt	= ablk_encrypt,
+			.decrypt	= ablk_decrypt,
+		}
+	}
+} };
+
+static int __init aesce_cbc_init(void)
+{
+	if (0) // TODO check for crypto extensions
+		return -ENODEV;
+
+	return crypto_register_algs(aesce_cbc_algs, ARRAY_SIZE(aesce_cbc_algs));
+}
+
+static void __exit aesce_cbc_exit(void)
+{
+	crypto_unregister_algs(aesce_cbc_algs, ARRAY_SIZE(aesce_cbc_algs));
+}
+
+module_init(aesce_cbc_init);
+module_exit(aesce_cbc_exit);
+
+MODULE_DESCRIPTION("AES in CBC/CTR/XTS modes using ARMv8 Crypto Extensions");
+MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
+MODULE_LICENSE("GPL");
diff --git a/arch/arm64/crypto/aesce-macros.S b/arch/arm64/crypto/aesce-macros.S
new file mode 100644
index 0000000..37d78f7
--- /dev/null
+++ b/arch/arm64/crypto/aesce-macros.S
@@ -0,0 +1,95 @@
+/*
+ * linux/arch/arm64/crypto/aesce-macros.s - shared macros for ARMv8 AES
+ *
+ * Copyright (C) 2013 Linaro Ltd <ard.biesheuvel@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+	.macro		load_round_keys,rounds,rk
+	cmp		\rounds, #12
+	ld1		{v16.16b-v19.16b}, [\rk], #64
+	ld1		{v20.16b-v23.16b}, [\rk], #64
+	ld1		{v24.16b-v26.16b}, [\rk], #48
+	blo		1111f
+	ld1		{v27.16b-v28.16b}, [\rk], #32
+	beq		1111f
+	ld1		{v29.16b-v30.16b}, [\rk]
+1111:
+	.endm
+
+	.macro		encrypt_block,out,in,rounds
+	cmp		\rounds, #12
+	aese		\in, v16.16b			// 1
+	aesmc		\in, \in
+	aese		\in, v17.16b			// 2
+	aesmc		\in, \in
+	aese		\in, v18.16b			// 3
+	aesmc		\in, \in
+	aese		\in, v19.16b			// 4
+	aesmc		\in, \in
+	aese		\in, v20.16b			// 5
+	aesmc		\in, \in
+	aese		\in, v21.16b			// 6
+	aesmc		\in, \in
+	aese		\in, v22.16b			// 7
+	aesmc		\in, \in
+	aese		\in, v23.16b			// 8
+	aesmc		\in, \in
+	aese		\in, v24.16b			// 9
+	aesmc		\in, \in
+	aese		\in, v25.16b			// 10
+	eor		\out, \in, v26.16b
+	blo		2222f
+	aesmc		\in, \in
+	aese		\in, v26.16b			// 11
+	aesmc		\in, \in
+	aese		\in, v27.16b			// 12
+	eor		\out, \in, v28.16b
+	beq		2222f
+	aesmc		\in, \in
+	aese		\in, v28.16b			// 13
+	aesmc		\in, \in
+	aese		\in, v29.16b			// 14
+	eor		\out, \in, v30.16b
+2222:
+	.endm
+
+	.macro		decrypt_block,out,in,rounds
+	cmp		\rounds, #12
+	aesd		\in, v16.16b			// 1
+	aesimc		\in, \in
+	aesd		\in, v17.16b			// 2
+	aesimc		\in, \in
+	aesd		\in, v18.16b			// 3
+	aesimc		\in, \in
+	aesd		\in, v19.16b			// 4
+	aesimc		\in, \in
+	aesd		\in, v20.16b			// 5
+	aesimc		\in, \in
+	aesd		\in, v21.16b			// 6
+	aesimc		\in, \in
+	aesd		\in, v22.16b			// 7
+	aesimc		\in, \in
+	aesd		\in, v23.16b			// 8
+	aesimc		\in, \in
+	aesd		\in, v24.16b			// 9
+	aesimc		\in, \in
+	aesd		\in, v25.16b			// 10
+	eor		\out, \in, v26.16b
+	blo		3333f
+	aesimc		\in, \in
+	aesd		\in, v26.16b			// 11
+	aesimc		\in, \in
+	aesd		\in, v27.16b			// 12
+	eor		\out, \in, v28.16b
+	beq		3333f
+	aesimc		\in, \in
+	aesd		\in, v28.16b			// 13
+	aesimc		\in, \in
+	aesd		\in, v29.16b			// 14
+	eor		\out, \in, v30.16b
+3333:
+	.endm
diff --git a/arch/arm64/crypto/aesce-xts.S b/arch/arm64/crypto/aesce-xts.S
new file mode 100644
index 0000000..9d4a475
--- /dev/null
+++ b/arch/arm64/crypto/aesce-xts.S
@@ -0,0 +1,129 @@
+/*
+ * linux/arch/arm64/crypto/aesce-xts.S - AES-XTS using ARMv8 crypto extensions
+ *
+ * Copyright (C) 2013 Linaro Ltd <ard.biesheuvel@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/linkage.h>
+
+#include "aesce-macros.S"
+
+#define NEXT_TWEAK(tweak,const,spare)					;\
+	sshr		spare ##.2d,  tweak ##.2d,  #63			;\
+	and		spare ##.16b, spare ##.16b, const ##.16b	;\
+	add		tweak ##.2d,  tweak ##.2d,  tweak ##.2d		;\
+	ext		spare ##.16b, spare ##.16b, spare ##.16b, #8	;\
+	eor		tweak ##.16b, tweak ##.16b, spare ##.16b
+
+	.text
+	.arch		armv8-a+crypto
+
+	// aesce_xts_encrypt(u8 out[], u8 const in[], u8 const rk1[],
+	//		     u8 const rk2[], int rounds, size_t bytes, u8 iv[],
+	//		     int first)
+	// aesce_xts_decrypt(u8 out[], u8 const in[], u8 const rk1[],
+	//		     u8 const rk2[], int rounds, size_t bytes, u8 iv[],
+	//		     int first)
+
+.Lxts_mul_x:
+	.word		1, 0, 0x87, 0
+
+ENTRY(aesce_xts_encrypt)
+	tst		w7, #1				// first call?
+	beq		.Lencmore
+
+	ld1		{v0.16b}, [x6]
+	load_round_keys	w4, x2
+	encrypt_block	v3.16b, v0.16b, w4		// first tweak
+	load_round_keys	w4, x3
+	ldr		q4, .Lxts_mul_x
+	b		.Lencfirst
+.Lencmore:
+	NEXT_TWEAK	(v3, v4, v8)
+.Lencfirst:
+	subs		x5, x5, #16
+.Lencloop:
+	ld1		{v1.16b}, [x1], #16
+	eor		v0.16b, v1.16b, v3.16b
+	encrypt_block	v2.16b, v0.16b, w4
+	eor		v2.16b, v2.16b, v3.16b
+	st1		{v2.16b}, [x0], #16
+	beq		.Lencout
+
+	NEXT_TWEAK	(v3, v4, v8)
+	subs		x5, x5, #16
+	bpl		.Lencloop
+
+	sub		x0, x0, #16
+	add		x5, x5, #16
+	mov		x2, x0
+.Lencsteal:
+	ldrb		w6, [x1], #1
+	ldrb		w7, [x2, #-16]
+	strb		w6, [x2, #-16]
+	strb		w7, [x2], #1
+	subs		x5, x5, #1
+	bne		.Lencsteal
+	mov		x1, x0
+	b		.Lencloop
+.Lencout:
+	ret
+ENDPROC(aesce_xts_encrypt)
+
+
+ENTRY(aesce_xts_decrypt)
+	tst		w7, #1				// first call?
+	beq		.Ldecmore
+
+	ld1		{v0.16b}, [x6]
+	load_round_keys	w4, x2
+	encrypt_block	v3.16b, v0.16b, w4		// first tweak
+	load_round_keys	w4, x3
+	ldr		q4, .Lxts_mul_x
+	b		.Ldecfirst
+.Ldecmore:
+	NEXT_TWEAK	(v3, v4, v8)
+.Ldecfirst:
+	tst		x5, #15				// odd size?
+	beq		.Ldeceven
+	sub		x5, x5, #16
+.Ldeceven:
+	subs		x5, x5, #16
+	bmi		.Lshort
+.Ldecloop:
+	ld1		{v1.16b}, [x1], #16
+	eor		v0.16b, v1.16b, v3.16b
+	decrypt_block	v2.16b, v0.16b, w4
+	eor		v2.16b, v2.16b, v3.16b
+	st1		{v2.16b}, [x0], #16
+	beq		.Ldecout
+	bmi		.Ldecstealout
+
+	NEXT_TWEAK	(v3, v4, v8)
+	subs		x5, x5, #16
+	bpl		.Ldecloop
+.Lshort:
+	mov		v5.16b, v3.16b
+	NEXT_TWEAK	(v3, v4, v8)			// last round of tweak
+	b		.Ldecloop
+.Ldecstealout:
+	sub		x0, x0, #16
+	add		x5, x5, #16
+	mov		x2, x0
+.Ldecsteal:
+	ldrb		w7, [x2]
+	ldrb		w6, [x1], #1
+	strb		w7, [x2, #16]
+	strb		w6, [x2], #1
+	subs		x5, x5, #1
+	bne		.Ldecsteal
+	mov		x1, x0
+	mov		v3.16b, v5.16b
+	b		.Ldecloop
+.Ldecout:
+	ret
+ENDPROC(aesce_xts_decrypt)
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 15750a5..fc0ad85 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -775,6 +775,13 @@ config CRYPTO_AES_ARM
 
 	  See <http://csrc.nist.gov/encryption/aes/> for more information.
 
+config CRYPTO_AES_ARM64CE
+	tristate "AES using ARMv8 Crypto Extensions"
+	depends on ARM64
+	select CRYPTO_BLKCIPHER
+	select CRYPTO_AES
+	select CRYPTO_ABLK_HELPER
+
 config CRYPTO_ANUBIS
 	tristate "Anubis cipher algorithm"
 	select CRYPTO_ALGAPI
-- 
1.8.1.2
