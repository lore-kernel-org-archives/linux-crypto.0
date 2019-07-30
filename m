Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13571C0650F
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 10:24:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE5042089E
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 10:24:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="V5Di11Bx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729275AbfG3KYG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jul 2019 06:24:06 -0400
Received: from mail-eopbgr770085.outbound.protection.outlook.com ([40.107.77.85]:15014
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727156AbfG3KYG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jul 2019 06:24:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lSHea/cGWW9o/Wh0pyHkUemKmHYLuqw14zkLK5Oy06XgZgSN9hewISqu8FNcMzJwzjmQMmElSjSPEOZwt52Sri30N+6ZBU/MYTWfoNj/cPyGaRJB++2ylD1Gxyp7c7aJMNq5GC0WaiGm2kAAKMqKW1jGZ8bcteXb/icus3ueVaeigV4fQxtZoWAcSS6nZB9XLD2KukzvrKJJHp4c0HwcTzEkILGYKmBvJjcsQOcCYBhVJIYoj/MUBDbSSWg24c8c7o2PDKXjBrj+cQqFa0LJpykTU68+skzFWhgepFYOIU+4iUIDIYB3tnpTd3X1cs/JGr9EwQOSDj4Dn8Epx7XAcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JN5YltsZF1TimDCe8vE8yNlsfj8Q+9ynkBLPIPDiUIo=;
 b=bRJ/8E3/bFobUqxpyYSI+Si5K+p0DpDjjtIsQF+ymVG9aK1zooj1KRU1KgbICiFV1pLKZcTlVWnTG1j0LW4EqUkp/s4sef9a04u8MkXdB1shlb6JxFn66IGS4FqE36wZei35g9wK0uycCOxykpad+9IsG/p+dHNGqTkxjxMSVGKlOKtRyoCgl/xwwD/K/ZDyzi8jbXiD+5Fz0roLO+LpBz8KIgPsjcize2EbbYgkqcGNLkKcBb4ArEi4f5OsYyWDMEE7lm1CFBUyXJ/U/kuLmAznhDhdGe+aK0Z4do4Dy9SHLjN75ZavDHZnCwfVNgrLZu1cSTf+tKF4hW3mGp5EOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JN5YltsZF1TimDCe8vE8yNlsfj8Q+9ynkBLPIPDiUIo=;
 b=V5Di11BxZ2tTDlNHKZq5xnoMkdDH4ZNHAiH+bA+Xyg+BdgfOt9y0LO4z6zY7mUv7T/Z8HwKwfNJhfX6gR4Mz0uZjatZH9pH+EK518223a3gSgf8aqlyHgaQ/Lya0+4biXgirKYrjy4fLFGYyLWqejgd/VCl+1/nJjpSIQMtrcp4=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB3088.namprd20.prod.outlook.com (52.132.174.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Tue, 30 Jul 2019 10:24:02 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2115.005; Tue, 30 Jul 2019
 10:24:02 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH] crypto: testmgr - Improve randomization of params for
 AEAD fuzz testing
Thread-Topic: [PATCH] crypto: testmgr - Improve randomization of params for
 AEAD fuzz testing
Thread-Index: AQHVQgvgfaiGsuGw40GmRhVVq3++o6bgUEIAgAD6YHCAAKUVgIAAIDgwgAAmnwCAAAIuUIAAFLOAgAAK/ICAAAZ4gIAABRaQgAA114CAAGN+oA==
Date:   Tue, 30 Jul 2019 10:24:01 +0000
Message-ID: <MN2PR20MB2973F8520EF22582201F3539CADC0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <20190728173040.GA699@sol.localdomain>
 <MN2PR20MB29737962BC74CCA790470C0BCADD0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190729181738.GB169027@gmail.com>
 <MN2PR20MB2973C131062F1D1CABA77015CADD0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190729223112.GA7529@gondor.apana.org.au>
 <MN2PR20MB29736A0F55875B91587142D9CADD0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190729235304.GJ169027@gmail.com>
 <MN2PR20MB2973302B66749E5E6EC4F444CADC0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190730005532.GL169027@gmail.com>
 <MN2PR20MB297328E526D41CE90707DAFACADC0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190730042627.GC1966@sol.localdomain>
In-Reply-To: <20190730042627.GC1966@sol.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 752d4445-cbc5-450c-7c6d-08d714d80ab7
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB3088;
x-ms-traffictypediagnostic: MN2PR20MB3088:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB3088B630CD50402C20FB77F0CADC0@MN2PR20MB3088.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0114FF88F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(396003)(136003)(39850400004)(366004)(376002)(346002)(13464003)(52314003)(189003)(199004)(55016002)(53936002)(446003)(76116006)(71200400001)(52536014)(66066001)(53546011)(478600001)(6436002)(6506007)(64756008)(66556008)(11346002)(7736002)(229853002)(2906002)(14454004)(74316002)(26005)(66476007)(66946007)(66446008)(102836004)(3846002)(54906003)(316002)(25786009)(81166006)(5660300002)(476003)(14444005)(9686003)(6916009)(6116002)(86362001)(99286004)(256004)(68736007)(8676002)(76176011)(486006)(8936002)(81156014)(305945005)(6246003)(71190400001)(15974865002)(4326008)(33656002)(7696005)(186003)(18886075002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB3088;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: MNWv3lQAXS9KiCf7BBMM21SEtl1YhBIWVr/LUJTjl0oNakMcC8IgIcR4Av7oxDrwtizuZa4A5nJc1S0nGKA3Ysn1mgoG1bdmrctRagNh9h0rv1rJ6pgv+LLMGIHd6j7o0Usrc4UZ0o2NWSOICj2vZtYl0Vgw2BNsg269PaIJuc6mqjr8KmRmcc0mGdVrNKXv5z+rt3BSJRCKNj2qSjsEB/VF4OgfU/xCH7/joP+8CUtAOU+b8EmAhs/hP/TjP9HADVcCq4/Pj9pe1/LKORBgxZv2H0aE4RmSkEvMrTbPsZJdN6nFQPcwLjiCqA7O68EFYMW/xE/3VSSZjW1lRyY6UjT3XGz2kYsbtADpiVhTf/8Tp5+LmKAxZvqMyxJCF55ZXN2aUKO7wltwLFP0EFlcOvCE36T9HByCa0oByiNTVx4=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 752d4445-cbc5-450c-7c6d-08d714d80ab7
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2019 10:24:01.9864
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB3088
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Eric Biggers <ebiggers@kernel.org>
> Sent: Tuesday, July 30, 2019 6:26 AM
> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>; Pascal van Leeuwen <pascalv=
anl@gmail.com>;
> linux-crypto@vger.kernel.org; davem@davemloft.net
> Subject: Re: [PATCH] crypto: testmgr - Improve randomization of params fo=
r AEAD fuzz
> testing
>=20
> On Tue, Jul 30, 2019 at 01:26:17AM +0000, Pascal Van Leeuwen wrote:
> > > > > Oh, I see.  Currently the fuzz tests assume that if encryption fa=
ils with an
> > > > > error (such as EINVAL), then decryption fails with that same erro=
r.
> > > > >
> > > > Ah ok, oops. It should really log the error that was returned by th=
e
> > > > generic decryption instead. Which should just be a matter of annota=
ting
> > > > it back to vec.crypt_error?
> > > >
> > >
> > > It doesn't do the generic decryption yet though, only the generic enc=
ryption.
> > >
> > I didn't look at the code in enough detail to pick that up, I was expec=
ting
> > it do do generic decryption and compare that to decryption with the alg=
orithm
> > being fuzzed. So what does it do then? Compare to the original input to=
 the
> > encryption? Ok, I guess that would save a generic decryption pass but, =
as we
> > see here, it would not be able to capture all the details of the API.
>=20
> Currently to generate an AEAD test vector the code just generates a "rand=
om"
> plaintext and encrypts it with the generic implementation.
>=20
> My plan is to extend the tests to also sometimes generate a "random" ciph=
ertext
> and try to decrypt it; and also sometimes try to decrypt a corrupted ciph=
ertext.
>=20
My guess is trying that first part will give you the second part for=20
free :-) (i.e. if it's random, it almost certainly won't authenticate)

> >
> > > > > Regardless of what we think the correct decryption error is, runn=
ing the
> > > > > decryption test at all in this case is sort of broken, since the =
ciphertext
> > > > > buffer was never initialized.
> > > > >
> > > > You could consider it broken or just some convenient way of getting
> > > > vectors that don't authenticate without needing to spend any effort=
 ...
> > > >
> > >
> > > It's not okay for it to be potentially using uninitialized memory tho=
ugh, even
> > > if just in the fuzz tests.
> > >
> > Well, in this particular case things should fail before you even hit th=
e
> > actual processing, so memory contents should be irrelevant really.
> > (by that same reasoning you would not actually hit vectors that don't
> > authenticate, by the way, there was an error in my thinking there)
>=20
> But the problem is that that's not what's actually happening, right?  "au=
thenc"
> actually does the authentication (of uninitialized memory, in this case) =
before
> it gets around to failing due to the cbc length restriction.
>=20
> Anyway, I suggest sending the patch I suggested as 1 of 2 to avoid this c=
ase (so
> your patch does not cause test failures), then this patch as 2 of 2.
>=20
Ok, fine

> - Eric


Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
