Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4D66C0650F
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 16:18:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53DB4206A2
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 16:18:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="XaZLZ/ip"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbfG3QSB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jul 2019 12:18:01 -0400
Received: from mail-eopbgr760044.outbound.protection.outlook.com ([40.107.76.44]:6077
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726389AbfG3QSA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jul 2019 12:18:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VFSWs9S+xgIcBkUStFvjEHxOM6zVbCYMfjLPcwIN4656TFcazpOGzTtJMceFte6WRlcAJx4KF5E8qAKxHLZCS8ocUL3tH5FBJkOKrEoXhpPkuIXNP9Paqzdt/4uNXuw0hD38qTdLQsvZKN/WgQ8GODRYGabWQVgM+hsglqwiCQ3s2RFkF9w3hWhTQ6CukpeKXGeV2WHdLkHmVDrPJKn7QjG/Uwtm1la2X4oppzdVQVH7rkX3RQGIOGwOOJyzxvKw4k+5IuTePNRPWRRbSCROeb1Kymc676HlKuEkcNp9w2Q7VlFNV34JNB7fcYf7lAbJ8Sq07hRdLXIqi0CpEqcONA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NfIu1ZA0y4g5YvN1fT2jzXB1byUvYeGoZ0PAN4YqUEA=;
 b=FR936/HcKqFgaOdbGpPQ4IYfp0A5LVMJlKoGrGbEhPs4gwIQGtwm+9pOEFJds3ONZcPiXEsaKVl/YSoHZ8dlOTgCUyrNX2NL6cE2YJLClz7qM6xzK3Afz4oCWYS3N5ljg8dGU67gFSiiqAuFWwPWaXI7R0LPqkqqm31sSbtfT+sQRtjkdgEDubqtXnVwa21x8QmFJGYR0p2nZMiYiY+b2W//mEy9uNIb8xg4BkcWUt6ikZBkLqrc1K5cFDEONR4Q8DDc6kzH2gysf5Numy5U4R4yegNNnuE+2eTVQvZxygakMv4CdaFxlnYpqc7Amq/rW7PvbdQhZsGusEPYy1OSuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NfIu1ZA0y4g5YvN1fT2jzXB1byUvYeGoZ0PAN4YqUEA=;
 b=XaZLZ/ipTCB3B73ro53ukyaGjq+qcF+oHbWuS6cyxNaX/D5fdIOdokesM20Al/mwQ8jDgDvlZEbB5m6wFXFi3psT9zaAkPqxjwSi6DQBTnpVDxpKQqLzZN6jnZqH2pSkSSHxTkDhtriwUrgHqE0yLYHh+kyK/gIJ+SxG5NPsTuM=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2319.namprd20.prod.outlook.com (20.179.146.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.13; Tue, 30 Jul 2019 16:17:55 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2115.005; Tue, 30 Jul 2019
 16:17:55 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
CC:     Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCHv2 2/3] crypto: inside-secure - add support for PCI based
 FPGA development board
Thread-Topic: [PATCHv2 2/3] crypto: inside-secure - add support for PCI based
 FPGA development board
Thread-Index: AQHVQ7iGiGasvxZ/1k28+z4dWUzE9abi5S6AgAAAqWCAAEv+AIAADciw
Date:   Tue, 30 Jul 2019 16:17:54 +0000
Message-ID: <MN2PR20MB2973FA07F5AB41D99A9FADD4CADC0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1564145005-26731-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1564145005-26731-3-git-send-email-pvanleeuwen@verimatrix.com>
 <20190730090811.GF3108@kwain>
 <MN2PR20MB2973B37C90FBD6E6C97B8E09CADC0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190730134232.GG3108@kwain>
In-Reply-To: <20190730134232.GG3108@kwain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6d10fadb-647a-4fb8-ef23-08d715097a9c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MN2PR20MB2319;
x-ms-traffictypediagnostic: MN2PR20MB2319:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <MN2PR20MB2319F242AE28A3E08CA1DEB5CADC0@MN2PR20MB2319.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0114FF88F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(39850400004)(136003)(346002)(376002)(189003)(199004)(13464003)(256004)(102836004)(66574012)(53546011)(14444005)(486006)(476003)(2906002)(71200400001)(71190400001)(446003)(11346002)(33656002)(74316002)(6116002)(3846002)(6916009)(4326008)(25786009)(86362001)(6246003)(68736007)(966005)(15974865002)(316002)(54906003)(478600001)(81166006)(14454004)(7736002)(229853002)(99286004)(305945005)(81156014)(66446008)(53936002)(66066001)(66946007)(76116006)(5660300002)(7696005)(8676002)(66476007)(64756008)(76176011)(66556008)(26005)(8936002)(6436002)(30864003)(9686003)(55016002)(6306002)(52536014)(6506007)(186003)(21314003)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2319;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: GPoPQiLmzKf9/aTiiab3g8/MI+X521jaIxYViem0Dhg+FqTWRIbI/pHjqTPU5gw5mstqL08G5hq9BnXlMYy0KBAQutkramoahEmJzjYeFbML4kQDyI2xkYeFH9EbnaJ/nE6nBd+y6w12lmXmHY/wBTHu1aqpedIGM70NwxHlx2X+IV17wRY3zet668LdlpPXwTBWctE1++pEbUwjHIJgvdr+a2zFv2q7LEXsRYs6j12aHYxvhONnn/85nDrnKYuW6UQav93k2w7TVYLTwqTPps2jMG8WXx2Q5+H/k2AmP1eFiMBfZDdj2RxV35VTaPx2Yt8cRv20l/v1sPM62qPFZTlDBY7RwUXqO1G8EduC1FcA1FrZ38Sv/q5YXGFhyvn1aKbYtTC00stYnwz/HXtyyaaKXbsi+44U5k2oPzKuLGE=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d10fadb-647a-4fb8-ef23-08d715097a9c
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2019 16:17:55.0359
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2319
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Antoine Tenart <antoine.tenart@bootlin.com>
> Sent: Tuesday, July 30, 2019 3:43 PM
> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Cc: Antoine Tenart <antoine.tenart@bootlin.com>; Pascal van Leeuwen
> <pascalvanl@gmail.com>; linux-crypto@vger.kernel.org; herbert@gondor.apan=
a.org.au;
> davem@davemloft.net
> Subject: Re: [PATCHv2 2/3] crypto: inside-secure - add support for PCI ba=
sed FPGA
> development board
>=20
> Hi Pascal,
>=20
> On Tue, Jul 30, 2019 at 10:20:43AM +0000, Pascal Van Leeuwen wrote:
> > > On Fri, Jul 26, 2019 at 02:43:24PM +0200, Pascal van Leeuwen wrote:
> >
> > > Is there a reason to have this one linked to Marvell? Aren't there ot=
her
> > > EIP197 (or EIP97) engines not on Marvell SoCs? (I'm pretty sure I kno=
w
> > > at least one).
> > >
> > Yes, there is a very good reason. These flags control features that are
> > very specific to those three Marvell socs and have nothing to do with
> > 'generic' EIP97IES's, EIP197B's or EIP197D's (these are just high-level
> > marketing/sales denominators and do not cover all the intricate config
> > details of the actual delivery that the driver needs to know about, so
> > this naive approach would not be maintainable scaling to other devices)
> > Therefore, I wanted to make that abundantly clear, hence the prefix.
> > (Renaming them to the specific Marvell SoC names was another option,
> > if only I knew which engine ended up in which SoC ...)
> >
> > While there are many SoC's out there with EIP97 and EIP197 engines,
> > the driver in its current form will NOT work (properly) on them, for
> > that there is still much work to be done beyond the patches I already
> > submitted. I already have the implementation for that (you tested that
> > already!), but chopping it into bits and submitting it all will take
> > a lot more time. But you have to understand that, without that, it's
> > totally useless to either me or Verimatrix.
> >
> > TL;DR: These flags are really just for controlling anything specific
> > to those particular Marvell instances and nothing else.
>=20
> I had this driver running on another non-Marvell SoC with very minor
> modifications, so there's then at least one hardware which is similar
> enough. In this case I don't see why this should be named "Marvell".
>=20
Just because it more or less appeared to run, does NOT mean that it=20
actually works properly, reliably and efficiently across the board.=20
Trust me, this is my design and I know it inside out and there is NO=20
engine out there equal to any Marvell engine.

