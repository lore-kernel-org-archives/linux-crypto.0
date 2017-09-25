From: "Raj, Ashok" <ashok.raj@intel.com>
Subject: Re: DMA error when sg->offset value is greater than PAGE_SIZE in
 Intel IOMMU
Date: Mon, 25 Sep 2017 08:54:30 -0700
Message-ID: <20170925155430.GB131920@otc-nc-03>
References: <20170920080151.GA3348@gondor.apana.org.au>
 <26992a1e-edb3-ed78-ce8e-31e0739d75f4@arm.com>
 <MWHPR12MB160092A868C613FF64CA9EE9C87A0@MWHPR12MB1600.namprd12.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Robin Murphy <robin.murphy@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Harsh Jain <Harsh@chelsio.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>
To: Casey Leedom <leedom@chelsio.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <MWHPR12MB160092A868C613FF64CA9EE9C87A0@MWHPR12MB1600.namprd12.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Casey

Sorry, somehow didn't see this one come by.


On Mon, Sep 25, 2017 at 05:46:40PM +0000, Casey Leedom wrote:
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

Not sure how the page->offset would end up being greater than page-size?

If you have additional traces, please send them by. 

Is this a new driver? wondering how we didn't run into this?


Cheers,
Ashok
