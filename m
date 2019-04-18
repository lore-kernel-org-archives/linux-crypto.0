Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42D24C10F0E
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:39:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C047217FA
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:39:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388947AbfDRNjj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Apr 2019 09:39:39 -0400
Received: from foss.arm.com ([217.140.101.70]:33462 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733192AbfDRNjj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Apr 2019 09:39:39 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8DE1D80D;
        Thu, 18 Apr 2019 06:39:38 -0700 (PDT)
Received: from e110176-lin.kfn.arm.com (e110176-lin.kfn.arm.com [10.50.4.178])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 226A33F5AF;
        Thu, 18 Apr 2019 06:39:36 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/35] crypto: ccree: move MLLI desc. before key load
Date:   Thu, 18 Apr 2019 16:38:38 +0300
Message-Id: <20190418133913.9122-4-gilad@benyossef.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190418133913.9122-1-gilad@benyossef.com>
References: <20190418133913.9122-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Refactor to move the descriptor copying the MLLI line to SRAM
to before the key loading descriptor in preparation to the
introduction of CPP later on.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/ccree/cc_cipher.c | 58 +++++++++++++++++++-------------
 1 file changed, 35 insertions(+), 23 deletions(-)

diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index dcab96861d6f..e4398de3aa39 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -558,12 +558,38 @@ static void cc_setup_key_desc(struct crypto_tfm *tfm,
 	}
 }
 
-static void cc_setup_cipher_data(struct crypto_tfm *tfm,
-				 struct cipher_req_ctx *req_ctx,
-				 struct scatterlist *dst,
-				 struct scatterlist *src, unsigned int nbytes,
-				 void *areq, struct cc_hw_desc desc[],
-				 unsigned int *seq_size)
+static void cc_setup_mlli_desc(struct crypto_tfm *tfm,
+			       struct cipher_req_ctx *req_ctx,
+			       struct scatterlist *dst, struct scatterlist *src,
+			       unsigned int nbytes, void *areq,
+			       struct cc_hw_desc desc[], unsigned int *seq_size)
+{
+	struct cc_cipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
+	struct device *dev = drvdata_to_dev(ctx_p->drvdata);
+
+	if (req_ctx->dma_buf_type == CC_DMA_BUF_MLLI) {
+		/* bypass */
+		dev_dbg(dev, " bypass params addr %pad length 0x%X addr 0x%08X\n",
+			&req_ctx->mlli_params.mlli_dma_addr,
+			req_ctx->mlli_params.mlli_len,
+			(unsigned int)ctx_p->drvdata->mlli_sram_addr);
+		hw_desc_init(&desc[*seq_size]);
+		set_din_type(&desc[*seq_size], DMA_DLLI,
+			     req_ctx->mlli_params.mlli_dma_addr,
+			     req_ctx->mlli_params.mlli_len, NS_BIT);
+		set_dout_sram(&desc[*seq_size],
+			      ctx_p->drvdata->mlli_sram_addr,
+			      req_ctx->mlli_params.mlli_len);
+		set_flow_mode(&desc[*seq_size], BYPASS);
+		(*seq_size)++;
+	}
+}
+
+static void cc_setup_flow_desc(struct crypto_tfm *tfm,
+			       struct cipher_req_ctx *req_ctx,
+			       struct scatterlist *dst, struct scatterlist *src,
+			       unsigned int nbytes, void *areq,
+			       struct cc_hw_desc desc[], unsigned int *seq_size)
 {
 	struct cc_cipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx_p->drvdata);
@@ -600,21 +626,6 @@ static void cc_setup_cipher_data(struct crypto_tfm *tfm,
 		set_flow_mode(&desc[*seq_size], flow_mode);
 		(*seq_size)++;
 	} else {
-		/* bypass */
-		dev_dbg(dev, " bypass params addr %pad length 0x%X addr 0x%08X\n",
-			&req_ctx->mlli_params.mlli_dma_addr,
-			req_ctx->mlli_params.mlli_len,
-			(unsigned int)ctx_p->drvdata->mlli_sram_addr);
-		hw_desc_init(&desc[*seq_size]);
-		set_din_type(&desc[*seq_size], DMA_DLLI,
-			     req_ctx->mlli_params.mlli_dma_addr,
-			     req_ctx->mlli_params.mlli_len, NS_BIT);
-		set_dout_sram(&desc[*seq_size],
-			      ctx_p->drvdata->mlli_sram_addr,
-			      req_ctx->mlli_params.mlli_len);
-		set_flow_mode(&desc[*seq_size], BYPASS);
-		(*seq_size)++;
-
 		hw_desc_init(&desc[*seq_size]);
 		set_din_type(&desc[*seq_size], DMA_MLLI,
 			     ctx_p->drvdata->mlli_sram_addr,
@@ -794,11 +805,12 @@ static int cc_cipher_process(struct skcipher_request *req,
 
 	/* Setup IV and XEX key used */
 	cc_setup_state_desc(tfm, req_ctx, ivsize, nbytes, desc, &seq_len);
+	/* Setup MLLI line, if needed */
+	cc_setup_mlli_desc(tfm, req_ctx, dst, src, nbytes, req, desc, &seq_len);
 	/* Setup key */
 	cc_setup_key_desc(tfm, req_ctx, nbytes, desc, &seq_len);
 	/* Data processing */
-	cc_setup_cipher_data(tfm, req_ctx, dst, src, nbytes, req, desc,
-			     &seq_len);
+	cc_setup_flow_desc(tfm, req_ctx, dst, src, nbytes, req, desc, &seq_len);
 
 	/* STAT_PHASE_3: Lock HW and push sequence */
 
-- 
2.21.0

