From: Jan Glauber <jang@linux.vnet.ibm.com>
Subject: [PATCH 1/4] generic sha_update and sha_final for s390
Date: Mon, 03 Mar 2008 17:19:43 +0100
Message-ID: <1204561183.6025.51.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:59651 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504AbYCCQUB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 3 Mar 2008 11:20:01 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate2.de.ibm.com (8.13.8/8.13.8) with ESMTP id m23GJt35091382
	for <linux-crypto@vger.kernel.org>; Mon, 3 Mar 2008 16:19:55 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m23GJbjx1134806
	for <linux-crypto@vger.kernel.org>; Mon, 3 Mar 2008 17:19:38 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m23GJb5Q019640
	for <linux-crypto@vger.kernel.org>; Mon, 3 Mar 2008 16:19:37 GMT
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The sha_{update|final} functions are similar for every sha variant.
Since that is error-prone and redundant replace these functions by
a shared generic implementation for s390.

Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>
---
 arch/s390/crypto/Makefile      |    4 -
 arch/s390/crypto/sha.h         |   34 +++++++++++++++
 arch/s390/crypto/sha1_s390.c   |   91 ++---------------------------------------
 arch/s390/crypto/sha256_s390.c |   90 ++--------------------------------------
 arch/s390/crypto/sha_common.c  |   90 ++++++++++++++++++++++++++++++++++++++++
 5 files changed, 138 insertions(+), 171 deletions(-)

Index: cryptodev-2.6/arch/s390/crypto/Makefile
===================================================================
--- cryptodev-2.6.orig/arch/s390/crypto/Makefile
+++ cryptodev-2.6/arch/s390/crypto/Makefile
@@ -2,8 +2,8 @@
 # Cryptographic API
 #
 
-obj-$(CONFIG_CRYPTO_SHA1_S390) += sha1_s390.o
-obj-$(CONFIG_CRYPTO_SHA256_S390) += sha256_s390.o
+obj-$(CONFIG_CRYPTO_SHA1_S390) += sha1_s390.o sha_common.o
+obj-$(CONFIG_CRYPTO_SHA256_S390) += sha256_s390.o sha_common.o
 obj-$(CONFIG_CRYPTO_DES_S390) += des_s390.o des_check_key.o
 obj-$(CONFIG_CRYPTO_AES_S390) += aes_s390.o
 obj-$(CONFIG_S390_PRNG) += prng.o
Index: cryptodev-2.6/arch/s390/crypto/sha.h
===================================================================
--- /dev/null
+++ cryptodev-2.6/arch/s390/crypto/sha.h
@@ -0,0 +1,34 @@
+/*
+ * Cryptographic API.
+ *
+ * s390 generic implementation of the SHA Secure Hash Algorithms.
+ *
+ * Copyright IBM Corp. 2007
+ * Author(s): Jan Glauber (jang@de.ibm.com)
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+#ifndef _CRYPTO_ARCH_S390_SHA_H
+#define _CRYPTO_ARCH_S390_SHA_H
+
+#include <linux/crypto.h>
+#include <crypto/sha.h>
+
+/* must be big enough for the largest SHA variant */
+#define SHA_MAX_BLOCK_SIZE      SHA256_BLOCK_SIZE
+
+struct s390_sha_ctx {
+	u64 count;              /* message length in bytes */
+	u32 state[8];
+	u8 buf[2 * SHA_MAX_BLOCK_SIZE];
+	int func;		/* KIMD function to use */
+};
+
+void s390_sha_update(struct crypto_tfm *tfm, const u8 *data, unsigned int len);
+void s390_sha_final(struct crypto_tfm *tfm, u8 *out);
+
+#endif
Index: cryptodev-2.6/arch/s390/crypto/sha1_s390.c
===================================================================
--- cryptodev-2.6.orig/arch/s390/crypto/sha1_s390.c
+++ cryptodev-2.6/arch/s390/crypto/sha1_s390.c
@@ -29,16 +29,11 @@
 #include <crypto/sha.h>
 
 #include "crypt_s390.h"
