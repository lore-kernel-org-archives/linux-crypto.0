From: mancha security <mancha1@zoho.com>
Subject: Re: [BUG/PATCH] kernel RNG and its secrets
Date: Fri, 10 Apr 2015 20:09:04 +0000
Message-ID: <20150410200904.GB16910@zoho.com>
References: <20150318095345.GA12923@zoho.com>
 <1697288.aUGCRhyl06@tauon>
 <20150410142208.GA16910@zoho.com>
 <1611407.vmKOV6O1rC@tauon>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="qcHopEYAB45HaUaB"
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>,
	Daniel Borkmann <daniel@iogearbox.net>, tytso@mit.edu,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au, dborkman@redhat.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sender1.zohomail.com ([74.201.84.155]:35294 "EHLO
	sender1.zohomail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbbDJUJq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 10 Apr 2015 16:09:46 -0400
Content-Disposition: inline
In-Reply-To: <1611407.vmKOV6O1rC@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--qcHopEYAB45HaUaB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 10, 2015 at 04:33:17PM +0200, Stephan Mueller wrote:
> Am Freitag, 10. April 2015, 14:22:08 schrieb mancha security:
>=20
> Hi mancha,
>=20
> >__asm__ __volatile__("": :"r"(p) :"memory")
>=20
> gcc -O2/3: mov present
>=20
> clang -O2/3: mov present
>=20
> =3D=3D> approach would be good too.
>=20
> Note, the assembly code does not seem to change whether to use this appro=
ach=20
> or the one I initially tested.
>=20
>=20
> Ciao
> Stephan

Hi Stephan.

Many thanks for confirmation.

--qcHopEYAB45HaUaB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIbBAEBCgAGBQJVKC3gAAoJEB4VYy8JqhaDQaYP+Nmg5aCy4TiZmGGVoM5s4GpB
DQ2dGpGjd9iHmTVm1Ykpvl6IIIPVwtDVAa8uVQlO2AcdA/zAMDqzMXBgRSu7rYLx
gwT5csHzlBcJTgCXm8cfG0Bmb+C82ygJP5Wl/4NuqeQmlrkjzjmNzKgKCSL+95g6
igWL0TKYQ4pLNTg/ZEMVJwokUO5l810rQsoPo3eaYFTKPT+HFnp26I2jRhflaYtl
Wuyyz8KV+R20uzT3+YTuyXCHyTqzz6PPafdSHpV4EK09kVJsEYt66raBCpIFzQ6R
i5jqTuf+EyR2kWlZEdo0lJBBz0INlw9v5xOzb0z97U6Q+SFY9yKg4HaxDjxvD6IZ
w9i/n9oageYWOiMLT4ao8oBvY5Kg65Y/2ZA3QqNN/ed4nTs3G1SnVOWU0cHH5RDI
Q2RzM3BIWTDdglo8/g/fbZ1VDVLol+YdxIHdl5MkaGIKY1Z2KgmQUVEOgJKdSgcS
5y5g6xqqXyNbmYsw7rRGGJmzlDXvPwgR+ADDPrr/8MRCfXSx2MJEGet68ErzeQ3y
Rv8qW9cI4VtcuogjiVCbsORZbVhm0f9ujFYeyJu472VJZwNT5LBaczKokbojPSbG
Mt1YeHckI2w2vKZixorGGsRXhwyvHzFK8TuKAa6bD0c/q1FkhqHc5wQ56DOV0heE
uvrtzcd8x0e+e94BUGE=
=7NhV
-----END PGP SIGNATURE-----

--qcHopEYAB45HaUaB--
