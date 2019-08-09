Return-Path: <SRS0=Ue/q=WF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA119C31E40
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 08:35:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57A832166E
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 08:35:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="DDQRja67"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405724AbfHIIfP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Aug 2019 04:35:15 -0400
Received: from mail-eopbgr720075.outbound.protection.outlook.com ([40.107.72.75]:20064
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405641AbfHIIfP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Aug 2019 04:35:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DnNAfZZKlLQ0uk5WsAulsouJaMBKQDvYCxP5yp0Twv+krfW123YyEt96aM8aShST4G6qsMSJwseq/whIJsg0i8ca4/9wZDOXgPyALYwEUrS6C3n//MH25G9GKQJgjpDjqD1qAXraKMrLmyhPrecvEae6G4YqfzNKOPE91UcJXBSYTAS4V/iv0vJL0xOAZ7lh1S2mJWX0EpADwHmjQunje9F+KG0Kid94QAXgrrfxOG9sAzgjyB4R6y2VQoLELOE6TEUNRv4g/qwPvEorqCclyqNfpeIyDv+Sk1xnk6s2nell4HXG+euoknBDlsvvzyc0F1GWgWXqdZyzCDFQBdB1Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ypxyNpEqCH82qTKqki2dBcCkaq35FeoBbguPwS/ff+c=;
 b=chRvqbkbS+kUmTouVHIGXpJcrVKevCzwFtnPtptdXhcMulfisW/wQB+oFkb5XQ8VORThEERHWGAB5f9qiL+R5YXtNGIPY1GQEpy7w+A3OTaDIZvCgGPDA0VWmL2e9VSvHsGMxoLQH/XFoouM/H0E0JTwqJY5AveXcBiXwQ+DfAi/id0IVKoTEIzxbsrsumIev3kj3+syJqz2WAMeb9zlBtyGSq43xsOZlsI6ZPqv2DzDgllVr2ZENLnkydUhLbQzdlRPemtmVz0WpqYmExk6gyXWi4Vb0W+OgH8vHNJj89/yDqpy2ASIp/awJDyjEIg9UPmAYhfS3EL25GLK2qKvOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ypxyNpEqCH82qTKqki2dBcCkaq35FeoBbguPwS/ff+c=;
 b=DDQRja67tKz5H9Q/oVyGqmieM5Yh1KhWIfC2MARiEOPULbVcHln+g7SCRUFys9UB6sBcNaPZrcE74FRi/eKhYX2HkA06/W2UA7RayV7CykHkRGvS3v61UB6H0VbrtWK0wIsnqbxwbGsdYYyXIsvjRxWDsdJOtLmsFFd2hOJtqDE=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2462.namprd20.prod.outlook.com (20.179.145.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.20; Fri, 9 Aug 2019 08:35:11 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2157.020; Fri, 9 Aug 2019
 08:35:11 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC:     Milan Broz <gmazyland@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: [dm-devel] xts fuzz testing and lack of ciphertext stealing
 support
Thread-Topic: [dm-devel] xts fuzz testing and lack of ciphertext stealing
 support
Thread-Index: AQHVO/5l0aVU4O6KC0WgPIqEsMQCDqbyl6kA
Date:   Fri, 9 Aug 2019 08:35:11 +0000
Message-ID: <MN2PR20MB2973E9DB18F11B4896F3CFA0CAD60@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <20190716221639.GA44406@gmail.com>
 <20190718072154.m2umem24x4grbf6w@gondor.apana.org.au>
 <36e78459-1594-6d19-0ab4-95b03a6de036@gmail.com>
 <MN2PR20MB2973E61815F069E8C7D74177CAC80@MN2PR20MB2973.namprd20.prod.outlook.com>
 <b042649c-db98-9710-b063-242bdf520252@gmail.com>
 <20190720065807.GA711@sol.localdomain>
 <0d4d6387-777c-bfd3-e54a-e7244fde0096@gmail.com>
 <CAKv+Gu9UF+a1UhVU19g1XcLaEqEaAwwkSm3-2wTHEAdD-q4mLQ@mail.gmail.com>
 <MN2PR20MB2973B9C2DDC508A81AF4A207CAC40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu9C2AEbb++W=QTVWbeA_88Fo57NcOwgU5R8HBvzFwXkJw@mail.gmail.com>
 <MN2PR20MB2973C378AE5674F9E3E29445CAC60@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu-8n_DoauycDQS_9zzRew1rTuPaLxHyg6xhXMmqEvMaCA@mail.gmail.com>
 <MN2PR20MB2973CAE4E9CFFE1F417B2509CAC10@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu-j-8-bQS2A46-Kf1KHtkoPJ5Htk8WratqzyngnVu-wpw@mail.gmail.com>
 <MN2PR20MB29739591E1A3E54E7A8A8E18CAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20f4832e-e3af-e3c2-d946-13bf8c367a60@nxp.com>
 <VI1PR0402MB34856F03FCE57AB62FC2257998D40@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <MN2PR20MB2973C16264CA748F147834E9CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <VI1PR0402MB34859FF5C6129DAE01B1CA0098D70@VI1PR0402MB3485.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB34859FF5C6129DAE01B1CA0098D70@VI1PR0402MB3485.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c07c7150-50f7-4d0b-34a3-08d71ca47e50
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MN2PR20MB2462;
x-ms-traffictypediagnostic: MN2PR20MB2462:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB246226138B32E7CA2A8CA9ABCAD60@MN2PR20MB2462.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 01244308DF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(366004)(39850400004)(396003)(346002)(189003)(199004)(13464003)(478600001)(446003)(2906002)(74316002)(305945005)(8936002)(476003)(486006)(316002)(11346002)(54906003)(86362001)(110136005)(6116002)(3846002)(99286004)(33656002)(15974865002)(66066001)(66946007)(66476007)(55016002)(76116006)(9686003)(7736002)(64756008)(66446008)(8676002)(81156014)(81166006)(14454004)(6436002)(66556008)(229853002)(53546011)(6506007)(71190400001)(71200400001)(7696005)(76176011)(25786009)(186003)(102836004)(6246003)(26005)(5660300002)(52536014)(53936002)(4326008)(256004)(14444005)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2462;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: M29vP+3+83O5VzoQcU/ZiUQDtiWRtYs05F7/r26ixLyJu+KpmNA2Jf4cHkOIa85we1dtlA5EjdhOjBokaRxBmJmHeCH1HW9xy+jhnM36d9HWjihuRluzEowfvm1cThxYSiRNtI2xF+v+inBD/ZWHjTHiOXNUbjw49AKTcCoRVJZeRkGBeaiWLnggWjzSzsNzdfW6eQ4/LZNF1MX8rE8Y6i/z4p9ZP8j2tx7GvmuzWm/MWDvKIGTevUjkfYJXQHtFRsNFM3uqX4an0n5L1qum3yunb5C9RbxZU65Ec5L05s5rIXAFqwW/HxsCBkk1O4iyLItMpGexIArGAd/jl2roadPxjrEa4ojKHhvSsl6vmHqztEBvfrH5YX2IDtzaSWKd8IGqyS/VgJvYc0SNURrnLZvc2927/P00DsWOBfL14k8=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c07c7150-50f7-4d0b-34a3-08d71ca47e50
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2019 08:35:11.4425
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZyWDn6Yo6xVsMJgdBeciH8CysP/8+3P1P2UEBXUcOTLqCRFaY52RdSjn04gq/wuc6Mm2VrleMG7eClirjQxLju9v/uDBHLurkSFQ3cYfGHM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2462
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Horia Geanta <horia.geanta@nxp.com>
> Sent: Thursday, August 8, 2019 4:50 PM
> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>; Ard Biesheuvel
> <ard.biesheuvel@linaro.org>
> Cc: Milan Broz <gmazyland@gmail.com>; Herbert Xu <herbert@gondor.apana.or=
g.au>; dm-
> devel@redhat.com; linux-crypto@vger.kernel.org
> Subject: Re: [dm-devel] xts fuzz testing and lack of ciphertext stealing =
support
>=20
> On 8/7/2019 11:58 PM, Pascal Van Leeuwen wrote:
> >> -----Original Message-----
> >> From: Horia Geanta <horia.geanta@nxp.com>
> >> Sent: Wednesday, August 7, 2019 5:52 PM
> >> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>; Ard Biesheuvel
> >> <ard.biesheuvel@linaro.org>
> >> Cc: Milan Broz <gmazyland@gmail.com>; Herbert Xu <herbert@gondor.apana=
.org.au>; dm-
> >> devel@redhat.com; linux-crypto@vger.kernel.org
> >> Subject: Re: [dm-devel] xts fuzz testing and lack of ciphertext steali=
ng support
> >>
> >> On 7/26/2019 10:59 PM, Horia Geant=E3 wrote:
> >>> On 7/26/2019 1:31 PM, Pascal Van Leeuwen wrote:
> >>>> Ok, find below a patch file that adds your vectors from the specific=
ation
> >>>> plus my set of additional vectors covering all CTS alignments combin=
ed
> >>>> with the block sizes you desired. Please note though that these vect=
ors
> >>>> are from our in-house home-grown model so no warranties.
> >>> I've checked the test vectors against caam (HW + driver).
> >>>
> >>> Test vectors from IEEE 1619-2007 (i.e. up to and including "XTS-AES 1=
8")
> >>> are fine.
> >>>
> >>> caam complains when /* Additional vectors to increase CTS coverage */
> >>> section starts:
> >>> alg: skcipher: xts-aes-caam encryption test failed (wrong result) on =
test vector 9,
> >> cfg=3D"in-place"
> >>>
> >> I've nailed this down to a caam hw limitation.
> >> Except for lx2160a and ls1028a SoCs, all the (older) SoCs allow only f=
or
> >> 8-byte wide IV (sector index).
> >>
> > I guess it's easy to say now, but I already suspected a problem with fu=
ll 16
> > byte random IV's. A problem with CTS itself seemed implausible due to t=
he base
> > vectors from the spec running fine and I did happen to notice that all
> > vectors from the spec only use up to the lower 40 bits of the sector nu=
mber.
> > While my vectors randomize all 16 bytes.
> >
> > So I guess that means that 16 byte multiples (i.e. not needing CTS) wit=
h
> > full 16 byte sector numbers will probably also fail on caam HW ...
> >
> Yes, the limitation applies for all input sizes.
>=20
> It's actually mentioned in the commit that added xts support few years ba=
ck:
> c6415a6016bf ("crypto: caam - add support for acipher xts(aes)")
>=20
>     sector index - HW limitation: CAAM device supports sector index of on=
ly
>     8 bytes to be used for sector index inside IV, instead of whole 16 by=
tes
>     received on request. This represents 2 ^ 64 =3D 16,777,216 Tera of po=
ssible
>     values for sector index.
>=20
> > As for the tweak size, with very close scrutiny of the IEEE spec I actu=
ally
> > noticed some inconsistencies:
> >
> > - the text very clearly defines the tweak as 128 bit and starting from =
an
> > *arbitrary* non-negative integer, this is what I based my implementatio=
n on
> >
> > - all text examples and test vectors max out at 40 bits ... just exampl=
es,
> > but odd nonetheless (why 40 anyway?)
> >
> > - the example code fragment in Annex C actually has the S data unit num=
ber
> > input as an u64b, further commented as "64 bits" (but then loops 16 tim=
es to
> > convert it to a byte string ...)
> >
> The input I received from our HW design team was something like:
>=20
> - some P1619 drafts used LRW (instead of XTS), where the tweak "T"
> was 16B-wide
>=20
> - at some point P1619 drafts switched (and eventually standardized) XTS,
> where "T" is no longer the tweak - "i" is the (public) tweak, "T" being
> an intermediate (hidden) result in the encryption scheme
>=20
> - since for XTS "i" is supposed to be the sector number,
> there is no need to support 16B values - 8B being deemed sufficient
>=20
Actually, the specification does NOT define i as a straight sector
number, it specifies i to start from some "arbitrary non-negative integer"
with further values assigned "consecutively". (which does not even mandate
a binary increment, as long as it can be seen as some unbroken ordered=20
sequence).

A predictable sector number being a potential attack vector, I can imagine
not wanting to start i from zero (although that's probably what most simple
implementations will do?).

> Agree, limiting "i" (XTS tweak) to 8B is out-of-spec - irrespective of th=
e
> usefulness of the full 16B.
> That's why latest Freescale / NXP SoCs support 16B tweaks.
>=20
> Thanks,
> Horia

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
