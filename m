From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: drbg - decrease verbosity
Date: Mon, 8 Jun 2015 09:33:55 +0800
Message-ID: <20150608013355.GA24494@gondor.apana.org.au>
References: <7507652.XDRqQzIvs8@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:59030 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbbFHBeB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Jun 2015 21:34:01 -0400
Content-Disposition: inline
In-Reply-To: <7507652.XDRqQzIvs8@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Jun 06, 2015 at 04:20:35AM +0200, Stephan Mueller wrote:
> When compiling the DRBG statically into the kernel, the testmgr
> allocation of the DRBG may be done at a time the Jitter RNG is
> not available. The testmgr instantiates a number of DRBGs for performing
> testing which may cause a flurry of logs about unavailable Jitter RNG.
> Note, the Jitter RNG is not needed for the testmgr operation anyways.

I think we should fix by ensuring the jitter is registered first.
You could try registering jitter at subsys_init instead of module_init.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
