From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4 5/5] crypto: AES CBC multi-buffer glue code
Date: Wed, 9 Dec 2015 10:52:42 +0800
Message-ID: <20151209025242.GA24861@gondor.apana.org.au>
References: <cover.1449091633.git.tim.c.chen@linux.intel.com>
 <1449086565.22260.15.camel@schen9-desk2.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>,
	Chandramouli Narayanan <mouli_7982@yahoo.com>,
	Vinodh Gopal <vinodh.gopal@intel.com>,
	James Guilford <james.guilford@intel.com>,
	Wajdi Feghali <wajdi.k.feghali@intel.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54013 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbbLICxc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 8 Dec 2015 21:53:32 -0500
Content-Disposition: inline
In-Reply-To: <1449086565.22260.15.camel@schen9-desk2.jf.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 02, 2015 at 12:02:45PM -0800, Tim Chen wrote:
>
> +/*
> + * CRYPTO_ALG_ASYNC flag is passed to indicate we have an ablk
> + * scatter-gather walk.
> + */
> +
> +static struct crypto_alg aes_cbc_mb_alg = {
> +	.cra_name		= "__cbc-aes-aesni-mb",
> +	.cra_driver_name	= "__driver-cbc-aes-aesni-mb",
> +	.cra_priority		= 100,
> +	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER | CRYPTO_ALG_ASYNC
> +					| CRYPTO_ALG_INTERNAL,
> +	.cra_blocksize		= AES_BLOCK_SIZE,
> +	.cra_ctxsize		= sizeof(struct crypto_aes_ctx) +
> +				  AESNI_ALIGN - 1,
> +	.cra_alignmask		= 0,
> +	.cra_type		= &crypto_blkcipher_type,
> +	.cra_module		= THIS_MODULE,
> +	.cra_list		= LIST_HEAD_INIT(aes_cbc_mb_alg.cra_list),
> +	.cra_u = {
> +		.blkcipher = {
> +			.min_keysize	= AES_MIN_KEY_SIZE,
> +			.max_keysize	= AES_MAX_KEY_SIZE,
> +			.ivsize		= AES_BLOCK_SIZE,
> +			.setkey		= aes_set_key,
> +			.encrypt	= mb_aes_cbc_encrypt,
> +			.decrypt	= mb_aes_cbc_decrypt
> +		},
> +	},
> +};

So why do we still need this? Shouldn't a single ablkcipher cover
all the cases?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
