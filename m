From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: hifn_795x: Fix a handful of minor bugs spotted
 by eye
Date: Thu, 18 May 2017 11:26:58 +0800
Message-ID: <20170518032658.GA31836@gondor.apana.org.au>
References: <1493398960-25643-1-git-send-email-logang@deltatee.com>
 <20170518032506.GA31773@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
To: Logan Gunthorpe <logang@deltatee.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:41716 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753855AbdERD1M (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 May 2017 23:27:12 -0400
Content-Disposition: inline
In-Reply-To: <20170518032506.GA31773@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 18, 2017 at 11:25:06AM +0800, Herbert Xu wrote:
> On Fri, Apr 28, 2017 at 11:02:40AM -0600, Logan Gunthorpe wrote:
> > * Cleaned up the formatting of ablkcipher_get arguments so it complies
> >   with kernel style
> > * The offset in ablkcipher_get sould be added to the source, not the
> >   destination. We rename it to soffset for clarity.
> > * dst++ should be dst=sg_next(dst)
> > * We call kunmap_atomic earlier so we only have to do it once.
> > * If ablkcipher_get fails, we should probably ensure the request
> >   completes with an error.
> 
> Please don't mix unrelated changes in the same patch.
> 
> Also was this tested on actual hardware? This is an old driver so
> it's probably best to just let it be.

Of course we do want fix the offset issue so could you please send
a new patch with just that fix?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
