From: Harald Welte <laforge@gnumonks.org>
Subject: Re: PadLock XSHA
Date: Thu, 2 Oct 2008 01:48:08 +0200
Message-ID: <20081001234808.GB25827@prithivi.gnumonks.org>
References: <20080830084316.GA19371@gondor.apana.org.au> <48B918F4.9030604@logix.cz> <20080831020941.GA25048@gondor.apana.org.au> <48BB4640.1040407@logix.cz> <20080901034412.GA20270@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pvezYHf7grwyp3Bc"
Cc: Michal Ludvig <michal@logix.cz>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:43688 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025AbYJBHu1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Oct 2008 03:50:27 -0400
Content-Disposition: inline
In-Reply-To: <20080901034412.GA20270@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--pvezYHf7grwyp3Bc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi again,

On Mon, Sep 01, 2008 at 01:44:13PM +1000, Herbert Xu wrote:
> On Mon, Sep 01, 2008 at 01:32:48PM +1200, Michal Ludvig wrote:
> >
> > That's right, I confused SHA with AES in PadLock, sorry. With AES the=
=20
> > first versions required 16-byte alignment on input and output data as=
=20
> > well as on the control word and there's a flag in newer PadLocks that=
=20
> > allow doing AES on unaligned data.
>=20
> Excellent.  We can use this to avoid copying for IPsec then.

I agree.

> > I can't find any PadLock guide newer than 2005-05-03 (probably the same=
=20
> > one that you have). I'll check with VIA what the status of this is.

The last published version is 1.66 from 4th August 2005. There really is
no update since there was no later silicon changes or padlock related errata
for padlock in any of the C7 ever since.

I expect there will be a new release for padlock in the CN/Nano at some
not too distant point.

--=20
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)

--pvezYHf7grwyp3Bc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQFI5Aw4XaXGVTD0i/8RApnZAJ9I0tC3Dokf8/5GjQqZOZGb+OkxbQCeJ7D8
dZSYVjX2h563S5ioDgMwhK4=
=gUi7
-----END PGP SIGNATURE-----

--pvezYHf7grwyp3Bc--
