From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH 00/13] crypto: copy AAD during encrypt for AEAD ciphers
Date: Thu, 12 Jan 2017 16:23:50 +0100
Message-ID: <6428553.skGSKSKcYl@tauon.atsec.com>
References: <10526995.lyZ7Je1KMx@positron.chronox.de> <31581301.kpbcu3havF@positron.chronox.de> <20170112145728.GA15595@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55476 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750920AbdALPX6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Jan 2017 10:23:58 -0500
In-Reply-To: <20170112145728.GA15595@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 12. Januar 2017, 22:57:28 CET schrieb Herbert Xu:

Hi Herbert,

> On Thu, Jan 12, 2017 at 12:22:09PM +0100, Stephan Müller wrote:
> > When addressing the issue in the algif_aead code, and expect that over
> > time
> > the AEAD implementations will gain the copy operation, eventually we will
> > copy the AAD twice. Of course, this could be prevented, if the algif_aead
> > code somehow uses the same SGL for the src and dst AAD.
> 
> Why would you copy it twice? You copy everything before you start
> and then just do in-place crypto.
> 

As far as I understand, we have the following AAD copy operations that we 
discuss:

- algif_aead: you suggested to add the AAD copy operation here

- AEAD implementations: over time, the AEAD implementations shall receive the 
AAD copy operation. The AAD copy operation shall only take place if the src 
SGL != dst SGL

The algif_aead code *always* will have the src SGL being different from the 
dst SGL. Thus, any existing AEAD implementation copy will always be performed 
which would be in addition to the algif_aead AAD copy operation. We can only 
avoid the AEAD implementation copy operation, if we add some code to 
algif_aead to make sure that the AAD data is pointed to by src/dst SGL that is 
identical. However, such logic to make src/dst SGL identical is quite complex 
compared to simply use one callback as suggested in the current patch set.

In the followup email, I suggested to add the AAD copy function invocation 
into crypto_aead_encrypt. This way, we can drop the numerous patches to the 
AEAD implementations and yet we can avoid adding such copy operation and src/
dst SGL unification logic to algif_aead.

> > > BTW, why are you only doing the copy for encryption?
> > 
> > I was looking at the only AEAD implementation that does the copy
> > operation:
> > authenc. There, the copy operation is only performed for encryption. I was
> > thinking a bit about why decryption was not covered. I think the answer is
> > the following: for encryption, the AAD is definitely needed in the dst
> > buffer as the dst buffer with the AAD must be sent to the recipient for
> > decryption. The decryption and the associated authentication only works
> > with the AAD. However, after decrypting, all the caller wants is the
> > decrypted plaintext only. There is no further use of the AAD after the
> > decryption step. Hence, copying the AAD to the dst buffer in the
> > decryption step would not serve the caller.
> That's just the current implementation.  If we're going to make
> this an API then we should do it for both directions.

Considering the suggestion above to add the AAD copy call to 
crypto_aead_encrypt, we can add such copy call also to crypto_aead_decrypt.

Ciao
Stephan
