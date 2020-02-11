Return-Path: <SRS0=l+Io=37=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB4F5C3B186
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Feb 2020 07:55:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A500C2070A
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Feb 2020 07:55:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZsaTAO4W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727578AbgBKHzj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Feb 2020 02:55:39 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:50552 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726973AbgBKHzj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Feb 2020 02:55:39 -0500
Received: by mail-pj1-f66.google.com with SMTP id r67so946109pjb.0
        for <linux-crypto@vger.kernel.org>; Mon, 10 Feb 2020 23:55:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8vFs7BtTYVd1LSFhoQs24FthfV+ot+Z7tDrrL6PgPKM=;
        b=ZsaTAO4WFPsygN+qxGuNhP+6MFSqIVSuVw5mjDcmYdIHvuowNA0qwSbZWFUKav7C6b
         i1gNRhWUe2eAlGlCVWTd+KnIkO/XCcm3oqPovJwBDxd3bxNMLjR6wO72QXZBR5PLznmu
         E8KLCdPPg4qQYvE5DyERBmnHCBRuwfMKS1faMDeJF8+LKU/T1pHnaBtyYnQ7bKRfe28+
         DOuAJl6H5yXvb9SkukzzRPuF0gDEN1Izs3UebhcaWi7bT5zrOAYX2y2oRFf9ONDp89cL
         j9R3kaYpnEPSnfnXV/BZ3oxovcYJKeKDLsyJvdJlzDmsUrIMXKtaKq/yeoCrj/m1axOK
         U7OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8vFs7BtTYVd1LSFhoQs24FthfV+ot+Z7tDrrL6PgPKM=;
        b=es6GsOTvQ7u6unw3e8GlVX3nAPGipVDryCq6WJtxxkTevC0WcLECOPMtPEM1VByD3G
         3zs8GaKxuPg06n+/fvZ4AkUdyh83RQziPUCJcYPfrXeF6qCAQ7m13bivPeYw6QrM0ifT
         a7qWDMIfcwYKzewwGy3W+sSyqW2GAFxNMZH1WWPZQpB3RGlg7DINU7Jxnrf2GNHVFgjQ
         Rfl3UcMQgfbfuyvA+aZpC6tPxps1cMvtS0Ox6OD8FTFJIiys9NNnmc4Jv0xEhYNUYSTb
         rxONYTBRqCgytLq8X4AObO0ruxvxxrcFWa4Tt+0nn2qMC5z4qicBsGo7xoCv5Dur9R+5
         OnUw==
X-Gm-Message-State: APjAAAU8cjBkTKX5WfpA5pKO1iRyEEDZzL8Q/tPUkVmWvdcTuaozch31
        CuvermZYFyTtqb7RqN8sPVTG8w==
X-Google-Smtp-Source: APXvYqz1uPZ7k3dz270TmnKh1yTCB+7vhihcnsvPtMsvjvNlP13kkFr2wI+NsX5OuvJI005GDFJzWg==
X-Received: by 2002:a17:902:161:: with SMTP id 88mr2065149plb.129.1581407738213;
        Mon, 10 Feb 2020 23:55:38 -0800 (PST)
Received: from localhost.localdomain ([45.135.186.96])
        by smtp.gmail.com with ESMTPSA id d73sm3011627pfd.109.2020.02.10.23.55.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 10 Feb 2020 23:55:37 -0800 (PST)
From:   Zhangfei Gao <zhangfei.gao@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        jonathan.cameron@huawei.com, dave.jiang@intel.com,
        grant.likely@arm.com, jean-philippe <jean-philippe@linaro.org>,
        Jerome Glisse <jglisse@redhat.com>,
        ilias.apalodimas@linaro.org, francois.ozog@linaro.org,
        kenneth-lee-2012@foxmail.com, Wangzhou <wangzhou1@hisilicon.com>,
        "haojian . zhuang" <haojian.zhuang@linaro.org>,
        guodong.xu@linaro.org
Cc:     linux-accelerators@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, iommu@lists.linux-foundation.org,
        Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v13 4/4] crypto: hisilicon - register zip engine to uacce
