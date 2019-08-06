Return-Path: <SRS0=y31I=WC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5C30C31E40
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Aug 2019 09:20:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 705B220B1F
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Aug 2019 09:20:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="qER4W4CY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732079AbfHFJU4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Aug 2019 05:20:56 -0400
Received: from mail-eopbgr710061.outbound.protection.outlook.com ([40.107.71.61]:60384
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730068AbfHFJU4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Aug 2019 05:20:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jw028UVe/xXpoADySY30prUtS3xsR3S+erBSM+cMhy1iKdV5HLG5gOyi5izpmekovRLabUalIKpuoIBe5rW4q3hZRYcw9hSza88vVG1RALn9DcNJOn2OVr/n4fXMW6yVqPzcl19od7aNJw1UBGZ5B03k+l2sATqEZfOlDE3XOuIaWGx0okmBCDMdEvhuMRMWkhRDPahaxE6r/dzywrPTRxajKnveu0mHILZEJky0QGjU+QgCO3B0hrzSqidke4JERDpIQK9UdVNe2FkZn6Grxso6i/m8m1MOwapZBjvurieRGG/toS9O4M+HFaAwZ67zk8ZqeoLAW9AD80EmjmIYRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NcZbbltim6GV8l1xZOFlJb94nygdoNoCjPryv+vfKXk=;
 b=gNY7vhk8KHD7jQMSrfdVNZvdH0U3r5M6dwjRlNe1u/F9HSwZbVy4udJvS1GTJ0z2joLDkZil9zJfHXPJj+2s9WlMobShEoqGDOpkbXxaz0fh8EzcAx4T/Mj6rsBZ2nfCfo4EFctmH58zyNbqASatBTB396Bp1eK2MaKZYlLvRhF8uGUWqfNy2XkzpOKNOgbjBAbKI8GihOixmUrdEMSTwlWsjRQCHZaVEHsxyM0cKdZFp4ddEPwBtbO1aDGoKxE5zeBTTRpMKQnosc22yvR5lJ3ujbpVccaPKDDFS8zdljQ6u+xxlay7T+ZjZZCCRVsztiaevf0Sgnv7OKC54ApM9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NcZbbltim6GV8l1xZOFlJb94nygdoNoCjPryv+vfKXk=;
 b=qER4W4CYtpdLTO8ORt67A/ZCLI7GzY5+j7kM2gAWaVJvg5uPdMSUh6deTh+h833B5ZiSls37o7nzCHgNOXnnJfLE8bmMHcWfgG0902EfdrXda+6uACJZbv+ZYO4RKp/lgOtFyUF86LDy+5WLgV9Og5c11vZD0te+6jZJm4Bxl50=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2510.namprd20.prod.outlook.com (20.179.144.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.14; Tue, 6 Aug 2019 09:20:53 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2136.018; Tue, 6 Aug 2019
 09:20:53 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>
Subject: RE: AEAD question
Thread-Topic: AEAD question
Thread-Index: AdVAg8AmA/XQEiKgTqyXrFAlioQdkwAJe5sAAAwi13AC1wLTwA==
Date:   Tue, 6 Aug 2019 09:20:52 +0000
Message-ID: <MN2PR20MB2973743A8887D20AC6104DC0CAD50@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <MN2PR20MB29734143B4A5F5E418D55001CAC40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190722162240.GB689@sol.localdomain>
 <MN2PR20MB2973B95A0C91380CF881FF25CAC40@MN2PR20MB2973.namprd20.prod.outlook.com>
In-Reply-To: <MN2PR20MB2973B95A0C91380CF881FF25CAC40@MN2PR20MB2973.namprd20.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e01bfbd3-bce0-4be6-6b4a-08d71a4f612b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2510;
x-ms-traffictypediagnostic: MN2PR20MB2510:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB2510A6C9FCFC7D0E423C0E18CAD50@MN2PR20MB2510.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0121F24F22
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39850400004)(366004)(396003)(136003)(346002)(13464003)(199004)(189003)(71200400001)(71190400001)(81166006)(6116002)(81156014)(5660300002)(55016002)(74316002)(7736002)(221733001)(68736007)(8676002)(305945005)(3846002)(110136005)(99286004)(3480700005)(478600001)(6246003)(76176011)(2501003)(25786009)(8936002)(7696005)(66946007)(66476007)(64756008)(7116003)(102836004)(66446008)(15974865002)(66556008)(6506007)(53546011)(26005)(4326008)(54906003)(52536014)(186003)(476003)(486006)(229853002)(33656002)(11346002)(66066001)(316002)(86362001)(14454004)(53936002)(446003)(76116006)(14444005)(6436002)(256004)(2906002)(9686003)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2510;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: sye0B7CCeMA3s0nR95TKFDlwswvDvLLZ85uAGXUekl0r1ZgDBo8JE1cYleB1EFmm2WKEhja0xaqN8buvSU+GXsk5Xn40s9z+MufU4QeV+NO3QUZWqsB/RlYohcnHx4geqgf6c6L5rOo6TnysEPFy+1qnpRuqvZDUuBVFb47J1uRC6hSWUyx5/GyqkGaoNULVY4hRF/3tYj6KyJp2iUYP0f5Tl+a4DAKUCS90e9ReU7/cZ/bY2vPpkir+C7bdTjuqhBVIhM8bqrFl2vlQccgKhBnk2F9GnB+I3GM8WjzVeBTCvKOkt7wD6K3H7r6OR+Zj+yk1hNR1RDWoZN1I4niqtNOC8wLkOZx9mNO348Dd7ozGwZcXwpdtP3F5EtmYp//yCelkwsXZwcA3w8cVDTVETjtAlsri6qncxN6zJaSBex8=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e01bfbd3-bce0-4be6-6b4a-08d71a4f612b
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2019 09:20:53.0089
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2510
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Herbert,

The discussion below still lacks some resolution ...

What is boils down to is: what should an authenc AEAD driver do when it
gets a setauthsize request of zero?

It could either return -EINVAL on the setauthsize request as AEAD with
an authsize of zero makes no sense at all and only allowing a limited=20
subset of authsizes seems to be commonplace.
Or it could process the request without appending or verifying the=20
authenticator (basically throwing away the authentication result!).

I have a strong preference for the former, as the latter would require
workarounds in the inside-secure driver for a corner case that does
not make any practicle sense (without the authenticator, it is not an
AEAD in the first place, why authenticate and throw away the result?),=20
but the current generic implementation does seem to process this.

Consistent behavior here is important for the fuzz testing by testmgr.

Regards,
Pascal

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.=
org> On Behalf Of
> Pascal Van Leeuwen
> Sent: Tuesday, July 23, 2019 12:27 AM
> To: Eric Biggers <ebiggers@kernel.org>
> Cc: linux-crypto@vger.kernel.org; Herbert Xu <herbert@gondor.apana.org.au=
>;
> davem@davemloft.net
> Subject: RE: AEAD question
>=20
> > -----Original Message-----
> > From: Eric Biggers <ebiggers@kernel.org>
> > Sent: Monday, July 22, 2019 6:23 PM
> > To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> > Cc: linux-crypto@vger.kernel.org; Herbert Xu <herbert@gondor.apana.org.=
au>;
> davem@davemloft.net
> > Subject: Re: AEAD question
> >
> > On Mon, Jul 22, 2019 at 12:55:39PM +0000, Pascal Van Leeuwen wrote:
> > > Eric & Herbert,
> > >
> > > I noticed the testmgr fuzz tester generating (occasionally, see previ=
ous mail) tests
> cases with
> > > authsize=3D0 for the AEAD ciphers. I'm wondering if that is intention=
al. Or actually,
> I'm wondering
> > > whether that should be considered a legal case.
> > > To me, it doesn't seem to make a whole lot of sense to do *authentica=
ted* encryption
> and then
> > > effectively throw away the authentication result ... (it's just a was=
te of power
> and/or cycles)
> > >
> > > The reason for this question is that supporting this requires some sp=
ecific workaround
> in my
> > > driver (yet again). And yes, I'm aware of the fact that I can adverti=
se I don't
> support zero length
> > > authentication tags, but then probably/likely testmgr will punish me =
for that instead.
> > >
> >
> > As before you're actually talking about the "authenc" template for IPSe=
c and not
> > about AEADs in general, right?
> >
> Hmmm .... for the time being yes. At the time I wrote that, I was still e=
xpecting all
> AEAD's to be
> somewhat consistent in this respect (as our hardware is), but actually I'=
ve just been
> trying to
> reverse engineer the GCM template and IIRC it indeed does not allow an au=
thsize of 0.
> Or anything below 4 bytes, actually.
>=20
> >  I'm not familiar with that algorithm, so you'll
> > have to research what the specification says, and what's actually using=
 it.
> >
> To the best of my knowledge, there is no formal specification of any such=
 thing. There are
> protocols that use it (e.g. IPsec) which have restrictions but other prot=
ocols beyond my
> knowledge may have other restrictions ... 0 seems very unlikely though ..=
.
>=20
> > Using an AEAD with authsize=3D0 is indeed silly, but perhaps someone us=
ing that in
> > some badly designed protocol where authentication is optional.  Also AF=
AICS from
> > the code, any authsize fits naturally into the algorithm; i.e., excludi=
ng 0
> > would be a special case.
> >
> Again, looking at the GCM template, excluding certain authsizes is certai=
nly not
> something out of the ordinary.
>=20
> > But again, someone actually has to research this.  Maybe
> > crypto_aead_setauthsize() should simply reject authsize=3D0 for all AEA=
Ds.
> >
> IMHO that would make sense. Without authentication, it's not an AEAD.
> And actually executing the MAC and then throwing away the *full* result i=
s really
> silly. More likely to be some programming mistake than actually intended =
use.
> (but if someone knows of an actual use case for that, please do correct m=
e)
>=20
> > What we should *not* do, IMO, is remove it from the tests and allow
> > implementations to do whatever they want.  If it's wrong we should fix =
it
> > everywhere, so that the behavior is consistent.
> >
> Oh, I fully agree there. All implementations should still respond the sam=
e.
>=20
> > - Eric
>=20
> Regards,
> Pascal van Leeuwen
> Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
> www.insidesecure.com

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
