From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH 1/2] crypto/ansi prng: use just a BH lock
Date: Tue, 30 Jun 2009 10:14:13 -0400
Message-ID: <20090630141413.GA13116@hmsreliant.think-freely.org>
References: <1246281425.3688.13.camel@queen> <20090629140704.GA25939@Chamillionaire.breakpoint.cc> <20090629152027.GA5022@hmsreliant.think-freely.org> <20090629214430.GA29616@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	davem@davemloft.net, Eric Sesterhenn <eric.sesterhenn@lsexperts.de>
To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53144 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447AbZF3OOW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 30 Jun 2009 10:14:22 -0400
Content-Disposition: inline
In-Reply-To: <20090629214430.GA29616@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 29, 2009 at 11:44:30PM +0200, Sebastian Andrzej Siewior wrote:
> From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> 
> the current code uses a mix of sping_lock() & spin_lock_irqsave(). This can
> lead to deadlock with the correct timming & cprng_get_random() + cprng_reset()
> sequence.
> I've converted them to bottom half locks since all three user grab just a BH
> lock so this runs probably in softirq :)
> 
> Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>

There are more than just 3 users of this rng.  This is the rng that gets
allocated in the event that someone calls crypto_alloc_rng("stdrng"), and
several ciphers use that, and in turn various ipsec implementations use those
ciphers.  That said, I've built it and tested it, and don't currently see any
users of this api from within interrupt context (i.e. no lockdep warnings).  I
think we may want to make this api accessible within interrupt context, but that
can probably wait until we have a user in said context, to find the best way to
do that.  Herbert, can you apply this to your tree?  Thanks!

Acked-by: Neil Horman <nhorman@tuxdriver.com>

> ---
>  crypto/ansi_cprng.c |    9 ++++-----
>  1 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
> index d80ed4c..ff00b58 100644
> --- a/crypto/ansi_cprng.c
> +++ b/crypto/ansi_cprng.c
> @@ -187,7 +187,6 @@ static int _get_more_prng_bytes(struct prng_context *ctx)
>  /* Our exported functions */
>  static int get_prng_bytes(char *buf, size_t nbytes, struct prng_context *ctx)
>  {
> -	unsigned long flags;
>  	unsigned char *ptr = buf;
>  	unsigned int byte_count = (unsigned int)nbytes;
>  	int err;
> @@ -196,7 +195,7 @@ static int get_prng_bytes(char *buf, size_t nbytes, struct prng_context *ctx)
>  	if (nbytes < 0)
>  		return -EINVAL;
>  
> -	spin_lock_irqsave(&ctx->prng_lock, flags);
> +	spin_lock_bh(&ctx->prng_lock);
>  
>  	err = -EINVAL;
>  	if (ctx->flags & PRNG_NEED_RESET)
> @@ -268,7 +267,7 @@ empty_rbuf:
>  		goto remainder;
>  
>  done:
> -	spin_unlock_irqrestore(&ctx->prng_lock, flags);
> +	spin_unlock_bh(&ctx->prng_lock);
>  	dbgprint(KERN_CRIT "returning %d from get_prng_bytes in context %p\n",
>  		err, ctx);
>  	return err;
> @@ -287,7 +286,7 @@ static int reset_prng_context(struct prng_context *ctx,
>  	int rc = -EINVAL;
>  	unsigned char *prng_key;
>  
> -	spin_lock(&ctx->prng_lock);
> +	spin_lock_bh(&ctx->prng_lock);
>  	ctx->flags |= PRNG_NEED_RESET;
>  
>  	prng_key = (key != NULL) ? key : (unsigned char *)DEFAULT_PRNG_KEY;
> @@ -332,7 +331,7 @@ static int reset_prng_context(struct prng_context *ctx,
>  	rc = 0;
>  	ctx->flags &= ~PRNG_NEED_RESET;
>  out:
> -	spin_unlock(&ctx->prng_lock);
> +	spin_unlock_bh(&ctx->prng_lock);
>  
>  	return rc;
>  
> -- 
> 1.6.3.3
> 
> 
