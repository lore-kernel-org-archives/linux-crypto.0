From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 2/8] crypto: add driver-side scomp interface
Date: Thu, 17 Mar 2016 19:00:27 +0800
Message-ID: <20160317110027.GA5378@gondor.apana.org.au>
References: <20160216195717.GA4207@gondor.apana.org.au>
 <1456336310-3737-1-git-send-email-giovanni.cabiddu@intel.com>
 <1456336310-3737-3-git-send-email-giovanni.cabiddu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:45551 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935327AbcCQLAe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Mar 2016 07:00:34 -0400
Content-Disposition: inline
In-Reply-To: <1456336310-3737-3-git-send-email-giovanni.cabiddu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Feb 24, 2016 at 05:51:44PM +0000, Giovanni Cabiddu wrote:
>
> +#define CRYPTO_SCOMP_DECOMP_NOCTX CRYPTO_ALG_PRIVATE

I don't think this should be an scomp-specific flag.  The point of
noctx is that we don't need to do a request-specific vmalloc.
Chances are that with hardware offload that you won't have to do
such a vmalloc anyway.  IOW acomp implementations are much more
likely to be of the noctx type than scomp.

This is how I think it should work:

1. There should be a single request_alloc function that allocates
just the request without the vmalloc.
2. You then have to call an alloc_space function to allocate the
vmalloc area (let's stop calling it ctx as it may lead to confusion
with other contexts in the crypto API).

The second step can obviously be skipped for the noctx case.

Also instead of the private bit let's put this into the alg type:

#define CRYPTO_ALG_TYPE_ACOMP          0x00000008
#define CRYPTO_ALG_TYPE_ACOMP_NOCTX    0x00000009
#define CRYPTO_ALG_TYPE_SCOMP          0x0000000a
#define CRYPTO_ALG_TYPE_SCOMP_NOCTX    0x0000000b

Now that we have killed crypto_hash we can shrink hash down to
two types and move it to 0xe, freeing up the space for acomp/scomp.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
