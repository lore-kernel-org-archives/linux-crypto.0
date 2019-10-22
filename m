Return-Path: <SRS0=VsUo=YP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9473CCA9EA0
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Oct 2019 18:49:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E61121872
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Oct 2019 18:49:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QTIivOI2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732436AbfJVStn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Oct 2019 14:49:43 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:34245 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731740AbfJVStn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Oct 2019 14:49:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571770180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E8O0t5mLKWMFyC+5V3TRZF/YQRc/K3yE/f9aNuc6HAk=;
        b=QTIivOI2S6Nn2tOmZdZ8TR/fDPveRe8uszUs3bdmr0n6JKBErEQNY79SBvVBXGjuZBXS7O
        B9ICdoEEJ2ccVu+CjDw/Hwlo2GBttU+U5fULwCsCFZCbuXWyS69Jmam4Kb7Lm4EYnlnZFp
        gS9F3jgGn6aqEuY4rVHnkmAnTFHtX7A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-334-abQy8RriPZeDeCy9ykJPoQ-1; Tue, 22 Oct 2019 14:49:36 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 590151005500;
        Tue, 22 Oct 2019 18:49:33 +0000 (UTC)
Received: from redhat.com (unknown [10.20.6.178])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EA7C460166;
        Tue, 22 Oct 2019 18:49:30 +0000 (UTC)
Date:   Tue, 22 Oct 2019 14:49:29 -0400
From:   Jerome Glisse <jglisse@redhat.com>
To:     Zhangfei Gao <zhangfei.gao@linaro.org>
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
Subject: Re: [PATCH v6 2/3] uacce: add uacce driver
Message-ID: <20191022184929.GC5169@redhat.com>
References: <1571214873-27359-1-git-send-email-zhangfei.gao@linaro.org>
 <1571214873-27359-3-git-send-email-zhangfei.gao@linaro.org>
MIME-Version: 1.0
In-Reply-To: <1571214873-27359-3-git-send-email-zhangfei.gao@linaro.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: abQy8RriPZeDeCy9ykJPoQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 16, 2019 at 04:34:32PM +0800, Zhangfei Gao wrote:
> From: Kenneth Lee <liguozhu@hisilicon.com>
>=20
> Uacce (Unified/User-space-access-intended Accelerator Framework) targets =
to
> provide Shared Virtual Addressing (SVA) between accelerators and processe=
s.
> So accelerator can access any data structure of the main cpu.
> This differs from the data sharing between cpu and io device, which share
> data content rather than address.
> Since unified address, hardware and user space of process can share the
> same virtual address in the communication.
>=20
> Uacce create a chrdev for every registration, the queue is allocated to
> the process when the chrdev is opened. Then the process can access the
> hardware resource by interact with the queue file. By mmap the queue
> file space to user space, the process can directly put requests to the
> hardware without syscall to the kernel space.

You need to remove all API that is not use by your first driver as
it will most likely bit rot without users. It is way better to add
things when a driver start to make use of it.

I am still not convince of the value of adding a new framework here
with only a single device as an example. It looks similar to some of
the fpga devices. Saddly because framework layering is not something
that exist i guess inventing a new framework is the only answer when
you can not quite fit into an existing one.

More fundamental question is why do you need to change the IOMMU
domain of the device ? I do not see any reason for that unless the
PASID has some restriction on ARM that i do not know of.

I do have multiple comments and point out various serious issues
below.

As it is from my POV it is a NAK. Note that i am not opposing of
adding a new framework, just that you need to trim things down
to what is use by your first driver and you also need to address
the various issues i point out below.

Cheers,
J=E9r=F4me

>=20
> Signed-off-by: Kenneth Lee <liguozhu@hisilicon.com>
> Signed-off-by: Zaibo Xu <xuzaibo@huawei.com>
> Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
> Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
> ---
>  Documentation/ABI/testing/sysfs-driver-uacce |  65 ++
>  drivers/misc/Kconfig                         |   1 +
>  drivers/misc/Makefile                        |   1 +
>  drivers/misc/uacce/Kconfig                   |  13 +
>  drivers/misc/uacce/Makefile                  |   2 +
>  drivers/misc/uacce/uacce.c                   | 995 +++++++++++++++++++++=
++++++
>  include/linux/uacce.h                        | 168 +++++
>  include/uapi/misc/uacce/uacce.h              |  41 ++
>  8 files changed, 1286 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-driver-uacce
>  create mode 100644 drivers/misc/uacce/Kconfig
>  create mode 100644 drivers/misc/uacce/Makefile
>  create mode 100644 drivers/misc/uacce/uacce.c
>  create mode 100644 include/linux/uacce.h
>  create mode 100644 include/uapi/misc/uacce/uacce.h
>=20

[...]

