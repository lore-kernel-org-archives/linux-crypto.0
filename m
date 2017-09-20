From: Harsh Jain <Harsh@chelsio.com>
Subject: Re: DMA error when sg->offset value is greater than PAGE_SIZE in
 Intel IOMMU
Date: Wed, 20 Sep 2017 16:50:24 +0530
Message-ID: <81e629aa-8b68-4e0e-404b-08f09a4bc52f@chelsio.com>
References: <20170920080151.GA3348@gondor.apana.org.au>
 <26992a1e-edb3-ed78-ce8e-31e0739d75f4@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: leedom@chelsio.com, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-crypto@vger.kernel.org,
        dwmw2@infradead.org
To: Robin Murphy <robin.murphy@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:46858 "EHLO l.chelsio.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751537AbdITLVP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Sep 2017 07:21:15 -0400
In-Reply-To: <26992a1e-edb3-ed78-ce8e-31e0739d75f4@arm.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 20-09-2017 15:42, Robin Murphy wrote:
> On 20/09/17 09:01, Herbert Xu wrote:
>> Harsh Jain <Harsh@chelsio.com> wrote:
>>> While debugging DMA mapping error in chelsio crypto driver we observed that when scatter/gather list received by driver has some entry with page->offset > 4096 (PAGE_SIZE). It starts giving DMA error.  Without IOMMU it works fine.
>> This is not a bug.  The network stack can and will feed us such
>> SG lists.
>>
>>> 2) It cannot be driver's responsibilty to update received sg entries to adjust offset and page 
>>> because we are not the only one who directly uses received sg list.
>> No the driver must deal with this.  Having said that, if we can
>> improve our driver helper interface to make this easier then we
>> should do that too.  What we certainly shouldn't do is to take a
>> whack-a-mole approach like this patch does.
> AFAICS this is entirely on intel-iommu - from a brief look it appears
> that all the IOVA calculations would handle the offset correctly, but
> then __domain_mapping() blindly uses sg_page() for the physical address,
> so if offset is larger than a page it would end up with the DMA mapping
> covering the wrong part of the buffer.
>
> Does the diff below help?
>
> Robin.
>
> ----->8-----
> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> index b3914fce8254..2ed43d928135 100644
> --- a/drivers/iommu/intel-iommu.c
> +++ b/drivers/iommu/intel-iommu.c
> @@ -2253,7 +2253,7 @@ static int __domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
>  			sg_res = aligned_nrpages(sg->offset, sg->length);
>  			sg->dma_address = ((dma_addr_t)iov_pfn << VTD_PAGE_SHIFT) + sg->offset;
>  			sg->dma_length = sg->length;
> -			pteval = page_to_phys(sg_page(sg)) | prot;
> +			pteval = (sg_phys(sg) & PAGE_MASK) | prot;
>  			phys_pfn = pteval >> VTD_PAGE_SHIFT;
>  		}
Robin,
Still having following error with above change.

[  429.645492] DMAR: DRHD: handling fault status reg 2
[  429.650847] DMAR: [DMA Write] Request device [02:00.4] fault addr f2682000 [t


>  
