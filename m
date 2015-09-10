From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH 1/7] crypto: bfin: replace sg_count by sg_nents
Date: Thu, 10 Sep 2015 15:21:36 +0200
Message-ID: <1441891302-12014-2-git-send-email-clabbe.montjoie@gmail.com>
References: <1441891302-12014-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	LABBE Corentin <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1441891302-12014-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The sg_count function in bfin_crc.c is the same function as sg_nents.
Remove the duplicate code and use sg_nents() instead.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/crypto/bfin_crc.c | 25 +++----------------------
 1 file changed, 3 insertions(+), 22 deletions(-)

diff --git a/drivers/crypto/bfin_crc.c b/drivers/crypto/bfin_crc.c
index 2f0b333..95b7396 100644
--- a/drivers/crypto/bfin_crc.c
+++ b/drivers/crypto/bfin_crc.c
@@ -96,26 +96,6 @@ struct bfin_crypto_crc_ctx {
 	u32			key;
 };
 
-
-/*
- * derive number of elements in scatterlist
- */
-static int sg_count(struct scatterlist *sg_list)
-{
-	struct scatterlist *sg = sg_list;
-	int sg_nents = 1;
-
-	if (sg_list == NULL)
-		return 0;
-
-	while (!sg_is_last(sg)) {
-		sg_nents++;
-		sg = sg_next(sg);
-	}
-
-	return sg_nents;
-}
-
 /*
  * get element in scatter list by given index
  */
@@ -160,7 +140,7 @@ static int bfin_crypto_crc_init(struct ahash_request *req)
 	}
 	spin_unlock_bh(&crc_list.lock);
 
-	if (sg_count(req->src) > CRC_MAX_DMA_DESC) {
+	if (sg_nents(req->src) > CRC_MAX_DMA_DESC) {
 		dev_dbg(ctx->crc->dev, "init: requested sg list is too big > %d\n",
 			CRC_MAX_DMA_DESC);
 		return -EINVAL;
@@ -376,7 +356,8 @@ static int bfin_crypto_crc_handle_queue(struct bfin_crypto_crc *crc,
 			ctx->sg = req->src;
 
 		/* Chop crc buffer size to multiple of 32 bit */
-		nsg = ctx->sg_nents = sg_count(ctx->sg);
+		nsg = sg_nents(ctx->sg);
+		ctx->sg_nents = nsg;
 		ctx->sg_buflen = ctx->buflast_len + req->nbytes;
 		ctx->bufnext_len = ctx->sg_buflen % 4;
 		ctx->sg_buflen &= ~0x3;
-- 
2.4.6