> diff --git a/drivers/misc/uacce/uacce.c b/drivers/misc/uacce/uacce.c
> new file mode 100644
> index 0000000..534ddc3
> --- /dev/null
> +++ b/drivers/misc/uacce/uacce.c
> @@ -0,0 +1,995 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +#include <linux/compat.h>
> +#include <linux/dma-iommu.h>
> +#include <linux/file.h>
> +#include <linux/irqdomain.h>
> +#include <linux/module.h>
> +#include <linux/poll.h>
> +#include <linux/sched/signal.h>
> +#include <linux/uacce.h>
> +
> +static struct class *uacce_class;
> +static DEFINE_IDR(uacce_idr);
> +static dev_t uacce_devt;
> +static DEFINE_MUTEX(uacce_mutex);
> +static const struct file_operations uacce_fops;
> +
> +static int uacce_queue_map_qfr(struct uacce_queue *q,
> +=09=09=09       struct uacce_qfile_region *qfr)
> +{
> +=09struct device *dev =3D q->uacce->pdev;
> +=09struct iommu_domain *domain =3D iommu_get_domain_for_dev(dev);
> +=09int i, j, ret;
> +
> +=09if (!(qfr->flags & UACCE_QFRF_MAP) || (qfr->flags & UACCE_QFRF_DMA))
> +=09=09return 0;
> +
> +=09if (!domain)
> +=09=09return -ENODEV;
> +
> +=09for (i =3D 0; i < qfr->nr_pages; i++) {
> +=09=09ret =3D iommu_map(domain, qfr->iova + i * PAGE_SIZE,
> +=09=09=09=09page_to_phys(qfr->pages[i]),
> +=09=09=09=09PAGE_SIZE, qfr->prot | q->uacce->prot);
> +=09=09if (ret)
> +=09=09=09goto err_with_map_pages;
> +
> +=09=09get_page(qfr->pages[i]);
> +=09}
> +
> +=09return 0;
> +
> +err_with_map_pages:
> +=09for (j =3D i - 1; j >=3D 0; j--) {
> +=09=09iommu_unmap(domain, qfr->iova + j * PAGE_SIZE, PAGE_SIZE);
> +=09=09put_page(qfr->pages[j]);
> +=09}
> +=09return ret;
> +}
> +
> +static void uacce_queue_unmap_qfr(struct uacce_queue *q,
> +=09=09=09=09  struct uacce_qfile_region *qfr)
> +{
> +=09struct device *dev =3D q->uacce->pdev;
> +=09struct iommu_domain *domain =3D iommu_get_domain_for_dev(dev);
> +=09int i;
> +
> +=09if (!domain || !qfr)
> +=09=09return;
> +
> +=09if (!(qfr->flags & UACCE_QFRF_MAP) || (qfr->flags & UACCE_QFRF_DMA))
> +=09=09return;
> +
> +=09for (i =3D qfr->nr_pages - 1; i >=3D 0; i--) {
> +=09=09iommu_unmap(domain, qfr->iova + i * PAGE_SIZE, PAGE_SIZE);
> +=09=09put_page(qfr->pages[i]);
> +=09}
> +}
> +
> +static int uacce_qfr_alloc_pages(struct uacce_qfile_region *qfr)
> +{
> +=09int i, j;
> +
> +=09qfr->pages =3D kcalloc(qfr->nr_pages, sizeof(*qfr->pages), GFP_ATOMIC=
);
> +=09if (!qfr->pages)
> +=09=09return -ENOMEM;
> +
> +=09for (i =3D 0; i < qfr->nr_pages; i++) {
> +=09=09qfr->pages[i] =3D alloc_page(GFP_ATOMIC | __GFP_ZERO);
> +=09=09if (!qfr->pages[i])
> +=09=09=09goto err_with_pages;
> +=09}
> +
> +=09return 0;
> +
> +err_with_pages:
> +=09for (j =3D i - 1; j >=3D 0; j--)
> +=09=09put_page(qfr->pages[j]);
> +
> +=09kfree(qfr->pages);
> +=09return -ENOMEM;
> +}
> +
> +static void uacce_qfr_free_pages(struct uacce_qfile_region *qfr)
> +{
> +=09int i;
> +
> +=09for (i =3D 0; i < qfr->nr_pages; i++)
> +=09=09put_page(qfr->pages[i]);
> +
> +=09kfree(qfr->pages);
> +}
> +
> +static inline int uacce_queue_mmap_qfr(struct uacce_queue *q,
> +=09=09=09=09       struct uacce_qfile_region *qfr,
> +=09=09=09=09       struct vm_area_struct *vma)
> +{
> +=09int i, ret;
> +
> +=09for (i =3D 0; i < qfr->nr_pages; i++) {
> +=09=09ret =3D remap_pfn_range(vma, vma->vm_start + (i << PAGE_SHIFT),
> +=09=09=09=09      page_to_pfn(qfr->pages[i]), PAGE_SIZE,
> +=09=09=09=09      vma->vm_page_prot);
> +=09=09if (ret)
> +=09=09=09return ret;
> +=09}
> +
> +=09return 0;
> +}
> +
> +static struct uacce_qfile_region *
> +uacce_create_region(struct uacce_queue *q, struct vm_area_struct *vma,
> +=09=09    enum uacce_qfrt type, unsigned int flags)
> +{
> +=09struct uacce_qfile_region *qfr;
> +=09struct uacce_device *uacce =3D q->uacce;
> +=09unsigned long vm_pgoff;
> +=09int ret =3D -ENOMEM;
> +
> +=09qfr =3D kzalloc(sizeof(*qfr), GFP_ATOMIC);
> +=09if (!qfr)
> +=09=09return ERR_PTR(-ENOMEM);
> +
> +=09qfr->type =3D type;
> +=09qfr->flags =3D flags;
> +=09qfr->iova =3D vma->vm_start;
> +=09qfr->nr_pages =3D vma_pages(vma);
> +
> +=09if (vma->vm_flags & VM_READ)
> +=09=09qfr->prot |=3D IOMMU_READ;
> +
> +=09if (vma->vm_flags & VM_WRITE)
> +=09=09qfr->prot |=3D IOMMU_WRITE;
> +
> +=09if (flags & UACCE_QFRF_SELFMT) {
> +=09=09if (!uacce->ops->mmap) {
> +=09=09=09ret =3D -EINVAL;
> +=09=09=09goto err_with_qfr;
> +=09=09}
> +
> +=09=09ret =3D uacce->ops->mmap(q, vma, qfr);
> +=09=09if (ret)
> +=09=09=09goto err_with_qfr;
> +=09=09return qfr;
> +=09}
> +
> +=09/* allocate memory */
> +=09if (flags & UACCE_QFRF_DMA) {
> +=09=09qfr->kaddr =3D dma_alloc_coherent(uacce->pdev,
> +=09=09=09=09=09=09qfr->nr_pages << PAGE_SHIFT,
> +=09=09=09=09=09=09&qfr->dma, GFP_KERNEL);
> +=09=09if (!qfr->kaddr) {
> +=09=09=09ret =3D -ENOMEM;
> +=09=09=09goto err_with_qfr;
> +=09=09}
> +=09} else {
> +=09=09ret =3D uacce_qfr_alloc_pages(qfr);
> +=09=09if (ret)
> +=09=09=09goto err_with_qfr;
> +=09}
> +
> +=09/* map to device */
> +=09ret =3D uacce_queue_map_qfr(q, qfr);
> +=09if (ret)
> +=09=09goto err_with_pages;
> +
> +=09/* mmap to user space */
> +=09if (flags & UACCE_QFRF_MMAP) {
> +=09=09if (flags & UACCE_QFRF_DMA) {
> +=09=09=09/* dma_mmap_coherent() requires vm_pgoff as 0
> +=09=09=09 * restore vm_pfoff to initial value for mmap()
> +=09=09=09 */

I would argue that the dma_mmap_coherent() is not the right function
to use here you might be better of doing remap_pfn_range() on your
own.

Working around existing API is not something you want to do, it can
easily break and it makes it harder for people who want to update that
API to not break anyone.

> +=09=09=09vm_pgoff =3D vma->vm_pgoff;
> +=09=09=09vma->vm_pgoff =3D 0;
> +=09=09=09ret =3D dma_mmap_coherent(uacce->pdev, vma, qfr->kaddr,
> +=09=09=09=09=09=09qfr->dma,
> +=09=09=09=09=09=09qfr->nr_pages << PAGE_SHIFT);
> +=09=09=09vma->vm_pgoff =3D vm_pgoff;
> +=09=09} else {
> +=09=09=09ret =3D uacce_queue_mmap_qfr(q, qfr, vma);
> +=09=09}
> +
> +=09=09if (ret)
> +=09=09=09goto err_with_mapped_qfr;
> +=09}
> +
> +=09return qfr;
> +
> +err_with_mapped_qfr:
> +=09uacce_queue_unmap_qfr(q, qfr);
> +err_with_pages:
> +=09if (flags & UACCE_QFRF_DMA)
> +=09=09dma_free_coherent(uacce->pdev, qfr->nr_pages << PAGE_SHIFT,
> +=09=09=09=09  qfr->kaddr, qfr->dma);
> +=09else
> +=09=09uacce_qfr_free_pages(qfr);
> +err_with_qfr:
> +=09kfree(qfr);
> +
> +=09return ERR_PTR(ret);
> +}
> +
> +static void uacce_destroy_region(struct uacce_queue *q,
> +=09=09=09=09 struct uacce_qfile_region *qfr)
> +{
> +=09struct uacce_device *uacce =3D q->uacce;
> +
> +=09if (qfr->flags & UACCE_QFRF_DMA) {
> +=09=09dma_free_coherent(uacce->pdev, qfr->nr_pages << PAGE_SHIFT,
> +=09=09=09=09  qfr->kaddr, qfr->dma);
> +=09} else if (qfr->pages) {
> +=09=09if (qfr->flags & UACCE_QFRF_KMAP && qfr->kaddr) {
> +=09=09=09vunmap(qfr->kaddr);
> +=09=09=09qfr->kaddr =3D NULL;
> +=09=09}
> +
> +=09=09uacce_qfr_free_pages(qfr);
> +=09}
> +=09kfree(qfr);
> +}
> +
> +static long uacce_cmd_share_qfr(struct uacce_queue *tgt, int fd)

