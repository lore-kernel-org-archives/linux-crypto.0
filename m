Return-Path: <SRS0=kkEj=VC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAD1CC46499
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jul 2019 19:49:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 872C5216E3
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jul 2019 19:49:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="lOAuswfm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725894AbfGETtc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Jul 2019 15:49:32 -0400
Received: from mail-eopbgr680089.outbound.protection.outlook.com ([40.107.68.89]:12768
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725813AbfGETtc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jul 2019 15:49:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9AqeA+meJaBHKnp1vtz7Z336atKn7MiQM2wQpnD6axI=;
 b=lOAuswfmIDUEBwEciuxrX2sVrn9bUmzFvl+XXRPhUiS3hICl6KoWUc0+JTW0XmcpM2z9KQae3mH3/kxDzjWyrqGQH3L83VgFUrRcKhAA+P56HvHqhek/+9bZGcDh8kIEJyucYr3zKPtgB8FdhXbzcftlAXy7bDvczX0G6dlEgyc=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2591.namprd20.prod.outlook.com (20.178.250.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.18; Fri, 5 Jul 2019 19:49:28 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69%6]) with mapi id 15.20.2052.019; Fri, 5 Jul 2019
 19:49:28 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: RE: testmgr fuzzing for AEAD ciphers
Thread-Topic: testmgr fuzzing for AEAD ciphers
Thread-Index: AdUyQjTY1c0oiQ20QKyM6t3OYyJc2gBJrKaAAAAaivA=
Date:   Fri, 5 Jul 2019 19:49:28 +0000
Message-ID: <MN2PR20MB29736D25D575BDC335D8A026CAF50@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <MN2PR20MB297300C9DA57540354107BEBCAFA0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190705193613.GA4022@sol.localdomain>
In-Reply-To: <20190705193613.GA4022@sol.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 42134c41-6e28-4517-b278-08d70181e437
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2591;
x-ms-traffictypediagnostic: MN2PR20MB2591:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB2591E4F2EBCDD9549F7E2A73CAF50@MN2PR20MB2591.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 008960E8EC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39850400004)(376002)(346002)(366004)(396003)(199004)(189003)(11346002)(256004)(53936002)(86362001)(55016002)(74316002)(6246003)(5660300002)(446003)(305945005)(52536014)(9686003)(7736002)(66476007)(76116006)(66946007)(73956011)(6116002)(64756008)(6436002)(6916009)(66556008)(3846002)(68736007)(486006)(66446008)(229853002)(476003)(54906003)(4326008)(316002)(66066001)(81166006)(81156014)(71190400001)(99286004)(15974865002)(8936002)(8676002)(71200400001)(33656002)(7696005)(102836004)(186003)(6506007)(14454004)(76176011)(2906002)(478600001)(25786009)(26005)(21314003)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2591;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: kdKv+CsRBJu0H5Gpm4YIXOfbG26nMRd0IT7+tyLuzA+YMWBJt1RYoWlOBjAWe+zE7IFoFG87DBYQD7QeS98LKR/DzMQutwuWyBmFRN8Pgdqo/yG/uNIwG6hWfZUKQif7pEorFd9AnmVn/5eqvlEl3ojgMqM8fefrU27qXmzzRqYMRsSSsN2b4G0WNxO8RGkjhX6hgEWN6ztTNjhzifjJ/LOEV2t23ala8+FviJ+JyFZ6cMcWzDz1aR1d2GNmkrgj9P2CMloFbTucr0Y+l/HJGoUkAiRqbMQuuvSSokoKDmh7PsPvN2wBZ1YywOnkIR0j8aT+kq0vao5BuoUDl83iq4XTyoKTzXnE2WTt7Kxhv5/HZpOL51BKiz7vRg/QBFoyh0Mj2S0pmfHbc2GdaCEjGfW3XV//ytm4CoGgcsCVDIM=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42134c41-6e28-4517-b278-08d70181e437
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2019 19:49:28.5420
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2591
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

>=20
> Hi Pascal,
>=20
> On Thu, Jul 04, 2019 at 08:37:11AM +0000, Pascal Van Leeuwen wrote:
> > Hi,
> >
> > I was attempting to get some fuzzing going for the RFC3686 AEAD ciphers=
 I'm adding to the
> > inside-secure driver, and I noticed some more things besides what I men=
tioned below:
> >
> > 1) If there is no test suite, but the entry does point to something oth=
er then alg_test_null,
> > then fuzzing is still not performed if there is no test suite, as all o=
f the alg_test_xxx routines
> > first check for suite->count being > 0 and exit due to count being 0 in=
 this case.
> > I would think that if there are no reference vectors, then fuzzing agai=
nst the generic
> > implementation (if enabled) is the very least you can do?
> >
> > 2) The AEAD fuzzing routine attempts to determine the maximum key size =
by actually
> > scanning the test suite. So if there is no test suite, this will remain=
 at zero and the AEAD
> > fuzzing routine will still exit without performing any tests because of=
 this.
> > Isn't there a better way to determine the maximum key size for AEAD cip=
hers?
> >
> > 3) The AEAD fuzzing vector generation generates fully random keydata th=
at is <=3D maxlen.
> > However, for AEAD ciphers, the key blob is actually some RTA struct con=
taining length
> > fields and types. Which means that most of the time, it will simply be =
generating illegal
> > key blobs and you are merely testing whether both implementations corre=
ctly flag the
> > key as illegal. (for which they likely use the same crypto_authenc_extr=
actkeys
> > subroutine, so that check probably/likely always passes - and therefore=
 is not very useful)
> >
>=20
> Yes, these are real issues; we need to make the testing code smarter and =
perhaps
> add some more test vectors too.  But just to clarify (since you keep usin=
g the
> more general phrase "AEAD ciphers"), these issues actually only apply to =
RFC3686
> ciphers, a.k.a. algorithms with "authenc" in their name, not to other AEA=
Ds in
> the crypto API such as GCM, ChaCha20-Poly1305, and AEGIS128.
>=20
Ok, since I was just working on authenc ciphersuites I assumed that the "ot=
her"
(real) AEAD's would work the same way, good to know that's not the case.
AES-GCM and AES-CCM are next on my list (after my holiday though) ...

> There's no way to easily determine the max key size of an arbitrary AEAD
> currently, since it's not stored in struct aead_alg.  That's why the curr=
ent
> code is scanning the test vectors.  Instead, we probably should store
> information about the supported key sizes and formats directly in struct
> alg_test_desc, independent of the test vectors themselves.  That would ma=
ke it
> possible to solve all three issues you've identified.
>=20
> - Eric
>
Yes, that should work I guess. That would also allow it to be an actual *li=
st* of=20
correct values instead of assuming a range between 0 and max, where only a
few values are truly valid, which is wasting a lot of testvectors. This wou=
ld
apply to skciphers as well.

Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

