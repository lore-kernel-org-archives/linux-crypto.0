Return-Path: <SRS0=cgyY=YY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0023CA9ECB
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Oct 2019 17:53:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B851208E3
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Oct 2019 17:53:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728837AbfJaRx4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Oct 2019 13:53:56 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:42404 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726602AbfJaRx4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Oct 2019 13:53:56 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 8EB3B79752E4F341A339;
        Fri,  1 Nov 2019 01:53:53 +0800 (CST)
Received: from localhost (10.202.226.61) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Fri, 1 Nov 2019
 01:53:47 +0800
Date:   Thu, 31 Oct 2019 17:13:57 +0000
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
        <iommu@lists.linux-foundation.org>,
        Kenneth Lee <liguozhu@hisilicon.com>,
        Zaibo Xu <xuzaibo@huawei.com>
Subject: Re: [PATCH v7 2/3] uacce: add uacce driver
Message-ID: <20191031171357.000067c7@huawei.com>
In-Reply-To: <1572331216-9503-3-git-send-email-zhangfei.gao@linaro.org>
References: <1572331216-9503-1-git-send-email-zhangfei.gao@linaro.org>
        <1572331216-9503-3-git-send-email-zhangfei.gao@linaro.org>
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

On Tue, 29 Oct 2019 14:40:15 +0800
Zhangfei Gao <zhangfei.gao@linaro.org> wrote:

> From: Kenneth Lee <liguozhu@hisilicon.com>
> 
> Uacce (Unified/User-space-access-intended Accelerator Framework) targets to
> provide Shared Virtual Addressing (SVA) between accelerators and processes.
> So accelerator can access any data structure of the main cpu.
> This differs from the data sharing between cpu and io device, which share
> data content rather than address.
> Since unified address, hardware and user space of process can share the
> same virtual address in the communication.
> 
> Uacce create a chrdev for every registration, the queue is allocated to
> the process when the chrdev is opened. Then the process can access the
> hardware resource by interact with the queue file. By mmap the queue
> file space to user space, the process can directly put requests to the
> hardware without syscall to the kernel space.
> 
> Signed-off-by: Kenneth Lee <liguozhu@hisilicon.com>
> Signed-off-by: Zaibo Xu <xuzaibo@huawei.com>
> Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
> Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>

Great, much more compact.

I've not gone through this in detail yet but a few initial comments inline.

Thanks,

Jonathan

> ---
>  Documentation/ABI/testing/sysfs-driver-uacce |  53 +++
>  drivers/misc/Kconfig                         |   1 +
>  drivers/misc/Makefile                        |   1 +
>  drivers/misc/uacce/Kconfig                   |  13 +
>  drivers/misc/uacce/Makefile                  |   2 +
>  drivers/misc/uacce/uacce.c                   | 574 +++++++++++++++++++++++++++
>  include/linux/uacce.h                        | 163 ++++++++
>  include/uapi/misc/uacce/uacce.h              |  38 ++
>  8 files changed, 845 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-driver-uacce
>  create mode 100644 drivers/misc/uacce/Kconfig
>  create mode 100644 drivers/misc/uacce/Makefile
>  create mode 100644 drivers/misc/uacce/uacce.c
>  create mode 100644 include/linux/uacce.h
>  create mode 100644 include/uapi/misc/uacce/uacce.h
> 
> diff --git a/Documentation/ABI/testing/sysfs-driver-uacce b/Documentation/ABI/testing/sysfs-driver-uacce
> new file mode 100644
> index 0000000..35699dc
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-driver-uacce
> @@ -0,0 +1,53 @@
> +What:           /sys/class/uacce/<dev_name>/id
> +Date:           Oct 2019
> +KernelVersion:  5.5
> +Contact:        linux-accelerators@lists.ozlabs.org
> +Description:    Id of the device.
> +
> +What:           /sys/class/uacce/<dev_name>/api
> +Date:           Oct 2019
> +KernelVersion:  5.5
> +Contact:        linux-accelerators@lists.ozlabs.org
> +Description:    Api of the device, used by application to match the correct driver
> +
> +What:           /sys/class/uacce/<dev_name>/flags
> +Date:           Oct 2019
> +KernelVersion:  5.5
> +Contact:        linux-accelerators@lists.ozlabs.org
> +Description:    Attributes of the device, see UACCE_DEV_xxx flag defined in uacce.h
> +
> +What:           /sys/class/uacce/<dev_name>/available_instances
> +Date:           Oct 2019
> +KernelVersion:  5.5
> +Contact:        linux-accelerators@lists.ozlabs.org
> +Description:    Available instances left of the device
> +
> +What:           /sys/class/uacce/<dev_name>/algorithms
> +Date:           Oct 2019
> +KernelVersion:  5.5
> +Contact:        linux-accelerators@lists.ozlabs.org
> +Description:    Algorithms supported by this accelerator
How are they separated?  Userspace code needs to know that.
(comma, tab, newline?)