It would be nice to comment what this function does, AFAICT it tries
to share a region uacce_qfile_region. Anyway this should be remove
altogether as it is not use by your first driver.

> +{
> +=09struct file *filep;
> +=09struct uacce_queue *src;
> +=09int ret =3D -EINVAL;
> +
> +=09mutex_lock(&uacce_mutex);
> +
> +=09if (tgt->state !=3D UACCE_Q_STARTED)
> +=09=09goto out_with_lock;
> +
> +=09filep =3D fget(fd);
> +=09if (!filep)
> +=09=09goto out_with_lock;
> +
> +=09if (filep->f_op !=3D &uacce_fops)
> +=09=09goto out_with_fd;
> +
> +=09src =3D filep->private_data;
> +=09if (!src)
> +=09=09goto out_with_fd;
> +
> +=09if (tgt->uacce->flags & UACCE_DEV_SVA)
> +=09=09goto out_with_fd;
> +
> +=09if (!src->qfrs[UACCE_QFRT_SS] || tgt->qfrs[UACCE_QFRT_SS])
> +=09=09goto out_with_fd;
> +
> +=09ret =3D uacce_queue_map_qfr(tgt, src->qfrs[UACCE_QFRT_SS]);
> +=09if (ret)
> +=09=09goto out_with_fd;
> +
> +=09tgt->qfrs[UACCE_QFRT_SS] =3D src->qfrs[UACCE_QFRT_SS];
> +=09list_add(&tgt->list, &src->qfrs[UACCE_QFRT_SS]->qs);

This list_add() seems bogus as the src->qfrs would already be
on a list so you are corrupting the list it is on.

> +
> +out_with_fd:
> +=09fput(filep);
> +out_with_lock:
> +=09mutex_unlock(&uacce_mutex);
> +=09return ret;
> +}

