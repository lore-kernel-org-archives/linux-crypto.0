From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 2/8] crypto: add driver-side scomp interface
Date: Wed, 23 Mar 2016 18:18:57 +0800
Message-ID: <20160323101857.GA27198@gondor.apana.org.au>
References: <20160216195717.GA4207@gondor.apana.org.au>
 <1456336310-3737-1-git-send-email-giovanni.cabiddu@intel.com>
 <1456336310-3737-3-git-send-email-giovanni.cabiddu@intel.com>
 <20160317110027.GA5378@gondor.apana.org.au>
 <20160318140248.GA22461@sivswdev01.ir.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38106 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819AbcCWKTV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Mar 2016 06:19:21 -0400
Content-Disposition: inline
In-Reply-To: <20160318140248.GA22461@sivswdev01.ir.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Mar 18, 2016 at 02:02:49PM +0000, Giovanni Cabiddu wrote:
>
> Are you suggesting to add to the struct acomp_req a pointer to a vmalloc
> area and remove the request context (which is contiguous to acomp_req and
> allocated in request_alloc)?

What I'm suggesting is simply to generalise the noctx case so that
it applies to acomp rather than just scomp.

In fact, I think we should do it as a separate user interface, e.g.,
crypto_qdecomp that does the decompression without a vmalloc work
space.  You'd only have to implement decompression support for
qdecomp since all compression algorithms require a vmalloc work
space.

So we would end up with crypto_acomp which always requires a
vmalloc work space and crypto_qdecomp for the noctx case.

Underneath you'd still maintain the two interfaces of acomp for
the SG case and scomp for the linear case.

> > Chances are that with hardware offload that you won't have to do
> > such a vmalloc anyway.  IOW acomp implementations are much more
> > likely to be of the noctx type than scomp.
> Our HW offload will always need a context area in the acomp_req but
> I agree, there might be other acomp implementations which won't.

That's interesting, why would your hardware need a vmalloc work
space per-request?

> Will allocate_space require a parameter which indicates the direction
> of the operation (compression or decompression) or are we relying on the
> user of the crypto API to know if he needs to call this function or not?

At this point I don't believe the savings would be worth our effort
so let's continue doing what we currently do which is to always
allocate for both directions.  Note that if you do the acomp/qdecomp
split then you'd only do the allocation for acomp.

In fact, we could then forget about the separate allocate_space
call and just do it inside acomp_request_alloc as the noctx case
would be accessed through the separate qdecomp interface.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
