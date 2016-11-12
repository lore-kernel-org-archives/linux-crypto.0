From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/3] crypto: AF_ALG - disregard AAD buffer space for
 output
Date: Sat, 12 Nov 2016 10:13:02 +0800
Message-ID: <20161112021302.GA32425@gondor.apana.org.au>
References: <3302668.EORF2jai5r@positron.chronox.de>
 <3506033.FskOdlTquT@positron.chronox.de>
 <20161112015519.GA32234@gondor.apana.org.au>
 <11739696.UFOoJjMX73@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mathew.j.martineau@linux.intel.com, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55288 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935315AbcKLCNW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Nov 2016 21:13:22 -0500
Content-Disposition: inline
In-Reply-To: <11739696.UFOoJjMX73@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Nov 12, 2016 at 03:03:36AM +0100, Stephan Mueller wrote:
> 
> When you have separate buffers, the kernel does not seem to copy the AD over 
> to the target buffer.

OK we should definitely fix that.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
