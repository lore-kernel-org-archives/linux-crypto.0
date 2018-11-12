Return-Path: <SRS0=oFif=NX=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42355 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728196AbeKLRw5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Nov 2018 12:52:57 -0500
From: Kenneth Lee <nek.in.cn@gmail.com>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Tim Sell <timothy.sell@unisys.com>,
        Sanyog Kale <sanyog.r.kale@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?=
        <u.kleine-koenig@pengutronix.de>, Vinod Koul <vkoul@kernel.org>,
        David Kershner <david.kershner@unisys.com>,
        Sagar Dharia <sdharia@codeaurora.org>,
        Gavin Schenk <g.schenk@eckelmann.de>,
        Jens Axboe <axboe@kernel.dk>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Cyrille Pitchen <cyrille.pitchen@free-electrons.com>,
        Johan Hovold <johan@kernel.org>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Hao Fang <fanghao11@huawei.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Zaibo Xu <xuzaibo@huawei.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-accelerators@lists.ozlabs.org
Cc: linuxarm@huawei.com, guodong.xu@linaro.org,
        zhangfei.gao@foxmail.com, haojian.zhuang@linaro.org,
        Kenneth Lee <liguozhu@hisilicon.com>
Subject: [RFCv3 PATCH 5/6] crypto: add uacce support to Hisilicon qm
Date: Mon, 12 Nov 2018 15:58:06 +0800
Message-Id: <20181112075807.9291-6-nek.in.cn@gmail.com>
In-Reply-To: <20181112075807.9291-1-nek.in.cn@gmail.com>
References: <20181112075807.9291-1-nek.in.cn@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Kenneth Lee <liguozhu@hisilicon.com>

This patch add uacce support to the Hislicon QM driver, any accelerator
that use QM can share its queues to the user space.

Signed-off-by: Kenneth Lee <liguozhu@hisilicon.com>
Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
Signed-off-by: Hao Fang <fanghao11@huawei.com>
Signed-off-by: Zaibo Xu <xuzaibo@huawei.com>
---
 drivers/crypto/hisilicon/Kconfig        |   7 +
 drivers/crypto/hisilicon/qm.c           | 227 +++++++++++++++++++++---
 drivers/crypto/hisilicon/qm.h           |  16 +-
 drivers/crypto/hisilicon/zip/zip_main.c |  27 ++-
 4 files changed, 249 insertions(+), 28 deletions(-)

diff --git a/drivers/crypto/hisilicon/Kconfig b/drivers/crypto/hisilicon/Kconfig
index ce9deefbf037..819e4995f361 100644
--- a/drivers/crypto/hisilicon/Kconfig
+++ b/drivers/crypto/hisilicon/Kconfig
@@ -16,6 +16,13 @@ config CRYPTO_DEV_HISI_QM
 	tristate
 	depends on ARM64 && PCI
 
+config CRYPTO_QM_UACCE
+	bool "enable UACCE support for all acceleartor with Hisi QM"
+	depends on CRYPTO_DEV_HISI_QM
+	select UACCE
+	help
+	  Support UACCE interface in Hisi QM.
+
 config CRYPTO_DEV_HISI_ZIP
 	tristate "Support for HISI ZIP Driver"
 	depends on ARM64
diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 5b810a6f4dd5..750d8c069d92 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -5,6 +5,7 @@
 #include <linux/io.h>
 #include <linux/irqreturn.h>
 #include <linux/log2.h>
+#include <linux/uacce.h>
 #include "qm.h"
 
 #define QM_DEF_Q_NUM			128
@@ -435,17 +436,29 @@ int hisi_qm_start_qp(struct hisi_qp *qp, unsigned long arg)
 	qp->sqc_dma = qm->sqc_dma + qp_index * sizeof(struct sqc);
 	qp->cqc_dma = qm->cqc_dma + qp_index * sizeof(struct cqc);
 
