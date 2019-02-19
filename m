Return-Path: <SRS0=4Nwj=Q2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87CA3C10F02
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Feb 2019 14:57:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6071521736
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Feb 2019 14:57:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726110AbfBSO5K (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Feb 2019 09:57:10 -0500
Received: from inva021.nxp.com ([92.121.34.21]:48566 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbfBSO5K (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Feb 2019 09:57:10 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 76F5B2001A3;
        Tue, 19 Feb 2019 15:57:08 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 69C6920012C;
        Tue, 19 Feb 2019 15:57:08 +0100 (CET)
Received: from enigma.ea.freescale.net (enigma.ea.freescale.net [10.171.81.110])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 17EAC2061F;
        Tue, 19 Feb 2019 15:57:08 +0100 (CET)
From:   =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-crypto@vger.kernel.org, linux-imx <linux-imx@nxp.com>
Subject: [PATCH 1/3] crypto: caam - fix hash context DMA unmap size
Date:   Tue, 19 Feb 2019 16:56:55 +0200
Message-Id: <20190219145657.2267-2-horia.geanta@nxp.com>
X-Mailer: git-send-email 2.16.2
In-Reply-To: <20190219145657.2267-1-horia.geanta@nxp.com>
References: <20190219145657.2267-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Franck LENORMAND <franck.lenormand@nxp.com>

When driver started using state->caam_ctxt for storing both running hash
and final hash, it was not updated to handle different DMA unmap
lengths.

Cc: <stable@vger.kernel.org> # v4.19+
Fixes: c19650d6ea99 ("crypto: caam - fix DMA mapping of stack memory")
Signed-off-by: Franck LENORMAND <franck.lenormand@nxp.com>
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamhash.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 3bba3cb92f03..2c5aca59229b 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -114,6 +114,7 @@ struct caam_hash_ctx {
 struct caam_hash_state {
 	dma_addr_t buf_dma;
 	dma_addr_t ctx_dma;
+	int ctx_dma_len;
 	u8 buf_0[CAAM_MAX_HASH_BLOCK_SIZE] ____cacheline_aligned;
 	int buflen_0;
 	u8 buf_1[CAAM_MAX_HASH_BLOCK_SIZE] ____cacheline_aligned;
@@ -171,6 +172,7 @@ static inline int map_seq_out_ptr_ctx(u32 *desc, struct device *jrdev,
 				      struct caam_hash_state *state,
 				      int ctx_len)
 {
+	state->ctx_dma_len = ctx_len;
 	state->ctx_dma = dma_map_single(jrdev, state->caam_ctx,
 					ctx_len, DMA_FROM_DEVICE);
 	if (dma_mapping_error(jrdev, state->ctx_dma)) {
@@ -212,6 +214,7 @@ static inline int ctx_map_to_sec4_sg(struct device *jrdev,
 				     struct caam_hash_state *state, int ctx_len,
 				     struct sec4_sg_entry *sec4_sg, u32 flag)
 {
+	state->ctx_dma_len = ctx_len;
 	state->ctx_dma = dma_map_single(jrdev, state->caam_ctx, ctx_len, flag);
 	if (dma_mapping_error(jrdev, state->ctx_dma)) {
 		dev_err(jrdev, "unable to map ctx\n");
@@ -594,12 +597,10 @@ static inline void ahash_unmap_ctx(struct device *dev,
 			struct ahash_edesc *edesc,
 			struct ahash_request *req, int dst_len, u32 flag)
 {
-	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
-	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct caam_hash_state *state = ahash_request_ctx(req);
 
 	if (state->ctx_dma) {
-		dma_unmap_single(dev, state->ctx_dma, ctx->ctx_len, flag);
+		dma_unmap_single(dev, state->ctx_dma, state->ctx_dma_len, flag);
 		state->ctx_dma = 0;
 	}
 	ahash_unmap(dev, edesc, req, dst_len);
@@ -1580,6 +1581,7 @@ static int ahash_init(struct ahash_request *req)
 	state->final = ahash_final_no_ctx;
 
 	state->ctx_dma = 0;
+	state->ctx_dma_len = 0;
 	state->current_buf = 0;
 	state->buf_dma = 0;
 	state->buflen_0 = 0;
-- 
2.16.2

