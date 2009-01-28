From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: Force panic on continuous CPRNG test failure
	when in FIPS mode
Date: Wed, 28 Jan 2009 15:18:28 +1100
Message-ID: <20090128041828.GB13157@gondor.apana.org.au>
References: <20090123155817.GA29548@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:32806 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752320AbZA1ESd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 27 Jan 2009 23:18:33 -0500
Content-Disposition: inline
In-Reply-To: <20090123155817.GA29548@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 23, 2009 at 10:58:17AM -0500, Neil Horman wrote:
> 
> diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
> index 0fac8ff..7eef5be 100644
> --- a/crypto/ansi_cprng.c
> +++ b/crypto/ansi_cprng.c
> @@ -132,10 +132,20 @@ static int _get_more_prng_bytes(struct prng_context *ctx)
>  			 */
>  			if (!memcmp(ctx->rand_data, ctx->last_rand_data,
>  					DEFAULT_BLK_SZ)) {
> -				printk(KERN_ERR
> -					"ctx %p Failed repetition check!\n",
> -					ctx);
> -				ctx->flags |= PRNG_NEED_RESET;
> +				if (fips_enabled) {
> +					/* FIPS 140-2 requires that we disable
> +					 * further use of crypto code if we fail
> +					 * this test,  easiest way to do that
> +					 * is panic the box
> +					 */
> +					panic("cprng %p failed continuity test",
> +						ctx);  
> +				} else {
> +					printk(KERN_ERR
> +						"ctx %p Failed repetition check!\n",
> +						ctx);
> +					ctx->flags |= PRNG_NEED_RESET;
> +				}

I'm OK with this change but I'd like it to look like:

	if (fips_enabled) {
		panic(...)
	}

	blah blah blah

This way the FIPS crap doesn't get in the way of everyday use.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
