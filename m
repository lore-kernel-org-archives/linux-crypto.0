From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] ansi_cprng: zero out key data on exit
Date: Mon, 24 Nov 2008 11:24:49 -0500
Message-ID: <20081124162449.GA23159@hmsreliant.think-freely.org>
References: <20081114205536.GA27175@hmsreliant.think-freely.org> <20081124132207.GB18313@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50545 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672AbYKXQ06 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 24 Nov 2008 11:26:58 -0500
Content-Disposition: inline
In-Reply-To: <20081124132207.GB18313@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 24, 2008 at 09:22:07PM +0800, Herbert Xu wrote:
> On Fri, Nov 14, 2008 at 03:55:36PM -0500, Neil Horman wrote:
> >
> > diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
> > index 72db0fd..e6ad373 100644
> > --- a/crypto/ansi_cprng.c
> > +++ b/crypto/ansi_cprng.c
> > @@ -266,6 +266,7 @@ done:
> >  static void free_prng_context(struct prng_context *ctx)
> >  {
> >  	crypto_free_cipher(ctx->tfm);
> > +	memset(ctx, 0, sizeof(struct prng_context));
> >  }
> 
> crypto_free_tfm should already handle this, no?
> 
Yep, my bad, you're right.  I was thinking since it was a pointer, we'd just
null the pointer rather than the data, but it didn't occur to me that both were
allocated contiguously, so we're good.  Patch rescinded, sorry for the noise.
Neil

> Cheers,
> -- 
> Visit Openswan at http://www.openswan.org/
> Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
/****************************************************
 * Neil Horman <nhorman@tuxdriver.com>
 * Software Engineer, Red Hat
 ****************************************************/
