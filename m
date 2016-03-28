From: Cristian Stoica <cristian.stoica@nxp.com>
Subject: RE: [PATCH v2 1/4] crypto: rsa - generalize ASN.1 sequences
Date: Mon, 28 Mar 2016 16:47:39 +0000
Message-ID: <AM4PR0401MB18762A39E7C5652C6F680E40E7860@AM4PR0401MB1876.eurprd04.prod.outlook.com>
References: <1458745459-1096-1-git-send-email-tudor-dan.ambarus@nxp.com>
 <1458745459-1096-2-git-send-email-tudor-dan.ambarus@nxp.com>
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
Received: from mail-db3on0065.outbound.protection.outlook.com ([157.55.234.65]:55416
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753438AbcC1RUQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 28 Mar 2016 13:20:16 -0400
In-Reply-To: <1458745459-1096-2-git-send-email-tudor-dan.ambarus@nxp.com>
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
> Subject: [PATCH v2 1/4] crypto: rsa - generalize ASN.1 sequences
> 
> Use common ASN.1 sequences for all RSA implementations.
> 
> Give hardware RSA implementations the chance to use the RSA's software
> implementation parser even if they are likely to want to use raw integers.
> 
> The parser expects a context that contains at the first address a pointer to a
> struct rsa_asn1_action instance that has function pointers to specific parser
> actions (return MPI or raw integer keys), followed by a key representation
> structure (for MPI or raw integers).
> 
> This approach has the advantage that users can select specific parser actions
> by using a general parser with function pointers to specific actions.
> 
> Signed-off-by: Tudor Ambarus <tudor-dan.ambarus@nxp.com>

Acked-by: Cristian Stoica <cristian.stoica@nxp.com>

> ---
>  crypto/rsa.c                  |  60 ++++++++++-----
>  crypto/rsa_helper.c           | 166 ++++++++++++++++++++++++++++++++----
> ------
>  include/crypto/internal/rsa.h |  31 ++++++--
>  3 files changed, 194 insertions(+), 63 deletions(-)
> 
> diff --git a/crypto/rsa.c b/crypto/rsa.c index 77d737f..7cb0153 100644
> --- a/crypto/rsa.c
> +++ b/crypto/rsa.c
> @@ -19,7 +19,7 @@
>   * RSAEP function [RFC3447 sec 5.1.1]
>   * c = m^e mod n;
>   */
> -static int _rsa_enc(const struct rsa_key *key, MPI c, MPI m)
> +static int _rsa_enc(const struct rsa_mpi_key *key, MPI c, MPI m)
>  {
>  	/* (1) Validate 0 <= m < n */
>  	if (mpi_cmp_ui(m, 0) < 0 || mpi_cmp(m, key->n) >= 0) @@ -33,7
> +33,7 @@ static int _rsa_enc(const struct rsa_key *key, MPI c, MPI m)
>   * RSADP function [RFC3447 sec 5.1.2]
>   * m = c^d mod n;
>   */
> -static int _rsa_dec(const struct rsa_key *key, MPI m, MPI c)
> +static int _rsa_dec(const struct rsa_mpi_key *key, MPI m, MPI c)
>  {
>  	/* (1) Validate 0 <= c < n */
>  	if (mpi_cmp_ui(c, 0) < 0 || mpi_cmp(c, key->n) >= 0) @@ -47,7 +47,7
> @@ static int _rsa_dec(const struct rsa_key *key, MPI m, MPI c)
>   * RSASP1 function [RFC3447 sec 5.2.1]
>   * s = m^d mod n
>   */
> -static int _rsa_sign(const struct rsa_key *key, MPI s, MPI m)
> +static int _rsa_sign(const struct rsa_mpi_key *key, MPI s, MPI m)
>  {
>  	/* (1) Validate 0 <= m < n */
>  	if (mpi_cmp_ui(m, 0) < 0 || mpi_cmp(m, key->n) >= 0) @@ -61,7
> +61,7 @@ static int _rsa_sign(const struct rsa_key *key, MPI s, MPI m)
>   * RSAVP1 function [RFC3447 sec 5.2.2]
>   * m = s^e mod n;
>   */
> -static int _rsa_verify(const struct rsa_key *key, MPI m, MPI s)
> +static int _rsa_verify(const struct rsa_mpi_key *key, MPI m, MPI s)
>  {
>  	/* (1) Validate 0 <= s < n */
>  	if (mpi_cmp_ui(s, 0) < 0 || mpi_cmp(s, key->n) >= 0) @@ -71,15
> +71,17 @@ static int _rsa_verify(const struct rsa_key *key, MPI m, MPI s)
>  	return mpi_powm(m, s, key->e, key->n);  }
> 
> -static inline struct rsa_key *rsa_get_key(struct crypto_akcipher *tfm)
> +static inline struct rsa_mpi_key *rsa_get_key(struct crypto_akcipher
> +*tfm)
>  {
> -	return akcipher_tfm_ctx(tfm);
> +	struct rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
> +
> +	return &ctx->key;
>  }
> 
>  static int rsa_enc(struct akcipher_request *req)  {
>  	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
> -	const struct rsa_key *pkey = rsa_get_key(tfm);
> +	const struct rsa_mpi_key *pkey = rsa_get_key(tfm);
>  	MPI m, c = mpi_alloc(0);
>  	int ret = 0;
>  	int sign;
> @@ -118,7 +120,7 @@ err_free_c:
>  static int rsa_dec(struct akcipher_request *req)  {
>  	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
> -	const struct rsa_key *pkey = rsa_get_key(tfm);
> +	const struct rsa_mpi_key *pkey = rsa_get_key(tfm);
>  	MPI c, m = mpi_alloc(0);
>  	int ret = 0;
>  	int sign;
> @@ -156,7 +158,7 @@ err_free_m:
>  static int rsa_sign(struct akcipher_request *req)  {
>  	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
> -	const struct rsa_key *pkey = rsa_get_key(tfm);
> +	const struct rsa_mpi_key *pkey = rsa_get_key(tfm);
>  	MPI m, s = mpi_alloc(0);
>  	int ret = 0;
>  	int sign;
> @@ -195,7 +197,7 @@ err_free_s:
>  static int rsa_verify(struct akcipher_request *req)  {
>  	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
> -	const struct rsa_key *pkey = rsa_get_key(tfm);
> +	const struct rsa_mpi_key *pkey = rsa_get_key(tfm);
>  	MPI s, m = mpi_alloc(0);
>  	int ret = 0;
>  	int sign;
> @@ -251,15 +253,16 @@ static int rsa_check_key_length(unsigned int len)
> static int rsa_set_pub_key(struct crypto_akcipher *tfm, const void *key,
>  			   unsigned int keylen)
>  {
> -	struct rsa_key *pkey = akcipher_tfm_ctx(tfm);
> +	struct rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
> +	struct rsa_mpi_key *pkey = &ctx->key;
>  	int ret;
> 
> -	ret = rsa_parse_pub_key(pkey, key, keylen);
> +	ret = rsa_parse_mpi_pub_key(ctx, key, keylen);
>  	if (ret)
>  		return ret;
> 
>  	if (rsa_check_key_length(mpi_get_size(pkey->n) << 3)) {
> -		rsa_free_key(pkey);
> +		rsa_free_mpi_key(pkey);
>  		ret = -EINVAL;
>  	}
>  	return ret;
> @@ -268,15 +271,16 @@ static int rsa_set_pub_key(struct crypto_akcipher
> *tfm, const void *key,  static int rsa_set_priv_key(struct crypto_akcipher
> *tfm, const void *key,
>  			    unsigned int keylen)
>  {
> -	struct rsa_key *pkey = akcipher_tfm_ctx(tfm);
> +	struct rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
> +	struct rsa_mpi_key *pkey = &ctx->key;
>  	int ret;
> 
> -	ret = rsa_parse_priv_key(pkey, key, keylen);
> +	ret = rsa_parse_mpi_priv_key(ctx, key, keylen);
>  	if (ret)
>  		return ret;
> 
>  	if (rsa_check_key_length(mpi_get_size(pkey->n) << 3)) {
> -		rsa_free_key(pkey);
> +		rsa_free_mpi_key(pkey);
>  		ret = -EINVAL;
>  	}
>  	return ret;
> @@ -284,16 +288,31 @@ static int rsa_set_priv_key(struct crypto_akcipher
> *tfm, const void *key,
> 
>  static int rsa_max_size(struct crypto_akcipher *tfm)  {
> -	struct rsa_key *pkey = akcipher_tfm_ctx(tfm);
> +	struct rsa_mpi_key *pkey = rsa_get_key(tfm);
> 
>  	return pkey->n ? mpi_get_size(pkey->n) : -EINVAL;  }
> 
> +static const struct rsa_asn1_action rsa_action = {
> +	.get_n = rsa_get_mpi_n,
> +	.get_e = rsa_get_mpi_e,
> +	.get_d = rsa_get_mpi_d,
> +};
> +
> +static int rsa_init_tfm(struct crypto_akcipher *tfm) {
> +	struct rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
> +
> +	ctx->action = &rsa_action;
> +
> +	return 0;
> +}
> +
>  static void rsa_exit_tfm(struct crypto_akcipher *tfm)  {
> -	struct rsa_key *pkey = akcipher_tfm_ctx(tfm);
> +	struct rsa_mpi_key *pkey = rsa_get_key(tfm);
> 
> -	rsa_free_key(pkey);
> +	rsa_free_mpi_key(pkey);
>  }
> 
>  static struct akcipher_alg rsa = {
> @@ -304,13 +323,14 @@ static struct akcipher_alg rsa = {
>  	.set_priv_key = rsa_set_priv_key,
>  	.set_pub_key = rsa_set_pub_key,
>  	.max_size = rsa_max_size,
> +	.init = rsa_init_tfm,
>  	.exit = rsa_exit_tfm,
>  	.base = {
>  		.cra_name = "rsa",
>  		.cra_driver_name = "rsa-generic",
>  		.cra_priority = 100,
>  		.cra_module = THIS_MODULE,
> -		.cra_ctxsize = sizeof(struct rsa_key),
> +		.cra_ctxsize = sizeof(struct rsa_ctx),
>  	},
>  };
> 
> diff --git a/crypto/rsa_helper.c b/crypto/rsa_helper.c index
> d226f48..0149ed3 100644
> --- a/crypto/rsa_helper.c
> +++ b/crypto/rsa_helper.c
> @@ -21,7 +21,95 @@
>  int rsa_get_n(void *context, size_t hdrlen, unsigned char tag,
>  	      const void *value, size_t vlen)
>  {
> -	struct rsa_key *key = context;
> +	const struct rsa_asn1_action **action = context;
> +
> +	if ((*action)->get_n)
> +		return (*action)->get_n(context, value, vlen);
> +
> +	return 0;
> +}
> +
> +int rsa_get_e(void *context, size_t hdrlen, unsigned char tag,
> +	      const void *value, size_t vlen)
> +{
> +	const struct rsa_asn1_action **action = context;
> +
> +	if ((*action)->get_e)
> +		return (*action)->get_e(context, value, vlen);
> +
> +	return 0;
> +}
> +
> +int rsa_get_d(void *context, size_t hdrlen, unsigned char tag,
> +	      const void *value, size_t vlen)
> +{
> +	const struct rsa_asn1_action **action = context;
> +
> +	if ((*action)->get_d)
> +		return (*action)->get_d(context, value, vlen);
> +
> +	return 0;
> +}
> +
> +int rsa_get_p(void *context, size_t hdrlen, unsigned char tag,
> +	      const void *value, size_t vlen)
> +{
> +	const struct rsa_asn1_action **action = context;
> +
> +	if ((*action)->get_p)
> +		return (*action)->get_p(context, value, vlen);
> +
> +	return 0;
> +}
> +
> +int rsa_get_q(void *context, size_t hdrlen, unsigned char tag,
> +	      const void *value, size_t vlen)
> +{
> +	const struct rsa_asn1_action **action = context;
> +
> +	if ((*action)->get_q)
> +		return (*action)->get_q(context, value, vlen);
> +
> +	return 0;
> +}
> +
> +int rsa_get_dp(void *context, size_t hdrlen, unsigned char tag,
> +	       const void *value, size_t vlen) {
> +	const struct rsa_asn1_action **action = context;
> +
> +	if ((*action)->get_dp)
> +		return (*action)->get_dp(context, value, vlen);
> +
> +	return 0;
> +}
> +
> +int rsa_get_dq(void *context, size_t hdrlen, unsigned char tag,
> +	       const void *value, size_t vlen) {
> +	const struct rsa_asn1_action **action = context;
> +
> +	if ((*action)->get_dq)
> +		return (*action)->get_dq(context, value, vlen);
> +
> +	return 0;
> +}
> +
> +int rsa_get_qinv(void *context, size_t hdrlen, unsigned char tag,
> +		 const void *value, size_t vlen)
> +{
> +	const struct rsa_asn1_action **action = context;
> +
> +	if ((*action)->get_qinv)
> +		return (*action)->get_qinv(context, value, vlen);
> +
> +	return 0;
> +}
> +
> +int rsa_get_mpi_n(void *context, const void *value, size_t vlen) {
> +	struct rsa_ctx *ctx = context;
> +	struct rsa_mpi_key *key = &ctx->key;
> 
>  	key->n = mpi_read_raw_data(value, vlen);
> 
> @@ -38,11 +126,12 @@ int rsa_get_n(void *context, size_t hdrlen, unsigned
> char tag,
>  	}
>  	return 0;
>  }
> +EXPORT_SYMBOL_GPL(rsa_get_mpi_n);
> 
> -int rsa_get_e(void *context, size_t hdrlen, unsigned char tag,
> -	      const void *value, size_t vlen)
> +int rsa_get_mpi_e(void *context, const void *value, size_t vlen)
>  {
> -	struct rsa_key *key = context;
> +	struct rsa_ctx *ctx = context;
> +	struct rsa_mpi_key *key = &ctx->key;
> 
>  	key->e = mpi_read_raw_data(value, vlen);
> 
> @@ -51,11 +140,12 @@ int rsa_get_e(void *context, size_t hdrlen, unsigned
> char tag,
> 
>  	return 0;
>  }
> +EXPORT_SYMBOL_GPL(rsa_get_mpi_e);
> 
> -int rsa_get_d(void *context, size_t hdrlen, unsigned char tag,
> -	      const void *value, size_t vlen)
> +int rsa_get_mpi_d(void *context, const void *value, size_t vlen)
>  {
> -	struct rsa_key *key = context;
> +	struct rsa_ctx *ctx = context;
> +	struct rsa_mpi_key *key = &ctx->key;
> 
>  	key->d = mpi_read_raw_data(value, vlen);
> 
> @@ -72,8 +162,14 @@ int rsa_get_d(void *context, size_t hdrlen, unsigned
> char tag,
>  	}
>  	return 0;
>  }
> +EXPORT_SYMBOL_GPL(rsa_get_mpi_d);
> 
> -static void free_mpis(struct rsa_key *key)
> +/**
> + * rsa_free_mpi_key() - frees rsa key allocated by rsa_parse_key()
> + *
> + * @rsa_mpi_key:	struct rsa_mpi_key key representation
> + */
> +void rsa_free_mpi_key(struct rsa_mpi_key *key)
>  {
>  	mpi_free(key->n);
>  	mpi_free(key->e);
> @@ -82,68 +178,64 @@ static void free_mpis(struct rsa_key *key)
>  	key->e = NULL;
>  	key->d = NULL;
>  }
> +EXPORT_SYMBOL_GPL(rsa_free_mpi_key);
> 
>  /**
> - * rsa_free_key() - frees rsa key allocated by rsa_parse_key()
> + * rsa_parse_mpi_pub_key() - extracts an RSA public key from BER encoded
> buffer
> + *			     and stores it in the provided context.
>   *
> - * @rsa_key:	struct rsa_key key representation
> - */
> -void rsa_free_key(struct rsa_key *key)
> -{
> -	free_mpis(key);
> -}
> -EXPORT_SYMBOL_GPL(rsa_free_key);
> -
> -/**
> - * rsa_parse_pub_key() - extracts an rsa public key from BER encoded
> buffer
> - *			 and stores it in the provided struct rsa_key
> - *
> - * @rsa_key:	struct rsa_key key representation
> + * @rsa_ctx:	RSA internal context
>   * @key:	key in BER format
>   * @key_len:	length of key
>   *
>   * Return:	0 on success or error code in case of error
>   */
> -int rsa_parse_pub_key(struct rsa_key *rsa_key, const void *key,
> -		      unsigned int key_len)
> +int rsa_parse_mpi_pub_key(struct rsa_ctx *ctx, const void *key,
> +			  unsigned int key_len)
>  {
> +	struct rsa_mpi_key *rsa_key = &ctx->key;
>  	int ret;
> 
> -	free_mpis(rsa_key);
> -	ret = asn1_ber_decoder(&rsapubkey_decoder, rsa_key, key,
> key_len);
> +	/* Free the old key if any */
> +	rsa_free_mpi_key(rsa_key);
> +
> +	ret = asn1_ber_decoder(&rsapubkey_decoder, ctx, key, key_len);
>  	if (ret < 0)
>  		goto error;
> 
>  	return 0;
>  error:
> -	free_mpis(rsa_key);
> +	rsa_free_mpi_key(rsa_key);
>  	return ret;
>  }
> -EXPORT_SYMBOL_GPL(rsa_parse_pub_key);
> +EXPORT_SYMBOL_GPL(rsa_parse_mpi_pub_key);
> 
>  /**
> - * rsa_parse_pub_key() - extracts an rsa private key from BER encoded
> buffer
> - *			 and stores it in the provided struct rsa_key
> + * rsa_parse_mpi_priv_key() - extracts an RSA private key from BER
> encoded
> + *			      buffer and stores it in the provided context.
>   *
> - * @rsa_key:	struct rsa_key key representation
> + * @rsa_ctx:	RSA internal context
>   * @key:	key in BER format
>   * @key_len:	length of key
>   *
>   * Return:	0 on success or error code in case of error
>   */
> -int rsa_parse_priv_key(struct rsa_key *rsa_key, const void *key,
> -		       unsigned int key_len)
> +int rsa_parse_mpi_priv_key(struct rsa_ctx *ctx, const void *key,
> +			   unsigned int key_len)
>  {
> +	struct rsa_mpi_key *rsa_key = &ctx->key;
>  	int ret;
> 
> -	free_mpis(rsa_key);
> -	ret = asn1_ber_decoder(&rsaprivkey_decoder, rsa_key, key,
> key_len);
> +	/* Free the old key if any */
> +	rsa_free_mpi_key(rsa_key);
> +
> +	ret = asn1_ber_decoder(&rsaprivkey_decoder, ctx, key, key_len);
>  	if (ret < 0)
>  		goto error;
> 
>  	return 0;
>  error:
> -	free_mpis(rsa_key);
> +	rsa_free_mpi_key(rsa_key);
>  	return ret;
>  }
> -EXPORT_SYMBOL_GPL(rsa_parse_priv_key);
> +EXPORT_SYMBOL_GPL(rsa_parse_mpi_priv_key);
> diff --git a/include/crypto/internal/rsa.h b/include/crypto/internal/rsa.h
> index c7585bd..f8ef7b1 100644
> --- a/include/crypto/internal/rsa.h
> +++ b/include/crypto/internal/rsa.h
> @@ -14,19 +14,38 @@
>  #define _RSA_HELPER_
>  #include <linux/mpi.h>
> 
> -struct rsa_key {
> +struct rsa_asn1_action {
> +	int (*get_n)(void *context, const void *value, size_t vlen);
> +	int (*get_e)(void *context, const void *value, size_t vlen);
> +	int (*get_d)(void *context, const void *value, size_t vlen);
> +	int (*get_p)(void *context, const void *value, size_t vlen);
> +	int (*get_q)(void *context, const void *value, size_t vlen);
> +	int (*get_dp)(void *context, const void *value, size_t vlen);
> +	int (*get_dq)(void *context, const void *value, size_t vlen);
> +	int (*get_qinv)(void *context, const void *value, size_t vlen); };
> +
> +struct rsa_mpi_key {
>  	MPI n;
>  	MPI e;
>  	MPI d;
>  };
> 
> -int rsa_parse_pub_key(struct rsa_key *rsa_key, const void *key,
> -		      unsigned int key_len);
> +struct rsa_ctx {
> +	const struct rsa_asn1_action *action;
> +	struct rsa_mpi_key key;
> +};
> +
> +int rsa_get_mpi_n(void *context, const void *value, size_t vlen); int
> +rsa_get_mpi_e(void *context, const void *value, size_t vlen); int
> +rsa_get_mpi_d(void *context, const void *value, size_t vlen);
> 
> -int rsa_parse_priv_key(struct rsa_key *rsa_key, const void *key,
> -		       unsigned int key_len);
> +void rsa_free_mpi_key(struct rsa_mpi_key *key);
> 
> -void rsa_free_key(struct rsa_key *rsa_key);
> +int rsa_parse_mpi_pub_key(struct rsa_ctx *ctx, const void *key,
> +			  unsigned int key_len);
> +int rsa_parse_mpi_priv_key(struct rsa_ctx *ctx, const void *key,
> +			   unsigned int key_len);
> 
>  extern struct crypto_template rsa_pkcs1pad_tmpl;  #endif
> --
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