-	qp->qdma.size = qm->sqe_size * QM_Q_DEPTH +
-			sizeof(struct cqe) * QM_Q_DEPTH,
-	qp->qdma.va = dma_alloc_coherent(dev, qp->qdma.size,
-					 &qp->qdma.dma,
-					 GFP_KERNEL | __GFP_ZERO);
-	dev_dbg(dev, "allocate qp dma buf(va=%p, dma=%pad, size=%lx)\n",
-		qp->qdma.va, &qp->qdma.dma, qp->qdma.size);
+	if (qm->uacce_mode) {
+		dev_dbg(dev, "User shared DMA Buffer used: (%lx/%x)\n",
+			off, QM_DUS_PAGE_NR << PAGE_SHIFT);
+		if (off > (QM_DUS_PAGE_NR << PAGE_SHIFT))
+			return -EINVAL;
+	} else {
+
+		/*
+		 * todo: we are using dma api here. it should be updated to
+		 * uacce api for user and kernel mode working at the same time
+		 */
+		qp->qdma.size = qm->sqe_size * QM_Q_DEPTH +
+				sizeof(struct cqe) * QM_Q_DEPTH,
+		qp->qdma.va = dma_alloc_coherent(dev, qp->qdma.size,
+						 &qp->qdma.dma,
+						 GFP_KERNEL | __GFP_ZERO);
+		dev_dbg(dev, "allocate qp dma buf(va=%p, dma=%pad, size=%lx)\n",
+			qp->qdma.va, &qp->qdma.dma, qp->qdma.size);
+	}
 
 	if (!qp->qdma.va) {
 		dev_err(dev, "cannot get qm dma buffer\n");
-		return -ENOMEM;
+		return qm->uacce_mode ? -EINVAL : -ENOMEM;
 	}
 
 	QP_INIT_BUF(qp, sqe, qm->sqe_size * QM_Q_DEPTH);
@@ -491,7 +504,8 @@ void hisi_qm_release_qp(struct hisi_qp *qp)
 	bitmap_clear(qm->qp_bitmap, qid, 1);
 	write_unlock(&qm->qps_lock);
 
-	dma_free_coherent(dev, qdma->size, qdma->va, qdma->dma);
+	if (!qm->uacce_mode)
+		dma_free_coherent(dev, qdma->size, qdma->va, qdma->dma);
 
 	kfree(qp);
 }
@@ -535,6 +549,149 @@ int hisi_qp_send(struct hisi_qp *qp, void *msg)
 }
 EXPORT_SYMBOL_GPL(hisi_qp_send);
 
