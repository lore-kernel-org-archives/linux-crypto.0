From: Tudor-Dan Ambarus <tudor-dan.ambarus@nxp.com>
Subject: RE: [PATCH] crypto: rsa - return raw integer for the ASN.1 parser
Date: Thu, 5 May 2016 10:25:55 +0000
Message-ID: <VI1PR04MB1311B7945557DB727564A928B87C0@VI1PR04MB1311.eurprd04.prod.outlook.com>
References: <1461934306-29190-1-git-send-email-tudor-dan.ambarus@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"Tudor-Dan Ambarus" <tudor-dan.ambarus@nxp.com>
To: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db3on0067.outbound.protection.outlook.com ([157.55.234.67]:58912
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756833AbcEEK7b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 May 2016 06:59:31 -0400
In-Reply-To: <1461934306-29190-1-git-send-email-tudor-dan.ambarus@nxp.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

This is related to the suggestion to move the DMA primitives
in the driver.

Please see inline.

> -----Original Message-----
> From: Tudor Ambarus [mailto:tudor-dan.ambarus@nxp.com]
> Sent: Friday, April 29, 2016 3:52 PM
> To: herbert@gondor.apana.org.au
> Cc: linux-crypto@vger.kernel.org; Tudor-Dan Ambarus
> Subject: [PATCH] crypto: rsa - return raw integer for the ASN.1 parser
> 
> Return the raw integer with no other processing.
> The scope is to have only one ANS.1 parser for the RSA keys.
> 
> Update the RSA software implementation so that it does
> the MPI conversion on top.
> 
> Signed-off-by: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
> ---
>  crypto/rsa.c                  | 122 ++++++++++++++---------
>  crypto/rsa_helper.c           | 224 ++++++++++++++++++++++++++++++++------
> ----
>  include/crypto/internal/rsa.h |  41 +++++++-
>  3 files changed, 287 insertions(+), 100 deletions(-)
> 
> diff --git a/crypto/rsa_helper.c b/crypto/rsa_helper.c
> index d226f48..492f37f 100644
> --- a/crypto/rsa_helper.c
> +++ b/crypto/rsa_helper.c
> @@ -14,136 +14,256 @@
>  int rsa_get_n(void *context, size_t hdrlen, unsigned char tag,
>  	      const void *value, size_t vlen)
>  {
> -	struct rsa_key *key = context;
> +	struct rsa_ctx *ctx = context;
> +	struct rsa_key *key = &ctx->key;
> +	const char *ptr = value;
> +	int ret = -EINVAL;
> 
> -	key->n = mpi_read_raw_data(value, vlen);
> -
> -	if (!key->n)
> -		return -ENOMEM;
> +	while (!*ptr && vlen) {
> +		ptr++;
> +		vlen--;
> +	}
> 
> +	key->n_sz = vlen;
>  	/* In FIPS mode only allow key size 2K & 3K */
> -	if (fips_enabled && (mpi_get_size(key->n) != 256 &&
> -			     mpi_get_size(key->n) != 384)) {
> -		pr_err("RSA: key size not allowed in FIPS mode\n");
> -		mpi_free(key->n);
> -		key->n = NULL;
> -		return -EINVAL;
> +	if (fips_enabled && (key->n_sz != 256 && key->n_sz != 384)) {
> +		dev_err(ctx->dev, "RSA: key size not allowed in FIPS mode\n");
> +		goto err;
>  	}
> +	/* invalid key size provided */
> +	ret = rsa_check_key_length(key->n_sz << 3);
> +	if (ret)
> +		goto err;
> +
> +	if (key->coherent)
> +		key->n = dma_zalloc_coherent(ctx->dev, key->n_sz, &key->dma_n,
> +					     key->flags);
> +	else
> +		key->n = kzalloc(key->n_sz, key->flags);

RSA hw implementations that can't enforce hardware coherency may want
to enforce software coherency. As we want a single ASN.1 parser for all
implementations, we need to cover all the cases.

One solution would be to use a common rsa_ctx structure for all
implementations so that the parser's functions can dereference the key
and allocate memory as needed by the user.

Other solution is to move all the device related variables to the driver,
and enforce the software coherency there, by allocating new key members
and copying the parsed data to them.

> +
> +	if (!key->n) {
> +		ret = -ENOMEM;
> +		goto err;
> +	}
> +
> +	memcpy(key->n, ptr, key->n_sz);
> +
>  	return 0;
> +err:
> +	key->n_sz = 0;
> +	key->n = NULL;
> +	return ret;
>  }
> 

> diff --git a/include/crypto/internal/rsa.h b/include/crypto/internal/rsa.h
> index c7585bd..a0a7431 100644
> --- a/include/crypto/internal/rsa.h
> +++ b/include/crypto/internal/rsa.h
> @@ -14,19 +14,52 @@
>  #define _RSA_HELPER_
>  #include <linux/mpi.h>
> 
> +/**
> + * rsa_key - RSA key structure
> + * @n           : RSA modulus raw byte stream
> + * @e           : RSA public exponent raw byte stream
> + * @d           : RSA private exponent raw byte stream
> + * @dma_n       : DMA address of RSA modulus
> + * @dma_e       : DMA address of RSA public exponent
> + * @dma_d       : DMA address of RSA private exponent
> + * @n_sz        : length in bytes of RSA modulus n
> + * @e_sz        : length in bytes of RSA public exponent
> + * @coherent    : set true to enforce software coherency for all key
> members
> + * @flags       : gfp_t key allocation flags
> + */
>  struct rsa_key {
> +	u8 *n;
> +	u8 *e;
> +	u8 *d;
> +	dma_addr_t dma_n;
> +	dma_addr_t dma_e;
> +	dma_addr_t dma_d;
> +	size_t n_sz;
> +	size_t e_sz;
> +	bool coherent;
> +	gfp_t flags;
> +};
> +
> +struct rsa_mpi_key {
>  	MPI n;
>  	MPI e;
>  	MPI d;
>  };
> 
> +struct rsa_ctx {
> +	struct rsa_key key;
> +	struct rsa_mpi_key mpi_key;
> +	struct device *dev;
> +};

If we go with the first solution we can move all the device related
variables to the rsa_ctx structure:

struct rsa_key {
	u8 *n;
	u8 *e;
	u8 *d;
	size_t n_sz;
	size_t e_sz;
	gfp_t flags;
};

struct rsa_mpi_key {
 	MPI n;
 	MPI e;
 	MPI d;
};

struct rsa_ctx {
	struct rsa_key key;
	struct rsa_mpi_key mpi_key;
	struct device *dev;
	bool coherent;
	dma_addr_t dma_n;
	dma_addr_t dma_e;
	dma_addr_t dma_d;
};

What do you think?

Thanks,
ta
