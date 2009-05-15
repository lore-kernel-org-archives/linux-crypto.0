From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Enable VIA PadLock on x86_64
Date: Fri, 15 May 2009 15:59:14 +1000
Message-ID: <20090515055913.GB17124@gondor.apana.org.au>
References: <20090510160341.GH12152@prithivi.gnumonks.org> <20090511022901.GA4005@prithivi.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Harald Welte <laforge@gnumonks.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:53567 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753006AbZEOF7O (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 May 2009 01:59:14 -0400
Content-Disposition: inline
In-Reply-To: <20090511022901.GA4005@prithivi.gnumonks.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 11, 2009 at 10:29:01AM +0800, Harald Welte wrote:
> On Mon, May 11, 2009 at 12:03:41AM +0800, Harald Welte wrote:
> > [CRYPTO] Support VIA PadLock hardware crypto on x86-64
>  
> Sorry, I should have read the list archives before posting.
> 
> Please apply the more correct patch from Sebastian Andrzej Siewior
> as available since March 14 at
> http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg03024.html
> 
> Is there any reason I'm missing that this patch is not mainline yet? It's
> a quite trivial bugfix.  So please consider this mail as a polite reminder :)

It's in cryptodev and should be in the release after 2.6.30.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
