Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB926C10F14
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:41:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD85820675
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:41:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389342AbfDRNkn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Apr 2019 09:40:43 -0400
Received: from foss.arm.com ([217.140.101.70]:33584 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389142AbfDRNkh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Apr 2019 09:40:37 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 97C3480D;
        Thu, 18 Apr 2019 06:40:36 -0700 (PDT)
Received: from e110176-lin.kfn.arm.com (e110176-lin.kfn.arm.com [10.50.4.178])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EEA4E3F5AF;
        Thu, 18 Apr 2019 06:40:34 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, stable@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 13/35] crypto: ccree: remove special handling of chained sg
Date:   Thu, 18 Apr 2019 16:38:48 +0300
Message-Id: <20190418133913.9122-14-gilad@benyossef.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190418133913.9122-1-gilad@benyossef.com>
References: <20190418133913.9122-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

We were handling chained scattergather lists with specialized code
needlessly as the regular sg APIs handle them just fine. The code
handling this also had an (unused) code path with a use-before-init
error, flagged by Coverity.

Remove all special handling of chained sg and leave their handling
to the regular sg APIs.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: stable@vger.kernel.org # v4.19+
---
 drivers/crypto/ccree/cc_buffer_mgr.c | 98 +++++++---------------------
 1 file changed, 22 insertions(+), 76 deletions(-)

