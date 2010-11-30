From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: [PATCHv2 4/6] omap-aes: unnecessary code removed
Date: Tue, 30 Nov 2010 10:13:30 +0200
Message-ID: <be7098ebdfe990862bce1fa64f6f822f7ebfa197.1291104329.git.dmitry.kasatkin@nokia.com>
References: <cover.1291104329.git.dmitry.kasatkin@nokia.com>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org
To: herbert@gondor.hengli.com.au
Return-path: <linux-omap-owner@vger.kernel.org>
In-Reply-To: <cover.1291104329.git.dmitry.kasatkin@nokia.com>
In-Reply-To: <cover.1291104329.git.dmitry.kasatkin@nokia.com>
References: <cover.1291104329.git.dmitry.kasatkin@nokia.com>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Key and IV should always be set before AES operation.
So no need to check if it has changed or not.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
---
 drivers/crypto/omap-aes.c |   70 +++++++++++----------------------------------
 1 files changed, 17 insertions(+), 53 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 704cc70..0b21dce 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -74,11 +74,9 @@
 #define FLAGS_CBC		BIT(1)
 #define FLAGS_GIV		BIT(2)
 
-#define FLAGS_NEW_KEY		BIT(4)
-#define FLAGS_NEW_IV		BIT(5)
-#define FLAGS_INIT		BIT(6)
-#define FLAGS_FAST		BIT(7)
-#define FLAGS_BUSY		BIT(8)
+#define FLAGS_INIT		BIT(4)
+#define FLAGS_FAST		BIT(5)
+#define FLAGS_BUSY		BIT(6)
 
 struct omap_aes_ctx {
 	struct omap_aes_dev *dd;
@@ -105,9 +103,6 @@ struct omap_aes_dev {
 	unsigned long		flags;
 	int			err;
 
-	u32			*iv;
-	u32			ctrl;
-
 	spinlock_t		lock;
 	struct crypto_queue	queue;
 
@@ -209,28 +204,13 @@ static int omap_aes_hw_init(struct omap_aes_dev *dd)
 static int omap_aes_write_ctrl(struct omap_aes_dev *dd)
 {
 	unsigned int key32;
-	int i, err, init = dd->flags & FLAGS_INIT;
+	int i, err;
 	u32 val, mask;
 
 	err = omap_aes_hw_init(dd);
 	if (err)
 		return err;
 
-	val = FLD_VAL(((dd->ctx->keylen >> 3) - 1), 4, 3);
-	if (dd->flags & FLAGS_CBC)
-		val |= AES_REG_CTRL_CBC;
-	if (dd->flags & FLAGS_ENCRYPT)
-		val |= AES_REG_CTRL_DIRECTION;
-
-	/* check if hw state & mode have not changed */
-	if (init && dd->ctrl == val && !(dd->flags & FLAGS_NEW_IV) &&
-		   !(dd->ctx->flags & FLAGS_NEW_KEY))
-		goto out;
-
-	/* only need to write control registers for new settings */
-
-	dd->ctrl = val;
-
 	val = 0;
 	if (dd->dma_lch_out >= 0)
 		val |= AES_REG_MASK_DMA_OUT_EN;
@@ -241,27 +221,28 @@ static int omap_aes_write_ctrl(struct omap_aes_dev *dd)
 
 	omap_aes_write_mask(dd, AES_REG_MASK, val, mask);
 
-	pr_debug("Set key\n");
 	key32 = dd->ctx->keylen / sizeof(u32);
-	/* set a key */
+
+	/* it seems a key should always be set even if it has not changed */
 	for (i = 0; i < key32; i++) {
 		omap_aes_write(dd, AES_REG_KEY(i),
 			__le32_to_cpu(dd->ctx->key[i]));
 	}
-	dd->ctx->flags &= ~FLAGS_NEW_KEY;
 
-	if (dd->flags & FLAGS_NEW_IV) {
-		pr_debug("Set IV\n");
-		omap_aes_write_n(dd, AES_REG_IV(0), dd->iv, 4);
-		dd->flags &= ~FLAGS_NEW_IV;
-	}
+	if ((dd->flags & FLAGS_CBC) && dd->req->info)
+		omap_aes_write_n(dd, AES_REG_IV(0), dd->req->info, 4);
+
+	val = FLD_VAL(((dd->ctx->keylen >> 3) - 1), 4, 3);
+	if (dd->flags & FLAGS_CBC)
+		val |= AES_REG_CTRL_CBC;
+	if (dd->flags & FLAGS_ENCRYPT)
+		val |= AES_REG_CTRL_DIRECTION;
 
 	mask = AES_REG_CTRL_CBC | AES_REG_CTRL_DIRECTION |
 			AES_REG_CTRL_KEY_SIZE;
 
-	omap_aes_write_mask(dd, AES_REG_CTRL, dd->ctrl, mask);
+	omap_aes_write_mask(dd, AES_REG_CTRL, val, mask);
 
-out:
 	/* start DMA or disable idle mode */
 	omap_aes_write_mask(dd, AES_REG_MASK, AES_REG_MASK_START,
 			    AES_REG_MASK_START);
@@ -561,16 +542,12 @@ static int omap_aes_crypt_dma_start(struct omap_aes_dev *dd)
 static void omap_aes_finish_req(struct omap_aes_dev *dd, int err)
 {
 	struct ablkcipher_request *req = dd->req;
-	struct omap_aes_ctx *ctx;
 
 	pr_debug("err: %d\n", err);
 
 	dd->flags &= ~FLAGS_BUSY;
 
-	ctx = crypto_ablkcipher_ctx(crypto_ablkcipher_reqtfm(req));
-
-	if (req->base.complete)
-		req->base.complete(&req->base, err);
+	req->base.complete(&req->base, err);
 }
 
 static int omap_aes_crypt_dma_stop(struct omap_aes_dev *dd)
@@ -636,8 +613,6 @@ static int omap_aes_handle_queue(struct omap_aes_dev *dd,
 
 	req = ablkcipher_request_cast(async_req);
 
-	pr_debug("get new req\n");
-
 	/* assign new request to device */
 	dd->req = req;
 	dd->total = req->nbytes;
@@ -651,18 +626,8 @@ static int omap_aes_handle_queue(struct omap_aes_dev *dd,
 	rctx->mode &= FLAGS_MODE_MASK;
 	dd->flags = (dd->flags & ~FLAGS_MODE_MASK) | rctx->mode;
 
-	dd->iv = req->info;
-	if ((dd->flags & FLAGS_CBC) && dd->iv)
-		dd->flags |= FLAGS_NEW_IV;
-	else
-		dd->flags &= ~FLAGS_NEW_IV;
-
+	dd->ctx = ctx;
 	ctx->dd = dd;
-	if (dd->ctx != ctx) {
-		/* assign new context to device */
-		dd->ctx = ctx;
-		ctx->flags |= FLAGS_NEW_KEY;
-	}
 
 	err = omap_aes_crypt_dma_start(dd);
 	if (err) {
@@ -744,7 +709,6 @@ static int omap_aes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 
 	memcpy(ctx->key, key, keylen);
 	ctx->keylen = keylen;
-	ctx->flags |= FLAGS_NEW_KEY;
 
 	return 0;
 }
-- 
1.7.0.4

