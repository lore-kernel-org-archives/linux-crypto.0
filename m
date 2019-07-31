Return-Path: <SRS0=mqYf=V4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86B0EC433FF
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 11:37:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46B942089E
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 11:37:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="Xnmu1xfk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbfGaLhO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 31 Jul 2019 07:37:14 -0400
Received: from mail-eopbgr680083.outbound.protection.outlook.com ([40.107.68.83]:41768
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726396AbfGaLhN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Jul 2019 07:37:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ggdl9eFM+mab0bRUHOEtO9XaqM+dUM0LAFVek2Rw0MsbPmT/FsEhaAfraDolCp89sRYPL45IUw+pmPsDl4ULDp7CApDfZv7Dy8fJkzQxklvUMqHTy63Ekf0ySZgBCVPGqwXU4EoycpqH87a9XU6KipMHPiTm6nUDabA2NIVhhfdjIHW5UEs75xGwSt9hagGx1OawYiS2h1KQkNF6zZC2CnM+AzZG6TPl8z1B219jzODqB8E9JGzeGunAJDKqQF57KSaJYyFWAIaykp9yv/wfSVTtuhdooTEmJq+no7p3IOmyXKZqHUv+HGMkQq8nXvFS5pNFbUu6emX4Eq8iwEqWzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3yoOaXqP85pO2VmKQM/3CTqBFMy6n4mzQPx01OqDkmI=;
 b=TEzDlw9t0P6ed0r0jZx0GKGjAl0cEZHpAVzj2q9k+TzsIPkLlgCZaglUQsjkeHTDXyjSTdq1JzzISt0akw/i7rqC4fUx6xcpH3StkKpta663uitx57mWBsha2NqweWcgSlpNkKHEWb5aVmNG6YQUYO7mK041MoHjk4QKuF/X2/3tgZmSYxcgdEDP3iNJ1EdHBRbNueqmclobM0LlG38/rb0AbS/qKUUahfKCifR+XT/wtI8G0M/FO9jjfdFPUQYOH5QsdqlIYW4ubYMsPDh6r351qbS7+RDF2YCI+l+uzD9qcTz1tWvNNGF37rRTAFouWvW1whNecBWngmyVQsTaSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3yoOaXqP85pO2VmKQM/3CTqBFMy6n4mzQPx01OqDkmI=;
 b=Xnmu1xfkvUTkCy9+KrhFx2l3TGAOjaS9dwaffbsaO58GGN2gcLgIRE898v/g82nCwSyGejlHIppksvfnJlpsCulsvIq7/08JH3J5RzDyUd9+VNFbB9yHvOIpgh8hjZFsk0/A5RZWZFpD/RbicKBJLXef98FSuj2f4U4nInWOWgE=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2495.namprd20.prod.outlook.com (20.179.144.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.14; Wed, 31 Jul 2019 11:37:09 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2115.005; Wed, 31 Jul 2019
 11:37:08 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCHv2 2/3] crypto: inside-secure - add support for PCI based
 FPGA development board
Thread-Topic: [PATCHv2 2/3] crypto: inside-secure - add support for PCI based
 FPGA development board
Thread-Index: AQHVQ7iGiGasvxZ/1k28+z4dWUzE9abi5S6AgAAAqWCAAaFIAIAAEdEAgAABQFA=
Date:   Wed, 31 Jul 2019 11:37:08 +0000
Message-ID: <MN2PR20MB29731297E57536B08BF82A56CADF0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1564145005-26731-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1564145005-26731-3-git-send-email-pvanleeuwen@verimatrix.com>
 <20190730090811.GF3108@kwain>
 <MN2PR20MB2973B37C90FBD6E6C97B8E09CADC0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <MN2PR20MB29734DDABC5D2812EAFEFBABCADF0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190731110750.GA20643@gondor.apana.org.au>
In-Reply-To: <20190731110750.GA20643@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 42cadadd-79a8-4e78-1c7d-08d715ab6be4
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2495;
x-ms-traffictypediagnostic: MN2PR20MB2495:
x-ms-exchange-purlcount: 3
x-microsoft-antispam-prvs: <MN2PR20MB24950B8CE14176BF11CA8CE8CADF0@MN2PR20MB2495.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 011579F31F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39850400004)(136003)(346002)(366004)(396003)(376002)(13464003)(199004)(189003)(33656002)(86362001)(486006)(256004)(305945005)(6916009)(3846002)(74316002)(66066001)(76116006)(186003)(2906002)(68736007)(66556008)(64756008)(476003)(66476007)(66446008)(54906003)(52536014)(66946007)(81156014)(81166006)(11346002)(8936002)(446003)(6116002)(7696005)(966005)(229853002)(14454004)(478600001)(6436002)(102836004)(99286004)(5660300002)(25786009)(6246003)(4326008)(8676002)(316002)(53546011)(6506007)(7736002)(26005)(6306002)(55016002)(9686003)(76176011)(15974865002)(71190400001)(71200400001)(53936002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2495;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: n/Whp2Bp3U8/ac77YdvR/XSkwPajXBSJ9qCXnCVrBGwQ9+XJuhDr4XE/DU07+NsGfRlET9b4cC0P3CaSqNZLpwWM6rIyLEQXHEVmuUpBn7oOozOKM2CmqtQdyNeEsPiBP929sjtpuorQ5NbnfT1dQ6cYweLUej9WqFHD7IJIPG+SelbCgPTkYEQMGV5rOUNHBoUHe+mk4IUqN3wigUlC3ybGOrVNGogKxUw0YG/iHkMX87TuGTT+Q/0yXAdcNEEQ8I/AcQHB0n50dtMydBLNZEsPwkY88x837DJfshyM6/Vp9OK4bNhBccxZOa7v2JI4ukEYyznlDXPjAMtNOnkEXxxn3Y8BWoG9EtwGSUxG3rrKKem/4BNjVQ4mKm3gFdB0y7ZskXucx7A3q8IGmHC9OK5m8DWhRZmd4UVA0m2LPQg=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42cadadd-79a8-4e78-1c7d-08d715ab6be4
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2019 11:37:08.5209
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2495
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Wednesday, July 31, 2019 1:08 PM
> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Cc: Antoine Tenart <antoine.tenart@bootlin.com>; Pascal van Leeuwen
> <pascalvanl@gmail.com>; linux-crypto@vger.kernel.org; davem@davemloft.net
> Subject: Re: [PATCHv2 2/3] crypto: inside-secure - add support for PCI ba=
sed FPGA
> development board
>=20
> On Wed, Jul 31, 2019 at 10:11:46AM +0000, Pascal Van Leeuwen wrote:
> >
> > > > > +static int __init crypto_is_init(void)
> > > > > +{
> > > > > +	int rc;
> > > > > +
> > > > > +	#if (IS_ENABLED(CONFIG_OF))
> > > > > +		/* Register platform driver */
> > > > > +		platform_driver_register(&crypto_safexcel);
> > > > > +	#endif
> > > >
> > > > When used in the code directly, you should use:
> > > >
> > > >   if (IS_ENABLED(CONFIG_OF))
> > > >
> > > Oops, I missed that one, will fix.
> > >
> > Actually, I tried that first, but it doesn't work in this particular ca=
se.
> > The #if is really necessary here to avoid compile errors due to
> > references to datastructures that are within another #if ... (which ref=
er
> > to functions with the #if etc. so it's a whole dependency chain)
>=20
> If you're going to use a #if then please don't indent it as that's
> not the kernel coding style.
>=20
Ok, I can do that

> I see why you can't use a straight "if" because you've moved
> crypto_safexcel inside a #if, but what if you got rid of that
> #if too?
>
Then it won't compile either because it references stuff outside of the=20
module that don't exist. Originally (previous version of the patch) I=20
had a different solution removing those function bodies using regular=20
if's but for some reason I don't remember anymore that didn't fly and=20
I had to change it into this.

> IOW what would it take to make the probe function compile
> with CONFIG_OF off?
>=20
That's how I came up with the current code using #if's. If anyone has a=20
better solution, I'm happy to hear it. But I don't really want to spend
more time on it doing trial-and-error and not getting anywhere.

> In general we want to maximise compiler coverage under all config
> options so if we can make it compiler without too much effort that
> would be the preferred solution.
>
I understand that, and I tried to do that initially, but that wouldn't
work so I ended up with this as a compromise ...

> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

