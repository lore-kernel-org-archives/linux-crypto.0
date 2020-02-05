Return-Path: <SRS0=oWw0=3Z=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E07C1C35249
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Feb 2020 05:19:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C65F217BA
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Feb 2020 05:19:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725913AbgBEFTk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 Feb 2020 00:19:40 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:19113 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbgBEFTk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Feb 2020 00:19:40 -0500
Received: from chumthang.blr.asicdesigners.com (chumthang.blr.asicdesigners.com [10.193.186.96])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 0155J7iT019895;
        Tue, 4 Feb 2020 21:19:34 -0800
From:   Ayush Sawal <ayush.sawal@chelsio.com>
To:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Cc:     manojmalviya@chelsio.com, Ayush Sawal <ayush.sawal@chelsio.com>
Subject: [PATCH crypto/chcr 2/2] This fixes the kernel panic which occurs during a libkcapi test
Date:   Wed,  5 Feb 2020 10:48:42 +0530
Message-Id: <20200205051842.29324-3-ayush.sawal@chelsio.com>
X-Mailer: git-send-email 2.25.0.114.g5b0ca87
In-Reply-To: <20200205051842.29324-1-ayush.sawal@chelsio.com>
References: <20200205051842.29324-1-ayush.sawal@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The libkcapi test which causes kernel panic is
aead asynchronous vmsplice multiple test.

./bin/kcapi  -v -d 4 -x 10   -c "ccm(aes)"
-q 4edb58e8d5eb6bc711c43a6f3693daebde2e5524f1b55297abb29f003236e43d
-t a7877c99 -n 674742abd0f5ba -k 2861fd0253705d7875c95ba8a53171b4
-a fb7bc304a3909e66e2e0c5ef952712dd884ce3e7324171369f2c5db1adc48c7d

This patch avoids dma_mapping of a zero length sg which causes the panic,
by using sg_nents_for_len which maps only upto a specific length

Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
---
 drivers/crypto/chelsio/chcr_algo.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index 699e3053895a..02b0ddb785a4 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -2489,8 +2489,9 @@ int chcr_aead_dma_map(struct device *dev,
 	else
 		reqctx->b0_dma = 0;
 	if (req->src == req->dst) {
-		error = dma_map_sg(dev, req->src, sg_nents(req->src),
-				   DMA_BIDIRECTIONAL);
+		error = dma_map_sg(dev, req->src,
+				sg_nents_for_len(req->src, dst_size),
+					DMA_BIDIRECTIONAL);
 		if (!error)
 			goto err;
 	} else {
-- 
2.25.0.114.g5b0ca87

