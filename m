Return-Path: <SRS0=Ue/q=WF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41CB6C31E40
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 21:33:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE65B208C3
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 21:33:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="u3OY3bOO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbfHIVd5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Aug 2019 17:33:57 -0400
Received: from mail-eopbgr690059.outbound.protection.outlook.com ([40.107.69.59]:59203
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726022AbfHIVd4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Aug 2019 17:33:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TRIojsVw8oHubRbB8mtfYcDsGp/Vdc3/j/XrmIDvvluIs4QX/Ynwfg1zAAouzogYH3TAsW9pmQp41gZWe9nEOxdTmYlKQLwLKEaHmXJzEJ5DbscSa5oFV3UNfZp3cPS+JiOewlIX83D1bmnB8vtFiNhGyr1ayMtA/BCrPWWssgv1l6PtTQPKMseoYJyUqzwbi9UiO90IyFLZCMeDgNq6qFt1ixn263DeosCVm1DbdUT78/wm16EYTjCBQEq2y83C1BxkyThFL+2mk3m4LCzOplHiDJK7IhvDDMI6vdQO1mgoeteIOeRSgVw/IVESzHDKH5gCpfF2UKgBHlo49cyDGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kml/gosS12HqNnqP4V+ulH9f5o5DZYpqog23z0UNHi8=;
 b=WvwIcMGSC+hjnv347iWyx9V4Vfpwn6RDXXhyzU0uNuFGVcjnxoZD+UD/Y7VyjIz53ohW7Tj7nbhP5rvMioNDTMNNq/ycn/IT5uCcm+NG3pvUH14o33HZ4kRZaphr6SQTIA6XPxLPAwlXPjMiOf/sGgPBLXBJ+f+NdnzHAv+SK9LH1dwtg3vQs0Q7zOIBoxRmEZo2zTF0aHPiBy+dLoHXQrajq5TW7xKkLyS48mSjCI1l+OC6d3d4EWTRUCWjHaVB/y9SaJNUyXTwS0c8tCwqNRYR/CaDhjRDPw5jyHHoXHdZAfpi55+LDosqBuh3julbKKZ3xpX8R0FpPd8ubMCMdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kml/gosS12HqNnqP4V+ulH9f5o5DZYpqog23z0UNHi8=;
 b=u3OY3bOOrJ6zS25Sh1gIp212TWFZjD5LX7bYDzgpWch/4nrwyir9r5n16ewHCVBhE74ltCtmDwOIGu31XoFLwalZsyYUBevKXJ7fo6no4acAwWZF+9Yxo7PSHtpnF9sg6Rhonl9ptAXp6X2SxU5nr6zjkisCbQyeIIXgDMB2RTw=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2303.namprd20.prod.outlook.com (20.179.148.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Fri, 9 Aug 2019 21:33:14 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2157.020; Fri, 9 Aug 2019
 21:33:14 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: [RFC PATCH v2] md/dm-crypt - reuse eboiv skcipher for IV
 generation
Thread-Topic: [RFC PATCH v2] md/dm-crypt - reuse eboiv skcipher for IV
 generation
Thread-Index: AQHVTOQKWnTPkdATo0i/D1XZtRSIkqbvRQ3wgABmBgCAAAHhUIAAJeoAgAAASmCAARpFgIAAAIWQgABIkICAAAcZkIAAQkcAgAEBE3CAAJHdAIAAM6SQgAAJhoCAAAKAEA==
Date:   Fri, 9 Aug 2019 21:33:14 +0000
Message-ID: <MN2PR20MB29736FF8E67D83FEA5A52E14CAD60@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <CAKv+Gu8fgg=gt4LSnCfShnf0-PZ=B1TNwM3zdQr+V6hkozgDOA@mail.gmail.com>
 <MN2PR20MB29733EEF59CCD754256D5621CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190808083059.GB5319@sol.localdomain>
 <MN2PR20MB297328E243D74E03C1EF54ACCAD70@MN2PR20MB2973.namprd20.prod.outlook.com>
 <67b4f0ee-b169-8af4-d7af-1c53a66ba587@gmail.com>
 <MN2PR20MB29739B9D16130F5C06831C92CAD70@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190808171508.GA201004@gmail.com>
 <MN2PR20MB2973387C1A083138866EE45FCAD60@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190809171720.GC658@sol.localdomain>
 <MN2PR20MB2973BE617D7BC075BB7BB1ACCAD60@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190809205614.GB100971@gmail.com>
In-Reply-To: <20190809205614.GB100971@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7ed6626b-4f73-44c1-2655-08d71d112f7a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MN2PR20MB2303;
x-ms-traffictypediagnostic: MN2PR20MB2303:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB2303DFF0121EED6D2EC58372CAD60@MN2PR20MB2303.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01244308DF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(39840400004)(366004)(396003)(346002)(189003)(13464003)(199004)(33656002)(102836004)(256004)(26005)(66066001)(316002)(3846002)(6116002)(186003)(71190400001)(229853002)(99286004)(2906002)(7696005)(14444005)(76176011)(71200400001)(9686003)(76116006)(8676002)(6916009)(66476007)(81156014)(64756008)(5660300002)(476003)(14454004)(486006)(66446008)(6246003)(66946007)(55016002)(66556008)(53936002)(52536014)(25786009)(81166006)(74316002)(86362001)(15974865002)(6436002)(7736002)(478600001)(53546011)(305945005)(6506007)(11346002)(446003)(4326008)(8936002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2303;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: B5ul+80AiB4enXWWzFKGqeh5OTNph3EmtM1lsq8U5Towgb36HwkOISVv3x5hP8j6nf5WF4AFzsVtAMHGyLwp52L4r4kyG0TYNYOntELU6OPXKAUXbITG8YcKYbQIDNpe/qBRW3hkwM7H7XYzXIZl2BE71v2T55rB3dWPKsq2WIbabI6hx0LV/Kx0br1heYr9s3QPI96q5bxhqYGPC+QIL3PHS+G9vQpRtoSLjxf1dAnlEqTeOSqHbNjTGlF4ZjTWU4oG7pCulFR0ND4Mdb3G6p0j3QBZo52BzGKPE+6by7Qzrhnr64UYdLQlpbuSd+MP5qzMEtV1BQ3Kgg5aWMZ257Kq/rd4oF7y5LA4blz4WKRTbiE9/8JdXVo7JAA/lNwZZvuYXcYs0kNtv97/fZPOT479/SK5EyaRxMYeGP/o0Lg=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ed6626b-4f73-44c1-2655-08d71d112f7a
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2019 21:33:14.2349
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rjwFuWAwC0kRK+BafFd5wT5mWlxKLbg0RV9D2RB7z3pqGTR93UrH4Mif0xUiC/+HodMeKBWHDfOjbOG4Q39UjGOU3bsynzyklWi4QuP0v0w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2303
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Eric Biggers <ebiggers@kernel.org>
> Sent: Friday, August 9, 2019 10:56 PM
> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Cc: linux-crypto@vger.kernel.org
> Subject: Re: [RFC PATCH v2] md/dm-crypt - reuse eboiv skcipher for IV gen=
eration
>=20
> On Fri, Aug 09, 2019 at 08:29:59PM +0000, Pascal Van Leeuwen wrote:
> > >
> > > There's no proof that other attacks don't exist.
> > >
> > As you can't prove something doesn't exist ...
>=20
> Of course you can, that's what the security proofs for crypto constructio=
ns
> always do.  They prove that no efficient attack exists (in some attack mo=
del)
> unless the underlying crypto primitives are weak.
>=20
> >
> > > If you're going to advocate
> > > for using it regardless, then you need to choose a different (weaker)=
 attack
> > > model, then formally prove that the construction is secure under that=
 model.
> > > Or show where someone else has done so.
> > >
> > I'm certainly NOT advocating the use of this. I was merely pointing out=
 a
> > legacy use case that happens to be very relevant to people stuck with i=
t,
> > which therefore should not be dismissed so easily.
> > And how this legacy use case may have further security implications (li=
ke
> > the tweak encryption being more sensitive than was being assumed, so yo=
u
> > don't want to run that through an insecure implementation).
>=20
> Obviously there are people already using bad crypto, whether this or some=
thing
> else, and they often need to continue to be supported.  I'm not disputing=
 that.
>=20
> What I'm disputing is your willingness to argue that it's not really that=
 bad,
> without a corresponding formal proof which crypto constructions always ha=
ve.
>=20
Real life designs require all kinds of trade-offs and compromises.
If you want to make something twice as expensive, you'd better have a=20
really solid reason for doing so. So yes, I do believe it is useful to
be sceptical and question these things. But I always listen to good=20
arguments, so just convince me I got it wrong *for my particular use
case* (I'm not generally interested in the generic case).

I mean, we were talking XTS here. Which is basically better-than-
nothing crypto anyway. It's one big compromise to be doing something
really fast without needing to expand the data. Good crypto would not
work on narrow blocks and/or include authentication as well ...

> - Eric



Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
