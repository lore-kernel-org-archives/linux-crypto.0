From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: add key wrapping block chaining mode
Date: Wed, 22 Apr 2015 16:11:08 +0200
Message-ID: <12434918.9URe3Fjl50@myon.chronox.de>
References: <6218629.uO4632Hmli@myon.chronox.de> <20150422061354.GA8053@gondor.apana.org.au> <5036814.6LNlN5eOjK@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34243 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965264AbbDVOLR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Apr 2015 10:11:17 -0400
In-Reply-To: <5036814.6LNlN5eOjK@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 22. April 2015, 14:23:04 schrieb Stephan Mueller:

Hi,

> Am Mittwoch, 22. April 2015, 14:13:54 schrieb Herbert Xu:
> 
> Hi Herbert,
> 
> > On Wed, Apr 22, 2015 at 01:53:24PM +0800, Herbert Xu wrote:
> > > On Wed, Apr 22, 2015 at 06:36:59AM +0200, Stephan Mueller wrote:
> > > > The key wrapping is an authenticated encryption operation without
> > > > associated data. Therefore, setting of AAD is permissible, but that
> > > > data
> > > > is not used by the cipher implementation.
> > > 
> > > In that case you should return an error if AAD is provided rather
> > > than silently discarding them since by definition AEAD must include
> > > the AAD in the integrity value.
> > 
> > In fact drop the AEAD altogether and just use ablkcipher.  The
> > integrity value is then simply the output IV.
> 
> Initially I was playing with ablkcipher. But then I moved to AEAD because
> the ciphertext is longer than the plaintext.
> 
> Isn't it a basic assumption to ablkcipher is that the ciphertext is equal in
> size as the plaintext?

One more issue to consider: the key wrapping is an authenticated encryption / 
decryption. Thus, decryption can return EBADMSG, a feature a normal blkcipher 
does not do.

Key wrap is more than a blkcipher, but less than an AEAD. Thus, I would 
consider the key wrapping as a speciality of AEAD where the "AD" part is 
simply NULL (a valid use case of the "regular" AEAD ciphers).


-- 
Ciao
Stephan
