Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60D84C10F14
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:41:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C07C20675
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:41:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389167AbfDRNlQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Apr 2019 09:41:16 -0400
Received: from foss.arm.com ([217.140.101.70]:33656 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388375AbfDRNlP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Apr 2019 09:41:15 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 938DF1688;
        Thu, 18 Apr 2019 06:41:15 -0700 (PDT)
Received: from e110176-lin.kfn.arm.com (e110176-lin.kfn.arm.com [10.50.4.178])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 27D743F5AF;
        Thu, 18 Apr 2019 06:41:13 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 20/35] crypto: ccree: do not copy zero size MLLI table
Date:   Thu, 18 Apr 2019 16:38:55 +0300
Message-Id: <20190418133913.9122-21-gilad@benyossef.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190418133913.9122-1-gilad@benyossef.com>
References: <20190418133913.9122-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When we are given a 0 sized cryptlen and assoclen in
a scatterlist with two entries we were falsely trying to
create a zero length MLLI table, causing the HW to choke.
Don't try to copy a zero sized MLLI table.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/ccree/cc_aead.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccree/cc_aead.c b/drivers/crypto/ccree/cc_aead.c
index 0fa676b5603c..0e8d2381c175 100644
--- a/drivers/crypto/ccree/cc_aead.c
+++ b/drivers/crypto/ccree/cc_aead.c
@@ -1163,9 +1163,9 @@ static void cc_mlli_to_sram(struct aead_request *req,
 	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 
-	if (req_ctx->assoc_buff_type == CC_DMA_BUF_MLLI ||
+	if ((req_ctx->assoc_buff_type == CC_DMA_BUF_MLLI ||
 	    req_ctx->data_buff_type == CC_DMA_BUF_MLLI ||
-	    !req_ctx->is_single_pass) {
+	    !req_ctx->is_single_pass) && req_ctx->mlli_params.mlli_len) {
 		dev_dbg(dev, "Copy-to-sram: mlli_dma=%08x, mlli_size=%u\n",
 			(unsigned int)ctx->drvdata->mlli_sram_addr,
 			req_ctx->mlli_params.mlli_len);
-- 
2.21.0

