Return-Path: <SRS0=Ux5j=YQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E4FCCA9EB6
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 07:42:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF189214B2
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 07:42:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="u5jOUrPq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727574AbfJWHme (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Oct 2019 03:42:34 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40333 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389999AbfJWHmd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Oct 2019 03:42:33 -0400
Received: by mail-wr1-f66.google.com with SMTP id o28so20855001wro.7
        for <linux-crypto@vger.kernel.org>; Wed, 23 Oct 2019 00:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=KGid5vtQjFPMce0PdLU6XWEyY23AJL898C5Gv+DHVUY=;
        b=u5jOUrPquPlfSoZAv/UUE6yYkNkhiDv3dsT8apJ5UIsZ8jjhkx/UhDNipKS015TQFl
         GwkUjAB5oX90pqdwXguol0BUMURYcWtm+4SseYeytjNqZkPC1w9pOOeOlSz7gvwC1c3E
         VE3HSNBo4xI6W6vkYKgNI2TRJ4H4pQiQ0uPkGujhtmGM11O3DVPKGejCiKgHiKiu7E1Y
         P7yBNsZgKwTlJh4VMzs1k8lm3ulTp0PDH3wO522PmWQXxg46UTnBbjShODH2uUgfV3ti
         HI98mq6yOT7+sfmeJ3v0sh/jBLc40+YJPY+gj6xxtRHXAquR7LgrISdmGnht7ctJgaPo
         8itQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KGid5vtQjFPMce0PdLU6XWEyY23AJL898C5Gv+DHVUY=;
        b=bW28xgp5kAdVAVJlOl1U7L2Bmkd9/hWNa8NLG5zfNCMarKRZOreLUDSYapQGTbWF9R
         roIX7Zaw7qV7ZFwFRE8VIo4i0tTazFrLXwg5pnfCrSAgOmRAHzqHMnZQ23eGGW16PGU0
         XABF62/p3171ijZ+YlQtkQ/nN6SobDhcmmVImnOqQ9FocrPhN5u+CT0FXOqs/bqeFC+u
         YIefG58KWRFOkwEgQyKWrObHBn1Ly32D2L5AKCz7Al3eZQa/Ilgqqr6wHHd75edNsy1r
         kHAe4pf4iHZrnthmI0zyDJy/PG08Jfyvm5YLEuwBRTpFo9bftZRnZ/ilOAW/SGIGTRCu
         SGrw==
X-Gm-Message-State: APjAAAXtujFKY4gSuCQPwz1TT3Pt4d2ohSYdmnPeN/6vKP9Tvu0T/O0m
        jUrV7c4Dtte6MWTf4lszehp1nw==
X-Google-Smtp-Source: APXvYqzTwBoeZ6eycm/qh37tl4Rv2liCZqsEziDaSS5Io1XGjDnpXG1oLya1X7S2yUgcug9swTChbg==
X-Received: by 2002:adf:fac2:: with SMTP id a2mr6635488wrs.290.1571816549918;
        Wed, 23 Oct 2019 00:42:29 -0700 (PDT)
Received: from lophozonia ([85.195.192.192])
        by smtp.gmail.com with ESMTPSA id r1sm15185527wrw.60.2019.10.23.00.42.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 00:42:29 -0700 (PDT)
Date:   Wed, 23 Oct 2019 09:42:27 +0200
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     "zhangfei.gao@foxmail.com" <zhangfei.gao@foxmail.com>
Cc:     Zhangfei Gao <zhangfei.gao@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
Message-ID: <20191023074227.GA264888@lophozonia>
References: <1571214873-27359-1-git-send-email-zhangfei.gao@linaro.org>
 <1571214873-27359-3-git-send-email-zhangfei.gao@linaro.org>
 <20191016172802.GA1533448@lophozonia>
 <5da9a9cd.1c69fb81.9f8e8.60faSMTPIN_ADDED_BROKEN@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5da9a9cd.1c69fb81.9f8e8.60faSMTPIN_ADDED_BROKEN@mx.google.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Oct 18, 2019 at 08:01:44PM +0800, zhangfei.gao@foxmail.com wrote:
> > More generally, it would be nice to use the DMA API when SVA isn't
> > supported, instead of manually allocating and mapping memory with
> > iommu_map(). Do we only handcraft these functions in order to have VA ==
> > IOVA?  On its own it doesn't seem like a strong enough reason to avoid the
> > DMA API.
> Here we use unmanaged domain to prevent va conflict with iova.
> The target is still to build shared virtual address though SVA is not
> supported.

If SVA isn't supported, having VA == IOVA looks nice but isn't
particularly useful. We could instead require that, if SVA isn't
supported, userspace handles VA and IOVA separately for any DMA region.

Enforcing VA == IOVA adds some unnecessary complexity to this module. In
addition to the special case for software MSIs that is already there
(uacce_iommu_has_sw_msi), it's also not guaranteed that the whole VA space
is representable with IOVAs, you might need to poke holes in the IOVA
space for reserved regions (See iommu.*resv). For example VFIO checks that
the IOVA requested by userspace doesn't fall into a reserved range (see
iova_list in vfio_iommu_type1.c). It also exports to userspace a list of
possible IOVAs through VFIO_IOMMU_GET_INFO.

Letting the DMA API allocate addresses would be simpler, since it already
deals with resv regions and software MSI.

