From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH v2] crypto: hash - Fix page length clamping in hash walk
Date: Wed, 4 May 2016 12:08:54 +0200
Message-ID: <20160504100854.GD3347@gauss.secunet.com>
References: <20160421071451.GE3347@gauss.secunet.com>
 <20160425100527.GA9521@gondor.apana.org.au>
 <20160428082743.GO3347@gauss.secunet.com>
 <20160503095531.GA18007@gondor.apana.org.au>
 <20160504093420.GB3347@gauss.secunet.com>
 <20160504095256.GA27632@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: Sowmini Varadhan <sowmini.varadhan@oracle.com>,
	<linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([62.96.220.36]:36467 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751606AbcEDKI5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 May 2016 06:08:57 -0400
Content-Disposition: inline
In-Reply-To: <20160504095256.GA27632@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 04, 2016 at 05:52:56PM +0800, Herbert Xu wrote:
> On Wed, May 04, 2016 at 11:34:20AM +0200, Steffen Klassert wrote:
> > 
> > Hmm, the 'sleeping while atomic' because of not unmapping
> > the page goes away, but now I see a lot of IPsec ICV fails
> > on the receive side. I'll try to find out what's going on.
> > 
> > Sowmini, could you please doublecheck with your test setup?
> 
> Don't bother, my patch was crap.  Here's one that's more likely
> to work:

This one is much better, works here :)
