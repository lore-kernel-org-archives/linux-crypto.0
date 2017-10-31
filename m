From: Romain Izard <romain.izard.pro@gmail.com>
Subject: [PATCH 1/2] crypto: atmel-aes - properly set IV after {en,de}crypt
Date: Tue, 31 Oct 2017 16:25:23 +0100
Message-ID: <20171031152524.25216-2-romain.izard.pro@gmail.com>
References: <20171031152524.25216-1-romain.izard.pro@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@microchip.com>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Romain Izard <romain.izard.pro@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171031152524.25216-1-romain.izard.pro@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Certain cipher modes like CTS expect the IV (req->info) of
ablkcipher_request (or equivalently req->iv of skcipher_request) to
contain the last ciphertext block when the {en,de}crypt operation is done.

Fix this issue for the Atmel AES hardware engine. The tcrypt test
case for cts(cbc(aes)) is now correctly passed.

In the case of in-place decryption, copy the ciphertext in an
intermediate buffer before decryption.

Signed-off-by: Romain Izard <romain.izard.pro@gmail.com>
---
 drivers/crypto/atmel-aes.c | 40 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 37 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 29e20c37f3a6..53432ab97d7e 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -110,6 +110,7 @@ struct atmel_aes_base_ctx {
 	int			keylen;
 	u32			key[AES_KEYSIZE_256 / sizeof(u32)];
 	u16			block_size;
+	bool			is_aead;
 };
 
 struct atmel_aes_ctx {
@@ -156,6 +157,7 @@ struct atmel_aes_authenc_ctx {
 
 struct atmel_aes_reqctx {
 	unsigned long		mode;
+	u32			lastc[AES_BLOCK_SIZE / sizeof(u32)];
 };
 
 #ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
@@ -497,12 +499,34 @@ static void atmel_aes_authenc_complete(struct atmel_aes_dev *dd, int err);
 static inline int atmel_aes_complete(struct atmel_aes_dev *dd, int err)
 {
 #ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
-	atmel_aes_authenc_complete(dd, err);
+	if (dd->ctx->is_aead)
+		atmel_aes_authenc_complete(dd, err);
 #endif
 
 	clk_disable(dd->iclk);
 	dd->flags &= ~AES_FLAGS_BUSY;
 
+	if (!dd->ctx->is_aead) {
+		struct ablkcipher_request *req =
+			ablkcipher_request_cast(dd->areq);
+		struct atmel_aes_reqctx *rctx = ablkcipher_request_ctx(req);
+		struct crypto_ablkcipher *ablkcipher =
+			crypto_ablkcipher_reqtfm(req);
+		int ivsize = crypto_ablkcipher_ivsize(ablkcipher);
+
+		if (rctx->mode & AES_FLAGS_ENCRYPT) {
+			scatterwalk_map_and_copy(req->info, req->dst,
+				req->nbytes - ivsize, ivsize, 0);
+		} else {
+			if (req->src == req->dst) {
+				memcpy(req->info, rctx->lastc, ivsize);
+			} else {
+				scatterwalk_map_and_copy(req->info, req->src,
+					req->nbytes - ivsize, ivsize, 0);
+			}
+		}
+	}
+
 	if (dd->is_async)
 		dd->areq->complete(dd->areq, err);
 
@@ -1071,11 +1095,11 @@ static int atmel_aes_ctr_start(struct atmel_aes_dev *dd)
 
 static int atmel_aes_crypt(struct ablkcipher_request *req, unsigned long mode)
 {
-	struct atmel_aes_base_ctx *ctx;
+	struct crypto_ablkcipher *ablkcipher = crypto_ablkcipher_reqtfm(req);
+	struct atmel_aes_base_ctx *ctx = crypto_ablkcipher_ctx(ablkcipher);
 	struct atmel_aes_reqctx *rctx;
 	struct atmel_aes_dev *dd;
 
-	ctx = crypto_ablkcipher_ctx(crypto_ablkcipher_reqtfm(req));
 	switch (mode & AES_FLAGS_OPMODE_MASK) {
 	case AES_FLAGS_CFB8:
 		ctx->block_size = CFB8_BLOCK_SIZE;
@@ -1097,6 +1121,7 @@ static int atmel_aes_crypt(struct ablkcipher_request *req, unsigned long mode)
 		ctx->block_size = AES_BLOCK_SIZE;
 		break;
 	}
+	ctx->is_aead = false;
 
 	dd = atmel_aes_find_dev(ctx);
 	if (!dd)
@@ -1105,6 +1130,13 @@ static int atmel_aes_crypt(struct ablkcipher_request *req, unsigned long mode)
 	rctx = ablkcipher_request_ctx(req);
 	rctx->mode = mode;
 
+	if (!(mode & AES_FLAGS_ENCRYPT) && (req->src == req->dst)) {
+		int ivsize = crypto_ablkcipher_ivsize(ablkcipher);
+
+		scatterwalk_map_and_copy(rctx->lastc, req->src,
+			(req->nbytes - ivsize), ivsize, 0);
+	}
+
 	return atmel_aes_handle_queue(dd, &req->base);
 }
 
@@ -1739,6 +1771,7 @@ static int atmel_aes_gcm_crypt(struct aead_request *req,
 
 	ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
 	ctx->block_size = AES_BLOCK_SIZE;
+	ctx->is_aead = true;
 
 	dd = atmel_aes_find_dev(ctx);
 	if (!dd)
@@ -2223,6 +2256,7 @@ static int atmel_aes_authenc_crypt(struct aead_request *req,
 
 	rctx->base.mode = mode;
 	ctx->block_size = AES_BLOCK_SIZE;
+	ctx->is_aead = true;
 
 	dd = atmel_aes_find_dev(ctx);
 	if (!dd)
-- 
2.14.1
