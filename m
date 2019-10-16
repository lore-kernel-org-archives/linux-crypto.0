Return-Path: <SRS0=0DWe=YJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA122FA3728
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 17:28:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85FB42082C
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 17:28:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="V4ottE6w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730061AbfJPR2J (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Oct 2019 13:28:09 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35397 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728773AbfJPR2J (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Oct 2019 13:28:09 -0400
Received: by mail-wm1-f67.google.com with SMTP id y21so3671193wmi.0
        for <linux-crypto@vger.kernel.org>; Wed, 16 Oct 2019 10:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+xEFDfh2hL66ZXFwcJ6+Ej1LhU3aeAdnAEouDJebaJE=;
        b=V4ottE6wcLTR+fRayJjG5ZFBdmVThyl79xP1O87h9e2UGhE2ummZPWPi6c3RcvHRIq
         jliIoMGIc7AEwxkTMhlbaZloAickfU6lyxatgHHzwaEnJfQsAXKenGqIZaKtWA2QpzfZ
         sjyVTtQYOTxZBhU7bQPZMAvBqWrxRESu6Ily6Jj1C7M/KLWjwiUe8z3WJIuUTtpd4zqP
         fomjT9x5hNhx8m8lwb2c8KuYx1kz5D2A91IpS1aGH+zVlLcRmUahXxKjPTsOIkowUYmI
         IAAge8a+VSG5tIWLjC03qOKZLiKH/YthgqWX5hYVnF+F3T/MwwXdcpFN1W+ifv92NV0t
         BlZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+xEFDfh2hL66ZXFwcJ6+Ej1LhU3aeAdnAEouDJebaJE=;
        b=DOh19usri1uY39Dm8qsTXoI9EHUvFjiinG34DQy+Af0nTeQXV1STnlGyBeYmpk1/yn
         rFSqhVe7xmiqaYkwXLkX5dDe/yah2bu4jwDiQBWfaGruEUzhKY6jEKFvfC0ZMLDRChsF
         onTzxbcHMhRI7Ybfp4dXvwUaAlxu6qalmJxoXj46UjkehzIcV8XcqZsUg5v4jPn7EACO
         uocmSLlU3RKflz3h5N+Uyy1tdh21HWQ3M3BryQVFj/HD+2vGY26OUJe3e2QobdJ9tsnI
         Omi82R8o4Hh9ocYBur+Zz9egsAlVl7hNKx0qyj+ZPtBA5okmVxhaQllE3D4/4uN8coad
         9oPQ==
X-Gm-Message-State: APjAAAUvKjsmmIvd1LLYrPlyKOscc+qmFIV9nUC+0GyFJrRrvZY/zIP1
        toP2yEOOkwLx71dI1sNHE+pZIw==
X-Google-Smtp-Source: APXvYqz6gPi14XcbzWrKp2vXQpDRSLun+KWTYD45l4Ny++Oi68Jj1tYHYuh9VtvvkuLb5wbUGJJNEQ==
X-Received: by 2002:a7b:c08e:: with SMTP id r14mr4230952wmh.118.1571246885411;
        Wed, 16 Oct 2019 10:28:05 -0700 (PDT)
Received: from lophozonia ([85.195.192.192])
        by smtp.gmail.com with ESMTPSA id y11sm2354361wrp.44.2019.10.16.10.28.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 10:28:04 -0700 (PDT)
Date:   Wed, 16 Oct 2019 19:28:02 +0200
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Zhangfei Gao <zhangfei.gao@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        jonathan.cameron@huawei.com, grant.likely@arm.com,
        ilias.apalodimas@linaro.org, francois.ozog@linaro.org,
        kenneth-lee-2012@foxmail.com, Wangzhou <wangzhou1@hisilicon.com>,
        "haojian . zhuang" <haojian.zhuang@linaro.org>,
        linux-accelerators@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, Kenneth Lee <liguozhu@hisilicon.com>,
        Zaibo Xu <xuzaibo@huawei.com>
