Return-Path: <SRS0=cgyY=YY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 363AACA9ECB
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Oct 2019 17:53:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01B152080F
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Oct 2019 17:53:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728561AbfJaRxb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Oct 2019 13:53:31 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5674 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726602AbfJaRxa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Oct 2019 13:53:30 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 689EB2DBA80752E48A43;
        Fri,  1 Nov 2019 01:53:28 +0800 (CST)
Received: from localhost (10.202.226.61) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Fri, 1 Nov 2019
 01:53:21 +0800
Date:   Thu, 31 Oct 2019 17:53:11 +0000
From:   Jonathan Cameron <jonathan.cameron@huawei.com>
To:     Zhangfei Gao <zhangfei.gao@linaro.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        <grant.likely@arm.com>, jean-philippe <jean-philippe@linaro.org>,
        "Jerome Glisse" <jglisse@redhat.com>,
        <ilias.apalodimas@linaro.org>, <francois.ozog@linaro.org>,
        <kenneth-lee-2012@foxmail.com>, Wangzhou <wangzhou1@hisilicon.com>,
        "haojian . zhuang" <haojian.zhuang@linaro.org>,
        <guodong.xu@linaro.org>, <linux-accelerators@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <iommu@lists.linux-foundation.org>
Subject: Re: [PATCH v7 3/3] crypto: hisilicon - register zip engine to uacce
Message-ID: <20191031175311.000013e8@huawei.com>
In-Reply-To: <1572331216-9503-4-git-send-email-zhangfei.gao@linaro.org>
References: <1572331216-9503-1-git-send-email-zhangfei.gao@linaro.org>
        <1572331216-9503-4-git-send-email-zhangfei.gao@linaro.org>
Organization: Huawei
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.61]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 29 Oct 2019 14:40:16 +0800
Zhangfei Gao <zhangfei.gao@linaro.org> wrote:

> Register qm to uacce framework for user crypto driver
> 
> Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
> Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
Hi. 

This shows there is probably a race during setup that you should close.
Userspace interface is exposed before the driver is ready to handle it.

Few other bits inline.

Thanks,

Jonathan

