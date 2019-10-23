Return-Path: <SRS0=Ux5j=YQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2507ECA9EB6
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 16:58:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA92421925
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 16:58:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SVM4Xfdq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbfJWQ60 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Oct 2019 12:58:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32842 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726664AbfJWQ60 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Oct 2019 12:58:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571849905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qTTBTaOEjj6UwppDZDbr2espgMg/5p88pNBoo1l7DMI=;
        b=SVM4XfdqAB1KKgHlaWTpcuX4VN3WOWZnrN809l7NFPS5ufHb5lUvSNqSv4QlB7AsWBlKWq
        wQbD0YctYqW0HiTJ5x0tvplgvikqoN9wQT+5CDf/ky3tR+w87uHQmaPO7bhqPediVraNc/
        PyNMqxSPIvfSwM6E2t69mUDA6YfgpbE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-2c7kOI1UPM2-cf5wB0RQTg-1; Wed, 23 Oct 2019 12:58:21 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 33D951005500;
        Wed, 23 Oct 2019 16:58:19 +0000 (UTC)
Received: from redhat.com (ovpn-124-105.rdu2.redhat.com [10.10.124.105])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B6B6B1001B07;
        Wed, 23 Oct 2019 16:58:16 +0000 (UTC)
Date:   Wed, 23 Oct 2019 12:58:14 -0400
From:   Jerome Glisse <jglisse@redhat.com>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     Zhangfei Gao <zhangfei.gao@linaro.org>, francois.ozog@linaro.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zaibo Xu <xuzaibo@huawei.com>, ilias.apalodimas@linaro.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Wangzhou <wangzhou1@hisilicon.com>, grant.likely@arm.com,
        "haojian . zhuang" <haojian.zhuang@linaro.org>,
        Kenneth Lee <liguozhu@hisilicon.com>,
        linux-accelerators@lists.ozlabs.org, kenneth-lee-2012@foxmail.com
Subject: Re: [PATCH v6 2/3] uacce: add uacce driver
Message-ID: <20191023165814.GB4163@redhat.com>
References: <1571214873-27359-1-git-send-email-zhangfei.gao@linaro.org>
 <1571214873-27359-3-git-send-email-zhangfei.gao@linaro.org>
 <20191016172802.GA1533448@lophozonia>
MIME-Version: 1.0
In-Reply-To: <20191016172802.GA1533448@lophozonia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: 2c7kOI1UPM2-cf5wB0RQTg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 16, 2019 at 07:28:02PM +0200, Jean-Philippe Brucker wrote:
[...]

> > +static struct uacce_qfile_region *
> > +uacce_create_region(struct uacce_queue *q, struct vm_area_struct *vma,
> > +=09=09    enum uacce_qfrt type, unsigned int flags)
> > +{
> > +=09struct uacce_qfile_region *qfr;
> > +=09struct uacce_device *uacce =3D q->uacce;
> > +=09unsigned long vm_pgoff;
> > +=09int ret =3D -ENOMEM;
> > +
> > +=09qfr =3D kzalloc(sizeof(*qfr), GFP_ATOMIC);
> > +=09if (!qfr)
> > +=09=09return ERR_PTR(-ENOMEM);
> > +
> > +=09qfr->type =3D type;
> > +=09qfr->flags =3D flags;
> > +=09qfr->iova =3D vma->vm_start;
> > +=09qfr->nr_pages =3D vma_pages(vma);
> > +
> > +=09if (vma->vm_flags & VM_READ)
> > +=09=09qfr->prot |=3D IOMMU_READ;
> > +
> > +=09if (vma->vm_flags & VM_WRITE)
> > +=09=09qfr->prot |=3D IOMMU_WRITE;
> > +
> > +=09if (flags & UACCE_QFRF_SELFMT) {
> > +=09=09if (!uacce->ops->mmap) {
> > +=09=09=09ret =3D -EINVAL;
> > +=09=09=09goto err_with_qfr;
> > +=09=09}
> > +
> > +=09=09ret =3D uacce->ops->mmap(q, vma, qfr);
> > +=09=09if (ret)
> > +=09=09=09goto err_with_qfr;
> > +=09=09return qfr;
> > +=09}
>=20
> I wish the SVA and !SVA paths were less interleaved. Both models are
> fundamentally different:
>=20
> * Without SVA you cannot share the device between multiple processes. All
>   DMA mappings are in the "main", non-PASID address space of the device.
>=20
>   Note that process isolation without SVA could be achieved with the
>   auxiliary domains IOMMU API (introduced primarily for vfio-mdev) but
>   this is not the model chosen here.
>=20
> * With SVA you can share the device between multiple processes. But if th=
e
>   process can somehow program its portion of the device to access the mai=
n
>   address space, you loose isolation. Only the kernel must be able to
>   program and access the main address space.
>=20
> When interleaving both code paths it's easy to make a mistake and loose
> this isolation. Although I think this code is correct, it took me some
> time to understand that we never end up calling dma_alloc or iommu_map
> when using SVA. Might be worth at least adding a check that if
> UACCE_DEV_SVA, then we never end up in the bottom part of this function.

I would go even further, just remove the DMA path as it is not use.
But yes at bare minimum it needs to be completely separate to avoid
confusion.


[...]


> > +static int uacce_fops_open(struct inode *inode, struct file *filep)
> > +{
> > +=09struct uacce_queue *q;
> > +=09struct iommu_sva *handle =3D NULL;
> > +=09struct uacce_device *uacce;
> > +=09int ret;
> > +=09int pasid =3D 0;
> > +
> > +=09uacce =3D idr_find(&uacce_idr, iminor(inode));
> > +=09if (!uacce)
> > +=09=09return -ENODEV;
> > +
> > +=09if (!try_module_get(uacce->pdev->driver->owner))
> > +=09=09return -ENODEV;
> > +
> > +=09ret =3D uacce_dev_open_check(uacce);
> > +=09if (ret)
> > +=09=09goto out_with_module;
> > +
> > +=09if (uacce->flags & UACCE_DEV_SVA) {
> > +=09=09handle =3D iommu_sva_bind_device(uacce->pdev, current->mm, NULL)=
;
> > +=09=09if (IS_ERR(handle))
> > +=09=09=09goto out_with_module;
> > +=09=09pasid =3D iommu_sva_get_pasid(handle);
>=20
> We need to register an mm_exit callback. Once we return, userspace will
> start running jobs on the accelerator. If the process is killed while the
> accelerator is running, the mm_exit callback tells the device driver to
> stop using this PASID (stop_queue()), so that it can be reallocated for
> another process.
>=20
> Implementing this with the right locking and ordering can be tricky. I'll
> try to implement the callback and test it on the device this week.

It already exist it is call mmu notifier, you can register an mmu notifier
and get callback once the mm exit.

Cheers,
J=E9r=F4me

