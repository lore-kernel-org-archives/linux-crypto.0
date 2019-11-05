Return-Path: <SRS0=QWZk=Y5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25254CA9EDB
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Nov 2019 07:44:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBFBD20818
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Nov 2019 07:44:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dFa9bQYk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387789AbfKEHn7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Nov 2019 02:43:59 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41617 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387678AbfKEHn7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Nov 2019 02:43:59 -0500
Received: by mail-pg1-f193.google.com with SMTP id l3so13437731pgr.8
        for <linux-crypto@vger.kernel.org>; Mon, 04 Nov 2019 23:43:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=8/Gn0utFRmAPxSXpFGHDgnfqJKxWyml3l8N7RpHi2XQ=;
        b=dFa9bQYkEdjVt76sMEZWdPwED2EseasI5aOJq3fI31/rH/N9CKPUmcaNjTVV89FHZR
         24jkLEoEMShfSYeG9JywmUodBWU0to5rLAKpzPqE/Tx//FP+g/kJT0+g/e7+8hAhweB0
         sES5miKe3ptxdtp58qILNVd0qBg2wfCwDbDu1kIzf52PWQqpwlRVxjDVrN8wM9bRcZ9A
         BBpk6/EhZ8cFWyOFtyKWDK1fjvd4358672V3Uj6K4Xr88mv2+D+1sH77I2G4eO2RJsL6
         KrzvuYuGwNkhPepOtcwgLjxQkx/NA46sL7CgvqESn5Q96VLsh3j/R0jucUXH9LssXdsT
         obAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=8/Gn0utFRmAPxSXpFGHDgnfqJKxWyml3l8N7RpHi2XQ=;
        b=QsiEK6SAOxPNC10zkli6zsj9C2/e/SK0hSOkWxkptOPcY79da2sU+XWepZpGQSU0Ih
         4uA1MhFI/y0N9LHDE7fJT0epCULcWXcTNxnvEJ+Oqufd7PYcuUfDnoyGIsH6SKxndNfy
         dWIm+d4MHdcTNrVni8C16+7oW6Mku0ukXw8A+TP0zz+OHy5F3MRB8/pI4mJ4gw65S6M8
         HD1AuEHvYOEkvdJpnu0is6zkhHRVzET4XOngYYcOUe56b7u3X+FKED294AqhkAAnyBJZ
         6K+xeoeoTQ8SFj0HSOiZOag5XE+at6gcG+NX3+9QvLSyPRXCnyDlf+bjBUHBNtmPKJ7v
         XaUA==
X-Gm-Message-State: APjAAAVfRwgvj515LuDWAjchXDHeuBDBvNA+kmogWNVGVNA3Q78Fg98e
        IldUvJGtlWKoZ3z7+LSGeIX7DQ==
X-Google-Smtp-Source: APXvYqxOwMESplrVMkljpMRzn3ouFOclmQqD/dHtnlO3RuJA42kmeH2Sr/yELt3Z5qOMkdJ1Se48GA==
X-Received: by 2002:a17:90a:3746:: with SMTP id u64mr1662124pjb.4.1572939838105;
        Mon, 04 Nov 2019 23:43:58 -0800 (PST)
Received: from ?IPv6:240e:362:46a:2000:dc7:27ad:6d11:a6a4? ([240e:362:46a:2000:dc7:27ad:6d11:a6a4])
        by smtp.gmail.com with ESMTPSA id r13sm2107668pgh.37.2019.11.04.23.43.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 Nov 2019 23:43:57 -0800 (PST)
Subject: Re: [PATCH v7 2/3] uacce: add uacce driver
To:     Jonathan Cameron <jonathan.cameron@huawei.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>, grant.likely@arm.com,
        jean-philippe <jean-philippe@linaro.org>,
        Jerome Glisse <jglisse@redhat.com>,
        ilias.apalodimas@linaro.org, francois.ozog@linaro.org,
        kenneth-lee-2012@foxmail.com, Wangzhou <wangzhou1@hisilicon.com>,
        "haojian . zhuang" <haojian.zhuang@linaro.org>,
        guodong.xu@linaro.org, linux-accelerators@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        iommu@lists.linux-foundation.org,
        Kenneth Lee <liguozhu@hisilicon.com>,
        Zaibo Xu <xuzaibo@huawei.com>
