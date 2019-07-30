Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F374C0650F
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 10:20:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E6FD206E0
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 10:20:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="igeKEju/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729091AbfG3KUs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jul 2019 06:20:48 -0400
Received: from mail-eopbgr740058.outbound.protection.outlook.com ([40.107.74.58]:19376
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728378AbfG3KUr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jul 2019 06:20:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eGfAw3iGLQtTb/DEEYbNE57nF14JsQ9/t/JW8pzJQyipT9/RWT7/sdSEC+da84zMEFLWD89cFH8/5KCSqY/30FY3ahpDskBj6zenJXj5dzbDgl38vqFJgHtnJ+CZxKeZj1r0ExkA9B5XFkrKBtLnzB+FHci3+QzU6tyZy52n12TBzsYPAOvA6eVe1635O2sg6iMlVkLGWnQeTc3Dhf1hcd6zRU0S6fLZxYCDtsilfO4mfVDjZDfSPCYxLiTUMjCbSh7VxZjuBK6QPRostgwh8KlFoDNMMIpJMVIw/TH0iY2hkFW7UfWIWyJgTCN4iOwiu5937pi4QxhTBysvG3mSSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DcvyU0/VNvEjGNUGNnmxvKK2WZY3Rrabsv+D+JspSPY=;
 b=KsN3STeLXRXIZJDMS7dI6bcjdhhxMbMMeBXDMzSgXse5wHjuX0DRzyNyuc3MStWAgPtsUvVUpNlrjq0KlBV1STFcoE68b4F7ev6IWxr052tr37dN6iQKkDdcE4mnAguUb32fGU/KvGl4yNlYLte32OEv1TLb93FMXgqcfQqHAL4Jp2MIET/8ArWTn1gT/fy9N1/gGGw6NYn8P+4qWZX29yebCtrjVQB8MhGjnjjdwmUlk63S11rLmrZAgXKN/2v7mi60RIjXYVleJOD8NUe7KDVmXl4QEL/GlGfQFG+x9ldRD4I0V22BM4ecQLvxoaH4kvJ3Vbq0wr1XyhL3rzrsZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DcvyU0/VNvEjGNUGNnmxvKK2WZY3Rrabsv+D+JspSPY=;
 b=igeKEju/7WVLCawcbDlf//S8UYqD5bGW3Wd9BeSSUyXCJCg6+0WdjQ5Uq9jxGT4+RRdjRUrzkJSRKSMDfacIL1gLtATV8a4C9hHveKuyi7688Zpf74G263vk9HNoO8aHCNe3eDwYgz+FMxFp9tZ6/Of5HH9jIXS/1XQEvDPsFcY=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB3088.namprd20.prod.outlook.com (52.132.174.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Tue, 30 Jul 2019 10:20:44 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2115.005; Tue, 30 Jul 2019
 10:20:43 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCHv2 2/3] crypto: inside-secure - add support for PCI based
 FPGA development board
Thread-Topic: [PATCHv2 2/3] crypto: inside-secure - add support for PCI based
 FPGA development board
Thread-Index: AQHVQ7iGiGasvxZ/1k28+z4dWUzE9abi5S6AgAAAqWA=
Date:   Tue, 30 Jul 2019 10:20:43 +0000
Message-ID: <MN2PR20MB2973B37C90FBD6E6C97B8E09CADC0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1564145005-26731-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1564145005-26731-3-git-send-email-pvanleeuwen@verimatrix.com>
 <20190730090811.GF3108@kwain>
