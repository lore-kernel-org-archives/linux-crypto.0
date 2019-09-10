Return-Path: <SRS0=06DT=XF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A521FC3A5A2
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Sep 2019 13:37:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CC64208E4
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Sep 2019 13:37:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="pmBcpXLr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbfIJNhv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Sep 2019 09:37:51 -0400
Received: from mail-eopbgr760051.outbound.protection.outlook.com ([40.107.76.51]:39348
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726613AbfIJNhv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Sep 2019 09:37:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hvaiSqGijkLFK6+BPThPzbizomzPosR8hF9prrwBevOHGc++XaghwrNspbCnORZNvluMC+FjDI9DEUBcySosOv6H3AbOQYLrBIZ5dKqf638W9zHOtDEcf5dNBKuH4xMH85oy+/0yoYBW608T1R0zKOX2eiCy0mteu2/Lq/UBSD4+vvZNTG9WGOAs6z78Yw31tNmec0pus5iKdEAxxKwSTc+5PQQKwIQiheIb16to0zIXIAVL2abEn07Vxs9iW7gby+tx78I06yE40BeNahAUr3AWijifG9S4BPvDd8EuDc+Kd66tqWGXBkmh/6cXwhhOD0qRi5NqweGadqEjfIYj5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9uTWWbxSHD6GC2TfPwr+PMTzWtO0r9dVcOXl0jGw2jk=;
 b=SzGGvmEpXpBCPmlh/62UVjqKDpOp+3B5c5d8ZU1/UpyMxsuFD5JY1RPlEVUc2wbIEUzQ0+gpjlAHFy3JLZRQJ/r1/u3Ma6uksXNZJrdDtbufDidlmB4GojNdPlGi0lLUhVq9HHZ3jB7RU8Of/0ydPSvDhx2LpBzsDjOfuAklhCl5ifu2773xzYN6sP06AiJX/XBMm0nW0z287SiR+b+Wdt+7/3yDGPmmnTFvAYdfV865AxVxnGM41BJAwJySqNILy87ofcL8rZQLi6zgFCDuXAV8vcvOLougnKrCsSLNdkFhwxwy48Ed2ncKvKvviZAGPUffJ2n4uMlztQ5qYhCV6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9uTWWbxSHD6GC2TfPwr+PMTzWtO0r9dVcOXl0jGw2jk=;
 b=pmBcpXLrkPugnLQxK6JbvA6+bsHqbZOacXkymSlA+ogAh6Yhp0GhdqYs7IIFec7MYSpYCQeOiZXNJv2W1hc6TmoHtYmr6CqeFc2bQQxbl1WNBNujScAv0dUeqzxyWz2f1p7OfwfgXkcDz6Q6ffGRzC5MPg6x5Xt87Kweq1KAZU4=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB3168.namprd20.prod.outlook.com (52.132.175.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.13; Tue, 10 Sep 2019 13:37:48 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717%7]) with mapi id 15.20.2241.018; Tue, 10 Sep 2019
 13:37:48 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Subject: RE: Interesting crypto manager behavior
Thread-Topic: Interesting crypto manager behavior
Thread-Index: AdVn1TV8jLDS1UVrTPOD3i+tUTHmBQAAk9AAAAAGV8AAATKuAA==
Date:   Tue, 10 Sep 2019 13:37:48 +0000
Message-ID: <MN2PR20MB2973945A74FA348D22FED248CAB60@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <MN2PR20MB2973C378D06E1694AE061983CAB60@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190910125902.GA5116@gondor.apana.org.au>
 <MN2PR20MB2973764C8F78DE9657DF5B41CAB60@MN2PR20MB2973.namprd20.prod.outlook.com>
