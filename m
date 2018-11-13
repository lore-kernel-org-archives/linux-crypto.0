Return-Path: <SRS0=KYvO=NY=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from foss.arm.com ([217.140.101.70]:50270 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731399AbeKMTie (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Nov 2018 14:38:34 -0500
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Yael Chemla <yael.chemla@foss.arm.com>
Cc: Ofir Drang <Ofir.Drang@arm.com>, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] crypto: ccree: add support for CryptoCell 703
Date: Tue, 13 Nov 2018 09:40:35 +0000
Message-Id: <1542102039-22256-2-git-send-email-gilad@benyossef.com>
In-Reply-To: <1542102039-22256-1-git-send-email-gilad@benyossef.com>
References: <1542102039-22256-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add support for Arm TrustZone CryptoCell 703.
The 703 is a variant of the CryptoCell 713 that supports only
algorithms certified by the Chinesse Office of the State Commercial
Cryptography Administration (OSCCA).

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/Kconfig           |  2 +-
 drivers/crypto/ccree/cc_aead.c   | 16 +++++++++++++++-
 drivers/crypto/ccree/cc_cipher.c | 38 +++++++++++++++++++++++++++++++++++++-
 drivers/crypto/ccree/cc_driver.c | 19 +++++++++++++++----
 drivers/crypto/ccree/cc_driver.h |  8 ++++++++
 drivers/crypto/ccree/cc_hash.c   | 16 ++++++++++++++--
 6 files changed, 90 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 9f1baae..d80751d 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -767,7 +767,7 @@ config CRYPTO_DEV_CCREE
 	help
 	  Say 'Y' to enable a driver for the REE interface of the Arm
 	  TrustZone CryptoCell family of processors. Currently the
-	  CryptoCell 713, 712, 710 and 630 are supported.
+	  CryptoCell 713, 703, 712, 710 and 630 are supported.
 	  Choose this if you wish to use hardware acceleration of
 	  cryptographic operations on the system REE.
 	  If unsure say Y.
diff --git a/drivers/crypto/ccree/cc_aead.c b/drivers/crypto/ccree/cc_aead.c
index e0ac376c..f2643cd 100644
--- a/drivers/crypto/ccree/cc_aead.c
+++ b/drivers/crypto/ccree/cc_aead.c
@@ -2367,6 +2367,7 @@ static struct cc_alg_template aead_algs[] = {
 		.flow_mode = S_DIN_to_AES,
 		.auth_mode = DRV_HASH_SHA1,
 		.min_hw_rev = CC_HW_REV_630,
+		.std_body = CC_STD_NIST,
 	},
 	{
 		.name = "authenc(hmac(sha1),cbc(des3_ede))",
@@ -2386,6 +2387,7 @@ static struct cc_alg_template aead_algs[] = {
 		.flow_mode = S_DIN_to_DES,
 		.auth_mode = DRV_HASH_SHA1,
 		.min_hw_rev = CC_HW_REV_630,
+		.std_body = CC_STD_NIST,
 	},
 	{
 		.name = "authenc(hmac(sha256),cbc(aes))",
@@ -2405,6 +2407,7 @@ static struct cc_alg_template aead_algs[] = {
 		.flow_mode = S_DIN_to_AES,
 		.auth_mode = DRV_HASH_SHA256,
 		.min_hw_rev = CC_HW_REV_630,
+		.std_body = CC_STD_NIST,
 	},
 	{
 		.name = "authenc(hmac(sha256),cbc(des3_ede))",
@@ -2424,6 +2427,7 @@ static struct cc_alg_template aead_algs[] = {
 		.flow_mode = S_DIN_to_DES,
 		.auth_mode = DRV_HASH_SHA256,
 		.min_hw_rev = CC_HW_REV_630,
+		.std_body = CC_STD_NIST,
 	},
 	{
 		.name = "authenc(xcbc(aes),cbc(aes))",
@@ -2443,6 +2447,7 @@ static struct cc_alg_template aead_algs[] = {
 		.flow_mode = S_DIN_to_AES,
 		.auth_mode = DRV_HASH_XCBC_MAC,
 		.min_hw_rev = CC_HW_REV_630,
+		.std_body = CC_STD_NIST,
 	},
 	{
 		.name = "authenc(hmac(sha1),rfc3686(ctr(aes)))",
@@ -2462,6 +2467,7 @@ static struct cc_alg_template aead_algs[] = {
 		.flow_mode = S_DIN_to_AES,
 		.auth_mode = DRV_HASH_SHA1,
 		.min_hw_rev = CC_HW_REV_630,
+		.std_body = CC_STD_NIST,
 	},
 	{
 		.name = "authenc(hmac(sha256),rfc3686(ctr(aes)))",
@@ -2481,6 +2487,7 @@ static struct cc_alg_template aead_algs[] = {
 		.flow_mode = S_DIN_to_AES,
 		.auth_mode = DRV_HASH_SHA256,
 		.min_hw_rev = CC_HW_REV_630,
+		.std_body = CC_STD_NIST,
 	},
 	{
 		.name = "authenc(xcbc(aes),rfc3686(ctr(aes)))",
@@ -2500,6 +2507,7 @@ static struct cc_alg_template aead_algs[] = {
 		.flow_mode = S_DIN_to_AES,
 		.auth_mode = DRV_HASH_XCBC_MAC,
 		.min_hw_rev = CC_HW_REV_630,
+		.std_body = CC_STD_NIST,
 	},
 	{
 		.name = "ccm(aes)",
@@ -2519,6 +2527,7 @@ static struct cc_alg_template aead_algs[] = {
 		.flow_mode = S_DIN_to_AES,
 		.auth_mode = DRV_HASH_NULL,
 		.min_hw_rev = CC_HW_REV_630,
+		.std_body = CC_STD_NIST,
 	},
 	{
 		.name = "rfc4309(ccm(aes))",
@@ -2538,6 +2547,7 @@ static struct cc_alg_template aead_algs[] = {
 		.flow_mode = S_DIN_to_AES,
 		.auth_mode = DRV_HASH_NULL,
 		.min_hw_rev = CC_HW_REV_630,
+		.std_body = CC_STD_NIST,
 	},
 	{
 		.name = "gcm(aes)",
@@ -2557,6 +2567,7 @@ static struct cc_alg_template aead_algs[] = {
 		.flow_mode = S_DIN_to_AES,
 		.auth_mode = DRV_HASH_NULL,
 		.min_hw_rev = CC_HW_REV_630,
+		.std_body = CC_STD_NIST,
 	},
 	{
 		.name = "rfc4106(gcm(aes))",
@@ -2576,6 +2587,7 @@ static struct cc_alg_template aead_algs[] = {
 		.flow_mode = S_DIN_to_AES,
 		.auth_mode = DRV_HASH_NULL,
 		.min_hw_rev = CC_HW_REV_630,
+		.std_body = CC_STD_NIST,
 	},
 	{
 		.name = "rfc4543(gcm(aes))",
@@ -2595,6 +2607,7 @@ static struct cc_alg_template aead_algs[] = {
 		.flow_mode = S_DIN_to_AES,
 		.auth_mode = DRV_HASH_NULL,
 		.min_hw_rev = CC_HW_REV_630,
+		.std_body = CC_STD_NIST,
 	},
 };
 
@@ -2679,7 +2692,8 @@ int cc_aead_alloc(struct cc_drvdata *drvdata)
 
 	/* Linux crypto */
 	for (alg = 0; alg < ARRAY_SIZE(aead_algs); alg++) {
-		if (aead_algs[alg].min_hw_rev > drvdata->hw_rev)
+		if ((aead_algs[alg].min_hw_rev > drvdata->hw_rev) ||
+		    !(drvdata->std_bodies & aead_algs[alg].std_body))
 			continue;
 
 		t_alg = cc_create_aead_alg(&aead_algs[alg], dev);
diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index 989e70f..cc92b03 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -833,6 +833,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.cipher_mode = DRV_CIPHER_XTS,
 		.flow_mode = S_DIN_to_AES,
 		.min_hw_rev = CC_HW_REV_630,
+		.std_body = CC_STD_NIST,
 	},
 	{
 		.name = "xts512(paes)",
@@ -850,6 +851,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.flow_mode = S_DIN_to_AES,
 		.data_unit = 512,
 		.min_hw_rev = CC_HW_REV_712,
+		.std_body = CC_STD_NIST,
 	},
 	{
 		.name = "xts4096(paes)",
@@ -867,6 +869,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.flow_mode = S_DIN_to_AES,
 		.data_unit = 4096,
 		.min_hw_rev = CC_HW_REV_712,
+		.std_body = CC_STD_NIST,
 	},
 	{
 		.name = "essiv(paes)",
@@ -883,6 +886,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.cipher_mode = DRV_CIPHER_ESSIV,
 		.flow_mode = S_DIN_to_AES,
 		.min_hw_rev = CC_HW_REV_712,
+		.std_body = CC_STD_NIST,
 	},
 	{
 		.name = "essiv512(paes)",
@@ -900,6 +904,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.flow_mode = S_DIN_to_AES,
 		.data_unit = 512,
 		.min_hw_rev = CC_HW_REV_712,
+		.std_body = CC_STD_NIST,
 	},
 	{
 		.name = "essiv4096(paes)",
@@ -917,6 +922,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.flow_mode = S_DIN_to_AES,
 		.data_unit = 4096,
 		.min_hw_rev = CC_HW_REV_712,
+		.std_body = CC_STD_NIST,
 	},
 	{
 		.name = "bitlocker(paes)",
@@ -933,6 +939,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.cipher_mode = DRV_CIPHER_BITLOCKER,
 		.flow_mode = S_DIN_to_AES,
 		.min_hw_rev = CC_HW_REV_712,
+		.std_body = CC_STD_NIST,
 	},
 	{
 		.name = "bitlocker512(paes)",
@@ -950,6 +957,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.flow_mode = S_DIN_to_AES,
 		.data_unit = 512,
 		.min_hw_rev = CC_HW_REV_712,
+		.std_body = CC_STD_NIST,
 	},
 	{
 		.name = "bitlocker4096(paes)",
@@ -967,6 +975,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.flow_mode = S_DIN_to_AES,
 		.data_unit = 4096,
 		.min_hw_rev = CC_HW_REV_712,
+		.std_body = CC_STD_NIST,
 	},
 	{
 		.name = "ecb(paes)",
@@ -983,6 +992,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.cipher_mode = DRV_CIPHER_ECB,
 		.flow_mode = S_DIN_to_AES,
 		.min_hw_rev = CC_HW_REV_712,
+		.std_body = CC_STD_NIST,
 	},
 	{
 		.name = "cbc(paes)",
@@ -999,6 +1009,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.cipher_mode = DRV_CIPHER_CBC,
 		.flow_mode = S_DIN_to_AES,
 		.min_hw_rev = CC_HW_REV_712,
+		.std_body = CC_STD_NIST,
 	},
 	{
 		.name = "ofb(paes)",
@@ -1015,6 +1026,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.cipher_mode = DRV_CIPHER_OFB,
 		.flow_mode = S_DIN_to_AES,
 		.min_hw_rev = CC_HW_REV_712,
+		.std_body = CC_STD_NIST,
 	},
 	{
 		.name = "cts(cbc(paes))",
@@ -1031,6 +1043,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.cipher_mode = DRV_CIPHER_CBC_CTS,
 		.flow_mode = S_DIN_to_AES,
 		.min_hw_rev = CC_HW_REV_712,
+		.std_body = CC_STD_NIST,
 	},
 	{
 		.name = "ctr(paes)",
@@ -1047,6 +1060,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.cipher_mode = DRV_CIPHER_CTR,
 		.flow_mode = S_DIN_to_AES,
 		.min_hw_rev = CC_HW_REV_712,
+		.std_body = CC_STD_NIST,
 	},
 	{
 		.name = "xts(aes)",
@@ -1063,6 +1077,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.cipher_mode = DRV_CIPHER_XTS,
 		.flow_mode = S_DIN_to_AES,
 		.min_hw_rev = CC_HW_REV_630,
+		.std_body = CC_STD_NIST,
 	},
 	{
 		.name = "xts512(aes)",
@@ -1080,6 +1095,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.flow_mode = S_DIN_to_AES,
 		.data_unit = 512,
 		.min_hw_rev = CC_HW_REV_712,
+		.std_body = CC_STD_NIST,
 	},
 	{
 		.name = "xts4096(aes)",
@@ -1097,6 +1113,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.flow_mode = S_DIN_to_AES,
 		.data_unit = 4096,
 		.min_hw_rev = CC_HW_REV_712,
+		.std_body = CC_STD_NIST,
 	},
 	{
 		.name = "essiv(aes)",
@@ -1113,6 +1130,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.cipher_mode = DRV_CIPHER_ESSIV,
 		.flow_mode = S_DIN_to_AES,
 		.min_hw_rev = CC_HW_REV_712,
+		.std_body = CC_STD_NIST,
 	},
 	{
 		.name = "essiv512(aes)",
@@ -1130,6 +1148,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.flow_mode = S_DIN_to_AES,
 		.data_unit = 512,
 		.min_hw_rev = CC_HW_REV_712,
+		.std_body = CC_STD_NIST,
 	},
 	{
 		.name = "essiv4096(aes)",
@@ -1147,6 +1166,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.flow_mode = S_DIN_to_AES,
 		.data_unit = 4096,
 		.min_hw_rev = CC_HW_REV_712,
+		.std_body = CC_STD_NIST,
 	},
 	{
 		.name = "bitlocker(aes)",
@@ -1163,6 +1183,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.cipher_mode = DRV_CIPHER_BITLOCKER,
 		.flow_mode = S_DIN_to_AES,
 		.min_hw_rev = CC_HW_REV_712,
+		.std_body = CC_STD_NIST,
 	},
 	{
 		.name = "bitlocker512(aes)",
@@ -1180,6 +1201,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.flow_mode = S_DIN_to_AES,
 		.data_unit = 512,
 		.min_hw_rev = CC_HW_REV_712,
+		.std_body = CC_STD_NIST,
 	},
 	{
 		.name = "bitlocker4096(aes)",
@@ -1197,6 +1219,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.flow_mode = S_DIN_to_AES,
 		.data_unit = 4096,
 		.min_hw_rev = CC_HW_REV_712,
+		.std_body = CC_STD_NIST,
 	},
 	{
 		.name = "ecb(aes)",
@@ -1213,6 +1236,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.cipher_mode = DRV_CIPHER_ECB,
 		.flow_mode = S_DIN_to_AES,
 		.min_hw_rev = CC_HW_REV_630,
+		.std_body = CC_STD_NIST,
 	},
 	{
 		.name = "cbc(aes)",
@@ -1229,6 +1253,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.cipher_mode = DRV_CIPHER_CBC,
 		.flow_mode = S_DIN_to_AES,
 		.min_hw_rev = CC_HW_REV_630,
+		.std_body = CC_STD_NIST,
 	},
 	{
 		.name = "ofb(aes)",
@@ -1245,6 +1270,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.cipher_mode = DRV_CIPHER_OFB,
 		.flow_mode = S_DIN_to_AES,
 		.min_hw_rev = CC_HW_REV_630,
+		.std_body = CC_STD_NIST,
 	},
 	{
 		.name = "cts(cbc(aes))",
@@ -1261,6 +1287,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.cipher_mode = DRV_CIPHER_CBC_CTS,
 		.flow_mode = S_DIN_to_AES,
 		.min_hw_rev = CC_HW_REV_630,
+		.std_body = CC_STD_NIST,
 	},
 	{
 		.name = "ctr(aes)",
@@ -1277,6 +1304,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.cipher_mode = DRV_CIPHER_CTR,
 		.flow_mode = S_DIN_to_AES,
 		.min_hw_rev = CC_HW_REV_630,
+		.std_body = CC_STD_NIST,
 	},
 	{
 		.name = "cbc(des3_ede)",
@@ -1293,6 +1321,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.cipher_mode = DRV_CIPHER_CBC,
 		.flow_mode = S_DIN_to_DES,
 		.min_hw_rev = CC_HW_REV_630,
+		.std_body = CC_STD_NIST,
 	},
 	{
 		.name = "ecb(des3_ede)",
@@ -1309,6 +1338,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.cipher_mode = DRV_CIPHER_ECB,
 		.flow_mode = S_DIN_to_DES,
 		.min_hw_rev = CC_HW_REV_630,
+		.std_body = CC_STD_NIST,
 	},
 	{
 		.name = "cbc(des)",
@@ -1325,6 +1355,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.cipher_mode = DRV_CIPHER_CBC,
 		.flow_mode = S_DIN_to_DES,
 		.min_hw_rev = CC_HW_REV_630,
+		.std_body = CC_STD_NIST,
 	},
 	{
 		.name = "ecb(des)",
@@ -1341,6 +1372,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.cipher_mode = DRV_CIPHER_ECB,
 		.flow_mode = S_DIN_to_DES,
 		.min_hw_rev = CC_HW_REV_630,
+		.std_body = CC_STD_NIST,
 	},
 	{
 		.name = "cbc(sm4)",
@@ -1357,6 +1389,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.cipher_mode = DRV_CIPHER_CBC,
 		.flow_mode = S_DIN_to_SM4,
 		.min_hw_rev = CC_HW_REV_713,
+		.std_body = CC_STD_OSCCA,
 	},
 	{
 		.name = "ecb(sm4)",
@@ -1373,6 +1406,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.cipher_mode = DRV_CIPHER_ECB,
 		.flow_mode = S_DIN_to_SM4,
 		.min_hw_rev = CC_HW_REV_713,
+		.std_body = CC_STD_OSCCA,
 	},
 	{
 		.name = "ctr(sm4)",
@@ -1389,6 +1423,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.cipher_mode = DRV_CIPHER_CTR,
 		.flow_mode = S_DIN_to_SM4,
 		.min_hw_rev = CC_HW_REV_713,
+		.std_body = CC_STD_OSCCA,
 	},
 };
 
@@ -1464,7 +1499,8 @@ int cc_cipher_alloc(struct cc_drvdata *drvdata)
 	dev_dbg(dev, "Number of algorithms = %zu\n",
 		ARRAY_SIZE(skcipher_algs));
 	for (alg = 0; alg < ARRAY_SIZE(skcipher_algs); alg++) {
-		if (skcipher_algs[alg].min_hw_rev > drvdata->hw_rev)
+		if ((skcipher_algs[alg].min_hw_rev > drvdata->hw_rev) ||
+		    !(drvdata->std_bodies & skcipher_algs[alg].std_body))
 			continue;
 
 		dev_dbg(dev, "creating %s\n", skcipher_algs[alg].driver_name);
diff --git a/drivers/crypto/ccree/cc_driver.c b/drivers/crypto/ccree/cc_driver.c
index 09a6ada..8ada308 100644
--- a/drivers/crypto/ccree/cc_driver.c
+++ b/drivers/crypto/ccree/cc_driver.c
@@ -39,27 +39,37 @@ struct cc_hw_data {
 	char *name;
 	enum cc_hw_rev rev;
 	u32 sig;
+	int std_bodies;
 };
 
 /* Hardware revisions defs. */
 
+/* The 703 is a OSCCA only variant of the 713 */
+static const struct cc_hw_data cc703_hw = {
+	.name = "703", .rev = CC_HW_REV_713, .std_bodies = CC_STD_OSCCA
+};
+
 static const struct cc_hw_data cc713_hw = {
-	.name = "713", .rev = CC_HW_REV_713
+	.name = "713", .rev = CC_HW_REV_713, .std_bodies = CC_STD_ALL
 };
 
 static const struct cc_hw_data cc712_hw = {
-	.name = "712", .rev = CC_HW_REV_712, .sig =  0xDCC71200U
+	.name = "712", .rev = CC_HW_REV_712, .sig =  0xDCC71200U,
+	.std_bodies = CC_STD_ALL
 };
 
 static const struct cc_hw_data cc710_hw = {
-	.name = "710", .rev = CC_HW_REV_710, .sig =  0xDCC63200U
+	.name = "710", .rev = CC_HW_REV_710, .sig =  0xDCC63200U,
+	.std_bodies = CC_STD_ALL
 };
 
 static const struct cc_hw_data cc630p_hw = {
-	.name = "630P", .rev = CC_HW_REV_630, .sig = 0xDCC63000U
+	.name = "630P", .rev = CC_HW_REV_630, .sig = 0xDCC63000U,
+	.std_bodies = CC_STD_ALL
 };
 
 static const struct of_device_id arm_ccree_dev_of_match[] = {
+	{ .compatible = "arm,cryptocell-703-ree", .data = &cc703_hw },
 	{ .compatible = "arm,cryptocell-713-ree", .data = &cc713_hw },
 	{ .compatible = "arm,cryptocell-712-ree", .data = &cc712_hw },
 	{ .compatible = "arm,cryptocell-710-ree", .data = &cc710_hw },
@@ -209,6 +219,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	hw_rev = (struct cc_hw_data *)dev_id->data;
 	new_drvdata->hw_rev_name = hw_rev->name;
 	new_drvdata->hw_rev = hw_rev->rev;
+	new_drvdata->std_bodies = hw_rev->std_bodies;
 
 	if (hw_rev->rev >= CC_HW_REV_712) {
 		new_drvdata->axim_mon_offset = CC_REG(AXIM_MON_COMP);
diff --git a/drivers/crypto/ccree/cc_driver.h b/drivers/crypto/ccree/cc_driver.h
index 1707909..5be7fd4 100644
--- a/drivers/crypto/ccree/cc_driver.h
+++ b/drivers/crypto/ccree/cc_driver.h
@@ -45,6 +45,12 @@ enum cc_hw_rev {
 	CC_HW_REV_713 = 713
 };
 
+enum cc_std_body {
+	CC_STD_NIST = 0x1,
+	CC_STD_OSCCA = 0x2,
+	CC_STD_ALL = 0x3
+};
+
 #define CC_COHERENT_CACHE_PARAMS 0xEEE
 
 /* Maximum DMA mask supported by IP */
@@ -131,6 +137,7 @@ struct cc_drvdata {
 	u32 axim_mon_offset;
 	u32 sig_offset;
 	u32 ver_offset;
+	int std_bodies;
 };
 
 struct cc_crypto_alg {
@@ -156,6 +163,7 @@ struct cc_alg_template {
 	int flow_mode; /* Note: currently, refers to the cipher mode only. */
 	int auth_mode;
 	u32 min_hw_rev;
+	enum cc_std_body std_body;
 	unsigned int data_unit;
 	struct cc_drvdata *drvdata;
 };
diff --git a/drivers/crypto/ccree/cc_hash.c b/drivers/crypto/ccree/cc_hash.c
index c80c9ae..2c4ddc8 100644
--- a/drivers/crypto/ccree/cc_hash.c
+++ b/drivers/crypto/ccree/cc_hash.c
@@ -1539,6 +1539,7 @@ struct cc_hash_template {
 	int inter_digestsize;
 	struct cc_drvdata *drvdata;
 	u32 min_hw_rev;
+	enum cc_std_body std_body;
 };
 
 #define CC_STATE_SIZE(_x) \
@@ -1573,6 +1574,7 @@ static struct cc_hash_template driver_hash[] = {
 		.hw_mode = DRV_HASH_HW_SHA1,
 		.inter_digestsize = SHA1_DIGEST_SIZE,
 		.min_hw_rev = CC_HW_REV_630,
+		.std_body = CC_STD_NIST,
 	},
 	{
 		.name = "sha256",
@@ -1599,6 +1601,7 @@ static struct cc_hash_template driver_hash[] = {
 		.hw_mode = DRV_HASH_HW_SHA256,
 		.inter_digestsize = SHA256_DIGEST_SIZE,
 		.min_hw_rev = CC_HW_REV_630,
+		.std_body = CC_STD_NIST,
 	},
 	{
 		.name = "sha224",
@@ -1625,6 +1628,7 @@ static struct cc_hash_template driver_hash[] = {
 		.hw_mode = DRV_HASH_HW_SHA256,
 		.inter_digestsize = SHA256_DIGEST_SIZE,
 		.min_hw_rev = CC_HW_REV_630,
+		.std_body = CC_STD_NIST,
 	},
 	{
 		.name = "sha384",
@@ -1651,6 +1655,7 @@ static struct cc_hash_template driver_hash[] = {
 		.hw_mode = DRV_HASH_HW_SHA512,
 		.inter_digestsize = SHA512_DIGEST_SIZE,
 		.min_hw_rev = CC_HW_REV_712,
+		.std_body = CC_STD_NIST,
 	},
 	{
 		.name = "sha512",
@@ -1677,6 +1682,7 @@ static struct cc_hash_template driver_hash[] = {
 		.hw_mode = DRV_HASH_HW_SHA512,
 		.inter_digestsize = SHA512_DIGEST_SIZE,
 		.min_hw_rev = CC_HW_REV_712,
+		.std_body = CC_STD_NIST,
 	},
 	{
 		.name = "md5",
@@ -1703,6 +1709,7 @@ static struct cc_hash_template driver_hash[] = {
 		.hw_mode = DRV_HASH_HW_MD5,
 		.inter_digestsize = MD5_DIGEST_SIZE,
 		.min_hw_rev = CC_HW_REV_630,
+		.std_body = CC_STD_NIST,
 	},
 	{
 		.name = "sm3",
@@ -1727,6 +1734,7 @@ static struct cc_hash_template driver_hash[] = {
 		.hw_mode = DRV_HASH_HW_SM3,
 		.inter_digestsize = SM3_DIGEST_SIZE,
 		.min_hw_rev = CC_HW_REV_713,
+		.std_body = CC_STD_OSCCA,
 	},
 	{
 		.mac_name = "xcbc(aes)",
@@ -1751,6 +1759,7 @@ static struct cc_hash_template driver_hash[] = {
 		.hw_mode = DRV_CIPHER_XCBC_MAC,
 		.inter_digestsize = AES_BLOCK_SIZE,
 		.min_hw_rev = CC_HW_REV_630,
+		.std_body = CC_STD_NIST,
 	},
 	{
 		.mac_name = "cmac(aes)",
@@ -1775,6 +1784,7 @@ static struct cc_hash_template driver_hash[] = {
 		.hw_mode = DRV_CIPHER_CMAC,
 		.inter_digestsize = AES_BLOCK_SIZE,
 		.min_hw_rev = CC_HW_REV_630,
+		.std_body = CC_STD_NIST,
 	},
 };
 
@@ -2001,9 +2011,11 @@ int cc_hash_alloc(struct cc_drvdata *drvdata)
 		struct cc_hash_alg *t_alg;
 		int hw_mode = driver_hash[alg].hw_mode;
 
-		/* We either support both HASH and MAC or none */
-		if (driver_hash[alg].min_hw_rev > drvdata->hw_rev)
+		/* Check that the HW revision and variants are suitable */
+		if ((driver_hash[alg].min_hw_rev > drvdata->hw_rev) ||
+		    !(drvdata->std_bodies & driver_hash[alg].std_body))
 			continue;
+
 		if (driver_hash[alg].is_mac) {
 			/* register hmac version */
 			t_alg = cc_alloc_hash_alg(&driver_hash[alg], dev, true);
-- 
2.7.4
