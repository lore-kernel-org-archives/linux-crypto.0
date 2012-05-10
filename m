From: Andreas Westin <andreas.westin@stericsson.com>
Subject: [PATCH v2 2/3] crypto: ux500: Update DMA handling for 3.4
Date: Thu, 10 May 2012 10:14:07 +0200
Message-ID: <1336637648-10064-3-git-send-email-andreas.westin@stericsson.com>
References: <1336637648-10064-1-git-send-email-andreas.westin@stericsson.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <arnd@arndb.de>,
	<sfr@canb.auug.org.au>, <lee.jones@linaro.org>,
	<linus.walleij@linaro.org>,
	Andreas Westin <andreas.westin@stericsson.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:36257 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757300Ab2EJIOi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 May 2012 04:14:38 -0400
In-Reply-To: <1336637648-10064-1-git-send-email-andreas.westin@stericsson.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

An update to the DMA framework added a new parameter to the
device_prep_slave_sg call.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Andreas Westin <andreas.westin@stericsson.com>
---
 drivers/crypto/ux500/cryp/cryp_core.c |    5 ++---
 drivers/crypto/ux500/hash/hash_core.c |    2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
index 7051e00..7cac127 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -542,8 +542,7 @@ static int cryp_set_dma_transfer(struct cryp_ctx *ctx,
 		desc = channel->device->device_prep_slave_sg(channel,
 					     ctx->device->dma.sg_src,
 					     ctx->device->dma.sg_src_len,
-					     direction,
-					     DMA_CTRL_ACK);
+					     direction, DMA_CTRL_ACK, NULL);
 		break;
 
 	case DMA_FROM_DEVICE:
@@ -569,7 +568,7 @@ static int cryp_set_dma_transfer(struct cryp_ctx *ctx,
 					     ctx->device->dma.sg_dst_len,
 					     direction,
 					     DMA_CTRL_ACK |
-					     DMA_PREP_INTERRUPT);
+					     DMA_PREP_INTERRUPT, NULL);
 
 		desc->callback = cryp_dma_out_callback;
 		desc->callback_param = ctx;
diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index cc6a371..77f7508 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -174,7 +174,7 @@ static int hash_set_dma_transfer(struct hash_ctx *ctx, struct scatterlist *sg,
 			"(TO_DEVICE)", __func__);
 	desc = channel->device->device_prep_slave_sg(channel,
 			ctx->device->dma.sg, ctx->device->dma.sg_len,
-			direction, DMA_CTRL_ACK | DMA_PREP_INTERRUPT);
+			direction, DMA_CTRL_ACK | DMA_PREP_INTERRUPT, NULL);
 	if (!desc) {
 		dev_err(ctx->device->dev,
 			"[%s]: device_prep_slave_sg() failed!", __func__);
-- 
1.7.10
