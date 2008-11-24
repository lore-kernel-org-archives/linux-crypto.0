From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] ansi_cprng: zero out key data on exit
Date: Mon, 24 Nov 2008 21:22:07 +0800
Message-ID: <20081124132207.GB18313@gondor.apana.org.au>
References: <20081114205536.GA27175@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:58607 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750704AbYKXNWN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 24 Nov 2008 08:22:13 -0500
Content-Disposition: inline
In-Reply-To: <20081114205536.GA27175@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Nov 14, 2008 at 03:55:36PM -0500, Neil Horman wrote:
>
> diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
> index 72db0fd..e6ad373 100644
> --- a/crypto/ansi_cprng.c
> +++ b/crypto/ansi_cprng.c
> @@ -266,6 +266,7 @@ done:
>  static void free_prng_context(struct prng_context *ctx)
>  {
>  	crypto_free_cipher(ctx->tfm);
> +	memset(ctx, 0, sizeof(struct prng_context));
>  }

crypto_free_tfm should already handle this, no?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