In-Reply-To: <20190730090811.GF3108@kwain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 009dc19b-5813-4aae-2120-08d714d79495
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB3088;
x-ms-traffictypediagnostic: MN2PR20MB3088:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <MN2PR20MB3088D85C21A6D1335C3D6DEACADC0@MN2PR20MB3088.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0114FF88F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(39850400004)(366004)(376002)(346002)(13464003)(189003)(199004)(55016002)(53936002)(446003)(76116006)(71200400001)(52536014)(66066001)(53546011)(478600001)(6436002)(6506007)(966005)(64756008)(66556008)(11346002)(7736002)(6306002)(229853002)(2906002)(14454004)(74316002)(26005)(66476007)(66946007)(66446008)(102836004)(3846002)(54906003)(316002)(110136005)(25786009)(81166006)(5660300002)(476003)(14444005)(9686003)(6116002)(86362001)(99286004)(66574012)(256004)(68736007)(8676002)(76176011)(486006)(8936002)(81156014)(305945005)(6246003)(71190400001)(15974865002)(4326008)(33656002)(7696005)(186003)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB3088;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2oYZNFGl7DZ0G4B6r+3Tz+PPowTpRyu9jNxSEXh/+0X8mt5sFh+0Jok/6pVupbLphbr1MDac9tn8new4LjWKYqEnb+tpTXn3S3MD0vgV469GLpK0iSlNDKlSnVPzw8MYOe/5qR3sQhVgMUuHzLaakTQADqEl0l9PunvkSApMY4n9MiTePhIAv5nvv52c12h+HfMq363Mq7cp3KbAOnMvlrE3spGBqFRd9BkJM6B3ZHlgG6RaqzlurVoCbMpSVYcT1kNcmtqhHdOnhQqURobGo+2UoOJigCHREmKec8rS0fqHVQXTW+i43VgDslYOnlF0MMnMajJs6rUfyqSzaxKNe0shisXO6jGyCmsj6qhFtqG/g9ihMNpfwu/+ZjuoGS//AQht8hVYX0p6qOboasEySwSmUKPGy1lBxx13RTLtH+8=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 009dc19b-5813-4aae-2120-08d714d79495
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2019 10:20:43.7031
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB3088
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Antoine Tenart <antoine.tenart@bootlin.com>
> Sent: Tuesday, July 30, 2019 11:08 AM
> To: Pascal van Leeuwen <pascalvanl@gmail.com>
> Cc: linux-crypto@vger.kernel.org; antoine.tenart@bootlin.com; herbert@gon=
dor.apana.org.au;
> davem@davemloft.net; Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Subject: Re: [PATCHv2 2/3] crypto: inside-secure - add support for PCI ba=
sed FPGA
> development board
>=20
> Hi Pascal,
>=20
> On Fri, Jul 26, 2019 at 02:43:24PM +0200, Pascal van Leeuwen wrote:
> > +	if (priv->version =3D=3D EIP197D_MRVL) {
>=20
> I see you renamed EIP197D to EIP197D_MRVL in the v2. Such a rename
> should not be part of this patch, as it has nothing to do with the
> engine you're adding support for.
>=20
I think the rename makes sense within the context of this patch, as the
patch allows it to be run on our development board which may not contain
Marvell hardware (see also the answer below). The rename makes it clear
from the code, at least, that for now only Marvell hardware is supported.

> Is there a reason to have this one linked to Marvell? Aren't there other
> EIP197 (or EIP97) engines not on Marvell SoCs? (I'm pretty sure I know
> at least one).
>=20
Yes, there is a very good reason. These flags control features that are
very specific to those three Marvell socs and have nothing to do with=20
'generic' EIP97IES's, EIP197B's or EIP197D's (these are just high-level
marketing/sales denominators and do not cover all the intricate config
details of the actual delivery that the driver needs to know about, so
this naive approach would not be maintainable scaling to other devices)=20
Therefore, I wanted to make that abundantly clear, hence the prefix.
(Renaming them to the specific Marvell SoC names was another option,
if only I knew which engine ended up in which SoC ...)

While there are many SoC's out there with EIP97 and EIP197 engines,
the driver in its current form will NOT work (properly) on them, for
that there is still much work to be done beyond the patches I already
submitted. I already have the implementation for that (you tested that
already!), but chopping it into bits and submitting it all will take=20
a lot more time. But you have to understand that, without that, it's=20
totally useless to either me or Verimatrix.

TL;DR: These flags are really just for controlling anything specific
to those particular Marvell instances and nothing else.

> > -	switch (priv->version) {
> > -	case EIP197B:
> > -		dir =3D "eip197b";
> > -		break;
> > -	case EIP197D:
> > -		dir =3D "eip197d";
> > -		break;
> > -	default:
> > +	if (priv->version =3D=3D EIP97IES_MRVL)
> >  		/* No firmware is required */
> >  		return 0;
> > -	}
> > +	else if (priv->version =3D=3D EIP197D_MRVL)
> > +		dir =3D "eip197d";
> > +	else
> > +		/* Default to minimum EIP197 config */
> > +		dir =3D "eip197b";
>=20
> You're moving the default choice from "no firmware" to being a specific
> one.
>=20
The EIP97 being the exception as the only firmware-less engine.
This makes EIP197_DEVBRD fall through to EIP197B firmware until
my patches supporting other EIP197 configs eventually get merged,
after which this part will change anyway.

> > -			if (priv->version !=3D EIP197B)
> > +			if (!(priv->version =3D=3D EIP197B_MRVL))
>=20
> '!=3D' ?
>=20
Yes, that one looks funny ;-) May have been some global search and
replace going awry. Will fix.

> > -			/* Fallback to the old firmware location for the
> > +			/*
> > +			 * Fallback to the old firmware location for the
>=20
> This is actually the expected comment style in net/ and crypto/. (There
> are other examples).
>=20
Not according to the Linux coding style (which only makes an exception
for /net) and not in most other crypto code I've seen. So maybe both
styles are allowed(?) and they are certainly both used, but this style
seems to be prevalent ...

> >  	/* For EIP197 set maximum number of TX commands to 2^5 =3D 32 */
> > -	if (priv->version =3D=3D EIP197B || priv->version =3D=3D EIP197D)
> > +	if (priv->version !=3D EIP97IES_MRVL)
>=20
> I would really prefer having explicit checks here. More engines will be
> supported in the future and doing will help. (There are others).
>=20
Same situation as with the crypto mode: I know for a fact the EIP97
is the *only* configuration that *doesn't* need this code. So why
would I have a long list of configurations there (that will keep
growing indefinitely) that *do* need that code? That will for sure
not improve maintainability ...


