Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A42EC282DD
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:41:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A68020675
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:41:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389183AbfDRNl3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Apr 2019 09:41:29 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:33684 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388375AbfDRNl1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Apr 2019 09:41:27 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C5CB91688;
        Thu, 18 Apr 2019 06:41:26 -0700 (PDT)
Received: from e110176-lin.kfn.arm.com (e110176-lin.kfn.arm.com [10.50.4.178])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 59BC73F5AF;
        Thu, 18 Apr 2019 06:41:25 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 22/35] crypto: ccree: simplify fragment ICV detection
Date:   Thu, 18 Apr 2019 16:38:57 +0300
Message-Id: <20190418133913.9122-23-gilad@benyossef.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190418133913.9122-1-gilad@benyossef.com>
References: <20190418133913.9122-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The code detecting whether the ICV is fragmented was overly
complex and limited the number of fragments an ICV may be
comprised of with no reason in the current code, casuing the
new testmgr tests to fail.

This patch removes this legacy limitation and greatly simplifies
the code.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/ccree/cc_buffer_mgr.c | 106 ++++++---------------------
 drivers/crypto/ccree/cc_driver.h     |   1 -
 2 files changed, 21 insertions(+), 86 deletions(-)

diff --git a/drivers/crypto/ccree/cc_buffer_mgr.c b/drivers/crypto/ccree/cc_buffer_mgr.c
index 09d352591a30..8269474cb9fa 100644
--- a/drivers/crypto/ccree/cc_buffer_mgr.c
+++ b/drivers/crypto/ccree/cc_buffer_mgr.c
@@ -602,55 +602,10 @@ void cc_unmap_aead_request(struct device *dev, struct aead_request *req)
 	}
 }
 
-static int cc_get_aead_icv_nents(struct device *dev, struct scatterlist *sgl,
-				 unsigned int sgl_nents, unsigned int authsize,
-				 u32 last_entry_data_size,
-				 bool *is_icv_fragmented)
+static bool cc_is_icv_frag(unsigned int sgl_nents, unsigned int authsize,
+			   u32 last_entry_data_size)
 {
-	unsigned int icv_max_size = 0;
-	unsigned int icv_required_size = authsize > last_entry_data_size ?
-					(authsize - last_entry_data_size) :
-					authsize;
-	unsigned int nents;
-	unsigned int i;
-
-	if (sgl_nents < MAX_ICV_NENTS_SUPPORTED) {
-		*is_icv_fragmented = false;
-		return 0;
-	}
-
-	for (i = 0 ; i < (sgl_nents - MAX_ICV_NENTS_SUPPORTED) ; i++) {
-		if (!sgl)
-			break;
-		sgl = sg_next(sgl);
-	}
-
-	if (sgl)
-		icv_max_size = sgl->length;
-
-	if (last_entry_data_size > authsize) {
-		/* ICV attached to data in last entry (not fragmented!) */
-		nents = 0;
-		*is_icv_fragmented = false;
-	} else if (last_entry_data_size == authsize) {
-		/* ICV placed in whole last entry (not fragmented!) */
-		nents = 1;
-		*is_icv_fragmented = false;
-	} else if (icv_max_size > icv_required_size) {
-		nents = 1;
-		*is_icv_fragmented = true;
-	} else if (icv_max_size == icv_required_size) {
-		nents = 2;
-		*is_icv_fragmented = true;
-	} else {
-		dev_err(dev, "Unsupported num. of ICV fragments (> %d)\n",
-			MAX_ICV_NENTS_SUPPORTED);
-		nents = -1; /*unsupported*/
-	}
-	dev_dbg(dev, "is_frag=%s icv_nents=%u\n",
-		(*is_icv_fragmented ? "true" : "false"), nents);
-
-	return nents;
+	return ((sgl_nents > 1) && (last_entry_data_size < authsize));
 }
 
 static int cc_aead_chain_iv(struct cc_drvdata *drvdata,
@@ -817,16 +772,15 @@ static void cc_prepare_aead_data_dlli(struct aead_request *req,
 	}
 }
 
