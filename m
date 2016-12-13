From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH] orinoco: Use shash instead of ahash for MIC calculations
Date: Mon, 12 Dec 2016 23:54:25 -0800
Message-ID: <20161213075425.GA5948@zzz>
References: <8c273c9c41f51b34bb3115086f1d776895580637.1481575835.git.luto@kernel.org>
 <8818c45b9ec6a04d85fabf9bb437cf119fd23659.1481575835.git.luto@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Stephan Mueller <smueller@chronox.de>
To: Andy Lutomirski <luto@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8818c45b9ec6a04d85fabf9bb437cf119fd23659.1481575835.git.luto@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Dec 12, 2016 at 12:55:55PM -0800, Andy Lutomirski wrote:
> +int orinoco_mic(struct crypto_shash *tfm_michael, u8 *key,
>  		u8 *da, u8 *sa, u8 priority,
>  		u8 *data, size_t data_len, u8 *mic)
>  {
> -	AHASH_REQUEST_ON_STACK(req, tfm_michael);
> -	struct scatterlist sg[2];
> +	SHASH_DESC_ON_STACK(desc, tfm_michael);
>  	u8 hdr[ETH_HLEN + 2]; /* size of header + padding */
>  	int err;
>  
> @@ -67,18 +66,27 @@ int orinoco_mic(struct crypto_ahash *tfm_michael, u8 *key,
>  	hdr[ETH_ALEN * 2 + 2] = 0;
>  	hdr[ETH_ALEN * 2 + 3] = 0;
>  
> -	/* Use scatter gather to MIC header and data in one go */
> -	sg_init_table(sg, 2);
> -	sg_set_buf(&sg[0], hdr, sizeof(hdr));
> -	sg_set_buf(&sg[1], data, data_len);
> +	desc->tfm = tfm_michael;
> +	desc->flags = 0;
>  
> -	if (crypto_ahash_setkey(tfm_michael, key, MIC_KEYLEN))
> -		return -1;
> +	err = crypto_shash_setkey(tfm_michael, key, MIC_KEYLEN);
> +	if (err)
> +		return err;
> +
> +	err = crypto_shash_init(desc);
> +	if (err)
> +		return err;
> +
> +	err = crypto_shash_update(desc, hdr, sizeof(hdr));
> +	if (err)
> +		return err;
> +
> +	err = crypto_shash_update(desc, data, data_len);
> +	if (err)
> +		return err;
> +
> +	err = crypto_shash_final(desc, mic);
> +	shash_desc_zero(desc);
>  
> -	ahash_request_set_tfm(req, tfm_michael);
> -	ahash_request_set_callback(req, 0, NULL, NULL);
> -	ahash_request_set_crypt(req, sg, mic, data_len + sizeof(hdr));
> -	err = crypto_ahash_digest(req);
> -	ahash_request_zero(req);
>  	return err;

It's probably a good idea to always do shash_desc_zero(), even when something
above it fails.  Otherwise this looks fine.  Thanks for sending these patches!

Eric
