From: Colin King <colin.king@canonical.com>
Subject: [PATCH] crypto: fix spelling mistake in dev_err error message
Date: Mon,  3 Aug 2015 00:05:03 +0100
Message-ID: <1438556703-22657-1-git-send-email-colin.king@canonical.com>
Cc: linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:58748 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbbHBXFk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 2 Aug 2015 19:05:40 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Trival change, fix spelling mistake 'aquire' -> 'acquire' in
dev_err message.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/crypto/img-hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
index ad47d0d..68e8aa9 100644
--- a/drivers/crypto/img-hash.c
+++ b/drivers/crypto/img-hash.c
@@ -334,7 +334,7 @@ static int img_hash_dma_init(struct img_hash_dev *hdev)
 
 	hdev->dma_lch = dma_request_slave_channel(hdev->dev, "tx");
 	if (!hdev->dma_lch) {
-		dev_err(hdev->dev, "Couldn't aquire a slave DMA channel.\n");
+		dev_err(hdev->dev, "Couldn't acquire a slave DMA channel.\n");
 		return -EBUSY;
 	}
 	dma_conf.direction = DMA_MEM_TO_DEV;
-- 
2.5.0
