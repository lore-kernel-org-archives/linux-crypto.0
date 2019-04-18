Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9F0BC10F0E
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:41:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83BD920675
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:41:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388301AbfDRNk7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Apr 2019 09:40:59 -0400
Received: from foss.arm.com ([217.140.101.70]:33628 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388582AbfDRNk7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Apr 2019 09:40:59 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CE9CD80D;
        Thu, 18 Apr 2019 06:40:58 -0700 (PDT)
Received: from e110176-lin.kfn.arm.com (e110176-lin.kfn.arm.com [10.50.4.178])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 62BBA3F5AF;
        Thu, 18 Apr 2019 06:40:57 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 17/35] crypto: ccree: use std api when possible
Date:   Thu, 18 Apr 2019 16:38:52 +0300
Message-Id: <20190418133913.9122-18-gilad@benyossef.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190418133913.9122-1-gilad@benyossef.com>
References: <20190418133913.9122-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Move to use the std api sg_nents_for_len() when we do not in fact
require the extra information about the number of bytes in the last
entry provided by the in-driver variant cc_get_sgl_nents().

This also resolves a Coverity warning cause by us not using
the output value.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/ccree/cc_buffer_mgr.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/ccree/cc_buffer_mgr.c b/drivers/crypto/ccree/cc_buffer_mgr.c
index 7c92373df351..ccb0257bdc58 100644
--- a/drivers/crypto/ccree/cc_buffer_mgr.c
+++ b/drivers/crypto/ccree/cc_buffer_mgr.c
@@ -133,9 +133,9 @@ void cc_zero_sgl(struct scatterlist *sgl, u32 data_len)
 void cc_copy_sg_portion(struct device *dev, u8 *dest, struct scatterlist *sg,
 			u32 to_skip, u32 end, enum cc_sg_cpy_direct direct)
 {
-	u32 nents, lbytes;
+	u32 nents;
 
-	nents = cc_get_sgl_nents(dev, sg, end, &lbytes);
+	nents = sg_nents_for_len(sg, end);
 	sg_copy_buffer(sg, nents, (void *)dest, (end - to_skip + 1), to_skip,
 		       (direct == CC_SG_TO_BUF));
 }
@@ -519,7 +519,6 @@ void cc_unmap_aead_request(struct device *dev, struct aead_request *req)
 	unsigned int hw_iv_size = areq_ctx->hw_iv_size;
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct cc_drvdata *drvdata = dev_get_drvdata(dev);
-	u32 dummy;
 	u32 size_to_unmap = 0;
 
 	if (areq_ctx->mac_buf_dma_addr) {
@@ -583,15 +582,13 @@ void cc_unmap_aead_request(struct device *dev, struct aead_request *req)
 	if (areq_ctx->is_gcm4543)
 		size_to_unmap += crypto_aead_ivsize(tfm);
 
-	dma_unmap_sg(dev, req->src,
-		     cc_get_sgl_nents(dev, req->src, size_to_unmap, &dummy),
+	dma_unmap_sg(dev, req->src, sg_nents_for_len(req->src, size_to_unmap),
 		     DMA_BIDIRECTIONAL);
 	if (req->src != req->dst) {
 		dev_dbg(dev, "Unmapping dst sgl: req->dst=%pK\n",
 			sg_virt(req->dst));
 		dma_unmap_sg(dev, req->dst,
-			     cc_get_sgl_nents(dev, req->dst, size_to_unmap,
-					      &dummy),
+			     sg_nents_for_len(req->dst, size_to_unmap),
 			     DMA_BIDIRECTIONAL);
 	}
 	if (drvdata->coherent &&
@@ -1429,8 +1426,7 @@ int cc_map_hash_request_update(struct cc_drvdata *drvdata, void *ctx,
 	if (total_in_len < block_size) {
 		dev_dbg(dev, " less than one block: curr_buff=%pK *curr_buff_cnt=0x%X copy_to=%pK\n",
 			curr_buff, *curr_buff_cnt, &curr_buff[*curr_buff_cnt]);
-		areq_ctx->in_nents =
-			cc_get_sgl_nents(dev, src, nbytes, &dummy);
+		areq_ctx->in_nents = sg_nents_for_len(src, nbytes);
 		sg_copy_to_buffer(src, areq_ctx->in_nents,
 				  &curr_buff[*curr_buff_cnt], nbytes);
 		*curr_buff_cnt += nbytes;
-- 
2.21.0