[...]

> +static long uacce_fops_unl_ioctl(struct file *filep,
> +=09=09=09=09 unsigned int cmd, unsigned long arg)

You need to documents properly all ioctl and also you need to
remove those that are not use by your first driver. They will
just bit rot as we do not know if they will ever be use.

> +{
> +=09struct uacce_queue *q =3D filep->private_data;
> +=09struct uacce_device *uacce =3D q->uacce;
> +
> +=09switch (cmd) {
> +=09case UACCE_CMD_SHARE_SVAS:
> +=09=09return uacce_cmd_share_qfr(q, arg);
> +
> +=09case UACCE_CMD_START:
> +=09=09return uacce_start_queue(q);
> +
> +=09case UACCE_CMD_PUT_Q:
> +=09=09return uacce_put_queue(q);
> +
> +=09default:
> +=09=09if (!uacce->ops->ioctl)
> +=09=09=09return -EINVAL;
> +
> +=09=09return uacce->ops->ioctl(q, cmd, arg);
> +=09}
> +}
> +

[...]

> +
> +static int uacce_dev_open_check(struct uacce_device *uacce)
> +{
> +=09if (uacce->flags & UACCE_DEV_SVA)
> +=09=09return 0;
> +
> +=09/*
> +=09 * The device can be opened once if it does not support pasid
> +=09 */
> +=09if (kref_read(&uacce->cdev->kobj.kref) > 2)
> +=09=09return -EBUSY;

You do not check if the device support pasid so comments does not
match code. Right now code says that you can not open a device more
than once. Also this check is racy there is no lock protecting the
read.

> +
> +=09return 0;
> +}
> +
> +static int uacce_fops_open(struct inode *inode, struct file *filep)
> +{
> +=09struct uacce_queue *q;
> +=09struct iommu_sva *handle =3D NULL;
> +=09struct uacce_device *uacce;
> +=09int ret;
> +=09int pasid =3D 0;
> +
> +=09uacce =3D idr_find(&uacce_idr, iminor(inode));
> +=09if (!uacce)
> +=09=09return -ENODEV;
> +
> +=09if (!try_module_get(uacce->pdev->driver->owner))
> +=09=09return -ENODEV;
> +
> +=09ret =3D uacce_dev_open_check(uacce);
> +=09if (ret)
> +=09=09goto out_with_module;
> +
> +=09if (uacce->flags & UACCE_DEV_SVA) {
> +=09=09handle =3D iommu_sva_bind_device(uacce->pdev, current->mm, NULL);
> +=09=09if (IS_ERR(handle))
> +=09=09=09goto out_with_module;
> +=09=09pasid =3D iommu_sva_get_pasid(handle);
> +=09}

The file descriptor can outlive the mm (through fork) what happens
when the mm dies ? Where is the sva_unbind ? Maybe in iommu code.
At very least a comment should be added explaining what happens.

> +
> +=09q =3D kzalloc(sizeof(struct uacce_queue), GFP_KERNEL);
> +=09if (!q) {
> +=09=09ret =3D -ENOMEM;
> +=09=09goto out_with_module;
> +=09}
> +
> +=09if (uacce->ops->get_queue) {
> +=09=09ret =3D uacce->ops->get_queue(uacce, pasid, q);
> +=09=09if (ret < 0)
> +=09=09=09goto out_with_mem;
> +=09}
> +
> +=09q->pasid =3D pasid;
> +=09q->handle =3D handle;
> +=09q->uacce =3D uacce;
> +=09q->mm =3D current->mm;
> +=09memset(q->qfrs, 0, sizeof(q->qfrs));
> +=09INIT_LIST_HEAD(&q->list);
> +=09init_waitqueue_head(&q->wait);
> +=09filep->private_data =3D q;
> +=09q->state =3D UACCE_Q_INIT;
> +
> +=09return 0;
> +
> +out_with_mem:
> +=09kfree(q);
> +out_with_module:
> +=09module_put(uacce->pdev->driver->owner);
> +=09return ret;
> +}
> +
> +static int uacce_fops_release(struct inode *inode, struct file *filep)
> +{
> +=09struct uacce_queue *q =3D filep->private_data;
> +=09struct uacce_qfile_region *qfr;
> +=09struct uacce_device *uacce =3D q->uacce;
> +=09bool is_to_free_region;
> +=09int free_pages =3D 0;
> +=09int i;
> +
> +=09mutex_lock(&uacce_mutex);
> +
> +=09if ((q->state =3D=3D UACCE_Q_STARTED) && uacce->ops->stop_queue)
> +=09=09uacce->ops->stop_queue(q);
> +
> +=09for (i =3D 0; i < UACCE_QFRT_MAX; i++) {
> +=09=09qfr =3D q->qfrs[i];
> +=09=09if (!qfr)
> +=09=09=09continue;
> +
> +=09=09is_to_free_region =3D false;
> +=09=09uacce_queue_unmap_qfr(q, qfr);
> +=09=09if (i =3D=3D UACCE_QFRT_SS) {
> +=09=09=09list_del(&q->list);
> +=09=09=09if (list_empty(&qfr->qs))
> +=09=09=09=09is_to_free_region =3D true;
> +=09=09} else
> +=09=09=09is_to_free_region =3D true;
> +
> +=09=09if (is_to_free_region) {
> +=09=09=09free_pages +=3D qfr->nr_pages;
> +=09=09=09uacce_destroy_region(q, qfr);
> +=09=09}
> +
> +=09=09qfr =3D NULL;
> +=09}
> +
> +=09if (current->mm =3D=3D q->mm) {
> +=09=09down_write(&q->mm->mmap_sem);
> +=09=09q->mm->data_vm -=3D free_pages;
> +=09=09up_write(&q->mm->mmap_sem);

This is bogus you do not get any reference on the mm through
mmgrab() so there is nothing protection the q->mm from being
release. Note that you do not want to do mmgrab() in open as
the file descriptor can outlive the mm.

> +=09}
> +
> +=09if (uacce->flags & UACCE_DEV_SVA)
> +=09=09iommu_sva_unbind_device(q->handle);
> +
> +=09if ((q->state =3D=3D UACCE_Q_INIT || q->state =3D=3D UACCE_Q_STARTED)=
 &&
> +=09     uacce->ops->put_queue)
> +=09=09uacce->ops->put_queue(q);
> +
> +=09kfree(q);
> +=09mutex_unlock(&uacce_mutex);
> +
> +=09module_put(uacce->pdev->driver->owner);

As the file can outlive the process it might also outlive the module
maybe you want to keep a reference on the module as part of the region
and release it in uacce_destroy_region()

> +
> +=09return 0;
> +}
> +
> +static int uacce_fops_mmap(struct file *filep, struct vm_area_struct *vm=
a)
> +{
> +=09struct uacce_queue *q =3D filep->private_data;
> +=09struct uacce_device *uacce =3D q->uacce;
> +=09struct uacce_qfile_region *qfr;
> +=09enum uacce_qfrt type =3D 0;
> +=09unsigned int flags =3D 0;
> +=09int ret;
> +
> +=09if (vma->vm_pgoff < UACCE_QFRT_MAX)
> +=09=09type =3D vma->vm_pgoff;
> +
> +=09vma->vm_flags |=3D VM_DONTCOPY | VM_DONTEXPAND;

Don't you also want VM_WIPEONFORK ?

> +
> +=09mutex_lock(&uacce_mutex);
> +
> +=09/* fixme: if the region need no pages, we don't need to check it */
> +=09if (q->mm->data_vm + vma_pages(vma) >
> +=09    rlimit(RLIMIT_DATA) >> PAGE_SHIFT) {
> +=09=09ret =3D -ENOMEM;
> +=09=09goto out_with_lock;
> +=09}
> +
> +=09if (q->qfrs[type]) {
> +=09=09ret =3D -EBUSY;

What about -EEXIST ? That test checks if a region of given
type already exist for the uacce_queue which is private to
that file descriptor. So it means that userspace which did
open the file is trying to create again the same region type
which already exist.

> +=09=09goto out_with_lock;
> +=09}
> +
> +=09switch (type) {
> +=09case UACCE_QFRT_MMIO:
> +=09=09flags =3D UACCE_QFRF_SELFMT;
> +=09=09break;
> +
> +=09case UACCE_QFRT_SS:
> +=09=09if (q->state !=3D UACCE_Q_STARTED) {
> +=09=09=09ret =3D -EINVAL;
> +=09=09=09goto out_with_lock;
> +=09=09}
> +
> +=09=09if (uacce->flags & UACCE_DEV_SVA) {
> +=09=09=09ret =3D -EINVAL;
> +=09=09=09goto out_with_lock;
> +=09=09}
> +
> +=09=09flags =3D UACCE_QFRF_MAP | UACCE_QFRF_MMAP;
> +
> +=09=09break;
> +
> +=09case UACCE_QFRT_DKO:
> +=09=09if (uacce->flags & UACCE_DEV_SVA) {
> +=09=09=09ret =3D -EINVAL;
> +=09=09=09goto out_with_lock;
> +=09=09}
> +
> +=09=09flags =3D UACCE_QFRF_MAP | UACCE_QFRF_KMAP;
> +
> +=09=09break;
> +
> +=09case UACCE_QFRT_DUS:
> +=09=09if (uacce->flags & UACCE_DEV_SVA) {
> +=09=09=09flags =3D UACCE_QFRF_SELFMT;
> +=09=09=09break;
> +=09=09}
> +
> +=09=09flags =3D UACCE_QFRF_MAP | UACCE_QFRF_MMAP;
> +=09=09break;
> +
> +=09default:
> +=09=09WARN_ON(&uacce->dev);
> +=09=09break;
> +=09}
> +
> +=09qfr =3D uacce_create_region(q, vma, type, flags);
> +=09if (IS_ERR(qfr)) {
> +=09=09ret =3D PTR_ERR(qfr);
> +=09=09goto out_with_lock;
> +=09}
> +=09q->qfrs[type] =3D qfr;
> +
> +=09if (type =3D=3D UACCE_QFRT_SS) {
> +=09=09INIT_LIST_HEAD(&qfr->qs);
> +=09=09list_add(&q->list, &q->qfrs[type]->qs);
> +=09}
> +
> +=09mutex_unlock(&uacce_mutex);
> +
> +=09if (qfr->pages)
> +=09=09q->mm->data_vm +=3D qfr->nr_pages;

The mm->data_vm fields is protected by the mmap_sem taken in write
mode AFAIR so what you are doing here is unsafe.

> +
> +=09return 0;
> +
> +out_with_lock:
> +=09mutex_unlock(&uacce_mutex);
> +=09return ret;
> +}
> +