-static int cc_prepare_aead_data_mlli(struct cc_drvdata *drvdata,
-				     struct aead_request *req,
-				     struct buffer_array *sg_data,
-				     u32 *src_last_bytes, u32 *dst_last_bytes,
-				     bool is_last_table)
+static void cc_prepare_aead_data_mlli(struct cc_drvdata *drvdata,
+				      struct aead_request *req,
+				      struct buffer_array *sg_data,
+				      u32 *src_last_bytes, u32 *dst_last_bytes,
+				      bool is_last_table)
 {
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	enum drv_crypto_direction direct = areq_ctx->gen_ctx.op_type;
 	unsigned int authsize = areq_ctx->req_authsize;
-	int rc = 0, icv_nents;
 	struct device *dev = drvdata_to_dev(drvdata);
 	struct scatterlist *sg;
 
@@ -837,14 +791,9 @@ static int cc_prepare_aead_data_mlli(struct cc_drvdata *drvdata,
 				areq_ctx->src_offset, is_last_table,
 				&areq_ctx->src.mlli_nents);
 
-		icv_nents = cc_get_aead_icv_nents(dev, areq_ctx->src_sgl,
-						  areq_ctx->src.nents,
-						  authsize, *src_last_bytes,
-						  &areq_ctx->is_icv_fragmented);
-		if (icv_nents < 0) {
-			rc = -ENOTSUPP;
-			goto prepare_data_mlli_exit;
-		}
+		areq_ctx->is_icv_fragmented =
+			cc_is_icv_frag(areq_ctx->src.nents, authsize,
+				       *src_last_bytes);
 
 		if (areq_ctx->is_icv_fragmented) {
 			/* Backup happens only when ICV is fragmented, ICV
@@ -886,16 +835,11 @@ static int cc_prepare_aead_data_mlli(struct cc_drvdata *drvdata,
 				areq_ctx->dst_offset, is_last_table,
 				&areq_ctx->dst.mlli_nents);
 
-		icv_nents = cc_get_aead_icv_nents(dev, areq_ctx->src_sgl,
-						  areq_ctx->src.nents,
-						  authsize, *src_last_bytes,
-						  &areq_ctx->is_icv_fragmented);
-		if (icv_nents < 0) {
-			rc = -ENOTSUPP;
-			goto prepare_data_mlli_exit;
-		}
-
+		areq_ctx->is_icv_fragmented =
+			cc_is_icv_frag(areq_ctx->src.nents, authsize,
+				       *src_last_bytes);
 		/* Backup happens only when ICV is fragmented, ICV
+
 		 * verification is made by CPU compare in order to simplify
 		 * MAC verification upon request completion
 		 */
@@ -923,14 +867,9 @@ static int cc_prepare_aead_data_mlli(struct cc_drvdata *drvdata,
 				areq_ctx->src_offset, is_last_table,
 				&areq_ctx->src.mlli_nents);
 
-		icv_nents = cc_get_aead_icv_nents(dev, areq_ctx->dst_sgl,
-						  areq_ctx->dst.nents,
-						  authsize, *dst_last_bytes,
-						  &areq_ctx->is_icv_fragmented);
-		if (icv_nents < 0) {
-			rc = -ENOTSUPP;
-			goto prepare_data_mlli_exit;
-		}
+		areq_ctx->is_icv_fragmented =
+			cc_is_icv_frag(areq_ctx->dst.nents, authsize,
+				       *dst_last_bytes);
 
 		if (!areq_ctx->is_icv_fragmented) {
 			sg = &areq_ctx->dst_sgl[areq_ctx->dst.nents - 1];
@@ -944,9 +883,6 @@ static int cc_prepare_aead_data_mlli(struct cc_drvdata *drvdata,
 			areq_ctx->icv_virt_addr = areq_ctx->mac_buf;
 		}
 	}
-
-prepare_data_mlli_exit:
-	return rc;
 }
 
 static int cc_aead_chain_data(struct cc_drvdata *drvdata,
@@ -1053,9 +989,9 @@ static int cc_aead_chain_data(struct cc_drvdata *drvdata,
 	    dst_mapped_nents  > 1 ||
 	    do_chain) {
 		areq_ctx->data_buff_type = CC_DMA_BUF_MLLI;
-		rc = cc_prepare_aead_data_mlli(drvdata, req, sg_data,
-					       &src_last_bytes,
-					       &dst_last_bytes, is_last_table);
+		cc_prepare_aead_data_mlli(drvdata, req, sg_data,
+					  &src_last_bytes, &dst_last_bytes,
+					  is_last_table);
 	} else {
 		areq_ctx->data_buff_type = CC_DMA_BUF_DLLI;
 		cc_prepare_aead_data_dlli(req, &src_last_bytes,
diff --git a/drivers/crypto/ccree/cc_driver.h b/drivers/crypto/ccree/cc_driver.h
index d21e0f0b5218..935ae0ba75c0 100644
--- a/drivers/crypto/ccree/cc_driver.h
+++ b/drivers/crypto/ccree/cc_driver.h
@@ -108,7 +108,6 @@ enum cc_std_body {
 
 #define MAX_REQUEST_QUEUE_SIZE 4096
 #define MAX_MLLI_BUFF_SIZE 2080
-#define MAX_ICV_NENTS_SUPPORTED 2
 
 /* Definitions for HW descriptors DIN/DOUT fields */
 #define NS_BIT 1
-- 
2.21.0

