From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/3] crypto: AF_ALG - disregard AAD buffer space for
 output
Date: Wed, 16 Nov 2016 17:04:46 +0800
Message-ID: <20161116090446.GE29644@gondor.apana.org.au>
References: <3302668.EORF2jai5r@positron.chronox.de>
 <4916573.RdN3EB8qT2@positron.chronox.de>
 <20161116085742.GA29644@gondor.apana.org.au>
 <2184005.6LaQaNuGm1@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mathew.j.martineau@linux.intel.com, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39808 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933027AbcKPJEy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Nov 2016 04:04:54 -0500
Content-Disposition: inline
In-Reply-To: <2184005.6LaQaNuGm1@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 16, 2016 at 10:02:59AM +0100, Stephan Mueller wrote:
>
> One thing occurred to me: The copying of the AD would only be done of src != 
> dst. For the AF_ALG interface, I thing we always have src != dst due to the 
> user space/kernel space translation. That means the kernel copies the AD 
> around even in user space src == dst. Isn't that a waste? I.e. shouldn't we 
> handle the AD copying rather in user space than in kernel space?

No that's not the case.  You can do zero-copy, in which case src
would be identical to dst.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
