Return-Path: <SRS0=Y8jf=AA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFD24C433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jun 2020 13:23:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAA4420DD4
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jun 2020 13:23:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732703AbgFSNX7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Jun 2020 09:23:59 -0400
Received: from inva020.nxp.com ([92.121.34.13]:38420 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732695AbgFSNX6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Jun 2020 09:23:58 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 46DA91A12E2;
        Fri, 19 Jun 2020 15:23:57 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 390421A0233;
        Fri, 19 Jun 2020 15:23:57 +0200 (CEST)
Received: from fsr-ub1864-014.ea.freescale.net (fsr-ub1864-014.ea.freescale.net [10.171.95.219])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id E77FB204B6;
        Fri, 19 Jun 2020 15:23:56 +0200 (CEST)
From:   =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        Colin King <colin.king@canonical.com>,
        linux-crypto@vger.kernel.org, NXP Linux Team <linux-imx@nxp.com>
Subject: [PATCH] crypto: caam/qi2 - fix return code in ahash_finup_no_ctx()
Date:   Fri, 19 Jun 2020 16:22:53 +0300
Message-Id: <20200619132253.17207-1-horia.geanta@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <b351f9b5-940c-61d3-38f2-3654c6da55b0@nxp.com>
References: <b351f9b5-940c-61d3-38f2-3654c6da55b0@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

ahash_finup_no_ctx() returns -ENOMEM in most error cases,
and this is fine for almost all of them.

However, the return code provided by dpaa2_caam_enqueue()
(e.g. -EIO or -EBUSY) shouldn't be overridden by -ENOMEM.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg_qi2.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 1e90412afea2..45e9ff851e2d 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -4004,7 +4004,7 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 	int digestsize = crypto_ahash_digestsize(ahash);
 	struct ahash_edesc *edesc;
 	struct dpaa2_sg_entry *sg_table;
-	int ret;
+	int ret = -ENOMEM;
 
 	src_nents = sg_nents_for_len(req->src, req->nbytes);
 	if (src_nents < 0) {
@@ -4017,7 +4017,7 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 					  DMA_TO_DEVICE);
 		if (!mapped_nents) {
 			dev_err(ctx->dev, "unable to DMA map source\n");
-			return -ENOMEM;
+			return ret;
 		}
 	} else {
 		mapped_nents = 0;
@@ -4027,7 +4027,7 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 	edesc = qi_cache_zalloc(GFP_DMA | flags);
 	if (!edesc) {
 		dma_unmap_sg(ctx->dev, req->src, src_nents, DMA_TO_DEVICE);
-		return -ENOMEM;
+		return ret;
 	}
 
 	edesc->src_nents = src_nents;
@@ -4044,6 +4044,7 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 					  DMA_TO_DEVICE);
 	if (dma_mapping_error(ctx->dev, edesc->qm_sg_dma)) {
 		dev_err(ctx->dev, "unable to map S/G table\n");
+		ret = -ENOMEM;
 		goto unmap;
 	}
 	edesc->qm_sg_bytes = qm_sg_bytes;
@@ -4054,6 +4055,7 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 	if (dma_mapping_error(ctx->dev, state->ctx_dma)) {
 		dev_err(ctx->dev, "unable to map ctx\n");
 		state->ctx_dma = 0;
+		ret = -ENOMEM;
 		goto unmap;
 	}
 
@@ -4080,7 +4082,7 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 unmap:
 	ahash_unmap_ctx(ctx->dev, edesc, req, DMA_FROM_DEVICE);
 	qi_cache_free(edesc);
-	return -ENOMEM;
+	return ret;
 }
 
 static int ahash_update_first(struct ahash_request *req)
-- 
2.17.1

