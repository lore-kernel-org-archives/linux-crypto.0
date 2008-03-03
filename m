From: Jan Glauber <jang@linux.vnet.ibm.com>
Subject: [PATCH 2/4] sha512 hardware acceleration for s390
Date: Mon, 03 Mar 2008 17:19:45 +0100
Message-ID: <1204561185.6025.52.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:25532 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755562AbYCCQUQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 3 Mar 2008 11:20:16 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate7.de.ibm.com (8.13.8/8.13.8) with ESMTP id m23GKE2S346162
	for <linux-crypto@vger.kernel.org>; Mon, 3 Mar 2008 16:20:14 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m23GJdqE1404972
	for <linux-crypto@vger.kernel.org>; Mon, 3 Mar 2008 17:19:40 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m23GJdZO019690
	for <linux-crypto@vger.kernel.org>; Mon, 3 Mar 2008 16:19:39 GMT
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Exploit the System z10 hardware acceleration for SHA512.

Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>
---
 arch/s390/crypto/Makefile      |    1 
 arch/s390/crypto/crypt_s390.h  |    2 +
 arch/s390/crypto/sha.h         |    5 +-
 arch/s390/crypto/sha512_s390.c |   71 +++++++++++++++++++++++++++++++++++++++++
 arch/s390/crypto/sha_common.c  |   11 +++++-
 drivers/crypto/Kconfig         |   11 ++++++
 6 files changed, 97 insertions(+), 4 deletions(-)

Index: cryptodev-2.6/drivers/crypto/Kconfig
===================================================================
--- cryptodev-2.6.orig/drivers/crypto/Kconfig
+++ cryptodev-2.6/drivers/crypto/Kconfig
@@ -100,6 +100,17 @@ config CRYPTO_SHA256_S390
 	  This version of SHA implements a 256 bit hash with 128 bits of
 	  security against collision attacks.
 
+config CRYPTO_SHA512_S390
+	tristate "SHA512 digest algorithm"
+	depends on S390
+	select CRYPTO_ALGAPI
+	help
+	  This is the s390 hardware accelerated implementation of the
+	  SHA512 secure hash standard.
+
+	  This version of SHA implements a 512 bit hash with 256 bits of
+	  security against collision attacks.
+
 config CRYPTO_DES_S390
 	tristate "DES and Triple DES cipher algorithms"
 	depends on S390
Index: cryptodev-2.6/arch/s390/crypto/Makefile
===================================================================
--- cryptodev-2.6.orig/arch/s390/crypto/Makefile
+++ cryptodev-2.6/arch/s390/crypto/Makefile
@@ -4,6 +4,7 @@
 
 obj-$(CONFIG_CRYPTO_SHA1_S390) += sha1_s390.o sha_common.o
 obj-$(CONFIG_CRYPTO_SHA256_S390) += sha256_s390.o sha_common.o
+obj-$(CONFIG_CRYPTO_SHA512_S390) += sha512_s390.o sha_common.o
 obj-$(CONFIG_CRYPTO_DES_S390) += des_s390.o des_check_key.o
 obj-$(CONFIG_CRYPTO_AES_S390) += aes_s390.o
 obj-$(CONFIG_S390_PRNG) += prng.o
Index: cryptodev-2.6/arch/s390/crypto/crypt_s390.h
===================================================================
--- cryptodev-2.6.orig/arch/s390/crypto/crypt_s390.h
+++ cryptodev-2.6/arch/s390/crypto/crypt_s390.h
@@ -82,6 +82,7 @@ enum crypt_s390_kimd_func {
 	KIMD_QUERY   = CRYPT_S390_KIMD | 0,
 	KIMD_SHA_1   = CRYPT_S390_KIMD | 1,
 	KIMD_SHA_256 = CRYPT_S390_KIMD | 2,
+	KIMD_SHA_512 = CRYPT_S390_KIMD | 3,
 };
 
 /*
@@ -92,6 +93,7 @@ enum crypt_s390_klmd_func {
 	KLMD_QUERY   = CRYPT_S390_KLMD | 0,
 	KLMD_SHA_1   = CRYPT_S390_KLMD | 1,
 	KLMD_SHA_256 = CRYPT_S390_KLMD | 2,
+	KLMD_SHA_512 = CRYPT_S390_KLMD | 3,
 };
 
 /*
Index: cryptodev-2.6/arch/s390/crypto/sha.h
===================================================================
--- cryptodev-2.6.orig/arch/s390/crypto/sha.h
+++ cryptodev-2.6/arch/s390/crypto/sha.h
@@ -19,11 +19,12 @@
 #include <crypto/sha.h>
 
 /* must be big enough for the largest SHA variant */
