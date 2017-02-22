From: Marcelo Cerri <marcelo.cerri@canonical.com>
Subject: Re: [PATCH 1/2] crypto: vmx - Use skcipher for cbc fallback
Date: Wed, 22 Feb 2017 16:18:19 -0300
Message-ID: <20170222191819.GB20626@gallifrey>
References: <20170222180015.27573-1-pfsmorigo@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="QTprm0S8XgL7H0Dt"
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org, paulus@samba.org,
 linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 davem@davemloft.net
To: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
Content-Disposition: inline
In-Reply-To: <20170222180015.27573-1-pfsmorigo@linux.vnet.ibm.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Id: linux-crypto.vger.kernel.org


--QTprm0S8XgL7H0Dt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paulo.

On Wed, Feb 22, 2017 at 03:00:15PM -0300, Paulo Flabiano Smorigo wrote:
> Signed-off-by: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>
> ---
>  drivers/crypto/vmx/aes_cbc.c | 41 ++++++++++++++++++++------------------=
---
>  1 file changed, 20 insertions(+), 21 deletions(-)
>=20
> diff --git a/drivers/crypto/vmx/aes_cbc.c b/drivers/crypto/vmx/aes_cbc.c
> index 94ad5c0..5aa70997 100644
> --- a/drivers/crypto/vmx/aes_cbc.c
> +++ b/drivers/crypto/vmx/aes_cbc.c
> @@ -27,11 +27,12 @@
>  #include <asm/switch_to.h>
>  #include <crypto/aes.h>
>  #include <crypto/scatterwalk.h>
> +#include <crypto/internal/skcipher.h>

Isn't crypto/skcipher.h enough?

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
> @@ -48,7 +49,7 @@ static int p8_aes_cbc_init(struct crypto_tfm *tfm)
>  	}
> =20
>  	fallback =3D
> -	    crypto_alloc_blkcipher(alg, 0, CRYPTO_ALG_NEED_FALLBACK);
> +	    crypto_alloc_skcipher(alg, 0, CRYPTO_ALG_NEED_FALLBACK);
>  	if (IS_ERR(fallback)) {
>  		printk(KERN_ERR
>  		       "Failed to allocate transformation for '%s': %ld\n",
> @@ -58,9 +59,9 @@ static int p8_aes_cbc_init(struct crypto_tfm *tfm)
>  	printk(KERN_INFO "Using '%s' as fallback implementation.\n",
>  	       crypto_tfm_alg_driver_name((struct crypto_tfm *) fallback));
> =20
> -	crypto_blkcipher_set_flags(
> +	crypto_skcipher_set_flags(
>  		fallback,
> -		crypto_blkcipher_get_flags((struct crypto_blkcipher *)tfm));
> +		crypto_skcipher_get_flags((struct crypto_skcipher *)tfm));
>  	ctx->fallback =3D fallback;
> =20
>  	return 0;
> @@ -71,7 +72,7 @@ static void p8_aes_cbc_exit(struct crypto_tfm *tfm)
>  	struct p8_aes_cbc_ctx *ctx =3D crypto_tfm_ctx(tfm);
> =20
>  	if (ctx->fallback) {
> -		crypto_free_blkcipher(ctx->fallback);
> +		crypto_free_skcipher(ctx->fallback);
>  		ctx->fallback =3D NULL;
>  	}
>  }
> @@ -91,7 +92,7 @@ static int p8_aes_cbc_setkey(struct crypto_tfm *tfm, co=
nst u8 *key,
>  	pagefault_enable();
>  	preempt_enable();
> =20
> -	ret +=3D crypto_blkcipher_setkey(ctx->fallback, key, keylen);
> +	ret +=3D crypto_skcipher_setkey(ctx->fallback, key, keylen);
>  	return ret;
>  }
> =20
> @@ -103,15 +104,14 @@ static int p8_aes_cbc_encrypt(struct blkcipher_desc=
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

Probably you have to wait for the completion here before proceeding.

Check Documentation/crypto/api-samples.rst


>  	} else {
>  		preempt_disable();
>  		pagefault_disable();
> @@ -144,15 +144,14 @@ static int p8_aes_cbc_decrypt(struct blkcipher_desc=
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

Same here.


>  	} else {
>  		preempt_disable();
>  		pagefault_disable();
> --=20
> 2.9.3
>=20

--=20
Regards,
Marcelo


--QTprm0S8XgL7H0Dt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJYreP7AAoJEM8aS8c01e1H5fAIAI4h1tZEGZtciGQZfKbh0z6S
7NCgOVXd/d7Rv/taxc6Qfut38JcB8ZIYssT79usDkdJsjL8mkdBkYpT0IJIdeZNd
fZE1abzCOuijTPy1e6JVcHkBEBPpZoZXhVsMZJnfmWmMydyUGuEJ7X1H2G+Yduii
RRQIBAzj9c/paoB3FLLLjqdcBz/ouMlTAjG3t0t4erHLQfTEwnEpNjWmG/LRDFpa
dU+m+rrRfnO5A5FwJVsvWyVFVidJIghAtpLAP/zXv+Zeaih+DArDZwnN4a1lPo9u
Ew1QikudmmIZZfUb5tRw/RdfL+vnsZT9VwqtqoFxXvFjDRt6fhomHhEP0BhSmBw=
=syFn
-----END PGP SIGNATURE-----

--QTprm0S8XgL7H0Dt--
