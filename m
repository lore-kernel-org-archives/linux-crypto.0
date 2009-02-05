From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH] crypto: compress - Add pcomp interface
Date: Thu, 5 Feb 2009 17:24:51 +0100 (CET)
Message-ID: <alpine.LRH.2.00.0902051703150.4290@vixen.sonytel.be>
References: <1231862386-11128-1-git-send-email-Geert.Uytterhoeven@sonycom.com> <1231862386-11128-2-git-send-email-Geert.Uytterhoeven@sonycom.com> <20090114031613.GA7429@gondor.apana.org.au> <Pine.LNX.4.64.0901141528010.31703@vixen.sonytel.be>
 <20090115030526.GA27726@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:48521 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754185AbZBEQYy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Feb 2009 11:24:54 -0500
In-Reply-To: <20090115030526.GA27726@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

	Hi Herbert,

On Thu, 15 Jan 2009, Herbert Xu wrote:
> On Wed, Jan 14, 2009 at 04:01:34PM +0100, Geert Uytterhoeven wrote:
> > On Wed, 14 Jan 2009, Herbert Xu wrote:
> > > Also, this is something that we'll potentially export to user-spa=
ce,
> > > so we need to ensure that it is invariant to word length.
> > >=20
> > > So something like this would be good
> > >=20
> > > 	int (*setup_comp)(struct crypto_pcomp *tfm, const void *params,
> > > 			  unsigned int length);
> > > 	int (*setup_decomp)(struct crypto_pcomp *tfm, const void *params=
,
> > > 			    unsigned int length);
> >=20
> > I assume "length" is the size of the passed params, so the algorith=
ms can
> > return -EINVAL if they're passed the wrong size?
> >=20
> > > The actual parameters should be formatted using the netlink helpe=
rs
> > > (nla_*).  So each parameter that you want to set should show up a=
s
> > > a netlink attribute.  If a paramter is absent then you'd just use
> > > the default, etc.
>
> > I assume "length" is the size of the passed params, so the algorith=
ms can
> > return -EINVAL if they're passed the wrong size?
>=20
> Well with the netlink parameters these can have variable lengths
> depending on how many parameters the user supplies.

How can this be exported to userspace?
How does this variable length parameter passing work? Do you have an ex=
ample?
Nothing in crypto/ seems to already use nla_*?

> Ah yes because crypto_comp is one of the original types that's
> still built-in.  Because there are so few compression users and
> algorithms (exactly 3 if you include null compression), I think
> we can dispense with the compatibility stuff altogether since
> we'll likely rip out fairly soon anyway.
>=20
> So just create the new type, readd deflate using the new type
> alongside the existing deflate algorithm.  The system is capable
> of supporting two algorithms of the same name with different types.

While the core of the crypto system supports two algorithms of the same=
 name
with different types, the testmgr doesn't.

As I removed the backwards-compatility layer at your request, I'll use =
"zlib"
for the name of the new module. It's more flexible than the fixed "defl=
ate"
one anyway.

Is this OK for you?

Thanks!

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
