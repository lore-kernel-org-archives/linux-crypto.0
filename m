Return-Path: <SRS0=bf8p=XK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA378C2BA1D
	for <linux-crypto@archiver.kernel.org>; Sun, 15 Sep 2019 22:02:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A21FD2067D
	for <linux-crypto@archiver.kernel.org>; Sun, 15 Sep 2019 22:02:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="DvXj8X5U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725951AbfIOWCm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 15 Sep 2019 18:02:42 -0400
Received: from mail-eopbgr700081.outbound.protection.outlook.com ([40.107.70.81]:40946
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725907AbfIOWCm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 15 Sep 2019 18:02:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=efGz+ln6SoJ5pG/1xtbsibRNYLCICw+UssU4xeNV1hQblB3OM1uO/KSnAq1WBI6fdQMywpTUmFEU0SgdLXeFSTUY8xR9n4iDi/uHOCtCO8kOIcQkEoJxsp5K3e/vYIjEz2iv9xfs9spfhWqOa+qBOwrjlZCHlkBloCL+dfAjls6QklX2LOhH2t4A/LyVU61vSVkEnRCz5dQZbXMW78PuGsALthkLf/G4Vct5pyBLsKURmaXeZ3kS2EMKekmZBMZJNPoycRBc59027a3ETDGEJx/JIpbFRRvh1e4C2MywJ+U9ePDTIg7/W5+NKdd/wL5KA5lDVSOD5n+nsAlGau+fpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hattS8cSH30gHpWqY/OQh6a+91AUb3JIVCmRrKjdMVo=;
 b=ZS6z1b6S8DEmHoW/KvTuVk69APX5H6Yictby+1EJM6dxiQKhbZ5H7Cj4gvMVo7n1PyRaAYwKNgjSN6cmKlGgyGmyEUa8TSSnhItlYpOduJXl8VpgStHpEz1t5OmI59c3x1cyX+7AWm8Y11pwQ09teBehEdilD3CTjeXSq/cO7lFyk8EljTKneBMce9x7mHW8J/L+a2PuVYDAPjxbeNjf1CWPxcFVd4X0VGnsyaqOiTeJvKwkVBISrREwIFtjvakjxbg+5kB/3V8MMxSBO3MYM6knUYbTeoIiccGEVFZKMPAPC8+1af5rtQVucL7w9sf2jDXdcbBL+m9fqDyV6GnVPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hattS8cSH30gHpWqY/OQh6a+91AUb3JIVCmRrKjdMVo=;
 b=DvXj8X5UZRQaExJG44z+IKdEQ1KntmmG86qblUEYFH43nIX7WVfEjwryzwLtBkC+o50Y4Q+4rCdWrFXUXGm2ho25HqMu90C9A2VFefCYqErMYEDb8FDSUbxdEiJfnS9uv7WykpLe5Ba4fpM37d8WKjvcwVKKSzS+hNiLDdtiJuc=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2815.namprd20.prod.outlook.com (20.178.252.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.21; Sun, 15 Sep 2019 22:02:38 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717%7]) with mapi id 15.20.2263.023; Sun, 15 Sep 2019
 22:02:38 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH 4/7] crypto: testmgr - Added testvectors for the ofb(sm4)
 & cfb(sm4) skciphers
Thread-Topic: [PATCH 4/7] crypto: testmgr - Added testvectors for the ofb(sm4)
 & cfb(sm4) skciphers
Thread-Index: AQHVaJXTG1IIcgClVUajVRoPFqk+JKcmpF4AgAA2P7CABlpJgIAAGMsg
Date:   Sun, 15 Sep 2019 22:02:38 +0000
Message-ID: <MN2PR20MB2973393F47319C40574BEA3FCA8D0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1568198304-8101-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1568198304-8101-5-git-send-email-pvanleeuwen@verimatrix.com>
 <20190911160545.GA210122@gmail.com>
 <MN2PR20MB29738D497EDEEC9FBBC939F1CAB10@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190915202037.GB1704@sol.localdomain>
