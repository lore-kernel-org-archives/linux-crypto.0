From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 00/20] crypto: caam - driver updates
Date: Sat, 30 Jun 2012 20:59:40 +0800
Message-ID: <20120630125940.GA12039@gondor.apana.org.au>
References: <1340412174-1784-1-git-send-email-kim.phillips@freescale.com>
 <20120627065144.GD22920@gondor.apana.org.au>
 <20120630.011851.1964175776825322391.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kim.phillips@freescale.com, linux-crypto@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:57570 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753006Ab2F3Nyq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 30 Jun 2012 09:54:46 -0400
Content-Disposition: inline
In-Reply-To: <20120630.011851.1964175776825322391.davem@davemloft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Jun 30, 2012 at 01:18:51AM -0700, David Miller wrote:
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Date: Wed, 27 Jun 2012 14:51:44 +0800
> 
> > While using the NAPI concept definitely makes sense, I'm still
> > unsure about using napi_struct directly in crypto code.  Dave,
> > did you have a chance to look at their patch to use NAPI in their
> > crypto driver?
> 
> So I think using the existing napi context is overkill for a crypto
> driver, there is so much stuff in that structure that will not be used
> and just end up being wasted space.
> 
> Better to create a crypto_napi struct that caters more closely to
> just what crypto driver need.

Yeah I agree completely.

In fact, now that I have had a bit more time to think this through
it seems that what they need isn't necessarily NAPI but better
management of the tasklet to achieve the same level of turnaround
performance as provided by NAPI + net_rx_action.

I'll try to spend some time on this next week.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