> What are the features specific to those Marvell SoC that won't be used
> in other integrations? I'm pretty sure there are common features between
> all those EIP97 engines on different SoCs.
>=20
- specific algorithms supported
- number of pipes present
- number of rings present
- number of ring interrupt controllers present
- full featured (TRC) versus simplified record cache (STRC)
- for TRC: size of cache admin & data RAMs, affects configuration
- size of various internal buffers which affects configuration
- width of the databus, which affects descriptor size
- workarounds needed for specific design bugs and/or limitations
- newer features unsupported by now old MRVL engines

That's just the low-hanging fruit. We've *never* delivered the same
engine configuration to different customers. It's always customized.

> > > > -	switch (priv->version) {
> > > > -	case EIP197B:
> > > > -		dir =3D "eip197b";
> > > > -		break;
> > > > -	case EIP197D:
> > > > -		dir =3D "eip197d";
> > > > -		break;
> > > > -	default:
> > > > +	if (priv->version =3D=3D EIP97IES_MRVL)
> > > >  		/* No firmware is required */
> > > >  		return 0;
> > > > -	}
> > > > +	else if (priv->version =3D=3D EIP197D_MRVL)
> > > > +		dir =3D "eip197d";
> > > > +	else
> > > > +		/* Default to minimum EIP197 config */
> > > > +		dir =3D "eip197b";
> > >
> > > You're moving the default choice from "no firmware" to being a specif=
ic
> > > one.
> > >
> > The EIP97 being the exception as the only firmware-less engine.
> > This makes EIP197_DEVBRD fall through to EIP197B firmware until
> > my patches supporting other EIP197 configs eventually get merged,
> > after which this part will change anyway.
>=20
> We don't know when/in what shape those patches will be merged, so in
> the meantime please make the "no firmware" the default choice.
>
"No firmware" is not possible with an EIP197. Trying to use it without
loading firmware will cause it to hang, which I don't believe is what
you would want. So the alternative would be to return an error, which
is fine by me, so then I'll change it into that as default.
=20
> > > > -			/* Fallback to the old firmware location for the
> > > > +			/*
> > > > +			 * Fallback to the old firmware location for the
> > >
> > > This is actually the expected comment style in net/ and crypto/. (The=
re
> > > are other examples).
> > >
> > Not according to the Linux coding style (which only makes an exception
> > for /net) and not in most other crypto code I've seen. So maybe both
> > styles are allowed(?) and they are certainly both used, but this style
> > seems to be prevalent ...
>=20
> I agree having non-written rules is not good (I don't make them), but
> not everything is described in the documentation or in the coding style.
> I don't really care about the comment style when adding new ones, but
> those are valid (& recommended) in crypto/ and it just make the patch
> bigger.
>=20
Ah, ok, your point being not to touch an already existing comment.
I missed that tiny detail ... I guess that's sort of automatic out of
my desire for consistency. I'll try to suppress those urges :-)

> > > >  	/* For EIP197 set maximum number of TX commands to 2^5 =3D 32 */
> > > > -	if (priv->version =3D=3D EIP197B || priv->version =3D=3D EIP197D)
> > > > +	if (priv->version !=3D EIP97IES_MRVL)
> > >
> > > I would really prefer having explicit checks here. More engines will =
be
> > > supported in the future and doing will help. (There are others).
> > >
> > Same situation as with the crypto mode: I know for a fact the EIP97
> > is the *only* configuration that *doesn't* need this code. So why
> > would I have a long list of configurations there (that will keep
> > growing indefinitely) that *do* need that code? That will for sure
> > not improve maintainability ...
>=20
> OK, I won't debate this for hours. At least add a comment, for when
> *others* will add support for new hardware (because that really is the
> point, *others* might update and modify the driver).
>=20
Sure, I can add some comments to clarify these.

