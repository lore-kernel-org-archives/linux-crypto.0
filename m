From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH trivial/resend 4/9] crypto: ux500: Update error message for dmaengine_prep_slave_sg() API
Date: Wed,  4 Mar 2015 10:19:30 +0100
Message-ID: <1425460770-9816-1-git-send-email-geert@linux-m68k.org>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from laurent.telenet-ops.be ([195.130.137.89]:60640 "EHLO
	laurent.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759693AbbCDJTg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 Mar 2015 04:19:36 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Geert Uytterhoeven <geert+renesas@glider.be>

Commit 7e933d3b1e25b250 ("crypto: ux500: use dmaengine_prep_slave_sg
API") changed the code to use the new API, but forgot to update an error
message.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
---
Resending trivial patches submitted in 2014.

 drivers/crypto/ux500/hash/hash_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index 187a8fd7eee7f5ec..5f5f360628fc443a 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -184,7 +184,7 @@ static int hash_set_dma_transfer(struct hash_ctx *ctx, struct scatterlist *sg,
 			direction, DMA_CTRL_ACK | DMA_PREP_INTERRUPT);
 	if (!desc) {
 		dev_err(ctx->device->dev,
-			"%s: device_prep_slave_sg() failed!\n", __func__);
+			"%s: dmaengine_prep_slave_sg() failed!\n", __func__);
 		return -EFAULT;
 	}
 
-- 
1.9.1
