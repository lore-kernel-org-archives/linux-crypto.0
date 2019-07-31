Return-Path: <SRS0=mqYf=V4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53079C32751
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 10:11:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 150A320657
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 10:11:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="vvvqay8N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbfGaKLu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 31 Jul 2019 06:11:50 -0400
Received: from mail-eopbgr800058.outbound.protection.outlook.com ([40.107.80.58]:63568
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725914AbfGaKLt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Jul 2019 06:11:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hfvIbtCS+8ZnQ+nneJf+fuJA4MpEJXeHJT1Fx68anTEuYbJMxMUhxZRRo/qlqIp6vzV0Pz7G9EAJ7l6forl9AR6Zoilps9uhoM4ahA80WXJXo7X+QeY3gLkDD7BagXMcGESMEDJkxEtaT89cBSUjLr1VX8Cj0oELqC7zFCDk3EEyo241TIoY+Y8buRq/Gzta6D60EZUekZwB5GoTguTGlMOXI2f3Qt+o5ifNu1+AzkWGLc0uJuI5nv3WwnHb4ELIDgEpQ5BfoBrm9xopiCNooN4Klb+bEjA3xFn5NlZPeTg4i3f4AnL+KFIKI+nt9XKDrCCSMALy1JWqxUqODrMRvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bm8pV8ZIwBp/B9CWNhZ6h4EQbtDjyp9EJjXJoArGC6k=;
 b=cvJ5AMfqPHLjy6/wFdcIKsdv/+OBc5MAW3CQuxm9XiyacKV39Q6fF1PLJHaArG6nTRKnXHb2lgavhq0YjvLOM3NZ4C3smhQEwee/FBhPtDzAKisz1kwpO1CiBTqPA0udCiI7zcKsvOIVVEu7yeX1zGDj6c2fcvYhn2F7UDGqFAnQrjQTlpKSyPz5XtLTKz+fXzS97eTkRszVx/s+hHw2WzmhTt6FQUmIIqErgpJuLAuMxlPQYqGphX0AkzPdYrZjxM+NzT5NjfMiwmcjgR2En4q9I7AiPK5FnVE26sMzOPjcskyhVpauR1SvsF++nAJRRyyaPm5jMo0+FQ4i3R3Uaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bm8pV8ZIwBp/B9CWNhZ6h4EQbtDjyp9EJjXJoArGC6k=;
 b=vvvqay8NDRS6cbaRhu0Jl919X+/AgiXoxK20I7uhVHQnaEBEQTAeepQocg96M6fO8hhXW/5ZZTHOezhDcldU8FIPQazOHXADYTaCuQWRNyjwaED1JsqZjEVXPPx/ipl0rvlRz7BrJiBD98Hb0jL5KPKtGPMlLYLIJkTxuUH7QiU=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2432.namprd20.prod.outlook.com (20.179.145.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Wed, 31 Jul 2019 10:11:46 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2115.005; Wed, 31 Jul 2019
 10:11:46 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCHv2 2/3] crypto: inside-secure - add support for PCI based
 FPGA development board
Thread-Topic: [PATCHv2 2/3] crypto: inside-secure - add support for PCI based
 FPGA development board
Thread-Index: AQHVQ7iGiGasvxZ/1k28+z4dWUzE9abi5S6AgAAAqWCAAaFIAA==
Date:   Wed, 31 Jul 2019 10:11:46 +0000
Message-ID: <MN2PR20MB29734DDABC5D2812EAFEFBABCADF0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1564145005-26731-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1564145005-26731-3-git-send-email-pvanleeuwen@verimatrix.com>
 <20190730090811.GF3108@kwain>
 <MN2PR20MB2973B37C90FBD6E6C97B8E09CADC0@MN2PR20MB2973.namprd20.prod.outlook.com>
In-Reply-To: <MN2PR20MB2973B37C90FBD6E6C97B8E09CADC0@MN2PR20MB2973.namprd20.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9bf04859-3c82-414b-11a9-08d7159f7ec7
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MN2PR20MB2432;
x-ms-traffictypediagnostic: MN2PR20MB2432:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <MN2PR20MB2432CAEF51C1AF7C648710E0CADF0@MN2PR20MB2432.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 011579F31F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(366004)(39850400004)(346002)(136003)(189003)(199004)(13464003)(478600001)(6246003)(9686003)(14454004)(966005)(74316002)(55016002)(53936002)(6306002)(4326008)(68736007)(81166006)(7736002)(8676002)(81156014)(8936002)(229853002)(316002)(33656002)(6436002)(110136005)(25786009)(2906002)(54906003)(76116006)(66446008)(64756008)(66556008)(66476007)(66946007)(66574012)(5660300002)(99286004)(66066001)(256004)(52536014)(71200400001)(71190400001)(15974865002)(14444005)(86362001)(3846002)(6116002)(7696005)(446003)(476003)(76176011)(102836004)(53546011)(6506007)(305945005)(486006)(186003)(26005)(11346002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2432;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: VVHeq9W0Zd3pl2bIXSHuTJcsFDlDZ9N2u5BMA/QlZJjs/iWKtt1DB6m5c1yFsiafk7aS64K7XPpvS2ZNVgVtFfNA7+aqJvc86X5F68NpKmkXjBwcbZuXkkr78iUZ/npDOtD+6g7Q/zqWGnst/Oi9GgQDvM0ppgFRXCjOTRDBsmMyxRbkCLor4Ip26xV6myTodWMY2e009/2pIRg/pZriDUWH2b8TeOpa8PGHENnHfk2LAGv8UAISjU+PrCwByW3vBISIsX3x1oabhCEOjIBj8fhJnFTVyCHSjScxUrzPC/hRoGdRtAbbMlquhxLdNnAzStoHxYYEQyYSu4Bd4dtEPyKLSsVY9a0HBdtMWiaIVciD0mcZpnFVXqy+ZRUW0AfO5HUExOdW30tELMRqR+3vfgMZI/cj+eBP3JzymFV0IFo=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bf04859-3c82-414b-11a9-08d7159f7ec7
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2019 10:11:46.5894
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2432
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.=
org> On Behalf Of
> Pascal Van Leeuwen
> Sent: Tuesday, July 30, 2019 12:21 PM
> To: Antoine Tenart <antoine.tenart@bootlin.com>; Pascal van Leeuwen <pasc=
alvanl@gmail.com>
> Cc: linux-crypto@vger.kernel.org; herbert@gondor.apana.org.au; davem@dave=
mloft.net
> Subject: RE: [PATCHv2 2/3] crypto: inside-secure - add support for PCI ba=
sed FPGA
> development board
>=20
>=20
> > > +static int __init crypto_is_init(void)
> > > +{
> > > +	int rc;
> > > +
> > > +	#if (IS_ENABLED(CONFIG_OF))
> > > +		/* Register platform driver */
> > > +		platform_driver_register(&crypto_safexcel);
> > > +	#endif
> >
> > When used in the code directly, you should use:
> >
> >   if (IS_ENABLED(CONFIG_OF))
> >
> Oops, I missed that one, will fix.
>=20
Actually, I tried that first, but it doesn't work in this particular case.=
=20
The #if is really necessary here to avoid compile errors due to=20
references to datastructures that are within another #if ... (which refer
to functions with the #if etc. so it's a whole dependency chain)

This seemed to be the best way to handle it, but any suggestions that
take into account the big picture are welcome!

> > Thanks!
> > Antoine
> >
> > --
> > Antoine T=E9nart, Bootlin
> > Embedded Linux and Kernel engineering
> > https://bootlin.com
>=20
> Thanks,
> Pascal van Leeuwen
> Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
> www.insidesecure.com

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
