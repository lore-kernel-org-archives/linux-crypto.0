Return-Path: <SRS0=wYoS=XZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE504C388F3
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Sep 2019 07:12:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FE5721855
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Sep 2019 07:12:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726008AbfI3HMY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Sep 2019 03:12:24 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3177 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726425AbfI3HMX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Sep 2019 03:12:23 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 3C3D66418A98FB30F03A;
        Mon, 30 Sep 2019 15:12:19 +0800 (CST)
Received: from localhost.localdomain (10.67.212.75) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.439.0; Mon, 30 Sep 2019 15:12:12 +0800
From:   Zhou Wang <wangzhou1@hisilicon.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linuxarm@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Shukun Tan <tanshukun1@huawei.com>
Subject: [PATCH 4/4] crypto: hisilicon - misc fix about sgl
Date:   Mon, 30 Sep 2019 15:08:55 +0800
Message-ID: <1569827335-21822-5-git-send-email-wangzhou1@hisilicon.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1569827335-21822-1-git-send-email-wangzhou1@hisilicon.com>
References: <1569827335-21822-1-git-send-email-wangzhou1@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.75]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch fixes some misc problems in sgl codes, e.g. missing static,
sparse error and input parameter check.

Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
Signed-off-by: Shukun Tan <tanshukun1@huawei.com>
---
 drivers/crypto/hisilicon/sgl.c | 40 ++++++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/hisilicon/sgl.c b/drivers/crypto/hisilicon/sgl.c
index f017361..bf72603 100644
--- a/drivers/crypto/hisilicon/sgl.c
+++ b/drivers/crypto/hisilicon/sgl.c
@@ -144,8 +144,8 @@ void hisi_acc_free_sgl_pool(struct device *dev, struct hisi_acc_sgl_pool *pool)
 }
 EXPORT_SYMBOL_GPL(hisi_acc_free_sgl_pool);
 
-struct hisi_acc_hw_sgl *acc_get_sgl(struct hisi_acc_sgl_pool *pool, u32 index,
-				    dma_addr_t *hw_sgl_dma)
+static struct hisi_acc_hw_sgl *acc_get_sgl(struct hisi_acc_sgl_pool *pool,
+					   u32 index, dma_addr_t *hw_sgl_dma)
 {
 	struct mem_block *block;
 	u32 block_index, offset;
@@ -161,23 +161,24 @@ struct hisi_acc_hw_sgl *acc_get_sgl(struct hisi_acc_sgl_pool *pool, u32 index,
 	return (void *)block[block_index].sgl + pool->sgl_size * offset;
 }
 
-void acc_put_sgl(struct hisi_acc_sgl_pool *pool, u32 index) {}
-
 static void sg_map_to_hw_sg(struct scatterlist *sgl,
 			    struct acc_hw_sge *hw_sge)
 {
 	hw_sge->buf = sgl->dma_address;
-	hw_sge->len = sgl->dma_length;
+	hw_sge->len = cpu_to_le32(sgl->dma_length);
 }
 
 static void inc_hw_sgl_sge(struct hisi_acc_hw_sgl *hw_sgl)
 {
-	hw_sgl->entry_sum_in_sgl++;
+	u16 var = le16_to_cpu(hw_sgl->entry_sum_in_sgl);
+
+	var++;
+	hw_sgl->entry_sum_in_sgl = cpu_to_le16(var);
 }
 
 static void update_hw_sgl_sum_sge(struct hisi_acc_hw_sgl *hw_sgl, u16 sum)
 {
-	hw_sgl->entry_sum_in_chain = sum;
+	hw_sgl->entry_sum_in_chain = cpu_to_le16(sum);
 }
 
 /**
@@ -201,10 +202,13 @@ hisi_acc_sg_buf_map_to_hw_sgl(struct device *dev,
 	dma_addr_t curr_sgl_dma = 0;
 	struct acc_hw_sge *curr_hw_sge;
 	struct scatterlist *sg;
-	int sg_n = sg_nents(sgl);
-	int i, ret;
+	int i, ret, sg_n;
 
-	if (!dev || !sgl || !pool || !hw_sgl_dma || sg_n > pool->sge_nr)
+	if (!dev || !sgl || !pool || !hw_sgl_dma)
+		return ERR_PTR(-EINVAL);
+
+	sg_n = sg_nents(sgl);
+	if (sg_n > pool->sge_nr)
 		return ERR_PTR(-EINVAL);
 
 	ret = dma_map_sg(dev, sgl, sg_n, DMA_BIDIRECTIONAL);
@@ -212,11 +216,12 @@ hisi_acc_sg_buf_map_to_hw_sgl(struct device *dev,
 		return ERR_PTR(-EINVAL);
 
 	curr_hw_sgl = acc_get_sgl(pool, index, &curr_sgl_dma);
-	if (!curr_hw_sgl) {
-		ret = -ENOMEM;
-		goto err_unmap_sg;
+	if (IS_ERR(curr_hw_sgl)) {
+		dma_unmap_sg(dev, sgl, sg_n, DMA_BIDIRECTIONAL);
+		return ERR_PTR(-ENOMEM);
+
 	}
-	curr_hw_sgl->entry_length_in_sgl = pool->sge_nr;
+	curr_hw_sgl->entry_length_in_sgl = cpu_to_le16(pool->sge_nr);
 	curr_hw_sge = curr_hw_sgl->sge_entries;
 
 	for_each_sg(sgl, sg, sg_n, i) {
@@ -229,10 +234,6 @@ hisi_acc_sg_buf_map_to_hw_sgl(struct device *dev,
 	*hw_sgl_dma = curr_sgl_dma;
 
 	return curr_hw_sgl;
-
-err_unmap_sg:
-	dma_unmap_sg(dev, sgl, sg_n, DMA_BIDIRECTIONAL);
-	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL_GPL(hisi_acc_sg_buf_map_to_hw_sgl);
 
@@ -249,6 +250,9 @@ EXPORT_SYMBOL_GPL(hisi_acc_sg_buf_map_to_hw_sgl);
 void hisi_acc_sg_buf_unmap(struct device *dev, struct scatterlist *sgl,
 			   struct hisi_acc_hw_sgl *hw_sgl)
 {
+	if (!dev || !sgl || !hw_sgl)
+		return;
+
 	dma_unmap_sg(dev, sgl, sg_nents(sgl), DMA_BIDIRECTIONAL);
 
 	hw_sgl->entry_sum_in_chain = 0;
-- 
2.8.1

