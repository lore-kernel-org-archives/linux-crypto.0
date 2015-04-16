From: Stephan Mueller <smueller@chronox.de>
Subject: Re: DRBG parallel requests
Date: Thu, 16 Apr 2015 17:13:50 +0200
Message-ID: <1683076.LPItN49aSW@tauon>
References: <20150416144455.GA17293@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Rafael Aquini <aquini@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34135 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbbDPPRl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 16 Apr 2015 11:17:41 -0400
In-Reply-To: <20150416144455.GA17293@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 16. April 2015, 22:44:55 schrieb Herbert Xu:

Hi Herbert, Rafael,

>Hi Stephan:
>
>Currently you can have two users of DRBG issuing requests in
>parallel and end up using the same internal state.  The only
>difference between them is the cycle counter that you inject
>into the DRBG.
>
>I can't see how this is safe as the cycle counter contains minimal
>entropy.  The whole DRBG scheme depends on the fact that states
>are not reused so surely this is a very bad thing?
>
>I think we should just stick with locking the entire generation
>function.

Ok, I can certainly add such a lock. That would simply the code significantly 
as the entire business with the shadow copy goes away.

However, before I aired the DRBG, Rafael reviewed the DRBG. Initially I had 
such a "global" lock during the operation of the DRBG. Rafael's strongest 
comment was to remove the lock in favor of the shadow approach considering 
that this approach scales much better.

Surely, the shadow approach scales better than a global lock. But its drawback 
is the (almost) identical state.

Rafael: do you have any better idea here other than remove the shadow copy 
approach and use a global lock?
>
>The only users of RNG in the crypto API do so in process context
>so we can make it a rule that all users RNG must be in process
>context.

Herbert, which type of lock am I allowed to use? Is a spin lock sufficient or 
shall I use a mutex. I am not fully sure whether the used shash or cipher type 
can sleep.
>
>Cheers,


Ciao
Stephan
