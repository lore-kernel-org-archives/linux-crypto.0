From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH v2 1/1] crypto: atmel-aes: add support to the XTS mode
Date: Mon, 3 Oct 2016 14:33:16 +0200
Message-ID: <5ba0856b4ef013fa22c8d5ef00a7d97efe63d61f.1475497672.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <smueller@chronox.de>,
        Cyrille Pitchen <cyrille.pitchen@atmel.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <nicolas.ferre@atmel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from exsmtp03.microchip.com ([198.175.253.49]:48780 "EHLO
        email.microchip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751041AbcJCMca (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Oct 2016 08:32:30 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds the xts(aes) algorithm, which is supported from
hardware version 0x500 and above (sama5d2x).

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
---
ChangeLog:

v1 -> v2:
- fix typo in comment inside atmel_aes_xts_process_data():
  s/reverted/reversed/
- use xts_check_key() from atmel_aes_xts_setkey() as suggested by
  Stephan Mueller.

 drivers/crypto/atmel-aes-regs.h |   4 +
 drivers/crypto/atmel-aes.c      | 185 ++++++++++++++++++++++++++++++++++++++--
 2 files changed, 183 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/atmel-aes-regs.h b/drivers/crypto/atmel-aes-regs.h
index 6c2951bb70b1..0ec04407b533 100644
--- a/drivers/crypto/atmel-aes-regs.h
+++ b/drivers/crypto/atmel-aes-regs.h
@@ -28,6 +28,7 @@
 #define AES_MR_OPMOD_CFB		(0x3 << 12)
 #define AES_MR_OPMOD_CTR		(0x4 << 12)
 #define AES_MR_OPMOD_GCM		(0x5 << 12)
+#define AES_MR_OPMOD_XTS		(0x6 << 12)
 #define AES_MR_LOD				(0x1 << 15)
 #define AES_MR_CFBS_MASK		(0x7 << 16)
 #define AES_MR_CFBS_128b		(0x0 << 16)
@@ -67,6 +68,9 @@
 #define AES_CTRR	0x98
 #define AES_GCMHR(x)	(0x9c + ((x) * 0x04))
 
+#define AES_TWR(x)	(0xc0 + ((x) * 0x04))
+#define AES_ALPHAR(x)	(0xd0 + ((x) * 0x04))
+
 #define AES_HW_VERSION	0xFC
 
 #endif /* __ATMEL_AES_REGS_H__ */
diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 1d9e7bd3f377..6b656f4a9378 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -36,6 +36,7 @@
 #include <crypto/scatterwalk.h>
 #include <crypto/algapi.h>
 #include <crypto/aes.h>
+#include <crypto/xts.h>
 #include <crypto/internal/aead.h>
 #include <linux/platform_data/crypto-atmel.h>
 #include <dt-bindings/dma/at91.h>
@@ -68,6 +69,7 @@
 #define AES_FLAGS_CFB8		(AES_MR_OPMOD_CFB | AES_MR_CFBS_8b)
 #define AES_FLAGS_CTR		AES_MR_OPMOD_CTR
 #define AES_FLAGS_GCM		AES_MR_OPMOD_GCM
+#define AES_FLAGS_XTS		AES_MR_OPMOD_XTS
 
 #define AES_FLAGS_MODE_MASK	(AES_FLAGS_OPMODE_MASK |	\
 				 AES_FLAGS_ENCRYPT |		\
@@ -89,6 +91,7 @@ struct atmel_aes_caps {
 	bool			has_cfb64;
 	bool			has_ctr32;
 	bool			has_gcm;
+	bool			has_xts;
 	u32			max_burst_size;
 };
 
@@ -135,6 +138,12 @@ struct atmel_aes_gcm_ctx {
 	atmel_aes_fn_t		ghash_resume;
 };
 
+struct atmel_aes_xts_ctx {
+	struct atmel_aes_base_ctx	base;
+
+	u32			key2[AES_KEYSIZE_256 / sizeof(u32)];
+};
+
 struct atmel_aes_reqctx {
 	unsigned long		mode;
 };
@@ -282,6 +291,20 @@ static const char *atmel_aes_reg_name(u32 offset, char *tmp, size_t sz)
 		snprintf(tmp, sz, "GCMHR[%u]", (offset - AES_GCMHR(0)) >> 2);
 		break;
 
+	case AES_TWR(0):
+	case AES_TWR(1):
+	case AES_TWR(2):
+	case AES_TWR(3):
+		snprintf(tmp, sz, "TWR[%u]", (offset - AES_TWR(0)) >> 2);
+		break;
+
+	case AES_ALPHAR(0):
+	case AES_ALPHAR(1):
+	case AES_ALPHAR(2):
+	case AES_ALPHAR(3):
+		snprintf(tmp, sz, "ALPHAR[%u]", (offset - AES_ALPHAR(0)) >> 2);
+		break;
+
 	default:
 		snprintf(tmp, sz, "0x%02x", offset);
 		break;
@@ -453,15 +476,15 @@ static inline int atmel_aes_complete(struct atmel_aes_dev *dd, int err)
 	return err;
 }
 
-static void atmel_aes_write_ctrl(struct atmel_aes_dev *dd, bool use_dma,
-				 const u32 *iv)
+static void atmel_aes_write_ctrl_key(struct atmel_aes_dev *dd, bool use_dma,
+				     const u32 *iv, const u32 *key, int keylen)
 {
 	u32 valmr = 0;
 
 	/* MR register must be set before IV registers */
-	if (dd->ctx->keylen == AES_KEYSIZE_128)
+	if (keylen == AES_KEYSIZE_128)
 		valmr |= AES_MR_KEYSIZE_128;
-	else if (dd->ctx->keylen == AES_KEYSIZE_192)
+	else if (keylen == AES_KEYSIZE_192)
 		valmr |= AES_MR_KEYSIZE_192;
 	else
 		valmr |= AES_MR_KEYSIZE_256;
@@ -478,13 +501,19 @@ static void atmel_aes_write_ctrl(struct atmel_aes_dev *dd, bool use_dma,
 
 	atmel_aes_write(dd, AES_MR, valmr);
 
-	atmel_aes_write_n(dd, AES_KEYWR(0), dd->ctx->key,
-			  SIZE_IN_WORDS(dd->ctx->keylen));
+	atmel_aes_write_n(dd, AES_KEYWR(0), key, SIZE_IN_WORDS(keylen));
 
 	if (iv && (valmr & AES_MR_OPMOD_MASK) != AES_MR_OPMOD_ECB)
 		atmel_aes_write_block(dd, AES_IVR(0), iv);
 }
 
+static inline void atmel_aes_write_ctrl(struct atmel_aes_dev *dd, bool use_dma,
+					const u32 *iv)
+
+{
+	atmel_aes_write_ctrl_key(dd, use_dma, iv,
+				 dd->ctx->key, dd->ctx->keylen);
+}
 
 /* CPU transfer */
 
@@ -1769,6 +1798,137 @@ static struct aead_alg aes_gcm_alg = {
 };
 
 
+/* xts functions */
+
+static inline struct atmel_aes_xts_ctx *
+atmel_aes_xts_ctx_cast(struct atmel_aes_base_ctx *ctx)
+{
+	return container_of(ctx, struct atmel_aes_xts_ctx, base);
+}
+
+static int atmel_aes_xts_process_data(struct atmel_aes_dev *dd);
+
+static int atmel_aes_xts_start(struct atmel_aes_dev *dd)
+{
+	struct atmel_aes_xts_ctx *ctx = atmel_aes_xts_ctx_cast(dd->ctx);
+	struct ablkcipher_request *req = ablkcipher_request_cast(dd->areq);
+	struct atmel_aes_reqctx *rctx = ablkcipher_request_ctx(req);
+	unsigned long flags;
+	int err;
+
+	atmel_aes_set_mode(dd, rctx);
+
+	err = atmel_aes_hw_init(dd);
+	if (err)
+		return atmel_aes_complete(dd, err);
+
+	/* Compute the tweak value from req->info with ecb(aes). */
+	flags = dd->flags;
+	dd->flags &= ~AES_FLAGS_MODE_MASK;
+	dd->flags |= (AES_FLAGS_ECB | AES_FLAGS_ENCRYPT);
+	atmel_aes_write_ctrl_key(dd, false, NULL,
+				 ctx->key2, ctx->base.keylen);
+	dd->flags = flags;
+
+	atmel_aes_write_block(dd, AES_IDATAR(0), req->info);
+	return atmel_aes_wait_for_data_ready(dd, atmel_aes_xts_process_data);
+}
+
+static int atmel_aes_xts_process_data(struct atmel_aes_dev *dd)
+{
+	struct ablkcipher_request *req = ablkcipher_request_cast(dd->areq);
+	bool use_dma = (req->nbytes >= ATMEL_AES_DMA_THRESHOLD);
+	u32 tweak[AES_BLOCK_SIZE / sizeof(u32)];
+	static const u32 one[AES_BLOCK_SIZE / sizeof(u32)] = {cpu_to_le32(1), };
+	u8 *tweak_bytes = (u8 *)tweak;
+	int i;
+
+	/* Read the computed ciphered tweak value. */
+	atmel_aes_read_block(dd, AES_ODATAR(0), tweak);
+	/*
+	 * Hardware quirk:
+	 * the order of the ciphered tweak bytes need to be reversed before
+	 * writing them into the ODATARx registers.
+	 */
+	for (i = 0; i < AES_BLOCK_SIZE/2; ++i) {
+		u8 tmp = tweak_bytes[AES_BLOCK_SIZE - 1 - i];
+
+		tweak_bytes[AES_BLOCK_SIZE - 1 - i] = tweak_bytes[i];
+		tweak_bytes[i] = tmp;
+	}
+
+	/* Process the data. */
+	atmel_aes_write_ctrl(dd, use_dma, NULL);
+	atmel_aes_write_block(dd, AES_TWR(0), tweak);
+	atmel_aes_write_block(dd, AES_ALPHAR(0), one);
+	if (use_dma)
+		return atmel_aes_dma_start(dd, req->src, req->dst, req->nbytes,
+					   atmel_aes_transfer_complete);
+
+	return atmel_aes_cpu_start(dd, req->src, req->dst, req->nbytes,
+				   atmel_aes_transfer_complete);
+}
+
+static int atmel_aes_xts_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
+				unsigned int keylen)
+{
+	struct atmel_aes_xts_ctx *ctx = crypto_ablkcipher_ctx(tfm);
+	int err;
+
+	err = xts_check_key(crypto_ablkcipher_tfm(tfm), key, keylen);
+	if (err)
+		return err;
+
+	memcpy(ctx->base.key, key, keylen/2);
+	memcpy(ctx->key2, key + keylen/2, keylen/2);
+	ctx->base.keylen = keylen/2;
+
+	return 0;
+}
+
+static int atmel_aes_xts_encrypt(struct ablkcipher_request *req)
+{
+	return atmel_aes_crypt(req, AES_FLAGS_XTS | AES_FLAGS_ENCRYPT);
+}
+
+static int atmel_aes_xts_decrypt(struct ablkcipher_request *req)
+{
+	return atmel_aes_crypt(req, AES_FLAGS_XTS);
+}
+
+static int atmel_aes_xts_cra_init(struct crypto_tfm *tfm)
+{
+	struct atmel_aes_xts_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	tfm->crt_ablkcipher.reqsize = sizeof(struct atmel_aes_reqctx);
+	ctx->base.start = atmel_aes_xts_start;
+
+	return 0;
+}
+
+static struct crypto_alg aes_xts_alg = {
+	.cra_name		= "xts(aes)",
+	.cra_driver_name	= "atmel-xts-aes",
+	.cra_priority		= ATMEL_AES_PRIORITY,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= AES_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct atmel_aes_xts_ctx),
+	.cra_alignmask		= 0xf,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_init		= atmel_aes_xts_cra_init,
+	.cra_exit		= atmel_aes_cra_exit,
+	.cra_u.ablkcipher = {
+		.min_keysize	= 2 * AES_MIN_KEY_SIZE,
+		.max_keysize	= 2 * AES_MAX_KEY_SIZE,
+		.ivsize		= AES_BLOCK_SIZE,
+		.setkey		= atmel_aes_xts_setkey,
+		.encrypt	= atmel_aes_xts_encrypt,
+		.decrypt	= atmel_aes_xts_decrypt,
+	}
+};
+
+
 /* Probe functions */
 
 static int atmel_aes_buff_init(struct atmel_aes_dev *dd)
