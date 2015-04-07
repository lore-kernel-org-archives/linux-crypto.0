From: Leilei Zhao <leilei.zhao@atmel.com>
Subject: [PATCH 09/10] crypto: atmel-aes: sync the buf used in DMA or CPU
Date: Tue, 7 Apr 2015 17:45:10 +0800
Message-ID: <1428399911-23325-10-git-send-email-leilei.zhao@atmel.com>
References: <1428399911-23325-1-git-send-email-leilei.zhao@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-arm-kernel@lists.infradead.org>,
	Leilei Zhao <leilei.zhao@atmel.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nicolas.ferre@atmel.com>, <Ludovic.Desroches@atmel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1428399911-23325-1-git-send-email-leilei.zhao@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The input buffer and output buffer are mapped for DMA transfer
in Atmel AES driver. But they are also be used by CPU when
the requested crypt length is not bigger than the threshold
value 16. The buffers will be cached in cache line when CPU
accessed them. When DMA uses the buffers again, the memory
can happened to be flushed by cache while DMA starts transfer.

So using API dma_sync_single_for_device and dma_sync_single_for_cpu
in DMA to ensure DMA coherence and CPU always access the correct
value. This fix the issue that the encrypted result periodically goes
wrong when doing performance test with OpenSSH.

Signed-off-by: Leilei Zhao <leilei.zhao@atmel.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/crypto/atmel-aes.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index f0532ab..9bd3437 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -315,10 +315,10 @@ static int atmel_aes_crypt_dma(struct atmel_aes_dev *dd,
 
 	dd->dma_size = length;
 
-	if (!(dd->flags & AES_FLAGS_FAST)) {
-		dma_sync_single_for_device(dd->dev, dma_addr_in, length,
-					   DMA_TO_DEVICE);
-	}
+	dma_sync_single_for_device(dd->dev, dma_addr_in, length,
+				   DMA_TO_DEVICE);
+	dma_sync_single_for_device(dd->dev, dma_addr_out, length,
+				   DMA_FROM_DEVICE);
 
 	if (dd->flags & AES_FLAGS_CFB8) {
 		dd->dma_lch_in.dma_conf.dst_addr_width =
@@ -391,6 +391,11 @@ static int atmel_aes_crypt_cpu_start(struct atmel_aes_dev *dd)
 {
 	dd->flags &= ~AES_FLAGS_DMA;
 
+	dma_sync_single_for_cpu(dd->dev, dd->dma_addr_in,
+				dd->dma_size, DMA_TO_DEVICE);
+	dma_sync_single_for_cpu(dd->dev, dd->dma_addr_out,
+				dd->dma_size, DMA_FROM_DEVICE);
+
 	/* use cache buffers */
 	dd->nb_in_sg = atmel_aes_sg_length(dd->req, dd->in_sg);
 	if (!dd->nb_in_sg)
@@ -459,6 +464,9 @@ static int atmel_aes_crypt_dma_start(struct atmel_aes_dev *dd)
 		dd->flags |= AES_FLAGS_FAST;
 
 	} else {
+		dma_sync_single_for_cpu(dd->dev, dd->dma_addr_in,
+					dd->dma_size, DMA_TO_DEVICE);
+
 		/* use cache buffers */
 		count = atmel_aes_sg_copy(&dd->in_sg, &dd->in_offset,
 				dd->buf_in, dd->buflen, dd->total, 0);
-- 
1.7.9.5
