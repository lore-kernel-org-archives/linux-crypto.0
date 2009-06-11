From: Huang Ying <ying.huang@intel.com>
Subject: [RFC 7/7] crypto: Add PCLMULQDQ accelerated GHASH implementation
Date: Thu, 11 Jun 2009 15:11:20 +0800
Message-ID: <1244704280.5320.131.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:61974 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760021AbZFKHLU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Jun 2009 03:11:20 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

PCLMULQDQ is used to accelerate the most time-consuming part of GHASH,
carry-less multiplication. More information about PCLMULQDQ can be
found at:

http://software.intel.com/en-us/articles/carry-less-multiplication-and-its-usage-for-computing-the-gcm-mode/

Because PCLMULQDQ changes XMM state, its usage must be enclosed with
kernel_fpu_begin/end, which can be used only in process context, the
acceleration is implemented as crypto_ahash. That is, request in soft
IRQ context will be deferred to the cryptd kernel thread.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/crypto/Makefile                   |    3 
 arch/x86/crypto/ghash-clmulni-intel_asm.S  |  118 +++++++++
 arch/x86/crypto/ghash-clmulni-intel_glue.c |  348 +++++++++++++++++++++++++++++
 arch/x86/include/asm/cpufeature.h          |    1 
 crypto/Kconfig                             |    8 
 crypto/cryptd.c                            |    7 
 include/crypto/cryptd.h                    |    1 
 7 files changed, 486 insertions(+)

