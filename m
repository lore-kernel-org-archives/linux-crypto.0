From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 2/3] crypto: AF_ALG - disregard AAD buffer space for output
Date: Sat, 12 Nov 2016 03:03:36 +0100
Message-ID: <11739696.UFOoJjMX73@positron.chronox.de>
References: <3302668.EORF2jai5r@positron.chronox.de> <3506033.FskOdlTquT@positron.chronox.de> <20161112015519.GA32234@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: mathew.j.martineau@linux.intel.com, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:50894 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935315AbcKLCMt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Nov 2016 21:12:49 -0500
In-Reply-To: <20161112015519.GA32234@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Samstag, 12. November 2016, 09:55:19 CET schrieb Herbert Xu:

Hi Herbert,

> On Thu, Nov 10, 2016 at 04:32:03AM +0100, Stephan Mueller wrote:
> > The kernel crypto API AEAD cipher operation generates output such that
> > space for the AAD is reserved in the output buffer without being
> > touched. The processed ciphertext/plaintext is appended to the reserved
> > AAD buffer.
> > 
> > The user space interface followed that approach. However, this is a
> > violation of the POSIX read definition which requires that any read data
> > is placed at the beginning of the caller-provided buffer. As the kernel
> > crypto API would leave room for the AAD, the old approach did not fully
> > comply with the POSIX specification.
> 
> Nack.  The kernel AEAD API will copy the AD as is, it definitely
> does not leave the output untouched unless of course when it is
> an in-place operation.  The user-space operation should operate
> in the same manner.

When you have separate buffers, the kernel does not seem to copy the AD over 
to the target buffer.
> 
> Cheers,


Ciao
Stephan
