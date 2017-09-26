From: "Raj, Ashok" <ashok.raj@intel.com>
Subject: Re: DMA error when sg->offset value is greater than PAGE_SIZE in
 Intel IOMMU
Date: Tue, 26 Sep 2017 07:40:33 -0700
Message-ID: <20170926144032.GA90930@otc-nc-03>
References: <20170920080151.GA3348@gondor.apana.org.au>
 <26992a1e-edb3-ed78-ce8e-31e0739d75f4@arm.com>
 <MWHPR12MB160092A868C613FF64CA9EE9C87A0@MWHPR12MB1600.namprd12.prod.outlook.com>
 <20170925155430.GB131920@otc-nc-03>
 <MWHPR12MB16004E2A92CC3FFEC6313DDBC87A0@MWHPR12MB1600.namprd12.prod.outlook.com>
 <afa02763-4556-0e14-7d1b-1c044cdc1ff7@chelsio.com>
 <6d2af675-7b97-6eaf-4daa-d7bf80a05923@chelsio.com>
 <437a9bd8-d4d6-22ca-1a64-1a3e73f1101a@arm.com>
 <20170926143441.GA136940@otc-nc-03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harsh Jain <Harsh@chelsio.com>, Casey Leedom <leedom@chelsio.com>,
        Herbert Xuy <herbert@gondor.apana.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>
To: Robin Murphy <robin.murphy@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:9754 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S937278AbdIZR2x (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Sep 2017 13:28:53 -0400
Content-Disposition: inline
In-Reply-To: <20170926143441.GA136940@otc-nc-03>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Oops..minor typo.. VTD_PAGE_SHIFT instead of VTD_PAGE_MASK


On Tue, Sep 26, 2017 at 07:34:41AM -0700, Ashok Raj wrote:
> On Tue, Sep 26, 2017 at 03:22:47PM +0100, Robin Murphy wrote:
> > diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> > index 6784a05dd6b2..d7f7def81613 100644
> > --- a/drivers/iommu/intel-iommu.c
> > +++ b/drivers/iommu/intel-iommu.c
> > @@ -2254,10 +2254,12 @@ static int __domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
> >  		uint64_t tmp;
> >  
> >  		if (!sg_res) {
> > +			size_t off = sg->offset & ~PAGE_MASK;
> 
> Should this be VTD_PAGE_MASK?
> 
> > +
> >  			sg_res = aligned_nrpages(sg->offset, sg->length);
> > -			sg->dma_address = ((dma_addr_t)iov_pfn << VTD_PAGE_SHIFT) + sg->offset;
> > +			sg->dma_address = ((dma_addr_t)iov_pfn << VTD_PAGE_SHIFT) + off;
> >  			sg->dma_length = sg->length;
> > -			pteval = page_to_phys(sg_page(sg)) | prot;
> > +			pteval = (page_to_phys(sg_page(sg)) + sg->offset - off) | prot;
> 
> Something seems wrong here.. sg->offset can be > VTD_PAGE_SIZE, think 
> we should add sg->offset and then find the pteval?
> 
> attached below another cut at fixing the same problem.. if there is something
> obvious i missed, let me know.
> 
> again.. untested :-)
> 
> Cheers,
> Ashok
> 

> Sometimes offset can be greater than 4K. vt-d needs to account for that.
> 
> From: Ashok Raj <ashok.raj@intel.com>
> 
> Signed-off-by: Ashok Raj <ashok.raj@intel.com>
> ---
>  drivers/iommu/intel-iommu.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> index 6784a05..d43b566 100644
> --- a/drivers/iommu/intel-iommu.c
> +++ b/drivers/iommu/intel-iommu.c
> @@ -2254,10 +2254,13 @@ static int __domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
>  		uint64_t tmp;
>  
>  		if (!sg_res) {
> +			size_t off = sg->offset & ~VTD_PAGE_SHIFT;
>  			sg_res = aligned_nrpages(sg->offset, sg->length);
> -			sg->dma_address = ((dma_addr_t)iov_pfn << VTD_PAGE_SHIFT) + sg->offset;
> +			sg->dma_address = ((dma_addr_t)
> +				(iov_pfn + sg->offset) << VTD_PAGE_SHIFT) + off;
>  			sg->dma_length = sg->length;
> -			pteval = page_to_phys(sg_page(sg)) | prot;
> +			pteval = (page_to_phys(sg_page(sg)) +
> +				(sg->offset << VTD_PAGE_SHIFT)) | prot;
>  			phys_pfn = pteval >> VTD_PAGE_SHIFT;
>  		}
>  


Sometimes offset can be greater than 4K. vt-d needs to account for that.

From: Ashok Raj <ashok.raj@intel.com>

Signed-off-by: Ashok Raj <ashok.raj@intel.com>
---
 drivers/iommu/intel-iommu.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 6784a05..0333afe 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -2254,10 +2254,13 @@ static int __domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
 		uint64_t tmp;
 
 		if (!sg_res) {
+			size_t off = sg->offset & ~VTD_PAGE_MASK;
 			sg_res = aligned_nrpages(sg->offset, sg->length);
-			sg->dma_address = ((dma_addr_t)iov_pfn << VTD_PAGE_SHIFT) + sg->offset;
+			sg->dma_address = ((dma_addr_t)
+				(iov_pfn + sg->offset) << VTD_PAGE_SHIFT) + off;
 			sg->dma_length = sg->length;
-			pteval = page_to_phys(sg_page(sg)) | prot;
+			pteval = (page_to_phys(sg_page(sg)) +
+				(sg->offset << VTD_PAGE_SHIFT)) | prot;
 			phys_pfn = pteval >> VTD_PAGE_SHIFT;
 		}
 
