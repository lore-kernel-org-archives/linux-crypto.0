From: Cristian Stoica <cristian.stoica@nxp.com>
Subject: RE: [PATCH v2 2/4] crypto: rsa_helper - add raw integer parser
 actions
Date: Mon, 28 Mar 2016 16:48:03 +0000
Message-ID: <AM4PR0401MB18765DECEC32485B9D924D05E7860@AM4PR0401MB1876.eurprd04.prod.outlook.com>
References: <1458745459-1096-1-git-send-email-tudor-dan.ambarus@nxp.com>
 <1458745459-1096-3-git-send-email-tudor-dan.ambarus@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"smueller@chronox.de" <smueller@chronox.de>,
	Horia Ioan Geanta Neag <horia.geanta@nxp.com>,
	Tudor-Dan Ambarus <tudor-dan.ambarus@nxp.com>
To: Tudor-Dan Ambarus <tudor-dan.ambarus@nxp.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"tadeusz.struk@intel.com" <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-am1on0097.outbound.protection.outlook.com ([157.56.112.97]:23172
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753852AbcC1SVm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 28 Mar 2016 14:21:42 -0400
In-Reply-To: <1458745459-1096-3-git-send-email-tudor-dan.ambarus@nxp.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org [mailto:linux-crypto-
> owner@vger.kernel.org] On Behalf Of Tudor Ambarus
> Sent: Wednesday, March 23, 2016 5:04 PM
> To: herbert@gondor.apana.org.au; tadeusz.struk@intel.com
> Cc: linux-crypto@vger.kernel.org; smueller@chronox.de; Horia Ioan Geanta
> Neag <horia.geanta@nxp.com>; Tudor-Dan Ambarus <tudor-
> dan.ambarus@nxp.com>
> Subject: [PATCH v2 2/4] crypto: rsa_helper - add raw integer parser actions
> 
> Dedicated to RSA (hardware) implementations that want to use raw integers
> instead of MPI keys.
> 
> Signed-off-by: Tudor Ambarus <tudor-dan.ambarus@nxp.com>

Acked-by: Cristian Stoica <cristian.stoica@nxp.com>

> ---
>  crypto/rsa.c                  |  15 ----
>  crypto/rsa_helper.c           | 182
> ++++++++++++++++++++++++++++++++++++++++++
>  include/crypto/internal/rsa.h |  28 +++++++
>  3 files changed, 210 insertions(+), 15 deletions(-)
> 
> diff --git a/crypto/rsa.c b/crypto/rsa.c index 7cb0153..37ac189 100644
> --- a/crypto/rsa.c
> +++ b/crypto/rsa.c
> @@ -235,21 +235,6 @@ err_free_m:
>  	return ret;
>  }
> 
> -static int rsa_check_key_length(unsigned int len) -{
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
>  static int rsa_set_pub_key(struct crypto_akcipher *tfm, const void *key,
>  			   unsigned int keylen)
>  {
> diff --git a/crypto/rsa_helper.c b/crypto/rsa_helper.c index 0149ed3..df1f480
> 100644
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
> @@ -239,3 +242,182 @@ error:
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(rsa_parse_mpi_priv_key);
> +
> +int rsa_check_key_length(unsigned int len) {
> +	switch (len) {
> +	case 512:
> +	case 1024:
> +	case 1536:
> +	case 2048:
> +	case 3072:
> +	case 4096:
> +		return 0;
> +	}
> +
> +	return -EINVAL;
> +}
> +EXPORT_SYMBOL_GPL(rsa_check_key_length);
> +
> +void raw_rsa_free_key(struct rsa_raw_key *key) {
> +	kzfree(key->d);
> +	key->d = NULL;
> +
> +	kfree(key->e);
> +	key->e = NULL;
> +
> +	kfree(key->n);
> +	key->n = NULL;
> +
> +	key->n_sz = 0;
> +	key->e_sz = 0;
> +}
> +EXPORT_SYMBOL_GPL(raw_rsa_free_key);
> +
> +void raw_rsa_free_coherent_key(struct device *dev, struct rsa_raw_key
> +*key) {
> +	if (key->d) {
> +		memset(key->d, '\0', key->n_sz);
> +		dma_free_coherent(dev, key->n_sz, key->d, key->dma_d);
> +		key->d = NULL;
> +	}
> +
> +	if (key->e) {
> +		dma_free_coherent(dev, key->n_sz, key->e, key->dma_e);
> +		key->e = NULL;
> +	}
> +
> +	if (key->n) {
> +		dma_free_coherent(dev, key->n_sz, key->n, key->dma_n);
> +		key->n = NULL;
> +	}
> +
> +	key->n_sz = 0;
> +	key->e_sz = 0;
> +}
> +EXPORT_SYMBOL_GPL(raw_rsa_free_coherent_key);
> +
> +int raw_rsa_get_n(void *context, const void *value, size_t vlen) {
> +	struct rsa_raw_ctx *ctx = context;
> +	struct rsa_raw_key *key = &ctx->key;
> +	const char *ptr = value;
> +	int ret = -EINVAL;
> +
> +	while (!*ptr && vlen) {
> +		ptr++;
> +		vlen--;
> +	}
> +
> +	key->n_sz = vlen;
> +	/* In FIPS mode only allow key size 2K & 3K */
> +	if (fips_enabled && (key->n_sz != 256 && key->n_sz != 384)) {
> +		dev_err(ctx->dev, "RSA: key size not allowed in FIPS
> mode\n");
> +		goto err;
> +	}
> +	/* invalid key size provided */
> +	ret = rsa_check_key_length(key->n_sz << 3);
> +	if (ret)
> +		goto err;
> +
> +	if (key->is_coherent)
> +		key->n = kzalloc(key->n_sz, key->flags);
> +	else
> +		key->n = dma_zalloc_coherent(ctx->dev, key->n_sz, &key-
> >dma_n,
> +					     key->flags);
> +
> +	if (!key->n) {
> +		ret = -ENOMEM;
> +		goto err;
> +	}
> +
> +	memcpy(key->n, ptr, key->n_sz);
> +
> +	return 0;
> +err:
> +	key->n_sz = 0;
> +	key->n = NULL;
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(raw_rsa_get_n);
> +
> +int raw_rsa_get_e(void *context, const void *value, size_t vlen) {
> +	struct rsa_raw_ctx *ctx = context;
> +	struct rsa_raw_key *key = &ctx->key;
> +	const char *ptr = value;
> +	size_t offset = 0;
> +
> +	while (!*ptr && vlen) {
> +		ptr++;
> +		vlen--;
> +	}
> +
> +	key->e_sz = vlen;
> +
> +	if (!key->n_sz || !vlen || vlen > key->n_sz) {
> +		key->e = NULL;
> +		return -EINVAL;
> +	}
> +
> +	if (key->is_coherent) {
> +		key->e = kzalloc(key->e_sz, key->flags);
> +	} else {
> +		key->e = dma_zalloc_coherent(ctx->dev, key->n_sz, &key-
> >dma_e,
> +					     key->flags);
> +		offset = key->n_sz - vlen;
> +	}
> +
> +	if (!key->e)
> +		return -ENOMEM;
> +
> +	memcpy(key->e + offset, ptr, vlen);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(raw_rsa_get_e);
> +
> +int raw_rsa_get_d(void *context, const void *value, size_t vlen) {
> +	struct rsa_raw_ctx *ctx = context;
> +	struct rsa_raw_key *key = &ctx->key;
> +	const char *ptr = value;
> +	size_t offset = 0;
> +	int ret = -EINVAL;
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
> +	if (fips_enabled && (vlen != 256 && vlen != 384)) {
> +		dev_err(ctx->dev, "RSA: key size not allowed in FIPS
> mode\n");
> +		goto err;
> +	}
> +
> +	if (key->is_coherent) {
> +		key->d = kzalloc(key->n_sz, key->flags);
> +	} else {
> +		key->d = dma_zalloc_coherent(ctx->dev, key->n_sz, &key-
> >dma_d,
> +					     key->flags);
> +		offset = key->n_sz - vlen;
> +	}
> +
> +	if (!key->d) {
> +		ret = -ENOMEM;
> +		goto err;
> +	}
> +
> +	memcpy(key->d + offset, ptr, vlen);
> +
> +	return 0;
> +err:
> +	key->d = NULL;
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(raw_rsa_get_d);
> diff --git a/include/crypto/internal/rsa.h b/include/crypto/internal/rsa.h
> index f8ef7b1..854b9b7 100644
> --- a/include/crypto/internal/rsa.h
> +++ b/include/crypto/internal/rsa.h
> @@ -31,11 +31,30 @@ struct rsa_mpi_key {
>  	MPI d;
>  };
> 
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
>  struct rsa_ctx {
>  	const struct rsa_asn1_action *action;
>  	struct rsa_mpi_key key;
>  };
> 
> +struct rsa_raw_ctx {
> +	const struct rsa_asn1_action *action;
> +	struct rsa_raw_key key;
> +	struct device *dev;
> +};
> +
>  int rsa_get_mpi_n(void *context, const void *value, size_t vlen);  int
> rsa_get_mpi_e(void *context, const void *value, size_t vlen);  int
> rsa_get_mpi_d(void *context, const void *value, size_t vlen); @@ -47,5
> +66,14 @@ int rsa_parse_mpi_pub_key(struct rsa_ctx *ctx, const void *key,
> int rsa_parse_mpi_priv_key(struct rsa_ctx *ctx, const void *key,
>  			   unsigned int key_len);
> 
> +int rsa_check_key_length(unsigned int len);
> +
> +void raw_rsa_free_key(struct rsa_raw_key *key); void
> +raw_rsa_free_coherent_key(struct device *dev, struct rsa_raw_key *key);
> +
> +int raw_rsa_get_n(void *context, const void *value, size_t vlen); int
> +raw_rsa_get_e(void *context, const void *value, size_t vlen); int
> +raw_rsa_get_d(void *context, const void *value, size_t vlen);
> +
>  extern struct crypto_template rsa_pkcs1pad_tmpl;  #endif
> --
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