> > > > @@ -869,9 +898,6 @@ static int safexcel_register_algorithms(struct
> safexcel_crypto_priv
> > > *priv)
> > > >  	for (i =3D 0; i < ARRAY_SIZE(safexcel_algs); i++) {
> > > >  		safexcel_algs[i]->priv =3D priv;
> > > >
> > > > -		if (!(safexcel_algs[i]->engines & priv->version))
> > > > -			continue;
> > >
> > > You should remove the 'engines' flag in a separate patch. I'm really =
not
> > > sure about this. I don't think all the IS EIP engines support the sam=
e
> > > sets of algorithms?
> > >
> > All algorithms provided at this moment are available from all engines
> > currently supported. So the whole mechanism, so far, is redundant.
> >
> > This will change as I add support for generic (non-Marvell) engines,
> > but the approach taken here is not scalable or maintainable. So I will
> > end up doing it differently, eventually. I don't see the point in
> > maintaining dead/unused/redundant code I'm about to replace anyway.
>=20
> But it's not done yet and we might discuss how you'll handle this. You
> can't know for sure you'll end up with a different approach.
>=20
We can discuss all we want, but the old approach for sure won't work
so there's no point in keeping those (effectively redundant up until
now, so why did they even exist?) 'engines' flags.=20

> At least remove this in a separate patch.
>
Ok, I can do that

