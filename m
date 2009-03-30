From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] [PATCH 2/4] cpu_chainiv: add percpu IV chain genarator
Date: Mon, 30 Mar 2009 21:19:55 +0800
Message-ID: <20090330131955.GA22604@gondor.apana.org.au>
References: <20090316114940.GN13998@secunet.com> <20090316115251.GP13998@secunet.com> <20090327083615.GB27903@gondor.apana.org.au> <20090330115415.GC6791@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:58408 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750998AbZC3NUG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 30 Mar 2009 09:20:06 -0400
Content-Disposition: inline
In-Reply-To: <20090330115415.GC6791@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Mar 30, 2009 at 01:54:15PM +0200, Steffen Klassert wrote:
> 
> Well, to do efficient parallel processing we need a percpu IV chain
> genarator. pcrypt sends the crypto requests round robin to the cpus
> independent of the flow they are belong to, so the flows and the IV
> streams are mixing. As long as we use the percpu IV chain genarator just
> for parallel algorithms we don't have this security issues. 

How about using eseqiv? It's designed for exactly this situation
where you want parallel async processing.  Its overhead is just
one extra encryption block.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
