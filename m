From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: crypto: hash - Fix page length clamping in hash walk
Date: Wed, 4 May 2016 11:34:20 +0200
Message-ID: <20160504093420.GB3347@gauss.secunet.com>
References: <20160421071451.GE3347@gauss.secunet.com>
 <20160425100527.GA9521@gondor.apana.org.au>
 <20160428082743.GO3347@gauss.secunet.com>
 <20160503095531.GA18007@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: Sowmini Varadhan <sowmini.varadhan@oracle.com>,
	<linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([62.96.220.36]:35598 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753769AbcEDJeZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 May 2016 05:34:25 -0400
Content-Disposition: inline
In-Reply-To: <20160503095531.GA18007@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, May 03, 2016 at 05:55:31PM +0800, Herbert Xu wrote:
> On Thu, Apr 28, 2016 at 10:27:43AM +0200, Steffen Klassert wrote:
> >
> > The problem was that if offset (in a superpage) equals
> > PAGE_SIZE in hash_walk_next(), nbytes becomes zero. So
> > we map the page, but we don't hash and unmap because we
> > exit the loop in shash_ahash_update() in this case.
> 
> I see.  Does this patch help?

Hmm, the 'sleeping while atomic' because of not unmapping
the page goes away, but now I see a lot of IPsec ICV fails
on the receive side. I'll try to find out what's going on.

Sowmini, could you please doublecheck with your test setup?