In-Reply-To: <20190915202037.GB1704@sol.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 145702d9-485e-4228-3031-08d73a286c15
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2815;
x-ms-traffictypediagnostic: MN2PR20MB2815:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB281509DE658ED8178B832864CA8D0@MN2PR20MB2815.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01613DFDC8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39850400004)(346002)(136003)(376002)(396003)(366004)(13464003)(189003)(199004)(71190400001)(53546011)(6506007)(256004)(6916009)(66556008)(66476007)(446003)(11346002)(5660300002)(76116006)(6436002)(66946007)(478600001)(66446008)(64756008)(99286004)(6116002)(476003)(316002)(3846002)(25786009)(74316002)(71200400001)(53936002)(6246003)(9686003)(305945005)(7736002)(14454004)(33656002)(186003)(229853002)(54906003)(7696005)(102836004)(52536014)(2906002)(86362001)(76176011)(486006)(55016002)(81156014)(81166006)(8676002)(8936002)(66066001)(4326008)(26005)(15974865002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2815;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: tG4S6ltGIO04mcidMctZmKveEjkpves5Quc6UN4Hou0zEPrnnkkur5hlk+xlIk63uL8dFRU+MHAqXiNLnE5xOfFCA6C31PRFXgo/6z8J/AjK8F4w9AWT9r4cnRoEcrxhWeKRNJAhbcT8Z/Su/I8YB+bUhnNPWvCvWx44NRSUAGoAuFmTbAHzAAcD9whqd6Ak6+aEwfFiJMBTYu4Vhy7JeuOdQJpCVH/UbstTc9ianRnngTp2V2292znP4LtmPmB+2t5fHIdPZNkIOle1i/DyVzwtdIi1/0QrMgbhxfOGeZSSHXVck/PSA9IaKBMYWFvp+N1zCRVNlFgXzaewbg8v+RmDPT22eDpfy/C7oLEtiGBoUZNYpGO1Njf+wcnHcTyoX9mCnpLGFcyhzB5kENextGu6bIR9HAP45nEeoRicJhE=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 145702d9-485e-4228-3031-08d73a286c15
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2019 22:02:38.0486
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Mx/sQruZ+YsvYsxwfXlxbK2dwo3rJwmqT/CLad3iiPNYoO19GTmVrhZZua5ayZAdUIfCyS8whl0vz8+yAVNmSrlpBx0ZGyiHH11PogZaUjI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2815
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Eric Biggers <ebiggers@kernel.org>
> Sent: Sunday, September 15, 2019 10:21 PM
> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Cc: Pascal van Leeuwen <pascalvanl@gmail.com>; linux-crypto@vger.kernel.o=
rg;
> antoine.tenart@bootlin.com; herbert@gondor.apana.org.au; davem@davemloft.=
net
> Subject: Re: [PATCH 4/7] crypto: testmgr - Added testvectors for the ofb(=
sm4) & cfb(sm4)
> skciphers
>=20
> On Wed, Sep 11, 2019 at 07:34:31PM +0000, Pascal Van Leeuwen wrote:
> > > -----Original Message-----
> > > From: Eric Biggers <ebiggers@kernel.org>
> > > Sent: Wednesday, September 11, 2019 6:06 PM
> > > To: Pascal van Leeuwen <pascalvanl@gmail.com>
> > > Cc: linux-crypto@vger.kernel.org; antoine.tenart@bootlin.com; herbert=
@gondor.apana.org.au;
> > > davem@davemloft.net; Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> > > Subject: Re: [PATCH 4/7] crypto: testmgr - Added testvectors for the =
ofb(sm4) & cfb(sm4)
> > > skciphers
> > >
> > > On Wed, Sep 11, 2019 at 12:38:21PM +0200, Pascal van Leeuwen wrote:
> > > > Added testvectors for the ofb(sm4) and cfb(sm4) skcipher algorithms
> > > >
> > >
> > > What is the use case for these algorithms?  Who/what is going to use =
them?
> > >
> > > - Eric
> > >
> > SM4 is a Chinese replacement for 128 bit AES, which is mandatory to be =
used for many
> > Chinese use cases. So they would use these whereever you would normally=
 use ofb(aes)
> > or cfb(aes). Frankly, I'm not aware of any practicle use cases for thes=
e feedback
> > modes, but we've been supporting them for decades and apparently the Cr=
ypto API
> > supports them for AES as well. So they must be useful for something ...
> >
> > The obvious advantage over CBC mode was that they only require the encr=
ypt part of
> > the cipher, but that holds for the (newer) CTR mode as well. So, my gue=
ss would be
> > some legacy uses cases from before the time CTR mode and AEAD's became =
popular.
> >
> > Maybe someone remembers why these were added for AES in the first place=
?
> >
>=20
> So if you have no idea why they should be added, why are you adding them?
>
Because our hardware supports these modes and I added support for this to
the inside-secure driver, so it made sense to be able to test that as well.
That's the primary reason for adding them, otherwise I would not have bothe=
red.

> - Eric

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