+#ifdef CONFIG_CRYPTO_QM_UACCE
+static void qm_qp_event_notifier(struct hisi_qp *qp)
+{
+	uacce_wake_up(qp->uacce_q);
+}
+
+static int hisi_qm_get_queue(struct uacce *uacce, unsigned long arg,
+			     struct uacce_queue **q)
+{
+	struct qm_info *qm = uacce->priv;
+	struct hisi_qp *qp = NULL;
+	struct uacce_queue *wd_q;
+	u8 alg_type = 0; /* fix me here */
+	int ret;
+
+	qp = hisi_qm_create_qp(qm, alg_type);
+	if (IS_ERR(qp))
+		return PTR_ERR(qp);
+
+	wd_q = kzalloc(sizeof(struct uacce_queue), GFP_KERNEL);
+	if (!wd_q) {
+		ret = -ENOMEM;
+		goto err_with_qp;
+	}
+
+	wd_q->priv = qp;
+	wd_q->uacce = uacce;
+	*q = wd_q;
+	qp->uacce_q = wd_q;
+	qp->event_cb = qm_qp_event_notifier;
+	qp->pasid = arg;
+
+	return 0;
+
+err_with_qp:
+	hisi_qm_release_qp(qp);
+	return ret;
+}
+
+static void hisi_qm_put_queue(struct uacce_queue *q)
+{
+	struct hisi_qp *qp = q->priv;
+
+	/* need to stop hardware, but can not support in v1 */
+	hisi_qm_release_qp(qp);
+	kfree(q);
+}
+
+/* map sq/cq/doorbell to user space */
+static int hisi_qm_mmap(struct uacce_queue *q,
+			struct vm_area_struct *vma)
+{
+	struct hisi_qp *qp = (struct hisi_qp *)q->priv;
+	struct qm_info *qm = qp->qm;
+	size_t sz = vma->vm_end - vma->vm_start;
+	u8 region;
+
+	region = vma->vm_pgoff;
+
+	switch (region) {
+	case 0:
+		if (sz > PAGE_SIZE)
+			return -EINVAL;
+
+		vma->vm_flags |= VM_IO;
+		/*
+		 * Warning: This is not safe as multiple queues use the same
+		 * doorbell, v1 hardware interface problem. will fix it in v2
+		 */
+		return remap_pfn_range(vma, vma->vm_start,
+				       qm->phys_base >> PAGE_SHIFT,
+				       sz, pgprot_noncached(vma->vm_page_prot));
+
+	default:
+		return -EINVAL;
+	}
+}
+
+static int hisi_qm_start_queue(struct uacce_queue *q)
+{
+	int ret;
+	struct qm_info *qm = q->uacce->priv;
+	struct hisi_qp *qp = (struct hisi_qp *)q->priv;
+
+	/* todo: we don't need to start qm here in SVA version */
+	qm->qdma.dma = q->qfrs[UACCE_QFRT_DKO]->iova;
+	qm->qdma.va = q->qfrs[UACCE_QFRT_DKO]->kaddr;
+
+	ret = hisi_qm_start(qm);
+	if (ret)
+		return ret;
+
+	qp->qdma.dma = q->qfrs[UACCE_QFRT_DUS]->iova;
+	qp->qdma.va = q->qfrs[UACCE_QFRT_DUS]->kaddr;
+	ret = hisi_qm_start_qp(qp, qp->pasid);
+	if (ret)
+		hisi_qm_stop(qm);
+
+	return 0;
+}
+
+static void hisi_qm_stop_queue(struct uacce_queue *q)
+{
+	struct qm_info *qm = q->uacce->priv;
+
+	/* todo: we don't need to stop qm in SVA version */
+	hisi_qm_stop(qm);
+}
+
+/*
+ * the device is set the UACCE_DEV_SVA, but it will be cut if SVA patch is not
+ * available
+ */
+static struct uacce_ops uacce_qm_ops = {
+	.owner = THIS_MODULE,
+	.flags = UACCE_DEV_SVA | UACCE_DEV_KMAP_DUS,
+	.api_ver = "hisi_qm_v1",
+	.qf_pg_start = {QM_DOORBELL_PAGE_NR,
+			QM_DOORBELL_PAGE_NR + QM_DKO_PAGE_NR,
+			QM_DOORBELL_PAGE_NR + QM_DKO_PAGE_NR + QM_DUS_PAGE_NR},
+
+	.get_queue = hisi_qm_get_queue,
+	.put_queue = hisi_qm_put_queue,
+	.start_queue = hisi_qm_start_queue,
+	.stop_queue = hisi_qm_stop_queue,
+	.mmap = hisi_qm_mmap,
+};
+
+static int qm_register_uacce(struct qm_info *qm)
+{
+	struct pci_dev *pdev = qm->pdev;
+	struct uacce *uacce = &qm->uacce;
+
+	uacce->name = dev_name(&pdev->dev);
+	uacce->dev = &pdev->dev;
+	uacce->is_vf = pdev->is_virtfn;
+	uacce->priv = qm;
+	uacce->ops = &uacce_qm_ops;
+
+	return uacce_register(uacce);
+}
+#endif
+
 static irqreturn_t qm_irq(int irq, void *data)
 {
 	struct qm_info *qm = data;
@@ -635,21 +792,34 @@ int hisi_qm_init(struct qm_info *qm)
 		}
 	}
 
