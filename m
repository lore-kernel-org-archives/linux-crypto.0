Return-Path: <SRS0=WkI6=YW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23AF6CA9EC2
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Oct 2019 06:41:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6CA7217F9
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Oct 2019 06:41:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TxXdsa37"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732652AbfJ2Glj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 29 Oct 2019 02:41:39 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40226 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732630AbfJ2Gli (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Oct 2019 02:41:38 -0400
Received: by mail-pf1-f195.google.com with SMTP id r4so3154964pfl.7
        for <linux-crypto@vger.kernel.org>; Mon, 28 Oct 2019 23:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dekWozQpi8Yds4BtBBFvE6aNgm93yn3hRX+1DVnhSXA=;
        b=TxXdsa37VU48AW/7JNoNomAxHsjllorHtXzFiL55rXM8tizApaPdseiN4jRvWjh4hu
         28njhgiqoINAZoT7iPK9J/uRgZsbDr9yfIp5ka2cak6LUudAOwPJgIcqmhv0F0hPzOkc
         P7DSdvH53puHBvbTXDDmMvOCq+RQRq+4QCeUPQdDUwkKQn5mOnGRux7Lw1+yJKxIMDAI
         qFTpQrsX/j0x4JMGE5Gz69GoeYz9rF0e1WZiBYJNfjbmsSlCSC2m5/x+cmuL7pLTYIB3
         9nUPutB2IvHv4Y6Zq6aZIIV4/bp5l3/K0c3xrJc/1WLd8Ro6cYFJ4vIkJ7yrKtmPCckZ
         FhXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dekWozQpi8Yds4BtBBFvE6aNgm93yn3hRX+1DVnhSXA=;
        b=egM7jlvL3F8ibhNAEfy1BRASzqRuGuyL7ntGFANdjE+VmkvIC2jebt9sQq3F2SPP2i
         PkBwcxwIiGmAvtWVxEh6Ep1dpbWGsQlaFaPOQ2auE+jsEIShPxdN5r5xtou5ge4Gp7NJ
         SpWso7M7M90OuRBvZXrDQEe6V0+FMGjIbRQgBnvEvWHU69/PToo0hWPA+gAyXLyclwBM
         1kAcplIWwD+xO+3XUFfnqCUCqS2gHvZHy3KoWheUdEjL6RiEYz6QipZnmeVNgEUsMj6B
         AwBqudvS1Q3TmeJdpbQzNac4kXPCn0q1rNqDUhc+xrK4fAQRq8AwpC3TSTzyRf6BVNNj
         flJw==
X-Gm-Message-State: APjAAAUaKYaDV9PMCinJbAt0vH2ydUcmnAKPPepuGNe8P0ng3WS8nFFC
        TaGwGFISzRKrJNsZBXZmfhBosQ==
X-Google-Smtp-Source: APXvYqx2R8/rL2D0gYW7AXASpTKI2pP8bAJABqIYriX4186C/mAvdaw/Vwt8ezZm/1JbQYdtkAvY3Q==
X-Received: by 2002:a17:90a:25e1:: with SMTP id k88mr4361121pje.14.1572331298008;
        Mon, 28 Oct 2019 23:41:38 -0700 (PDT)
Received: from localhost.localdomain ([240e:362:4dc:3a00:892e:70f7:f486:8f02])
        by smtp.gmail.com with ESMTPSA id e23sm13421834pgh.84.2019.10.28.23.41.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 28 Oct 2019 23:41:37 -0700 (PDT)
From:   Zhangfei Gao <zhangfei.gao@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        jonathan.cameron@huawei.com, grant.likely@arm.com,
        jean-philippe <jean-philippe@linaro.org>,
        Jerome Glisse <jglisse@redhat.com>,
        ilias.apalodimas@linaro.org, francois.ozog@linaro.org,
        kenneth-lee-2012@foxmail.com, Wangzhou <wangzhou1@hisilicon.com>,
        "haojian . zhuang" <haojian.zhuang@linaro.org>,
        guodong.xu@linaro.org
Cc:     linux-accelerators@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, iommu@lists.linux-foundation.org,
        Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v7 3/3] crypto: hisilicon - register zip engine to uacce
Date:   Tue, 29 Oct 2019 14:40:16 +0800
Message-Id: <1572331216-9503-4-git-send-email-zhangfei.gao@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1572331216-9503-1-git-send-email-zhangfei.gao@linaro.org>
References: <1572331216-9503-1-git-send-email-zhangfei.gao@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Register qm to uacce framework for user crypto driver

Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/crypto/hisilicon/qm.c           | 253 ++++++++++++++++++++++++++++++--
 drivers/crypto/hisilicon/qm.h           |  13 +-
 drivers/crypto/hisilicon/zip/zip_main.c |  39 ++---
 include/uapi/misc/uacce/qm.h            |  23 +++
 4 files changed, 292 insertions(+), 36 deletions(-)
 create mode 100644 include/uapi/misc/uacce/qm.h

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index a8ed6990..4b9cced 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -9,6 +9,9 @@
 #include <linux/log2.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
