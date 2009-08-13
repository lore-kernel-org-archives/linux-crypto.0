From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/3] crypto: talitos - simplify hmac data size
	calculation
Date: Thu, 13 Aug 2009 11:52:09 +1000
Message-ID: <20090813015209.GA17783@gondor.apana.org.au>
References: <20090807183958.94650fb7.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@ozlabs.org
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:36569 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752005AbZHMBwN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 12 Aug 2009 21:52:13 -0400
Content-Disposition: inline
In-Reply-To: <20090807183958.94650fb7.kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Aug 07, 2009 at 11:39:58PM +0000, Kim Phillips wrote:
> don't do request->src vs. assoc pointer math - it's the same as adding
> assoclen and ivsize (just with more effort).
> 
> Signed-off-by: Kim Phillips <kim.phillips@freescale.com>

All 3 patches applied.  Thanks Kim!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
