From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [patch/rfc] crypto: padlock-aes use crypto API
Date: Thu, 2 Aug 2007 21:36:19 +0800
Message-ID: <20070802133619.GA15542@gondor.apana.org.au>
References: <20070802081009.GA24488@Chamillionaire.breakpoint.cc> <20070802085816.GA12882@gondor.apana.org.au> <20070802092351.GA24639@Chamillionaire.breakpoint.cc> <20070802092825.GA13085@gondor.apana.org.au> <20070802130933.GE24639@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4554 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753482AbXHBNpK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Aug 2007 09:45:10 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1IGazE-0002Wy-QB
	for <linux-crypto@vger.kernel.org>; Thu, 02 Aug 2007 23:45:08 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1IGaqh-000436-00
	for <linux-crypto@vger.kernel.org>; Thu, 02 Aug 2007 21:36:19 +0800
Content-Disposition: inline
In-Reply-To: <20070802130933.GE24639@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Aug 02, 2007 at 03:09:33PM +0200, Sebastian Siewior wrote:
> 
> If this is that important, isn't it better to add/ replace the current
> _aligned call with such an optimized one? Or applies this kind of
> optimization only to this special driver where it is very expensive
> otherwise?

In this particular case we have a CPU that's relatively
poor at branching but very fast at doing AES so yes it
is special.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
