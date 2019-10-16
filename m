Return-Path: <SRS0=0DWe=YJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77AC9C4360C
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 08:35:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38D8521848
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 08:35:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pVfWgsEi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391278AbfJPIfQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Oct 2019 04:35:16 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37074 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391102AbfJPIfQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Oct 2019 04:35:16 -0400
Received: by mail-pf1-f195.google.com with SMTP id y5so14268320pfo.4
        for <linux-crypto@vger.kernel.org>; Wed, 16 Oct 2019 01:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jtgWWv3nTnOlR7dCg29F7EWx97mB6FavF2QvGijFLbM=;
        b=pVfWgsEis5lMoP4gcdpcrXUbvmPJr+GBziDZMDby2Ej9UbU5QkaM7f4+aGYMsP30h+
         jXwLmMrWfj1y3rrBxQG3G7oyZiR+XMKbeZp4nyOewYrLEGHB4TppXQzzcU0GqOJJIMWw
         hhUMOVequ7ZHTEOfiMKABLaVqiNA/ldZBouh4ydZ0LZfyPVzep25M19TClPRorgOPvfa
         1JkhydazoSdt/vQrEazUHFMF1FkerUfxqZ0Y6YnpTL23B1hjzQ8VDoDdcTxq5b/WZnsH
         AqnAowz7Qjgg5UW4BXcH8MxiOseF50fyfaMrUHcHHwGygYKyqMsjlh9mXN5kDeVn1weB
         hVNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jtgWWv3nTnOlR7dCg29F7EWx97mB6FavF2QvGijFLbM=;
        b=Mwls8j+5iPdJW/se/yxk1NI8yTNpePgoaELie+y1Q7gYUq0Fl/cPvjfTJ2zPT0zN1t
         LkqinhJz+DuEDaRpJrtSnML/AdVTTg1SbXX25qFmXfXBboOLIHaUgx1ZRUM3XFuA+4JA
         UZpeGdBJBvAZh2D68bokuVWa4GhtkoCOVX7OB15sQxhmjLLPnh2BKKEgIwlRVrdCxK0U
         ZdWuA7v29V6dErMHLVkf7MV4Lp3WfjeRECu3mb8Igl8QXG7sFap9e7+9ufHzLBO9uQQb
         48Zj4+plin2Q5CepX2XPrYk4CaHAU/uUwu49IswieYN98VKPY5lMDhqZdaVtrKayMGqw
         Kr6A==
X-Gm-Message-State: APjAAAUCMxqzDwy2bC5BxCz71hLzdogYuQyROTbCbbitMsHIF19DPwGB
        lk/KxfIbtu/HuzovXMUpH9K0GQ==
X-Google-Smtp-Source: APXvYqwRhBhNlewjzSPCUdBB5wlE27fxRQNq1utF1koJk+faj/OKZq+BkmbFqSuyOYN/+YhKUtU9oA==
X-Received: by 2002:a17:90a:aa98:: with SMTP id l24mr3555491pjq.96.1571214915166;
        Wed, 16 Oct 2019 01:35:15 -0700 (PDT)
Received: from localhost.localdomain ([85.203.47.199])
        by smtp.gmail.com with ESMTPSA id d19sm1745960pjz.5.2019.10.16.01.35.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 16 Oct 2019 01:35:14 -0700 (PDT)
From:   Zhangfei Gao <zhangfei.gao@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        jonathan.cameron@huawei.com, grant.likely@arm.com,
        jean-philippe <jean-philippe@linaro.org>,
        ilias.apalodimas@linaro.org, francois.ozog@linaro.org,
        kenneth-lee-2012@foxmail.com, Wangzhou <wangzhou1@hisilicon.com>,
        "haojian . zhuang" <haojian.zhuang@linaro.org>
Cc:     linux-accelerators@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v6 3/3] crypto: hisilicon - register zip engine to uacce
Date:   Wed, 16 Oct 2019 16:34:33 +0800
Message-Id: <1571214873-27359-4-git-send-email-zhangfei.gao@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1571214873-27359-1-git-send-email-zhangfei.gao@linaro.org>
References: <1571214873-27359-1-git-send-email-zhangfei.gao@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Register qm to uacce framework for user crypto driver

Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/crypto/hisilicon/qm.c           | 254 ++++++++++++++++++++++++++++++--
 drivers/crypto/hisilicon/qm.h           |  13 +-
 drivers/crypto/hisilicon/zip/zip_main.c |  39 ++---
 include/uapi/misc/uacce/qm.h            |  22 +++
 4 files changed, 292 insertions(+), 36 deletions(-)
 create mode 100644 include/uapi/misc/uacce/qm.h

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index a8ed6990..0ffb0ad 100644
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
@@ -1397,6 +1405,221 @@ static void hisi_qm_cache_wb(struct hisi_qm *qm)
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
+	uacce->qf_pg_size[UACCE_QFRT_SS]   = 0;
+
+	qm->uacce = uacce;
+
+	return 0;
+}
+
 /**
  * hisi_qm_init() - Initialize configures about qm.
  * @qm: The qm needing init.
@@ -1421,6 +1644,10 @@ int hisi_qm_init(struct hisi_qm *qm)
 		return -EINVAL;
 	}
 
+	ret = qm_register_uacce(qm);
+	if (ret < 0)
+		dev_warn(&pdev->dev, "fail to register uacce (%d)\n", ret);
+
 	ret = pci_enable_device_mem(pdev);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Failed to enable device mem!\n");
@@ -1433,6 +1660,8 @@ int hisi_qm_init(struct hisi_qm *qm)
 		goto err_disable_pcidev;
 	}
 
+	qm->phys_base = pci_resource_start(pdev, PCI_BAR_2);
+	qm->size = pci_resource_len(qm->pdev, PCI_BAR_2);
 	qm->io_base = ioremap(pci_resource_start(pdev, PCI_BAR_2),
 			      pci_resource_len(qm->pdev, PCI_BAR_2));
 	if (!qm->io_base) {
@@ -1504,6 +1733,9 @@ void hisi_qm_uninit(struct hisi_qm *qm)
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
index 0000000..08f1c79
--- /dev/null
+++ b/include/uapi/misc/uacce/qm.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
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
+#define UACCE_CMD_QM_SET_QP_CTX	_IOWR('H', 10, struct hisi_qp_ctx)
+
+#endif
-- 
2.7.4

