Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8E79C282DA
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 03:10:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F668214DA
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 03:10:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.onmicrosoft.com header.i=@insidesecure.onmicrosoft.com header.b="OvrAAaqt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732183AbfDRDKm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Apr 2019 23:10:42 -0400
Received: from mail-eopbgr70117.outbound.protection.outlook.com ([40.107.7.117]:25175
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731985AbfDRDKl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Apr 2019 23:10:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=insidesecure.onmicrosoft.com; s=selector1-insidesecure-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fz6olTMkezI3KPFkL/niRwhOlJBgs0QttWwFJIrLKTg=;
 b=OvrAAaqtyAd/2TqX80NjaxYgOCui1u6/kmJ2Ntp0/Fz2d4tWkG2uRAnrAfrhI0AMD/PRykl4PYVvCRa4sh6raYIERdAJMyxgTl0SQH8Zw/C6rr5dChHKal8wKArlftkent8ZFm7SsgzkXCIiLfNPPhV9xSRdbzCGjokMbFZjVNI=
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com (10.255.99.206) by
 AM6PR09MB3416.eurprd09.prod.outlook.com (20.179.246.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1813.11; Thu, 18 Apr 2019 03:10:35 +0000
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::94e3:32d7:8d9e:6fbd]) by AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::94e3:32d7:8d9e:6fbd%5]) with mapi id 15.20.1813.013; Thu, 18 Apr 2019
 03:10:35 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: RE: Question regarding crypto scatterlists / testmgr
Thread-Topic: Question regarding crypto scatterlists / testmgr
Thread-Index: AdT1UrNnwXz5dYegQq+/zS0mWvhdgAACM8MAAAEghoAAAaBzgAALBhaA
Date:   Thu, 18 Apr 2019 03:10:35 +0000
Message-ID: <AM6PR09MB352393F7DB634941B4F852FBD2260@AM6PR09MB3523.eurprd09.prod.outlook.com>
References: <AM6PR09MB352386B26E3F632D6FE2FDDDD2250@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190417202407.GA96242@gmail.com>
 <AM6PR09MB3523FD88FE64E10B78B555F4D2250@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190417214257.GB96242@gmail.com>
