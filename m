From: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: un4i-ss-cipher.c warning
Date: Thu, 20 Aug 2015 08:39:00 +0200
Message-ID: <20150820063900.GJ30520@lukather>
References: <CAOMqctShdb9xEkBmuaQKfB1cwGupbfH5TS5ZB_P85Hwpn+4zAA@mail.gmail.com>
 <20150820052903.GA26031@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZG+WKzXzVby2T9Ro"
Cc: Michal Suchanek <hramrach@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Corentin Labbe <clabbe.montjoie@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:34590 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752317AbbHTGjE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 20 Aug 2015 02:39:04 -0400
Content-Disposition: inline
In-Reply-To: <20150820052903.GA26031@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--ZG+WKzXzVby2T9Ro
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 20, 2015 at 01:29:03PM +0800, Herbert Xu wrote:
> On Wed, Aug 19, 2015 at 04:35:36PM +0200, Michal Suchanek wrote:
> > Hello,
> >=20
> > when building a kernel with sunxi crypto driver as merged into the
> > sinxi-wip branch I get a compiler warning.
> >=20
> > I am not sure this is the latest version of the driver. It does not
> > seem to be in mainline yet.
>=20
> The warning appears to be spurious as the code always ends up
> initialising todo before using it.

Not in the dev_dbg call line 258. If ileft was negative or null, todo
isn't assigned to anything.

I'm not sure whether initializing todo to 0 is the right thing to do
though. Corentin?

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--ZG+WKzXzVby2T9Ro
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJV1XYEAAoJEBx+YmzsjxAgb7QP/3Hk6oVdFfhEWg4i8VZdC96l
VHrCuuJPohiUqfsJyG16KvALauxH4zBj6+lk7RDBbGGFDkQOyllDTAQgQfVXyQwe
7HeYMbviO1z2fEmX7/aIYJ3kPGxRQsG7E7hj4XoGXv7sEb+pOxOAEnSJy6Jaf+LE
Og4KcZAXIpX+9/2GVbvFqDfUzOXRKDVqL2+p+VHV+BMgbhpgpbf8VPOdoG9YFHd9
MGo1cnDLtNvHEr98T7n4jJspGzk5X9260/GdZZWyY3Qly5C0G4bR/ci3Cj2MT2OS
kntX3dHBpDAjHcv1IyKMWWO1T4+pK1H3ag9IcyczCZg4ehUDb9SI1bOzzyyE87tC
8cMLdf3TkNdxWfyZoyMU3mYimvBZ1w067KtcEyO7r6FvWTtuOaJrPuGglWIn8B4t
lzDNRkctG5eGXsClKBR+uiDxF3czCU4c2p6cFTuOh0CcdpDTKHlgQIOzfou1yubC
aykkrtpr/8qPIq9IAiFQZUaAlcz3Rte3/98HS/lwvOId/lxhyIDjTdegjoLqUN4F
667fkr6HjmF2XhQEX3pfu8lyRNdUEF7qGfwcqrtAeJc54EK3Ab03hdXU6iPZVPLj
rdxeconVMcvMhCCWMKwDswpGozJHDBJrsqP5vpgIBICcq4+RwqJ+tU31FvVJ/b+m
mAQfOi3F+5Q+p/67gjwU
=7+Yv
-----END PGP SIGNATURE-----

--ZG+WKzXzVby2T9Ro--
