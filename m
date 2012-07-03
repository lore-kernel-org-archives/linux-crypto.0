From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH 3/4] crypto: talitos - add sha224, sha384 and sha512 to existing AEAD algorithms
Date: Tue, 3 Jul 2012 19:16:53 +0300
Message-ID: <1341332214-5525-3-git-send-email-horia.geanta@freescale.com>
References: <1341332214-5525-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:14948
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752181Ab2GCQRf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 Jul 2012 12:17:35 -0400
In-Reply-To: <1341332214-5525-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

With this, now all combinations of
CBC: AES, 3DES-EDE
with
HMAC: SHA-1, SHA-224, SHA-256, SHA-384, SHA-512
are supported.

Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
---
 drivers/crypto/talitos.c |  161 +++++++++++++++++++++++++++++++++++++++++++++-
 drivers/crypto/talitos.h |    6 ++
 2 files changed, 166 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 2561aea..efff788 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -623,7 +623,7 @@ static void talitos_unregister_rng(struct device *dev)
  * crypto alg
  */
 #define TALITOS_CRA_PRIORITY		3000
-#define TALITOS_MAX_KEY_SIZE		64
+#define TALITOS_MAX_KEY_SIZE		96
 #define TALITOS_MAX_IV_LENGTH		16 /* max of AES_BLOCK_SIZE, DES3_EDE_BLOCK_SIZE */
 
 #define MD5_BLOCK_SIZE    64
@@ -1956,6 +1956,59 @@ static struct talitos_alg_template driver_algs[] = {
 		                     DESC_HDR_MODE1_MDEU_PAD |
 		                     DESC_HDR_MODE1_MDEU_SHA1_HMAC,
 	},
