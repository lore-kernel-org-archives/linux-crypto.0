From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH v2 7/7] crypto: talitos - templates for AEAD using
 HMAC_SNOOP_NO_AFEU
Date: Mon,  6 Jun 2016 13:20:46 +0200 (CEST)
Message-ID: <fa7c4346e0f30a32520241be3e80ce7442b6be8e.1464390096.git.christophe.leroy@c-s.fr>
References: <cover.1464390094.git.christophe.leroy@c-s.fr>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@arm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	David S Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:12888 "EHLO pegase1.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602AbcFFNDm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 6 Jun 2016 09:03:42 -0400
In-Reply-To: <cover.1464390094.git.christophe.leroy@c-s.fr>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This will allow IPSEC on SEC1

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/crypto/talitos.c | 180 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 180 insertions(+)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index dfd3a93..0418a2f 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -811,6 +811,11 @@ static void talitos_unregister_rng(struct device *dev)
  * crypto alg
  */
 #define TALITOS_CRA_PRIORITY		3000
+/*
+ * Defines a priority for doing AEAD with descriptors type
+ * HMAC_SNOOP_NO_AFEA (HSNA) instead of type IPSEC_ESP
+ */
+#define TALITOS_CRA_PRIORITY_AEAD_HSNA	(TALITOS_CRA_PRIORITY - 1)
 #define TALITOS_MAX_KEY_SIZE		96
 #define TALITOS_MAX_IV_LENGTH		16 /* max of AES_BLOCK_SIZE, DES3_EDE_BLOCK_SIZE */
 
