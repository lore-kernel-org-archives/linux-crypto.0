From: Casey Leedom <leedom@chelsio.com>
Subject: Re: DMA error when sg->offset value is greater than PAGE_SIZE in
 Intel IOMMU
Date: Wed, 27 Sep 2017 21:29:23 +0000
Message-ID: <MWHPR12MB16005D59D7A33F3D5BE43395C8780@MWHPR12MB1600.namprd12.prod.outlook.com>
References: <MWHPR12MB160092A868C613FF64CA9EE9C87A0@MWHPR12MB1600.namprd12.prod.outlook.com>
 <20170925155430.GB131920@otc-nc-03>
 <MWHPR12MB16004E2A92CC3FFEC6313DDBC87A0@MWHPR12MB1600.namprd12.prod.outlook.com>
 <afa02763-4556-0e14-7d1b-1c044cdc1ff7@chelsio.com>
 <6d2af675-7b97-6eaf-4daa-d7bf80a05923@chelsio.com>
 <437a9bd8-d4d6-22ca-1a64-1a3e73f1101a@arm.com>
 <MWHPR12MB1600694D099E1CFAD6849A68C87B0@MWHPR12MB1600.namprd12.prod.outlook.com>
 <CAPcyv4jtYMZJ6V5VoXkGrcZ+ykWvYp1=qXrqJkjknk8Q_BVwgA@mail.gmail.com>
 <MWHPR12MB160060436AC70CB5BE8C0C6EC8780@MWHPR12MB1600.namprd12.prod.outlook.com>
 <20170927181802.3dcd7efb@m750.lan>,<20170927144847.GA95654@otc-nc-03>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: Dan Williams <dan.j.williams@intel.com>,
        "Harsh Jain" <Harsh@chelsio.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        Michael Werner <werner@chelsio.com>, "nd@arm.com" <nd@arm.com>
To: "Raj, Ashok" <ashok.raj@intel.com>,
        Robin Murphy <robin.murphy@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-dm3nam03on0122.outbound.protection.outlook.com ([104.47.41.122]:33941
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751801AbdI0V31 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Sep 2017 17:29:27 -0400
In-Reply-To: <20170927144847.GA95654@otc-nc-03>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hey Raj,

  Let us know if you need help in gathering more debugging information.  Fo=
r
the time being we've decided to ERRATA the use of the Intel I/O MMU with
IPsec till we Root Cause the issue.  But this is still at the top of Harsh'=
s
bug list.
=20
  With Robin's comments, I'm almost sure that the:

    (iov_pfn + sg->offset) << VTD_PAGE_SHIFT)

in your suggested patch is an issue.  iov_pfn is a Page Frame Number and
sg->offset is a Byte Offset.  It feels like this should be:

    size_t page_off =3D sg->offset & ~VTD_PAGE_MASK;
    unsigned long pfn_off =3D sg->offset >> VTD_PAGE_MASK;
    ...
    sg->dma_address =3D ((dma_addr_t)
                       (iov_pfn + pfn_off) << VTD_PAGE_SHIFT) + page_off;

When Harsh tried your original patch, Harsh' test system wouldn't even boot=
.

Casey
