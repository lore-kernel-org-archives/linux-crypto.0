From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: add key wrapping block chaining mode
Date: Thu, 23 Apr 2015 03:58:37 +0200
Message-ID: <3845789.gd1dJWGSe8@myon.chronox.de>
References: <6218629.uO4632Hmli@myon.chronox.de> <2382170.NBi3QxkUu4@myon.chronox.de> <20150423014609.GA17267@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34285 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756160AbbDWB6n (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Apr 2015 21:58:43 -0400
In-Reply-To: <20150423014609.GA17267@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 23. April 2015, 09:46:09 schrieb Herbert Xu:

Hi Herbert,

> On Thu, Apr 23, 2015 at 03:39:11AM +0200, Stephan Mueller wrote:
> > The KW does not return an IV. The IV is used for encryption to stir the
> > encryption a bit. The resulting ciphertext now contains the mixed in IV.
> > For decryption, the IV is only used to verify that the one block in the
> > decryption operation matches the IV.
> > 
> > So, there is no IV returned by the encryption.
> 
> Of course there is.  The first 8 bytes of the ciphertext is the
> output IV.

Well, you can see it as IV, but I have not seen other implementations of the 
KW where that first block is handled separately from the ciphertext.

So, when our implementations returns ciphertext minus the first block and the 
first block separately, it will deviate from other implementations 
significantly.

And KW is not standalone in the kernel. The idea is that user space wraps some 
key with their implementation, and hands the wrapped key down to the kernel. 
When the kernel needs it, it can unwrap it. But it will be kept wrapped for 
the time it is not used.
> 
> If you really want to pedantic then make a function wrapper around
> the whole thing and copy the IV in there.

So we have another memcpy just to copy that block into the IV field just to 
have the KW cipher implementation copy it to some other location again? I do 
not see the value of it.
> 
> Cheers,


-- 
Ciao
Stephan