> > > > +	if (IS_ENABLED(CONFIG_PCI) && (priv->version =3D=3D EIP197_DEVBRD=
)) {
> > >
> > > You have extra parenthesis here.
> > >
> > Our internal coding style (as well as my personal preference)
> > actually mandates to put parenthesis around everything so expect
> > that to happen a lot going forward as I've been doing it like that
> > for nearly 30 years now.
> >
> > Does the Linux coding style actually *prohibit* the use of these
> > "extra" parenthesis? I don't recall reading that anywhere ...
>=20
> I don't know if this is a written rule (as many others), but you'll find
> plenty of examples of reviews asking not to have extra parenthesis.
>
I can remove them, I was just wondering if there was actually any=20
rationale for not wanting to have them (considering that that at least
seems far more error prone). I have this strange desire to want to=20
know WHY I have to do something before I do it.

Is it just to show off your intimate knowledge of C operator precedence
and associativity  ;-) (which, incidentally, I'm not too familiar with)
=20
> > > > +	if (priv->version =3D=3D EIP197_DEVBRD) {
> > >
> > > It seems to me this is mixing an engine version information and a boa=
rd
> > > were the engine is integrated. Are there differences in the engine
> > > itself, or only in the way it's wired?
> > >
> > Actually, no. The way I see it, priv->version does not convey any engin=
e
> > information, just integration context (i.e. a specific Marvell SoC or, =
in
> > this case, our FPGA dev board), see also my explanation at the beginnin=
g.
>=20
> So that's really the point here :) This variable was introduced to
> convey the engine information, not the way it is integrated. There are
> EIP97 engines not on Marvell SoC which will just work out of the box
>
No, they will not. Certainly not if the driver becomes more capable.
You are making (dangerous) assumptions you don't have the knowledge
to make. With all due respect, not your fault, you just can't know
as this is not public information.

> (or with let's say a one liner adding support for using a clock)
>
No, that's naive thought. Marvell configs, for example, have a pretty
extensive algorithm loadout and relatively large record cache RAMs
as well as internal buffer RAMs. That will cause problems with most
other engines being a subset of that (which may be reliability=20
problems you won't immediately notice(!) ...).

> And the version could be in both cases something like 'EIP97'.
>=20
It needs to be something unique. And that will very quickly become
overwhelming as you need to maintain lists of which unique identifier
has which specific features somewhere. Or have huge case and/or=20
if-else if statements all over the place.

While all required parameters needed to configure the engine and
the driver can be directly probed from said hardware (including the
difference between an EIP97 and an EIP197, the number of pipes,
rings, everything, all you need is a base address), so why bother?

The only place where this 'version' can still be useful is to=20
distinguish the *platform*, which may need some specific initialization=20
(e.g. platform clocks, power domains, interrupt controllers and such).

> > Conveying engine information through a simple set of flags or some
> > integer or whatever is just not going to fly. No two of our engines
> > are ever the same, so that would quickly blow up in your face.
>=20
> Well, you have more info about this than I do, I can only trust you on
> this (it's just weird based on the experience I described just before,
> it seems to me the differences are not that big, but again, you know the
> h/w better).
>=20
Knowing the hardware better is actually a huge understatement, being the
responsible architect and lead designer :-) I specified and implemented
most of the stuff you are talking from the driver with my own two hands.

> I just don't want to end up with:
>=20
>   if (version =3D=3D EIP97_MRVL || version =3D=3D EIP97_XXX || ...)
>=20
That's an interesting remark as that is exactly what I am trying to
*avoid* through the way I'm using the version field and, for me,
contradicts some comments you had earlier?
Oh well, I'll take this statement as confirmation we're more or less
on the same page here.=20

> > > We had this discussion on the v1. Your point was that you wanted this
> > > information to be in .data. One solution I proposed then was to use a
> > > struct (with both a 'version' and a 'flag' variable inside) instead o=
f
> > > a single 'version' variable, so that we still can make checks on the
> > > version itself and not on something too specific.
> > >
> > As a result of that discussion, I kept your original version field
> > as intact as I could, knowing what I know and where I want to go.
> >
> > But to truly support generic engines, we really need all the stuff
> > that I added. Because it simply has that many parameters that are
> > different for each individual instance. But at the same time these
> > parameters can all be probed from the hardware directly, so
> > maintaining huge if statements all over the place decoding some
> > artificial version field is not the way to go (not maintainable).
> > Just probe all the parameters from the hardware and use them
> > directly where needed ... which my future patch set will do.
>=20
> OK, I do think this would be a good solution :)
>=20
I hope so ... as you're not exactly easy to convince and I can't
afford to keep spending this much effort on this for much longer
without getting in trouble with my dayjob.

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
