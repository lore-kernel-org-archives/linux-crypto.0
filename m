From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH 01/16] crypto: authenc - Don't multiply priorities
Date: Mon, 15 Aug 2011 10:02:57 +0200
Message-ID: <20110815080257.GU16877@secunet.com>
References: <20110811112603.GD16877@secunet.com>
 <20110811112639.GE16877@secunet.com>
 <20110815071928.GA29761@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:46540 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286Ab1HOICK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Aug 2011 04:02:10 -0400
Content-Disposition: inline
In-Reply-To: <20110815071928.GA29761@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 15, 2011 at 03:19:29PM +0800, Herbert Xu wrote:
> 
> Actually the reason it places a bigger weight on the cipher's
> priority is because typically ciphers are slower than hashes.
> So this is expressing the fact that we'd rather use a faster
> cipher with a slower hash than the other way around.

I thought the underlying ciphers and hashes choose their
priority based on the algorithms speed. So I thought it would
be ok to just add their priorities in the authenc algorithms.
Do you think we shoud keep the weight on the cipher's priority?

> 
> Do you have a particular scenario in mind where this is broken?
> 

I don't think it is broken. It's just easier to handle if an underlying
algorithm changes it's priority. If the user changes the priority of a
certain algorithm, I take the difference of the old and new priority
value and add this to all subsequent algorithms. So this can not take the
weight into account without some 'per algorithm' priority update functions.
