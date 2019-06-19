Return-Path: <SRS0=zZ2Z=US=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB454C31E49
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Jun 2019 14:37:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F65920679
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Jun 2019 14:37:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.com header.i=@insidesecure.com header.b="YkGL+lBd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbfFSOhx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 Jun 2019 10:37:53 -0400
Received: from mail-eopbgr70120.outbound.protection.outlook.com ([40.107.7.120]:64894
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726496AbfFSOhx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Jun 2019 10:37:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=insidesecure.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sFbgzOIhOeRw780owLlX6Q6JUUcDBn5H5pco1du8hvg=;
 b=YkGL+lBdtK4davo0ap/ACvw3HinUwrkKASDsRhIIN7n4sOGi/8ZUHaSjq5gEDOqZ3NImAmzOyzr3rGvCK/UGHhyfYk1jTf0WOpoTg8Hf1oW6JHRPtbHu0eaeFmV6eaXi8wmqPyqkTafMIvttIX7EDKH6rKrVMlzGnSvM+vDYhlg=
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com (10.255.99.206) by
 AM6PR09MB3432.eurprd09.prod.outlook.com (20.179.246.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.10; Wed, 19 Jun 2019 14:37:44 +0000
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::a44f:9cb2:a373:a6eb]) by AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::a44f:9cb2:a373:a6eb%7]) with mapi id 15.20.1987.014; Wed, 19 Jun 2019
 14:37:44 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
To:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH 3/3] crypto: inside-secure - add support for using the
 EIP197 without firmware images
Thread-Topic: [PATCH 3/3] crypto: inside-secure - add support for using the
 EIP197 without firmware images
Thread-Index: AQHVJaNNu6u4U0xf7kGF/n6JpxvKYaai6XuAgAAgPJA=
Date:   Wed, 19 Jun 2019 14:37:44 +0000
Message-ID: <AM6PR09MB3523D2FEC3A543FF037812DCD2E50@AM6PR09MB3523.eurprd09.prod.outlook.com>
References: <1560837384-29814-1-git-send-email-pvanleeuwen@insidesecure.com>
 <1560837384-29814-4-git-send-email-pvanleeuwen@insidesecure.com>
 <20190619122737.GB3254@kwain>