diff --git a/drivers/crypto/ccree/cc_buffer_mgr.c b/drivers/crypto/ccree/cc_buffer_mgr.c
index adef3cfa1251..7c92373df351 100644
--- a/drivers/crypto/ccree/cc_buffer_mgr.c
+++ b/drivers/crypto/ccree/cc_buffer_mgr.c
@@ -83,24 +83,17 @@ static void cc_copy_mac(struct device *dev, struct aead_request *req,
  */
 static unsigned int cc_get_sgl_nents(struct device *dev,
 				     struct scatterlist *sg_list,
-				     unsigned int nbytes, u32 *lbytes,
-				     bool *is_chained)
+				     unsigned int nbytes, u32 *lbytes)
 {
 	unsigned int nents = 0;
 
 	while (nbytes && sg_list) {
-		if (sg_list->length) {
-			nents++;
-			/* get the number of bytes in the last entry */
-			*lbytes = nbytes;
-			nbytes -= (sg_list->length > nbytes) ?
-					nbytes : sg_list->length;
-			sg_list = sg_next(sg_list);
-		} else {
-			sg_list = (struct scatterlist *)sg_page(sg_list);
-			if (is_chained)
-				*is_chained = true;
-		}
+		nents++;
+		/* get the number of bytes in the last entry */
+		*lbytes = nbytes;
+		nbytes -= (sg_list->length > nbytes) ?
+				nbytes : sg_list->length;
+		sg_list = sg_next(sg_list);
 	}
 	dev_dbg(dev, "nents %d last bytes %d\n", nents, *lbytes);
 	return nents;
@@ -142,7 +135,7 @@ void cc_copy_sg_portion(struct device *dev, u8 *dest, struct scatterlist *sg,
 {
 	u32 nents, lbytes;
 
-	nents = cc_get_sgl_nents(dev, sg, end, &lbytes, NULL);
+	nents = cc_get_sgl_nents(dev, sg, end, &lbytes);
 	sg_copy_buffer(sg, nents, (void *)dest, (end - to_skip + 1), to_skip,
 		       (direct == CC_SG_TO_BUF));
 }
@@ -314,40 +307,10 @@ static void cc_add_sg_entry(struct device *dev, struct buffer_array *sgl_data,
 	sgl_data->num_of_buffers++;
 }
 
-static int cc_dma_map_sg(struct device *dev, struct scatterlist *sg, u32 nents,
-			 enum dma_data_direction direction)
-{
-	u32 i, j;
-	struct scatterlist *l_sg = sg;
-
-	for (i = 0; i < nents; i++) {
-		if (!l_sg)
-			break;
-		if (dma_map_sg(dev, l_sg, 1, direction) != 1) {
-			dev_err(dev, "dma_map_page() sg buffer failed\n");
-			goto err;
-		}
-		l_sg = sg_next(l_sg);
-	}
-	return nents;
-
-err:
-	/* Restore mapped parts */
-	for (j = 0; j < i; j++) {
-		if (!sg)
-			break;
-		dma_unmap_sg(dev, sg, 1, direction);
-		sg = sg_next(sg);
-	}
-	return 0;
-}
-
 static int cc_map_sg(struct device *dev, struct scatterlist *sg,
 		     unsigned int nbytes, int direction, u32 *nents,
 		     u32 max_sg_nents, u32 *lbytes, u32 *mapped_nents)
 {
-	bool is_chained = false;
-
 	if (sg_is_last(sg)) {
 		/* One entry only case -set to DLLI */
 		if (dma_map_sg(dev, sg, 1, direction) != 1) {
@@ -361,35 +324,21 @@ static int cc_map_sg(struct device *dev, struct scatterlist *sg,
 		*nents = 1;
 		*mapped_nents = 1;
 	} else {  /*sg_is_last*/
-		*nents = cc_get_sgl_nents(dev, sg, nbytes, lbytes,
-					  &is_chained);
+		*nents = cc_get_sgl_nents(dev, sg, nbytes, lbytes);
 		if (*nents > max_sg_nents) {
 			*nents = 0;
 			dev_err(dev, "Too many fragments. current %d max %d\n",
 				*nents, max_sg_nents);
 			return -ENOMEM;
 		}
-		if (!is_chained) {
-			/* In case of mmu the number of mapped nents might
-			 * be changed from the original sgl nents
-			 */
-			*mapped_nents = dma_map_sg(dev, sg, *nents, direction);
-			if (*mapped_nents == 0) {
-				*nents = 0;
-				dev_err(dev, "dma_map_sg() sg buffer failed\n");
-				return -ENOMEM;
-			}
-		} else {
-			/*In this case the driver maps entry by entry so it
-			 * must have the same nents before and after map
-			 */
-			*mapped_nents = cc_dma_map_sg(dev, sg, *nents,
-						      direction);
-			if (*mapped_nents != *nents) {
-				*nents = *mapped_nents;
-				dev_err(dev, "dma_map_sg() sg buffer failed\n");
-				return -ENOMEM;
-			}
+		/* In case of mmu the number of mapped nents might
+		 * be changed from the original sgl nents
+		 */
+		*mapped_nents = dma_map_sg(dev, sg, *nents, direction);
+		if (*mapped_nents == 0) {
+			*nents = 0;
+			dev_err(dev, "dma_map_sg() sg buffer failed\n");
+			return -ENOMEM;
 		}
 	}
 
@@ -571,7 +520,6 @@ void cc_unmap_aead_request(struct device *dev, struct aead_request *req)
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct cc_drvdata *drvdata = dev_get_drvdata(dev);
 	u32 dummy;
-	bool chained;
 	u32 size_to_unmap = 0;
 
 	if (areq_ctx->mac_buf_dma_addr) {
@@ -636,15 +584,14 @@ void cc_unmap_aead_request(struct device *dev, struct aead_request *req)
 		size_to_unmap += crypto_aead_ivsize(tfm);
 
 	dma_unmap_sg(dev, req->src,
-		     cc_get_sgl_nents(dev, req->src, size_to_unmap,
-				      &dummy, &chained),
+		     cc_get_sgl_nents(dev, req->src, size_to_unmap, &dummy),
 		     DMA_BIDIRECTIONAL);
 	if (req->src != req->dst) {
 		dev_dbg(dev, "Unmapping dst sgl: req->dst=%pK\n",
 			sg_virt(req->dst));
 		dma_unmap_sg(dev, req->dst,
 			     cc_get_sgl_nents(dev, req->dst, size_to_unmap,
-					      &dummy, &chained),
+					      &dummy),
 			     DMA_BIDIRECTIONAL);
 	}
 	if (drvdata->coherent &&
@@ -1022,7 +969,6 @@ static int cc_aead_chain_data(struct cc_drvdata *drvdata,
 	unsigned int size_for_map = req->assoclen + req->cryptlen;
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	u32 sg_index = 0;
-	bool chained = false;
 	bool is_gcm4543 = areq_ctx->is_gcm4543;
 	u32 size_to_skip = req->assoclen;
 
@@ -1043,7 +989,7 @@ static int cc_aead_chain_data(struct cc_drvdata *drvdata,
 	size_for_map += (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ?
 			authsize : 0;
 	src_mapped_nents = cc_get_sgl_nents(dev, req->src, size_for_map,
-					    &src_last_bytes, &chained);
+					    &src_last_bytes);
 	sg_index = areq_ctx->src_sgl->length;
 	//check where the data starts
 	while (sg_index <= size_to_skip) {
@@ -1083,7 +1029,7 @@ static int cc_aead_chain_data(struct cc_drvdata *drvdata,
 	}
 
 	dst_mapped_nents = cc_get_sgl_nents(dev, req->dst, size_for_map,
-					    &dst_last_bytes, &chained);
+					    &dst_last_bytes);
 	sg_index = areq_ctx->dst_sgl->length;
 	offset = size_to_skip;
 
@@ -1484,7 +1430,7 @@ int cc_map_hash_request_update(struct cc_drvdata *drvdata, void *ctx,
 		dev_dbg(dev, " less than one block: curr_buff=%pK *curr_buff_cnt=0x%X copy_to=%pK\n",
 			curr_buff, *curr_buff_cnt, &curr_buff[*curr_buff_cnt]);
 		areq_ctx->in_nents =
-			cc_get_sgl_nents(dev, src, nbytes, &dummy, NULL);
+			cc_get_sgl_nents(dev, src, nbytes, &dummy);
 		sg_copy_to_buffer(src, areq_ctx->in_nents,
 				  &curr_buff[*curr_buff_cnt], nbytes);
 		*curr_buff_cnt += nbytes;
-- 
2.21.0

