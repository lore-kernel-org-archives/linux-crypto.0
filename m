From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] prng; bring prng into better alignment with specification
Date: Thu, 17 Jul 2008 15:48:56 +0800
Message-ID: <20080717074856.GB23621@gondor.apana.org.au>
References: <20080716203200.GB1648@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	davem@davemloft.net
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:46138 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753671AbYGQHs6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Jul 2008 03:48:58 -0400
Content-Disposition: inline
In-Reply-To: <20080716203200.GB1648@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 16, 2008 at 04:32:00PM -0400, Neil Horman wrote:
>  Bring prng into better alignment with specificaion:
>     
>  - Convert to using Generic AES 128 bit cipher
>  - Convert DT to be a non-shifted counter, increasing counter period
>     
>  Signed-off-by: Neil Horman <nhorman@tuxdriver.com>

Applied to cryptodev-2.6.
>
> @@ -325,17 +306,13 @@ int reset_prng_context(struct prng_context *ctx,
>  		       unsigned char *V, unsigned char *DT)
>  	int ret;
> -	int iv_len;
>  	int rc = -EFAULT;
>  	unsigned char *prng_key;
> -	unsigned char *prng_iv;
>  	spin_lock(&ctx->prng_lock);
>  	ctx->flags |= PRNG_NEED_RESET;
>  
>  	prng_key = (key != NULL) ? key : (unsigned char *)DEFAULT_PRNG_KEY;
>  
> -	prng_iv = iv ? iv : (unsigned char *)DEFAULT_PRNG_IV;

We can now kill the iv parameter too.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
