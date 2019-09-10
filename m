Return-Path: <SRS0=06DT=XF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CB88C3A5A2
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Sep 2019 13:10:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FBA5208E4
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Sep 2019 13:10:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="fbdbozn3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729312AbfIJNKQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Sep 2019 09:10:16 -0400
Received: from mail-eopbgr770040.outbound.protection.outlook.com ([40.107.77.40]:7045
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726008AbfIJNKQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Sep 2019 09:10:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C0tsm3boBfPtE4yCp/AaNKTt5PtO2J2vPHkhIwKnji9ePI6DLk/MemAQoLZ8H6n23qom20d+eVAZ6bgcIYoiJvy4yZQNROz4NwVxcJ1L6NdpVmcnQZ4209UNITRqnu1HQXJvf8vDTSDvPT/FxnDsDgLQuXqNYavVx+388wtYxiSZewi0DDMsKeCfH99woupMY7995U6s2sYmnqVdWLOM3SBZbiuqkQI3At4Ybgc0oNxcZaNZBPqi3CKHVsWOtMkl/4425vJHW2zLgrkCemTltWm5QCkmwsHhTHh29IK5TCIduiOAf9Uh82gUxwImhwogINghz9LyKK3K7Jf6QvGLFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H6xqIY0GN6mV+s/qkxCJwU/D7k+/SKnAFgeR5xpyF+c=;
 b=YCUEVvyionzkF62UdWkbOea6jygiY+6Jx4sgUE2akwoyinwE19stO6R27sQiHJL4t0cd5MOhQOyUslYyFvOiUCWzDwQvqyTLlFPJDj6jcbisYbn3qPebJ5rXg7m1za/1zj9RIlnl+1jowjsyzgE8jcN3ivNVsqrp9J0vZSJK+th56xjz/WnwfXDQBspEIOZF6udu4ByZiG/zM+qFBNfCFoZ2v+Np/QXywfQHCnjifa7zLOM4/5w8aYR1AxBMfNXkOgvetwqr+u15jkHotNCuQSGnUnAICT1PBc4dPf2MCST99SAk7ISZupC2XHCWFaOJvcGP433ccFJJnh+h8vzBUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H6xqIY0GN6mV+s/qkxCJwU/D7k+/SKnAFgeR5xpyF+c=;
 b=fbdbozn3cLII08BSAOZxCtWytkJBMTxwwvTvBSajON2q+PHMVvjLX6JYFPp5Cc3YB7Do+Vt3e1/1jGjBuHAUkCH+X6Wru+pnJw8otKNjQwmB/ktFoDAJIV98aakbbvWU/clFjOPPq5FqzARYvsZhDZbNLDw2+1M/Epgwg5kRlnk=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2654.namprd20.prod.outlook.com (20.178.252.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.15; Tue, 10 Sep 2019 13:10:13 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717%7]) with mapi id 15.20.2241.018; Tue, 10 Sep 2019
 13:10:13 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Subject: RE: Interesting crypto manager behavior
