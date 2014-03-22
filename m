From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH v3] crypto: caam - power management support for caam
 job-ring
Date: Sat, 22 Mar 2014 16:24:16 +0000
Message-ID: <1395505456.2770.70.camel@deadeye.wl.decadent.org.uk>
References: <1395341456-60542-1-git-send-email-yashpal.dutta@freescale.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Cr+0hl0GQHeg/SBX67c4"
Cc: linux-crypto@vger.kernel.org, horia.geanta@freescale.com,
	vakul@freescale.com, ruchika.gupta@freescale.com,
	stable@vger.kernel.org
To: Yashpal Dutta <yashpal.dutta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37757 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751655AbaCVQYY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 22 Mar 2014 12:24:24 -0400
In-Reply-To: <1395341456-60542-1-git-send-email-yashpal.dutta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--=-Cr+0hl0GQHeg/SBX67c4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2014-03-21 at 00:35 +0545, Yashpal Dutta wrote:
> Job ring is suspended gracefully and resume afresh.
>=20
> Both Sleep (where device will remain powered-on) and Deep-sleep (where
> device will be powered-down are handled gracefully. Persistance sessions
> are not supported across deep-sleep.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Yashpal Dutta <yashpal.dutta@freescale.com>
> ---
>  drivers/crypto/caam/intern.h |   2 +
>  drivers/crypto/caam/jr.c     | 257 +++++++++++++++++++++++++++++++------=
------
>  2 files changed, 190 insertions(+), 69 deletions(-)
[...]

This is too big for stable; is a simpler fix possible?

Ben.

--=20
Ben Hutchings
I'm not a reverse psychological virus.  Please don't copy me into your sig.

--=-Cr+0hl0GQHeg/SBX67c4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAUy25MOe/yOyVhhEJAQr6OQ//biCONDc/MQ2M/IyBN0qNiE0Wv93CAxun
ZpOif+fvp/ptq9zb51ZdZ9vsg/XwKN4tNiNfHNsolmPTyEf/CYs7CnnLGkE5djr0
Ag+0E5oJzN1+8geCxpHP9QQiZfyfac1s+mFzzOzNAz4i3sFhcZ3KiBW4BFYl9vOG
EoibFJI1ldqEvAreT2Ub4sjbRUFhF3yMdkW1pV/dr4Tt/gbYOeS5v8LtBnjePGTO
6QQk9osEsdrgwVzeI7+7yX+Dzu5yokEpeAL6daV92MJ3AOY9gpy7V4Tte6WbEbfc
KKTI2DoYjLmsLYXil+yKxvgWdffdvVcEUkw8dKHlfCrmkspgb0Cw9ZijjOCj8H7d
BIezoTv0SN6pm6Y5DGW3t9k06t3R8LNecDErGfQz0WwC8ZnNpn3Oyl8m5HhmIKSC
vlMErn+iK5VI8xTvnQ7RXSAubsmpRfT46B2e05RUVlsakbIIwGb4m0S6ckUkS8Wg
AsGWFXplNJvsU0tljWA3fprhfRCXjTfLAcKtz7SIXLP5KjNBFcUmsncbh6lF0UDC
AZm2x9gq1LUK3JSGWm3H13j+VBuXhOXsz5N2D9pD48zvKKGL7leRuERApUwprIOU
Ck0B6sdtGfWMtxRS4ZGubwTXB3KfmZUuwNcLm2KxurghXJkxdWrdAgyr16kaKffT
AdrT3v/HGCM=
=v6EV
-----END PGP SIGNATURE-----

--=-Cr+0hl0GQHeg/SBX67c4--
