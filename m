From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH 5/5] crypto: talitos - add IPsec ESN support
Date: Thu, 2 Aug 2012 17:16:41 +0300
Message-ID: <1343917001-20001-5-git-send-email-horia.geanta@freescale.com>
References: <1343917001-20001-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Kim Phillips <kim.phillips@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:42975
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752484Ab2HBOR4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Aug 2012 10:17:56 -0400
In-Reply-To: <1343917001-20001-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Suuport for ESNs (extended sequence numbers).
Tested with strongswan on a P2020RDB back-to-back setup.
>From /etc/ipsec.conf:
esp=aes-sha1-esn-modp4096!

Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
---
 drivers/crypto/talitos.c |  318 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 318 insertions(+), 0 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index a57fdcd..af9895a 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -2003,6 +2003,32 @@ static struct talitos_alg_template driver_algs[] = {
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
 		.alg.crypto = {
+			.cra_name = "authencesn(hmac(sha1),cbc(aes))",
+			.cra_driver_name = "authenc-hmac-sha1-cbc-aes-talitos",
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
+				.maxauthsize = SHA1_DIGEST_SIZE,
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
+				     DESC_HDR_SEL0_AESU |
+				     DESC_HDR_MODE0_AESU_CBC |
+				     DESC_HDR_SEL1_MDEUA |
+				     DESC_HDR_MODE1_MDEU_INIT |
+				     DESC_HDR_MODE1_MDEU_PAD |
+				     DESC_HDR_MODE1_MDEU_SHA1_HMAC,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AEAD,
+		.alg.crypto = {
 			.cra_name = "authenc(hmac(sha1),cbc(des3_ede))",
 			.cra_driver_name = "authenc-hmac-sha1-cbc-3des-talitos",
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
@@ -2028,6 +2054,33 @@ static struct talitos_alg_template driver_algs[] = {
 		                     DESC_HDR_MODE1_MDEU_PAD |
 		                     DESC_HDR_MODE1_MDEU_SHA1_HMAC,
 	},
+	{	.type = CRYPTO_ALG_TYPE_AEAD,
+		.alg.crypto = {
+			.cra_name = "authencesn(hmac(sha1),cbc(des3_ede))",
+			.cra_driver_name = "authenc-hmac-sha1-cbc-3des-talitos",
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
+				.maxauthsize = SHA1_DIGEST_SIZE,
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
+				     DESC_HDR_SEL0_DEU |
+				     DESC_HDR_MODE0_DEU_CBC |
+				     DESC_HDR_MODE0_DEU_3DES |
+				     DESC_HDR_SEL1_MDEUA |
+				     DESC_HDR_MODE1_MDEU_INIT |
+				     DESC_HDR_MODE1_MDEU_PAD |
+				     DESC_HDR_MODE1_MDEU_SHA1_HMAC,
+	},
 	{       .type = CRYPTO_ALG_TYPE_AEAD,
 		.alg.crypto = {
 			.cra_name = "authenc(hmac(sha224),cbc(aes))",
@@ -2054,6 +2107,32 @@ static struct talitos_alg_template driver_algs[] = {
 				     DESC_HDR_MODE1_MDEU_PAD |
 				     DESC_HDR_MODE1_MDEU_SHA224_HMAC,
 	},
+	{       .type = CRYPTO_ALG_TYPE_AEAD,
+		.alg.crypto = {
+			.cra_name = "authencesn(hmac(sha224),cbc(aes))",
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
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
 		.alg.crypto = {
 			.cra_name = "authenc(hmac(sha224),cbc(des3_ede))",
@@ -2083,6 +2162,33 @@ static struct talitos_alg_template driver_algs[] = {
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
 		.alg.crypto = {
+			.cra_name = "authencesn(hmac(sha224),cbc(des3_ede))",
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
+				     DESC_HDR_SEL0_DEU |
+				     DESC_HDR_MODE0_DEU_CBC |
+				     DESC_HDR_MODE0_DEU_3DES |
+				     DESC_HDR_SEL1_MDEUA |
+				     DESC_HDR_MODE1_MDEU_INIT |
+				     DESC_HDR_MODE1_MDEU_PAD |
+				     DESC_HDR_MODE1_MDEU_SHA224_HMAC,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AEAD,
+		.alg.crypto = {
 			.cra_name = "authenc(hmac(sha256),cbc(aes))",
 			.cra_driver_name = "authenc-hmac-sha256-cbc-aes-talitos",
 			.cra_blocksize = AES_BLOCK_SIZE,
@@ -2109,6 +2215,32 @@ static struct talitos_alg_template driver_algs[] = {
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
 		.alg.crypto = {
+			.cra_name = "authencesn(hmac(sha256),cbc(aes))",
+			.cra_driver_name = "authenc-hmac-sha256-cbc-aes-talitos",
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
+				.maxauthsize = SHA256_DIGEST_SIZE,
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
+				     DESC_HDR_SEL0_AESU |
+				     DESC_HDR_MODE0_AESU_CBC |
+				     DESC_HDR_SEL1_MDEUA |
+				     DESC_HDR_MODE1_MDEU_INIT |
+				     DESC_HDR_MODE1_MDEU_PAD |
+				     DESC_HDR_MODE1_MDEU_SHA256_HMAC,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AEAD,
+		.alg.crypto = {
 			.cra_name = "authenc(hmac(sha256),cbc(des3_ede))",
 			.cra_driver_name = "authenc-hmac-sha256-cbc-3des-talitos",
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
@@ -2136,6 +2268,33 @@ static struct talitos_alg_template driver_algs[] = {
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
 		.alg.crypto = {
+			.cra_name = "authencesn(hmac(sha256),cbc(des3_ede))",
+			.cra_driver_name = "authenc-hmac-sha256-cbc-3des-talitos",
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
+				.maxauthsize = SHA256_DIGEST_SIZE,
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
+				     DESC_HDR_SEL0_DEU |
+				     DESC_HDR_MODE0_DEU_CBC |
+				     DESC_HDR_MODE0_DEU_3DES |
+				     DESC_HDR_SEL1_MDEUA |
+				     DESC_HDR_MODE1_MDEU_INIT |
+				     DESC_HDR_MODE1_MDEU_PAD |
+				     DESC_HDR_MODE1_MDEU_SHA256_HMAC,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AEAD,
+		.alg.crypto = {
 			.cra_name = "authenc(hmac(sha384),cbc(aes))",
 			.cra_driver_name = "authenc-hmac-sha384-cbc-aes-talitos",
 			.cra_blocksize = AES_BLOCK_SIZE,
@@ -2162,6 +2321,32 @@ static struct talitos_alg_template driver_algs[] = {
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
 		.alg.crypto = {
+			.cra_name = "authencesn(hmac(sha384),cbc(aes))",
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
+				     DESC_HDR_SEL0_AESU |
+				     DESC_HDR_MODE0_AESU_CBC |
+				     DESC_HDR_SEL1_MDEUB |
+				     DESC_HDR_MODE1_MDEU_INIT |
+				     DESC_HDR_MODE1_MDEU_PAD |
+				     DESC_HDR_MODE1_MDEUB_SHA384_HMAC,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AEAD,
+		.alg.crypto = {
 			.cra_name = "authenc(hmac(sha384),cbc(des3_ede))",
 			.cra_driver_name = "authenc-hmac-sha384-cbc-3des-talitos",
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
@@ -2189,6 +2374,33 @@ static struct talitos_alg_template driver_algs[] = {
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
 		.alg.crypto = {
+			.cra_name = "authencesn(hmac(sha384),cbc(des3_ede))",
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
+				     DESC_HDR_SEL0_DEU |
+				     DESC_HDR_MODE0_DEU_CBC |
+				     DESC_HDR_MODE0_DEU_3DES |
+				     DESC_HDR_SEL1_MDEUB |
+				     DESC_HDR_MODE1_MDEU_INIT |
+				     DESC_HDR_MODE1_MDEU_PAD |
+				     DESC_HDR_MODE1_MDEUB_SHA384_HMAC,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AEAD,
+		.alg.crypto = {
 			.cra_name = "authenc(hmac(sha512),cbc(aes))",
 			.cra_driver_name = "authenc-hmac-sha512-cbc-aes-talitos",
 			.cra_blocksize = AES_BLOCK_SIZE,
@@ -2215,6 +2427,32 @@ static struct talitos_alg_template driver_algs[] = {
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
 		.alg.crypto = {
+			.cra_name = "authencesn(hmac(sha512),cbc(aes))",
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
+				     DESC_HDR_SEL0_AESU |
+				     DESC_HDR_MODE0_AESU_CBC |
+				     DESC_HDR_SEL1_MDEUB |
+				     DESC_HDR_MODE1_MDEU_INIT |
+				     DESC_HDR_MODE1_MDEU_PAD |
+				     DESC_HDR_MODE1_MDEUB_SHA512_HMAC,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AEAD,
+		.alg.crypto = {
 			.cra_name = "authenc(hmac(sha512),cbc(des3_ede))",
 			.cra_driver_name = "authenc-hmac-sha512-cbc-3des-talitos",
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
@@ -2242,6 +2480,33 @@ static struct talitos_alg_template driver_algs[] = {
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
 		.alg.crypto = {
+			.cra_name = "authencesn(hmac(sha512),cbc(des3_ede))",
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
+				     DESC_HDR_SEL0_DEU |
+				     DESC_HDR_MODE0_DEU_CBC |
+				     DESC_HDR_MODE0_DEU_3DES |
+				     DESC_HDR_SEL1_MDEUB |
+				     DESC_HDR_MODE1_MDEU_INIT |
+				     DESC_HDR_MODE1_MDEU_PAD |
+				     DESC_HDR_MODE1_MDEUB_SHA512_HMAC,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AEAD,
+		.alg.crypto = {
 			.cra_name = "authenc(hmac(md5),cbc(aes))",
 			.cra_driver_name = "authenc-hmac-md5-cbc-aes-talitos",
 			.cra_blocksize = AES_BLOCK_SIZE,
@@ -2268,6 +2533,32 @@ static struct talitos_alg_template driver_algs[] = {
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
 		.alg.crypto = {
+			.cra_name = "authencesn(hmac(md5),cbc(aes))",
+			.cra_driver_name = "authenc-hmac-md5-cbc-aes-talitos",
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
+				.maxauthsize = MD5_DIGEST_SIZE,
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
+				     DESC_HDR_SEL0_AESU |
+				     DESC_HDR_MODE0_AESU_CBC |
+				     DESC_HDR_SEL1_MDEUA |
+				     DESC_HDR_MODE1_MDEU_INIT |
+				     DESC_HDR_MODE1_MDEU_PAD |
+				     DESC_HDR_MODE1_MDEU_MD5_HMAC,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AEAD,
+		.alg.crypto = {
 			.cra_name = "authenc(hmac(md5),cbc(des3_ede))",
 			.cra_driver_name = "authenc-hmac-md5-cbc-3des-talitos",
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
@@ -2293,6 +2584,33 @@ static struct talitos_alg_template driver_algs[] = {
 		                     DESC_HDR_MODE1_MDEU_PAD |
 		                     DESC_HDR_MODE1_MDEU_MD5_HMAC,
 	},
+	{	.type = CRYPTO_ALG_TYPE_AEAD,
+		.alg.crypto = {
+			.cra_name = "authencesn(hmac(md5),cbc(des3_ede))",
+			.cra_driver_name = "authenc-hmac-md5-cbc-3des-talitos",
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
+				.maxauthsize = MD5_DIGEST_SIZE,
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
+				     DESC_HDR_SEL0_DEU |
+				     DESC_HDR_MODE0_DEU_CBC |
+				     DESC_HDR_MODE0_DEU_3DES |
+				     DESC_HDR_SEL1_MDEUA |
+				     DESC_HDR_MODE1_MDEU_INIT |
+				     DESC_HDR_MODE1_MDEU_PAD |
+				     DESC_HDR_MODE1_MDEU_MD5_HMAC,
+	},
 	/* ABLKCIPHER algorithms. */
 	{	.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
 		.alg.crypto = {
-- 
1.7.3.4
