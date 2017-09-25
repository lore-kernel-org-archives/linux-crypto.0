From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: DMA error when sg->offset value is greater than PAGE_SIZE in
 Intel IOMMU
Date: Mon, 25 Sep 2017 12:31:39 -0700
Message-ID: <CAPcyv4j3J41eY2eR07nTvo75F0yCbL9bNHM8GmXEFOHDQUuf8Q@mail.gmail.com>
References: <20170920080151.GA3348@gondor.apana.org.au> <26992a1e-edb3-ed78-ce8e-31e0739d75f4@arm.com>
 <MWHPR12MB160092A868C613FF64CA9EE9C87A0@MWHPR12MB1600.namprd12.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Robin Murphy <robin.murphy@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Harsh Jain <Harsh@chelsio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        David Woodhouse <David.Woodhouse@intel.com>
To: Casey Leedom <leedom@chelsio.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <MWHPR12MB160092A868C613FF64CA9EE9C87A0@MWHPR12MB1600.namprd12.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Sep 25, 2017 at 10:46 AM, Casey Leedom <leedom@chelsio.com> wrote:
> | From: Robin Murphy <robin.murphy@arm.com>
> | Sent: Wednesday, September 20, 2017 3:12 AM
> |
> | On 20/09/17 09:01, Herbert Xu wrote:
> | >
> | > Harsh Jain <Harsh@chelsio.com> wrote:
> | >>
> | >> While debugging DMA mapping error in chelsio crypto driver we
> | >> observed that when scatter/gather list received by driver has
> | >> some entry with page->offset > 4096 (PAGE_SIZE). It starts
> | >> giving DMA error.  Without IOMMU it works fine.
> | >
> | > This is not a bug.  The network stack can and will feed us such
> | > SG lists.
> | >
> | >> 2) It cannot be driver's responsibilty to update received sg
> | >> entries to adjust offset and page because we are not the only
> | >> one who directly uses received sg list.
> | >
> | > No the driver must deal with this.  Having said that, if we can
> | > improve our driver helper interface to make this easier then we
> | > should do that too.  What we certainly shouldn't do is to take a
> | > whack-a-mole approach like this patch does.
> |
> | AFAICS this is entirely on intel-iommu - from a brief look it appears
> | that all the IOVA calculations would handle the offset correctly, but
> | then __domain_mapping() blindly uses sg_page() for the physical address,
> | so if offset is larger than a page it would end up with the DMA mapping
> | covering the wrong part of the buffer.
> |
> | Does the diff below help?
> |
> | Robin.
> |
> | ----->8-----
> | diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> | index b3914fce8254..2ed43d928135 100644
> | --- a/drivers/iommu/intel-iommu.c
> | +++ b/drivers/iommu/intel-iommu.c
> | @@ -2253,7 +2253,7 @@ static int __domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
> |                          sg_res = aligned_nrpages(sg->offset, sg->length);
> |                          sg->dma_address = ((dma_addr_t)iov_pfn << VTD_PAGE_SHIFT) + sg->offset;
> |                          sg->dma_length = sg->length;
> | -                       pteval = page_to_phys(sg_page(sg)) | prot;
> | +                       pteval = (sg_phys(sg) & PAGE_MASK) | prot;

This breaks on platforms where sizeof(phys_addr_t) > sizeof(unsigned
long). I.e. it's not always safe to assume that PAGE_MASK is the
correct width.

> |                          phys_pfn = pteval >> VTD_PAGE_SHIFT;
> |                  }
>
>   Adding some likely people to the Cc list so they can comment on this.
> Dan Williams submitted that specific piece of code in kernel.org:3e6110fd54
> ... but there are lots of similar bits in that function.  Hopefully one of
> the Intel I/O MMU Gurus will have a better idea of what may be going wrong
> here.  In the mean time I've asked our team to gather far more detailed
> debug traces showing the exact Scatter/Gather Lists we're getting, what they
> get translated to in the DMA Mappings, and what DMA Addresses were seeing in
> error.

IIUC it looks like this has been broken ever since commit e1605495c716
"intel-iommu: Introduce domain_sg_mapping() to speed up
intel_map_sg()". I.e. it looks like the calculation for pte_val should
be:

    pteval = (page_to_phys(sg_page(sg)) + sg->offset) | prot;
