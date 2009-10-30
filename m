From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/2] crypto: pcrypt - Add pcrypt crypto parallelization
	wrapper
Date: Fri, 30 Oct 2009 08:58:18 -0400
Message-ID: <20091030125818.GA6379@gondor.apana.org.au>
References: <20091008072537.GG15653@secunet.com> <20091008072818.GI15653@secunet.com> <20091008.231833.107456737.davem@davemloft.net> <20091030100609.GR15653@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:48868 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756777AbZJ3M6S (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 30 Oct 2009 08:58:18 -0400
Content-Disposition: inline
In-Reply-To: <20091030100609.GR15653@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Oct 30, 2009 at 11:06:09AM +0100, Steffen Klassert wrote:
>
> If we use tunnel mode, xfrm_input() calls netif_rx() which is certainly
> wrong if we are in thread context, we need to call netif_rx_ni() instead. 

Since this is all happening through a crypto completion call,
it needs to be done with BH off since that's a requirement for
crypto completion functions.  So netif_rx will work correctly
as when BH is reenabled it'll pick up the packets.

> Also xfrm_input() uses bare spinlocks to protect the xfrm_state, this is
> not appropriate in this case. We probaply need to switch off the bottom
> halves, if we allow to return from the cypto-layer in softirq and thread
> context.

This too should be fine with BH off.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