> The iova from dma api can be same with va, and device can not distinguish
> them.
> So here we borrow va from user space and iommu_map to device, and the va
> becomes iova.
> Since this iova is from user space, so no conflict.
> Then dma api can not be used in this case.
> 
> drivers/vfio/vfio_iommu_type1.c also use iommu_domain_alloc.

VFIO needs to let userspace pick its IOVA, because the IOVA space is
generally managed by a guest OS. In my opinion this is a baggage that
uacce doesn't need.

If we only supported the DMA API and not unmanaged IOMMU domains,
userspace would need to do a little bit more work by differentiating
between VA and DMA addresses, but that could be abstracted into the uacce
library and it would make the kernel module a lot simpler.

[...]
> > I wish the SVA and !SVA paths were less interleaved. Both models are
> > fundamentally different:
> > 
> > * Without SVA you cannot share the device between multiple processes. All
> >    DMA mappings are in the "main", non-PASID address space of the device.
> > 
> >    Note that process isolation without SVA could be achieved with the
> >    auxiliary domains IOMMU API (introduced primarily for vfio-mdev) but
> >    this is not the model chosen here.
> Does pasid has to be supported for this case?

Yes, you do need PASID support for auxiliary domains, but not PRI/Stall.

[...]
> > > +	/* allocate memory */
> > > +	if (flags & UACCE_QFRF_DMA) {
> > At the moment UACCE_QFRF_DMA is never set, so there is a lot of unused and
> > possibly untested code in this file. I think it would be simpler to choose
> > between either DMA API or unmanaged IOMMU domains and stick with it. As
> > said before, I'd prefer DMA API.
> UACCE_QFRF_DMA is using dma api, it used this for quick method, though it
> can not prevent va conflict.
> We use an ioctl to get iova of the dma buffer.
> Since the interface is not standard, we kept the interface and verified
> internally.

As above, it's probably worth exploring this method further for !SVA.

> > > +		qfr->kaddr = dma_alloc_coherent(uacce->pdev,
> > > +						qfr->nr_pages << PAGE_SHIFT,
> > > +						&qfr->dma, GFP_KERNEL);
> > > +		if (!qfr->kaddr) {
> > > +			ret = -ENOMEM;
> > > +			goto err_with_qfr;
> > > +		}
> > > +	} else {
> > > +		ret = uacce_qfr_alloc_pages(qfr);
> > > +		if (ret)
> > > +			goto err_with_qfr;
> > > +	}
> > > +
> > > +	/* map to device */
> > > +	ret = uacce_queue_map_qfr(q, qfr);
> > Worth moving into the else above.
> The idea here is a, map to device, b, map to user space.

Yes but dma_alloc_coherent() creates the IOMMU mapping, and
uacce_queue_map_qfr()'s only task is to create the IOMMU mapping when the
DMA API isn't in use, so you could move this call up, right after
uacce_qfr_alloc_pages().

[...]
> > > +	q->state = UACCE_Q_ZOMBIE;
> > Since the PUT_Q ioctl makes the queue unrecoverable, why should userspace
> > invoke it instead of immediately calling close()?
> We found close does not release resource immediately, which may cause issue
> when re-open again
> when all queues are used.

I think the only way to fix that problem is to avoid reallocating the
resources until they are released, because we can't count on userspace to
always call the PUT_Q ioctl. Sometimes the program will crash before that.

> > > +static int uacce_fops_mmap(struct file *filep, struct vm_area_struct *vma)
> > > +{
> > > +	struct uacce_queue *q = filep->private_data;
> > > +	struct uacce_device *uacce = q->uacce;
> > > +	struct uacce_qfile_region *qfr;
> > > +	enum uacce_qfrt type = 0;
> > > +	unsigned int flags = 0;
> > > +	int ret;
> > > +
> > > +	if (vma->vm_pgoff < UACCE_QFRT_MAX)
> > > +		type = vma->vm_pgoff;
> > > +
> > > +	vma->vm_flags |= VM_DONTCOPY | VM_DONTEXPAND;
> > > +
> > > +	mutex_lock(&uacce_mutex);

By the way, lockdep detects a possible unsafe locking scenario here,
because we're taking the uacce_mutex even though mmap called us with the
mmap_sem held for writing. Conversely uacce_fops_release() takes the
mmap_sem for writing while holding the uacce_mutex. I think it can be
fixed easily, if we simply remove the use of mmap_sem in
uacce_fops_release(), since it's only taken to do some accounting which
doesn't look right.

However, a similar but more complex locking issue comes from the current
use of iommu_sva_bind/unbind_device():

uacce_fops_open:
 iommu_sva_unbind_device()
  iommu_sva_bind_group()	[iommu_group->mutex]
    mmu_notifier_get()		[mmap_sem]

uacce_fops_mmap:		[mmap_sem]
				[uacce_mutex]

uacce_fops_release:
				[uacce_mutex]
  iommu_sva_unbind_device()	[iommu_group->mutex]

This circular dependency can be broken by calling iommu_sva_unbind_device()
outside of uacce_mutex, but I think it's worth reworking the queue locking
scheme a little and use fine-grained locking for the queue state.

Something else I noticed is uacce_idr isn't currently protected. The IDR
API expected the caller to use its own locking scheme. You could replace
it with an xarray, which I think is preferred to IDR now and provides a
xa_lock.

Thanks,
Jean