> +
> +What:           /sys/class/uacce/<dev_name>/qfrt_mmio_size

qfrt is not the most obvious naming ever.  Do we care beyond its
a region for this interface?  region_mmio_size maybe?

> +Date:           Oct 2019
> +KernelVersion:  5.5
> +Contact:        linux-accelerators@lists.ozlabs.org
> +Description:    Page size of mmio region queue file

Size of page in this region, or number of pages in the region?

> +
> +What:           /sys/class/uacce/<dev_name>/qfrt_dus_size
> +Date:           Oct 2019
> +KernelVersion:  5.5
> +Contact:        linux-accelerators@lists.ozlabs.org
> +Description:    Page size of dus region queue file
> +
> +What:           /sys/class/uacce/<dev_name>/numa_distance
> +Date:           Oct 2019
> +KernelVersion:  5.5
> +Contact:        linux-accelerators@lists.ozlabs.org
> +Description:    Distance of device node to cpu node

I wonder if we should be doing this in here. There are other standard
ways of obtaining this for the device.  Follow parent and check node_id
there then use the /sys/bus/node path to find out the distances.

> +
> +What:           /sys/class/uacce/<dev_name>/node_id
> +Date:           Oct 2019
> +KernelVersion:  5.5
> +Contact:        linux-accelerators@lists.ozlabs.org
> +Description:    Id of the numa node
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index c55b637..929feb0 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -481,4 +481,5 @@ source "drivers/misc/cxl/Kconfig"
>  source "drivers/misc/ocxl/Kconfig"
>  source "drivers/misc/cardreader/Kconfig"
>  source "drivers/misc/habanalabs/Kconfig"
> +source "drivers/misc/uacce/Kconfig"
>  endmenu
> diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
> index c1860d3..9abf292 100644
> --- a/drivers/misc/Makefile
> +++ b/drivers/misc/Makefile
> @@ -56,4 +56,5 @@ obj-$(CONFIG_OCXL)		+= ocxl/
>  obj-y				+= cardreader/
>  obj-$(CONFIG_PVPANIC)   	+= pvpanic.o
>  obj-$(CONFIG_HABANA_AI)		+= habanalabs/
> +obj-$(CONFIG_UACCE)		+= uacce/
>  obj-$(CONFIG_XILINX_SDFEC)	+= xilinx_sdfec.o
> diff --git a/drivers/misc/uacce/Kconfig b/drivers/misc/uacce/Kconfig
> new file mode 100644
> index 0000000..5e39b60
> --- /dev/null
> +++ b/drivers/misc/uacce/Kconfig
> @@ -0,0 +1,13 @@
> +config UACCE
> +	tristate "Accelerator Framework for User Land"
> +	depends on IOMMU_API
> +	help
> +	  UACCE provides interface for the user process to access the hardware
> +	  without interaction with the kernel space in data path.
> +
> +	  The user-space interface is described in
> +	  include/uapi/misc/uacce/uacce.h
> +
> +	  See Documentation/misc-devices/uacce.rst for more details.
> +
> +	  If you don't know what to do here, say N.

Pessimist :) Everyone should want uacce so don't put them off.  Having said
that perhaps for now it should be hidden and enabled on a driver by driver
basis?

