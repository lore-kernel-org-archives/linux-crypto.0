From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: add key wrapping block chaining mode
Date: Thu, 23 Apr 2015 03:39:11 +0200
Message-ID: <2382170.NBi3QxkUu4@myon.chronox.de>
References: <6218629.uO4632Hmli@myon.chronox.de> <5036814.6LNlN5eOjK@myon.chronox.de> <20150423013337.GB16834@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34283 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753758AbbDWBlN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Apr 2015 21:41:13 -0400
In-Reply-To: <20150423013337.GB16834@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 23. April 2015, 09:33:37 schrieb Herbert Xu:

Hi Herbert,

> On Wed, Apr 22, 2015 at 02:23:04PM +0200, Stephan Mueller wrote:
> > Isn't it a basic assumption to ablkcipher is that the ciphertext is equal
> > in size as the plaintext?
> 
> Not necessarily since a blkcipher also outputs IV which is exactly
> what's happening in KW.

The KW does not return an IV. The IV is used for encryption to stir the 
encryption a bit. The resulting ciphertext now contains the mixed in IV. For 
decryption, the IV is only used to verify that the one block in the decryption 
operation matches the IV.

So, there is no IV returned by the encryption.
> 
> For the fixed IV value you could use givencrypt so you don't even
> an rfc wrapper.

I am almost done with the rfc wrapper. I would like to keep the work done 
already :-)

> 
> Cheers,


-- 
Ciao
Stephan
