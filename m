From: Dan Streetman <ddstreet@ieee.org>
Subject: [PATCH 6/8] crypto: nx - merge nx-compress and nx-compress-crypto
Date: Wed, 22 Jul 2015 14:26:36 -0400
Message-ID: <1437589598-23917-7-git-send-email-ddstreet@ieee.org>
References: <1437589598-23917-1-git-send-email-ddstreet@ieee.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Dan Streetman <ddstreet@ieee.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1437589598-23917-1-git-send-email-ddstreet@ieee.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Merge the nx-842.c code into nx-842-crypto.c.

This allows later patches to remove the 'platform' driver, and instead
allow each platform driver to directly register with the crypto
compression api.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
---
 drivers/crypto/nx/Kconfig         |  17 ++-----
 drivers/crypto/nx/Makefile        |   4 +-
 drivers/crypto/nx/nx-842-crypto.c |  70 +++++++++++++-------------
 drivers/crypto/nx/nx-842.c        | 103 --------------------------------------
 drivers/crypto/nx/nx-842.h        |  28 +++++++----
 5 files changed, 60 insertions(+), 162 deletions(-)
 delete mode 100644 drivers/crypto/nx/nx-842.c

diff --git a/drivers/crypto/nx/Kconfig b/drivers/crypto/nx/Kconfig
index e421c96..ad7552a 100644
--- a/drivers/crypto/nx/Kconfig
+++ b/drivers/crypto/nx/Kconfig
@@ -14,11 +14,14 @@ config CRYPTO_DEV_NX_ENCRYPT
 config CRYPTO_DEV_NX_COMPRESS
 	tristate "Compression acceleration support"
 	default y
+	select CRYPTO_ALGAPI
+	select 842_DECOMPRESS
 	help
 	  Support for PowerPC Nest (NX) compression acceleration. This
 	  module supports acceleration for compressing memory with the 842
-	  algorithm.  One of the platform drivers must be selected also.
-	  If you choose 'M' here, this module will be called nx_compress.
+	  algorithm using the cryptographic API.  One of the platform
+	  drivers must be selected also.  If you choose 'M' here, this
+	  module will be called nx_compress.
 
 if CRYPTO_DEV_NX_COMPRESS
 
@@ -42,14 +45,4 @@ config CRYPTO_DEV_NX_COMPRESS_POWERNV
 	  algorithm.  This supports NX hardware on the PowerNV platform.
 	  If you choose 'M' here, this module will be called nx_compress_powernv.
 
-config CRYPTO_DEV_NX_COMPRESS_CRYPTO
-	tristate "Compression acceleration cryptographic interface"
-	select CRYPTO_ALGAPI
-	select 842_DECOMPRESS
-	default y
-	help
-	  Support for PowerPC Nest (NX) accelerators using the cryptographic
-	  API.  If you choose 'M' here, this module will be called
-	  nx_compress_crypto.
-
 endif
diff --git a/drivers/crypto/nx/Makefile b/drivers/crypto/nx/Makefile
index e1684f5..e29ee85 100644
--- a/drivers/crypto/nx/Makefile
+++ b/drivers/crypto/nx/Makefile
@@ -13,9 +13,7 @@ nx-crypto-objs := nx.o \
 obj-$(CONFIG_CRYPTO_DEV_NX_COMPRESS) += nx-compress.o nx-compress-platform.o
 obj-$(CONFIG_CRYPTO_DEV_NX_COMPRESS_PSERIES) += nx-compress-pseries.o
 obj-$(CONFIG_CRYPTO_DEV_NX_COMPRESS_POWERNV) += nx-compress-powernv.o
-obj-$(CONFIG_CRYPTO_DEV_NX_COMPRESS_CRYPTO) += nx-compress-crypto.o
-nx-compress-objs := nx-842.o
+nx-compress-objs := nx-842-crypto.o
 nx-compress-platform-objs := nx-842-platform.o
 nx-compress-pseries-objs := nx-842-pseries.o
 nx-compress-powernv-objs := nx-842-powernv.o
-nx-compress-crypto-objs := nx-842-crypto.o
diff --git a/drivers/crypto/nx/nx-842-crypto.c b/drivers/crypto/nx/nx-842-crypto.c
index 51ca168..4472e20 100644
--- a/drivers/crypto/nx/nx-842-crypto.c
+++ b/drivers/crypto/nx/nx-842-crypto.c
@@ -13,6 +13,9 @@
  *
  * Copyright (C) IBM Corporation, 2011-2015
  *