[...]

> +/* Borrowed from VFIO to fix msi translation */
> +static bool uacce_iommu_has_sw_msi(struct iommu_group *group,
> +=09=09=09=09   phys_addr_t *base)

I fail to see why you need this in a common framework this
seems to be specific to a device.

> +{
> +=09struct list_head group_resv_regions;
> +=09struct iommu_resv_region *region, *next;
> +=09bool ret =3D false;
> +
> +=09INIT_LIST_HEAD(&group_resv_regions);
> +=09iommu_get_group_resv_regions(group, &group_resv_regions);
> +=09list_for_each_entry(region, &group_resv_regions, list) {
> +=09=09/*
> +=09=09 * The presence of any 'real' MSI regions should take
> +=09=09 * precedence over the software-managed one if the
> +=09=09 * IOMMU driver happens to advertise both types.
> +=09=09 */
> +=09=09if (region->type =3D=3D IOMMU_RESV_MSI) {
> +=09=09=09ret =3D false;
> +=09=09=09break;
> +=09=09}
> +
> +=09=09if (region->type =3D=3D IOMMU_RESV_SW_MSI) {
> +=09=09=09*base =3D region->start;
> +=09=09=09ret =3D true;
> +=09=09}
> +=09}
> +
> +=09list_for_each_entry_safe(region, next, &group_resv_regions, list)
> +=09=09kfree(region);
> +
> +=09return ret;
> +}
> +
> +static int uacce_set_iommu_domain(struct uacce_device *uacce)
> +{
> +=09struct iommu_domain *domain;
> +=09struct iommu_group *group;
> +=09struct device *dev =3D uacce->pdev;
> +=09bool resv_msi;
> +=09phys_addr_t resv_msi_base =3D 0;
> +=09int ret;
> +
> +=09if (uacce->flags & UACCE_DEV_SVA)
> +=09=09return 0;
> +
> +=09/* allocate and attach an unmanaged domain */
> +=09domain =3D iommu_domain_alloc(uacce->pdev->bus);
> +=09if (!domain) {
> +=09=09dev_err(&uacce->dev, "cannot get domain for iommu\n");
> +=09=09return -ENODEV;
> +=09}
> +
> +=09ret =3D iommu_attach_device(domain, uacce->pdev);
> +=09if (ret)
> +=09=09goto err_with_domain;
> +
> +=09if (iommu_capable(dev->bus, IOMMU_CAP_CACHE_COHERENCY))
> +=09=09uacce->prot |=3D IOMMU_CACHE;
> +
> +=09group =3D iommu_group_get(dev);
> +=09if (!group) {
> +=09=09ret =3D -EINVAL;
> +=09=09goto err_with_domain;
> +=09}
> +
> +=09resv_msi =3D uacce_iommu_has_sw_msi(group, &resv_msi_base);
> +=09iommu_group_put(group);
> +
> +=09if (resv_msi) {
> +=09=09if (!irq_domain_check_msi_remap() &&
> +=09=09    !iommu_capable(dev->bus, IOMMU_CAP_INTR_REMAP)) {
> +=09=09=09dev_warn(dev, "No interrupt remapping support!");
> +=09=09=09ret =3D -EPERM;
> +=09=09=09goto err_with_domain;
> +=09=09}
> +
> +=09=09ret =3D iommu_get_msi_cookie(domain, resv_msi_base);
> +=09=09if (ret)
> +=09=09=09goto err_with_domain;
> +=09}
> +
> +=09return 0;
> +
> +err_with_domain:
> +=09iommu_domain_free(domain);
> +=09return ret;
> +}
> +
> +static void uacce_unset_iommu_domain(struct uacce_device *uacce)
> +{
> +=09struct iommu_domain *domain;
> +
> +=09if (uacce->flags & UACCE_DEV_SVA)
> +=09=09return;
> +
> +=09domain =3D iommu_get_domain_for_dev(uacce->pdev);
> +=09if (!domain) {
> +=09=09dev_err(&uacce->dev, "bug: no domain attached to device\n");
> +=09=09return;
> +=09}
> +
> +=09iommu_detach_device(domain, uacce->pdev);
> +=09iommu_domain_free(domain);
> +}
> +
> +/**
> + * uacce_register - register an accelerator
> + * @parent: pointer of uacce parent device
> + * @interface: pointer of uacce_interface for register
> + */
> +struct uacce_device *uacce_register(struct device *parent,
> +=09=09=09=09    struct uacce_interface *interface)
> +{
> +=09int ret;
> +=09struct uacce_device *uacce;
> +=09unsigned int flags =3D interface->flags;
> +
> +=09uacce =3D kzalloc(sizeof(struct uacce_device), GFP_KERNEL);
> +=09if (!uacce)
> +=09=09return ERR_PTR(-ENOMEM);
> +
> +=09if (flags & UACCE_DEV_SVA) {
> +=09=09ret =3D iommu_dev_enable_feature(parent, IOMMU_DEV_FEAT_SVA);
> +=09=09if (ret)
> +=09=09=09flags &=3D ~UACCE_DEV_SVA;
> +=09}
> +
> +=09uacce->pdev =3D parent;
> +=09uacce->flags =3D flags;
> +=09uacce->ops =3D interface->ops;
> +
> +=09ret =3D uacce_set_iommu_domain(uacce);
> +=09if (ret)
> +=09=09goto err_free;

Why do you need to change the IOMMU domain ? This is orthogonal to
what you are trying to achieve. Domain has nothing to do with SVA
or userspace queue (at least not on x86 AFAIK).


> +
> +=09mutex_lock(&uacce_mutex);
> +
> +=09ret =3D idr_alloc(&uacce_idr, uacce, 0, 0, GFP_KERNEL);
> +=09if (ret < 0)
> +=09=09goto err_with_lock;
> +
> +=09uacce->cdev =3D cdev_alloc();
> +=09uacce->cdev->ops =3D &uacce_fops;
> +=09uacce->dev_id =3D ret;
> +=09uacce->cdev->owner =3D THIS_MODULE;
> +=09device_initialize(&uacce->dev);
> +=09uacce->dev.devt =3D MKDEV(MAJOR(uacce_devt), uacce->dev_id);
> +=09uacce->dev.class =3D uacce_class;
> +=09uacce->dev.groups =3D uacce_dev_groups;
> +=09uacce->dev.parent =3D uacce->pdev;
> +=09uacce->dev.release =3D uacce_release;
> +=09dev_set_name(&uacce->dev, "%s-%d", interface->name, uacce->dev_id);
> +=09ret =3D cdev_device_add(uacce->cdev, &uacce->dev);
> +=09if (ret)
> +=09=09goto err_with_idr;
> +
> +=09mutex_unlock(&uacce_mutex);
> +
> +=09return uacce;
> +
> +err_with_idr:
> +=09idr_remove(&uacce_idr, uacce->dev_id);
> +err_with_lock:
> +=09mutex_unlock(&uacce_mutex);
> +=09uacce_unset_iommu_domain(uacce);
> +err_free:
> +=09if (flags & UACCE_DEV_SVA)
> +=09=09iommu_dev_disable_feature(uacce->pdev, IOMMU_DEV_FEAT_SVA);
> +=09kfree(uacce);
> +=09return ERR_PTR(ret);
> +}
> +EXPORT_SYMBOL_GPL(uacce_register);

