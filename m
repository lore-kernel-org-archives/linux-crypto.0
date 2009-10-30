From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH 2/2] crypto: pcrypt - Add pcrypt crypto parallelization
	wrapper
Date: Fri, 30 Oct 2009 11:06:09 +0100
Message-ID: <20091030100609.GR15653@secunet.com>
References: <20091008072537.GG15653@secunet.com> <20091008072818.GI15653@secunet.com> <20091008.231833.107456737.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:43491 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755247AbZJ3KGQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 30 Oct 2009 06:06:16 -0400
Content-Disposition: inline
In-Reply-To: <20091008.231833.107456737.davem@davemloft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 08, 2009 at 11:18:33PM -0700, David Miller wrote:
> 
> Steffen are we going to end up adding a softirq for every crypto
> transform type?
> 
> That won't work, softirqs are to be scarcely allocated and operate
> at a very high level.
> 

I changed padata to use workqueues instead of softirqs to do the
parallelization/serialization. The performance for IPsec is similar
to the softirq version, so probaply we don't need to use softirqs at
all.

While thinking about using workqueues for padata/pcrypt, I noticed
two problems if we return asynchronous in thread context from the
crypto-layer to xfrm. Returning in thread context is not new with
pcrypt, we also can return in thread context if we use the cryptd. 

If we use tunnel mode, xfrm_input() calls netif_rx() which is certainly
wrong if we are in thread context, we need to call netif_rx_ni() instead. 
Also xfrm_input() uses bare spinlocks to protect the xfrm_state, this is
not appropriate in this case. We probaply need to switch off the bottom
halves, if we allow to return from the cypto-layer in softirq and thread
context.

Any thoughts on how to handle this?
