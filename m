From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/7]: N2CRYPTO fixes and HMAC support
Date: Wed, 26 May 2010 11:38:42 +1000
Message-ID: <20100526013842.GA21436@gondor.apana.org.au>
References: <20100525.174329.59682635.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([216.59.3.182]:46344 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933032Ab0EZBip (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 May 2010 21:38:45 -0400
Content-Disposition: inline
In-Reply-To: <20100525.174329.59682635.davem@davemloft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, May 25, 2010 at 05:43:29PM -0700, David Miller wrote:
> 
> As we discussed side-band the n2crypto driver plumbed async hash
> requests to fallbacks incorrectly.  And along the way I found
> several other bugs as well.
> 
> The recent of_device/of_platform_driver infrastructure changes
> criss-crossed the n2_crypto driver addition, so some fixups
> were needed to restore the build.
> 
> Finally, HMAC support because really easy to add once the async
> hash fallback stuff was fixed properly, so here it is :-)
> 
> Please pull, thanks a lot.

Pulled.  Thanks Dave!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
