Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9472010E2;
	Sat, 25 Nov 2023 03:50:12 -0800 (PST)
Received: from kwepemm000009.china.huawei.com (unknown [172.30.72.53])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Scqm32w7WzMnN3;
	Sat, 25 Nov 2023 19:45:23 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm000009.china.huawei.com (7.193.23.227) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sat, 25 Nov 2023 19:50:09 +0800
From: Weili Qian <qianweili@huawei.com>
To: <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<liulongfang@huawei.com>
Subject: [PATCH 1/3] crypto: hisilicon/sgl - small cleanups for sgl.c
Date: Sat, 25 Nov 2023 19:50:09 +0800
Message-ID: <20231125115011.22519-2-qianweili@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20231125115011.22519-1-qianweili@huawei.com>
References: <20231125115011.22519-1-qianweili@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm000009.china.huawei.com (7.193.23.227)
X-CFilter-Loop: Reflected

1. Remove unnecessary brackets in function hisi_acc_create_sgl_pool().
2. Modify local variable type, ensure that the variable type is
consistent with the variable type to be compared.
3. Because the function clear_hw_sgl_sge() is in the task process,
obtain the value of le16_to_cpu(hw_sgl->entry_sum_in_sgl) before
loop execting to shorten the loop execution time.

Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/sgl.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/hisilicon/sgl.c b/drivers/crypto/hisilicon/sgl.c
index 3df7a256e919..4b2cd6736df7 100644
--- a/drivers/crypto/hisilicon/sgl.c
+++ b/drivers/crypto/hisilicon/sgl.c
@@ -121,10 +121,10 @@ struct hisi_acc_sgl_pool *hisi_acc_create_sgl_pool(struct device *dev,
 	return pool;
 
 err_free_mem:
-	for (j = 0; j < i; j++) {
+	for (j = 0; j < i; j++)
 		dma_free_coherent(dev, block_size, block[j].sgl,
 				  block[j].sgl_dma);
-	}
+
 	kfree_sensitive(pool);
 	return ERR_PTR(-ENOMEM);
 }
@@ -140,7 +140,7 @@ EXPORT_SYMBOL_GPL(hisi_acc_create_sgl_pool);
 void hisi_acc_free_sgl_pool(struct device *dev, struct hisi_acc_sgl_pool *pool)
 {
 	struct mem_block *block;
-	int i;
+	u32 i;
 
 	if (!dev || !pool)
 		return;
@@ -196,9 +196,10 @@ static void update_hw_sgl_sum_sge(struct hisi_acc_hw_sgl *hw_sgl, u16 sum)
 static void clear_hw_sgl_sge(struct hisi_acc_hw_sgl *hw_sgl)
 {
 	struct acc_hw_sge *hw_sge = hw_sgl->sge_entries;
+	u16 entry_sum = le16_to_cpu(hw_sgl->entry_sum_in_sgl);
 	int i;
 
-	for (i = 0; i < le16_to_cpu(hw_sgl->entry_sum_in_sgl); i++) {
+	for (i = 0; i < entry_sum; i++) {
 		hw_sge[i].page_ctrl = NULL;
 		hw_sge[i].buf = 0;
 		hw_sge[i].len = 0;
@@ -223,10 +224,11 @@ hisi_acc_sg_buf_map_to_hw_sgl(struct device *dev,
 			      u32 index, dma_addr_t *hw_sgl_dma)
 {
 	struct hisi_acc_hw_sgl *curr_hw_sgl;
+	unsigned int i, sg_n_mapped;
 	dma_addr_t curr_sgl_dma = 0;
 	struct acc_hw_sge *curr_hw_sge;
 	struct scatterlist *sg;
-	int i, sg_n, sg_n_mapped;
+	int sg_n;
 
 	if (!dev || !sgl || !pool || !hw_sgl_dma)
 		return ERR_PTR(-EINVAL);
-- 
2.33.0