-
-struct s390_sha1_ctx {
-	u64 count;		/* message length */
-	u32 state[5];
-	u8 buf[2 * SHA1_BLOCK_SIZE];
-};
+#include "sha.h"
 
 static void sha1_init(struct crypto_tfm *tfm)
 {
-	struct s390_sha1_ctx *sctx = crypto_tfm_ctx(tfm);
+	struct s390_sha_ctx *sctx = crypto_tfm_ctx(tfm);
 
 	sctx->state[0] = SHA1_H0;
 	sctx->state[1] = SHA1_H1;
@@ -46,79 +41,7 @@ static void sha1_init(struct crypto_tfm 
 	sctx->state[3] = SHA1_H3;
 	sctx->state[4] = SHA1_H4;
 	sctx->count = 0;
-}
-
-static void sha1_update(struct crypto_tfm *tfm, const u8 *data,
-			unsigned int len)
-{
-	struct s390_sha1_ctx *sctx = crypto_tfm_ctx(tfm);
-	unsigned int index;
-	int ret;
-
-	/* how much is already in the buffer? */
-	index = sctx->count & 0x3f;
-
-	sctx->count += len;
-
-	if (index + len < SHA1_BLOCK_SIZE)
-		goto store;
-
-	/* process one stored block */
-	if (index) {
-		memcpy(sctx->buf + index, data, SHA1_BLOCK_SIZE - index);
-		ret = crypt_s390_kimd(KIMD_SHA_1, sctx->state, sctx->buf,
-				      SHA1_BLOCK_SIZE);
-		BUG_ON(ret != SHA1_BLOCK_SIZE);
-		data += SHA1_BLOCK_SIZE - index;
-		len -= SHA1_BLOCK_SIZE - index;
-	}
-
-	/* process as many blocks as possible */
-	if (len >= SHA1_BLOCK_SIZE) {
-		ret = crypt_s390_kimd(KIMD_SHA_1, sctx->state, data,
-				      len & ~(SHA1_BLOCK_SIZE - 1));
-		BUG_ON(ret != (len & ~(SHA1_BLOCK_SIZE - 1)));
-		data += ret;
-		len -= ret;
-	}
-
-store:
-	/* anything left? */
-	if (len)
-		memcpy(sctx->buf + index , data, len);
-}
-
-/* Add padding and return the message digest. */
-static void sha1_final(struct crypto_tfm *tfm, u8 *out)
-{
-	struct s390_sha1_ctx *sctx = crypto_tfm_ctx(tfm);
-	u64 bits;
-	unsigned int index, end;
-	int ret;
-
-	/* must perform manual padding */
-	index = sctx->count & 0x3f;
-	end =  (index < 56) ? SHA1_BLOCK_SIZE : (2 * SHA1_BLOCK_SIZE);
-
-	/* start pad with 1 */
-	sctx->buf[index] = 0x80;
-
-	/* pad with zeros */
-	index++;
-	memset(sctx->buf + index, 0x00, end - index - 8);
-
-	/* append message length */
-	bits = sctx->count * 8;
-	memcpy(sctx->buf + end - 8, &bits, sizeof(bits));
-
-	ret = crypt_s390_kimd(KIMD_SHA_1, sctx->state, sctx->buf, end);
-	BUG_ON(ret != end);
-
-	/* copy digest to out */
-	memcpy(out, sctx->state, SHA1_DIGEST_SIZE);
-
-	/* wipe context */
-	memset(sctx, 0, sizeof *sctx);
+	sctx->func = KIMD_SHA_1;
 }
 
 static struct crypto_alg alg = {
@@ -127,21 +50,20 @@ static struct crypto_alg alg = {
 	.cra_priority	=	CRYPT_S390_PRIORITY,
 	.cra_flags	=	CRYPTO_ALG_TYPE_DIGEST,
 	.cra_blocksize	=	SHA1_BLOCK_SIZE,
-	.cra_ctxsize	=	sizeof(struct s390_sha1_ctx),
+	.cra_ctxsize	=	sizeof(struct s390_sha_ctx),
 	.cra_module	=	THIS_MODULE,
 	.cra_list	=	LIST_HEAD_INIT(alg.cra_list),
 	.cra_u		=	{ .digest = {
 	.dia_digestsize	=	SHA1_DIGEST_SIZE,
 	.dia_init	=	sha1_init,
-	.dia_update	=	sha1_update,
-	.dia_final	=	sha1_final } }
+	.dia_update	=	s390_sha_update,
+	.dia_final	=	s390_sha_final } }
 };
 
 static int __init init(void)
 {
 	if (!crypt_s390_func_available(KIMD_SHA_1))
 		return -EOPNOTSUPP;
-
 	return crypto_register_alg(&alg);
 }
 