> ---
>  drivers/crypto/hisilicon/qm.c           | 253 ++++++++++++++++++++++++++++++--
>  drivers/crypto/hisilicon/qm.h           |  13 +-
>  drivers/crypto/hisilicon/zip/zip_main.c |  39 ++---
>  include/uapi/misc/uacce/qm.h            |  23 +++
>  4 files changed, 292 insertions(+), 36 deletions(-)
>  create mode 100644 include/uapi/misc/uacce/qm.h
> 
> diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
> index a8ed6990..4b9cced 100644
> --- a/drivers/crypto/hisilicon/qm.c
> +++ b/drivers/crypto/hisilicon/qm.c
> @@ -9,6 +9,9 @@
>  #include <linux/log2.h>
>  #include <linux/seq_file.h>
>  #include <linux/slab.h>
> +#include <linux/uacce.h>
> +#include <linux/uaccess.h>
> +#include <uapi/misc/uacce/qm.h>
>  #include "qm.h"
>  
>  /* eq/aeq irq enable */
> @@ -465,17 +468,22 @@ static void qm_cq_head_update(struct hisi_qp *qp)
>  
>  static void qm_poll_qp(struct hisi_qp *qp, struct hisi_qm *qm)
>  {
> -	struct qm_cqe *cqe = qp->cqe + qp->qp_status.cq_head;
> -
> -	if (qp->req_cb) {
> -		while (QM_CQE_PHASE(cqe) == qp->qp_status.cqc_phase) {
> -			dma_rmb();
> -			qp->req_cb(qp, qp->sqe + qm->sqe_size * cqe->sq_head);
> -			qm_cq_head_update(qp);
> -			cqe = qp->cqe + qp->qp_status.cq_head;
> -			qm_db(qm, qp->qp_id, QM_DOORBELL_CMD_CQ,
> -			      qp->qp_status.cq_head, 0);
> -			atomic_dec(&qp->qp_status.used);
> +	struct qm_cqe *cqe;
> +
> +	if (qp->event_cb) {
> +		qp->event_cb(qp);
> +	} else {
> +		cqe = qp->cqe + qp->qp_status.cq_head;
> +
> +		if (qp->req_cb) {
> +			while (QM_CQE_PHASE(cqe) == qp->qp_status.cqc_phase) {
> +				dma_rmb();
> +				qp->req_cb(qp, qp->sqe + qm->sqe_size *
> +					   cqe->sq_head);
> +				qm_cq_head_update(qp);
> +				cqe = qp->cqe + qp->qp_status.cq_head;
> +				atomic_dec(&qp->qp_status.used);
> +			}
>  		}
>  
>  		/* set c_flag */
> @@ -1397,6 +1405,220 @@ static void hisi_qm_cache_wb(struct hisi_qm *qm)
>  	}
>  }
>  
> +static void qm_qp_event_notifier(struct hisi_qp *qp)
> +{
> +	wake_up_interruptible(&qp->uacce_q->wait);
> +}
> +
> +static int hisi_qm_get_available_instances(struct uacce_device *uacce)
> +{
> +	int i, ret;
> +	struct hisi_qm *qm = uacce->priv;
> +
> +	read_lock(&qm->qps_lock);
> +	for (i = 0, ret = 0; i < qm->qp_num; i++)
> +		if (!qm->qp_array[i])
> +			ret++;
> +	read_unlock(&qm->qps_lock);
> +
> +	return ret;
> +}
> +
> +static int hisi_qm_uacce_get_queue(struct uacce_device *uacce,
> +				   unsigned long arg,
> +				   struct uacce_queue *q)
> +{
> +	struct hisi_qm *qm = uacce->priv;
> +	struct hisi_qp *qp;
> +	u8 alg_type = 0;
> +
> +	qp = hisi_qm_create_qp(qm, alg_type);
> +	if (IS_ERR(qp))
> +		return PTR_ERR(qp);
> +
> +	q->priv = qp;
> +	q->uacce = uacce;
> +	qp->uacce_q = q;
> +	qp->event_cb = qm_qp_event_notifier;
> +	qp->pasid = arg;
> +
> +	return 0;
> +}
> +
> +static void hisi_qm_uacce_put_queue(struct uacce_queue *q)
> +{
> +	struct hisi_qp *qp = q->priv;
> +
> +	/*
> +	 * As put_queue is only called in uacce_mode=1, and only one queue can
We got rid of the modes I think so comment needs an update.

> +	 * be used in this mode. we flush all sqc cache back in put queue.
> +	 */
> +	hisi_qm_cache_wb(qp->qm);
> +
> +	/* need to stop hardware, but can not support in v1 */
> +	hisi_qm_release_qp(qp);

Should we just drop support for the v1 hardware if we can't do this?

> +}
> +
> +/* map sq/cq/doorbell to user space */
> +static int hisi_qm_uacce_mmap(struct uacce_queue *q,
> +			      struct vm_area_struct *vma,
> +			      struct uacce_qfile_region *qfr)
> +{
> +	struct hisi_qp *qp = q->priv;
> +	struct hisi_qm *qm = qp->qm;
> +	size_t sz = vma->vm_end - vma->vm_start;
> +	struct pci_dev *pdev = qm->pdev;
> +	struct device *dev = &pdev->dev;
> +	unsigned long vm_pgoff;
> +	int ret;
> +
> +	switch (qfr->type) {
> +	case UACCE_QFRT_MMIO:
> +		if (qm->ver == QM_HW_V2) {
> +			if (sz > PAGE_SIZE * (QM_DOORBELL_PAGE_NR +
> +			    QM_DOORBELL_SQ_CQ_BASE_V2 / PAGE_SIZE))
> +				return -EINVAL;
> +		} else {
> +			if (sz > PAGE_SIZE * QM_DOORBELL_PAGE_NR)
> +				return -EINVAL;
> +		}
> +
> +		vma->vm_flags |= VM_IO;
> +
> +		return remap_pfn_range(vma, vma->vm_start,
> +				       qm->phys_base >> PAGE_SHIFT,
> +				       sz, pgprot_noncached(vma->vm_page_prot));
> +	case UACCE_QFRT_DUS:
> +		if (sz != qp->qdma.size)
> +			return -EINVAL;
> +

Comment style in here is inconsistent. Match the existing code.

> +		/* dma_mmap_coherent() requires vm_pgoff as 0
> +		 * restore vm_pfoff to initial value for mmap()
> +		 */
> +		vm_pgoff = vma->vm_pgoff;
> +		vma->vm_pgoff = 0;
> +		ret = dma_mmap_coherent(dev, vma, qp->qdma.va,
> +					qp->qdma.dma, sz);
> +		vma->vm_pgoff = vm_pgoff;
> +		return ret;
> +
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +static int hisi_qm_uacce_start_queue(struct uacce_queue *q)
> +{
> +	struct hisi_qp *qp = q->priv;
> +
> +	return hisi_qm_start_qp(qp, qp->pasid);
> +}
> +
> +static void hisi_qm_uacce_stop_queue(struct uacce_queue *q)
> +{
> +	struct hisi_qp *qp = q->priv;
> +
> +	hisi_qm_stop_qp(qp);
I'm a great fan of minimalism on these
	hisi_qm_stop_qp(q->priv); doesn't really loose any clarity.

> +}
> +
> +static int qm_set_sqctype(struct uacce_queue *q, u16 type)
> +{
> +	struct hisi_qm *qm = q->uacce->priv;
> +	struct hisi_qp *qp = q->priv;
> +
> +	write_lock(&qm->qps_lock);
> +	qp->alg_type = type;
> +	write_unlock(&qm->qps_lock);
> +
> +	return 0;
> +}
> +
> +static long hisi_qm_uacce_ioctl(struct uacce_queue *q, unsigned int cmd,
> +				unsigned long arg)
> +{
> +	struct hisi_qp *qp = q->priv;
> +	struct hisi_qp_ctx qp_ctx;
> +
> +	if (cmd == UACCE_CMD_QM_SET_QP_CTX) {
> +		if (copy_from_user(&qp_ctx, (void __user *)arg,
> +				   sizeof(struct hisi_qp_ctx)))
> +			return -EFAULT;
> +
> +		if (qp_ctx.qc_type != 0 && qp_ctx.qc_type != 1)
> +			return -EINVAL;
> +
> +		qm_set_sqctype(q, qp_ctx.qc_type);
> +		qp_ctx.id = qp->qp_id;
> +
> +		if (copy_to_user((void __user *)arg, &qp_ctx,
> +				 sizeof(struct hisi_qp_ctx)))
> +			return -EFAULT;
> +	} else {
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static struct uacce_ops uacce_qm_ops = {
> +	.get_available_instances = hisi_qm_get_available_instances,
> +	.get_queue = hisi_qm_uacce_get_queue,
> +	.put_queue = hisi_qm_uacce_put_queue,
> +	.start_queue = hisi_qm_uacce_start_queue,
> +	.stop_queue = hisi_qm_uacce_stop_queue,
> +	.mmap = hisi_qm_uacce_mmap,
> +	.ioctl = hisi_qm_uacce_ioctl,
> +};
> +
> +static int qm_register_uacce(struct hisi_qm *qm)
> +{
> +	struct pci_dev *pdev = qm->pdev;
> +	struct uacce_device *uacce;
> +	unsigned long mmio_page_nr;
> +	unsigned long dus_page_nr;
> +	struct uacce_interface interface = {
> +		.flags = UACCE_DEV_SVA,
> +		.ops = &uacce_qm_ops,
> +	};
> +
> +	strncpy(interface.name, pdev->driver->name, sizeof(interface.name));
> +
> +	uacce = uacce_register(&pdev->dev, &interface);
> +	if (IS_ERR(uacce))
> +		return PTR_ERR(uacce);

Is there a potential race here as we have exposed the character device before
the driver is ready for it to be used?  Probably need to split the code that
allocates a uacce interface from the bit that actually exposes it to userspace.

> +
> +	if (uacce->flags & UACCE_DEV_SVA) {
> +		qm->use_sva = true;
> +	} else {
> +		/* only consider sva case */
> +		uacce_unregister(uacce);
> +		return -EINVAL;
> +	}
> +
> +	uacce->is_vf = pdev->is_virtfn;
> +	uacce->priv = qm;
> +	uacce->algs = qm->algs;
> +
> +	if (qm->ver == QM_HW_V1) {
> +		mmio_page_nr = QM_DOORBELL_PAGE_NR;
> +		uacce->api_ver = HISI_QM_API_VER_BASE;
> +	} else {
> +		mmio_page_nr = QM_DOORBELL_PAGE_NR +
> +			QM_DOORBELL_SQ_CQ_BASE_V2 / PAGE_SIZE;
> +		uacce->api_ver = HISI_QM_API_VER2_BASE;
> +	}
> +
> +	dus_page_nr = (PAGE_SIZE - 1 + qm->sqe_size * QM_Q_DEPTH +
> +		       sizeof(struct qm_cqe) * QM_Q_DEPTH) >> PAGE_SHIFT;
> +
> +	uacce->qf_pg_size[UACCE_QFRT_MMIO] = mmio_page_nr;
> +	uacce->qf_pg_size[UACCE_QFRT_DUS]  = dus_page_nr;
> +
> +	qm->uacce = uacce;
> +
> +	return 0;
> +}
> +
>  /**
>   * hisi_qm_init() - Initialize configures about qm.
>   * @qm: The qm needing init.
> @@ -1421,6 +1643,10 @@ int hisi_qm_init(struct hisi_qm *qm)
>  		return -EINVAL;
>  	}
>  
> +	ret = qm_register_uacce(qm);
> +	if (ret < 0)
> +		dev_warn(&pdev->dev, "fail to register uacce (%d)\n", ret);
> +

looks like there are error paths in qm_init in which we should call
the uacce_unregister?

>  	ret = pci_enable_device_mem(pdev);
>  	if (ret < 0) {
>  		dev_err(&pdev->dev, "Failed to enable device mem!\n");
> @@ -1433,6 +1659,8 @@ int hisi_qm_init(struct hisi_qm *qm)
>  		goto err_disable_pcidev;
>  	}
>  
> +	qm->phys_base = pci_resource_start(pdev, PCI_BAR_2);
> +	qm->size = pci_resource_len(qm->pdev, PCI_BAR_2);
>  	qm->io_base = ioremap(pci_resource_start(pdev, PCI_BAR_2),
>  			      pci_resource_len(qm->pdev, PCI_BAR_2));

Use qm->phys_base/size in the ioremap here to avoid repeating the code.

>  	if (!qm->io_base) {
> @@ -1504,6 +1732,9 @@ void hisi_qm_uninit(struct hisi_qm *qm)
>  	iounmap(qm->io_base);
>  	pci_release_mem_regions(pdev);
>  	pci_disable_device(pdev);
> +
> +	if (qm->uacce)
> +		uacce_unregister(qm->uacce);

Can we make uacce_unregister check the input?
Might make for cleaner users.

>  }
>  EXPORT_SYMBOL_GPL(hisi_qm_uninit);
>  
> diff --git a/drivers/crypto/hisilicon/qm.h b/drivers/crypto/hisilicon/qm.h
> index 103e2fd..84a3be9 100644
> --- a/drivers/crypto/hisilicon/qm.h
> +++ b/drivers/crypto/hisilicon/qm.h
> @@ -77,6 +77,10 @@
>  
>  #define HISI_ACC_SGL_SGE_NR_MAX		255
>  
> +/* page number for queue file region */
> +#define QM_DOORBELL_PAGE_NR		1
> +

1 blank line only is almost always enough.

> +
>  enum qp_state {
>  	QP_STOP,
>  };
> @@ -161,7 +165,12 @@ struct hisi_qm {
>  	u32 error_mask;
>  	u32 msi_mask;
>  
> +	const char *algs;
>  	bool use_dma_api;
> +	bool use_sva;
> +	resource_size_t phys_base;
> +	resource_size_t size;
> +	struct uacce_device *uacce;
>  };
>  
>  struct hisi_qp_status {
> @@ -191,10 +200,12 @@ struct hisi_qp {
>  	struct hisi_qp_ops *hw_ops;
>  	void *qp_ctx;
>  	void (*req_cb)(struct hisi_qp *qp, void *data);
> +	void (*event_cb)(struct hisi_qp *qp);
>  	struct work_struct work;
>  	struct workqueue_struct *wq;
> -

unrelated change.

>  	struct hisi_qm *qm;
> +	u16 pasid;
> +	struct uacce_queue *uacce_q;
>  };
>  
>  int hisi_qm_init(struct hisi_qm *qm);
> diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
> index 1b2ee96..48860d2 100644
> --- a/drivers/crypto/hisilicon/zip/zip_main.c
> +++ b/drivers/crypto/hisilicon/zip/zip_main.c
> @@ -316,8 +316,14 @@ static void hisi_zip_set_user_domain_and_cache(struct hisi_zip *hisi_zip)
>  	writel(AXUSER_BASE, base + HZIP_BD_RUSER_32_63);
>  	writel(AXUSER_BASE, base + HZIP_SGL_RUSER_32_63);
>  	writel(AXUSER_BASE, base + HZIP_BD_WUSER_32_63);
> -	writel(AXUSER_BASE, base + HZIP_DATA_RUSER_32_63);
> -	writel(AXUSER_BASE, base + HZIP_DATA_WUSER_32_63);
> +
> +	if (hisi_zip->qm.use_sva) {
> +		writel(AXUSER_BASE | AXUSER_SSV, base + HZIP_DATA_RUSER_32_63);
> +		writel(AXUSER_BASE | AXUSER_SSV, base + HZIP_DATA_WUSER_32_63);
> +	} else {
> +		writel(AXUSER_BASE, base + HZIP_DATA_RUSER_32_63);
> +		writel(AXUSER_BASE, base + HZIP_DATA_WUSER_32_63);
> +	}
>  
>  	/* let's open all compression/decompression cores */
>  	writel(DECOMP_CHECK_ENABLE | ALL_COMP_DECOMP_EN,
> @@ -671,24 +677,12 @@ static int hisi_zip_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	qm = &hisi_zip->qm;
>  	qm->pdev = pdev;
>  	qm->ver = rev_id;
> -

Try to avoid noise from white space changes.  No huge help to delete the blank line here.

> +	qm->use_dma_api = true;
> +	qm->algs = "zlib\ngzip\n";
>  	qm->sqe_size = HZIP_SQE_SIZE;
>  	qm->dev_name = hisi_zip_name;
>  	qm->fun_type = (pdev->device == PCI_DEVICE_ID_ZIP_PF) ? QM_HW_PF :
>  								QM_HW_VF;

Unrelated changes I think.  Can we clean out the old left overs
of uacce from the driver in a precursor patch? Also if it's no longer
used can we drop the module param?

> -	switch (uacce_mode) {
> -	case 0:
> -		qm->use_dma_api = true;
> -		break;
> -	case 1:
> -		qm->use_dma_api = false;
> -		break;
> -	case 2:
> -		qm->use_dma_api = true;
> -		break;
> -	default:
> -		return -EINVAL;
> -	}
>  
>  	ret = hisi_qm_init(qm);
>  	if (ret) {
> @@ -976,12 +970,10 @@ static int __init hisi_zip_init(void)
>  		goto err_pci;
>  	}
>  
> -	if (uacce_mode == 0 || uacce_mode == 2) {
> -		ret = hisi_zip_register_to_crypto();
> -		if (ret < 0) {
> -			pr_err("Failed to register driver to crypto.\n");
> -			goto err_crypto;
> -		}
> +	ret = hisi_zip_register_to_crypto();
> +	if (ret < 0) {
> +		pr_err("Failed to register driver to crypto.\n");
> +		goto err_crypto;
>  	}
>  
>  	return 0;
> @@ -996,8 +988,7 @@ static int __init hisi_zip_init(void)
>  
>  static void __exit hisi_zip_exit(void)
>  {
> -	if (uacce_mode == 0 || uacce_mode == 2)
> -		hisi_zip_unregister_from_crypto();
> +	hisi_zip_unregister_from_crypto();



>  	pci_unregister_driver(&hisi_zip_pci_driver);
>  	hisi_zip_unregister_debugfs();
>  }
> diff --git a/include/uapi/misc/uacce/qm.h b/include/uapi/misc/uacce/qm.h
> new file mode 100644
> index 0000000..d79a8f2
> --- /dev/null
> +++ b/include/uapi/misc/uacce/qm.h
Given generic directory (assuming uacce becomes heavily used) probably
want to prefix that if it is unique to hisilicon.

hisi_qm.h?

> @@ -0,0 +1,23 @@
> +/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
> +#ifndef HISI_QM_USR_IF_H
> +#define HISI_QM_USR_IF_H
> +
> +#include <linux/types.h>
> +
> +/**
> + * struct hisi_qp_ctx - User data for hisi qp.
> + * @id: Specifies which Turbo decode algorithm to use

What's a Turbo algorithm?  I don't know and I have the manuals ;)

> + * @qc_type: Accelerator algorithm type
> + */
> +struct hisi_qp_ctx {
> +	__u16 id;
> +	__u16 qc_type;
> +};
> +
> +#define HISI_QM_API_VER_BASE "hisi_qm_v1"
> +#define HISI_QM_API_VER2_BASE "hisi_qm_v2"
> +
> +/* UACCE_CMD_QM_SET_QP_CTX: Set qp algorithm type */
> +#define UACCE_CMD_QM_SET_QP_CTX	_IOWR('H', 10, struct hisi_qp_ctx)
> +
> +#endif


