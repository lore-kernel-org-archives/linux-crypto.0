From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: drbg - decrease verbosity
Date: Mon, 08 Jun 2015 13:02:12 +0200
Message-ID: <11203229.1MDhPYad8M@tachyon.chronox.de>
References: <7507652.XDRqQzIvs8@tachyon.chronox.de> <20150608013355.GA24494@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:46111 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248AbbFHLCY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Jun 2015 07:02:24 -0400
In-Reply-To: <20150608013355.GA24494@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 8. Juni 2015, 09:33:55 schrieb Herbert Xu:

Hi Herbert,

> On Sat, Jun 06, 2015 at 04:20:35AM +0200, Stephan Mueller wrote:
> > When compiling the DRBG statically into the kernel, the testmgr
> > allocation of the DRBG may be done at a time the Jitter RNG is
> > not available. The testmgr instantiates a number of DRBGs for performing
> > testing which may cause a flurry of logs about unavailable Jitter RNG.
> > Note, the Jitter RNG is not needed for the testmgr operation anyways.
> 
> I think we should fix by ensuring the jitter is registered first.
> You could try registering jitter at subsys_init instead of module_init.

Thanks for the hint about the root cause. I will do that right away.
> 
> Cheers,


-- 
Ciao
Stephan
