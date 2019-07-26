Return-Path: <SRS0=5D8e=VX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0156C7618B
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 12:28:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B4EB22C7E
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 12:28:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="AM0Bwkhp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbfGZM23 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jul 2019 08:28:29 -0400
Received: from mail-eopbgr760057.outbound.protection.outlook.com ([40.107.76.57]:17677
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726277AbfGZM23 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jul 2019 08:28:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hx04EINrs4x+21XZMX3t1ttxbQasa4D7kNDMMQ+iVyg1Na4L8al0N6RHc1rZZPcUgfhnlVh5GALOm6LTytj23NG8GjhH1kCi4xhEKCcVdmBQHRF7ibN7Ko0hNaMYUfqunrvq7Pws2aH7pxdmmCvugsDyX27s3YZN3R+wuFa0HwAGnQ3XQIJExjpyecTsaLkHNJRd+fghtWuV4MUGKHInXGWFHwd0ozTpdjbaRE63xyvNNTeJnIYEhWa7g9PzbyJLu6m0bQJAmRUtOfXY+Nciw4fV7UWx1jYBJXptQ00VZjG9qPFClwWhxWJK/v3OSAmwH/xMk1WKV/di1M26DQBQ9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DF/5LmfsUzrWe2AKFwg4zNeenneeKUlsN4hYnCZAhcs=;
 b=lKzo2xPNREnF8Mdqs4eZlohXQjBrU52Gjq8HaOvUYpVuVOK07J4uGB/a8kyOIlOHypfMubAvFh2AnPaOqRxc6Lk3EtXMR+pXCdw5AJhzmRH3Ey4WSROAQ3vQvT3baQzH4k6VsoUM3KOtLxEwOn3HTq+aufmRidKpwuyKoc2r1M/NSdV82GXpMU2qx8KJGISoaJL1+B/V0QG4ilzBtCTY/tRBl2VPI/NPDZBw6ozvad2RovjY2XzIWaj/0r0sB38qBAkTlfbIJXeIaavcRuslqPBp9+Gw1ToImYHi6MD97GuxEVBmGvwdAGxwq6SeYYrI4hEvaCvM8rFVfJX4bxlfAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DF/5LmfsUzrWe2AKFwg4zNeenneeKUlsN4hYnCZAhcs=;
 b=AM0BwkhprLx8wCTeUUHu8JX+saBAf2g+mQ/bmCfpc1tlRBxayfJLS1RLn8WrnRthC7fD3MARIgo2h8/Z2L0HrdYnqtQNqP7RtIVHV+pKuOsgO9rN4AnOtAyU+wwEiaRkIaLgorNmlR1bPICy1qSLl1YZkY16TRLub0P4wkbvpyg=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2320.namprd20.prod.outlook.com (20.179.145.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Fri, 26 Jul 2019 12:28:26 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69%6]) with mapi id 15.20.2094.017; Fri, 26 Jul 2019
 12:28:26 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCHv2 0/3] crypto: inside-secure - broaden driver scope
Thread-Topic: [PATCHv2 0/3] crypto: inside-secure - broaden driver scope
Thread-Index: AQHVK2PPZerQVZ6WRkuW8hpHhbt/sKbc9NLQgAAISQCAAAWVQA==
Date:   Fri, 26 Jul 2019 12:28:26 +0000
Message-ID: <MN2PR20MB29736E689B55F3D17B7CB9B0CAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1561469816-7871-1-git-send-email-pleeuwen@localhost.localdomain>
 <MN2PR20MB2973DAAEF813270C88BB941CCAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190726120206.GB3235@kwain>
