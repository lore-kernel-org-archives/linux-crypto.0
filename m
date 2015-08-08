From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 6/6] scatterlist: use sg_phys()
Date: Fri, 7 Aug 2015 18:15:49 -0700
Message-ID: <CAPcyv4gkZZH5FCeZgOcsXJaE0Ug5F3x0VxhX0PqkoNZwLeEbyQ@mail.gmail.com>
References: <1438964116-24321-1-git-send-email-hch@lst.de>
	<1438964116-24321-7-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jens Axboe <axboe@kernel.dk>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Julia Lawall <Julia.Lawall@lip6.fr>,
	Joerg Roedel <joro@8bytes.org>
To: Christoph Hellwig <hch@lst.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:33585 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946491AbbHHBPu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Aug 2015 21:15:50 -0400
Received: by wijp15 with SMTP id p15so77475116wij.0
        for <linux-crypto@vger.kernel.org>; Fri, 07 Aug 2015 18:15:49 -0700 (PDT)
In-Reply-To: <1438964116-24321-7-git-send-email-hch@lst.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Aug 7, 2015 at 9:15 AM, Christoph Hellwig <hch@lst.de> wrote:
> From: Dan Williams <dan.j.williams@intel.com>
>
> Coccinelle cleanup to replace open coded sg to physical address
> translations.  This is in preparation for introducing scatterlists that
> reference __pfn_t.
>
> // sg_phys.cocci: convert usage page_to_phys(sg_page(sg)) to sg_phys(sg)
> // usage: make coccicheck COCCI=sg_phys.cocci MODE=patch
>
> virtual patch
> virtual report
> virtual org
>
> @@
> struct scatterlist *sg;
> @@
>
> - page_to_phys(sg_page(sg)) + sg->offset
> + sg_phys(sg)
>
> @@
> struct scatterlist *sg;
> @@
>
> - page_to_phys(sg_page(sg))
> + sg_phys(sg) - sg->offset

So this ends up being an awkward conversion, a better one is:

- page_to_phys(sg_page(sg))
+ sg_phys(sg) & PAGE_MASK

[..]
> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> index 5852df8..e0faecc 100644
> --- a/drivers/iommu/intel-iommu.c
> +++ b/drivers/iommu/intel-iommu.c
> @@ -2098,7 +2098,7 @@ static int __domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
>                         sg_res = aligned_nrpages(sg->offset, sg->length);
>                         sg->dma_address = ((dma_addr_t)iov_pfn << VTD_PAGE_SHIFT) + sg->offset;
>                         sg->dma_length = sg->length;
> -                       pteval = page_to_phys(sg_page(sg)) | prot;
> +                       pteval = (sg_phys(sg) - sg->offset) | prot;

For example here, as Joerg pointed out.

[1]: https://lkml.org/lkml/2015/6/10/230
