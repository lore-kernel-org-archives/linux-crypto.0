From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: Re: rfc4543 testvectors in testmgr.h kernel
Date: Tue, 10 Feb 2015 19:39:22 +0200
Message-ID: <54DA424A.7080909@iki.fi>
References: <20150210162243.GH32656@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="Qeb0g8Tg15MORGtRfgr6C1VlRuJHnASfW"
Cc: Marcus Meissner <meissner@suse.de>
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36759 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752274AbbBJRje (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Feb 2015 12:39:34 -0500
In-Reply-To: <20150210162243.GH32656@suse.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Qeb0g8Tg15MORGtRfgr6C1VlRuJHnASfW
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 10.02.2015 18:22, Marcus Meissner wrote:
> Hi Jussi,
>=20
> We were trying to use rfc4543(gcm(aes)) in the kernel for FIPS mode,
> but the testvectors seem to fail.

You probably need to add '.fips_allowed =3D 1,' in testmgr.c for "rfc4543=
(gcm(aes))" to enable algorithm in fips mode.

>=20
> Did you verify that they work? Are these the ones from Page 18 of=20
> https://tools.ietf.org/html/draft-mcgrew-gcm-test-01, as there the "pla=
intext"=20
> and "aaad" seem to be switched?

rfc4543() wrapper constructs the aad from '.assoc' and '.input'.

-Jussi

>=20
> Ciao, Marcus
>=20



--Qeb0g8Tg15MORGtRfgr6C1VlRuJHnASfW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQGcBAEBCgAGBQJU2kJSAAoJEAaL+yOpMWaGe7UL/Am5aiA2cmy5WGPpsNtcVDZo
nCw561EK+jGbcrv2tXNvJRR1yOYXh0hxNT4VxQRJEM1gE8pBjyzY0DYl//EZn3/q
DFYdj5NnbrgLygZKbLETuZfv2KR1Uot2jdCDAG9b2QrZMvU6h0zmhqFFUk7+g7hH
A75E9s3zzzYjy/jufvs8RKSRiIwWA/O/w/RSOyxU90H9P1if/gp2FzmuQbFkqaV/
+O5TpusPqvieHwpjjnJ7q3H5TvxUpqhoFhf35vJJZ04iibi9RitW1zLFa/IAgHLt
n765hpvSgwUEkC+1Evu3lia7s42WL6vEGAxXz/oa0PeYUkoQ0hQInAryGUYMyZHE
CZ+NfaK4cdUn3MIqbwpIRyMK2OyB7nTsXxblMi/j8B0MBjJ7/j9EI5JHdInYC2Ff
R+FwDJJVhrbJ2VkHjOUf9bG2FDjiqpFxe2Oeu9DUbgFFMg5UmkE0oiv6iPJj+4zJ
tNtfWyb+EdU3wo6RDFcereeKFKc/v37tUKU4uKRC9Q==
=q+3b
-----END PGP SIGNATURE-----

--Qeb0g8Tg15MORGtRfgr6C1VlRuJHnASfW--
