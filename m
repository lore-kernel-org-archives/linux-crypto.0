Return-Path: <SRS0=HT46=UT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C68DC43613
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Jun 2019 14:59:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5595320673
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Jun 2019 14:59:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.com header.i=@insidesecure.com header.b="zzy4syCm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbfFTO71 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Jun 2019 10:59:27 -0400
Received: from mail-eopbgr20125.outbound.protection.outlook.com ([40.107.2.125]:38464
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726530AbfFTO71 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Jun 2019 10:59:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=insidesecure.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EXB/O+Cx/nFFjLXhL2uCaOwdfMhR52dXer/egr/lH+g=;
 b=zzy4syCmek8+Q0CW5LtPvZwb3DdEGRFnycaUges2OIlP88R/2EGR641m/tcn2RFj8Z0X9wZDz8vL9GNQ2jMJpJXau1FoJLEWlxSjaI6WG0l+6S+O8OCNPE+sCTQ4Y3WH87cy6PXp7jzjB5WS8q+oN2iUvtkWQGKQO6uPsUk9nnI=
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com (10.255.99.206) by
 AM6PR09MB2728.eurprd09.prod.outlook.com (20.179.0.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Thu, 20 Jun 2019 14:59:20 +0000
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::a44f:9cb2:a373:a6eb]) by AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::a44f:9cb2:a373:a6eb%7]) with mapi id 15.20.1987.014; Thu, 20 Jun 2019
 14:59:20 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
CC:     Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH 3/3] crypto: inside-secure - add support for using the
 EIP197 without firmware images
Thread-Topic: [PATCH 3/3] crypto: inside-secure - add support for using the
 EIP197 without firmware images
Thread-Index: AQHVJaNNu6u4U0xf7kGF/n6JpxvKYaai6XuAgAAgPJCAAX9kAIAAGfRA
Date:   Thu, 20 Jun 2019 14:59:20 +0000
Message-ID: <AM6PR09MB35236CA6971A1B6D03AB9BD4D2E40@AM6PR09MB3523.eurprd09.prod.outlook.com>
References: <1560837384-29814-1-git-send-email-pvanleeuwen@insidesecure.com>
 <1560837384-29814-4-git-send-email-pvanleeuwen@insidesecure.com>
 <20190619122737.GB3254@kwain>
 <AM6PR09MB3523D2FEC3A543FF037812DCD2E50@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190620131512.GB4642@kwain>
