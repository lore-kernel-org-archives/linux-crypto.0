From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH 00/13] crypto: copy AAD during encrypt for AEAD ciphers
Date: Thu, 12 Jan 2017 12:22:09 +0100
Message-ID: <31581301.kpbcu3havF@positron.chronox.de>
References: <10526995.lyZ7Je1KMx@positron.chronox.de> <20170112061936.GA10325@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55468 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751304AbdALLWN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Jan 2017 06:22:13 -0500
In-Reply-To: <20170112061936.GA10325@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 12. Januar 2017, 14:19:36 CET schrieb Herbert Xu:

Hi Herbert,

> On Tue, Jan 10, 2017 at 02:36:21AM +0100, Stephan Müller wrote:
> > to all driver maintainers: the patches I added are compile tested, but
> > I do not have the hardware to verify the code. May I ask the respective
> > hardware maintainers to verify that the code is appropriate and works
> > as intended? Thanks a lot.
> > 
> > Herbert, this is my proprosal for our discussion around copying the
> > AAD for algif_aead. Instead of adding the code to algif_aead and wait
> > until it transpires to all cipher implementations, I thought it would
> > be more helpful to fix all cipher implementations.
> 
> I think it's too much churn.  Let's get the algif_aead code fixed
> up first, and then pursue this later.

My idea with this patch set was to have only a minimal change to any AEAD 
implementation, i.e. one callback to address this issue.

When addressing the issue in the algif_aead code, and expect that over time 
the AEAD implementations will gain the copy operation, eventually we will copy 
the AAD twice. Of course, this could be prevented, if the algif_aead code 
somehow uses the same SGL for the src and dst AAD.

Some time back I published the patch "crypto: AF_ALG - disregard AAD buffer 
space for output". This patch tried changing the src and dst SGL to remove the 
AAD. Considering this patch trying to change the src and dst SGL structure, I 
expect that the patch to algif_aead to have a common src/dst SGL for the AAD 
to prevent the AAD copy from the AEAD implementations is similar in 
complexity.

Weighing the complexity of such temporary band-aid for algif_aead with the 
addition of one callback to each AEAD implementation (which would need to be 
added some when anyway), I thought it is less complex to add the one callback 
to the AEAD implementations.
> 
> BTW, why are you only doing the copy for encryption?

I was looking at the only AEAD implementation that does the copy operation: 
authenc. There, the copy operation is only performed for encryption. I was 
thinking a bit about why decryption was not covered. I think the answer is the 
following: for encryption, the AAD is definitely needed in the dst buffer as 
the dst buffer with the AAD must be sent to the recipient for decryption. The 
decryption and the associated authentication only works with the AAD. However, 
after decrypting, all the caller wants is the decrypted plaintext only. There 
is no further use of the AAD after the decryption step. Hence, copying the AAD 
to the dst buffer in the decryption step would not serve the caller.

Ciao
Stephan
