From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] crypto: ansi_cprng - Fix module initialization
Date: Tue, 25 Aug 2009 06:59:00 -0400
Message-ID: <20090825105900.GB24710@hmsreliant.think-freely.org>
References: <20090825081416.GC14755@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48948 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbZHYK7I (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Aug 2009 06:59:08 -0400
Content-Disposition: inline
In-Reply-To: <20090825081416.GC14755@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 25, 2009 at 10:14:16AM +0200, Steffen Klassert wrote:
> Return the value we got from crypto_register_alg() instead of
> returning 0 in any case.
> 
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
> ---
>  crypto/ansi_cprng.c |    9 +--------
>  1 files changed, 1 insertions(+), 8 deletions(-)
> 
> diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
> index 5357ba7..3aa6e38 100644
> --- a/crypto/ansi_cprng.c
> +++ b/crypto/ansi_cprng.c
> @@ -408,17 +408,10 @@ static struct crypto_alg rng_alg = {
>  /* Module initalization */
>  static int __init prng_mod_init(void)
>  {
> -	int ret = 0;
> -
>  	if (fips_enabled)
>  		rng_alg.cra_priority += 200;
>  
> -	ret = crypto_register_alg(&rng_alg);
> -
> -	if (ret)
> -		goto out;
> -out:
> -	return 0;
> +	return crypto_register_alg(&rng_alg);
>  }
>  
>  static void __exit prng_mod_fini(void)
> -- 
> 1.5.4.2
> 
> 
Thanks!

Acked-by: Neil Horman <nhorman@tuxdriver.com>