@@ -1877,6 +2037,9 @@ static void atmel_aes_unregister_algs(struct atmel_aes_dev *dd)
 {
 	int i;
 
+	if (dd->caps.has_xts)
+		crypto_unregister_alg(&aes_xts_alg);
+
 	if (dd->caps.has_gcm)
 		crypto_unregister_aead(&aes_gcm_alg);
 
@@ -1909,8 +2072,16 @@ static int atmel_aes_register_algs(struct atmel_aes_dev *dd)
 			goto err_aes_gcm_alg;
 	}
 
+	if (dd->caps.has_xts) {
+		err = crypto_register_alg(&aes_xts_alg);
+		if (err)
+			goto err_aes_xts_alg;
+	}
+
 	return 0;
 
+err_aes_xts_alg:
+	crypto_unregister_aead(&aes_gcm_alg);
 err_aes_gcm_alg:
 	crypto_unregister_alg(&aes_cfb64_alg);
 err_aes_cfb64_alg:
@@ -1928,6 +2099,7 @@ static void atmel_aes_get_cap(struct atmel_aes_dev *dd)
 	dd->caps.has_cfb64 = 0;
 	dd->caps.has_ctr32 = 0;
 	dd->caps.has_gcm = 0;
+	dd->caps.has_xts = 0;
 	dd->caps.max_burst_size = 1;
 
 	/* keep only major version number */
@@ -1937,6 +2109,7 @@ static void atmel_aes_get_cap(struct atmel_aes_dev *dd)
 		dd->caps.has_cfb64 = 1;
 		dd->caps.has_ctr32 = 1;
 		dd->caps.has_gcm = 1;
+		dd->caps.has_xts = 1;
 		dd->caps.max_burst_size = 4;
 		break;
 	case 0x200:
-- 
2.7.4
