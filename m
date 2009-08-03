From: Huang Ying <ying.huang@intel.com>
Subject: [PATCH -v2 1/5] crypto: Add GHASH digest algorithm for GCM
Date: Mon,  3 Aug 2009 15:45:27 +0800
Message-ID: <1249285531-22422-1-git-send-email-ying.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Huang Ying <ying.huang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:6657 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752660AbZHCHpe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 3 Aug 2009 03:45:34 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

GHASH is implemented as a shash algorithm. The actual implementation
is copied from gcm.c. This makes it possible to add
architecture/hardware accelerated GHASH implementation.

v2:
 - Fix a bug in Makefile (Thanks Sebastian)
 - Some other minor fixes

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 crypto/Kconfig         |    7 ++
 crypto/Makefile        |    1 +
 crypto/ghash-generic.c |  170 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 178 insertions(+), 0 deletions(-)
 create mode 100644 crypto/ghash-generic.c

diff --git a/crypto/Kconfig b/crypto/Kconfig
index f2002d8..0ae170e 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -290,6 +290,13 @@ config CRYPTO_CRC32C_INTEL
 	  gain performance compared with software implementation.
 	  Module will be crc32c-intel.
 
+config CRYPTO_GHASH
+	tristate "GHASH digest algorithm"
+	select CRYPTO_SHASH
+	select CRYPTO_GF128MUL
+	help
+	  GHASH is message digest algorithm for GCM (Galois/Counter Mode).
+
 config CRYPTO_MD4
 	tristate "MD4 digest algorithm"
 	select CRYPTO_HASH
diff --git a/crypto/Makefile b/crypto/Makefile
index 3c961b4..c2ca721 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -82,6 +82,7 @@ obj-$(CONFIG_CRYPTO_RNG2) += rng.o
 obj-$(CONFIG_CRYPTO_RNG2) += krng.o
 obj-$(CONFIG_CRYPTO_ANSI_CPRNG) += ansi_cprng.o
 obj-$(CONFIG_CRYPTO_TEST) += tcrypt.o
+obj-$(CONFIG_CRYPTO_GHASH) += ghash-generic.o
 
 #
 # generic algorithms and the async_tx api
diff --git a/crypto/ghash-generic.c b/crypto/ghash-generic.c
new file mode 100644
index 0000000..be44256
--- /dev/null
+++ b/crypto/ghash-generic.c
@@ -0,0 +1,170 @@
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
+#include <crypto/algapi.h>
+#include <crypto/gf128mul.h>
+#include <crypto/internal/hash.h>
+#include <linux/crypto.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#define GHASH_BLOCK_SIZE	16
+#define GHASH_DIGEST_SIZE	16
+
+struct ghash_ctx {
+	struct gf128mul_4k *gf128;
+};
+
+struct ghash_desc_ctx {
+	u8 buffer[GHASH_BLOCK_SIZE];
+	u32 bytes;
+};
+
+static int ghash_init(struct shash_desc *desc)
+{
+	struct ghash_desc_ctx *dctx = shash_desc_ctx(desc);
+
+	memset(dctx, 0, sizeof(*dctx));
+
+	return 0;
+}
+
+static int ghash_setkey(struct crypto_shash *tfm,
+			const u8 *key, unsigned int keylen)
+{
+	struct ghash_ctx *ctx = crypto_shash_ctx(tfm);
+
+	if (keylen != GHASH_BLOCK_SIZE) {
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
+		u8 *pos = dst + (GHASH_BLOCK_SIZE - dctx->bytes);
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
+	while (srclen >= GHASH_BLOCK_SIZE) {
+		crypto_xor(dst, src, GHASH_BLOCK_SIZE);
+		gf128mul_4k_lle((be128 *)dst, ctx->gf128);
+		src += GHASH_BLOCK_SIZE;
+		srclen -= GHASH_BLOCK_SIZE;
+	}
+
+	if (srclen) {
+		dctx->bytes = GHASH_BLOCK_SIZE - srclen;
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
+		u8 *tmp = dst + (GHASH_BLOCK_SIZE - dctx->bytes);
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
+	memcpy(dst, buf, GHASH_BLOCK_SIZE);
+
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
-- 
1.6.3.3

