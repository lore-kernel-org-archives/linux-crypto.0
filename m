From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH v3 2/8] crypto: add driver-side scomp interface
Date: Fri, 18 Mar 2016 14:02:49 +0000
Message-ID: <20160318140248.GA22461@sivswdev01.ir.intel.com>
References: <20160216195717.GA4207@gondor.apana.org.au>
 <1456336310-3737-1-git-send-email-giovanni.cabiddu@intel.com>
 <1456336310-3737-3-git-send-email-giovanni.cabiddu@intel.com>
 <20160317110027.GA5378@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:32101 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352AbcCRODY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Mar 2016 10:03:24 -0400
Content-Disposition: inline
In-Reply-To: <20160317110027.GA5378@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

I would like to have some clarifications before submitting a v4.

On Thu, Mar 17, 2016 at 07:00:27PM +0800, Herbert Xu wrote:
> On Wed, Feb 24, 2016 at 05:51:44PM +0000, Giovanni Cabiddu wrote:
> >
> > +#define CRYPTO_SCOMP_DECOMP_NOCTX CRYPTO_ALG_PRIVATE
> 
> I don't think this should be an scomp-specific flag.  The point of
> noctx is that we don't need to do a request-specific vmalloc.
Are you suggesting to add to the struct acomp_req a pointer to a vmalloc
area and remove the request context (which is contiguous to acomp_req and
allocated in request_alloc)?

> Chances are that with hardware offload that you won't have to do
> such a vmalloc anyway.  IOW acomp implementations are much more
> likely to be of the noctx type than scomp.
Our HW offload will always need a context area in the acomp_req but
I agree, there might be other acomp implementations which won't.

> This is how I think it should work:
> 
> 1. There should be a single request_alloc function that allocates
> just the request without the vmalloc.
> 2. You then have to call an alloc_space function to allocate the
> vmalloc area (let's stop calling it ctx as it may lead to confusion
> with other contexts in the crypto API).
Will allocate_space require a parameter which indicates the direction
of the operation (compression or decompression) or are we relying on the
user of the crypto API to know if he needs to call this function or not?

> The second step can obviously be skipped for the noctx case.
> 
> Also instead of the private bit let's put this into the alg type:
> 
> #define CRYPTO_ALG_TYPE_ACOMP          0x00000008
> #define CRYPTO_ALG_TYPE_ACOMP_NOCTX    0x00000009
> #define CRYPTO_ALG_TYPE_SCOMP          0x0000000a
> #define CRYPTO_ALG_TYPE_SCOMP_NOCTX    0x0000000b
The reason why Joonsoo Kim proposed the concept of NOCTX was to avoid
allocating a decompression context.
Are you suggesting also to extend this concept to compression as well?
If yes we would need a way to indicate for which direction the driver
requires the context/space. How can we specify that?

> Now that we have killed crypto_hash we can shrink hash down to
> two types and move it to 0xe, freeing up the space for acomp/scomp.
Sounds good.

Thank you,

-- 
Giovanni
