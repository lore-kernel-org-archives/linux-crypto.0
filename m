From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH v6 2/8] crypto: add driver-side scomp interface
Date: Wed, 22 Jun 2016 16:53:50 +0100
Message-ID: <20160622155350.GA22247@sivswdev01.ir.intel.com>
References: <1465373818-29720-1-git-send-email-giovanni.cabiddu@intel.com>
 <1465373818-29720-3-git-send-email-giovanni.cabiddu@intel.com>
 <20160613085612.GA7333@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38092 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472AbcFVPyY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jun 2016 11:54:24 -0400
Content-Disposition: inline
In-Reply-To: <20160613085612.GA7333@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 13, 2016 at 04:56:12PM +0800, Herbert Xu wrote:
> The backup path is also very unlikely to work because we'll be
> hitting this with 64K sizes and this just won't work with a 4K
> page size.
Is scatterwalk_map_and_copy broken?

> So up until now we've getting around this 64K issue with vmalloc,
> and then we try to conserve the precious vmalloc resource by using
> per-cpu allocation.
I don't clearly understand what is the issue.
Can you please give me more details?

> This totally breaks down once you go to DMA, where an SG list is
> required. 
scomp backends should be used only for software implementations. 
A driver backend which needs DMA should plug into acomp.

> Unfortunately, this means that there is no easy way
> to linearise the data for our software implementations.
> 
> There is no easy way out I'm afraid.  I think we'll have to bite
> the bullet and refit our software algos so that they handle SG
> lists.
Although feasible, I think it wouldn't be an easy job.

> Not only will this solve the problem at hand, it'll also mean that
> acomp users will never have to do vmalloc so it's a win-win.  It
> also means that we won't need the scomp interface at all.
> 
> This does bring up another question of who should be allocating the
> output memory.  Up until now it has been up to the user to do so.
> However, if our algos can actually handle SG lists then I think it
> should be fairly easy to make them do the allocation instead.  What
> do you think?
I would prefer the user of the api to allocate and manage the output
memory.

Thanks,

-- 
Giovanni