+ * Designer of the Power data compression engine:
+ *   Bulent Abali <abali@us.ibm.com>
+ *
  * Original Authors: Robert Jennings <rcj@linux.vnet.ibm.com>
  *                   Seth Jennings <sjenning@linux.vnet.ibm.com>
  *
@@ -162,24 +165,11 @@ static void nx842_crypto_exit(struct crypto_tfm *tfm)
 	free_page((unsigned long)ctx->dbounce);
 }
 
-static int read_constraints(struct nx842_constraints *c)
+static void check_constraints(struct nx842_constraints *c)
 {
-	int ret;
-
-	ret = nx842_constraints(c);
-	if (ret) {
-		pr_err_ratelimited("could not get nx842 constraints : %d\n",
-				   ret);
-		return ret;
-	}
-
 	/* limit maximum, to always have enough bounce buffer to decompress */
-	if (c->maximum > BOUNCE_BUFFER_SIZE) {
+	if (c->maximum > BOUNCE_BUFFER_SIZE)
 		c->maximum = BOUNCE_BUFFER_SIZE;
-		pr_info_once("limiting nx842 maximum to %x\n", c->maximum);
-	}
-
-	return 0;
 }
 
 static int nx842_crypto_add_header(struct nx842_crypto_header *hdr, u8 *buf)