[...]

> diff --git a/include/linux/uacce.h b/include/linux/uacce.h
> new file mode 100644
> index 0000000..8ce0640
> --- /dev/null
> +++ b/include/linux/uacce.h
> @@ -0,0 +1,168 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +#ifndef _LINUX_UACCE_H
> +#define _LINUX_UACCE_H
> +
> +#include <linux/cdev.h>
> +#include <uapi/misc/uacce/uacce.h>
> +
> +#define UACCE_NAME=09=09"uacce"
> +
> +struct uacce_queue;
> +struct uacce_device;
> +
> +/* uacce queue file flag, requires different operation */
> +#define UACCE_QFRF_MAP=09=09BIT(0)=09/* map to current queue */
> +#define UACCE_QFRF_MMAP=09=09BIT(1)=09/* map to user space */
> +#define UACCE_QFRF_KMAP=09=09BIT(2)=09/* map to kernel space */
> +#define UACCE_QFRF_DMA=09=09BIT(3)=09/* use dma api for the region */
> +#define UACCE_QFRF_SELFMT=09BIT(4)=09/* self maintained qfr */
> +
> +/**
> + * struct uacce_qfile_region - structure of queue file region
> + * @type: type of the qfr
> + * @iova: iova share between user and device space
> + * @pages: pages pointer of the qfr memory
> + * @nr_pages: page numbers of the qfr memory
> + * @prot: qfr protection flag
> + * @flags: flags of qfr
> + * @qs: list sharing the same region, for ss region
> + * @kaddr: kernel addr of the qfr
> + * @dma: dma address, if created by dma api
> + */
> +struct uacce_qfile_region {
> +=09enum uacce_qfrt type;
> +=09unsigned long iova;
> +=09struct page **pages;
> +=09u32 nr_pages;
> +=09u32 prot;
> +=09u32 flags;
> +=09struct list_head qs;
> +=09void *kaddr;
> +=09dma_addr_t dma;
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
> +=09int (*get_available_instances)(struct uacce_device *uacce);
> +=09int (*get_queue)(struct uacce_device *uacce, unsigned long arg,
> +=09=09=09 struct uacce_queue *q);
> +=09void (*put_queue)(struct uacce_queue *q);
> +=09int (*start_queue)(struct uacce_queue *q);
> +=09void (*stop_queue)(struct uacce_queue *q);
> +=09int (*is_q_updated)(struct uacce_queue *q);
> +=09void (*mask_notify)(struct uacce_queue *q, int event_mask);
> +=09int (*mmap)(struct uacce_queue *q, struct vm_area_struct *vma,
> +=09=09    struct uacce_qfile_region *qfr);
> +=09int (*reset)(struct uacce_device *uacce);
> +=09int (*reset_queue)(struct uacce_queue *q);
> +=09long (*ioctl)(struct uacce_queue *q, unsigned int cmd,
> +=09=09      unsigned long arg);
> +};
> +
> +/**
> + * struct uacce_interface
> + * @name: the uacce device name.  Will show up in sysfs
> + * @flags: uacce device attributes
> + * @ops: pointer to the struct uacce_ops
> + *
> + * This structure is used for the uacce_register()
> + */
> +struct uacce_interface {
> +=09char name[32];

You should add a define for the maximum lenght of name.

> +=09unsigned int flags;

Should be enum uacce_dev_flag not unsigned int and that
enum should be defined above and not in uAPI see comments
i made next to that enum.

> +=09struct uacce_ops *ops;
> +};
> +
> +enum uacce_q_state {
> +=09UACCE_Q_INIT,
> +=09UACCE_Q_STARTED,
> +=09UACCE_Q_ZOMBIE,
> +};
> +
> +/**
> + * struct uacce_queue
> + * @uacce: pointer to uacce
> + * @priv: private pointer
> + * @wait: wait queue head
> + * @pasid: pasid of the queue
> + * @handle: iommu_sva handle return from iommu_sva_bind_device
> + * @list: share list for qfr->qs
> + * @mm: current->mm
> + * @qfrs: pointer of qfr regions
> + * @state: queue state machine
> + */
> +struct uacce_queue {
> +=09struct uacce_device *uacce;
> +=09void *priv;
> +=09wait_queue_head_t wait;
> +=09int pasid;
> +=09struct iommu_sva *handle;
> +=09struct list_head list;
> +=09struct mm_struct *mm;
> +=09struct uacce_qfile_region *qfrs[UACCE_QFRT_MAX];
> +=09enum uacce_q_state state;
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
> + */
> +struct uacce_device {
> +=09const char *algs;
> +=09const char *api_ver;
> +=09unsigned long qf_pg_size[UACCE_QFRT_MAX];
> +=09struct uacce_ops *ops;
> +=09struct device *pdev;
> +=09bool is_vf;
> +=09u32 flags;
> +=09u32 dev_id;
> +=09u32 prot;
> +=09struct cdev *cdev;
> +=09struct device dev;
> +=09void *priv;
> +};
> +
> +#if IS_ENABLED(CONFIG_UACCE)
> +
> +struct uacce_device *uacce_register(struct device *parent,
> +=09=09=09=09    struct uacce_interface *interface);
> +void uacce_unregister(struct uacce_device *uacce);
> +
> +#else /* CONFIG_UACCE */
> +
> +static inline
> +struct uacce_device *uacce_register(struct device *parent,
> +=09=09=09=09    struct uacce_interface *interface)
> +{
> +=09return ERR_PTR(-ENODEV);
> +}
> +
> +static inline void uacce_unregister(struct uacce_device *uacce) {}
> +
> +#endif /* CONFIG_UACCE */
> +
> +#endif /* _LINUX_UACCE_H */
> diff --git a/include/uapi/misc/uacce/uacce.h b/include/uapi/misc/uacce/ua=
cce.h
> new file mode 100644
> index 0000000..c859668
> --- /dev/null
> +++ b/include/uapi/misc/uacce/uacce.h
> @@ -0,0 +1,41 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +#ifndef _UAPIUUACCE_H
> +#define _UAPIUUACCE_H
> +
> +#include <linux/types.h>
> +#include <linux/ioctl.h>
> +
> +#define UACCE_CMD_SHARE_SVAS=09_IO('W', 0)
> +#define UACCE_CMD_START=09=09_IO('W', 1)
> +#define UACCE_CMD_PUT_Q=09=09_IO('W', 2)
> +
> +/**
> + * enum uacce_dev_flag: Device flags:
> + * @UACCE_DEV_SHARE_DOMAIN: no PASID, can share sva for one process
> + * @UACCE_DEV_SVA: Shared Virtual Addresses
> + *=09=09   Support PASID
> + *=09=09   Support device page fault (pcie device) or
> + *=09=09   smmu stall (platform device)
> + */
> +enum uacce_dev_flag {
> +=09UACCE_DEV_SHARE_DOMAIN =3D 0x0,

UACCE_DEV_SHARE_DOMAIN is not use anywhere better do not introduce somethin=
g
that is not use.


> +=09UACCE_DEV_SVA =3D 0x1,
> +};

More general question why is it part of the UAPI header file ?
To me it seems that those flags are only use internaly to the
kernel and never need to be expose to userspace.

> +
> +/**
> + * enum uacce_qfrt: qfrt type
> + * @UACCE_QFRT_MMIO: device mmio region
> + * @UACCE_QFRT_DKO: device kernel-only region
> + * @UACCE_QFRT_DUS: device user share region
> + * @UACCE_QFRT_SS: static shared memory region
> + * @UACCE_QFRT_MAX: indicate the boundary
> + */

Your first driver only use DUS and MMIO, you should not define
thing that are not even use by the first driver, especialy when
it comes to userspace API.

> +enum uacce_qfrt {
> +=09UACCE_QFRT_MMIO =3D 0,
> +=09UACCE_QFRT_DKO =3D 1,
> +=09UACCE_QFRT_DUS =3D 2,
> +=09UACCE_QFRT_SS =3D 3,
> +=09UACCE_QFRT_MAX =3D 16,

Isn't 16 bit low ? Do you really need a maximum ? I would not
expose or advertise a maxmimum in this userspace facing header.

