Return-Path: <SRS0=wYoS=XZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DFB1C388F4
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Sep 2019 07:12:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EE07218DE
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Sep 2019 07:12:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729478AbfI3HMX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Sep 2019 03:12:23 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3180 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726008AbfI3HMX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Sep 2019 03:12:23 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 494BD480D7532B268F3E;
        Mon, 30 Sep 2019 15:12:19 +0800 (CST)
Received: from localhost.localdomain (10.67.212.75) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.439.0; Mon, 30 Sep 2019 15:12:11 +0800
From:   Zhou Wang <wangzhou1@hisilicon.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linuxarm@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Shukun Tan <tanshukun1@huawei.com>
Subject: [PATCH 3/4] crypto: hisilicon - fix large sgl memory allocation problem when disable smmu
Date:   Mon, 30 Sep 2019 15:08:54 +0800
Message-ID: <1569827335-21822-4-git-send-email-wangzhou1@hisilicon.com>
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

When disabling SMMU, it may fail to allocate large continuous memory. This
patch fixes this by allocating memory as blocks.

Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
Signed-off-by: Shukun Tan <tanshukun1@huawei.com>
---
 drivers/crypto/hisilicon/sgl.c | 83 ++++++++++++++++++++++++++++++++++--------
 1 file changed, 68 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/hisilicon/sgl.c b/drivers/crypto/hisilicon/sgl.c
index f71de0d..f017361 100644
--- a/drivers/crypto/hisilicon/sgl.c
+++ b/drivers/crypto/hisilicon/sgl.c
@@ -8,6 +8,7 @@
 #define HISI_ACC_SGL_SGE_NR_MIN		1
 #define HISI_ACC_SGL_NR_MAX		256
 #define HISI_ACC_SGL_ALIGN_SIZE		64
+#define HISI_ACC_MEM_BLOCK_NR		5
 
 struct acc_hw_sge {
 	dma_addr_t buf;
@@ -31,9 +32,13 @@ struct hisi_acc_hw_sgl {
 } __aligned(1);
 
 struct hisi_acc_sgl_pool {
-	struct hisi_acc_hw_sgl *sgl;
-	dma_addr_t sgl_dma;
-	size_t size;
+	struct mem_block {
+		struct hisi_acc_hw_sgl *sgl;
+		dma_addr_t sgl_dma;
+		size_t size;
+	} mem_block[HISI_ACC_MEM_BLOCK_NR];
+	u32 sgl_num_per_block;
+	u32 block_num;
 	u32 count;
 	u32 sge_nr;
 	size_t sgl_size;
@@ -51,33 +56,66 @@ struct hisi_acc_sgl_pool {
 struct hisi_acc_sgl_pool *hisi_acc_create_sgl_pool(struct device *dev,
 						   u32 count, u32 sge_nr)
 {
+	u32 sgl_size, block_size, sgl_num_per_block, block_num, remain_sgl = 0;
 	struct hisi_acc_sgl_pool *pool;
-	u32 sgl_size;
-	u32 size;
+	struct mem_block *block;
+	u32 i, j;
 
 	if (!dev || !count || !sge_nr || sge_nr > HISI_ACC_SGL_SGE_NR_MAX)
 		return ERR_PTR(-EINVAL);
 
 	sgl_size = sizeof(struct acc_hw_sge) * sge_nr +
 		   sizeof(struct hisi_acc_hw_sgl);
-	size = sgl_size * count;
+	block_size = PAGE_SIZE * (1 << (MAX_ORDER - 1));
+	sgl_num_per_block = block_size / sgl_size;
+	block_num = count / sgl_num_per_block;
+	remain_sgl = count % sgl_num_per_block;
+
+	if ((!remain_sgl && block_num > HISI_ACC_MEM_BLOCK_NR) ||
+	    (remain_sgl > 0 && block_num > HISI_ACC_MEM_BLOCK_NR - 1))
+		return ERR_PTR(-EINVAL);
 
 	pool = kzalloc(sizeof(*pool), GFP_KERNEL);
 	if (!pool)
 		return ERR_PTR(-ENOMEM);
+	block = pool->mem_block;
 
-	pool->sgl = dma_alloc_coherent(dev, size, &pool->sgl_dma, GFP_KERNEL);
-	if (!pool->sgl) {
-		kfree(pool);
-		return ERR_PTR(-ENOMEM);
+	for (i = 0; i < block_num; i++) {
+		block[i].sgl = dma_alloc_coherent(dev, block_size,
+						  &block[i].sgl_dma,
+						  GFP_KERNEL);
+		if (!block[i].sgl)
+			goto err_free_mem;
+
+		block[i].size = block_size;
 	}
 
-	pool->size = size;
+	if (remain_sgl > 0) {
+		block[i].sgl = dma_alloc_coherent(dev, remain_sgl * sgl_size,
+						  &block[i].sgl_dma,
+						  GFP_KERNEL);
+		if (!block[i].sgl)
+			goto err_free_mem;
+
+		block[i].size = remain_sgl * sgl_size;
+	}
+
+	pool->sgl_num_per_block = sgl_num_per_block;
+	pool->block_num = remain_sgl ? block_num + 1 : block_num;
 	pool->count = count;
 	pool->sgl_size = sgl_size;
 	pool->sge_nr = sge_nr;
 
 	return pool;
+
+err_free_mem:
+	for (j = 0; j < i; j++) {
+		dma_free_coherent(dev, block_size, block[j].sgl,
+				  block[j].sgl_dma);
+		memset(block + j, 0, sizeof(*block));
+	}
+	kfree(pool);
+	return ERR_PTR(-ENOMEM);
 }
 EXPORT_SYMBOL_GPL(hisi_acc_create_sgl_pool);
 
@@ -90,10 +128,18 @@ EXPORT_SYMBOL_GPL(hisi_acc_create_sgl_pool);
  */
 void hisi_acc_free_sgl_pool(struct device *dev, struct hisi_acc_sgl_pool *pool)
 {
+	struct mem_block *block;
+	int i;
+
 	if (!dev || !pool)
 		return;
 
-	dma_free_coherent(dev, pool->size, pool->sgl, pool->sgl_dma);
+	block = pool->mem_block;
+
+	for (i = 0; i < pool->block_num; i++)
+		dma_free_coherent(dev, block[i].size, block[i].sgl,
+				  block[i].sgl_dma);
+
 	kfree(pool);
 }
 EXPORT_SYMBOL_GPL(hisi_acc_free_sgl_pool);
@@ -101,11 +147,18 @@ EXPORT_SYMBOL_GPL(hisi_acc_free_sgl_pool);
 struct hisi_acc_hw_sgl *acc_get_sgl(struct hisi_acc_sgl_pool *pool, u32 index,
 				    dma_addr_t *hw_sgl_dma)
 {
-	if (!pool || !hw_sgl_dma || index >= pool->count || !pool->sgl)
+	struct mem_block *block;
+	u32 block_index, offset;
+
+	if (!pool || !hw_sgl_dma || index >= pool->count)
 		return ERR_PTR(-EINVAL);
 
-	*hw_sgl_dma = pool->sgl_dma + pool->sgl_size * index;
-	return (void *)pool->sgl + pool->sgl_size * index;
+	block = pool->mem_block;
+	block_index = index / pool->sgl_num_per_block;
+	offset = index % pool->sgl_num_per_block;
+
+	*hw_sgl_dma = block[block_index].sgl_dma + pool->sgl_size * offset;
+	return (void *)block[block_index].sgl + pool->sgl_size * offset;
 }
 
 void acc_put_sgl(struct hisi_acc_sgl_pool *pool, u32 index) {}
-- 
2.8.1