In-Reply-To: <20190619122737.GB3254@kwain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bc2b27ff-a9cb-4617-1bdd-08d6f4c3b13a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:AM6PR09MB3432;
x-ms-traffictypediagnostic: AM6PR09MB3432:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <AM6PR09MB343291B909F289469DBB365AD2E50@AM6PR09MB3432.eurprd09.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0073BFEF03
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(376002)(136003)(346002)(39850400004)(51914003)(13464003)(199004)(189003)(229853002)(53546011)(4326008)(6506007)(11346002)(52536014)(256004)(26005)(14444005)(66066001)(2906002)(966005)(66574012)(316002)(54906003)(15974865002)(102836004)(110136005)(186003)(478600001)(86362001)(3846002)(6116002)(71200400001)(71190400001)(14454004)(5660300002)(486006)(81166006)(6246003)(476003)(81156014)(305945005)(7736002)(33656002)(66556008)(64756008)(66476007)(66946007)(66446008)(73956011)(76116006)(8936002)(74316002)(6436002)(68736007)(99286004)(55016002)(25786009)(6306002)(9686003)(446003)(76176011)(53936002)(7696005)(8676002)(18886075002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR09MB3432;H:AM6PR09MB3523.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: OQdyRIa/Xan7ZETY55BZi5nRv/NmHw/iUkpl50Zi7GwMCdzGIR2n2eG1ryM+4yoSBY+y5RrZnKqju0PRd7ADdCag0wAgbdGyJOndDndhDPnkkbapteJexWemJNm/1pPceoBUPz/4ebOIFk4wU7TI0TJcpZoshu9HtkSrtjqMUQK6JZJWvrOhnSL6A9e/vJ6hwE+0sW6YtqUK16MnVpM8ke14XhA/LwBPMrUdg5kegO+jYhzW4bWyd50n0H3AJS8Lkgi4di78QJ1jF8SOMC+YvfPP+i+b+6AOwu5eDQojsTeabz0tJOSuLKggG0q8ESIMM7bbUrjme5XGvg/rHNEV821B08tz78u2EkGWJ0/45d8LTqgyXi+18kX/CxBioLcCQwr2LJvl/KcA7rDHfi4Eockg0AEOrxJyG2UHIgkoOws=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc2b27ff-a9cb-4617-1bdd-08d6f4c3b13a
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2019 14:37:44.6560
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@insidesecure.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR09MB3432
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Thanks for the comments!

> -----Original Message-----
> From: Antoine Tenart <antoine.tenart@bootlin.com>
> Sent: Wednesday, June 19, 2019 2:28 PM
> To: Pascal van Leeuwen <pascalvanl@gmail.com>
> Cc: linux-crypto@vger.kernel.org; antoine.tenart@bootlin.com; herbert@gon=
dor.apana.org.au;
> davem@davemloft.net; Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
> Subject: Re: [PATCH 3/3] crypto: inside-secure - add support for using th=
e EIP197 without
> firmware images
>=20
> Hi Pascal,
>=20
> On Tue, Jun 18, 2019 at 07:56:24AM +0200, Pascal van Leeuwen wrote:
> >
> >  static int eip197_load_firmwares(struct safexcel_crypto_priv *priv)
> >  {
> > +	/*
> > +	 * The embedded one-size-fits-all MiniFW is just for handling TR
> > +	 * prefetch & invalidate. It does not support any FW flows, effective=
ly
> > +	 * turning the EIP197 into a glorified EIP97
> > +	 */
> > +	const u32 ipue_minifw[] =3D {
> > +		 0x24808200, 0x2D008204, 0x2680E208, 0x2780E20C,
> > +		 0x2200F7FF, 0x38347000, 0x2300F000, 0x15200A80,
> > +		 0x01699003, 0x60038011, 0x38B57000, 0x0119F04C,
> > +		 0x01198548, 0x20E64000, 0x20E75000, 0x1E200000,
> > +		 0x30E11000, 0x103A93FF, 0x60830014, 0x5B8B0000,
> > +		 0xC0389000, 0x600B0018, 0x2300F000, 0x60800011,
> > +		 0x90800000, 0x10000000, 0x10000000};
> > +	const u32 ifpp_minifw[] =3D {
> > +		 0x21008000, 0x260087FC, 0xF01CE4C0, 0x60830006,
> > +		 0x530E0000, 0x90800000, 0x23008004, 0x24808008,
> > +		 0x2580800C, 0x0D300000, 0x205577FC, 0x30D42000,
> > +		 0x20DAA7FC, 0x43107000, 0x42220004, 0x00000000,
> > +		 0x00000000, 0x00000000, 0x00000000, 0x00000000,
> > +		 0x00060004, 0x20337004, 0x90800000, 0x10000000,
> > +		 0x10000000};
>=20
> What is the license of this firmware? With this patch, it would be
> shipped with Linux kernel images and this question is then very
> important.
>=20
I am very well aware of that. The driver under GPL 2.0 so that simply
would also apply to this. This was written by me specifically for this
particular driver anyway and my company allows me to GPL this stuff.

> In addition to this, the direction the kernel has taken was to *remove*
> binary firmwares from its source code. I'm afraid adding this is a
> no-go.
>=20
Actually, I would like to argue against that here.

For a HW engineer, there really is no fundamental difference between
control register contents or an instruction word. They can both have
the exact same effects internal to the HW.
If I had disguised this as a handful of config reg writes writing=20
some #define'd magic values, probably no one would have even noticed.

This is not firmware for some general purpose CPU, it is firmware=20
for some very dedicated microengine thingy controlling some local
datapath. By that same definition, the tokens the driver generates
for processing could be considered "firmware" as well (as they are
used by the hardware in a very similar way) ...

> The proper solution I believe would be to support loading this "MiniFW",
> which (depending on the license) could be either distributed in the
> rootfs and loaded (like what's done currently), or through
> CONFIG_EXTRA_FIRMWARE.
>=20
That seems total overkill for just a handful of words though.
But I can do that if the community insists ...

> This should be discussed first before discussing the implementation of
> this particular patch.
>=20
> Thanks!
> Antoine
>=20
> --
> Antoine T=E9nart, Bootlin
> Embedded Linux and Kernel engineering
> https://bootlin.com


Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Inside Secure
www.insidesecure.com