Subject: Re: [PATCH v6 2/3] uacce: add uacce driver
Message-ID: <20191016172802.GA1533448@lophozonia>
References: <1571214873-27359-1-git-send-email-zhangfei.gao@linaro.org>
 <1571214873-27359-3-git-send-email-zhangfei.gao@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571214873-27359-3-git-send-email-zhangfei.gao@linaro.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

I have a few comments on the overall design and some implementation
details below.

Could you also Cc iommu@lists.linux-foundation.org on your next posting?
I'm sure some subscribers would be interested and I don't think many
people know about linux-accelerators yet.

On Wed, Oct 16, 2019 at 04:34:32PM +0800, Zhangfei Gao wrote:
> diff --git a/Documentation/ABI/testing/sysfs-driver-uacce b/Documentation/ABI/testing/sysfs-driver-uacce
> new file mode 100644
> index 0000000..e48333c
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-driver-uacce
> @@ -0,0 +1,65 @@
> +What:           /sys/class/uacce/hisi_zip-<n>/id

Should probably be /sys/class/uacce/<dev_name>/ if we want the API to be
used by other drivers.

[...]
> +static int uacce_queue_map_qfr(struct uacce_queue *q,
> +			       struct uacce_qfile_region *qfr)
> +{
> +	struct device *dev = q->uacce->pdev;
> +	struct iommu_domain *domain = iommu_get_domain_for_dev(dev);
> +	int i, j, ret;
> +
> +	if (!(qfr->flags & UACCE_QFRF_MAP) || (qfr->flags & UACCE_QFRF_DMA))
> +		return 0;
> +
> +	if (!domain)
> +		return -ENODEV;
> +
> +	for (i = 0; i < qfr->nr_pages; i++) {
> +		ret = iommu_map(domain, qfr->iova + i * PAGE_SIZE,
> +				page_to_phys(qfr->pages[i]),
> +				PAGE_SIZE, qfr->prot | q->uacce->prot);
> +		if (ret)
> +			goto err_with_map_pages;
> +
> +		get_page(qfr->pages[i]);

I guess we need this reference when coming from UACCE_CMD_SHARE_SVAS?
Otherwise we should already get one from alloc_page().

[...]
> +static int uacce_qfr_alloc_pages(struct uacce_qfile_region *qfr)
> +{
> +	int i, j;
> +
> +	qfr->pages = kcalloc(qfr->nr_pages, sizeof(*qfr->pages), GFP_ATOMIC);

Why GFP_ATOMIC and not GFP_KERNEL?  GFP_ATOMIC is used all over this file
but there doesn't seem to be any non-sleepable context.

> +	if (!qfr->pages)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < qfr->nr_pages; i++) {
> +		qfr->pages[i] = alloc_page(GFP_ATOMIC | __GFP_ZERO);

Is it worth copying __iommu_dma_alloc_pages() here - using
alloc_pages_node() to allocate memory close to the device and to allocate
compound pages if possible?

Also, do we need GFP_USER here?


More generally, it would be nice to use the DMA API when SVA isn't
supported, instead of manually allocating and mapping memory with
iommu_map(). Do we only handcraft these functions in order to have VA ==
IOVA?  On its own it doesn't seem like a strong enough reason to avoid the
DMA API.

SVA simplifies DMA memory management and enables core mm features for DMA
such as demand paging. VA == IOVA is just a natural consequence. But in
the !SVA mode, the userspace library does need to create DMA mappings
itself. So, since it has special cases for !SVA, it could easily get the
IOVA of a DMA buffer from the kernel using another ioctl.

[...]
> +static struct uacce_qfile_region *
> +uacce_create_region(struct uacce_queue *q, struct vm_area_struct *vma,
> +		    enum uacce_qfrt type, unsigned int flags)
> +{
> +	struct uacce_qfile_region *qfr;
> +	struct uacce_device *uacce = q->uacce;
> +	unsigned long vm_pgoff;
> +	int ret = -ENOMEM;
> +
> +	qfr = kzalloc(sizeof(*qfr), GFP_ATOMIC);
> +	if (!qfr)
> +		return ERR_PTR(-ENOMEM);
> +
> +	qfr->type = type;
> +	qfr->flags = flags;
> +	qfr->iova = vma->vm_start;
> +	qfr->nr_pages = vma_pages(vma);
> +
> +	if (vma->vm_flags & VM_READ)
> +		qfr->prot |= IOMMU_READ;
> +
> +	if (vma->vm_flags & VM_WRITE)
> +		qfr->prot |= IOMMU_WRITE;
> +
> +	if (flags & UACCE_QFRF_SELFMT) {
> +		if (!uacce->ops->mmap) {
> +			ret = -EINVAL;
> +			goto err_with_qfr;
> +		}
> +
> +		ret = uacce->ops->mmap(q, vma, qfr);
> +		if (ret)
> +			goto err_with_qfr;
> +		return qfr;
> +	}

I wish the SVA and !SVA paths were less interleaved. Both models are
fundamentally different:

* Without SVA you cannot share the device between multiple processes. All
  DMA mappings are in the "main", non-PASID address space of the device.

  Note that process isolation without SVA could be achieved with the
  auxiliary domains IOMMU API (introduced primarily for vfio-mdev) but
  this is not the model chosen here.

* With SVA you can share the device between multiple processes. But if the
  process can somehow program its portion of the device to access the main
  address space, you loose isolation. Only the kernel must be able to
  program and access the main address space.

When interleaving both code paths it's easy to make a mistake and loose
this isolation. Although I think this code is correct, it took me some
time to understand that we never end up calling dma_alloc or iommu_map
when using SVA. Might be worth at least adding a check that if
UACCE_DEV_SVA, then we never end up in the bottom part of this function.

> +
> +	/* allocate memory */
> +	if (flags & UACCE_QFRF_DMA) {

At the moment UACCE_QFRF_DMA is never set, so there is a lot of unused and
possibly untested code in this file. I think it would be simpler to choose
between either DMA API or unmanaged IOMMU domains and stick with it. As
said before, I'd prefer DMA API.

> +		qfr->kaddr = dma_alloc_coherent(uacce->pdev,
> +						qfr->nr_pages << PAGE_SHIFT,
> +						&qfr->dma, GFP_KERNEL);
> +		if (!qfr->kaddr) {
> +			ret = -ENOMEM;
> +			goto err_with_qfr;
> +		}
> +	} else {
> +		ret = uacce_qfr_alloc_pages(qfr);
> +		if (ret)
> +			goto err_with_qfr;
> +	}
> +
> +	/* map to device */
> +	ret = uacce_queue_map_qfr(q, qfr);

Worth moving into the else above.

[...]
> +static long uacce_cmd_share_qfr(struct uacce_queue *tgt, int fd)
> +{
> +	struct file *filep;
> +	struct uacce_queue *src;
> +	int ret = -EINVAL;
> +
> +	mutex_lock(&uacce_mutex);
> +
> +	if (tgt->state != UACCE_Q_STARTED)
> +		goto out_with_lock;
> +
> +	filep = fget(fd);
> +	if (!filep)
> +		goto out_with_lock;
> +
> +	if (filep->f_op != &uacce_fops)
> +		goto out_with_fd;
> +
> +	src = filep->private_data;
> +	if (!src)
> +		goto out_with_fd;
> +
> +	if (tgt->uacce->flags & UACCE_DEV_SVA)
> +		goto out_with_fd;
> +
> +	if (!src->qfrs[UACCE_QFRT_SS] || tgt->qfrs[UACCE_QFRT_SS])
> +		goto out_with_fd;
> +
> +	ret = uacce_queue_map_qfr(tgt, src->qfrs[UACCE_QFRT_SS]);

I don't understand what this ioctl does. The function duplicates the
static mappings from one queue to another, right?  But static mappings are
a !SVA thing and currently on !SVA a single queue can be opened at a time.
In addition, unless the two queues belong to different devices, they would
share the same IOMMU domain and the mappings would already exist, so you
don't need to call uacce_queue_map_qfr() again.

[...]
> +static long uacce_put_queue(struct uacce_queue *q)
> +{
> +	struct uacce_device *uacce = q->uacce;
> +
> +	mutex_lock(&uacce_mutex);
> +
> +	if ((q->state == UACCE_Q_STARTED) && uacce->ops->stop_queue)
> +		uacce->ops->stop_queue(q);
> +
> +	if ((q->state == UACCE_Q_INIT || q->state == UACCE_Q_STARTED) &&
> +	     uacce->ops->put_queue)
> +		uacce->ops->put_queue(q);
> +
> +	q->state = UACCE_Q_ZOMBIE;

Since the PUT_Q ioctl makes the queue unrecoverable, why should userspace
invoke it instead of immediately calling close()?

[...]
> +static int uacce_dev_open_check(struct uacce_device *uacce)
> +{
> +	if (uacce->flags & UACCE_DEV_SVA)
> +		return 0;
> +
> +	/*
> +	 * The device can be opened once if it does not support pasid
> +	 */
> +	if (kref_read(&uacce->cdev->kobj.kref) > 2)

Why 2?  It doesn't feel right to access the cdev internals for this, could
we just have a ref uacce->opened for this purpose?

> +		return -EBUSY;
> +
> +	return 0;
> +}
> +
> +static int uacce_fops_open(struct inode *inode, struct file *filep)
> +{
> +	struct uacce_queue *q;
> +	struct iommu_sva *handle = NULL;
> +	struct uacce_device *uacce;
> +	int ret;
> +	int pasid = 0;
> +
> +	uacce = idr_find(&uacce_idr, iminor(inode));
> +	if (!uacce)
> +		return -ENODEV;
> +
> +	if (!try_module_get(uacce->pdev->driver->owner))
> +		return -ENODEV;
> +
> +	ret = uacce_dev_open_check(uacce);
> +	if (ret)
> +		goto out_with_module;
> +
> +	if (uacce->flags & UACCE_DEV_SVA) {
> +		handle = iommu_sva_bind_device(uacce->pdev, current->mm, NULL);
> +		if (IS_ERR(handle))
> +			goto out_with_module;
> +		pasid = iommu_sva_get_pasid(handle);

We need to register an mm_exit callback. Once we return, userspace will
start running jobs on the accelerator. If the process is killed while the
accelerator is running, the mm_exit callback tells the device driver to
stop using this PASID (stop_queue()), so that it can be reallocated for
another process.

Implementing this with the right locking and ordering can be tricky. I'll
try to implement the callback and test it on the device this week.

[...]
> +static int uacce_fops_mmap(struct file *filep, struct vm_area_struct *vma)
> +{
> +	struct uacce_queue *q = filep->private_data;
> +	struct uacce_device *uacce = q->uacce;
> +	struct uacce_qfile_region *qfr;
> +	enum uacce_qfrt type = 0;
> +	unsigned int flags = 0;
> +	int ret;
> +
> +	if (vma->vm_pgoff < UACCE_QFRT_MAX)
> +		type = vma->vm_pgoff;
> +
> +	vma->vm_flags |= VM_DONTCOPY | VM_DONTEXPAND;
> +
> +	mutex_lock(&uacce_mutex);
> +
> +	/* fixme: if the region need no pages, we don't need to check it */
> +	if (q->mm->data_vm + vma_pages(vma) >
> +	    rlimit(RLIMIT_DATA) >> PAGE_SHIFT) {

Doesn't may_expand_vm() do the job already?

> +		ret = -ENOMEM;
> +		goto out_with_lock;
> +	}
> +
> +	if (q->qfrs[type]) {
> +		ret = -EBUSY;
> +		goto out_with_lock;
> +	}
> +
> +	switch (type) {
> +	case UACCE_QFRT_MMIO:
> +		flags = UACCE_QFRF_SELFMT;
> +		break;
> +
> +	case UACCE_QFRT_SS:
> +		if (q->state != UACCE_Q_STARTED) {
> +			ret = -EINVAL;
> +			goto out_with_lock;
> +		}
> +
> +		if (uacce->flags & UACCE_DEV_SVA) {
> +			ret = -EINVAL;
> +			goto out_with_lock;
> +		}
> +
> +		flags = UACCE_QFRF_MAP | UACCE_QFRF_MMAP;
> +
> +		break;
> +
> +	case UACCE_QFRT_DKO:
> +		if (uacce->flags & UACCE_DEV_SVA) {
> +			ret = -EINVAL;
> +			goto out_with_lock;
> +		}
> +
> +		flags = UACCE_QFRF_MAP | UACCE_QFRF_KMAP;
> +
> +		break;
> +
> +	case UACCE_QFRT_DUS:
> +		if (uacce->flags & UACCE_DEV_SVA) {
> +			flags = UACCE_QFRF_SELFMT;
> +			break;
> +		}
> +
> +		flags = UACCE_QFRF_MAP | UACCE_QFRF_MMAP;
> +		break;
> +
> +	default:
> +		WARN_ON(&uacce->dev);
> +		break;
> +	}
> +
> +	qfr = uacce_create_region(q, vma, type, flags);

Don't we need to setup a a vma->vm_ops->close callback, to remove this
region on munmap()?

> +	if (IS_ERR(qfr)) {
> +		ret = PTR_ERR(qfr);
> +		goto out_with_lock;
> +	}
> +	q->qfrs[type] = qfr;
> +
> +	if (type == UACCE_QFRT_SS) {
> +		INIT_LIST_HEAD(&qfr->qs);
> +		list_add(&q->list, &q->qfrs[type]->qs);
> +	}
> +
> +	mutex_unlock(&uacce_mutex);
> +
> +	if (qfr->pages)
> +		q->mm->data_vm += qfr->nr_pages;

This too should be done by the core already.

[...]
> +/* Borrowed from VFIO to fix msi translation */
> +static bool uacce_iommu_has_sw_msi(struct iommu_group *group,

Sharing the same functions would be nicer.

[...]
> +struct uacce_device *uacce_register(struct device *parent,
> +				    struct uacce_interface *interface)
> +{
> +	int ret;
> +	struct uacce_device *uacce;
> +	unsigned int flags = interface->flags;
> +
> +	uacce = kzalloc(sizeof(struct uacce_device), GFP_KERNEL);
> +	if (!uacce)
> +		return ERR_PTR(-ENOMEM);
> +
> +	if (flags & UACCE_DEV_SVA) {
> +		ret = iommu_dev_enable_feature(parent, IOMMU_DEV_FEAT_SVA);
> +		if (ret)
> +			flags &= ~UACCE_DEV_SVA;
> +	}
> +
> +	uacce->pdev = parent;
> +	uacce->flags = flags;
> +	uacce->ops = interface->ops;
> +
> +	ret = uacce_set_iommu_domain(uacce);
> +	if (ret)
> +		goto err_free;
> +
> +	mutex_lock(&uacce_mutex);
> +
> +	ret = idr_alloc(&uacce_idr, uacce, 0, 0, GFP_KERNEL);
> +	if (ret < 0)
> +		goto err_with_lock;
> +
> +	uacce->cdev = cdev_alloc();

Need to check the return value.

> +	uacce->cdev->ops = &uacce_fops;
> +	uacce->dev_id = ret;
> +	uacce->cdev->owner = THIS_MODULE;
> +	device_initialize(&uacce->dev);
> +	uacce->dev.devt = MKDEV(MAJOR(uacce_devt), uacce->dev_id);
> +	uacce->dev.class = uacce_class;
> +	uacce->dev.groups = uacce_dev_groups;
> +	uacce->dev.parent = uacce->pdev;
> +	uacce->dev.release = uacce_release;
> +	dev_set_name(&uacce->dev, "%s-%d", interface->name, uacce->dev_id);
> +	ret = cdev_device_add(uacce->cdev, &uacce->dev);
> +	if (ret)
> +		goto err_with_idr;
> +
> +	mutex_unlock(&uacce_mutex);

We published the new device into /dev/ and /sys/ even though the uacce
structure has yet to be completed by the caller (for example qf_pg_size,
api_ver, etc). Maybe we can add an initializer to uacce_ops so we can
publish a complete structure?

> +
> +	return uacce;
> +
> +err_with_idr:
> +	idr_remove(&uacce_idr, uacce->dev_id);
> +err_with_lock:
> +	mutex_unlock(&uacce_mutex);
> +	uacce_unset_iommu_domain(uacce);
> +err_free:
> +	if (flags & UACCE_DEV_SVA)
> +		iommu_dev_disable_feature(uacce->pdev, IOMMU_DEV_FEAT_SVA);
> +	kfree(uacce);
> +	return ERR_PTR(ret);
> +}
> +EXPORT_SYMBOL_GPL(uacce_register);
> +
> +/**
> + * uacce_unregister - unregisters an accelerator
> + * @uacce: the accelerator to unregister
> + */
> +void uacce_unregister(struct uacce_device *uacce)
> +{
> +	if (uacce == NULL)
> +		return;
> +
> +	mutex_lock(&uacce_mutex);

Are we certain that no open queue remains?

> +
> +	if (uacce->flags & UACCE_DEV_SVA)
> +		iommu_dev_disable_feature(uacce->pdev, IOMMU_DEV_FEAT_SVA);
> +
> +	uacce_unset_iommu_domain(uacce);
> +	cdev_device_del(uacce->cdev, &uacce->dev);
> +	idr_remove(&uacce_idr, uacce->dev_id);
> +	put_device(&uacce->dev);
> +
> +	mutex_unlock(&uacce_mutex);
> +}
> +EXPORT_SYMBOL_GPL(uacce_unregister);

> diff --git a/include/uapi/misc/uacce/uacce.h b/include/uapi/misc/uacce/uacce.h
> new file mode 100644
> index 0000000..c859668
> --- /dev/null
> +++ b/include/uapi/misc/uacce/uacce.h
> @@ -0,0 +1,41 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */

Needs to be 
/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */

Otherwise headers_install.sh complains on v5.4 (same for the qm UAPI in
patch 3)

> +#ifndef _UAPIUUACCE_H
> +#define _UAPIUUACCE_H
> +
> +#include <linux/types.h>
> +#include <linux/ioctl.h>
> +
> +#define UACCE_CMD_SHARE_SVAS	_IO('W', 0)
> +#define UACCE_CMD_START		_IO('W', 1)
> +#define UACCE_CMD_PUT_Q		_IO('W', 2)

These must be documented.

> +
> +/**
> + * enum uacce_dev_flag: Device flags:
> + * @UACCE_DEV_SHARE_DOMAIN: no PASID, can share sva for one process
> + * @UACCE_DEV_SVA: Shared Virtual Addresses
> + *		   Support PASID
> + *		   Support device page fault (pcie device) or
> + *		   smmu stall (platform device)

Both stall and PRI are device page faults, so this could say "Support
device page faults (PCI PRI or SMMU Stall)".

> + */
> +enum uacce_dev_flag {
> +	UACCE_DEV_SHARE_DOMAIN = 0x0,
> +	UACCE_DEV_SVA = 0x1,
> +};

This is a bitmap so UACCE_DEV_SHARE_DOMAIN will loose its meaning when
adding a new flag. There will be:

	UACCE_DEV_SVA		= 1 << 0,
	UACCE_DEV_NEWFEATURE	= 1 << 1,

Then a value of zero will simply mean "no special feature". I think we
could simply remove UACCE_DEV_SHARE_DOMAIN now, it's not used.

Thanks,
Jean
