Return-Path: <SRS0=PsuD=V6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B33B7C32750
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Aug 2019 08:17:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C3A020679
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Aug 2019 08:17:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390816AbfHBIQw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Aug 2019 04:16:52 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:49870 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390805AbfHBIQw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Aug 2019 04:16:52 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 683B550D049FEE854F42;
        Fri,  2 Aug 2019 16:16:50 +0800 (CST)
Received: from localhost.localdomain (10.67.212.75) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.439.0; Fri, 2 Aug 2019 16:16:44 +0800
From:   Zhou Wang <wangzhou1@hisilicon.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>
CC:     <linuxarm@huawei.com>, <linux-kernel@vger.kernel.org>,
        Zhou Wang <wangzhou1@hisilicon.com>
Subject: [PATCH v3 2/7] crypto: hisilicon - add hardware SGL support
Date:   Fri, 2 Aug 2019 15:57:51 +0800
Message-ID: <1564732676-35987-3-git-send-email-wangzhou1@hisilicon.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1564732676-35987-1-git-send-email-wangzhou1@hisilicon.com>
References: <1564732676-35987-1-git-send-email-wangzhou1@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.75]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

HiSilicon accelerators in Hip08 use same hardware scatterlist for data format.
We support it in this module.

Specific accelerator drivers can use hisi_acc_create_sgl_pool to allocate
hardware SGLs ahead. Then use hisi_acc_sg_buf_map_to_hw_sgl to get one
hardware SGL and pass related information to hardware SGL.

The DMA address of mapped hardware SGL can be passed to SGL src/dst field
in QM SQE.

Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/crypto/hisilicon/Kconfig  |   8 ++
 drivers/crypto/hisilicon/Makefile |   1 +
 drivers/crypto/hisilicon/sgl.c    | 214 ++++++++++++++++++++++++++++++++++++++
 drivers/crypto/hisilicon/sgl.h    |  24 +++++
 4 files changed, 247 insertions(+)
 create mode 100644 drivers/crypto/hisilicon/sgl.c
 create mode 100644 drivers/crypto/hisilicon/sgl.h

diff --git a/drivers/crypto/hisilicon/Kconfig b/drivers/crypto/hisilicon/Kconfig
index b79be8d..457d9bc 100644
--- a/drivers/crypto/hisilicon/Kconfig
+++ b/drivers/crypto/hisilicon/Kconfig
@@ -19,3 +19,11 @@ config CRYPTO_DEV_HISI_QM
 	help
 	  HiSilicon accelerator engines use a common queue management
 	  interface. Specific engine driver may use this module.
+
+config CRYPTO_HISI_SGL
+	tristate
+	depends on ARM64
+	help
+	  HiSilicon accelerator engines use a common hardware scatterlist
+	  interface for data format. Specific engine driver may use this
+	  module.
diff --git a/drivers/crypto/hisilicon/Makefile b/drivers/crypto/hisilicon/Makefile
index 05e9052..96cb913 100644
--- a/drivers/crypto/hisilicon/Makefile
+++ b/drivers/crypto/hisilicon/Makefile
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_CRYPTO_DEV_HISI_SEC) += sec/
 obj-$(CONFIG_CRYPTO_DEV_HISI_QM) += qm.o
