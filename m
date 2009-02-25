From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH] crypto: compress - Add pcomp interface
Date: Wed, 25 Feb 2009 14:26:28 +0100 (CET)
Message-ID: <alpine.LRH.2.00.0902251425570.4063@vixen.sonytel.be>
References: <20090114031613.GA7429@gondor.apana.org.au> <Pine.LNX.4.64.0901141528010.31703@vixen.sonytel.be> <20090115030526.GA27726@gondor.apana.org.au> <alpine.LRH.2.00.0902051703150.4290@vixen.sonytel.be> <20090210061822.GA19774@gondor.apana.org.au>
 <alpine.LRH.2.00.0902121613580.29413@vixen.sonytel.be> <20090219040847.GA973@gondor.apana.org.au> <alpine.LRH.2.00.0902191005110.27630@vixen.sonytel.be> <20090219104250.GA9633@gondor.apana.org.au> <alpine.LRH.2.00.0902231822080.22762@vixen.sonytel.be>
 <20090225025605.GA30920@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:63445 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753416AbZBYN0c (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Feb 2009 08:26:32 -0500
In-Reply-To: <20090225025605.GA30920@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 25 Feb 2009, Herbert Xu wrote:
> On Mon, Feb 23, 2009 at 06:32:19PM +0100, Geert Uytterhoeven wrote:
> >
> > Is the below (on top of my last patch series) what you have in mind=
?
>=20
> Looks great to me!

OK.

> > Notes:
> >   - I had to drop the `const' from the `params' pointers of
> >     pcomp_alg.{,de}compress_setup().
> >     Trying to make nla_parse() take const nlattr structures instead=
 seems to
> >     open a big can of worms...
>=20
> I don't think that's a big deal.
>=20
> >   - I should add a dependency of CONFIG_CRYPTO_ZLIB on CONFIG_NET (=
due to the
> >     need for nla_parse()). However, I don't like that.
>=20
> Dave has OKed it for the attribute stuff to be moved into lib.
> So if you want to tackle that then be my guest :) Otherwise I'll
> look into moving it.

I already have a patch for that. I'll fold the netlink parsing into the
original series and will resubmit.

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village =B7 Da Vincilaan 7-D1 =B7 B-1935 Zaventem =B7 Bel=
gium

Phone:    +32 (0)2 700 8453
=46ax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 =B7 RPR Brussels
=46ortis =B7 BIC GEBABEBB =B7 IBAN BE41293037680010
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
