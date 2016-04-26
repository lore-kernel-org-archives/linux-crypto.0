From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH] crypto: gcm - Fix rfc4543 decryption crash
Date: Tue, 26 Apr 2016 13:42:56 +0200
Message-ID: <1461670976.14569.40.camel@decadent.org.uk>
References: <20160318144240.GA20816@gondor.apana.org.au>
	 <20160318173423.GB19137@kroah.com>
	 <20160319022307.GA25338@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-lTrQF+FwExwwVukXBXSa"
Cc: stable@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	patrick.meyer@vasgard.com
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Greg KH <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36298 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751165AbcDZLnL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Apr 2016 07:43:11 -0400
In-Reply-To: <20160319022307.GA25338@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--=-lTrQF+FwExwwVukXBXSa
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2016-03-19 at 10:23 +0800, Herbert Xu wrote:
> On Fri, Mar 18, 2016 at 10:34:23AM -0700, Greg KH wrote:
> >=20
> > On Fri, Mar 18, 2016 at 10:42:40PM +0800, Herbert Xu wrote:
> > >=20
> > > This bug has already bee fixed upstream since 4.2.=C2=A0=C2=A0However=
, it
> > > was fixed during the AEAD conversion so no fix was backported to
> > > the older kernels.
> > What was the commit id of that fix?
> commit adcbc688fe2f8107b7f564187593293aa9ea3932
> Author: Herbert Xu <herbert@gondor.apana.org.au>
> Date:=C2=A0=C2=A0=C2=A0Tue Jun 16 13:54:18 2015 +0800
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0crypto: gcm - Convert to new AEAD interface
> =C2=A0
> >=20
> > What stable kernel(s) do you want this in?
> Since the fix was merged in 4.2 this is needed on all kernels
> prior to that, i.e., 4.1 and any prior version.

It looks like the bug was introduced in 3.10 by:

d733ac90f9fe8ac284e523f9920b507555b12f6d
Author: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Date:=C2=A0=C2=A0=C2=A0Sun Apr 7 16:43:46 2013 +0300

=C2=A0=C2=A0=C2=A0=C2=A0crypto: gcm - fix rfc4543 to handle async crypto co=
rrectly
=C2=A0 =C2=A0=C2=A0
So 3.2.y and 3.4.y don't need this fix - or should they get both fixes?

Ben.

--=20
Ben Hutchings
The generation of random numbers is too important to be left to chance.
                                                            - Robert Coveyo=
u

--=-lTrQF+FwExwwVukXBXSa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJXH1RAAAoJEOe/yOyVhhEJTGoQANRZSQcVPXPVcUz0vcYepvsf
uvDOXsqWKTmgFT64irqpws53oXFBANIIwROBzotqGTqjkxo7z3xH+YIyvBDWHASo
BGC8WljUkyXgvO3puQKvpxo61QnVAI6e486FsDIaAVlgl0UlMoiGflBkKU1ZBqkb
XBJyG7S9ShdLOyxmum9zjpW+yMtXQeSpWumwsMGkdcs53pqvIECu6AURUMS03Mq5
J1nbEXaN76+W8zuIJNkM+8QLzhY0SPEMqIka9j8qB9Uar5aruaHdxKEQ6ux44ydt
Brm5xOz7NcsblATe2mkvdCocBqc/P/aWu0JfysXIYGVuY57J1iwkMslfBVMf9STO
mDXCElv007P7QwDB/2UtCqkE7zpqWXYf6UIiM0TPzlN+hSFQ20stvK2ItMjLAunW
9HLWNmJNIxhJkjCGLJDdXXqrwym/v9mAT8hIaQn+w0zeq2ce8h3xwt2OfQGjevYx
jwjbSpgmJJToZq7pgB6QIeJHZQrLdgKs/bg7+mVM3+opRLnZt1BbNr85gIq/GGhy
Fqt9NFpzlHwbciN2JyLu68ugNYiyJyFMBtWa8L5ENG/ijrU1+P3oLN1ME9PUC1C2
9GiGNi33T6smgkou9/t9RjraYi8YWQfqS+PvRl2z/aOXVlfxwH/qmyvXe0Rx/1b7
FFsIW4ot8WP2LPjmBByr
=tpTV
-----END PGP SIGNATURE-----

--=-lTrQF+FwExwwVukXBXSa--