> diff --git a/drivers/misc/uacce/Makefile b/drivers/misc/uacce/Makefile
> new file mode 100644
> index 0000000..5b4374e
> --- /dev/null
> +++ b/drivers/misc/uacce/Makefile
> @@ -0,0 +1,2 @@
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +obj-$(CONFIG_UACCE) += uacce.o
> diff --git a/drivers/misc/uacce/uacce.c b/drivers/misc/uacce/uacce.c
> new file mode 100644
> index 0000000..2b6b038
> --- /dev/null
> +++ b/drivers/misc/uacce/uacce.c
> @@ -0,0 +1,574 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +#include <linux/compat.h>
> +#include <linux/dma-iommu.h>
> +#include <linux/module.h>
> +#include <linux/poll.h>
> +#include <linux/uacce.h>
> +
> +static struct class *uacce_class;
> +static dev_t uacce_devt;
> +static DEFINE_MUTEX(uacce_mutex);
> +static DEFINE_XARRAY_ALLOC(uacce_xa);
> +
> +static int uacce_start_queue(struct uacce_queue *q)
> +{
> +	int ret = -EINVAL;
> +
> +	mutex_lock(&uacce_mutex);
> +
> +	if (q->state != UACCE_Q_INIT)
> +		goto out_with_lock;
> +
> +	if (q->uacce->ops->start_queue) {
> +		ret = q->uacce->ops->start_queue(q);
> +		if (ret < 0)
> +			goto out_with_lock;
> +	}
> +
> +	q->state = UACCE_Q_STARTED;
out_with_lock:
> +	mutex_unlock(&uacce_mutex);
> +
return ret;
Though need to handle ret a bit differently above...

> +	return 0;
> +
> +out_with_lock:
> +	mutex_unlock(&uacce_mutex);
> +	return ret;
> +}
> +
> +static int uacce_put_queue(struct uacce_queue *q)
> +{
> +	struct uacce_device *uacce = q->uacce;
> +
> +	mutex_lock(&uacce_mutex);
> +
> +	if (q->state == UACCE_Q_ZOMBIE)
> +		goto out;
> +
> +	if ((q->state == UACCE_Q_STARTED) && uacce->ops->stop_queue)
> +		uacce->ops->stop_queue(q);
> +
> +	if ((q->state == UACCE_Q_INIT || q->state == UACCE_Q_STARTED) &&
> +	     uacce->ops->put_queue)
> +		uacce->ops->put_queue(q);
> +
> +	q->state = UACCE_Q_ZOMBIE;
> +out:
> +	mutex_unlock(&uacce_mutex);
> +
> +	return 0;
> +}
> +
> +static long uacce_fops_unl_ioctl(struct file *filep,
> +				 unsigned int cmd, unsigned long arg)
> +{
> +	struct uacce_queue *q = filep->private_data;
> +	struct uacce_device *uacce = q->uacce;
> +
> +	switch (cmd) {
> +	case UACCE_CMD_START_Q:
> +		return uacce_start_queue(q);
> +
> +	case UACCE_CMD_PUT_Q:
> +		return uacce_put_queue(q);
> +
> +	default:
> +		if (!uacce->ops->ioctl)
> +			return -EINVAL;
> +
> +		return uacce->ops->ioctl(q, cmd, arg);
> +	}
> +}
> +
> +#ifdef CONFIG_COMPAT
> +static long uacce_fops_compat_ioctl(struct file *filep,
> +				   unsigned int cmd, unsigned long arg)
> +{
> +	arg = (unsigned long)compat_ptr(arg);
> +
> +	return uacce_fops_unl_ioctl(filep, cmd, arg);
> +}
> +#endif
> +
> +static int uacce_sva_exit(struct device *dev, struct iommu_sva *handle,
> +			  void *data)
> +{
> +	struct uacce_device *uacce = data;
> +	struct uacce_queue *q;
> +
> +	mutex_lock(&uacce->q_lock);
> +	list_for_each_entry(q, &uacce->qs, list) {
> +		if (q->pid == task_pid_nr(current))
> +			uacce_put_queue(q);
> +	}
> +	mutex_unlock(&uacce->q_lock);
> +
> +	return 0;
> +}
> +
> +static struct iommu_sva_ops uacce_sva_ops = {
> +	.mm_exit = uacce_sva_exit,
> +};
> +
> +static int uacce_fops_open(struct inode *inode, struct file *filep)
> +{
> +	struct iommu_sva *handle = NULL;
> +	struct uacce_device *uacce;
> +	struct uacce_queue *q;
> +	int ret = 0;
> +	int pasid = 0;
> +
> +	uacce = xa_load(&uacce_xa, iminor(inode));
> +	if (!uacce)
> +		return -ENODEV;
> +
> +	if (!try_module_get(uacce->pdev->driver->owner))
> +		return -ENODEV;
> +
> +	q = kzalloc(sizeof(struct uacce_queue), GFP_KERNEL);
> +	if (!q) {
> +		ret = -ENOMEM;
> +		goto out_with_module;
> +	}
> +
> +	if (uacce->flags & UACCE_DEV_SVA) {
> +		handle = iommu_sva_bind_device(uacce->pdev, current->mm, uacce);
> +		if (IS_ERR(handle))
> +			goto out_with_mem;
> +
> +		ret = iommu_sva_set_ops(handle, &uacce_sva_ops);
> +		if (ret)
> +			goto out_unbind;
> +
> +		pasid = iommu_sva_get_pasid(handle);
> +		if (pasid == IOMMU_PASID_INVALID)
> +			goto out_unbind;
> +	}
> +
> +	if (uacce->ops->get_queue) {
> +		ret = uacce->ops->get_queue(uacce, pasid, q);
> +		if (ret < 0)
> +			goto out_unbind;
> +	}
> +
> +	q->pid = task_pid_nr(current);
> +	q->pasid = pasid;
> +	q->handle = handle;
> +	q->uacce = uacce;
> +	memset(q->qfrs, 0, sizeof(q->qfrs));
> +	init_waitqueue_head(&q->wait);
> +	filep->private_data = q;
> +	q->state = UACCE_Q_INIT;
> +
> +	mutex_lock(&uacce->q_lock);
> +	list_add(&q->list, &uacce->qs);
> +	mutex_unlock(&uacce->q_lock);
> +
> +	return 0;
> +
> +out_unbind:
> +	if (uacce->flags & UACCE_DEV_SVA)
> +		iommu_sva_unbind_device(handle);
> +out_with_mem:
> +	kfree(q);
> +out_with_module:
> +	module_put(uacce->pdev->driver->owner);
> +	return ret;
> +}
> +
> +static int uacce_fops_release(struct inode *inode, struct file *filep)
> +{
> +	struct uacce_queue *q = filep->private_data;
> +	struct uacce_device *uacce = q->uacce;
> +
> +	uacce_put_queue(q);
> +
> +	if (uacce->flags & UACCE_DEV_SVA)
> +		iommu_sva_unbind_device(q->handle);
> +
> +	mutex_lock(&uacce->q_lock);
> +	list_del(&q->list);
> +	mutex_unlock(&uacce->q_lock);
> +	kfree(q);
> +	module_put(uacce->pdev->driver->owner);
> +
> +	return 0;
> +}
> +
> +static void uacce_vma_close(struct vm_area_struct *vma)
> +{
> +	struct uacce_queue *q = vma->vm_private_data;
> +	enum uacce_qfrt type = 0;
> +
> +	if (vma->vm_pgoff < UACCE_QFRT_MAX)
> +		type = vma->vm_pgoff;
> +
> +	kfree(q->qfrs[type]);
> +}
> +
> +static const struct vm_operations_struct uacce_vm_ops = {
> +	.close = uacce_vma_close,
> +};
> +
> +static struct uacce_qfile_region *
> +uacce_create_region(struct uacce_queue *q, struct vm_area_struct *vma,
> +		    enum uacce_qfrt type, unsigned int flags)
> +{
> +	struct uacce_device *uacce = q->uacce;
> +	struct uacce_qfile_region *qfr;
> +	int ret = -ENOMEM;
> +
> +	qfr = kzalloc(sizeof(*qfr), GFP_KERNEL);
> +	if (!qfr)
> +		return ERR_PTR(-ENOMEM);
> +
> +	qfr->type = type;
> +	qfr->flags = flags;
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
> +
> +	return qfr;
> +
> +err_with_qfr:
> +	kfree(qfr);
> +	return ERR_PTR(ret);
> +}
> +
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

