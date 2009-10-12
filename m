From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] crypto: Fix test in get_prng_bytes()
Date: Mon, 12 Oct 2009 10:29:08 -0400
Message-ID: <20091012142908.GD8885@hmsreliant.think-freely.org>
References: <4AD32A75.5030706@gmail.com> <20091012135142.GB8885@hmsreliant.think-freely.org> <20091012140753.GA30300@gondor.apana.org.au> <4AD33B8D.4030708@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Roel Kluin <roel.kluin@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36909 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756853AbZJLO3x (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 12 Oct 2009 10:29:53 -0400
Content-Disposition: inline
In-Reply-To: <4AD33B8D.4030708@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Oct 12, 2009 at 04:22:05PM +0200, Roel Kluin wrote:
> Op 12-10-09 16:07, Herbert Xu schreef:
> > On Mon, Oct 12, 2009 at 09:51:42AM -0400, Neil Horman wrote:
> > .
> >>> Or should this test be removed?
> >>>
> >>> diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
> >>> index 3aa6e38..9162456 100644
> >>> --- a/crypto/ansi_cprng.c
> >>> +++ b/crypto/ansi_cprng.c
> >>> @@ -192,7 +192,7 @@ static int get_prng_bytes(char *buf, size_t nbytes, struct prng_context *ctx)
> >>>  	int err;
> >>>  
> >>>  
> >>> -	if (nbytes < 0)
> >>> +	if ((ssize_t)nbytes < 0)
> >>>  		return -EINVAL;
> >>>  
> >>>  	spin_lock_bh(&ctx->prng_lock);
> >> No, you're quite right, its a harmless, but unneeded check.  Herbert, could you
> >> pull this into cryptodev please?  Thank you.
> > 
> > Hmm, if it's unneeded why don't we just kill it instead?
> 
> In that case:
> -------------------------->8------------------8<-------------------------
> size_t nbytes cannot be less than 0 and the test was redundant.
> 
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
> index 3aa6e38..47995ae 100644
> --- a/crypto/ansi_cprng.c
> +++ b/crypto/ansi_cprng.c
> @@ -192,9 +192,6 @@ static int get_prng_bytes(char *buf, size_t nbytes, struct prng_context *ctx)
>  	int err;
>  
>  
> -	if (nbytes < 0)
> -		return -EINVAL;
> -
>  	spin_lock_bh(&ctx->prng_lock);
>  
>  	err = -EINVAL;
> 


There you go, yes :)
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Neil

