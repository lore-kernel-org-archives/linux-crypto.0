From: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH] crypto: sun4i-ss: support the Security System PRNG
Date: Wed, 21 Jun 2017 08:48:55 +0200
Message-ID: <20170621064855.z5mu4f3r3dt4kotc@flea.lan>
References: <20170620085819.20114-1-clabbe.montjoie@gmail.com>
 <20170620095947.i3r3iym2cxz5jciw@flea.lan>
 <20170620114536.GA4766@Red>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="3s2uby6hfasnvcsh"
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, wens@csie.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:49136 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751909AbdFUGs5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Jun 2017 02:48:57 -0400
Content-Disposition: inline
In-Reply-To: <20170620114536.GA4766@Red>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--3s2uby6hfasnvcsh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 20, 2017 at 01:45:36PM +0200, Corentin Labbe wrote:
> On Tue, Jun 20, 2017 at 11:59:47AM +0200, Maxime Ripard wrote:
> > Hi,
> >=20
> > On Tue, Jun 20, 2017 at 10:58:19AM +0200, Corentin Labbe wrote:
> > > The Security System have a PRNG, this patch add support for it via
> > > crypto_rng.
> >=20
> > This might be a dumb question, but is the CRYPTO_RNG code really
> > supposed to be used with PRNG?
> >=20
>=20
> Yes, see recently added drivers/crypto/exynos-rng.c

It's still not really clear from the commit log (if you're talking
about c46ea13f55b6) why and if using the RNG code for a PRNG is a good
idea.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--3s2uby6hfasnvcsh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJZShbXAAoJEBx+YmzsjxAgoBsP/iXwQGAtU3mXw3v7q12TBeRV
vppmXUo3NyEM/ijef5z8Jctm97L2U1Zk2SGwHTcu42rQ+xtD0En6bc2txVCFNb2H
BAmwxFDukmMNLt8NJ7PqwAh/Hbj2MNnsomGsF3yXpjaL1rmMZf02oFvCaL0Fw0DT
QQt5VDAKDzbqE2NEqJ+0k3xjIxWSVZekb8krYCVt1ssGhE2BxfB9AYi7Nxy52Ywa
ZoNA1P+6PhRJCZEgxOVWRL/InYan8kIxIowwVJdcat7gNg3xDaGgrw3UMFsloup+
qo49h6lVPLIXTXuG5il6esTTGT+4ES0gv2Ycv4cTqjgtg5Xt6VptdnjEahgGmtAA
kRgikWzhsvyTt7EH7gg6tugdbdasUjZ/uIAN3ob/SzNcu0KICoNHlo68o6DTyKTj
A+eWR8bYaUgszBc2tLzsQaqhSofSiNC4goDJI8VpX/y8Yw2IkAILahe8JmUxa/A/
SqZt0bvDQE/c0FOhjQth7TAF0iwA9wAuBhlKPr8Mp29/mEr0WkPK0DTZpvpZozRg
NmqWPxluV+c9PY5Ju7CsnE1aBKb+LSBHDST6JgBui0qBe11GdyGOlEXeE/1qlmrx
ydYCwZoEgfSltqmBNG8WTIe1gFqjY6wdSO813TZxh/R4ZfcltH76ehskS9zwLzXH
Jfn2d8nlpRhK0tNHkkkt
=5Pue
-----END PGP SIGNATURE-----

--3s2uby6hfasnvcsh--
