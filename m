From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v3] crypto: rsa - return raw integers for the ASN.1 parser
Date: Tue, 07 Jun 2016 16:33:17 +0200
Message-ID: <4389374.qHp8yZtTYB@tauon.atsec.com>
References: <1465309269-2214-1-git-send-email-tudor-dan.ambarus@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:35978 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754979AbcFGOdV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Jun 2016 10:33:21 -0400
In-Reply-To: <1465309269-2214-1-git-send-email-tudor-dan.ambarus@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 7. Juni 2016, 17:21:09 schrieb Tudor Ambarus:

Hi Tudor,

> Return the raw key with no other processing so that the caller
> can copy it or MPI parse it, etc.
> 
> The scope is to have only one ANS.1 parser for all RSA
> implementations.
> 
> Update the RSA software implementation so that it does
> the MPI conversion on top.
> 
> Signed-off-by: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
> ---
>  crypto/rsa.c                  | 119 ++++++++++++++++++++++++++-------------
> crypto/rsa_helper.c           | 128
> +++++++++++++++++++++--------------------- include/crypto/internal/rsa.h | 
> 22 ++++++--
>  3 files changed, 161 insertions(+), 108 deletions(-)
> 
> diff --git a/crypto/rsa.c b/crypto/rsa.c
> index 77d737f..ea78d61 100644
> --- a/crypto/rsa.c
> +++ b/crypto/rsa.c
> @@ -14,12 +14,24 @@
>  #include <crypto/internal/akcipher.h>
>  #include <crypto/akcipher.h>
>  #include <crypto/algapi.h>
> +#include <linux/mpi.h>
> +
> +struct rsa_mpi_key {
> +	MPI n;
> +	MPI e;
> +	MPI d;
> +};
> +
> +struct rsa_ctx {
> +	struct rsa_key key;
> +	struct rsa_mpi_key mpi_key;
> +};
> 
>  /*
>   * RSAEP function [RFC3447 sec 5.1.1]
>   * c = m^e mod n;
>   */
> -static int _rsa_enc(const struct rsa_key *key, MPI c, MPI m)
> +static int _rsa_enc(const struct rsa_mpi_key *key, MPI c, MPI m)
>  {
>  	/* (1) Validate 0 <= m < n */
>  	if (mpi_cmp_ui(m, 0) < 0 || mpi_cmp(m, key->n) >= 0)
> @@ -33,7 +45,7 @@ static int _rsa_enc(const struct rsa_key *key, MPI c, MPI
> m) * RSADP function [RFC3447 sec 5.1.2]
>   * m = c^d mod n;
>   */
> -static int _rsa_dec(const struct rsa_key *key, MPI m, MPI c)
> +static int _rsa_dec(const struct rsa_mpi_key *key, MPI m, MPI c)
>  {
>  	/* (1) Validate 0 <= c < n */
>  	if (mpi_cmp_ui(c, 0) < 0 || mpi_cmp(c, key->n) >= 0)
> @@ -47,7 +59,7 @@ static int _rsa_dec(const struct rsa_key *key, MPI m, MPI
> c) * RSASP1 function [RFC3447 sec 5.2.1]
>   * s = m^d mod n
>   */
> -static int _rsa_sign(const struct rsa_key *key, MPI s, MPI m)
> +static int _rsa_sign(const struct rsa_mpi_key *key, MPI s, MPI m)
>  {
>  	/* (1) Validate 0 <= m < n */
>  	if (mpi_cmp_ui(m, 0) < 0 || mpi_cmp(m, key->n) >= 0)
> @@ -61,7 +73,7 @@ static int _rsa_sign(const struct rsa_key *key, MPI s, MPI
> m) * RSAVP1 function [RFC3447 sec 5.2.2]
>   * m = s^e mod n;
>   */
> -static int _rsa_verify(const struct rsa_key *key, MPI m, MPI s)
> +static int _rsa_verify(const struct rsa_mpi_key *key, MPI m, MPI s)
>  {
>  	/* (1) Validate 0 <= s < n */
>  	if (mpi_cmp_ui(s, 0) < 0 || mpi_cmp(s, key->n) >= 0)
> @@ -71,15 +83,17 @@ static int _rsa_verify(const struct rsa_key *key, MPI m,
> MPI s) return mpi_powm(m, s, key->e, key->n);
>  }
> 
> -static inline struct rsa_key *rsa_get_key(struct crypto_akcipher *tfm)
> +static inline struct rsa_mpi_key *rsa_get_key(struct crypto_akcipher *tfm)
>  {
> -	return akcipher_tfm_ctx(tfm);
> +	struct rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
> +
> +	return &ctx->mpi_key;
>  }
> 
>  static int rsa_enc(struct akcipher_request *req)
>  {
>  	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
> -	const struct rsa_key *pkey = rsa_get_key(tfm);
> +	const struct rsa_mpi_key *pkey = rsa_get_key(tfm);
>  	MPI m, c = mpi_alloc(0);
>  	int ret = 0;
>  	int sign;
> @@ -118,7 +132,7 @@ err_free_c:
>  static int rsa_dec(struct akcipher_request *req)
>  {
>  	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
> -	const struct rsa_key *pkey = rsa_get_key(tfm);
> +	const struct rsa_mpi_key *pkey = rsa_get_key(tfm);
>  	MPI c, m = mpi_alloc(0);
>  	int ret = 0;
>  	int sign;
> @@ -156,7 +170,7 @@ err_free_m:
>  static int rsa_sign(struct akcipher_request *req)
>  {
>  	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
> -	const struct rsa_key *pkey = rsa_get_key(tfm);
> +	const struct rsa_mpi_key *pkey = rsa_get_key(tfm);
>  	MPI m, s = mpi_alloc(0);
>  	int ret = 0;
>  	int sign;
> @@ -195,7 +209,7 @@ err_free_s:
>  static int rsa_verify(struct akcipher_request *req)
>  {
>  	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
> -	const struct rsa_key *pkey = rsa_get_key(tfm);
> +	const struct rsa_mpi_key *pkey = rsa_get_key(tfm);
>  	MPI s, m = mpi_alloc(0);
>  	int ret = 0;
>  	int sign;
> @@ -233,67 +247,94 @@ err_free_m:
>  	return ret;
>  }
> 
> -static int rsa_check_key_length(unsigned int len)
> +static void rsa_free_mpi_key(struct rsa_mpi_key *key)
>  {
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
> +	mpi_free(key->d);
> +	mpi_free(key->e);
> +	mpi_free(key->n);
> +	key->d = NULL;
> +	key->e = NULL;
> +	key->n = NULL;
>  }
> 
>  static int rsa_set_pub_key(struct crypto_akcipher *tfm, const void *key,
>  			   unsigned int keylen)
>  {
> -	struct rsa_key *pkey = akcipher_tfm_ctx(tfm);
> +	struct rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
> +	struct rsa_key *pkey = &ctx->key;
> +	struct rsa_mpi_key *mpi_key = &ctx->mpi_key;
>  	int ret;
> 
> +	/* Free the old MPI key if any */
> +	rsa_free_mpi_key(mpi_key);
> +
>  	ret = rsa_parse_pub_key(pkey, key, keylen);
>  	if (ret)
>  		return ret;
> 
> -	if (rsa_check_key_length(mpi_get_size(pkey->n) << 3)) {
> -		rsa_free_key(pkey);
> -		ret = -EINVAL;
> -	}
> -	return ret;
> +	mpi_key->e = mpi_read_raw_data(pkey->e, pkey->e_sz);
> +	if (!mpi_key->e)
> +		goto err;
> +
> +	mpi_key->n = mpi_read_raw_data(pkey->n, pkey->n_sz);
> +	if (!mpi_key->n)
> +		goto err;
> +
> +	return 0;
> +
> +err:
> +	rsa_free_mpi_key(mpi_key);
> +	return -ENOMEM;
>  }
> 
>  static int rsa_set_priv_key(struct crypto_akcipher *tfm, const void *key,
>  			    unsigned int keylen)
>  {
> -	struct rsa_key *pkey = akcipher_tfm_ctx(tfm);
> +	struct rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
> +	struct rsa_key *pkey = &ctx->key;
> +	struct rsa_mpi_key *mpi_key = &ctx->mpi_key;
>  	int ret;
> 
> +	/* Free the old MPI key if any */
> +	rsa_free_mpi_key(mpi_key);
> +
>  	ret = rsa_parse_priv_key(pkey, key, keylen);
>  	if (ret)
>  		return ret;
> 
> -	if (rsa_check_key_length(mpi_get_size(pkey->n) << 3)) {
> -		rsa_free_key(pkey);
> -		ret = -EINVAL;
> -	}
> -	return ret;
> +	mpi_key->d = mpi_read_raw_data(pkey->d, pkey->n_sz);
> +	if (!mpi_key->d)
> +		goto err;
> +
> +	mpi_key->e = mpi_read_raw_data(pkey->e, pkey->e_sz);
> +	if (!mpi_key->e)
> +		goto err;
> +
> +	mpi_key->n = mpi_read_raw_data(pkey->n, pkey->n_sz);
> +	if (!mpi_key->n)
> +		goto err;
> +
> +	return 0;
> +
> +err:
> +	rsa_free_mpi_key(mpi_key);
> +	return -ENOMEM;
>  }
> 
>  static int rsa_max_size(struct crypto_akcipher *tfm)
>  {
> -	struct rsa_key *pkey = akcipher_tfm_ctx(tfm);
> +	struct rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
> +	struct rsa_key *pkey = &ctx->key;
> 
> -	return pkey->n ? mpi_get_size(pkey->n) : -EINVAL;
> +	return pkey->n ? pkey->n_sz : -EINVAL;
>  }
> 
>  static void rsa_exit_tfm(struct crypto_akcipher *tfm)
>  {
> -	struct rsa_key *pkey = akcipher_tfm_ctx(tfm);
> +	struct rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
> +	struct rsa_mpi_key *mpi_key = &ctx->mpi_key;
> 
> -	rsa_free_key(pkey);
> +	rsa_free_mpi_key(mpi_key);
>  }
> 
>  static struct akcipher_alg rsa = {
> @@ -310,7 +351,7 @@ static struct akcipher_alg rsa = {
>  		.cra_driver_name = "rsa-generic",
>  		.cra_priority = 100,
>  		.cra_module = THIS_MODULE,
> -		.cra_ctxsize = sizeof(struct rsa_key),
> +		.cra_ctxsize = sizeof(struct rsa_ctx),
>  	},
>  };
> 
> diff --git a/crypto/rsa_helper.c b/crypto/rsa_helper.c
> index d226f48..f0677b7 100644
> --- a/crypto/rsa_helper.c
> +++ b/crypto/rsa_helper.c
> @@ -18,24 +18,50 @@
>  #include "rsapubkey-asn1.h"
>  #include "rsaprivkey-asn1.h"
> 
> +static int rsa_check_key_length(unsigned int len)
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
> +
> +	return -EINVAL;
> +}
> +
>  int rsa_get_n(void *context, size_t hdrlen, unsigned char tag,
>  	      const void *value, size_t vlen)
>  {
>  	struct rsa_key *key = context;
> +	const u8 *ptr = value;
> +	int ret;
> 
> -	key->n = mpi_read_raw_data(value, vlen);
> +	while (!*ptr && vlen) {
> +		ptr++;
> +		vlen--;
> +	}

As you do this operation 3 times, isn't an inline better here?

> 
> -	if (!key->n)
> -		return -ENOMEM;
> +	/* invalid key provided */
> +	if (!ptr)
> +		return -EINVAL;

Hm, you check the pointer here, but you dereference it already above. So, I 
guess you want to move that check to the beginning of the function?
> 
>  	/* In FIPS mode only allow key size 2K & 3K */
> -	if (fips_enabled && (mpi_get_size(key->n) != 256 &&
> -			     mpi_get_size(key->n) != 384)) {
> +	if (fips_enabled && (vlen != 256 && vlen != 384)) {
>  		pr_err("RSA: key size not allowed in FIPS mode\n");
> -		mpi_free(key->n);
> -		key->n = NULL;
>  		return -EINVAL;
>  	}
> +	/* invalid key size provided */
> +	ret = rsa_check_key_length(vlen << 3);
> +	if (ret)
> +		return ret;
> +
> +	key->n = ptr;
> +	key->n_sz = vlen;
> +
>  	return 0;
>  }
> 
> @@ -43,11 +69,19 @@ int rsa_get_e(void *context, size_t hdrlen, unsigned
> char tag, const void *value, size_t vlen)
>  {
>  	struct rsa_key *key = context;
> +	const u8 *ptr = value;
> +
> +	while (!*ptr && vlen) {
> +		ptr++;
> +		vlen--;
> +	}

No NULL check for ptr? Is it always guaranteed that there is no NULL 
considering that this may be exposed to user space?
> 
> -	key->e = mpi_read_raw_data(value, vlen);
> +	/* invalid key provided */
> +	if (!ptr || !key->n_sz || !vlen || vlen > key->n_sz)
> +		return -EINVAL;

Ah, here we have that check -- again, I would assume it should move up.
> 
> -	if (!key->e)
> -		return -ENOMEM;
> +	key->e = ptr;
> +	key->e_sz = vlen;
> 
>  	return 0;
>  }
> @@ -56,47 +90,33 @@ int rsa_get_d(void *context, size_t hdrlen, unsigned
> char tag, const void *value, size_t vlen)
>  {
>  	struct rsa_key *key = context;
> +	const u8 *ptr = value;
> 
> -	key->d = mpi_read_raw_data(value, vlen);
> +	while (!*ptr && vlen) {
> +		ptr++;
> +		vlen--;
> +	}

Same here.
> 
> -	if (!key->d)
> -		return -ENOMEM;
> +	/* invalid key provided */
> +	if (!ptr || !key->n_sz || !vlen || vlen > key->n_sz)
> +		return -EINVAL;
> 
>  	/* In FIPS mode only allow key size 2K & 3K */
> -	if (fips_enabled && (mpi_get_size(key->d) != 256 &&
> -			     mpi_get_size(key->d) != 384)) {
> +	if (fips_enabled && (vlen != 256 && vlen != 384)) {
>  		pr_err("RSA: key size not allowed in FIPS mode\n");
> -		mpi_free(key->d);
> -		key->d = NULL;
>  		return -EINVAL;
>  	}
> -	return 0;
> -}
> 
> -static void free_mpis(struct rsa_key *key)
> -{
> -	mpi_free(key->n);
> -	mpi_free(key->e);
> -	mpi_free(key->d);
> -	key->n = NULL;
> -	key->e = NULL;
> -	key->d = NULL;
> -}
> +	key->d = ptr;
> +	key->d_sz = vlen;
> 
> -/**
> - * rsa_free_key() - frees rsa key allocated by rsa_parse_key()
> - *
> - * @rsa_key:	struct rsa_key key representation
> - */
> -void rsa_free_key(struct rsa_key *key)
> -{
> -	free_mpis(key);
> +	return 0;
>  }
> -EXPORT_SYMBOL_GPL(rsa_free_key);
> 
>  /**
> - * rsa_parse_pub_key() - extracts an rsa public key from BER encoded buffer
> - *			 and stores it in the provided struct rsa_key
> + * rsa_parse_pub_key() - decodes the BER encoded buffer and stores in the
> + *                       provided struct rsa_key, pointers to the raw key
> as is, + *                       so that the caller can copy it or MPI
> parse it, etc. *
>   * @rsa_key:	struct rsa_key key representation
>   * @key:	key in BER format
> @@ -107,23 +127,15 @@ EXPORT_SYMBOL_GPL(rsa_free_key);
>  int rsa_parse_pub_key(struct rsa_key *rsa_key, const void *key,
>  		      unsigned int key_len)
>  {
> -	int ret;
> -
> -	free_mpis(rsa_key);
> -	ret = asn1_ber_decoder(&rsapubkey_decoder, rsa_key, key, key_len);
> -	if (ret < 0)
> -		goto error;
> -
> -	return 0;
> -error:
> -	free_mpis(rsa_key);
> -	return ret;
> +	return asn1_ber_decoder(&rsapubkey_decoder, rsa_key, key, key_len);
>  }
>  EXPORT_SYMBOL_GPL(rsa_parse_pub_key);
> 
>  /**
> - * rsa_parse_pub_key() - extracts an rsa private key from BER encoded
> buffer - *			 and stores it in the provided struct rsa_key
> + * rsa_parse_priv_key() - decodes the BER encoded buffer and stores in the
> + *                        provided struct rsa_key, pointers to the raw key
> + *                        as is, so that the caller can copy it or MPI
> parse it, + *                        etc.
>   *
>   * @rsa_key:	struct rsa_key key representation
>   * @key:	key in BER format
> @@ -134,16 +146,6 @@ EXPORT_SYMBOL_GPL(rsa_parse_pub_key);
>  int rsa_parse_priv_key(struct rsa_key *rsa_key, const void *key,
>  		       unsigned int key_len)
>  {
> -	int ret;
> -
> -	free_mpis(rsa_key);
> -	ret = asn1_ber_decoder(&rsaprivkey_decoder, rsa_key, key, key_len);
> -	if (ret < 0)
> -		goto error;
> -
> -	return 0;
> -error:
> -	free_mpis(rsa_key);
> -	return ret;
> +	return asn1_ber_decoder(&rsaprivkey_decoder, rsa_key, key, key_len);
>  }
>  EXPORT_SYMBOL_GPL(rsa_parse_priv_key);
> diff --git a/include/crypto/internal/rsa.h b/include/crypto/internal/rsa.h
> index c7585bd..d6c042a 100644
> --- a/include/crypto/internal/rsa.h
> +++ b/include/crypto/internal/rsa.h
> @@ -12,12 +12,24 @@
>   */
>  #ifndef _RSA_HELPER_
>  #define _RSA_HELPER_
> -#include <linux/mpi.h>
> +#include <linux/types.h>
> 
> +/**
> + * rsa_key - RSA key structure
> + * @n           : RSA modulus raw byte stream
> + * @e           : RSA public exponent raw byte stream
> + * @d           : RSA private exponent raw byte stream
> + * @n_sz        : length in bytes of RSA modulus n
> + * @e_sz        : length in bytes of RSA public exponent
> + * @d_sz        : length in bytes of RSA private exponent
> + */
>  struct rsa_key {
> -	MPI n;
> -	MPI e;
> -	MPI d;
> +	const u8 *n;
> +	const u8 *e;
> +	const u8 *d;
> +	size_t n_sz;
> +	size_t e_sz;
> +	size_t d_sz;
>  };
> 
>  int rsa_parse_pub_key(struct rsa_key *rsa_key, const void *key,
> @@ -26,7 +38,5 @@ int rsa_parse_pub_key(struct rsa_key *rsa_key, const void
> *key, int rsa_parse_priv_key(struct rsa_key *rsa_key, const void *key,
>  		       unsigned int key_len);
> 
> -void rsa_free_key(struct rsa_key *rsa_key);
> -
>  extern struct crypto_template rsa_pkcs1pad_tmpl;
>  #endif


Ciao
Stephan
