From: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Subject: [PATCH 1/1] crypto: img-hash - use dma_data_direction when calling dma_map_sg
Date: Sun, 15 Jan 2017 13:37:50 +0100
Message-ID: <20170115123750.3010-1-nicolas.iooss_linux@m4x.org>
Cc: linux-kernel@vger.kernel.org,
        Nicolas Iooss <nicolas.iooss_linux@m4x.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The fourth argument of dma_map_sg() and dma_unmap_sg() is an item of
dma_data_direction enum. Function img_hash_xmit_dma() wrongly used
DMA_MEM_TO_DEV, which is an item of dma_transfer_direction enum.

Replace DMA_MEM_TO_DEV (which value is 1) with DMA_TO_DEVICE (which
value is fortunately also 1) when calling dma_map_sg() and
dma_unmap_sg().

Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
---
 drivers/crypto/img-hash.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
index a2e77b87485b..9b07f3d88feb 100644
--- a/drivers/crypto/img-hash.c
+++ b/drivers/crypto/img-hash.c
@@ -226,7 +226,7 @@ static int img_hash_xmit_dma(struct img_hash_dev *hdev, struct scatterlist *sg)
 	struct dma_async_tx_descriptor *desc;
 	struct img_hash_request_ctx *ctx = ahash_request_ctx(hdev->req);
 
-	ctx->dma_ct = dma_map_sg(hdev->dev, sg, 1, DMA_MEM_TO_DEV);
+	ctx->dma_ct = dma_map_sg(hdev->dev, sg, 1, DMA_TO_DEVICE);
 	if (ctx->dma_ct == 0) {
 		dev_err(hdev->dev, "Invalid DMA sg\n");
 		hdev->err = -EINVAL;
@@ -241,7 +241,7 @@ static int img_hash_xmit_dma(struct img_hash_dev *hdev, struct scatterlist *sg)
 	if (!desc) {
 		dev_err(hdev->dev, "Null DMA descriptor\n");
 		hdev->err = -EINVAL;
-		dma_unmap_sg(hdev->dev, sg, 1, DMA_MEM_TO_DEV);
+		dma_unmap_sg(hdev->dev, sg, 1, DMA_TO_DEVICE);
 		return -EINVAL;
 	}
 	desc->callback = img_hash_dma_callback;
-- 
2.11.0
