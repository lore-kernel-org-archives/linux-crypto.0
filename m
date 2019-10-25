Return-Path: <SRS0=9dQ/=YS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84FF6CA9EA0
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 07:01:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 359EB21929
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 07:01:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kHYl8R+m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405965AbfJYHBq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Oct 2019 03:01:46 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42831 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405865AbfJYHBq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Oct 2019 03:01:46 -0400
Received: by mail-pg1-f196.google.com with SMTP id f14so906032pgi.9
        for <linux-crypto@vger.kernel.org>; Fri, 25 Oct 2019 00:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=df5H3gWd6bMVT6+iRHB/O4hETaq4rWDF8wisypECGHk=;
        b=kHYl8R+mhjuK82PSWamwJ/RaUujtvZkRMj7YP2ivOFt0bWbBr+ka4WrkNX6uKZGpEG
         10dWskhnYAPCUai3Da4TJl3cFlKykOGbk7OnPzuVUKndq8kdCctVLrNzWHex/KUiVPQj
         JvEaXS2A6tKX9z89FOBL5SfmCBtH2e/zGJGKwKtr0Y/0yJlQk8SpRbvt6UTnQV0raxlu
         vN8eX+6cHlpVJLxYA38q+/HrBsCt+ErMIkUWEam0V3sSsC81GACSv//8D5ACZWiMz9Aa
         9312u6N9j5VZ9VhYRFspVDKTgelko0QlA0zhS9bz3daHL7JQmrvLK7zdyaUQ/veciEpQ
         /dcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=df5H3gWd6bMVT6+iRHB/O4hETaq4rWDF8wisypECGHk=;
        b=hSht3LDm/uzJvNFXz3jNOHgRDcXBB9M0hJIF+fSNOEIkyH14I7KtupUOM9kmZQOL9H
         aRiQlVVV29VXBDalxSPGlbvJ5AJptGMfVS8UrK/EGNVU6gP6hf8iqlosTLJVGgxx5AK0
         ER2wWtgDVtCKawHp86OLrmLl65DZT4mYXggqBDbvBaUoATR7JWv/8l1WmNlJSC2grrMc
         GGFy8DcjV2pSkoLD6Tf5dNlF5+XUBsFXnYQVXOqXtWMxjjpZztQAQ8GwcsMMlhzvquiX
         udeGmkEjw2Zykt8A2WiuNfvYze3mJZ5tDEWLDsOrlnu/uGyJokPd6XAs3l3byooZOoQx
         uJnQ==
X-Gm-Message-State: APjAAAUFk5tLXS1Mjy0ajlgbmeXgLtofXAulqDqZYmE41wsqSo+0wdTP
        Yna3hGpA3LilIOCLX8XtEB223g==
X-Google-Smtp-Source: APXvYqzFQu5ro21vE+IIx2DggDLQCJ4D1X5ctrs1u2xHV+iz/4lP5GqewLdO1H3VtmJOc9f9z1gsug==
X-Received: by 2002:a17:90a:fb85:: with SMTP id cp5mr2084658pjb.19.1571986904363;
        Fri, 25 Oct 2019 00:01:44 -0700 (PDT)
Received: from [10.66.2.174] ([85.203.47.184])
        by smtp.gmail.com with ESMTPSA id h68sm1084662pfb.149.2019.10.25.00.01.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Oct 2019 00:01:43 -0700 (PDT)
Subject: Re: [PATCH v6 2/3] uacce: add uacce driver
To:     Jerome Glisse <jglisse@redhat.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        jonathan.cameron@huawei.com, grant.likely@arm.com,
        jean-philippe <jean-philippe@linaro.org>,
        ilias.apalodimas@linaro.org, francois.ozog@linaro.org,
        kenneth-lee-2012@foxmail.com, Wangzhou <wangzhou1@hisilicon.com>,
        "haojian . zhuang" <haojian.zhuang@linaro.org>,
        Zaibo Xu <xuzaibo@huawei.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, Kenneth Lee <liguozhu@hisilicon.com>,
        linux-accelerators@lists.ozlabs.org
References: <1571214873-27359-1-git-send-email-zhangfei.gao@linaro.org>
 <1571214873-27359-3-git-send-email-zhangfei.gao@linaro.org>
 <20191022184929.GC5169@redhat.com>
From:   zhangfei <zhangfei.gao@linaro.org>
Message-ID: <1d019500-4296-27b8-f759-d3dd65b61541@linaro.org>
Date:   Fri, 25 Oct 2019 15:01:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191022184929.GC5169@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi, Jerome

Thanks for the suggestions