-	qm->qdma.size = max_t(size_t, sizeof(struct eqc),
-			      sizeof(struct aeqc)) +
-			sizeof(struct eqe) * QM_Q_DEPTH +
-			sizeof(struct sqc) * qm->qp_num +
-			sizeof(struct cqc) * qm->qp_num;
-	qm->qdma.va = dma_alloc_coherent(dev, qm->qdma.size,
-					 &qm->qdma.dma,
-					 GFP_KERNEL | __GFP_ZERO);
-	dev_dbg(dev, "allocate qm dma buf(va=%p, dma=%pad, size=%lx)\n",
-		qm->qdma.va, &qm->qdma.dma, qm->qdma.size);
-	ret = qm->qdma.va ? 0 : -ENOMEM;
+	if (qm->uacce_mode) {
+#ifdef CONFIG_CRYPTO_QM_UACCE
+		ret = qm_register_uacce(qm);
+#else
+		dev_err(dev, "qm uacce feature is not enabled\n");
+		ret = -EINVAL;
+#endif
+
+	} else {
+		qm->qdma.size = max_t(size_t, sizeof(struct eqc),
+				      sizeof(struct aeqc)) +
+				sizeof(struct eqe) * QM_Q_DEPTH +
+				sizeof(struct sqc) * qm->qp_num +
+				sizeof(struct cqc) * qm->qp_num;
+		qm->qdma.va = dma_alloc_coherent(dev, qm->qdma.size,
+						 &qm->qdma.dma,
+						 GFP_KERNEL | __GFP_ZERO);
+		dev_dbg(dev, "allocate qm dma buf(va=%p, dma=%pad, size=%lx)\n",
+			qm->qdma.va, &qm->qdma.dma, qm->qdma.size);
+		ret = qm->qdma.va ? 0 : -ENOMEM;
+	}
 
 	if (ret)
 		goto err_with_irq;
 
+	dev_dbg(dev, "init qm %s to %s mode\n", pdev->is_physfn ? "pf" : "vf",
+		qm->uacce_mode ? "uacce" : "crypto");
+
 	return 0;
 
 err_with_irq:
@@ -669,7 +839,13 @@ void hisi_qm_uninit(struct qm_info *qm)
 {
 	struct pci_dev *pdev = qm->pdev;
 
-	dma_free_coherent(&pdev->dev, qm->qdma.size, qm->qdma.va, qm->qdma.dma);
+	if (qm->uacce_mode) {
+#ifdef CONFIG_CRYPTO_QM_UACCE
+		uacce_unregister(&qm->uacce);
+#endif
+	} else
+		dma_free_coherent(&pdev->dev, qm->qdma.size, qm->qdma.va,
+				  qm->qdma.dma);
 
 	devm_free_irq(&pdev->dev, pci_irq_vector(pdev, 0), qm);
 	pci_free_irq_vectors(pdev);
@@ -690,7 +866,7 @@ int hisi_qm_start(struct qm_info *qm)
 } while (0)
 
 	if (!qm->qdma.va)
-		return -EINVAL;
+		return qm->uacce_mode ? 0 : -EINVAL;
 
 	if (qm->pdev->is_physfn)
 		qm->ops->vft_config(qm, qm->qp_base, qm->qp_num);
@@ -705,6 +881,13 @@ int hisi_qm_start(struct qm_info *qm)
 	QM_INIT_BUF(qm, eqc,
 		    max_t(size_t, sizeof(struct eqc), sizeof(struct aeqc)));
 
+	if (qm->uacce_mode) {
+		dev_dbg(&qm->pdev->dev, "kernel-only buffer used (0x%lx/0x%x)\n",
+			off, QM_DKO_PAGE_NR << PAGE_SHIFT);
+		if (off > (QM_DKO_PAGE_NR << PAGE_SHIFT))
+			return -EINVAL;
+	}
+
 	qm->eqc->base_l = lower_32_bits(qm->eqe_dma);
 	qm->eqc->base_h = upper_32_bits(qm->eqe_dma);
 	qm->eqc->dw3 = 2 << MB_EQC_EQE_SHIFT;
