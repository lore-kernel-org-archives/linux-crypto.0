Return-Path: <SRS0=+H67=WH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 243CCC0650F
	for <linux-crypto@archiver.kernel.org>; Sun, 11 Aug 2019 21:39:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC81920818
	for <linux-crypto@archiver.kernel.org>; Sun, 11 Aug 2019 21:39:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="GCEr6LmX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbfHKVjx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 11 Aug 2019 17:39:53 -0400
Received: from mail-eopbgr690080.outbound.protection.outlook.com ([40.107.69.80]:40455
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726011AbfHKVjx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 11 Aug 2019 17:39:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X3PDSAcRPMItYSSjUnJu61B7eauPaUiCqBVq/9ERCdm9z/W33pT/cEOW1k0rNthD7FILn5T1z2xUQflPUYaV3WCdKbf0oaelAKeWyaljlePe1GFZUDrqRhXjv1iGphW0vmYikIJfQB90dnKDQHk4b0+MkKA7dfLLxEISRtZql34Jj18tBEIYoKgx8DIHP2/vxtyE+41qRFp1ejT0GmX70EClMLKLcrd8dMsaz3Zh3HEs+JEdv4H8Ov0p/81MbUQmJthcch+unbLp6tqj35nPR+eNBfB56IQAnynrfhwwtNV0Uakn+1vAaEEdBMMJfebazGJ4ublA7olKC0zxkQu18g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TrjdK6xZqryVzpTRMH/td0xqc2QwJ7p3z5Vax9XahvU=;
 b=byAweqN28xoS586a5JIKS8wJzNHEAib4XutGuUXcLPosuaz4Mbp16lZuUUzMGAWCCvV2nmdy8uRrmAea0aQKTbAvBLF0me3DEELwGL6oqKsipHRui6sJ8+1nm1+zCD9KsuJQc4egn+COtS5yumzW9vHAu7T59eEgpj2pILw0nqxphMOmM4wEbWt+EsBUjFFC1YY0gQ+EiF37Z1Oec3Ikew2LRdwfqczXtit+Ai8Hq2iJ1lSe/UIYmGMxzYr28FAMdh6CG9mk84lxzEuqIfemJWMjn4ZWfMLrpOiYDBFLeGNf5Eo7E7TEIAdNqdqblPy2cPUOUGafb764SMjDB8qniA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TrjdK6xZqryVzpTRMH/td0xqc2QwJ7p3z5Vax9XahvU=;
 b=GCEr6LmXRsMV16bsfc5l/09jhrcv+HdVMoG0WUBHiAyYtVEW6uChci/DIupTzryoB1wjggARBAAZOXksPBHsHFmt35wdGZsvZq4ZPSoF4bVFPZNxSZZwEwHACkMIg+PNrQx0V35bEztQ/r/2VoskIevTH59hyktP4I5ZgFY1MlI=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2702.namprd20.prod.outlook.com (20.178.252.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.17; Sun, 11 Aug 2019 21:39:46 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2157.022; Sun, 11 Aug 2019
 21:39:46 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Eric Biggers <ebiggers@kernel.org>,
        Milan Broz <gmazyland@gmail.com>
CC:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: [dm-devel] xts fuzz testing and lack of ciphertext stealing
 support
Thread-Topic: [dm-devel] xts fuzz testing and lack of ciphertext stealing
 support
Thread-Index: AQHVO/5l0aVU4O6KC0WgPIqEsMQCDqbzPYWAgAAwjTCAAIUtAIACADgAgACcyQCAABGx8A==
Date:   Sun, 11 Aug 2019 21:39:46 +0000
Message-ID: <MN2PR20MB29731377CA325722EDD6582ACAD00@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <VI1PR0402MB34856F03FCE57AB62FC2257998D40@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <MN2PR20MB2973127E4C159A8F5CFDD0C9CAD70@MN2PR20MB2973.namprd20.prod.outlook.com>
 <VI1PR0402MB3485689B4B65C879BC1D137398D70@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190809024821.GA7186@gondor.apana.org.au>
 <CAKv+Gu9hk=PGpsAWWOU61VrA3mVQd10LudA1qg0LbiX7DG9RjA@mail.gmail.com>
 <VI1PR0402MB3485F94AECC495F133F6B3D798D60@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <CAKv+Gu-_WObNm+ySXDWjhqe2YPzajX83MofuF-WKPSdLg5t4Ew@mail.gmail.com>
 <MN2PR20MB297361CA3C29C236D6D8F6F4CAD60@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu-xWxZ58tzyYoH_jDKfJoM+KzOWWpzCeHEmOXQ39Bv15g@mail.gmail.com>
 <d6d0b155-476b-d495-3418-4b171003cdd7@gmail.com>
 <20190811203406.GA17421@sol.localdomain>
In-Reply-To: <20190811203406.GA17421@sol.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a87a6c93-21b6-4ebb-bc87-08d71ea46ded
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2702;
x-ms-traffictypediagnostic: MN2PR20MB2702:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB2702B4163C279F375CA1E5DDCAD00@MN2PR20MB2702.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0126A32F74
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(396003)(346002)(39840400004)(13464003)(189003)(199004)(229853002)(6436002)(53936002)(99286004)(71200400001)(74316002)(4326008)(25786009)(71190400001)(5660300002)(86362001)(2906002)(316002)(55016002)(7696005)(6506007)(53546011)(110136005)(54906003)(76176011)(8936002)(7736002)(305945005)(33656002)(446003)(14454004)(81166006)(9686003)(102836004)(81156014)(8676002)(256004)(14444005)(476003)(76116006)(478600001)(26005)(11346002)(66476007)(66946007)(6246003)(486006)(66556008)(66446008)(66066001)(64756008)(186003)(3846002)(6116002)(15974865002)(52536014)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2702;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: JnhOTfNVwDyMt1RESEYvjR8wlsnXb3eBYoR+q2dtt1a2ZvXfHTZdEgt08LHX2UzjrGPz8LDDZU10SppWCd42GhznKN5l51NXHsDotKGbg27BBmAVof0+kwc1oXYCz+Xf5VrBkamQgdMxKGHrKhvj5nd86WGyYqd6NLTeFqSXJ67ZPXGdFH9oZyxmuHxdCfdLap3GpzJqj3tuKCmA8kazjOgyVj9ipCbMT7t5t+ibsdExwy0ZGTBmC32mD8uzFR3fH8mFum83C5CDUtu3BIHvS46YD2XS+f54yrRixqfzlrC/jeb7c5ESm2TPBe4FNMimu/TZlBukHIUOaNBulJQGZ9hMhKQSgfLE+f3TpJ4+amzhLCbZhgZtzw1i8WA/TgkLt9ndt9Q3mq825BcynvFooiodPL23kKSwEV4q698wxrc=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a87a6c93-21b6-4ebb-bc87-08d71ea46ded
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2019 21:39:46.3011
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wK6lDT5NjJ+dGKkXOM+0x+/SPH+DxQOeUy0AdYcr1e5nD6tQzCEUXqIeWrIkg4U7D1dqKCaU5m3Wl6ERK5T1P+fpXLRf/4zguOXjM/4Sjeo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2702
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Eric Biggers <ebiggers@kernel.org>
> Sent: Sunday, August 11, 2019 10:34 PM
> To: Milan Broz <gmazyland@gmail.com>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>; Pascal Van Leeuwen
> <pvanleeuwen@verimatrix.com>; dm-devel@redhat.com; Herbert Xu <herbert@go=
ndor.apana.org.au>;
> Horia Geanta <horia.geanta@nxp.com>; linux-crypto@vger.kernel.org
> Subject: Re: [dm-devel] xts fuzz testing and lack of ciphertext stealing =
support
>=20
> On Sun, Aug 11, 2019 at 01:12:56PM +0200, Milan Broz wrote:
> > On 10/08/2019 06:39, Ard Biesheuvel wrote:
> > > Truncated IVs are a huge issue, since we already expose the correct
> > > API via AF_ALG (without any restrictions on how many of the IV bits
> > > are populated), and apparently, if your AF_ALG request for xts(aes)
> > > happens to be fulfilled by the CAAM driver and your implementation
> > > uses more than 64 bits for the IV, the top bits get truncated silentl=
y
> > > and your data might get eaten.
> >
> > Actually, I think we have already serious problem with in in kernel (no=
 AF_ALG needed).
> >
> > I do not have the hardware, but please could you check that dm-crypt bi=
g-endian IV
> > (plain64be) produces the same output on CAAM?
> >
> > It is 64bit IV, but big-endian and we use size of cipher block (16bytes=
) here,
> > so the first 8 bytes are zero in this case.
> >
> > I would expect data corruption in comparison to generic implementation,
> > if it supports only the first 64bit...
> >
> > Try this:
> >
> > # create small null device of 8 sectors,  we use zeroes as fixed cipher=
text
> > dmsetup create zero --table "0 8 zero"
> >
> > # create crypt device on top of it (with some key), using plain64be IV
> > dmsetup create crypt --table "0 8 crypt aes-xts-plain64be
> e8cfa3dbfe373b536be43c5637387786c01be00ba5f730aacb039e86f3eb72f3 0 /dev/m=
apper/zero 0"
> >
> > # and compare it with and without your driver, this is what I get here:
> > # sha256sum /dev/mapper/crypt
> > 532f71198d0d84d823b8e410738c6f43bc3e149d844dd6d37fa5b36d150501e1  /dev/=
mapper/crypt
> > # dmsetup remove crypt
> >
> > You can try little-endian version (plain64), this should always work ev=
en with CAAM
> > dmsetup create crypt --table "0 8 crypt aes-xts-plain64
> e8cfa3dbfe373b536be43c5637387786c01be00ba5f730aacb039e86f3eb72f3 0 /dev/m=
apper/zero 0"
> >
> > # sha256sum /dev/mapper/crypt
> > f17abd27dedee4e539758eabdb6c15fa619464b509cf55f16433e6a25da42857  /dev/=
mapper/crypt
> > # dmsetup remove crypt
> >
> > # dmsetup remove zero
> >
> >
> > If you get different plaintext in the first case, your driver is actual=
ly creating
> > data corruption in this configuration and it should be fixed!
> > (Only the first sector must be the same, because it has IV =3D=3D 0.)
> >
> > Milan
> >
> > p.s.
> > If you ask why we have this IV, it was added per request to allow map s=
ome chipset-based
> > encrypted drives directly. I guess it is used for some data forensic th=
ings.
> >
>=20
> Also, if the CAAM driver is really truncating the IV for "xts(aes)", it s=
hould
> already be failing the extra crypto self-tests, since the fuzz testing in
> test_skcipher_vs_generic_impl() uses random IVs.
>=20
> - Eric
>
Yes, good point. Although that is only seen during development and not=20
during "normal" use ...


Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
