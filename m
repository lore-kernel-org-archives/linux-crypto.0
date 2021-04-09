Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 964C0C433B4
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Apr 2021 09:06:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A73C61186
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Apr 2021 09:06:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbhDIJHD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Apr 2021 05:07:03 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:16871 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231756AbhDIJHC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Apr 2021 05:07:02 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FGsf44gfRzlWxL;
        Fri,  9 Apr 2021 17:05:00 +0800 (CST)
Received: from huawei.com (10.67.165.24) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.498.0; Fri, 9 Apr 2021
 17:06:39 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yekai13@huawei.com>
Subject: [PATCH v3 3/5] crypto: hisilicon/sgl - add some dfx logs
Date:   Fri, 9 Apr 2021 17:04:02 +0800
Message-ID: <1617959044-11023-4-git-send-email-yekai13@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1617959044-11023-1-git-send-email-yekai13@huawei.com>
References: <1617959044-11023-1-git-send-email-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add some dfx logs in some abnormal exit situations.

Signed-off-by: Kai Ye <yekai13@huawei.com>
---
 drivers/crypto/hisilicon/sgl.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/hisilicon/sgl.c b/drivers/crypto/hisilicon/sgl.c
index b8a811f..d04e551 100644
--- a/drivers/crypto/hisilicon/sgl.c
+++ b/drivers/crypto/hisilicon/sgl.c
@@ -90,8 +90,10 @@ struct hisi_acc_sgl_pool *hisi_acc_create_sgl_pool(struct device *dev,
 		block[i].sgl = dma_alloc_coherent(dev, block_size,
 						  &block[i].sgl_dma,
 						  GFP_KERNEL);
-		if (!block[i].sgl)
+		if (!block[i].sgl) {
+			dev_err(dev, "Fail to allocate hw SG buffer!\n");
 			goto err_free_mem;
+		}
 
 		block[i].size = block_size;
 	}
@@ -100,8 +102,10 @@ struct hisi_acc_sgl_pool *hisi_acc_create_sgl_pool(struct device *dev,
 		block[i].sgl = dma_alloc_coherent(dev, remain_sgl * sgl_size,
 						  &block[i].sgl_dma,
 						  GFP_KERNEL);
-		if (!block[i].sgl)
+		if (!block[i].sgl) {
+			dev_err(dev, "Fail to allocate remained hw SG buffer!\n");
 			goto err_free_mem;
+		}
 
 		block[i].size = remain_sgl * sgl_size;
 	}
@@ -216,16 +220,19 @@ hisi_acc_sg_buf_map_to_hw_sgl(struct device *dev,
 	sg_n = sg_nents(sgl);
 
 	sg_n_mapped = dma_map_sg(dev, sgl, sg_n, DMA_BIDIRECTIONAL);
-	if (!sg_n_mapped)
+	if (!sg_n_mapped) {
+		dev_err(dev, "DMA mapping for SG error!\n");
 		return ERR_PTR(-EINVAL);
+	}
 
 	if (sg_n_mapped > pool->sge_nr) {
-		dma_unmap_sg(dev, sgl, sg_n, DMA_BIDIRECTIONAL);
+		dev_err(dev, "the number of entries in input scatterlist is bigger than SGL pool setting.\n");
 		return ERR_PTR(-EINVAL);
 	}
 
 	curr_hw_sgl = acc_get_sgl(pool, index, &curr_sgl_dma);
 	if (IS_ERR(curr_hw_sgl)) {
+		dev_err(dev, "Get SGL error!\n");
 		dma_unmap_sg(dev, sgl, sg_n, DMA_BIDIRECTIONAL);
 		return ERR_PTR(-ENOMEM);
 
-- 
2.8.1

