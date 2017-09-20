From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: AF_ALG - remove SGL end indicator when chaining
Date: Wed, 20 Sep 2017 16:32:09 +0800
Message-ID: <20170920083209.GA3395@gondor.apana.org.au>
References: <1913314.pET67Fvxje@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org, stable@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1913314.pET67Fvxje@positron.chronox.de>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Aug 30, 2017 at 06:59:07PM +0200, Stephan Müller wrote:
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
> Fixes: 8ff590903d5fc ("crypto: algif_skcipher - User-space interface
> for skcipher operations")
> CC: <stable@vger.kernel.org>
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Hmm, this patch does not apply against the current tree.  Is this
a stable-only patch?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
