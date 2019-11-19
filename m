Return-Path: <SRS0=Veu2=ZL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04145C43141
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 06:00:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9F5021939
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 06:00:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbfKSGAG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Nov 2019 01:00:06 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:54742 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730030AbfKSFqa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Nov 2019 00:46:30 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 9AFCD65D2B03D8D3F7A3;
        Tue, 19 Nov 2019 13:46:29 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.439.0; Tue, 19 Nov 2019 13:46:23 +0800
From:   Zhou Wang <wangzhou1@hisilicon.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linuxarm@huawei.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>
Subject: [PATCH 1/3] crypto: hisilicon - Fix issue with wrong number of sg elements after dma map
Date:   Tue, 19 Nov 2019 13:42:56 +0800
Message-ID: <1574142178-76514-2-git-send-email-wangzhou1@hisilicon.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1574142178-76514-1-git-send-email-wangzhou1@hisilicon.com>
References: <1574142178-76514-1-git-send-email-wangzhou1@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

We fill the hardware scatter gather list assuming it will need the same
number of elements at the original scatterlist. If an IOMMU is involved,
then it may well need fewer. The return value of dma_map_sg tells us how
many.

Probably never caused visible problems as the hardware won't get to
the elements that are incorrect before it finds enough space.

Fixes: dfed0098ab91 (crypto: hisilicon - add hardware SGL support)
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/crypto/hisilicon/sgl.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/hisilicon/sgl.c b/drivers/crypto/hisilicon/sgl.c
index 012023c..1e153a0 100644
--- a/drivers/crypto/hisilicon/sgl.c
+++ b/drivers/crypto/hisilicon/sgl.c
@@ -202,18 +202,21 @@ hisi_acc_sg_buf_map_to_hw_sgl(struct device *dev,
 	dma_addr_t curr_sgl_dma = 0;
 	struct acc_hw_sge *curr_hw_sge;
 	struct scatterlist *sg;
-	int i, ret, sg_n;
+	int i, sg_n, sg_n_mapped;
 
 	if (!dev || !sgl || !pool || !hw_sgl_dma)
 		return ERR_PTR(-EINVAL);
 
 	sg_n = sg_nents(sgl);
-	if (sg_n > pool->sge_nr)
+
+	sg_n_mapped = dma_map_sg(dev, sgl, sg_n, DMA_BIDIRECTIONAL);
+	if (!sg_n_mapped)
 		return ERR_PTR(-EINVAL);
 
-	ret = dma_map_sg(dev, sgl, sg_n, DMA_BIDIRECTIONAL);
-	if (!ret)
+	if (sg_n_mapped > pool->sge_nr) {
+		dma_unmap_sg(dev, sgl, sg_n, DMA_BIDIRECTIONAL);
 		return ERR_PTR(-EINVAL);
+	}
 
 	curr_hw_sgl = acc_get_sgl(pool, index, &curr_sgl_dma);
 	if (IS_ERR(curr_hw_sgl)) {
@@ -224,7 +227,7 @@ hisi_acc_sg_buf_map_to_hw_sgl(struct device *dev,
 	curr_hw_sgl->entry_length_in_sgl = cpu_to_le16(pool->sge_nr);
 	curr_hw_sge = curr_hw_sgl->sge_entries;
 
-	for_each_sg(sgl, sg, sg_n, i) {
+	for_each_sg(sgl, sg, sg_n_mapped, i) {
 		sg_map_to_hw_sg(sg, curr_hw_sge);
 		inc_hw_sgl_sge(curr_hw_sgl);
 		curr_hw_sge++;
-- 
2.8.1

