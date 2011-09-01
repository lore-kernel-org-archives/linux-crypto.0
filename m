From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [[RFC] PATCH 2/4] crypto: blowfish: rename C-version to
	blowfish_generic
Date: Fri, 02 Sep 2011 01:45:12 +0300
Message-ID: <20110901224512.7795.15984.stgit@localhost6.localdomain6>
References: <20110901224506.7795.35128.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:48846 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932501Ab1IAWxt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 1 Sep 2011 18:53:49 -0400
In-Reply-To: <20110901224506.7795.35128.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Rename blowfish to blowfish_generic so that assembler versions of blowfish
cipher can autoload. Module alias 'blowfish' is added.

Also fix checkpatch warnings.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/Makefile           |    2 -
 crypto/blowfish.c         |  139 --------------------------------------------
 crypto/blowfish_generic.c |  142 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 143 insertions(+), 140 deletions(-)
 delete mode 100644 crypto/blowfish.c
 create mode 100644 crypto/blowfish_generic.c

diff --git a/crypto/Makefile b/crypto/Makefile
index 495b791..fa8cbbb 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -60,7 +60,7 @@ obj-$(CONFIG_CRYPTO_PCRYPT) += pcrypt.o
 obj-$(CONFIG_CRYPTO_CRYPTD) += cryptd.o
 obj-$(CONFIG_CRYPTO_DES) += des_generic.o
 obj-$(CONFIG_CRYPTO_FCRYPT) += fcrypt.o
-obj-$(CONFIG_CRYPTO_BLOWFISH) += blowfish.o
+obj-$(CONFIG_CRYPTO_BLOWFISH) += blowfish_generic.o
 obj-$(CONFIG_CRYPTO_BLOWFISH_COMMON) += blowfish_common.o
 obj-$(CONFIG_CRYPTO_TWOFISH) += twofish_generic.o
 obj-$(CONFIG_CRYPTO_TWOFISH_COMMON) += twofish_common.o
