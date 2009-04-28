From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [RFC] [PATCH v2 3/4] xfrm: Add a netlink attribute for
	software crypto accelerators
Date: Tue, 28 Apr 2009 12:11:21 +0200
Message-ID: <20090428101121.GC20366@secunet.com>
References: <20090427085346.GA21761@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:39187 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753730AbZD1KJP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 Apr 2009 06:09:15 -0400
Content-Disposition: inline
In-Reply-To: <20090427085346.GA21761@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Apr 27, 2009 at 04:53:46PM +0800, Herbert Xu wrote:
> 
> While this should work for pcrypt, I'd like this to be solved
> more generally.  The crux of the issue is that we can't specify
> an arbitrary implementation of a given algorithm.  So the obvious
> solution is to specify the driver name along with the algorithm
> name.

So how general should it be? For the moment I would see pcrypt and maybe
cryptd as possible candidates to use this mechanism. I'm just wondering
if it is worth to set up a list of crypto templates that can be choosen
from userspace, similar to the xfrm_algo_list.

> 
> This is in fact pretty much what you've done, but I'd just like
> it to be generalised.  In particular, instead of having just a
> single name per SA, we should allow one to be set for each algorithm
> type.

Just to get you right, do you think about adding a netlink attribute for
each algorithm type?

> 
> On another note, I don't expect this to be the primary mechanism
> for activating parallel processing.  Doing it manually on each
> SA is just painful.  This should be used for testing or when you
> want to specify it for a subset of SAs only.
> 
> When the admin wants to turn the entire system over to pcrypt,
> it should be done at the crypto layer, by simply registering
> the pcrypt version of the algorithm in question, and having it
> as the default implementation of that algorithm.

That's not really clear to me how to let the user register the pcrypt
version of the algorithm, so what's the desired way do this.

> 
> In fact, this mechanism should then be able to allow specific
> SAs to not use parallel processing, which means that it should
> definitely not be called accl :)
> 

Yes, I think I'll find a better name :)

Steffen
