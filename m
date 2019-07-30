Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCD7FC76186
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 00:30:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3A922070B
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 00:30:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="ezTRb2Sv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728192AbfG3Aaa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Jul 2019 20:30:30 -0400
Received: from mail-eopbgr810088.outbound.protection.outlook.com ([40.107.81.88]:48673
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728099AbfG3Aaa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jul 2019 20:30:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HoBmNheodcmDiYZk1jU44MZytzyXFD5+i1m5lcc+gbF4m42QWrThAAe1tOOhQlfoA2rD4PAU2rpcMcf7PkeQhDzEGUWvRpYXceGcz+P7I/t3Qu7P/lOftJqgYoXgKFgMoMQIZXejihbjdpNSqjwY+oGN3jtaNrG77JgiQzKK8NNu9comSeFUwYebEfiwtQ8aKHEfEEyxhc97tF34sQpQdZf7BES64z3Y6rsWeut6ptH+VYZzWTaDMZEVVCg8r7NrveLaEz099seBGbrpBNDgbnE71p8gXUtGdm2+ZEXcL+m8cVQg/83V+0zzC4+EUCYfGzyn9uRZLRiab5+d01ts/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LxJKZqq/demRtOARqbyZE27BudGCl7eCyFGLMYoacKQ=;
 b=QawyZCWQANqdPGkwDGaerUeqBOJUxkFq33bexeMJ+uwWmxn4JZP2EQ5AD3eqeUdTJNeSACbD8kTuRCxNnmk5+MXyp1BWtne9TdUI7KQH9CYI71wlklSoWNuzcRpngcLmOsAX7Vmcc4diu2i2jjMNxeRF8uiYv3W2EP9ezFKDJS99eAp2cxvKlHcIa41PwB/dawWtdc2ehAyAlGJBjxtbZ/kpjmKXTaR2PPqPKuyEHT0d3bqcG0Vcl8BGJ9lakXPrBwIqPScKkGyrS6uf8lv62NYlP8y1926msQWxt3+sLGUkB9ahR96jFBCSUyOEscHVSv7CLxEsz2SQZOViRXBh0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LxJKZqq/demRtOARqbyZE27BudGCl7eCyFGLMYoacKQ=;
 b=ezTRb2SvQFfesqnP+ljx+GlCNOE8KOK25YhYUrrFuY+0HSj9P0LD9ceVkXpLoO/vmP6Y9yMKcrknpKH4mcgvwgcB46H3BZFcPC21ccPkd9tDTQHm17Tx/czXYxt5v9y2ctzUY03O/AjcN5YuCMQwY5CVYexHpsdfBmFRsFtFMEU=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2416.namprd20.prod.outlook.com (20.179.148.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.13; Tue, 30 Jul 2019 00:30:27 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2115.005; Tue, 30 Jul 2019
 00:30:27 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH] crypto: testmgr - Improve randomization of params for
 AEAD fuzz testing
Thread-Topic: [PATCH] crypto: testmgr - Improve randomization of params for
 AEAD fuzz testing
Thread-Index: AQHVQgvgfaiGsuGw40GmRhVVq3++o6bgUEIAgAD6YHCAAKUVgIAAIDgwgABESoCAAAFE0A==
Date:   Tue, 30 Jul 2019 00:30:27 +0000
Message-ID: <MN2PR20MB29737592FDBB399FC27099E3CADC0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1563960917-8236-1-git-send-email-pvanleeuwen@verimatrix.com>
 <20190728173040.GA699@sol.localdomain>
 <MN2PR20MB29737962BC74CCA790470C0BCADD0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190729181738.GB169027@gmail.com>
 <MN2PR20MB2973C131062F1D1CABA77015CADD0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190730001722.GK169027@gmail.com>
In-Reply-To: <20190730001722.GK169027@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bbe47e6a-9285-48f6-4dde-08d714851ea5
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MN2PR20MB2416;
x-ms-traffictypediagnostic: MN2PR20MB2416:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB2416A500D3A1D06B5C22F991CADC0@MN2PR20MB2416.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0114FF88F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(376002)(39850400004)(396003)(346002)(13464003)(199004)(189003)(6916009)(4326008)(99286004)(229853002)(5660300002)(102836004)(476003)(15974865002)(86362001)(446003)(6436002)(11346002)(71190400001)(76176011)(66446008)(7696005)(25786009)(305945005)(68736007)(54906003)(316002)(186003)(26005)(76116006)(71200400001)(66946007)(74316002)(66476007)(66556008)(64756008)(14454004)(7736002)(478600001)(9686003)(66066001)(81166006)(8676002)(3846002)(6116002)(8936002)(81156014)(53936002)(52536014)(256004)(55016002)(6506007)(53546011)(486006)(6246003)(33656002)(2906002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2416;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 3+2xQKJpJ/N3zwBdXsf2+EEIe0UsgGxfLJFMhdzUy1dB8IWVVqlQG/ht8axjrPBNOkWHnqKkmtSTTxcxMHfqArsRipKYBzyINDY53LH9AjZb9G2gSYQEjksv4aJa5HRmZebuD41zt36p9fOjDEsRbea0WhYkhKN5WHOkje4ugKsRh2gCqhA38YlYIP1hsmXYeF8bifJHzY8WL7NIoLjIEIEl9A7RTIvIAyYEOhOOrYWGPSoblLqNeXFEUQdtGMu4Z3tkao/v8V4HdUTClYgEwAzgOa88nv9du/8D+iPWbxwOPfUACI1htqDjrzlrMXNxNmHszmy9GJm2/+FJjdU0fDKnE+YuHjvdnY2+bNqW0gXmkNZruvH7gWKCYil3Rl5wCP96V5h44yK6My2NTtRFM2KjaCXTafuOABTmqpbz468=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbe47e6a-9285-48f6-4dde-08d714851ea5
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2019 00:30:27.1911
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2416
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Eric Biggers <ebiggers@kernel.org>
> Sent: Tuesday, July 30, 2019 2:17 AM
> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Cc: Pascal van Leeuwen <pascalvanl@gmail.com>; linux-crypto@vger.kernel.o=
rg;
> herbert@gondor.apana.org.au; davem@davemloft.net
> Subject: Re: [PATCH] crypto: testmgr - Improve randomization of params fo=
r AEAD fuzz testing
>=20
> On Mon, Jul 29, 2019 at 10:16:48PM +0000, Pascal Van Leeuwen wrote:
> > > > > Note that the "empty test suite" message shouldn't be printed (es=
pecially not at
> > > > > KERN_ERR level!) if it's working as intended.
> > > > >
> > > > That's not my code, that was already there. I already got these mes=
sages before my
> > > > modifications, for some ciphersuites. Of course if we don't want th=
at, we can make
> > > > it a pr_warn pr_dbg?
> > >
> > > I didn't get these error messages before this patch.  They start show=
ing up
> > > because this patch changes alg_test_null to alg_test_aead for algorit=
hms with no
> > > test vectors.
> > >
> > Ok, I guess I caused it for some additional ciphersuites by forcing the=
m
> > to be at least fuzz tested. But there were some ciphersuites without te=
st
> > vectors already reporting this in my situation because they did not poi=
nt
> > to alg_test_null in the first place.
>=20
> Are you sure?  I don't see anything that had no test vectors but didn't u=
se
> alg_test_null.
>=20
> > So it wasn't entirely clear what the
> > whole intention was in the first place, as it wasn't consistent.
> > If we all agree on the logging level we want for this message, then I c=
an
> > make that change.
>=20
> I suggest at least downgrading it to KERN_INFO, since that's the level us=
ed for
> logging that there wasn't any test description found at all:
>=20
> 	printk(KERN_INFO "alg: No test for %s (%s)\n", alg, driver);
>=20
Ah ... I think I may have confused those 2 error messages that mean pretty
much the same thing to me ... no test ... empty testsuite. If the testsuite
is empty, there is no test. So KERN_INFO appears to be what we want here.

> >
> > > > > Why not put these new fields in the existing 'struct aead_test_su=
ite'?
> > > > >
> > > > > I don't see the point of the separate 'params' struct.  It just c=
onfuses things.
> > > > >
> > > > Mostly because I'm not that familiar with C datastructures (I'm not=
 a programmer
> > > > and this is pretty much my first serious experience with C), so I d=
idn't know how
> > > > to do that / didn't want to break anything else :-)
> > > >
> > > > So if you can provide some example on how to do that ...
> > >
> > > I'm simply suggesting adding the fields of 'struct aead_test_params' =
to
> > > 'struct aead_test_suite'.
> > >
> > My next mail tried to explain why that's not so simple ...
>=20
> The only actual issue is that you can't reuse the __VECS() macro because =
it adds
> an extra level of braces, right?
>=20
Yes, not being able to use __LENS within __VECS would be the main problem.
And I'm not familiar enough with the C preprocessor to solve that myself.

> > Actually, the patch *should* (didn't try yet) make it work for both: if=
 both
> > alen and clen are valid (>=3D0) then it creates a key blob from those r=
anges.
> > If only clen is valid (>=3D0) but a alen is not (i.e., -1), then it wil=
l just
> > generate a random key the "normal" way with length clen.
> > So, for authenc you define both ranges, for other AEAD you define only =
a
> > cipher key length range with the auth key range count at 0.
> >
>=20
> Okay, I guess that makes sense.  It wasn't obvious to me though.
>=20
> - Eric

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
