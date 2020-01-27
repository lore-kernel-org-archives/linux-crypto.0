Return-Path: <SRS0=Q+7j=3Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 752EFC33CB1
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jan 2020 12:29:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52B0420702
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jan 2020 12:29:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729887AbgA0M3s (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Jan 2020 07:29:48 -0500
Received: from foss.arm.com ([217.140.110.172]:43792 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730196AbgA0M3r (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Jan 2020 07:29:47 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 281DF30E;
        Mon, 27 Jan 2020 04:29:47 -0800 (PST)
Received: from e110176-lin.kfn.arm.com (e110176-lin.kfn.arm.com [10.50.4.146])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C156A3F52E;
        Mon, 27 Jan 2020 04:29:45 -0800 (PST)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC] crypto: ccree - protect against short scatterlists
Date:   Mon, 27 Jan 2020 14:29:39 +0200
Message-Id: <20200127122939.6952-1-gilad@benyossef.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Deal gracefully with the event of being handed a scatterlist
which is shorter than expected.

This mitigates a crash in some cases of Crypto API calls due with
scatterlists with a NULL first buffer, despite the aead.h
forbidding doing so.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/crypto/ccree/cc_buffer_mgr.c | 54 ++++++++++++++--------------
 1 file changed, 26 insertions(+), 28 deletions(-)

diff --git a/drivers/crypto/ccree/cc_buffer_mgr.c b/drivers/crypto/ccree/cc_buffer_mgr.c
index a72586eccd81..62a0dfb0b0b6 100644
--- a/drivers/crypto/ccree/cc_buffer_mgr.c
+++ b/drivers/crypto/ccree/cc_buffer_mgr.c
@@ -87,6 +87,11 @@ static unsigned int cc_get_sgl_nents(struct device *dev,
 {
 	unsigned int nents = 0;
 
+	*lbytes = 0;
+
+	if (!sg_list || !sg_list->length)
+		goto out;
+
 	while (nbytes && sg_list) {
 		nents++;
 		/* get the number of bytes in the last entry */
@@ -95,6 +100,8 @@ static unsigned int cc_get_sgl_nents(struct device *dev,
 				nbytes : sg_list->length;
 		sg_list = sg_next(sg_list);
 	}
+
+out:
 	dev_dbg(dev, "nents %d last bytes %d\n", nents, *lbytes);
 	return nents;
 }
@@ -290,37 +297,28 @@ static int cc_map_sg(struct device *dev, struct scatterlist *sg,
 		     unsigned int nbytes, int direction, u32 *nents,
 		     u32 max_sg_nents, u32 *lbytes, u32 *mapped_nents)
 {
-	if (sg_is_last(sg)) {
-		/* One entry only case -set to DLLI */
-		if (dma_map_sg(dev, sg, 1, direction) != 1) {
-			dev_err(dev, "dma_map_sg() single buffer failed\n");
-			return -ENOMEM;
-		}
-		dev_dbg(dev, "Mapped sg: dma_address=%pad page=%p addr=%pK offset=%u length=%u\n",
-			&sg_dma_address(sg), sg_page(sg), sg_virt(sg),
-			sg->offset, sg->length);
-		*lbytes = nbytes;
-		*nents = 1;
-		*mapped_nents = 1;
-	} else {  /*sg_is_last*/
-		*nents = cc_get_sgl_nents(dev, sg, nbytes, lbytes);
-		if (*nents > max_sg_nents) {
-			*nents = 0;
-			dev_err(dev, "Too many fragments. current %d max %d\n",
-				*nents, max_sg_nents);
-			return -ENOMEM;
-		}
-		/* In case of mmu the number of mapped nents might
-		 * be changed from the original sgl nents
-		 */
-		*mapped_nents = dma_map_sg(dev, sg, *nents, direction);
-		if (*mapped_nents == 0) {
+	int ret = 0;
+
+	*nents = cc_get_sgl_nents(dev, sg, nbytes, lbytes);
+	if (*nents > max_sg_nents) {
+		*nents = 0;
+		dev_err(dev, "Too many fragments. current %d max %d\n",
+			*nents, max_sg_nents);
+		return -ENOMEM;
+	}
+
+	if (nents) {
+
+		ret = dma_map_sg(dev, sg, *nents, direction);
+		if (dma_mapping_error(dev, ret)) {
 			*nents = 0;
-			dev_err(dev, "dma_map_sg() sg buffer failed\n");
+			dev_err(dev, "dma_map_sg() sg buffer failed %d\n", ret);
 			return -ENOMEM;
 		}
 	}
 
+	*mapped_nents = ret;
+
 	return 0;
 }
 
@@ -881,7 +879,7 @@ static int cc_aead_chain_data(struct cc_drvdata *drvdata,
 					    &src_last_bytes);
 	sg_index = areq_ctx->src_sgl->length;
 	//check where the data starts
-	while (sg_index <= size_to_skip) {
+	while (src_mapped_nents && (sg_index <= size_to_skip)) {
 		src_mapped_nents--;
 		offset -= areq_ctx->src_sgl->length;
 		sgl = sg_next(areq_ctx->src_sgl);
@@ -921,7 +919,7 @@ static int cc_aead_chain_data(struct cc_drvdata *drvdata,
 	offset = size_to_skip;
 
 	//check where the data starts
-	while (sg_index <= size_to_skip) {
+	while (dst_mapped_nents && sg_index <= size_to_skip) {
 		dst_mapped_nents--;
 		offset -= areq_ctx->dst_sgl->length;
 		sgl = sg_next(areq_ctx->dst_sgl);
-- 
2.23.0