In-Reply-To: <20190417214257.GB96242@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 85c0d580-fe6b-4c4b-e3e1-08d6c3ab6d36
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600141)(711020)(4605104)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM6PR09MB3416;
x-ms-traffictypediagnostic: AM6PR09MB3416:
x-microsoft-antispam-prvs: <AM6PR09MB341608EDECED0878ACA6E579D2260@AM6PR09MB3416.eurprd09.prod.outlook.com>
x-forefront-prvs: 0011612A55
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(396003)(39850400004)(346002)(376002)(199004)(189003)(52314003)(13464003)(6436002)(9686003)(55016002)(93886005)(6916009)(53936002)(66066001)(446003)(486006)(3846002)(33656002)(68736007)(316002)(5660300002)(6116002)(54906003)(11346002)(476003)(102836004)(52536014)(81156014)(256004)(71200400001)(8676002)(14444005)(81166006)(305945005)(229853002)(8936002)(7696005)(71190400001)(99286004)(7736002)(186003)(4326008)(53546011)(14454004)(6506007)(478600001)(26005)(86362001)(2906002)(97736004)(25786009)(76176011)(74316002)(6246003);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR09MB3416;H:AM6PR09MB3523.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: uKImpvMJ7lIvB2TjmPJq4oHy3tpcS6deUdyiOqWSRX0pe2/+djwnSbQzO41h+mwOvPxiM8g13ruS/pdctQLLl9+PIjufgCVK9UKhyu1n61vxmwp9+8OB0LYRvH1A3+H2xtNiG+f+osP5FaUfUmmrsHwfmjP/5MRs9ymwtNZpjYkFdWCZ3+i7f7UpvPUE2XSRrsJ64GZqToFvaw7KHQjtLoqHD55kKx4fWqt1TNDb/dN4jtJ1CysPvHrUo3ZDjqHaHM/SrOArNwQNKyvS+YLUXhIg32O/dlIbnmLkHV86iYM03LpdXQOA8NlbpL6klSeVgZ43JJdmUCsS6kzzoHawEp39a0nu1uya7CTjyEEFs51VgDRV/9BNdzLKh7lInqE1D1BSlCijg75Xz7QlutFJmMqqo+qTRQZFiPtmItWlqeI=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85c0d580-fe6b-4c4b-e3e1-08d6c3ab6d36
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2019 03:10:35.6750
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR09MB3416
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Eric Biggers [mailto:ebiggers@kernel.org]
> Sent: Wednesday, April 17, 2019 11:43 PM
> To: Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
> Cc: linux-crypto@vger.kernel.org; Herbert Xu
> <herbert@gondor.apana.org.au>
> Subject: Re: Question regarding crypto scatterlists / testmgr
>
> Hi Pascal,
>
> On Wed, Apr 17, 2019 at 09:16:54PM +0000, Pascal Van Leeuwen wrote:
> > > -----Original Message-----
> > > From: Eric Biggers [mailto:ebiggers@kernel.org]
> > > Sent: Wednesday, April 17, 2019 10:24 PM
> > > To: Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
> > > Cc: linux-crypto@vger.kernel.org; Herbert Xu
> > > <herbert@gondor.apana.org.au>
> > > Subject: Re: Question regarding crypto scatterlists / testmgr
> > >
> > > Hi Pascal,
> > >
> > > On Wed, Apr 17, 2019 at 07:51:08PM +0000, Pascal Van Leeuwen wrote:
> > > > Hi,
> > > >
> > > > I'm trying to fix the inside-secure driver to pass all testmgr
> > > > tests and I have one final issue remaining with the AEAD ciphers.
> > > > As it was not clear at all what the exact problem was, I spent
> > > > some time reverse engineering testmgr and I got the distinct
> > > > impression that it is using scatter particles that cross page
> > > > boundaries. On purpose, even.
> > > >
> > > > While the inside-secure driver is built on the premise that
> > > > scatter particles are continuous in device space. As I can't
> > > > think of any reason why you would want to scatter/gather other
> > > > than to handle virtual-to-physical address translation ...
> > > > In any case, this should affect all other other operations as
> > > > well, but maybe those just got "lucky" by getting particles
> > > > that were still contiguous in device space, despite the page
> > > > crossing (to *really* verify this, you would have to fully
> > > > randomize your page allocation!)
> > > >
> > > > Anyway, assuming that I *should* be able to handle particles
> > > > that are *not* contiguous in device space, then there should
> > > > probably already exist some function in the kernel API that
> > > > converts a scatterlist with non-contiguous particles into a
> > > > scatterlist with contiguous particles, taking into account the
> > > > presence of an IOMMU? Considering pretty much every device
> > > > driver would need to do that?
> > > > Does anyone know which function(s) to use for that?
> > > >
> > > > Regards,
> > > > Pascal van Leeuwen
> > > > Silicon IP Architect, Multi-Protocol Engines @ Inside Secure
> > > >
> > >
> > > Indeed, since v5.1, testmgr tests scatterlist elements that cross a
> > > page.
> > > However, the pages are guaranteed to be *physically* contiguous.
> Does
> > > dma_map_sg() not handle this?
> > >
> > I'm not entirely sure and the API documentation is not particularly
> > clear on *what* dma_map_sg() actually does, but I highly doubt it
> > considering the particle count is only an input parameter (i.e. it
> > can't output an increase in particles that would be required).
> > So I think it just ensures the pages are actually flushed to memory
> > and accessible by the device (in case an IOMMU interferes) and not
> > much than that.
> >
> > In any case, scatter particles to be used by hardware should *not*
> > cross any physical page boundaries.
> > But also see the thread I had on this with Ard - seems like the
> crypto
> > API already has some mechanism for enforcing this but it's not
> enabled
> > for AEAD ciphers?
> >
> > >
> > > BTW, this isn't just a theoretical case.  Many crypto API users do
> > > crypto on
> > > kmalloced buffers, and those can cross a page boundary, especially
> if
> > > they are
> > > large.  All software crypto algorithms handle this case.
> > >
> > Software sits behind the CPU's MMU and sees virtual memory as
> > contiguous. It does not need to "handle" anything, it gets it for
> free.
> > Hardware does not have that luxury, unless you have a functioning
> IOMMU
> > but that is still pretty rare.
> > So for hardware, you need to break down your buffers until individual
> > pages and stitch those together. That's the main use case of a
> scatter
> > list and it requires the particles to NOT cross physical pages.
> >
> > > The fact that these types of issues are just being considered now
> > > certainly
> > > isn't raising my confidence in the hardware crypto drivers in the
> > > kernel...
> > >
> > Actually, this is *not* a problem with the hardware drivers. It's a
> > problem with the API and/or how you are trying to use it. Hardware
> > does NOT see the nice contiguous virtual memory that SW sees.
> >
>
> I don't understand why you keep talking about virtual memory.  The
> memory in
> each scatterlist element is referenced by struct page, not by virtual
> address.
> It may cross page boundaries; however, all pages referenced by each
> element are
> guaranteed to be adjacent, i.e. physically contiguous.  Am I missing
> something?
>
Ok, I'm not super at home with the behavior of all these kernel API calls
just, just learning, so I did not really know that. I thought you were
trying to say that the pages themselves were contiguous, not that the
pages were contiguous with respect to each other.

The pages not being contiguous seemed to be a perfect explanation for the
behavior I was seeing, and testmgr *does* try to make data cross page
boundaries, which does not seem to be super useful if they're guaranteed
to be contiguous anyway.  However, I just thought of another reason that
could explain the same behavior (and why it affects only AEAD) ... let me
explore that tomorrow.

> Note that memory allocated by kmalloc() is both virtually and
> physically
> contigious.  That's why it works to use sg_init_one() on a kmalloc()'ed
> buffer.
>
> - Eric


Thanks,

Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines

