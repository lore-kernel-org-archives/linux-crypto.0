From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: implement DH primitives under akcipher API
Date: Mon, 15 Feb 2016 14:57:08 +0100
Message-ID: <2214574.VuIVa0pDBJ@positron.chronox.de>
References: <1455526915-23104-1-git-send-email-salvatore.benedetto@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: Salvatore Benedetto <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:33860 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134AbcBON5R (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Feb 2016 08:57:17 -0500
In-Reply-To: <1455526915-23104-1-git-send-email-salvatore.benedetto@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 15. Februar 2016, 09:01:55 schrieb Salvatore Benedetto:

Hi Salvatore, Herbert,

> Implement Diffie-Hellman primitives required by the scheme under the
> akcipher API. Here is how it works.
> 1) Call set_pub_key() by passing DH parameters (p,g) in PKCS3 format
> 2) Call set_priv_key() to set your own private key (xa) in raw format
> 3) Call decrypt() without passing any data as input to get back the
>    public part which will be computed as g^xa mod p
> 4) Call encrypt() by passing the counter part public key (yb) in raw format
>    as input to get back the shared secret calculated as zz = yb^xa mod p
> 
> A test is included in the patch. Test vector has been generated with
> openssl

Herbert, as this is a raw DH operation where the shared secret must be 
subjected to a KDF, I guess the KDF patch I provided some time ago may become 
of interest again?
> 
> Signed-off-by: Salvatore Benedetto <salvatore.benedetto@intel.com>
> ---
>  crypto/Kconfig    |   8 ++
>  crypto/Makefile   |   7 ++
>  crypto/dh.c       | 264
> ++++++++++++++++++++++++++++++++++++++++++++++++++++++ crypto/pkcs3.asn1 | 
>  5 ++
>  crypto/tcrypt.c   |   4 +
>  crypto/testmgr.c  | 140 +++++++++++++++++++++++++++--
>  crypto/testmgr.h  | 208 +++++++++++++++++++++++++++++++++++++++++-
>  7 files changed, 627 insertions(+), 9 deletions(-)
>  create mode 100644 crypto/dh.c
>  create mode 100644 crypto/pkcs3.asn1
> 
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index f6bfdda..fd5b78d 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -101,6 +101,14 @@ config CRYPTO_RSA
>  	help
>  	  Generic implementation of the RSA public key algorithm.
> 
> +config CRYPTO_DH
> +	tristate "Diffie-Hellman algorithm"
> +	select CRYPTO_AKCIPHER
> +	select MPILIB
> +	select ASN1
> +	help
> +	  Generic implementation of the Diffie-Hellman algorithm.
> +
>  config CRYPTO_MANAGER
>  	tristate "Cryptographic algorithm manager"
>  	select CRYPTO_MANAGER2
> diff --git a/crypto/Makefile b/crypto/Makefile
> index 4f4ef7e..ee73489 100644
> --- a/crypto/Makefile
> +++ b/crypto/Makefile
> @@ -31,6 +31,13 @@ obj-$(CONFIG_CRYPTO_HASH2) += crypto_hash.o
> 
>  obj-$(CONFIG_CRYPTO_AKCIPHER2) += akcipher.o
> 
> +$(obj)/pkcs3-asn1.o: $(obj)/pkcs3-asn1.c $(obj)/pkcs3-asn1.h
> +clean-files += pkcs3-asn1.c pkcs3-asn1.h
> +
> +dh_generic-y := pkcs3-asn1.o
> +dh_generic-y += dh.o
> +obj-$(CONFIG_CRYPTO_DH) += dh_generic.o
> +
>  $(obj)/rsapubkey-asn1.o: $(obj)/rsapubkey-asn1.c $(obj)/rsapubkey-asn1.h
>  $(obj)/rsaprivkey-asn1.o: $(obj)/rsaprivkey-asn1.c $(obj)/rsaprivkey-asn1.h
> clean-files += rsapubkey-asn1.c rsapubkey-asn1.h
> diff --git a/crypto/dh.c b/crypto/dh.c
> new file mode 100644
> index 0000000..614c4f1
> --- /dev/null
> +++ b/crypto/dh.c
> @@ -0,0 +1,264 @@
> +/*  Diffie-Hellman Key Agreement Method [RFC2631]
> + *
> + * Copyright (c) 2016, Intel Corporation
> + * Authors: Salvatore Benedetto <salvatore.benedetto@intel.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public Licence
> + * as published by the Free Software Foundation; either version
> + * 2 of the Licence, or (at your option) any later version.
> + */
> +
> +#include <linux/module.h>
> +#include <crypto/internal/akcipher.h>
> +#include <crypto/akcipher.h>
> +#include <crypto/algapi.h>
> +#include <linux/mpi.h>
> +#include "pkcs3-asn1.h"
> +
> +struct dh_params {
> +	MPI p;
> +	MPI g;
> +	MPI xa;
> +};
> +
> +int dh_get_g(void *context, size_t hdrlen, unsigned char tag, const void
> *value, +	     size_t vlen)
> +{
> +	struct dh_params *params = context;
> +
> +	params->g = mpi_read_raw_data(value, vlen);
> +
> +	if (!params->g)
> +		return -ENOMEM;
> +
> +	return 0;
> +}
> +
> +int dh_get_p(void *context, size_t hdrlen, unsigned char tag, const void
> *value, +	     size_t vlen)
> +{
> +	struct dh_params *params = context;
> +
> +	params->p = mpi_read_raw_data(value, vlen);
> +
> +	if (!params->p)
> +		return -ENOMEM;
> +
> +	return 0;
> +}
> +
> +static int dh_parse_params(struct dh_params *params, const void *key,
> +			   unsigned int keylen)
> +{
> +	int ret;
> +
> +	mpi_free(params->p);
> +	mpi_free(params->g);
> +
> +	ret = asn1_ber_decoder(&pkcs3_decoder, params, key, keylen);
> +
> +	return ret;
> +}
> +
> +static void dh_free_params(struct dh_params *params)
> +{
> +	mpi_free(params->p);
> +	mpi_free(params->g);
> +	mpi_free(params->xa);
> +	params->p = NULL;
> +	params->g = NULL;
> +	params->xa = NULL;
> +}
> +
> +/*
> + * Public key generation function [RFC2631 sec 2.1.1]
> + * ya = g^xa mod p;
> + */
> +static int _generate_public_key(const struct dh_params *params, MPI ya)
> +{
> +	/* ya = g^xa mod p */
> +	return mpi_powm(ya, params->g, params->xa, params->p);
> +}
> +
> +/*
> + * ZZ generation function [RFC2631 sec 2.1.1]
> + * ZZ = yb^xa mod p;
> + */
> +static int _compute_shared_secret(const struct dh_params *params, MPI yb,
> +				  MPI zz)
> +{
> +	/* ZZ = yb^xa mod p */
> +	return mpi_powm(zz, yb, params->xa, params->p);
> +}
> +
> +static inline struct dh_params *dh_get_params(struct crypto_akcipher *tfm)
> +{
> +	return akcipher_tfm_ctx(tfm);
> +}
> +
> +static int dh_generate_public_key(struct akcipher_request *req)
> +{
> +	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
> +	const struct dh_params *params = dh_get_params(tfm);
> +	MPI ya = mpi_alloc(0);
> +	int ret = 0;
> +	int sign;
> +
> +	if (!ya)
> +		return -ENOMEM;
> +
> +	if (unlikely(!params->p || !params->g || !params->xa)) {
> +		ret = -EINVAL;
> +		goto err_free_ya;
> +	}
> +	ret = _generate_public_key(params, ya);
> +	if (ret)
> +		goto err_free_ya;
> +
> +	ret = mpi_write_to_sgl(ya, req->dst, &req->dst_len, &sign);
> +	if (ret)
> +		goto err_free_ya;
> +
> +	if (sign < 0)
> +		ret = -EBADMSG;
> +
> +err_free_ya:
> +	mpi_free(ya);
> +	return ret;
> +}
> +
> +static int dh_compute_shared_secret(struct akcipher_request *req)
> +{
> +	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
> +	struct dh_params *params = dh_get_params(tfm);
> +	MPI yb, zz = mpi_alloc(0);
> +	int ret = 0;
> +	int sign;
> +
> +	if (!zz)
> +		return -ENOMEM;
> +
> +	if (unlikely(!params->p || !params->xa)) {
> +		ret = -EINVAL;
> +		goto err_free_zz;
> +	}
> +
> +	yb = mpi_read_raw_from_sgl(req->src, req->src_len);
> +	if (!yb) {
> +		ret = EINVAL;
> +		goto err_free_zz;
> +	}
> +
> +	ret = _compute_shared_secret(params, yb, zz);
> +	if (ret)
> +		goto err_free_yb;
> +
> +	ret = mpi_write_to_sgl(zz, req->dst, &req->dst_len, &sign);
> +	if (ret)
> +		goto err_free_yb;
> +
> +	if (sign < 0)
> +		ret = -EBADMSG;
> +
> +err_free_yb:
> +	mpi_free(yb);
> +err_free_zz:
> +	mpi_free(zz);
> +	return ret;
> +}
> +
> +static int dh_check_params_length(unsigned int p_len)
> +{
> +	switch (p_len) {
> +	case 768:
> +	case 1024:
> +	case 1536:
> +	case 2048:
> +	case 3072:
> +	case 4096:
> +		return 0;
> +	}
> +	return -EINVAL;
> +}

