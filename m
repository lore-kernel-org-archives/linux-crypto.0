From: George Cherian <george.cherian@cavium.com>
Subject: [PATCH v2 3/3] crypto: cavium: Add more algorithms
Date: Thu,  4 May 2017 11:34:46 +0000
Message-ID: <1493897686-12330-4-git-send-email-george.cherian@cavium.com>
References: <1493897686-12330-1-git-send-email-george.cherian@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: george.cherian@cavium.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
To: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam03on0050.outbound.protection.outlook.com ([104.47.42.50]:3520
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752500AbdEDLfR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 May 2017 07:35:17 -0400
In-Reply-To: <1493897686-12330-1-git-send-email-george.cherian@cavium.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add more algorithm support for the driver.
Add support for ecb(aes), cfb(aes) and ecb(des3_ede).

Signed-off-by: George Cherian <george.cherian@cavium.com>
---
 drivers/crypto/cavium/cpt/cptvf_algs.c | 81 ++++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

diff --git a/drivers/crypto/cavium/cpt/cptvf_algs.c b/drivers/crypto/cavium/cpt/cptvf_algs.c
index 443c362..1b220f3 100644
--- a/drivers/crypto/cavium/cpt/cptvf_algs.c
+++ b/drivers/crypto/cavium/cpt/cptvf_algs.c
@@ -312,12 +312,30 @@ static int cvm_cbc_aes_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 	return cvm_setkey(cipher, key, keylen, AES_CBC);
 }
 
+static int cvm_ecb_aes_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
+			      u32 keylen)
+{
+	return cvm_setkey(cipher, key, keylen, AES_ECB);
+}
+
+static int cvm_cfb_aes_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
+			      u32 keylen)
+{
+	return cvm_setkey(cipher, key, keylen, AES_CFB);
+}
+
 static int cvm_cbc_des3_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 			       u32 keylen)
 {
 	return cvm_setkey(cipher, key, keylen, DES3_CBC);
 }
 
+static int cvm_ecb_des3_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
+			       u32 keylen)
+{
+	return cvm_setkey(cipher, key, keylen, DES3_ECB);
+}
+
 int cvm_enc_dec_init(struct crypto_tfm *tfm)
 {
 	struct cvm_enc_ctx *ctx = crypto_tfm_ctx(tfm);
@@ -377,6 +395,48 @@ struct crypto_alg algs[] = { {
 	.cra_module = THIS_MODULE,
 }, {
 	.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize = AES_BLOCK_SIZE,
+	.cra_ctxsize = sizeof(struct cvm_enc_ctx),
+	.cra_alignmask = 7,
+	.cra_priority = 4001,
+	.cra_name = "ecb(aes)",
+	.cra_driver_name = "cavium-ecb-aes",
+	.cra_type = &crypto_ablkcipher_type,
+	.cra_u = {
+		.ablkcipher = {
+			.ivsize = AES_BLOCK_SIZE,
+			.min_keysize = AES_MIN_KEY_SIZE,
+			.max_keysize = AES_MAX_KEY_SIZE,
+			.setkey = cvm_ecb_aes_setkey,
+			.encrypt = cvm_encrypt,
+			.decrypt = cvm_decrypt,
+		},
+	},
+	.cra_init = cvm_enc_dec_init,
+	.cra_module = THIS_MODULE,
+}, {
+	.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize = AES_BLOCK_SIZE,
+	.cra_ctxsize = sizeof(struct cvm_enc_ctx),
+	.cra_alignmask = 7,
+	.cra_priority = 4001,
+	.cra_name = "cfb(aes)",
+	.cra_driver_name = "cavium-cfb-aes",
+	.cra_type = &crypto_ablkcipher_type,
+	.cra_u = {
+		.ablkcipher = {
+			.ivsize = AES_BLOCK_SIZE,
+			.min_keysize = AES_MIN_KEY_SIZE,
+			.max_keysize = AES_MAX_KEY_SIZE,
+			.setkey = cvm_cfb_aes_setkey,
+			.encrypt = cvm_encrypt,
+			.decrypt = cvm_decrypt,
+		},
+	},
+	.cra_init = cvm_enc_dec_init,
+	.cra_module = THIS_MODULE,
+}, {
+	.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 	.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 	.cra_ctxsize = sizeof(struct cvm_des3_ctx),
 	.cra_alignmask = 7,
@@ -396,6 +456,27 @@ struct crypto_alg algs[] = { {
 	},
 	.cra_init = cvm_enc_dec_init,
 	.cra_module = THIS_MODULE,
+}, {
+	.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+	.cra_ctxsize = sizeof(struct cvm_des3_ctx),
+	.cra_alignmask = 7,
+	.cra_priority = 4001,
+	.cra_name = "ecb(des3_ede)",
+	.cra_driver_name = "cavium-ecb-des3_ede",
+	.cra_type = &crypto_ablkcipher_type,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize = DES3_EDE_KEY_SIZE,
+			.max_keysize = DES3_EDE_KEY_SIZE,
+			.ivsize = DES_BLOCK_SIZE,
+			.setkey = cvm_ecb_des3_setkey,
+			.encrypt = cvm_encrypt,
+			.decrypt = cvm_decrypt,
+		},
+	},
+	.cra_init = cvm_enc_dec_init,
+	.cra_module = THIS_MODULE,
 } };
 
 static inline int cav_register_algs(void)
-- 
2.1.4
