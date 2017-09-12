From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: Re: [PATCH] crypto: inside-secure - fix gcc-4.9 warnings
Date: Tue, 12 Sep 2017 13:22:33 +0200
Message-ID: <20170912112233.GA2851@kwain>
References: <20170912101232.3688217-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ofer Heifetz <oferh@marvell.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:33857 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751289AbdILLWf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Sep 2017 07:22:35 -0400
Content-Disposition: inline
In-Reply-To: <20170912101232.3688217-1-arnd@arndb.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

On Tue, Sep 12, 2017 at 12:12:16PM +0200, Arnd Bergmann wrote:
> All older compiler versions up to gcc-4.9 produce these
> harmless warnings:
>=20
> drivers/crypto/inside-secure/safexcel_cipher.c:389:9: warning: missing br=
aces around initializer [-Wmissing-braces]
> drivers/crypto/inside-secure/safexcel_cipher.c:389:9: warning: (near init=
ialization for =E2=80=98result.completion=E2=80=99) [-Wmissing-braces]
> drivers/crypto/inside-secure/safexcel_hash.c:422:9: warning: missing brac=
es around initializer [-Wmissing-braces]
> drivers/crypto/inside-secure/safexcel_hash.c:422:9: warning: (near initia=
lization for =E2=80=98result.completion=E2=80=99) [-Wmissing-braces]
>=20
> This changes the syntax to something that works on all versions
> without warnings.
>=20
> Fixes: 1b44c5a60c13 ("crypto: inside-secure - add SafeXcel EIP197 crypto =
engine driver")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Antoine Tenart <antoine.tenart@free-electrons.com>

Thanks!
Antoine

> ---
>  drivers/crypto/inside-secure/safexcel_cipher.c | 2 +-
>  drivers/crypto/inside-secure/safexcel_hash.c   | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/cry=
pto/inside-secure/safexcel_cipher.c
> index d2207ac5ba19..5438552bc6d7 100644
> --- a/drivers/crypto/inside-secure/safexcel_cipher.c
> +++ b/drivers/crypto/inside-secure/safexcel_cipher.c
> @@ -386,7 +386,7 @@ static int safexcel_cipher_exit_inv(struct crypto_tfm=
 *tfm)
>  	struct safexcel_cipher_ctx *ctx =3D crypto_tfm_ctx(tfm);
>  	struct safexcel_crypto_priv *priv =3D ctx->priv;
>  	struct skcipher_request req;
> -	struct safexcel_inv_result result =3D { 0 };
> +	struct safexcel_inv_result result =3D {};
>  	int ring =3D ctx->base.ring;
> =20
>  	memset(&req, 0, sizeof(struct skcipher_request));
> diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypt=
o/inside-secure/safexcel_hash.c
> index 3f819399cd95..3980f946874f 100644
> --- a/drivers/crypto/inside-secure/safexcel_hash.c
> +++ b/drivers/crypto/inside-secure/safexcel_hash.c
> @@ -419,7 +419,7 @@ static int safexcel_ahash_exit_inv(struct crypto_tfm =
*tfm)
>  	struct safexcel_ahash_ctx *ctx =3D crypto_tfm_ctx(tfm);
>  	struct safexcel_crypto_priv *priv =3D ctx->priv;
>  	struct ahash_request req;
> -	struct safexcel_inv_result result =3D { 0 };
> +	struct safexcel_inv_result result =3D {};
>  	int ring =3D ctx->base.ring;
> =20
>  	memset(&req, 0, sizeof(struct ahash_request));
> --=20
> 2.9.0
>=20

--=20
Antoine T=C3=A9nart, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEM7Tg8N8kXOlT7hOhXE2LyK3bvNgFAlm3w3cACgkQXE2LyK3b
vNhx0g/+J8uQ10XEXcdmXdsaIW1EZm/oRgbC4qo3TAxFH6YgbPo+uHsVbm5fFhqq
ZeAsfjElbYauHWqAA8QQuPnoN6mapreJKUaQejt9/b/12TCAB1wwr/JfQ4n16F9E
9gBbr9FTTJggVgNuVODzpleIEmhbGDeJ9BFhdlztoZApgXtJ4snVxZw5JW24ZE7C
GyiA6sD90MpID7XAVwWOPyFelMBI4CYhGo6LCeGLwVAkBEr9kkkKCF6+TDkkSmkJ
9GCfqLa7k/CrLeLmnSlFer0yYg1fI+hi0fB5sboAbohwEoD0aEsSKK95zvKtO4T2
kK6v7gC5WzQLZPd98ovPkZ/rChL9p70oUtWjHcO2o4HlErrvZKnRgeqUEF7EP5AA
aZd3sfQ2FolgRnLG95H0oB4VjcPVP+JDkWtIMb8niSkhUkUEgWa4OTaY3TTUV2Bg
pLg9QvpFJwhQqnuNDTY4OOqX1OTBN81OZskyNSPYCrCWrAM2KRV6xDL+PY3yikdk
YPAj2FwxTB45EdEpxD7lQhOEp62qCvWsy32iIj6nLLFBI4K9guHQypwHA6QbFnAc
bkUMC+KklHqsp/nvNcOXPcBRFOOERg69lr0x+ZSggOQKQszyt7XxnD6mm3e01vGZ
sKzXWG+vFKeQK8bbyA9ghMU9PtgndMKylzkoEqfS2pxtJ/hk6nU=
=YdH8
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--