In-Reply-To: <20190726120206.GB3235@kwain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6daf214d-63f9-495b-aa04-08d711c4c25d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2320;
x-ms-traffictypediagnostic: MN2PR20MB2320:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB232030FBA6023CA421E54FD5CAC00@MN2PR20MB2320.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01106E96F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39850400004)(376002)(366004)(346002)(136003)(13464003)(199004)(189003)(55016002)(66476007)(86362001)(9686003)(66946007)(66556008)(64756008)(26005)(102836004)(305945005)(7736002)(3846002)(2501003)(76116006)(5640700003)(6116002)(4326008)(99286004)(6246003)(6436002)(52536014)(5660300002)(53936002)(66066001)(7696005)(76176011)(66446008)(316002)(229853002)(68736007)(486006)(8676002)(14454004)(71190400001)(71200400001)(15974865002)(476003)(66574012)(33656002)(2906002)(478600001)(81166006)(6916009)(6506007)(81156014)(446003)(74316002)(8936002)(14444005)(186003)(256004)(25786009)(54906003)(53546011)(11346002)(2351001)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2320;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: qi2fCr7Agnqe29VGIxoVLe0DTui4ybHFmCt9bxwIHVm/NY3n/OUReOOIPVrJqZPEmZX1Ci2w/vl+u+gpA+50gK1nZ2748pfPyLILdy3KaAX1DjNwYi9SqLnpQoBmv0ZeuqX+9crW/y/a+lb/ND61BlTYoSS2LL5qXqIJSsTeTPmKCHH1ovUl4hy6ssYeUy1UgIf1ldvNzo9MjBDkPSdHe5UWaJEvG0iYwXXf9vGBYM0u+TEmhxgEBRNmSriPLNeY7Pq+L5EgOUiLuxYvSCisbnTtX0Vqkab0HwoM6ufuRAVLZ2RCJnCZMiJwvfcKMt/ZkIF3G600Zx1M0BdV3jaLxkewZnGBsvTWx5lJ4BjhKg5PV1zBDPxEC+0wHyWqc8pPFjyYXw2HvRcrpS5cZrDKxJMsEdrADlK5hKirW14yrlM=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6daf214d-63f9-495b-aa04-08d711c4c25d
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2019 12:28:26.7355
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2320
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Antoine,

> -----Original Message-----
> From: antoine.tenart@bootlin.com <antoine.tenart@bootlin.com>
> Sent: Friday, July 26, 2019 2:02 PM
> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Cc: linux-crypto@vger.kernel.org; antoine.tenart@bootlin.com; herbert@gon=
dor.apana.org.au; davem@davemloft.net
> Subject: Re: [PATCHv2 0/3] crypto: inside-secure - broaden driver scope
>=20
> Hi Pascal,
>=20
> On Fri, Jul 26, 2019 at 11:33:07AM +0000, Pascal Van Leeuwen wrote:
> >
> > Just a gentle ping to remind people that this patch set - which incorpo=
rates the feedback I
> > got on an earlier version thereof - has been pending for over a month n=
ow without
> > receiving any feedback on it whatsoever ...
>=20
> I do not recall seeing this series and somehow I cannot find it in any
> of my mailboxes or in patchwork. Would you care to send it again ?
>=20
> I'm not sure if the issue with this series is on my side or if there was
> an issue while sending it.
>=20
I can resend them as is, but I'm afraid I will then I will face the same pr=
oblem of=20
them not being added to patchwork ...

> Thanks!
> Antoine
>=20
> > > From: Pascal van Leeuwen <pvanleeuwen@insidesecure.com>
> > >
> > > This is a first baby step towards making the inside-secure crypto dri=
ver
> > > more broadly useful. The current driver only works for Marvell Armada=
 HW
> > > and requires proprietary firmware, only available under NDA from Marv=
ell,
> > > to be installed. This patch set allows the driver to be used with oth=
er
> > > hardware and removes the dependence on that proprietary firmware.
> > >
> > > changes since v1:
> > > - changed dev_info's into dev_dbg to reduce normal verbosity
> > > - terminate all message strings with \n
> > > - use priv->version field strictly to enumerate device context
> > > - fixed some code & comment style issues
> > > - removed EIP97/197 references from messages
> > > - use #if(IS_ENABLED(CONFIG_PCI)) to remove all PCI related code
> > > - use #if(IS_ENABLED(CONFIG_OF)) to remove all device tree related co=
de
> > > - do not inline the minifw but read it from /lib/firmware instead
> > >
> > > Pascal van Leeuwen (3):
> > >   crypto: inside-secure - make driver selectable for non-Marvell
> > >     hardware
> > >   crypto: inside-secure - add support for PCI based FPGA development
> > >     board
> > >   crypto: inside-secure - add support for using the EIP197 without
> > >     vendor firmware
> > >
> > >  drivers/crypto/Kconfig                         |  12 +-
> > >  drivers/crypto/inside-secure/safexcel.c        | 748 +++++++++++++++=
++--------
> > >  drivers/crypto/inside-secure/safexcel.h        |  36 +-
> > >  drivers/crypto/inside-secure/safexcel_cipher.c |  11 -
> > >  drivers/crypto/inside-secure/safexcel_hash.c   |  12 -
> > >  drivers/crypto/inside-secure/safexcel_ring.c   |   3 +-
> > >  6 files changed, 569 insertions(+), 253 deletions(-)
> > >
> > > --
> > > 1.8.3.1
>=20
> --
> Antoine T=E9nart, Bootlin
> Embedded Linux and Kernel engineering
>

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