Could put
out_with_lock:
here and return ret instead of 0.
You'll need to set ret to default to 0 in that
case though.

> +	mutex_unlock(&uacce_mutex);
> +
> +	return 0;
> +
> +out_with_lock:
> +	mutex_unlock(&uacce_mutex);
> +	return ret;
> +}
> +
> +static __poll_t uacce_fops_poll(struct file *file, poll_table *wait)
> +{
> +	struct uacce_queue *q = file->private_data;
> +	struct uacce_device *uacce = q->uacce;
> +
> +	poll_wait(file, &q->wait, wait);
> +	if (uacce->ops->is_q_updated && uacce->ops->is_q_updated(q))
> +		return EPOLLIN | EPOLLRDNORM;
> +
> +	return 0;
> +}
> +
> +static const struct file_operations uacce_fops = {
> +	.owner		= THIS_MODULE,
> +	.open		= uacce_fops_open,
> +	.release	= uacce_fops_release,
> +	.unlocked_ioctl	= uacce_fops_unl_ioctl,
> +#ifdef CONFIG_COMPAT
> +	.compat_ioctl	= uacce_fops_compat_ioctl,
> +#endif
> +	.mmap		= uacce_fops_mmap,
> +	.poll		= uacce_fops_poll,
> +};
> +
> +#define to_uacce_device(dev) container_of(dev, struct uacce_device, dev)
> +
> +static ssize_t id_show(struct device *dev,
> +		       struct device_attribute *attr, char *buf)
> +{
> +	struct uacce_device *uacce = to_uacce_device(dev);
> +
> +	return sprintf(buf, "%d\n", uacce->dev_id);
> +}
> +
> +static ssize_t api_show(struct device *dev,
> +			struct device_attribute *attr, char *buf)
> +{
> +	struct uacce_device *uacce = to_uacce_device(dev);
> +
> +	return sprintf(buf, "%s\n", uacce->api_ver);
> +}
> +
> +static ssize_t numa_distance_show(struct device *dev,
> +				  struct device_attribute *attr, char *buf)
> +{
> +	struct uacce_device *uacce = to_uacce_device(dev);
> +	int distance;
> +
> +	distance = node_distance(smp_processor_id(), uacce->pdev->numa_node);
> +
> +	return sprintf(buf, "%d\n", abs(distance));
> +}
> +
> +static ssize_t node_id_show(struct device *dev,
> +			    struct device_attribute *attr, char *buf)
> +{
> +	struct uacce_device *uacce = to_uacce_device(dev);
> +	int node_id;
> +
> +	node_id = dev_to_node(uacce->pdev);
> +
> +	return sprintf(buf, "%d\n", node_id);
> +}
> +
> +static ssize_t flags_show(struct device *dev,
> +			  struct device_attribute *attr, char *buf)
> +{
> +	struct uacce_device *uacce = to_uacce_device(dev);
> +
> +	return sprintf(buf, "%u\n", uacce->flags);
> +}
> +
> +static ssize_t available_instances_show(struct device *dev,
> +					struct device_attribute *attr,
> +					char *buf)
> +{
> +	struct uacce_device *uacce = to_uacce_device(dev);
> +	int val = 0;
> +
> +	if (uacce->ops->get_available_instances)
> +		val = uacce->ops->get_available_instances(uacce);
> +
> +	return sprintf(buf, "%d\n", val);
> +}
> +
> +static ssize_t algorithms_show(struct device *dev,
> +			       struct device_attribute *attr, char *buf)
> +{
> +	struct uacce_device *uacce = to_uacce_device(dev);
> +
> +	return sprintf(buf, "%s", uacce->algs);
Any risk algs won't have the \n?
I'd kind of expect it to be a null termated arrays to allow the core
to format it however it wants to.

> +}
> +
> +static ssize_t qfrt_mmio_size_show(struct device *dev,
> +				   struct device_attribute *attr, char *buf)
> +{
> +	struct uacce_device *uacce = to_uacce_device(dev);
> +
> +	return sprintf(buf, "%lu\n",
> +		       uacce->qf_pg_size[UACCE_QFRT_MMIO] << PAGE_SHIFT);
> +}
> +
> +static ssize_t qfrt_dus_size_show(struct device *dev,
> +				  struct device_attribute *attr, char *buf)
> +{
> +	struct uacce_device *uacce = to_uacce_device(dev);
> +
> +	return sprintf(buf, "%lu\n",
> +		       uacce->qf_pg_size[UACCE_QFRT_DUS] << PAGE_SHIFT);
> +}
> +
> +static DEVICE_ATTR_RO(id);
> +static DEVICE_ATTR_RO(api);
> +static DEVICE_ATTR_RO(numa_distance);
> +static DEVICE_ATTR_RO(node_id);
> +static DEVICE_ATTR_RO(flags);
> +static DEVICE_ATTR_RO(available_instances);
> +static DEVICE_ATTR_RO(algorithms);
> +static DEVICE_ATTR_RO(qfrt_mmio_size);
> +static DEVICE_ATTR_RO(qfrt_dus_size);
> +
> +static struct attribute *uacce_dev_attrs[] = {
> +	&dev_attr_id.attr,
> +	&dev_attr_api.attr,
> +	&dev_attr_node_id.attr,
> +	&dev_attr_numa_distance.attr,
> +	&dev_attr_flags.attr,
> +	&dev_attr_available_instances.attr,
> +	&dev_attr_algorithms.attr,
> +	&dev_attr_qfrt_mmio_size.attr,
> +	&dev_attr_qfrt_dus_size.attr,
> +	NULL,
> +};
> +ATTRIBUTE_GROUPS(uacce_dev);
> +
> +static void uacce_release(struct device *dev)
> +{
> +	struct uacce_device *uacce = to_uacce_device(dev);
> +
> +	kfree(uacce);
> +}
> +
> +/**
> + * uacce_register - register an accelerator
This isn't quite correct kernel-doc.  Please run the
generation script over it and fix any warnings.

	uacce_register() - register an accelerator

> + * @parent: pointer of uacce parent device
> + * @interface: pointer of uacce_interface for register
> + */
> +struct uacce_device *uacce_register(struct device *parent,
> +				    struct uacce_interface *interface)
> +{
> +	unsigned int flags = interface->flags;
> +	struct uacce_device *uacce;
> +	int ret;
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
> +	ret = xa_alloc(&uacce_xa, &uacce->dev_id, uacce, xa_limit_32b,
> +		       GFP_KERNEL);
> +	if (ret < 0)
> +		goto err_with_uacce;
> +
> +	uacce->cdev = cdev_alloc();

If we can embed this (see below) then use cdev_init instead.

> +	if (!uacce->cdev) {
> +		ret = -ENOMEM;
> +		goto err_with_xa;
> +	}
> +
> +	INIT_LIST_HEAD(&uacce->qs);
> +	mutex_init(&uacce->q_lock);
> +	uacce->cdev->ops = &uacce_fops;
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
> +		goto err_with_xa;
> +
> +	return uacce;
> +
> +err_with_xa:
> +	if (uacce->cdev)
> +		cdev_del(uacce->cdev);
Why not use a separate label to handle the above rather than checking if
it's set?

> +	xa_erase(&uacce_xa, uacce->dev_id);
> +err_with_uacce:
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
> +	if (!uacce)
> +		return;
> +

I'd like to see a comment here on why we are doing things not unwinding
actions from uacce_register.

> +	mutex_lock(&uacce->q_lock);
> +	if (!list_empty(&uacce->qs)) {
> +		struct uacce_queue *q;
> +
> +		list_for_each_entry(q, &uacce->qs, list) {
> +			uacce_put_queue(q);
> +			if (uacce->flags & UACCE_DEV_SVA)
> +				iommu_sva_unbind_device(q->handle);
> +		}
> +	}
> +	mutex_unlock(&uacce->q_lock);
> +

For these next parts which are the unwind of uacce_register, why are they not
in the reverse order of what is happening in there (where possible given
device lifespan). That is why do we not disable the iommu feature much later?

> +	if (uacce->flags & UACCE_DEV_SVA)
> +		iommu_dev_disable_feature(uacce->pdev, IOMMU_DEV_FEAT_SVA);
> +
> +	cdev_device_del(uacce->cdev, &uacce->dev);
> +	xa_erase(&uacce_xa, uacce->dev_id);
> +	put_device(&uacce->dev);
> +}
> +EXPORT_SYMBOL_GPL(uacce_unregister);
> +
> +static int __init uacce_init(void)
> +{
> +	int ret;
> +
> +	uacce_class = class_create(THIS_MODULE, UACCE_NAME);
> +	if (IS_ERR(uacce_class))
> +		return PTR_ERR(uacce_class);
> +
> +	ret = alloc_chrdev_region(&uacce_devt, 0, MINORMASK, UACCE_NAME);
> +	if (ret) {
> +		class_destroy(uacce_class);
> +		return ret;
drop the return ret out of these brackets. i.e.

if (ret)
	class_destroy(uacce_class)

return ret;

> +	}
> +
> +	return 0;
> +}
> +
> +static __exit void uacce_exit(void)
> +{
> +	unregister_chrdev_region(uacce_devt, MINORMASK);
> +	class_destroy(uacce_class);
> +}
> +
> +subsys_initcall(uacce_init);
> +module_exit(uacce_exit);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Hisilicon Tech. Co., Ltd.");
> +MODULE_DESCRIPTION("Accelerator interface for Userland applications");
> diff --git a/include/linux/uacce.h b/include/linux/uacce.h
> new file mode 100644
> index 0000000..04c8643
> --- /dev/null
> +++ b/include/linux/uacce.h
> @@ -0,0 +1,163 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +#ifndef _LINUX_UACCE_H
> +#define _LINUX_UACCE_H
> +
> +#include <linux/cdev.h>
> +#include <uapi/misc/uacce/uacce.h>
> +
> +#define UACCE_NAME		"uacce"
> +#define UACCE_QFRT_MAX		16
What does QFRT stand for?
> +#define UACCE_MAX_NAME_SIZE	64
> +
> +struct uacce_queue;
> +struct uacce_device;
> +
> +/**
> + * enum uacce_qfr_flag: queue file flag:
> + * @UACCE_QFRF_SELFMT: self maintained qfr
> + */
> +enum uacce_qfr_flag {
> +	UACCE_QFRF_SELFMT = BIT(0),
> +};

