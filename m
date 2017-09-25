From: "Raj, Ashok" <ashok.raj@intel.com>
Subject: Re: DMA error when sg->offset value is greater than PAGE_SIZE in
 Intel IOMMU
Date: Mon, 25 Sep 2017 12:03:11 -0700
Message-ID: <20170925190310.GA132175@otc-nc-03>
References: <20170920080151.GA3348@gondor.apana.org.au>
 <26992a1e-edb3-ed78-ce8e-31e0739d75f4@arm.com>
 <MWHPR12MB160092A868C613FF64CA9EE9C87A0@MWHPR12MB1600.namprd12.prod.outlook.com>
 <CAPcyv4j3J41eY2eR07nTvo75F0yCbL9bNHM8GmXEFOHDQUuf8Q@mail.gmail.com>
 <MWHPR12MB1600948B2F57696189FC7C22C87A0@MWHPR12MB1600.namprd12.prod.outlook.com>
 <CAPcyv4ihhJM5+iHTMzH2m5n7X5347MHkj0h2DC5KGobjby5nmg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Casey Leedom <leedom@chelsio.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Harsh Jain <Harsh@chelsio.com>, Ashok Raj <ashok.raj@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:56882 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932698AbdIYVsm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Sep 2017 17:48:42 -0400
Content-Disposition: inline
In-Reply-To: <CAPcyv4ihhJM5+iHTMzH2m5n7X5347MHkj0h2DC5KGobjby5nmg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi

On Mon, Sep 25, 2017 at 01:11:04PM -0700, Dan Williams wrote:
> On Mon, Sep 25, 2017 at 1:05 PM, Casey Leedom <leedom@chelsio.com> wrote:
> > | From: Dan Williams <dan.j.williams@intel.com>
> > | Sent: Monday, September 25, 2017 12:31 PM
> > | ...
> > | IIUC it looks like this has been broken ever since commit e1605495c716
> > | "intel-iommu: Introduce domain_sg_mapping() to speed up
> > | intel_map_sg()". I.e. it looks like the calculation for pte_val should
> > | be:
> > |
> > |     pteval = (page_to_phys(sg_page(sg)) + sg->offset) | prot;
> >
> > Hhmmm, shouldn't that be:
> >
> >     pteval = (page_to_phys(sg_page(sg)) + (sg->offset>>PAGE_SHIFT)) | prot;
> 
> Yes, I think you're right. We do want to mask off the page-unaligned
> portion of sg->offset.

Shoulnd't we normalize the entire sg_page(sg) + sg_offset.

if when you only mask the page-unaligned portion i suspect you might be
pointing to a different region?

something like (sg_page(sg) + (sg->offset << VTD_PAGE_SHIFT)) 

then add the unaligned part.. sg->offset>>VTD_PAGE_SHIFT

Is this happening because you are using a 2M page? not sure what triggers
this or causes the driver to get passed in larger than 4K offset, or 
running 32bit kernel?

if its legal to get passed in such odd values, we should fix IOMMU driver to 
handle it properly, otherwise we should atleast fail those requests.

Cheers,
Ashok