@@ -154,6 +76,5 @@ module_init(init);
 module_exit(fini);
 
 MODULE_ALIAS("sha1");
-
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("SHA1 Secure Hash Algorithm");
Index: cryptodev-2.6/arch/s390/crypto/sha256_s390.c
===================================================================
--- cryptodev-2.6.orig/arch/s390/crypto/sha256_s390.c
+++ cryptodev-2.6/arch/s390/crypto/sha256_s390.c
@@ -22,16 +22,11 @@
 #include <crypto/sha.h>
 
 #include "crypt_s390.h"
-
-struct s390_sha256_ctx {
-	u64 count;		/* message length */
-	u32 state[8];
-	u8 buf[2 * SHA256_BLOCK_SIZE];
-};
+#include "sha.h"
 
 static void sha256_init(struct crypto_tfm *tfm)
 {
-	struct s390_sha256_ctx *sctx = crypto_tfm_ctx(tfm);
+	struct s390_sha_ctx *sctx = crypto_tfm_ctx(tfm);
 
 	sctx->state[0] = SHA256_H0;
 	sctx->state[1] = SHA256_H1;
@@ -42,79 +37,7 @@ static void sha256_init(struct crypto_tf
 	sctx->state[6] = SHA256_H6;
 	sctx->state[7] = SHA256_H7;
 	sctx->count = 0;
-}
-
-static void sha256_update(struct crypto_tfm *tfm, const u8 *data,
-			  unsigned int len)
-{
-	struct s390_sha256_ctx *sctx = crypto_tfm_ctx(tfm);
-	unsigned int index;
-	int ret;
-
-	/* how much is already in the buffer? */
-	index = sctx->count & 0x3f;
-
-	sctx->count += len;
-
-	if ((index + len) < SHA256_BLOCK_SIZE)
-		goto store;
-
-	/* process one stored block */
-	if (index) {
-		memcpy(sctx->buf + index, data, SHA256_BLOCK_SIZE - index);
-		ret = crypt_s390_kimd(KIMD_SHA_256, sctx->state, sctx->buf,
-				      SHA256_BLOCK_SIZE);
-		BUG_ON(ret != SHA256_BLOCK_SIZE);
-		data += SHA256_BLOCK_SIZE - index;
-		len -= SHA256_BLOCK_SIZE - index;
-	}
-
-	/* process as many blocks as possible */
-	if (len >= SHA256_BLOCK_SIZE) {
-		ret = crypt_s390_kimd(KIMD_SHA_256, sctx->state, data,
-				      len & ~(SHA256_BLOCK_SIZE - 1));
-		BUG_ON(ret != (len & ~(SHA256_BLOCK_SIZE - 1)));
-		data += ret;
-		len -= ret;
-	}
-
-store:
-	/* anything left? */
-	if (len)
-		memcpy(sctx->buf + index , data, len);
-}
-
-/* Add padding and return the message digest */
-static void sha256_final(struct crypto_tfm *tfm, u8 *out)
-{
-	struct s390_sha256_ctx *sctx = crypto_tfm_ctx(tfm);
-	u64 bits;
-	unsigned int index, end;
-	int ret;
-
-	/* must perform manual padding */
-	index = sctx->count & 0x3f;
-	end = (index < 56) ? SHA256_BLOCK_SIZE : (2 * SHA256_BLOCK_SIZE);
-
-	/* start pad with 1 */
-	sctx->buf[index] = 0x80;
-
-	/* pad with zeros */
-	index++;
-	memset(sctx->buf + index, 0x00, end - index - 8);
-
-	/* append message length */
-	bits = sctx->count * 8;
-	memcpy(sctx->buf + end - 8, &bits, sizeof(bits));
-
-	ret = crypt_s390_kimd(KIMD_SHA_256, sctx->state, sctx->buf, end);
-	BUG_ON(ret != end);
-
-	/* copy digest to out */
-	memcpy(out, sctx->state, SHA256_DIGEST_SIZE);
-
-	/* wipe context */
-	memset(sctx, 0, sizeof *sctx);
+	sctx->func = KIMD_SHA_256;
 }
 
 static struct crypto_alg alg = {
@@ -123,14 +46,14 @@ static struct crypto_alg alg = {
 	.cra_priority	=	CRYPT_S390_PRIORITY,
 	.cra_flags	=	CRYPTO_ALG_TYPE_DIGEST,
 	.cra_blocksize	=	SHA256_BLOCK_SIZE,
-	.cra_ctxsize	=	sizeof(struct s390_sha256_ctx),
+	.cra_ctxsize	=	sizeof(struct s390_sha_ctx),
 	.cra_module	=	THIS_MODULE,
 	.cra_list	=	LIST_HEAD_INIT(alg.cra_list),
 	.cra_u		=	{ .digest = {
 	.dia_digestsize	=	SHA256_DIGEST_SIZE,
 	.dia_init	=	sha256_init,
-	.dia_update	=	sha256_update,
-	.dia_final	=	sha256_final } }
+	.dia_update	=	s390_sha_update,
+	.dia_final	=	s390_sha_final } }
 };
 
 static int init(void)