diff --git a/drivers/crypto/hisilicon/qm.h b/drivers/crypto/hisilicon/qm.h
index 6d124d948738..81b0b8c1f0b0 100644
--- a/drivers/crypto/hisilicon/qm.h
+++ b/drivers/crypto/hisilicon/qm.h
@@ -9,6 +9,10 @@
 #include <linux/slab.h>
 #include "qm_usr_if.h"
 
+#ifdef CONFIG_CRYPTO_QM_UACCE
+#include <linux/uacce.h>
+#endif
+
 /* qm user domain */
 #define QM_ARUSER_M_CFG_1		0x100088
 #define QM_ARUSER_M_CFG_ENABLE		0x100090
@@ -146,6 +150,12 @@ struct qm_info {
 	struct mutex mailbox_lock;
 
 	struct hisi_acc_qm_hw_ops *ops;
+
+	bool uacce_mode;
+
+#ifdef CONFIG_CRYPTO_QM_UACCE
+	struct uacce uacce;
+#endif
 };
 #define QM_ADDR(qm, off) ((qm)->io_base + off)
 
@@ -186,6 +196,10 @@ struct hisi_qp {
 
 	struct qm_info *qm;
 
+#ifdef CONFIG_CRYPTO_QM_UACCE
+	struct uacce_queue *uacce_q;
+#endif
+
 	/* for crypto sync API */
 	struct completion completion;
 
@@ -197,7 +211,7 @@ struct hisi_qp {
 
 /* QM external interface for accelerator driver.
  * To use qm:
- * 1. Set qm with pdev, and sqe_size set accordingly
+ * 1. Set qm with pdev, uacce_mode, and sqe_size set accordingly
  * 2. hisi_qm_init()
  * 3. config the accelerator hardware
  * 4. hisi_qm_start()
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index f4f3b6d89340..f5fcd0f4b836 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -5,6 +5,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/uacce.h>
 #include "zip.h"
 #include "zip_crypto.h"
 
@@ -28,6 +29,9 @@
 LIST_HEAD(hisi_zip_list);
 DEFINE_MUTEX(hisi_zip_list_lock);
 
+static bool uacce_mode;
+module_param(uacce_mode, bool, 0);
+
 static const char hisi_zip_name[] = "hisi_zip";
 
 static const struct pci_device_id hisi_zip_dev_ids[] = {
@@ -96,6 +100,7 @@ static int hisi_zip_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	qm = &hisi_zip->qm;
 	qm->pdev = pdev;
+	qm->uacce_mode = uacce_mode;
 	qm->qp_base = HZIP_PF_DEF_Q_BASE;
 	qm->qp_num = HZIP_PF_DEF_Q_NUM;
 	qm->sqe_size = HZIP_SQE_SIZE;
@@ -150,10 +155,21 @@ static int __init hisi_zip_init(void)
 		return ret;
 	}
 
-	ret = hisi_zip_register_to_crypto();
-	if (ret < 0) {
-		pci_unregister_driver(&hisi_zip_pci_driver);
-		return ret;
+	/* todo:
+	 *
+	 * Before JPB's SVA patch is enabled, SMMU/IOMMU cannot support PASID.
+	 * When it is accepted in the mainline kernel, we can add a
+	 * IOMMU_DOMAIN_DAUL mode to IOMMU, then the dma and iommu API can
+	 * work together. We then can let crypto and uacce mode works at the
+	 * same time.
+	 */
+	if (!uacce_mode) {
+		pr_debug("hisi_zip: init crypto mode\n");
+		ret = hisi_zip_register_to_crypto();
+		if (ret < 0) {
+			pci_unregister_driver(&hisi_zip_pci_driver);
+			return ret;
+		}
 	}
 
 	return 0;
@@ -161,7 +177,8 @@ static int __init hisi_zip_init(void)
 
 static void __exit hisi_zip_exit(void)
 {
-	hisi_zip_unregister_from_crypto();
+	if (!uacce_mode)
+		hisi_zip_unregister_from_crypto();
 	pci_unregister_driver(&hisi_zip_pci_driver);
 }
 
-- 
2.17.1
