From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [Patch V5 1/7] crypto: Multi-buffer encryption infrastructure
 support
Date: Mon, 24 Apr 2017 17:00:24 +0800
Message-ID: <20170424090024.GA20535@gondor.apana.org.au>
References: <1492721440-3698-1-git-send-email-megha.dey@linux.intel.com>
 <1492721440-3698-2-git-send-email-megha.dey@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tim.c.chen@linux.intel.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        megha.dey@intel.com
To: Megha Dey <megha.dey@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [198.176.57.175] ([198.176.57.175]:45148 "EHLO
        deadmen.hmeau.com" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1167393AbdDXJBa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Apr 2017 05:01:30 -0400
Content-Disposition: inline
In-Reply-To: <1492721440-3698-2-git-send-email-megha.dey@linux.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 20, 2017 at 01:50:34PM -0700, Megha Dey wrote:
>
> +static int simd_skcipher_decrypt_mb(struct skcipher_request *req)
> +{
> +	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> +	struct simd_skcipher_ctx_mb *ctx = crypto_skcipher_ctx(tfm);
> +	struct skcipher_request *subreq;
> +	struct crypto_skcipher *child;
> +
> +	subreq = skcipher_request_ctx(req);
> +	*subreq = *req;
> +
> +	child = &ctx->mcryptd_tfm->base;
> +
> +	skcipher_request_set_tfm(subreq, child);
> +
> +	return crypto_skcipher_decrypt(subreq);
> +}

Why did you add the code here in simd.c? This doesn't seem to have
anything to do with kernel SIMD instructions.

>From your later patch I see that what you want is simply a wrapper
around a synchronous internal algorithm.  That is indeed similar
in purpose to simd.c, but I still find it weird to be adding this
code here.

My suggestion is to instead move this code to mcryptd.c.  It's
a bit fiddly because mcryptd already exists as a template.  But
you should still be able to create a seaprate mcryptd interface
for skcipher in the way that simd does it.  In time we can convert
mcryptd hash to this model too.

Also you adopted the simd compat naming scheme.  Please don't do
that as you're creating something brand new so there is no need
to keep the existing compat (i.e., __XXX) naming scheme.  In the
new naming scheme, the internal algorithm should just carry the
normal alg name (e.g., ecb(aes)) and driver name, while the mcryptd
wrapped version will have the same algorithm name but carry a
prefix on the driver name (which is simd- for simd.c, but you
should probably used mcryptd-).

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
