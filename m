From: Jan Glauber <jang@linux.vnet.ibm.com>
Subject: [PATCH] s390: support hardware accelerated SHA-224
Date: Wed, 29 Jun 2011 14:23:16 +0200
Message-ID: <1309350196.20428.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:41954 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637Ab1F2MXl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Jun 2011 08:23:41 -0400
Received: from d06nrmr1507.portsmouth.uk.ibm.com (d06nrmr1507.portsmouth.uk.ibm.com [9.149.38.233])
	by mtagate4.uk.ibm.com (8.13.1/8.13.1) with ESMTP id p5TCNP4R010665
	for <linux-crypto@vger.kernel.org>; Wed, 29 Jun 2011 12:23:25 GMT
Received: from d06av11.portsmouth.uk.ibm.com (d06av11.portsmouth.uk.ibm.com [9.149.37.252])
	by d06nrmr1507.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p5TCNO5V2183414
	for <linux-crypto@vger.kernel.org>; Wed, 29 Jun 2011 13:23:24 +0100
Received: from d06av11.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av11.portsmouth.uk.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p5TCNOwX018461
	for <linux-crypto@vger.kernel.org>; Wed, 29 Jun 2011 06:23:24 -0600
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On recent s390 machines hardware acceleration is available for SHA-256.
SHA-224 is based on SHA-256 so it can also be accelerated by hardware.
Do this by adding the proper algorithm description and initialization.

Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>
---
 arch/s390/crypto/sha256_s390.c |   66 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 55 insertions(+), 11 deletions(-)

--- a/arch/s390/crypto/sha256_s390.c
+++ b/arch/s390/crypto/sha256_s390.c
@@ -1,15 +1,12 @@
 /*
  * Cryptographic API.
  *
- * s390 implementation of the SHA256 Secure Hash Algorithm.
+ * s390 implementation of the SHA256 and SHA224 Secure Hash Algorithm.
  *
  * s390 Version:
- *   Copyright IBM Corp. 2005,2007
+ *   Copyright IBM Corp. 2005,2011
  *   Author(s): Jan Glauber (jang@de.ibm.com)
  *
- * Derived from "crypto/sha256_generic.c"
- * and "arch/s390/crypto/sha1_s390.c"
- *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
  * Software Foundation; either version 2 of the License, or (at your option)
@@ -65,7 +62,7 @@ static int sha256_import(struct shash_de
 	return 0;
 }
 
-static struct shash_alg alg = {
+static struct shash_alg sha256_alg = {
 	.digestsize	=	SHA256_DIGEST_SIZE,
 	.init		=	sha256_init,
 	.update		=	s390_sha_update,
@@ -84,22 +81,69 @@ static struct shash_alg alg = {
 	}
 };
 
-static int sha256_s390_init(void)
+static int sha224_init(struct shash_desc *desc)
 {
+	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
+
+	sctx->state[0] = SHA224_H0;
+	sctx->state[1] = SHA224_H1;
+	sctx->state[2] = SHA224_H2;
+	sctx->state[3] = SHA224_H3;
+	sctx->state[4] = SHA224_H4;
+	sctx->state[5] = SHA224_H5;
+	sctx->state[6] = SHA224_H6;
+	sctx->state[7] = SHA224_H7;
+	sctx->count = 0;
+	sctx->func = KIMD_SHA_256;
+
+	return 0;
+}
+
+static struct shash_alg sha224_alg = {
+	.digestsize	=	SHA224_DIGEST_SIZE,
+	.init		=	sha224_init,
+	.update		=	s390_sha_update,
+	.final		=	s390_sha_final,
+	.export		=	sha256_export,
+	.import		=	sha256_import,
+	.descsize	=	sizeof(struct s390_sha_ctx),
+	.statesize	=	sizeof(struct sha256_state),
+	.base		=	{
+		.cra_name	=	"sha224",
+		.cra_driver_name=	"sha224-s390",
+		.cra_priority	=	CRYPT_S390_PRIORITY,
+		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize	=	SHA224_BLOCK_SIZE,
+		.cra_module	=	THIS_MODULE,
+	}
+};
+
+static int __init sha256_s390_init(void)
+{
+	int ret;
+
 	if (!crypt_s390_func_available(KIMD_SHA_256, CRYPT_S390_MSA))
 		return -EOPNOTSUPP;
-
-	return crypto_register_shash(&alg);
+	ret = crypto_register_shash(&sha256_alg);
+	if (ret < 0)
+		goto out;
+	ret = crypto_register_shash(&sha224_alg);
+	if (ret < 0)
+		crypto_unregister_shash(&sha256_alg);
+out:
+	return ret;
 }
 
 static void __exit sha256_s390_fini(void)
 {
-	crypto_unregister_shash(&alg);
+	crypto_unregister_shash(&sha224_alg);
+	crypto_unregister_shash(&sha256_alg);
 }
 
 module_init(sha256_s390_init);
 module_exit(sha256_s390_fini);
 
 MODULE_ALIAS("sha256");
+MODULE_ALIAS("sha224");
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("SHA256 Secure Hash Algorithm");
+MODULE_DESCRIPTION("SHA256 and SHA224 Secure Hash Algorithm");
