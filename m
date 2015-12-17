From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH 14/24] crypto: atmel-aes: remove useless AES_FLAGS_DMA flag
Date: Thu, 17 Dec 2015 17:48:45 +0100
Message-ID: <bc344cf9484078f5f0bf8a606efb338803633f45.1450366831.git.cyrille.pitchen@atmel.com>
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

Since the 'done' task code was split into atmel_aes_cpu_complete() and
atmel_aes_dma_complete(), the AES_FLAGS_DMA flag has become useless.

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
---
 drivers/crypto/atmel-aes.c | 37 +++++++++++++++----------------------
 1 file changed, 15 insertions(+), 22 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 8a2b3e81c087..68e4177ad61b 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -66,7 +66,6 @@
 
 #define AES_FLAGS_INIT		BIT(2)
 #define AES_FLAGS_BUSY		BIT(3)
-#define AES_FLAGS_DMA		BIT(4)
 #define AES_FLAGS_FAST		BIT(5)
 
 #define AES_FLAGS_PERSISTENT	(AES_FLAGS_INIT | AES_FLAGS_BUSY)
@@ -393,8 +392,6 @@ static int atmel_aes_crypt_dma(struct atmel_aes_dev *dd,
 	dmaengine_slave_config(dd->dma_lch_in.chan, &dd->dma_lch_in.dma_conf);
 	dmaengine_slave_config(dd->dma_lch_out.chan, &dd->dma_lch_out.dma_conf);
 
-	dd->flags |= AES_FLAGS_DMA;
-
 	sg_init_table(&sg[0], 1);
 	sg_dma_address(&sg[0]) = dma_addr_in;
 	sg_dma_len(&sg[0]) = length;
@@ -433,8 +430,6 @@ static int atmel_aes_crypt_cpu_start(struct atmel_aes_dev *dd)
 {
 	struct ablkcipher_request *req = ablkcipher_request_cast(dd->areq);
 
-	dd->flags &= ~AES_FLAGS_DMA;
-
 	dma_sync_single_for_cpu(dd->dev, dd->dma_addr_in,
 				dd->dma_size, DMA_TO_DEVICE);
 	dma_sync_single_for_cpu(dd->dev, dd->dma_addr_out,
@@ -642,25 +637,23 @@ static int atmel_aes_start(struct atmel_aes_dev *dd)
 
 static int atmel_aes_crypt_dma_stop(struct atmel_aes_dev *dd)
 {
-	int err = -EINVAL;
+	int err = 0;
 	size_t count;
 
-	if (dd->flags & AES_FLAGS_DMA) {
-		err = 0;
-		if  (dd->flags & AES_FLAGS_FAST) {
-			dma_unmap_sg(dd->dev, dd->out_sg, 1, DMA_FROM_DEVICE);
-			dma_unmap_sg(dd->dev, dd->in_sg, 1, DMA_TO_DEVICE);
-		} else {
-			dma_sync_single_for_cpu(dd->dev, dd->dma_addr_out,
-				dd->dma_size, DMA_FROM_DEVICE);
-
-			/* copy data */
-			count = atmel_aes_sg_copy(&dd->out_sg, &dd->out_offset,
-				dd->buf_out, dd->buflen, dd->dma_size, 1);
-			if (count != dd->dma_size) {
-				err = -EINVAL;
-				pr_err("not all data converted: %zu\n", count);
-			}
+	if  (dd->flags & AES_FLAGS_FAST) {
+		dma_unmap_sg(dd->dev, dd->out_sg, 1, DMA_FROM_DEVICE);
+		dma_unmap_sg(dd->dev, dd->in_sg, 1, DMA_TO_DEVICE);
+	} else {
+		dma_sync_single_for_cpu(dd->dev, dd->dma_addr_out,
+					dd->dma_size, DMA_FROM_DEVICE);
+
+		/* copy data */
+		count = atmel_aes_sg_copy(&dd->out_sg, &dd->out_offset,
+					  dd->buf_out, dd->buflen,
+					  dd->dma_size, 1);
+		if (count != dd->dma_size) {
+			err = -EINVAL;
+			pr_err("not all data converted: %zu\n", count);
 		}
 	}
 
-- 
1.8.2.2
