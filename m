From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH v6 2/8] crypto: add driver-side scomp interface
Date: Tue, 28 Jun 2016 08:41:42 +0100
Message-ID: <20160628074141.GA7321@sivswdev01.ir.intel.com>
References: <1465373818-29720-1-git-send-email-giovanni.cabiddu@intel.com>
 <1465373818-29720-3-git-send-email-giovanni.cabiddu@intel.com>
 <20160613085612.GA7333@gondor.apana.org.au>
 <20160622155350.GA22247@sivswdev01.ir.intel.com>
 <20160623105034.GA10475@gondor.apana.org.au>
 <20160624083728.GA15549@sivswdev01.ir.intel.com>
 <20160624092643.GA18935@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, weigang.li@intel.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:52504 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbcF1Hlq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 Jun 2016 03:41:46 -0400
Content-Disposition: inline
In-Reply-To: <20160624092643.GA18935@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 24, 2016 at 05:26:43PM +0800, Herbert Xu wrote:
> Hmm, I guess we can still keep scomp and use vmalloc until someone
> spends the effort and optimises each algorithm to make them use acomp
> directly.
Ok.

> So I'd still like to move the allocation down into the algorithm.
> That way IPsec no longer needs to keep around a 64K buffer when
> the average packet size is less than a page.
> 
> What we can do for legacy scomp algorithms is to keep a per-cpu
> cache of 64K scratch buffers allocated using vmalloc.  Obviously
> this means that if the output size exceeds 64K then we will fail
> the operation.  But I don't really see an option besides optimising
> the algorithm to use acomp.
Are you suggesting a different cache of scratch buffers for every
algorithm implementation or a shared cache shared across all legacy
scomp algorithms?

> IOW let's move the memory allocation logic of IPComp into the scomp
> layer.  Before we do that we should also make sure that no other
> users of crypto compress needs output sizes in excess of 64K.
Would it be ok 128K instead?
We are proposing to use the acomp API from BTRFS. Limiting the size
of the source and destination buffers to 64K would not work since
BTRFS usually compresses 128KB. 
Here is the RFC sent by Weigang to the BTFS list:
http://www.spinics.net/lists/linux-btrfs/msg56648.html

Regards,

-- 
Giovanni