@@ -150,6 +73,5 @@ module_init(init);
 module_exit(fini);
 
 MODULE_ALIAS("sha256");
-
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("SHA256 Secure Hash Algorithm");
Index: cryptodev-2.6/arch/s390/crypto/sha_common.c
===================================================================
--- /dev/null
+++ cryptodev-2.6/arch/s390/crypto/sha_common.c
@@ -0,0 +1,90 @@
+/*
+ * Cryptographic API.
+ *
+ * s390 generic implementation of the SHA Secure Hash Algorithms.
+ *
+ * Copyright IBM Corp. 2007
+ * Author(s): Jan Glauber (jang@de.ibm.com)
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+
+#include <linux/crypto.h>
+#include "sha.h"
+#include "crypt_s390.h"
+
+void s390_sha_update(struct crypto_tfm *tfm, const u8 *data, unsigned int len)
+{
+	struct s390_sha_ctx *ctx = crypto_tfm_ctx(tfm);
+	unsigned int bsize = crypto_tfm_alg_blocksize(tfm);
+	unsigned int index;
+	int ret;
+
+	/* how much is already in the buffer? */
+	index = ctx->count & (bsize - 1);
+	ctx->count += len;
+
+	if ((index + len) < bsize)
+		goto store;
+
+	/* process one stored block */
+	if (index) {
+		memcpy(ctx->buf + index, data, bsize - index);
+		ret = crypt_s390_kimd(ctx->func, ctx->state, ctx->buf, bsize);
+		BUG_ON(ret != bsize);
+		data += bsize - index;
+		len -= bsize - index;
+	}
+
+	/* process as many blocks as possible */
+	if (len >= bsize) {
+		ret = crypt_s390_kimd(ctx->func, ctx->state, data,
+				      len & ~(bsize - 1));
+		BUG_ON(ret != (len & ~(bsize - 1)));
+		data += ret;
+		len -= ret;
+	}
+store:
+	if (len)
+		memcpy(ctx->buf + index , data, len);
+}
+EXPORT_SYMBOL_GPL(s390_sha_update);
+
+void s390_sha_final(struct crypto_tfm *tfm, u8 *out)
+{
+	struct s390_sha_ctx *ctx = crypto_tfm_ctx(tfm);
+	unsigned int bsize = crypto_tfm_alg_blocksize(tfm);
+	u64 bits;
+	unsigned int index, end;
+	int ret;
+
+	/* must perform manual padding */
+	index = ctx->count & (bsize - 1);
+	end = (index < bsize - 8) ? bsize : (2 * bsize);
+
+	/* start pad with 1 */
+	ctx->buf[index] = 0x80;
+	index++;
+
+	/* pad with zeros */
+	memset(ctx->buf + index, 0x00, end - index - 8);
+
+	bits = ctx->count * 8;
+	memcpy(ctx->buf + end - 8, &bits, sizeof(bits));
+
+	ret = crypt_s390_kimd(ctx->func, ctx->state, ctx->buf, end);
+	BUG_ON(ret != end);
+
+	/* copy digest to out */
+	memcpy(out, ctx->state, crypto_hash_digestsize(crypto_hash_cast(tfm)));
+	/* wipe context */
+	memset(ctx, 0, sizeof *ctx);
+}
+EXPORT_SYMBOL_GPL(s390_sha_final);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("s390 SHA cipher common functions");


