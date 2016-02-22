From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH 4/8] akcipher: Move the RSA DER encoding to the crypto
 layer
Date: Mon, 22 Feb 2016 11:59:30 -0800
Message-ID: <56CB68A2.50505@intel.com>
References: <20160219171806.17223.91381.stgit@warthog.procyon.org.uk>
 <20160219171836.17223.9507.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-security-module@vger.kernel.org, zohar@linux.vnet.ibm.com,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:48835 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755214AbcBVUDu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 22 Feb 2016 15:03:50 -0500
In-Reply-To: <20160219171836.17223.9507.stgit@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 02/19/2016 09:18 AM, David Howells wrote:
> Move the RSA EMSA-PKCS1-v1_5 encoding from the asymmetric-key public_key
> subtype to the rsa crypto module.  This means that the public_key subtype
> no longer has any dependencies on public key type.
> 
> To make this work, I've made the following changes:
> 
>  (1) An indicator as to the hash algorithm employed must be passed to the
>      public key algorithm.  I have made this a string, equivalent to the
>      name in the matching crypto module and placed it in akcipher_request.
> 
>  (2) The RSA module builds the EMSA-PKCS1-v1_5 encoded message (EM) and
>      then compares that to the 'decrypted' signature.  This function can
>      then be reused for signing.
> 
>  (3) The destination buffer in akcipher_request is now an input buffer
>      holding the message digest (M) for the verify operation.  The output
>      of the verify operation is purely the error code.
> 
>  (4) The crypto driver in crypto/asymmetric_keys/rsa.c is now reduced to
>      something that doesn't care about what the encryption actually does
>      and and has been merged into public_key.c.
> 
>  (5) The test drivers set a NULL hash algorithm as I'm not sure what they
>      should be.
> 
>  (6) CONFIG_PUBLIC_KEY_ALGO_RSA is gone.  Module signing must set
>      CONFIG_CRYPTO_RSA=y instead.
> 
> Thoughts:
> 
>  (*) Should the encoding style (eg. raw, EMSA-PKCS1-v1_5) also be passed to
>      the public key algorithm?

I wonder if this should be merged with the crypto/rsa-pkcs1pad.c template
that we already have. Looks like the two do the same padding now.
Should we merge then and pass the hash param as a separate template param,
e.g the public_key would allocate "pkcs1pad(rsa, sha1)"?

> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  crypto/asymmetric_keys/Kconfig      |    7 -
>  crypto/asymmetric_keys/Makefile     |    1 
>  crypto/asymmetric_keys/public_key.c |   69 +++++++++--
>  crypto/asymmetric_keys/rsa.c        |  224 -----------------------------------
>  crypto/rsa.c                        |  210 ++++++++++++++++++++++++++++-----
>  crypto/testmgr.c                    |    5 -
>  include/crypto/akcipher.h           |    7 +
>  include/crypto/public_key.h         |    2 
>  init/Kconfig                        |    2 
>  9 files changed, 248 insertions(+), 279 deletions(-)
>  delete mode 100644 crypto/asymmetric_keys/rsa.c
> 
> diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
> index 905d745c2f85..91a7e047a765 100644
> --- a/crypto/asymmetric_keys/Kconfig
> +++ b/crypto/asymmetric_keys/Kconfig
> @@ -12,7 +12,6 @@ if ASYMMETRIC_KEY_TYPE
>  config ASYMMETRIC_PUBLIC_KEY_SUBTYPE
>  	tristate "Asymmetric public-key crypto algorithm subtype"
>  	select MPILIB
> -	select PUBLIC_KEY_ALGO_RSA
>  	select CRYPTO_HASH_INFO
>  	help
>  	  This option provides support for asymmetric public key type handling.
> @@ -20,12 +19,6 @@ config ASYMMETRIC_PUBLIC_KEY_SUBTYPE
>  	  appropriate hash algorithms (such as SHA-1) must be available.
>  	  ENOPKG will be reported if the requisite algorithm is unavailable.
>  
> -config PUBLIC_KEY_ALGO_RSA
> -	tristate "RSA public-key algorithm"
> -	select CRYPTO_RSA
> -	help
> -	  This option enables support for the RSA algorithm (PKCS#1, RFC3447).
> -
>  config X509_CERTIFICATE_PARSER
>  	tristate "X.509 certificate parser"
>  	depends on ASYMMETRIC_PUBLIC_KEY_SUBTYPE
> diff --git a/crypto/asymmetric_keys/Makefile b/crypto/asymmetric_keys/Makefile
> index b78a194ea014..f90486256f01 100644
> --- a/crypto/asymmetric_keys/Makefile
> +++ b/crypto/asymmetric_keys/Makefile
> @@ -7,7 +7,6 @@ obj-$(CONFIG_ASYMMETRIC_KEY_TYPE) += asymmetric_keys.o
>  asymmetric_keys-y := asymmetric_type.o signature.o
>  
>  obj-$(CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE) += public_key.o
> -obj-$(CONFIG_PUBLIC_KEY_ALGO_RSA) += rsa.o
>  
>  #
>  # X.509 Certificate handling
> diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
> index b383629b9e62..66727a13d561 100644
> --- a/crypto/asymmetric_keys/public_key.c
> +++ b/crypto/asymmetric_keys/public_key.c
> @@ -17,8 +17,10 @@
>  #include <linux/kernel.h>
>  #include <linux/slab.h>
>  #include <linux/seq_file.h>
> +#include <linux/scatterlist.h>
>  #include <keys/asymmetric-subtype.h>
>  #include <crypto/public_key.h>
> +#include <crypto/akcipher.h>
>  
>  MODULE_LICENSE("GPL");
>  
> @@ -35,12 +37,6 @@ const char *const pkey_id_type_name[PKEY_ID_TYPE__LAST] = {
>  };
>  EXPORT_SYMBOL_GPL(pkey_id_type_name);
>  
> -static int (*alg_verify[PKEY_ALGO__LAST])(const struct public_key *pkey,
> -	const struct public_key_signature *sig) = {
> -	NULL,
> -	rsa_verify_signature
> -};
> -
>  /*
>   * Provide a part of a description of the key for /proc/keys.
>   */
> @@ -68,24 +64,75 @@ void public_key_destroy(void *payload)
>  }
>  EXPORT_SYMBOL_GPL(public_key_destroy);
>  
> +struct public_key_completion {
> +	struct completion completion;
> +	int err;
> +};
> +
> +static void public_key_verify_done(struct crypto_async_request *req, int err)
> +{
> +	struct public_key_completion *compl = req->data;
> +
> +	if (err == -EINPROGRESS)
> +		return;
> +
> +	compl->err = err;
> +	complete(&compl->completion);
> +}
> +
>  /*
>   * Verify a signature using a public key.
>   */
>  int public_key_verify_signature(const struct public_key *pkey,
>  				const struct public_key_signature *sig)
>  {
> +	struct public_key_completion compl;
> +	struct crypto_akcipher *tfm;
> +	struct akcipher_request *req;
> +	struct scatterlist sig_sg, digest_sg;
> +	int ret = -ENOMEM;
> +
> +	pr_devel("==>%s()\n", __func__);
> +
>  	BUG_ON(!pkey);
>  	BUG_ON(!sig);
>  	BUG_ON(!sig->digest);
>  	BUG_ON(!sig->s);
>  
> -	if (pkey->pkey_algo >= PKEY_ALGO__LAST)
> -		return -ENOPKG;
> +	tfm = crypto_alloc_akcipher(pkey_algo_name[sig->pkey_algo], 0, 0);
> +	if (IS_ERR(tfm))
> +		return PTR_ERR(tfm);
> +
> +	req = akcipher_request_alloc(tfm, GFP_KERNEL);
> +	if (!req)
> +		goto error_free_tfm;
> +
> +	ret = crypto_akcipher_set_pub_key(tfm, pkey->key, pkey->keylen);
> +	if (ret)
> +		goto error_free_req;
> +
> +	sg_init_one(&sig_sg, sig->s, sig->s_size);
> +	sg_init_one(&digest_sg, sig->digest, sig->digest_size);
> +	akcipher_request_set_crypt(req, &sig_sg, &digest_sg,
> +				   sig->s_size, sig->digest_size,
> +				   hash_algo_name[sig->pkey_hash_algo]);
> +	init_completion(&compl.completion);
> +	akcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG |
> +				      CRYPTO_TFM_REQ_MAY_SLEEP,
> +				      public_key_verify_done, &compl);
>  
> -	if (!alg_verify[pkey->pkey_algo])
> -		return -ENOPKG;
> +	ret = crypto_akcipher_verify(req);
> +	if (ret == -EINPROGRESS) {
> +		wait_for_completion(&compl.completion);
> +		ret = compl.err;
> +	}
>  
> -	return alg_verify[pkey->pkey_algo](pkey, sig);
> +error_free_req:
> +	akcipher_request_free(req);
> +error_free_tfm:
> +	crypto_free_akcipher(tfm);
> +	pr_devel("<==%s() = %d\n", __func__, ret);
> +	return ret;
>  }
>  EXPORT_SYMBOL_GPL(public_key_verify_signature);
>  
> diff --git a/crypto/asymmetric_keys/rsa.c b/crypto/asymmetric_keys/rsa.c
> deleted file mode 100644
> index 51502bca65e7..000000000000
> --- a/crypto/asymmetric_keys/rsa.c
> +++ /dev/null
> @@ -1,224 +0,0 @@
> -/* RSA asymmetric public-key algorithm [RFC3447]
> - *
> - * Copyright (C) 2012 Red Hat, Inc. All Rights Reserved.
> - * Written by David Howells (dhowells@redhat.com)
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public Licence
> - * as published by the Free Software Foundation; either version
> - * 2 of the Licence, or (at your option) any later version.
> - */
> -
> -#define pr_fmt(fmt) "RSA: "fmt
> -#include <linux/module.h>
> -#include <linux/slab.h>
> -#include <crypto/akcipher.h>
> -#include <crypto/public_key.h>
> -#include <crypto/algapi.h>
> -
> -MODULE_LICENSE("GPL");
> -MODULE_DESCRIPTION("RSA Public Key Algorithm");
> -
> -#define kenter(FMT, ...) \
> -	pr_devel("==> %s("FMT")\n", __func__, ##__VA_ARGS__)
> -#define kleave(FMT, ...) \
> -	pr_devel("<== %s()"FMT"\n", __func__, ##__VA_ARGS__)
> -
> -/*
> - * Hash algorithm OIDs plus ASN.1 DER wrappings [RFC4880 sec 5.2.2].
> - */
> -static const u8 RSA_digest_info_MD5[] = {
> -	0x30, 0x20, 0x30, 0x0C, 0x06, 0x08,
> -	0x2A, 0x86, 0x48, 0x86, 0xF7, 0x0D, 0x02, 0x05, /* OID */
> -	0x05, 0x00, 0x04, 0x10
> -};
> -
> -static const u8 RSA_digest_info_SHA1[] = {
> -	0x30, 0x21, 0x30, 0x09, 0x06, 0x05,
> -	0x2B, 0x0E, 0x03, 0x02, 0x1A,
> -	0x05, 0x00, 0x04, 0x14
> -};
> -
> -static const u8 RSA_digest_info_RIPE_MD_160[] = {
> -	0x30, 0x21, 0x30, 0x09, 0x06, 0x05,
> -	0x2B, 0x24, 0x03, 0x02, 0x01,
> -	0x05, 0x00, 0x04, 0x14
> -};
> -
> -static const u8 RSA_digest_info_SHA224[] = {
> -	0x30, 0x2d, 0x30, 0x0d, 0x06, 0x09,
> -	0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x04,
> -	0x05, 0x00, 0x04, 0x1C
> -};
> -
> -static const u8 RSA_digest_info_SHA256[] = {
> -	0x30, 0x31, 0x30, 0x0d, 0x06, 0x09,
> -	0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x01,
> -	0x05, 0x00, 0x04, 0x20
> -};
> -
> -static const u8 RSA_digest_info_SHA384[] = {
> -	0x30, 0x41, 0x30, 0x0d, 0x06, 0x09,
> -	0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x02,
> -	0x05, 0x00, 0x04, 0x30
> -};
> -
> -static const u8 RSA_digest_info_SHA512[] = {
> -	0x30, 0x51, 0x30, 0x0d, 0x06, 0x09,
> -	0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x03,
> -	0x05, 0x00, 0x04, 0x40
> -};
> -
> -static const struct {
> -	const u8 *data;
> -	size_t size;
> -} RSA_ASN1_templates[PKEY_HASH__LAST] = {
> -#define _(X) { RSA_digest_info_##X, sizeof(RSA_digest_info_##X) }
> -	[HASH_ALGO_MD5]		= _(MD5),
> -	[HASH_ALGO_SHA1]	= _(SHA1),
> -	[HASH_ALGO_RIPE_MD_160]	= _(RIPE_MD_160),
> -	[HASH_ALGO_SHA256]	= _(SHA256),
> -	[HASH_ALGO_SHA384]	= _(SHA384),
> -	[HASH_ALGO_SHA512]	= _(SHA512),
> -	[HASH_ALGO_SHA224]	= _(SHA224),
> -#undef _
> -};
> -
> -struct rsa_completion {
> -	struct completion completion;
> -	int err;
> -};
> -
> -/*
> - * Perform the RSA signature verification.
> - * @H: Value of hash of data and metadata
> - * @EM: The computed signature value
> - * @k: The size of EM (EM[0] is an invalid location but should hold 0x00)
> - * @hash_size: The size of H
> - * @asn1_template: The DigestInfo ASN.1 template
> - * @asn1_size: Size of asm1_template[]
> - */
> -static int rsa_verify(const u8 *H, const u8 *EM, size_t k, size_t hash_size,
> -		      const u8 *asn1_template, size_t asn1_size)
> -{
> -	unsigned PS_end, T_offset, i;
> -
> -	kenter(",,%zu,%zu,%zu", k, hash_size, asn1_size);
> -
> -	if (k < 2 + 1 + asn1_size + hash_size)
> -		return -EBADMSG;
> -
> -	/* Decode the EMSA-PKCS1-v1_5
> -	 * note: leading zeros are stripped by the RSA implementation
> -	 */
> -	if (EM[0] != 0x01) {
> -		kleave(" = -EBADMSG [EM[0] == %02u]", EM[0]);
> -		return -EBADMSG;
> -	}
> -
> -	T_offset = k - (asn1_size + hash_size);
> -	PS_end = T_offset - 1;
> -	if (EM[PS_end] != 0x00) {
> -		kleave(" = -EBADMSG [EM[T-1] == %02u]", EM[PS_end]);
> -		return -EBADMSG;
> -	}
> -
> -	for (i = 1; i < PS_end; i++) {
> -		if (EM[i] != 0xff) {
> -			kleave(" = -EBADMSG [EM[PS%x] == %02u]", i - 2, EM[i]);
> -			return -EBADMSG;
> -		}
> -	}
> -
> -	if (crypto_memneq(asn1_template, EM + T_offset, asn1_size) != 0) {
> -		kleave(" = -EBADMSG [EM[T] ASN.1 mismatch]");
> -		return -EBADMSG;
> -	}
> -
> -	if (crypto_memneq(H, EM + T_offset + asn1_size, hash_size) != 0) {
> -		kleave(" = -EKEYREJECTED [EM[T] hash mismatch]");
> -		return -EKEYREJECTED;
> -	}
> -
> -	kleave(" = 0");
> -	return 0;
> -}
> -
> -static void public_key_verify_done(struct crypto_async_request *req, int err)
> -{
> -	struct rsa_completion *compl = req->data;
> -
> -	if (err == -EINPROGRESS)
> -		return;
> -
> -	compl->err = err;
> -	complete(&compl->completion);
> -}
> -
> -int rsa_verify_signature(const struct public_key *pkey,
> -			 const struct public_key_signature *sig)
> -{
> -	struct crypto_akcipher *tfm;
> -	struct akcipher_request *req;
> -	struct rsa_completion compl;
> -	struct scatterlist sig_sg, sg_out;
> -	void *outbuf = NULL;
> -	unsigned int outlen = 0;
> -	int ret = -ENOMEM;
> -
> -	tfm = crypto_alloc_akcipher("rsa", 0, 0);
> -	if (IS_ERR(tfm))
> -		goto error_out;
> -
> -	req = akcipher_request_alloc(tfm, GFP_KERNEL);
> -	if (!req)
> -		goto error_free_tfm;
> -
> -	ret = crypto_akcipher_set_pub_key(tfm, pkey->key, pkey->keylen);
> -	if (ret)
> -		goto error_free_req;
> -
> -	ret = -EINVAL;
> -	outlen = crypto_akcipher_maxsize(tfm);
> -	if (!outlen)
> -		goto error_free_req;
> -
> -	/* Initialize the output buffer */
> -	ret = -ENOMEM;
> -	outbuf = kmalloc(outlen, GFP_KERNEL);
> -	if (!outbuf)
> -		goto error_free_req;
> -
> -	sg_init_one(&sig_sg, sig->s, sig->s_size);
> -	sg_init_one(&sg_out, outbuf, outlen);
> -	akcipher_request_set_crypt(req, &sig_sg, &sg_out, sig->s_size, outlen);
> -	init_completion(&compl.completion);
> -	akcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG |
> -				      CRYPTO_TFM_REQ_MAY_SLEEP,
> -				      public_key_verify_done, &compl);
> -
> -	ret = crypto_akcipher_verify(req);
> -	if (ret == -EINPROGRESS) {
> -		wait_for_completion(&compl.completion);
> -		ret = compl.err;
> -	}
> -
> -	if (ret)
> -		goto error_free_req;
> -
> -	/* Output from the operation is an encoded message (EM) of
> -	 * length k octets.
> -	 */
> -	outlen = req->dst_len;
> -	ret = rsa_verify(sig->digest, outbuf, outlen, sig->digest_size,
> -			 RSA_ASN1_templates[sig->pkey_hash_algo].data,
> -			 RSA_ASN1_templates[sig->pkey_hash_algo].size);
> -error_free_req:
> -	akcipher_request_free(req);
> -error_free_tfm:
> -	crypto_free_akcipher(tfm);
> -error_out:
> -	kfree(outbuf);
> -	return ret;
> -}
> -EXPORT_SYMBOL_GPL(rsa_verify_signature);
> diff --git a/crypto/rsa.c b/crypto/rsa.c
> index 77d737f52147..9a7c9ca9eafc 100644
> --- a/crypto/rsa.c
> +++ b/crypto/rsa.c
> @@ -16,6 +16,78 @@
>  #include <crypto/algapi.h>
>  
>  /*
> + * Hash algorithm OIDs plus ASN.1 DER wrappings [RFC4880 sec 5.2.2].
> + */
> +static const u8 rsa_digest_info_md5[] = {
> +	0x30, 0x20, 0x30, 0x0c, 0x06, 0x08,
> +	0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x02, 0x05, /* OID */
> +	0x05, 0x00, 0x04, 0x10
> +};
> +
> +static const u8 rsa_digest_info_sha1[] = {
> +	0x30, 0x21, 0x30, 0x09, 0x06, 0x05,
> +	0x2b, 0x0e, 0x03, 0x02, 0x1a,
> +	0x05, 0x00, 0x04, 0x14
> +};
> +
> +static const u8 rsa_digest_info_rmd160[] = {
> +	0x30, 0x21, 0x30, 0x09, 0x06, 0x05,
> +	0x2b, 0x24, 0x03, 0x02, 0x01,
> +	0x05, 0x00, 0x04, 0x14
> +};
> +
> +static const u8 rsa_digest_info_sha224[] = {
> +	0x30, 0x2d, 0x30, 0x0d, 0x06, 0x09,
> +	0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x04,
> +	0x05, 0x00, 0x04, 0x1c
> +};
> +
> +static const u8 rsa_digest_info_sha256[] = {
> +	0x30, 0x31, 0x30, 0x0d, 0x06, 0x09,
> +	0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x01,
> +	0x05, 0x00, 0x04, 0x20
> +};
> +
> +static const u8 rsa_digest_info_sha384[] = {
> +	0x30, 0x41, 0x30, 0x0d, 0x06, 0x09,
> +	0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x02,
> +	0x05, 0x00, 0x04, 0x30
> +};
> +
> +static const u8 rsa_digest_info_sha512[] = {
> +	0x30, 0x51, 0x30, 0x0d, 0x06, 0x09,
> +	0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x03,
> +	0x05, 0x00, 0x04, 0x40
> +};
> +
> +static const struct rsa_asn1_template {
> +	const char	*name;
> +	const u8	*data;
> +	size_t		size;
> +} rsa_asn1_templates[] = {
> +#define _(X) { #X, rsa_digest_info_##X, sizeof(rsa_digest_info_##X) }
> +	_(md5),
> +	_(sha1),
> +	_(rmd160),
> +	_(sha256),
> +	_(sha384),
> +	_(sha512),
> +	_(sha224),
> +	{ NULL }
> +#undef _
> +};
> +
> +static const struct rsa_asn1_template *rsa_lookup_asn1(const char *name)
> +{
> +	const struct rsa_asn1_template *p;
> +
> +	for (p = rsa_asn1_templates; p->name; p++)
> +		if (strcmp(name, p->name) == 0)
> +			return p;
> +	return NULL;
> +}
> +
> +/*
>   * RSAEP function [RFC3447 sec 5.1.1]
>   * c = m^e mod n;
>   */
> @@ -71,6 +143,13 @@ static int _rsa_verify(const struct rsa_key *key, MPI m, MPI s)
>  	return mpi_powm(m, s, key->e, key->n);
>  }
>  
> +static int rsa_max_size(struct crypto_akcipher *tfm)
> +{
> +	struct rsa_key *pkey = akcipher_tfm_ctx(tfm);
> +
> +	return pkey->n ? mpi_get_size(pkey->n) : -EINVAL;
> +}
> +
>  static inline struct rsa_key *rsa_get_key(struct crypto_akcipher *tfm)
>  {
>  	return akcipher_tfm_ctx(tfm);
> @@ -192,44 +271,122 @@ err_free_s:
>  	return ret;
>  }
>  
> -static int rsa_verify(struct akcipher_request *req)
> +static int rsa_verify_raw(struct akcipher_request *req, MPI EM)
>  {
>  	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
>  	const struct rsa_key *pkey = rsa_get_key(tfm);
> -	MPI s, m = mpi_alloc(0);
> -	int ret = 0;
> -	int sign;
> +	MPI s, m_calc;
> +	int ret;
>  
> -	if (!m)
> +	m_calc = mpi_alloc(0);
> +	if (!m_calc)
>  		return -ENOMEM;
>  
> -	if (unlikely(!pkey->n || !pkey->e)) {
> -		ret = -EINVAL;
> -		goto err_free_m;
> -	}
> -
>  	ret = -ENOMEM;
>  	s = mpi_read_raw_from_sgl(req->src, req->src_len);
> -	if (!s) {
> -		ret = -ENOMEM;
> -		goto err_free_m;
> -	}
> +	if (!s)
> +		goto err_free_m_calc;
>  
> -	ret = _rsa_verify(pkey, m, s);
> +	ret = _rsa_verify(pkey, m_calc, s);
>  	if (ret)
>  		goto err_free_s;
>  
> -	ret = mpi_write_to_sgl(m, req->dst, &req->dst_len, &sign);
> -	if (ret)
> +	ret = -EKEYREJECTED;
> +	if (mpi_cmp(m_calc, EM) != 0)
>  		goto err_free_s;
>  
> -	if (sign < 0)
> -		ret = -EBADMSG;
> -
> +	ret = 0;
>  err_free_s:
>  	mpi_free(s);
> -err_free_m:
> -	mpi_free(m);
> +err_free_m_calc:
> +	mpi_free(m_calc);
> +	return ret;
> +}
> +
> +/*
> + * Turn Hash(M) into EM for a key of size k and a specified hash algorithm as
> + * per EMSA-PKCS1-v1_5:
> + *
> + *	EM = 0x00 || 0x01 || PS || 0x00 || T
> + */
> +static MPI rsa_emsa_pkcs1_v1_5(struct scatterlist *H, int H_size, int k,
> +			       const char *hash_algo)
> +{
> +	const struct rsa_asn1_template *asn1;
> +	MPI EM;
> +	int PS_end, T_offset;
> +	u8 *buf;
> +
> +	asn1 = rsa_lookup_asn1(hash_algo);
> +	if (!asn1)
> +		return ERR_PTR(-ENOPKG);
> +
> +	if (k < 2 + 1 + asn1->size + H_size)
> +		return ERR_PTR(-EMSGSIZE);
> +
> +	T_offset = k - (asn1->size + H_size);
> +	PS_end = T_offset - 1;
> +	if (PS_end - 2 < 8)
> +		return ERR_PTR(-EMSGSIZE);
> +
> +	buf = kmalloc(k, GFP_KERNEL);
> +	if (!buf)
> +		return ERR_PTR(-ENOMEM);
> +
> +	/* Set the initial zero and block type octets */
> +	buf[0] = 0x00;
> +	buf[1] = 0x01;
> +
> +	/* Set the padding string and the divider */
> +	memset(buf + 2, 0xff, PS_end - 2);
> +	buf[PS_end] = 0x00;
> +
> +	/* Set the DER-encoded DigestInfo */
> +	memcpy(buf + T_offset, asn1->data, asn1->size);
> +
> +	/* Finally set the  */
> +	if (sg_copy_to_buffer(H, sg_nents(H),
> +			      buf + T_offset + asn1->size,
> +			      H_size) != H_size) {
> +		EM = ERR_PTR(-EMSGSIZE);
> +		goto error_free_buf;
> +	}
> +
> +	EM = mpi_read_raw_data(buf, k);
> +	if (!EM)
> +		EM = ERR_PTR(-ENOMEM);
> +	
> +error_free_buf:
> +	kfree(buf);
> +	return EM;
> +}
> +
> +static int rsa_verify_encoded(struct akcipher_request *req)
> +{
> +	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
> +	const struct rsa_key *pkey = rsa_get_key(tfm);
> +	MPI EM;
> +	int ret, k;
> +
> +	pr_devel("==>%s(%u,%u,%s)\n",
> +		 __func__, req->src_len, req->dst_len, req->hash_algo);
> +
> +	if (unlikely(!pkey->n || !pkey->e || !req->hash_algo))
> +		return -EINVAL;
> +
> +	/* Find k - the size of E(M). */
> +	k = rsa_max_size(tfm);
> +	if (k < 0)
> +		return k;
> +
> +	EM = rsa_emsa_pkcs1_v1_5(req->dst, req->dst_len, k, req->hash_algo);
> +	if (IS_ERR(EM))
> +		return PTR_ERR(EM);
> +
> +	ret = rsa_verify_raw(req, EM);
> +
> +	mpi_free(EM);
> +	pr_devel("<==%s() = %d\n", __func__, ret);
>  	return ret;
>  }
>  
> @@ -282,13 +439,6 @@ static int rsa_set_priv_key(struct crypto_akcipher *tfm, const void *key,
>  	return ret;
>  }
>  
> -static int rsa_max_size(struct crypto_akcipher *tfm)
> -{
> -	struct rsa_key *pkey = akcipher_tfm_ctx(tfm);
> -
> -	return pkey->n ? mpi_get_size(pkey->n) : -EINVAL;
> -}
> -
>  static void rsa_exit_tfm(struct crypto_akcipher *tfm)
>  {
>  	struct rsa_key *pkey = akcipher_tfm_ctx(tfm);
> @@ -300,7 +450,7 @@ static struct akcipher_alg rsa = {
>  	.encrypt = rsa_enc,
>  	.decrypt = rsa_dec,
>  	.sign = rsa_sign,
> -	.verify = rsa_verify,
> +	.verify = rsa_verify_encoded,
>  	.set_priv_key = rsa_set_priv_key,
>  	.set_pub_key = rsa_set_pub_key,
>  	.max_size = rsa_max_size,
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index ae8c57fd8bc7..94879a3d2ef7 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -1882,7 +1882,7 @@ static int do_test_rsa(struct crypto_akcipher *tfm,
>  	sg_set_buf(&src_tab[1], vecs->m + 8, vecs->m_size - 8);
>  	sg_init_one(&dst, outbuf_enc, out_len_max);
>  	akcipher_request_set_crypt(req, src_tab, &dst, vecs->m_size,
> -				   out_len_max);
> +				   out_len_max, NULL);
>  	akcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
>  				      tcrypt_complete, &result);
>  
> @@ -1916,7 +1916,8 @@ static int do_test_rsa(struct crypto_akcipher *tfm,
>  	sg_init_one(&src, vecs->c, vecs->c_size);
>  	sg_init_one(&dst, outbuf_dec, out_len_max);
>  	init_completion(&result.completion);
> -	akcipher_request_set_crypt(req, &src, &dst, vecs->c_size, out_len_max);
> +	akcipher_request_set_crypt(req, &src, &dst, vecs->c_size, out_len_max,
> +				   NULL);
>  
>  	/* Run RSA decrypt - m = c^d mod n;*/
>  	err = wait_async_op(&result, crypto_akcipher_decrypt(req));
> diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
> index 354de15cea6b..a59a6a0d6784 100644
> --- a/include/crypto/akcipher.h
> +++ b/include/crypto/akcipher.h
> @@ -27,6 +27,7 @@
>   *		result.
>   *		In case of error where the dst sgl size was insufficient,
>   *		it will be updated to the size required for the operation.
> + * @hash_algo:	The hash algorithm used for sign/verify operations.
>   * @__ctx:	Start of private context data
>   */
>  struct akcipher_request {
> @@ -35,6 +36,7 @@ struct akcipher_request {
>  	struct scatterlist *dst;
>  	unsigned int src_len;
>  	unsigned int dst_len;
> +	const char *hash_algo;
>  	void *__ctx[] CRYPTO_MINALIGN_ATTR;
>  };
>  
> @@ -241,17 +243,20 @@ static inline void akcipher_request_set_callback(struct akcipher_request *req,
>   * @dst:	ptr to output scatter list
>   * @src_len:	size of the src input scatter list to be processed
>   * @dst_len:	size of the dst output scatter list
> + * @hash_algo:	The hash algorithm that was used for a signature (or NULL).
>   */
>  static inline void akcipher_request_set_crypt(struct akcipher_request *req,
>  					      struct scatterlist *src,
>  					      struct scatterlist *dst,
>  					      unsigned int src_len,
> -					      unsigned int dst_len)
> +					      unsigned int dst_len,
> +					      const char *hash_algo)
>  {
>  	req->src = src;
>  	req->dst = dst;
>  	req->src_len = src_len;
>  	req->dst_len = dst_len;
> +	req->hash_algo = hash_algo;
>  }
>  
>  /**
> diff --git a/include/crypto/public_key.h b/include/crypto/public_key.h
> index a1693ed77be6..80ab099a3edf 100644
> --- a/include/crypto/public_key.h
> +++ b/include/crypto/public_key.h
> @@ -91,6 +91,4 @@ extern struct key *x509_request_asymmetric_key(struct key *keyring,
>  int public_key_verify_signature(const struct public_key *pkey,
>  				const struct public_key_signature *sig);
>  
> -int rsa_verify_signature(const struct public_key *pkey,
> -			 const struct public_key_signature *sig);
>  #endif /* _LINUX_PUBLIC_KEY_H */
> diff --git a/init/Kconfig b/init/Kconfig
> index 22320804fbaf..af4de4f1b02c 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1757,9 +1757,9 @@ config SYSTEM_DATA_VERIFICATION
>  	select SYSTEM_TRUSTED_KEYRING
>  	select KEYS
>  	select CRYPTO
> +	select CRYPTO_RSA
>  	select ASYMMETRIC_KEY_TYPE
>  	select ASYMMETRIC_PUBLIC_KEY_SUBTYPE
> -	select PUBLIC_KEY_ALGO_RSA
>  	select ASN1
>  	select OID_REGISTRY
>  	select X509_CERTIFICATE_PARSER
> 


-- 
TS
