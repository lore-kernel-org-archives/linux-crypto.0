From: jang@linux.vnet.ibm.com
Subject: [PATCH 5/8] s390: add System z hardware support for GHASH
Date: Tue, 19 Apr 2011 21:29:18 +0200
Message-ID: <20110419193248.955757766@linux.vnet.ibm.com>
References: <20110419192913.888086020@linux.vnet.ibm.com>
Cc: linux-crypto@vger.kernel.org,
	Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:54710 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893Ab1DSTeB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Apr 2011 15:34:01 -0400
Received: from d06nrmr1507.portsmouth.uk.ibm.com (d06nrmr1507.portsmouth.uk.ibm.com [9.149.38.233])
	by mtagate5.uk.ibm.com (8.13.1/8.13.1) with ESMTP id p3JJXxsB022975
	for <linux-crypto@vger.kernel.org>; Tue, 19 Apr 2011 19:33:59 GMT
Received: from d06av04.portsmouth.uk.ibm.com (d06av04.portsmouth.uk.ibm.com [9.149.37.216])
	by d06nrmr1507.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p3JJYtSf1794216
	for <linux-crypto@vger.kernel.org>; Tue, 19 Apr 2011 20:34:55 +0100
Received: from d06av04.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av04.portsmouth.uk.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p3JJXxSA028431
	for <linux-crypto@vger.kernel.org>; Tue, 19 Apr 2011 13:33:59 -0600
Content-Disposition: inline; filename=crypto-ghash.patch
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Gerald Schaefer <gerald.schaefer@de.ibm.com>

This patch adds System z hardware acceleration support for the GHASH
algorithm for GCM (Galois/Counter Mode).
The hardware support is available beginning with System z196.

Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>
Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
---
 arch/s390/crypto/Makefile     |    1 
 arch/s390/crypto/crypt_s390.h |    1 
 arch/s390/crypto/ghash_s390.c |  162 ++++++++++++++++++++++++++++++++++++++++++
 drivers/crypto/Kconfig        |   10 ++
 4 files changed, 174 insertions(+)

--- a/arch/s390/crypto/Makefile
+++ b/arch/s390/crypto/Makefile
@@ -8,3 +8,4 @@ obj-$(CONFIG_CRYPTO_SHA512_S390) += sha5
 obj-$(CONFIG_CRYPTO_DES_S390) += des_s390.o
 obj-$(CONFIG_CRYPTO_AES_S390) += aes_s390.o
 obj-$(CONFIG_S390_PRNG) += prng.o
