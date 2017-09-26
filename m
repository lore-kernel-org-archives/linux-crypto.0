From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: DMA error when sg->offset value is greater than PAGE_SIZE in
 Intel IOMMU
Date: Tue, 26 Sep 2017 09:10:52 -0700
Message-ID: <CAPcyv4jtYMZJ6V5VoXkGrcZ+ykWvYp1=qXrqJkjknk8Q_BVwgA@mail.gmail.com>
References: <20170920080151.GA3348@gondor.apana.org.au> <26992a1e-edb3-ed78-ce8e-31e0739d75f4@arm.com>
 <MWHPR12MB160092A868C613FF64CA9EE9C87A0@MWHPR12MB1600.namprd12.prod.outlook.com>
 <20170925155430.GB131920@otc-nc-03> <MWHPR12MB16004E2A92CC3FFEC6313DDBC87A0@MWHPR12MB1600.namprd12.prod.outlook.com>
 <afa02763-4556-0e14-7d1b-1c044cdc1ff7@chelsio.com> <6d2af675-7b97-6eaf-4daa-d7bf80a05923@chelsio.com>
 <437a9bd8-d4d6-22ca-1a64-1a3e73f1101a@arm.com> <MWHPR12MB1600694D099E1CFAD6849A68C87B0@MWHPR12MB1600.namprd12.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Robin Murphy <robin.murphy@arm.com>,
        Harsh Jain <Harsh@chelsio.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Woodhouse <David.Woodhouse@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        Michael Werner <werner@chelsio.com>
To: Casey Leedom <leedom@chelsio.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:54295 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935993AbdIZQKy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Sep 2017 12:10:54 -0400
Received: by mail-oi0-f46.google.com with SMTP id u130so12192498oib.11
        for <linux-crypto@vger.kernel.org>; Tue, 26 Sep 2017 09:10:53 -0700 (PDT)
In-Reply-To: <MWHPR12MB1600694D099E1CFAD6849A68C87B0@MWHPR12MB1600.namprd12.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Sep 26, 2017 at 9:06 AM, Casey Leedom <leedom@chelsio.com> wrote:
> | From: Robin Murphy <robin.murphy@arm.com>
> | Sent: Tuesday, September 26, 2017 7:22 AM
>
> |
> | On 26/09/17 13:21, Harsh Jain wrote:
> | > Find attached new set of log. After repeated tries it panics.
> |
> | Thanks, that makes things a bit clearer - looks like fixing the physical
> | address/pteval calculation to not be off by a page in one direction wasn't
> | helping much because the returned DMA address is actually also off by a
> | page in the other direction, and thus overflowing past the allocated IOVA
> | into whoever else's mapping happened to be there; complete carnage ensues.
> |
> | After another look through the intel_map_sg() path, here's my second
> (still
> | completely untested) guess at a possible fix.
> |
> | Robin.
> |
> | ----->8-----
> | diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> | index 6784a05dd6b2..d7f7def81613 100644
> | --- a/drivers/iommu/intel-iommu.c
> | +++ b/drivers/iommu/intel-iommu.c
> | @@ -2254,10 +2254,12 @@ static int __domain_mapping(struct dmar_domain
> *domain, unsigned long iov_pfn,
> |                  uint64_t tmp;
> |
> |                  if (!sg_res) {
> | +                       size_t off = sg->offset & ~PAGE_MASK;
> | +
> |                          sg_res = aligned_nrpages(sg->offset, sg->length);
> | -                       sg->dma_address = ((dma_addr_t)iov_pfn <<
> VTD_PAGE_SHIFT) + sg->offset;
> | +                       sg->dma_address = ((dma_addr_t)iov_pfn <<
> VTD_PAGE_SHIFT) + off;
> |                          sg->dma_length = sg->length;
> | -                       pteval = page_to_phys(sg_page(sg)) | prot;
> | +                       pteval = (page_to_phys(sg_page(sg)) + sg->offset -
> off) | prot;
> |                          phys_pfn = pteval >> VTD_PAGE_SHIFT;
> |                  }
>
>   Thanks Robin.  And thanks Harsh for sending the detailed trace logs.  I'll
> see if I can get this tested today.  Harsh is probably headed towards bed,
> but there may be sufficiently good instructions in our internal bug system
> to reproduce the issue.
>
>   Regardless, it seems that you agree that there's an issue with the Intel
> I/O MMU support code with regard to the legal values which a (struct
> scatterlist) can take on?  I still can't find any documentation for this
> and, personally, I'm a bit baffled by a Page-oriented Scatter/Gather List
> representation where [Offset, Offset+Length) can reside outside the Page.

Consider the case where the page represents a huge page, then an
offset greater than PAGE_SIZE (up to HPAGE_SIZE) makes sense.