-#define SHA_MAX_BLOCK_SIZE      SHA256_BLOCK_SIZE
+#define SHA_MAX_STATE_SIZE	16
+#define SHA_MAX_BLOCK_SIZE      SHA512_BLOCK_SIZE
 
 struct s390_sha_ctx {
 	u64 count;              /* message length in bytes */
-	u32 state[8];
+	u32 state[SHA_MAX_STATE_SIZE];
 	u8 buf[2 * SHA_MAX_BLOCK_SIZE];
 	int func;		/* KIMD function to use */
 };
Index: cryptodev-2.6/arch/s390/crypto/sha512_s390.c
===================================================================
--- /dev/null
+++ cryptodev-2.6/arch/s390/crypto/sha512_s390.c
@@ -0,0 +1,71 @@
+/*
+ * Cryptographic API.
+ *
+ * s390 implementation of the SHA512 Secure Hash Algorithm.
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
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/crypto.h>
+
+#include "sha.h"
+#include "crypt_s390.h"
+
+static void sha512_init(struct crypto_tfm *tfm)
+{
+	struct s390_sha_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	*(__u64 *)&ctx->state[0] = 0x6a09e667f3bcc908ULL;
+	*(__u64 *)&ctx->state[2] = 0xbb67ae8584caa73bULL;
+	*(__u64 *)&ctx->state[4] = 0x3c6ef372fe94f82bULL;
+	*(__u64 *)&ctx->state[6] = 0xa54ff53a5f1d36f1ULL;
+	*(__u64 *)&ctx->state[8] = 0x510e527fade682d1ULL;
+	*(__u64 *)&ctx->state[10] = 0x9b05688c2b3e6c1fULL;
+	*(__u64 *)&ctx->state[12] = 0x1f83d9abfb41bd6bULL;
+	*(__u64 *)&ctx->state[14] = 0x5be0cd19137e2179ULL;
+	ctx->count = 0;
+	ctx->func = KIMD_SHA_512;
+}
+
+static struct crypto_alg alg = {
+	.cra_name	=	"sha512",
+	.cra_driver_name =	"sha512-s390",
+	.cra_priority	=	CRYPT_S390_PRIORITY,
+	.cra_flags	=	CRYPTO_ALG_TYPE_DIGEST,
+	.cra_blocksize	=	SHA512_BLOCK_SIZE,
+	.cra_ctxsize	=	sizeof(struct s390_sha_ctx),
+	.cra_module	=	THIS_MODULE,
+	.cra_list	=	LIST_HEAD_INIT(alg.cra_list),
+	.cra_u		=	{ .digest = {
+	.dia_digestsize	=	SHA512_DIGEST_SIZE,
+	.dia_init	=	sha512_init,
+	.dia_update	=	s390_sha_update,
+	.dia_final	=	s390_sha_final } }
+};
+
+static int __init init(void)
+{
+	if (!crypt_s390_func_available(KIMD_SHA_512))
+		return -EOPNOTSUPP;
+	return crypto_register_alg(&alg);
+}
+
+static void __exit fini(void)
+{
+	crypto_unregister_alg(&alg);
+}
+
+module_init(init);
+module_exit(fini);
+
+MODULE_ALIAS("sha512");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("SHA512 Secure Hash Algorithm");
Index: cryptodev-2.6/arch/s390/crypto/sha_common.c
===================================================================
--- cryptodev-2.6.orig/arch/s390/crypto/sha_common.c
+++ cryptodev-2.6/arch/s390/crypto/sha_common.c
@@ -59,12 +59,15 @@ void s390_sha_final(struct crypto_tfm *t
 	struct s390_sha_ctx *ctx = crypto_tfm_ctx(tfm);
 	unsigned int bsize = crypto_tfm_alg_blocksize(tfm);
 	u64 bits;
-	unsigned int index, end;
+	unsigned int index, end, plen;
 	int ret;
 
+	/* SHA-512 uses 128 bit padding length */
+	plen = (bsize > SHA256_BLOCK_SIZE) ? 16 : 8;
+
 	/* must perform manual padding */
 	index = ctx->count & (bsize - 1);
-	end = (index < bsize - 8) ? bsize : (2 * bsize);
+	end = (index < bsize - plen) ? bsize : (2 * bsize);
 
 	/* start pad with 1 */
 	ctx->buf[index] = 0x80;
@@ -73,6 +76,10 @@ void s390_sha_final(struct crypto_tfm *t
 	/* pad with zeros */
 	memset(ctx->buf + index, 0x00, end - index - 8);
 
+	/*
+	 * Append message length. Well, SHA-512 wants a 128 bit lenght value,
+	 * nevertheless we use u64, should be enough for now...
+	 */
 	bits = ctx->count * 8;
 	memcpy(ctx->buf + end - 8, &bits, sizeof(bits));
 