In-Reply-To: <MN2PR20MB2973764C8F78DE9657DF5B41CAB60@MN2PR20MB2973.namprd20.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bb91861c-b4a4-4f0f-1449-08d735f411fb
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB3168;
x-ms-traffictypediagnostic: MN2PR20MB3168:
x-ms-exchange-purlcount: 3
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR20MB316837ED6A2BB81CE9A9501FCAB60@MN2PR20MB3168.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01565FED4C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(396003)(39850400004)(136003)(376002)(199004)(189003)(52314003)(13464003)(2906002)(14454004)(229853002)(55016002)(86362001)(76176011)(8936002)(53546011)(8676002)(966005)(6506007)(81156014)(52536014)(102836004)(478600001)(6436002)(81166006)(3846002)(66946007)(66476007)(66556008)(6246003)(64756008)(25786009)(66066001)(66446008)(6116002)(9686003)(5660300002)(76116006)(54906003)(74316002)(110136005)(316002)(4326008)(3480700005)(305945005)(7696005)(11346002)(14444005)(6306002)(99286004)(71200400001)(26005)(53936002)(446003)(186003)(15974865002)(7736002)(33656002)(486006)(256004)(71190400001)(476003)(2940100002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB3168;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: P+KGp6U8XqZOvnGBPscEUUpxK22NTDS68ikr97wzP50LMDxWN8/WzCkx9HKMs+2bYMz+g14UKdzVJ5cqVb8esaZ4UBdS0pYaM7v4dGnJtkvaY6SWKZ2Dp+Oqg3qzI1PMWQQzurN+mLMS6RMyQTJaOZjcSxnJy4KuMBHFKnZRBB4rqbfevqCZ9wDGm2dNZhANMmopOmBQf9WwdUiVYZSUH+TPGOOkCqkXfA1mjqKMqZmmX+fhqjRqVHrh8mEZl/gVODdbi6pazFmjYrc28f2ShjyxB9XQsUJtuW5xXpsxmEAEz/UebMen2wVYBLAjwUl/Mm0J44l2L49r0a7x5GCIi1sRWL/oBc8l987E662BrONCo55mMpLNf06gt72oLFXx24yEcjha4ft3uelOoB80xn3M1Yfch/RYaujRu2zlkGY=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb91861c-b4a4-4f0f-1449-08d735f411fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2019 13:37:48.4565
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gfh2kKYEouiktacdzI7HrA22rTWCuw1QNIpFZKk0BhdeJdFPhDBquKwmxNhsAyzFchTX/rFIhR6kT4kaOsObd7DEFOWhi4J421sJ0IBATOM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB3168
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.=
org> On Behalf
> Of Pascal Van Leeuwen
> Sent: Tuesday, September 10, 2019 3:10 PM
> To: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: linux-crypto@vger.kernel.org; Eric Biggers <ebiggers@kernel.org>
> Subject: RE: Interesting crypto manager behavior
>=20
>=20
>=20
> > -----Original Message-----
> > From: Herbert Xu <herbert@gondor.apana.org.au>
> > Sent: Tuesday, September 10, 2019 2:59 PM
> > To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> > Cc: linux-crypto@vger.kernel.org; Eric Biggers <ebiggers@kernel.org>
> > Subject: Re: Interesting crypto manager behavior
> >
> > On Tue, Sep 10, 2019 at 12:50:04PM +0000, Pascal Van Leeuwen wrote:
> > >
> > > I'm allocating a fallback (AEAD) cipher to handle some corner cases
> > > my HW cannot handle, but I noticed that the fallback itself is being
> > > tested when I allocate it (or so it seems) and if the fallback itself
> > > fails on some testvector, it is not replaced by an alternative while
> > > such an alternative should be available. So I have to fail my entire
> > > init because the fallback could not be allocated.
> >
> > This has nothing to do with fallbacks and it's just how template
> > instantiation works.  If the instantiation fails it will not try
> > to construct another one.  The point is that if your algorithm
> > works then it should not fail the instantiation self-test.  And
> > if it does fail then it's a bug in the algorithm, not the API.
> >
> > > i.e. while requesting a fallback for rfc7539(chacha20, poly1305), it
> > > attempts rfc7539(safexcel-chacha20,poly1305-simd), which fails, but
> > > it could still fall back to e.g. rfc7539(chacha20-simd, poly1305-simd=
),
> > > which should work.
> > >
> > > Actually, I really do not want the fallback to hit another algorithm
> > > of my own driver. Is there some way to prevent that from happening?
> > > (without actually referencing hard cra_driver_name's ...)
> >
> > I think if safexcel-chacha20 causes a failure when used with rfc7539
> > then it should just be fixed, or unexported.
> >
> Actually, the whole situation occurred because I manually added a
> testvector to testmgr.h that even fails with generic, generic :-)
> So no, safexcel-chacha20 does not cause the failure, I was surprised
> by the behavior, expecting it to fallback all the way to generic if
> needed.
>=20
> Anyway, this leads me to a follow-up question:
> I'm trying to implement rfc7539esp(chacha20,poly1305) but I cannot
> make sense of what it *should* do.
> From the generic template code, the only difference from the regular
> rfc7539 I could reverse engineer is that the  first 4 bytes of the IV
> move to the end of the key (as "salt").
> However, when I implemented just that, I got mismatches on the appended
> ICV. And, with rfc7539 working just fine and considering the minimal
> differences which are easy to review, I cannot make sense of it.
>=20
> So I copied the single rfc7539esp testvector to the regular rfc7539
> vector set and modified it accordingly, i.e. I moved the last 4 bytes
> of the key to the start of IV again.
> But if I do that, the vector even fails on rfc7539esp(generic,generic).
>=20
> Upon closer inspection of the vector, I noticed the following:
> It is basically the exact same vector as the last (2nd) regular rfc7539
> vector, with the first 4 bytes of the IV moved to the end of the key
> (OK) BUT also with 8 bytes added to the AAD (which look like it's the IV)=
.
> While the expected ICV is still the same, which is of course impossible
> if you add more AAD data.
>=20
> So really, can someone tell me how this rfc7539esp mode is supposed to
> work? And where this is handled in chacha20_poly1305.c as I cannot find
> where it makes that exception ...
>=20

Ok, never mind. After confirming that, for ESP, the IV is not actually
authenticated at all, and therefore should be somehow skipped, and after
searching through the code for all instances of "assoclen", I finally
came across the following in the poly_genkey function (~last place you
would for such a thing):

	rctx->assoclen =3D req->assoclen;

	if (crypto_aead_ivsize(tfm) =3D=3D 8) {
		if (rctx->assoclen < 8)
			return -EINVAL;
		rctx->assoclen -=3D 8;
	}

So, as it turns out, for an ivsize of 8, which happens to be the
case for rfc7539esp only, we need to skip the last 8 bytes of AAD.
QED

> > Cheers,
> > --
> > Email: Herbert Xu <herbert@gondor.apana.org.au>
> > Home Page: http://gondor.apana.org.au/~herbert/
> > PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
>=20
>=20
Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com



