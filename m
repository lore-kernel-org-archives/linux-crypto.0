Return-Path: <SRS0=IdBJ=WE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67251C0650F
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Aug 2019 09:31:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 313C42173C
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Aug 2019 09:31:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="cnAcNxaC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732261AbfHHJbN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 8 Aug 2019 05:31:13 -0400
Received: from mail-eopbgr710071.outbound.protection.outlook.com ([40.107.71.71]:61718
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731122AbfHHJbN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Aug 2019 05:31:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kl88cEd3+fXE58MtQL9s9Kc0EFPGsTzAeqgdWl7GkBW5PxADc3Gg4+sd17rm0BzAs4vIPriH9IASu3qImNcvcZlwzGeXgkdYmbY03cMIqaNHzNcs6tVUgRIZgB3iPUhJghh1ajCoZH8evWXEZPrtVr6iAZVw0WFDlegBLDGjNljBqqM836rQKqv8HiY5ifDqbRtxcch2pXdx+LC2gjUvplYmZ0IEaNqKL3yBvmc74AVBGb9MKFvZduTJmJfEMwkE041SJ44brDf4jiEubb+Ps9s5+b1OZL5uKdZblTsrcf00ygp0A0HDJzPZo96I1KY0H+1L9kSDR7eK8JPra/yqKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ruKl+R0OAegoKIrBJccZFf8G9XjUZDHTF2jSD5pge+o=;
 b=OpaZLQWL3PbQxAHvQ4TClr3iWKsPCVSNv7HJOBurxFnSp9pe0ARVc/QPo2TFiHt5YaVG48sc+pfq9YP1no4O4eQ/Y1EQRRvqkjffpKMyaqQWyT46808mYjVfpyT3lZygceuvqyhP6zGlkq/7O7SnobZ6oRXlwHl0xTP6edzZZUrQNhxCkN6FSbeCQrJN5wINDmEIbQiAxgaHnXbTV9ibIJcHCEiuAz/rYHQuNfBRtJpksVZ1ifM9AnUdCxatkmhyUz30Zj5xm/C4UY5XM24N9UqpDmGk8wwDiJL5Th76kTr8nW/hbF1+TC2JaigYgVDXLzstt5EyhuxjlJ6ij/Uc1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ruKl+R0OAegoKIrBJccZFf8G9XjUZDHTF2jSD5pge+o=;
 b=cnAcNxaCeKkiiw0jHbnl3L3OCfk4qPSmfKq7awK0ktxq8YLmAK7UvMQpyluvZUznLEaKj+GetiI6A8l26V6ZpXrDxez4VYf8A3WjfioyPBQms4gnSsHtR5y43QRbJuLtQemkrsfN3UXP1mm202HqnEqnqBLvz9h4Nvo6bj9/CLU=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB3149.namprd20.prod.outlook.com (52.132.174.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.19; Thu, 8 Aug 2019 09:31:09 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2157.015; Thu, 8 Aug 2019
 09:31:09 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "agk@redhat.com" <agk@redhat.com>,
        "snitzer@redhat.com" <snitzer@redhat.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "gmazyland@gmail.com" <gmazyland@gmail.com>
Subject: RE: [RFC PATCH v2] md/dm-crypt - reuse eboiv skcipher for IV
 generation
Thread-Topic: [RFC PATCH v2] md/dm-crypt - reuse eboiv skcipher for IV
 generation
Thread-Index: AQHVTOQKWnTPkdATo0i/D1XZtRSIkqbvRQ3wgABmBgCAAAHhUIAAJeoAgAAASmCAARpFgIAAAIWQ
Date:   Thu, 8 Aug 2019 09:31:08 +0000
Message-ID: <MN2PR20MB297328E243D74E03C1EF54ACCAD70@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <20190807055022.15551-1-ard.biesheuvel@linaro.org>
 <MN2PR20MB297336108DF89337DDEEE2F6CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu_jFW26boEhpnAZg9sjWWZf60FXSWuSqNvC5FJiL7EVSA@mail.gmail.com>
 <MN2PR20MB2973A02FC4D6F1D11BA80792CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu8fgg=gt4LSnCfShnf0-PZ=B1TNwM3zdQr+V6hkozgDOA@mail.gmail.com>
 <MN2PR20MB29733EEF59CCD754256D5621CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190808083059.GB5319@sol.localdomain>
In-Reply-To: <20190808083059.GB5319@sol.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cdc865d3-69c8-462b-11e7-08d71be32528
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB3149;
x-ms-traffictypediagnostic: MN2PR20MB3149:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <MN2PR20MB314952301208418763A92070CAD70@MN2PR20MB3149.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 012349AD1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39850400004)(346002)(376002)(136003)(396003)(199004)(189003)(13464003)(6306002)(55016002)(74316002)(53936002)(9686003)(4326008)(446003)(229853002)(476003)(11346002)(316002)(186003)(6116002)(2906002)(33656002)(26005)(76116006)(305945005)(6436002)(14444005)(256004)(486006)(66446008)(54906003)(66476007)(66556008)(64756008)(71200400001)(7696005)(66946007)(81166006)(76176011)(6916009)(8936002)(3846002)(81156014)(8676002)(66066001)(15974865002)(71190400001)(6506007)(53546011)(6246003)(99286004)(52536014)(478600001)(25786009)(5660300002)(86362001)(102836004)(7736002)(14454004)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB3149;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: e7IsXyqyQ+T2KVjJvJkPkFt6xv/Ma10r50EdY7W9Cgm68Mh3wY6YvyuEfrL3Q27wQVKdi5jmchv0J48g5zNQsRH4FsShp0OeiKEJG1epIWTq4JdcCuOf8iLGCveq0PowlWIkvWnz9IJx3o3ePdAHeZG/E/6+UsZNyrrPhUmbL3PmA6Urs8jg0gwsVcCTa7GB30mQwufPsyNTl7DjMFllD03Uan06RTVOziZ+UaSbFLkkiHFoyNBZlfLL1iaploVHp64AoJwEshWP5X2jWS55klw6KqQCq5W0ujAdAZcB3e/qE+AG7wl+seS/hKa/rcEZMbo0wBrDDFqEU3lGPsdVHyZlUR/A9y6N/J2cQERmJJkJlBLUjfKTp7CsDsFYvl9Dd2Am2VbpEhhH4Bm5QSH7sGm/DaGqJbr561NO3gV00ug=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdc865d3-69c8-462b-11e7-08d71be32528
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2019 09:31:08.9894
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BvuyYBOZZeY1FiIFR6ohwofHAe5Ez1T4maX7zTNZ9ikTb2cJKhP8tDuBWtTAEWlEBcFetkRtiiJjbP6DNcGMhCWjt6X/PTqL91K+/Q144bE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB3149
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Eric Biggers <ebiggers@kernel.org>
> Sent: Thursday, August 8, 2019 10:31 AM
> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>; linux-crypto@vger.kernel.=
org;
> herbert@gondor.apana.org.au; agk@redhat.com; snitzer@redhat.com; dm-devel=
@redhat.com;
> gmazyland@gmail.com
> Subject: Re: [RFC PATCH v2] md/dm-crypt - reuse eboiv skcipher for IV gen=
eration
>=20
> On Wed, Aug 07, 2019 at 04:14:22PM +0000, Pascal Van Leeuwen wrote:
> > > > > In your case, we are not dealing with known plaintext attacks,
> > > > >
> > > > Since this is XTS, which is used for disk encryption, I would argue
> > > > we do! For the tweak encryption, the sector number is known plainte=
xt,
> > > > same as for EBOIV. Also, you may be able to control data being writ=
ten
> > > > to the disk encrypted, either directly or indirectly.
> > > > OK, part of the data into the CTS encryption will be previous ciphe=
rtext,
> > > > but that may be just 1 byte with the rest being the known plaintext=
.
> > > >
> > >
> > > The tweak encryption uses a dedicated key, so leaking it does not hav=
e
> > > the same impact as it does in the EBOIV case.
> > >
> > Well ... yes and no. The spec defines them as seperately controllable -
> > deviating from the original XEX definition - but in most practicle use =
cases
> > I've seen, the same key is used for both, as having 2 keys just increas=
es
> > key  storage requirements and does not actually improve effective secur=
ity
> > (of the algorithm itself, implementation peculiarities like this one as=
ide
> > :-), as  XEX has been proven secure using a single key. And the securit=
y
> > proof for XTS actually builds on that while using 2 keys deviates from =
it.
> >
>=20
> This is a common misconception.  Actually, XTS needs 2 distinct keys to b=
e a
> CCA-secure tweakable block cipher, due to another subtle difference from =
XEX:
> XEX (by which I really mean "XEX[E,2]") builds the sequence of masks star=
ting
> with x^1, while XTS starts with x^0.  If only 1 key is used, the inclusio=
n of
> the 0th power in XTS allows the attack described in Section 6 of the XEX =
paper
> (https://web.cs.ucdavis.edu/~rogaway/papers/offsets.pdf).
>=20
Interesting ... I'm not a cryptographer, just a humble HW engineer speciali=
zed
in implementing crypto. I'm basing my views mostly on the Liskov/Minematsu
"Comments on XTS", who assert that using 2 keys in XTS was misguided.=20
(and I never saw any follow-on comments asserting that this view was wrong =
...)
On not avoiding j=3D0 in the XTS spec they actually comment:
"This difference is significant in security, but has no impact on effective=
ness=20
for practical applications.", which I read as "not relevant for normal use"=
.

In any case, it's frequently *used* with both keys being equal for performa=
nce
and key storage reasons.

> Of course, it's debatable what this means *in practice* to the usual XTS =
use
> cases like disk encryption, for which CCA security may not be critical...=
  But
> technically, single-key XTS isn't secure under as strong an attack model =
as XEX.
>=20
Well, technically the XTS specification does not actually mandate that j sh=
ould
start at 0 (!), although that's what the vectors and example code suggest .=
..

> - Eric

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