What is the reason for restricting the size to 4096?
> +
> +static int dh_no_op(struct akcipher_request *req)
> +{
> +	return -ENOPROTOOPT;
> +}
> +
> +static int dh_set_priv_key(struct crypto_akcipher *tfm, const void *key,
> +			   unsigned int keylen)
> +{
> +	struct dh_params *params = akcipher_tfm_ctx(tfm);

dh_get_params?
> +
> +	params->xa = mpi_read_raw_data(key, keylen);
> +
> +	if (!params->xa)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static int dh_set_pub_key(struct crypto_akcipher *tfm, const void *key,
> +			  unsigned int keylen)
> +{
> +	struct dh_params *params = akcipher_tfm_ctx(tfm);

dh_get_params?

> +	int ret = 0;
> +
> +	ret = dh_parse_params(params, key, keylen);
> +	if (ret)
> +		return ret;
> +	if (dh_check_params_length(mpi_get_size(params->p) << 3))
> +		ret = -EINVAL;
> +
> +	return ret;
> +}
> +
> +static int dh_max_size(struct crypto_akcipher *tfm)
> +{
> +	struct dh_params *params = akcipher_tfm_ctx(tfm);

dh_get_params?
> +
> +	return params->p ? mpi_get_size(params->p) : -EINVAL;
> +}
> +
> +static void dh_exit_tfm(struct crypto_akcipher *tfm)
> +{
> +	struct dh_params *params = akcipher_tfm_ctx(tfm);

dh_get_params?

> +
> +	dh_free_params(params);
> +}
> +
> +static struct akcipher_alg dh = {
> +	.encrypt = dh_compute_shared_secret,
> +	.decrypt = dh_generate_public_key,

May I ask what purpose this function has? I thought a DH shall generate the 
shared secret only?

> +	.sign = dh_no_op,
> +	.verify = dh_no_op,
> +	.set_priv_key = dh_set_priv_key,
> +	.set_pub_key = dh_set_pub_key,
> +	.max_size = dh_max_size,
> +	.exit = dh_exit_tfm,
> +	.base = {
> +		.cra_name = "dh",
> +		.cra_driver_name = "dh-generic",
> +		.cra_priority = 100,
> +		.cra_module = THIS_MODULE,
> +		.cra_ctxsize = sizeof(struct dh_params),
> +	},
> +};
> +
> +static int dh_init(void)
> +{
> +	return crypto_register_akcipher(&dh);
> +}
> +
> +static void dh_exit(void)
> +{
> +	crypto_unregister_akcipher(&dh);
> +}
> +
> +module_init(dh_init);
> +module_exit(dh_exit);
> +MODULE_ALIAS_CRYPTO("dh");
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("DH generic algorithm");
> diff --git a/crypto/pkcs3.asn1 b/crypto/pkcs3.asn1
> new file mode 100644
> index 0000000..3d4ba5c
> --- /dev/null
> +++ b/crypto/pkcs3.asn1
> @@ -0,0 +1,5 @@
> +DHParameter ::= SEQUENCE {
> +    prime               INTEGER ({ dh_get_p }),
> +    base                INTEGER ({ dh_get_g }),
> +    private_len         INTEGER OPTIONAL
> +}
> diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
> index 579dce0..53c45f7 100644
> --- a/crypto/tcrypt.c
> +++ b/crypto/tcrypt.c
> @@ -1981,6 +1981,10 @@ static int do_test(const char *alg, u32 type, u32
> mask, int m) speed_template_8_32);
>  		break;
> 
> +	case 600:
> +		ret += tcrypt_test("dh");
> +		break;
> +
>  	case 1000:
>  		test_available();
>  		break;
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index 93f3527..adf6815 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -112,7 +112,7 @@ struct drbg_test_suite {
>  };
> 
>  struct akcipher_test_suite {
> -	struct akcipher_testvec *vecs;
> +	struct akcipher_testvec vecs;
>  	unsigned int count;
>  };
> 
> @@ -1773,8 +1773,113 @@ static int alg_test_drbg(const struct alg_test_desc
> *desc, const char *driver,
> 
>  }
> 
> +static int do_test_dh(struct crypto_akcipher *tfm,
> +		      struct akcipher_testvec_dh *vec)
> +{
> +	struct akcipher_request *req;
> +	void *input_buf = NULL;
> +	void *output_buf = NULL;
> +	struct tcrypt_result result;
> +	unsigned int out_len_max;
> +	int err = -ENOMEM;
> +	struct scatterlist src, dst;
> +
> +	req = akcipher_request_alloc(tfm, GFP_KERNEL);
> +	if (!req)
> +		return err;
> +
> +	init_completion(&result.completion);
> +
> +	/* Set p,g */
> +	err = crypto_akcipher_set_pub_key(tfm, vec->pkcs3, vec->pkcs3_size);
> +	if (err)
> +		goto free_req;
> +
> +	/* Set A private Key */
> +	err = crypto_akcipher_set_priv_key(tfm, vec->priv_key_A, vec-
>key_len);
> +	if (err)
> +		goto free_req;
> +
> +	out_len_max = crypto_akcipher_maxsize(tfm);
> +	output_buf = kzalloc(out_len_max, GFP_KERNEL);
> +	if (!output_buf) {
> +		err = -ENOMEM;
> +		goto free_req;
> +	}
> +
> +	sg_init_one(&dst, output_buf, out_len_max);
> +	akcipher_request_set_crypt(req, NULL, &dst, 0, out_len_max);
> +	akcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> +				      tcrypt_complete, &result);
> +
> +	/* Compute A public key = g^xa mod p */
> +	err = wait_async_op(&result, crypto_akcipher_decrypt(req));
> +	if (err) {
> +		pr_err("alg: dh: decrypt test failed. err %d\n", err);
> +		goto free_output;
> +	}
> +	/* Verify calculated public key */
> +	if (memcmp(vec->expected_pub_key_A, sg_virt(req->dst), vec->key_len)) 
{
> +		pr_err("alg: dh: decrypt test failed. Invalid output\n");
> +		err = -EINVAL;
> +		goto free_output;
> +	}
> +
> +	/* Calculate shared secret key by using counter part public key. */
> +	input_buf = kzalloc(vec->key_len, GFP_KERNEL);
> +	if (!input_buf) {
> +		err = -ENOMEM;
> +		goto free_output;
> +	}
> +
> +	memcpy(input_buf, vec->pub_key_B, vec->key_len);
> +	sg_init_one(&src, input_buf, vec->key_len);
> +	sg_init_one(&dst, output_buf, out_len_max);
> +	akcipher_request_set_crypt(req, &src, &dst, vec->key_len, 
out_len_max);
> +	akcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> +				      tcrypt_complete, &result);
> +	err = wait_async_op(&result, crypto_akcipher_encrypt(req));
> +	if (err) {
> +		pr_err("alg: dh: encrypt test failed. err %d\n", err);
> +		goto free_all;
> +	}
> +	/*
> +	 * verify shared secret from which the user will derive
> +	 * secret key by executing whatever hash it has chosen
> +	 */
> +	if (memcmp(vec->expected_shared_secret, sg_virt(req->dst),
> +		   vec->key_len)) {
> +		pr_err("alg: dh: encrypt test failed. Invalid output\n");
> +		err = -EINVAL;
> +	}
> +
> +free_all:
> +	kfree(input_buf);
> +free_output:
> +	kfree(output_buf);
> +free_req:
> +	akcipher_request_free(req);
> +	return err;
> +}
> +
> +static int test_dh(struct crypto_akcipher *tfm,
> +		   struct akcipher_testvec_dh *vecs, unsigned int tcount)
> +{
> +	int ret, i;
> +
> +	for (i = 0; i < tcount; i++) {
> +		ret = do_test_dh(tfm, vecs++);
> +		if (ret) {
> +			pr_err("alg: dh: test failed on vector %d, err=%d\n",
> +			       i + 1, ret);
> +			return ret;
> +		}
> +	}
> +	return 0;
> +}
> +
>  static int do_test_rsa(struct crypto_akcipher *tfm,
> -		       struct akcipher_testvec *vecs)
> +		       struct akcipher_testvec_rsa *vecs)
>  {
>  	struct akcipher_request *req;
>  	void *outbuf_enc = NULL;
> @@ -1870,7 +1975,8 @@ free_req:
>  	return err;
>  }
> 
> -static int test_rsa(struct crypto_akcipher *tfm, struct akcipher_testvec
> *vecs, +static int test_rsa(struct crypto_akcipher *tfm,
> +		    struct akcipher_testvec_rsa *vecs,
>  		    unsigned int tcount)
>  {
>  	int ret, i;
> @@ -1890,7 +1996,9 @@ static int test_akcipher(struct crypto_akcipher *tfm,
> const char *alg, struct akcipher_testvec *vecs, unsigned int tcount)
>  {
>  	if (strncmp(alg, "rsa", 3) == 0)
> -		return test_rsa(tfm, vecs, tcount);
> +		return test_rsa(tfm, vecs->a.rsa, tcount);
> +	else if (strncmp(alg, "dh", 3) == 0)
> +		return test_dh(tfm, vecs->a.dh, tcount);
> 
>  	return 0;
>  }
> @@ -1907,8 +2015,9 @@ static int alg_test_akcipher(const struct
> alg_test_desc *desc, driver, PTR_ERR(tfm));
>  		return PTR_ERR(tfm);
>  	}
> -	if (desc->suite.akcipher.vecs)
> -		err = test_akcipher(tfm, desc->alg, desc->suite.akcipher.vecs,
> +	if (desc->suite.akcipher.vecs.a.rsa)
> +		err = test_akcipher(tfm, desc->alg,
> +				    &desc->suite.akcipher.vecs,
>  				    desc->suite.akcipher.count);
> 
>  	crypto_free_akcipher(tfm);
> @@ -2676,6 +2785,19 @@ static const struct alg_test_desc alg_test_descs[] =
> { }
>  		}
>  	}, {
> +		.alg = "dh",
> +		.test = alg_test_akcipher,

fis_allowed=1 please

> +		.suite = {
> +			.akcipher = {
> +				.vecs = {
> +					.a = {
> +						.dh = dh_tv_template
> +					},
> +				},
> +				.count = DH_TEST_VECTORS
> +			}
> +		}
> +	}, {
>  		.alg = "digest_null",
>  		.test = alg_test_null,
>  	}, {
> @@ -3560,7 +3682,11 @@ static const struct alg_test_desc alg_test_descs[] =
> { .fips_allowed = 1,
>  		.suite = {
>  			.akcipher = {
> -				.vecs = rsa_tv_template,
> +				.vecs = {
> +					.a = {
> +						.rsa = rsa_tv_template
> +					},
> +				},
>  				.count = RSA_TEST_VECTORS
>  			}
>  		}
> diff --git a/crypto/testmgr.h b/crypto/testmgr.h
> index 487ec88..ba08ed6 100644
> --- a/crypto/testmgr.h
> +++ b/crypto/testmgr.h
> @@ -123,7 +123,7 @@ struct drbg_testvec {
>  	size_t expectedlen;
>  };
> 
> -struct akcipher_testvec {
> +struct akcipher_testvec_rsa {
>  	unsigned char *key;
>  	unsigned char *m;
>  	unsigned char *c;
> @@ -133,6 +133,23 @@ struct akcipher_testvec {
>  	bool public_key_vec;
>  };
> 
> +struct akcipher_testvec_dh {
> +	unsigned char *pkcs3;
> +	unsigned pkcs3_size;
> +	unsigned char *priv_key_A;
> +	unsigned char *pub_key_B;
> +	unsigned char *expected_pub_key_A;
> +	unsigned char *expected_shared_secret;
> +	unsigned key_len;
> +};
> +
> +struct akcipher_testvec {
> +	union {
> +		struct akcipher_testvec_rsa *rsa;
> +		struct akcipher_testvec_dh *dh;
> +	} a;
> +};
> +
>  static char zeroed_string[48];
> 
>  /*
> @@ -143,7 +160,7 @@ static char zeroed_string[48];
>  #else
>  #define RSA_TEST_VECTORS	4
>  #endif
> -static struct akcipher_testvec rsa_tv_template[] = {
> +static struct akcipher_testvec_rsa rsa_tv_template[] = {
>  	{
>  #ifndef CONFIG_CRYPTO_FIPS
>  	.key =
> @@ -330,6 +347,193 @@ static struct akcipher_testvec rsa_tv_template[] = {
>  	}
>  };
> 
> +#define DH_TEST_VECTORS 2
> +
> +struct akcipher_testvec_dh dh_tv_template[] = {
> +	{
> +	/* p, g */
> +	.pkcs3 =
> +	"\x30\x82\x01\x08\x02\x82\x01\x01\x00\x9f\xab\x7c\xc2\x50\xa7\xdc"
> +	"\x3c\x17\x2a\x5b\x9f\x76\x17\x8e\x92\xa6\xb0\x13\x1e\x6e\x7b\x9a"
> +	"\x6b\x8d\x06\xcf\x9f\x90\xb8\x21\x6a\x30\x04\xe8\xda\xc0\x13\x27"
> +	"\xc8\x40\xbf\x6c\x84\x1e\xe2\x9e\xf9\xd2\x48\x11\xc7\x06\xd3\x06"
> +	"\xb8\xaa\xbe\x69\x3f\xf2\x60\x06\xa0\xd1\x55\x03\x63\xa1\xfd\x33"
> +	"\x2c\x04\xe4\xf0\xe6\x02\x8a\x97\x1e\x22\x4f\x2b\x73\x15\x23\xa5"
> +	"\x26\x97\xd6\x91\x11\xd8\x80\x35\xe7\x7f\x19\x29\x6c\x59\x64\x24"
> +	"\x68\xc0\x40\x66\x5d\xa8\xcb\xda\x84\xce\xbc\xf7\x1b\x68\x81\xac"
> +	"\xec\xe9\x84\xc1\x46\xef\xac\xe2\xb2\x85\xf2\x92\x06\x82\xbe\xe7"
> +	"\x12\x53\x21\xfc\xc5\x82\xe5\xe3\x7f\x26\xe5\x53\x02\x58\xb1\xa9"
> +	"\x26\x32\x5f\xb9\xa6\x23\x1d\xd8\x26\xda\x7a\x67\xab\x8a\x84\x97"
> +	"\x2e\x78\xc1\x6d\xec\x67\x50\x27\x2d\x52\xf7\x67\xec\x5b\x2c\x9f"
> +	"\x17\xb7\x81\xec\x47\x60\x65\xf5\x86\x20\x4f\x82\x84\xd9\xee\x62"
> +	"\x6f\x49\x7d\x80\x9e\xaa\x8a\x7a\x82\x45\x65\x36\x0b\xf1\xfe\x01"
> +	"\x06\x52\x3c\xa1\xdf\xc8\x84\x89\xb0\xee\xb6\xfa\x95\x12\x42\xb9"
> +	"\x87\x53\x77\x1c\xe0\x56\x25\xf6\x96\x31\xec\x62\x82\x77\xb7\x52"
> +	"\xac\x25\x71\x49\x97\x13\x83\x23\x63\x02\x01\x02",
> +	.pkcs3_size = 268,
> +	.priv_key_A =
> +	"\x48\xed\x07\x3d\x49\x20\xf8\xa5\xcf\x90\xcd\xf9\x97\x63\xd2\x51"
> +	"\x3d\xac\xbd\x2d\x49\x4a\xb8\x87\x06\x62\xd2\x0c\x13\x55\x73\x77"
> +	"\x97\x15\xd3\x23\x8a\x3b\x3e\xb9\x14\xa6\xfb\x20\x7b\xd1\xea\x68"
> +	"\x85\x9a\xc6\x8f\x66\x9a\x78\xf0\x26\xce\x8c\xe0\x66\x4e\x51\xc9"
> +	"\xf5\xf9\x89\xc6\x0a\xc5\x4b\x99\xdc\xb0\x36\x3e\xf2\xc7\x7f\x52"
> +	"\x60\x99\x12\xbd\x8f\x85\x7b\x0a\x99\xa9\x85\x21\xc6\x50\x66\xf6"
> +	"\xde\x62\xc4\x08\x3f\x8c\x97\x91\xb0\x19\x72\x2a\x56\xc6\x85\x12"
> +	"\x8e\x89\x65\xa7\x13\x34\x51\x53\x2e\xe0\x07\x6c\x01\xaa\xb1\x23"
> +	"\x42\x54\xa5\x49\xfd\x01\x2a\xd8\xa7\xc3\xd6\x6a\x6f\x3c\x76\xc4"
> +	"\x4b\x37\x55\x30\xb7\xbe\xb7\x87\x4e\x43\x68\x37\xd8\xa0\x6f\x53"
> +	"\x59\xb6\x25\xd4\x44\xc9\x43\xcd\xb1\x20\x8c\xf9\x3a\xd5\xbc\x97"
> +	"\x70\x8e\xad\x1a\x8b\x69\xbd\xae\xf9\xd0\x48\x70\x40\x4d\x3f\xdc"
> +	"\xea\x10\xef\x61\x49\x1b\x87\x10\xff\x96\x36\x73\x4f\x75\xf5\x75"
> +	"\x23\xbb\x5e\x48\xe8\x96\x57\xcf\x33\x76\x78\x2e\x86\x90\x5c\x2c"
> +	"\x17\xe6\x70\x8a\x6c\x0c\x0d\xa8\x3e\x79\xa6\x9e\xe1\xbf\x18\x40"
> +	"\xeb\x2c\x1a\xb9\x14\xf5\x02\xeb\x37\x66\x06\x1c\xe8\xb5\x75\x0d",
> +	.pub_key_B =
> +	"\x18\xd9\x78\xdd\x6a\xc9\x19\x4e\xe6\xa0\x83\xcc\x12\x00\x3b\x6c"
> +	"\x4c\x8c\x11\x38\x94\x90\xd7\xc4\x1f\xa6\x64\x04\x35\x4a\xda\x48"
> +	"\x5a\xeb\x38\xe7\xae\x44\x16\x4a\x94\xfe\x7c\xa9\x00\xff\x67\x20"
> +	"\x4c\xef\x34\x45\xfe\x2d\xf5\xa9\xfb\xa8\xc0\x45\x09\xcd\xcd\xc0"
> +	"\x4c\x20\xc0\x1e\x42\x41\x4b\x37\x6c\x90\xba\xef\xd6\x65\xab\xb1"
> +	"\xec\x51\x30\xfa\x08\xfc\x22\xc6\x42\xce\x6a\x90\xb7\x27\xe4\x52"
> +	"\x76\x28\x78\x17\x56\x71\x73\xeb\xaf\x6e\xbb\x61\x7a\x6b\x4b\xdb"
> +	"\x8e\x2f\xaa\xfa\x9e\x40\xee\x84\xf6\x63\x9b\xb7\xe2\x22\x72\x6b"
> +	"\x94\x58\x3f\x08\xa5\xbe\xd6\x87\x63\xe7\xbb\x5a\xfb\x52\x92\xd2"
> +	"\xe6\x5e\x7e\x55\x78\x4b\xc0\x0e\x1a\xe5\xe6\x0f\x0e\x41\xd5\x05"
> +	"\xb7\x71\x42\x78\x35\x74\xad\x33\x9f\x24\xc0\x3b\x09\xd5\xcf\x4d"
> +	"\x6e\x20\x3a\xee\x04\x9f\x05\x2d\x8d\x77\x06\x2d\x9b\x67\xba\x39"
> +	"\x2f\x6c\x1d\x7b\x75\x57\xed\x2f\xe2\xf1\xbc\x0b\x3a\x77\xf2\xba"
> +	"\xb2\xb1\x98\x52\x34\x40\x53\x7b\x0e\xb6\x13\x6a\x5b\x91\xe4\x59"
> +	"\x67\x2c\x45\x3a\x07\x1a\xa2\x3b\xdb\xa1\xa6\x08\xf0\x80\xe8\x61"
> +	"\xca\xac\x95\xb3\x3e\xd6\x97\x98\x08\x7e\x50\x48\xc0\x25\x45\xd0",
> +	.expected_pub_key_A =
> +	"\x91\x9e\x52\xa3\xb8\x20\x25\x12\x17\xcc\x37\x82\x81\x22\x14\x7a"
> +	"\x81\x88\xce\x9f\xf2\x46\xb1\x17\xaf\x41\x23\xc9\xb8\x93\x40\xfd"
> +	"\xa9\x96\x05\x5a\x1a\xcc\xa6\x51\xe2\x9e\xca\x63\x2a\x67\x72\x4a"
> +	"\xe1\x2b\xa7\xbe\xf9\xeb\x69\xc8\x2d\x29\xb6\x6b\x5f\xc0\xf2\x90"
> +	"\xa9\x36\x49\xdb\xcc\x6b\x5e\xed\x76\x47\x9f\xc9\x2e\x91\x68\x75"
> +	"\xa3\x39\x6c\x50\xa6\xaf\x81\xac\x23\x58\xa9\xc9\x71\xf3\x87\x97"
> +	"\xef\x0c\x80\x19\xac\xb7\xf0\xa0\x83\x44\x4b\x1c\x08\xf1\x4f\x23"
> +	"\xfb\xf1\x61\x39\x00\x59\xef\x83\xa5\xaf\x2f\x3f\xc0\x19\x2a\x5b"
> +	"\x22\x53\xdb\x8b\x24\xbc\xe4\xaa\x9a\x19\x6b\xfd\x20\xbf\x1a\xe2"
> +	"\xb5\xaf\x82\x3e\xb8\xea\xe7\x28\xcd\xad\xfe\x00\xee\x70\x52\x46"
> +	"\x3d\x2c\x55\x81\x44\xed\x15\x21\xc8\x48\x75\x4d\x6f\xf0\xba\xe9"
> +	"\xab\x4c\x65\xf3\x54\x2e\x74\xd9\xe7\xe2\xb7\xad\xec\x6d\xb2\x6e"
> +	"\xc1\xe3\x2d\x0e\xb1\x18\x36\xd7\xb9\x42\x6b\x2f\xc9\x51\x2e\xff"
> +	"\x5d\xd0\xca\x8c\x0d\x0d\x95\xd3\x16\xf3\xdb\xc1\x2b\xed\x00\x32"
> +	"\xd7\x77\xb8\x0e\x86\x7a\x57\x48\x74\x23\x30\xae\xe0\x3c\x38\xa6"
> +	"\xed\xf9\x0c\x16\xf2\xf2\xa0\xe0\x51\x80\x67\x92\xe4\xc7\x9a\x5e",
> +	.expected_shared_secret =
> +	"\x1d\x7d\x2e\x47\x06\xbe\x46\xd3\x69\xf6\xe7\x0e\x88\xdc\xe8\xe1"
> +	"\xe6\x6a\xfc\x3c\xbc\xc1\x85\xe9\x24\xf0\x7b\x75\x0f\xa4\x04\xd6"
> +	"\x9b\xef\x7b\x30\x55\xde\xbf\xd4\xb2\xcb\xce\x74\x53\xae\x72\x34"
> +	"\x19\x36\x9e\xe9\x45\xb8\xda\x59\x22\x41\x9e\xa3\x8f\x02\xaa\x60"
> +	"\xb1\x8b\xf9\x84\xd4\x8a\xeb\xea\xd1\xd9\x1a\x53\xe9\x5f\x01\xd1"
> +	"\x40\xb4\x73\x63\xc5\x1a\x79\xf1\x08\xb6\xc0\x0c\x85\x9e\x3e\x70"
> +	"\xea\x79\xd9\xc2\x5b\x17\xa7\x1e\xeb\x58\x3e\x1b\xca\x7a\x4d\xab"
> +	"\x61\x5b\xdf\xa2\x6f\x1e\xd4\x36\xeb\xe3\xe9\x04\x10\x8e\x0b\xc9"
> +	"\x18\x8c\x0d\x6e\x4f\x2e\xc5\xfc\x5b\x6a\xb5\x9f\xdf\x71\x50\x04"
> +	"\x54\x62\x49\x57\xf3\xc6\x9e\x39\xc6\x56\xf1\x2d\x31\x59\x58\xdb"
> +	"\x67\x94\x25\xbd\x47\xe2\xdd\x95\x0c\x39\xb1\xfa\x22\xc6\x94\xc4"
> +	"\x75\xab\xff\xe2\xce\x52\xa2\xeb\x78\x26\x10\x0f\x2d\x8c\xf2\xad"
> +	"\xd2\xc7\xaf\x85\xd9\x5c\x71\xfe\x9e\xe9\xeb\xbf\x20\x36\x1e\x9a"
> +	"\x74\x43\xe6\x06\x00\x8a\x4d\x64\x41\x2a\x15\x6d\x60\x44\x3f\x2c"
> +	"\xcd\x05\x16\x54\x6a\x48\x7c\x71\x0a\xe9\x33\x95\x16\xc7\xf4\x23"
> +	"\xc2\x8d\xed\x8a\x24\x5d\x99\xc7\x8c\x8b\x07\x47\x8c\xe9\x0c\x10",
> +	.key_len = 256
> +	},
> +	{
> +	/* p, g */
> +	.pkcs3 =
> +	"\x30\x82\x01\x08\x02\x82\x01\x01\x00\x9f\xab\x7c\xc2\x50\xa7\xdc"
> +	"\x3c\x17\x2a\x5b\x9f\x76\x17\x8e\x92\xa6\xb0\x13\x1e\x6e\x7b\x9a"
> +	"\x6b\x8d\x06\xcf\x9f\x90\xb8\x21\x6a\x30\x04\xe8\xda\xc0\x13\x27"
> +	"\xc8\x40\xbf\x6c\x84\x1e\xe2\x9e\xf9\xd2\x48\x11\xc7\x06\xd3\x06"
> +	"\xb8\xaa\xbe\x69\x3f\xf2\x60\x06\xa0\xd1\x55\x03\x63\xa1\xfd\x33"
> +	"\x2c\x04\xe4\xf0\xe6\x02\x8a\x97\x1e\x22\x4f\x2b\x73\x15\x23\xa5"
> +	"\x26\x97\xd6\x91\x11\xd8\x80\x35\xe7\x7f\x19\x29\x6c\x59\x64\x24"
> +	"\x68\xc0\x40\x66\x5d\xa8\xcb\xda\x84\xce\xbc\xf7\x1b\x68\x81\xac"
> +	"\xec\xe9\x84\xc1\x46\xef\xac\xe2\xb2\x85\xf2\x92\x06\x82\xbe\xe7"
> +	"\x12\x53\x21\xfc\xc5\x82\xe5\xe3\x7f\x26\xe5\x53\x02\x58\xb1\xa9"
> +	"\x26\x32\x5f\xb9\xa6\x23\x1d\xd8\x26\xda\x7a\x67\xab\x8a\x84\x97"
> +	"\x2e\x78\xc1\x6d\xec\x67\x50\x27\x2d\x52\xf7\x67\xec\x5b\x2c\x9f"
> +	"\x17\xb7\x81\xec\x47\x60\x65\xf5\x86\x20\x4f\x82\x84\xd9\xee\x62"
> +	"\x6f\x49\x7d\x80\x9e\xaa\x8a\x7a\x82\x45\x65\x36\x0b\xf1\xfe\x01"
> +	"\x06\x52\x3c\xa1\xdf\xc8\x84\x89\xb0\xee\xb6\xfa\x95\x12\x42\xb9"
> +	"\x87\x53\x77\x1c\xe0\x56\x25\xf6\x96\x31\xec\x62\x82\x77\xb7\x52"
> +	"\xac\x25\x71\x49\x97\x13\x83\x23\x63\x02\x01\x02",
> +	.pkcs3_size = 268,
> +	.priv_key_A =
> +	"\x7d\xfb\xa2\x51\x24\xa4\xfa\x65\x35\x1c\x3b\xef\x3f\x6b\x10\x27"
> +	"\xde\x30\xcb\x2c\xa7\x5b\xfe\x1a\xec\x5f\x2b\x1c\x7b\xd8\xa7\xfd"
> +	"\x37\x15\xec\x62\xbd\x64\x71\x57\x31\x48\xcc\x8c\xd9\x6f\xe9\x24"
> +	"\x9d\x63\xff\x1f\xb6\x7d\xf7\x30\x23\x13\xdc\x0f\x27\xd9\x6e\x11"
> +	"\x8b\x54\x80\xe4\x35\x52\x98\x5c\xac\x87\x56\xdf\x5e\xe2\xbe\x08"
> +	"\x63\xfd\xb2\xe4\x06\x2b\x04\x68\xf6\x3a\x45\x3b\xb0\xf1\x81\x32"
> +	"\x36\xa3\xde\xe4\xe7\xec\x8b\x87\x32\x09\x45\x87\x1c\x1c\x0e\x84"
> +	"\xf7\x30\x09\x7d\x7f\x98\xf5\xbe\x92\x50\xbd\xa8\xc2\x35\x11\xe3"
> +	"\x0a\xf2\x90\x1a\x18\xcb\x5a\xe5\x4e\x4a\x93\x3d\x6d\x26\xa6\x36"
> +	"\x79\x45\x75\x12\xb4\x27\x95\xcd\x9e\x6b\x37\x57\x4d\x69\x21\xa9"
> +	"\xff\x5d\xe2\xf2\xf8\x4f\xeb\x50\x79\xa4\xa7\x87\x59\x78\x23\xfa"
> +	"\x67\xb5\xdc\x6e\xa6\x59\x81\xba\x65\x8e\x65\xfc\x7f\x51\xc8\xad"
> +	"\x1d\x28\x50\x60\x92\x2a\xcc\x9c\x47\xc7\x13\xd2\xf4\xb8\xa2\xab"
> +	"\x2c\x50\x4c\xf1\xcd\xef\xb7\x94\x1c\xe7\xd3\x2a\x55\x37\xff\xfa"
> +	"\x6d\xe8\x43\x01\xb0\x9b\x24\x5d\xd4\x57\x7d\xb5\x30\xaa\x60\x97"
> +	"\x33\xfe\xe7\x31\x39\x96\xe6\xb3\xf4\x11\xde\x3c\x57\x4b\xcb\xad",
> +	.pub_key_B =
> +	"\x91\x9e\x52\xa3\xb8\x20\x25\x12\x17\xcc\x37\x82\x81\x22\x14\x7a"
> +	"\x81\x88\xce\x9f\xf2\x46\xb1\x17\xaf\x41\x23\xc9\xb8\x93\x40\xfd"
> +	"\xa9\x96\x05\x5a\x1a\xcc\xa6\x51\xe2\x9e\xca\x63\x2a\x67\x72\x4a"
> +	"\xe1\x2b\xa7\xbe\xf9\xeb\x69\xc8\x2d\x29\xb6\x6b\x5f\xc0\xf2\x90"
> +	"\xa9\x36\x49\xdb\xcc\x6b\x5e\xed\x76\x47\x9f\xc9\x2e\x91\x68\x75"
> +	"\xa3\x39\x6c\x50\xa6\xaf\x81\xac\x23\x58\xa9\xc9\x71\xf3\x87\x97"
> +	"\xef\x0c\x80\x19\xac\xb7\xf0\xa0\x83\x44\x4b\x1c\x08\xf1\x4f\x23"
> +	"\xfb\xf1\x61\x39\x00\x59\xef\x83\xa5\xaf\x2f\x3f\xc0\x19\x2a\x5b"
> +	"\x22\x53\xdb\x8b\x24\xbc\xe4\xaa\x9a\x19\x6b\xfd\x20\xbf\x1a\xe2"
> +	"\xb5\xaf\x82\x3e\xb8\xea\xe7\x28\xcd\xad\xfe\x00\xee\x70\x52\x46"
> +	"\x3d\x2c\x55\x81\x44\xed\x15\x21\xc8\x48\x75\x4d\x6f\xf0\xba\xe9"
> +	"\xab\x4c\x65\xf3\x54\x2e\x74\xd9\xe7\xe2\xb7\xad\xec\x6d\xb2\x6e"
> +	"\xc1\xe3\x2d\x0e\xb1\x18\x36\xd7\xb9\x42\x6b\x2f\xc9\x51\x2e\xff"
> +	"\x5d\xd0\xca\x8c\x0d\x0d\x95\xd3\x16\xf3\xdb\xc1\x2b\xed\x00\x32"
> +	"\xd7\x77\xb8\x0e\x86\x7a\x57\x48\x74\x23\x30\xae\xe0\x3c\x38\xa6"
> +	"\xed\xf9\x0c\x16\xf2\xf2\xa0\xe0\x51\x80\x67\x92\xe4\xc7\x9a\x5e",
> +	.expected_pub_key_A =
> +	"\x18\xd9\x78\xdd\x6a\xc9\x19\x4e\xe6\xa0\x83\xcc\x12\x00\x3b\x6c"
> +	"\x4c\x8c\x11\x38\x94\x90\xd7\xc4\x1f\xa6\x64\x04\x35\x4a\xda\x48"
> +	"\x5a\xeb\x38\xe7\xae\x44\x16\x4a\x94\xfe\x7c\xa9\x00\xff\x67\x20"
> +	"\x4c\xef\x34\x45\xfe\x2d\xf5\xa9\xfb\xa8\xc0\x45\x09\xcd\xcd\xc0"
> +	"\x4c\x20\xc0\x1e\x42\x41\x4b\x37\x6c\x90\xba\xef\xd6\x65\xab\xb1"
> +	"\xec\x51\x30\xfa\x08\xfc\x22\xc6\x42\xce\x6a\x90\xb7\x27\xe4\x52"
> +	"\x76\x28\x78\x17\x56\x71\x73\xeb\xaf\x6e\xbb\x61\x7a\x6b\x4b\xdb"
> +	"\x8e\x2f\xaa\xfa\x9e\x40\xee\x84\xf6\x63\x9b\xb7\xe2\x22\x72\x6b"
> +	"\x94\x58\x3f\x08\xa5\xbe\xd6\x87\x63\xe7\xbb\x5a\xfb\x52\x92\xd2"
> +	"\xe6\x5e\x7e\x55\x78\x4b\xc0\x0e\x1a\xe5\xe6\x0f\x0e\x41\xd5\x05"
> +	"\xb7\x71\x42\x78\x35\x74\xad\x33\x9f\x24\xc0\x3b\x09\xd5\xcf\x4d"
> +	"\x6e\x20\x3a\xee\x04\x9f\x05\x2d\x8d\x77\x06\x2d\x9b\x67\xba\x39"
> +	"\x2f\x6c\x1d\x7b\x75\x57\xed\x2f\xe2\xf1\xbc\x0b\x3a\x77\xf2\xba"
> +	"\xb2\xb1\x98\x52\x34\x40\x53\x7b\x0e\xb6\x13\x6a\x5b\x91\xe4\x59"
> +	"\x67\x2c\x45\x3a\x07\x1a\xa2\x3b\xdb\xa1\xa6\x08\xf0\x80\xe8\x61"
> +	"\xca\xac\x95\xb3\x3e\xd6\x97\x98\x08\x7e\x50\x48\xc0\x25\x45\xd0",
> +	.expected_shared_secret =
> +	"\x1d\x7d\x2e\x47\x06\xbe\x46\xd3\x69\xf6\xe7\x0e\x88\xdc\xe8\xe1"
> +	"\xe6\x6a\xfc\x3c\xbc\xc1\x85\xe9\x24\xf0\x7b\x75\x0f\xa4\x04\xd6"
> +	"\x9b\xef\x7b\x30\x55\xde\xbf\xd4\xb2\xcb\xce\x74\x53\xae\x72\x34"
> +	"\x19\x36\x9e\xe9\x45\xb8\xda\x59\x22\x41\x9e\xa3\x8f\x02\xaa\x60"
> +	"\xb1\x8b\xf9\x84\xd4\x8a\xeb\xea\xd1\xd9\x1a\x53\xe9\x5f\x01\xd1"
> +	"\x40\xb4\x73\x63\xc5\x1a\x79\xf1\x08\xb6\xc0\x0c\x85\x9e\x3e\x70"
> +	"\xea\x79\xd9\xc2\x5b\x17\xa7\x1e\xeb\x58\x3e\x1b\xca\x7a\x4d\xab"
> +	"\x61\x5b\xdf\xa2\x6f\x1e\xd4\x36\xeb\xe3\xe9\x04\x10\x8e\x0b\xc9"
> +	"\x18\x8c\x0d\x6e\x4f\x2e\xc5\xfc\x5b\x6a\xb5\x9f\xdf\x71\x50\x04"
> +	"\x54\x62\x49\x57\xf3\xc6\x9e\x39\xc6\x56\xf1\x2d\x31\x59\x58\xdb"
> +	"\x67\x94\x25\xbd\x47\xe2\xdd\x95\x0c\x39\xb1\xfa\x22\xc6\x94\xc4"
> +	"\x75\xab\xff\xe2\xce\x52\xa2\xeb\x78\x26\x10\x0f\x2d\x8c\xf2\xad"
> +	"\xd2\xc7\xaf\x85\xd9\x5c\x71\xfe\x9e\xe9\xeb\xbf\x20\x36\x1e\x9a"
> +	"\x74\x43\xe6\x06\x00\x8a\x4d\x64\x41\x2a\x15\x6d\x60\x44\x3f\x2c"
> +	"\xcd\x05\x16\x54\x6a\x48\x7c\x71\x0a\xe9\x33\x95\x16\xc7\xf4\x23"
> +	"\xc2\x8d\xed\x8a\x24\x5d\x99\xc7\x8c\x8b\x07\x47\x8c\xe9\x0c\x10",
> +	.key_len = 256
> +	}
> +};
> +
>  /*
>   * MD4 test vectors from RFC1320
>   */


Ciao
Stephan
