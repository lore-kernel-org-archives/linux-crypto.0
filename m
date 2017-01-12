From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH 00/13] crypto: copy AAD during encrypt for AEAD ciphers
Date: Thu, 12 Jan 2017 16:34:39 +0100
Message-ID: <2819680.QEYfZCVF62@tauon.atsec.com>
References: <10526995.lyZ7Je1KMx@positron.chronox.de> <6428553.skGSKSKcYl@tauon.atsec.com> <20170112152710.GA16222@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55480 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750768AbdALPeq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Jan 2017 10:34:46 -0500
In-Reply-To: <20170112152710.GA16222@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 12. Januar 2017, 23:27:10 CET schrieb Herbert Xu:

Hi Herbert,

> On Thu, Jan 12, 2017 at 04:23:50PM +0100, Stephan Müller wrote:
> > As far as I understand, we have the following AAD copy operations that we
> > discuss:
> > 
> > - algif_aead: you suggested to add the AAD copy operation here
> > 
> > - AEAD implementations: over time, the AEAD implementations shall receive
> > the AAD copy operation. The AAD copy operation shall only take place if
> > the src SGL != dst SGL
> 
> If and when that happens we'd simply need to remove the copy from
> algif_aead code. 

We would only be able to remove it if all AEAD implementations are converted. 
But for the conversion time, we do face that issue.

> But even if we didn't you wouldn't have two copies
> because algif_aead should invoke the in-place code-path after doing
> a full copy of src to dst.

Are you suggesting that the entire data in the src SGL is first copied to the 
dst SGL by algif_aead? If yes, that still requires significant src/dst SGL 
tinkering as we have the tag -- the src SGL for encrypt does not have the tag 
space where the dst SGL for encrypt is required to have the tag size. This is 
vice versa for the decryption operation.

And to me the most elegant solution seems adding the copy operation to 
crypto_aead_[en|de]crypt.

Ciao
Stephan
