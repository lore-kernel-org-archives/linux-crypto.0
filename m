From: Kenneth Lee <nek.in.cn@gmail.com>
Subject: [RFC PATCH 6/7] crypto: add spimdev support to Hisilicon QM
Date: Wed,  1 Aug 2018 18:22:20 +0800
Message-ID: <20180801102221.5308-7-nek.in.cn@gmail.com>
References: <20180801102221.5308-1-nek.in.cn@gmail.com>
Cc: linuxarm@huawei.com
To: Jonathan Corbet <corbet@lwn.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kenneth Lee <liguozhu@hisilicon.com>,
        Hao Fang <fanghao11@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-accelerators@lists.ozlabs.org,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Sanjay Kumar <sanjay.k.kumar@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180801102221.5308-1-nek.in.cn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Kenneth Lee <liguozhu@hisilicon.com>

The commit add spimdev support to the Hislicon QM driver, any
accelerator that use QM can share its queues to the user space.

Signed-off-by: Kenneth Lee <liguozhu@hisilicon.com>
Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
Signed-off-by: Hao Fang <fanghao11@huawei.com>
Signed-off-by: Zaibo Xu <xuzaibo@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 150 ++++++++++++++++++++++++++++++++++
 drivers/crypto/hisilicon/qm.h |  12 +++
 2 files changed, 162 insertions(+)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index e779bc661500..06da8387dc58 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -667,6 +667,146 @@ int hisi_qp_send(struct hisi_qp *qp, void *msg)
 }
 EXPORT_SYMBOL_GPL(hisi_qp_send);
 