Same issue with enums for flags.  Doesn't make much sense to me.
Only one value can be taken which doesn't make it a flag.

> +
> +/**
> + * struct uacce_qfile_region - structure of queue file region
> + * @type: type of the qfr
> + * @flags: flags of qfr
> + * @prot: qfr protection flag
> + */
> +struct uacce_qfile_region {
> +	enum uacce_qfrt type;
> +	enum uacce_qfr_flag flags;
> +	u32 prot;
> +};
> +
> +/**
> + * struct uacce_ops - uacce device operations
> + * @get_available_instances:  get available instances left of the device
> + * @get_queue: get a queue from the device
> + * @put_queue: free a queue to the device
> + * @start_queue: make the queue start work after get_queue
> + * @stop_queue: make the queue stop work before put_queue
> + * @is_q_updated: check whether the task is finished
> + * @mask_notify: mask the task irq of queue
> + * @mmap: mmap addresses of queue to user space
> + * @reset: reset the uacce device
> + * @reset_queue: reset the queue
> + * @ioctl: ioctl for user space users of the queue
> + */
> +struct uacce_ops {
> +	int (*get_available_instances)(struct uacce_device *uacce);
> +	int (*get_queue)(struct uacce_device *uacce, unsigned long arg,
> +			 struct uacce_queue *q);
> +	void (*put_queue)(struct uacce_queue *q);
> +	int (*start_queue)(struct uacce_queue *q);
> +	void (*stop_queue)(struct uacce_queue *q);
> +	int (*is_q_updated)(struct uacce_queue *q);
> +	void (*mask_notify)(struct uacce_queue *q, int event_mask);
> +	int (*mmap)(struct uacce_queue *q, struct vm_area_struct *vma,
> +		    struct uacce_qfile_region *qfr);
> +	int (*reset)(struct uacce_device *uacce);
> +	int (*reset_queue)(struct uacce_queue *q);

Some of these aren't used on only existing driver.  Introduce them only
in the series that uses them.

> +	long (*ioctl)(struct uacce_queue *q, unsigned int cmd,
> +		      unsigned long arg);
> +};
> +
> +/**
> + * struct uacce_interface
I think this needs a description for kernel doc (even if it's obvious!)
Could be wrong though.

> + * @name: the uacce device name.  Will show up in sysfs
> + * @flags: uacce device attributes
> + * @ops: pointer to the struct uacce_ops
> + *
> + * This structure is used for the uacce_register()
> + */
> +struct uacce_interface {
> +	char name[UACCE_MAX_NAME_SIZE];
> +	enum uacce_dev_flag flags;
> +	struct uacce_ops *ops;
> +};
> +
> +enum uacce_q_state {
> +	UACCE_Q_INIT,
> +	UACCE_Q_STARTED,
> +	UACCE_Q_ZOMBIE,
> +};
> +
> +/**
> + * struct uacce_queue
> + * @uacce: pointer to uacce
> + * @priv: private pointer
> + * @wait: wait queue head
> + * @pasid: pasid of the queue
> + * @pid: pid of the process using the queue
> + * @handle: iommu_sva handle return from iommu_sva_bind_device
> + * @list: queue list
> + * @qfrs: pointer of qfr regions
> + * @state: queue state machine
> + */
> +struct uacce_queue {
> +	struct uacce_device *uacce;
> +	void *priv;
> +	wait_queue_head_t wait;
> +	int pasid;
> +	pid_t pid;
> +	struct iommu_sva *handle;
> +	struct list_head list;
> +	struct uacce_qfile_region *qfrs[UACCE_QFRT_MAX];
> +	enum uacce_q_state state;
> +};
> +
> +/**
> + * struct uacce_device
> + * @algs: supported algorithms
> + * @api_ver: api version
> + * @qf_pg_size: page size of the queue file regions
> + * @ops: pointer to the struct uacce_ops
> + * @pdev: pointer to the parent device
> + * @is_vf: whether virtual function
> + * @flags: uacce attributes
> + * @dev_id: id of the uacce device
> + * @prot: uacce protection flag
> + * @cdev: cdev of the uacce
> + * @dev: dev of the uacce
> + * @priv: private pointer of the uacce
> + * @qs: list head of queue->list
> + * @q_lock: lock for qs
> + */
> +struct uacce_device {
> +	const char *algs;
> +	const char *api_ver;
> +	unsigned long qf_pg_size[UACCE_QFRT_MAX];
> +	struct uacce_ops *ops;

Can we make this ops structure a point to a constant struct?
I'm guessing it'll be fixed for a given driver.

> +	struct device *pdev;

Perhaps just call it parent. pdev will be confusing with
pci devices.

> +	bool is_vf;
> +	u32 flags;
> +	u32 dev_id;
> +	u32 prot;
> +	struct cdev *cdev;

Can we embed the cdev structure rather than use a pointer
and separate allocation?

> +	struct device dev;
> +	void *priv;
> +	struct list_head qs;
> +	struct mutex q_lock;
> +};
> +
> +#if IS_ENABLED(CONFIG_UACCE)
> +
> +struct uacce_device *uacce_register(struct device *parent,
> +				    struct uacce_interface *interface);
> +void uacce_unregister(struct uacce_device *uacce);
> +
> +#else /* CONFIG_UACCE */
> +
> +static inline
> +struct uacce_device *uacce_register(struct device *parent,
> +				    struct uacce_interface *interface)
> +{
> +	return ERR_PTR(-ENODEV);
> +}
> +
> +static inline void uacce_unregister(struct uacce_device *uacce) {}
> +
> +#endif /* CONFIG_UACCE */
> +
> +#endif /* _LINUX_UACCE_H */
> diff --git a/include/uapi/misc/uacce/uacce.h b/include/uapi/misc/uacce/uacce.h
> new file mode 100644
> index 0000000..a4f9378
> --- /dev/null
> +++ b/include/uapi/misc/uacce/uacce.h
> @@ -0,0 +1,38 @@
> +/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
> +#ifndef _UAPIUUACCE_H
> +#define _UAPIUUACCE_H
> +
> +#include <linux/types.h>
> +#include <linux/ioctl.h>
> +
> +/* UACCE_CMD_START_Q: Start the queue */
> +#define UACCE_CMD_START_Q	_IO('W', 0)
> +
> +/**
> + * UACCE_CMD_PUT_Q:
> + * User actively stop queue and free queue resource immediately
> + * Optimization method since close fd may delay
> + */
> +#define UACCE_CMD_PUT_Q		_IO('W', 1)
> +
> +/**
> + * enum uacce_dev_flag: Device flags:
> + * @UACCE_DEV_SVA: Shared Virtual Addresses
> + *		   Support PASID
> + *		   Support device page faults (PCI PRI or SMMU Stall)
> + */
> +enum uacce_dev_flag {
> +	UACCE_DEV_SVA = BIT(0),

As mentioned in docs review, this doesn't look like an enum to me.
Just use #define for the bit and a suitable sized integer for any
calls using it.

> +};
> +
> +/**
> + * enum uacce_qfrt: qfrt type
> + * @UACCE_QFRT_MMIO: device mmio region
> + * @UACCE_QFRT_DUS: device user share region
> + */
> +enum uacce_qfrt {
> +	UACCE_QFRT_MMIO = 0,
> +	UACCE_QFRT_DUS = 1,
> +};
> +
> +#endif


