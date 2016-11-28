From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/3] crypto: AF_ALG - disregard AAD buffer space for
 output
Date: Mon, 28 Nov 2016 19:39:15 +0800
Message-ID: <20161128113915.GB990@gondor.apana.org.au>
References: <3302668.EORF2jai5r@positron.chronox.de>
 <2184005.6LaQaNuGm1@positron.chronox.de>
 <20161116090446.GE29644@gondor.apana.org.au>
 <6354916.mphDsJscQs@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mathew.j.martineau@linux.intel.com, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39438 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754036AbcK1LkG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Nov 2016 06:40:06 -0500
Content-Disposition: inline
In-Reply-To: <6354916.mphDsJscQs@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Nov 19, 2016 at 10:08:06PM +0100, Stephan Mueller wrote:
> 
> The way to go on this topic would be to use the same logic as the authenc 
> implementation by using a null cipher for the copy operation. Though, finding 
> out whether the src and dst buffers are the same is an interesting 
> proposition, because we need to traverse the src and dst SGLs to see whether 
> the same pages and same offsets are used. A simple check for src SGL == dst 
> SGL will not work for the AF_ALG implementation, because the src SGL will 
> always be different from the dst SGL because they are constructed in different 
> ways (tsgl will always be different from rsgl). What may be the same are the 
> pages and offsets that are pointed to by the SGL in case of zerocopy.

True, you won't be able to use the fast path and will end up doing
the copy.  However, it should still work because we also have an
aliasing check within the null copy code (skcipher_null_crypt).

So for the sake of simplicity, I think we should start with just
copying src to dst unconditionally in algif_aead, and then calling
the underlying crypto code with just dst to invoke the inplace code
path.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
