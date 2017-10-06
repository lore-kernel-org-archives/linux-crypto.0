From: Romain Izard <romain.izard.pro@gmail.com>
Subject: [PATCH] crypto: atmel-aes - properly set IV after {en,de}crypt
Date: Fri,  6 Oct 2017 17:51:08 +0200
Message-ID: <20171006155108.6581-1-romain.izard.pro@gmail.com>
Cc: David Gstir <david@sigma-star.at>,
        Nicolas Feignon <nicolas.feignon@mobile-devices.fr>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Cyrille Pitchen <cyrille.pitchen@microchip.com>,
        linux-crypto@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Romain Izard <romain.izard.pro@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Certain cipher modes like CTS expect the IV (req->info) of
ablkcipher_request (or equivalently req->iv of skcipher_request) to
contain the last ciphertext block when the {en,de}crypt operation is done.

Fix this issue for the Atmel AES hardware engine. The tcrypt test
case for cts(cbc(aes)) is now correctly passed.

To handle the case of in-place decryption, copy the ciphertext in an
intermediate buffer before decryption.

Signed-off-by: Romain Izard <romain.izard.pro@gmail.com>
---
 drivers/crypto/atmel-aes.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 29e20c37f3a6..f22300babb45 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -156,6 +156,7 @@ struct atmel_aes_authenc_ctx {
 
 struct atmel_aes_reqctx {
 	unsigned long		mode;
+	u8			*backup_info;
 };
 
 #ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
@@ -496,6 +497,12 @@ static void atmel_aes_authenc_complete(struct atmel_aes_dev *dd, int err);
 
 static inline int atmel_aes_complete(struct atmel_aes_dev *dd, int err)
 {
+	struct ablkcipher_request *req = ablkcipher_request_cast(dd->areq);
+	struct crypto_ablkcipher *ablkcipher = crypto_ablkcipher_reqtfm(req);
+	struct atmel_aes_reqctx *rctx = ablkcipher_request_ctx(req);
+	int ivsize = crypto_ablkcipher_ivsize(ablkcipher);
+	bool enc = atmel_aes_is_encrypt(dd);
+
 #ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
 	atmel_aes_authenc_complete(dd, err);
 #endif
@@ -503,6 +510,15 @@ static inline int atmel_aes_complete(struct atmel_aes_dev *dd, int err)
 	clk_disable(dd->iclk);
 	dd->flags &= ~AES_FLAGS_BUSY;
 
+	if (enc) {
+		scatterwalk_map_and_copy(req->info, req->dst,
+					 req->nbytes - ivsize, ivsize, 0);
+	} else if (rctx->backup_info) {
+		memcpy(req->info, rctx->backup_info, ivsize);
+		kfree(rctx->backup_info);
+		rctx->backup_info = NULL;
+	}
+
 	if (dd->is_async)
 		dd->areq->complete(dd->areq, err);
 
@@ -959,13 +975,25 @@ static int atmel_aes_transfer_complete(struct atmel_aes_dev *dd)
 static int atmel_aes_start(struct atmel_aes_dev *dd)
 {
 	struct ablkcipher_request *req = ablkcipher_request_cast(dd->areq);
+	struct crypto_ablkcipher *ablkcipher = crypto_ablkcipher_reqtfm(req);
 	struct atmel_aes_reqctx *rctx = ablkcipher_request_ctx(req);
+	int ivsize = crypto_ablkcipher_ivsize(ablkcipher);
+	bool enc = atmel_aes_is_encrypt(dd);
 	bool use_dma = (req->nbytes >= ATMEL_AES_DMA_THRESHOLD ||
 			dd->ctx->block_size != AES_BLOCK_SIZE);
 	int err;
 
 	atmel_aes_set_mode(dd, rctx);
 
+	if (!enc) {
+		rctx->backup_info = kzalloc(ivsize, GFP_KERNEL);
+		if (rctx->backup_info == NULL)
+			return atmel_aes_complete(dd, -ENOMEM);
+
+		scatterwalk_map_and_copy(rctx->backup_info, req->src,
+				 (req->nbytes - ivsize), ivsize, 0);
+	}
+
 	err = atmel_aes_hw_init(dd);
 	if (err)
 		return atmel_aes_complete(dd, err);
-- 
2.11.0
