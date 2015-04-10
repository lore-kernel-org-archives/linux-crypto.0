From: mancha security <mancha1@zoho.com>
Subject: Re: [BUG/PATCH] kernel RNG and its secrets
Date: Fri, 10 Apr 2015 14:22:08 +0000
Message-ID: <20150410142208.GA16910@zoho.com>
References: <20150318095345.GA12923@zoho.com>
 <2792913.x6Cv5ZCyOY@tauon>
 <1428674403.3377.4.camel@stressinduktion.org>
 <1697288.aUGCRhyl06@tauon>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>,
	Daniel Borkmann <daniel@iogearbox.net>, tytso@mit.edu,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au, dborkman@redhat.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sender1.zohomail.com ([74.201.84.155]:35117 "EHLO
	sender1.zohomail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934116AbbDJOWo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 10 Apr 2015 10:22:44 -0400
Content-Disposition: inline
In-Reply-To: <1697288.aUGCRhyl06@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 10, 2015 at 04:09:10PM +0200, Stephan Mueller wrote:
> Am Freitag, 10. April 2015, 16:00:03 schrieb Hannes Frederic Sowa:
>=20
> Hi Hannes,
>=20
> >On Fr, 2015-04-10 at 15:25 +0200, Stephan Mueller wrote:
> >> I would like to bring up that topic again as I did some more analyses:
> >>=20
> >> For testing I used the following code:
> >>=20
> >> static inline void memset_secure(void *s, int c, size_t n)
> >> {
> >>=20
> >>         memset(s, c, n);
> >> =09
> >> 	BARRIER
> >>=20
> >> }
> >>=20
> >> where BARRIER is defined as:
> >>=20
> >> (1) __asm__ __volatile__("" : "=3Dr" (s) : "0" (s));
> >>=20
> >> (2) __asm__ __volatile__("": : :"memory");
> >>=20
> >> (3) __asm__ __volatile__("" : "=3Dr" (s) : "0" (s) : "memory");
> >
> >Hm, I wonder a little bit...
> >
> >Could you quickly test if you replace (s) with (n) just for the fun of
> >it? I don't know if we should ask clang people about that, at least it
> >is their goal to be as highly compatible with gcc inline asm.
>=20
> Using=20
>=20
>  __asm__ __volatile__("" : "=3Dr" (n) : "0" (n) : "memory");
>=20
> clang O2/3: no mov
>=20
> gcc O2/3: mov present
>=20
> =3D=3D> not good
>=20
>=20
> Using
>  __asm__ __volatile__("" : "=3Dr" (n) : "0" (n));
>=20
> clang O2/3: no mov
>=20
> gcc O2/3: no mov
>=20
>=20
> =3D=3D> not good
>=20
>=20
> What do you expect that change shall do?
>=20
> >
> >Thanks for looking into this!
> >
> >Bye,
> >Hannes
>=20
>=20
> Ciao
> Stephan

Thanks for the comprehensive testing! Clang 3.3 and was giving me good
results; didn't try newer versions.

I wonder what your tests give with an earlier suggestion of mine:

#define barrier(p) __asm__ __volatile__("": :"r"(p) :"memory")

void memzero_explicit(void *s, size_t count)
{
  memset(s, 0, count);
  barrier(s);
}

--mancha

--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJVJ9yQAAoJEB4VYy8JqhaDWhYP/0USC+FuAAa1X7L/j/GbJ4xG
VWUe1K73SS73SAbgup7QFoixE53Da+iLB9n0OgIFDSrweEbA6hxi8bsXj5KoRoPN
vlJy9LlJQNtPpKAhcHnAviJ1YXSlGMQkgggEtFGIc5fbnc8JURWl6k/onXBSE4cc
ugQrn9BRvCHS/X2UgGUm36WpIyCAQtW1k2uZO0Vvkgb2a+7ngfmbO8aG2rwKe+XE
jHYs+M29AazhJnsag7U/aZgdWr2U3hr0D5FBMY97g2NjKk0FnadM2U/rzwj6l8Ff
n9YWAOZr/F4lEZQZE3KpfTNnbx8NY2wQrOvZeiuZckC9CoLOlDdolO7ChYbcdKNb
PiD/APX1os0Y05fncAsNQ2M5Bl0ltkQL4S6nnJVGEW4hxzNqDPnIyApWNJkgpDPd
kPCwvubyxsgu1qnvf7gphGjILQrzIt85KjTIW+i2SZ1DEMbqIxJnWDFBRiGHKbCO
Ds3tgUSADxBOB7RBj0Yp1NW1lqm/qInQcSzIR10xOPCwKh+RV98uQkvJ2zNxtICz
t5obNJU25V+GFkGr10TyFmQlfdPS01xCYgZOA8LJWsEFjSuRbneaPvWEdQbA1CsX
sKG6UV5HUflUMDvtqTy0L+BgZxGSIBp8EIuDyQhJ/5uvN+T3gRAyzz4MvumrBlkZ
0SFMFbqB/W6sFQ1G5jSc
=Oinn
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
