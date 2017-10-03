From: "Raj, Ashok" <ashok.raj@intel.com>
Subject: Re: [PATCH] iommu/vt-d: Fix scatterlist offset handling
Date: Tue, 3 Oct 2017 12:36:53 -0700
Message-ID: <20171003193653.GA244814@otc-nc-03>
References: <644c3e01654f8bd48d669c36e424959d6ef0e27e.1506607370.git.robin.murphy@arm.com>
 <MWHPR12MB1600DA9DF9CF54221B752694C8790@MWHPR12MB1600.namprd12.prod.outlook.com>
 <20170928132942.GA99552@otc-nc-03>
 <a135090f-27e2-cf69-b3a7-c9d0e101bf07@arm.com>
 <20170928154345.GA101272@otc-nc-03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Casey Leedom <leedom@chelsio.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Atul Gupta <atul.gupta@chelsio.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Michael Werner <werner@chelsio.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        Harsh Jain <Harsh@chelsio.com>
To: Robin Murphy <robin.murphy@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:47042 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750865AbdJCWt6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Oct 2017 18:49:58 -0400
Content-Disposition: inline
In-Reply-To: <20170928154345.GA101272@otc-nc-03>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Robin

I now see your patch and it does seem to be fix the problem.

On Thu, Sep 28, 2017 at 08:43:46AM -0700, Ashok Raj wrote:
> Hi Robin
> 
> 
> On Thu, Sep 28, 2017 at 05:59:11PM +0100, Robin Murphy wrote:
> > I hope our email server hasn't got blacklisted again... Said patch is
> > the top of this very thread we're replying on[1] - you were definitely
> > on cc :(
> 
>         (sg->dma_address + sg->dma_len) ----+
>         sg->dma_address ---------+          |
>         iov_pfn------+           |          |
>                      |           |          |
>                      v           v          v
>     iova:   a        b        c        d        e        f
>             |--------|--------|--------|--------|--------|
>                               <...calculated....>
>                      [_____mapped______]
>     pfn:    0        1        2        3        4        5
>             |--------|--------|--------|--------|--------|
>                      ^           ^          ^
>                      |           |          |
>         sg->page ----+           |          |
>         sg->offset --------------+          |
>         (sg->offset + sg->length) ----------+
> 
> The picture seems right. Looking at the code i'm not sure if i understand
> it correctly.
> 
> pgoff = sg->offset & ~PAGE_MASK;
> 
> this gets the offset past the start of page.
> 
> sg->dma_address = ((dma_addr_t)iov_pfn << VTD_PAGE_SHIFT) + pgoff;
> 
> this would set dma_address at b+off instead of starting at c+off correct?


I assumed align_nrpages() would allocate 2 pages when
the offset is over PAGE_SIZE, but it seems economical and only
allocates 1 page to cover just the sg->length bytes.

the pteval also seems correct now, since you changed to 
sg_phys() that already accounts for sg->offset, so you 
subtract pgoff.

-           pteval = page_to_phys(sg_page(sg)) | prot;
+           pteval = (sg_phys(sg) - pgoff) | prot;


Cheers,
Ashok