@@ -260,7 +250,9 @@ nospc:
 	timeout = ktime_add_ms(ktime_get(), COMP_BUSY_TIMEOUT);
 	do {
 		dlen = tmplen; /* reset dlen, if we're retrying */
-		ret = nx842_compress(src, slen, dst, &dlen, ctx->wmem);
+		ret = nx842_platform_driver()->compress(src, slen,
+							dst, &dlen,
+							ctx->wmem);
 		/* possibly we should reduce the slen here, instead of
 		 * retrying with the dbounce buffer?
 		 */
@@ -297,12 +289,14 @@ static int nx842_crypto_compress(struct crypto_tfm *tfm,
 	struct nx842_crypto_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct nx842_crypto_header *hdr = &ctx->header;
 	struct nx842_crypto_param p;
-	struct nx842_constraints c;
+	struct nx842_constraints c = *nx842_platform_driver()->constraints;
 	unsigned int groups, hdrsize, h;
 	int ret, n;
 	bool add_header;
 	u16 ignore = 0;
 
+	check_constraints(&c);
+
 	p.in = (u8 *)src;
 	p.iremain = slen;
 	p.out = dst;
@@ -311,10 +305,6 @@ static int nx842_crypto_compress(struct crypto_tfm *tfm,
 
 	*dlen = 0;
 
-	ret = read_constraints(&c);
-	if (ret)
-		return ret;
-
 	groups = min_t(unsigned int, NX842_CRYPTO_GROUP_MAX,
 		       DIV_ROUND_UP(p.iremain, c.maximum));
 	hdrsize = NX842_CRYPTO_HEADER_SIZE(groups);
@@ -381,8 +371,7 @@ static int decompress(struct nx842_crypto_ctx *ctx,
 		      struct nx842_crypto_param *p,
 		      struct nx842_crypto_header_group *g,
 		      struct nx842_constraints *c,
-		      u16 ignore,
-		      bool usehw)
+		      u16 ignore)
 {
 	unsigned int slen = be32_to_cpu(g->compressed_length);
 	unsigned int required_len = be32_to_cpu(g->uncompressed_length);
@@ -404,9 +393,6 @@ static int decompress(struct nx842_crypto_ctx *ctx,
 
 	src += padding;
 
-	if (!usehw)
-		goto usesw;
-
 	if (slen % c->multiple)
 		adj_slen = round_up(slen, c->multiple);
 	if (slen < c->minimum)
@@ -443,7 +429,9 @@ static int decompress(struct nx842_crypto_ctx *ctx,
 	timeout = ktime_add_ms(ktime_get(), DECOMP_BUSY_TIMEOUT);
 	do {
 		dlen = tmplen; /* reset dlen, if we're retrying */
-		ret = nx842_decompress(src, slen, dst, &dlen, ctx->wmem);
+		ret = nx842_platform_driver()->decompress(src, slen,
+							  dst, &dlen,
+							  ctx->wmem);
 	} while (ret == -EBUSY && ktime_before(ktime_get(), timeout));
 	if (ret) {
 usesw:
@@ -486,10 +474,11 @@ static int nx842_crypto_decompress(struct crypto_tfm *tfm,
 	struct nx842_crypto_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct nx842_crypto_header *hdr;
 	struct nx842_crypto_param p;
-	struct nx842_constraints c;
+	struct nx842_constraints c = *nx842_platform_driver()->constraints;
 	int n, ret, hdr_len;
 	u16 ignore = 0;
-	bool usehw = true;
+
+	check_constraints(&c);
 
 	p.in = (u8 *)src;
 	p.iremain = slen;
@@ -499,9 +488,6 @@ static int nx842_crypto_decompress(struct crypto_tfm *tfm,
 
 	*dlen = 0;
 
-	if (read_constraints(&c))
-		usehw = false;
-
 	hdr = (struct nx842_crypto_header *)src;
 
 	spin_lock_bh(&ctx->lock);
@@ -516,7 +502,7 @@ static int nx842_crypto_decompress(struct crypto_tfm *tfm,
 			.uncompressed_length =	cpu_to_be32(p.oremain),
 		};
 
-		ret = decompress(ctx, &p, &g, &c, 0, usehw);
+		ret = decompress(ctx, &p, &g, &c, 0);
 		if (ret)
 			goto unlock;
 
@@ -549,7 +535,7 @@ static int nx842_crypto_decompress(struct crypto_tfm *tfm,
 		if (n + 1 == hdr->groups)
 			ignore = be16_to_cpu(hdr->ignore);
 
-		ret = decompress(ctx, &p, &hdr->group[n], &c, ignore, usehw);
+		ret = decompress(ctx, &p, &hdr->group[n], &c, ignore);
 		if (ret)
 			goto unlock;
 	}
@@ -583,6 +569,18 @@ static struct crypto_alg alg = {
 
 static int __init nx842_crypto_mod_init(void)
 {
+	request_module("nx-compress-powernv");
+	request_module("nx-compress-pseries");
+
+	/* we prevent loading/registering if there's no platform driver,
+	 * and we get the platform module that set it so it won't unload,
+	 * so we don't need to check if it's set in any of our functions
+	 */
+	if (!nx842_platform_driver_get()) {
+		pr_err("no nx842 platform driver found.\n");
+		return -ENODEV;
+	}
+
 	return crypto_register_alg(&alg);
 }
 module_init(nx842_crypto_mod_init);
@@ -590,11 +588,13 @@ module_init(nx842_crypto_mod_init);
 static void __exit nx842_crypto_mod_exit(void)
 {
 	crypto_unregister_alg(&alg);
+
+	nx842_platform_driver_put();
 }
 module_exit(nx842_crypto_mod_exit);
 
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("IBM PowerPC Nest (NX) 842 Hardware Compression Interface");
+MODULE_DESCRIPTION("IBM PowerPC Nest (NX) 842 Hardware Compression Driver");
 MODULE_ALIAS_CRYPTO("842");
 MODULE_ALIAS_CRYPTO("842-nx");
 MODULE_AUTHOR("Dan Streetman <ddstreet@ieee.org>");
diff --git a/drivers/crypto/nx/nx-842.c b/drivers/crypto/nx/nx-842.c
deleted file mode 100644
index 6e5e0d6..0000000
--- a/drivers/crypto/nx/nx-842.c
+++ /dev/null
@@ -1,103 +0,0 @@
-/*
- * Driver frontend for IBM Power 842 compression accelerator
- *
- * Copyright (C) 2015 Dan Streetman, IBM Corp
- *
- * Designer of the Power data compression engine:
- *   Bulent Abali <abali@us.ibm.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#include "nx-842.h"
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Dan Streetman <ddstreet@ieee.org>");
-MODULE_DESCRIPTION("842 H/W Compression driver for IBM Power processors");
-
-/**
- * nx842_constraints
- *
- * This provides the driver's constraints.  Different nx842 implementations
- * may have varying requirements.  The constraints are:
- *   @alignment:	All buffers should be aligned to this
- *   @multiple:		All buffer lengths should be a multiple of this
- *   @minimum:		Buffer lengths must not be less than this amount
- *   @maximum:		Buffer lengths must not be more than this amount
- *
- * The constraints apply to all buffers and lengths, both input and output,
- * for both compression and decompression, except for the minimum which
- * only applies to compression input and decompression output; the
- * compressed data can be less than the minimum constraint.  It can be
- * assumed that compressed data will always adhere to the multiple
- * constraint.
- *
- * The driver may succeed even if these constraints are violated;
- * however the driver can return failure or suffer reduced performance
- * if any constraint is not met.
- */
-int nx842_constraints(struct nx842_constraints *c)
-{
-	memcpy(c, nx842_platform_driver()->constraints, sizeof(*c));
-	return 0;
-}
-EXPORT_SYMBOL_GPL(nx842_constraints);
-
-/**
- * nx842_workmem_size
- *
- * Get the amount of working memory the driver requires.
- */
-size_t nx842_workmem_size(void)
-{
-	return nx842_platform_driver()->workmem_size;
-}
-EXPORT_SYMBOL_GPL(nx842_workmem_size);
-
-int nx842_compress(const unsigned char *in, unsigned int ilen,
-		   unsigned char *out, unsigned int *olen, void *wmem)
-{
-	return nx842_platform_driver()->compress(in, ilen, out, olen, wmem);
-}
-EXPORT_SYMBOL_GPL(nx842_compress);
-
-int nx842_decompress(const unsigned char *in, unsigned int ilen,
-		     unsigned char *out, unsigned int *olen, void *wmem)
-{
-	return nx842_platform_driver()->decompress(in, ilen, out, olen, wmem);
-}
-EXPORT_SYMBOL_GPL(nx842_decompress);
-
-static __init int nx842_init(void)
-{
-	request_module("nx-compress-powernv");
-	request_module("nx-compress-pseries");
-
-	/* we prevent loading if there's no platform driver, and we get the
-	 * module that set it so it won't unload, so we don't need to check
-	 * if it's set in any of the above functions
-	 */
-	if (!nx842_platform_driver_get()) {
-		pr_err("no nx842 driver found.\n");
-		return -ENODEV;
-	}
-
-	return 0;
-}
-module_init(nx842_init);
-
-static void __exit nx842_exit(void)
-{
-	nx842_platform_driver_put();
-}
-module_exit(nx842_exit);
diff --git a/drivers/crypto/nx/nx-842.h b/drivers/crypto/nx/nx-842.h
index ac0ea79..c7dd0a4 100644
--- a/drivers/crypto/nx/nx-842.h
+++ b/drivers/crypto/nx/nx-842.h
@@ -104,6 +104,25 @@ static inline unsigned long nx842_get_pa(void *addr)
 #define GET_FIELD(v, m)		(((v) & (m)) >> MASK_LSH(m))
 #define SET_FIELD(v, m, val)	(((v) & ~(m)) | (((val) << MASK_LSH(m)) & (m)))
 
+/**
+ * This provides the driver's constraints.  Different nx842 implementations
+ * may have varying requirements.  The constraints are:
+ *   @alignment:	All buffers should be aligned to this
+ *   @multiple:		All buffer lengths should be a multiple of this
+ *   @minimum:		Buffer lengths must not be less than this amount
+ *   @maximum:		Buffer lengths must not be more than this amount
+ *
+ * The constraints apply to all buffers and lengths, both input and output,
+ * for both compression and decompression, except for the minimum which
+ * only applies to compression input and decompression output; the
+ * compressed data can be less than the minimum constraint.  It can be
+ * assumed that compressed data will always adhere to the multiple
+ * constraint.
+ *
+ * The driver may succeed even if these constraints are violated;
+ * however the driver can return failure or suffer reduced performance
+ * if any constraint is not met.
+ */
 struct nx842_constraints {
 	int alignment;
 	int multiple;
@@ -132,13 +151,4 @@ void nx842_platform_driver_unset(struct nx842_driver *driver);
 bool nx842_platform_driver_get(void);
 void nx842_platform_driver_put(void);
 
-size_t nx842_workmem_size(void);
-
-int nx842_constraints(struct nx842_constraints *constraints);
-
-int nx842_compress(const unsigned char *in, unsigned int in_len,
-		   unsigned char *out, unsigned int *out_len, void *wrkmem);
-int nx842_decompress(const unsigned char *in, unsigned int in_len,
-		     unsigned char *out, unsigned int *out_len, void *wrkmem);
-
 #endif /* __NX_842_H__ */
-- 
2.1.0
