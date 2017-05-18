From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: hifn_795x: Fix a handful of minor bugs spotted
 by eye
Date: Thu, 18 May 2017 11:25:06 +0800
Message-ID: <20170518032506.GA31773@gondor.apana.org.au>
References: <1493398960-25643-1-git-send-email-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
To: Logan Gunthorpe <logang@deltatee.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1493398960-25643-1-git-send-email-logang@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Apr 28, 2017 at 11:02:40AM -0600, Logan Gunthorpe wrote:
> * Cleaned up the formatting of ablkcipher_get arguments so it complies
>   with kernel style
> * The offset in ablkcipher_get sould be added to the source, not the
>   destination. We rename it to soffset for clarity.
> * dst++ should be dst=sg_next(dst)
> * We call kunmap_atomic earlier so we only have to do it once.
> * If ablkcipher_get fails, we should probably ensure the request
>   completes with an error.

Please don't mix unrelated changes in the same patch.

Also was this tested on actual hardware? This is an old driver so
it's probably best to just let it be.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