In-Reply-To: <20190620131512.GB4642@kwain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a621267e-0b93-4ec5-03a5-08d6f58fdffa
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:AM6PR09MB2728;
x-ms-traffictypediagnostic: AM6PR09MB2728:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <AM6PR09MB2728527C3071527FCB1C80C2D2E40@AM6PR09MB2728.eurprd09.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0074BBE012
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39830400003)(366004)(396003)(376002)(136003)(346002)(199004)(189003)(13464003)(15974865002)(66476007)(11346002)(71190400001)(256004)(53936002)(7736002)(316002)(66574012)(25786009)(6916009)(8936002)(81166006)(68736007)(76116006)(26005)(305945005)(966005)(446003)(71200400001)(73956011)(229853002)(99286004)(76176011)(54906003)(81156014)(6436002)(7696005)(4326008)(486006)(478600001)(8676002)(186003)(33656002)(55016002)(86362001)(6306002)(66946007)(9686003)(66556008)(3846002)(6246003)(66446008)(5660300002)(66066001)(53546011)(52536014)(64756008)(6506007)(102836004)(476003)(2906002)(6116002)(14454004)(74316002)(18886075002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR09MB2728;H:AM6PR09MB3523.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 86wHE3aq+qs++jUmeHUUj0z0Z7Xq3TnF4JFUilB17xMwI/uAzB8INZIWOQXcYFTZHNwMklbp0504tVkYXBIdM+hB11qUiQdYowoyq0HwHxI6f5tBV2bUs2gCb4D/PG8n/vZvd2bqS9I9UhXmAnX+rC/j4vUBUcx+myitnFd/bYhs5E5H3J6At5NUoECXPfNKKzI4ccAsTEjqMSSkuYFafrnNco41Nigg9QfrApamKzZtxWCjn5tluF5Dl5hiEwmAcWsz65DJZB1NHOwTtW7IAlPjAcxlnXFqhdRbvy05u3jw83b8iWhIF/EM1v9sRLlsF+l5Kzh3sfpTFVaXzPWIjqpODWJbZ0fBIhgF8x5yt3IdHMh6jgtc63DA8lfEh8Wq2sdo8qqnsCXmTkwTBXF9YKAViyab9EJ3NjNVr4mChYc=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a621267e-0b93-4ec5-03a5-08d6f58fdffa
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2019 14:59:20.5327
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@insidesecure.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR09MB2728
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Antoine Tenart <antoine.tenart@bootlin.com>
> Sent: Thursday, June 20, 2019 3:15 PM
> To: Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
> Cc: Antoine Tenart <antoine.tenart@bootlin.com>; Pascal van Leeuwen <pasc=
alvanl@gmail.com>; linux-crypto@vger.kernel.org;
> herbert@gondor.apana.org.au; davem@davemloft.net
> Subject: Re: [PATCH 3/3] crypto: inside-secure - add support for using th=
e EIP197 without firmware images
>=20
> Hi Pascal,
>=20
> On Wed, Jun 19, 2019 at 02:37:44PM +0000, Pascal Van Leeuwen wrote:
> > > From: Antoine Tenart <antoine.tenart@bootlin.com>
> > > On Tue, Jun 18, 2019 at 07:56:24AM +0200, Pascal van Leeuwen wrote:
> >
> > > In addition to this, the direction the kernel has taken was to *remov=
e*
> > > binary firmwares from its source code. I'm afraid adding this is a
> > > no-go.
> >
> > For a HW engineer, there really is no fundamental difference between
> > control register contents or an instruction word. They can both have
> > the exact same effects internal to the HW.
> > If I had disguised this as a handful of config reg writes writing
> > some #define'd magic values, probably no one would have even noticed.
>=20
> I do not fully agree. If this is comparable to configuring h/w
> registers, then you could probably have defines explaining why each bit
> is set and what it's doing. Which would be fine.
>=20
Strictly speaking, we (and probably most other HW vendors as well) don't do=
=20
that for every register bit either, not even in the official Programmer Man=
ual.=20
Some bits are just "you don't need to know, just write this" :-)

But I get your point.

> > By that same definition, the tokens the driver generates for
> > processing could be considered "firmware" as well (as they are used by
> > the hardware in a very similar way) ...
>=20
> Right. The main difference here is we do have a clear definition of what
> the tokens are doing. Thanks to your explanation, if this firmware is
> really looking like the token we're using, the words have a defined
> structure and the magic values could be generated with proper defines
> and macros. And I think it's the main issue here: it's not acceptable to
> have an array of magic values. If you can give a meaning to those bits,
> I see no reason why it couldn't be added to the driver.
>=20
> (And I'm all for what you're trying to achieve here :)).
>=20
Now we're reaching a tricky subject. Because I think if some people here
find out those token bits are explicitly documented in the driver, they
will not be so happy ... (don't worry, I won't wake any sleeping dogs :-)
We provide this information to our customers under NDA, but it's=20
obviously quite sensitive information as it reveals a lot about the
inner workings of our HW design.

The encoding of the microengine control words is considered even
more sensitive, so we don't even provide that under NDA.
Adding that to the driver will probably get me in trouble.

So maybe putting these images in /lib/firmware is unavoidable, but
I'd really like to hear some more opinions on that subject.

> > > The proper solution I believe would be to support loading this "MiniF=
W",
> > > which (depending on the license) could be either distributed in the
> > > rootfs and loaded (like what's done currently), or through
> > > CONFIG_EXTRA_FIRMWARE.
> > >
> > That seems total overkill for just a handful of words though.
>=20
> Given your explanation, I agree. (If those bits can have meaning).
>=20
> Thanks!
> Antoine
>=20
> --
> Antoine T=E9nart, Bootlin
> Embedded Linux and Kernel engineering
> https://bootlin.com

Thanks,

Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Inside Secure
www.insidesecure.com

