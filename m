From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3/4] crypto: drbg - replace spinlock with mutex
Date: Mon, 20 Apr 2015 08:48:55 +0800
Message-ID: <20150420004855.GA16974@gondor.apana.org.au>
References: <1551177.C0RmlOO9iU@myon.chronox.de>
 <1695105.vT0DvueDZS@myon.chronox.de>
 <20150420002709.GB16750@gondor.apana.org.au>
 <2050637.ShmA9JvV53@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:40517 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbbDTAs7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 19 Apr 2015 20:48:59 -0400
Content-Disposition: inline
In-Reply-To: <2050637.ShmA9JvV53@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Apr 20, 2015 at 02:45:02AM +0200, Stephan Mueller wrote:
> 
> I do not want to deviate from the kernel crypto API by adding some additional 
> wrapper. But what we can do is to leave the DRBG unseeded during alloc time. 
> As long as the DRBG is unseeded, it will return EAGAIN to any request for 
> random numbers, forcing the caller to use crypto_rng_reset to activate the 
> DRBG.
> 
> When the DRBG receives a reset, it will always obtain the seed and treat any 
> user-provided data as personalization string / additional data.

That's exactly what I was suggesting.  I already have two patches
that I will post once I finish testing.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