Date:   Tue, 11 Feb 2020 15:54:25 +0800
Message-Id: <1581407665-13504-5-git-send-email-zhangfei.gao@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1581407665-13504-1-git-send-email-zhangfei.gao@linaro.org>
References: <1581407665-13504-1-git-send-email-zhangfei.gao@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Register qm to uacce framework for user crypto driver

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/crypto/hisilicon/qm.c           | 239 +++++++++++++++++++++++-
 drivers/crypto/hisilicon/qm.h           |  11 ++
 drivers/crypto/hisilicon/zip/zip_main.c |  18 +-
 include/uapi/misc/uacce/hisi_qm.h       |  23 +++
 4 files changed, 283 insertions(+), 8 deletions(-)
 create mode 100644 include/uapi/misc/uacce/hisi_qm.h

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index b57da5ef8b5b..61cf3f52ca6e 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -9,6 +9,9 @@
 #include <linux/log2.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
+#include <linux/uacce.h>
+#include <linux/uaccess.h>
+#include <uapi/misc/uacce/hisi_qm.h>
 #include "qm.h"
 
 /* eq/aeq irq enable */
@@ -465,9 +468,14 @@ static void qm_cq_head_update(struct hisi_qp *qp)
 
 static void qm_poll_qp(struct hisi_qp *qp, struct hisi_qm *qm)
 {
-	struct qm_cqe *cqe = qp->cqe + qp->qp_status.cq_head;
+	if (qp->event_cb) {
+		qp->event_cb(qp);
+		return;
+	}
 
 	if (qp->req_cb) {
+		struct qm_cqe *cqe = qp->cqe + qp->qp_status.cq_head;
+
 		while (QM_CQE_PHASE(cqe) == qp->qp_status.cqc_phase) {
 			dma_rmb();
 			qp->req_cb(qp, qp->sqe + qm->sqe_size *
@@ -1269,7 +1277,7 @@ static int qm_qp_ctx_cfg(struct hisi_qp *qp, int qp_id, int pasid)
  * @qp: The qp we want to start to run.
  * @arg: Accelerator specific argument.
  *
- * After this function, qp can receive request from user. Return qp_id if
+ * After this function, qp can receive request from user. Return 0 if
  * successful, Return -EBUSY if failed.
  */
 int hisi_qm_start_qp(struct hisi_qp *qp, unsigned long arg)
@@ -1314,7 +1322,7 @@ int hisi_qm_start_qp(struct hisi_qp *qp, unsigned long arg)
 
 	dev_dbg(dev, "queue %d started\n", qp_id);
 
-	return qp_id;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(hisi_qm_start_qp);
 
@@ -1395,6 +1403,214 @@ static void hisi_qm_cache_wb(struct hisi_qm *qm)
 	}
 }
 
+static void qm_qp_event_notifier(struct hisi_qp *qp)
+{
+	wake_up_interruptible(&qp->uacce_q->wait);
+}
+
+static int hisi_qm_get_available_instances(struct uacce_device *uacce)
+{
+	int i, ret;
+	struct hisi_qm *qm = uacce->priv;
+
+	read_lock(&qm->qps_lock);
+	for (i = 0, ret = 0; i < qm->qp_num; i++)
+		if (!qm->qp_array[i])
+			ret++;
+	read_unlock(&qm->qps_lock);
+
+	return ret;
+}
+
+static int hisi_qm_uacce_get_queue(struct uacce_device *uacce,
+				   unsigned long arg,
+				   struct uacce_queue *q)
+{
+	struct hisi_qm *qm = uacce->priv;
+	struct hisi_qp *qp;
+	u8 alg_type = 0;
+
+	qp = hisi_qm_create_qp(qm, alg_type);
+	if (IS_ERR(qp))
+		return PTR_ERR(qp);
+
+	q->priv = qp;
+	q->uacce = uacce;
+	qp->uacce_q = q;
+	qp->event_cb = qm_qp_event_notifier;
+	qp->pasid = arg;
+
+	return 0;
+}
+
+static void hisi_qm_uacce_put_queue(struct uacce_queue *q)
+{
+	struct hisi_qp *qp = q->priv;
+
+	hisi_qm_cache_wb(qp->qm);
+	hisi_qm_release_qp(qp);
+}
+
+/* map sq/cq/doorbell to user space */
+static int hisi_qm_uacce_mmap(struct uacce_queue *q,
+			      struct vm_area_struct *vma,
+			      struct uacce_qfile_region *qfr)
+{
+	struct hisi_qp *qp = q->priv;
+	struct hisi_qm *qm = qp->qm;
+	size_t sz = vma->vm_end - vma->vm_start;
+	struct pci_dev *pdev = qm->pdev;
+	struct device *dev = &pdev->dev;
+	unsigned long vm_pgoff;
+	int ret;
+
+	switch (qfr->type) {
+	case UACCE_QFRT_MMIO:
+		if (qm->ver == QM_HW_V2) {
+			if (sz > PAGE_SIZE * (QM_DOORBELL_PAGE_NR +
+			    QM_DOORBELL_SQ_CQ_BASE_V2 / PAGE_SIZE))
+				return -EINVAL;
+		} else {
+			if (sz > PAGE_SIZE * QM_DOORBELL_PAGE_NR)
+				return -EINVAL;
+		}
+
+		vma->vm_flags |= VM_IO;
+
+		return remap_pfn_range(vma, vma->vm_start,
+				       qm->phys_base >> PAGE_SHIFT,
+				       sz, pgprot_noncached(vma->vm_page_prot));
+	case UACCE_QFRT_DUS:
+		if (sz != qp->qdma.size)
+			return -EINVAL;
+
+		/*
+		 * dma_mmap_coherent() requires vm_pgoff as 0
+		 * restore vm_pfoff to initial value for mmap()
+		 */
+		vm_pgoff = vma->vm_pgoff;
+		vma->vm_pgoff = 0;
+		ret = dma_mmap_coherent(dev, vma, qp->qdma.va,
+					qp->qdma.dma, sz);
+		vma->vm_pgoff = vm_pgoff;
+		return ret;
+
+	default:
+		return -EINVAL;
+	}
+}
+
+static int hisi_qm_uacce_start_queue(struct uacce_queue *q)
+{
+	struct hisi_qp *qp = q->priv;
+
+	return hisi_qm_start_qp(qp, qp->pasid);
+}
+
+static void hisi_qm_uacce_stop_queue(struct uacce_queue *q)
+{
+	hisi_qm_stop_qp(q->priv);
+}
+
+static int qm_set_sqctype(struct uacce_queue *q, u16 type)
+{
+	struct hisi_qm *qm = q->uacce->priv;
+	struct hisi_qp *qp = q->priv;
+
+	write_lock(&qm->qps_lock);
+	qp->alg_type = type;
+	write_unlock(&qm->qps_lock);
+
+	return 0;
+}
+
+static long hisi_qm_uacce_ioctl(struct uacce_queue *q, unsigned int cmd,
+				unsigned long arg)
+{
+	struct hisi_qp *qp = q->priv;
+	struct hisi_qp_ctx qp_ctx;
+
+	if (cmd == UACCE_CMD_QM_SET_QP_CTX) {
+		if (copy_from_user(&qp_ctx, (void __user *)arg,
+				   sizeof(struct hisi_qp_ctx)))
+			return -EFAULT;
+
+		if (qp_ctx.qc_type != 0 && qp_ctx.qc_type != 1)
+			return -EINVAL;
+
+		qm_set_sqctype(q, qp_ctx.qc_type);
+		qp_ctx.id = qp->qp_id;
+
+		if (copy_to_user((void __user *)arg, &qp_ctx,
+				 sizeof(struct hisi_qp_ctx)))
+			return -EFAULT;
+	} else {
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static const struct uacce_ops uacce_qm_ops = {
+	.get_available_instances = hisi_qm_get_available_instances,
+	.get_queue = hisi_qm_uacce_get_queue,
+	.put_queue = hisi_qm_uacce_put_queue,
+	.start_queue = hisi_qm_uacce_start_queue,
+	.stop_queue = hisi_qm_uacce_stop_queue,
+	.mmap = hisi_qm_uacce_mmap,
+	.ioctl = hisi_qm_uacce_ioctl,
+};
+
+static int qm_alloc_uacce(struct hisi_qm *qm)
+{
+	struct pci_dev *pdev = qm->pdev;
+	struct uacce_device *uacce;
+	unsigned long mmio_page_nr;
+	unsigned long dus_page_nr;
+	struct uacce_interface interface = {
+		.flags = UACCE_DEV_SVA,
+		.ops = &uacce_qm_ops,
+	};
+
+	strncpy(interface.name, pdev->driver->name, sizeof(interface.name));
+
+	uacce = uacce_alloc(&pdev->dev, &interface);
+	if (IS_ERR(uacce))
+		return PTR_ERR(uacce);
+
+	if (uacce->flags & UACCE_DEV_SVA) {
+		qm->use_sva = true;
+	} else {
+		/* only consider sva case */
+		uacce_remove(uacce);
+		qm->uacce = NULL;
+		return -EINVAL;
+	}
+
+	uacce->is_vf = pdev->is_virtfn;
+	uacce->priv = qm;
+	uacce->algs = qm->algs;
+
+	if (qm->ver == QM_HW_V1) {
+		mmio_page_nr = QM_DOORBELL_PAGE_NR;
+		uacce->api_ver = HISI_QM_API_VER_BASE;
+	} else {
+		mmio_page_nr = QM_DOORBELL_PAGE_NR +
+			QM_DOORBELL_SQ_CQ_BASE_V2 / PAGE_SIZE;
+		uacce->api_ver = HISI_QM_API_VER2_BASE;
+	}
+
+	dus_page_nr = (PAGE_SIZE - 1 + qm->sqe_size * QM_Q_DEPTH +
+		       sizeof(struct qm_cqe) * QM_Q_DEPTH) >> PAGE_SHIFT;
+
+	uacce->qf_pg_num[UACCE_QFRT_MMIO] = mmio_page_nr;
+	uacce->qf_pg_num[UACCE_QFRT_DUS]  = dus_page_nr;
+
+	qm->uacce = uacce;
+
+	return 0;
+}
+
 /**
  * hisi_qm_get_free_qp_num() - Get free number of qp in qm.
  * @qm: The qm which want to get free qp.
@@ -1437,10 +1653,14 @@ int hisi_qm_init(struct hisi_qm *qm)
 		return -EINVAL;
 	}
 
+	ret = qm_alloc_uacce(qm);
+	if (ret < 0)
+		dev_warn(&pdev->dev, "fail to alloc uacce (%d)\n", ret);
+
 	ret = pci_enable_device_mem(pdev);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Failed to enable device mem!\n");
-		return ret;
+		goto err_remove_uacce;
 	}
 
 	ret = pci_request_mem_regions(pdev, qm->dev_name);
@@ -1449,8 +1669,9 @@ int hisi_qm_init(struct hisi_qm *qm)
 		goto err_disable_pcidev;
 	}
 
-	qm->io_base = ioremap(pci_resource_start(pdev, PCI_BAR_2),
-			      pci_resource_len(qm->pdev, PCI_BAR_2));
+	qm->phys_base = pci_resource_start(pdev, PCI_BAR_2);
+	qm->phys_size = pci_resource_len(qm->pdev, PCI_BAR_2);
+	qm->io_base = ioremap(qm->phys_base, qm->phys_size);
 	if (!qm->io_base) {
 		ret = -EIO;
 		goto err_release_mem_regions;
@@ -1493,6 +1714,9 @@ int hisi_qm_init(struct hisi_qm *qm)
 	pci_release_mem_regions(pdev);
 err_disable_pcidev:
 	pci_disable_device(pdev);
+err_remove_uacce:
+	uacce_remove(qm->uacce);
+	qm->uacce = NULL;
 
 	return ret;
 }
@@ -1509,6 +1733,9 @@ void hisi_qm_uninit(struct hisi_qm *qm)
 	struct pci_dev *pdev = qm->pdev;
 	struct device *dev = &pdev->dev;
 
+	uacce_remove(qm->uacce);
+	qm->uacce = NULL;
+
 	if (qm->use_dma_api && qm->qdma.va) {
 		hisi_qm_cache_wb(qm);
 		dma_free_coherent(dev, qm->qdma.size,
diff --git a/drivers/crypto/hisilicon/qm.h b/drivers/crypto/hisilicon/qm.h
index 078b8f1f1b77..c096f80a1333 100644
--- a/drivers/crypto/hisilicon/qm.h
+++ b/drivers/crypto/hisilicon/qm.h
@@ -77,6 +77,9 @@
 
 #define HISI_ACC_SGL_SGE_NR_MAX		255
 
+/* page number for queue file region */
+#define QM_DOORBELL_PAGE_NR		1
+
 enum qp_state {
 	QP_STOP,
 };
@@ -162,7 +165,12 @@ struct hisi_qm {
 	u32 error_mask;
 	u32 msi_mask;
 
+	const char *algs;
 	bool use_dma_api;
+	bool use_sva;
+	resource_size_t phys_base;
+	resource_size_t phys_size;
+	struct uacce_device *uacce;
 };
 
 struct hisi_qp_status {
@@ -192,10 +200,13 @@ struct hisi_qp {
 	struct hisi_qp_ops *hw_ops;
 	void *qp_ctx;
 	void (*req_cb)(struct hisi_qp *qp, void *data);
+	void (*event_cb)(struct hisi_qp *qp);
 	struct work_struct work;
 	struct workqueue_struct *wq;
 
 	struct hisi_qm *qm;
+	u16 pasid;
+	struct uacce_queue *uacce_q;
 };
 
 int hisi_qm_init(struct hisi_qm *qm);
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 93345f0d7415..013252824f88 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -11,6 +11,7 @@
 #include <linux/pci.h>
 #include <linux/seq_file.h>
 #include <linux/topology.h>
+#include <linux/uacce.h>
 #include "zip.h"
 
 #define PCI_DEVICE_ID_ZIP_PF		0xa250
@@ -350,8 +351,14 @@ static void hisi_zip_set_user_domain_and_cache(struct hisi_zip *hisi_zip)
 	writel(AXUSER_BASE, base + HZIP_BD_RUSER_32_63);
 	writel(AXUSER_BASE, base + HZIP_SGL_RUSER_32_63);
 	writel(AXUSER_BASE, base + HZIP_BD_WUSER_32_63);
-	writel(AXUSER_BASE, base + HZIP_DATA_RUSER_32_63);
-	writel(AXUSER_BASE, base + HZIP_DATA_WUSER_32_63);
+
+	if (hisi_zip->qm.use_sva) {
+		writel(AXUSER_BASE | AXUSER_SSV, base + HZIP_DATA_RUSER_32_63);
+		writel(AXUSER_BASE | AXUSER_SSV, base + HZIP_DATA_WUSER_32_63);
+	} else {
+		writel(AXUSER_BASE, base + HZIP_DATA_RUSER_32_63);
+		writel(AXUSER_BASE, base + HZIP_DATA_WUSER_32_63);
+	}
 
 	/* let's open all compression/decompression cores */
 	writel(DECOMP_CHECK_ENABLE | ALL_COMP_DECOMP_EN,
@@ -792,6 +799,7 @@ static int hisi_zip_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	qm->pdev = pdev;
 	qm->ver = rev_id;
 
+	qm->algs = "zlib\ngzip";
 	qm->sqe_size = HZIP_SQE_SIZE;
 	qm->dev_name = hisi_zip_name;
 	qm->fun_type = (pdev->device == PCI_DEVICE_ID_ZIP_PF) ? QM_HW_PF :
@@ -835,6 +843,12 @@ static int hisi_zip_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	hisi_zip_add_to_list(hisi_zip);
 
+	if (qm->uacce) {
+		ret = uacce_register(qm->uacce);
+		if (ret)
+			goto err_qm_uninit;
+	}
+
 	if (qm->fun_type == QM_HW_PF && vfs_num > 0) {
 		ret = hisi_zip_sriov_enable(pdev, vfs_num);
 		if (ret < 0)
diff --git a/include/uapi/misc/uacce/hisi_qm.h b/include/uapi/misc/uacce/hisi_qm.h
new file mode 100644
index 000000000000..6435f0bcb556
--- /dev/null
+++ b/include/uapi/misc/uacce/hisi_qm.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
+#ifndef _UAPI_HISI_QM_H
+#define _UAPI_HISI_QM_H
+
+#include <linux/types.h>
+
+/**
+ * struct hisi_qp_ctx - User data for hisi qp.
+ * @id: qp_index return to user space
+ * @qc_type: Accelerator algorithm type
+ */
+struct hisi_qp_ctx {
+	__u16 id;
+	__u16 qc_type;
+};
+
+#define HISI_QM_API_VER_BASE "hisi_qm_v1"
+#define HISI_QM_API_VER2_BASE "hisi_qm_v2"
+
+/* UACCE_CMD_QM_SET_QP_CTX: Set qp algorithm type */
+#define UACCE_CMD_QM_SET_QP_CTX	_IOWR('H', 10, struct hisi_qp_ctx)
+
+#endif
-- 
2.23.0

