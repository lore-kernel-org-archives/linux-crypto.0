Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B52F0C10F14
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:41:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9280F20675
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:41:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389242AbfDRNlo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Apr 2019 09:41:44 -0400
Received: from foss.arm.com ([217.140.101.70]:33710 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389216AbfDRNln (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Apr 2019 09:41:43 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4B58680D;
        Thu, 18 Apr 2019 06:41:43 -0700 (PDT)
Received: from e110176-lin.kfn.arm.com (e110176-lin.kfn.arm.com [10.50.4.178])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CF1ED3F5AF;
        Thu, 18 Apr 2019 06:41:41 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 25/35] crypto: ccree: make AEAD sgl iterator well behaved
Date:   Thu, 18 Apr 2019 16:39:00 +0300
Message-Id: <20190418133913.9122-26-gilad@benyossef.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190418133913.9122-1-gilad@benyossef.com>
References: <20190418133913.9122-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix some scatter list interation code was not handling scatter lists
being shorter than expected in a graceful manner.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/ccree/cc_buffer_mgr.c | 55 +++++++++-------------------
 1 file changed, 17 insertions(+), 38 deletions(-)

diff --git a/drivers/crypto/ccree/cc_buffer_mgr.c b/drivers/crypto/ccree/cc_buffer_mgr.c
index 86e498bee0bb..fa625bdde3f9 100644
--- a/drivers/crypto/ccree/cc_buffer_mgr.c
+++ b/drivers/crypto/ccree/cc_buffer_mgr.c
@@ -659,11 +659,9 @@ static int cc_aead_chain_assoc(struct cc_drvdata *drvdata,
 {
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	int rc = 0;
-	u32 mapped_nents = 0;
-	struct scatterlist *current_sg = req->src;
+	int mapped_nents = 0;
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	unsigned int sg_index = 0;
-	u32 size_of_assoc = areq_ctx->assoclen;
+	unsigned int size_of_assoc = areq_ctx->assoclen;
 	struct device *dev = drvdata_to_dev(drvdata);
 
 	if (areq_ctx->is_gcm4543)
@@ -684,26 +682,10 @@ static int cc_aead_chain_assoc(struct cc_drvdata *drvdata,
 		goto chain_assoc_exit;
 	}
 
-	//iterate over the sgl to see how many entries are for associated data
-	//it is assumed that if we reach here , the sgl is already mapped
-	sg_index = current_sg->length;
-	//the first entry in the scatter list contains all the associated data
-	if (sg_index > size_of_assoc) {
-		mapped_nents++;
-	} else {
-		while (sg_index <= size_of_assoc) {
-			current_sg = sg_next(current_sg);
-			/* if have reached the end of the sgl, then this is
-			 * unexpected
-			 */
-			if (!current_sg) {
-				dev_err(dev, "reached end of sg list. unexpected\n");
-				return -EINVAL;
-			}
-			sg_index += current_sg->length;
-			mapped_nents++;
-		}
-	}
+	mapped_nents = sg_nents_for_len(req->src, size_of_assoc);
+	if (mapped_nents < 0)
+		return mapped_nents;
+
 	if (mapped_nents > LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES) {
 		dev_err(dev, "Too many fragments. current %d max %d\n",
 			mapped_nents, LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES);
@@ -898,6 +880,7 @@ static int cc_aead_chain_data(struct cc_drvdata *drvdata,
 	u32 sg_index = 0;
 	bool is_gcm4543 = areq_ctx->is_gcm4543;
 	u32 size_to_skip = areq_ctx->assoclen;
+	struct scatterlist *sgl;
 
 	if (is_gcm4543)
 		size_to_skip += crypto_aead_ivsize(tfm);
@@ -920,15 +903,13 @@ static int cc_aead_chain_data(struct cc_drvdata *drvdata,
 	sg_index = areq_ctx->src_sgl->length;
 	//check where the data starts
 	while (sg_index <= size_to_skip) {
+		src_mapped_nents--;
 		offset -= areq_ctx->src_sgl->length;
-		areq_ctx->src_sgl = sg_next(areq_ctx->src_sgl);
-		//if have reached the end of the sgl, then this is unexpected
-		if (!areq_ctx->src_sgl) {
-			dev_err(dev, "reached end of sg list. unexpected\n");
-			return -EINVAL;
-		}
+		sgl = sg_next(areq_ctx->src_sgl);
+		if (!sgl)
+			break;
+		areq_ctx->src_sgl = sgl;
 		sg_index += areq_ctx->src_sgl->length;
-		src_mapped_nents--;
 	}
 	if (src_mapped_nents > LLI_MAX_NUM_OF_DATA_ENTRIES) {
 		dev_err(dev, "Too many fragments. current %d max %d\n",
@@ -962,15 +943,13 @@ static int cc_aead_chain_data(struct cc_drvdata *drvdata,
 
 	//check where the data starts
 	while (sg_index <= size_to_skip) {
+		dst_mapped_nents--;
 		offset -= areq_ctx->dst_sgl->length;
-		areq_ctx->dst_sgl = sg_next(areq_ctx->dst_sgl);
-		//if have reached the end of the sgl, then this is unexpected
-		if (!areq_ctx->dst_sgl) {
-			dev_err(dev, "reached end of sg list. unexpected\n");
-			return -EINVAL;
-		}
+		sgl = sg_next(areq_ctx->dst_sgl);
+		if (!sgl)
+			break;
+		areq_ctx->dst_sgl = sgl;
 		sg_index += areq_ctx->dst_sgl->length;
-		dst_mapped_nents--;
 	}
 	if (dst_mapped_nents > LLI_MAX_NUM_OF_DATA_ENTRIES) {
 		dev_err(dev, "Too many fragments. current %d max %d\n",
-- 
2.21.0

