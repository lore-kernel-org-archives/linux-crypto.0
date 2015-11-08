From: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
Subject: Re: [PATCH] crypto: sun4i-ss: add missing statesize
Date: Sun, 8 Nov 2015 19:22:38 +0100
Message-ID: <1447006457@msgid.manchmal.in-ulm.de>
References: <1446709737-11316-1-git-send-email-clabbe.montjoie@gmail.com>
 <20151105160719.GG6114@lukather>
 <20151106045639.GA14722@gondor.apana.org.au>
 <20151108175003.GT6114@lukather>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="dFWYt1i2NyOo1oI9"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	LABBE Corentin <clabbe.montjoie@gmail.com>,
	davem@davemloft.net, wens@csie.org, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-sunxi@googlegroups.com, stable@vger.kernel.org
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151108175003.GT6114@lukather>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--dFWYt1i2NyOo1oI9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Maxime Ripard wrote...

> > > > This patch specifiy statesize for sha1 and md5.
> > > >=20
> > > > Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
> > > > Cc: stable@vger.kernel.org
> > >=20
> > > Please also add a Fixes tag (and the stable version it applies to).
> >=20
> > I don't see the point for a fixes tag as it would simply refer
> > to the original patch-set that added the driver.
>=20
> What's the problem with that?

Fixes: should rather point to the commit that caused the breakage in my
opinion. Which did this by intention:

| commit 8996eafdcbad149ac0f772fb1649fbb75c482a6a
| Author: Russell King <rmk+kernel@arm.linux.org.uk>
| Date:   Fri Oct 9 20:43:33 2015 +0100
|=20
|     crypto: ahash - ensure statesize is non-zero
(...)
+     This patch adds a check to prevent these drivers from registering
+     ahash algorithms until they are fixed.

Another crypto subsystem (mv_cesa) suffers from the same problem. I
have a patch ready but would prefer a consensus on these formalities
before submitting.

Aside from this, if you really need another Tested-by:, add me. And
also Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=3D107281

    Christoph

--dFWYt1i2NyOo1oI9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJWP5LuAAoJEMQsWOtZFJL9u60QAIou+IpE2L5iO3C4oSOhXS7V
FL/ziOZiTzQyI+uRumSjUPkGQq602ez90jNm0+D7zG6uZI8WFb+NMOMsbgKYsw52
137KP8KROY2dTEC7NCvUnoo/UCCgl4SddmgK8tg4usEADB25w08r4GuEVHntBBl+
bkjQCPnyaCoTDXJ9WUN/gkkMkXPwyaFCL35W0Z9ZMB5Ue7XWQQLQr51fuiLtXoDC
XnuXhtR/fKN2Mzuf1UhTCQ8I8+kuvGQYYEhvfgI8BH17Tt71G7jWwKxA0/kaxNao
ffotNvW6ziTyDxV+D3r6FT5BMfY6jwIpytJuIHsZA8/eWTkfjPS2b/XFQsDlJvIm
trgJZ/mMdl2OCkky/1e3vRyf1qarbrBjxevjXUW3jPo2tJG1krjkAIeH2GzZ7Pfp
n5cz43IbiUNyjKgQK4AJrebkRofseC5mH6qcGX+jHANrmweQmlzlHnj2zUXkMQKf
3ajbBpa5X0Hmo4M5gEP/KyTG3yt+F85kcjSrWO85URA3BXNkepFblOAaNCEcboUI
l3oGcyF4P5db1m/lujiT3KETNXGS9Mip0uIpCXzwNggeko8kh40ILduqMx1x+2iY
POYxFdy/7umsCuNV8D1G6eXL3Yph7jR0A2TmAD5gHKR4Am0Fhls+IO5eent2CckK
/ibf+A9SupfgEV30i9u6
=UyFD
-----END PGP SIGNATURE-----

--dFWYt1i2NyOo1oI9--
