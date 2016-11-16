From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 2/3] crypto: AF_ALG - disregard AAD buffer space for output
Date: Wed, 16 Nov 2016 10:02:59 +0100
Message-ID: <2184005.6LaQaNuGm1@positron.chronox.de>
References: <3302668.EORF2jai5r@positron.chronox.de> <4916573.RdN3EB8qT2@positron.chronox.de> <20161116085742.GA29644@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: mathew.j.martineau@linux.intel.com, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:50940 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752720AbcKPJDC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Nov 2016 04:03:02 -0500
In-Reply-To: <20161116085742.GA29644@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 16. November 2016, 16:57:42 CET schrieb Herbert Xu:

Hi Herbert,

> On Tue, Nov 15, 2016 at 08:06:47PM +0100, Stephan Mueller wrote:
> > Shall the fix be rolled into the patch together with the fix for the tag
> > value as well as the crash fix? Or can we have a stand-alone patch fixing
> > this.
> I think these are two separate issues and we don't need to fix them
> all in one go.

I will resubmit the patches regarding the tag and the bug fix then.
> 
> > Btw., how do you suggest that should be fixed? I would assume that this
> > needs to be fixed on a per-implementation basis. I tested authenc and it
> > copies the buffers over. gcm_base(ctr-aes-aesni,ghash-clmulni),
> > rfc4106-gcm-aesni or ccm_base(ctr-aes-aesni,aes-aesni) do not copy the AD
> > over.
> 
> We should fix as much as we can and then add a testmgr test to find
> the rest.

One thing occurred to me: The copying of the AD would only be done of src != 
dst. For the AF_ALG interface, I thing we always have src != dst due to the 
user space/kernel space translation. That means the kernel copies the AD 
around even in user space src == dst. Isn't that a waste? I.e. shouldn't we 
handle the AD copying rather in user space than in kernel space?

Ciao
Stephan
