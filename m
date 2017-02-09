From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH next 1/2] crypto: atmel-sha: fix missing "return" instructions
Date: Thu, 9 Feb 2017 17:51:20 +0100
Message-ID: <f422ed3195a06d40da9f83e4ff3aa60427e82cc5.1486655562.git.cyrille.pitchen@atmel.com>
References: <cover.1486655562.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Cyrille Pitchen <cyrille.pitchen@atmel.com>, dan.carpenter@oracle.com,
 linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
 <nicolas.ferre@atmel.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <cover.1486655562.git.cyrille.pitchen@atmel.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

This patch fixes a previous patch: "crypto: atmel-sha - update request
queue management to make it more generic".

Indeed the patch above should have replaced the "return -EINVAL;" lines by
"return atmel_sha_complete(dd, -EINVAL);" but instead replaced them by a
simple call of "atmel_sha_complete(dd, -EINVAL);".
Hence all "return" instructions were missing.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
---
 drivers/crypto/atmel-sha.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 22d0c0c118da..d6c3d9529d36 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -668,7 +668,7 @@ static int atmel_sha_xmit_dma(struct atmel_sha_dev *dd, dma_addr_t dma_addr1,
 			DMA_MEM_TO_DEV, DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 	}
 	if (!in_desc)
-		atmel_sha_complete(dd, -EINVAL);
+		return atmel_sha_complete(dd, -EINVAL);
 
 	in_desc->callback = atmel_sha_dma_callback;
 	in_desc->callback_param = dd;
@@ -725,7 +725,7 @@ static int atmel_sha_xmit_dma_map(struct atmel_sha_dev *dd,
 	if (dma_mapping_error(dd->dev, ctx->dma_addr)) {
 		dev_err(dd->dev, "dma %u bytes error\n", ctx->buflen +
 				ctx->block_size);
-		atmel_sha_complete(dd, -EINVAL);
+		return atmel_sha_complete(dd, -EINVAL);
 	}
 
 	ctx->flags &= ~SHA_FLAGS_SG;
@@ -816,7 +816,7 @@ static int atmel_sha_update_dma_start(struct atmel_sha_dev *dd)
 		if (dma_mapping_error(dd->dev, ctx->dma_addr)) {
 			dev_err(dd->dev, "dma %u bytes error\n",
 				ctx->buflen + ctx->block_size);
-			atmel_sha_complete(dd, -EINVAL);
+			return atmel_sha_complete(dd, -EINVAL);
 		}
 
 		if (length == 0) {
@@ -830,7 +830,7 @@ static int atmel_sha_update_dma_start(struct atmel_sha_dev *dd)
 			if (!dma_map_sg(dd->dev, ctx->sg, 1,
 				DMA_TO_DEVICE)) {
 					dev_err(dd->dev, "dma_map_sg  error\n");
-					atmel_sha_complete(dd, -EINVAL);
+					return atmel_sha_complete(dd, -EINVAL);
 			}
 
 			ctx->flags |= SHA_FLAGS_SG;
@@ -844,7 +844,7 @@ static int atmel_sha_update_dma_start(struct atmel_sha_dev *dd)
 
 	if (!dma_map_sg(dd->dev, ctx->sg, 1, DMA_TO_DEVICE)) {
 		dev_err(dd->dev, "dma_map_sg  error\n");
-		atmel_sha_complete(dd, -EINVAL);
+		return atmel_sha_complete(dd, -EINVAL);
 	}
 
 	ctx->flags |= SHA_FLAGS_SG;
-- 
2.7.4
