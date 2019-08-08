Return-Path: <SRS0=IdBJ=WE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 474F4C0650F
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Aug 2019 13:23:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 059282171F
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Aug 2019 13:23:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="u5hoaj9E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732989AbfHHNXO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 8 Aug 2019 09:23:14 -0400
Received: from mail-eopbgr770085.outbound.protection.outlook.com ([40.107.77.85]:7040
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728327AbfHHNXO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Aug 2019 09:23:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XQTOKRGCGPAV+ec3uD/bYFfwSxhHEQ76xp17oyMrAbzKECbN4V5jqP8rK2sNhOAMl+63giNPLzHRZz8Ss0jcGOlB12O6DlKxCV/D7tMoiMi9T1QeYITIJYJmzmyGEIDwvrC4YpL/i9st+DgekMYR+TVWbVaYcJhjwB8wAsCNO0nlzPZKUzsnwlP5AQFDqXSTKeJKKH3OvqrPT2Z2c4YJ8lYtEfBsxq533TgjjBbyS8I/F5qKH5gXTfe79FOVHIq0eCZQnvzOY6JQFkhlHkX1Rb5VyNHEUPfMeJzHI9MVdn7b06BYRj9lQcY8AkpMs5r/LjfUkxHXYFSAPc1p5Mez0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x/zwfQlF5TH9im06q8giWrXMgTdumSs8LA47tg4Mvl8=;
 b=aSsD2gEIqMZRnTK7jhzirVhPNyEhIbuNz86rYByTEbL0LBsY0OZ0oHBPq2syQLnHwd/3ymYzjBRY2dKgdvPZC/Z69YEj+mVkUcbxvkpTa5JH4kIErGOW25eFIGQX2hrQx1JLvHi7HC8oGpV0yIkMNMooMz2OP8fxG9XPOej3i1k98ZhPMoILiuSHEdm1wPj2Q07mKXJ0ivZWcGcjdB6Z1ZA45T3A/iAnXY5REQJ4AMMRVFSn8LYFK7JUdfIAKPj1nQ8YSsZ8BTkCEdG9RKyeBUX3PU0+Bihqd3ary43CBb81pabzDi2sybTZ8bn4juqgEepzVs+pBagOQ+NLQOJgBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x/zwfQlF5TH9im06q8giWrXMgTdumSs8LA47tg4Mvl8=;
 b=u5hoaj9Eai6eFkER8JQeUgnEe9EIdDLN4iwLeAra/qhOzAG+uvg/WkwnbTysnKq5GsJxJ5iqM0mO3ccgQHDKFNeHB/8Lyb+xzWF2QRLkH/Ahaew529UhJq0VZQNKAtYeXZatUpSLAwjtDw2el+1CEeW+cVOf2fGFURR2rU3n7z0=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2895.namprd20.prod.outlook.com (20.179.148.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.14; Thu, 8 Aug 2019 13:23:10 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2157.015; Thu, 8 Aug 2019
 13:23:10 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Milan Broz <gmazyland@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>
CC:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "agk@redhat.com" <agk@redhat.com>,
        "snitzer@redhat.com" <snitzer@redhat.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: RE: [RFC PATCH v2] md/dm-crypt - reuse eboiv skcipher for IV
 generation
Thread-Topic: [RFC PATCH v2] md/dm-crypt - reuse eboiv skcipher for IV
 generation
Thread-Index: AQHVTOQKWnTPkdATo0i/D1XZtRSIkqbvRQ3wgABmBgCAAAHhUIAAJeoAgAAASmCAARpFgIAAAIWQgABIkICAAAcZkA==
Date:   Thu, 8 Aug 2019 13:23:10 +0000
Message-ID: <MN2PR20MB29739B9D16130F5C06831C92CAD70@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <20190807055022.15551-1-ard.biesheuvel@linaro.org>
 <MN2PR20MB297336108DF89337DDEEE2F6CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu_jFW26boEhpnAZg9sjWWZf60FXSWuSqNvC5FJiL7EVSA@mail.gmail.com>
 <MN2PR20MB2973A02FC4D6F1D11BA80792CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu8fgg=gt4LSnCfShnf0-PZ=B1TNwM3zdQr+V6hkozgDOA@mail.gmail.com>
 <MN2PR20MB29733EEF59CCD754256D5621CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190808083059.GB5319@sol.localdomain>
 <MN2PR20MB297328E243D74E03C1EF54ACCAD70@MN2PR20MB2973.namprd20.prod.outlook.com>
 <67b4f0ee-b169-8af4-d7af-1c53a66ba587@gmail.com>
In-Reply-To: <67b4f0ee-b169-8af4-d7af-1c53a66ba587@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 17e6f19b-2bc7-4ba6-d156-08d71c038f18
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2895;
x-ms-traffictypediagnostic: MN2PR20MB2895:
x-ms-exchange-purlcount: 3
x-microsoft-antispam-prvs: <MN2PR20MB2895624767241B02939C78D3CAD70@MN2PR20MB2895.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 012349AD1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39840400004)(346002)(366004)(136003)(396003)(376002)(13464003)(199004)(189003)(6116002)(26005)(7736002)(25786009)(86362001)(316002)(6246003)(71200400001)(54906003)(110136005)(4326008)(71190400001)(52536014)(476003)(14454004)(11346002)(446003)(486006)(966005)(74316002)(6506007)(2906002)(53546011)(33656002)(102836004)(76176011)(5660300002)(15974865002)(478600001)(186003)(9686003)(55016002)(6306002)(66066001)(14444005)(229853002)(53936002)(76116006)(8676002)(6436002)(66946007)(256004)(81156014)(81166006)(8936002)(99286004)(66476007)(66556008)(305945005)(64756008)(7696005)(66446008)(3846002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2895;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 5g369BdUzVNdoYY9bytqDcCR492ZYDt6B8Mzp8fR9rlknNXDDGgi8REyWONWdNvysc2gqTyvek6ve/+Gv2GTUMT5igVVIST49uT0UME73NpWyWJVWQpTg1WpeqXheQ7BnRzFtaPyU812Fmv2zw2b2N97quvQ5FCCxO/MhQUzbfGtdbPfxq8B+u4ppaxZ2eQM2Zaz/XBrRZS8JjUQp3uaqo3PDJz4XE6uWKiah0Ui9m3YDZltt4gH8dAYfZavB+ugcWjrgBZe99z2rCSsAR5LhgeTVR12Nts7oDk/UAY/BPEtFBWcPw3woylXXNmolOPAN9zQ81csryMvoX4OB819Tn3NxICa5x9Li75wJ06F+EpdDtjmKZaeYQ/qnWHi+w7goHxDKWzdRhhJ0lDE6+wlypYzr6P2O0iLZqDFQi1xDfY=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17e6f19b-2bc7-4ba6-d156-08d71c038f18
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2019 13:23:10.6183
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fQ9oqv5+vgvNPTustlAoofM2r4BEzAKl/ZJv4/0KbpA+eiOdF0mWtJo1HDBi8M+DpdYDbqBYM5YSMWnBxDy7v4+eTIaGH7oWH7n2HYQCqjs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2895
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Milan Broz <gmazyland@gmail.com>
> Sent: Thursday, August 8, 2019 2:53 PM
> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>; Eric Biggers <ebigge=
rs@kernel.org>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>; linux-crypto@vger.kernel.=
org;
> herbert@gondor.apana.org.au; agk@redhat.com; snitzer@redhat.com; dm-devel=
@redhat.com
> Subject: Re: [RFC PATCH v2] md/dm-crypt - reuse eboiv skcipher for IV gen=
eration
>=20
> On 08/08/2019 11:31, Pascal Van Leeuwen wrote:
> >> -----Original Message-----
> >> From: Eric Biggers <ebiggers@kernel.org>
> >> Sent: Thursday, August 8, 2019 10:31 AM
> >> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> >> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>; linux-crypto@vger.kern=
el.org;
> >> herbert@gondor.apana.org.au; agk@redhat.com; snitzer@redhat.com; dm-de=
vel@redhat.com;
> >> gmazyland@gmail.com
> >> Subject: Re: [RFC PATCH v2] md/dm-crypt - reuse eboiv skcipher for IV =
generation
> >>
> >> On Wed, Aug 07, 2019 at 04:14:22PM +0000, Pascal Van Leeuwen wrote:
> >>>>>> In your case, we are not dealing with known plaintext attacks,
> >>>>>>
> >>>>> Since this is XTS, which is used for disk encryption, I would argue
> >>>>> we do! For the tweak encryption, the sector number is known plainte=
xt,
> >>>>> same as for EBOIV. Also, you may be able to control data being writ=
ten
> >>>>> to the disk encrypted, either directly or indirectly.
> >>>>> OK, part of the data into the CTS encryption will be previous ciphe=
rtext,
> >>>>> but that may be just 1 byte with the rest being the known plaintext=
.
> >>>>>
> >>>>
> >>>> The tweak encryption uses a dedicated key, so leaking it does not ha=
ve
> >>>> the same impact as it does in the EBOIV case.
> >>>>
> >>> Well ... yes and no. The spec defines them as seperately controllable=
 -
> >>> deviating from the original XEX definition - but in most practicle us=
e cases
> >>> I've seen, the same key is used for both, as having 2 keys just incre=
ases
> >>> key  storage requirements and does not actually improve effective sec=
urity
> >>> (of the algorithm itself, implementation peculiarities like this one =
aside
> >>> :-), as  XEX has been proven secure using a single key. And the secur=
ity
> >>> proof for XTS actually builds on that while using 2 keys deviates fro=
m it.
> >>>
> >>
> >> This is a common misconception.  Actually, XTS needs 2 distinct keys t=
o be a
> >> CCA-secure tweakable block cipher, due to another subtle difference fr=
om XEX:
> >> XEX (by which I really mean "XEX[E,2]") builds the sequence of masks s=
tarting
> >> with x^1, while XTS starts with x^0.  If only 1 key is used, the inclu=
sion of
> >> the 0th power in XTS allows the attack described in Section 6 of the X=
EX paper
> >> (https://web.cs.ucdavis.edu/~rogaway/papers/offsets.pdf).
> >>
> > Interesting ... I'm not a cryptographer, just a humble HW engineer spec=
ialized
> > in implementing crypto. I'm basing my views mostly on the Liskov/Minema=
tsu
> > "Comments on XTS", who assert that using 2 keys in XTS was misguided.
> > (and I never saw any follow-on comments asserting that this view was wr=
ong ...)
> > On not avoiding j=3D0 in the XTS spec they actually comment:
> > "This difference is significant in security, but has no impact on effec=
tiveness
> > for practical applications.", which I read as "not relevant for normal =
use".
> >
> > In any case, it's frequently *used* with both keys being equal for perf=
ormance
> > and key storage reasons.
>=20
> There is already check in kernel for XTS "weak" keys (tweak and encryptio=
n keys must not be
> the same).
>=20
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/i=
nclude/crypto/xts.h#
> n27
>=20
> For now it applies only in FIPS mode... (and if I see correctly it is dup=
licated in all
> drivers).
>=20
I never had any need to look into FIPS for XTS before, but this actually ap=
pears
to be accurate. FIPS indeed *requires this*. Much to my surprise, I might a=
dd.
Still looking for some actual rationale that goes beyond suggestion and inn=
uendo=20
(and is not too heavy on the math ;-) though.


> Milan


Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
