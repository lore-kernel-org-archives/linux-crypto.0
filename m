From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH v6 2/8] crypto: add driver-side scomp interface
Date: Fri, 24 Jun 2016 09:37:28 +0100
Message-ID: <20160624083728.GA15549@sivswdev01.ir.intel.com>
References: <1465373818-29720-1-git-send-email-giovanni.cabiddu@intel.com>
 <1465373818-29720-3-git-send-email-giovanni.cabiddu@intel.com>
 <20160613085612.GA7333@gondor.apana.org.au>
 <20160622155350.GA22247@sivswdev01.ir.intel.com>
 <20160623105034.GA10475@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:4843 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943AbcFXIhd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Jun 2016 04:37:33 -0400
Content-Disposition: inline
In-Reply-To: <20160623105034.GA10475@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 23, 2016 at 06:50:34PM +0800, Herbert Xu wrote:
> No that's not the problem.  The problem is that you can't kmalloc
> 64K of memory.  kmalloc requires physically contiguous memory and
> you cannot rely on having 64K of contiguous memory.
It is clear now. Thanks.

> > > This totally breaks down once you go to DMA, where an SG list is
> > > required. 
> > scomp backends should be used only for software implementations. 
> > A driver backend which needs DMA should plug into acomp.
> 
> What I'm saying is that the current strategy of using vmalloc
> memory as input/output buffers cannot possibly work with acomp
> since you cannot do DMA over vmalloc memory.
I'll remove scomp and refit the software algos to plug into acomp
directly.
Would it be admissible if software algos implementations will vmalloc
the source and the destination buffers for linearizing the scatter gather
lists and will operate on those?

Thanks,

-- 
Giovanni