References: <1572331216-9503-1-git-send-email-zhangfei.gao@linaro.org>
 <1572331216-9503-3-git-send-email-zhangfei.gao@linaro.org>
 <20191031171357.000067c7@huawei.com>
From:   zhangfei <zhangfei.gao@linaro.org>
Message-ID: <6e427d92-e0c3-e77d-51f4-f7c1ae4d7da7@linaro.org>
Date:   Tue, 5 Nov 2019 15:43:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191031171357.000067c7@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi, Jonathan

Thanks for the suggestions

On 2019/11/1 上午1:13, Jonathan Cameron wrote:
> On Tue, 29 Oct 2019 14:40:15 +0800
> Zhangfei Gao <zhangfei.gao@linaro.org> wrote:
>
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
>>
>> Signed-off-by: Kenneth Lee <liguozhu@hisilicon.com>
>> Signed-off-by: Zaibo Xu <xuzaibo@huawei.com>
>> Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
>> Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
> Great, much more compact.
>
> I've not gone through this in detail yet but a few initial comments inline.
>
> Thanks,
>
> Jonathan
>
>> ---
>>   Documentation/ABI/testing/sysfs-driver-uacce |  53 +++
>>   drivers/misc/Kconfig                         |   1 +
>>   drivers/misc/Makefile                        |   1 +
>>   drivers/misc/uacce/Kconfig                   |  13 +
>>   drivers/misc/uacce/Makefile                  |   2 +
>>   drivers/misc/uacce/uacce.c                   | 574 +++++++++++++++++++++++++++
>>   include/linux/uacce.h                        | 163 ++++++++
>>   include/uapi/misc/uacce/uacce.h              |  38 ++
>>   8 files changed, 845 insertions(+)
>>   create mode 100644 Documentation/ABI/testing/sysfs-driver-uacce
>>   create mode 100644 drivers/misc/uacce/Kconfig
>>   create mode 100644 drivers/misc/uacce/Makefile
>>   create mode 100644 drivers/misc/uacce/uacce.c
>>   create mode 100644 include/linux/uacce.h
>>   create mode 100644 include/uapi/misc/uacce/uacce.h
>>
>> diff --git a/Documentation/ABI/testing/sysfs-driver-uacce b/Documentation/ABI/testing/sysfs-driver-uacce
>> new file mode 100644
>> index 0000000..35699dc
>> --- /dev/null
>> +++ b/Documentation/ABI/testing/sysfs-driver-uacce
>> @@ -0,0 +1,53 @@
>> +What:           /sys/class/uacce/<dev_name>/id
>> +Date:           Oct 2019
>> +KernelVersion:  5.5
>> +Contact:        linux-accelerators@lists.ozlabs.org
>> +Description:    Id of the device.
>> +
>> +What:           /sys/class/uacce/<dev_name>/api
>> +Date:           Oct 2019
>> +KernelVersion:  5.5
>> +Contact:        linux-accelerators@lists.ozlabs.org
>> +Description:    Api of the device, used by application to match the correct driver
>> +
>> +What:           /sys/class/uacce/<dev_name>/flags
>> +Date:           Oct 2019
>> +KernelVersion:  5.5
>> +Contact:        linux-accelerators@lists.ozlabs.org
>> +Description:    Attributes of the device, see UACCE_DEV_xxx flag defined in uacce.h
>> +
>> +What:           /sys/class/uacce/<dev_name>/available_instances
>> +Date:           Oct 2019
>> +KernelVersion:  5.5
>> +Contact:        linux-accelerators@lists.ozlabs.org
>> +Description:    Available instances left of the device
>> +
>> +What:           /sys/class/uacce/<dev_name>/algorithms
>> +Date:           Oct 2019
>> +KernelVersion:  5.5
>> +Contact:        linux-accelerators@lists.ozlabs.org
>> +Description:    Algorithms supported by this accelerator
> How are they separated?  Userspace code needs to know that.
> (comma, tab, newline?)
Yes, will add "separated by new line"
>
>> +
>> +What:           /sys/class/uacce/<dev_name>/qfrt_mmio_size
> qfrt is not the most obvious naming ever.  Do we care beyond its
> a region for this interface?  region_mmio_size maybe?
OK,
>
>> +Date:           Oct 2019
>> +KernelVersion:  5.5
>> +Contact:        linux-accelerators@lists.ozlabs.org
>> +Description:    Page size of mmio region queue file
> Size of page in this region, or number of pages in the region?
Change to "Page numbers of mmio region queue file"
>
>> +
>> +What:           /sys/class/uacce/<dev_name>/qfrt_dus_size
>> +Date:           Oct 2019
>> +KernelVersion:  5.5
>> +Contact:        linux-accelerators@lists.ozlabs.org
>> +Description:    Page size of dus region queue file
>> +
>> +What:           /sys/class/uacce/<dev_name>/numa_distance
>> +Date:           Oct 2019
>> +KernelVersion:  5.5
>> +Contact:        linux-accelerators@lists.ozlabs.org
>> +Description:    Distance of device node to cpu node
> I wonder if we should be doing this in here. There are other standard
> ways of obtaining this for the device.  Follow parent and check node_id
> there then use the /sys/bus/node path to find out the distances.
Could you clarify more about this method.
The purpose here is cpu searching the nearest device(zip) doing work.
Does user application know which node it is running and compare distance?
>> +
>> +What:           /sys/class/uacce/<dev_name>/node_id
>> +Date:           Oct 2019
>> +KernelVersion:  5.5
>> +Contact:        linux-accelerators@lists.ozlabs.org
>> +Description:    Id of the numa node
>> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
>> index c55b637..929feb0 100644
>> --- a/drivers/misc/Kconfig
>> +++ b/drivers/misc/Kconfig
>> @@ -481,4 +481,5 @@ source "drivers/misc/cxl/Kconfig"
>>   source "drivers/misc/ocxl/Kconfig"
>>   source "drivers/misc/cardreader/Kconfig"
>>   source "drivers/misc/habanalabs/Kconfig"
>> +source "drivers/misc/uacce/Kconfig"
>>   endmenu
>> diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
>> index c1860d3..9abf292 100644
>> --- a/drivers/misc/Makefile
>> +++ b/drivers/misc/Makefile
>> @@ -56,4 +56,5 @@ obj-$(CONFIG_OCXL)		+= ocxl/
>>   obj-y				+= cardreader/
>>   obj-$(CONFIG_PVPANIC)   	+= pvpanic.o
>>   obj-$(CONFIG_HABANA_AI)		+= habanalabs/
>> +obj-$(CONFIG_UACCE)		+= uacce/
>>   obj-$(CONFIG_XILINX_SDFEC)	+= xilinx_sdfec.o
>> diff --git a/drivers/misc/uacce/Kconfig b/drivers/misc/uacce/Kconfig
>> new file mode 100644
>> index 0000000..5e39b60
>> --- /dev/null
>> +++ b/drivers/misc/uacce/Kconfig
>> @@ -0,0 +1,13 @@
>> +config UACCE
>> +	tristate "Accelerator Framework for User Land"
>> +	depends on IOMMU_API
>> +	help
>> +	  UACCE provides interface for the user process to access the hardware
>> +	  without interaction with the kernel space in data path.
>> +
>> +	  The user-space interface is described in
>> +	  include/uapi/misc/uacce/uacce.h
>> +
>> +	  See Documentation/misc-devices/uacce.rst for more details.
>> +
>> +	  If you don't know what to do here, say N.
> Pessimist :) Everyone should want uacce so don't put them off.  Having said
> that perhaps for now it should be hidden and enabled on a driver by driver
> basis?
>
>> diff --git a/drivers/misc/uacce/Makefile b/drivers/misc/uacce/Makefile
>> new file mode 100644
>> index 0000000..5b4374e
>> --- /dev/null
>> +++ b/drivers/misc/uacce/Makefile
>> @@ -0,0 +1,2 @@
>> +# SPDX-License-Identifier: GPL-2.0-or-later
>> +obj-$(CONFIG_UACCE) += uacce.o
>> diff --git a/drivers/misc/uacce/uacce.c b/drivers/misc/uacce/uacce.c
>> new file mode 100644
>> index 0000000..2b6b038
>> --- /dev/null
>> +++ b/drivers/misc/uacce/uacce.c
>> @@ -0,0 +1,574 @@
>> +// SPDX-License-Identifier: GPL-2.0-or-later
>> +#include <linux/compat.h>
>> +#include <linux/dma-iommu.h>
>> +#include <linux/module.h>
>> +#include <linux/poll.h>
>> +#include <linux/uacce.h>
>> +
>> +static struct class *uacce_class;
>> +static dev_t uacce_devt;
>> +static DEFINE_MUTEX(uacce_mutex);
>> +static DEFINE_XARRAY_ALLOC(uacce_xa);
>> +
>> +static int uacce_start_queue(struct uacce_queue *q)
>> +{
>> +	int ret = -EINVAL;
>> +
>> +	mutex_lock(&uacce_mutex);
>> +
>> +	if (q->state != UACCE_Q_INIT)
>> +		goto out_with_lock;
>> +
>> +	if (q->uacce->ops->start_queue) {
>> +		ret = q->uacce->ops->start_queue(q);
>> +		if (ret < 0)
>> +			goto out_with_lock;
>> +	}
>> +
>> +	q->state = UACCE_Q_STARTED;
> out_with_lock:
>> +	mutex_unlock(&uacce_mutex);
>> +
> return ret;
> Though need to handle ret a bit differently above...
OK
>
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
> +	vma->vm_flags |= VM_DONTCOPY | VM_DONTEXPAND | VM_WIPEONFORK;
> +	vma->vm_ops = &uacce_vm_ops;
> +	vma->vm_private_data = q;
> +
> +	mutex_lock(&uacce_mutex);
> +
> +	if (q->qfrs[type]) {
> +		ret = -EEXIST;
> +		goto out_with_lock;
> +	}
> +
> +	switch (type) {
> +	case UACCE_QFRT_MMIO:
> +		flags = UACCE_QFRF_SELFMT;
> +		break;
> +
> +	case UACCE_QFRT_DUS:
> +		if (uacce->flags & UACCE_DEV_SVA) {
> +			flags = UACCE_QFRF_SELFMT;
> +			break;
> +		}
> +		break;
> +
> +	default:
> +		WARN_ON(&uacce->dev);
> +		break;
> +	}
> +
> +	qfr = uacce_create_region(q, vma, type, flags);
> +	if (IS_ERR(qfr)) {
> +		ret = PTR_ERR(qfr);
> +		goto out_with_lock;
> +	}
> +	q->qfrs[type] = qfr;
> +
> Could put
> out_with_lock:
> here and return ret instead of 0.
> You'll need to set ret to default to 0 in that
> case though.
OK
>
> +static ssize_t algorithms_show(struct device *dev,
> +			       struct device_attribute *attr, char *buf)
> +{
> +	struct uacce_device *uacce = to_uacce_device(dev);
> +
> +	return sprintf(buf, "%s", uacce->algs);
> Any risk algs won't have the \n?
> I'd kind of expect it to be a null termated arrays to allow the core
> to format it however it wants to.
Yes, adding \n is better.
>
>> +}
>> +
>> +static ssize_t qfrt_mmio_size_show(struct device *dev,
>> +				   struct device_attribute *attr, char *buf)
>> +{
>> +	struct uacce_device *uacce = to_uacce_device(dev);
>> +
>> +	return sprintf(buf, "%lu\n",
>> +		       uacce->qf_pg_size[UACCE_QFRT_MMIO] << PAGE_SHIFT);
>> +}
>> +
>> +static ssize_t qfrt_dus_size_show(struct device *dev,
>> +				  struct device_attribute *attr, char *buf)
>> +{
>> +	struct uacce_device *uacce = to_uacce_device(dev);
>> +
>> +	return sprintf(buf, "%lu\n",
>> +		       uacce->qf_pg_size[UACCE_QFRT_DUS] << PAGE_SHIFT);
>> +}
>> +
>> +static DEVICE_ATTR_RO(id);
>> +static DEVICE_ATTR_RO(api);
>> +static DEVICE_ATTR_RO(numa_distance);
>> +static DEVICE_ATTR_RO(node_id);
>> +static DEVICE_ATTR_RO(flags);
>> +static DEVICE_ATTR_RO(available_instances);
>> +static DEVICE_ATTR_RO(algorithms);
>> +static DEVICE_ATTR_RO(qfrt_mmio_size);
>> +static DEVICE_ATTR_RO(qfrt_dus_size);
>> +
>> +static struct attribute *uacce_dev_attrs[] = {
>> +	&dev_attr_id.attr,
>> +	&dev_attr_api.attr,
>> +	&dev_attr_node_id.attr,
>> +	&dev_attr_numa_distance.attr,
>> +	&dev_attr_flags.attr,
>> +	&dev_attr_available_instances.attr,
>> +	&dev_attr_algorithms.attr,
>> +	&dev_attr_qfrt_mmio_size.attr,
>> +	&dev_attr_qfrt_dus_size.attr,
>> +	NULL,
>> +};
>> +ATTRIBUTE_GROUPS(uacce_dev);
>> +
>> +static void uacce_release(struct device *dev)
>> +{
>> +	struct uacce_device *uacce = to_uacce_device(dev);
>> +
>> +	kfree(uacce);
>> +}
>> +
>> +/**
>> + * uacce_register - register an accelerator
> This isn't quite correct kernel-doc.  Please run the
> generation script over it and fix any warnings.
>
> 	uacce_register() - register an accelerator
Sure, will add (), though no warning reported from ./scripts/kernel-doc
>
>> + * @parent: pointer of uacce parent device
>> + * @interface: pointer of uacce_interface for register
>> + */
>> +struct uacce_device *uacce_register(struct device *parent,
>> +				    struct uacce_interface *interface)
>> +{
>> +	unsigned int flags = interface->flags;
>> +	struct uacce_device *uacce;
>> +	int ret;
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
>> +	ret = xa_alloc(&uacce_xa, &uacce->dev_id, uacce, xa_limit_32b,
>> +		       GFP_KERNEL);
>> +	if (ret < 0)
>> +		goto err_with_uacce;
>> +
>> +	uacce->cdev = cdev_alloc();
> If we can embed this (see below) then use cdev_init instead.
>
>> +	if (!uacce->cdev) {
>> +		ret = -ENOMEM;
>> +		goto err_with_xa;
>> +	}
>> +
>> +	INIT_LIST_HEAD(&uacce->qs);
>> +	mutex_init(&uacce->q_lock);
>> +	uacce->cdev->ops = &uacce_fops;
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
>> +		goto err_with_xa;
>> +
>> +	return uacce;
>> +
>> +err_with_xa:
>> +	if (uacce->cdev)
>> +		cdev_del(uacce->cdev);
> Why not use a separate label to handle the above rather than checking if
> it's set?
ok,
>
>> +	xa_erase(&uacce_xa, uacce->dev_id);
>> +err_with_uacce:
>> +	if (flags & UACCE_DEV_SVA)
>> +		iommu_dev_disable_feature(uacce->pdev, IOMMU_DEV_FEAT_SVA);
>> +	kfree(uacce);
>> +	return ERR_PTR(ret);
>> +}
>> +EXPORT_SYMBOL_GPL(uacce_register);
>> +
>> +/**
>> + * uacce_unregister - unregisters an accelerator
>> + * @uacce: the accelerator to unregister
>> + */
>> +void uacce_unregister(struct uacce_device *uacce)
>> +{
>> +	if (!uacce)
>> +		return;
>> +
> I'd like to see a comment here on why we are doing things not unwinding
> actions from uacce_register.
OK will add comments.
Here is "ensure no open queue remains"
>> +	mutex_lock(&uacce->q_lock);
>> +	if (!list_empty(&uacce->qs)) {
>> +		struct uacce_queue *q;
>> +
>> +		list_for_each_entry(q, &uacce->qs, list) {
>> +			uacce_put_queue(q);
>> +			if (uacce->flags & UACCE_DEV_SVA)
>> +				iommu_sva_unbind_device(q->handle);
>> +		}
>> +	}
>> +	mutex_unlock(&uacce->q_lock);
>> +
> For these next parts which are the unwind of uacce_register, why are they not
> in the reverse order of what is happening in there (where possible given
> device lifespan). That is why do we not disable the iommu feature much later?
First close all queues, then disable sva feature.
>
>> +	if (uacce->flags & UACCE_DEV_SVA)
>> +		iommu_dev_disable_feature(uacce->pdev, IOMMU_DEV_FEAT_SVA);
>> +
>> +	cdev_device_del(uacce->cdev, &uacce->dev);
>> +	xa_erase(&uacce_xa, uacce->dev_id);
>> +	put_device(&uacce->dev);
>> +}
>> +EXPORT_SYMBOL_GPL(uacce_unregister);
>> +
>> +static int __init uacce_init(void)
>> +{
>> +	int ret;
>> +
>> +	uacce_class = class_create(THIS_MODULE, UACCE_NAME);
>> +	if (IS_ERR(uacce_class))
>> +		return PTR_ERR(uacce_class);
>> +
>> +	ret = alloc_chrdev_region(&uacce_devt, 0, MINORMASK, UACCE_NAME);
>> +	if (ret) {
>> +		class_destroy(uacce_class);
>> +		return ret;
> drop the return ret out of these brackets. i.e.
>
> if (ret)
> 	class_destroy(uacce_class)
>
> return ret;
sure, thanks
>
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static __exit void uacce_exit(void)
>> +{
>> +	unregister_chrdev_region(uacce_devt, MINORMASK);
>> +	class_destroy(uacce_class);
>> +}
>> +
>> +subsys_initcall(uacce_init);
>> +module_exit(uacce_exit);
>> +
>> +MODULE_LICENSE("GPL");
>> +MODULE_AUTHOR("Hisilicon Tech. Co., Ltd.");
>> +MODULE_DESCRIPTION("Accelerator interface for Userland applications");
>> diff --git a/include/linux/uacce.h b/include/linux/uacce.h
>> new file mode 100644
>> index 0000000..04c8643
>> --- /dev/null
>> +++ b/include/linux/uacce.h
>> @@ -0,0 +1,163 @@
>> +/* SPDX-License-Identifier: GPL-2.0-or-later */
>> +#ifndef _LINUX_UACCE_H
>> +#define _LINUX_UACCE_H
>> +
>> +#include <linux/cdev.h>
>> +#include <uapi/misc/uacce/uacce.h>
>> +
>> +#define UACCE_NAME		"uacce"
>> +#define UACCE_QFRT_MAX		16
> What does QFRT stand for?
change to UACCE_MAX_REGION
>> +#define UACCE_MAX_NAME_SIZE	64
>> +
>> +struct uacce_queue;
>> +struct uacce_device;
>> +
>> +/**
>> + * enum uacce_qfr_flag: queue file flag:
>> + * @UACCE_QFRF_SELFMT: self maintained qfr
>> + */
>> +enum uacce_qfr_flag {
>> +	UACCE_QFRF_SELFMT = BIT(0),
>> +};
> Same issue with enums for flags.  Doesn't make much sense to me.
> Only one value can be taken which doesn't make it a flag.
>
>> +
>> +/**
>> + * struct uacce_qfile_region - structure of queue file region
>> + * @type: type of the qfr
>> + * @flags: flags of qfr
>> + * @prot: qfr protection flag
>> + */
>> +struct uacce_qfile_region {
>> +	enum uacce_qfrt type;
>> +	enum uacce_qfr_flag flags;
>> +	u32 prot;
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
> Some of these aren't used on only existing driver.  Introduce them only
> in the series that uses them.
OK
>
>> +	long (*ioctl)(struct uacce_queue *q, unsigned int cmd,
>> +		      unsigned long arg);
>> +};
>> +
>> +/**
>> + * struct uacce_interface
> I think this needs a description for kernel doc (even if it's obvious!)
> Could be wrong though.
OK
>
>> + * @name: the uacce device name.  Will show up in sysfs
>> + * @flags: uacce device attributes
>> + * @ops: pointer to the struct uacce_ops
>> + *
>> + * This structure is used for the uacce_register()
>> + */
>> +struct uacce_interface {
>> +	char name[UACCE_MAX_NAME_SIZE];
>> +	enum uacce_dev_flag flags;
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
>> + * @pid: pid of the process using the queue
>> + * @handle: iommu_sva handle return from iommu_sva_bind_device
>> + * @list: queue list
>> + * @qfrs: pointer of qfr regions
>> + * @state: queue state machine
>> + */
>> +struct uacce_queue {
>> +	struct uacce_device *uacce;
>> +	void *priv;
>> +	wait_queue_head_t wait;
>> +	int pasid;
>> +	pid_t pid;
>> +	struct iommu_sva *handle;
>> +	struct list_head list;
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
>> + * @qs: list head of queue->list
>> + * @q_lock: lock for qs
>> + */
>> +struct uacce_device {
>> +	const char *algs;
>> +	const char *api_ver;
>> +	unsigned long qf_pg_size[UACCE_QFRT_MAX];
>> +	struct uacce_ops *ops;
> Can we make this ops structure a point to a constant struct?
> I'm guessing it'll be fixed for a given driver.
OK
>
>> +	struct device *pdev;
> Perhaps just call it parent. pdev will be confusing with
> pci devices.
OK
>
>> +	bool is_vf;
>> +	u32 flags;
>> +	u32 dev_id;
>> +	u32 prot;
>> +	struct cdev *cdev;
> Can we embed the cdev structure rather than use a pointer
> and separate allocation?
NO, we can't.
We originally embed the cdev structure, and Greg reminded us these two 
structure have different lifetime.
https://lkml.org/lkml/2019/8/28/771
>> +	struct device dev;
>> +	void *priv;
>> +	struct list_head qs;
>> +	struct mutex q_lock;
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
>> index 0000000..a4f9378
>> --- /dev/null
>> +++ b/include/uapi/misc/uacce/uacce.h
>> @@ -0,0 +1,38 @@
>> +/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
>> +#ifndef _UAPIUUACCE_H
>> +#define _UAPIUUACCE_H
>> +
>> +#include <linux/types.h>
>> +#include <linux/ioctl.h>
>> +
>> +/* UACCE_CMD_START_Q: Start the queue */
>> +#define UACCE_CMD_START_Q	_IO('W', 0)
>> +
>> +/**
>> + * UACCE_CMD_PUT_Q:
>> + * User actively stop queue and free queue resource immediately
>> + * Optimization method since close fd may delay
>> + */
>> +#define UACCE_CMD_PUT_Q		_IO('W', 1)
>> +
>> +/**
>> + * enum uacce_dev_flag: Device flags:
>> + * @UACCE_DEV_SVA: Shared Virtual Addresses
>> + *		   Support PASID
>> + *		   Support device page faults (PCI PRI or SMMU Stall)
>> + */
>> +enum uacce_dev_flag {
>> +	UACCE_DEV_SVA = BIT(0),
> As mentioned in docs review, this doesn't look like an enum to me.
> Just use #define for the bit and a suitable sized integer for any
> calls using it.
OK, but there are still more features in the future patch.

Thanks