@@ -2152,6 +2157,27 @@ static struct talitos_alg_template driver_algs[] = {
 		                     DESC_HDR_MODE1_MDEU_SHA1_HMAC,
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
+		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
+		.alg.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha1),cbc(aes))",
+				.cra_driver_name = "authenc-hmac-sha1-"
+						   "cbc-aes-talitos",
+				.cra_blocksize = AES_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_ASYNC,
+			},
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize = SHA1_DIGEST_SIZE,
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_AESU |
+				     DESC_HDR_MODE0_AESU_CBC |
+				     DESC_HDR_SEL1_MDEUA |
+				     DESC_HDR_MODE1_MDEU_INIT |
+				     DESC_HDR_MODE1_MDEU_PAD |
+				     DESC_HDR_MODE1_MDEU_SHA1_HMAC,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AEAD,
 		.alg.aead = {
 			.base = {
 				.cra_name = "authenc(hmac(sha1),"
@@ -2173,6 +2199,29 @@ static struct talitos_alg_template driver_algs[] = {
 		                     DESC_HDR_MODE1_MDEU_PAD |
 		                     DESC_HDR_MODE1_MDEU_SHA1_HMAC,
 	},
+	{	.type = CRYPTO_ALG_TYPE_AEAD,
+		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
+		.alg.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha1),"
+					    "cbc(des3_ede))",
+				.cra_driver_name = "authenc-hmac-sha1-"
+						   "cbc-3des-talitos",
+				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_ASYNC,
+			},
+			.ivsize = DES3_EDE_BLOCK_SIZE,
+			.maxauthsize = SHA1_DIGEST_SIZE,
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_DEU |
+				     DESC_HDR_MODE0_DEU_CBC |
+				     DESC_HDR_MODE0_DEU_3DES |
+				     DESC_HDR_SEL1_MDEUA |
+				     DESC_HDR_MODE1_MDEU_INIT |
+				     DESC_HDR_MODE1_MDEU_PAD |
+				     DESC_HDR_MODE1_MDEU_SHA1_HMAC,
+	},
 	{       .type = CRYPTO_ALG_TYPE_AEAD,
 		.alg.aead = {
 			.base = {
@@ -2193,6 +2242,27 @@ static struct talitos_alg_template driver_algs[] = {
 				     DESC_HDR_MODE1_MDEU_PAD |
 				     DESC_HDR_MODE1_MDEU_SHA224_HMAC,
 	},
+	{       .type = CRYPTO_ALG_TYPE_AEAD,
+		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
+		.alg.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha224),cbc(aes))",
+				.cra_driver_name = "authenc-hmac-sha224-"
+						   "cbc-aes-talitos",
+				.cra_blocksize = AES_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_ASYNC,
+			},
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize = SHA224_DIGEST_SIZE,
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_AESU |
+				     DESC_HDR_MODE0_AESU_CBC |
+				     DESC_HDR_SEL1_MDEUA |
+				     DESC_HDR_MODE1_MDEU_INIT |
+				     DESC_HDR_MODE1_MDEU_PAD |
+				     DESC_HDR_MODE1_MDEU_SHA224_HMAC,
+	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
 		.alg.aead = {
 			.base = {
@@ -2216,6 +2286,29 @@ static struct talitos_alg_template driver_algs[] = {
 		                     DESC_HDR_MODE1_MDEU_SHA224_HMAC,
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
+		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
+		.alg.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha224),"
+					    "cbc(des3_ede))",
+				.cra_driver_name = "authenc-hmac-sha224-"
+						   "cbc-3des-talitos",
+				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_ASYNC,
+			},
+			.ivsize = DES3_EDE_BLOCK_SIZE,
+			.maxauthsize = SHA224_DIGEST_SIZE,
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_DEU |
+				     DESC_HDR_MODE0_DEU_CBC |
+				     DESC_HDR_MODE0_DEU_3DES |
+				     DESC_HDR_SEL1_MDEUA |
+				     DESC_HDR_MODE1_MDEU_INIT |
+				     DESC_HDR_MODE1_MDEU_PAD |
+				     DESC_HDR_MODE1_MDEU_SHA224_HMAC,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AEAD,
 		.alg.aead = {
 			.base = {
 				.cra_name = "authenc(hmac(sha256),cbc(aes))",
@@ -2236,6 +2329,27 @@ static struct talitos_alg_template driver_algs[] = {
 		                     DESC_HDR_MODE1_MDEU_SHA256_HMAC,
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
+		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
+		.alg.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha256),cbc(aes))",
+				.cra_driver_name = "authenc-hmac-sha256-"
+						   "cbc-aes-talitos",
+				.cra_blocksize = AES_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_ASYNC,
+			},
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize = SHA256_DIGEST_SIZE,
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_AESU |
+				     DESC_HDR_MODE0_AESU_CBC |
+				     DESC_HDR_SEL1_MDEUA |
+				     DESC_HDR_MODE1_MDEU_INIT |
+				     DESC_HDR_MODE1_MDEU_PAD |
+				     DESC_HDR_MODE1_MDEU_SHA256_HMAC,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AEAD,
 		.alg.aead = {
 			.base = {
 				.cra_name = "authenc(hmac(sha256),"
@@ -2258,6 +2372,29 @@ static struct talitos_alg_template driver_algs[] = {
 		                     DESC_HDR_MODE1_MDEU_SHA256_HMAC,
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
+		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
+		.alg.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha256),"
+					    "cbc(des3_ede))",
+				.cra_driver_name = "authenc-hmac-sha256-"
+						   "cbc-3des-talitos",
+				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_ASYNC,
+			},
+			.ivsize = DES3_EDE_BLOCK_SIZE,
+			.maxauthsize = SHA256_DIGEST_SIZE,
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_DEU |
+				     DESC_HDR_MODE0_DEU_CBC |
+				     DESC_HDR_MODE0_DEU_3DES |
+				     DESC_HDR_SEL1_MDEUA |
+				     DESC_HDR_MODE1_MDEU_INIT |
+				     DESC_HDR_MODE1_MDEU_PAD |
+				     DESC_HDR_MODE1_MDEU_SHA256_HMAC,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AEAD,
 		.alg.aead = {
 			.base = {
 				.cra_name = "authenc(hmac(sha384),cbc(aes))",
@@ -2362,6 +2499,27 @@ static struct talitos_alg_template driver_algs[] = {
 		                     DESC_HDR_MODE1_MDEU_MD5_HMAC,
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
+		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
+		.alg.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(md5),cbc(aes))",
+				.cra_driver_name = "authenc-hmac-md5-"
+						   "cbc-aes-talitos",
+				.cra_blocksize = AES_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_ASYNC,
+			},
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize = MD5_DIGEST_SIZE,
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_AESU |
+				     DESC_HDR_MODE0_AESU_CBC |
+				     DESC_HDR_SEL1_MDEUA |
+				     DESC_HDR_MODE1_MDEU_INIT |
+				     DESC_HDR_MODE1_MDEU_PAD |
+				     DESC_HDR_MODE1_MDEU_MD5_HMAC,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AEAD,
 		.alg.aead = {
 			.base = {
 				.cra_name = "authenc(hmac(md5),cbc(des3_ede))",
@@ -2382,6 +2540,28 @@ static struct talitos_alg_template driver_algs[] = {
 		                     DESC_HDR_MODE1_MDEU_PAD |
 		                     DESC_HDR_MODE1_MDEU_MD5_HMAC,
 	},
+	{	.type = CRYPTO_ALG_TYPE_AEAD,
+		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
+		.alg.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(md5),cbc(des3_ede))",
+				.cra_driver_name = "authenc-hmac-md5-"
+						   "cbc-3des-talitos",
+				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_ASYNC,
+			},
+			.ivsize = DES3_EDE_BLOCK_SIZE,
+			.maxauthsize = MD5_DIGEST_SIZE,
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
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
2.1.0
