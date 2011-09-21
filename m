From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH 01/16] crypto: authenc - Don't multiply priorities
Date: Wed, 21 Sep 2011 10:32:15 +0200
Message-ID: <20110921083215.GD1808@secunet.com>
References: <20110811112603.GD16877@secunet.com>
 <20110811112639.GE16877@secunet.com>
 <20110815071928.GA29761@gondor.apana.org.au>
 <20110815080257.GU16877@secunet.com>
 <20110815085546.GA30341@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:56164 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047Ab1IUIcS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 Sep 2011 04:32:18 -0400
Content-Disposition: inline
In-Reply-To: <20110815085546.GA30341@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 15, 2011 at 04:55:46PM +0800, Herbert Xu wrote:
> On Mon, Aug 15, 2011 at 10:02:57AM +0200, Steffen Klassert wrote:
> >
> > I don't think it is broken. It's just easier to handle if an underlying
> > algorithm changes it's priority. If the user changes the priority of a
> > certain algorithm, I take the difference of the old and new priority
> > value and add this to all subsequent algorithms. So this can not take the
> > weight into account without some 'per algorithm' priority update functions.
> 
> Oh I see.  I don't think we need to go that far.
> 
> Here are two simpler ways of handling this:
> 
> 1) Liquidate all instances on top of the algorithm being changed
> (this is what we already do when you register a new implementation
> of an algorithm with a higher priority).
> 
> 2) Do nothing and let the user change everything manually.
> 
> My take would be to just do 1) considering that the usage scenario
> is that the user is either going to change something like AES at
> the very bottom of the pile or something complex at the top.
> 

I've just noticed that we need the update functionality to change
the priority of algorithms that are not build from templates because
we can't delete them without unloading the module. If the algorithm
is not build as a module, we can't delete it at all. So there is no
chance to change the priority without an update functionality.

Therefore I'll bring the update functions back. I'll use your option 1)
to deal with the algorithms on top of the changed one.
