From: Kenneth Lee <nek.in.cn@gmail.com>
Subject: [PATCH 6/7] crypto: add sdmdev support to Hisilicon QM
Date: Mon,  3 Sep 2018 08:52:03 +0800
Message-ID: <20180903005204.26041-7-nek.in.cn@gmail.com>
References: <20180903005204.26041-1-nek.in.cn@gmail.com>
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
In-Reply-To: <20180903005204.26041-1-nek.in.cn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Kenneth Lee <liguozhu@hisilicon.com>

This commit add spimdev support to the Hislicon QM driver, any
accelerator that use QM can expose its queues to the user space.

Signed-off-by: Kenneth Lee <liguozhu@hisilicon.com>
Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
Signed-off-by: Hao Fang <fanghao11@huawei.com>
Signed-off-by: Zaibo Xu <xuzaibo@huawei.com>
---
 drivers/crypto/hisilicon/Kconfig |  10 ++
 drivers/crypto/hisilicon/qm.c    | 159 +++++++++++++++++++++++++++++++
 drivers/crypto/hisilicon/qm.h    |  12 +++
 3 files changed, 181 insertions(+)

diff --git a/drivers/crypto/hisilicon/Kconfig b/drivers/crypto/hisilicon/Kconfig
index 1d155708cd69..b85fab48fdab 100644
--- a/drivers/crypto/hisilicon/Kconfig
+++ b/drivers/crypto/hisilicon/Kconfig
@@ -17,6 +17,16 @@ config CRYPTO_DEV_HISI_SEC
 	  To compile this as a module, choose M here: the module
 	  will be called hisi_sec.
 
+config CRYPTO_DEV_HISI_SDMDEV
+	bool "Enable SDMDEV interface"
+	depends on CRYPTO_DEV_HISILICON
+	select VFIO_SDMDEV
+	help
+	  Enable this enable the SDMDEV, "shared IOMMU Domain Mediated Device"
+	  interface for all Hisilicon accelerators if they can. The SDMDEV
+	  enable the WarpDrive user space accelerator driver to access the
+	  hardware function directly.
+
 config CRYPTO_DEV_HISI_QM
 	tristate
 	depends on ARM64 && PCI
diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index ea618b4d0929..c94e138e9b99 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -639,6 +639,155 @@ int hisi_qp_send(struct hisi_qp *qp, void *msg)
 }
 EXPORT_SYMBOL_GPL(hisi_qp_send);
 
