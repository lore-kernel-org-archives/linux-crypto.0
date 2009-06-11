From: Huang Ying <ying.huang@intel.com>
Subject: [RFC 1/7] crypto: Add GHASH digest algorithm for GCM
Date: Thu, 11 Jun 2009 15:10:26 +0800
Message-ID: <1244704226.5320.124.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:28492 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759157AbZFKHKj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Jun 2009 03:10:39 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

GHASH is implemented as a shash algorithm. The actual implementation
is copied from gcm.c. This makes it possible to add
architecture/hardware accelerated GHASH implementation.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 crypto/Kconfig         |    7 +
 crypto/Makefile        |    2 
 crypto/ghash-generic.c |  179 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 188 insertions(+)

--- /dev/null
+++ b/crypto/ghash-generic.c
@@ -0,0 +1,179 @@
+/*
+ * GHASH: digest algorithm for GCM (Galois/Counter Mode).
+ *
+ * Copyright (c) 2007 Nokia Siemens Networks - Mikko Herranen <mh1@iki.fi>
+ * Copyright (c) 2009 Intel Corp.
+ *   Author: Huang Ying <ying.huang@intel.com>
+ *
+ * The algorithm implementation is copied from gcm.c.
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
+#include <crypto/gf128mul.h>
+#include <crypto/algapi.h>
+#include <crypto/internal/hash.h>
+
+#define GHASH_BLOCK_SIZE	16
+#define GHASH_DIGEST_SIZE	16
+
+struct ghash_ctx {
+	struct gf128mul_4k *gf128;
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
+	if (ctx->gf128)
+		gf128mul_free_4k(ctx->gf128);
+	ctx->gf128 = gf128mul_init_4k_lle((be128 *)key);
+	if (!ctx->gf128)
+		return -ENOMEM;
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
+			gf128mul_4k_lle((be128 *)dst, ctx->gf128);
+	}
+
+	while (srclen >= 16) {
+		crypto_xor(dst, src, 16);
+		gf128mul_4k_lle((be128 *)dst, ctx->gf128);
+		src += 16;
+		srclen -= 16;
+	}
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
+		gf128mul_4k_lle((be128 *)dst, ctx->gf128);
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
+static int ghash_init_tfm(struct crypto_tfm *tfm)
+{
+	struct ghash_ctx *ctx = crypto_tfm_ctx(tfm);
+	ctx->gf128 = NULL;
+	return 0;
+}
+
+static void ghash_exit_tfm(struct crypto_tfm *tfm)
+{
+	struct ghash_ctx *ctx = crypto_tfm_ctx(tfm);
+	if (ctx->gf128)
+		gf128mul_free_4k(ctx->gf128);
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
+		.cra_name		= "ghash",
+		.cra_driver_name	= "ghash-generic",
+		.cra_priority		= 100,
+		.cra_flags		= CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize		= GHASH_BLOCK_SIZE,
+		.cra_ctxsize		= sizeof(struct ghash_ctx),
+		.cra_module		= THIS_MODULE,
+		.cra_list		= LIST_HEAD_INIT(ghash_alg.base.cra_list),
+		.cra_init		= ghash_init_tfm,
+		.cra_exit		= ghash_exit_tfm,
+	},
+};
+
+static int __init ghash_mod_init(void)
+{
+	return crypto_register_shash(&ghash_alg);
+}
+
+static void __exit ghash_mod_exit(void)
+{
+	crypto_unregister_shash(&ghash_alg);
+}
+
+module_init(ghash_mod_init);
+module_exit(ghash_mod_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("GHASH Message Digest Algorithm");
+MODULE_ALIAS("ghash");
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -419,6 +419,13 @@ config CRYPTO_WP512
 	  See also:
 	  <http://planeta.terra.com.br/informatica/paulobarreto/WhirlpoolPage.html>
 
+config CRYPTO_GHASH
+	tristate "GHASH digest algorithm"
+	select CRYPTO_SHASH
+	select CRYPTO_GF128MUL
+	help
+	  GHASH is message digest algorithm for GCM (Galois/Counter Mode).
+
 comment "Ciphers"
 
 config CRYPTO_AES
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -83,6 +83,8 @@ obj-$(CONFIG_CRYPTO_RNG2) += rng.o
 obj-$(CONFIG_CRYPTO_RNG2) += krng.o
 obj-$(CONFIG_CRYPTO_ANSI_CPRNG) += ansi_cprng.o
 obj-$(CONFIG_CRYPTO_TEST) += tcrypt.o
+obj-$(CONFIG_CRYPTO_MD5) += md5.o
+obj-$(CONFIG_CRYPTO_GHASH) += ghash-generic.o
 
 #
 # generic algorithms and the async_tx api


