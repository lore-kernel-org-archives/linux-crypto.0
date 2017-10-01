From: Christoph Hellwig <hch@infradead.org>
Subject: Re: DMA error when sg->offset value is greater than PAGE_SIZE in
 Intel IOMMU
Date: Sun, 1 Oct 2017 01:59:13 -0700
Message-ID: <20171001085913.GA29880@infradead.org>
References: <MWHPR12MB160092A868C613FF64CA9EE9C87A0@MWHPR12MB1600.namprd12.prod.outlook.com>
 <20170925155430.GB131920@otc-nc-03>
 <MWHPR12MB16004E2A92CC3FFEC6313DDBC87A0@MWHPR12MB1600.namprd12.prod.outlook.com>
 <afa02763-4556-0e14-7d1b-1c044cdc1ff7@chelsio.com>
 <6d2af675-7b97-6eaf-4daa-d7bf80a05923@chelsio.com>
 <437a9bd8-d4d6-22ca-1a64-1a3e73f1101a@arm.com>
 <MWHPR12MB1600694D099E1CFAD6849A68C87B0@MWHPR12MB1600.namprd12.prod.outlook.com>
 <CAPcyv4jtYMZJ6V5VoXkGrcZ+ykWvYp1=qXrqJkjknk8Q_BVwgA@mail.gmail.com>
 <MWHPR12MB160060436AC70CB5BE8C0C6EC8780@MWHPR12MB1600.namprd12.prod.outlook.com>
 <CAPcyv4hL92Ru5x-b_5s80EwO=w37M=KEr289zrCRSM_8juvDzw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Casey Leedom <leedom@chelsio.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Harsh Jain <Harsh@chelsio.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Woodhouse <David.Woodhouse@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        Michael Werner <werner@chelsio.com>
To: Dan Williams <dan.j.williams@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4hL92Ru5x-b_5s80EwO=w37M=KEr289zrCRSM_8juvDzw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Sep 27, 2017 at 10:13:51AM -0700, Dan Williams wrote:
> As far as I can see "Offset can be greater than PAGE_SIZE" is the only
> safe assumption for core code.

It seems completely bogus to me, but if it is the current assumption
we'll have to document it.  But this brings me back to that
our scatterlists are a pretty horrible data structure to start
with as they try to mix virtual and physical addressing together.

We'd be much better of by passing a chain of bio_vecs where we
just need virtual addresses, a chain of [bus_addr,len] pairs where
we just need a physical address, and both where we need both instead
of this giant structure that tries to do both at the same time..
