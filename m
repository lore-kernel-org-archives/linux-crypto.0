From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 5/5] crypto: caam - add support for MD5 algorithm variants
Date: Wed, 16 Nov 2011 18:21:52 -0600
Message-ID: <20111116182152.1443deafa9f92401176b3c9f@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:18382
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754751Ab1KQAWv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Nov 2011 19:22:51 -0500
Received: from mail53-ch1 (localhost [127.0.0.1])	by mail53-ch1-R.bigfish.com
 (Postfix) with ESMTP id 55845C00EF	for <linux-crypto@vger.kernel.org>; Thu,
 17 Nov 2011 00:22:34 +0000 (UTC)
Received: from CH1EHSMHS006.bigfish.com (snatpool1.int.messaging.microsoft.com
 [10.43.68.249])	by mail53-ch1.bigfish.com (Postfix) with ESMTP id 2B332200042
	for <linux-crypto@vger.kernel.org>; Thu, 17 Nov 2011 00:22:34 +0000 (UTC)
Received: from x9 (x9.am.freescale.net [10.82.120.9])	by
 az33smr02.freescale.net (8.13.1/8.13.0) with SMTP id pAH0Mm3c028553	for
 <linux-crypto@vger.kernel.org>; Wed, 16 Nov 2011 18:22:49 -0600 (CST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

specifically, add these algorithm combinations:

authenc-hmac-md5-cbc-aes-caam
authenc-hmac-md5-cbc-des3_ede-caam
authenc-hmac-md5-cbc-des-caam

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/caam/caamalg.c |   57 +++++++++++++++++++++++++++++++++++++++++
 drivers/crypto/caam/compat.h  |    1 +
 2 files changed, 58 insertions(+), 0 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 4159265..a5bc706 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -1806,6 +1806,25 @@ struct caam_alg_template {
 static struct caam_alg_template driver_algs[] = {
 	/* single-pass ipsec_esp descriptor */
 	{
+		.name = "authenc(hmac(md5),cbc(aes))",
+		.driver_name = "authenc-hmac-md5-cbc-aes-caam",
+		.blocksize = AES_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_AEAD,
+		.template_aead = {
+			.setkey = aead_setkey,
+			.setauthsize = aead_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
+			.givencrypt = aead_givencrypt,
+			.geniv = "<built-in>",
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize = MD5_DIGEST_SIZE,
+			},
+		.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CBC,
+		.class2_alg_type = OP_ALG_ALGSEL_MD5 | OP_ALG_AAI_HMAC_PRECOMP,
+		.alg_op = OP_ALG_ALGSEL_MD5 | OP_ALG_AAI_HMAC,
+	},
+	{
 		.name = "authenc(hmac(sha1),cbc(aes))",
 		.driver_name = "authenc-hmac-sha1-cbc-aes-caam",
 		.blocksize = AES_BLOCK_SIZE,
@@ -1865,6 +1884,25 @@ static struct caam_alg_template driver_algs[] = {
 		.alg_op = OP_ALG_ALGSEL_SHA512 | OP_ALG_AAI_HMAC,
 	},
 	{
+		.name = "authenc(hmac(md5),cbc(des3_ede))",
+		.driver_name = "authenc-hmac-md5-cbc-des3_ede-caam",
+		.blocksize = DES3_EDE_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_AEAD,
+		.template_aead = {
+			.setkey = aead_setkey,
+			.setauthsize = aead_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
+			.givencrypt = aead_givencrypt,
+			.geniv = "<built-in>",
+			.ivsize = DES3_EDE_BLOCK_SIZE,
+			.maxauthsize = MD5_DIGEST_SIZE,
+			},
+		.class1_alg_type = OP_ALG_ALGSEL_3DES | OP_ALG_AAI_CBC,
+		.class2_alg_type = OP_ALG_ALGSEL_MD5 | OP_ALG_AAI_HMAC_PRECOMP,
+		.alg_op = OP_ALG_ALGSEL_MD5 | OP_ALG_AAI_HMAC,
+	},
+	{
 		.name = "authenc(hmac(sha1),cbc(des3_ede))",
 		.driver_name = "authenc-hmac-sha1-cbc-des3_ede-caam",
 		.blocksize = DES3_EDE_BLOCK_SIZE,
@@ -1924,6 +1962,25 @@ static struct caam_alg_template driver_algs[] = {
 		.alg_op = OP_ALG_ALGSEL_SHA512 | OP_ALG_AAI_HMAC,
 	},
 	{
+		.name = "authenc(hmac(md5),cbc(des))",
+		.driver_name = "authenc-hmac-md5-cbc-des-caam",
+		.blocksize = DES_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_AEAD,
+		.template_aead = {
+			.setkey = aead_setkey,
+			.setauthsize = aead_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
+			.givencrypt = aead_givencrypt,
+			.geniv = "<built-in>",
+			.ivsize = DES_BLOCK_SIZE,
+			.maxauthsize = MD5_DIGEST_SIZE,
+			},
+		.class1_alg_type = OP_ALG_ALGSEL_DES | OP_ALG_AAI_CBC,
+		.class2_alg_type = OP_ALG_ALGSEL_MD5 | OP_ALG_AAI_HMAC_PRECOMP,
+		.alg_op = OP_ALG_ALGSEL_MD5 | OP_ALG_AAI_HMAC,
+	},
+	{
 		.name = "authenc(hmac(sha1),cbc(des))",
 		.driver_name = "authenc-hmac-sha1-cbc-des-caam",
 		.blocksize = DES_BLOCK_SIZE,
diff --git a/drivers/crypto/caam/compat.h b/drivers/crypto/caam/compat.h
index d38f2af..a63bc65 100644
--- a/drivers/crypto/caam/compat.h
+++ b/drivers/crypto/caam/compat.h
@@ -28,6 +28,7 @@
 #include <crypto/aes.h>
 #include <crypto/des.h>
 #include <crypto/sha.h>
+#include <crypto/md5.h>
 #include <crypto/aead.h>
 #include <crypto/authenc.h>
 #include <crypto/scatterwalk.h>
-- 
1.7.7
