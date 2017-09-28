From: Harsh Jain <Harsh@chelsio.com>
Subject: Re: DMA error when sg->offset value is greater than PAGE_SIZE in
 Intel IOMMU
Date: Thu, 28 Sep 2017 10:31:35 +0530
Message-ID: <0764911a-1412-4a42-cf6b-74c6b78a4c3f@chelsio.com>
References: <MWHPR12MB16004E2A92CC3FFEC6313DDBC87A0@MWHPR12MB1600.namprd12.prod.outlook.com>
 <afa02763-4556-0e14-7d1b-1c044cdc1ff7@chelsio.com>
 <6d2af675-7b97-6eaf-4daa-d7bf80a05923@chelsio.com>
 <437a9bd8-d4d6-22ca-1a64-1a3e73f1101a@arm.com>
 <MWHPR12MB1600694D099E1CFAD6849A68C87B0@MWHPR12MB1600.namprd12.prod.outlook.com>
 <CAPcyv4jtYMZJ6V5VoXkGrcZ+ykWvYp1=qXrqJkjknk8Q_BVwgA@mail.gmail.com>
 <MWHPR12MB160060436AC70CB5BE8C0C6EC8780@MWHPR12MB1600.namprd12.prod.outlook.com>
 <20170927181802.3dcd7efb@m750.lan> <20170927144847.GA95654@otc-nc-03>
 <MWHPR12MB16005D59D7A33F3D5BE43395C8780@MWHPR12MB1600.namprd12.prod.outlook.com>
 <20170927190745.GA96373@otc-nc-03>
 <MWHPR12MB16007E5363E79173C52BFA19C8780@MWHPR12MB1600.namprd12.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Robin Murphy <robin.murphy@arm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        Michael Werner <werner@chelsio.com>, "nd@arm.com" <nd@arm.com>
To: Casey Leedom <leedom@chelsio.com>,
        "Raj, Ashok" <ashok.raj@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:27614 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750731AbdI1FC0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Sep 2017 01:02:26 -0400
In-Reply-To: <MWHPR12MB16007E5363E79173C52BFA19C8780@MWHPR12MB1600.namprd12.prod.outlook.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


On 28-09-2017 03:43, Casey Leedom wrote:
> | From: Raj, Ashok <ashok.raj@intel.com>
> | Sent: Wednesday, September 27, 2017 12:07 PM
> |
> | looking at the debug output i got from Harsh it still looks like a bug in
> | the code.
> |
> | [  538.284589] __domain_mapping nr_pages 0x1
> | [ 538.284600] __domain_mapping sg_res 0x1 sg->dma_address 0xf291000e dma len
> | 0x38 pteval 0x3cbce3003 phys_pfn 0x3cbce3
> | [ 538.284604] chelsio driver - offset 4110 len 56 dma addr f291000e dma len
> | 56
> | [  538.284667] DMAR: DRHD: handling fault status reg 2
> | [ 538.290017] DMAR: [DMA Write] Request device [02:00.4] fault addr f2910000
> | [fault reason 05] PTE Write access is not set
> |
> | somehow when crypto_authenc_encrypt() -> scatterwalk_ffwd()-> sg_set_page()
> |
> | ->sg_set_page(dst, sg_page(src), src->length - len, src->offset + len);
> |
> | src->offset + len gets set as sg->offset in sg_set_page(). Either the
> | assumption that there should be room is incorrect, or some higher order
> | crypto
Input received from user(Here XFRM) contains AAD(Additional Authentication data) || DATA(enc/dec) || Tag(hash). before passing input
to Cipher engine(chelsio) crypto_authenc_encrypt has to skip AAD which is 16 in our case. To skip that 16 bytes they simply incremented offset by 16. 
I think Robin is right DMA mapping should handle it.
> | code that ends up setting the offset did the wrong calculation.
> |
> | if src->offset is already towards the end of the page, then offset+len will
> | go beyond the end of page.
>
>   Hhmmm, it seems like we need Herbert to comment on this.
>
>   Herbert, is there any specific debugging information that you'd like to
> see here?
>
> Casey