> > @@ -869,9 +898,6 @@ static int safexcel_register_algorithms(struct safe=
xcel_crypto_priv
> *priv)
> >  	for (i =3D 0; i < ARRAY_SIZE(safexcel_algs); i++) {
> >  		safexcel_algs[i]->priv =3D priv;
> >
> > -		if (!(safexcel_algs[i]->engines & priv->version))
> > -			continue;
>=20
> You should remove the 'engines' flag in a separate patch. I'm really not
> sure about this. I don't think all the IS EIP engines support the same
> sets of algorithms?
>=20
All algorithms provided at this moment are available from all engines
currently supported. So the whole mechanism, so far, is redundant.

This will change as I add support for generic (non-Marvell) engines,
but the approach taken here is not scalable or maintainable. So I will
end up doing it differently, eventually. I don't see the point in
maintaining dead/unused/redundant code I'm about to replace anyway.

> > @@ -925,22 +945,18 @@ static void safexcel_configure(struct safexcel_cr=
ypto_priv *priv)
> >  	val =3D readl(EIP197_HIA_AIC_G(priv) + EIP197_HIA_OPTIONS);
> >
> >  	/* Read number of PEs from the engine */
> > -	switch (priv->version) {
> > -	case EIP197B:
> > -	case EIP197D:
> > -		mask =3D EIP197_N_PES_MASK;
> > -		break;
> > -	default:
> > +	if (priv->version =3D=3D EIP97IES_MRVL)
> >  		mask =3D EIP97_N_PES_MASK;
> > -	}
> > +	else
> > +		mask =3D EIP197_N_PES_MASK;
> > +
>=20
> You also lose readability here.
>=20
I don't see why or how. Same reasoning here: the EIP97 is the
only known exception so why bother with a full list of "the rest".
That's just more code to maintain and more error prone.
(and this code, like previous similar cases, will shortly need to
change when adding generic engine support, so this is just (hopefully
very) temporary anyway)

> > +	if (IS_ENABLED(CONFIG_PCI) && (priv->version =3D=3D EIP197_DEVBRD)) {
>=20
> You have extra parenthesis here.
>=20
Our internal coding style (as well as my personal preference)=20
actually mandates to put parenthesis around everything so expect
that to happen a lot going forward as I've been doing it like that
for nearly 30 years now.

Does the Linux coding style actually *prohibit* the use of these
"extra" parenthesis? I don't recall reading that anywhere ...

> > -	platform_set_drvdata(pdev, priv);
>=20
> Side note: this is why you had to send the patch fixing rmmod.
>=20
Ah ... so that's where it accidentally disappeared :-)

> >  static void safexcel_hw_reset_rings(struct safexcel_crypto_priv *priv)
> > @@ -1160,6 +1139,78 @@ static void safexcel_hw_reset_rings(struct safex=
cel_crypto_priv
> *priv)
> >  	}
> >  }
> >
> > +#if (IS_ENABLED(CONFIG_OF))
>=20
> No need for the extra parenthesis here.
>=20
Same comment as before

> > +	if (priv->version =3D=3D EIP197_DEVBRD) {
>=20
> It seems to me this is mixing an engine version information and a board
> were the engine is integrated. Are there differences in the engine
> itself, or only in the way it's wired?
>=20
Actually, no. The way I see it, priv->version does not convey any engine
information, just integration context (i.e. a specific Marvell SoC or, in=20
this case, our FPGA dev board), see also my explanation at the beginning.

Conveying engine information through a simple set of flags or some
integer or whatever is just not going to fly. No two of our engines
are ever the same, so that would quickly blow up in your face.

> We had this discussion on the v1. Your point was that you wanted this
> information to be in .data. One solution I proposed then was to use a
> struct (with both a 'version' and a 'flag' variable inside) instead of
> a single 'version' variable, so that we still can make checks on the
> version itself and not on something too specific.
>=20
As a result of that discussion, I kept your original version field
as intact as I could, knowing what I know and where I want to go.

But to truly support generic engines, we really need all the stuff
that I added. Because it simply has that many parameters that are
different for each individual instance. But at the same time these
parameters can all be probed from the hardware directly, so
maintaining huge if statements all over the place decoding some=20
artificial version field is not the way to go (not maintainable).
Just probe all the parameters from the hardware and use them=20
directly where needed ... which my future patch set will do.

> > +static int __init crypto_is_init(void)
> > +{
> > +	int rc;
> > +
> > +	#if (IS_ENABLED(CONFIG_OF))
> > +		/* Register platform driver */
> > +		platform_driver_register(&crypto_safexcel);
> > +	#endif
>=20
> When used in the code directly, you should use:
>=20
>   if (IS_ENABLED(CONFIG_OF))
>=20
Oops, I missed that one, will fix.

> Thanks!
> Antoine
>=20
> --
> Antoine T=E9nart, Bootlin
> Embedded Linux and Kernel engineering
> https://bootlin.com

Thanks,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
