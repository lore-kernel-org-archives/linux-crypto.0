From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: Re: [PATCH 1/2] crypto: inside-secure - fix invalidation check in
 hmac_sha1_setkey
Date: Tue, 18 Jul 2017 15:07:32 +0200
Message-ID: <20170718130732.GF2563@kwain>
References: <20170717094520.3497-1-antoine.tenart@free-electrons.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="tmoQ0UElFV5VgXgH"
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:57437 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751378AbdGRNHn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 09:07:43 -0400
Content-Disposition: inline
In-Reply-To: <20170717094520.3497-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--tmoQ0UElFV5VgXgH
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jul 17, 2017 at 11:45:19AM +0200, Antoine Tenart wrote:
> The safexcel_hmac_sha1_setkey function checks if an invalidation command
> should be issued, i.e. when the context ipad/opad change. This checks is
> done after filling the ipad/opad which and it can't be true. The patch
> fixes this by moving the check before the ipad/opad memcpy operations.
>=20
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>

This patch should have stable: and fixes: tags. I'll add them and send a
v2.

Thanks,
Antoine

> ---
>  drivers/crypto/inside-secure/safexcel_hash.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypt=
o/inside-secure/safexcel_hash.c
> index 8527a5899a2f..a11b2edb41b9 100644
> --- a/drivers/crypto/inside-secure/safexcel_hash.c
> +++ b/drivers/crypto/inside-secure/safexcel_hash.c
> @@ -883,9 +883,6 @@ static int safexcel_hmac_sha1_setkey(struct crypto_ah=
ash *tfm, const u8 *key,
>  	if (ret)
>  		return ret;
> =20
> -	memcpy(ctx->ipad, &istate.state, SHA1_DIGEST_SIZE);
> -	memcpy(ctx->opad, &ostate.state, SHA1_DIGEST_SIZE);
> -
>  	for (i =3D 0; i < ARRAY_SIZE(istate.state); i++) {
>  		if (ctx->ipad[i] !=3D le32_to_cpu(istate.state[i]) ||
>  		    ctx->opad[i] !=3D le32_to_cpu(ostate.state[i])) {
> @@ -894,6 +891,9 @@ static int safexcel_hmac_sha1_setkey(struct crypto_ah=
ash *tfm, const u8 *key,
>  		}
>  	}
> =20
> +	memcpy(ctx->ipad, &istate.state, SHA1_DIGEST_SIZE);
> +	memcpy(ctx->opad, &ostate.state, SHA1_DIGEST_SIZE);
> +
>  	return 0;
>  }
> =20
> --=20
> 2.13.3
>=20

--=20
Antoine T=E9nart, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--tmoQ0UElFV5VgXgH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEM7Tg8N8kXOlT7hOhXE2LyK3bvNgFAlluCBQACgkQXE2LyK3b
vNgTQw//SA0mpFUfuNUDkLFga0Wu7ZdhFI3S8Wi8stlMEHixAMkNJo7CBJmXph7r
XkC/Lxw530bgWWat3vltfV86KzODCuhgrD4D2IRydb2iLsbHJgoNAM3orSLR6uLy
NsOTr3CWCCl+GXBuyVDJucQTSC6rrSD1JWELL6OORxC+F9dMEJXuQMLoBHcoNQJj
7LUSUNkCf+CCVuQekfhfOIddKZtrlG+LcQ4kl/Ety5l1zq9zGvgBlUR57cyecOlm
E7Xun1hzAuOY6Beyul39PGkzwGtNZId4qwI4MF4vjTGwwi5pmRwtrqhVKJ1If6Lm
9+f+RAJTfIsVgVCUKPspwN4qrvAcrFFh26CZh+dHPk2go1L5K9fWiDhtz9RRWNUb
PXnWIXDyplfll6GMgUIf5fh7PRXkXmjyxqjIlJBscYFxV2HvMMHt3iVyU8wqD3bv
hFdUEljn5gw0PLwWGjNAMG5t8q59iQwpqCVMKUgrO2Lrlobk6pX6dL5e2dYHXV4T
OIQe39995rmJSHbwP5J1TQLajdKUwMXFvDEFRwhiyV17KwtTef+lK/NqKVK5iHkr
Tk7N/x8Iq5R5rMHTrKshtOI6T4T4OQgzCcyF7VdLE4JtYVp9J50Tc3/WPMOJF5r/
BkZZcopmTl5Q5gCwj+9sbfMTPUELzsrYEDEImklGM6twKDmpIqw=
=x/Nk
-----END PGP SIGNATURE-----

--tmoQ0UElFV5VgXgH--
