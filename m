From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] crypto: Fix test in get_prng_bytes()
Date: Mon, 12 Oct 2009 10:28:29 -0400
Message-ID: <20091012142829.GC8885@hmsreliant.think-freely.org>
References: <4AD32A75.5030706@gmail.com> <20091012135142.GB8885@hmsreliant.think-freely.org> <20091012140753.GA30300@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Roel Kluin <roel.kluin@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36903 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932222AbZJLO3Q (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 12 Oct 2009 10:29:16 -0400
Content-Disposition: inline
In-Reply-To: <20091012140753.GA30300@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Oct 12, 2009 at 11:07:53PM +0900, Herbert Xu wrote:
> On Mon, Oct 12, 2009 at 09:51:42AM -0400, Neil Horman wrote:
> .
> > > Or should this test be removed?
> > > 
> > > diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
> > > index 3aa6e38..9162456 100644
> > > --- a/crypto/ansi_cprng.c
> > > +++ b/crypto/ansi_cprng.c
> > > @@ -192,7 +192,7 @@ static int get_prng_bytes(char *buf, size_t nbytes, struct prng_context *ctx)
> > >  	int err;
> > >  
> > >  
> > > -	if (nbytes < 0)
> > > +	if ((ssize_t)nbytes < 0)
> > >  		return -EINVAL;
> > >  
> > >  	spin_lock_bh(&ctx->prng_lock);
> > No, you're quite right, its a harmless, but unneeded check.  Herbert, could you
> > pull this into cryptodev please?  Thank you.
> 
> Hmm, if it's unneeded why don't we just kill it instead?
> 
Sorry, thats what I mean't to say.  Can you kill it, or do you want a patch for
it?
Neil

> Thanks,
> -- 
> Visit Openswan at http://www.openswan.org/
> Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> 