+obj-$(CONFIG_CRYPTO_HISI_SGL) += sgl.o
diff --git a/drivers/crypto/hisilicon/sgl.c b/drivers/crypto/hisilicon/sgl.c
new file mode 100644
index 0000000..8ef7679
--- /dev/null
+++ b/drivers/crypto/hisilicon/sgl.c
@@ -0,0 +1,214 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019 HiSilicon Limited. */
+#include <linux/dma-mapping.h>
+#include <linux/module.h>
+#include "./sgl.h"
+
+#define HISI_ACC_SGL_SGE_NR_MIN		1
+#define HISI_ACC_SGL_SGE_NR_MAX		255
+#define HISI_ACC_SGL_SGE_NR_DEF		10
+#define HISI_ACC_SGL_NR_MAX		256
+#define HISI_ACC_SGL_ALIGN_SIZE		64
+
+static int acc_sgl_sge_set(const char *val, const struct kernel_param *kp)
+{
+	int ret;
+	u32 n;
+
+	if (!val)
+		return -EINVAL;
+
+	ret = kstrtou32(val, 10, &n);
+	if (ret != 0 || n > HISI_ACC_SGL_SGE_NR_MAX || n == 0)
+		return -EINVAL;
+
+	return param_set_int(val, kp);
+}
+
+static const struct kernel_param_ops acc_sgl_sge_ops = {
+	.set = acc_sgl_sge_set,
+	.get = param_get_int,
+};
+
+static u32 acc_sgl_sge_nr = HISI_ACC_SGL_SGE_NR_DEF;
+module_param_cb(acc_sgl_sge_nr, &acc_sgl_sge_ops, &acc_sgl_sge_nr, 0444);
+MODULE_PARM_DESC(acc_sgl_sge_nr, "Number of sge in sgl(1-255)");
+
+struct acc_hw_sge {
+	dma_addr_t buf;
+	void *page_ctrl;
+	__le32 len;
+	__le32 pad;
+	__le32 pad0;
+	__le32 pad1;
+};
+
+/* use default sgl head size 64B */
+struct hisi_acc_hw_sgl {
+	dma_addr_t next_dma;
+	__le16 entry_sum_in_chain;
+	__le16 entry_sum_in_sgl;
+	__le16 entry_length_in_sgl;
+	__le16 pad0;
+	__le64 pad1[5];
+	struct hisi_acc_hw_sgl *next;
+	struct acc_hw_sge sge_entries[];
+} __aligned(1);
+
+/**
+ * hisi_acc_create_sgl_pool() - Create a hw sgl pool.
+ * @dev: The device which hw sgl pool belongs to.
+ * @pool: Pointer of pool.
+ * @count: Count of hisi_acc_hw_sgl in pool.
+ *
+ * This function creates a hw sgl pool, after this user can get hw sgl memory
+ * from it.
+ */
+int hisi_acc_create_sgl_pool(struct device *dev,
+			     struct hisi_acc_sgl_pool *pool, u32 count)
+{
+	u32 sgl_size;
+	u32 size;
+
+	if (!dev || !pool || !count)
+		return -EINVAL;
+
+	sgl_size = sizeof(struct acc_hw_sge) * acc_sgl_sge_nr +
+		   sizeof(struct hisi_acc_hw_sgl);
+	size = sgl_size * count;
+
+	pool->sgl = dma_alloc_coherent(dev, size, &pool->sgl_dma, GFP_KERNEL);
+	if (!pool->sgl)
+		return -ENOMEM;
+
+	pool->size = size;
+	pool->count = count;
+	pool->sgl_size = sgl_size;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(hisi_acc_create_sgl_pool);
+
+/**
+ * hisi_acc_free_sgl_pool() - Free a hw sgl pool.
+ * @dev: The device which hw sgl pool belongs to.
+ * @pool: Pointer of pool.
+ *
+ * This function frees memory of a hw sgl pool.
+ */
+void hisi_acc_free_sgl_pool(struct device *dev, struct hisi_acc_sgl_pool *pool)
+{
+	dma_free_coherent(dev, pool->size, pool->sgl, pool->sgl_dma);
+	memset(pool, 0, sizeof(struct hisi_acc_sgl_pool));
+}
+EXPORT_SYMBOL_GPL(hisi_acc_free_sgl_pool);
+
+struct hisi_acc_hw_sgl *acc_get_sgl(struct hisi_acc_sgl_pool *pool, u32 index,
+				    dma_addr_t *hw_sgl_dma)
+{
+	if (!pool || !hw_sgl_dma || index >= pool->count || !pool->sgl)
+		return ERR_PTR(-EINVAL);
+
+	*hw_sgl_dma = pool->sgl_dma + pool->sgl_size * index;
+	return (void *)pool->sgl + pool->sgl_size * index;
+}
+
+void acc_put_sgl(struct hisi_acc_sgl_pool *pool, u32 index) {}
+
+static void sg_map_to_hw_sg(struct scatterlist *sgl,
+			    struct acc_hw_sge *hw_sge)
+{
+	hw_sge->buf = sgl->dma_address;
+	hw_sge->len = sgl->dma_length;
+}
+
+static void inc_hw_sgl_sge(struct hisi_acc_hw_sgl *hw_sgl)
+{
+	hw_sgl->entry_sum_in_sgl++;
+}
+
+static void update_hw_sgl_sum_sge(struct hisi_acc_hw_sgl *hw_sgl, u16 sum)
+{
+	hw_sgl->entry_sum_in_chain = sum;
+}
+
+/**
+ * hisi_acc_sg_buf_map_to_hw_sgl - Map a scatterlist to a hw sgl.
+ * @dev: The device which hw sgl belongs to.
+ * @sgl: Scatterlist which will be mapped to hw sgl.
+ * @pool: Pool which hw sgl memory will be allocated in.
+ * @index: Index of hisi_acc_hw_sgl in pool.
+ * @hw_sgl_dma: The dma address of allocated hw sgl.
+ *
+ * This function builds hw sgl according input sgl, user can use hw_sgl_dma
+ * as src/dst in its BD. Only support single hw sgl currently.
+ */
+struct hisi_acc_hw_sgl *
+hisi_acc_sg_buf_map_to_hw_sgl(struct device *dev,
+			      struct scatterlist *sgl,
+			      struct hisi_acc_sgl_pool *pool,
+			      u32 index, dma_addr_t *hw_sgl_dma)
+{
+	struct hisi_acc_hw_sgl *curr_hw_sgl;
+	dma_addr_t curr_sgl_dma;
+	struct acc_hw_sge *curr_hw_sge;
+	struct scatterlist *sg;
+	int sg_n = sg_nents(sgl);
+	int i, ret;
+
+	if (!dev || !sgl || !pool || !hw_sgl_dma || sg_n > acc_sgl_sge_nr)
+		return ERR_PTR(-EINVAL);
+
+	ret = dma_map_sg(dev, sgl, sg_n, DMA_BIDIRECTIONAL);
+	if (!ret)
+		return ERR_PTR(-EINVAL);
+
+	curr_hw_sgl = acc_get_sgl(pool, index, &curr_sgl_dma);
+	if (!curr_hw_sgl) {
+		ret = -ENOMEM;
+		goto err_unmap_sg;
+	}
+	curr_hw_sgl->entry_length_in_sgl = acc_sgl_sge_nr;
+	curr_hw_sge = curr_hw_sgl->sge_entries;
+
+	for_each_sg(sgl, sg, sg_n, i) {
+		sg_map_to_hw_sg(sg, curr_hw_sge);
+		inc_hw_sgl_sge(curr_hw_sgl);
+		curr_hw_sge++;
+	}
+
+	update_hw_sgl_sum_sge(curr_hw_sgl, acc_sgl_sge_nr);
+	*hw_sgl_dma = curr_sgl_dma;
+
+	return curr_hw_sgl;
+
+err_unmap_sg:
+	dma_unmap_sg(dev, sgl, sg_n, DMA_BIDIRECTIONAL);
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL_GPL(hisi_acc_sg_buf_map_to_hw_sgl);
+
+/**
+ * hisi_acc_sg_buf_unmap() - Unmap allocated hw sgl.
+ * @dev: The device which hw sgl belongs to.
+ * @sgl: Related scatterlist.
+ * @hw_sgl: Virtual address of hw sgl.
+ * @hw_sgl_dma: DMA address of hw sgl.
+ * @pool: Pool which hw sgl is allocated in.
+ *
+ * This function unmaps allocated hw sgl.
+ */
+void hisi_acc_sg_buf_unmap(struct device *dev, struct scatterlist *sgl,
+			   struct hisi_acc_hw_sgl *hw_sgl)
+{
+	dma_unmap_sg(dev, sgl, sg_nents(sgl), DMA_BIDIRECTIONAL);
+
+	hw_sgl->entry_sum_in_chain = 0;
+	hw_sgl->entry_sum_in_sgl = 0;
+	hw_sgl->entry_length_in_sgl = 0;
+}
+EXPORT_SYMBOL_GPL(hisi_acc_sg_buf_unmap);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Zhou Wang <wangzhou1@hisilicon.com>");
+MODULE_DESCRIPTION("HiSilicon Accelerator SGL support");
diff --git a/drivers/crypto/hisilicon/sgl.h b/drivers/crypto/hisilicon/sgl.h
new file mode 100644
index 0000000..3ac8871
--- /dev/null
+++ b/drivers/crypto/hisilicon/sgl.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2019 HiSilicon Limited. */
+#ifndef HISI_ACC_SGL_H
+#define HISI_ACC_SGL_H
+
+struct hisi_acc_sgl_pool {
+	struct hisi_acc_hw_sgl *sgl;
+	dma_addr_t sgl_dma;
+	size_t size;
+	u32 count;
+	size_t sgl_size;
+};
+
+struct hisi_acc_hw_sgl *
+hisi_acc_sg_buf_map_to_hw_sgl(struct device *dev,
+			      struct scatterlist *sgl,
+			      struct hisi_acc_sgl_pool *pool,
+			      u32 index, dma_addr_t *hw_sgl_dma);
+void hisi_acc_sg_buf_unmap(struct device *dev, struct scatterlist *sgl,
+			   struct hisi_acc_hw_sgl *hw_sgl);
+int hisi_acc_create_sgl_pool(struct device *dev, struct hisi_acc_sgl_pool *pool,
+			     u32 count);
+void hisi_acc_free_sgl_pool(struct device *dev, struct hisi_acc_sgl_pool *pool);
+#endif
-- 
2.8.1

