From: Casey Leedom <leedom@chelsio.com>
Subject: Re: DMA error when sg->offset value is greater than PAGE_SIZE in
 Intel IOMMU
Date: Mon, 25 Sep 2017 17:46:40 +0000
Message-ID: <MWHPR12MB160092A868C613FF64CA9EE9C87A0@MWHPR12MB1600.namprd12.prod.outlook.com>
References: <20170920080151.GA3348@gondor.apana.org.au>,<26992a1e-edb3-ed78-ce8e-31e0739d75f4@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
To: Robin Murphy <robin.murphy@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Harsh Jain" <Harsh@chelsio.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2nam02on0094.outbound.protection.outlook.com ([104.47.38.94]:11027
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S934514AbdIYRqo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Sep 2017 13:46:44 -0400
In-Reply-To: <26992a1e-edb3-ed78-ce8e-31e0739d75f4@arm.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

| From: Robin Murphy <robin.murphy@arm.com>
| Sent: Wednesday, September 20, 2017 3:12 AM
|
| On 20/09/17 09:01, Herbert Xu wrote:
| >
| > Harsh Jain <Harsh@chelsio.com> wrote:
| >>
| >> While debugging DMA mapping error in chelsio crypto driver we
| >> observed that when scatter/gather list received by driver has
| >> some entry with page->offset > 4096 (PAGE_SIZE). It starts
| >> giving DMA error.  Without IOMMU it works fine.
| >
| > This is not a bug.  The network stack can and will feed us such
| > SG lists.
| >
| >> 2) It cannot be driver's responsibilty to update received sg
| >> entries to adjust offset and page because we are not the only
| >> one who directly uses received sg list.
| >
| > No the driver must deal with this.  Having said that, if we can
| > improve our driver helper interface to make this easier then we
| > should do that too.  What we certainly shouldn't do is to take a
| > whack-a-mole approach like this patch does.
|
| AFAICS this is entirely on intel-iommu - from a brief look it appears
| that all the IOVA calculations would handle the offset correctly, but
| then __domain_mapping() blindly uses sg_page() for the physical address,
| so if offset is larger than a page it would end up with the DMA mapping
| covering the wrong part of the buffer.
|
| Does the diff below help?
|
| Robin.
|
| ----->8-----
| diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
| index b3914fce8254..2ed43d928135 100644
| --- a/drivers/iommu/intel-iommu.c
| +++ b/drivers/iommu/intel-iommu.c
| @@ -2253,7 +2253,7 @@ static int __domain_mapping(struct dmar_domain *dom=
ain, unsigned long iov_pfn,
|                          sg_res =3D aligned_nrpages(sg->offset, sg->lengt=
h);
|                          sg->dma_address =3D ((dma_addr_t)iov_pfn << VTD_=
PAGE_SHIFT) + sg->offset;
|                          sg->dma_length =3D sg->length;
| -                       pteval =3D page_to_phys(sg_page(sg)) | prot;
| +                       pteval =3D (sg_phys(sg) & PAGE_MASK) | prot;
|                          phys_pfn =3D pteval >> VTD_PAGE_SHIFT;
|                  }

  Adding some likely people to the Cc list so they can comment on this.
Dan Williams submitted that specific piece of code in kernel.org:3e6110fd54
... but there are lots of similar bits in that function.  Hopefully one of
the Intel I/O MMU Gurus will have a better idea of what may be going wrong
here.  In the mean time I've asked our team to gather far more detailed
debug traces showing the exact Scatter/Gather Lists we're getting, what the=
y
get translated to in the DMA Mappings, and what DMA Addresses were seeing i=
n
error.

Casey
