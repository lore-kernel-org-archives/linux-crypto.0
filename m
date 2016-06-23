From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v6 2/8] crypto: add driver-side scomp interface
Date: Thu, 23 Jun 2016 18:50:34 +0800
Message-ID: <20160623105034.GA10475@gondor.apana.org.au>
References: <1465373818-29720-1-git-send-email-giovanni.cabiddu@intel.com>
 <1465373818-29720-3-git-send-email-giovanni.cabiddu@intel.com>
 <20160613085612.GA7333@gondor.apana.org.au>
 <20160622155350.GA22247@sivswdev01.ir.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47772 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbcFWKuk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 23 Jun 2016 06:50:40 -0400
Content-Disposition: inline
In-Reply-To: <20160622155350.GA22247@sivswdev01.ir.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 22, 2016 at 04:53:50PM +0100, Giovanni Cabiddu wrote:
> On Mon, Jun 13, 2016 at 04:56:12PM +0800, Herbert Xu wrote:
> > The backup path is also very unlikely to work because we'll be
> > hitting this with 64K sizes and this just won't work with a 4K
> > page size.
> Is scatterwalk_map_and_copy broken?

No that's not the problem.  The problem is that you can't kmalloc
64K of memory.  kmalloc requires physically contiguous memory and
you cannot rely on having 64K of contiguous memory.

> > This totally breaks down once you go to DMA, where an SG list is
> > required. 
> scomp backends should be used only for software implementations. 
> A driver backend which needs DMA should plug into acomp.

What I'm saying is that the current strategy of using vmalloc
memory as input/output buffers cannot possibly work with acomp
since you cannot do DMA over vmalloc memory.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