+#ifdef CONFIG_CRYPTO_DEV_HISI_SPIMDEV
+/* mdev->supported_type_groups */
+static struct attribute *hisi_qm_type_attrs[] = {
+	VFIO_SPIMDEV_DEFAULT_MDEV_TYPE_ATTRS,
+	NULL,
+};
+static struct attribute_group hisi_qm_type_group = {
+	.attrs = hisi_qm_type_attrs,
+};
+static struct attribute_group *mdev_type_groups[] = {
+	&hisi_qm_type_group,
+	NULL,
+};
+
+static void qm_qp_event_notifier(struct hisi_qp *qp)
+{
+	vfio_spimdev_wake_up(qp->spimdev_q);
+}
+
+static int hisi_qm_get_queue(struct vfio_spimdev *spimdev, unsigned long arg,
+			  struct vfio_spimdev_queue **q)
+{
+	struct qm_info *qm = spimdev->priv;
+	struct hisi_qp *qp = NULL;
+	struct vfio_spimdev_queue *wd_q;
+	u8 alg_type = 0; /* fix me here */
+	int ret;
+	int pasid = arg;
+
+	qp = hisi_qm_create_qp(qm, alg_type);
+	if (IS_ERR(qp))
+		return PTR_ERR(qp);
+
+	wd_q = kzalloc(sizeof(struct vfio_spimdev_queue), GFP_KERNEL);
+	if (!wd_q) {
+		ret = -ENOMEM;
+		goto err_with_qp;
+	}
+
+	wd_q->priv = qp;
+	wd_q->spimdev = spimdev;
+	wd_q->qid = (u16)ret;
+	*q = wd_q;
+	qp->spimdev_q = wd_q;
+	qp->event_cb = qm_qp_event_notifier;
+
+	ret = hisi_qm_start_qp(qp, arg);
+	if (ret < 0)
+		goto err_with_wd_q;
+
+	return ret;
+
+err_with_wd_q:
+	kfree(wd_q);
+err_with_qp:
+	hisi_qm_release_qp(qp);
+	return ret;
+}
+
+static int hisi_qm_put_queue(struct vfio_spimdev_queue *q)
+{
+	struct hisi_qp *qp = q->priv;
+
+	/* need to stop hardware, but can not support in v1 */
+	hisi_qm_release_qp(qp);
+	kfree(q);
+	return 0;
+}
+
+/* map sq/cq/doorbell to user space */
+static int hisi_qm_mmap(struct vfio_spimdev_queue *q,
+			struct vm_area_struct *vma)
+{
+	struct hisi_qp *qp = (struct hisi_qp *)q->priv;
+	struct qm_info *qm = qp->qm;
+	struct device *dev = &qm->pdev->dev;
+	size_t sz = vma->vm_end - vma->vm_start;
+	u8 region;
+
+	vma->vm_flags |= (VM_IO | VM_LOCKED | VM_DONTEXPAND | VM_DONTDUMP);
+	region = _VFIO_SPIMDEV_REGION(vma->vm_pgoff);
+
+	switch (region) {
+	case 0:
+		if (sz > PAGE_SIZE)
+			return -EINVAL;
+		/*
+		 * Warning: This is not safe as multiple queues use the same
+		 * doorbell, v1 hardware interface problem. v2 will fix it
+		 */
+		return remap_pfn_range(vma, vma->vm_start,
+				       qm->phys_base >> PAGE_SHIFT,
+				       sz, pgprot_noncached(vma->vm_page_prot));
+	case 1:
+		vma->vm_pgoff = 0;
+		if (sz > qp->scqe.size)
+			return -EINVAL;
+
+		return dma_mmap_coherent(dev, vma, qp->scqe.addr, qp->scqe.dma,
+				sz);
+
+	default:
+		return -EINVAL;
+	}
+}
+
+static const struct vfio_spimdev_ops qm_ops = {
+	.get_queue = hisi_qm_get_queue,
+	.put_queue = hisi_qm_put_queue,
+	.mmap = hisi_qm_mmap,
+};
+
+static int qm_register_spimdev(struct qm_info *qm)
+{
+	struct pci_dev *pdev = qm->pdev;
+	struct vfio_spimdev *spimdev = &qm->spimdev;
+
+	spimdev->iommu_type = VFIO_TYPE1_IOMMU;
+#ifdef CONFIG_IOMMU_SVA
+	spimdev->dma_flag = VFIO_SPIMDEV_DMA_MULTI_PROC_MAP;
+#else
+	spimdev->dma_flag = VFIO_SPIMDEV_DMA_SINGLE_PROC_MAP;
+#endif
+	spimdev->owner = THIS_MODULE;
+	spimdev->name = qm->dev_name;
+	spimdev->dev = &pdev->dev;
+	spimdev->is_vf = pdev->is_virtfn;
+	spimdev->priv = qm;
+	spimdev->api_ver = "hisi_qm_v1";
+	spimdev->flags = 0;
+
+	spimdev->mdev_fops.mdev_attr_groups = qm->mdev_dev_groups;
+	hisi_qm_type_group.name = qm->dev_name;
+	spimdev->mdev_fops.supported_type_groups = mdev_type_groups;
+	spimdev->ops = &qm_ops;
+
+	return vfio_spimdev_register(spimdev);
+}
+#endif
+
 int hisi_qm_init(const char *dev_name, struct qm_info *qm)
 {
 	int ret;
@@ -804,6 +944,12 @@ int hisi_qm_start(struct qm_info *qm)
 	if (ret)
 		goto err_with_cqc;
 
+#ifdef CONFIG_CRYPTO_DEV_HISI_SPIMDEV
+	ret = qm_register_spimdev(qm);
+	if (ret)
+		goto err_with_irq;
+#endif
+
 	writel(0x0, QM_ADDR(qm, QM_VF_EQ_INT_MASK));
 
 	return 0;
@@ -830,6 +976,10 @@ void hisi_qm_stop(struct qm_info *qm)
 	struct pci_dev *pdev = qm->pdev;
 	struct device *dev = &pdev->dev;
 
+#ifdef CONFIG_CRYPTO_DEV_HISI_SPIMDEV
+	vfio_spimdev_unregister(&qm->spimdev);
+#endif
+
 	free_irq(pci_irq_vector(pdev, 0), qm);
 	qm_uninit_q_buffer(dev, &qm->cqc);
 	kfree(qm->qp_array);
diff --git a/drivers/crypto/hisilicon/qm.h b/drivers/crypto/hisilicon/qm.h
index b3c5c34a0d13..f73c08098b82 100644
--- a/drivers/crypto/hisilicon/qm.h
+++ b/drivers/crypto/hisilicon/qm.h
@@ -8,6 +8,10 @@
 #include <linux/pci.h>
 #include <linux/slab.h>
 
+#ifdef CONFIG_CRYPTO_DEV_HISI_SPIMDEV
+#include <linux/vfio_spimdev.h>
+#endif
+
 #define QM_CQE_SIZE			16
 /* default queue depth for sq/cq/eq */
 #define QM_Q_DEPTH			1024
@@ -59,6 +63,10 @@ struct qm_info {
 
 	struct hisi_acc_qm_hw_ops *ops;
 
+#ifdef CONFIG_CRYPTO_DEV_HISI_SPIMDEV
+	struct vfio_spimdev spimdev;
+	const struct attribute_group **mdev_dev_groups;
+#endif
 };
 #define QM_ADDR(qm, off) ((qm)->io_base + off)
 
@@ -90,6 +98,10 @@ struct hisi_qp {
 
 	struct qm_info *qm;
 
+#ifdef CONFIG_CRYPTO_DEV_HISI_SPIMDEV
+	struct vfio_spimdev_queue *spimdev_q;
+#endif
+
 	/* for crypto sync API */
 	struct completion completion;
 
-- 
2.17.1