+#include <linux/uacce.h>
+#include <linux/uaccess.h>
+#include <uapi/misc/uacce/qm.h>
 #include "qm.h"
 
 /* eq/aeq irq enable */
@@ -465,17 +468,22 @@ static void qm_cq_head_update(struct hisi_qp *qp)
 
 static void qm_poll_qp(struct hisi_qp *qp, struct hisi_qm *qm)
 {
-	struct qm_cqe *cqe = qp->cqe + qp->qp_status.cq_head;
-
-	if (qp->req_cb) {
-		while (QM_CQE_PHASE(cqe) == qp->qp_status.cqc_phase) {
-			dma_rmb();
-			qp->req_cb(qp, qp->sqe + qm->sqe_size * cqe->sq_head);
-			qm_cq_head_update(qp);
-			cqe = qp->cqe + qp->qp_status.cq_head;
-			qm_db(qm, qp->qp_id, QM_DOORBELL_CMD_CQ,
-			      qp->qp_status.cq_head, 0);
-			atomic_dec(&qp->qp_status.used);
+	struct qm_cqe *cqe;
+
+	if (qp->event_cb) {
+		qp->event_cb(qp);
+	} else {
+		cqe = qp->cqe + qp->qp_status.cq_head;
+
+		if (qp->req_cb) {
+			while (QM_CQE_PHASE(cqe) == qp->qp_status.cqc_phase) {
+				dma_rmb();
+				qp->req_cb(qp, qp->sqe + qm->sqe_size *
+					   cqe->sq_head);
+				qm_cq_head_update(qp);
+				cqe = qp->cqe + qp->qp_status.cq_head;
+				atomic_dec(&qp->qp_status.used);
+			}
 		}
 
 		/* set c_flag */
@@ -1397,6 +1405,220 @@ static void hisi_qm_cache_wb(struct hisi_qm *qm)
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
+	/*
+	 * As put_queue is only called in uacce_mode=1, and only one queue can
+	 * be used in this mode. we flush all sqc cache back in put queue.
+	 */
+	hisi_qm_cache_wb(qp->qm);
+
+	/* need to stop hardware, but can not support in v1 */
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
+		/* dma_mmap_coherent() requires vm_pgoff as 0
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
+	struct hisi_qp *qp = q->priv;
+
+	hisi_qm_stop_qp(qp);
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
+static struct uacce_ops uacce_qm_ops = {
+	.get_available_instances = hisi_qm_get_available_instances,
+	.get_queue = hisi_qm_uacce_get_queue,
+	.put_queue = hisi_qm_uacce_put_queue,
+	.start_queue = hisi_qm_uacce_start_queue,
+	.stop_queue = hisi_qm_uacce_stop_queue,
+	.mmap = hisi_qm_uacce_mmap,
+	.ioctl = hisi_qm_uacce_ioctl,
+};
+
+static int qm_register_uacce(struct hisi_qm *qm)
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
+	uacce = uacce_register(&pdev->dev, &interface);
+	if (IS_ERR(uacce))
+		return PTR_ERR(uacce);
+
+	if (uacce->flags & UACCE_DEV_SVA) {
+		qm->use_sva = true;
+	} else {
+		/* only consider sva case */
+		uacce_unregister(uacce);
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
+	uacce->qf_pg_size[UACCE_QFRT_MMIO] = mmio_page_nr;
+	uacce->qf_pg_size[UACCE_QFRT_DUS]  = dus_page_nr;
+
+	qm->uacce = uacce;
+
+	return 0;
+}
+
 /**
  * hisi_qm_init() - Initialize configures about qm.
  * @qm: The qm needing init.
@@ -1421,6 +1643,10 @@ int hisi_qm_init(struct hisi_qm *qm)
 		return -EINVAL;
 	}
 
+	ret = qm_register_uacce(qm);
+	if (ret < 0)
+		dev_warn(&pdev->dev, "fail to register uacce (%d)\n", ret);
+
 	ret = pci_enable_device_mem(pdev);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Failed to enable device mem!\n");
@@ -1433,6 +1659,8 @@ int hisi_qm_init(struct hisi_qm *qm)
 		goto err_disable_pcidev;
 	}
 
+	qm->phys_base = pci_resource_start(pdev, PCI_BAR_2);
+	qm->size = pci_resource_len(qm->pdev, PCI_BAR_2);
 	qm->io_base = ioremap(pci_resource_start(pdev, PCI_BAR_2),
 			      pci_resource_len(qm->pdev, PCI_BAR_2));
 	if (!qm->io_base) {
@@ -1504,6 +1732,9 @@ void hisi_qm_uninit(struct hisi_qm *qm)
 	iounmap(qm->io_base);
 	pci_release_mem_regions(pdev);
 	pci_disable_device(pdev);
+
+	if (qm->uacce)
+		uacce_unregister(qm->uacce);
 }
 EXPORT_SYMBOL_GPL(hisi_qm_uninit);
 
diff --git a/drivers/crypto/hisilicon/qm.h b/drivers/crypto/hisilicon/qm.h
index 103e2fd..84a3be9 100644
--- a/drivers/crypto/hisilicon/qm.h
+++ b/drivers/crypto/hisilicon/qm.h
@@ -77,6 +77,10 @@
 
 #define HISI_ACC_SGL_SGE_NR_MAX		255
 
+/* page number for queue file region */
+#define QM_DOORBELL_PAGE_NR		1
+
+
 enum qp_state {
 	QP_STOP,
 };
@@ -161,7 +165,12 @@ struct hisi_qm {
 	u32 error_mask;
 	u32 msi_mask;
 
+	const char *algs;
 	bool use_dma_api;
+	bool use_sva;
+	resource_size_t phys_base;
+	resource_size_t size;
+	struct uacce_device *uacce;
 };
 
 struct hisi_qp_status {
@@ -191,10 +200,12 @@ struct hisi_qp {
 	struct hisi_qp_ops *hw_ops;
 	void *qp_ctx;
 	void (*req_cb)(struct hisi_qp *qp, void *data);
+	void (*event_cb)(struct hisi_qp *qp);
 	struct work_struct work;
 	struct workqueue_struct *wq;
-
 	struct hisi_qm *qm;
+	u16 pasid;
+	struct uacce_queue *uacce_q;
 };
 
 int hisi_qm_init(struct hisi_qm *qm);
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 1b2ee96..48860d2 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -316,8 +316,14 @@ static void hisi_zip_set_user_domain_and_cache(struct hisi_zip *hisi_zip)
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
@@ -671,24 +677,12 @@ static int hisi_zip_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	qm = &hisi_zip->qm;
 	qm->pdev = pdev;
 	qm->ver = rev_id;
-
+	qm->use_dma_api = true;
+	qm->algs = "zlib\ngzip\n";
 	qm->sqe_size = HZIP_SQE_SIZE;
 	qm->dev_name = hisi_zip_name;
 	qm->fun_type = (pdev->device == PCI_DEVICE_ID_ZIP_PF) ? QM_HW_PF :
 								QM_HW_VF;
-	switch (uacce_mode) {
-	case 0:
-		qm->use_dma_api = true;
-		break;
-	case 1:
-		qm->use_dma_api = false;
-		break;
-	case 2:
-		qm->use_dma_api = true;
-		break;
-	default:
-		return -EINVAL;
-	}
 
 	ret = hisi_qm_init(qm);
 	if (ret) {
@@ -976,12 +970,10 @@ static int __init hisi_zip_init(void)
 		goto err_pci;
 	}
 
-	if (uacce_mode == 0 || uacce_mode == 2) {
-		ret = hisi_zip_register_to_crypto();
-		if (ret < 0) {
-			pr_err("Failed to register driver to crypto.\n");
-			goto err_crypto;
-		}
+	ret = hisi_zip_register_to_crypto();
+	if (ret < 0) {
+		pr_err("Failed to register driver to crypto.\n");
+		goto err_crypto;
 	}
 
 	return 0;
@@ -996,8 +988,7 @@ static int __init hisi_zip_init(void)
 
 static void __exit hisi_zip_exit(void)
 {
-	if (uacce_mode == 0 || uacce_mode == 2)
-		hisi_zip_unregister_from_crypto();
+	hisi_zip_unregister_from_crypto();
 	pci_unregister_driver(&hisi_zip_pci_driver);
 	hisi_zip_unregister_debugfs();
 }
diff --git a/include/uapi/misc/uacce/qm.h b/include/uapi/misc/uacce/qm.h
new file mode 100644
index 0000000..d79a8f2
--- /dev/null
+++ b/include/uapi/misc/uacce/qm.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
+#ifndef HISI_QM_USR_IF_H
+#define HISI_QM_USR_IF_H
+
+#include <linux/types.h>
+
+/**
+ * struct hisi_qp_ctx - User data for hisi qp.
+ * @id: Specifies which Turbo decode algorithm to use
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
2.7.4

