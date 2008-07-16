From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH 1/2] RNG: Add Pseudo Random Number Generator to kernel
Date: Wed, 16 Jul 2008 09:58:41 -0400
Message-ID: <20080716135841.GC24291@hmsreliant.think-freely.org>
References: <20080703202102.GB5237@hmsendeavour.rdu.redhat.com> <20080716134456.GA16546@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4781 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755221AbYGPN6v (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Jul 2008 09:58:51 -0400
Content-Disposition: inline
In-Reply-To: <20080716134456.GA16546@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 16, 2008 at 09:44:56PM +0800, Herbert Xu wrote:
> On Thu, Jul 03, 2008 at 04:21:02PM -0400, Neil Horman wrote:
> >> +	/*
> > +	 * Now update our DT value
> > +	 */
> > +	for (i=DEFAULT_BLK_SZ-1;i>0;i--) {
> > +		ctx->DT[i] = ctx->DT[i-1];
> > +	}
> > +	ctx->DT[0] += 1;
> 
> Is there any reason behind using this algorithm as opposed to
> a simple counter?
> 
No, this was rather a stream of conscious thing, shifting incrementing numbers
through the buffer, I can certainly make it a simple counter.

Neil

> Cheers,
> -- 
> Visit Openswan at http://www.openswan.org/
> Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

-- 
/****************************************************
 * Neil Horman <nhorman@tuxdriver.com>
 * Software Engineer, Red Hat
 ****************************************************/
