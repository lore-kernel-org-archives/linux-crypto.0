From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: rsa - return raw integers for the ASN.1 parser
Date: Tue, 31 May 2016 15:11:06 +0800
Message-ID: <20160531071106.GA14223@gondor.apana.org.au>
References: <1463065233-13452-1-git-send-email-tudor-dan.ambarus@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:56917 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313AbcEaHiC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 May 2016 03:38:02 -0400
Content-Disposition: inline
In-Reply-To: <1463065233-13452-1-git-send-email-tudor-dan.ambarus@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 12, 2016 at 06:00:33PM +0300, Tudor Ambarus wrote:
>
>  int rsa_get_n(void *context, size_t hdrlen, unsigned char tag,
>  	      const void *value, size_t vlen)
>  {
>  	struct rsa_key *key = context;
> +	const char *ptr = value;
> +	int ret;
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
> +	key->n = kzalloc(vlen, key->flags);
> +	if (!key->n)
> +		return -ENOMEM;
> +

The helper shouldn't be copying it at all.

Just return the raw key as is and then the caller can copy it
or MPI parse it, etc.

The helper should just do the parsing and nothing else.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
