From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: zeroing tfms in crypto_free_tfm()
Date: Thu, 5 Feb 2009 12:03:20 +0100 (CET)
Message-ID: <alpine.LRH.2.00.0902051159530.4290@vixen.sonytel.be>
References: <alpine.LRH.2.00.0902041606460.29216@vixen.sonytel.be> <20090205055437.GF22749@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:41887 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750782AbZBELDV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Feb 2009 06:03:21 -0500
In-Reply-To: <20090205055437.GF22749@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 5 Feb 2009, Herbert Xu wrote:
> On Wed, Feb 04, 2009 at 04:09:04PM +0100, Geert Uytterhoeven wrote:
> > However, in the mean time, the allocation mechanism for crypto_tfm =
objects has
> > been changed twice, by:
> >   1. commit fbdae9f3e7fb57c07cb0d973f113eb25da2e8ff2 ("[CRYPTO] Ens=
ure cit_iv
> >      is aligned correctly"), which replaced "alg->cra_ctxsize" by
> >      "crypto_ctxsize(alg, flags)" in crypto_alloc_tfm(),
> >   2. commit 7b0bac64cd5b74d6f1147524c26216de13a501fd ("crypto: api =
- Rebirth of
> >      crypto_alloc_tfm"), which introduced the alternative crypto_cr=
eate_tfm(),
> >      where the memory requirements are based on
> >      "frontend->extsize(alg, frontend)" instead of "alg->cra_ctxsiz=
e".
>=20
> Good catch.  In fact we've been freeing the wrong pointer with
> shash all along.  I wonder how it avoided crashing.

It doesn't crash because crypto_shash_type.tfmsize =3D
offsetof(struct crypto_shash, base) =3D zero.

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
