Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CC6EC10F0E
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:41:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 772CA20675
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:41:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389200AbfDRNld (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Apr 2019 09:41:33 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:33692 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388375AbfDRNlc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Apr 2019 09:41:32 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4F0891688;
        Thu, 18 Apr 2019 06:41:32 -0700 (PDT)
Received: from e110176-lin.kfn.arm.com (e110176-lin.kfn.arm.com [10.50.4.178])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D7CBF3F5AF;
        Thu, 18 Apr 2019 06:41:30 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 23/35] crypto: ccree: simplify AEAD ICV addr calculation
Date:   Thu, 18 Apr 2019 16:38:58 +0300
Message-Id: <20190418133913.9122-24-gilad@benyossef.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190418133913.9122-1-gilad@benyossef.com>
References: <20190418133913.9122-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The function cc_prepare_aead_data_dlli() which calculates ICV addresses
was needlessly complicate it. This patch simplifies it without altering
its functionality.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/ccree/cc_buffer_mgr.c | 28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/ccree/cc_buffer_mgr.c b/drivers/crypto/ccree/cc_buffer_mgr.c
index 8269474cb9fa..8554cfb2963a 100644
--- a/drivers/crypto/ccree/cc_buffer_mgr.c
+++ b/drivers/crypto/ccree/cc_buffer_mgr.c
@@ -749,27 +749,21 @@ static void cc_prepare_aead_data_dlli(struct aead_request *req,
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	enum drv_crypto_direction direct = areq_ctx->gen_ctx.op_type;
 	unsigned int authsize = areq_ctx->req_authsize;
+	struct scatterlist *sg;
+	ssize_t offset;
 
 	areq_ctx->is_icv_fragmented = false;
-	if (req->src == req->dst) {
-		/*INPLACE*/
-		areq_ctx->icv_dma_addr = sg_dma_address(areq_ctx->src_sgl) +
-			(*src_last_bytes - authsize);
-		areq_ctx->icv_virt_addr = sg_virt(areq_ctx->src_sgl) +
-			(*src_last_bytes - authsize);
-	} else if (direct == DRV_CRYPTO_DIRECTION_DECRYPT) {
-		/*NON-INPLACE and DECRYPT*/
-		areq_ctx->icv_dma_addr = sg_dma_address(areq_ctx->src_sgl) +
-			(*src_last_bytes - authsize);
-		areq_ctx->icv_virt_addr = sg_virt(areq_ctx->src_sgl) +
-			(*src_last_bytes - authsize);
+
+	if ((req->src == req->dst) || direct == DRV_CRYPTO_DIRECTION_DECRYPT) {
+		sg = areq_ctx->src_sgl;
+		offset = *src_last_bytes - authsize;
 	} else {
-		/*NON-INPLACE and ENCRYPT*/
-		areq_ctx->icv_dma_addr = sg_dma_address(areq_ctx->dst_sgl) +
-			(*dst_last_bytes - authsize);
-		areq_ctx->icv_virt_addr = sg_virt(areq_ctx->dst_sgl) +
-			(*dst_last_bytes - authsize);
+		sg = areq_ctx->dst_sgl;
+		offset = *dst_last_bytes - authsize;
 	}
+
+	areq_ctx->icv_dma_addr = sg_dma_address(sg) + offset;
+	areq_ctx->icv_virt_addr = sg_virt(sg) + offset;
 }
 
 static void cc_prepare_aead_data_mlli(struct cc_drvdata *drvdata,
-- 
2.21.0

