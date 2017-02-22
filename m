From: Marcelo Cerri <marcelo.cerri@canonical.com>
Subject: Re: [PATCH 2/2] crypto: vmx - Use skcipher for xts fallback
Date: Wed, 22 Feb 2017 16:20:04 -0300
Message-ID: <20170222192004.GC20626@gallifrey>
References: <20170222180045.28341-1-pfsmorigo@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="oTHb8nViIGeoXxdp"
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org, paulus@samba.org,
 linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 davem@davemloft.net
To: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
Content-Disposition: inline
In-Reply-To: <20170222180045.28341-1-pfsmorigo@linux.vnet.ibm.com>
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


--oTHb8nViIGeoXxdp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

In addition to cbc comments:

On Wed, Feb 22, 2017 at 03:00:45PM -0300, Paulo Flabiano Smorigo wrote:
> Signed-off-by: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>
> ---
>  drivers/crypto/vmx/aes_xts.c | 32 ++++++++++++++++++--------------
>  1 file changed, 18 insertions(+), 14 deletions(-)
>=20
> diff --git a/drivers/crypto/vmx/aes_xts.c b/drivers/crypto/vmx/aes_xts.c
> index 24353ec3..a8245e1 100644
> --- a/drivers/crypto/vmx/aes_xts.c
> +++ b/drivers/crypto/vmx/aes_xts.c
> @@ -28,11 +28,12 @@
>  #include <crypto/aes.h>
>  #include <crypto/scatterwalk.h>
>  #include <crypto/xts.h>
> +#include <crypto/internal/skcipher.h>
> =20
>  #include "aesp8-ppc.h"
> =20
>  struct p8_aes_xts_ctx {
> -	struct crypto_blkcipher *fallback;
> +	struct crypto_skcipher *fallback;
>  	struct aes_key enc_key;
>  	struct aes_key dec_key;
>  	struct aes_key tweak_key;
> @@ -41,7 +42,7 @@ struct p8_aes_xts_ctx {
>  static int p8_aes_xts_init(struct crypto_tfm *tfm)
>  {
>  	const char *alg;
> -	struct crypto_blkcipher *fallback;
> +	struct crypto_skcipher *fallback;
>  	struct p8_aes_xts_ctx *ctx =3D crypto_tfm_ctx(tfm);
> =20
>  	if (!(alg =3D crypto_tfm_alg_name(tfm))) {
> @@ -50,7 +51,7 @@ static int p8_aes_xts_init(struct crypto_tfm *tfm)
>  	}
> =20
>  	fallback =3D
> -		crypto_alloc_blkcipher(alg, 0, CRYPTO_ALG_NEED_FALLBACK);
> +		crypto_alloc_skcipher(alg, 0, CRYPTO_ALG_NEED_FALLBACK);
>  	if (IS_ERR(fallback)) {
>  		printk(KERN_ERR
>  			"Failed to allocate transformation for '%s': %ld\n",
> @@ -60,9 +61,9 @@ static int p8_aes_xts_init(struct crypto_tfm *tfm)
>  	printk(KERN_INFO "Using '%s' as fallback implementation.\n",
>  		crypto_tfm_alg_driver_name((struct crypto_tfm *) fallback));
> =20
> -	crypto_blkcipher_set_flags(
> +	crypto_skcipher_set_flags(
>  		fallback,
> -		crypto_blkcipher_get_flags((struct crypto_blkcipher *)tfm));
> +		crypto_skcipher_get_flags((struct crypto_skcipher *)tfm));
>  	ctx->fallback =3D fallback;
> =20
>  	return 0;
> @@ -73,7 +74,7 @@ static void p8_aes_xts_exit(struct crypto_tfm *tfm)
>  	struct p8_aes_xts_ctx *ctx =3D crypto_tfm_ctx(tfm);
> =20
>  	if (ctx->fallback) {
> -		crypto_free_blkcipher(ctx->fallback);
> +		crypto_free_skcipher(ctx->fallback);
>  		ctx->fallback =3D NULL;
>  	}
>  }
> @@ -98,7 +99,7 @@ static int p8_aes_xts_setkey(struct crypto_tfm *tfm, co=
nst u8 *key,
>  	pagefault_enable();
>  	preempt_enable();
> =20
> -	ret +=3D crypto_blkcipher_setkey(ctx->fallback, key, keylen);
> +	ret +=3D crypto_skcipher_setkey(ctx->fallback, key, keylen);
>  	return ret;
>  }
> =20
> @@ -113,15 +114,18 @@ static int p8_aes_xts_crypt(struct blkcipher_desc *=
desc,
>  	struct blkcipher_walk walk;
>  	struct p8_aes_xts_ctx *ctx =3D
>  		crypto_tfm_ctx(crypto_blkcipher_tfm(desc->tfm));
> -	struct blkcipher_desc fallback_desc =3D {
> -		.tfm =3D ctx->fallback,
> -		.info =3D desc->info,
> -		.flags =3D desc->flags
> -	};
> =20
>  	if (in_interrupt()) {
> -		ret =3D enc ? crypto_blkcipher_encrypt(&fallback_desc, dst, src, nbyte=
s) :
> -                            crypto_blkcipher_decrypt(&fallback_desc, dst=
, src, nbytes);
> +		SKCIPHER_REQUEST_ON_STACK(req, ctx->fallback);
> +		skcipher_request_set_tfm(req, ctx->fallback);
> +		skcipher_request_set_callback(req, desc->flags, NULL, NULL);
> +		skcipher_request_set_crypt(req, src, dst, nbytes, desc->info);
> +		ret =3D crypto_skcipher_encrypt(req);

You probably don't want this crypto_skcipher_encrypt call.


> +		if (enc)
> +			crypto_skcipher_encrypt(req);
> +		else
> +			crypto_skcipher_decrypt(req);

And you should check the return values here.

> +		skcipher_request_zero(req);
>  	} else {
>  		preempt_disable();
>  		pagefault_disable();
> --=20
> 2.9.3
>=20

--=20
Regards,
Marcelo


--oTHb8nViIGeoXxdp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJYreRkAAoJEM8aS8c01e1Ha0QH/0nc46uFTDCvAu+YVPqOK5hB
xZzL6MMXLOzaV30iB0L3vndShjvQW09SWeL67kfTjtMs4k3aQ71ZNbL0V2sIgoXw
bkh3WQG3RglJ1DRtLJXdab0NLkudrExvUbXO59w9LeXgY7k7igNrpZdLMxQi0myP
kZAGgTxXmJUPUN8Xkj6q5pIeoprKMYbFqHID/KuE4TQ/b1AeEqBwvTo5UuX2bI0h
qhQpJREvSzXYVh6POyyyRhyhXeFjgGAeYjG14xqQvSFn8osUMkAaMEHRUReWje4z
WcJrukq9u9dJLmHnVG+DH8+MXNZKf+UpHCknNH98Sge+lsfwgHBU9EzFdjp0HxQ=
=YE9i
-----END PGP SIGNATURE-----

--oTHb8nViIGeoXxdp--