+	{       .type = CRYPTO_ALG_TYPE_AEAD,
+		.alg.crypto = {
+			.cra_name = "authenc(hmac(sha224),cbc(aes))",
+			.cra_driver_name = "authenc-hmac-sha224-cbc-aes-talitos",
+			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
+			.cra_type = &crypto_aead_type,
+			.cra_aead = {
+				.setkey = aead_setkey,
+				.setauthsize = aead_setauthsize,
+				.encrypt = aead_encrypt,
+				.decrypt = aead_decrypt,
+				.givencrypt = aead_givencrypt,
+				.geniv = "<built-in>",
+				.ivsize = AES_BLOCK_SIZE,
+				.maxauthsize = SHA224_DIGEST_SIZE,
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
+				     DESC_HDR_SEL0_AESU |
+				     DESC_HDR_MODE0_AESU_CBC |
+				     DESC_HDR_SEL1_MDEUA |
+				     DESC_HDR_MODE1_MDEU_INIT |
+				     DESC_HDR_MODE1_MDEU_PAD |
+				     DESC_HDR_MODE1_MDEU_SHA224_HMAC,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AEAD,
+		.alg.crypto = {
+			.cra_name = "authenc(hmac(sha224),cbc(des3_ede))",
+			.cra_driver_name = "authenc-hmac-sha224-cbc-3des-talitos",
+			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
+			.cra_type = &crypto_aead_type,
+			.cra_aead = {
+				.setkey = aead_setkey,
+				.setauthsize = aead_setauthsize,
+				.encrypt = aead_encrypt,
+				.decrypt = aead_decrypt,
+				.givencrypt = aead_givencrypt,
+				.geniv = "<built-in>",
+				.ivsize = DES3_EDE_BLOCK_SIZE,
+				.maxauthsize = SHA224_DIGEST_SIZE,
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
+			             DESC_HDR_SEL0_DEU |
+		                     DESC_HDR_MODE0_DEU_CBC |
+		                     DESC_HDR_MODE0_DEU_3DES |
+		                     DESC_HDR_SEL1_MDEUA |
+		                     DESC_HDR_MODE1_MDEU_INIT |
+		                     DESC_HDR_MODE1_MDEU_PAD |
+		                     DESC_HDR_MODE1_MDEU_SHA224_HMAC,
+	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
 		.alg.crypto = {
 			.cra_name = "authenc(hmac(sha256),cbc(aes))",
@@ -2011,6 +2064,112 @@ static struct talitos_alg_template driver_algs[] = {
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
 		.alg.crypto = {
+			.cra_name = "authenc(hmac(sha384),cbc(aes))",
+			.cra_driver_name = "authenc-hmac-sha384-cbc-aes-talitos",
+			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
+			.cra_type = &crypto_aead_type,
+			.cra_aead = {
+				.setkey = aead_setkey,
+				.setauthsize = aead_setauthsize,
+				.encrypt = aead_encrypt,
+				.decrypt = aead_decrypt,
+				.givencrypt = aead_givencrypt,
+				.geniv = "<built-in>",
+				.ivsize = AES_BLOCK_SIZE,
+				.maxauthsize = SHA384_DIGEST_SIZE,
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
+			             DESC_HDR_SEL0_AESU |
+		                     DESC_HDR_MODE0_AESU_CBC |
+		                     DESC_HDR_SEL1_MDEUB |
+		                     DESC_HDR_MODE1_MDEU_INIT |
+		                     DESC_HDR_MODE1_MDEU_PAD |
+		                     DESC_HDR_MODE1_MDEUB_SHA384_HMAC,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AEAD,
+		.alg.crypto = {
+			.cra_name = "authenc(hmac(sha384),cbc(des3_ede))",
+			.cra_driver_name = "authenc-hmac-sha384-cbc-3des-talitos",
+			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
+			.cra_type = &crypto_aead_type,
+			.cra_aead = {
+				.setkey = aead_setkey,
+				.setauthsize = aead_setauthsize,
+				.encrypt = aead_encrypt,
+				.decrypt = aead_decrypt,
+				.givencrypt = aead_givencrypt,
+				.geniv = "<built-in>",
+				.ivsize = DES3_EDE_BLOCK_SIZE,
+				.maxauthsize = SHA384_DIGEST_SIZE,
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
+			             DESC_HDR_SEL0_DEU |
+		                     DESC_HDR_MODE0_DEU_CBC |
+		                     DESC_HDR_MODE0_DEU_3DES |
+		                     DESC_HDR_SEL1_MDEUB |
+		                     DESC_HDR_MODE1_MDEU_INIT |
+		                     DESC_HDR_MODE1_MDEU_PAD |
+		                     DESC_HDR_MODE1_MDEUB_SHA384_HMAC,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AEAD,
+		.alg.crypto = {
+			.cra_name = "authenc(hmac(sha512),cbc(aes))",
+			.cra_driver_name = "authenc-hmac-sha512-cbc-aes-talitos",
+			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
+			.cra_type = &crypto_aead_type,
+			.cra_aead = {
+				.setkey = aead_setkey,
+				.setauthsize = aead_setauthsize,
+				.encrypt = aead_encrypt,
+				.decrypt = aead_decrypt,
+				.givencrypt = aead_givencrypt,
+				.geniv = "<built-in>",
+				.ivsize = AES_BLOCK_SIZE,
+				.maxauthsize = SHA512_DIGEST_SIZE,
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
+			             DESC_HDR_SEL0_AESU |
+		                     DESC_HDR_MODE0_AESU_CBC |
+		                     DESC_HDR_SEL1_MDEUB |
+		                     DESC_HDR_MODE1_MDEU_INIT |
+		                     DESC_HDR_MODE1_MDEU_PAD |
+		                     DESC_HDR_MODE1_MDEUB_SHA512_HMAC,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AEAD,
+		.alg.crypto = {
+			.cra_name = "authenc(hmac(sha512),cbc(des3_ede))",
+			.cra_driver_name = "authenc-hmac-sha512-cbc-3des-talitos",
+			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
+			.cra_type = &crypto_aead_type,
+			.cra_aead = {
+				.setkey = aead_setkey,
+				.setauthsize = aead_setauthsize,
+				.encrypt = aead_encrypt,
+				.decrypt = aead_decrypt,
+				.givencrypt = aead_givencrypt,
+				.geniv = "<built-in>",
+				.ivsize = DES3_EDE_BLOCK_SIZE,
+				.maxauthsize = SHA512_DIGEST_SIZE,
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
+			             DESC_HDR_SEL0_DEU |
+		                     DESC_HDR_MODE0_DEU_CBC |
+		                     DESC_HDR_MODE0_DEU_3DES |
+		                     DESC_HDR_SEL1_MDEUB |
+		                     DESC_HDR_MODE1_MDEU_INIT |
+		                     DESC_HDR_MODE1_MDEU_PAD |
+		                     DESC_HDR_MODE1_MDEUB_SHA512_HMAC,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AEAD,
+		.alg.crypto = {
 			.cra_name = "authenc(hmac(md5),cbc(aes))",
 			.cra_driver_name = "authenc-hmac-md5-cbc-aes-talitos",
 			.cra_blocksize = AES_BLOCK_SIZE,
diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index 41b80f6..61a1405 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -326,6 +326,12 @@ extern int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
 					 DESC_HDR_MODE1_MDEU_HMAC)
 #define	DESC_HDR_MODE1_MDEU_SHA1_HMAC	(DESC_HDR_MODE1_MDEU_SHA1 | \
 					 DESC_HDR_MODE1_MDEU_HMAC)
+#define DESC_HDR_MODE1_MDEU_SHA224_HMAC	(DESC_HDR_MODE1_MDEU_SHA224 | \
+					 DESC_HDR_MODE1_MDEU_HMAC)
+#define DESC_HDR_MODE1_MDEUB_SHA384_HMAC	(DESC_HDR_MODE1_MDEUB_SHA384 | \
+						 DESC_HDR_MODE1_MDEU_HMAC)
+#define DESC_HDR_MODE1_MDEUB_SHA512_HMAC	(DESC_HDR_MODE1_MDEUB_SHA512 | \
+						 DESC_HDR_MODE1_MDEU_HMAC)
 
 /* direction of overall data flow (DIR) */
 #define	DESC_HDR_DIR_INBOUND		cpu_to_be32(0x00000002)
-- 
1.7.3.4
