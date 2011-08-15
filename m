From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH 01/16] crypto: authenc - Don't multiply priorities
Date: Mon, 15 Aug 2011 12:08:06 +0200
Message-ID: <20110815100806.GV16877@secunet.com>
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
Received: from a.mx.secunet.com ([195.81.216.161]:45358 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937Ab1HOKHR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Aug 2011 06:07:17 -0400
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

Hm, I thought about that already. But in this case, we can change the
priority just if all the algorithms on top are unused. My intention
was to be able to change the priority without the need of removing all
transforms build from these algorithms. So I had the hope to get it
that all existing transforms continue to use the old algorithm of
hightest priority and all newly build transforms use the new
algorithm with the highest priority.

> 
> 2) Do nothing and let the user change everything manually.

This has the same issue, with the only difference that the user
has to remove the instances on top manually.

I think the only value of the priority update is, if we can do it
without removing existing transforms. If this is not possible
it is much easier to just delete the algorithm in question and
to build a new one with the updated priority.
