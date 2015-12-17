From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH 18/24] crypto: atmel-aes: fix typo and indentation
Date: Thu, 17 Dec 2015 18:13:02 +0100
Message-ID: <41ed819e39f375c464d362f2a259141d750302b4.1450366831.git.cyrille.pitchen@atmel.com>
References: <cover.1450366831.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	Cyrille Pitchen <cyrille.pitchen@atmel.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<nicolas.ferre@atmel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1450366831.git.cyrille.pitchen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Dummy patch to fix typo and indentation.

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
---
 drivers/crypto/atmel-aes.c | 56 +++++++++++++++++++++-------------------------
 1 file changed, 25 insertions(+), 31 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 176ab3878583..208fa8dce7f7 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -80,9 +80,9 @@
 
 
 struct atmel_aes_caps {
-	bool	has_dualbuff;
-	bool	has_cfb64;
-	u32		max_burst_size;
+	bool			has_dualbuff;
+	bool			has_cfb64;
+	u32			max_burst_size;
 };
 
 struct atmel_aes_dev;
@@ -92,13 +92,11 @@ typedef int (*atmel_aes_fn_t)(struct atmel_aes_dev *);
 
 
 struct atmel_aes_base_ctx {
-	struct atmel_aes_dev *dd;
-	atmel_aes_fn_t	start;
-
-	int		keylen;
-	u32		key[AES_KEYSIZE_256 / sizeof(u32)];
-
-	u16		block_size;
+	struct atmel_aes_dev	*dd;
+	atmel_aes_fn_t		start;
+	int			keylen;
+	u32			key[AES_KEYSIZE_256 / sizeof(u32)];
+	u16			block_size;
 };
 
 struct atmel_aes_ctx {
@@ -106,7 +104,7 @@ struct atmel_aes_ctx {
 };
 
 struct atmel_aes_reqctx {
-	unsigned long mode;
+	unsigned long		mode;
 };
 
 struct atmel_aes_dma {
@@ -131,7 +129,7 @@ struct atmel_aes_dev {
 
 	struct device		*dev;
 	struct clk		*iclk;
-	int	irq;
+	int			irq;
 
 	unsigned long		flags;
 
@@ -155,7 +153,7 @@ struct atmel_aes_dev {
 
 	struct atmel_aes_caps	caps;
 
-	u32	hw_version;
+	u32			hw_version;
 };
 
 struct atmel_aes_drv {
@@ -782,11 +780,11 @@ static void atmel_aes_buff_cleanup(struct atmel_aes_dev *dd)
 
 static int atmel_aes_crypt(struct ablkcipher_request *req, unsigned long mode)
 {
-	struct atmel_aes_base_ctx *ctx = crypto_ablkcipher_ctx(
-			crypto_ablkcipher_reqtfm(req));
-	struct atmel_aes_reqctx *rctx = ablkcipher_request_ctx(req);
+	struct atmel_aes_base_ctx *ctx;
+	struct atmel_aes_reqctx *rctx;
 	struct atmel_aes_dev *dd;
 
+	ctx = crypto_ablkcipher_ctx(crypto_ablkcipher_reqtfm(req));
 	switch (mode & AES_FLAGS_OPMODE_MASK) {
 	case AES_FLAGS_CFB8:
 		ctx->block_size = CFB8_BLOCK_SIZE;
@@ -813,6 +811,7 @@ static int atmel_aes_crypt(struct ablkcipher_request *req, unsigned long mode)
 	if (!dd)
 		return -ENODEV;
 
+	rctx = ablkcipher_request_ctx(req);
 	rctx->mode = mode;
 
 	return atmel_aes_handle_queue(dd, &req->base);
@@ -873,8 +872,9 @@ static int atmel_aes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 {
 	struct atmel_aes_base_ctx *ctx = crypto_ablkcipher_ctx(tfm);
 
-	if (keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_192 &&
-		   keylen != AES_KEYSIZE_256) {
+	if (keylen != AES_KEYSIZE_128 &&
+	    keylen != AES_KEYSIZE_192 &&
+	    keylen != AES_KEYSIZE_256) {
 		crypto_ablkcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
 	}
@@ -897,26 +897,22 @@ static int atmel_aes_ecb_decrypt(struct ablkcipher_request *req)
 
 static int atmel_aes_cbc_encrypt(struct ablkcipher_request *req)
 {
-	return atmel_aes_crypt(req,
-		AES_FLAGS_ENCRYPT | AES_FLAGS_CBC);
+	return atmel_aes_crypt(req, AES_FLAGS_CBC | AES_FLAGS_ENCRYPT);
 }
 
 static int atmel_aes_cbc_decrypt(struct ablkcipher_request *req)
 {
-	return atmel_aes_crypt(req,
-		AES_FLAGS_CBC);
+	return atmel_aes_crypt(req, AES_FLAGS_CBC);
 }
 
 static int atmel_aes_ofb_encrypt(struct ablkcipher_request *req)
 {
-	return atmel_aes_crypt(req,
-		AES_FLAGS_ENCRYPT | AES_FLAGS_OFB);
+	return atmel_aes_crypt(req, AES_FLAGS_OFB | AES_FLAGS_ENCRYPT);
 }
 
 static int atmel_aes_ofb_decrypt(struct ablkcipher_request *req)
 {
-	return atmel_aes_crypt(req,
-		AES_FLAGS_OFB);
+	return atmel_aes_crypt(req, AES_FLAGS_OFB);
 }
 
 static int atmel_aes_cfb_encrypt(struct ablkcipher_request *req)
@@ -971,14 +967,12 @@ static int atmel_aes_cfb8_decrypt(struct ablkcipher_request *req)
 
 static int atmel_aes_ctr_encrypt(struct ablkcipher_request *req)
 {
-	return atmel_aes_crypt(req,
-		AES_FLAGS_ENCRYPT | AES_FLAGS_CTR);
+	return atmel_aes_crypt(req, AES_FLAGS_CTR | AES_FLAGS_ENCRYPT);
 }
 
 static int atmel_aes_ctr_decrypt(struct ablkcipher_request *req)
 {
-	return atmel_aes_crypt(req,
-		AES_FLAGS_CTR);
+	return atmel_aes_crypt(req, AES_FLAGS_CTR);
 }
 
 static int atmel_aes_cra_init(struct crypto_tfm *tfm)
@@ -1196,7 +1190,7 @@ static void atmel_aes_queue_task(unsigned long data)
 
 static void atmel_aes_done_task(unsigned long data)
 {
-	struct atmel_aes_dev *dd = (struct atmel_aes_dev *) data;
+	struct atmel_aes_dev *dd = (struct atmel_aes_dev *)data;
 
 	dd->is_async = true;
 	(void)dd->resume(dd);
-- 
1.8.2.2
