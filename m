From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH] crypto: compress - Add pcomp interface
Date: Thu, 12 Feb 2009 16:19:40 +0100 (CET)
Message-ID: <alpine.LRH.2.00.0902121613580.29413@vixen.sonytel.be>
References: <1231862386-11128-1-git-send-email-Geert.Uytterhoeven@sonycom.com> <1231862386-11128-2-git-send-email-Geert.Uytterhoeven@sonycom.com> <20090114031613.GA7429@gondor.apana.org.au> <Pine.LNX.4.64.0901141528010.31703@vixen.sonytel.be>
 <20090115030526.GA27726@gondor.apana.org.au> <alpine.LRH.2.00.0902051703150.4290@vixen.sonytel.be> <20090210061822.GA19774@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:33855 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758372AbZBLPTm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 12 Feb 2009 10:19:42 -0500
In-Reply-To: <20090210061822.GA19774@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 10 Feb 2009, Herbert Xu wrote:
> On Thu, Feb 05, 2009 at 05:24:51PM +0100, Geert Uytterhoeven wrote:
> > > Well with the netlink parameters these can have variable lengths
> > > depending on how many parameters the user supplies.
> >=20
> > How can this be exported to userspace?
> > How does this variable length parameter passing work? Do you have a=
n example?
>=20
> See how we use it for rtnetlink, e.g., in net/ipv4/ip_gre.c.
>=20
> > Nothing in crypto/ seems to already use nla_*?
>=20
> Well we don't have a user-space API yet :) But checkout the
> discussions on this list.

I'm sorry, but this is a totally separate change, so I'm not going to d=
o it
right now.

> > While the core of the crypto system supports two algorithms of the =
same name
> > with different types, the testmgr doesn't.
>=20
> I was lazy :) But really it isn't too hard to add a type field to
> the array in testmgr.  We don't even have to add it for existing
> entries (except for the ones that you're trying to replace, i.e.,
> deflate).

Are you sure about that? Shouldn't all the call sites to tcrypt_test() =
get a
type parameter, too?

> > As I removed the backwards-compatility layer at your request, I'll =
use "zlib"
> > for the name of the new module. It's more flexible than the fixed "=
deflate"
> > one anyway.
> >=20
> > Is this OK for you?
>=20
> Hmm, I think we need to have it stay as deflate if we're to make
> an easy transition for existing users (e.g., IPsec).

It's just a matter of replacing the literal "deflate" by "zlib", when s=
witching
net/xfrm/xfrm_algo.c from the old to the new API. As there won't be a
backwards-compatibility layer, the algorithm names don't have to match.

It's much less work than adding crypto types to all parts of the test c=
ode...

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
