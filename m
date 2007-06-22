From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [1/1 take 2] HIFN: preliminary HIFN 795x driver for new async cryptoapi.
Date: Fri, 22 Jun 2007 20:36:08 +0800
Message-ID: <20070622123608.GA29919@gondor.apana.org.au>
References: <20070604134248.GA9645@2ka.mipt.ru> <20070622072844.GA27341@gondor.apana.org.au> <20070622115726.GA29425@2ka.mipt.ru> <20070622122948.GA28000@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3631 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752722AbXFVMgL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Jun 2007 08:36:11 -0400
Content-Disposition: inline
In-Reply-To: <20070622122948.GA28000@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jun 22, 2007 at 02:29:48PM +0200, Sebastian Siewior wrote:
>
> >What will prevent crypto user from filling that queue with crypto
> >requests more and more when hardware is not capable to work with such
> >rate?
> 
> Nothing, the hw signalizes with -EBUSY such a state and the crypto user
> has to slow down.
> If the crypto user continues such a behavior, the system will go OOM
> (this is atleast my understanding).

Yes, we're assuming that each tfm will only use MAY_BACKLOG
once so we don't actually need to allocate memory for it at
request time.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
