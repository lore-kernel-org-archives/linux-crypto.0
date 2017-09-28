From: "Raj, Ashok" <ashok.raj@intel.com>
Subject: Re: [PATCH] iommu/vt-d: Fix scatterlist offset handling
Date: Thu, 28 Sep 2017 08:43:46 -0700
Message-ID: <20170928154345.GA101272@otc-nc-03>
References: <644c3e01654f8bd48d669c36e424959d6ef0e27e.1506607370.git.robin.murphy@arm.com>
 <MWHPR12MB1600DA9DF9CF54221B752694C8790@MWHPR12MB1600.namprd12.prod.outlook.com>
 <20170928132942.GA99552@otc-nc-03>
 <a135090f-27e2-cf69-b3a7-c9d0e101bf07@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Casey Leedom <leedom@chelsio.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        Harsh Jain <Harsh@chelsio.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Werner <werner@chelsio.com>,
        Atul Gupta <atul.gupta@chelsio.com>
To: Robin Murphy <robin.murphy@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:27574 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750942AbdI1SjH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Sep 2017 14:39:07 -0400
Content-Disposition: inline
In-Reply-To: <a135090f-27e2-cf69-b3a7-c9d0e101bf07@arm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Robin

thanks.. i have no idea.. i see all the other patches from you :-)
my email has decided to play games with me i suppose :-)

On Thu, Sep 28, 2017 at 05:59:11PM +0100, Robin Murphy wrote:
> I hope our email server hasn't got blacklisted again... Said patch is
> the top of this very thread we're replying on[1] - you were definitely
> on cc :(

        (sg->dma_address + sg->dma_len) ----+
        sg->dma_address ---------+          |
        iov_pfn------+           |          |
                     |           |          |
                     v           v          v
    iova:   a        b        c        d        e        f
            |--------|--------|--------|--------|--------|
                              <...calculated....>
                     [_____mapped______]
    pfn:    0        1        2        3        4        5
            |--------|--------|--------|--------|--------|
                     ^           ^          ^
                     |           |          |
        sg->page ----+           |          |
        sg->offset --------------+          |
        (sg->offset + sg->length) ----------+

The picture seems right. Looking at the code i'm not sure if i understand
it correctly.

pgoff = sg->offset & ~PAGE_MASK;

this gets the offset past the start of page.

sg->dma_address = ((dma_addr_t)iov_pfn << VTD_PAGE_SHIFT) + pgoff;

this would set dma_address at b+off instead of starting at c+off correct?

> 
> Robin
> 
> [1]:https://lists.linuxfoundation.org/pipermail/iommu/2017-September/024371.html
