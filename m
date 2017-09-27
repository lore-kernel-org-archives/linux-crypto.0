From: Robin Murphy <robin.murphy@arm.com>
Subject: Re: DMA error when sg->offset value is greater than PAGE_SIZE in
 Intel IOMMU
Date: Wed, 27 Sep 2017 18:18:02 +0100
Message-ID: <20170927181802.3dcd7efb@m750.lan>
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
        <MWHPR12MB160060436AC70CB5BE8C0C6EC8780@MWHPR12MB1600.namprd12.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Cc: Dan Williams <dan.j.williams@intel.com>,
        "Harsh Jain" <Harsh@chelsio.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        Michael Werner <werner@chelsio.com>, nd@arm.com
To: Casey Leedom <leedom@chelsio.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <MWHPR12MB160060436AC70CB5BE8C0C6EC8780@MWHPR12MB1600.namprd12.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, 27 Sep 2017 16:31:04 +0000
Casey Leedom <leedom@chelsio.com> wrote:

> | From: Dan Williams <dan.j.williams@intel.com>
> | Sent: Tuesday, September 26, 2017 9:10 AM
> |  =20
> | On Tue, Sep 26, 2017 at 9:06 AM, Casey Leedom <leedom@chelsio.com>
> wrote: | > | From: Robin Murphy <robin.murphy@arm.com>
> | > | Sent: Tuesday, September 26, 2017 7:22 AM
> | > |...
> | > ...
> | >   Regardless, it seems that you agree that there's an issue with
> the Intel | > I/O MMU support code with regard to the legal values
> which a (struct | > scatterlist) can take on?  I still can't find any
> documentation for this | > and, personally, I'm a bit baffled by a
> Page-oriented Scatter/Gather List | > representation where [Offset,
> Offset+Length) can reside outside the Page. |
> | Consider the case where the page represents a huge page, then an
> | offset greater than PAGE_SIZE (up to HPAGE_SIZE) makes sense.
>=20
>   Okay, but whatever the underlaying Page Size is, should [Offset,
> Offset+Length) completely reside within the referenced Page?  I'm just
> trying to understand the Invariance Conditions which are assumed by
> all of the code which processes Scatter/gather Lists ...

=46rom my experience, in general terms each scatterlist segment
represents some contiguous quantity of pages, of which sg->page is the
first, while sg->length and sg->offset describe the specific bounds of
that segment's data. As such, the length may certainly (and frequently
does) exceed PAGE_SIZE; for the offset, it's unlikely that the producer
would initially construct one greater than PAGE_SIZE instead of just
pointing sg->page further forward, but it seems reasonable for it to
come about if some intermediate subsystem is processing an existing
list in-place (as seems to be the case with crypto here).

My opinion is that this may be a slightly unusual case, but I would
not consider it an illegal one. I think most DMA mapping
implementations would handle it whether intentionally or not.

Robin.
