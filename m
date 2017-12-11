From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: Re: [PATCH 3/4] crypto: inside-secure - only update the result
 buffer when provided
Date: Mon, 11 Dec 2017 08:49:57 +0100
Message-ID: <20171211074957.GC25616@kwain>
References: <20171128090518.12469-1-antoine.tenart@free-electrons.com>
 <20171128090518.12469-4-antoine.tenart@free-electrons.com>
 <20171211072946.GA8823@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        davem@davemloft.net, thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com,
        miquel.raynal@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:52187 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750707AbdLKHt7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Dec 2017 02:49:59 -0500
Content-Disposition: inline
In-Reply-To: <20171211072946.GA8823@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

On Mon, Dec 11, 2017 at 06:29:46PM +1100, Herbert Xu wrote:
> On Tue, Nov 28, 2017 at 10:05:17AM +0100, Antoine Tenart wrote:
> >  
> >  	if (sreq->finish)
> >  		result_sz = crypto_ahash_digestsize(ahash);
> > -	memcpy(sreq->state, areq->result, result_sz);
> > +
> > +	/* The called isn't required to supply a result buffer. Updated it only
> > +	 * when provided.
> > +	 */
> > +	if (areq->result)
> > +		memcpy(sreq->state, areq->result, result_sz);
> 
> I don't think you should use whether areq->result is NULL to
> determine whether to copy data into it.  For example, I could
> be making an update call with a non-NULL areq->result and it would
> be completely wrong if you overwrote that with the above memcpy.
> 
> IOW areq->result should not be touched at all unless you are doing
> a finalisation.

I didn't know that. It means the SafeXcel driver logic is wrong
regarding this point, as areq->result is DMA mapped and used of all hash
operations (including updates).

So this patch is indeed fixing an issue, which should probably not be
there in the first place. I guess you recommend using a buffer local to
the driver instead, and only update areq->request on completion (final).

Thanks!
Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
