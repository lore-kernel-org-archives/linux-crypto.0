Return-Path: <SRS0=g7fO=NJ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from foss.arm.com ([217.140.101.70]:37796 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729509AbeJ2Sia (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Oct 2018 14:38:30 -0400
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc: Ofir Drang <Ofir.Drang@arm.com>, Yael Chemla <Yael.Chemla@arm.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] crypto: ccree: add SM4 support
Date: Mon, 29 Oct 2018 09:50:14 +0000
Message-Id: <1540806616-5483-4-git-send-email-gilad@benyossef.com>
In-Reply-To: <1540806616-5483-1-git-send-email-gilad@benyossef.com>
References: <1540806616-5483-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add support for SM4 cipher in CryptoCell 713.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/Kconfig                  |  1 +
 drivers/crypto/ccree/cc_cipher.c        | 66 +++++++++++++++++++++++++++++++++
 drivers/crypto/ccree/cc_hw_queue_defs.h |  3 ++
 3 files changed, 70 insertions(+)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index bea4de6..c7e6f5d 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -751,6 +751,7 @@ config CRYPTO_DEV_CCREE
 	select CRYPTO_ECB
 	select CRYPTO_CTR
 	select CRYPTO_XTS
+	select CRYPTO_SM4
 	help
 	  Say 'Y' to enable a driver for the REE interface of the Arm
 	  TrustZone CryptoCell family of processors. Currently the
diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index 7623b299..989e70f 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -7,6 +7,7 @@
 #include <crypto/internal/skcipher.h>
 #include <crypto/des.h>
 #include <crypto/xts.h>
+#include <crypto/sm4.h>
 #include <crypto/scatterwalk.h>
 
 #include "cc_driver.h"
@@ -83,6 +84,9 @@ static int validate_keys_sizes(struct cc_cipher_ctx *ctx_p, u32 size)
 		if (size == DES3_EDE_KEY_SIZE || size == DES_KEY_SIZE)
 			return 0;
 		break;
+	case S_DIN_to_SM4:
+		if (size == SM4_KEY_SIZE)
+			return 0;
 	default:
 		break;
 	}
@@ -122,6 +126,17 @@ static int validate_data_size(struct cc_cipher_ctx *ctx_p,
 		if (IS_ALIGNED(size, DES_BLOCK_SIZE))
 			return 0;
 		break;
+	case S_DIN_to_SM4:
+		switch (ctx_p->cipher_mode) {
+		case DRV_CIPHER_CTR:
+			return 0;
+		case DRV_CIPHER_ECB:
+		case DRV_CIPHER_CBC:
+			if (IS_ALIGNED(size, SM4_BLOCK_SIZE))
+				return 0;
+		default:
+			break;
+		}
 	default:
 		break;
 	}
@@ -522,6 +537,9 @@ static void cc_setup_cipher_data(struct crypto_tfm *tfm,
 	case S_DIN_to_DES:
 		flow_mode = DIN_DES_DOUT;
 		break;
+	case S_DIN_to_SM4:
+		flow_mode = DIN_SM4_DOUT;
+		break;
 	default:
 		dev_err(dev, "invalid flow mode, flow_mode = %d\n", flow_mode);
 		return;
@@ -1324,6 +1342,54 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.flow_mode = S_DIN_to_DES,
 		.min_hw_rev = CC_HW_REV_630,
 	},
+	{
+		.name = "cbc(sm4)",
+		.driver_name = "cbc-sm4-ccree",
+		.blocksize = SM4_BLOCK_SIZE,
+		.template_skcipher = {
+			.setkey = cc_cipher_setkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
+			.min_keysize = SM4_KEY_SIZE,
+			.max_keysize = SM4_KEY_SIZE,
+			.ivsize = SM4_BLOCK_SIZE,
+			},
+		.cipher_mode = DRV_CIPHER_CBC,
+		.flow_mode = S_DIN_to_SM4,
+		.min_hw_rev = CC_HW_REV_713,
+	},
+	{
+		.name = "ecb(sm4)",
+		.driver_name = "ecb-sm4-ccree",
+		.blocksize = SM4_BLOCK_SIZE,
+		.template_skcipher = {
+			.setkey = cc_cipher_setkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
+			.min_keysize = SM4_KEY_SIZE,
+			.max_keysize = SM4_KEY_SIZE,
+			.ivsize = 0,
+			},
+		.cipher_mode = DRV_CIPHER_ECB,
+		.flow_mode = S_DIN_to_SM4,
+		.min_hw_rev = CC_HW_REV_713,
+	},
+	{
+		.name = "ctr(sm4)",
+		.driver_name = "ctr-sm4-ccree",
+		.blocksize = SM4_BLOCK_SIZE,
+		.template_skcipher = {
+			.setkey = cc_cipher_setkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
+			.min_keysize = SM4_KEY_SIZE,
+			.max_keysize = SM4_KEY_SIZE,
+			.ivsize = SM4_BLOCK_SIZE,
+			},
+		.cipher_mode = DRV_CIPHER_CTR,
+		.flow_mode = S_DIN_to_SM4,
+		.min_hw_rev = CC_HW_REV_713,
+	},
 };
 
 static struct cc_crypto_alg *cc_create_alg(const struct cc_alg_template *tmpl,
diff --git a/drivers/crypto/ccree/cc_hw_queue_defs.h b/drivers/crypto/ccree/cc_hw_queue_defs.h
index 45985b9..f719ff9c 100644
--- a/drivers/crypto/ccree/cc_hw_queue_defs.h
+++ b/drivers/crypto/ccree/cc_hw_queue_defs.h
@@ -107,6 +107,7 @@ enum cc_flow_mode {
 	AES_to_AES_to_HASH_and_DOUT	= 13,
 	AES_to_AES_to_HASH	= 14,
 	AES_to_HASH_and_AES	= 15,
+	DIN_SM4_DOUT		= 16,
 	DIN_AES_AESMAC		= 17,
 	HASH_to_DOUT		= 18,
 	/* setup flows */
@@ -114,9 +115,11 @@ enum cc_flow_mode {
 	S_DIN_to_AES2		= 33,
 	S_DIN_to_DES		= 34,
 	S_DIN_to_RC4		= 35,
+	S_DIN_to_SM4		= 36,
 	S_DIN_to_HASH		= 37,
 	S_AES_to_DOUT		= 38,
 	S_AES2_to_DOUT		= 39,
+	S_SM4_to_DOUT		= 40,
 	S_RC4_to_DOUT		= 41,
 	S_DES_to_DOUT		= 42,
 	S_HASH_to_DOUT		= 43,
-- 
2.7.4