+#ifdef CONFIG_CRYPTO_DEV_HISI_SDMDEV
+/* mdev->supported_type_groups */
+static struct attribute *hisi_qm_type_attrs[] = {
+	VFIO_SDMDEV_DEFAULT_MDEV_TYPE_ATTRS,
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
+	vfio_sdmdev_wake_up(qp->sdmdev_q);
+}
+
+static int hisi_qm_get_queue(struct vfio_sdmdev *sdmdev,
+			  struct vfio_sdmdev_queue **q)
+{
+	struct qm_info *qm = sdmdev->priv;
+	struct hisi_qp *qp = NULL;
+	struct vfio_sdmdev_queue *wd_q;
+	u8 alg_type = 0; /* fix me here */
+	int ret;
+
+	qp = hisi_qm_create_qp(qm, alg_type);
+	if (IS_ERR(qp))
+		return PTR_ERR(qp);
+
+	wd_q = kzalloc(sizeof(struct vfio_sdmdev_queue), GFP_KERNEL);
+	if (!wd_q) {
+		ret = -ENOMEM;
+		goto err_with_qp;
+	}
+
+	wd_q->priv = qp;
+	wd_q->sdmdev = sdmdev;
+	*q = wd_q;
+	qp->sdmdev_q = wd_q;
+	qp->event_cb = qm_qp_event_notifier;
+
+	return 0;
+
+err_with_qp:
+	hisi_qm_release_qp(qp);
+	return ret;
+}
+
+void hisi_qm_put_queue(struct vfio_sdmdev_queue *q)
+{
+	struct hisi_qp *qp = q->priv;
+
+	hisi_qm_release_qp(qp);
+	kfree(q);
+}
+
+/* map sq/cq/doorbell to user space */
+static int hisi_qm_mmap(struct vfio_sdmdev_queue *q,
+			struct vm_area_struct *vma)
+{
+	struct hisi_qp *qp = (struct hisi_qp *)q->priv;
+	struct qm_info *qm = qp->qm;
+	struct device *dev = &qm->pdev->dev;
+	size_t sz = vma->vm_end - vma->vm_start;
+	u8 region;
+
+	vma->vm_flags |= (VM_IO | VM_LOCKED | VM_DONTEXPAND | VM_DONTDUMP);
+	region = _VFIO_SDMDEV_REGION(vma->vm_pgoff);
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
+static int hisi_qm_start_queue(struct vfio_sdmdev_queue *q)
+{
+	struct hisi_qp *qp = q->priv;
+
+#ifdef CONFIG_IOMMU_SVA
+	return hisi_qm_start_qp(qp, q->pasid);
+#else
+	return hisi_qm_start_qp(qp, 0);
+#endif
+}
+
+static void hisi_qm_stop_queue(struct vfio_sdmdev_queue *q)
+{
+	/* need to stop hardware, but can not support in v1 */
+}
+
+static const struct vfio_sdmdev_ops qm_ops = {
+	.get_queue = hisi_qm_get_queue,
+	.put_queue = hisi_qm_put_queue,
+	.start_queue = hisi_qm_start_queue,
+	.stop_queue = hisi_qm_stop_queue,
+	.mmap = hisi_qm_mmap,
+};
+
+static int qm_register_sdmdev(struct qm_info *qm)
+{
+	struct pci_dev *pdev = qm->pdev;
+	struct vfio_sdmdev *sdmdev = &qm->sdmdev;
+
+	sdmdev->iommu_type = VFIO_TYPE1_IOMMU;
+
+#ifdef CONFIG_IOMMU_SVA
+	sdmdev->dma_flag = VFIO_SDMDEV_DMA_MULTI_PROC_MAP;
+#else
+	sdmdev->dma_flag = VFIO_SDMDEV_DMA_SINGLE_PROC_MAP;
+#endif
+
+	sdmdev->name = qm->dev_name;
+	sdmdev->dev = &pdev->dev;
+	sdmdev->is_vf = pdev->is_virtfn;
+	sdmdev->priv = qm;
+	sdmdev->api_ver = "hisi_qm_v1";
+	sdmdev->flags = 0;
+
+	sdmdev->mdev_fops.mdev_attr_groups = qm->mdev_dev_groups;
+	hisi_qm_type_group.name = qm->dev_name;
+	sdmdev->mdev_fops.supported_type_groups = mdev_type_groups;
+	sdmdev->ops = &qm_ops;
+
+	return vfio_sdmdev_register(sdmdev);
+}
+#endif
+
 int hisi_qm_init(const char *dev_name, struct qm_info *qm)
 {
 	struct pci_dev *pdev = qm->pdev;
@@ -769,6 +918,12 @@ int hisi_qm_start(struct qm_info *qm)
 	if (ret)
 		goto err_with_cqc;
 
+#ifdef CONFIG_CRYPTO_DEV_HISI_SDMDEV
+	ret = qm_register_sdmdev(qm);
+	if (ret)
+		goto err_with_cqc;
+#endif
+
 	writel(0x0, QM_ADDR(qm, QM_VF_EQ_INT_MASK));
 
 	return 0;
@@ -795,6 +950,10 @@ void hisi_qm_stop(struct qm_info *qm)
 	struct pci_dev *pdev = qm->pdev;
 	struct device *dev = &pdev->dev;
 
+#ifdef CONFIG_CRYPTO_DEV_HISI_SDMDEV
+	vfio_sdmdev_unregister(&qm->sdmdev);
+#endif
+
 	free_irq(pci_irq_vector(pdev, 0), qm);
 	qm_uninit_q_buffer(dev, &qm->cqc);
 	kfree(qm->qp_array);
diff --git a/drivers/crypto/hisilicon/qm.h b/drivers/crypto/hisilicon/qm.h
index 0e81182ac6a8..0d24e0bd42e8 100644
--- a/drivers/crypto/hisilicon/qm.h
+++ b/drivers/crypto/hisilicon/qm.h
@@ -8,6 +8,10 @@
 #include <linux/pci.h>
 #include <linux/slab.h>
 
+#ifdef CONFIG_CRYPTO_DEV_HISI_SDMDEV
+#include <linux/vfio_sdmdev.h>
+#endif
+
 #define QM_CQE_SIZE			16
 /* default queue depth for sq/cq/eq */
 #define QM_Q_DEPTH			1024
@@ -59,6 +63,10 @@ struct qm_info {
 
 	struct hisi_acc_qm_hw_ops *ops;
 
+#ifdef CONFIG_CRYPTO_DEV_HISI_SDMDEV
+	struct vfio_sdmdev sdmdev;
+	const struct attribute_group **mdev_dev_groups;
+#endif
 };
 #define QM_ADDR(qm, off) ((qm)->io_base + off)
 
@@ -89,6 +97,10 @@ struct hisi_qp {
 
 	struct qm_info *qm;
 
+#ifdef CONFIG_CRYPTO_DEV_HISI_SDMDEV
+	struct vfio_sdmdev_queue *sdmdev_q;
+#endif
+
 	/* for crypto sync API */
 	struct completion completion;
 
-- 
2.17.1
