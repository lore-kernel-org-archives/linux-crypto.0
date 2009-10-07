From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH 1/2] padata: generic interface for parallel processing
Date: Wed, 7 Oct 2009 16:22:41 +0200
Message-ID: <20091007142241.GF15653@secunet.com>
References: <20090831091145.GB32705@secunet.com> <20090831091249.GC32705@secunet.com> <20090919231958.GA8097@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:41490 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753710AbZJGOxI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 Oct 2009 10:53:08 -0400
Content-Disposition: inline
In-Reply-To: <20090919231958.GA8097@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Sep 19, 2009 at 04:19:59PM -0700, Herbert Xu wrote:
> On Mon, Aug 31, 2009 at 11:12:49AM +0200, Steffen Klassert wrote:
> > This patch introduces an interface to process data objects
> > in parallel. On request it is possible to serialize again.
> > The parallelized objects return after serialization in the
> > same order as they were before the parallelization.
> > 
> > Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
> 
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> Looks good to me.  Dave, do you want to pick this one up?
> 

I plan to send a rebased patchset tomorrow,
so who wants to take this one?
