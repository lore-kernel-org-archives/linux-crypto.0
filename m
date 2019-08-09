Return-Path: <SRS0=Ue/q=WF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F3C3C433FF
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 15:06:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD165204EC
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 15:06:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="qY/uHMS/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406490AbfHIPG1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Aug 2019 11:06:27 -0400
Received: from mail-eopbgr780050.outbound.protection.outlook.com ([40.107.78.50]:10608
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726152AbfHIPG1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Aug 2019 11:06:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mZLm17GeA2e+vGHSS+JqI/zRjGQladnQdbGdEKdCaXZe0OlwKTCZ2c5YcwAEcjfJOvdd7snWH/zImxj5w8F6mZBeie/BXjaGFPNdO+MTN/JG/2vIHDYQKpsBhpM+b2BzWN0YsgBHTNr1Snpw1mabSXJvTUf0Otn9VnwxKMg285RYuOEAkXEJpPdKlStaBlFrxkZbJpckBJ/KdhW09jYSo98HpM0PArwlBQqTz3WXU3bZQILo0zV6N6Yc+opO9T6gLnELvGWSXKpI6aZ6+3hwwsv2ylgjWd1P8toGzs09qalWoZI+4FKiC1kA6/eUoqO9b4feYruvc9GRP1CGscBUvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6WuBp1dQSGV5hF3Te/Rro/3YZ3Qvw/14LyP9oDyHhj0=;
 b=LUzHbTPrNE6Xkwc8v33RAP86uZ2lTyFcaHBDKUkbk3p0DpXc45ZO55IRq6y6UsINt+xkiCSwv9AQUyWVXUSsBJ47apCGYR07XGRxzmhPih2Ecb+5lHPb3tXy+iebmKVS8OQxLj8DIesxUeAkXycIAZVj2FoyOxZ4ZNfcn5bAoIACQDpb4CnAAdnzE+z22X3eRdz6zw4fdJ8tbKCIhLysMhVSdt4CQggCqwtz7T05Bq5flmajwBYie4nF7QB0MTpisR1e5jmQZ9X+UZ591u6ERBrIsXAAau+CMbZIIgeqOJVFiCqovICmjwiluf9KK5WJ3NIlg8i81y2u+jVxGDxXKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6WuBp1dQSGV5hF3Te/Rro/3YZ3Qvw/14LyP9oDyHhj0=;
 b=qY/uHMS/jdyx+gmivMo6dxQe40Gmt/2PU7fwAh/Nb/hFjd4CIZItjZJ60gfmWzn98fHL+svi97cbSYbJJqNr1PXxiJWz3Q4oIBTosA27LbowtBcP88pUPbeanWwpO3SHKkbGE/vzlHgRZu//UTCIjJ12io3yKMUY0GwUmO88fq4=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB3133.namprd20.prod.outlook.com (52.132.174.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.15; Fri, 9 Aug 2019 15:06:23 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2157.020; Fri, 9 Aug 2019
 15:06:23 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>
Subject: RE: XTS template wrapping question
Thread-Topic: XTS template wrapping question
Thread-Index: AdVOpvQVifejpBWTRVyvNwtV/QL5zQABu5aQAASi1wA=
Date:   Fri, 9 Aug 2019 15:06:23 +0000
Message-ID: <MN2PR20MB2973782AD2114D66B2A0807ECAD60@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <MN2PR20MB2973BB8A78D663C6A3D6A223CAD60@MN2PR20MB2973.namprd20.prod.outlook.com>
 <MN2PR20MB29737E7D905FE0B9D3CE3A68CAD60@MN2PR20MB2973.namprd20.prod.outlook.com>
In-Reply-To: <MN2PR20MB29737E7D905FE0B9D3CE3A68CAD60@MN2PR20MB2973.namprd20.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6f223e66-3689-4e4f-4fb6-08d71cdb249b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB3133;
x-ms-traffictypediagnostic: MN2PR20MB3133:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB313318BA666727560A1F7CFDCAD60@MN2PR20MB3133.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01244308DF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(346002)(396003)(39850400004)(376002)(13464003)(189003)(199004)(8936002)(26005)(66066001)(14454004)(81156014)(81166006)(478600001)(9686003)(229853002)(53936002)(2940100002)(5660300002)(3480700005)(102836004)(15974865002)(33656002)(6116002)(186003)(6246003)(55016002)(3846002)(6436002)(74316002)(71190400001)(99286004)(8676002)(76176011)(71200400001)(64756008)(52536014)(316002)(256004)(86362001)(2906002)(66476007)(2501003)(305945005)(486006)(6506007)(476003)(53546011)(7736002)(66556008)(11346002)(25786009)(66946007)(446003)(66446008)(7696005)(110136005)(76116006)(2201001)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB3133;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 3Bzs0MVau5ytV6C60CpKiZeSnLZTxOlvqU+ks2oVjcXORbm1+VpmcuamZH3xlBJ3koKLFSQSq79eEOfl6Tk9/Jmafkm3bvLKIMIv2aBk0zS6LeIqHcEqPNfawUCWbe/JLp7QRg8idOvP+bWhQdi2eSFOLV5YZrNbH4H8w2BSR0L08cvdDIXxmZ0D4ScO8WAaoPd6eddWF2jy2To5RjuZ9hngsJvSA7kwFf+Uicf/wzmm0epA4QzxO4zU4jHYcW5lKAmcd8/WMDtpP7nwKBYj/cb7T3X8BJsmYYCJm9c8Ey5ei+jYJKFQWUMj2imx225wr55v3cEjczS26zE9I+cu4guOedywEf29hGOZFzgeMxmgtXCsViUQgPDfHJTbTUA8W941qVBU+GRygOjOwTGs4CMd09Op5fkKAXMdpdMvBqA=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f223e66-3689-4e4f-4fb6-08d71cdb249b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2019 15:06:23.3368
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: av++nL+lVbnEEPsmfL/iEc4JW1hgKzj/ZdWyRjxwdpB3bfdExRntPc4o0J0+5oUuGcCvxBMgjsIburKXgsR7J3/HVttaO2iSsGzL1pUFNHc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB3133
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Sent: Friday, August 9, 2019 4:18 PM
> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>; linux-crypto@vger.ke=
rnel.org;
> herbert@gondor.apana.org.au; davem@davemloft.net; Eric Biggers <ebiggers@=
kernel.org>
> Subject: RE: XTS template wrapping question
>=20
> > -----Original Message-----
> > From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kerne=
l.org> On Behalf
> Of
> > Pascal Van Leeuwen
> > Sent: Friday, August 9, 2019 1:39 PM
> > To: linux-crypto@vger.kernel.org; herbert@gondor.apana.org.au; davem@da=
vemloft.net; Eric
> > Biggers <ebiggers@kernel.org>
> > Subject: XTS template wrapping question
> >
> > Herbert, Eric,
> >
> > While working on the XTS template, I noticed that it is being used
> > (e.g. from testmgr, but also when explictly exported from other drivers=
)
> > as e.g. "xts(aes)", with the generic driver actually being
> > "xts(ecb(aes-generic))".
> >
> > While what I would expect would be "xts(ecb(aes))", the reason being
> > that plain "aes" is defined as a single block cipher while the XTS
> > template actually efficiently wraps an skcipher (like ecb(aes)).
> > The generic driver reference actually proves this point.
> >
> > The problem with XTS being used without the ecb template in between,
> > is that hardware accelerators will typically advertise an ecb(aes)
> > skcipher and the current approach makes it impossible to leverage
> > that for XTS (while the XTS template *could* actually do that
> > efficiently, from what I understand from the code ...).
> > Advertising a single block "aes" cipher from a hardware accelerator
> > unfortunately defeats the purpose of acceleration.
> >
> > I also wonder what happens if aes-generic is the only AES
> > implementation available? How would the crypto API know it needs to
> > do "xts(aes)" as "xts(ecb(aes))" without some explicit export?
> > (And I don't see how xts(aes) would work directly, considering
> > that only seems to handle single cipher blocks? Or ... will
> > the crypto API actually wrap some multi-block skcipher thing
> > around the single block cipher instance automatically??)
> >
> Actually, the above was based on observations from testmgr, which
> doesn't seem to test xts(safexcel-ecb-aes) even though I gave that
> a very high .cra_priority as well as that what is advertised under
> /proc/crypto, which does not include such a thing either.
>=20
> However, playing with tcrypt mode=3D600 shows some interesting
> results:
>=20
> WITHOUT the inside-secure driver loaded, both LRW encrypt and
> decrypt run on top of ecb-aes-aesni as you would expect.
> Both xts encrypt and decrypt give a "failed to load transform"
> with an error code of -80. Strange ... -80 =3D ELIBBAD??
> (Do note that the selftest of xts(aes) using xts-aesni worked
> just fine according to /proc/crypto!)
>=20
> WITH the inside-secure driver loaded, NOT advertising xts(aes)
> itself and everything at cra_priority of 300: same (expected).
>=20
> WITH the inside-secure driver loaded, NOT advertising xts(aes)
> itself and everything safexcel at cra_priority of 2000:
> LRW decrypt now runs on top of safexcel-ecb-aes, but LRW
> encrypt now runs on top of aes-generic? This makes no sense as
> the encrypt datapath structure is the same as for decrypt so
> it should run just fine on top of safexcel-ecb-aes. And besides
> that, why drop from aesni all the way down to aes-generic??
> xts encrypt and decrypt still give the -80 error, while you
> would expect that to now run using the xts wrapper around
> safexcel-ecb-aes (but no way to tell if that's happening).
>=20
> WITH the inside-secure driver loaded, advertising xts(aes)
> itself and everything at cra_priority of 2000:
> still the same LRW assymmetry as mentioned above, but
> xts encrypt and decrypt now work fine using safexcel-aes-xts
>=20
> Conclusions from the above:
>=20
> - There's something fishy with the selection of the underlying
>   AES cipher for LRW encrypt (but not for LRW decrypt).
>
Actually, this makes no sense at all as crypto_skcipher_alloc=20
does not even see the direction you're going to use in your=20
requests. Still, it is what I consistently see happening in=20
the tcrypt logging. Weird!

> - xts-aes-aesni (and the xts.c wrapper?) appear(s) broken in
>   some way not detected by testmgr but affecting tcrypt use,
>   while the inside-secure driver's local xts works just fine
>=20

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
