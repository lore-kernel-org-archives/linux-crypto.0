From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v6 2/8] crypto: add driver-side scomp interface
Date: Fri, 24 Jun 2016 17:26:43 +0800
Message-ID: <20160624092643.GA18935@gondor.apana.org.au>
References: <1465373818-29720-1-git-send-email-giovanni.cabiddu@intel.com>
 <1465373818-29720-3-git-send-email-giovanni.cabiddu@intel.com>
 <20160613085612.GA7333@gondor.apana.org.au>
 <20160622155350.GA22247@sivswdev01.ir.intel.com>
 <20160623105034.GA10475@gondor.apana.org.au>
 <20160624083728.GA15549@sivswdev01.ir.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:59215 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbcFXJ0s (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Jun 2016 05:26:48 -0400
Content-Disposition: inline
In-Reply-To: <20160624083728.GA15549@sivswdev01.ir.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 24, 2016 at 09:37:28AM +0100, Giovanni Cabiddu wrote:
>
> I'll remove scomp and refit the software algos to plug into acomp
> directly.
> Would it be admissible if software algos implementations will vmalloc
> the source and the destination buffers for linearizing the scatter gather
> lists and will operate on those?

Hmm, I guess we can still keep scomp and use vmalloc until someone
spends the effort and optimises each algorithm to make them use acomp
directly.

So I'd still like to move the allocation down into the algorithm.
That way IPsec no longer needs to keep around a 64K buffer when
the average packet size is less than a page.

What we can do for legacy scomp algorithms is to keep a per-cpu
cache of 64K scratch buffers allocated using vmalloc.  Obviously
this means that if the output size exceeds 64K then we will fail
the operation.  But I don't really see an option besides optimising
the algorithm to use acomp.

IOW let's move the memory allocation logic of IPComp into the scomp
layer.  Before we do that we should also make sure that no other
users of crypto compress needs output sizes in excess of 64K.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