Thread-Topic: Interesting crypto manager behavior
Thread-Index: AdVn1TV8jLDS1UVrTPOD3i+tUTHmBQAAk9AAAAAGV8A=
Date:   Tue, 10 Sep 2019 13:10:13 +0000
Message-ID: <MN2PR20MB2973764C8F78DE9657DF5B41CAB60@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <MN2PR20MB2973C378D06E1694AE061983CAB60@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190910125902.GA5116@gondor.apana.org.au>
In-Reply-To: <20190910125902.GA5116@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 828b88b8-5e99-4f69-75c6-08d735f0376e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2654;
x-ms-traffictypediagnostic: MN2PR20MB2654:
x-ms-exchange-purlcount: 3
x-microsoft-antispam-prvs: <MN2PR20MB26549454BF5C7AE98F530CA5CAB60@MN2PR20MB2654.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01565FED4C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39850400004)(376002)(396003)(346002)(366004)(52314003)(199004)(189003)(13464003)(11346002)(6116002)(66446008)(102836004)(66946007)(6306002)(66556008)(66476007)(64756008)(5660300002)(76176011)(6916009)(256004)(14444005)(26005)(99286004)(478600001)(186003)(6436002)(4326008)(229853002)(54906003)(81166006)(81156014)(86362001)(8936002)(316002)(53936002)(8676002)(66066001)(6246003)(966005)(74316002)(7736002)(55016002)(6506007)(53546011)(15974865002)(3846002)(9686003)(25786009)(476003)(7696005)(52536014)(2906002)(14454004)(486006)(76116006)(71190400001)(71200400001)(305945005)(3480700005)(33656002)(446003)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2654;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: r8p5CJtUpjsnE7VTAkDAvzFgXL5STFOYdEM2P352wXtsKpvC/1Aoc4ezsDnFfqvq5H0rLt/H+X0Y27RU9OO8SbyZRVt9Ch7QGSY29Il1p3LNO4RvEVEsLcCJrL7FnUcGCcAsUB7/g2QC8tRCJoFtEXPZa9sqSySraDkAHKAPaNLIL98Q2l3AOql2u6Vhf0WSukTkTcz+K6fy8xHAx6lk00bR5CO9HwFaJfkbnvpYAk1/lt8SwxFLluCDHWnTP2AwSGbqMhc+1wxSlsEzbtSfFMLeOVDz8swIgQWSXXKCwtKxEhKXf8mRrSAgteLJrZqaomwvQf5lHnQch3Qrb0TZUjIde9MGKEVm0ib0t0xk5EcIfyyrqx+J+lykwt5DO4g16Wj6C8vlRZkdoTXhQGNl9KF1LamAsG6iNWtICOljkrc=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 828b88b8-5e99-4f69-75c6-08d735f0376e
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2019 13:10:13.3364
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CjdlcGjsDzEa+vZCftk/TVru+d57IpBTfThC6xioJKiLGD25UTvQ8mHTLSS8aECy3up3sW8W9Ci813iL7v5m5GJJ9qaok1F1dTD15N9ujKk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2654
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Tuesday, September 10, 2019 2:59 PM
> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Cc: linux-crypto@vger.kernel.org; Eric Biggers <ebiggers@kernel.org>
> Subject: Re: Interesting crypto manager behavior
>=20
> On Tue, Sep 10, 2019 at 12:50:04PM +0000, Pascal Van Leeuwen wrote:
> >
> > I'm allocating a fallback (AEAD) cipher to handle some corner cases
> > my HW cannot handle, but I noticed that the fallback itself is being
> > tested when I allocate it (or so it seems) and if the fallback itself
> > fails on some testvector, it is not replaced by an alternative while
> > such an alternative should be available. So I have to fail my entire
> > init because the fallback could not be allocated.
>=20
> This has nothing to do with fallbacks and it's just how template
> instantiation works.  If the instantiation fails it will not try
> to construct another one.  The point is that if your algorithm
> works then it should not fail the instantiation self-test.  And
> if it does fail then it's a bug in the algorithm, not the API.
>=20
> > i.e. while requesting a fallback for rfc7539(chacha20, poly1305), it
> > attempts rfc7539(safexcel-chacha20,poly1305-simd), which fails, but
> > it could still fall back to e.g. rfc7539(chacha20-simd, poly1305-simd),
> > which should work.
> >
> > Actually, I really do not want the fallback to hit another algorithm
> > of my own driver. Is there some way to prevent that from happening?
> > (without actually referencing hard cra_driver_name's ...)
>=20
> I think if safexcel-chacha20 causes a failure when used with rfc7539
> then it should just be fixed, or unexported.
>=20
Actually, the whole situation occurred because I manually added a
testvector to testmgr.h that even fails with generic, generic :-)
So no, safexcel-chacha20 does not cause the failure, I was surprised
by the behavior, expecting it to fallback all the way to generic if
needed.

Anyway, this leads me to a follow-up question:
I'm trying to implement rfc7539esp(chacha20,poly1305) but I cannot=20
make sense of what it *should* do.
From the generic template code, the only difference from the regular
rfc7539 I could reverse engineer is that the  first 4 bytes of the IV
move to the end of the key (as "salt").
However, when I implemented just that, I got mismatches on the appended=20
ICV. And, with rfc7539 working just fine and considering the minimal
differences which are easy to review, I cannot make sense of it.

So I copied the single rfc7539esp testvector to the regular rfc7539
vector set and modified it accordingly, i.e. I moved the last 4 bytes
of the key to the start of IV again.=20
But if I do that, the vector even fails on rfc7539esp(generic,generic).

Upon closer inspection of the vector, I noticed the following:
It is basically the exact same vector as the last (2nd) regular rfc7539
vector, with the first 4 bytes of the IV moved to the end of the key
(OK) BUT also with 8 bytes added to the AAD (which look like it's the IV).
While the expected ICV is still the same, which is of course impossible
if you add more AAD data.

So really, can someone tell me how this rfc7539esp mode is supposed to
work? And where this is handled in chacha20_poly1305.c as I cannot find
where it makes that exception ...

> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt


Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
