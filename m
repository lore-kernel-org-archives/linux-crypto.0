Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7518BC433E0
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Mar 2021 03:44:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B03B64E04
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Mar 2021 03:44:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbhCADoA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 28 Feb 2021 22:44:00 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12655 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231614AbhCADoA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 28 Feb 2021 22:44:00 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DpmJR6ZgzzlR3b;
        Mon,  1 Mar 2021 11:41:11 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Mon, 1 Mar 2021 11:43:12 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <marco.chiappero@intel.com>, <ebiggers@google.com>,
        <tomaszx.kowalik@intel.com>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <tanghui20@huawei.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] crypto: qat - fix use of 'dma_map_single'
Date:   Mon, 1 Mar 2021 11:40:58 +0800
Message-ID: <1614570058-38194-1-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

DMA_TO_DEVICE synchronisation must be done after the last modification
of the memory region by the software and before it is handed off to
the device.

Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 drivers/crypto/qat/qat_common/qat_algs.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index ff78c73..e88c534 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -731,10 +731,6 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 	if (unlikely(!bufl))
 		return -ENOMEM;
 
-	blp = dma_map_single(dev, bufl, sz, DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(dev, blp)))
-		goto err_in;
-
 	for_each_sg(sgl, sg, n, i) {
 		int y = sg_nctr;
 
@@ -750,6 +746,9 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 		sg_nctr++;
 	}
 	bufl->num_bufs = sg_nctr;
+	blp = dma_map_single(dev, bufl, sz, DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(dev, blp)))
+		goto err_in;
 	qat_req->buf.bl = bufl;
 	qat_req->buf.blp = blp;
 	qat_req->buf.sz = sz;
@@ -764,9 +763,6 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 				       dev_to_node(&GET_DEV(inst->accel_dev)));
 		if (unlikely(!buflout))
 			goto err_in;
-		bloutp = dma_map_single(dev, buflout, sz_out, DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(dev, bloutp)))
-			goto err_out;
 		bufers = buflout->bufers;
 		for_each_sg(sglout, sg, n, i) {
 			int y = sg_nctr;
@@ -784,6 +780,9 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 		}
 		buflout->num_bufs = sg_nctr;
 		buflout->num_mapped_bufs = sg_nctr;
+		bloutp = dma_map_single(dev, buflout, sz_out, DMA_TO_DEVICE);
+		if (unlikely(dma_mapping_error(dev, bloutp)))
+			goto err_out;
 		qat_req->buf.blout = buflout;
 		qat_req->buf.bloutp = bloutp;
 		qat_req->buf.sz_out = sz_out;
@@ -795,17 +794,21 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 	return 0;
 
 err_out:
+	if (!dma_mapping_error(dev, bloutp))
+		dma_unmap_single(dev, bloutp, sz_out, DMA_TO_DEVICE);
+
 	n = sg_nents(sglout);
 	for (i = 0; i < n; i++)
 		if (!dma_mapping_error(dev, buflout->bufers[i].addr))
 			dma_unmap_single(dev, buflout->bufers[i].addr,
 					 buflout->bufers[i].len,
 					 DMA_BIDIRECTIONAL);
-	if (!dma_mapping_error(dev, bloutp))
-		dma_unmap_single(dev, bloutp, sz_out, DMA_TO_DEVICE);
 	kfree(buflout);
 
 err_in:
+	if (!dma_mapping_error(dev, blp))
+		dma_unmap_single(dev, blp, sz, DMA_TO_DEVICE);
+
 	n = sg_nents(sgl);
 	for (i = 0; i < n; i++)
 		if (!dma_mapping_error(dev, bufl->bufers[i].addr))
@@ -813,8 +816,6 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 					 bufl->bufers[i].len,
 					 DMA_BIDIRECTIONAL);
 
-	if (!dma_mapping_error(dev, blp))
-		dma_unmap_single(dev, blp, sz, DMA_TO_DEVICE);
 	kfree(bufl);
 
 	dev_err(dev, "Failed to map buf for dma\n");
-- 
2.8.1

