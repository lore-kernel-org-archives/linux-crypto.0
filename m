From: Harald Welte <laforge@gnumonks.org>
Subject: Re: PadLock XSHA
Date: Thu, 2 Oct 2008 01:45:30 +0200
Message-ID: <20081001234530.GA25827@prithivi.gnumonks.org>
References: <20080830084316.GA19371@gondor.apana.org.au> <48B918F4.9030604@logix.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UugvWAfsgieZRqgk"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Michal Ludvig <michal@logix.cz>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:43690 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbYJBHu1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Oct 2008 03:50:27 -0400
Content-Disposition: inline
In-Reply-To: <48B918F4.9030604@logix.cz>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Sorry for the late response, and putting on my VIA hat for a second:

On Sat, Aug 30, 2008 at 09:55:00PM +1200, Michal Ludvig wrote:
=20
> > Can you remind me the reason why our PadLock SHA implementation
> > copies things into a page before hashing it?
> >=20
> > According to the programming manual, it would seem that the state
> > should be recorded in EDI after each 64-byte block so we should
> > be able to use the init/update/final model, no?
> >=20
> > Or has the chip changed since we implemented it?
>=20
> IIRC The first versions of VIA PadLock required the input data to be
> aligned on 16-bytes boundaries and more importantly they always
> finalised the hash. Therefore we had to collect all data before hashing
> them.
>
> AFAIK Recent versions of PadLock don't insist on finalising the hash and
> don't insist on input data alignment either and this workaround isn't
> needed anymore. I don't know if VIA still sells their motherboard models
> with the older CPUs or not.

as far as I know, all VIA padlock enabled processors that you can buy today
always finalize the hash.  I have heard rumors that with the CN / Nano this=
 is
changing.  VIA will update the padlock programming manual about that.

Since AFAIK Nano is still only sampling and thre's no end-user product with
that CPU in the market yet, there's no hurry right now.

I'll make sure to ping you guys once three is news about this.
--=20
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)

--UugvWAfsgieZRqgk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQFI5AuaXaXGVTD0i/8RAm5zAJ46Y2bghuZEhJJ8l9KESVAOPF2IDgCfVune
mxkTovvQf2GKFl12H93ZKjA=
=SamR
-----END PGP SIGNATURE-----

--UugvWAfsgieZRqgk--