+obj-$(CONFIG_CRYPTO_GHASH_S390) += ghash_s390.o
--- a/arch/s390/crypto/crypt_s390.h
+++ b/arch/s390/crypto/crypt_s390.h
@@ -112,6 +112,7 @@ enum crypt_s390_kimd_func {
 	KIMD_SHA_1   = CRYPT_S390_KIMD | 1,
 	KIMD_SHA_256 = CRYPT_S390_KIMD | 2,
 	KIMD_SHA_512 = CRYPT_S390_KIMD | 3,
+	KIMD_GHASH   = CRYPT_S390_KIMD | 65,
 };
 
 /*
--- /dev/null
+++ b/arch/s390/crypto/ghash_s390.c
@@ -0,0 +1,162 @@
+/*
+ * Cryptographic API.
+ *
+ * s390 implementation of the GHASH algorithm for GCM (Galois/Counter Mode).
+ *
+ * Copyright IBM Corp. 2011
+ * Author(s): Gerald Schaefer <gerald.schaefer@de.ibm.com>
+ */
+
+#include <crypto/internal/hash.h>
+#include <linux/module.h>
+
+#include "crypt_s390.h"
+
+#define GHASH_BLOCK_SIZE	16
+#define GHASH_DIGEST_SIZE	16
+
+struct ghash_ctx {
+	u8 icv[16];
+	u8 key[16];
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
+	memcpy(ctx->key, key, GHASH_BLOCK_SIZE);
+	memset(ctx->icv, 0, GHASH_BLOCK_SIZE);
+
+	return 0;
+}
+
+static int ghash_update(struct shash_desc *desc,
+			 const u8 *src, unsigned int srclen)
+{
+	struct ghash_desc_ctx *dctx = shash_desc_ctx(desc);
+	struct ghash_ctx *ctx = crypto_shash_ctx(desc->tfm);
+	unsigned int n;
+	u8 *buf = dctx->buffer;
+	int ret;
+
+	if (dctx->bytes) {
+		u8 *pos = buf + (GHASH_BLOCK_SIZE - dctx->bytes);
+
+		n = min(srclen, dctx->bytes);
+		dctx->bytes -= n;
+		srclen -= n;
+
+		memcpy(pos, src, n);
+		src += n;
+
+		if (!dctx->bytes) {
+			ret = crypt_s390_kimd(KIMD_GHASH, ctx, buf,
+					      GHASH_BLOCK_SIZE);
+			BUG_ON(ret != GHASH_BLOCK_SIZE);
+		}
+	}
+
+	n = srclen & ~(GHASH_BLOCK_SIZE - 1);
+	if (n) {
+		ret = crypt_s390_kimd(KIMD_GHASH, ctx, src, n);
+		BUG_ON(ret != n);
+		src += n;
+		srclen -= n;
+	}
+
+	if (srclen) {
+		dctx->bytes = GHASH_BLOCK_SIZE - srclen;
+		memcpy(buf, src, srclen);
+	}
+
+	return 0;
+}
+
+static void ghash_flush(struct ghash_ctx *ctx, struct ghash_desc_ctx *dctx)
+{
+	u8 *buf = dctx->buffer;
+	int ret;
+
+	if (dctx->bytes) {
+		u8 *pos = buf + (GHASH_BLOCK_SIZE - dctx->bytes);
+
+		memset(pos, 0, dctx->bytes);
+
+		ret = crypt_s390_kimd(KIMD_GHASH, ctx, buf, GHASH_BLOCK_SIZE);
+		BUG_ON(ret != GHASH_BLOCK_SIZE);
+	}
+
+	dctx->bytes = 0;
+}
+
+static int ghash_final(struct shash_desc *desc, u8 *dst)
+{
+	struct ghash_desc_ctx *dctx = shash_desc_ctx(desc);
+	struct ghash_ctx *ctx = crypto_shash_ctx(desc->tfm);
+
+	ghash_flush(ctx, dctx);
+	memcpy(dst, ctx->icv, GHASH_BLOCK_SIZE);
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
+		.cra_name		= "ghash",
+		.cra_driver_name	= "ghash-s390",
+		.cra_priority		= CRYPT_S390_PRIORITY,
+		.cra_flags		= CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize		= GHASH_BLOCK_SIZE,
+		.cra_ctxsize		= sizeof(struct ghash_ctx),
+		.cra_module		= THIS_MODULE,
+		.cra_list		= LIST_HEAD_INIT(ghash_alg.base.cra_list),
+	},
+};
+
+static int __init ghash_mod_init(void)
+{
+	if (!crypt_s390_func_available(KIMD_GHASH,
+				       CRYPT_S390_MSA | CRYPT_S390_MSA4))
+		return -EOPNOTSUPP;
+
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
+MODULE_ALIAS("ghash");
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("GHASH Message Digest Algorithm, s390 implementation");
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -154,6 +154,16 @@ config S390_PRNG
 	  ANSI X9.17 standard. The PRNG is usable via the char device
 	  /dev/prandom.
 
+config CRYPTO_GHASH_S390
+	tristate "GHASH digest algorithm"
+	depends on S390
+	select CRYPTO_HASH
+	help
+	  This is the s390 hardware accelerated implementation of the
+	  GHASH message digest algorithm for GCM (Galois/Counter Mode).
+
+	  It is available as of z196.
+
 config CRYPTO_DEV_MV_CESA
 	tristate "Marvell's Cryptographic Engine"
 	depends on PLAT_ORION

-- 
