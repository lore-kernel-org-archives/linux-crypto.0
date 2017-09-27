From: Casey Leedom <leedom@chelsio.com>
Subject: Re: DMA error when sg->offset value is greater than PAGE_SIZE in
 Intel IOMMU
Date: Wed, 27 Sep 2017 17:30:08 +0000
Message-ID: <MWHPR12MB1600F29183F84D29077FD4BDC8780@MWHPR12MB1600.namprd12.prod.outlook.com>
References: <20170920080151.GA3348@gondor.apana.org.au>
        <26992a1e-edb3-ed78-ce8e-31e0739d75f4@arm.com>
        <MWHPR12MB160092A868C613FF64CA9EE9C87A0@MWHPR12MB1600.namprd12.prod.outlook.com>
        <20170925155430.GB131920@otc-nc-03>
        <MWHPR12MB16004E2A92CC3FFEC6313DDBC87A0@MWHPR12MB1600.namprd12.prod.outlook.com>
        <afa02763-4556-0e14-7d1b-1c044cdc1ff7@chelsio.com>
        <6d2af675-7b97-6eaf-4daa-d7bf80a05923@chelsio.com>
        <437a9bd8-d4d6-22ca-1a64-1a3e73f1101a@arm.com>
        <MWHPR12MB1600694D099E1CFAD6849A68C87B0@MWHPR12MB1600.namprd12.prod.outlook.com>
        <CAPcyv4jtYMZJ6V5VoXkGrcZ+ykWvYp1=qXrqJkjknk8Q_BVwgA@mail.gmail.com>
        <MWHPR12MB160060436AC70CB5BE8C0C6EC8780@MWHPR12MB1600.namprd12.prod.outlook.com>,<20170927181802.3dcd7efb@m750.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: Dan Williams <dan.j.williams@intel.com>,
        "Harsh Jain" <Harsh@chelsio.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        Michael Werner <werner@chelsio.com>, "nd@arm.com" <nd@arm.com>
To: Robin Murphy <robin.murphy@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam01on0101.outbound.protection.outlook.com ([104.47.32.101]:49888
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750852AbdI0RaO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Sep 2017 13:30:14 -0400
In-Reply-To: <20170927181802.3dcd7efb@m750.lan>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

| From: Robin Murphy <robin.murphy@arm.com>
| Sent: Wednesday, September 27, 2017 10:18 AM
|=20
| From my experience, in general terms each scatterlist segment
| represents some contiguous quantity of pages, of which sg->page is the
| first, while sg->length and sg->offset describe the specific bounds of
| that segment's data. ...

  Okay, thanks Robin.  That'll help me in my reviews of your and Ashok's
suggested changes to the Intel I/O MMU __domain_mapping() routine.

Casey=