On 2019/10/23 上午2:49, Jerome Glisse wrote:
> On Wed, Oct 16, 2019 at 04:34:32PM +0800, Zhangfei Gao wrote:
>> From: Kenneth Lee <liguozhu@hisilicon.com>
>>
>> Uacce (Unified/User-space-access-intended Accelerator Framework) targets to
>> provide Shared Virtual Addressing (SVA) between accelerators and processes.
>> So accelerator can access any data structure of the main cpu.
>> This differs from the data sharing between cpu and io device, which share
>> data content rather than address.
>> Since unified address, hardware and user space of process can share the
>> same virtual address in the communication.
>>
>> Uacce create a chrdev for every registration, the queue is allocated to
>> the process when the chrdev is opened. Then the process can access the
>> hardware resource by interact with the queue file. By mmap the queue
>> file space to user space, the process can directly put requests to the
>> hardware without syscall to the kernel space.
> You need to remove all API that is not use by your first driver as
> it will most likely bit rot without users. It is way better to add
> things when a driver start to make use of it.
>
> I am still not convince of the value of adding a new framework here
> with only a single device as an example. It looks similar to some of
> the fpga devices. Saddly because framework layering is not something
> that exist i guess inventing a new framework is the only answer when
> you can not quite fit into an existing one.
>
> More fundamental question is why do you need to change the IOMMU
> domain of the device ? I do not see any reason for that unless the
> PASID has some restriction on ARM that i do not know of.
>
> I do have multiple comments and point out various serious issues
> below.
>
> As it is from my POV it is a NAK. Note that i am not opposing of
> adding a new framework, just that you need to trim things down
> to what is use by your first driver and you also need to address
> the various issues i point out below.
>
> Cheers,
> Jérôme
>
>> Signed-off-by: Kenneth Lee <liguozhu@hisilicon.com>
>> Signed-off-by: Zaibo Xu <xuzaibo@huawei.com>
>> Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
>> Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
>> ---
>>   Documentation/ABI/testing/sysfs-driver-uacce |  65 ++
>>   drivers/misc/Kconfig                         |   1 +
>>   drivers/misc/Makefile                        |   1 +
>>   drivers/misc/uacce/Kconfig                   |  13 +
>>   drivers/misc/uacce/Makefile                  |   2 +
>>   drivers/misc/uacce/uacce.c                   | 995 +++++++++++++++++++++++++++
>>   include/linux/uacce.h                        | 168 +++++
>>   include/uapi/misc/uacce/uacce.h              |  41 ++
>>   8 files changed, 1286 insertions(+)
>>   create mode 100644 Documentation/ABI/testing/sysfs-driver-uacce
>>   create mode 100644 drivers/misc/uacce/Kconfig
>>   create mode 100644 drivers/misc/uacce/Makefile
>>   create mode 100644 drivers/misc/uacce/uacce.c
>>   create mode 100644 include/linux/uacce.h
>>   create mode 100644 include/uapi/misc/uacce/uacce.h
>>
> [...]
>
>> diff --git a/drivers/misc/uacce/uacce.c b/drivers/misc/uacce/uacce.c
>> new file mode 100644
>> index 0000000..534ddc3
>> --- /dev/null
>> +++ b/drivers/misc/uacce/uacce.c
>> @@ -0,0 +1,995 @@
>> +// SPDX-License-Identifier: GPL-2.0-or-later
>> +#include <linux/compat.h>
>> +#include <linux/dma-iommu.h>
>> +#include <linux/file.h>
>> +#include <linux/irqdomain.h>
>> +#include <linux/module.h>
>> +#include <linux/poll.h>
>> +#include <linux/sched/signal.h>
>> +#include <linux/uacce.h>
>> +
>> +static struct class *uacce_class;
>> +static DEFINE_IDR(uacce_idr);
>> +static dev_t uacce_devt;
>> +static DEFINE_MUTEX(uacce_mutex);
>> +static const struct file_operations uacce_fops;
>> +
>> +static int uacce_queue_map_qfr(struct uacce_queue *q,
>> +			       struct uacce_qfile_region *qfr)
>> +{
>> +	struct device *dev = q->uacce->pdev;
>> +	struct iommu_domain *domain = iommu_get_domain_for_dev(dev);
>> +	int i, j, ret;
>> +
>> +	if (!(qfr->flags & UACCE_QFRF_MAP) || (qfr->flags & UACCE_QFRF_DMA))
>> +		return 0;
>> +
>> +	if (!domain)
>> +		return -ENODEV;
>> +
>> +	for (i = 0; i < qfr->nr_pages; i++) {
>> +		ret = iommu_map(domain, qfr->iova + i * PAGE_SIZE,
>> +				page_to_phys(qfr->pages[i]),
>> +				PAGE_SIZE, qfr->prot | q->uacce->prot);
>> +		if (ret)
>> +			goto err_with_map_pages;
>> +
>> +		get_page(qfr->pages[i]);
>> +	}
>> +
>> +	return 0;
>> +
>> +err_with_map_pages:
>> +	for (j = i - 1; j >= 0; j--) {
>> +		iommu_unmap(domain, qfr->iova + j * PAGE_SIZE, PAGE_SIZE);
>> +		put_page(qfr->pages[j]);
>> +	}
>> +	return ret;
>> +}
>> +
>> +static void uacce_queue_unmap_qfr(struct uacce_queue *q,
>> +				  struct uacce_qfile_region *qfr)
>> +{
>> +	struct device *dev = q->uacce->pdev;
>> +	struct iommu_domain *domain = iommu_get_domain_for_dev(dev);
>> +	int i;
>> +
>> +	if (!domain || !qfr)
>> +		return;
>> +
>> +	if (!(qfr->flags & UACCE_QFRF_MAP) || (qfr->flags & UACCE_QFRF_DMA))
>> +		return;
>> +
>> +	for (i = qfr->nr_pages - 1; i >= 0; i--) {
>> +		iommu_unmap(domain, qfr->iova + i * PAGE_SIZE, PAGE_SIZE);
>> +		put_page(qfr->pages[i]);
>> +	}
>> +}
>> +
>> +static int uacce_qfr_alloc_pages(struct uacce_qfile_region *qfr)
>> +{
>> +	int i, j;
>> +
>> +	qfr->pages = kcalloc(qfr->nr_pages, sizeof(*qfr->pages), GFP_ATOMIC);
>> +	if (!qfr->pages)
>> +		return -ENOMEM;
>> +
>> +	for (i = 0; i < qfr->nr_pages; i++) {
>> +		qfr->pages[i] = alloc_page(GFP_ATOMIC | __GFP_ZERO);
>> +		if (!qfr->pages[i])
>> +			goto err_with_pages;
>> +	}
>> +
>> +	return 0;
>> +
>> +err_with_pages:
>> +	for (j = i - 1; j >= 0; j--)
>> +		put_page(qfr->pages[j]);
>> +
>> +	kfree(qfr->pages);
>> +	return -ENOMEM;
>> +}
>> +
>> +static void uacce_qfr_free_pages(struct uacce_qfile_region *qfr)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < qfr->nr_pages; i++)
>> +		put_page(qfr->pages[i]);
>> +
>> +	kfree(qfr->pages);
>> +}
>> +
>> +static inline int uacce_queue_mmap_qfr(struct uacce_queue *q,
>> +				       struct uacce_qfile_region *qfr,
>> +				       struct vm_area_struct *vma)
>> +{
>> +	int i, ret;
>> +
>> +	for (i = 0; i < qfr->nr_pages; i++) {
>> +		ret = remap_pfn_range(vma, vma->vm_start + (i << PAGE_SHIFT),
>> +				      page_to_pfn(qfr->pages[i]), PAGE_SIZE,
>> +				      vma->vm_page_prot);
>> +		if (ret)
>> +			return ret;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static struct uacce_qfile_region *
>> +uacce_create_region(struct uacce_queue *q, struct vm_area_struct *vma,
>> +		    enum uacce_qfrt type, unsigned int flags)
>> +{
>> +	struct uacce_qfile_region *qfr;
>> +	struct uacce_device *uacce = q->uacce;
>> +	unsigned long vm_pgoff;
>> +	int ret = -ENOMEM;
>> +
>> +	qfr = kzalloc(sizeof(*qfr), GFP_ATOMIC);
>> +	if (!qfr)
>> +		return ERR_PTR(-ENOMEM);
>> +
>> +	qfr->type = type;
>> +	qfr->flags = flags;
>> +	qfr->iova = vma->vm_start;
>> +	qfr->nr_pages = vma_pages(vma);
>> +
>> +	if (vma->vm_flags & VM_READ)
>> +		qfr->prot |= IOMMU_READ;
>> +
>> +	if (vma->vm_flags & VM_WRITE)
>> +		qfr->prot |= IOMMU_WRITE;
>> +
>> +	if (flags & UACCE_QFRF_SELFMT) {
>> +		if (!uacce->ops->mmap) {
>> +			ret = -EINVAL;
>> +			goto err_with_qfr;
>> +		}
>> +
>> +		ret = uacce->ops->mmap(q, vma, qfr);
>> +		if (ret)
>> +			goto err_with_qfr;
>> +		return qfr;
>> +	}
>> +
>> +	/* allocate memory */
>> +	if (flags & UACCE_QFRF_DMA) {
>> +		qfr->kaddr = dma_alloc_coherent(uacce->pdev,
>> +						qfr->nr_pages << PAGE_SHIFT,
>> +						&qfr->dma, GFP_KERNEL);
>> +		if (!qfr->kaddr) {
>> +			ret = -ENOMEM;
>> +			goto err_with_qfr;
>> +		}
>> +	} else {
>> +		ret = uacce_qfr_alloc_pages(qfr);
>> +		if (ret)
>> +			goto err_with_qfr;
>> +	}
>> +
>> +	/* map to device */
>> +	ret = uacce_queue_map_qfr(q, qfr);
>> +	if (ret)
>> +		goto err_with_pages;
>> +
>> +	/* mmap to user space */
>> +	if (flags & UACCE_QFRF_MMAP) {
>> +		if (flags & UACCE_QFRF_DMA) {
>> +			/* dma_mmap_coherent() requires vm_pgoff as 0
>> +			 * restore vm_pfoff to initial value for mmap()
>> +			 */
> I would argue that the dma_mmap_coherent() is not the right function
> to use here you might be better of doing remap_pfn_range() on your
> own.
>
> Working around existing API is not something you want to do, it can
> easily break and it makes it harder for people who want to update that
> API to not break anyone.
Here dma_mmap_coherent is mmap the dma_alloc_coherent,
Will remove dma api first and only consider sva case.
>
>> +			vm_pgoff = vma->vm_pgoff;
>> +			vma->vm_pgoff = 0;
>> +			ret = dma_mmap_coherent(uacce->pdev, vma, qfr->kaddr,
>> +						qfr->dma,
>> +						qfr->nr_pages << PAGE_SHIFT);
>> +			vma->vm_pgoff = vm_pgoff;
>> +		} else {
>> +			ret = uacce_queue_mmap_qfr(q, qfr, vma);
>> +		}
>> +
>> +		if (ret)
>> +			goto err_with_mapped_qfr;
>> +	}
>> +
>> +	return qfr;
>> +
>> +err_with_mapped_qfr:
>> +	uacce_queue_unmap_qfr(q, qfr);
>> +err_with_pages:
>> +	if (flags & UACCE_QFRF_DMA)
>> +		dma_free_coherent(uacce->pdev, qfr->nr_pages << PAGE_SHIFT,
>> +				  qfr->kaddr, qfr->dma);
>> +	else
>> +		uacce_qfr_free_pages(qfr);
>> +err_with_qfr:
>> +	kfree(qfr);
>> +
>> +	return ERR_PTR(ret);
>> +}
>> +
>> +static void uacce_destroy_region(struct uacce_queue *q,
>> +				 struct uacce_qfile_region *qfr)
>> +{
>> +	struct uacce_device *uacce = q->uacce;
>> +
>> +	if (qfr->flags & UACCE_QFRF_DMA) {
>> +		dma_free_coherent(uacce->pdev, qfr->nr_pages << PAGE_SHIFT,
>> +				  qfr->kaddr, qfr->dma);
>> +	} else if (qfr->pages) {
>> +		if (qfr->flags & UACCE_QFRF_KMAP && qfr->kaddr) {
>> +			vunmap(qfr->kaddr);
>> +			qfr->kaddr = NULL;
>> +		}
>> +
>> +		uacce_qfr_free_pages(qfr);
>> +	}
>> +	kfree(qfr);
>> +}
>> +
>> +static long uacce_cmd_share_qfr(struct uacce_queue *tgt, int fd)
> It would be nice to comment what this function does, AFAICT it tries
> to share a region uacce_qfile_region. Anyway this should be remove
> altogether as it is not use by your first driver.
Will only consider sva case in the first patch, and remove this ioctl then.
>
>> +{
>> +	struct file *filep;
>> +	struct uacce_queue *src;
>> +	int ret = -EINVAL;
>> +
>> +	mutex_lock(&uacce_mutex);
>> +
>> +	if (tgt->state != UACCE_Q_STARTED)
>> +		goto out_with_lock;
>> +
>> +	filep = fget(fd);
>> +	if (!filep)
>> +		goto out_with_lock;
>> +
>> +	if (filep->f_op != &uacce_fops)
>> +		goto out_with_fd;
>> +
>> +	src = filep->private_data;
>> +	if (!src)
>> +		goto out_with_fd;
>> +
>> +	if (tgt->uacce->flags & UACCE_DEV_SVA)
>> +		goto out_with_fd;
>> +
>> +	if (!src->qfrs[UACCE_QFRT_SS] || tgt->qfrs[UACCE_QFRT_SS])
>> +		goto out_with_fd;
>> +
>> +	ret = uacce_queue_map_qfr(tgt, src->qfrs[UACCE_QFRT_SS]);
>> +	if (ret)
>> +		goto out_with_fd;
>> +
>> +	tgt->qfrs[UACCE_QFRT_SS] = src->qfrs[UACCE_QFRT_SS];
>> +	list_add(&tgt->list, &src->qfrs[UACCE_QFRT_SS]->qs);
> This list_add() seems bogus as the src->qfrs would already be
> on a list so you are corrupting the list it is on.
>
>> +
>> +out_with_fd:
>> +	fput(filep);
>> +out_with_lock:
>> +	mutex_unlock(&uacce_mutex);
>> +	return ret;
>> +}
> [...]
>
>> +static long uacce_fops_unl_ioctl(struct file *filep,
>> +				 unsigned int cmd, unsigned long arg)
> You need to documents properly all ioctl and also you need to
> remove those that are not use by your first driver. They will
> just bit rot as we do not know if they will ever be use.
OK, understand.
>
>> +{
>> +	struct uacce_queue *q = filep->private_data;
>> +	struct uacce_device *uacce = q->uacce;
>> +
>> +	switch (cmd) {
>> +	case UACCE_CMD_SHARE_SVAS:
>> +		return uacce_cmd_share_qfr(q, arg);
>> +
>> +	case UACCE_CMD_START:
>> +		return uacce_start_queue(q);
>> +
>> +	case UACCE_CMD_PUT_Q:
>> +		return uacce_put_queue(q);
>> +
>> +	default:
>> +		if (!uacce->ops->ioctl)
>> +			return -EINVAL;
>> +
>> +		return uacce->ops->ioctl(q, cmd, arg);
>> +	}
>> +}
>> +
> [...]
>
>> +
>> +static int uacce_dev_open_check(struct uacce_device *uacce)
>> +{
>> +	if (uacce->flags & UACCE_DEV_SVA)
>> +		return 0;
>> +
>> +	/*
>> +	 * The device can be opened once if it does not support pasid
>> +	 */
>> +	if (kref_read(&uacce->cdev->kobj.kref) > 2)
>> +		return -EBUSY;
> You do not check if the device support pasid so comments does not
> match code. Right now code says that you can not open a device more
> than once. Also this check is racy there is no lock protecting the
> read.
Will remove this, though it is atomic.
!sva case does not have such limitation.
>
>> +
>> +	return 0;
>> +}
>> +
>> +static int uacce_fops_open(struct inode *inode, struct file *filep)
>> +{
>> +	struct uacce_queue *q;
>> +	struct iommu_sva *handle = NULL;
>> +	struct uacce_device *uacce;
>> +	int ret;
>> +	int pasid = 0;
>> +
>> +	uacce = idr_find(&uacce_idr, iminor(inode));
>> +	if (!uacce)
>> +		return -ENODEV;
>> +
>> +	if (!try_module_get(uacce->pdev->driver->owner))
>> +		return -ENODEV;
>> +
>> +	ret = uacce_dev_open_check(uacce);
>> +	if (ret)
>> +		goto out_with_module;
>> +
>> +	if (uacce->flags & UACCE_DEV_SVA) {
>> +		handle = iommu_sva_bind_device(uacce->pdev, current->mm, NULL);
>> +		if (IS_ERR(handle))
>> +			goto out_with_module;
>> +		pasid = iommu_sva_get_pasid(handle);
>> +	}
> The file descriptor can outlive the mm (through fork) what happens
> when the mm dies ? Where is the sva_unbind ? Maybe in iommu code.
> At very least a comment should be added explaining what happens.
unbind is in the uacce_fops_release.
Will register mm_exit for sva case.
>
>> +
>> +	q = kzalloc(sizeof(struct uacce_queue), GFP_KERNEL);
>> +	if (!q) {
>> +		ret = -ENOMEM;
>> +		goto out_with_module;
>> +	}
>> +
>> +	if (uacce->ops->get_queue) {
>> +		ret = uacce->ops->get_queue(uacce, pasid, q);
>> +		if (ret < 0)
>> +			goto out_with_mem;
>> +	}
>> +
>> +	q->pasid = pasid;
>> +	q->handle = handle;
>> +	q->uacce = uacce;
>> +	q->mm = current->mm;
>> +	memset(q->qfrs, 0, sizeof(q->qfrs));
>> +	INIT_LIST_HEAD(&q->list);
>> +	init_waitqueue_head(&q->wait);
>> +	filep->private_data = q;
>> +	q->state = UACCE_Q_INIT;
>> +
>> +	return 0;
>> +
>> +out_with_mem:
>> +	kfree(q);
>> +out_with_module:
>> +	module_put(uacce->pdev->driver->owner);
>> +	return ret;
>> +}
>> +
>> +static int uacce_fops_release(struct inode *inode, struct file *filep)
>> +{
>> +	struct uacce_queue *q = filep->private_data;
>> +	struct uacce_qfile_region *qfr;
>> +	struct uacce_device *uacce = q->uacce;
>> +	bool is_to_free_region;
>> +	int free_pages = 0;
>> +	int i;
>> +
>> +	mutex_lock(&uacce_mutex);
>> +
>> +	if ((q->state == UACCE_Q_STARTED) && uacce->ops->stop_queue)
>> +		uacce->ops->stop_queue(q);
>> +
>> +	for (i = 0; i < UACCE_QFRT_MAX; i++) {
>> +		qfr = q->qfrs[i];
>> +		if (!qfr)
>> +			continue;
>> +
>> +		is_to_free_region = false;
>> +		uacce_queue_unmap_qfr(q, qfr);
>> +		if (i == UACCE_QFRT_SS) {
>> +			list_del(&q->list);
>> +			if (list_empty(&qfr->qs))
>> +				is_to_free_region = true;
>> +		} else
>> +			is_to_free_region = true;
>> +
>> +		if (is_to_free_region) {
>> +			free_pages += qfr->nr_pages;
>> +			uacce_destroy_region(q, qfr);
>> +		}
>> +
>> +		qfr = NULL;
>> +	}
>> +
>> +	if (current->mm == q->mm) {
>> +		down_write(&q->mm->mmap_sem);
>> +		q->mm->data_vm -= free_pages;
>> +		up_write(&q->mm->mmap_sem);
> This is bogus you do not get any reference on the mm through
> mmgrab() so there is nothing protection the q->mm from being
> release. Note that you do not want to do mmgrab() in open as
> the file descriptor can outlive the mm.
Will remove this.
>
>> +	}
>> +
>> +	if (uacce->flags & UACCE_DEV_SVA)
>> +		iommu_sva_unbind_device(q->handle);
>> +
>> +	if ((q->state == UACCE_Q_INIT || q->state == UACCE_Q_STARTED) &&
>> +	     uacce->ops->put_queue)
>> +		uacce->ops->put_queue(q);
>> +
>> +	kfree(q);
>> +	mutex_unlock(&uacce_mutex);
>> +
>> +	module_put(uacce->pdev->driver->owner);
> As the file can outlive the process it might also outlive the module
> maybe you want to keep a reference on the module as part of the region
> and release it in uacce_destroy_region()
module_get and module_put already considers refs, so we may not needed 
any more.
>
>> +
>> +	return 0;
>> +}
>> +
>> +static int uacce_fops_mmap(struct file *filep, struct vm_area_struct *vma)
>> +{
>> +	struct uacce_queue *q = filep->private_data;
>> +	struct uacce_device *uacce = q->uacce;
>> +	struct uacce_qfile_region *qfr;
>> +	enum uacce_qfrt type = 0;
>> +	unsigned int flags = 0;
>> +	int ret;
>> +
>> +	if (vma->vm_pgoff < UACCE_QFRT_MAX)
>> +		type = vma->vm_pgoff;
>> +
>> +	vma->vm_flags |= VM_DONTCOPY | VM_DONTEXPAND;
> Don't you also want VM_WIPEONFORK ?
Looks it is required, thanks.
>
>> +
>> +	mutex_lock(&uacce_mutex);
>> +
>> +	/* fixme: if the region need no pages, we don't need to check it */
>> +	if (q->mm->data_vm + vma_pages(vma) >
>> +	    rlimit(RLIMIT_DATA) >> PAGE_SHIFT) {
>> +		ret = -ENOMEM;
>> +		goto out_with_lock;
>> +	}
>> +
>> +	if (q->qfrs[type]) {
>> +		ret = -EBUSY;
> What about -EEXIST ? That test checks if a region of given
> type already exist for the uacce_queue which is private to
> that file descriptor. So it means that userspace which did
> open the file is trying to create again the same region type
> which already exist.
Good idea.
>
>> +		goto out_with_lock;
>> +	}
>> +
>> +	switch (type) {
>> +	case UACCE_QFRT_MMIO:
>> +		flags = UACCE_QFRF_SELFMT;
>> +		break;
>> +
>> +	case UACCE_QFRT_SS:
>> +		if (q->state != UACCE_Q_STARTED) {
>> +			ret = -EINVAL;
>> +			goto out_with_lock;
>> +		}
>> +
>> +		if (uacce->flags & UACCE_DEV_SVA) {
>> +			ret = -EINVAL;
>> +			goto out_with_lock;
>> +		}
>> +
>> +		flags = UACCE_QFRF_MAP | UACCE_QFRF_MMAP;
>> +
>> +		break;
>> +
>> +	case UACCE_QFRT_DKO:
>> +		if (uacce->flags & UACCE_DEV_SVA) {
>> +			ret = -EINVAL;
>> +			goto out_with_lock;
>> +		}
>> +
>> +		flags = UACCE_QFRF_MAP | UACCE_QFRF_KMAP;
>> +
>> +		break;
>> +
>> +	case UACCE_QFRT_DUS:
>> +		if (uacce->flags & UACCE_DEV_SVA) {
>> +			flags = UACCE_QFRF_SELFMT;
>> +			break;
>> +		}
>> +
>> +		flags = UACCE_QFRF_MAP | UACCE_QFRF_MMAP;
>> +		break;
>> +
>> +	default:
>> +		WARN_ON(&uacce->dev);
>> +		break;
>> +	}
>> +
>> +	qfr = uacce_create_region(q, vma, type, flags);
>> +	if (IS_ERR(qfr)) {
>> +		ret = PTR_ERR(qfr);
>> +		goto out_with_lock;
>> +	}
>> +	q->qfrs[type] = qfr;
>> +
>> +	if (type == UACCE_QFRT_SS) {
>> +		INIT_LIST_HEAD(&qfr->qs);
>> +		list_add(&q->list, &q->qfrs[type]->qs);
>> +	}
>> +
>> +	mutex_unlock(&uacce_mutex);
>> +
>> +	if (qfr->pages)
>> +		q->mm->data_vm += qfr->nr_pages;
> The mm->data_vm fields is protected by the mmap_sem taken in write
> mode AFAIR so what you are doing here is unsafe.
>
>> +
>> +	return 0;
>> +
>> +out_with_lock:
>> +	mutex_unlock(&uacce_mutex);
>> +	return ret;
>> +}
>> +
> [...]
>
>> +/* Borrowed from VFIO to fix msi translation */
>> +static bool uacce_iommu_has_sw_msi(struct iommu_group *group,
>> +				   phys_addr_t *base)
> I fail to see why you need this in a common framework this
> seems to be specific to a device.
>
>> +{
>> +	struct list_head group_resv_regions;
>> +	struct iommu_resv_region *region, *next;
>> +	bool ret = false;
>> +
>> +	INIT_LIST_HEAD(&group_resv_regions);
>> +	iommu_get_group_resv_regions(group, &group_resv_regions);
>> +	list_for_each_entry(region, &group_resv_regions, list) {
>> +		/*
>> +		 * The presence of any 'real' MSI regions should take
>> +		 * precedence over the software-managed one if the
>> +		 * IOMMU driver happens to advertise both types.
>> +		 */
>> +		if (region->type == IOMMU_RESV_MSI) {
>> +			ret = false;
>> +			break;
>> +		}
>> +
>> +		if (region->type == IOMMU_RESV_SW_MSI) {
>> +			*base = region->start;
>> +			ret = true;
>> +		}
>> +	}
>> +
>> +	list_for_each_entry_safe(region, next, &group_resv_regions, list)
>> +		kfree(region);
>> +
>> +	return ret;
>> +}
>> +
>> +static int uacce_set_iommu_domain(struct uacce_device *uacce)
>> +{
>> +	struct iommu_domain *domain;
>> +	struct iommu_group *group;
>> +	struct device *dev = uacce->pdev;
>> +	bool resv_msi;
>> +	phys_addr_t resv_msi_base = 0;
>> +	int ret;
>> +
>> +	if (uacce->flags & UACCE_DEV_SVA)
>> +		return 0;
>> +
>> +	/* allocate and attach an unmanaged domain */
>> +	domain = iommu_domain_alloc(uacce->pdev->bus);
>> +	if (!domain) {
>> +		dev_err(&uacce->dev, "cannot get domain for iommu\n");
>> +		return -ENODEV;
>> +	}
>> +
>> +	ret = iommu_attach_device(domain, uacce->pdev);
>> +	if (ret)
>> +		goto err_with_domain;
>> +
>> +	if (iommu_capable(dev->bus, IOMMU_CAP_CACHE_COHERENCY))
>> +		uacce->prot |= IOMMU_CACHE;
>> +
>> +	group = iommu_group_get(dev);
>> +	if (!group) {
>> +		ret = -EINVAL;
>> +		goto err_with_domain;
>> +	}
>> +
>> +	resv_msi = uacce_iommu_has_sw_msi(group, &resv_msi_base);
>> +	iommu_group_put(group);
>> +
>> +	if (resv_msi) {
>> +		if (!irq_domain_check_msi_remap() &&
>> +		    !iommu_capable(dev->bus, IOMMU_CAP_INTR_REMAP)) {
>> +			dev_warn(dev, "No interrupt remapping support!");
>> +			ret = -EPERM;
>> +			goto err_with_domain;
>> +		}
>> +
>> +		ret = iommu_get_msi_cookie(domain, resv_msi_base);
>> +		if (ret)
>> +			goto err_with_domain;
>> +	}
>> +
>> +	return 0;
>> +
>> +err_with_domain:
>> +	iommu_domain_free(domain);
>> +	return ret;
>> +}
>> +
>> +static void uacce_unset_iommu_domain(struct uacce_device *uacce)
>> +{
>> +	struct iommu_domain *domain;
>> +
>> +	if (uacce->flags & UACCE_DEV_SVA)
>> +		return;
>> +
>> +	domain = iommu_get_domain_for_dev(uacce->pdev);
>> +	if (!domain) {
>> +		dev_err(&uacce->dev, "bug: no domain attached to device\n");
>> +		return;
>> +	}
>> +
>> +	iommu_detach_device(domain, uacce->pdev);
>> +	iommu_domain_free(domain);
>> +}
>> +
>> +/**
>> + * uacce_register - register an accelerator
>> + * @parent: pointer of uacce parent device
>> + * @interface: pointer of uacce_interface for register
>> + */
>> +struct uacce_device *uacce_register(struct device *parent,
>> +				    struct uacce_interface *interface)
>> +{
>> +	int ret;
>> +	struct uacce_device *uacce;
>> +	unsigned int flags = interface->flags;
>> +
>> +	uacce = kzalloc(sizeof(struct uacce_device), GFP_KERNEL);
>> +	if (!uacce)
>> +		return ERR_PTR(-ENOMEM);
>> +
>> +	if (flags & UACCE_DEV_SVA) {
>> +		ret = iommu_dev_enable_feature(parent, IOMMU_DEV_FEAT_SVA);
>> +		if (ret)
>> +			flags &= ~UACCE_DEV_SVA;
>> +	}
>> +
>> +	uacce->pdev = parent;
>> +	uacce->flags = flags;
>> +	uacce->ops = interface->ops;
>> +
>> +	ret = uacce_set_iommu_domain(uacce);
>> +	if (ret)
>> +		goto err_free;
> Why do you need to change the IOMMU domain ? This is orthogonal to
> what you are trying to achieve. Domain has nothing to do with SVA
> or userspace queue (at least not on x86 AFAIK).
>
>
>> +
>> +	mutex_lock(&uacce_mutex);
>> +
>> +	ret = idr_alloc(&uacce_idr, uacce, 0, 0, GFP_KERNEL);
>> +	if (ret < 0)
>> +		goto err_with_lock;
>> +
>> +	uacce->cdev = cdev_alloc();
>> +	uacce->cdev->ops = &uacce_fops;
>> +	uacce->dev_id = ret;
>> +	uacce->cdev->owner = THIS_MODULE;
>> +	device_initialize(&uacce->dev);
>> +	uacce->dev.devt = MKDEV(MAJOR(uacce_devt), uacce->dev_id);
>> +	uacce->dev.class = uacce_class;
>> +	uacce->dev.groups = uacce_dev_groups;
>> +	uacce->dev.parent = uacce->pdev;
>> +	uacce->dev.release = uacce_release;
>> +	dev_set_name(&uacce->dev, "%s-%d", interface->name, uacce->dev_id);
>> +	ret = cdev_device_add(uacce->cdev, &uacce->dev);
>> +	if (ret)
>> +		goto err_with_idr;
>> +
>> +	mutex_unlock(&uacce_mutex);
>> +
>> +	return uacce;
>> +
>> +err_with_idr:
>> +	idr_remove(&uacce_idr, uacce->dev_id);
>> +err_with_lock:
>> +	mutex_unlock(&uacce_mutex);
>> +	uacce_unset_iommu_domain(uacce);
>> +err_free:
>> +	if (flags & UACCE_DEV_SVA)
>> +		iommu_dev_disable_feature(uacce->pdev, IOMMU_DEV_FEAT_SVA);
>> +	kfree(uacce);
>> +	return ERR_PTR(ret);
>> +}
>> +EXPORT_SYMBOL_GPL(uacce_register);
> [...]
>
>> diff --git a/include/linux/uacce.h b/include/linux/uacce.h
>> new file mode 100644
>> index 0000000..8ce0640
>> --- /dev/null
>> +++ b/include/linux/uacce.h
>> @@ -0,0 +1,168 @@
>> +/* SPDX-License-Identifier: GPL-2.0-or-later */
>> +#ifndef _LINUX_UACCE_H
>> +#define _LINUX_UACCE_H
>> +
>> +#include <linux/cdev.h>
>> +#include <uapi/misc/uacce/uacce.h>
>> +
>> +#define UACCE_NAME		"uacce"
>> +
>> +struct uacce_queue;
>> +struct uacce_device;
>> +
>> +/* uacce queue file flag, requires different operation */
>> +#define UACCE_QFRF_MAP		BIT(0)	/* map to current queue */
>> +#define UACCE_QFRF_MMAP		BIT(1)	/* map to user space */
>> +#define UACCE_QFRF_KMAP		BIT(2)	/* map to kernel space */
>> +#define UACCE_QFRF_DMA		BIT(3)	/* use dma api for the region */
>> +#define UACCE_QFRF_SELFMT	BIT(4)	/* self maintained qfr */
>> +
>> +/**
>> + * struct uacce_qfile_region - structure of queue file region
>> + * @type: type of the qfr
>> + * @iova: iova share between user and device space
>> + * @pages: pages pointer of the qfr memory
>> + * @nr_pages: page numbers of the qfr memory
>> + * @prot: qfr protection flag
>> + * @flags: flags of qfr
>> + * @qs: list sharing the same region, for ss region
>> + * @kaddr: kernel addr of the qfr
>> + * @dma: dma address, if created by dma api
>> + */
>> +struct uacce_qfile_region {
>> +	enum uacce_qfrt type;
>> +	unsigned long iova;
>> +	struct page **pages;
>> +	u32 nr_pages;
>> +	u32 prot;
>> +	u32 flags;
>> +	struct list_head qs;
>> +	void *kaddr;
>> +	dma_addr_t dma;
>> +};
>> +
>> +/**
>> + * struct uacce_ops - uacce device operations
>> + * @get_available_instances:  get available instances left of the device
>> + * @get_queue: get a queue from the device
>> + * @put_queue: free a queue to the device
>> + * @start_queue: make the queue start work after get_queue
>> + * @stop_queue: make the queue stop work before put_queue
>> + * @is_q_updated: check whether the task is finished
>> + * @mask_notify: mask the task irq of queue
>> + * @mmap: mmap addresses of queue to user space
>> + * @reset: reset the uacce device
>> + * @reset_queue: reset the queue
>> + * @ioctl: ioctl for user space users of the queue
>> + */
>> +struct uacce_ops {
>> +	int (*get_available_instances)(struct uacce_device *uacce);
>> +	int (*get_queue)(struct uacce_device *uacce, unsigned long arg,
>> +			 struct uacce_queue *q);
>> +	void (*put_queue)(struct uacce_queue *q);
>> +	int (*start_queue)(struct uacce_queue *q);
>> +	void (*stop_queue)(struct uacce_queue *q);
>> +	int (*is_q_updated)(struct uacce_queue *q);
>> +	void (*mask_notify)(struct uacce_queue *q, int event_mask);
>> +	int (*mmap)(struct uacce_queue *q, struct vm_area_struct *vma,
>> +		    struct uacce_qfile_region *qfr);
>> +	int (*reset)(struct uacce_device *uacce);
>> +	int (*reset_queue)(struct uacce_queue *q);
>> +	long (*ioctl)(struct uacce_queue *q, unsigned int cmd,
>> +		      unsigned long arg);
>> +};
>> +
>> +/**
>> + * struct uacce_interface
>> + * @name: the uacce device name.  Will show up in sysfs
>> + * @flags: uacce device attributes
>> + * @ops: pointer to the struct uacce_ops
>> + *
>> + * This structure is used for the uacce_register()
>> + */
>> +struct uacce_interface {
>> +	char name[32];
> You should add a define for the maximum lenght of name.
Sure, thanks
>
>> +	unsigned int flags;
> Should be enum uacce_dev_flag not unsigned int and that
> enum should be defined above and not in uAPI see comments
> i made next to that enum.
enum uacce_dev_flag is better, thanks
>
>> +	struct uacce_ops *ops;
>> +};
>> +
>> +enum uacce_q_state {
>> +	UACCE_Q_INIT,
>> +	UACCE_Q_STARTED,
>> +	UACCE_Q_ZOMBIE,
>> +};
>> +
>> +/**
>> + * struct uacce_queue
>> + * @uacce: pointer to uacce
>> + * @priv: private pointer
>> + * @wait: wait queue head
>> + * @pasid: pasid of the queue
>> + * @handle: iommu_sva handle return from iommu_sva_bind_device
>> + * @list: share list for qfr->qs
>> + * @mm: current->mm
>> + * @qfrs: pointer of qfr regions
>> + * @state: queue state machine
>> + */
>> +struct uacce_queue {
>> +	struct uacce_device *uacce;
>> +	void *priv;
>> +	wait_queue_head_t wait;
>> +	int pasid;
>> +	struct iommu_sva *handle;
>> +	struct list_head list;
>> +	struct mm_struct *mm;
>> +	struct uacce_qfile_region *qfrs[UACCE_QFRT_MAX];
>> +	enum uacce_q_state state;
>> +};
>> +
>> +/**
>> + * struct uacce_device
>> + * @algs: supported algorithms
>> + * @api_ver: api version
>> + * @qf_pg_size: page size of the queue file regions
>> + * @ops: pointer to the struct uacce_ops
>> + * @pdev: pointer to the parent device
>> + * @is_vf: whether virtual function
>> + * @flags: uacce attributes
>> + * @dev_id: id of the uacce device
>> + * @prot: uacce protection flag
>> + * @cdev: cdev of the uacce
>> + * @dev: dev of the uacce
>> + * @priv: private pointer of the uacce
>> + */
>> +struct uacce_device {
>> +	const char *algs;
>> +	const char *api_ver;
>> +	unsigned long qf_pg_size[UACCE_QFRT_MAX];
>> +	struct uacce_ops *ops;
>> +	struct device *pdev;
>> +	bool is_vf;
>> +	u32 flags;
>> +	u32 dev_id;
>> +	u32 prot;
>> +	struct cdev *cdev;
>> +	struct device dev;
>> +	void *priv;
>> +};
>> +
>> +#if IS_ENABLED(CONFIG_UACCE)
>> +
>> +struct uacce_device *uacce_register(struct device *parent,
>> +				    struct uacce_interface *interface);
>> +void uacce_unregister(struct uacce_device *uacce);
>> +
>> +#else /* CONFIG_UACCE */
>> +
>> +static inline
>> +struct uacce_device *uacce_register(struct device *parent,
>> +				    struct uacce_interface *interface)
>> +{
>> +	return ERR_PTR(-ENODEV);
>> +}
>> +
>> +static inline void uacce_unregister(struct uacce_device *uacce) {}
>> +
>> +#endif /* CONFIG_UACCE */
>> +
>> +#endif /* _LINUX_UACCE_H */
>> diff --git a/include/uapi/misc/uacce/uacce.h b/include/uapi/misc/uacce/uacce.h
>> new file mode 100644
>> index 0000000..c859668
>> --- /dev/null
>> +++ b/include/uapi/misc/uacce/uacce.h
>> @@ -0,0 +1,41 @@
>> +/* SPDX-License-Identifier: GPL-2.0-or-later */
>> +#ifndef _UAPIUUACCE_H
>> +#define _UAPIUUACCE_H
>> +
>> +#include <linux/types.h>
>> +#include <linux/ioctl.h>
>> +
>> +#define UACCE_CMD_SHARE_SVAS	_IO('W', 0)
>> +#define UACCE_CMD_START		_IO('W', 1)
>> +#define UACCE_CMD_PUT_Q		_IO('W', 2)
>> +
>> +/**
>> + * enum uacce_dev_flag: Device flags:
>> + * @UACCE_DEV_SHARE_DOMAIN: no PASID, can share sva for one process
>> + * @UACCE_DEV_SVA: Shared Virtual Addresses
>> + *		   Support PASID
>> + *		   Support device page fault (pcie device) or
>> + *		   smmu stall (platform device)
>> + */
>> +enum uacce_dev_flag {
>> +	UACCE_DEV_SHARE_DOMAIN = 0x0,
> UACCE_DEV_SHARE_DOMAIN is not use anywhere better do not introduce something
> that is not use.
Yes, will remove it.
>
>
>> +	UACCE_DEV_SVA = 0x1,
>> +};
> More general question why is it part of the UAPI header file ?
> To me it seems that those flags are only use internaly to the
> kernel and never need to be expose to userspace.
The flags are required by user app.
User can get flags via sysfs and understand what type it is.
For example, when flags & UACCE_DEV_SVA, malloced memory can be used.
>
>> +
>> +/**
>> + * enum uacce_qfrt: qfrt type
>> + * @UACCE_QFRT_MMIO: device mmio region
>> + * @UACCE_QFRT_DKO: device kernel-only region
>> + * @UACCE_QFRT_DUS: device user share region
>> + * @UACCE_QFRT_SS: static shared memory region
>> + * @UACCE_QFRT_MAX: indicate the boundary
>> + */
> Your first driver only use DUS and MMIO, you should not define
> thing that are not even use by the first driver, especialy when
> it comes to userspace API.
Sure, thanks
>
>> +enum uacce_qfrt {
>> +	UACCE_QFRT_MMIO = 0,
>> +	UACCE_QFRT_DKO = 1,
>> +	UACCE_QFRT_DUS = 2,
>> +	UACCE_QFRT_SS = 3,
>> +	UACCE_QFRT_MAX = 16,
> Isn't 16 bit low ? Do you really need a maximum ? I would not
> expose or advertise a maxmimum in this userspace facing header.
Good idea, will remove UACCE_QFRT_MAX and let it open.

Thanks
>

