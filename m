From: Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH 04/10] crypto: omap-aes: Use BIT() macro
Date: Thu, 2 Jul 2015 02:59:03 -0500
Message-ID: <20150702075903.GD4033@saruman.tx.rr.com>
References: <1435814320-30347-1-git-send-email-lokeshvutla@ti.com>
 <1435814320-30347-5-git-send-email-lokeshvutla@ti.com>
Reply-To: <balbi@ti.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ylS2wUBXLOxYXZFQ"
Cc: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
	<davem@davemloft.net>, <linux-omap@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <t-kristo@ti.com>, <nsekhar@ti.com>
To: Lokesh Vutla <lokeshvutla@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:42083 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbbGBH7H (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Jul 2015 03:59:07 -0400
Content-Disposition: inline
In-Reply-To: <1435814320-30347-5-git-send-email-lokeshvutla@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

--ylS2wUBXLOxYXZFQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 02, 2015 at 10:48:34AM +0530, Lokesh Vutla wrote:
> Use BIT()/GENMASK() macros for all register definitions instead of
> hand-writing bit masks.
>=20
> Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
> ---
>  drivers/crypto/omap-aes.c |   36 ++++++++++++++++++------------------
>  1 file changed, 18 insertions(+), 18 deletions(-)
>=20
> diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
> index 96fc7f7..d974ab6 100644
> --- a/drivers/crypto/omap-aes.c
> +++ b/drivers/crypto/omap-aes.c
> @@ -52,30 +52,30 @@
>  #define AES_REG_IV(dd, x)		((dd)->pdata->iv_ofs + ((x) * 0x04))
> =20
>  #define AES_REG_CTRL(dd)		((dd)->pdata->ctrl_ofs)
> -#define AES_REG_CTRL_CTR_WIDTH_MASK	(3 << 7)
> -#define AES_REG_CTRL_CTR_WIDTH_32		(0 << 7)
> -#define AES_REG_CTRL_CTR_WIDTH_64		(1 << 7)
> -#define AES_REG_CTRL_CTR_WIDTH_96		(2 << 7)
> -#define AES_REG_CTRL_CTR_WIDTH_128		(3 << 7)
> -#define AES_REG_CTRL_CTR		(1 << 6)
> -#define AES_REG_CTRL_CBC		(1 << 5)
> -#define AES_REG_CTRL_KEY_SIZE		(3 << 3)
> -#define AES_REG_CTRL_DIRECTION		(1 << 2)
> -#define AES_REG_CTRL_INPUT_READY	(1 << 1)
> -#define AES_REG_CTRL_OUTPUT_READY	(1 << 0)
> -#define AES_REG_CTRL_MASK		FLD_MASK(24, 2)
> +#define AES_REG_CTRL_CTR_WIDTH_MASK	GENMASK(8, 7)
> +#define AES_REG_CTRL_CTR_WIDTH_32	0
> +#define AES_REG_CTRL_CTR_WIDTH_64	BIT(7)
> +#define AES_REG_CTRL_CTR_WIDTH_96	BIT(8)
> +#define AES_REG_CTRL_CTR_WIDTH_128	GENMASK(8, 7)
> +#define AES_REG_CTRL_CTR		BIT(6)
> +#define AES_REG_CTRL_CBC		BIT(5)
> +#define AES_REG_CTRL_KEY_SIZE		GENMASK(4, 3)
> +#define AES_REG_CTRL_DIRECTION		BIT(2)
> +#define AES_REG_CTRL_INPUT_READY	BIT(1)
> +#define AES_REG_CTRL_OUTPUT_READY	BIT(0)
> +#define AES_REG_CTRL_MASK		GENMASK(24, 2)

this was defined a couple patches ago, why didn't you define it with
GENMASK() to start with ?

--=20
balbi

--ylS2wUBXLOxYXZFQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVlO9HAAoJEIaOsuA1yqRECioP/1kwAQbNsyZy7pSYknePxx0/
HagQsAMXpgNWZyR75RuFxG2ww3bM78MmhxyrpC6XhnNotmeL6E+kXnGWES3sjatg
9xTiPVmnFNwi4Bie1tVZ39MScHAWz+mwGa21E7DDztlIu2AKTwvLAqmmGxNXu9kk
b4K+IT2f/0tMdhTAkZjqavrwHB49MzUDvcTiAlBHPe/fFDRzoF0/4YoIXOyBdkda
DPHLNZEmq943E0N4cDfUYnaK3rb9YjC9tjxMDIUbF1TlUwDuHv9X+tEV3PQjdcJT
BAoLuUU5a4YFX8c2XeO/sQHFI9Q9i0H8pFHuFvm6QCOv11UoMyg2bq79HlU0kd8q
cImNd8GbZUu5J6F20d4pzgiWcfrY8+9mmix/ZrPxZ6QM+hzSCO/Qbz7GAyTDgc4G
iuSSmC3XkSUpEA3YRg/RaWe1QZMrAXlSBHDROBeJ/ki/qdQBr2ANc9MzvNMn6Kcn
jRHz/QEggcWdVRG5fZPTBzcLCL1z1CKkSSaegl5jTgyfWIaU1e6vOJ7wnI+1WzDU
Rh5G51PpDWKmVeNIDhxjPe+WQ62/qt/C6tThvZMx5SpVhYMMZ1YRi2JhwJj1U6WO
utJ/uqSLrTcqsJ1nkRDBNS/pGELk7kCX+chfG64wGuJ7zlVjrmxtJC+MH+oxTM4g
PIqsTZaCIEWk8G2ggyhx
=2Raq
-----END PGP SIGNATURE-----

--ylS2wUBXLOxYXZFQ--
