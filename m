Return-Path: <SRS0=ER81=T3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20E5DC07542
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 14:52:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 059612182B
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 14:52:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbfE0Ovw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 May 2019 10:51:52 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:36231 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726979AbfE0Ovv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 May 2019 10:51:51 -0400
X-Originating-IP: 90.88.147.134
Received: from localhost (aaubervilliers-681-1-27-134.w90-88.abo.wanadoo.fr [90.88.147.134])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 7D529C0008;
        Mon, 27 May 2019 14:51:44 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, maxime.chevallier@bootlin.com,
        gregory.clement@bootlin.com, miquel.raynal@bootlin.com,
        nadavh@marvell.com, igall@marvell.com
Subject: [PATCH 13/14] crypto: inside-secure - fix use of the SG list
Date:   Mon, 27 May 2019 16:51:05 +0200
Message-Id: <20190527145106.8693-14-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190527145106.8693-1-antoine.tenart@bootlin.com>
References: <20190527145106.8693-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Replace sg_nents_for_len by sg_nents when DMA mapping/unmapping buffers
and when looping over the SG entries. This fix cases where the SG
entries aren't used fully, which would in such cases led to using fewer
SG entries than needed (and thus the engine wouldn't have access to the
full input data and the result would be wrong).

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 .../crypto/inside-secure/safexcel_cipher.c    | 39 ++++++-------------
 drivers/crypto/inside-secure/safexcel_hash.c  |  3 +-
 2 files changed, 12 insertions(+), 30 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index cedfb121c278..6e193baccec7 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -369,16 +369,10 @@ static int safexcel_handle_req_result(struct safexcel_crypto_priv *priv, int rin
 	safexcel_complete(priv, ring);
 
 	if (src == dst) {
-		dma_unmap_sg(priv->dev, src,
-			     sg_nents_for_len(src, cryptlen),
-			     DMA_BIDIRECTIONAL);
+		dma_unmap_sg(priv->dev, src, sg_nents(src), DMA_BIDIRECTIONAL);
 	} else {
-		dma_unmap_sg(priv->dev, src,
-			     sg_nents_for_len(src, cryptlen),
-			     DMA_TO_DEVICE);
-		dma_unmap_sg(priv->dev, dst,
-			     sg_nents_for_len(dst, cryptlen),
-			     DMA_FROM_DEVICE);
+		dma_unmap_sg(priv->dev, src, sg_nents(src), DMA_TO_DEVICE);
+		dma_unmap_sg(priv->dev, dst, sg_nents(dst), DMA_FROM_DEVICE);
 	}
 
 	*should_complete = true;
@@ -403,26 +397,21 @@ static int safexcel_send_req(struct crypto_async_request *base, int ring,
 	int i, ret = 0;
 
 	if (src == dst) {
-		nr_src = dma_map_sg(priv->dev, src,
-				    sg_nents_for_len(src, totlen),
+		nr_src = dma_map_sg(priv->dev, src, sg_nents(src),
 				    DMA_BIDIRECTIONAL);
 		nr_dst = nr_src;
 		if (!nr_src)
 			return -EINVAL;
 	} else {
-		nr_src = dma_map_sg(priv->dev, src,
-				    sg_nents_for_len(src, totlen),
+		nr_src = dma_map_sg(priv->dev, src, sg_nents(src),
 				    DMA_TO_DEVICE);
 		if (!nr_src)
 			return -EINVAL;
 
-		nr_dst = dma_map_sg(priv->dev, dst,
-				    sg_nents_for_len(dst, totlen),
+		nr_dst = dma_map_sg(priv->dev, dst, sg_nents(dst),
 				    DMA_FROM_DEVICE);
 		if (!nr_dst) {
-			dma_unmap_sg(priv->dev, src,
-				     sg_nents_for_len(src, totlen),
-				     DMA_TO_DEVICE);
+			dma_unmap_sg(priv->dev, src, nr_src, DMA_TO_DEVICE);
 			return -EINVAL;
 		}
 	}
@@ -472,7 +461,7 @@ static int safexcel_send_req(struct crypto_async_request *base, int ring,
 
 	/* result descriptors */
 	for_each_sg(dst, sg, nr_dst, i) {
-		bool first = !i, last = (i == nr_dst - 1);
+		bool first = !i, last = sg_is_last(sg);
 		u32 len = sg_dma_len(sg);
 
 		rdesc = safexcel_add_rdesc(priv, ring, first, last,
@@ -501,16 +490,10 @@ static int safexcel_send_req(struct crypto_async_request *base, int ring,
 		safexcel_ring_rollback_wptr(priv, &priv->ring[ring].cdr);
 
 	if (src == dst) {
-		dma_unmap_sg(priv->dev, src,
-			     sg_nents_for_len(src, totlen),
-			     DMA_BIDIRECTIONAL);
+		dma_unmap_sg(priv->dev, src, nr_src, DMA_BIDIRECTIONAL);
 	} else {
-		dma_unmap_sg(priv->dev, src,
-			     sg_nents_for_len(src, totlen),
-			     DMA_TO_DEVICE);
-		dma_unmap_sg(priv->dev, dst,
-			     sg_nents_for_len(dst, totlen),
-			     DMA_FROM_DEVICE);
+		dma_unmap_sg(priv->dev, src, nr_src, DMA_TO_DEVICE);
+		dma_unmap_sg(priv->dev, dst, nr_dst, DMA_FROM_DEVICE);
 	}
 
 	return ret;
diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index 20950744ea4e..a80a5e757b1f 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -273,8 +273,7 @@ static int safexcel_ahash_send_req(struct crypto_async_request *async, int ring,
 	}
 
 	/* Now handle the current ahash request buffer(s) */
-	req->nents = dma_map_sg(priv->dev, areq->src,
-				sg_nents_for_len(areq->src, areq->nbytes),
+	req->nents = dma_map_sg(priv->dev, areq->src, sg_nents(areq->src),
 				DMA_TO_DEVICE);
 	if (!req->nents) {
 		ret = -ENOMEM;
-- 
2.21.0

