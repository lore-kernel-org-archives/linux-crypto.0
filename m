From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH - RESEND] crypto: AF_ALG - remove SGL terminator
 indicator when  chaining
Date: Thu, 21 Sep 2017 16:18:25 +0800
Message-ID: <20170921081825.GA8887@gondor.apana.org.au>
References: <5857040.2sfW0oRrdW@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: greg@kroah.com, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:44950 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751521AbdIUISt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Sep 2017 04:18:49 -0400
Content-Disposition: inline
In-Reply-To: <5857040.2sfW0oRrdW@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Sep 21, 2017 at 10:16:53AM +0200, Stephan Mueller wrote:
> The SGL is MAX_SGL_ENTS + 1 in size. The last SG entry is used for the
> chaining and is properly updated with the sg_chain invocation. During
> the filling-in of the initial SG entries, sg_mark_end is called for each
> SG entry. This is appropriate as long as no additional SGL is chained
> with the current SGL. However, when a new SGL is chained and the last
> SG entry is updated with sg_chain, the last but one entry still contains
> the end marker from the sg_mark_end. This end marker must be removed as
> otherwise a walk of the chained SGLs will cause a NULL pointer
> dereference at the last but one SG entry, because sg_next will return
> NULL.
> 
> The patch only applies to all kernels up to and including 4.13. The
> patch 2d97591ef43d0587be22ad1b0d758d6df4999a0b added to 4.14-rc1
> introduced a complete new code base which addresses this bug in
> a different way. Yet, that patch is too invasive for stable kernels
> and was therefore not marked for stable.
> 
> Fixes: 8ff590903d5fc ("crypto: algif_skcipher - User-space interface
> for skcipher operations")
> CC: <stable@vger.kernel.org>
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
