From: Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 5/6] crypto: ux500: use dmaengine_prep_slave_sg API
Date: Tue, 25 Jun 2013 10:54:48 +0200
Message-ID: <1372150489-25594-6-git-send-email-fabio.baltieri@linaro.org>
References: <1372150489-25594-1-git-send-email-fabio.baltieri@linaro.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Linus Walleij <linus.walleij@linaro.org>,
	Lee Jones <lee.jones@linaro.org>,
	Fabio Baltieri <fabio.baltieri@linaro.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1372150489-25594-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Use dmaengine_prep_slave_sg inline function instead of going through the
structures manually.

Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/crypto/ux500/cryp/cryp_core.c | 20 ++++++++++----------
 drivers/crypto/ux500/hash/hash_core.c |  4 ++--
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
index 1957c18..0cd89df 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -553,10 +553,10 @@ static int cryp_set_dma_transfer(struct cryp_ctx *ctx,
 		dev_dbg(ctx->device->dev, "[%s]: Setting up DMA for buffer "
 			"(TO_DEVICE)", __func__);
 
-		desc = channel->device->device_prep_slave_sg(channel,
-					     ctx->device->dma.sg_src,
-					     ctx->device->dma.sg_src_len,
-					     direction, DMA_CTRL_ACK, NULL);
+		desc = dmaengine_prep_slave_sg(channel,
+				ctx->device->dma.sg_src,
+				ctx->device->dma.sg_src_len,
+				direction, DMA_CTRL_ACK);
 		break;
 
 	case DMA_FROM_DEVICE:
@@ -577,12 +577,12 @@ static int cryp_set_dma_transfer(struct cryp_ctx *ctx,
 		dev_dbg(ctx->device->dev, "[%s]: Setting up DMA for buffer "
 			"(FROM_DEVICE)", __func__);
 
-		desc = channel->device->device_prep_slave_sg(channel,
-					     ctx->device->dma.sg_dst,
-					     ctx->device->dma.sg_dst_len,
-					     direction,
-					     DMA_CTRL_ACK |
-					     DMA_PREP_INTERRUPT, NULL);
+		desc = dmaengine_prep_slave_sg(channel,
+				ctx->device->dma.sg_dst,
+				ctx->device->dma.sg_dst_len,
+				direction,
+				DMA_CTRL_ACK |
+				DMA_PREP_INTERRUPT);
 
 		desc->callback = cryp_dma_out_callback;
 		desc->callback_param = ctx;
diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index 8c2817804..3527777 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -180,9 +180,9 @@ static int hash_set_dma_transfer(struct hash_ctx *ctx, struct scatterlist *sg,
 
 	dev_dbg(ctx->device->dev, "[%s]: Setting up DMA for buffer "
 			"(TO_DEVICE)", __func__);
-	desc = channel->device->device_prep_slave_sg(channel,
+	desc = dmaengine_prep_slave_sg(channel,
 			ctx->device->dma.sg, ctx->device->dma.sg_len,
-			direction, DMA_CTRL_ACK | DMA_PREP_INTERRUPT, NULL);
+			direction, DMA_CTRL_ACK | DMA_PREP_INTERRUPT);
 	if (!desc) {
 		dev_err(ctx->device->dev,
 			"[%s]: device_prep_slave_sg() failed!", __func__);
-- 
1.8.2
