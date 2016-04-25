From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH] crypto: Make the page handling of hash walk
 compatible to networking.
Date: Mon, 25 Apr 2016 18:05:27 +0800
Message-ID: <20160425100527.GA9521@gondor.apana.org.au>
References: <20160421071451.GE3347@gauss.secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sowmini Varadhan <sowmini.varadhan@oracle.com>,
	linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:40465 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220AbcDYKFq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Apr 2016 06:05:46 -0400
Content-Disposition: inline
In-Reply-To: <20160421071451.GE3347@gauss.secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 21, 2016 at 09:14:51AM +0200, Steffen Klassert wrote:
> The network layer tries to allocate high order pages for skb_buff
> fragments, this leads to problems if we pass such a buffer to
> crypto because crypto assumes to have always order null pages
> in the scatterlists.

I don't understand.  AFAICS the crypto API assumes no such thing.
Of course there might be a bug there since we probably don't get
too many superpages coming in normally.

> Herbert, I could not find out why this PAGE_SIZE limit is in place.
> So not sure if this is the right fix. Also, would it be ok to merge
> this, or whatever is the right fix through the IPsec tree? We need
> this before we can change esp to avoid linearization.

Your patch makes no sense.  When you do a kmap you can only do
one page at a time.  So if you have a "superpage" (an SG list
entry with multiple contiguous pages) then you must walk it one
page at a time.

That's why we cap it at PAGE_SIZE.

Is it not walking the superpage properly?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