--- /dev/null
+++ b/arch/x86/crypto/ghash-clmulni-intel_asm.S
@@ -0,0 +1,118 @@
+/*
+ * Accelerated GHASH implementation with Intel PCLMULQDQ-NI
+ * instructions. This file contains accelerated gf128mul
+ * implementation.
+ *
+ * Copyright (c) 2009 Intel Corp.
+ *   Author: Huang Ying <ying.huang@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ */
+
+#include <linux/linkage.h>
+
+.text
+
+.align 16
+.Lbswap_mask:
+	.octa 0x000102030405060708090a0b0c0d0e0f
+
+/* void clmul_gf128mul_lle(be128 *r, const be128 *b) */
+ENTRY(clmul_gf128mul_lle)
+	movups (%rdi), %xmm0	# A
+	movups (%rsi), %xmm1	# B
+	# convert from lle to ble
+	movaps .Lbswap_mask, %xmm6
+	pshufb %xmm6, %xmm0
+	pshufb %xmm6, %xmm1
+	movaps %xmm1, %xmm2
+	#pclmulqdq $0x00, %xmm0, %xmm2 # A0 * B0
+	.byte 0x66, 0x0f, 0x3a, 0x44, 0xd0, 0x00
+	movaps %xmm1, %xmm3
+	#pclmulqdq $0x01, %xmm0, %xmm3 # A0 * B1
+	.byte 0x66, 0x0f, 0x3a, 0x44, 0xd8, 0x01
+	movaps %xmm1, %xmm4
+	#pclmulqdq $0x10, %xmm0, %xmm4 # A1 * B0
+	.byte 0x66, 0x0f, 0x3a, 0x44, 0xe0, 0x10
+	#pclmulqdq $0x11, %xmm0, %xmm1 # A1 * B1
+	.byte 0x66, 0x0f, 0x3a, 0x44, 0xc8, 0x11
+	movaps %xmm3, %xmm5
+	pslldq $8, %xmm3
+	psrldq $8, %xmm5
+	movaps %xmm4, %xmm0
+	pslldq $8, %xmm0
+	psrldq $8, %xmm4
+	pxor %xmm5, %xmm1
+	pxor %xmm4, %xmm1
+	pxor %xmm3, %xmm0
+	pxor %xmm2, %xmm0
+
+	movaps %xmm0, %xmm3
+	psrldq $8, %xmm3
+	psrlq $63, %xmm3
+
+	movaps %xmm0, %xmm2
+	psllq $1, %xmm2
+	pslldq $8, %xmm0
+	psrlq $63, %xmm0
+	por %xmm2, %xmm0
+
+	movaps %xmm1, %xmm2
+	psllq $1, %xmm2
+	pslldq $8, %xmm1
+	psrlq $63, %xmm1
+	por %xmm2, %xmm1
+	por %xmm3, %xmm1
+
+/* reduce */
+
+	movl $0xe1, %eax
+	movd %eax, %xmm2
+	pslldq $15, %xmm2
+
+	movaps %xmm0, %xmm3
+	#pclmulqdq $0x11, %xmm2, %xmm0
+	.byte 0x66, 0x0f, 0x3a, 0x44, 0xc2, 0x11
+	#pclmulqdq $0x10, %xmm2, %xmm3
+	.byte 0x66, 0x0f, 0x3a, 0x44, 0xda, 0x10
+	movaps %xmm3, %xmm4
+	pslldq $8, %xmm3
+	psrldq $8, %xmm4
+	pxor %xmm4, %xmm0
+
+	movaps %xmm3, %xmm4
+	psrldq $8, %xmm4
+	psrlq $63, %xmm4
+
+	movaps %xmm3, %xmm5
+	psllq $1, %xmm5
+	pslldq $8, %xmm3
+	psrlq $63, %xmm3
+	por %xmm5, %xmm3
+
+	movaps %xmm0, %xmm5
+	psllq $1, %xmm5
+	pslldq $8, %xmm0
+	psrlq $63, %xmm0
+	por %xmm5, %xmm0
+	por %xmm4, %xmm0
+
+	pxor %xmm1, %xmm0
+
+	#pclmulqdq $0x11, %xmm2, %xmm3
+	.byte 0x66, 0x0f, 0x3a, 0x44, 0xda, 0x11
+
+	movaps %xmm3, %xmm4
+	psllq $1, %xmm4
+	pslldq $8, %xmm3
+	psrlq $63, %xmm3
+	por %xmm4, %xmm3
+
+	pxor %xmm3, %xmm0
+
+	# convert from ble to lle
+	pshufb %xmm6, %xmm0
+	movups %xmm0, (%rdi)
+	ret
--- /dev/null
+++ b/arch/x86/crypto/ghash-clmulni-intel_glue.c
@@ -0,0 +1,348 @@
+/*
+ * Accelerated GHASH implementation with Intel PCLMULQDQ-NI
+ * instructions. This file contains glue code.
+ *
+ * Copyright (c) 2009 Intel Corp.
+ *   Author: Huang Ying <ying.huang@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/crypto.h>
+#include <crypto/algapi.h>
+#include <crypto/gf128mul.h>
+#include <crypto/internal/hash.h>
+#include <crypto/cryptd.h>
+#include <asm/i387.h>
+
+#define GHASH_BLOCK_SIZE	16
+#define GHASH_DIGEST_SIZE	16
+
+void clmul_gf128mul_lle(be128 *r, const be128 *b);
+
+struct ghash_async_ctx
+{
+	struct cryptd_ahash *cryptd_tfm;
+};
+
+struct ghash_ctx {
+	be128 hash;
+};
+
+struct ghash_desc_ctx {
+	u8 buffer[16];
+	u32 bytes;
+};
+
+static int ghash_init(struct shash_desc *desc)
+{
+	struct ghash_desc_ctx *dctx = shash_desc_ctx(desc);
+
+	dctx->bytes = 0;
+	memset(dctx->buffer, 0, 16);
+
+	return 0;
+}
+
+static int ghash_setkey(struct crypto_shash *tfm,
+			const u8 *key, unsigned int keylen)
+{
+	struct ghash_ctx *ctx = crypto_shash_ctx(tfm);
+
+	if (keylen != 16) {
+		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+
+	memcpy(&ctx->hash, key, keylen);
+
+	return 0;
+}
+
+static int ghash_update(struct shash_desc *desc,
+			 const u8 *src, unsigned int srclen)
+{
+	struct ghash_desc_ctx *dctx = shash_desc_ctx(desc);
+	struct ghash_ctx *ctx = crypto_shash_ctx(desc->tfm);
+	u8 *dst = dctx->buffer;
+
+	kernel_fpu_begin();
+	if (dctx->bytes) {
+		int n = min(srclen, dctx->bytes);
+		u8 *pos = dst + (16 - dctx->bytes);
+
+		dctx->bytes -= n;
+		srclen -= n;
+
+		while (n--)
+			*pos++ ^= *src++;
+
+		if (!dctx->bytes)
+			clmul_gf128mul_lle((be128 *)dst, &ctx->hash);
+	}
+
+	while (srclen >= 16) {
+		crypto_xor(dst, src, 16);
+		clmul_gf128mul_lle((be128 *)dst, &ctx->hash);
+		src += 16;
+		srclen -= 16;
+	}
+	kernel_fpu_end();
+
+	if (srclen) {
+		dctx->bytes = 16 - srclen;
+		while (srclen--)
+			*dst++ ^= *src++;
+	}
+
+	return 0;
+}
+
+static void ghash_flush(struct ghash_ctx *ctx, struct ghash_desc_ctx *dctx)
+{
+	u8 *dst = dctx->buffer;
+
+	if (dctx->bytes) {
+		u8 *tmp = dst + (16 - dctx->bytes);
+
+		while (dctx->bytes--)
+			*tmp++ ^= 0;
+
+		kernel_fpu_begin();
+		gf128mul_lle((be128 *)dst, &ctx->hash);
+		kernel_fpu_end();
+	}
+
+	dctx->bytes = 0;
+}
+
+static int ghash_final(struct shash_desc *desc, u8 *dst)
+{
+	struct ghash_desc_ctx *dctx = shash_desc_ctx(desc);
+	struct ghash_ctx *ctx = crypto_shash_ctx(desc->tfm);
+	u8 *buf = dctx->buffer;
+
+	ghash_flush(ctx, dctx);
+	memcpy(dst, buf, 16);
+
+	return 0;
+}
+
+static struct shash_alg ghash_alg = {
+	.digestsize	= GHASH_DIGEST_SIZE,
+	.init		= ghash_init,
+	.update		= ghash_update,
+	.final		= ghash_final,
+	.setkey		= ghash_setkey,
+	.descsize	= sizeof(struct ghash_desc_ctx),
+	.base		= {
+		.cra_name		= "__ghash",
+		.cra_driver_name	= "__ghash-pclmulqdqni",
+		.cra_priority		= 0,
+		.cra_flags		= CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize		= GHASH_BLOCK_SIZE,
+		.cra_ctxsize		= sizeof(struct ghash_ctx),
+		.cra_module		= THIS_MODULE,
+		.cra_list		= LIST_HEAD_INIT(ghash_alg.base.cra_list),
+	},
+};
+
+static int ghash_async_init(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct ghash_async_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct ahash_request *cryptd_req = ahash_request_ctx(req);
+	struct cryptd_ahash *cryptd_tfm = ctx->cryptd_tfm;
+
+	if (kernel_fpu_using()) {
+		memcpy(cryptd_req, req, sizeof(*req));
+		ahash_request_set_tfm(cryptd_req, &cryptd_tfm->base);
+		return crypto_ahash_init(cryptd_req);
+	} else {
+		struct shash_desc *desc = cryptd_shash_desc(cryptd_req);
+		struct crypto_shash *child = cryptd_ahash_child(cryptd_tfm);
+
+		desc->tfm = child;
+		desc->flags = req->base.flags;
+		return crypto_shash_init(desc);
+	}
+}
+
+static int ghash_async_update(struct ahash_request *req)
+{
+	struct ahash_request *cryptd_req = ahash_request_ctx(req);
+
+	if (kernel_fpu_using()) {
+		struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+		struct ghash_async_ctx *ctx = crypto_ahash_ctx(tfm);
+		struct cryptd_ahash *cryptd_tfm = ctx->cryptd_tfm;
+
+		memcpy(cryptd_req, req, sizeof(*req));
+		ahash_request_set_tfm(cryptd_req, &cryptd_tfm->base);
+		return crypto_ahash_update(cryptd_req);
+	} else {
+		struct shash_desc *desc = cryptd_shash_desc(cryptd_req);
+		struct crypto_hash_walk walk;
+		int nbytes;
+
+		for (nbytes = crypto_hash_walk_first(req, &walk); nbytes > 0;
+		     nbytes = crypto_hash_walk_done(&walk, nbytes))
+			nbytes = crypto_shash_update(desc, walk.data, nbytes);
+		return nbytes;
+	}
+}
+
+static int ghash_async_final(struct ahash_request *req)
+{
+	struct ahash_request *cryptd_req = ahash_request_ctx(req);
+
+	if (kernel_fpu_using()) {
+		struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+		struct ghash_async_ctx *ctx = crypto_ahash_ctx(tfm);
+		struct cryptd_ahash *cryptd_tfm = ctx->cryptd_tfm;
+
+		memcpy(cryptd_req, req, sizeof(*req));
+		ahash_request_set_tfm(cryptd_req, &cryptd_tfm->base);
+		return crypto_ahash_final(cryptd_req);
+	} else {
+		struct shash_desc *desc = cryptd_shash_desc(cryptd_req);
+		return crypto_shash_final(desc, req->result);
+	}
+}
+
+static int ghash_async_digest(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct ghash_async_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct ahash_request *cryptd_req = ahash_request_ctx(req);
+	struct cryptd_ahash *cryptd_tfm = ctx->cryptd_tfm;
+
+	if (kernel_fpu_using()) {
+		memcpy(cryptd_req, req, sizeof(*req));
+		ahash_request_set_tfm(cryptd_req, &cryptd_tfm->base);
+		return crypto_ahash_digest(cryptd_req);
+	} else {
+		struct shash_desc *desc = cryptd_shash_desc(cryptd_req);
+		struct crypto_shash *child = cryptd_ahash_child(cryptd_tfm);
+		struct crypto_hash_walk walk;
+		int nbytes;
+		int err;
+
+		desc->tfm = child;
+		desc->flags = req->base.flags;
+		err = crypto_shash_init(desc);
+		if (err)
+			return err;
+
+		for (nbytes = crypto_hash_walk_first(req, &walk); nbytes > 0;
+		     nbytes = crypto_hash_walk_done(&walk, nbytes))
+			nbytes = crypto_shash_update(desc, walk.data, nbytes);
+		if (nbytes)
+			return nbytes;
+
+		return crypto_shash_final(desc, req->result);
+	}
+}
+
+static int ghash_async_setkey(struct crypto_ahash *tfm, const u8 *key,
+			      unsigned int keylen)
+{
+	struct ghash_async_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct crypto_ahash *child = &ctx->cryptd_tfm->base;
+	int err;
+
+	crypto_ahash_clear_flags(child, CRYPTO_TFM_REQ_MASK);
+	crypto_ahash_set_flags(child, crypto_ahash_get_flags(tfm)
+			       & CRYPTO_TFM_REQ_MASK);
+	err = crypto_ahash_setkey(child, key, keylen);
+	crypto_ahash_set_flags(tfm, crypto_ahash_get_flags(child)
+			       & CRYPTO_TFM_RES_MASK);
+
+	return 0;
+}
+
+static int ghash_async_init_tfm(struct crypto_tfm *tfm)
+{
+	struct cryptd_ahash *cryptd_tfm;
+	struct ghash_async_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	cryptd_tfm = cryptd_alloc_ahash("__ghash-pclmulqdqni", 0, 0);
+	if (IS_ERR(cryptd_tfm))
+		return PTR_ERR(cryptd_tfm);
+	ctx->cryptd_tfm = cryptd_tfm;
+	tfm->crt_ahash.reqsize = sizeof(struct ahash_request) +
+		crypto_ahash_reqsize(&cryptd_tfm->base);
+
+	return 0;
+}
+
+static void ghash_async_exit_tfm(struct crypto_tfm *tfm)
+{
+	struct ghash_async_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	cryptd_free_ahash(ctx->cryptd_tfm);
+}
+
+static struct crypto_alg ghash_async_alg = {
+	.cra_name		= "ghash",
+	.cra_driver_name	= "ghash-clmulni",
+	.cra_priority		= 400,
+	.cra_flags		= CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= GHASH_BLOCK_SIZE,
+	.cra_type		= &crypto_ahash_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(ghash_async_alg.cra_list),
+	.cra_init		= ghash_async_init_tfm,
+	.cra_exit		= ghash_async_exit_tfm,
+	.cra_u = {
+		.ahash = {
+			.digestsize	= GHASH_DIGEST_SIZE,
+			.init		= ghash_async_init,
+			.update		= ghash_async_update,
+			.final		= ghash_async_final,
+			.setkey		= ghash_async_setkey,
+			.digest		= ghash_async_digest,
+		},
+	},
+};
+
+static int __init ghash_pclmulqdqni_mod_init(void)
+{
+	int err;
+
+	if (!cpu_has_pclmulqdq) {
+		printk(KERN_ERR "Intel PCLMULQDQ-NI instructions are not"
+		       " detected.\n");
+		return -ENODEV;
+	}
+
+	if ((err = crypto_register_shash(&ghash_alg)))
+		goto err_out;
+	if ((err = crypto_register_alg(&ghash_async_alg)))
+		goto err_shash;
+
+	return 0;
+
+err_shash:
+	crypto_unregister_shash(&ghash_alg);
+err_out:
+	return err;
+}
+
+static void __exit ghash_pclmulqdqni_mod_exit(void)
+{
+	crypto_unregister_alg(&ghash_async_alg);
+	crypto_unregister_shash(&ghash_alg);
+}
+
+module_init(ghash_pclmulqdqni_mod_init);
+module_exit(ghash_pclmulqdqni_mod_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("GHASH Message Digest Algorithm, acclerated by PCLMULQDQ-NI");
+MODULE_ALIAS("ghash");
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -426,6 +426,14 @@ config CRYPTO_GHASH
 	help
 	  GHASH is message digest algorithm for GCM (Galois/Counter Mode).
 
+config CRYPTO_GHASH_CLMUL_NI_INTEL
+	tristate "GHASH digest algorithm (CLMUL-NI accelerated)"
+	select CRYPTO_SHASH
+	select CRYPTO_CRYPTD
+	help
+	  GHASH is message digest algorithm for GCM (Galois/Counter Mode).
+	  The implementation is accelerated by CLMUL-NI of Intel.
+
 comment "Ciphers"
 
 config CRYPTO_AES
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -12,6 +12,7 @@ obj-$(CONFIG_CRYPTO_AES_X86_64) += aes-x
 obj-$(CONFIG_CRYPTO_TWOFISH_X86_64) += twofish-x86_64.o
 obj-$(CONFIG_CRYPTO_SALSA20_X86_64) += salsa20-x86_64.o
 obj-$(CONFIG_CRYPTO_AES_NI_INTEL) += aesni-intel.o
+obj-$(CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL) += ghash-clmulni-intel.o
 
 obj-$(CONFIG_CRYPTO_CRC32C_INTEL) += crc32c-intel.o
 
@@ -24,3 +25,5 @@ twofish-x86_64-y := twofish-x86_64-asm_6
 salsa20-x86_64-y := salsa20-x86_64-asm_64.o salsa20_glue.o
 
 aesni-intel-y := aesni-intel_asm.o aesni-intel_glue.o
+
+ghash-clmulni-intel-y := ghash-clmulni-intel_asm.o ghash-clmulni-intel_glue.o
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -243,6 +243,7 @@ extern const char * const x86_power_flag
 #define cpu_has_x2apic		boot_cpu_has(X86_FEATURE_X2APIC)
 #define cpu_has_xsave		boot_cpu_has(X86_FEATURE_XSAVE)
 #define cpu_has_hypervisor	boot_cpu_has(X86_FEATURE_HYPERVISOR)
+#define cpu_has_pclmulqdq	boot_cpu_has(X86_FEATURE_PCLMULQDQ)
 
 #if defined(CONFIG_X86_INVLPG) || defined(CONFIG_X86_64)
 # define cpu_has_invlpg		1
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -677,6 +677,13 @@ struct crypto_shash *cryptd_ahash_child(
 }
 EXPORT_SYMBOL_GPL(cryptd_ahash_child);
 
+struct shash_desc *cryptd_shash_desc(struct ahash_request *req)
+{
+	struct cryptd_hash_request_ctx *rctx = ahash_request_ctx(req);
+	return &rctx->desc;
+}
+EXPORT_SYMBOL_GPL(cryptd_shash_desc);
+
 void cryptd_free_ahash(struct cryptd_ahash *tfm)
 {
 	crypto_free_ahash(&tfm->base);
--- a/include/crypto/cryptd.h
+++ b/include/crypto/cryptd.h
@@ -39,6 +39,7 @@ static inline struct cryptd_ahash *__cry
 struct cryptd_ahash *cryptd_alloc_ahash(const char *alg_name,
 					u32 type, u32 mask);
 struct crypto_shash *cryptd_ahash_child(struct cryptd_ahash *tfm);
+struct shash_desc *cryptd_shash_desc(struct ahash_request *req);
 void cryptd_free_ahash(struct cryptd_ahash *tfm);
 
 #endif


