From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] crypto: Fix test in get_prng_bytes()
Date: Mon, 12 Oct 2009 09:51:42 -0400
Message-ID: <20091012135142.GB8885@hmsreliant.think-freely.org>
References: <4AD32A75.5030706@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Roel Kluin <roel.kluin@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49551 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933AbZJLNw3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 12 Oct 2009 09:52:29 -0400
Content-Disposition: inline
In-Reply-To: <4AD32A75.5030706@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Oct 12, 2009 at 03:09:09PM +0200, Roel Kluin wrote:
> size_t nbytes cannot be less than 0.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Or should this test be removed?
> 
> diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
> index 3aa6e38..9162456 100644
> --- a/crypto/ansi_cprng.c
> +++ b/crypto/ansi_cprng.c
> @@ -192,7 +192,7 @@ static int get_prng_bytes(char *buf, size_t nbytes, struct prng_context *ctx)
>  	int err;
>  
>  
> -	if (nbytes < 0)
> +	if ((ssize_t)nbytes < 0)
>  		return -EINVAL;
>  
>  	spin_lock_bh(&ctx->prng_lock);
No, you're quite right, its a harmless, but unneeded check.  Herbert, could you
pull this into cryptodev please?  Thank you.

Thanks for the patch Roel.

Acked-by: Neil Horman <nhorman@tuxdriver.com>

Neil

> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
