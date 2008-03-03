From: Jan Glauber <jang@linux.vnet.ibm.com>
Subject: [PATCH 3/4] sha384 hardware acceleration for s390
Date: Mon, 03 Mar 2008 17:19:47 +0100
Message-ID: <1204561187.6025.53.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mtagate8.de.ibm.com ([195.212.29.157]:9169 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589AbYCCQUS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 3 Mar 2008 11:20:18 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate8.de.ibm.com (8.13.8/8.13.8) with ESMTP id m23GKHjC024866
	for <linux-crypto@vger.kernel.org>; Mon, 3 Mar 2008 16:20:17 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m23GJgZT475336
	for <linux-crypto@vger.kernel.org>; Mon, 3 Mar 2008 17:19:44 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m23GJfDB019726
	for <linux-crypto@vger.kernel.org>; Mon, 3 Mar 2008 16:19:42 GMT
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Exploit the System z10 hardware acceleration for SHA384.

Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>
---
 arch/s390/crypto/sha512_s390.c |   57 +++++++++++++++++++++++++++++++++++------
 drivers/crypto/Kconfig         |    6 ++--
 2 files changed, 54 insertions(+), 9 deletions(-)

Index: cryptodev-2.6/drivers/crypto/Kconfig
===================================================================
--- cryptodev-2.6.orig/drivers/crypto/Kconfig
+++ cryptodev-2.6/drivers/crypto/Kconfig
@@ -101,7 +101,7 @@ config CRYPTO_SHA256_S390
 	  security against collision attacks.
 
 config CRYPTO_SHA512_S390
-	tristate "SHA512 digest algorithm"
+	tristate "SHA384 and SHA512 digest algorithm"
 	depends on S390
 	select CRYPTO_ALGAPI
 	help
@@ -109,7 +109,9 @@ config CRYPTO_SHA512_S390
 	  SHA512 secure hash standard.
 
 	  This version of SHA implements a 512 bit hash with 256 bits of
-	  security against collision attacks.
+	  security against collision attacks. The code also includes SHA-384,
+	  a 384 bit hash with 192 bits of security against collision attacks.
+
 
 config CRYPTO_DES_S390
 	tristate "DES and Triple DES cipher algorithms"
Index: cryptodev-2.6/arch/s390/crypto/sha512_s390.c
===================================================================
--- cryptodev-2.6.orig/arch/s390/crypto/sha512_s390.c
+++ cryptodev-2.6/arch/s390/crypto/sha512_s390.c
@@ -1,7 +1,7 @@
 /*
  * Cryptographic API.
  *
- * s390 implementation of the SHA512 Secure Hash Algorithm.
+ * s390 implementation of the SHA512 and SHA38 Secure Hash Algorithm.
  *
  * Copyright IBM Corp. 2007
  * Author(s): Jan Glauber (jang@de.ibm.com)
@@ -35,7 +35,7 @@ static void sha512_init(struct crypto_tf
 	ctx->func = KIMD_SHA_512;
 }
 
-static struct crypto_alg alg = {
+static struct crypto_alg sha512_alg = {
 	.cra_name	=	"sha512",
 	.cra_driver_name =	"sha512-s390",
 	.cra_priority	=	CRYPT_S390_PRIORITY,
@@ -43,7 +43,7 @@ static struct crypto_alg alg = {
 	.cra_blocksize	=	SHA512_BLOCK_SIZE,
 	.cra_ctxsize	=	sizeof(struct s390_sha_ctx),
 	.cra_module	=	THIS_MODULE,
-	.cra_list	=	LIST_HEAD_INIT(alg.cra_list),
+	.cra_list	=	LIST_HEAD_INIT(sha512_alg.cra_list),
 	.cra_u		=	{ .digest = {
 	.dia_digestsize	=	SHA512_DIGEST_SIZE,
 	.dia_init	=	sha512_init,
@@ -51,21 +51,64 @@ static struct crypto_alg alg = {
 	.dia_final	=	s390_sha_final } }
 };
 
+MODULE_ALIAS("sha512");
+
+static void sha384_init(struct crypto_tfm *tfm)
+{
+	struct s390_sha_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	*(__u64 *)&ctx->state[0] = 0xcbbb9d5dc1059ed8ULL;
+	*(__u64 *)&ctx->state[2] = 0x629a292a367cd507ULL;
+	*(__u64 *)&ctx->state[4] = 0x9159015a3070dd17ULL;
+	*(__u64 *)&ctx->state[6] = 0x152fecd8f70e5939ULL;
+	*(__u64 *)&ctx->state[8] = 0x67332667ffc00b31ULL;
+	*(__u64 *)&ctx->state[10] = 0x8eb44a8768581511ULL;
+	*(__u64 *)&ctx->state[12] = 0xdb0c2e0d64f98fa7ULL;
+	*(__u64 *)&ctx->state[14] = 0x47b5481dbefa4fa4ULL;
+	ctx->count = 0;
+	ctx->func = KIMD_SHA_512;
+}
+
+static struct crypto_alg sha384_alg = {
+	.cra_name	=	"sha384",
+	.cra_driver_name =	"sha384-s390",
+	.cra_priority	=	CRYPT_S390_PRIORITY,
+	.cra_flags	=	CRYPTO_ALG_TYPE_DIGEST,
+	.cra_blocksize	=	SHA384_BLOCK_SIZE,
+	.cra_ctxsize	=	sizeof(struct s390_sha_ctx),
+	.cra_module	=	THIS_MODULE,
+	.cra_list	=	LIST_HEAD_INIT(sha384_alg.cra_list),
+	.cra_u		=	{ .digest = {
+	.dia_digestsize	=	SHA384_DIGEST_SIZE,
+	.dia_init	=	sha384_init,
+	.dia_update	=	s390_sha_update,
+	.dia_final	=	s390_sha_final } }
+};
+
+MODULE_ALIAS("sha384");
+
 static int __init init(void)
 {
+	int ret;
+
 	if (!crypt_s390_func_available(KIMD_SHA_512))
 		return -EOPNOTSUPP;
-	return crypto_register_alg(&alg);
+	if ((ret = crypto_register_alg(&sha512_alg)) < 0)
+		goto out;
+	if ((ret = crypto_register_alg(&sha384_alg)) < 0)
+		crypto_unregister_alg(&sha512_alg);
+out:
+	return ret;
 }
 
 static void __exit fini(void)
 {
-	crypto_unregister_alg(&alg);
+	crypto_unregister_alg(&sha512_alg);
+	crypto_unregister_alg(&sha384_alg);
 }
 
 module_init(init);
 module_exit(fini);
 
-MODULE_ALIAS("sha512");
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("SHA512 Secure Hash Algorithm");
+MODULE_DESCRIPTION("SHA512 and SHA-384 Secure Hash Algorithm");


