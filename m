From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH 1/1] Added CRYPTO_ALG_KERN_DRIVER_ONLY flag (2nd
 attempt)
Date: Tue, 13 Dec 2011 10:10:17 -0600
Message-ID: <20111213101017.aceb0df9285bd5701d61df39@freescale.com>
References: <4EE712A0.3090601@gnutls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:42230 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752676Ab1LMQLg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Dec 2011 11:11:36 -0500
In-Reply-To: <4EE712A0.3090601@gnutls.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 13 Dec 2011 09:53:52 +0100
Nikos Mavrogiannopoulos <nmav@gnutls.org> wrote:

Niko,

caam is ok.  For talitos, either this way:

> diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
> index 230509e..5620788 100644
> --- a/drivers/crypto/talitos.c
> +++ b/drivers/crypto/talitos.c
> @@ -2007,7 +2007,9 @@ static struct talitos_alg_template driver_algs[] = {
>  			.cra_name = "authenc(hmac(sha1),cbc(aes))",
>  			.cra_driver_name = "authenc-hmac-sha1-cbc-aes-talitos",
>  			.cra_blocksize = AES_BLOCK_SIZE,
> -			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
> +			.cra_flags = CRYPTO_ALG_TYPE_AEAD |
> +					CRYPTO_ALG_ASYNC |
> +					CRYPTO_ALG_KERN_DRIVER_ONLY,
>  			.cra_type = &crypto_aead_type,
>  			.cra_aead = {
>  				.setkey = aead_setkey,
> @@ -2033,7 +2035,9 @@ static struct talitos_alg_template driver_algs[] = {
>  			.cra_name = "authenc(hmac(sha1),cbc(des3_ede))",
>  			.cra_driver_name = "authenc-hmac-sha1-cbc-3des-talitos",
>  			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
> -			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
> +			.cra_flags = CRYPTO_ALG_TYPE_AEAD |
> +					CRYPTO_ALG_ASYNC |
> +					CRYPTO_ALG_KERN_DRIVER_ONLY,
>  			.cra_type = &crypto_aead_type,
>  			.cra_aead = {
>  				.setkey = aead_setkey,
> @@ -2060,7 +2064,9 @@ static struct talitos_alg_template driver_algs[] = {
>  			.cra_name = "authenc(hmac(sha256),cbc(aes))",
>  			.cra_driver_name = "authenc-hmac-sha256-cbc-aes-talitos",
>  			.cra_blocksize = AES_BLOCK_SIZE,
> -			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
> +			.cra_flags = CRYPTO_ALG_TYPE_AEAD |
> +					CRYPTO_ALG_ASYNC |
> +					CRYPTO_ALG_KERN_DRIVER_ONLY,
>  			.cra_type = &crypto_aead_type,
>  			.cra_aead = {
>  				.setkey = aead_setkey,
> @@ -2086,7 +2092,9 @@ static struct talitos_alg_template driver_algs[] = {
>  			.cra_name = "authenc(hmac(sha256),cbc(des3_ede))",
>  			.cra_driver_name = "authenc-hmac-sha256-cbc-3des-talitos",
>  			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
> -			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
> +			.cra_flags = CRYPTO_ALG_TYPE_AEAD |
> +					CRYPTO_ALG_ASYNC |
> +					CRYPTO_ALG_KERN_DRIVER_ONLY,
>  			.cra_type = &crypto_aead_type,
>  			.cra_aead = {
>  				.setkey = aead_setkey,
> @@ -2113,7 +2121,9 @@ static struct talitos_alg_template driver_algs[] = {
>  			.cra_name = "authenc(hmac(md5),cbc(aes))",
>  			.cra_driver_name = "authenc-hmac-md5-cbc-aes-talitos",
>  			.cra_blocksize = AES_BLOCK_SIZE,
> -			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
> +			.cra_flags = CRYPTO_ALG_TYPE_AEAD |
> +					CRYPTO_ALG_ASYNC |
> +					CRYPTO_ALG_KERN_DRIVER_ONLY,
>  			.cra_type = &crypto_aead_type,
>  			.cra_aead = {
>  				.setkey = aead_setkey,
> @@ -2139,7 +2149,9 @@ static struct talitos_alg_template driver_algs[] = {
>  			.cra_name = "authenc(hmac(md5),cbc(des3_ede))",
>  			.cra_driver_name = "authenc-hmac-md5-cbc-3des-talitos",
>  			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
> -			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
> +			.cra_flags = CRYPTO_ALG_TYPE_AEAD |
> +					CRYPTO_ALG_ASYNC |
> +					CRYPTO_ALG_KERN_DRIVER_ONLY,
>  			.cra_type = &crypto_aead_type,
>  			.cra_aead = {
>  				.setkey = aead_setkey,
> @@ -2168,7 +2180,8 @@ static struct talitos_alg_template driver_algs[] = {
>  			.cra_driver_name = "cbc-aes-talitos",
>  			.cra_blocksize = AES_BLOCK_SIZE,
>  			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
> -                                     CRYPTO_ALG_ASYNC,
> +				     CRYPTO_ALG_ASYNC |
> +				     CRYPTO_ALG_KERN_DRIVER_ONLY,
>  			.cra_type = &crypto_ablkcipher_type,
>  			.cra_ablkcipher = {
>  				.setkey = ablkcipher_setkey,
> @@ -2190,7 +2203,8 @@ static struct talitos_alg_template driver_algs[] = {
>  			.cra_driver_name = "cbc-3des-talitos",
>  			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
>  			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
> -                                     CRYPTO_ALG_ASYNC,
> +				     CRYPTO_ALG_ASYNC |
> +				     CRYPTO_ALG_KERN_DRIVER_ONLY,
>  			.cra_type = &crypto_ablkcipher_type,
>  			.cra_ablkcipher = {
>  				.setkey = ablkcipher_setkey,
> @@ -2221,7 +2235,8 @@ static struct talitos_alg_template driver_algs[] = {
>  				.cra_driver_name = "md5-talitos",
>  				.cra_blocksize = MD5_BLOCK_SIZE,
>  				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
> -					     CRYPTO_ALG_ASYNC,
> +					     CRYPTO_ALG_ASYNC |
> +					     CRYPTO_ALG_KERN_DRIVER_ONLY,
>  				.cra_type = &crypto_ahash_type
>  			}
>  		},
> @@ -2242,7 +2257,8 @@ static struct talitos_alg_template driver_algs[] = {
>  				.cra_driver_name = "sha1-talitos",
>  				.cra_blocksize = SHA1_BLOCK_SIZE,
>  				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
> -					     CRYPTO_ALG_ASYNC,
> +					     CRYPTO_ALG_ASYNC |
> +					     CRYPTO_ALG_KERN_DRIVER_ONLY,
>  				.cra_type = &crypto_ahash_type
>  			}
>  		},
> @@ -2263,7 +2279,8 @@ static struct talitos_alg_template driver_algs[] = {
>  				.cra_driver_name = "sha224-talitos",
>  				.cra_blocksize = SHA224_BLOCK_SIZE,
>  				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
> -					     CRYPTO_ALG_ASYNC,
> +					     CRYPTO_ALG_ASYNC |
> +					     CRYPTO_ALG_KERN_DRIVER_ONLY,
>  				.cra_type = &crypto_ahash_type
>  			}
>  		},
> @@ -2284,7 +2301,8 @@ static struct talitos_alg_template driver_algs[] = {
>  				.cra_driver_name = "sha256-talitos",
>  				.cra_blocksize = SHA256_BLOCK_SIZE,
>  				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
> -					     CRYPTO_ALG_ASYNC,
> +					     CRYPTO_ALG_ASYNC |
> +					     CRYPTO_ALG_KERN_DRIVER_ONLY,
>  				.cra_type = &crypto_ahash_type
>  			}
>  		},
> @@ -2305,7 +2323,8 @@ static struct talitos_alg_template driver_algs[] = {
>  				.cra_driver_name = "sha384-talitos",
>  				.cra_blocksize = SHA384_BLOCK_SIZE,
>  				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
> -					     CRYPTO_ALG_ASYNC,
> +					     CRYPTO_ALG_ASYNC |
> +					     CRYPTO_ALG_KERN_DRIVER_ONLY,
>  				.cra_type = &crypto_ahash_type
>  			}
>  		},
> @@ -2326,7 +2345,8 @@ static struct talitos_alg_template driver_algs[] = {
>  				.cra_driver_name = "sha512-talitos",
>  				.cra_blocksize = SHA512_BLOCK_SIZE,
>  				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
> -					     CRYPTO_ALG_ASYNC,
> +					     CRYPTO_ALG_ASYNC |
> +					     CRYPTO_ALG_KERN_DRIVER_ONLY,
>  				.cra_type = &crypto_ahash_type
>  			}
>  		},

or this way:

> @@ -2647,6 +2667,7 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
>  	alg->cra_priority = TALITOS_CRA_PRIORITY;
>  	alg->cra_alignmask = 0;
>  	alg->cra_ctxsize = sizeof(struct talitos_ctx);
> +	alg->cra_flags |= CRYPTO_ALG_KERN_DRIVER_ONLY;
>  
>  	t_alg->dev = dev;

but not both.

My preference is the latter.  If you want to do it the former way,
rebase on Herbert's latest cryptodev tree, because the new algorithm
implementations are missing from this patch.

Kim
