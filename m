Return-Path: <SRS0=5M5o=S3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28566C43218
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Apr 2019 14:52:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 487242067C
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Apr 2019 14:52:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbfDYOwi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Apr 2019 10:52:38 -0400
Received: from inva020.nxp.com ([92.121.34.13]:53154 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726830AbfDYOwi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Apr 2019 10:52:38 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 391C31A028B;
        Thu, 25 Apr 2019 16:52:36 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 2C8471A01FC;
        Thu, 25 Apr 2019 16:52:36 +0200 (CEST)
Received: from fsr-ub1864-014.ea.freescale.net (fsr-ub1864-014.ea.freescale.net [10.171.95.219])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id E83C82061F;
        Thu, 25 Apr 2019 16:52:35 +0200 (CEST)
From:   =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH 1/3] crypto: caam/qi2 - fix zero-length buffer DMA mapping
Date:   Thu, 25 Apr 2019 17:52:21 +0300
Message-Id: <20190425145223.28603-2-horia.geanta@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190425145223.28603-1-horia.geanta@nxp.com>
References: <20190425145223.28603-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Commit 04e6d25c5bb2 ("crypto: caam - fix zero-length buffer DMA mapping")
fixed an issue in caam/jr driver where ahash implementation was
DMA mapping a zero-length buffer.

Current commit applies a similar fix for caam/qi2 driver.

Cc: <stable@vger.kernel.org> # v4.20+
Fixes: 3f16f6c9d632 ("crypto: caam/qi2 - add support for ahash algorithms")
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg_qi2.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index d19c97acf1aa..f3aac3efd51c 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -3795,10 +3795,13 @@ static int ahash_final_no_ctx(struct ahash_request *req)
 	if (!edesc)
 		return ret;
 
-	state->buf_dma = dma_map_single(ctx->dev, buf, buflen, DMA_TO_DEVICE);
-	if (dma_mapping_error(ctx->dev, state->buf_dma)) {
-		dev_err(ctx->dev, "unable to map src\n");
-		goto unmap;
+	if (buflen) {
+		state->buf_dma = dma_map_single(ctx->dev, buf, buflen,
+						DMA_TO_DEVICE);
+		if (dma_mapping_error(ctx->dev, state->buf_dma)) {
+			dev_err(ctx->dev, "unable to map src\n");
+			goto unmap;
+		}
 	}
 
 	edesc->dst_dma = dma_map_single(ctx->dev, req->result, digestsize,
@@ -3811,9 +3814,17 @@ static int ahash_final_no_ctx(struct ahash_request *req)
 
 	memset(&req_ctx->fd_flt, 0, sizeof(req_ctx->fd_flt));
 	dpaa2_fl_set_final(in_fle, true);
-	dpaa2_fl_set_format(in_fle, dpaa2_fl_single);
-	dpaa2_fl_set_addr(in_fle, state->buf_dma);
-	dpaa2_fl_set_len(in_fle, buflen);
+	/*
+	 * crypto engine requires the input entry to be present when
+	 * "frame list" FD is used.
+	 * Since engine does not support FMT=2'b11 (unused entry type), leaving
+	 * in_fle zeroized (except for "Final" flag) is the best option.
+	 */
+	if (buflen) {
+		dpaa2_fl_set_format(in_fle, dpaa2_fl_single);
+		dpaa2_fl_set_addr(in_fle, state->buf_dma);
+		dpaa2_fl_set_len(in_fle, buflen);
+	}
 	dpaa2_fl_set_format(out_fle, dpaa2_fl_single);
 	dpaa2_fl_set_addr(out_fle, edesc->dst_dma);
 	dpaa2_fl_set_len(out_fle, digestsize);
-- 
2.17.1

