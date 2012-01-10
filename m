From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 1/2] crypto: caam - add sha224 and sha384 variants to
 existing AEAD algorithms
Date: Mon, 9 Jan 2012 18:26:44 -0600
Message-ID: <20120109182644.13645da93d24a84ff6611b49@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Hemant Agrawal <hemant@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:50044
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933521Ab2AJA2I (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Jan 2012 19:28:08 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Hemant Agrawal <hemant@freescale.com>

Signed-off-by: Hemant Agrawal <hemant@freescale.com>
Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/caam/caamalg.c |  115 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 115 insertions(+), 0 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index e73cf2e..f6b8dcc 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -1844,6 +1844,25 @@ static struct caam_alg_template driver_algs[] = {
 		.alg_op = OP_ALG_ALGSEL_SHA1 | OP_ALG_AAI_HMAC,
 	},
 	{
+		.name = "authenc(hmac(sha224),cbc(aes))",
+		.driver_name = "authenc-hmac-sha224-cbc-aes-caam",
+		.blocksize = AES_BLOCK_SIZE,
+		.template_aead = {
+			.setkey = aead_setkey,
+			.setauthsize = aead_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
+			.givencrypt = aead_givencrypt,
+			.geniv = "<built-in>",
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize = SHA224_DIGEST_SIZE,
+			},
+		.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CBC,
+		.class2_alg_type = OP_ALG_ALGSEL_SHA224 |
+				   OP_ALG_AAI_HMAC_PRECOMP,
+		.alg_op = OP_ALG_ALGSEL_SHA224 | OP_ALG_AAI_HMAC,
+	},
+	{
 		.name = "authenc(hmac(sha256),cbc(aes))",
 		.driver_name = "authenc-hmac-sha256-cbc-aes-caam",
 		.blocksize = AES_BLOCK_SIZE,
@@ -1864,6 +1883,26 @@ static struct caam_alg_template driver_algs[] = {
 		.alg_op = OP_ALG_ALGSEL_SHA256 | OP_ALG_AAI_HMAC,
 	},
 	{
+		.name = "authenc(hmac(sha384),cbc(aes))",
+		.driver_name = "authenc-hmac-sha384-cbc-aes-caam",
+		.blocksize = AES_BLOCK_SIZE,
+		.template_aead = {
+			.setkey = aead_setkey,
+			.setauthsize = aead_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
+			.givencrypt = aead_givencrypt,
+			.geniv = "<built-in>",
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize = SHA384_DIGEST_SIZE,
+			},
+		.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CBC,
+		.class2_alg_type = OP_ALG_ALGSEL_SHA384 |
+				   OP_ALG_AAI_HMAC_PRECOMP,
+		.alg_op = OP_ALG_ALGSEL_SHA384 | OP_ALG_AAI_HMAC,
+	},
+
+	{
 		.name = "authenc(hmac(sha512),cbc(aes))",
 		.driver_name = "authenc-hmac-sha512-cbc-aes-caam",
 		.blocksize = AES_BLOCK_SIZE,
@@ -1922,6 +1961,25 @@ static struct caam_alg_template driver_algs[] = {
 		.alg_op = OP_ALG_ALGSEL_SHA1 | OP_ALG_AAI_HMAC,
 	},
 	{
+		.name = "authenc(hmac(sha224),cbc(des3_ede))",
+		.driver_name = "authenc-hmac-sha224-cbc-des3_ede-caam",
+		.blocksize = DES3_EDE_BLOCK_SIZE,
+		.template_aead = {
+			.setkey = aead_setkey,
+			.setauthsize = aead_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
+			.givencrypt = aead_givencrypt,
+			.geniv = "<built-in>",
+			.ivsize = DES3_EDE_BLOCK_SIZE,
+			.maxauthsize = SHA224_DIGEST_SIZE,
+			},
+		.class1_alg_type = OP_ALG_ALGSEL_3DES | OP_ALG_AAI_CBC,
+		.class2_alg_type = OP_ALG_ALGSEL_SHA224 |
+				   OP_ALG_AAI_HMAC_PRECOMP,
+		.alg_op = OP_ALG_ALGSEL_SHA224 | OP_ALG_AAI_HMAC,
+	},
+	{
 		.name = "authenc(hmac(sha256),cbc(des3_ede))",
 		.driver_name = "authenc-hmac-sha256-cbc-des3_ede-caam",
 		.blocksize = DES3_EDE_BLOCK_SIZE,
@@ -1942,6 +2000,25 @@ static struct caam_alg_template driver_algs[] = {
 		.alg_op = OP_ALG_ALGSEL_SHA256 | OP_ALG_AAI_HMAC,
 	},
 	{
+		.name = "authenc(hmac(sha384),cbc(des3_ede))",
+		.driver_name = "authenc-hmac-sha384-cbc-des3_ede-caam",
+		.blocksize = DES3_EDE_BLOCK_SIZE,
+		.template_aead = {
+			.setkey = aead_setkey,
+			.setauthsize = aead_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
+			.givencrypt = aead_givencrypt,
+			.geniv = "<built-in>",
+			.ivsize = DES3_EDE_BLOCK_SIZE,
+			.maxauthsize = SHA384_DIGEST_SIZE,
+			},
+		.class1_alg_type = OP_ALG_ALGSEL_3DES | OP_ALG_AAI_CBC,
+		.class2_alg_type = OP_ALG_ALGSEL_SHA384 |
+				   OP_ALG_AAI_HMAC_PRECOMP,
+		.alg_op = OP_ALG_ALGSEL_SHA384 | OP_ALG_AAI_HMAC,
+	},
+	{
 		.name = "authenc(hmac(sha512),cbc(des3_ede))",
 		.driver_name = "authenc-hmac-sha512-cbc-des3_ede-caam",
 		.blocksize = DES3_EDE_BLOCK_SIZE,
@@ -2000,6 +2077,25 @@ static struct caam_alg_template driver_algs[] = {
 		.alg_op = OP_ALG_ALGSEL_SHA1 | OP_ALG_AAI_HMAC,
 	},
 	{
+		.name = "authenc(hmac(sha224),cbc(des))",
+		.driver_name = "authenc-hmac-sha224-cbc-des-caam",
+		.blocksize = DES_BLOCK_SIZE,
+		.template_aead = {
+			.setkey = aead_setkey,
+			.setauthsize = aead_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
+			.givencrypt = aead_givencrypt,
+			.geniv = "<built-in>",
+			.ivsize = DES_BLOCK_SIZE,
+			.maxauthsize = SHA224_DIGEST_SIZE,
+			},
+		.class1_alg_type = OP_ALG_ALGSEL_DES | OP_ALG_AAI_CBC,
+		.class2_alg_type = OP_ALG_ALGSEL_SHA224 |
+				   OP_ALG_AAI_HMAC_PRECOMP,
+		.alg_op = OP_ALG_ALGSEL_SHA224 | OP_ALG_AAI_HMAC,
+	},
+	{
 		.name = "authenc(hmac(sha256),cbc(des))",
 		.driver_name = "authenc-hmac-sha256-cbc-des-caam",
 		.blocksize = DES_BLOCK_SIZE,
@@ -2020,6 +2116,25 @@ static struct caam_alg_template driver_algs[] = {
 		.alg_op = OP_ALG_ALGSEL_SHA256 | OP_ALG_AAI_HMAC,
 	},
 	{
+		.name = "authenc(hmac(sha384),cbc(des))",
+		.driver_name = "authenc-hmac-sha384-cbc-des-caam",
+		.blocksize = DES_BLOCK_SIZE,
+		.template_aead = {
+			.setkey = aead_setkey,
+			.setauthsize = aead_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
+			.givencrypt = aead_givencrypt,
+			.geniv = "<built-in>",
+			.ivsize = DES_BLOCK_SIZE,
+			.maxauthsize = SHA384_DIGEST_SIZE,
+			},
+		.class1_alg_type = OP_ALG_ALGSEL_DES | OP_ALG_AAI_CBC,
+		.class2_alg_type = OP_ALG_ALGSEL_SHA384 |
+				   OP_ALG_AAI_HMAC_PRECOMP,
+		.alg_op = OP_ALG_ALGSEL_SHA384 | OP_ALG_AAI_HMAC,
+	},
+	{
 		.name = "authenc(hmac(sha512),cbc(des))",
 		.driver_name = "authenc-hmac-sha512-cbc-des-caam",
 		.blocksize = DES_BLOCK_SIZE,
-- 
1.7.8.3
