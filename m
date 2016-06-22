From: Tero Kristo <t-kristo@ti.com>
Subject: [PATCHv2 03/27] crypto: omap: do not call dmaengine_terminate_all
Date: Wed, 22 Jun 2016 16:23:36 +0300
Message-ID: <1466601840-18486-4-git-send-email-t-kristo@ti.com>
References: <1466601840-18486-1-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-arm-kernel@lists.infradead.org>
To: <linux-omap@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<tony@atomide.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>, <lokeshvutla@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:50548 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbcFVNZI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jun 2016 09:25:08 -0400
In-Reply-To: <1466601840-18486-1-git-send-email-t-kristo@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Lokesh Vutla <lokeshvutla@ti.com>

The extra call to dmaengine_terminate_all is not needed, as the DMA
is not running at this point. This improves performance slightly.

Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 drivers/crypto/omap-aes.c  | 2 --
 drivers/crypto/omap-sham.c | 1 -
 2 files changed, 3 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 4a0e6a5..8178632 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -528,8 +528,6 @@ static int omap_aes_crypt_dma_stop(struct omap_aes_dev *dd)
 
 	omap_aes_dma_stop(dd);
 
-	dmaengine_terminate_all(dd->dma_lch_in);
-	dmaengine_terminate_all(dd->dma_lch_out);
 
 	return 0;
 }
diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 2b0a1bd..fd3cac3 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -815,7 +815,6 @@ static int omap_sham_update_dma_stop(struct omap_sham_dev *dd)
 {
 	struct omap_sham_reqctx *ctx = ahash_request_ctx(dd->req);
 
-	dmaengine_terminate_all(dd->dma_lch);
 
 	if (ctx->flags & BIT(FLAGS_SG)) {
 		dma_unmap_sg(dd->dev, ctx->sg, 1, DMA_TO_DEVICE);
-- 
1.9.1
