From: Syam Sidhardhan <syamsidhardh@gmail.com>
Subject: [PATCH] crypto: bfin_crc: Fix possible NULL pointer dereference
Date: Mon, 25 Feb 2013 03:57:39 +0530
Message-ID: <1361744859-28310-1-git-send-email-s.syam@samsung.com>
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
	syamsidhardh@gmail.com
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:55090 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758625Ab3BXW14 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 24 Feb 2013 17:27:56 -0500
Received: by mail-pa0-f48.google.com with SMTP id hz10so1380317pad.35
        for <linux-crypto@vger.kernel.org>; Sun, 24 Feb 2013 14:27:55 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

If we define dev_dbg(), then there is a possible NULL pointer
dereference.

Signed-off-by: Syam Sidhardhan <s.syam@samsung.com>
---
 drivers/crypto/bfin_crc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/bfin_crc.c b/drivers/crypto/bfin_crc.c
index 827913d..d797f31 100644
--- a/drivers/crypto/bfin_crc.c
+++ b/drivers/crypto/bfin_crc.c
@@ -151,7 +151,7 @@ static int bfin_crypto_crc_init(struct ahash_request *req)
 	struct bfin_crypto_crc_reqctx *ctx = ahash_request_ctx(req);
 	struct bfin_crypto_crc *crc;
 
-	dev_dbg(crc->dev, "crc_init\n");
+	dev_dbg(ctx->crc->dev, "crc_init\n");
 	spin_lock_bh(&crc_list.lock);
 	list_for_each_entry(crc, &crc_list.dev_list, list) {
 		crc_ctx->crc = crc;
@@ -160,7 +160,7 @@ static int bfin_crypto_crc_init(struct ahash_request *req)
 	spin_unlock_bh(&crc_list.lock);
 
 	if (sg_count(req->src) > CRC_MAX_DMA_DESC) {
-		dev_dbg(crc->dev, "init: requested sg list is too big > %d\n",
+		dev_dbg(ctx->crc->dev, "init: requested sg list is too big > %d\n",
 			CRC_MAX_DMA_DESC);
 		return -EINVAL;
 	}
@@ -175,7 +175,7 @@ static int bfin_crypto_crc_init(struct ahash_request *req)
 	/* init crc results */
 	put_unaligned_le32(crc_ctx->key, req->result);
 
-	dev_dbg(crc->dev, "init: digest size: %d\n",
+	dev_dbg(ctx->crc->dev, "init: digest size: %d\n",
 		crypto_ahash_digestsize(tfm));
 
 	return bfin_crypto_crc_init_hw(crc, crc_ctx->key);
-- 
1.7.9.5
