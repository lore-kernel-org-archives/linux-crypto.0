From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH 07/24] crypto: atmel-aes: change atmel_aes_write_ctrl() signature
Date: Thu, 17 Dec 2015 17:48:38 +0100
Message-ID: <034ee506976eb9e9f766cae62ccacf56d848f947.1450366831.git.cyrille.pitchen@atmel.com>
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

This patch changes the signature of atmel_aes_write_ctrl() to make it more
generic. This will be used by future patches when implementing new block
cipher modes such as GCM.

Especially atmel_aes_hw_init() is now called outside
atmel_aes_write_ctrl(): this allows to call atmel_aes_write_ctrl() many
times, still initializing the hardware only once.

Indeed, the support of GCM will require to update the Mode Register and
the IV when processing a single request.

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
---
 drivers/crypto/atmel-aes.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 9a9e1b88a384..ccb8a8322bf7 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -496,16 +496,11 @@ static int atmel_aes_crypt_dma_start(struct atmel_aes_dev *dd)
 	return err;
 }
 
-static int atmel_aes_write_ctrl(struct atmel_aes_dev *dd)
+static void atmel_aes_write_ctrl(struct atmel_aes_dev *dd, bool use_dma,
+				 const u32 *iv)
 {
-	int err;
 	u32 valcr = 0, valmr = 0;
 
-	err = atmel_aes_hw_init(dd);
-
-	if (err)
-		return err;
-
 	/* MR register must be set before IV registers */
 	if (dd->ctx->keylen == AES_KEYSIZE_128)
 		valmr |= AES_MR_KEYSIZE_128;
@@ -539,7 +534,7 @@ static int atmel_aes_write_ctrl(struct atmel_aes_dev *dd)
 	if (dd->flags & AES_FLAGS_ENCRYPT)
 		valmr |= AES_MR_CYPHER_ENC;
 
-	if (dd->total > ATMEL_AES_DMA_THRESHOLD) {
+	if (use_dma) {
 		valmr |= AES_MR_SMOD_IDATAR0;
 		if (dd->caps.has_dualbuff)
 			valmr |= AES_MR_DUALBUFF;
@@ -555,11 +550,9 @@ static int atmel_aes_write_ctrl(struct atmel_aes_dev *dd)
 
 	if (((dd->flags & AES_FLAGS_CBC) || (dd->flags & AES_FLAGS_CFB) ||
 	   (dd->flags & AES_FLAGS_OFB) || (dd->flags & AES_FLAGS_CTR)) &&
-	   dd->req->info) {
-		atmel_aes_write_n(dd, AES_IVR(0), dd->req->info, 4);
+	   iv) {
+		atmel_aes_write_n(dd, AES_IVR(0), iv, 4);
 	}
-
-	return 0;
 }
 
 static int atmel_aes_handle_queue(struct atmel_aes_dev *dd,
@@ -570,6 +563,7 @@ static int atmel_aes_handle_queue(struct atmel_aes_dev *dd,
 	struct atmel_aes_reqctx *rctx;
 	unsigned long flags;
 	int err, ret = 0;
+	bool use_dma;
 
 	spin_lock_irqsave(&dd->lock, flags);
 	if (req)
@@ -607,9 +601,11 @@ static int atmel_aes_handle_queue(struct atmel_aes_dev *dd,
 	dd->ctx = ctx;
 	ctx->dd = dd;
 
-	err = atmel_aes_write_ctrl(dd);
+	err = atmel_aes_hw_init(dd);
 	if (!err) {
-		if (dd->total > ATMEL_AES_DMA_THRESHOLD)
+		use_dma = (dd->total > ATMEL_AES_DMA_THRESHOLD);
+		atmel_aes_write_ctrl(dd, use_dma, req->info);
+		if (use_dma)
 			err = atmel_aes_crypt_dma_start(dd);
 		else
 			err = atmel_aes_crypt_cpu_start(dd);
-- 
1.8.2.2
