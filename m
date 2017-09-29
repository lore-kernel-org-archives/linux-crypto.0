From: Harsh Jain <Harsh@chelsio.com>
Subject: Re: [PATCH] iommu/vt-d: Fix scatterlist offset handling
Date: Fri, 29 Sep 2017 13:44:45 +0530
Message-ID: <fe25071a-18bf-e468-01e7-36515f2110e2@chelsio.com>
References: <644c3e01654f8bd48d669c36e424959d6ef0e27e.1506607370.git.robin.murphy@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: dwmw2@infradead.org, ashok.raj@intel.com, leedom@chelsio.com,
        herbert@gondor.apana.org.au, iommu@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Robin Murphy <robin.murphy@arm.com>, joro@8bytes.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:56848 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751933AbdI2IPc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Sep 2017 04:15:32 -0400
In-Reply-To: <644c3e01654f8bd48d669c36e424959d6ef0e27e.1506607370.git.robin.murphy@arm.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Robin,

I tried running patch on our test setup.

With "intel_iommu=on" : I can see single occurrence of DMAR Write failure on perf traffic with 10 thread.

    [  749.616480] perf: interrupt took too long (3203 > 3202), lowering kernel.perf_event_max_sample_rate to 62000
[  852.500671] DMAR: DRHD: handling fault status reg 2
[  852.506039] DMAR: [DMA Write] Request device [02:00.4] fault addr ef919000 [fault reason 05] PTE Write access is not set
[root@heptagon linux_t4_build]# cat /proc/cmdline
BOOT_IMAGE=/vmlinuz-4.9.51+ root=UUID=ccbb7f18-b3f0-43df-89de-07521e9c02fe ro intel_iommu=on crashkernel=auto rhgb quiet rhgb quiet console=ttyS0,115200, console=tty0 LANG=en_US.UTF-8

With intel_iommu=sp_off : It works fine for more than 30 minutes without any issues.


On 28-09-2017 19:44, Robin Murphy wrote:
> The intel-iommu DMA ops fail to correctly handle scatterlists where
> sg->offset is greater than PAGE_SIZE - the IOVA allocation is computed
> appropriately based on the page-aligned portion of the offset, but the
> mapping is set up relative to sg->page, which means it fails to actually
> cover the whole buffer (and in the worst case doesn't cover it at all):
>
>     (sg->dma_address + sg->dma_len) ----+
>     sg->dma_address ---------+          |
>     iov_pfn------+           |          |
>                  |           |          |
>                  v           v          v
> iova:   a        b        c        d        e        f
>         |--------|--------|--------|--------|--------|
>                           <...calculated....>
>                  [_____mapped______]
> pfn:    0        1        2        3        4        5
>         |--------|--------|--------|--------|--------|
>                  ^           ^          ^
>                  |           |          |
>     sg->page ----+           |          |
>     sg->offset --------------+          |
>     (sg->offset + sg->length) ----------+
>
> As a result, the caller ends up overrunning the mapping into whatever
> lies beyond, which usually goes badly:
>
> [  429.645492] DMAR: DRHD: handling fault status reg 2
> [  429.650847] DMAR: [DMA Write] Request device [02:00.4] fault addr f2682000 ...
>
> Whilst this is a fairly rare occurrence, it can happen from the result
> of intermediate scatterlist processing such as scatterwalk_ffwd() in the
> crypto layer. Whilst that particular site could be fixed up, it still
> seems worthwhile to bring intel-iommu in line with other DMA API
> implementations in handling this robustly.
>
> To that end, fix the intel_map_sg() path to line up the mapping
> correctly (in units of MM pages rather than VT-d pages to match the
> aligned_nrpages() calculation) regardless of the offset, and use
> sg_phys() consistently for clarity.
>
> Reported-by: Harsh Jain <Harsh@chelsio.com>
> Signed-off-by: Robin Murphy <robin.murphy@arm.com>
> ---
>  drivers/iommu/intel-iommu.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> index 6784a05dd6b2..83f3d4831f94 100644
> --- a/drivers/iommu/intel-iommu.c
> +++ b/drivers/iommu/intel-iommu.c
> @@ -2254,10 +2254,12 @@ static int __domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
>  		uint64_t tmp;
>  
>  		if (!sg_res) {
> +			unsigned int pgoff = sg->offset & ~PAGE_MASK;
> +
>  			sg_res = aligned_nrpages(sg->offset, sg->length);
> -			sg->dma_address = ((dma_addr_t)iov_pfn << VTD_PAGE_SHIFT) + sg->offset;
> +			sg->dma_address = ((dma_addr_t)iov_pfn << VTD_PAGE_SHIFT) + pgoff;
>  			sg->dma_length = sg->length;
> -			pteval = page_to_phys(sg_page(sg)) | prot;
> +			pteval = (sg_phys(sg) - pgoff) | prot;
>  			phys_pfn = pteval >> VTD_PAGE_SHIFT;
>  		}
>  
> @@ -3790,7 +3792,7 @@ static int intel_nontranslate_map_sg(struct device *hddev,
>  
>  	for_each_sg(sglist, sg, nelems, i) {
>  		BUG_ON(!sg_page(sg));
> -		sg->dma_address = page_to_phys(sg_page(sg)) + sg->offset;
> +		sg->dma_address = sg_phys(sg);
>  		sg->dma_length = sg->length;
>  	}
>  	return nelems;
