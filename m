From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [RFC PATCH] crypto: Make the page handling of hash walk
 compatible to networking.
Date: Thu, 28 Apr 2016 10:27:43 +0200
Message-ID: <20160428082743.GO3347@gauss.secunet.com>
References: <20160421071451.GE3347@gauss.secunet.com>
 <20160425100527.GA9521@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: Sowmini Varadhan <sowmini.varadhan@oracle.com>,
	<linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([62.96.220.36]:33650 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932AbcD1I1r (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 Apr 2016 04:27:47 -0400
Content-Disposition: inline
In-Reply-To: <20160425100527.GA9521@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Apr 25, 2016 at 06:05:27PM +0800, Herbert Xu wrote:
> On Thu, Apr 21, 2016 at 09:14:51AM +0200, Steffen Klassert wrote:
> > The network layer tries to allocate high order pages for skb_buff
> > fragments, this leads to problems if we pass such a buffer to
> > crypto because crypto assumes to have always order null pages
> > in the scatterlists.
> 
> I don't understand.  AFAICS the crypto API assumes no such thing.
> Of course there might be a bug there since we probably don't get
> too many superpages coming in normally.

Maybe I misinterpreted the things I observed.

> 
> > Herbert, I could not find out why this PAGE_SIZE limit is in place.
> > So not sure if this is the right fix. Also, would it be ok to merge
> > this, or whatever is the right fix through the IPsec tree? We need
> > this before we can change esp to avoid linearization.
> 
> Your patch makes no sense.  

That's possible :)

> When you do a kmap you can only do
> one page at a time.  So if you have a "superpage" (an SG list
> entry with multiple contiguous pages) then you must walk it one
> page at a time.
> 
> That's why we cap it at PAGE_SIZE.
> 
> Is it not walking the superpage properly?

The problem was that if offset (in a superpage) equals
PAGE_SIZE in hash_walk_next(), nbytes becomes zero. So
we map the page, but we don't hash and unmap because we
exit the loop in shash_ahash_update() in this case.
