From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v2] crypto: AF_ALG - fix AEAD AIO handling of zero buffer
Date: Wed, 07 Dec 2016 13:29:13 +0100
Message-ID: <2633671.N2joko3Rba@tauon.atsec.com>
References: <3547426.Fep2bfj8cH@positron.chronox.de> <20161201132207.GF2249@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:39096 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751064AbcLGM3S (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Dec 2016 07:29:18 -0500
In-Reply-To: <20161201132207.GF2249@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 1. Dezember 2016, 21:22:07 CET schrieb Herbert Xu:

Hi Herbert,

> On Thu, Dec 01, 2016 at 08:22:37AM +0100, Stephan Mueller wrote:
> > Hi Herbert,
> > 
> > I split out the bug fix patch from the AD/tag formatting patch as they
> > most likely will come after the next merge window.
> > 
> > ---8<---
> > 
> > Handle the case when the caller provided a zero buffer to
> > sendmsg/sendpage. Such scenario is legal for AEAD ciphers when no
> > plaintext / ciphertext and no AAD is provided and the caller only
> > requests the generation of the tag value.
> > 
> > Signed-off-by: Stephan Mueller <smueller@chronox.de>
> 
> Patch applied.  Thanks.

May I suggest to forward that patch to stable as this patch fixes a kernel 
crasher that can be triggered by an unprivileged user?

The bug was introduced in 4.7 with the AEAD AIO addition.

Ciao
Stephan
