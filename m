From: Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH 07/10] crypto: omap-aes: gcm: Add support for unaligned
 lengths
Date: Thu, 2 Jul 2015 03:05:16 -0500
Message-ID: <20150702080516.GG4033@saruman.tx.rr.com>
References: <1435814320-30347-1-git-send-email-lokeshvutla@ti.com>
 <1435814320-30347-8-git-send-email-lokeshvutla@ti.com>
Reply-To: <balbi@ti.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FwyhczKCDPOVeYh6"
Cc: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
	<davem@davemloft.net>, <linux-omap@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <t-kristo@ti.com>, <nsekhar@ti.com>
To: Lokesh Vutla <lokeshvutla@ti.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1435814320-30347-8-git-send-email-lokeshvutla@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--FwyhczKCDPOVeYh6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 02, 2015 at 10:48:37AM +0530, Lokesh Vutla wrote:
> Check if the inputs are not aligned, if not process
> the input before starting the hw acceleration.
> Similarly after completition of hw acceleration.
>=20
> Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>

and this ?

--=20
balbi

--FwyhczKCDPOVeYh6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVlPC8AAoJEIaOsuA1yqREmUYP/1r++TGpUyw4ARywvjtkg/J1
kIZovsUIvJ5e03zdc0e7sQhbFafawj/A8KS3O4L3zw7pN4+zGatWrs5HcYebqLzr
czFUdLOa8RE2u1NKyoWJ75kuY+9PNQz3ShSLm3lKbo1gQHAU3ySO/QZS6pK9DHyH
n5vhyfcEL8M+wV+8Sc+Xxn6NQOBr7K//tYvfAcXc3ZmFTROAKYs/scSEGEZzQ1EP
9FvXnzLqFSgZa06BmyceukT+m5opy73kSYCRcfuz3ZqVEfPY6fUmx1zKMmrgbGBM
o7Kr/q0QcfSKzxjFy/y9dtYIk6i7gJjchB/N7ii2yNIP0WGGVmAODJ0VBDo0y1cn
bF47fPGTxo8GjReaGPutHtore57tMVB7Yqi2b1wiSdv1ca0QhBSdbx1IR+Nx9U9k
CST0GfwfsN7pA8d2KWvY++sjDDMq9Bor/zyMCG4kf2AMTQSGGrWFEqhge1B2bx25
SZJwBX31mVDu8otZXf8tTHUxHx3NSU0YFwAoF//UoD+YNVNLJ108t+Ae5/I45i2A
6pxR4D+GhItEjwn2YbfaH2WF+cmGPoqjmRer4zBZUW2KCZ5GUEO5qUZWluq/jFzj
X8MvJ2kffj01ldlLw5kp/ED0XL8dG+oO61+feA8ne1K6pZhsjxAwfPT16nSvROhV
DXn78M+oMFWkQ3NxvGxV
=E8nt
-----END PGP SIGNATURE-----

--FwyhczKCDPOVeYh6--
