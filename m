From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3] crypto: only call put_page on referenced and used
 pages
Date: Tue, 13 Sep 2016 18:08:16 +0800
Message-ID: <20160913100816.GA30804@gondor.apana.org.au>
References: <13399079.xub8KL5p6S@positron.chronox.de>
 <1794862.SeMhQgguHO@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60339 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756513AbcIMKI2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Sep 2016 06:08:28 -0400
Content-Disposition: inline
In-Reply-To: <1794862.SeMhQgguHO@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Sep 13, 2016 at 10:18:54AM +0200, Stephan Mueller wrote:
> Am Montag, 12. September 2016, 14:43:45 CEST schrieb Stephan Mueller:
> 
> Hi Herbert,
> 
> > Hi Herbert,
> > 
> > after getting the AIO code working on sendmsg, tried it with vmsplice/splice
> > and I get a memory corruption. Interestingly, the stack trace is partially
> > garbled too. Thus, tracking this one down may be a bit of a challenge.
> 
> The issue is a NULL pointer dereference in skcipher_free_async_sgls. The issue is that SGs may not have even a page mapped to them and thus the page entry is NULL.
> 
> The following patch fixes the issue and replaces the patch I sent earlier.

This patch appears to be papering over a real bug.

The async path should be exactly the same as the sync path, except
that we don't wait for completion.  So the question is why are we
getting this crash here for async but not sync?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
