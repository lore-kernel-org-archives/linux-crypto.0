From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 2/3] crypto: AF_ALG - disregard AAD buffer space for output
Date: Sat, 19 Nov 2016 22:08:06 +0100
Message-ID: <6354916.mphDsJscQs@positron.chronox.de>
References: <3302668.EORF2jai5r@positron.chronox.de> <2184005.6LaQaNuGm1@positron.chronox.de> <20161116090446.GE29644@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: mathew.j.martineau@linux.intel.com, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:50982 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752922AbcKSVIK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 19 Nov 2016 16:08:10 -0500
In-Reply-To: <20161116090446.GE29644@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 16. November 2016, 17:04:46 CET schrieb Herbert Xu:

Hi Herbert,

> On Wed, Nov 16, 2016 at 10:02:59AM +0100, Stephan Mueller wrote:
> > One thing occurred to me: The copying of the AD would only be done of src
> > != dst. For the AF_ALG interface, I thing we always have src != dst due
> > to the user space/kernel space translation. That means the kernel copies
> > the AD around even in user space src == dst. Isn't that a waste? I.e.
> > shouldn't we handle the AD copying rather in user space than in kernel
> > space?
> 
> No that's not the case.  You can do zero-copy, in which case src
> would be identical to dst.

The way to go on this topic would be to use the same logic as the authenc 
implementation by using a null cipher for the copy operation. Though, finding 
out whether the src and dst buffers are the same is an interesting 
proposition, because we need to traverse the src and dst SGLs to see whether 
the same pages and same offsets are used. A simple check for src SGL == dst 
SGL will not work for the AF_ALG implementation, because the src SGL will 
always be different from the dst SGL because they are constructed in different 
ways (tsgl will always be different from rsgl). What may be the same are the 
pages and offsets that are pointed to by the SGL in case of zerocopy.

Keeping that in mind, I am wondering whether the authenc() implementation 
should be changed to simply remove the copy operation in there. As there seem 
to be no other AEAD cipher implements that copy operation (at least the major 
CCM and GCM implementations applicable to X86 do not do that), it seems that 
it is not necessary at all for in-kernel users. The authenc implementation 
performs the copy operation of the src SGL if it is different from the dst 
SGL. See the following code used by authenc:

        if (req->src != req->dst) {
                err = crypto_authenc_copy_assoc(req);
                if (err)
                        return err;

                dst = scatterwalk_ffwd(areq_ctx->dst, req->dst, req-
>assoclen);
        }

Thus, the authenc implementation will always copy the AAD over in case of 
AF_ALG even though zerocopy with the same buffers are used.

When the in-kernel users of AEAD seemingly do not care about the copying of 
the AAD, and considering that authenc would not do it right for AF_ALG, I am 
wondering whether we should:

1. remove the AAD copy in authenc to make it en-par with the other AEAD 
implementations

2. re-consider the discussed patch

3. tell users to copy the AAD over if they need it in the dst buffers.

Ciao
Stephan
