From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 2/3] crypto: AF_ALG - disregard AAD buffer space for output
Date: Tue, 15 Nov 2016 20:06:47 +0100
Message-ID: <4916573.RdN3EB8qT2@positron.chronox.de>
References: <3302668.EORF2jai5r@positron.chronox.de> <11739696.UFOoJjMX73@positron.chronox.de> <20161112021302.GA32425@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: mathew.j.martineau@linux.intel.com, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:50922 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753843AbcKOTGy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Nov 2016 14:06:54 -0500
In-Reply-To: <20161112021302.GA32425@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Samstag, 12. November 2016, 10:13:02 CET schrieb Herbert Xu:

Hi Herbert,

> On Sat, Nov 12, 2016 at 03:03:36AM +0100, Stephan Mueller wrote:
> > When you have separate buffers, the kernel does not seem to copy the AD
> > over to the target buffer.
> 
> OK we should definitely fix that.

Shall the fix be rolled into the patch together with the fix for the tag value 
as well as the crash fix? Or can we have a stand-alone patch fixing this.

Btw., how do you suggest that should be fixed? I would assume that this needs 
to be fixed on a per-implementation basis. I tested authenc and it copies the 
buffers over. gcm_base(ctr-aes-aesni,ghash-clmulni), rfc4106-gcm-aesni or 
ccm_base(ctr-aes-aesni,aes-aesni) do not copy the AD over.

Ciao
Stephan
