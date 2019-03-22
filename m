Return-Path: <SRS0=7kP/=RZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9F53C43381
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 19:50:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ACBCC21841
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 19:50:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbfCVTuU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Mar 2019 15:50:20 -0400
Received: from vmicros1.altlinux.org ([194.107.17.57]:33464 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbfCVTuT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Mar 2019 15:50:19 -0400
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id B42DF72CC53;
        Fri, 22 Mar 2019 22:42:31 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id 6500B4A4A16;
        Fri, 22 Mar 2019 22:42:31 +0300 (MSK)
Date:   Fri, 22 Mar 2019 22:42:31 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 06/11] X.509: parse public key parameters from x509
 for akcipher
Message-ID: <20190322194231.ih6itzctanyheoi4@altlinux.org>
Mail-Followup-To: David Howells <dhowells@redhat.com>,
        keyrings@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190301175918.29694-1-vt@altlinux.org>
 <20190301175918.29694-7-vt@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20190301175918.29694-7-vt@altlinux.org>
User-Agent: NeoMutt/20171215-106-ac61c7
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

David,

Can you please Ack this patch or suggest modifications as it includes
changes to ASYMMETRIC KEYS tree?

Thanks,

On Fri, Mar 01, 2019 at 08:59:13PM +0300, Vitaly Chikunov wrote:
> Some public key algorithms (like EC-DSA) keep in parameters field
> important data such as digest and curve OIDs (possibly more for
> different EC-DSA variants). Thus, just setting a public key (as
> for RSA) is not enough.
> 
> Append parameters into the key stream for akcipher_set_{pub,priv}_key.
> Appended data is: (u32) algo OID, (u32) parameters length, parameters
> data.
> 
> This does not affect current akcipher API nor RSA ciphers (they could
> ignore it). Idea of appending parameters to the key stream is by Herbert
> Xu.
> 
> Cc: David Howells <dhowells@redhat.com>
> Cc: keyrings@vger.kernel.org
> Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
> ---
>  crypto/asymmetric_keys/asym_tpm.c         | 43 ++++++++++++++++--
>  crypto/asymmetric_keys/public_key.c       | 72 ++++++++++++++++++++++++-------
>  crypto/asymmetric_keys/x509.asn1          |  2 +-
>  crypto/asymmetric_keys/x509_cert_parser.c | 31 +++++++++++++
>  crypto/testmgr.c                          | 24 +++++++++--
>  crypto/testmgr.h                          |  5 +++
>  include/crypto/akcipher.h                 | 18 ++++----
>  include/crypto/public_key.h               |  4 ++
>  8 files changed, 168 insertions(+), 31 deletions(-)
> 
> diff --git a/crypto/asymmetric_keys/asym_tpm.c b/crypto/asymmetric_keys/asym_tpm.c
> index 402fc34ca044..d95d7ec50e5a 100644
> --- a/crypto/asymmetric_keys/asym_tpm.c
> +++ b/crypto/asymmetric_keys/asym_tpm.c
> @@ -395,6 +395,12 @@ static int determine_akcipher(const char *encoding, const char *hash_algo,
>  	return -ENOPKG;
>  }
>  
> +static u8 *tpm_pack_u32(u8 *dst, u32 val)
> +{
> +	memcpy(dst, &val, sizeof(val));
> +	return dst + sizeof(val);
> +}
> +
>  /*
>   * Query information about a key.
>   */
> @@ -407,6 +413,7 @@ static int tpm_key_query(const struct kernel_pkey_params *params,
>  	struct crypto_akcipher *tfm;
>  	uint8_t der_pub_key[PUB_KEY_BUF_SIZE];
>  	uint32_t der_pub_key_len;
> +	u8 *pkey, *ptr;
>  	int len;
>  
>  	/* TPM only works on private keys, public keys still done in software */
> @@ -421,7 +428,16 @@ static int tpm_key_query(const struct kernel_pkey_params *params,
>  	der_pub_key_len = derive_pub_key(tk->pub_key, tk->pub_key_len,
>  					 der_pub_key);
>  
> -	ret = crypto_akcipher_set_pub_key(tfm, der_pub_key, der_pub_key_len);
> +	pkey = kmalloc(der_pub_key_len + sizeof(u32) * 2, GFP_KERNEL);
> +	if (!pkey)
> +		goto error_free_tfm;
> +	memcpy(pkey, der_pub_key, der_pub_key_len);
> +	ptr = pkey + der_pub_key_len;
> +	/* Set dummy parameters to satisfy set_pub_key ABI. */
> +	ptr = tpm_pack_u32(ptr, 0); /* algo */
> +	ptr = tpm_pack_u32(ptr, 0); /* parameter length */
> +
> +	ret = crypto_akcipher_set_pub_key(tfm, pkey, der_pub_key_len);
>  	if (ret < 0)
>  		goto error_free_tfm;
>  
> @@ -440,6 +456,7 @@ static int tpm_key_query(const struct kernel_pkey_params *params,
>  
>  	ret = 0;
>  error_free_tfm:
> +	kfree(pkey);
>  	crypto_free_akcipher(tfm);
>  	pr_devel("<==%s() = %d\n", __func__, ret);
>  	return ret;
> @@ -460,6 +477,7 @@ static int tpm_key_encrypt(struct tpm_key *tk,
>  	struct scatterlist in_sg, out_sg;
>  	uint8_t der_pub_key[PUB_KEY_BUF_SIZE];
>  	uint32_t der_pub_key_len;
> +	u8 *pkey, *ptr;
>  	int ret;
>  
>  	pr_devel("==>%s()\n", __func__);
> @@ -475,7 +493,15 @@ static int tpm_key_encrypt(struct tpm_key *tk,
>  	der_pub_key_len = derive_pub_key(tk->pub_key, tk->pub_key_len,
>  					 der_pub_key);
>  
> -	ret = crypto_akcipher_set_pub_key(tfm, der_pub_key, der_pub_key_len);
> +	pkey = kmalloc(der_pub_key_len + sizeof(u32) * 2, GFP_KERNEL);
> +	if (!pkey)
> +		goto error_free_tfm;
> +	memcpy(pkey, der_pub_key, der_pub_key_len);
> +	ptr = pkey + der_pub_key_len;
> +	ptr = tpm_pack_u32(ptr, 0); /* algo */
> +	ptr = tpm_pack_u32(ptr, 0); /* parameter length */
> +
> +	ret = crypto_akcipher_set_pub_key(tfm, pkey, der_pub_key_len);
>  	if (ret < 0)
>  		goto error_free_tfm;
>  
> @@ -500,6 +526,7 @@ static int tpm_key_encrypt(struct tpm_key *tk,
>  
>  	akcipher_request_free(req);
>  error_free_tfm:
> +	kfree(pkey);
>  	crypto_free_akcipher(tfm);
>  	pr_devel("<==%s() = %d\n", __func__, ret);
>  	return ret;
> @@ -748,6 +775,7 @@ static int tpm_key_verify_signature(const struct key *key,
>  	char alg_name[CRYPTO_MAX_ALG_NAME];
>  	uint8_t der_pub_key[PUB_KEY_BUF_SIZE];
>  	uint32_t der_pub_key_len;
> +	u8 *pkey, *ptr;
>  	int ret;
>  
>  	pr_devel("==>%s()\n", __func__);
> @@ -770,7 +798,15 @@ static int tpm_key_verify_signature(const struct key *key,
>  	der_pub_key_len = derive_pub_key(tk->pub_key, tk->pub_key_len,
>  					 der_pub_key);
>  
> -	ret = crypto_akcipher_set_pub_key(tfm, der_pub_key, der_pub_key_len);
> +	pkey = kmalloc(der_pub_key_len + sizeof(u32) * 2, GFP_KERNEL);
> +	if (!pkey)
> +		goto error_free_tfm;
> +	memcpy(pkey, der_pub_key, der_pub_key_len);
> +	ptr = pkey + der_pub_key_len;
> +	ptr = tpm_pack_u32(ptr, 0); /* algo */
> +	ptr = tpm_pack_u32(ptr, 0); /* parameter length */
> +
> +	ret = crypto_akcipher_set_pub_key(tfm, pkey, der_pub_key_len);
>  	if (ret < 0)
>  		goto error_free_tfm;
>  
> @@ -792,6 +828,7 @@ static int tpm_key_verify_signature(const struct key *key,
>  
>  	akcipher_request_free(req);
>  error_free_tfm:
> +	kfree(pkey);
>  	crypto_free_akcipher(tfm);
>  	pr_devel("<==%s() = %d\n", __func__, ret);
>  	if (WARN_ON_ONCE(ret > 0))
> diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
> index 4dcfe281b898..0564951f8760 100644
> --- a/crypto/asymmetric_keys/public_key.c
> +++ b/crypto/asymmetric_keys/public_key.c
> @@ -45,6 +45,7 @@ void public_key_free(struct public_key *key)
>  {
>  	if (key) {
>  		kfree(key->key);
> +		kfree(key->params);
>  		kfree(key);
>  	}
>  }
> @@ -94,6 +95,12 @@ int software_key_determine_akcipher(const char *encoding,
>  	return -ENOPKG;
>  }
>  
> +static u8 *pkey_pack_u32(u8 *dst, u32 val)
> +{
> +	memcpy(dst, &val, sizeof(val));
> +	return dst + sizeof(val);
> +}
> +
>  /*
>   * Query information about a key.
>   */
> @@ -103,6 +110,7 @@ static int software_key_query(const struct kernel_pkey_params *params,
>  	struct crypto_akcipher *tfm;
>  	struct public_key *pkey = params->key->payload.data[asym_crypto];
>  	char alg_name[CRYPTO_MAX_ALG_NAME];
> +	u8 *key, *ptr;
>  	int ret, len;
>  
>  	ret = software_key_determine_akcipher(params->encoding,
> @@ -115,14 +123,22 @@ static int software_key_query(const struct kernel_pkey_params *params,
>  	if (IS_ERR(tfm))
>  		return PTR_ERR(tfm);
>  
> +	key = kmalloc(pkey->keylen + sizeof(u32) * 2 + pkey->paramlen,
> +		      GFP_KERNEL);
> +	if (!key)
> +		goto error_free_tfm;
> +	memcpy(key, pkey->key, pkey->keylen);
> +	ptr = key + pkey->keylen;
> +	ptr = pkey_pack_u32(ptr, pkey->algo);
> +	ptr = pkey_pack_u32(ptr, pkey->paramlen);
> +	memcpy(ptr, pkey->params, pkey->paramlen);
> +
>  	if (pkey->key_is_private)
> -		ret = crypto_akcipher_set_priv_key(tfm,
> -						   pkey->key, pkey->keylen);
> +		ret = crypto_akcipher_set_priv_key(tfm, key, pkey->keylen);
>  	else
> -		ret = crypto_akcipher_set_pub_key(tfm,
> -						  pkey->key, pkey->keylen);
> +		ret = crypto_akcipher_set_pub_key(tfm, key, pkey->keylen);
>  	if (ret < 0)
> -		goto error_free_tfm;
> +		goto error_free_key;
>  
>  	len = crypto_akcipher_maxsize(tfm);
>  	info->key_size = len * 8;
> @@ -143,6 +159,8 @@ static int software_key_query(const struct kernel_pkey_params *params,
>  	}
>  	ret = 0;
>  
> +error_free_key:
> +	kfree(key);
>  error_free_tfm:
>  	crypto_free_akcipher(tfm);
>  	pr_devel("<==%s() = %d\n", __func__, ret);
> @@ -161,6 +179,7 @@ static int software_key_eds_op(struct kernel_pkey_params *params,
>  	struct crypto_wait cwait;
>  	struct scatterlist in_sg, out_sg;
>  	char alg_name[CRYPTO_MAX_ALG_NAME];
> +	char *key, *ptr;
>  	int ret;
>  
>  	pr_devel("==>%s()\n", __func__);
> @@ -179,14 +198,23 @@ static int software_key_eds_op(struct kernel_pkey_params *params,
>  	if (!req)
>  		goto error_free_tfm;
>  
> +	key = kmalloc(pkey->keylen + sizeof(u32) * 2 + pkey->paramlen,
> +		      GFP_KERNEL);
> +	if (!key)
> +		goto error_free_req;
> +
> +	memcpy(key, pkey->key, pkey->keylen);
> +	ptr = key + pkey->keylen;
> +	ptr = pkey_pack_u32(ptr, pkey->algo);
> +	ptr = pkey_pack_u32(ptr, pkey->paramlen);
> +	memcpy(ptr, pkey->params, pkey->paramlen);
> +
>  	if (pkey->key_is_private)
> -		ret = crypto_akcipher_set_priv_key(tfm,
> -						   pkey->key, pkey->keylen);
> +		ret = crypto_akcipher_set_priv_key(tfm, key, pkey->keylen);
>  	else
> -		ret = crypto_akcipher_set_pub_key(tfm,
> -						  pkey->key, pkey->keylen);
> +		ret = crypto_akcipher_set_pub_key(tfm, key, pkey->keylen);
>  	if (ret)
> -		goto error_free_req;
> +		goto error_free_key;
>  
>  	sg_init_one(&in_sg, in, params->in_len);
>  	sg_init_one(&out_sg, out, params->out_len);
> @@ -216,6 +244,8 @@ static int software_key_eds_op(struct kernel_pkey_params *params,
>  	if (ret == 0)
>  		ret = req->dst_len;
>  
> +error_free_key:
> +	kfree(key);
>  error_free_req:
>  	akcipher_request_free(req);
>  error_free_tfm:
> @@ -235,6 +265,7 @@ int public_key_verify_signature(const struct public_key *pkey,
>  	struct akcipher_request *req;
>  	struct scatterlist src_sg[2];
>  	char alg_name[CRYPTO_MAX_ALG_NAME];
> +	char *key, *ptr;
>  	int ret;
>  
>  	pr_devel("==>%s()\n", __func__);
> @@ -258,14 +289,23 @@ int public_key_verify_signature(const struct public_key *pkey,
>  	if (!req)
>  		goto error_free_tfm;
>  
> +	key = kmalloc(pkey->keylen + sizeof(u32) * 2 + pkey->paramlen,
> +		      GFP_KERNEL);
> +	if (!key)
> +		goto error_free_req;
> +
> +	memcpy(key, pkey->key, pkey->keylen);
> +	ptr = key + pkey->keylen;
> +	ptr = pkey_pack_u32(ptr, pkey->algo);
> +	ptr = pkey_pack_u32(ptr, pkey->paramlen);
> +	memcpy(ptr, pkey->params, pkey->paramlen);
> +
>  	if (pkey->key_is_private)
> -		ret = crypto_akcipher_set_priv_key(tfm,
> -						   pkey->key, pkey->keylen);
> +		ret = crypto_akcipher_set_priv_key(tfm, key, pkey->keylen);
>  	else
> -		ret = crypto_akcipher_set_pub_key(tfm,
> -						  pkey->key, pkey->keylen);
> +		ret = crypto_akcipher_set_pub_key(tfm, key, pkey->keylen);
>  	if (ret)
> -		goto error_free_req;
> +		goto error_free_key;
>  
>  	sg_init_table(src_sg, 2);
>  	sg_set_buf(&src_sg[0], sig->s, sig->s_size);
> @@ -278,6 +318,8 @@ int public_key_verify_signature(const struct public_key *pkey,
>  				      crypto_req_done, &cwait);
>  	ret = crypto_wait_req(crypto_akcipher_verify(req), &cwait);
>  
> +error_free_key:
> +	kfree(key);
>  error_free_req:
>  	akcipher_request_free(req);
>  error_free_tfm:
> diff --git a/crypto/asymmetric_keys/x509.asn1 b/crypto/asymmetric_keys/x509.asn1
> index aae0cde414e2..5c9f4e4a5231 100644
> --- a/crypto/asymmetric_keys/x509.asn1
> +++ b/crypto/asymmetric_keys/x509.asn1
> @@ -22,7 +22,7 @@ CertificateSerialNumber ::= INTEGER
>  
>  AlgorithmIdentifier ::= SEQUENCE {
>  	algorithm		OBJECT IDENTIFIER ({ x509_note_OID }),
> -	parameters		ANY OPTIONAL
> +	parameters		ANY OPTIONAL ({ x509_note_params })
>  }
>  
>  Name ::= SEQUENCE OF RelativeDistinguishedName
> diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
> index 991f4d735a4e..b2cdf2db1987 100644
> --- a/crypto/asymmetric_keys/x509_cert_parser.c
> +++ b/crypto/asymmetric_keys/x509_cert_parser.c
> @@ -26,6 +26,9 @@ struct x509_parse_context {
>  	const void	*cert_start;		/* Start of cert content */
>  	const void	*key;			/* Key data */
>  	size_t		key_size;		/* Size of key data */
> +	const void	*params;		/* Key parameters */
> +	size_t		params_size;		/* Size of key parameters */
> +	enum OID	key_algo;		/* Public key algorithm */
>  	enum OID	last_oid;		/* Last OID encountered */
>  	enum OID	algo_oid;		/* Algorithm OID */
>  	unsigned char	nr_mpi;			/* Number of MPIs stored */
> @@ -109,6 +112,13 @@ struct x509_certificate *x509_cert_parse(const void *data, size_t datalen)
>  
>  	cert->pub->keylen = ctx->key_size;
>  
> +	cert->pub->params = kmemdup(ctx->params, ctx->params_size, GFP_KERNEL);
> +	if (!cert->pub->params)
> +		goto error_decode;
> +
> +	cert->pub->paramlen = ctx->params_size;
> +	cert->pub->algo = ctx->key_algo;
> +
>  	/* Grab the signature bits */
>  	ret = x509_get_sig_params(cert);
>  	if (ret < 0)
> @@ -401,6 +411,27 @@ int x509_note_subject(void *context, size_t hdrlen,
>  }
>  
>  /*
> + * Extract the parameters for the public key
> + */
> +int x509_note_params(void *context, size_t hdrlen,
> +		     unsigned char tag,
> +		     const void *value, size_t vlen)
> +{
> +	struct x509_parse_context *ctx = context;
> +
> +	/*
> +	 * AlgorithmIdentifier is used three times in the x509, we should skip
> +	 * first and ignore third, using second one which is after subject and
> +	 * before subjectPublicKey.
> +	 */
> +	if (!ctx->cert->raw_subject || ctx->key)
> +		return 0;
> +	ctx->params = value - hdrlen;
> +	ctx->params_size = vlen + hdrlen;
> +	return 0;
> +}
> +
> +/*
>   * Extract the data for the public key algorithm
>   */
>  int x509_extract_key_data(void *context, size_t hdrlen,
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index 443d5b6f1045..50396b3a2a47 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -2493,6 +2493,12 @@ static int alg_test_kpp(const struct alg_test_desc *desc, const char *driver,
>  	return err;
>  }
>  
> +static u8 *test_pack_u32(u8 *dst, u32 val)
> +{
> +	memcpy(dst, &val, sizeof(val));
> +	return dst + sizeof(val);
> +}
> +
>  static int test_akcipher_one(struct crypto_akcipher *tfm,
>  			     const struct akcipher_testvec *vecs)
>  {
> @@ -2507,6 +2513,7 @@ static int test_akcipher_one(struct crypto_akcipher *tfm,
>  	const char *m, *c;
>  	unsigned int m_size, c_size;
>  	const char *op;
> +	u8 *key, *ptr;
>  
>  	if (testmgr_alloc_buf(xbuf))
>  		return err;
> @@ -2517,12 +2524,20 @@ static int test_akcipher_one(struct crypto_akcipher *tfm,
>  
>  	crypto_init_wait(&wait);
>  
> +	key = kmalloc(vecs->key_len + sizeof(u32) * 2 + vecs->param_len,
> +		      GFP_KERNEL);
> +	if (!key)
> +		goto free_xbuf;
> +	memcpy(key, vecs->key, vecs->key_len);
> +	ptr = key + vecs->key_len;
> +	ptr = test_pack_u32(ptr, vecs->algo);
> +	ptr = test_pack_u32(ptr, vecs->param_len);
> +	memcpy(ptr, vecs->params, vecs->param_len);
> +
>  	if (vecs->public_key_vec)
> -		err = crypto_akcipher_set_pub_key(tfm, vecs->key,
> -						  vecs->key_len);
> +		err = crypto_akcipher_set_pub_key(tfm, key, vecs->key_len);
>  	else
> -		err = crypto_akcipher_set_priv_key(tfm, vecs->key,
> -						   vecs->key_len);
> +		err = crypto_akcipher_set_priv_key(tfm, key, vecs->key_len);
>  	if (err)
>  		goto free_req;
>  
> @@ -2652,6 +2667,7 @@ static int test_akcipher_one(struct crypto_akcipher *tfm,
>  	kfree(outbuf_enc);
>  free_req:
>  	akcipher_request_free(req);
> +	kfree(key);
>  free_xbuf:
>  	testmgr_free_buf(xbuf);
>  	return err;
> diff --git a/crypto/testmgr.h b/crypto/testmgr.h
> index f267633cf13a..75d8f8c3e203 100644
> --- a/crypto/testmgr.h
> +++ b/crypto/testmgr.h
> @@ -25,6 +25,8 @@
>  #ifndef _CRYPTO_TESTMGR_H
>  #define _CRYPTO_TESTMGR_H
>  
> +#include <linux/oid_registry.h>
> +
>  #define MAX_IVLEN		32
>  
>  /*
> @@ -135,13 +137,16 @@ struct drbg_testvec {
>  
>  struct akcipher_testvec {
>  	const unsigned char *key;
> +	const unsigned char *params;
>  	const unsigned char *m;
>  	const unsigned char *c;
>  	unsigned int key_len;
> +	unsigned int param_len;
>  	unsigned int m_size;
>  	unsigned int c_size;
>  	bool public_key_vec;
>  	bool siggen_sigver_test;
> +	enum OID algo;
>  };
>  
>  struct kpp_testvec {
> diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
> index 28ffa9ef03a9..4ecbedddd9a1 100644
> --- a/include/crypto/akcipher.h
> +++ b/include/crypto/akcipher.h
> @@ -74,10 +74,10 @@ struct crypto_akcipher {
>   *		operation
>   * @set_pub_key: Function invokes the algorithm specific set public key
>   *		function, which knows how to decode and interpret
> - *		the BER encoded public key
> + *		the BER encoded public key and parameters
>   * @set_priv_key: Function invokes the algorithm specific set private key
>   *		function, which knows how to decode and interpret
> - *		the BER encoded private key
> + *		the BER encoded private key and parameters
>   * @max_size:	Function returns dest buffer size required for a given key.
>   * @init:	Initialize the cryptographic transformation object.
>   *		This function is used to initialize the cryptographic
> @@ -388,11 +388,12 @@ static inline int crypto_akcipher_verify(struct akcipher_request *req)
>   * crypto_akcipher_set_pub_key() - Invoke set public key operation
>   *
>   * Function invokes the algorithm specific set key function, which knows
> - * how to decode and interpret the encoded key
> + * how to decode and interpret the encoded key and parameters
>   *
>   * @tfm:	tfm handle
> - * @key:	BER encoded public key
> - * @keylen:	length of the key
> + * @key:	BER encoded public key, algo OID, paramlen, BER encoded
> + *		parameters
> + * @keylen:	length of the key (not including other data)
>   *
>   * Return: zero on success; error code in case of error
>   */
> @@ -409,11 +410,12 @@ static inline int crypto_akcipher_set_pub_key(struct crypto_akcipher *tfm,
>   * crypto_akcipher_set_priv_key() - Invoke set private key operation
>   *
>   * Function invokes the algorithm specific set key function, which knows
> - * how to decode and interpret the encoded key
> + * how to decode and interpret the encoded keya and parameters
>   *
>   * @tfm:	tfm handle
> - * @key:	BER encoded private key
> - * @keylen:	length of the key
> + * @key:	BER encoded private key, algo OID, paramlen, BER encoded
> + *		parameters
> + * @keylen:	length of the key (not including other data)
>   *
>   * Return: zero on success; error code in case of error
>   */
> diff --git a/include/crypto/public_key.h b/include/crypto/public_key.h
> index be626eac9113..712fe1214b5f 100644
> --- a/include/crypto/public_key.h
> +++ b/include/crypto/public_key.h
> @@ -15,6 +15,7 @@
>  #define _LINUX_PUBLIC_KEY_H
>  
>  #include <linux/keyctl.h>
> +#include <linux/oid_registry.h>
>  
>  /*
>   * Cryptographic data for the public-key subtype of the asymmetric key type.
> @@ -25,6 +26,9 @@
>  struct public_key {
>  	void *key;
>  	u32 keylen;
> +	enum OID algo;
> +	void *params;
> +	u32 paramlen;
>  	bool key_is_private;
>  	const char *id_type;
>  	const char *pkey_algo;
> -- 
> 2.11.0
