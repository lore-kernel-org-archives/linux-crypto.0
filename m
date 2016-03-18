From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 02/10] crypto: rsa_helper - add raw integer parser actions
Date: Fri, 18 Mar 2016 20:46:51 +0100
Message-ID: <3040533.U92nQRUNV9@tauon.atsec.com>
References: <1458325927-14737-1-git-send-email-tudor-dan.ambarus@nxp.com> <1458325927-14737-2-git-send-email-tudor-dan.ambarus@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: herbert@gondor.apana.org.au, tadeusz.struk@intel.com,
	linux-crypto@vger.kernel.org, horia.geanta@nxp.com
To: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:33144 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762AbcCRTqy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Mar 2016 15:46:54 -0400
In-Reply-To: <1458325927-14737-2-git-send-email-tudor-dan.ambarus@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 18. M=E4rz 2016, 20:31:59 schrieb Tudor Ambarus:

Hi Tudor,

> Dedicated to RSA (hardware) implementations that want to use
> raw integers instead of MPI keys.
>=20
> Signed-off-by: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
> ---
>  crypto/rsa.c                  |  15 ----
>  crypto/rsa_helper.c           | 158
> ++++++++++++++++++++++++++++++++++++++++++ include/crypto/internal/rs=
a.h |=20
> 24 +++++++
>  3 files changed, 182 insertions(+), 15 deletions(-)
>=20
> diff --git a/crypto/rsa.c b/crypto/rsa.c
> index 2d53ad8..44baccf 100644
> --- a/crypto/rsa.c
> +++ b/crypto/rsa.c
> @@ -235,21 +235,6 @@ err_free_m:
>  	return ret;
>  }
>=20
> -static int rsa_check_key_length(unsigned int len)
> -{
> -	switch (len) {
> -	case 512:
> -	case 1024:
> -	case 1536:
> -	case 2048:
> -	case 3072:
> -	case 4096:
> -		return 0;
> -	}
> -
> -	return -EINVAL;
> -}
> -
>  static int rsa_set_pub_key(struct crypto_akcipher *tfm, const void *=
key,
>  			   unsigned int keylen)
>  {
> diff --git a/crypto/rsa_helper.c b/crypto/rsa_helper.c
> index 1ed32af..1708db8 100644
> --- a/crypto/rsa_helper.c
> +++ b/crypto/rsa_helper.c
> @@ -14,6 +14,9 @@
>  #include <linux/export.h>
>  #include <linux/err.h>
>  #include <linux/fips.h>
> +#include <linux/slab.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/device.h>
>  #include <crypto/internal/rsa.h>
>  #include "rsapubkey-asn1.h"
>  #include "rsaprivkey-asn1.h"
> @@ -190,3 +193,158 @@ void set_rsa_priv_action(struct rsa_asn1_action
> *action) action->get_n =3D rsa_get_mpi_n;
>  }
>  EXPORT_SYMBOL_GPL(set_rsa_priv_action);
> +
> +int rsa_check_key_length(unsigned int len)
> +{
> +	switch (len) {
> +	case 512:
> +	case 1024:
> +	case 1536:
> +	case 2048:
> +	case 3072:
> +	case 4096:
> +		return 0;
> +	}

I know that you copied the code to a new location that was there alread=
y. But=20
based on the discussion we had for DH, does it make sense that the kern=
el adds=20
such (artificial) limits?
> +
> +	return -EINVAL;
> +}
> +EXPORT_SYMBOL_GPL(rsa_check_key_length);
> +
> +int raw_rsa_get_n(void *context, size_t hdrlen, unsigned char tag,
> +		  const void *value, size_t vlen)
> +{
> +	struct rsa_raw_ctx *ctx =3D context;
> +	struct rsa_raw_key *key =3D &ctx->key;
> +	const char *ptr =3D value;
> +	int ret =3D -EINVAL;
> +
> +	while (!*ptr && vlen) {
> +		ptr++;
> +		vlen--;
> +	}
> +
> +	key->n_sz =3D vlen;
> +	/* In FIPS mode only allow key size 2K & 3K */
> +	if (fips_enabled && (key->n_sz !=3D 256 && key->n_sz !=3D 384)) {

Again, you copied that code that used to be there . But very very recen=
tly,=20
NIST allowed 4k keys too. May I ask to allow it here?

> +		dev_err(ctx->dev, "RSA: key size not allowed in FIPS mode\n");
> +		goto err;
> +	}
> +	/* invalid key size provided */
> +	ret =3D rsa_check_key_length(key->n_sz << 3);
> +	if (ret)
> +		goto err;
> +
> +	if (key->is_coherent)
> +		key->n =3D kzalloc(key->n_sz, key->flags);
> +	else
> +		key->n =3D dma_zalloc_coherent(ctx->dev, key->n_sz, &key->dma_n,
> +					     key->flags);
> +
> +	if (!key->n) {
> +		ret =3D -ENOMEM;
> +		goto err;
> +	}
> +
> +	memcpy(key->n, ptr, key->n_sz);
> +
> +	return 0;
> +err:
> +	key->n_sz =3D 0;
> +	key->n =3D NULL;
> +	return ret;
> +}
> +
> +int raw_rsa_get_e(void *context, size_t hdrlen, unsigned char tag,
> +		  const void *value, size_t vlen)
> +{
> +	struct rsa_raw_ctx *ctx =3D context;
> +	struct rsa_raw_key *key =3D &ctx->key;
> +	const char *ptr =3D value;
> +
> +	while (!*ptr && vlen) {
> +		ptr++;
> +		vlen--;
> +	}
> +
> +	key->e_sz =3D vlen;
> +
> +	if (!key->n_sz || !vlen || vlen > key->n_sz) {
> +		key->e =3D NULL;
> +		return -EINVAL;
> +	}
> +
> +	if (key->is_coherent)
> +		key->e =3D kzalloc(key->e_sz, key->flags);
> +	else
> +		key->e =3D dma_zalloc_coherent(ctx->dev, key->n_sz, &key->dma_e,
> +					     key->flags);
> +
> +	if (!key->e)
> +		return -ENOMEM;
> +
> +	if (key->is_coherent)
> +		memcpy(key->e, ptr, key->e_sz);
> +	else
> +		memcpy(key->e + (key->n_sz - vlen), ptr, vlen);
> +
> +	return 0;
> +}
> +
> +int raw_rsa_get_d(void *context, size_t hdrlen, unsigned char tag,
> +		  const void *value, size_t vlen)
> +{
> +	struct rsa_raw_ctx *ctx =3D context;
> +	struct rsa_raw_key *key =3D &ctx->key;
> +	const char *ptr =3D value;
> +	int ret =3D -EINVAL;
> +
> +	while (!*ptr && vlen) {
> +		ptr++;
> +		vlen--;
> +	}
> +
> +	if (!key->n_sz || !vlen || vlen > key->n_sz)
> +		goto err;
> +
> +	/* In FIPS mode only allow key size 2K & 3K */
> +	if (fips_enabled && (vlen !=3D 256 && vlen !=3D 384)) {
> +		dev_err(ctx->dev, "RSA: key size not allowed in FIPS mode\n");
> +		goto err;
> +	}
> +
> +	if (key->is_coherent)
> +		key->d =3D kzalloc(key->n_sz, key->flags);
> +	else
> +		key->d =3D dma_zalloc_coherent(ctx->dev, key->n_sz, &key->dma_d,
> +					     key->flags);
> +
> +	if (!key->n) {
> +		ret =3D -ENOMEM;
> +		goto err;
> +	}
> +
> +	if (key->is_coherent)
> +		memcpy(key->d, ptr, vlen);
> +	else
> +		memcpy(key->d + (key->n_sz - vlen), ptr, vlen);
> +
> +	return 0;
> +err:
> +	key->d =3D NULL;
> +	return ret;
> +}
> +
> +void set_raw_rsa_pub_action(struct rsa_asn1_action *action)
> +{
> +	action->get_e =3D raw_rsa_get_e;
> +	action->get_n =3D raw_rsa_get_n;
> +}
> +EXPORT_SYMBOL_GPL(set_raw_rsa_pub_action);
> +
> +void set_raw_rsa_priv_action(struct rsa_asn1_action *action)
> +{
> +	action->get_d =3D raw_rsa_get_d;
> +	action->get_e =3D raw_rsa_get_e;
> +	action->get_n =3D raw_rsa_get_n;
> +}
> +EXPORT_SYMBOL_GPL(set_raw_rsa_priv_action);
> diff --git a/include/crypto/internal/rsa.h b/include/crypto/internal/=
rsa.h
> index bf0f49d..7820e83 100644
> --- a/include/crypto/internal/rsa.h
> +++ b/include/crypto/internal/rsa.h
> @@ -20,6 +20,19 @@ struct rsa_mpi_key {
>  	MPI d;
>  };
>=20
> +struct rsa_raw_key {
> +	u8 *n;
> +	u8 *e;
> +	u8 *d;
> +	dma_addr_t dma_n;
> +	dma_addr_t dma_e;
> +	dma_addr_t dma_d;
> +	size_t n_sz;
> +	size_t e_sz;
> +	bool is_coherent;
> +	gfp_t flags;
> +};
> +
>  struct rsa_asn1_action {
>  	int (*get_n)(void *context, size_t hdrlen, unsigned char tag,
>  		     const void *value, size_t vlen);
> @@ -34,6 +47,12 @@ struct rsa_ctx {
>  	struct rsa_mpi_key key;
>  };
>=20
> +struct rsa_raw_ctx {
> +	struct rsa_asn1_action action;
> +	struct rsa_raw_key key;
> +	struct device *dev;
> +};
> +
>  void rsa_free_mpi_key(struct rsa_mpi_key *key);
>=20
>  int rsa_parse_mpi_pub_key(struct rsa_ctx *ctx, const void *key,
> @@ -44,5 +63,10 @@ int rsa_parse_mpi_priv_key(struct rsa_ctx *ctx, co=
nst
> void *key, void set_rsa_pub_action(struct rsa_asn1_action *action);
>  void set_rsa_priv_action(struct rsa_asn1_action *action);
>=20
> +int rsa_check_key_length(unsigned int len);
> +
> +void set_raw_rsa_pub_action(struct rsa_asn1_action *action);
> +void set_raw_rsa_priv_action(struct rsa_asn1_action *action);
> +
>  extern struct crypto_template rsa_pkcs1pad_tmpl;
>  #endif


Ciao
Stephan
