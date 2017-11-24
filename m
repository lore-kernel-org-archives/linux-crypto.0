From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v3] crypto: algif_aead - skip SGL entries with NULL page
Date: Fri, 24 Nov 2017 17:09:58 +0100
Message-ID: <1673642.HJniZzKvGP@tauon.chronox.de>
References: <3016707.l0K91qkPze@positron.chronox.de> <9325029.81qbAra0rM@positron.chronox.de> <20171124073728.GA15597@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:42474 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751668AbdKXQKA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Nov 2017 11:10:00 -0500
In-Reply-To: <20171124073728.GA15597@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 24. November 2017, 08:37:28 CET schrieb Herbert Xu:

Hi Herbert,

> On Fri, Nov 10, 2017 at 11:04:52AM +0100, Stephan Müller wrote:
> > Hi Herbert,
> > 
> > I missed the termination of the outer loop of list_for_each_entry_safe.
> > 
> > The patch was tested on x86 64 and 32 bit environments.
> > 
> > ---8<---
> > 
> > The TX SGL may contain SGL entries that are assigned a NULL page. This
> > may happen if a multi-stage AIO operation is performed where the data
> > for each stage is pointed to by one SGL entry. Upon completion of that
> > stage, af_alg_pull_tsgl will assign NULL to the SGL entry.
> > 
> > The NULL cipher used to copy the AAD from TX SGL to the destination
> > buffer, however, cannot handle the case where the SGL starts with an SGL
> > entry having a NULL page. Thus, the code needs to advance the start
> > pointer into the SGL to the first non-NULL entry.
> > 
> > This fixes a crash visible on Intel x86 32 bit using the libkcapi test
> > suite.
> > 
> > Fixes: 72548b093ee38 ("crypto: algif_aead - copy AAD from src to dst")
> > Signed-off-by: Stephan Mueller <smueller@chronox.de>
> 
> Patch applied.  Thanks.

Would it make sense to feed it to stable?

Ciao
Stephan
