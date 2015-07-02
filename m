From: Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH 01/10] crypto: omap-aes: Add support for lengths not
 aligned with AES_BLOCK_SIZE
Date: Thu, 2 Jul 2015 02:53:41 -0500
Message-ID: <20150702075341.GA4033@saruman.tx.rr.com>
References: <1435814320-30347-1-git-send-email-lokeshvutla@ti.com>
 <1435814320-30347-2-git-send-email-lokeshvutla@ti.com>
Reply-To: <balbi@ti.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="liOOAslEiF7prFVr"
Cc: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
	<davem@davemloft.net>, <linux-omap@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <t-kristo@ti.com>, <nsekhar@ti.com>
To: Lokesh Vutla <lokeshvutla@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:39206 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262AbbGBHxq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Jul 2015 03:53:46 -0400
Content-Disposition: inline
In-Reply-To: <1435814320-30347-2-git-send-email-lokeshvutla@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 02, 2015 at 10:48:31AM +0530, Lokesh Vutla wrote:
> OMAP AES driver returns an error if the data is not aligned with
> AES_BLOCK_SIZE bytes.
> But OMAP AES hw allows data input upto 1 byte aligned, but still
> zeros are to be appended and complete AES_BLOCK_SIZE has to be written.
> And correct length has to be passed in LENGTH field.
> Adding support for inputs not aligned with AES_BLOCK_SIZE.
>=20
> Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
> ---
>  drivers/crypto/omap-aes.c |   33 ++++++++++++++++-----------------
>  1 file changed, 16 insertions(+), 17 deletions(-)
>=20
> diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
> index 9a28b7e..a923101 100644
> --- a/drivers/crypto/omap-aes.c
> +++ b/drivers/crypto/omap-aes.c
> @@ -558,6 +558,9 @@ static int omap_aes_check_aligned(struct scatterlist =
*sg, int total)
>  {
>  	int len =3D 0;
> =20
> +	if (!IS_ALIGNED(total, AES_BLOCK_SIZE))
> +		return -1;

-EINVAL?

--=20
balbi

--liOOAslEiF7prFVr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVlO4FAAoJEIaOsuA1yqREkPAP/A1r1Zl0TJUXgjetXKt/QTD4
UvdFIOWBIsr/cOifa0i0VBti4JobZgoukkCCEoaxAOLoqlHOToekJmoVEFhHHAyt
Lsjgz5zsyYtJkxhBY8C0Ui/uxYIW6xqtFVqdCu9Ka29xaTkE85pSfndZCiKmBnLc
dE8trqJOcJwwAnrZPni9Kpewle0/a025VzbBto3gyo42oH5f4ov5J0seW8lF+c6S
UIVFOptH4dmG0ZGMBP1VMKucV6s0JVLtOU1aHzqVXoDflQqOHdXYvHgP+fziUErL
0CkZ6Gd6gXsZZTol9AMkx/iJnXpdUAvUm/1Eb/31NnJF5+fTcSiepaWjgbT7Ew0d
ylJ9MxPYklHee6zFEZYRhhJ21uJYFY7Yeem+rPvS6lrPsZ5LV6//XyL/j69Q1L1o
/B20ewNmnlkMylT/oE3OvPRquVUJvG2/s2ekqNJwOFHqzt69R9lw08NL79OCPikt
iey/Do88mv6H4spyXV3r1D7lM4uA6BgqUKbwsVXUVdDQxPPVq3aX4MEt2w3JlZxl
4hYTgN/iYrCifx+9Fy3Tc8sJ3Yt1jhHKn2AkoHu2YIJ0p2NaJJVtPdEqTJrtEod+
0Xfz6/YITk/Ngv5LeR1cQHT7y1YWqfuE7KznC/ylwcOolsZjfHWyXHdLkp7+Tdiu
RfFRIoAW5cw9ZlXuvkVw
=x5/1
-----END PGP SIGNATURE-----

--liOOAslEiF7prFVr--
