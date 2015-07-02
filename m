From: Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH 02/10] crypto: omap-aes: Fix configuring of AES mode
Date: Thu, 2 Jul 2015 02:57:32 -0500
Message-ID: <20150702075732.GB4033@saruman.tx.rr.com>
References: <1435814320-30347-1-git-send-email-lokeshvutla@ti.com>
 <1435814320-30347-3-git-send-email-lokeshvutla@ti.com>
Reply-To: <balbi@ti.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bCsyhTFzCvuiizWE"
Cc: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
	<davem@davemloft.net>, <linux-omap@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <t-kristo@ti.com>, <nsekhar@ti.com>
To: Lokesh Vutla <lokeshvutla@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:42019 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbbGBH5h (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Jul 2015 03:57:37 -0400
Content-Disposition: inline
In-Reply-To: <1435814320-30347-3-git-send-email-lokeshvutla@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

--bCsyhTFzCvuiizWE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 02, 2015 at 10:48:32AM +0530, Lokesh Vutla wrote:
> AES_CTRL_REG is used to configure AES mode. Before configuring
> any mode we need to make sure all other modes are reset or else
> driver will misbehave. So mask all modes before configuring
> any AES mode.
>=20
> Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
> ---
>  drivers/crypto/omap-aes.c |   13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
> index a923101..96fc7f7 100644
> --- a/drivers/crypto/omap-aes.c
> +++ b/drivers/crypto/omap-aes.c
> @@ -63,6 +63,7 @@
>  #define AES_REG_CTRL_DIRECTION		(1 << 2)
>  #define AES_REG_CTRL_INPUT_READY	(1 << 1)
>  #define AES_REG_CTRL_OUTPUT_READY	(1 << 0)
> +#define AES_REG_CTRL_MASK		FLD_MASK(24, 2)

you end up masking bits which aren't even defined in this driver. What
are those bits ? Perhaps add macros for them and define
AES_REG_CTRL_MASK by explicitly ORing those macros ? That would, at
least, be clearer

--=20
balbi

--bCsyhTFzCvuiizWE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVlO7sAAoJEIaOsuA1yqREKF4P/AyPweTy6A0mZMGG2FMOqm5l
YN3qsnR+R0dnil+fP4W1LbZpZhXJWhZkFql5RbKtFzhhIEW809yhQGy/F+Dt/JNw
dHsSYMU23a7cgZIORNZ6TU/0tOmuQ+xpys01mcvFG2SXc/Bjvn7+g6uNMsaky8Gn
dxvSkd98+rztw1nBI+fRNt6Jq3fey76Cia5drndDCd9YSl5Y3NB+B6PWx9485rj6
SPR0YO/4FO/LuL7VxwsQmGvazK8v9/kHC6hD+5O5rPaYhkoOpGahlAtYDtZj18Y8
GnFBrYgazPGGxWKRZA7ftFuQ5Q4/U411Hm1FdbvN5cOljUF39xMn51cY7OImohzE
NL+bXAHi5ay9sxYftk59tuf8wB//xgU7/PycJwkl8UXZ00LmPHBM/Y7qgli7ekiE
8u76pWKoh1jY2Knlu5DJ/O2Ez/g0PGd75zjbd4rzXYCByXERmrNdG/SuQOu5StX3
UakXN28rumVIjONdjTpycNXXNz/wn+WPXtf1KAteEm8Ee6YwsAK26qt8bZiqMP9f
AjPFfhuwE0jsxHTBfkKgA6b5bJDaCV2yeA85jlU1gsPr0BXZd+g7oztMArICYSZg
smagzzgRIueg8vii2UCqim3KrjE3FDhBNcjSuU278QOxA+/NngOj37Pke94Kfb03
EfhIFYYuHE33wh9Tm25x
=PBGq
-----END PGP SIGNATURE-----

--bCsyhTFzCvuiizWE--
