From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: nios2: Export get_cycles
Date: Tue, 9 Jun 2015 15:19:32 +1000
Message-ID: <20150609151932.4e6ac9e9@canb.auug.org.au>
References: <3181127.KGS6GDHCq6@tachyon.chronox.de>
	<55766C3A.3070101@roeck-us.net>
	<20150609044646.GA6892@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/g7/RxS7kueT_C2xoz2A=K7X"; protocol="application/pgp-signature"
Cc: Guenter Roeck <linux@roeck-us.net>,
	Stephan Mueller <smueller@chronox.de>,
	Peter Zijlstra
	<public-peterz-wegcikhe2lqwvfeawa7xhq@plane.gmane.org>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Jim Davis <jim.epost@gmail.com>,
	Linux-Next <linux-next@vger.kernel.org>,
	linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Waiman Long <waiman.long@hp.com>,
	Ingo Molnar <mingo@kernel.org>, x86 <x86@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20150609044646.GA6892@gondor.apana.org.au>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--Sig_/g7/RxS7kueT_C2xoz2A=K7X
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Herbert,

On Tue, 9 Jun 2015 12:46:46 +0800 Herbert Xu <herbert@gondor.apana.org.au> =
wrote:
>
> On Mon, Jun 08, 2015 at 09:31:54PM -0700, Guenter Roeck wrote:
> >=20
> > nios2 still fails to build with
> >=20
> > ERROR: "get_cycles" [crypto/jitterentropy.ko] undefined!
>=20
> It's the only arch that doesn't inline get_cycles and doesn't
> export it.
>=20
> ---8<---
> nios2 is the only architecture that does not inline get_cycles
> and does not export it.  This breaks crypto as it uses get_cycles
> in a number of modules.
>=20
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Also added into linux-next today.

I am assuming that they will turn up in the crypto tree soon(ish).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/g7/RxS7kueT_C2xoz2A=K7X
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJVdndpAAoJEMDTa8Ir7ZwV7h4P/3g4HqLoz2aMtYvOnuoUvpc8
gtkKjQ5/vCIKAhpeib/VU79Fq/dRsyyIuvaTo+GGAz91FX7wrRE+aD+uhhmQD+dq
oC79yrtHxy50YV3cJnDrQnSqGQlqIe1VVeEKk1MH41TSDA67DdWyr7fOuPBf80qw
3W+/hFlcKqMzIWpohW5RjP37V//tAPG7rArDecNDq7MWkmJJDwOdDEjFXwFUra99
PJ7hpaV/bYJX9zLW2zZH47mRuNOK2yFLNjnmNsMmKQ/CvyAkgg0GUnN+0GVv/iUd
8R7pgROsAwc6N35qROhGwo5iAwKwRACIbK30S2Q6NeOcS3OyjhkLZ8k0Txc/QG3M
hhYjr/YT2dOWCaYUTPubgS/0/dZRjL855rEg/QHi3gDxCRNPhvZaWyjLwbE0dNhP
Q5jEyTXzOHWusb2ZaSh57zZ2LwbLb8JrRSHrJ4KSIaByeSeLcnpnpNk13xKEGmfV
NqPJd+rCqMo+MvliFamn6Kkr/wN3TUgRc5UtEprg+X/oQM5uOBJ8gAbCzJyyRYa9
zyuNSNmRH1hM+T+ELkUbjRkeXFaTu1sB3jt49PoPGfGfGgHoQLwLPXmG6fln+0Mw
FvMYPxkW1lw+2NHqFRVTOuC/n6qgCPV50GA3biHPuZ3X7GLh26qxZW9LPtip6arZ
q69ZRFT34Y9g1KkGbfg4
=wKHj
-----END PGP SIGNATURE-----

--Sig_/g7/RxS7kueT_C2xoz2A=K7X--
