From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v5 1/5] random: Async and sync API for accessing
 nonblocking_pool
Date: Mon, 11 May 2015 17:28:29 +0800
Message-ID: <20150511092829.GA4014@gondor.apana.org.au>
References: <1887272.cxqymnQQZn@tachyon.chronox.de>
 <3264123.O3YfJV7UGj@tachyon.chronox.de>
 <20150511065714.GA2598@gondor.apana.org.au>
 <3644541.vBsSXgpCaS@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pebolle@tiscali.nl, andreas.steffen@strongswan.org, tytso@mit.edu,
	sandyinchina@gmail.com, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:45867 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376AbbEKJ2p (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2015 05:28:45 -0400
Content-Disposition: inline
In-Reply-To: <3644541.vBsSXgpCaS@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 11, 2015 at 09:30:11AM +0200, Stephan Mueller wrote:
>
> I will remove that in the next installment. But that means that the DRBG 
> kernel module (or any other module) cannot be unloaded until the work 
> completes.

I don't think that's a big deal.

> Are you suggesting to only leave get_blocking_random_bytes and have the caller 
> implementing the appropriate synchronous wait or async work?

No there should just be a single interface where you feed it a
function pointer and a data pointer.  This function should then
be called when the pool is ready.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
