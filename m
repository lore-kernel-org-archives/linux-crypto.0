From: "Raj, Ashok" <ashok.raj@intel.com>
Subject: Re: DMA error when sg->offset value is greater than PAGE_SIZE in
 Intel IOMMU
Date: Thu, 28 Sep 2017 06:05:50 -0700
Message-ID: <20170928130549.GA99456@otc-nc-03>
References: <afa02763-4556-0e14-7d1b-1c044cdc1ff7@chelsio.com>
 <6d2af675-7b97-6eaf-4daa-d7bf80a05923@chelsio.com>
 <437a9bd8-d4d6-22ca-1a64-1a3e73f1101a@arm.com>
 <MWHPR12MB1600694D099E1CFAD6849A68C87B0@MWHPR12MB1600.namprd12.prod.outlook.com>
 <CAPcyv4jtYMZJ6V5VoXkGrcZ+ykWvYp1=qXrqJkjknk8Q_BVwgA@mail.gmail.com>
 <MWHPR12MB160060436AC70CB5BE8C0C6EC8780@MWHPR12MB1600.namprd12.prod.outlook.com>
 <20170927181802.3dcd7efb@m750.lan>
 <20170927144847.GA95654@otc-nc-03>
 <MWHPR12MB16005D59D7A33F3D5BE43395C8780@MWHPR12MB1600.namprd12.prod.outlook.com>
 <26d68681-a157-26d3-84cb-6684dcaf3135@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Casey Leedom <leedom@chelsio.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        Michael Werner <werner@chelsio.com>, "nd@arm.com" <nd@arm.com>
To: Harsh Jain <Harsh@chelsio.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <26d68681-a157-26d3-84cb-6684dcaf3135@chelsio.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Thanks for trying that Harsh. 

sp_off turns of super page support. Which this mode, do you still see offsets greater than 4k?

On Thu, Sep 28, 2017 at 07:08:21PM +0530, Harsh Jain wrote:
> 
> 
> Today I tried with "Intel_iommu=sp_off" boot option. Traffic runs without any error for more than 1 hrs. What magic this option did? :)

Cheers,
Ashok
