From: Marcelo Cerri <marcelo.cerri@canonical.com>
Subject: Re: [PATCH v2 1/2] crypto: vmx - Use skcipher for cbc fallback
Date: Sun, 26 Feb 2017 16:21:07 -0300
Message-ID: <20170226192107.GA7129@gallifrey>
References: <20170223112052.GA14019@gondor.apana.org.au>
 <20170224142354.10231-1-pfsmorigo@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
Cc: linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
        paulus@samba.org, mpe@ellerman.id.au, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
To: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:32894 "EHLO
        mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751253AbdBZTVV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 26 Feb 2017 14:21:21 -0500
Received: by mail-qk0-f174.google.com with SMTP id n127so69957493qkf.0
        for <linux-crypto@vger.kernel.org>; Sun, 26 Feb 2017 11:21:20 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20170224142354.10231-1-pfsmorigo@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 24, 2017 at 11:23:54AM -0300, Paulo Flabiano Smorigo wrote:
> Signed-off-by: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>
> ---
>  drivers/crypto/vmx/aes_cbc.c | 44 ++++++++++++++++++++++----------------=
------
>  1 file changed, 22 insertions(+), 22 deletions(-)
>=20
> diff --git a/drivers/crypto/vmx/aes_cbc.c b/drivers/crypto/vmx/aes_cbc.c
> index 94ad5c0..2bb5910 100644
> --- a/drivers/crypto/vmx/aes_cbc.c
> +++ b/drivers/crypto/vmx/aes_cbc.c
> @@ -27,11 +27,12 @@
>  #include <asm/switch_to.h>
>  #include <crypto/aes.h>
>  #include <crypto/scatterwalk.h>
> +#include <crypto/skcipher.h>
> =20
>  #include "aesp8-ppc.h"
> =20
>  struct p8_aes_cbc_ctx {
> -	struct crypto_blkcipher *fallback;
> +	struct crypto_skcipher *fallback;
>  	struct aes_key enc_key;
>  	struct aes_key dec_key;
>  };
> @@ -39,7 +40,7 @@ struct p8_aes_cbc_ctx {
>  static int p8_aes_cbc_init(struct crypto_tfm *tfm)
>  {
>  	const char *alg;
> -	struct crypto_blkcipher *fallback;
> +	struct crypto_skcipher *fallback;
>  	struct p8_aes_cbc_ctx *ctx =3D crypto_tfm_ctx(tfm);
> =20
>  	if (!(alg =3D crypto_tfm_alg_name(tfm))) {
> @@ -47,8 +48,9 @@ static int p8_aes_cbc_init(struct crypto_tfm *tfm)
>  		return -ENOENT;
>  	}
> =20
> -	fallback =3D
> -	    crypto_alloc_blkcipher(alg, 0, CRYPTO_ALG_NEED_FALLBACK);
> +	fallback =3D crypto_alloc_skcipher(alg, 0,
> +			CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
> +
>  	if (IS_ERR(fallback)) {
>  		printk(KERN_ERR
>  		       "Failed to allocate transformation for '%s': %ld\n",
> @@ -58,9 +60,9 @@ static int p8_aes_cbc_init(struct crypto_tfm *tfm)
>  	printk(KERN_INFO "Using '%s' as fallback implementation.\n",
>  	       crypto_tfm_alg_driver_name((struct crypto_tfm *) fallback));

You need to update that to use crypto_skcipher_tfm(). The same is valid
for the xts patch.

> =20
> -	crypto_blkcipher_set_flags(
> +	crypto_skcipher_set_flags(
>  		fallback,
> -		crypto_blkcipher_get_flags((struct crypto_blkcipher *)tfm));
> +		crypto_skcipher_get_flags((struct crypto_skcipher *)tfm));
>  	ctx->fallback =3D fallback;
> =20
>  	return 0;
> @@ -71,7 +73,7 @@ static void p8_aes_cbc_exit(struct crypto_tfm *tfm)
>  	struct p8_aes_cbc_ctx *ctx =3D crypto_tfm_ctx(tfm);
> =20
>  	if (ctx->fallback) {
> -		crypto_free_blkcipher(ctx->fallback);
> +		crypto_free_skcipher(ctx->fallback);
>  		ctx->fallback =3D NULL;
>  	}
>  }
> @@ -91,7 +93,7 @@ static int p8_aes_cbc_setkey(struct crypto_tfm *tfm, co=
nst u8 *key,
>  	pagefault_enable();
>  	preempt_enable();
> =20
> -	ret +=3D crypto_blkcipher_setkey(ctx->fallback, key, keylen);
> +	ret +=3D crypto_skcipher_setkey(ctx->fallback, key, keylen);
>  	return ret;
>  }
> =20
> @@ -103,15 +105,14 @@ static int p8_aes_cbc_encrypt(struct blkcipher_desc=
 *desc,
>  	struct blkcipher_walk walk;
>  	struct p8_aes_cbc_ctx *ctx =3D
>  		crypto_tfm_ctx(crypto_blkcipher_tfm(desc->tfm));
> -	struct blkcipher_desc fallback_desc =3D {
> -		.tfm =3D ctx->fallback,
> -		.info =3D desc->info,
> -		.flags =3D desc->flags
> -	};
> =20
>  	if (in_interrupt()) {
> -		ret =3D crypto_blkcipher_encrypt(&fallback_desc, dst, src,
> -					       nbytes);
> +		SKCIPHER_REQUEST_ON_STACK(req, ctx->fallback);
> +		skcipher_request_set_tfm(req, ctx->fallback);
> +		skcipher_request_set_callback(req, desc->flags, NULL, NULL);
> +		skcipher_request_set_crypt(req, src, dst, nbytes, desc->info);
> +		ret =3D crypto_skcipher_encrypt(req);
> +		skcipher_request_zero(req);
>  	} else {
>  		preempt_disable();
>  		pagefault_disable();
> @@ -144,15 +145,14 @@ static int p8_aes_cbc_decrypt(struct blkcipher_desc=
 *desc,
>  	struct blkcipher_walk walk;
>  	struct p8_aes_cbc_ctx *ctx =3D
>  		crypto_tfm_ctx(crypto_blkcipher_tfm(desc->tfm));
> -	struct blkcipher_desc fallback_desc =3D {
> -		.tfm =3D ctx->fallback,
> -		.info =3D desc->info,
> -		.flags =3D desc->flags
> -	};
> =20
>  	if (in_interrupt()) {
> -		ret =3D crypto_blkcipher_decrypt(&fallback_desc, dst, src,
> -					       nbytes);
> +		SKCIPHER_REQUEST_ON_STACK(req, ctx->fallback);
> +		skcipher_request_set_tfm(req, ctx->fallback);
> +		skcipher_request_set_callback(req, desc->flags, NULL, NULL);
> +		skcipher_request_set_crypt(req, src, dst, nbytes, desc->info);
> +		ret =3D crypto_skcipher_decrypt(req);
> +		skcipher_request_zero(req);
>  	} else {
>  		preempt_disable();
>  		pagefault_disable();
> --=20
> 2.7.4
>=20

--=20
Regards,
Marcelo


--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJYsyqjAAoJEM8aS8c01e1HwU8IALrwS33SfOHTXNC9bjihapjf
k+ZVwd17vLe0wTAw1qYqvjwWvOTEqjzElm8A911ltu0uKy0ZFL30Kq80+zIJir6k
DxTTWx5b/99+98gc9xr2beBEH4fXeK475cdWmRerYBMsU5qY0zV1DMP4DTgD8s2u
CcScieeAkHPH17dOq1J1xydg3HMyeoJApzGkH33dOcTJLaZRiNTc/yYVLWEtOeDr
YsuqcENZgPvOu2dhMREmYWFO02aG00u6FNDMC3zrIDB7pPP08OCfs0CzhIKY6r7r
DNDwePfTTZXvyVNC8Kkwxq7ILLEfNsTJfpT9l4ggfzBAP+hpAgY9vA47ReGRBTU=
=h4n3
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
