From: Leilei Zhao <leilei.zhao@atmel.com>
Subject: [PATCH 10/10] crypto: atmel-aes: correct usage of dma_sync_* API
Date: Tue, 7 Apr 2015 17:45:11 +0800
Message-ID: <1428399911-23325-11-git-send-email-leilei.zhao@atmel.com>
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

The output buffer is used for CPU access, so
the API should be dma_sync_single_for_cpu which
makes the cache line invalid in order to reload
the value in memory.

Signed-off-by: Leilei Zhao <leilei.zhao@atmel.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/crypto/atmel-aes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 9bd3437..aa84623 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -627,7 +627,7 @@ static int atmel_aes_crypt_dma_stop(struct atmel_aes_dev *dd)
 			dma_unmap_sg(dd->dev, dd->out_sg, 1, DMA_FROM_DEVICE);
 			dma_unmap_sg(dd->dev, dd->in_sg, 1, DMA_TO_DEVICE);
 		} else {
-			dma_sync_single_for_device(dd->dev, dd->dma_addr_out,
+			dma_sync_single_for_cpu(dd->dev, dd->dma_addr_out,
 				dd->dma_size, DMA_FROM_DEVICE);
 
 			/* copy data */
-- 
1.7.9.5
