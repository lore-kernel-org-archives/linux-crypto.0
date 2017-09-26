From: Robin Murphy <robin.murphy@arm.com>
Subject: Re: DMA error when sg->offset value is greater than PAGE_SIZE in
 Intel IOMMU
Date: Tue, 26 Sep 2017 19:15:47 +0100
Message-ID: <691bd1d4-ba5f-dd82-2866-d64cd2d6b55e@arm.com>
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
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Harsh Jain <Harsh@chelsio.com>, Casey Leedom <leedom@chelsio.com>,
        Herbert Xuy <herbert@gondor.apana.org.au>,
        David Woodhouse <David.Woodhouse@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>
To: "Raj, Ashok" <ashok.raj@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:37188 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965646AbdIZSPv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Sep 2017 14:15:51 -0400
In-Reply-To: <20170926143441.GA136940@otc-nc-03>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 26/09/17 15:34, Raj, Ashok wrote:
> On Tue, Sep 26, 2017 at 03:22:47PM +0100, Robin Murphy wrote:
>> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
>> index 6784a05dd6b2..d7f7def81613 100644
>> --- a/drivers/iommu/intel-iommu.c
>> +++ b/drivers/iommu/intel-iommu.c
>> @@ -2254,10 +2254,12 @@ static int __domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
>>  		uint64_t tmp;
>>  
>>  		if (!sg_res) {
>> +			size_t off = sg->offset & ~PAGE_MASK;
> 
> Should this be VTD_PAGE_MASK?

PAGE_MASK (and the corresponding pteval arithmetic) was intentional
here; given the way aligned_nrpages() works, the IOVA space allocated in
intel_map_sg() (and thus iov_pfn) is already rounded to full MM pages,
and it seemed like the original intent was to map the whole lot - this
change is just to make that happen correctly.

Whether it's actually reasonable to decouple the IOMMU and CPU page
sizes entirely (as we do in dma-iommu, for example), and not do the
MM-page-alignment thing at all, is another matter that I'm happy to
leave in your hands :)

Robin.

>> +
>>  			sg_res = aligned_nrpages(sg->offset, sg->length);
>> -			sg->dma_address = ((dma_addr_t)iov_pfn << VTD_PAGE_SHIFT) + sg->offset;
>> +			sg->dma_address = ((dma_addr_t)iov_pfn << VTD_PAGE_SHIFT) + off;
>>  			sg->dma_length = sg->length;
>> -			pteval = page_to_phys(sg_page(sg)) | prot;
>> +			pteval = (page_to_phys(sg_page(sg)) + sg->offset - off) | prot;
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
