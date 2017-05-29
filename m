From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: Re: [PATCH 09/11] crypto: sun4i-ss: move from ablkcipher to skcipher
 API
Date: Mon, 29 May 2017 16:56:13 +0200
Message-ID: <20170529145613.GA14148@kwain>
References: <20170524190652.13278-1-antoine.tenart@free-electrons.com>
 <20170524190652.13278-10-antoine.tenart@free-electrons.com>
 <20170529144757.GA23017@Red>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        maxime.ripard@free-electrons.com, wens@csie.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:59646 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751116AbdE2O4Z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 May 2017 10:56:25 -0400
Content-Disposition: inline
In-Reply-To: <20170529144757.GA23017@Red>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Corentin,

On Mon, May 29, 2017 at 04:47:57PM +0200, Corentin Labbe wrote:
> On Wed, May 24, 2017 at 09:06:50PM +0200, Antoine Tenart wrote:
> > +			.cra_flags =3D CRYPTO_ALG_TYPE_SKCIPHER |
> > +				     CRYPTO_ALG_KERN_DRIVER_ONLY,
>=20
> You add CRYPTO_ALG_KERN_DRIVER_ONLY on all flags which is unrelated to
> the patch description.

Right, I forgot to make an extra patch for this. I'll fix this (and the
other ones).

Thanks,
Antoine

--=20
Antoine T=E9nart, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJZLDaMAAoJEFxNi8it27zYOPQP/AnIfAs3WbfROGLLWIst3T+H
rFWFsczZ5yxH4KyAaaHp2cbRSodS/nS1liDWOxgoW0bsytAtImFSKJaDBWG9Rg9r
5ZFy7hQCNlHIL1xp+/h4f0MGPo0a3jgn5UGXy+NXqCxhtQZyKfv9306DMC3E2VA2
r1rg/MzhIa1iwqfds67xAF1Wl1bbKivO+iCG6leBN/WmEplfGr+za+yuOzy8/WCR
CAyFTYJrOpF7HN12oCnxpPvSQhCSZHPNAfreCj8OV8e4xHi9+bas02y2SRqw8eBy
B7dURsWyHiVcBE6rYmIaMy4AL0hTXfVu7hWvAmWFp1O0JgSK/6GYEEFoFKoMoJRj
n6Z8O2k5z8eT7b9b/M0K0rFanMS0z6rIrmUIZzRf18ReJdgAlLrv1490Lj8Xptqg
jONaAem4rSjKztKzCDDfzFfw/iZtWHmvJxoSDi/+Q/EHhT7RCQKJRYyNGBHJOtjn
BIeHcLyp5thu+2tQoT0UzHQQ+THdEK1TG+ePjiHeidfYGlaG4F5WyApP2ei+1Tkc
urtpGUcXRlAMlMjh8NhIzKqM2JuvtrTmZsvItX0flgX5ITW5bh3OR4p7ye78IPZg
S5UAPJ9LhY+0ljxy0gtf9ee/OO5zusICMJb9wz3gMcMvFMa9duFC1JydwkeByjhv
wMHuhAEHuf6GrrB0piWM
=jQsn
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--
