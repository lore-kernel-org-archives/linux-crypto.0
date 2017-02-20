From: Ryder Lee <ryder.lee@mediatek.com>
Subject: [PATCH 9/9] crypto: mediatek - add support to OFB mode and CFB128 mode
Date: Mon, 20 Feb 2017 17:27:02 +0800
Message-ID: <1487582822-30393-10-git-send-email-ryder.lee@mediatek.com>
References: <1487582822-30393-1-git-send-email-ryder.lee@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-mediatek@lists.infradead.org>,
        <linux-crypto@vger.kernel.org>, Ryder Lee <ryder.lee@mediatek.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:50594 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752421AbdBTJ1W (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Feb 2017 04:27:22 -0500
In-Reply-To: <1487582822-30393-1-git-send-email-ryder.lee@mediatek.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds support to OFB mode and CFB128 mode.

Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
---
 drivers/crypto/mediatek/mtk-aes.c | 84 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 78 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/mediatek/mtk-aes.c b/drivers/crypto/mediatek/mtk-aes.c
index 9e845e8..c2bdfb9 100644
--- a/drivers/crypto/mediatek/mtk-aes.c
+++ b/drivers/crypto/mediatek/mtk-aes.c
@@ -25,7 +25,7 @@
 
 #define AES_CT_CTRL_HDR		cpu_to_le32(0x00220000)
 
-/* AES-CBC/ECB/CTR command token */
+/* AES-CBC/ECB/CTR/OFB/CFB command token */
 #define AES_CMD0		cpu_to_le32(0x05000000)
 #define AES_CMD1		cpu_to_le32(0x2d060000)
 #define AES_CMD2		cpu_to_le32(0xe4a63806)
@@ -52,6 +52,8 @@
 /* AES transform information word 1 fields */
 #define AES_TFM_ECB		cpu_to_le32(0x0 << 0)
 #define AES_TFM_CBC		cpu_to_le32(0x1 << 0)
+#define AES_TFM_OFB		cpu_to_le32(0x4 << 0)
+#define AES_TFM_CFB128		cpu_to_le32(0x5 << 0)
 #define AES_TFM_CTR_INIT	cpu_to_le32(0x2 << 0)	/* init counter to 1 */
 #define AES_TFM_CTR_LOAD	cpu_to_le32(0x6 << 0)	/* load/reuse counter */
 #define AES_TFM_3IV		cpu_to_le32(0x7 << 5)	/* using IV 0-2 */
@@ -60,13 +62,15 @@
 #define AES_TFM_ENC_HASH	cpu_to_le32(0x1 << 17)
 
 /* AES flags */
-#define AES_FLAGS_CIPHER_MSK	GENMASK(2, 0)
+#define AES_FLAGS_CIPHER_MSK	GENMASK(4, 0)
 #define AES_FLAGS_ECB		BIT(0)
 #define AES_FLAGS_CBC		BIT(1)
 #define AES_FLAGS_CTR		BIT(2)
-#define AES_FLAGS_GCM		BIT(3)
-#define AES_FLAGS_ENCRYPT	BIT(4)
-#define AES_FLAGS_BUSY		BIT(5)
+#define AES_FLAGS_OFB		BIT(3)
+#define AES_FLAGS_CFB128	BIT(4)
+#define AES_FLAGS_GCM		BIT(5)
+#define AES_FLAGS_ENCRYPT	BIT(6)
+#define AES_FLAGS_BUSY		BIT(7)
 
 #define AES_AUTH_TAG_ERR	cpu_to_le32(BIT(26))
 
@@ -412,7 +416,7 @@ static int mtk_aes_map(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
 	return mtk_aes_complete(cryp, aes, -EINVAL);
 }
 
-/* Initialize transform information of CBC/ECB/CTR mode */
+/* Initialize transform information of CBC/ECB/CTR/OFB/CFB mode */
 static void mtk_aes_info_init(struct mtk_cryp *cryp, struct mtk_aes_rec *aes,
 			      size_t len)
 {
@@ -441,6 +445,12 @@ static void mtk_aes_info_init(struct mtk_cryp *cryp, struct mtk_aes_rec *aes,
 	case AES_FLAGS_CTR:
 		info->tfm[1] = AES_TFM_CTR_LOAD;
 		goto ctr;
+	case AES_FLAGS_OFB:
+		info->tfm[1] = AES_TFM_OFB;
+		break;
+	case AES_FLAGS_CFB128:
+		info->tfm[1] = AES_TFM_CFB128;
+		break;
 
 	default:
 		/* Should not happen... */
@@ -699,6 +709,26 @@ static int mtk_aes_ctr_decrypt(struct ablkcipher_request *req)
 	return mtk_aes_crypt(req, AES_FLAGS_CTR);
 }
 
+static int mtk_aes_ofb_encrypt(struct ablkcipher_request *req)
+{
+	return mtk_aes_crypt(req, AES_FLAGS_ENCRYPT | AES_FLAGS_OFB);
+}
+
+static int mtk_aes_ofb_decrypt(struct ablkcipher_request *req)
+{
+	return mtk_aes_crypt(req, AES_FLAGS_OFB);
+}
+
+static int mtk_aes_cfb_encrypt(struct ablkcipher_request *req)
+{
+	return mtk_aes_crypt(req, AES_FLAGS_ENCRYPT | AES_FLAGS_CFB128);
+}
+
+static int mtk_aes_cfb_decrypt(struct ablkcipher_request *req)
+{
+	return mtk_aes_crypt(req, AES_FLAGS_CFB128);
+}
+
 static int mtk_aes_cra_init(struct crypto_tfm *tfm)
 {
 	struct mtk_aes_ctx *ctx = crypto_tfm_ctx(tfm);
@@ -794,6 +824,48 @@ static int mtk_aes_ctr_cra_init(struct crypto_tfm *tfm)
 		.decrypt	= mtk_aes_ctr_decrypt,
 	}
 },
+{
+	.cra_name		= "ofb(aes)",
+	.cra_driver_name	= "ofb-aes-mtk",
+	.cra_priority		= 400,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER |
+				  CRYPTO_ALG_ASYNC,
+	.cra_init		= mtk_aes_cra_init,
+	.cra_blocksize		= 1,
+	.cra_ctxsize		= sizeof(struct mtk_aes_ctx),
+	.cra_alignmask		= 0xf,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_u.ablkcipher = {
+		.min_keysize	= AES_MIN_KEY_SIZE,
+		.max_keysize	= AES_MAX_KEY_SIZE,
+		.ivsize		= AES_BLOCK_SIZE,
+		.setkey		= mtk_aes_setkey,
+		.encrypt	= mtk_aes_ofb_encrypt,
+		.decrypt	= mtk_aes_ofb_decrypt,
+	}
+},
+{
+	.cra_name		= "cfb(aes)",
+	.cra_driver_name	= "cfb-aes-mtk",
+	.cra_priority		= 400,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER |
+				  CRYPTO_ALG_ASYNC,
+	.cra_init		= mtk_aes_cra_init,
+	.cra_blocksize		= 1,
+	.cra_ctxsize		= sizeof(struct mtk_aes_ctx),
+	.cra_alignmask		= 0xf,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_u.ablkcipher = {
+		.min_keysize	= AES_MIN_KEY_SIZE,
+		.max_keysize	= AES_MAX_KEY_SIZE,
+		.ivsize		= AES_BLOCK_SIZE,
+		.setkey		= mtk_aes_setkey,
+		.encrypt	= mtk_aes_cfb_encrypt,
+		.decrypt	= mtk_aes_cfb_decrypt,
+	}
+},
 };
 
 static inline struct mtk_aes_gcm_ctx *
-- 
1.9.1
