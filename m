Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5D8FC433FF
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 10:54:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D87C206E0
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 10:54:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="dXmkl+yq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727481AbfG3Ky0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jul 2019 06:54:26 -0400
Received: from mail-eopbgr790050.outbound.protection.outlook.com ([40.107.79.50]:13584
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727445AbfG3Ky0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jul 2019 06:54:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U3HEeA4/w1RYJawfo4yYiOcwMqQmPc3xdA69MVy3YTWZ2uo4vW0QEqxw8jb04Vw8koiMgOodbroUCDBmx+qXWEEdfWVTPjS4qQiLNoojnfxzyjwt3yc63fxVFJHdm+H75UBY+9/ID6NF0GCssq3DQQ0GilG0+F/eblzht+s4g+LkTAPaAFHZqNZ2vtsHvHgNywRubvHiTFP/WKjtCacq1zr+TYtXSt0AqXnkSUinP24neEpufoECifFBHqL+WLjPin05W4clIKCIZ+0gwMWYcO4q7eTxhTLIWyoYU28Pm1OqjRK1lo64hvzT+e1OorKg4hga0juqGHqTSGFjRsTwRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uZDL9LUBuiQ0EuPmsztORqtAWRUv3FSJf0JJgycX7fg=;
 b=P5fTdE1Q9HwpOnwGhQgGYsf5A4U2Ckd/NOSa3GSEihbA0lxxYgagjnBqkoNb052aLDmL/XERnvFZJYokWtmWwA8gOTTFuXuMO6zBgLtONVT5ecvY/87lRXfCnbeeNk3flpa05PbbnPBICzswGAOJHjjy4okQoSr/27nybz6Tbb5nXUOCdpsJgzKYwm/dkd07+7dYZE++DjmcmOLBVxGYArXe409n5Dfez8eTYOg/FkOvFbtTEtzVhtITNTyzaX1XYtaTNMyC7tvtXhct41lQ2ByBpkzpIqpGLweX/gJbOeaIXrpRPVBB3/I3JH9bT0gQ2jnY3Z9kaS3jFAy98tifcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uZDL9LUBuiQ0EuPmsztORqtAWRUv3FSJf0JJgycX7fg=;
 b=dXmkl+yqFkNVmjnGueBlOLbZ9K8GnFS7tSC9t4Iibdd7GWmccFzzTFvCt2moXDDk6KmZ2g+SE2n/nEYpTNC8mcV+PFp3+rvcX3Btxk2zHnU3h31j96e1+nM2hNXTORXB4NtSxn5B54mH9j/wUv/M18bvosaUfq22rO5ELGnUSSA=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB3037.namprd20.prod.outlook.com (52.132.173.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Tue, 30 Jul 2019 10:54:22 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2115.005; Tue, 30 Jul 2019
 10:54:22 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
CC:     Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH 2/3] crypto: inside-secure - added support for
 rfc3686(ctr(aes))
Thread-Topic: [PATCH 2/3] crypto: inside-secure - added support for
 rfc3686(ctr(aes))
Thread-Index: AQHVMwaydQ+3aJIWekiqcp1KNvSggKbc9n6AgAAHURCAAA0+AIAAB9iQgAXnVACAACKbsA==
Date:   Tue, 30 Jul 2019 10:54:22 +0000
Message-ID: <MN2PR20MB2973EAE2824203360014C0FFCADC0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1562309364-942-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1562309364-942-3-git-send-email-pvanleeuwen@verimatrix.com>
 <20190726123305.GD3235@kwain>
 <MN2PR20MB2973C6D05EED9B878D2EC4B9CAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190726134640.GD5031@kwain>
 <MN2PR20MB2973EB161252E245878473B1CAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190730082400.GD3108@kwain>
In-Reply-To: <20190730082400.GD3108@kwain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a90c904a-2505-48af-1cb9-08d714dc47d6
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB3037;
x-ms-traffictypediagnostic: MN2PR20MB3037:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <MN2PR20MB30376EAB2FA070A3242B7EC8CADC0@MN2PR20MB3037.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0114FF88F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39850400004)(346002)(396003)(376002)(136003)(13464003)(189003)(199004)(64756008)(476003)(446003)(9686003)(6306002)(6116002)(6436002)(66476007)(66556008)(26005)(55016002)(8936002)(66446008)(66946007)(3846002)(8676002)(4326008)(6506007)(5660300002)(81156014)(478600001)(6246003)(229853002)(966005)(53546011)(86362001)(76116006)(68736007)(186003)(11346002)(66066001)(305945005)(486006)(33656002)(316002)(76176011)(6916009)(81166006)(25786009)(66574012)(99286004)(74316002)(15974865002)(52536014)(53936002)(71200400001)(71190400001)(2906002)(14444005)(54906003)(7736002)(7696005)(256004)(14454004)(102836004)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB3037;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: poRyALQISh5oKLIefSYJxpAEk8enOPtZr+4ErytIvrrRJLeLHCoIKco/zWVe86yTZOOhBCFJXOBB06/TDqfpY7VwnzHcUMJ0FgRA/eBINDPoondfvJ5vUAV2kqSBmgrKAESJb7JZXerefGZVeDcm95phdu7QCefLQbomuefPqCU6Iq7Wx63fIzibRxMcZuF9RfIdwkn1hRu7X4hlwrOAAijqyex79q94RD8Em7obSRp3iLJ2mFEdMUXLthB9Cnh+PHuB3o5RadyYkUYRgWKsH/aKEIWwvw2wDuimyvDcU3xk5QRCL5E+vqO3gIWAQNB556ORHIbf/yNVlUujP41iV9xYpSkYy7+PUd4H/QvutPoEZ8CJmDloLIz4cLb0v0kFLANG7s293zx4Hs4+4Rp6PoDiRYhrZZi/Ywdb3JcJlgA=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a90c904a-2505-48af-1cb9-08d714dc47d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2019 10:54:22.4790
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB3037
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Antoine Tenart <antoine.tenart@bootlin.com>
> Sent: Tuesday, July 30, 2019 10:24 AM
> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Cc: Antoine Tenart <antoine.tenart@bootlin.com>; Pascal van Leeuwen
> <pascalvanl@gmail.com>; linux-crypto@vger.kernel.org; herbert@gondor.apan=
a.org.au;
> davem@davemloft.net
> Subject: Re: [PATCH 2/3] crypto: inside-secure - added support for rfc368=
6(ctr(aes))
>=20
> On Fri, Jul 26, 2019 at 02:29:48PM +0000, Pascal Van Leeuwen wrote:
> > > From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.ker=
nel.org> On
> Behalf Of Antoine Tenart
> > > On Fri, Jul 26, 2019 at 01:28:13PM +0000, Pascal Van Leeuwen wrote:
> > > > > On Fri, Jul 05, 2019 at 08:49:23AM +0200, Pascal van Leeuwen wrot=
e:
> > > >
> > > > > > @@ -62,9 +63,9 @@ static void safexcel_skcipher_token(struct sa=
fexcel_cipher_ctx
> *ctx, u8 *iv,
> > > > > >  				    u32 length)
> > > > > > -	if (ctx->mode =3D=3D CONTEXT_CONTROL_CRYPTO_MODE_CBC) {
> > > > > > +	if (ctx->mode !=3D CONTEXT_CONTROL_CRYPTO_MODE_ECB) {
> > > > >
> > > > > I think it's better for maintenance and readability to have somet=
hing
> > > > > like:
> > > > >
> > > > >   if (ctx->mode =3D=3D CONTEXT_CONTROL_CRYPTO_MODE_CBC ||
> > > > >       ctx->mode =3D=3D CONTEXT_CONTROL_CRYPTO_MODE_CTR_LOAD)
> > > > >
> > > > Not really. I *really* want to execute that for any mode other than=
 ECB,
> > > > ECB being the *only* mode that does not require an IV (which I know
> > > > for a fact, being the architect and all :-).
> > > > And I don't believe a long list of modes that *do* require an IV wo=
uld
> > > > be  more readable or easy to maintain than this single compare ...
> > >
> > > That's where I disagree as you need extra knowledge to be aware of th=
is.
> > > Being explicit removes any possible question one may ask. But that's =
a
> > > small point really :)
> > >
> > Well, while we're disagreeing ... I disagree with your assertion that y=
ou
> > would need more knowledge to know which modes do NOT need an IV
> > than to know which modes DO need an IV. There's really no fundamental
> > difference, it's two sides of the exact same coin ... you need that
> > knowledge either way.
>=20
> The point is if you look for occurrences of, let's say
> CONTEXT_CONTROL_CRYPTO_MODE_CBC, to see the code path it'll be way
> easier if you have direct comparisons.
>=20
Not a good enough reason considering the downsides of having less
performant code that is more difficult to maintain, IMHO (you will
have to keep adding modes as we have plenty more and may add even
more to the hardware later - and make sure the list is and stays
complete going forward).=20
So how often do you really need to do that search?
Speaking as someone who has been adding new modes fairly recently
but never had any need for that ...

> > 1) This code is executed for each individual cipher call, i.e. it's in =
the
> > critical path. Having just 1 compare-and-branch there is better for
> > performance than having many.
>=20
> Not sure about what the impact really is.
>=20
Well, the driver is not exactly extracting maximum performance from=20
our engine for small blocks at the moment, so I would say any cycle=20
gained matters. Software overhead is the Achilles heel of hardware
acceleration. And if you don't accelerate, your hardware is defacto
useless. So anything in the critical path should be carefully
considered. (which is also why I object so strongly to all these API
corner cases we're forced to support, but now I digress ...)

You can debate about significance, but at some point it all adds up.
Better to not add the cycles - if it's no effort at all! - then to
have to optimize them away later. Speaking as someone who has spent
a major part of his professional life squeezing out those cycles to
meet very real and hard performance requirements.

> > 2) Generally, all else being equal, having less code is easier to maint=
ain
> > than having more code.
>=20
> That really depends, having readable code is easier to maintain :)
>=20
But how would it be more readable? "Do this for any mode other than
ECB" seems pretty clear and readable to me? And is exactly what should
happen here. Also, less code of the same complexity level (i.e. the
same simple compares!) is still more readable than more code.

> > 4) If there is anything unclear about an otherwise fine code construct,
> > then you clarify it by adding a comment, not by rewriting it to be inef=
ficient
> > and redundant ;-)
>=20
> Fair point.
>=20
> Thanks,
> Antoine
>=20
> --
> Antoine T=E9nart, Bootlin
> Embedded Linux and Kernel engineering
> https://bootlin.com


Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
