Return-Path: <SRS0=TZua=WD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FA17C433FF
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Aug 2019 20:58:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 680A42173C
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Aug 2019 20:58:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="xyxUF9DU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388822AbfHGU6B (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Aug 2019 16:58:01 -0400
Received: from mail-eopbgr780088.outbound.protection.outlook.com ([40.107.78.88]:10417
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388728AbfHGU6B (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Aug 2019 16:58:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DIUqaAPkj+DVtlflPeBkTWIr0VFC1jSqDdYE4B53/L9ZTie52Ai5X7AiqgPewMxb2v4fLP7KE9FYKibisx7L0WM+GxQ07M9KSN4s9EBuurg9vNq81sz5N/2C6jFTw/FfANj1Clj6luKZZvBpcUo4/HHvDmg2FtxweQtt7QO0dDCOZ9/9GR4RbFpK2oa0WPbqLq4LtnaOOwTJLQSzBP0QgkdhdIYV0wrebzEzz6AgHtahQCxGjukvlUT9wpUrdJO6X3t4ZQvsuBXioqhmaSvjWnBZixCR/rFDSmYqJ0xLA/yQ286ivAiPMAOOSZZnOIeOr3l+kXKIQKlAQkeXiqI0Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kyx2Eo0Cs0ZpKHQrUo0TNxsezoiBHxVMM1L5qUfdr3w=;
 b=JWTLtXljoESm4+fWvKPzrkpZq5BTUXvHiJp+jhl0ZJlg+bSsa7bjZdqcD/iSp+TLyP4MXATYmgPqdkLHwMZQdKk/9jZJm43jVauK3T5hyzeNtyUVZxYJfF8H4QIiHA4ViRRkUcZnDlm0U8JJDj93grtajshjmKK+C+EpnrFC1LNUPzfXLDrxkKmg+p7n6KGhYlF3alEP02/h2JdFP14/ZtY7HPIkOkEu0ZqhoUY1FuWYvJTqQ/wlI2Q+8Avyqza120UrEjq0C9RcdDpSVMQ2XAoDvw9cPmatFs4oaIRx9L+9gsjUU4faxhYWBNVtBgluoSIzwqS5Vb6/X3oAlpbTig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kyx2Eo0Cs0ZpKHQrUo0TNxsezoiBHxVMM1L5qUfdr3w=;
 b=xyxUF9DUeosFUrPelYQEEL4gH+WECr23S62+2U6nRqD3zf08KB4Oc5263jVPXiYmdTkLkufI17zBSPYAttwR/EMdmn+SQNAumCwnKSWhHVw526JUzWwX2t/MNcklzOUX9zgdpHonpZFHEpm8cLjoYTBBcNsaX4+8gU8a/cmMFM8=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB3279.namprd20.prod.outlook.com (52.132.175.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.16; Wed, 7 Aug 2019 20:57:55 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2136.018; Wed, 7 Aug 2019
 20:57:55 +0000
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
Thread-Index: AQHVO/5l0aVU4O6KC0WgPIqEsMQCDqbwRNbQ
Date:   Wed, 7 Aug 2019 20:57:55 +0000
Message-ID: <MN2PR20MB2973C16264CA748F147834E9CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
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
In-Reply-To: <VI1PR0402MB34856F03FCE57AB62FC2257998D40@VI1PR0402MB3485.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f4f832e6-3f53-4004-fbac-08d71b79ebe2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB3279;
x-ms-traffictypediagnostic: MN2PR20MB3279:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB3279EDB1C73DCE7498779014CAD40@MN2PR20MB3279.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01221E3973
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39850400004)(136003)(396003)(366004)(346002)(376002)(189003)(199004)(13464003)(52536014)(33656002)(102836004)(6246003)(8676002)(54906003)(4326008)(316002)(64756008)(476003)(229853002)(446003)(6116002)(66556008)(3846002)(2906002)(110136005)(478600001)(99286004)(7736002)(81156014)(81166006)(305945005)(25786009)(66946007)(256004)(11346002)(8936002)(486006)(66446008)(14454004)(66476007)(14444005)(71200400001)(71190400001)(76176011)(9686003)(7696005)(186003)(53546011)(76116006)(5660300002)(53936002)(6506007)(6436002)(66066001)(86362001)(26005)(15974865002)(74316002)(55016002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB3279;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: LGEzgNfbz40bXKXIkKQfXm7/zUUKcEb077GS/IIGZqpRzgD/x+TfCg+mpjJydCK+8SA1saKmbuC0dhOcMa+pZ7l06cLkEl3r9l8XQ+7ZRmgT8vySlwHPHt+x3ygKWQIYmcqprgfSZGnKLM29BqAgvcSZ4iqt9qSkP9RIkK7ca5DK56RBQGC4YTAFuYFVmzq5q8v1hnYvWC88U+yrDKzFLSoGxZ6sy18pweihLtZmRALFY4+j2QS97dGUZJKwvx9xD7kt56lIzlqf8hKNjvSIOisBQLqV6L6bklahM9vy79jTENJdf63IBEESFkiVodf1LEbJD3q/jyY4O7u1ICPwjrZ7Onjlzy+cmiIylnMD24g6bpA9xoto9uP0Uuq20RT24bC0M3u7Cfoz1KRPLUBL+yNoVTv4JUW4s8Y033OKCjg=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4f832e6-3f53-4004-fbac-08d71b79ebe2
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2019 20:57:55.6979
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB3279
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Horia Geanta <horia.geanta@nxp.com>
> Sent: Wednesday, August 7, 2019 5:52 PM
> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>; Ard Biesheuvel
> <ard.biesheuvel@linaro.org>
> Cc: Milan Broz <gmazyland@gmail.com>; Herbert Xu <herbert@gondor.apana.or=
g.au>; dm-
> devel@redhat.com; linux-crypto@vger.kernel.org
> Subject: Re: [dm-devel] xts fuzz testing and lack of ciphertext stealing =
support
>=20
> On 7/26/2019 10:59 PM, Horia Geant=E3 wrote:
> > On 7/26/2019 1:31 PM, Pascal Van Leeuwen wrote:
> >> Ok, find below a patch file that adds your vectors from the specificat=
ion
> >> plus my set of additional vectors covering all CTS alignments combined
> >> with the block sizes you desired. Please note though that these vector=
s
> >> are from our in-house home-grown model so no warranties.
> > I've checked the test vectors against caam (HW + driver).
> >
> > Test vectors from IEEE 1619-2007 (i.e. up to and including "XTS-AES 18"=
)
> > are fine.
> >
> > caam complains when /* Additional vectors to increase CTS coverage */
> > section starts:
> > alg: skcipher: xts-aes-caam encryption test failed (wrong result) on te=
st vector 9,
> cfg=3D"in-place"
> >
> I've nailed this down to a caam hw limitation.
> Except for lx2160a and ls1028a SoCs, all the (older) SoCs allow only for
> 8-byte wide IV (sector index).
>
I guess it's easy to say now, but I already suspected a problem with full 1=
6=20
byte random IV's. A problem with CTS itself seemed implausible due to the b=
ase
vectors from the spec running fine and I did happen to notice that all=20
vectors from the spec only use up to the lower 40 bits of the sector number=
.
While my vectors randomize all 16 bytes.

So I guess that means that 16 byte multiples (i.e. not needing CTS) with
full 16 byte sector numbers will probably also fail on caam HW ...
=09
As for the tweak size, with very close scrutiny of the IEEE spec I actually
noticed some inconsistencies:

- the text very clearly defines the tweak as 128 bit and starting from an=20
*arbitrary* non-negative integer, this is what I based my implementation on

- all text examples and test vectors max out at 40 bits ... just examples,
but odd nonetheless (why 40 anyway?)

- the example code fragment in Annex C actually has the S data unit number
input as an u64b, further commented as "64 bits" (but then loops 16 times t=
o
convert it to a byte string ...)

So I guess from this specification, a true HW engineer might implement a
full 128 bit tweak, while a SW engineer looking at the example code might
just implement 64 bits. And the latter would pass all provided test vectors=
.

> Will follow up with 16-byte IV support for the above-mentioned SoCs.
>=20
> Pascal,
>=20
> Could you also generate a few test vectors covering CTS with 8-byte IV?
>=20
I can generate them in a format similar to what's in the IEEE spec, but I
don't feel much like typing them over into testmgr.h format again.
If you don't mind.

> Thanks,
> Horia

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
