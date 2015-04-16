From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: DRBG parallel requests
Date: Thu, 16 Apr 2015 23:30:38 +0800
Message-ID: <20150416153038.GB17690@gondor.apana.org.au>
References: <20150416144455.GA17293@gondor.apana.org.au>
 <1683076.LPItN49aSW@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Rafael Aquini <aquini@redhat.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38199 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbbDPPao (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 16 Apr 2015 11:30:44 -0400
Content-Disposition: inline
In-Reply-To: <1683076.LPItN49aSW@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 16, 2015 at 05:13:50PM +0200, Stephan Mueller wrote:
>
> Surely, the shadow approach scales better than a global lock. But its drawback 
> is the (almost) identical state.

The drawback is that your DRBG is no longer anything like that
specified by the standard.  You've completely changed the
cryptography by reusing the internal state.

> Rafael: do you have any better idea here other than remove the shadow copy 
> approach and use a global lock?

I don't think you can get around the global lock due to the sequential
nature of the DRBG that is built into its design.

> >The only users of RNG in the crypto API do so in process context
> >so we can make it a rule that all users RNG must be in process
> >context.
> 
> Herbert, which type of lock am I allowed to use? Is a spin lock sufficient or 
> shall I use a mutex. I am not fully sure whether the used shash or cipher type 
> can sleep.

As I said we can make it a rule that any user of our RNG must be in
process context (all existing users are) so you can use a mutex.

Also, if we change the entropy source to a blocking one as discussed
in the other thread then you'd definitely want to have a mutex intead
of a spin lock.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
