From: Casey Leedom <leedom@chelsio.com>
Subject: Re: DMA error when sg->offset value is greater than PAGE_SIZE in
 Intel IOMMU
Date: Mon, 25 Sep 2017 23:41:52 +0000
Message-ID: <MWHPR12MB1600B13A5FE1E0A5D73572D3C87A0@MWHPR12MB1600.namprd12.prod.outlook.com>
References: <20170920080151.GA3348@gondor.apana.org.au>
 <26992a1e-edb3-ed78-ce8e-31e0739d75f4@arm.com>
 <MWHPR12MB160092A868C613FF64CA9EE9C87A0@MWHPR12MB1600.namprd12.prod.outlook.com>
 <CAPcyv4j3J41eY2eR07nTvo75F0yCbL9bNHM8GmXEFOHDQUuf8Q@mail.gmail.com>
 <MWHPR12MB1600948B2F57696189FC7C22C87A0@MWHPR12MB1600.namprd12.prod.outlook.com>
 <CAPcyv4ihhJM5+iHTMzH2m5n7X5347MHkj0h2DC5KGobjby5nmg@mail.gmail.com>,<20170925190310.GA132175@otc-nc-03>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Harsh Jain" <Harsh@chelsio.com>,
        "Michael Werner" <werner@chelsio.com>
To: "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170925190310.GA132175@otc-nc-03>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

| From: Raj, Ashok <ashok.raj@intel.com>
| Sent: Monday, September 25, 2017 12:03 PM
|  =20
| On Mon, Sep 25, 2017 at 01:11:04PM -0700, Dan Williams wrote:
| > On Mon, Sep 25, 2017 at 1:05 PM, Casey Leedom <leedom@chelsio.com> wrot=
e:
| > > | From: Dan Williams <dan.j.williams@intel.com>
| > > | Sent: Monday, September 25, 2017 12:31 PM
| > > | ...
| > > | IIUC it looks like this has been broken ever since commit e1605495c=
716
| > > | "intel-iommu: Introduce domain_sg_mapping() to speed up
| > > | intel_map_sg()". I.e. it looks like the calculation for pte_val sho=
uld
| > > | be:
| > > |
| > > |     pteval =3D (page_to_phys(sg_page(sg)) + sg->offset) | prot;
| > >
| > > Hhmmm, shouldn't that be:
| > >
| > >     pteval =3D (page_to_phys(sg_page(sg)) + (sg->offset>>PAGE_SHIFT))=
 | prot;
| >
| > Yes, I think you're right. We do want to mask off the page-unaligned
| > portion of sg->offset.
|
| Shoulnd't we normalize the entire sg_page(sg) + sg_offset.
|
| if when you only mask the page-unaligned portion i suspect you might be
| pointing to a different region?
|
| something like (sg_page(sg) + (sg->offset << VTD_PAGE_SHIFT))
|
| then add the unaligned part.. sg->offset>>VTD_PAGE_SHIFT
|
| Is this happening because you are using a 2M page? not sure what triggers
| this or causes the driver to get passed in larger than 4K offset, or
| running 32bit kernel?
|
| if its legal to get passed in such odd values, we should fix IOMMU driver=
 to
| handle it properly, otherwise we should atleast fail those requests.

  (woof) This is all above me.  I've spent a chunk of time fruitlessly
trying to find documentation which says that scatterlist's are allowed to
have offset/length values which extend outside the sg_page(sg).  So someone
much more familiar with this stuff is going to need to say what's allowed.

  As I said, I've asked Harsh to provide us with a detailed trace of exactl=
y
what he's seeing and what the Scatter/Gather Lists are getting translated
into.  That information may make it easier to understand if/how
__domain_mapping() is screwing up ...

Casey
