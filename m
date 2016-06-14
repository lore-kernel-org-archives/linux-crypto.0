From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v5] crypto: rsa - return raw integers for the ASN.1 parser
Date: Tue, 14 Jun 2016 15:20:06 +0200
Message-ID: <2066344.ohg9RiuaKP@tauon.atsec.com>
References: <1465910098-16349-1-git-send-email-tudor-dan.ambarus@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:36458 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863AbcFNNUJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jun 2016 09:20:09 -0400
In-Reply-To: <1465910098-16349-1-git-send-email-tudor-dan.ambarus@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 14. Juni 2016, 16:14:58 schrieb Tudor Ambarus:

Hi Tudor,

>  static int rsa_set_priv_key(struct crypto_akcipher *tfm, const void *key,
>  			    unsigned int keylen)
>  {
> -	struct rsa_key *pkey = akcipher_tfm_ctx(tfm);
> +	struct rsa_mpi_key *mpi_key = akcipher_tfm_ctx(tfm);
> +	struct rsa_key raw_key = {0};
>  	int ret;
> 
> -	ret = rsa_parse_priv_key(pkey, key, keylen);
> +	/* Free the old MPI key if any */
> +	rsa_free_mpi_key(mpi_key);
> +
> +	ret = rsa_parse_priv_key(&raw_key, key, keylen);
>  	if (ret)
>  		return ret;
> 
> -	if (rsa_check_key_length(mpi_get_size(pkey->n) << 3)) {
> -		rsa_free_key(pkey);
> -		ret = -EINVAL;
> +	mpi_key->d = mpi_read_raw_data(raw_key.d, raw_key.d_sz);
> +	if (!mpi_key->d)
> +		goto err;
> +
> +	mpi_key->e = mpi_read_raw_data(raw_key.e, raw_key.e_sz);
> +	if (!mpi_key->e)
> +		goto err;
> +
> +	mpi_key->n = mpi_read_raw_data(raw_key.n, raw_key.n_sz);
> +	if (!mpi_key->n)
> +		goto err;
> +
> +	if (rsa_check_key_length(mpi_get_size(mpi_key->n) << 3)) {
> +		rsa_free_mpi_key(mpi_key);
> +		return -EINVAL;
>  	}
> -	return ret;
> +
> +	return 0;
> +
> +err:
> +	rsa_free_mpi_key(mpi_key);
> +	return -ENOMEM;
>  }

memzero_explicit(raw_key) should be added here in success and failure code 
paths.

Ciao
Stephan