diff --git a/crypto/blowfish.c b/crypto/blowfish.c
deleted file mode 100644
index 0f86d31..0000000
--- a/crypto/blowfish.c
+++ /dev/null
@@ -1,139 +0,0 @@
-/*
- * Cryptographic API.
- *
- * Blowfish Cipher Algorithm, by Bruce Schneier.
- * http://www.counterpane.com/blowfish.html
- *
- * Adapted from Kerneli implementation.
- *
- * Copyright (c) Herbert Valerio Riedel <hvr@hvrlab.org>
- * Copyright (c) Kyle McMartin <kyle@debian.org>
- * Copyright (c) 2002 James Morris <jmorris@intercode.com.au>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- */
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/mm.h>
-#include <asm/byteorder.h>
-#include <linux/crypto.h>
-#include <linux/types.h>
-#include <crypto/blowfish.h>
-
-/*
- * Round loop unrolling macros, S is a pointer to a S-Box array
- * organized in 4 unsigned longs at a row.
- */
-#define GET32_3(x) (((x) & 0xff))
-#define GET32_2(x) (((x) >> (8)) & (0xff))
-#define GET32_1(x) (((x) >> (16)) & (0xff))
-#define GET32_0(x) (((x) >> (24)) & (0xff))
-
-#define bf_F(x) (((S[GET32_0(x)] + S[256 + GET32_1(x)]) ^ \
-          S[512 + GET32_2(x)]) + S[768 + GET32_3(x)])
-
-#define ROUND(a, b, n)  b ^= P[n]; a ^= bf_F (b)
-
-static void bf_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
-{
-	struct bf_ctx *ctx = crypto_tfm_ctx(tfm);
-	const __be32 *in_blk = (const __be32 *)src;
-	__be32 *const out_blk = (__be32 *)dst;
-	const u32 *P = ctx->p;
-	const u32 *S = ctx->s;
-	u32 yl = be32_to_cpu(in_blk[0]);
-	u32 yr = be32_to_cpu(in_blk[1]);
-
-	ROUND(yr, yl, 0);
-	ROUND(yl, yr, 1);
-	ROUND(yr, yl, 2);
-	ROUND(yl, yr, 3);
-	ROUND(yr, yl, 4);
-	ROUND(yl, yr, 5);
-	ROUND(yr, yl, 6);
-	ROUND(yl, yr, 7);
-	ROUND(yr, yl, 8);
-	ROUND(yl, yr, 9);
-	ROUND(yr, yl, 10);
-	ROUND(yl, yr, 11);
-	ROUND(yr, yl, 12);
-	ROUND(yl, yr, 13);
-	ROUND(yr, yl, 14);
-	ROUND(yl, yr, 15);
-
-	yl ^= P[16];
-	yr ^= P[17];
-
-	out_blk[0] = cpu_to_be32(yr);
-	out_blk[1] = cpu_to_be32(yl);
-}
-
-static void bf_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
-{
-	struct bf_ctx *ctx = crypto_tfm_ctx(tfm);
-	const __be32 *in_blk = (const __be32 *)src;
-	__be32 *const out_blk = (__be32 *)dst;
-	const u32 *P = ctx->p;
-	const u32 *S = ctx->s;
-	u32 yl = be32_to_cpu(in_blk[0]);
-	u32 yr = be32_to_cpu(in_blk[1]);
-
-	ROUND(yr, yl, 17);
-	ROUND(yl, yr, 16);
-	ROUND(yr, yl, 15);
-	ROUND(yl, yr, 14);
-	ROUND(yr, yl, 13);
-	ROUND(yl, yr, 12);
-	ROUND(yr, yl, 11);
-	ROUND(yl, yr, 10);
-	ROUND(yr, yl, 9);
-	ROUND(yl, yr, 8);
-	ROUND(yr, yl, 7);
-	ROUND(yl, yr, 6);
-	ROUND(yr, yl, 5);
-	ROUND(yl, yr, 4);
-	ROUND(yr, yl, 3);
-	ROUND(yl, yr, 2);
-
-	yl ^= P[1];
-	yr ^= P[0];
-
-	out_blk[0] = cpu_to_be32(yr);
-	out_blk[1] = cpu_to_be32(yl);
-}
-
-static struct crypto_alg alg = {
-	.cra_name		=	"blowfish",
-	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
-	.cra_blocksize		=	BF_BLOCK_SIZE,
-	.cra_ctxsize		=	sizeof(struct bf_ctx),
-	.cra_alignmask		=	3,
-	.cra_module		=	THIS_MODULE,
-	.cra_list		=	LIST_HEAD_INIT(alg.cra_list),
-	.cra_u			=	{ .cipher = {
-	.cia_min_keysize	=	BF_MIN_KEY_SIZE,
-	.cia_max_keysize	=	BF_MAX_KEY_SIZE,
-	.cia_setkey		=	blowfish_setkey,
-	.cia_encrypt 		=	bf_encrypt,
-	.cia_decrypt  		=	bf_decrypt } }
-};
-
-static int __init blowfish_mod_init(void)
-{
-	return crypto_register_alg(&alg);
-}
-
-static void __exit blowfish_mod_fini(void)
-{
-	crypto_unregister_alg(&alg);
-}
-
-module_init(blowfish_mod_init);
-module_exit(blowfish_mod_fini);
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Blowfish Cipher Algorithm");
diff --git a/crypto/blowfish_generic.c b/crypto/blowfish_generic.c
new file mode 100644
index 0000000..6f269b5
--- /dev/null
+++ b/crypto/blowfish_generic.c
@@ -0,0 +1,142 @@
+/*
+ * Cryptographic API.
+ *
+ * Blowfish Cipher Algorithm, by Bruce Schneier.
+ * http://www.counterpane.com/blowfish.html
+ *
+ * Adapted from Kerneli implementation.
+ *
+ * Copyright (c) Herbert Valerio Riedel <hvr@hvrlab.org>
+ * Copyright (c) Kyle McMartin <kyle@debian.org>
+ * Copyright (c) 2002 James Morris <jmorris@intercode.com.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/mm.h>
+#include <asm/byteorder.h>
+#include <linux/crypto.h>
+#include <linux/types.h>
+#include <crypto/blowfish.h>
+
+/*
+ * Round loop unrolling macros, S is a pointer to a S-Box array
+ * organized in 4 unsigned longs at a row.
+ */
+#define GET32_3(x) (((x) & 0xff))
+#define GET32_2(x) (((x) >> (8)) & (0xff))
+#define GET32_1(x) (((x) >> (16)) & (0xff))
+#define GET32_0(x) (((x) >> (24)) & (0xff))
+
+#define bf_F(x) (((S[GET32_0(x)] + S[256 + GET32_1(x)]) ^ \
+		S[512 + GET32_2(x)]) + S[768 + GET32_3(x)])
+
+#define ROUND(a, b, n) ({ b ^= P[n]; a ^= bf_F(b); })
+
+static void bf_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+{
+	struct bf_ctx *ctx = crypto_tfm_ctx(tfm);
+	const __be32 *in_blk = (const __be32 *)src;
+	__be32 *const out_blk = (__be32 *)dst;
+	const u32 *P = ctx->p;
+	const u32 *S = ctx->s;
+	u32 yl = be32_to_cpu(in_blk[0]);
+	u32 yr = be32_to_cpu(in_blk[1]);
+
+	ROUND(yr, yl, 0);
+	ROUND(yl, yr, 1);
+	ROUND(yr, yl, 2);
+	ROUND(yl, yr, 3);
+	ROUND(yr, yl, 4);
+	ROUND(yl, yr, 5);
+	ROUND(yr, yl, 6);
+	ROUND(yl, yr, 7);
+	ROUND(yr, yl, 8);
+	ROUND(yl, yr, 9);
+	ROUND(yr, yl, 10);
+	ROUND(yl, yr, 11);
+	ROUND(yr, yl, 12);
+	ROUND(yl, yr, 13);
+	ROUND(yr, yl, 14);
+	ROUND(yl, yr, 15);
+
+	yl ^= P[16];
+	yr ^= P[17];
+
+	out_blk[0] = cpu_to_be32(yr);
+	out_blk[1] = cpu_to_be32(yl);
+}
+
+static void bf_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+{
+	struct bf_ctx *ctx = crypto_tfm_ctx(tfm);
+	const __be32 *in_blk = (const __be32 *)src;
+	__be32 *const out_blk = (__be32 *)dst;
+	const u32 *P = ctx->p;
+	const u32 *S = ctx->s;
+	u32 yl = be32_to_cpu(in_blk[0]);
+	u32 yr = be32_to_cpu(in_blk[1]);
+
+	ROUND(yr, yl, 17);
+	ROUND(yl, yr, 16);
+	ROUND(yr, yl, 15);
+	ROUND(yl, yr, 14);
+	ROUND(yr, yl, 13);
+	ROUND(yl, yr, 12);
+	ROUND(yr, yl, 11);
+	ROUND(yl, yr, 10);
+	ROUND(yr, yl, 9);
+	ROUND(yl, yr, 8);
+	ROUND(yr, yl, 7);
+	ROUND(yl, yr, 6);
+	ROUND(yr, yl, 5);
+	ROUND(yl, yr, 4);
+	ROUND(yr, yl, 3);
+	ROUND(yl, yr, 2);
+
+	yl ^= P[1];
+	yr ^= P[0];
+
+	out_blk[0] = cpu_to_be32(yr);
+	out_blk[1] = cpu_to_be32(yl);
+}
+
+static struct crypto_alg alg = {
+	.cra_name		=	"blowfish",
+	.cra_driver_name	=	"blowfish-generic",
+	.cra_priority		=	100,
+	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
+	.cra_blocksize		=	BF_BLOCK_SIZE,
+	.cra_ctxsize		=	sizeof(struct bf_ctx),
+	.cra_alignmask		=	3,
+	.cra_module		=	THIS_MODULE,
+	.cra_list		=	LIST_HEAD_INIT(alg.cra_list),
+	.cra_u			=	{ .cipher = {
+	.cia_min_keysize	=	BF_MIN_KEY_SIZE,
+	.cia_max_keysize	=	BF_MAX_KEY_SIZE,
+	.cia_setkey		=	blowfish_setkey,
+	.cia_encrypt		=	bf_encrypt,
+	.cia_decrypt		=	bf_decrypt } }
+};
+
+static int __init blowfish_mod_init(void)
+{
+	return crypto_register_alg(&alg);
+}
+
+static void __exit blowfish_mod_fini(void)
+{
+	crypto_unregister_alg(&alg);
+}
+
+module_init(blowfish_mod_init);
+module_exit(blowfish_mod_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Blowfish Cipher Algorithm");
+MODULE_ALIAS("blowfish");
